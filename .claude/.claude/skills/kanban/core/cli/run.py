from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager
from core.domain.workflow import WorkflowEngine
from core.types import Phase


def _resolve() -> tuple[Filesystem, Config, TaskManager, WorkflowEngine]:
    root = Path.cwd()
    fs = Filesystem(root=root)
    cfg = Config(fs)
    tm = TaskManager(fs, cfg)
    we = WorkflowEngine(fs, cfg)
    return fs, cfg, tm, we


def cmd_run(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    task_id = args[0]
    _, _, tm, we = _resolve()
    task = tm.show(task_id)
    if len(args) > 2 and args[1] == "--phase":
        target = Phase(args[2])
    else:
        next_p = we.next_phase(task.phase)
        if next_p is None:
            return {
                "task_id": task_id,
                "phase": task.phase.value,
                "message": "already at terminal phase",
            }
        target = next_p
    new_phase = we.transition(task, target)
    tm.update(task_id, phase=new_phase.value)
    return {
        "task_id": task_id,
        "phase": new_phase.value,
        "message": f"entered {new_phase.value} phase",
    }


def cmd_decide(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    task_id = args[0]
    action = "approve_and_archive"
    if len(args) > 2 and args[1] == "--action":
        action = args[2]
    return {
        "task_id": task_id,
        "action": action,
        "message": f"user decision: {action}",
    }


def cmd_guard(args: list[str]) -> dict:
    return {"subcommand": args[0] if args else "check-artifacts"}


def cmd_workflow(args: list[str]) -> dict:
    return {"subcommand": args[0] if args else "transition"}


def cmd_worktree(args: list[str]) -> dict:
    return {"subcommand": args[0] if args else "create"}


def cmd_nlp(args: list[str]) -> dict:
    text = " ".join(args)
    return {"input": text}


def cmd_recover(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "action": "recover"}


def cmd_rollback(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "action": "rollback"}


def cmd_resume(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "action": "resume"}
