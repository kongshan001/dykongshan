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
    import os
    from pathlib import Path
    from core.infra.filesystem import Filesystem

    root = Filesystem.find_project_root()
    kanban_dir = root / ".kanban"
    anomalies = []

    # Anomaly 1: .kanban/ inside .claude/skills/ (should be at project root)
    skills_kanban = root / ".claude" / "skills" / "kanban" / ".kanban"
    if skills_kanban.exists():
        anomalies.append({
            "type": "mislocated_kanban",
            "path": str(skills_kanban),
            "message": ".kanban/ found inside .claude/skills/kanban/ — should be at project root",
            "fix": f"rm -rf {skills_kanban}",
        })

    # Anomaly 2: .kanban/ at both project root and inside framework source
    cwd = Path.cwd()
    framework_root = None
    for p in [cwd] + list(cwd.parents):
        if (p / "pyproject.toml").exists() and (p / "core").is_dir():
            framework_root = p
            break
    if framework_root and framework_root != root:
        fw_kanban = framework_root / ".kanban"
        if fw_kanban.exists():
            anomalies.append({
                "type": "framework_mislocation",
                "path": str(fw_kanban),
                "message": ".kanban/ exists inside framework source — tasks should be in project .kanban/",
            })

    config_ok = (kanban_dir / "config.json").is_file()
    workflow_ok = (kanban_dir / "workflow.json").is_file()

    gitignore = root / ".gitignore"
    if gitignore.exists():
        import fnmatch
        output_dir = "src"
        cfg_file = kanban_dir / "config.json"
        if cfg_file.is_file():
            try:
                output_dir = json.loads(cfg_file.read_text(encoding="utf-8")).get("output_dir", "src")
            except: pass
        for line in gitignore.read_text(encoding="utf-8").split("\n"):
            pat = line.strip()
            if pat and not pat.startswith("#"):
                if fnmatch.fnmatch(output_dir, pat) or fnmatch.fnmatch(f"{output_dir}/", pat):
                    anomalies.append({
                        "type": "gitignore_conflict", "pattern": pat,
                        "message": f"output_dir '{output_dir}' excluded by .gitignore",
                        "fix": f"Remove '{pat}' from .gitignore or use git add -f",
                    })
                    break

    healthy = config_ok and workflow_ok and len(anomalies) == 0
    return {
        "project_root": str(root),
        "kanban_dir": str(kanban_dir),
        "config_ok": config_ok,
        "workflow_ok": workflow_ok,
        "ok": healthy,
        "healthy": healthy,
        "anomalies": anomalies,
        "python_version": sys.version,
        "executable": sys.executable,
    }


def _cmd_help(args: list[str]) -> dict:
    return {"commands": sorted(_CMD_MAP.keys())}


if __name__ == "__main__":
    main()
