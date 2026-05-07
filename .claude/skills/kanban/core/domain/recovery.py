from __future__ import annotations
import json
from core.infra.filesystem import Filesystem


class RecoveryManager:
    def __init__(self, fs: Filesystem):
        self._fs = fs

    def find_interrupted(self) -> list[dict]:
        interrupted = []
        for f in sorted(
            self._fs.kanban_dir.glob("tasks/TASK-*.json")
        ):
            data = json.loads(f.read_text())
            if data.get("status") in ("in_progress", "error"):
                interrupted.append({
                    "id": data["id"],
                    "phase": data.get("phase"),
                    "status": data.get("status"),
                })
        return interrupted

    def recover(self, task_id: str) -> dict:
        tf = self._fs.task_file(task_id)
        if not self._fs.file_exists(tf):
            return {"success": False, "reason": "task not found"}
        data = self._fs.read_json(tf)
        return {
            "success": True,
            "task_id": task_id,
            "current_phase": data.get("phase"),
        }
