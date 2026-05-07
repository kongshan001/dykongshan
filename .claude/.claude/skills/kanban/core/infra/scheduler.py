from __future__ import annotations
from core.types import Phase


class Scheduler:
    EVAL_ROLES = [
        {"name": "code_reviewer", "agent_type": "code-reviewer"},
        {"name": "qa", "agent_type": "qa"},
        {"name": "pm", "agent_type": "pm"},
        {"name": "designer", "agent_type": "designer"},
    ]

    PHASE_ORDER = [
        Phase.PLAN,
        Phase.EXECUTE,
        Phase.EVALUATE,
        Phase.USER_DECISION,
        Phase.ARCHIVE,
    ]

    @classmethod
    def eval_roles(cls) -> list[dict]:
        return list(cls.EVAL_ROLES)

    @classmethod
    def dispatch_order(cls) -> list[Phase]:
        return list(cls.PHASE_ORDER)

    @classmethod
    def next_phase(cls, current: Phase) -> Phase | None:
        try:
            idx = cls.PHASE_ORDER.index(current)
            return cls.PHASE_ORDER[idx + 1]
        except (ValueError, IndexError):
            return None
