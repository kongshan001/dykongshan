from __future__ import annotations
import json
from pathlib import Path

from core.types import Task, TaskStatus, Phase
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.infra.consts import Consts


class TaskNotFoundError(Exception):
    pass


class TaskManager:
    def __init__(self, fs: Filesystem, config: Config):
        self._fs = fs
        self._cfg = config

    def create(self, title: str, description: str) -> Task:
        task_id = self._next_task_id()
        task = Task(id=task_id, title=title, description=description)
        self._write_task(task)
        return task

    def show(self, task_id: str) -> Task:
        tf = self._fs.task_file(task_id)
        if not self._fs.file_exists(tf):
            raise TaskNotFoundError(f"Task {task_id} not found")
        return self._read_task(tf)

    def status(self) -> dict:
        tasks = []
        for f in sorted(self._fs.kanban_dir.glob("tasks/TASK-*.json")):
            tasks.append(json.loads(f.read_text()))
        by_status: dict[str, int] = {}
        for t in tasks:
            s = t.get("status", "unknown")
            by_status[s] = by_status.get(s, 0) + 1
        return {"total": len(tasks), "by_status": by_status, "tasks": tasks}

    def update(self, task_id: str, **kwargs) -> Task:
        task = self.show(task_id)
        for key, value in kwargs.items():
            if key == "phase" and isinstance(value, str):
                value = Phase(value)
            if key == "status" and isinstance(value, str):
                value = TaskStatus(value)
            if hasattr(task, key):
                setattr(task, key, value)
        self._write_task(task)
        return task

    def delete(self, task_id: str) -> None:
        tf = self._fs.task_file(task_id)
        if self._fs.file_exists(tf):
            tf.unlink()

    def _next_task_id(self) -> str:
        existing = list(self._fs.kanban_dir.glob("tasks/TASK-*.json"))
        if not existing:
            return "TASK-001"
        nums = []
        for p in existing:
            try:
                nums.append(int(p.stem.split("-")[1]))
            except (IndexError, ValueError):
                pass
        return f"{Consts.TASK_ID_PREFIX}{max(nums) + 1:03d}"

    def _read_task(self, path: Path) -> Task:
        data = self._fs.read_json(path)
        return Task(
            id=data["id"],
            title=data["title"],
            description=data.get("description", ""),
            status=TaskStatus(data.get("status", "pending")),
            phase=Phase(data.get("phase", "plan")),
            iteration=data.get("iteration", 1),
            history=data.get("history", []),
        )

    def _write_task(self, task: Task) -> None:
        data = {
            "id": task.id,
            "title": task.title,
            "description": task.description,
            "status": task.status.value,
            "phase": task.phase.value,
            "iteration": task.iteration,
            "history": task.history,
        }
        self._fs.write_json(self._fs.task_file(task.id), data)
