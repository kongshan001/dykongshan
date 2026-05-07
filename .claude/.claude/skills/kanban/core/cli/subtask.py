def dispatch(args: list[str]) -> dict:
    return {"subcommand": args[0] if args else "start", "task_id": args[1] if len(args) > 1 else None}
