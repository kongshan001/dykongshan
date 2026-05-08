from __future__ import annotations
import json
from pathlib import Path
from core.infra.filesystem import Filesystem


class TestFilesystem:
    def test_task_dir(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        d = fs.task_dir("TASK-001")
        assert d == tmp_kanban / ".kanban" / "tasks" / "TASK-001"

    def test_task_file(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        f = fs.task_file("TASK-001")
        assert f == tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"

    def test_report_dir(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        d = fs.report_dir("TASK-001", 1)
        expected = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "iterations" / "1" / "reports"
        assert d == expected

    def test_archive_dir(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        d = fs.archive_dir()
        assert d == tmp_kanban / ".kanban" / "archive"

    def test_archive_task_file(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        f = fs.archive_task_file("TASK-001")
        assert f == tmp_kanban / ".kanban" / "archive" / "TASK-001.json"

    def test_inbox_file(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        f = fs.inbox_file()
        assert f == tmp_kanban / ".kanban" / "inbox" / "inbox.json"

    def test_read_json(self, tmp_kanban):
        data = {"foo": "bar"}
        p = tmp_kanban / "test.json"
        p.write_text(json.dumps(data))
        fs = Filesystem(root=tmp_kanban)
        assert fs.read_json(p) == data

    def test_write_json(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        p = tmp_kanban / "out.json"
        fs.write_json(p, {"key": "value"})
        assert json.loads(p.read_text()) == {"key": "value"}

    def test_ensure_dir(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        p = tmp_kanban / "deep" / "nested" / "dir"
        fs.ensure_dir(p)
        assert p.is_dir()

    def test_iteration_dir(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        d = fs.iteration_dir("TASK-001", 2)
        expected = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "iterations" / "2"
        assert d == expected

    def test_file_exists(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        p = tmp_kanban / "exists.txt"
        p.write_text("hi")
        assert fs.file_exists(p) is True
        assert fs.file_exists(tmp_kanban / "nope.txt") is False

    def test_config_file(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        assert fs.config_file() == tmp_kanban / ".kanban" / "config.json"

    def test_workflow_file(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        assert fs.workflow_file() == tmp_kanban / ".kanban" / "workflow.json"


class TestFindProjectRoot:
    def test_finds_root_from_subdirectory(self, tmp_path):
        """Walk up from subdirectory to find .kanban/config.json."""
        project_root = tmp_path / "myproject"
        kanban_dir = project_root / ".kanban"
        kanban_dir.mkdir(parents=True)
        (kanban_dir / "config.json").write_text('{"output_dir": "src"}')

        subdir = project_root / "src" / "lib" / "deep"
        subdir.mkdir(parents=True)

        import os
        old = os.getcwd()
        try:
            os.chdir(str(subdir))
            found = Filesystem.find_project_root()
            assert (found / ".kanban" / "config.json").exists()
        finally:
            os.chdir(old)

    def test_falls_back_to_cwd(self, tmp_path):
        """No config found → fall back to cwd."""
        import os
        old = os.getcwd()
        try:
            os.chdir(str(tmp_path))
            found = Filesystem.find_project_root()
            assert found == Path(tmp_path)
        finally:
            os.chdir(old)

    def test_config_at_cwd(self, tmp_path):
        """config.json directly in cwd's .kanban/."""
        (tmp_path / ".kanban").mkdir(parents=True)
        (tmp_path / ".kanban" / "config.json").write_text('{}')

        import os
        old = os.getcwd()
        try:
            os.chdir(str(tmp_path))
            found = Filesystem.find_project_root()
            assert (found / ".kanban" / "config.json").exists()
        finally:
            os.chdir(old)

    def test_env_var_override(self, tmp_path, monkeypatch):
        """KANBAN_ROOT env var takes priority."""
        project_root = tmp_path / "explicit"
        (project_root / ".kanban").mkdir(parents=True)
        (project_root / ".kanban" / "config.json").write_text('{}')

        monkeypatch.setenv("KANBAN_ROOT", str(project_root))
        found = Filesystem.find_project_root()
        assert found == project_root

    def test_env_var_invalid_falls_back(self, tmp_path, monkeypatch):
        """Invalid KANBAN_ROOT falls back to search."""
        monkeypatch.setenv("KANBAN_ROOT", str(tmp_path / "nonexistent"))
        (tmp_path / ".kanban").mkdir(parents=True)
        (tmp_path / ".kanban" / "config.json").write_text('{}')

        import os
        old = os.getcwd()
        try:
            os.chdir(str(tmp_path))
            found = Filesystem.find_project_root()
            assert (found / ".kanban" / "config.json").exists()
        finally:
            os.chdir(old)
