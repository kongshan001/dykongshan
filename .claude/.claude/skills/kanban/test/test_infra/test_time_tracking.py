from __future__ import annotations
import time
import json
from core.infra.time_tracking import TimeTracker


class TestTimeTracker:
    def test_start_phase(self, tmp_path):
        tracker = TimeTracker(tmp_path / "time.json")
        tracker.start_phase("TASK-001", "plan")
        data = json.loads((tmp_path / "time.json").read_text())
        assert "TASK-001" in data
        assert "plan" in data["TASK-001"]["phases"]

    def test_end_phase(self, tmp_path):
        tracker = TimeTracker(tmp_path / "time.json")
        tracker.start_phase("TASK-001", "plan")
        time.sleep(0.01)
        tracker.end_phase("TASK-001", "plan")
        data = json.loads((tmp_path / "time.json").read_text())
        elapsed = data["TASK-001"]["phases"]["plan"]["elapsed_seconds"]
        assert elapsed > 0

    def test_report(self, tmp_path):
        tracker = TimeTracker(tmp_path / "time.json")
        tracker.start_phase("TASK-001", "plan")
        tracker.end_phase("TASK-001", "plan")
        report = tracker.report("TASK-001")
        assert report["total_seconds"] > 0
        assert len(report["phases"]) == 1
