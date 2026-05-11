from __future__ import annotations
import json
from pathlib import Path


def _run(*args, cwd):
    import os, subprocess, sys
    _KANBAN_SRC = str(Path(__file__).resolve().parent.parent.parent)
    env = os.environ.copy()
    existing = env.get("PYTHONPATH", "")
    env["PYTHONPATH"] = _KANBAN_SRC + (f":{existing}" if existing else "")
    result = subprocess.run(
        [sys.executable, "-m", "core"] + list(args),
        capture_output=True, text=True, cwd=str(cwd), env=env,
    )
    return json.loads(result.stdout)


class TestInbox:
    def test_task_create_generates_inbox_template(self, tmp_kanban):
        """Creating a task should auto-generate inbox.md template."""
        result = _run("create", "Test task", "--desc", "Test description", cwd=tmp_kanban)
        assert result["success"] is True
        task_id = result["data"]["id"]

        inbox_path = tmp_kanban / ".kanban" / "tasks" / task_id / "inbox.md"
        assert inbox_path.exists(), "inbox.md should be created with task"

        content = inbox_path.read_text(encoding="utf-8")
        assert f"# Task Inbox — {task_id}" in content
        assert "用户反馈渠道" in content
        assert "kanban inbox add" in content

    def test_inbox_add_creates_new_entry(self, tmp_kanban, sample_task_file):
        """inbox add should append new entry to inbox.md."""
        result = _run("inbox", "add", "TASK-001", "Need to add more tests", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["action"] == "added"
        assert "Need to add more tests" in data["text"]

        inbox_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox.md"
        content = inbox_path.read_text(encoding="utf-8")
        assert "- [ ] Need to add more tests" in content

    def test_inbox_add_appends_to_existing(self, tmp_kanban, sample_task_file):
        """inbox add should append to existing inbox.md content."""
        # First add
        _run("inbox", "add", "TASK-001", "First item", cwd=tmp_kanban)
        # Second add
        result = _run("inbox", "add", "TASK-001", "Second item", cwd=tmp_kanban)
        assert result["success"] is True

        inbox_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox.md"
        content = inbox_path.read_text(encoding="utf-8")
        assert "First item" in content
        assert "Second item" in content

    def test_inbox_archive_moves_checked_items(self, tmp_kanban, sample_task_file):
        """inbox archive should move checked items to inbox-archive.md."""
        inbox_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox.md"
        # Create inbox with mixed items
        inbox_path.write_text(
            "# Task Inbox — TASK-001\n\n"
            "- [ ] Pending item\n"
            "- [x] Completed item 1\n"
            "- [x] Completed item 2\n"
            "- [ ] Another pending\n",
            encoding="utf-8"
        )

        result = _run("inbox", "archive", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["archived_count"] == 2
        assert data["pending_count"] == 2

        # Check archive file exists
        archive_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox-archive.md"
        assert archive_path.exists()
        archive_content = archive_path.read_text(encoding="utf-8")
        assert "Completed item 1" in archive_content
        assert "Completed item 2" in archive_content

        # Check inbox only has pending items
        inbox_content = inbox_path.read_text(encoding="utf-8")
        assert "- [ ] Pending item" in inbox_content
        assert "- [ ] Another pending" in inbox_content
        assert "Completed item" not in inbox_content

    def test_inbox_archive_empty_when_no_checked_items(self, tmp_kanban, sample_task_file):
        """inbox archive should do nothing when no checked items exist."""
        inbox_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox.md"
        inbox_path.write_text(
            "# Task Inbox — TASK-001\n\n"
            "- [ ] Only pending items\n"
            "- [ ] No completed ones\n",
            encoding="utf-8"
        )

        result = _run("inbox", "archive", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["archived_count"] == 0

        # Archive file should not be created
        archive_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox-archive.md"
        assert not archive_path.exists()

    def test_inbox_add_requires_text(self, tmp_kanban, sample_task_file):
        """inbox add should require feedback text."""
        result = _run("inbox", "add", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is False
        assert "feedback text required" in result["error"]

    def test_inbox_add_requires_task_id(self, tmp_kanban):
        """inbox add should require task_id."""
        result = _run("inbox", "add", cwd=tmp_kanban)
        assert result["success"] is False
        assert "task_id required" in result["error"]

    def test_guard_check_inbox_counts_pending(self, tmp_kanban, sample_task_file):
        """guard check-inbox should count pending items."""
        inbox_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox.md"
        inbox_path.write_text(
            "# Task Inbox — TASK-001\n\n"
            "- [ ] Pending item 1\n"
            "- [x] Completed item\n"
            "- [ ] Pending item 2\n",
            encoding="utf-8"
        )

        result = _run("guard", "check-inbox", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["has_pending"] is True
        assert data["pending_count"] == 2
        assert len(data["pending"]) == 2

    def test_inbox_natural_language_support(self, tmp_kanban, sample_task_file):
        """inbox should support natural language without format restrictions."""
        inbox_path = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "inbox.md"
        inbox_path.write_text(
            "# Task Inbox — TASK-001\n\n"
            "觉得这个功能还需要优化一下性能\n"
            "测试发现边界情况下有问题，需要修复\n"
            "想增加一个导出功能\n",
            encoding="utf-8"
        )

        result = _run("guard", "check-inbox", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["has_pending"] is True
        # Should count the natural language feedback items
        assert data["pending_count"] == 3
        assert "觉得这个功能还需要优化一下性能" in str(data["pending"])

    def test_inbox_archive_workflow(self, tmp_kanban, sample_task_file):
        """Demonstrate complete inbox workflow: add -> archive -> verify."""
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        inbox_path = task_dir / "inbox.md"

        # Initial content with checkbox format for archive demo
        inbox_path.write_text(
            "# Task Inbox — TASK-001\n\n"
            "- [ ] 需要补充单元测试\n"
            "- [ ] 优化数据库查询性能\n",
            encoding="utf-8"
        )

        # Add new item using command
        result = _run("inbox", "add", "TASK-001", "修复边界情况问题", cwd=tmp_kanban)
        assert result["success"] is True

        # Verify all items are pending
        result = _run("guard", "check-inbox", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["pending_count"] == 3

        # Mark items as completed (simulate user editing by manually updating file)
        inbox_path.write_text(
            "# Task Inbox — TASK-001\n\n"
            "- [x] 需要补充单元测试\n"
            "- [ ] 优化数据库查询性能\n"
            "- [x] 修复边界情况问题 <!-- 2026-05-10 12:00 -->\n",
            encoding="utf-8"
        )

        # Archive completed items
        result = _run("inbox", "archive", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["archived_count"] == 2
        assert data["pending_count"] == 1  # "优化数据库查询性能" remains

        # Verify archive file created
        archive_path = task_dir / "inbox-archive.md"
        assert archive_path.exists()
        archive_content = archive_path.read_text(encoding="utf-8")
        assert "需要补充单元测试" in archive_content
        assert "修复边界情况问题" in archive_content

        # Verify inbox only has pending item
        inbox_content = inbox_path.read_text(encoding="utf-8")
        assert "优化数据库查询性能" in inbox_content
        assert "需要补充单元测试" not in inbox_content
