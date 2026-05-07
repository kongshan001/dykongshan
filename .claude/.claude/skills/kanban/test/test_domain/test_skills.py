from __future__ import annotations
from core.domain.skills import SkillManager


class TestSkillManager:
    def test_list_skills(self):
        sm = SkillManager()
        skills = sm.list_skills()
        assert isinstance(skills, list)
        assert "core" in skills

    def test_evolve_skill(self):
        sm = SkillManager()
        result = sm.evolve("test_skill", "improve error handling")
        assert result["skill_name"] == "test_skill"
        assert "error handling" in result["direction"]
        assert result["status"] == "recorded"
