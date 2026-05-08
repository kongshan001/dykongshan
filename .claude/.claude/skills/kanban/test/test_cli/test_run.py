from __future__ import annotations
import json
import os
import subprocess
import sys
from pathlib import Path

# Derive the kanban package root (skills/kanban/)
_KANBAN_SRC = str(Path(__file__).resolve().parent.parent.parent)


def _run(*args, cwd):
    env = os.environ.copy()
    existing = env.get("PYTHONPATH", "")
    env["PYTHONPATH"] = _KANBAN_SRC + (f":{existing}" if existing else "")
    result = subprocess.run(
        [sys.executable, "-m", "core"] + list(args),
        capture_output=True, text=True, cwd=str(cwd), env=env,
    )
    return json.loads(result.stdout)


class TestCLIRun:
    def test_run_task(self, tmp_kanban, sample_task_file):
        # Set up required artifacts so guard check passes
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "requirements.md").write_text("# Requirements\n\nTest requirements.")
        (task_dir / "task_breakdown.json").write_text(json.dumps({
            "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
        }))
        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["phase"] == "plan_review"
        assert "agents_to_spawn" in result["data"]
        assert isinstance(result["data"]["agents_to_spawn"], list)

    def test_run_missing_task(self, tmp_kanban):
        result = _run("run", "TASK-999", cwd=tmp_kanban)
        assert result["success"] is False

    def test_decide(self, tmp_kanban, sample_task_file):
        result = _run(
            "decide", "TASK-001", "--action", "approve_and_archive",
            cwd=tmp_kanban,
        )
        assert result["success"] is True
        assert result["data"]["action"] == "approve_and_archive"

    def test_complete_phase_blocked_by_guard(self, tmp_kanban, sample_task_file):
        """complete-phase must check guard first — missing artifacts = blocked."""
        result = _run("workflow", "complete-phase", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is False
        assert "guard" in str(result).lower() or "fail" in str(result).lower()

    def test_complete_phase_passes_with_artifacts(self, tmp_kanban, sample_task_file):
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "requirements.md").write_text("# Requirements\n\nTest.")
        (task_dir / "task_breakdown.json").write_text(json.dumps({
            "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
        }))
        result = _run("workflow", "complete-phase", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True

    def test_workflow_transition_persists_phase_to_disk(self, tmp_kanban, sample_task_file):
        """cmd_workflow transition must persist the new phase to task.json (#101/#100)."""
        result = _run("workflow", "transition", "TASK-001", "plan_review", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["to"] == "plan_review"

        # Read the task back — phase must be persisted on disk
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        assert task_data["phase"] == "plan_review", (
            f"Expected phase=plan_review on disk, got {task_data['phase']}"
        )
