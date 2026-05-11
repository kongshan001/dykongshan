from __future__ import annotations
import sys


def dispatch(args: list[str]) -> dict:
    if args and args[0] == "record":
        return _record(args[1:])
    return _list()


def _list() -> dict:
    return {
        "version": "0.4.0",
        "python": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
        "platform": sys.platform,
    }


def _record(args: list[str]) -> dict:
    if not args:
        return {"error": "version required"}
    version = args[0]
    title = ""
    task_id = ""
    i = 1
    while i < len(args):
        if args[i] == "--title" and i + 1 < len(args):
            title = args[i + 1]
            i += 2
        elif args[i] == "--task" and i + 1 < len(args):
            task_id = args[i + 1]
            i += 2
        else:
            i += 1

    from core.infra.filesystem import Filesystem
    root = Filesystem.find_project_root()
    versions_dir = root / ".kanban" / "versions"
    if versions_dir.is_symlink():
        versions_dir = versions_dir.resolve()
    versions_dir.mkdir(parents=True, exist_ok=True)

    if not version.startswith("v"):
        version = f"v{version}"

    content_parts = [f"# {version}\n"]
    if title:
        content_parts.append(f"\n## {title}\n")
    if task_id:
        content_parts.append(f"\nTask: {task_id}\n")
    content_parts.append("\n")
    (versions_dir / f"{version}.md").write_text(
        "".join(content_parts), encoding="utf-8"
    )
    return {"version": version, "recorded": True}
