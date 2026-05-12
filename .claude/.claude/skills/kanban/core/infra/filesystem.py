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
        # New format: .kanban/tasks/TASK-077/task.json
        new_path = self._kanban_dir / "tasks" / task_id / "task.json"
        if new_path.is_file():
            return new_path
        # Old format (or new task not yet created): .kanban/tasks/TASK-077.json
        return self._kanban_dir / "tasks" / f"{task_id}.json"

    def report_dir(self, task_id: str, iteration: int) -> Path:
        return self.iteration_dir(task_id, iteration)

    def iteration_dir(self, task_id: str, iteration: int) -> Path:
        return self._kanban_dir / "tasks" / task_id / f"iteration-{iteration}"

    def archive_dir(self) -> Path:
        return self._kanban_dir / "archive"

    def archive_task_file(self, task_id: str) -> Path:
        # New format: archive/TASK-077/task.json
        new_path = self._kanban_dir / "archive" / task_id / "task.json"
        if new_path.is_file():
            return new_path
        # Old format: archive/TASK-077.json
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
        try:
            with open(path, encoding="utf-8") as f:
                return json.load(f)
        except json.JSONDecodeError as e:
            raise ValueError(
                f"Invalid JSON in {path} at line {e.lineno}: {e.msg}"
            ) from e

    def write_json(self, path: Path, data: dict[str, Any]) -> None:
        self.ensure_dir(path.parent)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

    def file_exists(self, path: Path) -> bool:
        return path.is_file()

    @staticmethod
    def ensure_dir(path: Path) -> None:
        path.mkdir(parents=True, exist_ok=True)

    @staticmethod
    def resolve_python(config_path: Path | None = None) -> tuple[str, str]:
        """Resolve a working Python interpreter and the PYTHONPATH for core module.

        Returns:
            (python_bin, pythonpath) where pythonpath is the dir containing core/
        """
        import subprocess
        import sys

        # Determine PYTHONPATH: directory containing the core/ package
        # __file__ = .../core/infra/filesystem.py → parent.parent = .../core → parent = .../kanban/
        core_parent = Path(__file__).parent.parent.parent  # .claude/skills/kanban/
        pythonpath = str(core_parent)

        # 1. Check config.json python_bin
        if config_path and config_path.is_file():
            try:
                cfg = json.loads(config_path.read_text(encoding="utf-8"))
                bin_path = cfg.get("python_bin")
                if bin_path:
                    # Resolve relative to project root
                    if not Path(bin_path).is_absolute():
                        bin_path = str(config_path.parent.parent / bin_path)
                    result = subprocess.run(
                        [bin_path, "--version"],
                        capture_output=True, timeout=5,
                    )
                    if result.returncode == 0:
                        return bin_path, pythonpath
            except Exception:
                pass

        # 2. Use current interpreter (most reliable)
        if sys.executable and Path(sys.executable).exists():
            return sys.executable, pythonpath

        # 3. Try platform-appropriate candidates
        candidates = ["python", "python3"]
        for candidate in candidates:
            try:
                result = subprocess.run(
                    [candidate, "--version"],
                    capture_output=True, timeout=5,
                )
                # exit code 49 = Windows Store python3 stub; skip it
                if result.returncode == 0:
                    return candidate, pythonpath
                if result.returncode == 49:
                    continue
            except Exception:
                continue

        # Last resort
        return "python3", pythonpath
