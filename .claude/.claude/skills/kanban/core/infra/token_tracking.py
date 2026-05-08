from __future__ import annotations
import json
from pathlib import Path


class TokenTracker:
    def __init__(self, data_file: Path, budget: int = 200000):
        self._file = Path(data_file)
        self._budget = budget
        self._data = self._load()

    def track(self, task_id: str, tokens: int, phase: str) -> None:
        entry = self._data.setdefault(task_id, {"by_phase": {}})
        entry["by_phase"][phase] = entry["by_phase"].get(phase, 0) + tokens
        entry["total_tokens"] = entry.get("total_tokens", 0) + tokens
        self._save()

    def report(self, task_id: str) -> dict:
        return self._data.get(
            task_id, {"total_tokens": 0, "by_phase": {}}
        )

    def check_budget(self, task_id: str) -> bool:
        return self.report(task_id)["total_tokens"] <= self._budget

    def _load(self) -> dict:
        if self._file.exists():
            return json.loads(self._file.read_text(encoding="utf-8"))
        return {}

    def _save(self) -> None:
        self._file.parent.mkdir(parents=True, exist_ok=True)
        self._file.write_text(json.dumps(self._data, indent=2), encoding="utf-8")
