from __future__ import annotations
import json
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager, TaskNotFoundError
from core.domain.scanner import scan_project, ScanReport


def _resolve() -> tuple[Filesystem, Config, TaskManager]:
    root = Path.cwd()
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
    root = Path.cwd()

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
        fs.write_json(config_file, {
            "output_dir": "src",
            "max_iterations": 6,
            "pass_threshold": 9.0,
        })
        created.append(str(config_file.relative_to(root)))

    # Ensure workflow.json exists
    workflow_file = fs.workflow_file()
    if not fs.file_exists(workflow_file):
        fs.write_json(workflow_file, {
            "phases": [
                {"id": "plan", "agents": [{"role": "planner", "required": True, "agent_type": "kanban-planner"}]},
                {"id": "plan_review", "pass_threshold": 7.0, "max_rounds": 3},
                {"id": "qa_spec"},
                {"id": "spec_review", "pass_threshold": 7.0, "max_rounds": 3},
                {"id": "execute"},
                {"id": "evaluate", "pass_threshold": 9.0},
                {"id": "retrospective"},
                {"id": "user_decision"},
                {"id": "archive"},
            ],
            "pass_threshold": 9.0,
            "max_iterations": 6,
        })
        created.append(str(workflow_file.relative_to(root)))

    report = None
    scan_error = None
    try:
        report = scan_project(root)
    except Exception as e:
        scan_error = str(e)

    result = {
        "message": "kanban env ready",
        "kanban_dir": str(fs.kanban_dir),
        "created": created,
    }

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
    root = Path.cwd()
    report = scan_project(root)
    return _serialize_report(report)


def cmd_create(args: list[str]) -> dict:
    title_parts = []
    desc_parts = []
    in_desc = False
    for a in args:
        if a == "--desc":
            in_desc = True
            continue
        if in_desc:
            desc_parts.append(a)
        else:
            title_parts.append(a)
    title = " ".join(title_parts) if title_parts else "Untitled"
    desc = " ".join(desc_parts) if desc_parts else ""
    _, _, tm = _resolve()
    task = tm.create(title, desc)
    # Auto-advance to plan phase with in_progress status
    tm.update(task.id, phase="plan", status="in_progress")
    return {
        "id": task.id,
        "title": task.title,
        "phase": "plan",
        "status": "in_progress",
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
        "iteration": task.iteration,
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
