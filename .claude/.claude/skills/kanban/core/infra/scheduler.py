from __future__ import annotations
from core.types import Phase


class Scheduler:
    EVAL_ROLES = [
        {"name": "code_reviewer", "agent_type": "kanban-code-reviewer"},
        {"name": "qa", "agent_type": "kanban-qa"},
        {"name": "pm", "agent_type": "kanban-pm"},
        {"name": "designer", "agent_type": "kanban-designer"},
    ]

    @staticmethod
    def scan_agents(fs) -> list[dict]:
        """Scan .claude/agents/ directory for agent definitions."""
        agents_dir = fs.kanban_dir.parent / ".claude" / "agents"
        if not agents_dir.exists() or not agents_dir.is_dir():
            return []
        agents = []
        for f in sorted(agents_dir.glob("*.md")):
            name = f.stem
            agents.append({"name": name, "file": str(f)})
        return agents

    PHASE_ORDER = [
        Phase.PLAN,
        Phase.PLAN_REVIEW,
        Phase.QA_SPEC,
        Phase.SPEC_REVIEW,
        Phase.EXECUTE,
        Phase.EVALUATE,
        Phase.RETROSPECTIVE,
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

    @classmethod
    def previous_phase(cls, current: Phase) -> Phase | None:
        try:
            idx = cls.PHASE_ORDER.index(current)
            if idx > 0:
                return cls.PHASE_ORDER[idx - 1]
        except ValueError:
            pass
        return None
