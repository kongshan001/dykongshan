from __future__ import annotations
import argparse
import json
import os
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager, TaskNotFoundError
from core.domain.scanner import scan_project, ScanReport


def _resolve() -> tuple[Filesystem, Config, TaskManager]:
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    cfg = Config(fs)
    return fs, cfg, TaskManager(fs, cfg)


def _serialize_report(report: ScanReport) -> dict:
    return {
        "project_root": report.project_root,
        "language": report.language,
        "has_kanban": report.has_kanban,
        "agent_conflicts": [
            {
                "role": c.role,
                "kanban_agent": c.kanban_agent,
                "project_file": c.project_agent_file,
                "action": c.action,
                "description": c.description,
            }
            for c in report.agent_conflicts
        ],
        "existing_skills": report.existing_skills,
        "infrastructure_gaps": [
            {
                "category": g.category,
                "tool": g.tool,
                "detected": g.detected,
                "suggestion": g.suggestion,
            }
            for g in report.infrastructure_gaps
        ],
        "recommendations": report.recommendations,
    }


def cmd_init(args: list[str]) -> dict:
    fs, _, _ = _resolve()
    root = Filesystem.find_project_root()

    # Ensure .kanban/ directory structure exists (fix #80)
    required_dirs = [
        fs.kanban_dir,
        fs.kanban_dir / "tasks",
        fs.kanban_dir / "archive",
        fs.kanban_dir / "inbox",
        fs.kanban_dir / "reports",
        fs.kanban_dir / "dashboard",
        fs.kanban_dir / "skills" / "evolved",
    ]
    created = []
    for d in required_dirs:
        if not d.exists():
            d.mkdir(parents=True)
            created.append(str(d.relative_to(root)))

    # Ensure config.json exists
    config_file = fs.config_file()
    if not fs.file_exists(config_file):
        python_bin = "venv/Scripts/python.exe" if os.name == "nt" else "venv/bin/python"
        fs.write_json(config_file, {
            "output_dir": "src",
            "max_iterations": 6,
            "pass_threshold": 8.0,
            "python_bin": python_bin,
        })
        created.append(str(config_file.relative_to(root)))

    # Ensure workflow.json exists (read from template)
    workflow_file = fs.workflow_file()
    if not fs.file_exists(workflow_file):
        template_path = Path(__file__).resolve().parent.parent.parent / "templates" / "workflow.json"
        with open(template_path, "r", encoding="utf-8") as f:
            template = json.load(f)
        fs.write_json(workflow_file, template)
        created.append(str(workflow_file.relative_to(root)))

    report = None
    scan_error = None
    try:
        report = scan_project(root)
    except Exception as e:
        scan_error = str(e)

    # Read output_dir from config (may have just been created)
    config = {}
    if fs.file_exists(config_file):
        config = fs.read_json(config_file)
    output_dir = config.get("output_dir", "src")

    result = {
        "message": "kanban env ready",
        "kanban_dir": str(fs.kanban_dir),
        "created": created,
    }

    # Check if output_dir is in .gitignore
    gitignore_path = os.path.join(str(root), ".gitignore")
    if os.path.exists(gitignore_path):
        with open(gitignore_path, encoding="utf-8") as f:
            gitignore_content = f.read()
        for line in gitignore_content.splitlines():
            line = line.strip()
            if line in (f"{output_dir}/", output_dir, f"/{output_dir}/", f"/{output_dir}"):
                result["gitignore_warning"] = (
                    f"output_dir '{output_dir}' is in .gitignore. "
                    f"Use 'git add -f' to add files in that directory."
                )
                break

    if report is not None:
        result["scan"] = _serialize_report(report)
    else:
        result["scan"] = {
            "error": scan_error or "scan failed",
            "recommendations": [],
        }

    return result


def cmd_scan(args: list[str]) -> dict:
    """Explicit scan command for debugging/testing."""
    root = Filesystem.find_project_root()
    report = scan_project(root)
    return _serialize_report(report)


def cmd_create(args: list[str]) -> dict:
    from core.types import AutoMode

    parser = argparse.ArgumentParser(prog="kanban create", add_help=False)
    parser.add_argument("title", nargs="*", default=[], help="Task title")
    parser.add_argument("--desc", nargs="*", default=[], help="Task description")
    parser.add_argument("--auto-mode", nargs="*", default=[], dest="auto_mode",
                        help="Auto-mode flags: all, brainstorm, iteration, lightweight, archive, worktree")
    parser.add_argument("--priority", type=int, default=5, dest="priority",
                        help="Task priority (0-10, default 5)")

    parsed = parser.parse_args(args)
    title = " ".join(parsed.title) if parsed.title else "Untitled"
    desc = " ".join(parsed.desc) if parsed.desc else ""
    auto_mode_flags = parsed.auto_mode

    # Parse auto_mode flags
    auto_mode = AutoMode()
    if auto_mode_flags:
        if "all" in auto_mode_flags:
            auto_mode = AutoMode(
                auto_brainstorm=True,
                auto_iteration=True,
                auto_lightweight=True,
                auto_archive=True,
                auto_worktree=True,
            )
        else:
            for flag in auto_mode_flags:
                if flag == "brainstorm":
                    auto_mode.auto_brainstorm = True
                elif flag == "iteration":
                    auto_mode.auto_iteration = True
                elif flag == "lightweight":
                    auto_mode.auto_lightweight = True
                elif flag == "archive":
                    auto_mode.auto_archive = True
                elif flag == "worktree":
                    auto_mode.auto_worktree = True

    _, _, tm = _resolve()
    task = tm.create(title, desc)
    priority = max(0, min(10, parsed.priority))
    # Apply auto_mode, priority and advance to plan phase
    tm.update(task.id, phase="plan", status="in_progress", auto_mode=auto_mode, priority=priority)
    return {
        "id": task.id,
        "title": task.title,
        "phase": "plan",
        "status": "in_progress",
        "auto_mode": {
            "auto_brainstorm": auto_mode.auto_brainstorm,
            "auto_iteration": auto_mode.auto_iteration,
            "auto_lightweight": auto_mode.auto_lightweight,
            "auto_archive": auto_mode.auto_archive,
            "auto_worktree": auto_mode.auto_worktree,
        },
        "message": f"Task {task.id} created and advanced to plan phase. Ready to run.",
    }


def cmd_status(args: list[str]) -> dict:
    _, _, tm = _resolve()
    return tm.status()


def cmd_show(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    _, _, tm = _resolve()
    task = tm.show(args[0])
    return {
        "id": task.id, "title": task.title,
        "description": task.description,
        "status": task.status.value, "phase": task.phase.value,
        "iteration": task.iteration, "priority": task.priority,
    }


def cmd_clean(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id or --all required"}
    fs, _, tm = _resolve()

    if "--all" in args:
        cleaned = []
        for f in sorted(fs.kanban_dir.glob("archive/TASK-*.json")):
            task_id = f.stem
            f.unlink()
            cleaned.append(task_id)
        return {"cleaned": cleaned, "count": len(cleaned)}

    task_id = args[0]
    tm.delete(task_id)
    return {"message": f"cleaned {task_id}"}
