from __future__ import annotations
import json
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.infra.time_tracking import TimeTracker
from core.infra.token_tracking import TokenTracker
from core.domain.task import TaskManager
from core.domain.progress import ProgressTracker


def _resolve(task_id: str) -> tuple[Filesystem, Config, TaskManager]:
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    cfg = Config(fs)
    tm = TaskManager(fs, cfg)
    return fs, cfg, tm


def cmd_score(args: list[str]) -> dict:
    task_id = args[0] if args else "unknown"
    fs, _, tm = _resolve(task_id)
    try:
        task = tm.show(task_id)
    except Exception:
        return {"task_id": task_id, "scores": [], "average": None}

    scores = []
    for it in range(1, task.iteration + 1):
        report_dir = fs.report_dir(task_id, it)
        if not report_dir.exists():
            continue
        for role in ["code_reviewer", "qa", "pm", "designer"]:
            rf = report_dir / f"{role}_report.json"
            if fs.file_exists(rf):
                data = fs.read_json(rf)
                scores.append({
                    "role": role,
                    "iteration": it,
                    "total": data.get("total", 0),
                })
    avg = round(sum(s["total"] for s in scores) / len(scores), 2) if scores else None
    return {"task_id": task_id, "scores": scores, "average": avg}


def cmd_summary(args: list[str]) -> dict:
    task_id = args[0] if args else "unknown"
    fs, _, tm = _resolve(task_id)
    try:
        task = tm.show(task_id)
    except Exception:
        return {"task_id": task_id, "summary": "task not found"}
    progress = ProgressTracker(fs)
    return {
        "task_id": task.id,
        "title": task.title,
        "status": task.status.value,
        "phase": task.phase.value,
        "iteration": task.iteration,
        "progress": progress.progress(task_id),
    }


def cmd_progress(args: list[str]) -> dict:
    task_id = args[0] if args else "unknown"
    fs, _, _ = _resolve(task_id)
    tracker = ProgressTracker(fs)
    return {"task_id": task_id, "progress": tracker.progress(task_id)}


def cmd_time(args: list[str]) -> dict:
    task_id = args[0] if args else "unknown"
    fs, _, _ = _resolve(task_id)
    tracker = TimeTracker(fs.kanban_dir / "reports" / "time_tracking.json")
    return {"task_id": task_id, "time": tracker.report(task_id)}


def cmd_tokens(args: list[str]) -> dict:
    task_id = args[0] if args else "unknown"
    fs, _, _ = _resolve(task_id)
    tracker = TokenTracker(fs.kanban_dir / "reports" / "token_tracking.json")
    return {"task_id": task_id, "tokens": tracker.report(task_id)}


def cmd_dashboard(args: list[str]) -> dict:
    from core.infra.dashboard import DashboardBuilder
    fs, _, _ = _resolve("")
    builder = DashboardBuilder(fs.tasks_dir)
    return {"dashboard": builder.build()}
