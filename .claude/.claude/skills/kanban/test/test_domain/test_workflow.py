from __future__ import annotations
import pytest

from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.types import Task, Phase, TaskStatus
from core.domain.workflow import WorkflowEngine, TransitionError


class TestWorkflowEngine:
    def test_transition_plan_to_execute(self, tmp_kanban, sample_task):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        we = WorkflowEngine(fs, cfg)
        new_phase = we.transition(sample_task, Phase.EXECUTE)
        assert new_phase == Phase.EXECUTE

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
        assert task.phase == Phase.EXECUTE

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
        assert we.next_phase(Phase.PLAN) == Phase.EXECUTE
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
