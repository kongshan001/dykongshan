from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.infra.git import Git, GitError
from core.infra.worktree import Worktree, WorktreeError
from core.domain.task import TaskManager, TaskNotFoundError
from core.domain.workflow import WorkflowEngine
from core.domain.guard import Guard, CheckResult
from core.domain.nlp import parse_nlp
from core.domain.recovery import recover_list, recover_check_timeout, resume_task, rollback_task
from core.types import Phase


class GuardError(Exception):
    pass


def _get_agents_for_phase(fs: Filesystem, phase_id: str) -> list[dict]:
    """Read workflow.json and return agents for the given phase."""
    cfg = Config(fs)
    workflow = cfg.workflow
    for p in workflow.get("phases", []):
        if p.get("id") == phase_id:
            return p.get("agents", [])
    if phase_id == "evaluate":
        from core.infra.scheduler import Scheduler
        return Scheduler.eval_roles()
    return []


_BRAINSTORMING_ELEMENTS = [
    ("技术栈选型", "tech_stack"),
    ("核心功能清单", "feature_list"),
    ("验收标准", "acceptance_criteria"),
    ("约束条件", "constraints"),
]

_KEYWORDS_MAP = {
    "tech_stack": ["技术栈", "tech stack", "python", "react", "node", "go", "rust"],
    "feature_list": ["功能", "feature", "实现", "支持", "包含"],
    "acceptance_criteria": ["验收", "acceptance", "预期", "应该", "shall", "must"],
    "constraints": ["约束", "限制", "constraint", "不", "禁止", "必须"],
}


def _move_to_archive(fs: Filesystem, task_id: str) -> None:
    src = fs.task_file(task_id)
    dst = fs.archive_task_file(task_id)
    if fs.file_exists(src):
        fs.ensure_dir(dst.parent)
        src.rename(dst)


def _extract_knowledge_on_archive(task_id: str) -> None:
    """IR-06: Extract knowledge from pitfalls/decisions on archive."""
    try:
        root = Filesystem.find_project_root()
        fs = Filesystem(root=root)
        from core.domain.knowledge import KnowledgeManager
        km = KnowledgeManager(fs)
        task_dir = fs.task_dir(task_id)
        for fname in ("execution_pitfalls.md", "execution_decisions.md"):
            fpath = task_dir / fname
            if fs.file_exists(fpath):
                content = fpath.read_text(encoding="utf-8")
                if content.strip():
                    km.add("auto", f"{task_id} — {fname}", content[:500])
    except Exception:
        pass  # knowledge extraction is best-effort


def _check_brainstorming_gate(description: str) -> dict:
    """IR-16: Check if task description has all 4 required elements for pass-through."""
    desc = (description or "").lower()
    missing = []
    for label, key in _BRAINSTORMING_ELEMENTS:
        if not any(kw in desc for kw in _KEYWORDS_MAP[key]):
            missing.append({"label": label, "key": key})
    return {"passed": len(missing) == 0, "missing": missing}


def _resolve() -> tuple[Filesystem, Config, TaskManager, WorkflowEngine]:
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    cfg = Config(fs)
    tm = TaskManager(fs, cfg)
    we = WorkflowEngine(fs, cfg)
    return fs, cfg, tm, we


def _resolve_worktree() -> tuple[Git, Worktree]:
    root = Filesystem.find_project_root()
    g = Git(repo_root=root)
    wt = Worktree(git=g, repo_root=root)
    return g, wt


# ── run ──────────────────────────────────────────────────────────

