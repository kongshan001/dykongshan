from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager, TaskNotFoundError


def _resolve() -> tuple[Filesystem, Config, TaskManager]:
    root = Path.cwd()
    fs = Filesystem(root=root)
    cfg = Config(fs)
    return fs, cfg, TaskManager(fs, cfg)


def cmd_init(args: list[str]) -> dict:
    fs, _, _ = _resolve()
    return {"message": "kanban env ready", "kanban_dir": str(fs.kanban_dir)}


def cmd_create(args: list[str]) -> dict:
    title = args[0] if args else "Untitled"
    desc = args[1] if len(args) > 1 else ""
    _, _, tm = _resolve()
    task = tm.create(title, desc)
    return {"id": task.id, "title": task.title}


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
        "iteration": task.iteration,
    }


def cmd_clean(args: list[str]) -> dict:
    if not args:
        return {"error": "task_id required"}
    _, _, tm = _resolve()
    tm.delete(args[0])
    return {"message": f"cleaned {args[0]}"}
