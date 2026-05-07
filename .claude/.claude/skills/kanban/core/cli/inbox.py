def dispatch(args: list[str]) -> dict:
    return {"subcommand": args[0] if args else "list"}


def cmd_feedback(args: list[str]) -> dict:
    return {"task_id": args[0] if args else None}
