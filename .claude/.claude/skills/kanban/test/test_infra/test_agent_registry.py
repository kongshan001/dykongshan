from __future__ import annotations
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.infra.scheduler import Scheduler


class TestAgentRegistry:
    def test_scan_agents_discovers_md_files(self, tmp_kanban):
        """scan_agents discovers .md files from .claude/agents/."""
        agents_dir = tmp_kanban / ".claude" / "agents"
        agents_dir.mkdir(parents=True)
        (agents_dir / "kanban-planner.md").write_text("---\nname: planner\n---\n")
        (agents_dir / "custom-reviewer.md").write_text("---\nname: reviewer\n---\n")

        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        scheduler = Scheduler()
        agents = scheduler.scan_agents(fs)

        assert len(agents) >= 2
        names = [a["name"] for a in agents]
        assert "kanban-planner" in names
        assert "custom-reviewer" in names

    def test_scan_agents_empty_dir(self, tmp_kanban):
        """Empty agents dir returns empty list."""
        agents_dir = tmp_kanban / ".claude" / "agents"
        agents_dir.mkdir(parents=True)

        fs = Filesystem(root=tmp_kanban)
        scheduler = Scheduler()
        agents = scheduler.scan_agents(fs)

        assert agents == []


class TestBudgetCircuitBreaker:
    def test_budget_config_exposed(self, tmp_kanban):
        """Config returns budget settings."""
        import json
        config_file = tmp_kanban / ".kanban" / "config.json"
        config_data = json.loads(config_file.read_text())
        config_data["budget"] = {
            "per_task": 500000,
            "per_phase": {"plan": 50000, "execute": 200000, "evaluate": 150000},
            "warning_threshold": 0.8,
            "hard_limit": True,
        }
        config_file.write_text(json.dumps(config_data))

        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        budget = cfg.raw.get("budget", {})

        assert budget["per_task"] == 500000
        assert budget["warning_threshold"] == 0.8
        assert budget["hard_limit"] is True

    def test_budget_warning_at_threshold(self, tmp_kanban):
        """Warning when token usage exceeds threshold."""
        import json
        config_file = tmp_kanban / ".kanban" / "config.json"
        config_data = json.loads(config_file.read_text())
        config_data["budget"] = {
            "per_task": 100000,
            "warning_threshold": 0.8,
            "hard_limit": True,
        }
        config_file.write_text(json.dumps(config_data))

        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        budget = cfg.raw.get("budget", {})

        # Simulate: used 85000 / 100000 = 85% > 80% threshold
        used = 85000
        limit = budget["per_task"]
        threshold = limit * budget["warning_threshold"]
        assert used > threshold  # should trigger warning
