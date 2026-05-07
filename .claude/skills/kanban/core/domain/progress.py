from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem


class ProgressTracker:
    def __init__(self, fs: Filesystem):
        self._fs = fs

    def subtask_start(self, task_id: str, subtask_id: str) -> None:
        checkpoint = self._checkpoint_file(task_id)
        self._fs.ensure_dir(checkpoint.parent)
        data = (
            self._fs.read_json(checkpoint)
            if self._fs.file_exists(checkpoint)
            else {}
        )
        data[subtask_id] = {"status": "in_progress", "started": True}
        self._fs.write_json(checkpoint, data)

    def subtask_done(self, task_id: str, subtask_id: str) -> None:
        checkpoint = self._checkpoint_file(task_id)
        data = (
            self._fs.read_json(checkpoint)
            if self._fs.file_exists(checkpoint)
            else {}
        )
        data[subtask_id] = {"status": "completed"}
        self._fs.write_json(checkpoint, data)

    def progress(self, task_id: str) -> dict:
        checkpoint = self._checkpoint_file(task_id)
        if not self._fs.file_exists(checkpoint):
            return {"total": 0, "completed": 0}
        data = self._fs.read_json(checkpoint)
        total = len(data)
        completed = sum(
            1 for v in data.values() if v.get("status") == "completed"
        )
        return {"total": total, "completed": completed}

    def _checkpoint_file(self, task_id: str) -> Path:
        return self._fs.task_dir(task_id) / "checkpoint.json"
