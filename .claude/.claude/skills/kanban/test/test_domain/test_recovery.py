from __future__ import annotations
import json
from core.infra.filesystem import Filesystem
from core.domain.recovery import RecoveryManager


class TestRecoveryManager:
    def test_find_interrupted(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        (fs.kanban_dir / "tasks" / "TASK-001.json").write_text(json.dumps({
            "id": "TASK-001", "status": "in_progress", "phase": "execute"
        }))
        (fs.kanban_dir / "tasks" / "TASK-002.json").write_text(json.dumps({
            "id": "TASK-002", "status": "completed", "phase": "archive"
        }))
        rm = RecoveryManager(fs)
        interrupted = rm.find_interrupted()
        assert len(interrupted) == 1
        assert interrupted[0]["id"] == "TASK-001"

    def test_recover_existing_task(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        (fs.kanban_dir / "tasks" / "TASK-001.json").write_text(json.dumps({
            "id": "TASK-001", "status": "in_progress", "phase": "execute"
        }))
        rm = RecoveryManager(fs)
        result = rm.recover("TASK-001")
        assert result["success"] is True
        assert result["current_phase"] == "execute"

    def test_recover_missing_task(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        rm = RecoveryManager(fs)
        result = rm.recover("TASK-999")
        assert result["success"] is False

    def test_resume_returns_current_phase(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        (fs.kanban_dir / "tasks" / "TASK-001.json").write_text(json.dumps({
            "id": "TASK-001", "status": "in_progress", "phase": "execute"
        }))
        rm = RecoveryManager(fs)
        result = rm.resume("TASK-001")
        assert result["success"] is True
        assert result["current_phase"] == "execute"
        # Verify task file unchanged
        data = fs.read_json(fs.task_file("TASK-001"))
        assert data["phase"] == "execute"
        assert data["status"] == "in_progress"

    def test_rollback_goes_to_previous_phase(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        (fs.kanban_dir / "tasks" / "TASK-001.json").write_text(json.dumps({
            "id": "TASK-001", "status": "in_progress", "phase": "execute"
        }))
        rm = RecoveryManager(fs)
        result = rm.rollback("TASK-001")
        assert result["success"] is True
        assert result.get("rolled_back_to") is not None
        # Verify task file was updated to previous phase
        data = fs.read_json(fs.task_file("TASK-001"))
        assert data["phase"] != "execute"

    def test_rollback_from_plan_has_no_previous(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        (fs.kanban_dir / "tasks" / "TASK-001.json").write_text(json.dumps({
            "id": "TASK-001", "status": "in_progress", "phase": "plan"
        }))
        rm = RecoveryManager(fs)
        result = rm.rollback("TASK-001")
        assert result["success"] is False
        assert "no previous phase" in result.get("reason", "").lower()
