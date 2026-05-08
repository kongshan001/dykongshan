from __future__ import annotations
import json
import time
from pathlib import Path


class SkillManager:
    def list_skills(self) -> list[str]:
        return [
            "core", "brainstorming", "writing-plans",
            "executing-plans", "test-driven-development",
        ]

    def evolve(self, skill_name: str, direction: str,
               evolve_dir: Path | None = None) -> dict:
        if evolve_dir is None:
            return {
                "skill_name": skill_name,
                "direction": direction,
                "status": "recorded",
            }
        evolve_dir = Path(evolve_dir)
        evolve_dir.mkdir(parents=True, exist_ok=True)
        candidate = {
            "skill_name": skill_name,
            "direction": direction,
            "status": "pending",
            "created_at": time.time(),
        }
        filename = f"candidate_{skill_name}_{int(time.time())}.json"
        candidate_file = evolve_dir / filename
        candidate_file.write_text(
            json.dumps(candidate, indent=2, ensure_ascii=False),
            encoding="utf-8",
        )
        return {
            "skill_name": skill_name,
            "direction": direction,
            "status": "candidate_saved",
            "file": str(candidate_file),
        }
