from __future__ import annotations
import json
import re
from pathlib import Path
from core.types import NLPResult


class NLPRouter:
    def __init__(self, patterns_path: Path):
        self._patterns = json.loads(Path(patterns_path).read_text())

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
            for kw in cmd_def.get("keywords", []):
                if kw in lower:
                    if 1.0 > best_score:
                        best_score = 1.0
                        best_match = cmd_name

        return best_match

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
