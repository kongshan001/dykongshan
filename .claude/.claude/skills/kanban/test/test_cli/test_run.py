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
        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["phase"] == "execute"

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
