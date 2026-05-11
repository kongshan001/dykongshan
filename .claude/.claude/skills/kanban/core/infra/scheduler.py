from __future__ import annotations
from core.types import Phase


class Scheduler:
    EVAL_ROLES = [
        {"name": "code_reviewer", "agent_type": "kanban-code-reviewer"},
        {"name": "qa", "agent_type": "kanban-qa"},
        {"name": "pm", "agent_type": "kanban-pm"},
        {"name": "designer", "agent_type": "kanban-designer"},
    ]

    PLAN_REVIEW_DIMENSIONS = [
        {"name": "requirement_clarity", "agent_type": "kanban-plan-reviewer"},
        {"name": "technical_feasibility", "agent_type": "kanban-plan-reviewer"},
        {"name": "task_decomposition", "agent_type": "kanban-plan-reviewer"},
        {"name": "acceptance_criteria", "agent_type": "kanban-plan-reviewer"},
        {"name": "research_completeness", "agent_type": "kanban-plan-reviewer"},
        {"name": "parallel_safety", "agent_type": "kanban-plan-reviewer"},
    ]

    RETROSPECTIVE_ROLES = [
        {"name": "retrospective_writer", "agent_type": "kanban-knowledge-manager"},
        {"name": "acceptance_writer", "agent_type": "kanban-knowledge-manager"},
        {"name": "knowledge_extractor", "agent_type": "kanban-knowledge-manager"},
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
    def plan_review_dimensions(cls) -> list[dict]:
        return list(cls.PLAN_REVIEW_DIMENSIONS)

    @classmethod
    def retrospective_roles(cls) -> list[dict]:
        return list(cls.RETROSPECTIVE_ROLES)

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
