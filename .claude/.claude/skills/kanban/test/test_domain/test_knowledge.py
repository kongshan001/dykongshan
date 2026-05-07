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
