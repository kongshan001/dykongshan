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
        assert Scheduler.next_phase(Phase.PLAN) == Phase.EXECUTE
        assert Scheduler.next_phase(Phase.EXECUTE) == Phase.EVALUATE
        assert Scheduler.next_phase(Phase.ARCHIVE) is None
