from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.domain.skills import SkillManager


def dispatch(args: list[str]) -> dict:
    root = Path.cwd()
    fs = Filesystem(root=root)
    sm = SkillManager()

    sub = args[0] if args else "list"
    if sub == "list":
        return {"skills": sm.list_skills()}
    if sub == "evolve":
        if len(args) < 3:
            return {"error": "usage: evolve-skills evolve <name> <direction>"}
        skill_name = args[1]
        direction = " ".join(args[2:])
        evolve_dir = fs.kanban_dir / "skills" / "evolved"
        result = sm.evolve(skill_name, direction, evolve_dir=evolve_dir)
        return result
    return {"subcommand": sub}