def cmd_run(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    task_id = args[0]
    fs, cfg, tm, we = _resolve()
    task = tm.show(task_id)
    lightweight_requested = "--lightweight" in args
    if len(args) > 2 and args[1] == "--phase":
        target = Phase(args[2])
    elif len(args) > 3 and args[2] == "--phase":
        target = Phase(args[3])
    else:
        next_p = we.next_phase(task.phase)
        if next_p is None:
            return {
                "task_id": task_id,
                "phase": task.phase.value,
                "message": "already at terminal phase",
            }
        target = next_p

    # Guard check before transition (fix #83)
    guard = Guard(fs, cfg)
    guard_result = guard.check_artifacts(task, task.phase)
    if not guard_result.passed:
        return {
            "task_id": task_id,
            "phase": task.phase.value,
            "message": "guard check failed",
            "guard_failures": guard_result.failures,
            "guard_warnings": guard_result.warnings,
        }

    # IR-16: brainstorming gate before plan → plan_review
    brainstorming = None
    if task.phase == Phase.PLAN and target == Phase.PLAN_REVIEW:
        brainstorming = _check_brainstorming_gate(task.description)

    new_phase = we.transition(task, target)
    tm.update(task_id, phase=new_phase.value)
    agents = _get_agents_for_phase(fs, new_phase.value)
    result = {
        "task_id": task_id,
        "phase": new_phase.value,
        "message": f"entered {new_phase.value} phase",
        "guard": {"passed": True},
        "agents_to_spawn": agents,
        "agent_count": len(agents),
    }
    if brainstorming is not None:
        result["brainstorming_gate"] = brainstorming

    # Lightweight mode detection for execute phase
    if new_phase == Phase.EXECUTE:
        lw_keywords = ["fix", "bug", "hotfix", "修复", "清理", "clean",
                        "config", "配置", "typo", "拼写", "格式"]
        qualifies = any(kw in task.description.lower() for kw in lw_keywords)
        if lightweight_requested:
            result["lightweight"] = True
        elif qualifies:
            result["lightweight_available"] = True
            result["requires_confirmation"] = True

    return result


# ── decide ───────────────────────────────────────────────────────

def cmd_decide(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    task_id = args[0]
    action = "approve_and_archive"
    if len(args) > 2 and args[1] == "--action":
        action = args[2]
    fs, _, tm, we = _resolve()
    task = tm.show(task_id)
    valid_actions = {"approve_and_archive", "abort", "restart_from_plan", "restart_from_execute"}
    if action not in valid_actions:
        return {"error": f"unknown action: {action}", "valid_actions": sorted(valid_actions)}

    tm.record_decision(task_id, action)

    # Execute the action (fix #82)
    if action == "approve_and_archive":
        tm.update(task_id, phase="archive", status="archived")
        _move_to_archive(fs, task_id)
        _extract_knowledge_on_archive(task_id)
    elif action == "abort":
        tm.update(task_id, phase="archive", status="cancelled")
        _move_to_archive(fs, task_id)
    elif action == "restart_from_plan":
        tm.update(task_id, phase="plan", status="in_progress", iteration=task.iteration + 1)
    elif action == "restart_from_execute":
        tm.update(task_id, phase="execute", status="in_progress", iteration=task.iteration + 1)

    return {
        "task_id": task_id,
        "action": action,
        "message": f"user decision: {action} — executed",
    }


# ── guard ────────────────────────────────────────────────────────

def cmd_guard(args: list[str]) -> dict:
    if not args:
        return {"error": "subcommand required"}
    sub = args[0]
    fs, cfg, tm, _ = _resolve()
    guard = Guard(fs, cfg)

    if sub == "check-artifacts":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        phase = Phase(args[2]) if len(args) > 2 else task.phase
        result = guard.check_artifacts(task, phase)
        return {
            "subcommand": sub,
            "task_id": task.id,
            "phase": phase.value,
            "passed": result.passed,
            "failures": result.failures,
            "warnings": result.warnings,
        }

    if sub == "check-evaluation":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        iteration = int(args[2]) if len(args) > 2 else task.iteration
        result = guard.check_evaluation(task, iteration)
        return {
            "subcommand": sub,
            "task_id": task.id,
            "iteration": iteration,
            "passed": result.passed,
            "failures": result.failures,
        }

    if sub == "check-plan-quality":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        report_dir = fs.report_dir(task.id, task.iteration)
        result = guard.check_plan_quality(task, report_dir)
        return {
            "subcommand": sub,
            "task_id": task.id,
            "passed": result.passed,
            "failures": result.failures,
        }

    if sub == "check-inbox":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        inbox_path = fs.task_dir(task.id) / "inbox.md"
        pending = []
        if fs.file_exists(inbox_path):
            content = inbox_path.read_text(encoding="utf-8")
            for line in content.split("\n"):
                stripped = line.strip()
                if stripped and not stripped.startswith("#") and not stripped.startswith("<!--"):
                    if stripped.startswith("- [ ]") or stripped.startswith("* [ ]") or stripped[0].isdigit():
                        pending.append(stripped)
        return {
            "subcommand": sub,
            "task_id": task.id,
            "has_pending": len(pending) > 0,
            "pending_count": len(pending),
            "pending": pending,
        }

    if sub == "check-spec":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        result = guard.check_spec(task, fs.report_dir(task.id, task.iteration))
        return {
            "subcommand": sub,
            "task_id": task.id,
            "passed": result.passed,
            "failures": result.failures,
        }

    if sub == "check-parallel-conflicts":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        result = guard.check_parallel_conflicts(task)
        return {
            "subcommand": sub,
            "task_id": task.id,
            "passed": result.passed,
            "failures": result.failures,
        }

    if sub == "check-cross-task-conflicts":
        result = guard.check_cross_task_conflicts()
        return {
            "subcommand": sub,
            "passed": result.passed,
            "failures": result.failures,
            "warnings": result.warnings,
        }

    return {"error": f"unknown guard subcommand: {sub}"}


# ── workflow ─────────────────────────────────────────────────────

def cmd_workflow(args: list[str]) -> dict:
    if not args:
        return {"error": "subcommand required"}
    sub = args[0]
    _, _, tm, we = _resolve()

    if sub == "transition":
        if len(args) < 3:
            return {"error": "task_id and target phase required"}
        task = tm.show(args[1])
        target = Phase(args[2])
        new_phase = we.transition(task, target)
        tm.update(task.id, phase=new_phase.value)
        return {"task_id": task.id, "from": task.phase.value, "to": new_phase.value}

    if sub == "complete-phase":
        if len(args) < 2:
            return {"error": "task_id required"}
        fs, cfg, tm, _ = _resolve()
        task = tm.show(args[1])
        guard = Guard(fs, cfg)
        guard_result = guard.check_artifacts(task, task.phase)
        if not guard_result.passed:
            raise GuardError(
                f"guard check failed for {task.id} at {task.phase.value}: "
                + "; ".join(guard_result.failures)
            )
        updated = we.complete_phase(task)
        tm.update(task.id, phase=updated.phase.value)
        return {"task_id": task.id, "phase": updated.phase.value}

    if sub == "self-improve-check":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        if len(args) >= 3:
            avg_score = float(args[2])
        else:
            # Auto-read from task score_history
            if task.score_history:
                latest = task.score_history[-1]
                avg_score = latest.get("average", 0.0)
            else:
                return {"error": "no avg_score provided and no score_history in task"}
        result = we.self_improve_check(task, avg_score)
        return {"task_id": task.id, **result}

    if sub == "get-roles" or sub == "get-phase-agents":
        phase_str = args[1] if len(args) > 1 else "evaluate"
        cfg = Config(Filesystem(root=Filesystem.find_project_root()))
        workflow = cfg.workflow
        phase_config = None
        for p in workflow.get("phases", []):
            if p.get("id") == phase_str:
                phase_config = p
                break
        agents = phase_config.get("agents", []) if phase_config else []
        if not agents and phase_str == "evaluate":
            from core.infra.scheduler import Scheduler
            agents = Scheduler.eval_roles()

        # Include scheduling config (timeout, parallelism) from config.json
        raw = cfg.raw
        timeout = raw.get("timeout", {})
        scheduler_cfg = raw.get("scheduler", {})
        scheduling = {
            "single_agent_seconds": timeout.get("single_agent_seconds", 180),
            "phase_timeout_seconds": timeout.get(f"{phase_str}_seconds"),
            "max_parallel": scheduler_cfg.get("max_parallel", 3),
            "poll_interval_seconds": scheduler_cfg.get("poll_interval_seconds", 30),
        }
        return {"phase": phase_str, "agents": agents, "scheduling": scheduling}

    if sub == "next-phase":
        if len(args) < 2:
            return {"error": "task_id required"}
        task = tm.show(args[1])
        next_p = we.next_phase(task.phase)
        return {
            "task_id": task.id,
            "current": task.phase.value,
            "next": next_p.value if next_p else None,
        }

    if sub == "start-iteration":
        if len(args) < 3:
            return {"error": "task_id and type (hot/full) required"}
        task_id = args[1]
        itype = args[2]
        if itype not in ("hot", "full"):
            return {"error": "iteration type must be hot or full"}

        fs2, _, tm2, _ = _resolve()
        task = tm2.show(task_id)
        old_iter = task.iteration
        new_iter = old_iter + 1
        task_dir = fs2.task_dir(task_id)

        # Move execution artifacts from task root to iteration-N/ for isolation
        for fname in ["execution_summary.md", "execution_pitfalls.md", "execution_decisions.md"]:
            src = task_dir / fname
            if fs2.file_exists(src):
                dest_dir = task_dir / f"iteration-{old_iter}"
                fs2.ensure_dir(dest_dir)
                src.rename(dest_dir / fname)

        # Set phase and increment iteration
        target_phase = Phase.EXECUTE if itype == "hot" else Phase.PLAN
        tm2.update(task_id, phase=target_phase.value, iteration=new_iter)
        return {
            "task_id": task_id,
            "type": itype,
            "iteration": new_iter,
            "phase": target_phase.value,
        }

    return {"error": f"unknown workflow subcommand: {sub}"}


# ── worktree ─────────────────────────────────────────────────────

def cmd_worktree(args: list[str]) -> dict:
    if not args:
        return {"error": "subcommand required"}
    sub = args[0]
    g, wt = _resolve_worktree()

    if sub == "create":
        if len(args) < 2:
            return {"error": "task_id required"}
        task_id = args[1]
        branch = f"task/{task_id}"
        try:
            path = wt.create(task_id, branch)
            return {
                "subcommand": sub,
                "task_id": task_id,
                "branch": branch,
                "path": str(path),
            }
        except WorktreeError as e:
            return {"error": str(e)}

    if sub == "remove":
        if len(args) < 2:
            return {"error": "task_id required"}
        task_id = args[1]
        force = "--force" in args
        try:
            wt.remove(task_id, force=force)
            return {"subcommand": sub, "task_id": task_id, "removed": True}
        except WorktreeError as e:
            return {"error": str(e)}

    if sub == "exists":
        if len(args) < 2:
            return {"error": "task_id required"}
        return {"subcommand": sub, "task_id": args[1], "exists": wt.exists(args[1])}

    if sub == "list":
        return {"subcommand": sub, "worktrees": wt.list_all()}

    if sub == "merge":
        if len(args) < 2:
            return {"error": "task_id required"}
        task_id = args[1]
        branch = f"task/{task_id}"
        try:
            g._run(["checkout", g.current_branch()])
            g._run(["merge", branch, "--no-ff", "-m", f"merge: {task_id}"])
            g.push()
            return {"subcommand": sub, "task_id": task_id, "merged": True}
        except GitError as e:
            return {"error": str(e)}

    if sub == "cleanup":
        if len(args) < 2:
            return {"error": "task_id required"}
        task_id = args[1]
        branch = f"task/{task_id}"
        try:
            wt.remove(task_id, force=True)
            try:
                g._run(["branch", "-D", branch], check=False)
            except GitError:
                pass
            return {"subcommand": sub, "task_id": task_id, "cleaned": True}
        except WorktreeError as e:
            return {"error": str(e)}

    return {"error": f"unknown worktree subcommand: {sub}"}


# ── nlp ──────────────────────────────────────────────────────────

def cmd_nlp(args: list[str]) -> dict:
    """Return available commands + raw input for LLM interpretation.

    No keyword matching — the orchestrator (Claude Code) uses its LLM
    to map natural language to the exact command from the list below.
    """
    text = " ".join(args)
    from core.domain.nlp import extract_task_id
    return {
        "input": text,
        "task_id": extract_task_id(text),
        "interpret_by_llm": True,
        "available_commands": [
            {"command": "init",                  "example": "/kanban init"},
            {"command": "create",                "example": '/kanban create "<title>" [--desc "<desc>"]'},
            {"command": "status",                "example": "/kanban status"},
            {"command": "show",                  "example": "/kanban show <task_id>"},
            {"command": "run",                   "example": "/kanban run <task_id> [--phase <phase>]"},
            {"command": "decide",                "example": "/kanban decide <task_id> --action approve_and_archive|abort|restart_from_plan|restart_from_execute"},
            {"command": "score",                 "example": "/kanban score <task_id>"},
            {"command": "summary",               "example": "/kanban summary <task_id>"},
            {"command": "recover",               "example": "/kanban recover [<task_id>]"},
            {"command": "resume",                "example": "/kanban resume <task_id>"},
            {"command": "rollback",              "example": "/kanban rollback <task_id>"},
            {"command": "clean",                 "example": "/kanban clean [<task_id>|--all|--before <date>]"},
            {"command": "time",                  "example": "/kanban time [<task_id>]"},
            {"command": "tokens",                "example": "/kanban tokens <task_id>"},
            {"command": "progress",              "example": "/kanban progress <task_id>"},
            {"command": "subtask",               "example": "/kanban subtask start|done <task_id> <subtask_id>"},
            {"command": "dashboard",             "example": "/kanban dashboard [start|stop|status|restart]"},
            {"command": "version",               "example": "/kanban version list|record"},
            {"command": "knowledge",             "example": "/kanban knowledge search <keyword>"},
            {"command": "feedback",              "example": "/kanban feedback <task_id>"},
            {"command": "evolve-skills",         "example": "/kanban evolve-skills"},
            {"command": "check-env",             "example": "/kanban check-env"},
        ],
    }


# ── recover / rollback / resume ──────────────────────────────────

def cmd_recover(args: list[str]) -> dict:
    if args:
        task_id = args[0]
        if "--check-timeout" in args:
            result = recover_check_timeout(task_id)
            return {"task_id": task_id, "timeout": result}
        return {"task_id": task_id, "action": "recover"}
    return {"action": "recover", "interrupted_tasks": recover_list()}


def cmd_rollback(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    task_id = args[0]
    result = rollback_task(task_id)
    return {"task_id": task_id, "action": "rollback", "result": result}


def cmd_resume(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    task_id = args[0]
    result = resume_task(task_id)
    return {"task_id": task_id, "action": "resume", "result": result}
