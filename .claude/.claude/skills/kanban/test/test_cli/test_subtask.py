"""Tests for subtask.py — parallel batch scheduling."""
from __future__ import annotations
import json
import os
import tempfile
from pathlib import Path
from core.cli.subtask import plan_batches, batch_details


def _setup_task(root: Path, subtasks: list[dict]) -> str:
    """Write task_breakdown.json and return task_id."""
    tasks_dir = root / ".kanban" / "tasks"
    tasks_dir.mkdir(parents=True, exist_ok=True)

    (root / ".kanban" / "config.json").write_text(json.dumps({"output_dir": "src"}))
    (root / ".kanban" / "workflow.json").write_text(json.dumps({
        "phases": [{"id": "plan"}, {"id": "execute"}],
        "pass_threshold": 9.0, "max_iterations": 6,
    }))

    task_id = "TASK-001"
    task_dir = tasks_dir / task_id
    task_dir.mkdir(parents=True, exist_ok=True)
    (task_dir / "task_breakdown.json").write_text(json.dumps({"subtasks": subtasks}))

    task_file = tasks_dir / f"{task_id}.json"
    task_file.write_text(json.dumps({
        "id": task_id, "title": "Test", "description": "",
        "status": "pending", "phase": "execute", "iteration": 1, "history": [],
    }))
    return task_id


def _run_in(root: Path, fn, *args):
    """Run fn with cwd set to root."""
    old = os.getcwd()
    try:
        os.chdir(str(root))
        return fn(*args)
    finally:
        os.chdir(old)


class TestPlanBatches:
    def test_empty_subtasks(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert plan["total_subtasks"] == 0
        assert plan["batches"] == []

    def test_single_subtask(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "One", "dependencies": [], "parallelizable": False}
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert len(plan["batches"]) == 1
        assert plan["batches"][0] == ["ST-001"]

    def test_two_independent_parallel(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "A", "dependencies": [], "parallelizable": True, "file_ownership": ["a.py"]},
            {"id": "ST-002", "title": "B", "dependencies": [], "parallelizable": True, "file_ownership": ["b.py"]},
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert len(plan["batches"]) == 1  # Same batch
        assert len(plan["batches"][0]) == 2

    def test_file_conflict_split_batches(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "A", "dependencies": [], "parallelizable": True, "file_ownership": ["shared.py"]},
            {"id": "ST-002", "title": "B", "dependencies": [], "parallelizable": True, "file_ownership": ["shared.py"]},
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert plan["total_batches"] >= 2  # Must be split

    def test_dependency_chain(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "A", "dependencies": [], "parallelizable": True, "file_ownership": ["a.py"]},
            {"id": "ST-002", "title": "B", "dependencies": ["ST-001"], "parallelizable": True, "file_ownership": ["b.py"]},
            {"id": "ST-003", "title": "C", "dependencies": ["ST-002"], "parallelizable": True, "file_ownership": ["c.py"]},
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert plan["total_batches"] == 3  # Each in own batch

    def test_mixed_dependencies(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "A", "dependencies": [], "parallelizable": True, "file_ownership": ["a.py"]},
            {"id": "ST-002", "title": "B", "dependencies": [], "parallelizable": True, "file_ownership": ["b.py"]},
            {"id": "ST-003", "title": "C", "dependencies": ["ST-001"], "parallelizable": True, "file_ownership": ["c.py"]},
            {"id": "ST-004", "title": "D", "dependencies": ["ST-001", "ST-002"], "parallelizable": True, "file_ownership": ["d.py"]},
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert plan["batches"][0] == ["ST-001", "ST-002"]  # Batch 1: independent
        # Batch 2: ST-003 (depends on ST-001) and ST-004 (depends on both in batch 1)
        # both have their deps satisfied and different files → can run together
        assert set(plan["batches"][1]) == {"ST-003", "ST-004"}

    def test_non_parallelizable_alone(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "A", "dependencies": [], "parallelizable": False, "file_ownership": ["a.py"]},
            {"id": "ST-002", "title": "B", "dependencies": [], "parallelizable": True, "file_ownership": ["b.py"]},
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        # ST-001 not parallelizable → own batch, ST-002 in separate batch
        assert len(plan["batches"][0]) == 1  # ST-001 alone

    def test_circular_dependency(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "A", "dependencies": ["ST-002"], "parallelizable": True},
            {"id": "ST-002", "title": "B", "dependencies": ["ST-001"], "parallelizable": True},
        ])
        plan = _run_in(tmp_kanban, plan_batches, task_id)
        assert "error" in plan
        assert "circular" in plan["error"]


class TestBatchDetails:
    def test_details(self, tmp_kanban):
        task_id = _setup_task(tmp_kanban, [
            {"id": "ST-001", "title": "One", "dependencies": [], "parallelizable": False, "file_ownership": ["a.py"]},
        ])
        details = _run_in(tmp_kanban, batch_details, task_id)
        assert details["total_batches"] == 1
        assert details["batches"][0]["size"] == 1
        assert details["batches"][0]["subtasks"][0]["id"] == "ST-001"
        assert details["batches"][0]["subtasks"][0]["file_ownership"] == ["a.py"]
