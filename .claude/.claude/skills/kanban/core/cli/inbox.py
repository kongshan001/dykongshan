from __future__ import annotations
import json
from datetime import datetime
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.domain.task import TaskManager, TaskNotFoundError
from core.infra.config import Config


class InboxError(Exception):
    pass


def dispatch(args: list[str]) -> dict:
    sub = args[0] if args else "list"
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)

    if sub == "list":
        return _list_inbox(fs)
    if sub == "add":
        return _add_to_task_inbox(fs, args[1:])
    if sub == "archive":
        return _archive_task_inbox(fs, args[1:])
    if sub == "process":
        return {"subcommand": sub, "processed": []}
    return {"subcommand": sub}


def cmd_feedback(args: list[str]) -> dict:
    task_id = args[0] if args else None
    if not task_id:
        return {"error": "task_id required"}
    text = " ".join(args[1:]) if len(args) > 1 else ""

    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    inbox_file = fs.inbox_file()
    fs.ensure_dir(inbox_file.parent)

    entries = []
    if fs.file_exists(inbox_file):
        entries = fs.read_json(inbox_file)

    entries.append({
        "task_id": task_id,
        "text": text,
        "type": "feedback",
    })
    fs.write_json(inbox_file, entries)
    return {"task_id": task_id, "feedback": text, "saved": True}


def _list_inbox(fs: Filesystem) -> dict:
    inbox_file = fs.inbox_file()
    if not fs.file_exists(inbox_file):
        return {"inbox": [], "count": 0}
    entries = fs.read_json(inbox_file)
    return {"inbox": entries, "count": len(entries)}


def _add_to_task_inbox(fs: Filesystem, args: list[str]) -> dict:
    """Add a feedback item to a task's inbox.md file."""
    if not args:
        raise InboxError("task_id required")
    task_id = args[0]
    text = " ".join(args[1:]) if len(args) > 1 else ""

    if not text:
        raise InboxError("feedback text required")

    task_dir = fs.task_dir(task_id)
    inbox_path = task_dir / "inbox.md"

    # Ensure task directory exists
    fs.ensure_dir(task_dir)

    # Create or append to inbox.md
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    new_entry = f"- [ ] {text} <!-- {timestamp} -->\n"

    if fs.file_exists(inbox_path):
        content = inbox_path.read_text(encoding="utf-8")
        # Add entry after header section
        lines = content.split("\n")
        insert_pos = 0
        for i, line in enumerate(lines):
            if line.startswith("#"):
                insert_pos = i + 1
            elif line.strip() and not line.startswith("#"):
                # Found first non-header line, insert before it
                break
        lines.insert(insert_pos, "")
        lines.insert(insert_pos + 1, new_entry)
        inbox_path.write_text("\n".join(lines), encoding="utf-8")
    else:
        # Create new inbox.md with header
        inbox_path.write_text(
            f"# Task Inbox — {task_id}\n\n"
            f"用户反馈和待办事项。\n\n"
            f"{new_entry}",
            encoding="utf-8"
        )

    return {
        "task_id": task_id,
        "action": "added",
        "text": text,
        "inbox_file": str(inbox_path)
    }


def _archive_task_inbox(fs: Filesystem, args: list[str]) -> dict:
    """Archive completed items from task's inbox.md to inbox-archive.md."""
    if not args:
        raise InboxError("task_id required")
    task_id = args[0]

    task_dir = fs.task_dir(task_id)
    inbox_path = task_dir / "inbox.md"
    archive_path = task_dir / "inbox-archive.md"

    if not fs.file_exists(inbox_path):
        return {
            "task_id": task_id,
            "action": "archive",
            "archived_count": 0,
            "message": "inbox.md not found"
        }

    content = inbox_path.read_text(encoding="utf-8")
    lines = content.split("\n")

    # Separate completed (checked) and pending (unchecked) items
    archived = []
    remaining = []
    in_items = False

    for line in lines:
        if line.startswith("- [x]") or line.startswith("* [x]"):
            archived.append(line)
        elif line.startswith("- [ ]") or line.startswith("* [ ]"):
            remaining.append(line)
        else:
            remaining.append(line)

    if not archived:
        return {
            "task_id": task_id,
            "action": "archive",
            "archived_count": 0,
            "message": "no completed items to archive"
        }

    # Write archive
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    archive_header = f"\n## Archive — {timestamp}\n\n"
    archive_content = archive_header + "\n".join(archived)

    if fs.file_exists(archive_path):
        existing = archive_path.read_text(encoding="utf-8")
        archive_path.write_text(existing + archive_content, encoding="utf-8")
    else:
        archive_path.write_text(
            f"# Inbox Archive — {task_id}\n\n"
            f"已归档的用户反馈和待办事项。\n"
            f"{archive_content}",
            encoding="utf-8"
        )

    # Update inbox.md with only pending items
    inbox_path.write_text("\n".join(remaining), encoding="utf-8")

    return {
        "task_id": task_id,
        "action": "archived",
        "archived_count": len(archived),
        "pending_count": sum(1 for line in remaining if line.startswith("- [ ]") or line.startswith("* [ ]")),
        "archive_file": str(archive_path)
    }


def archive_on_task_completion(task_id: str) -> dict:
    """
    Auto-archive inbox items when task is completed/archived.
    Called by cmd_decide when action is approve_and_archive.
    """
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    return _archive_task_inbox(fs, [task_id])
