from __future__ import annotations
import importlib
import json
import sys

_CMD_MAP: dict[str, tuple[str, str]] = {
    "check-env":  ("core.cli.main", "_cmd_check_env"),
    "init":       ("core.cli.task", "cmd_init"),
    "scan":       ("core.cli.task", "cmd_scan"),
    "create":     ("core.cli.task", "cmd_create"),
    "status":     ("core.cli.task", "cmd_status"),
    "show":       ("core.cli.task", "cmd_show"),
    "clean":      ("core.cli.task", "cmd_clean"),
    "run":        ("core.cli.run", "cmd_run"),
    "decide":     ("core.cli.run", "cmd_decide"),
    "guard":      ("core.cli.run", "cmd_guard"),
    "workflow":   ("core.cli.run", "cmd_workflow"),
    "worktree":   ("core.cli.run", "cmd_worktree"),
    "nlp":        ("core.cli.run", "cmd_nlp"),
    "recover":    ("core.cli.run", "cmd_recover"),
    "rollback":   ("core.cli.run", "cmd_rollback"),
    "resume":     ("core.cli.run", "cmd_resume"),
    "subtask":    ("core.cli.subtask", "dispatch"),
    "score":      ("core.cli.query", "cmd_score"),
    "summary":    ("core.cli.query", "cmd_summary"),
    "progress":   ("core.cli.query", "cmd_progress"),
    "time":       ("core.cli.query", "cmd_time"),
    "tokens":     ("core.cli.query", "cmd_tokens"),
    "dashboard":  ("core.cli.query", "cmd_dashboard"),
    "knowledge":  ("core.cli.knowledge", "dispatch"),
    "inbox":      ("core.cli.inbox", "dispatch"),
    "feedback":   ("core.cli.inbox", "cmd_feedback"),
    "version":    ("core.cli.version", "dispatch"),
    "plan":           ("core.cli.plan", "dispatch"),
    "evolve-skills":  ("core.cli.skills", "dispatch"),
    "framework":      ("core.cli.framework", "dispatch"),
    "evaluator":      ("core.cli.evaluator", "dispatch"),
    "help":           ("core.cli.main", "_cmd_help"),
}


def main() -> None:
    if len(sys.argv) < 2:
        _output({"success": False, "error": "missing command"})
        sys.exit(1)

    cmd = sys.argv[1]
    entry = _CMD_MAP.get(cmd)
    if entry is None:
        _output({
            "success": False,
            "error": f"unknown command: {cmd}",
            "code": "UNKNOWN_COMMAND",
        })
        sys.exit(1)

    mod_name, fn_name = entry
    mod = importlib.import_module(mod_name)
    fn = getattr(mod, fn_name)
    try:
        result = fn(sys.argv[2:])
        _output({"success": True, "data": result})
    except Exception as e:
        _output({
            "success": False,
            "error": str(e),
            "code": type(e).__name__,
        })


def _output(data: dict) -> None:
    print(json.dumps(data, ensure_ascii=False))


def _cmd_check_env(args: list[str]) -> dict:
    return {
        "python_version": sys.version,
        "executable": sys.executable,
        "ok": True,
    }


def _cmd_help(args: list[str]) -> dict:
    return {"commands": sorted(_CMD_MAP.keys())}


if __name__ == "__main__":
    main()
