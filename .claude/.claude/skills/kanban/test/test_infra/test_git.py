from __future__ import annotations
import subprocess
import pytest
from pathlib import Path
from core.infra.git import Git, GitError


def _init_git(path: Path) -> None:
    subprocess.run(
        ["git", "init", "-b", "main", str(path)],
        capture_output=True, check=True
    )
    subprocess.run(
        ["git", "-C", str(path), "config", "user.email", "test@test.com"],
        capture_output=True, check=True
    )
    subprocess.run(
        ["git", "-C", str(path), "config", "user.name", "Test"],
        capture_output=True, check=True
    )
    (path / ".gitkeep").write_text("")
    subprocess.run(
        ["git", "-C", str(path), "add", ".gitkeep"],
        capture_output=True, check=True
    )
    subprocess.run(
        ["git", "-C", str(path), "commit", "-m", "initial"],
        capture_output=True, check=True
    )


class TestGit:
    def test_is_repo_true(self, tmp_path):
        _init_git(tmp_path)
        g = Git(tmp_path)
        assert g.is_repo() is True

    def test_is_repo_false(self, tmp_path):
        g = Git(tmp_path)
        assert g.is_repo() is False

    def test_current_branch(self, tmp_path):
        _init_git(tmp_path)
        g = Git(tmp_path)
        branch = g.current_branch()
        assert branch is not None
        assert len(branch) > 0

    def test_commit_and_push(self, tmp_path):
        _init_git(tmp_path)
        (tmp_path / "new_file.txt").write_text("hello")
        g = Git(tmp_path)
        g.add(["new_file.txt"])
        result = g.commit("test: add new file")
        assert result is True

    def test_has_uncommitted_changes_false_when_clean(self, tmp_path):
        _init_git(tmp_path)
        g = Git(tmp_path)
        assert g.has_uncommitted_changes() is False

    def test_has_uncommitted_changes_true_when_dirty(self, tmp_path):
        _init_git(tmp_path)
        (tmp_path / "dirty.txt").write_text("unstaged")
        g = Git(tmp_path)
        assert g.has_uncommitted_changes() is True

    def test_commit_fails_without_staged_changes(self, tmp_path):
        _init_git(tmp_path)
        g = Git(tmp_path)
        result = g.commit("empty commit")
        assert result is False

    def test_git_error_on_invalid_command(self, tmp_path):
        _init_git(tmp_path)
        g = Git(tmp_path)
        with pytest.raises(GitError):
            g._run(["nonexistent-git-command"])
