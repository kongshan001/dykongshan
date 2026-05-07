from __future__ import annotations


class SkillManager:
    def list_skills(self) -> list[str]:
        return [
            "core", "brainstorming", "writing-plans",
            "executing-plans", "test-driven-development",
        ]

    def evolve(self, skill_name: str, direction: str) -> dict:
        return {
            "skill_name": skill_name,
            "direction": direction,
            "status": "recorded",
        }
