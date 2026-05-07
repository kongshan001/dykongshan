def dispatch(args: list[str]) -> dict:
    return {"subcommand": args[0] if args else "list", "args": args[1:]}
