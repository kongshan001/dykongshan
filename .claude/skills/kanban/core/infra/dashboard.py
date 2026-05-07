from __future__ import annotations
import json
from pathlib import Path


class DashboardBuilder:
    def __init__(self, tasks_dir: Path):
        self._tasks_dir = Path(tasks_dir)

    def build(self) -> dict:
        tasks = []
        for f in sorted(self._tasks_dir.glob("TASK-*.json")):
            tasks.append(json.loads(f.read_text()))

        by_status: dict[str, int] = {}
        by_phase: dict[str, int] = {}
        for t in tasks:
            s = t.get("status", "unknown")
            p = t.get("phase", "unknown")
            by_status[s] = by_status.get(s, 0) + 1
            by_phase[p] = by_phase.get(p, 0) + 1

        return {
            "total": len(tasks),
            "by_status": by_status,
            "by_phase": by_phase,
            "tasks": [
                {"id": t["id"], "title": t["title"], "status": t.get("status")}
                for t in tasks
            ],
        }
