from __future__ import annotations
from core.infra.scheduler import Scheduler
from core.types import Phase


class TestScheduler:
    def test_eval_roles_count(self):
        roles = Scheduler.eval_roles()
        assert len(roles) == 4
        role_names = [r["name"] for r in roles]
        assert "code_reviewer" in role_names
        assert "qa" in role_names
        assert "pm" in role_names
        assert "designer" in role_names

    def test_eval_roles_have_agent_types(self):
        for role in Scheduler.eval_roles():
            assert "name" in role
            assert "agent_type" in role

    def test_dispatch_order_follows_phases(self):
        order = Scheduler.dispatch_order()
        assert order[0] == Phase.PLAN
        assert order[-1] == Phase.ARCHIVE

    def test_next_phase(self):
        assert Scheduler.next_phase(Phase.PLAN) == Phase.PLAN_REVIEW
        assert Scheduler.next_phase(Phase.EXECUTE) == Phase.EVALUATE
        assert Scheduler.next_phase(Phase.ARCHIVE) is None


class TestPlanReviewDimensions:
    def test_dimensions_count(self):
        dims = Scheduler.plan_review_dimensions()
        assert len(dims) == 6

    def test_dimension_names(self):
        dims = Scheduler.plan_review_dimensions()
        names = [d["name"] for d in dims]
        expected = [
            "requirement_clarity", "technical_feasibility",
            "task_decomposition", "acceptance_criteria",
            "research_completeness", "parallel_safety",
        ]
        assert names == expected

    def test_each_dimension_has_name_and_agent_type(self):
        for d in Scheduler.plan_review_dimensions():
            assert "name" in d
            assert "agent_type" in d

    def test_retrospective_roles(self):
        roles = Scheduler.retrospective_roles()
        names = [r["name"] for r in roles]
        assert "retrospective_writer" in names
        assert "acceptance_writer" in names
        assert "knowledge_extractor" in names

    def test_retrospective_roles_have_agent_type(self):
        for r in Scheduler.retrospective_roles():
            assert "agent_type" in r
