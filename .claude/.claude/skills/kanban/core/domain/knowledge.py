from __future__ import annotations
import re
from core.infra.filesystem import Filesystem


class KnowledgeManager:
    def __init__(
        self,
        fs: Filesystem,
        log_filename: str = "knowledge-log.md",
    ):
        self._fs = fs
        self._log_filename = log_filename

    def add(self, category: str, title: str, content: str) -> None:
        entry = f"\n### {category}: {title}\n\n{content}\n"
        log_path = self._fs.kanban_dir / self._log_filename
        with open(log_path, "a", encoding="utf-8") as f:
            f.write(entry)

    def search(self, keyword: str) -> list[str]:
        scored = self.search_scored(keyword)
        lines = []
        for r in scored:
            if "line" in r:
                lines.append(r["line"])
            elif r.get("title"):
                lines.append(f"[{r['category']}] {r['title']}: {r['content'][:100]}")
        return lines

    def search_scored(self, keyword: str) -> list[dict]:
        log_path = self._fs.kanban_dir / self._log_filename
        if not self._fs.file_exists(log_path):
            return []
        keyword_lower = keyword.lower()
        entries = self._parse_entries(log_path)

        if entries:
            results = []
            for e in entries:
                score = 0
                if keyword_lower in e["title"].lower():
                    score += 3
                if keyword_lower in e["category"].lower():
                    score += 2
                if keyword_lower in e["content"].lower():
                    score += 1
                if score > 0:
                    results.append({**e, "score": score})
            results.sort(key=lambda r: r["score"], reverse=True)
            return results

        # Fallback: line-based search for unparseable logs
        results = []
        with open(log_path, encoding="utf-8") as f:
            for line in f:
                if keyword_lower in line.lower():
                    results.append({
                        "line": line.strip(), "score": 1,
                        "title": "", "category": "", "content": line.strip(),
                    })
        return results

    def search_by_tag(self, tag: str) -> list[str]:
        return self._search_meta(f"[tag:{tag}]")

    def search_by_task(self, task_id: str) -> list[str]:
        return self._search_meta(f"[task:{task_id}]")

    def _parse_entries(self, log_path) -> list[dict]:
        """Parse knowledge-log.md into structured entries."""
        text = log_path.read_text(encoding="utf-8")
        entries = []
        # Match: ### category: title\n\ncontent
        pattern = re.compile(
            r'###\s+(\S+):\s*(.+?)\n\s*\n(.*?)(?=\n###|\Z)', re.DOTALL
        )
        for m in pattern.finditer(text):
            entries.append({
                "category": m.group(1),
                "title": m.group(2).strip(),
                "content": m.group(3).strip(),
            })
        return entries

    def _search_meta(self, pattern: str) -> list[str]:
        log_path = self._fs.kanban_dir / self._log_filename
        if not self._fs.file_exists(log_path):
            return []
        results = []
        with open(log_path, encoding="utf-8") as f:
            for line in f:
                if pattern in line:
                    results.append(line.strip())
        return results
