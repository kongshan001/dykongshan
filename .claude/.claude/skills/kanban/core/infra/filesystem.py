from __future__ import annotations
import json
import os
from pathlib import Path
from typing import Any


class Filesystem:
    def __init__(self, root: Path):
        self._root = Path(root)
        self._kanban_dir = self._root / ".kanban"

    @staticmethod
    def find_project_root() -> Path:
        """Find the project root by walking up from cwd looking for .kanban/config.json.

        Priority:
        1. KANBAN_ROOT env var (if valid — contains .kanban/config.json)
        2. Walk up from cwd until .kanban/config.json found
        3. Fall back to cwd
        """
        env_root = os.environ.get("KANBAN_ROOT")
        if env_root:
            env_path = Path(env_root)
            if (env_path / ".kanban" / "config.json").is_file():
                return env_path

        cwd = Path.cwd()
        for parent in [cwd] + list(cwd.parents):
            if (parent / ".kanban" / "config.json").is_file():
                return parent
        return cwd

    @property
    def kanban_dir(self) -> Path:
        return self._kanban_dir

    def task_dir(self, task_id: str) -> Path:
        return self._kanban_dir / "tasks" / task_id

    def task_file(self, task_id: str) -> Path:
        return self._kanban_dir / "tasks" / f"{task_id}.json"

    def report_dir(self, task_id: str, iteration: int) -> Path:
        return self.iteration_dir(task_id, iteration) / "reports"

    def iteration_dir(self, task_id: str, iteration: int) -> Path:
        return self._kanban_dir / "tasks" / task_id / "iterations" / str(iteration)

    def archive_dir(self) -> Path:
        return self._kanban_dir / "archive"

    def archive_task_file(self, task_id: str) -> Path:
        return self._kanban_dir / "archive" / f"{task_id}.json"

    def inbox_file(self) -> Path:
        return self._kanban_dir / "inbox" / "inbox.json"

    def dispatch_dir(self, task_id: str) -> Path:
        return self._kanban_dir / "tasks" / task_id / "dispatch"

    def config_file(self) -> Path:
        return self._kanban_dir / "config.json"

    def workflow_file(self) -> Path:
        return self._kanban_dir / "workflow.json"

    def read_json(self, path: Path) -> dict[str, Any]:
        with open(path, encoding="utf-8") as f:
            return json.load(f)

    def write_json(self, path: Path, data: dict[str, Any]) -> None:
        self.ensure_dir(path.parent)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

    def file_exists(self, path: Path) -> bool:
        return path.is_file()

    @staticmethod
    def ensure_dir(path: Path) -> None:
        path.mkdir(parents=True, exist_ok=True)
