from __future__ import annotations
import json
import os
import subprocess
import sys
from pathlib import Path

# Derive the kanban package root (skills/kanban/) so that PYTHONPATH includes it
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


class TestCLITask:
    def test_check_env(self, tmp_kanban):
        result = _run("check-env", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["ok"] is True

    def test_create_task(self, tmp_kanban):
        result = _run("create", "MyTask", "desc", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["id"] == "TASK-001"

    def test_show_task(self, tmp_kanban, sample_task_file):
        result = _run("show", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["id"] == "TASK-001"

    def test_show_missing_task(self, tmp_kanban):
        result = _run("show", "TASK-999", cwd=tmp_kanban)
        assert result["success"] is False

    def test_unknown_command(self):
        result = _run("nonexistent", cwd=".")
        assert result["success"] is False
        assert "UNKNOWN_COMMAND" in result.get("code", "")

    def test_status(self, tmp_kanban, sample_task_file):
        result = _run("status", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["total"] >= 1

    def test_help(self):
        result = _run("help", cwd=".")
        assert result["success"] is True
        assert "commands" in result["data"]
