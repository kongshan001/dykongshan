from __future__ import annotations
import json
import pytest
import tempfile
import shutil
from pathlib import Path


@pytest.fixture
def tmp_kanban():
    """Create minimal .kanban directory structure in a temp dir."""
    root = Path(tempfile.mkdtemp(prefix="kanban_test_"))
    kanban_dir = root / ".kanban"
    tasks_dir = kanban_dir / "tasks"
    archive_dir = kanban_dir / "archive"
    tasks_dir.mkdir(parents=True)
    archive_dir.mkdir(parents=True)

    config = {
        "output_dir": "src",
        "max_iterations": 6,
    }
    (kanban_dir / "config.json").write_text(json.dumps(config, indent=2))

    # Minimal stub — matches real structure only for passable fields
    workflow = {
        "phases": ["plan", "execute", "evaluate", "user_decision", "archive"],
        "pass_threshold": 9.0,
        "max_iterations": 6,
    }
    (kanban_dir / "workflow.json").write_text(json.dumps(workflow, indent=2))

    yield root
    shutil.rmtree(root, ignore_errors=True)


from core.types import Task, TaskStatus, Phase


@pytest.fixture
def sample_task(tmp_kanban):
    """A standard Task fixture pointing into tmp_kanban."""
    return Task(
        id="TASK-001",
        title="测试任务",
        description="用于测试的示例任务",
        status=TaskStatus.PENDING,
        phase=Phase.PLAN,
        iteration=1,
    )


@pytest.fixture
def sample_task_file(tmp_kanban, sample_task):
    """Write sample_task as JSON to .kanban/tasks/TASK-001.json."""
    import json
    task_json = {
        "id": sample_task.id,
        "title": sample_task.title,
        "description": sample_task.description,
        "status": sample_task.status.value,
        "phase": sample_task.phase.value,
        "iteration": sample_task.iteration,
        "history": [],
    }
    task_file = tmp_kanban / ".kanban" / "tasks" / f"{sample_task.id}.json"
    task_file.write_text(json.dumps(task_json, indent=2))
    return task_file
