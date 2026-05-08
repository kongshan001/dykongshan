from __future__ import annotations
import json


def _run(*args, cwd):
    import os, subprocess, sys
    from pathlib import Path
    _KANBAN_SRC = str(Path(__file__).resolve().parent.parent.parent)
    env = os.environ.copy()
    existing = env.get("PYTHONPATH", "")
    env["PYTHONPATH"] = _KANBAN_SRC + (f":{existing}" if existing else "")
    result = subprocess.run(
        [sys.executable, "-m", "core"] + list(args),
        capture_output=True, text=True, cwd=str(cwd), env=env,
    )
    return json.loads(result.stdout)


class TestGetPhaseAgents:
    def test_evaluate_agents_include_scheduling_config(self, tmp_kanban):
        """get-phase-agents evaluate returns timeout and parallel config."""
        result = _run("workflow", "get-phase-agents", "evaluate", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert "agents" in data
        assert isinstance(data["agents"], list)
        assert len(data["agents"]) >= 1

    def test_scheduling_config_included(self, tmp_kanban):
        """get-phase-agents returns scheduling metadata from config."""
        result = _run("workflow", "get-phase-agents", "evaluate", cwd=tmp_kanban)
        data = result["data"]
        # Scheduling metadata should include timeout and parallel config
        assert "scheduling" in data, f"Expected scheduling key, got: {list(data.keys())}"
        sched = data["scheduling"]
        assert "single_agent_seconds" in sched
        assert "max_parallel" in sched
