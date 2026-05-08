from __future__ import annotations
import json
from pathlib import Path
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


class TestDashboardJSIntegrity:
    """Verify all JS files referenced by dashboard components exist (#103)."""

    @staticmethod
    def _dashboard_root() -> Path:
        return Path(__file__).resolve().parent.parent.parent / "dashboard" / "js"

    def test_stats_overview_exists(self):
        f = self._dashboard_root() / "components" / "StatsOverview.js"
        assert f.is_file(), f"Missing {f}"

    def test_use_score_chart_exists(self):
        f = self._dashboard_root() / "composables" / "useScoreChart.js"
        assert f.is_file(), f"Missing {f}"

    def test_all_imported_files_exist(self):
        """Every JS file imported by KanbanBoard.js must be resolvable."""
        root = self._dashboard_root()
        required = [
            root / "components" / "KanbanBoard.js",
            root / "components" / "StatsOverview.js",
            root / "composables" / "useRealtime.js",
            root / "composables" / "useReportViewer.js",
            root / "composables" / "useSearchFilter.js",
            root / "composables" / "useTaskDetail.js",
            root / "composables" / "useScoreChart.js",
        ]
        missing = [str(f) for f in required if not f.is_file()]
        assert not missing, f"Missing dashboard files: {missing}"
