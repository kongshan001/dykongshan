from __future__ import annotations
from core.infra.filesystem import Filesystem
from core.domain.knowledge import KnowledgeManager


class TestKnowledgeManager:
    def test_add_entry(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        km.add("bug", "Test Bug", "A bug was found and fixed")
        log_path = fs.kanban_dir / "knowledge-log.md"
        content = log_path.read_text()
        assert "### bug: Test Bug" in content
        assert "A bug was found and fixed" in content

    def test_search_finds_entry(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        km.add("pattern", "Singleton", "Use singleton for config")
        results = km.search("Singleton")
        assert len(results) > 0

    def test_search_no_match(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        results = km.search("nonexistent_xyz")
        assert len(results) == 0

    def test_search_empty_log(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        results = km.search("anything")
        assert results == []

    def test_search_by_tag(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        km.add("bug", "NullPointer", "[tag:bugfix] null check missing")
        km.add("pattern", "Singleton", "[tag:design] use singleton")
        results = km.search_by_tag("bugfix")
        assert len(results) == 1
        assert "null check" in results[0]

    def test_search_by_task(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        km.add("fix", "Timeout", "[task:TASK-001] fixed timeout issue")
        km.add("fix", "Memory", "[task:TASK-002] fixed memory leak")
        results = km.search_by_task("TASK-001")
        assert len(results) == 1
        assert "timeout" in results[0]


class TestKnowledgeScoredSearch:
    def test_scored_search_ranks_by_relevance(self, tmp_kanban):
        """Title match scores higher than content match."""
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        # Title contains "worktree" — should rank first
        km.add("bug", "Worktree Cleanup", "[task:TASK-001] ensure worktree is removed")
        # Only content contains "worktree" — should rank lower
        km.add("pattern", "Git Isolation", "[task:TASK-002] use git worktree for isolation")

        results = km.search_scored("worktree")
        assert len(results) >= 2
        # First result should be the one with "worktree" in title
        assert "Worktree Cleanup" in results[0]["title"]

    def test_scored_search_returns_structured_entries(self, tmp_kanban):
        """Scored search returns dicts with title/category/content/score."""
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        km.add("architecture", "Module Design", "[task:TASK-001] modules should follow SOLID")

        results = km.search_scored("Module")
        assert len(results) == 1
        r = results[0]
        assert r["title"] == "Module Design"
        assert r["category"] == "architecture"
        assert r["score"] > 0

    def test_scored_search_fallback_to_line_search(self, tmp_kanban):
        """Unparseable entries fall back to line-based search."""
        fs = Filesystem(root=tmp_kanban)
        km = KnowledgeManager(fs)
        log_path = fs.kanban_dir / "knowledge-log.md"
        log_path.write_text("Just some random text with keyword_xyz in it\n")

        results = km.search_scored("keyword_xyz")
        assert len(results) == 1
        assert results[0]["score"] == 1  # fallback score
