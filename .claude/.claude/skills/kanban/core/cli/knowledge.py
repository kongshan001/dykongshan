from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.domain.knowledge import KnowledgeManager


def dispatch(args: list[str]) -> dict:
    sub = args[0] if args else "search"
    if sub == "search":
        return _handle_search(args[1:])
    return {"subcommand": sub, "results": []}


def _handle_search(args: list[str]) -> dict:
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    mgr = KnowledgeManager(fs)

    tag = None
    task = None
    keyword = ""
    i = 0
    while i < len(args):
        if args[i] == "--tag" and i + 1 < len(args):
            tag = args[i + 1]
            i += 2
        elif args[i] == "--task" and i + 1 < len(args):
            task = args[i + 1]
            i += 2
        else:
            keyword = args[i]
            i += 1

    if tag:
        results = mgr.search_by_tag(tag)
        return {"tag": tag, "results": results, "count": len(results)}
    if task:
        results = mgr.search_by_task(task)
        return {"task": task, "results": results, "count": len(results)}
    return cmd_search(keyword)


def cmd_search(keyword: str) -> dict:
    if not keyword:
        return {"keyword": "", "results": [], "count": 0}
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    mgr = KnowledgeManager(fs)
    results = mgr.search(keyword)
    return {"keyword": keyword, "results": results, "count": len(results)}
