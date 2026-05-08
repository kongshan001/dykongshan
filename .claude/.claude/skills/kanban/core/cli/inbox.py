from __future__ import annotations
import json
from pathlib import Path
from core.infra.filesystem import Filesystem


def dispatch(args: list[str]) -> dict:
    sub = args[0] if args else "list"
    root = Path.cwd()
    fs = Filesystem(root=root)

    if sub == "list":
        return _list_inbox(fs)
    if sub == "process":
        return {"subcommand": sub, "processed": []}
    return {"subcommand": sub}


def cmd_feedback(args: list[str]) -> dict:
    task_id = args[0] if args else None
    if not task_id:
        return {"error": "task_id required"}
    text = " ".join(args[1:]) if len(args) > 1 else ""

    root = Path.cwd()
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
