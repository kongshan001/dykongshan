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


def _setup_task_with_phase(task_file, task_dir, phase, desc):
    """Write task.json at desired phase and put minimal guard-passing artifacts."""
    task_data = json.loads(task_file.read_text())
    task_data["description"] = desc
    task_data["phase"] = phase
    task_file.write_text(json.dumps(task_data))

    task_dir.mkdir(parents=True, exist_ok=True)
    (task_dir / "requirements.md").write_text("# Requirements\n\nTest")
    (task_dir / "task_breakdown.json").write_text(json.dumps({
        "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
    }))
    (task_dir / "execution_summary.md").write_text("# Summary\n\nok")
    (task_dir / "execution_pitfalls.md").write_text("# Pitfalls\n\nnone")
    (task_dir / "execution_decisions.md").write_text("# Decisions\n\nok")
    # spec_review guard artifact
    (task_dir / "spec_review_report.json").write_text(json.dumps({"passed": True}))


class TestLightweightMode:
    def test_fix_task_returns_lightweight_available_not_enabled(self, tmp_kanban, sample_task_file):
        """Bug/fix task entering execute: lightweight_available=true, lightweight=false."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        _setup_task_with_phase(task_file, task_dir, "spec_review",
                                "修复一个 bug：transition 不持久化")

        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data.get("lightweight_available") is True, f"got {data}"
        assert data.get("lightweight") is not True

    def test_fix_task_with_flag_enables_lightweight(self, tmp_kanban, sample_task_file):
        """Bug task with --lightweight flag entering execute: lightweight=true."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        _setup_task_with_phase(task_file, task_dir, "spec_review",
                                "修复一个 bug：transition 不持久化")

        result = _run("run", "TASK-001", "--lightweight", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data.get("lightweight") is True, f"got {data}"

    def test_feature_task_no_lightweight_signal(self, tmp_kanban, sample_task_file):
        """New feature task entering execute: no lightweight signal."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        _setup_task_with_phase(task_file, task_dir, "spec_review",
                                "实现用户登录功能，支持 OAuth 和 JWT")

        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data.get("lightweight") is not True, f"got {data}"
        assert data.get("lightweight_available") is not True, f"got {data}"

    def test_lightweight_available_requires_confirmation(self, tmp_kanban, sample_task_file):
        """When lightweight_available, requires_confirmation signals AskUserQuestion."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        _setup_task_with_phase(task_file, task_dir, "spec_review",
                                "fix: 修复编码问题")

        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data.get("lightweight_available") is True
        assert data.get("requires_confirmation") is True, (
            f"lightweight_available must set requires_confirmation, got keys: {list(data.keys())}"
        )
