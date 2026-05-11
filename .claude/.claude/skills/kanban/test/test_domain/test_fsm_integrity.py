"""FSM integrity tests — verify the full flow cannot be bypassed or skipped."""
from __future__ import annotations
import json
import pytest
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager
from core.domain.workflow import WorkflowEngine, TransitionError
from core.domain.guard import Guard
from core.types import Task, Phase, TaskStatus


def _make_task(phase, history=None):
    return Task(
        id="TASK-001", title="Test", description="test",
        status=TaskStatus.IN_PROGRESS, phase=phase,
        history=history or [],
    )


class TestFSMTransitionEnforcement:
    """transition() must reject multi-phase jumps."""

    def test_one_step_forward_allowed(self):
        we = WorkflowEngine(None, None)
        task = _make_task(Phase.PLAN)
        new_phase = we.transition(task, Phase.PLAN_REVIEW)
        assert new_phase == Phase.PLAN_REVIEW

    def test_two_step_jump_rejected(self):
        we = WorkflowEngine(None, None)
        task = _make_task(Phase.PLAN)
        with pytest.raises(TransitionError, match="Cannot skip"):
            we.transition(task, Phase.QA_SPEC)

    def test_backward_jump_rejected(self):
        we = WorkflowEngine(None, None)
        task = _make_task(Phase.EXECUTE)
        with pytest.raises(TransitionError, match="Cannot transition backward"):
            we.transition(task, Phase.PLAN)

    def test_full_forward_chain_allowed(self):
        """Complete 9-phase chain: each step must be individually valid."""
        we = WorkflowEngine(None, None)
        task = _make_task(Phase.PLAN)
        phases = [
            Phase.PLAN_REVIEW, Phase.QA_SPEC, Phase.SPEC_REVIEW,
            Phase.EXECUTE, Phase.EVALUATE, Phase.RETROSPECTIVE,
            Phase.USER_DECISION, Phase.ARCHIVE,
        ]
        for p in phases:
            new_p = we.transition(task, p)
            assert new_p == p
            task.phase = new_p


class TestFSMPhaseCompleteness:
    """Phase completeness guard must detect skipped phases."""

    def test_complete_history_passes(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.EXECUTE, [
            {"phase": "plan", "status": "completed"},
            {"phase": "plan_review", "status": "completed"},
            {"phase": "qa_spec", "status": "completed"},
            {"phase": "spec_review", "status": "completed"},
        ])
        assert guard.check_phase_completeness(task).passed

    def test_skipped_plan_review_detected(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.EXECUTE, [
            {"phase": "plan", "status": "completed"},
        ])
        result = guard.check_phase_completeness(task)
        assert not result.passed
        assert "plan_review" in str(result.failures)

    def test_no_history_at_plan_passes(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.PLAN, [])
        assert guard.check_phase_completeness(task).passed

    def test_skip_to_archive_detected(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.ARCHIVE, [
            {"phase": "plan", "status": "completed"},
        ])
        result = guard.check_phase_completeness(task)
        assert not result.passed
        assert len(result.failures[0].split(",")) >= 7  # 7 missed phases


class TestFSMCompletePhase:
    """complete_phase records history with status=completed."""

    def test_complete_phase_records_history(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        # Write minimal config for pass_threshold
        we = WorkflowEngine(fs, cfg)
        task = _make_task(Phase.PLAN, [])
        updated = we.complete_phase(task)
        assert len(updated.history) == 1
        assert updated.history[0]["status"] == "completed"
        assert updated.history[0]["phase"] == "plan"
        assert updated.phase == Phase.PLAN_REVIEW  # advanced

    def test_full_cycle_history_integrity(self, tmp_kanban):
        """Simulate complete plan→archive cycle and verify history."""
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.PLAN, [])

        all_phases = [
            Phase.PLAN_REVIEW, Phase.QA_SPEC, Phase.SPEC_REVIEW,
            Phase.EXECUTE, Phase.EVALUATE, Phase.RETROSPECTIVE,
            Phase.USER_DECISION, Phase.ARCHIVE,
        ]

        for _ in all_phases:
            task = we.complete_phase(task)

        # After full cycle, history should have all 9 phases
        completed = {h["phase"] for h in task.history if h["status"] == "completed"}
        expected = {"plan", "plan_review", "qa_spec", "spec_review",
                     "execute", "evaluate", "retrospective", "user_decision"}
        assert completed == expected
        assert task.phase == Phase.ARCHIVE


class TestFSMGuardIntegration:
    """Guard artifact checks integrated with FSM phases."""

    def test_plan_artifacts_required(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.PLAN)
        result = guard.check_artifacts(task, Phase.PLAN)
        assert not result.passed
        assert any("requirements.md" in f for f in result.failures)

    def test_plan_artifacts_pass_with_files(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        task_dir = fs.task_dir("TASK-001")
        fs.ensure_dir(task_dir)
        (task_dir / "design.md").write_text("# D")
        (task_dir / "requirements.md").write_text("# R")
        (task_dir / "task_breakdown.json").write_text(json.dumps({"subtasks": []}))

        guard = Guard(fs, cfg)
        task = _make_task(Phase.PLAN)
        assert guard.check_artifacts(task, Phase.PLAN).passed

    def test_evaluate_phase_requires_4_roles(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        guard = Guard(fs, cfg)
        task = _make_task(Phase.EVALUATE)
        result = guard.check_artifacts(task, Phase.EVALUATE)
        assert not result.passed
        assert len(result.failures) >= 4  # all 4 roles missing

    def test_evaluate_passes_with_reports(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        report_dir = fs.report_dir("TASK-001", 1)
        fs.ensure_dir(report_dir)
        for role in ["code_reviewer", "qa", "pm", "designer"]:
            (report_dir / f"{role}_report.json").write_text(json.dumps({
                "role": role, "task_id": "TASK-001", "iteration": 1,
                "total": 8.0, "summary": "ok",
            }))
        # acceptance.md is required at evaluate phase (Guard enforcement)
        task_dir = fs.task_dir("TASK-001")
        fs.ensure_dir(task_dir)
        (task_dir / "acceptance.md").write_text("# Acceptance\n\nOK")
        guard = Guard(fs, cfg)
        task = _make_task(Phase.EVALUATE)
        result = guard.check_artifacts(task, Phase.EVALUATE)
        assert result.passed
