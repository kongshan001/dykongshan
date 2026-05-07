from __future__ import annotations
import json
import pytest
from pathlib import Path

from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.types import Task, Phase, TaskStatus
from core.domain.task import TaskManager, TaskNotFoundError


class TestTaskManager:
    def test_create_task(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        task = tm.create("My Task", "A description")
        assert task.id == "TASK-001"
        assert task.title == "My Task"
        assert task.description == "A description"
        assert fs.file_exists(fs.task_file("TASK-001"))

    def test_create_task_increments_id(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        t1 = tm.create("First", "desc")
        t2 = tm.create("Second", "desc")
        assert t1.id == "TASK-001"
        assert t2.id == "TASK-002"

    def test_show_task(self, tmp_kanban, sample_task_file):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        task = tm.show("TASK-001")
        assert task.id == "TASK-001"
        assert task.title == "测试任务"

    def test_show_task_not_found(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        with pytest.raises(TaskNotFoundError):
            tm.show("TASK-999")

    def test_status(self, tmp_kanban, sample_task_file):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        status = tm.status()
        assert status["total"] >= 1

    def test_update_task(self, tmp_kanban, sample_task_file):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        tm.update("TASK-001", phase="execute", iteration=2)
        task = tm.show("TASK-001")
        assert task.phase == Phase.EXECUTE
        assert task.iteration == 2

    def test_delete_task(self, tmp_kanban, sample_task_file):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        tm.delete("TASK-001")
        assert not fs.file_exists(fs.task_file("TASK-001"))

    def test_create_with_auto_numeric_id(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        tm = TaskManager(fs, cfg)
        (fs.kanban_dir / "tasks" / "TASK-005.json").write_text(
            json.dumps({"id": "TASK-005", "title": "existing"})
        )
        task = tm.create("New", "desc")
        assert task.id == "TASK-006"
