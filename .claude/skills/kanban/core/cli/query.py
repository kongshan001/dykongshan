def cmd_score(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "scores": []}


def cmd_summary(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "summary": ""}


def cmd_progress(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "progress": {}}


def cmd_time(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "time": {}}


def cmd_tokens(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None, "tokens": {}}


def cmd_dashboard(args: list[str]) -> dict:
    return {"dashboard": {}}
