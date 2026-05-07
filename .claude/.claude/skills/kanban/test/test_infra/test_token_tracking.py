from __future__ import annotations
from core.infra.token_tracking import TokenTracker


class TestTokenTracker:
    def test_track_tokens(self, tmp_path):
        tracker = TokenTracker(tmp_path / "tokens.json")
        tracker.track("TASK-001", 1500, "plan")
        report = tracker.report("TASK-001")
        assert report["total_tokens"] == 1500
        assert report["by_phase"]["plan"] == 1500

    def test_multiple_phases(self, tmp_path):
        tracker = TokenTracker(tmp_path / "tokens.json")
        tracker.track("TASK-001", 1000, "plan")
        tracker.track("TASK-001", 2000, "execute")
        report = tracker.report("TASK-001")
        assert report["total_tokens"] == 3000

    def test_budget_check_under(self, tmp_path):
        tracker = TokenTracker(tmp_path / "tokens.json", budget=5000)
        tracker.track("TASK-001", 3000, "execute")
        assert tracker.check_budget("TASK-001") is True

    def test_budget_check_over(self, tmp_path):
        tracker = TokenTracker(tmp_path / "tokens.json", budget=1000)
        tracker.track("TASK-001", 2000, "execute")
        assert tracker.check_budget("TASK-001") is False
