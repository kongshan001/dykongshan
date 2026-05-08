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

    def test_evolve_writes_candidate_file(self, tmp_kanban):
        from pathlib import Path
        sm = SkillManager()
        evolve_dir = tmp_kanban / ".kanban" / "skills" / "evolved"
        evolve_dir.mkdir(parents=True, exist_ok=True)
        result = sm.evolve("testing-skill", "add retry logic", evolve_dir=evolve_dir)
        assert result["skill_name"] == "testing-skill"
        assert result["status"] == "candidate_saved"
        candidate_files = list(evolve_dir.glob("*.json"))
        assert len(candidate_files) >= 1
