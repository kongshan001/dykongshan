"""Tests for auto_mode feature (Issue #109)."""
from __future__ import annotations
import json

from core.types import AutoMode, Task, TaskStatus, Phase


class TestAutoModeDataclass:
    def test_default_all_false(self):
        am = AutoMode()
        assert am.auto_brainstorm is False
        assert am.auto_iteration is False
        assert am.auto_lightweight is False
        assert am.auto_archive is False
        assert am.auto_worktree is False

    def test_selective_enable(self):
        am = AutoMode(auto_brainstorm=True, auto_archive=True)
        assert am.auto_brainstorm is True
        assert am.auto_iteration is False
        assert am.auto_lightweight is False
        assert am.auto_archive is True
        assert am.auto_worktree is False

    def test_all_enabled(self):
        am = AutoMode(True, True, True, True)
        assert all([am.auto_brainstorm, am.auto_iteration,
                     am.auto_lightweight, am.auto_archive])
        assert am.auto_worktree is False

    def test_auto_worktree_flag(self):
        am = AutoMode(auto_worktree=True)
        assert am.auto_worktree is True
        assert am.auto_brainstorm is False


class TestAutoModeSerialization:
    def test_write_task_includes_auto_mode(self, tmp_path):
        """Task JSON should include auto_mode field."""
        from core.infra.filesystem import Filesystem
        from core.infra.config import Config
        from core.domain.task import TaskManager

        kanban_dir = tmp_path / ".kanban"
        kanban_dir.mkdir()
        (kanban_dir / "config.json").write_text("{}")
        (kanban_dir / "workflow.json").write_text('{"phases":[]}')
        tasks_dir = kanban_dir / "tasks"
        tasks_dir.mkdir()

        fs = Filesystem(root=tmp_path)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)

        auto_mode = AutoMode(auto_brainstorm=True, auto_iteration=True)
        task = tm.create("Test task", "desc")
        tm.update(task.id, auto_mode=auto_mode)

        # Read raw JSON from new directory format
        task_file = tasks_dir / task.id / "task.json"
        raw = json.loads(task_file.read_text(encoding="utf-8"))
        assert "auto_mode" in raw
        assert raw["auto_mode"]["auto_brainstorm"] is True
        assert raw["auto_mode"]["auto_iteration"] is True
        assert raw["auto_mode"]["auto_lightweight"] is False
        assert raw["auto_mode"]["auto_archive"] is False

    def test_read_task_with_auto_mode(self, tmp_path):
        """Reading task.json with auto_mode should parse correctly."""
        from core.infra.filesystem import Filesystem
        from core.infra.config import Config
        from core.domain.task import TaskManager

        kanban_dir = tmp_path / ".kanban"
        kanban_dir.mkdir()
        (kanban_dir / "config.json").write_text("{}")
        (kanban_dir / "workflow.json").write_text('{"phases":[]}')
        tasks_dir = kanban_dir / "tasks"
        tasks_dir.mkdir()

        # Write task with auto_mode
        task_data = {
            "id": "TASK-001",
            "title": "Test",
            "description": "",
            "status": "pending",
            "phase": "plan",
            "iteration": 1,
            "history": [],
            "scores": {},
            "score_history": [],
            "auto_mode": {
                "auto_brainstorm": True,
                "auto_iteration": False,
                "auto_lightweight": True,
                "auto_archive": True,
            },
        }
        (tasks_dir / "TASK-001.json").write_text(
            json.dumps(task_data), encoding="utf-8"
        )
        (tasks_dir / "TASK-001").mkdir()

        fs = Filesystem(root=tmp_path)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)

        task = tm.show("TASK-001")
        assert task.auto_mode.auto_brainstorm is True
        assert task.auto_mode.auto_iteration is False
        assert task.auto_mode.auto_lightweight is True
        assert task.auto_mode.auto_archive is True

    def test_read_task_without_auto_mode_defaults_false(self, tmp_path):
        """Legacy task.json without auto_mode should default to all False."""
        from core.infra.filesystem import Filesystem
        from core.infra.config import Config
        from core.domain.task import TaskManager

        kanban_dir = tmp_path / ".kanban"
        kanban_dir.mkdir()
        (kanban_dir / "config.json").write_text("{}")
        (kanban_dir / "workflow.json").write_text('{"phases":[]}')
        tasks_dir = kanban_dir / "tasks"
        tasks_dir.mkdir()

        task_data = {
            "id": "TASK-001",
            "title": "Legacy task",
            "description": "",
            "status": "pending",
            "phase": "plan",
            "iteration": 1,
            "history": [],
            "scores": {},
            "score_history": [],
        }
        (tasks_dir / "TASK-001.json").write_text(
            json.dumps(task_data), encoding="utf-8"
        )
        (tasks_dir / "TASK-001").mkdir()

        fs = Filesystem(root=tmp_path)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)

        task = tm.show("TASK-001")
        assert task.auto_mode.auto_brainstorm is False
        assert task.auto_mode.auto_iteration is False
        assert task.auto_mode.auto_lightweight is False
        assert task.auto_mode.auto_archive is False

    def test_create_with_auto_mode_all(self, tmp_path):
        """Create task with auto_mode=all via TaskManager directly."""
        from core.infra.filesystem import Filesystem
        from core.infra.config import Config
        from core.domain.task import TaskManager

        kanban_dir = tmp_path / ".kanban"
        kanban_dir.mkdir()
        (kanban_dir / "config.json").write_text("{}")
        (kanban_dir / "workflow.json").write_text('{"phases":[]}')
        (kanban_dir / "tasks").mkdir()

        fs = Filesystem(root=tmp_path)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)

        auto_mode = AutoMode(True, True, True, True)
        task = tm.create("Test", "desc")
        tm.update(task.id, auto_mode=auto_mode)

        updated = tm.show(task.id)
        assert updated.auto_mode.auto_brainstorm is True
        assert updated.auto_mode.auto_iteration is True
        assert updated.auto_mode.auto_lightweight is True
        assert updated.auto_mode.auto_archive is True

    def test_create_with_auto_mode_selective(self, tmp_path):
        """Create task with selective auto-mode via TaskManager directly."""
        from core.infra.filesystem import Filesystem
        from core.infra.config import Config
        from core.domain.task import TaskManager

        kanban_dir = tmp_path / ".kanban"
        kanban_dir.mkdir()
        (kanban_dir / "config.json").write_text("{}")
        (kanban_dir / "workflow.json").write_text('{"phases":[]}')
        (kanban_dir / "tasks").mkdir()

        fs = Filesystem(root=tmp_path)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)

        auto_mode = AutoMode(auto_brainstorm=True, auto_archive=True)
        task = tm.create("Test", "desc")
        tm.update(task.id, auto_mode=auto_mode)

        updated = tm.show(task.id)
        assert updated.auto_mode.auto_brainstorm is True
        assert updated.auto_mode.auto_iteration is False
        assert updated.auto_mode.auto_lightweight is False
        assert updated.auto_mode.auto_archive is True
