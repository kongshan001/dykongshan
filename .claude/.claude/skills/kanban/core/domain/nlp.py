from __future__ import annotations
import json
import re
from pathlib import Path
from core.types import NLPResult


class NLPRouter:
    def __init__(self, patterns_path: Path):
        self._patterns = json.loads(Path(patterns_path).read_text(encoding="utf-8"))

    def parse(self, text: str) -> NLPResult:
        cmd = self._match_command(text)
        if cmd is None:
            return NLPResult(success=False, command="unknown")
        task_id = self._extract_task_id(text)
        return NLPResult(success=True, command=cmd, task_id=task_id)

    def _match_command(self, text: str) -> str | None:
        commands = self._patterns.get("commands", {})
        best_match = None
        best_score = 0.0
        lower = text.lower()

        for cmd_name, cmd_def in commands.items():
            for kw, weight in self._iter_keywords(cmd_def.get("keywords", [])):
                if kw in lower:
                    if weight > best_score:
                        best_score = weight
                        best_match = cmd_name

        return best_match

    @staticmethod
    def _iter_keywords(keywords):
        """Yield (keyword, weight) tuples, flattening nested {exact, synonyms, fuzzy} dicts."""
        if isinstance(keywords, dict):
            for kw in keywords.get("exact", []):
                yield kw, 1.0
            for kw in keywords.get("synonyms", []):
                yield kw, 0.8
            for kw in keywords.get("fuzzy", []):
                yield kw, 0.6
        elif isinstance(keywords, list):
            for kw in keywords:
                yield kw, 1.0

    def _extract_task_id(self, text: str) -> str | None:
        m = re.search(r"TASK-(\d{1,3})", text, re.IGNORECASE)
        if m:
            return f"TASK-{int(m.group(1)):03d}"

        cn_map = (
            self._patterns.get("task_id_patterns", {})
            .get("chinese_number", {})
            .get("mappings", {})
        )
        for cn, num in cn_map.items():
            if cn in text:
                return f"TASK-{num:03d}"

        return None


def parse_nlp(text: str) -> NLPResult:
    """Thin wrapper used by CLI."""
    patterns_dir = Path(__file__).resolve().parent.parent.parent / "lib"
    patterns_path = patterns_dir / "nlp_patterns.json"
    if patterns_path.exists():
        router = NLPRouter(patterns_path)
        return router.parse(text)
    return NLPResult(success=False, command="unknown")
