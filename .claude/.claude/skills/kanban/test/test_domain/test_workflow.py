from __future__ import annotations
import pytest

import json
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.types import Task, Phase, TaskStatus
from core.domain.guard import Guard
from core.domain.workflow import WorkflowEngine, TransitionError


class TestWorkflowEngine:
    def test_transition_plan_to_plan_review(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        new_phase = we.transition(sample_task, Phase.PLAN_REVIEW)
        assert new_phase == Phase.PLAN_REVIEW

    def test_transition_skip_phase_raises(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        with pytest.raises(TransitionError):
            we.transition(sample_task, Phase.EVALUATE)

    def test_transition_backwards_raises(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        sample_task.phase = Phase.EXECUTE
        with pytest.raises(TransitionError):
            we.transition(sample_task, Phase.PLAN)

    def test_complete_phase_records_history(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        task = we.complete_phase(sample_task)
        assert len(task.history) == 1
        assert task.history[0]["phase"] == "plan"
        assert task.phase == Phase.PLAN_REVIEW

    def test_is_terminal(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        assert we.is_terminal(Phase.ARCHIVE) is True
        assert we.is_terminal(Phase.PLAN) is False

    def test_next_phase(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        assert we.next_phase(Phase.PLAN) == Phase.PLAN_REVIEW
        assert we.next_phase(Phase.ARCHIVE) is None

    def test_self_improve_check_over_max_iterations(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        sample_task.iteration = 7
        result = we.self_improve_check(sample_task, avg_score=5.0)
        assert result["action"] == "max_iterations"
        assert "max" in result["reason"].lower()

    def test_self_improve_check_passing_score(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        sample_task.iteration = 2
        result = we.self_improve_check(sample_task, avg_score=9.5)
        assert result["action"] == "user_decision"

    def test_self_improve_check_hot_iteration(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        sample_task.iteration = 2
        result = we.self_improve_check(sample_task, avg_score=7.5)
        assert result["action"] == "hot_iteration"

    def test_self_improve_check_full_iteration(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        sample_task.iteration = 2
        result = we.self_improve_check(sample_task, avg_score=5.0)
        assert result["action"] == "full_iteration"

    # ── Guard-in-transition tests (ST-002) ──────────────────────

    def test_transition_with_guard_passes_when_artifacts_exist(self, tmp_kanban, sample_task):
        """Transition with guard succeeds when required artifacts exist."""
        task_dir = tmp_kanban / ".kanban" / "tasks" / sample_task.id
        task_dir.mkdir(exist_ok=True)
        (task_dir / "design.md").write_text("# Design\n\ndesign content")
        (task_dir / "requirements.md").write_text("# Requirements\n\nreq content")
        (task_dir / "task_breakdown.json").write_text(
            json.dumps({"subtasks": [{"id": "ST-001", "title": "test"}]}))

        sample_task.history = [{"phase": "plan", "status": "completed"}]

        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        we = WorkflowEngine(fs, cfg, guard=guard)
        new_phase = we.transition(sample_task, Phase.PLAN_REVIEW)
        assert new_phase == Phase.PLAN_REVIEW

    def test_transition_with_guard_fails_when_artifacts_missing(self, tmp_kanban, sample_task):
        """Transition with guard raises TransitionError when required artifacts are missing."""
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        we = WorkflowEngine(fs, cfg, guard=guard)
        with pytest.raises(TransitionError, match="Guard blocked"):
            we.transition(sample_task, Phase.PLAN_REVIEW)

    def test_transition_with_guard_fails_when_phases_skipped(self, tmp_kanban, sample_task):
        """Transition with guard raises TransitionError when previous phases were not completed.

        Use EXECUTE -> EVALUATE transition: EXECUTE has prior phases (plan,
        plan_review, qa_spec, spec_review) that must appear in history.
        """
        task_dir = tmp_kanban / ".kanban" / "tasks" / sample_task.id
        task_dir.mkdir(exist_ok=True)
        (task_dir / "execution_summary.md").write_text("# Summary\n\ncontent")
        (task_dir / "execution_pitfalls.md").write_text("# Pitfalls\n\ncontent")
        (task_dir / "execution_decisions.md").write_text("# Decisions\n\ncontent")

        sample_task.phase = Phase.EXECUTE
        # history is empty — no prior phases marked as completed
        sample_task.history = []

        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        we = WorkflowEngine(fs, cfg, guard=guard)
        with pytest.raises(TransitionError, match="Phase completeness check failed"):
            we.transition(sample_task, Phase.EVALUATE)

    def test_transition_without_guard_still_works(self, tmp_kanban, sample_task):
        """Transition without guard (None) skips guard checks and works as before."""
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)  # no guard
        new_phase = we.transition(sample_task, Phase.PLAN_REVIEW)
        assert new_phase == Phase.PLAN_REVIEW
