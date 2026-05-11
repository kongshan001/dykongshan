from __future__ import annotations
import json
import time
from pathlib import Path

from core.types import Task, TaskStatus, Phase, AutoMode
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
        task.history.append({
            "phase": "plan",
            "status": "started",
            "started_at": time.time(),
        })
        self._write_task(task)
        self._create_task_templates(task_id)
        return task

    def _create_task_templates(self, task_id: str) -> None:
        """Create template files for a new task, including inbox.md."""
        task_dir = self._fs.task_dir(task_id)
        self._fs.ensure_dir(task_dir)

        # Create inbox.md template (natural language, no format restrictions)
        inbox_path = task_dir / "inbox.md"
        if not self._fs.file_exists(inbox_path):
            inbox_path.write_text(
                f"# Task Inbox — {task_id}\n\n"
                f"## 用户反馈渠道\n\n"
                f"在此记录任务相关的用户反馈、改进建议、待办事项等。\n\n"
                f"可以使用自然语言自由记录，LLM 会自动解析和理解。\n\n"
                f"### 示例\n\n"
                f"- 觉得这个功能还需要优化一下性能\n"
                f"- 测试发现边界情况下有问题，需要修复\n"
                f"- 想增加一个导出功能\n\n"
                f"---\n\n"
                f"**提示**: 使用 \\`kanban inbox add {task_id} \"反馈内容\"\\` 添加新事项\n",
                encoding="utf-8"
            )

    def show(self, task_id: str) -> Task:
        tf = self._fs.task_file(task_id)
        if not self._fs.file_exists(tf):
            raise TaskNotFoundError(f"Task {task_id} not found")
        return self._read_task(tf)

    def status(self) -> dict:
        tasks = []
        seen_ids = set()
        # New format: tasks/TASK-NNN/task.json
        for f in sorted(self._fs.kanban_dir.glob("tasks/TASK-*/task.json")):
            data = json.loads(f.read_text(encoding="utf-8"))
            tasks.append(data)
            seen_ids.add(data.get("id", ""))
        # Old format: tasks/TASK-NNN.json (skip if already found in new format)
        for f in sorted(self._fs.kanban_dir.glob("tasks/TASK-*.json")):
            if f.stem not in seen_ids:
                tasks.append(json.loads(f.read_text(encoding="utf-8")))
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

    def record_decision(self, task_id: str, action: str) -> None:
        task = self.show(task_id)
        task.history.append({
            "phase": "user_decision",
            "action": action,
            "timestamp": time.time(),
        })
        self._write_task(task)

    def delete(self, task_id: str) -> None:
        import shutil
        # Remove directory-based task (new format)
        task_dir = self._fs.task_dir(task_id)
        if task_dir.is_dir():
            shutil.rmtree(task_dir)
        # Remove flat file (old format)
        flat = self._fs.kanban_dir / "tasks" / f"{task_id}.json"
        if flat.is_file():
            flat.unlink()

    def _next_task_id(self) -> str:
        nums = []
        for pattern in ("tasks/TASK-*/task.json", "tasks/TASK-*.json", "archive/TASK-*"):
            for p in self._fs.kanban_dir.glob(pattern):
                # Extract task ID from path: tasks/TASK-077/task.json or tasks/TASK-077.json
                parts = p.parts
                for part in parts:
                    if part.startswith("TASK-"):
                        try:
                            n = int(part.replace(".json", "").split("-")[1])
                            nums.append(n)
                        except (IndexError, ValueError):
                            pass
                        break
        if not nums:
            return "TASK-001"
        return f"{Consts.TASK_ID_PREFIX}{max(nums) + 1:03d}"

    def _read_task(self, path: Path) -> Task:
        data = self._fs.read_json(path)
        # Parse auto_mode from JSON
        auto_mode_data = data.get("auto_mode", {})
        if isinstance(auto_mode_data, dict):
            auto_mode = AutoMode(
                auto_brainstorm=auto_mode_data.get("auto_brainstorm", False),
                auto_iteration=auto_mode_data.get("auto_iteration", False),
                auto_lightweight=auto_mode_data.get("auto_lightweight", False),
                auto_archive=auto_mode_data.get("auto_archive", False),
                auto_worktree=auto_mode_data.get("auto_worktree", False),
            )
        elif isinstance(auto_mode_data, bool):
            # Legacy support: boolean -> enable all
            auto_mode = AutoMode(
                auto_brainstorm=auto_mode_data,
                auto_iteration=auto_mode_data,
                auto_lightweight=auto_mode_data,
                auto_archive=auto_mode_data,
                auto_worktree=auto_mode_data,
            )
        else:
            auto_mode = AutoMode()

        return Task(
            id=data["id"],
            title=data["title"],
            description=data.get("description", ""),
            status=TaskStatus(data.get("status", "pending")),
            phase=Phase(data.get("phase", "plan")),
            iteration=data.get("iteration", 1),
            lightweight=data.get("lightweight", False),
            history=data.get("history", []),
            scores=data.get("scores", {}),
            score_history=data.get("score_history", []),
            auto_mode=auto_mode,
            user_decision=data.get("user_decision"),
        )

    def _write_task(self, task: Task) -> None:
        data = {
            "id": task.id,
            "title": task.title,
            "description": task.description,
            "status": task.status.value,
            "phase": task.phase.value,
            "iteration": task.iteration,
            "lightweight": task.lightweight,
            "history": task.history,
            "scores": task.scores,
            "score_history": task.score_history,
            "auto_mode": {
                "auto_brainstorm": task.auto_mode.auto_brainstorm,
                "auto_iteration": task.auto_mode.auto_iteration,
                "auto_lightweight": task.auto_mode.auto_lightweight,
                "auto_archive": task.auto_mode.auto_archive,
                "auto_worktree": task.auto_mode.auto_worktree,
            },
            "user_decision": task.user_decision,
        }
        # Always use new directory format: tasks/TASK-NNN/task.json
        task_dir = self._fs.task_dir(task.id)
        self._fs.ensure_dir(task_dir)
        self._fs.write_json(task_dir / "task.json", data)
        # Clean up old flat format to prevent stale data
        old_file = self._fs.kanban_dir / "tasks" / f"{task.id}.json"
        if old_file.is_file():
            old_file.unlink()
