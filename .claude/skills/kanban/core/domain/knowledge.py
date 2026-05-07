from __future__ import annotations
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
        with open(log_path, "a") as f:
            f.write(entry)

    def search(self, keyword: str) -> list[str]:
        log_path = self._fs.kanban_dir / self._log_filename
        if not self._fs.file_exists(log_path):
            return []
        results = []
        with open(log_path) as f:
            for line in f:
                if keyword in line:
                    results.append(line.strip())
        return results
