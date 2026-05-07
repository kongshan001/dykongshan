from __future__ import annotations
import json
from core.infra.dashboard import DashboardBuilder


class TestDashboardBuilder:
    def test_build_from_tasks(self, tmp_path):
        tasks_dir = tmp_path / "tasks"
        tasks_dir.mkdir()
        (tasks_dir / "TASK-001.json").write_text(json.dumps({
            "id": "TASK-001", "title": "One", "status": "in_progress",
            "phase": "execute", "iteration": 2,
        }))
        (tasks_dir / "TASK-002.json").write_text(json.dumps({
            "id": "TASK-002", "title": "Two", "status": "pending",
            "phase": "plan", "iteration": 1,
        }))

        builder = DashboardBuilder(tasks_dir)
        data = builder.build()
        assert data["total"] == 2
        assert data["by_status"]["in_progress"] == 1
        assert data["by_status"]["pending"] == 1
        assert len(data["tasks"]) == 2
