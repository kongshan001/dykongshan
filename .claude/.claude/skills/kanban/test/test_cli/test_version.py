from __future__ import annotations
import json
import os
import subprocess
import sys
from pathlib import Path

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


class TestVersion:
    def test_version_returns_info(self):
        result = _run("version", cwd=".")
        assert result["success"] is True
        data = result["data"]
        assert "version" in data
        assert "python" in data
        assert "platform" in data
        assert data["platform"] == sys.platform

    def test_version_record(self, tmp_kanban):
        result = _run("version", "record", "0.5.0", "--title", "Test release", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["version"] == "v0.5.0"
        assert result["data"]["recorded"] is True

        versions_dir = tmp_kanban / ".kanban" / "versions"
        assert (versions_dir / "v0.5.0.md").exists()
