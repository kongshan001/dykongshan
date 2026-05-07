from __future__ import annotations
import subprocess
import pytest
from pathlib import Path
from core.infra.git import Git
from core.infra.worktree import Worktree, WorktreeError


@pytest.fixture
def git_repo(tmp_path):
    root = tmp_path / "repo"
    root.mkdir()
    subprocess.run(
        ["git", "init", "-b", "main", str(root)],
        capture_output=True, check=True
    )
    subprocess.run(
        ["git", "-C", str(root), "config", "user.email", "t@t.com"],
        capture_output=True
    )
    subprocess.run(
        ["git", "-C", str(root), "config", "user.name", "T"],
        capture_output=True
    )
    (root / "f.txt").write_text("init")
    subprocess.run(
        ["git", "-C", str(root), "add", "f.txt"],
        capture_output=True
    )
    subprocess.run(
        ["git", "-C", str(root), "commit", "-m", "init"],
        capture_output=True
    )
    return root


class TestWorktree:
    def test_create_and_remove(self, git_repo):
        wt = Worktree(Git(git_repo), git_repo)
        wt_path = wt.create("TASK-001", "feature/kanban-TASK-001")
        assert wt_path.exists()
        assert (wt_path / "f.txt").exists()

        wt.remove("TASK-001", force=True)
        assert not wt_path.exists()

    def test_create_fails_when_duplicate(self, git_repo):
        wt = Worktree(Git(git_repo), git_repo)
        wt.create("TASK-002", "feature/kanban-TASK-002")
        with pytest.raises(WorktreeError):
            wt.create("TASK-002", "feature/kanban-TASK-002")

    def test_exists(self, git_repo):
        wt = Worktree(Git(git_repo), git_repo)
        assert wt.exists("TASK-999") is False
        wt.create("TASK-003", "feature/kanban-TASK-003")
        assert wt.exists("TASK-003") is True

    def test_list_all(self, git_repo):
        wt = Worktree(Git(git_repo), git_repo)
        wt.create("TASK-004", "feature/kanban-TASK-004")
        wts = wt.list_all()
        assert len(wts) >= 2  # main + TASK-004

    def test_remove_nonexistent_is_noop(self, git_repo):
        wt = Worktree(Git(git_repo), git_repo)
        wt.remove("TASK-999", force=True)  # should not raise
