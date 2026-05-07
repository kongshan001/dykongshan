from __future__ import annotations
import json
from dataclasses import asdict

from core.types import (
    Phase, TaskStatus, ScoreDimension,
    ScoreResult, Task, Report, NLPResult, MatchLevel
)


class TestPhase:
    def test_all_phases_defined(self):
        assert Phase.PLAN.value == "plan"
        assert Phase.EXECUTE.value == "execute"
        assert Phase.EVALUATE.value == "evaluate"
        assert Phase.USER_DECISION.value == "user_decision"
        assert Phase.ARCHIVE.value == "archive"

    def test_phase_from_string(self):
        assert Phase("plan") == Phase.PLAN
        assert Phase("execute") == Phase.EXECUTE


class TestTaskStatus:
    def test_all_statuses_defined(self):
        assert TaskStatus.PENDING.value == "pending"
        assert TaskStatus.IN_PROGRESS.value == "in_progress"
        assert TaskStatus.COMPLETED.value == "completed"
        assert TaskStatus.ERROR.value == "error"
        assert TaskStatus.ARCHIVED.value == "archived"


class TestTask:
    def test_default_values(self):
        task = Task(id="TASK-001", title="Test", description="Desc")
        assert task.status == TaskStatus.PENDING
        assert task.phase == Phase.PLAN
        assert task.iteration == 1
        assert task.worktree_path is None
        assert task.history == []

    def test_to_json_serializable(self):
        task = Task(id="TASK-001", title="Test", description="Desc")
        d = asdict(task)
        d["status"] = task.status.value
        d["phase"] = task.phase.value
        d["worktree_path"] = None
        result = json.dumps(d)
        assert "TASK-001" in result

    def test_to_json_with_worktree_path(self):
        task = Task(id="TASK-002", title="Test", description="Desc",
                    worktree_path="/tmp/test")
        d = asdict(task)
        d["status"] = task.status.value
        d["phase"] = task.phase.value
        result = json.dumps(d)
        assert "/tmp/test" in result


class TestScoreResult:
    def test_create_score(self):
        s = ScoreResult(
            dimension=ScoreDimension.CODE_QUALITY,
            score=8.5,
            comment="Good"
        )
        assert s.score == 8.5
        assert s.dimension == ScoreDimension.CODE_QUALITY


class TestNLPResult:
    def test_success_result(self):
        r = NLPResult(success=True, command="create", task_id=None)
        assert r.success is True
        assert r.command == "create"

    def test_failed_result(self):
        r = NLPResult(success=False, command="unknown")
        assert r.success is False


class TestReport:
    def test_report_creation(self):
        r = Report(
            role="qa",
            task_id="TASK-001",
            iteration=1,
            scores=[ScoreResult(ScoreDimension.TEST_COMPLETENESS, 7.0, "ok")],
            summary="All good"
        )
        assert r.role == "qa"
        assert len(r.scores) == 1


class TestMatchLevel:
    def test_match_level_weights(self):
        assert MatchLevel.EXACT.weight == 1.0
        assert MatchLevel.SYNONYM.weight == 0.8
        assert MatchLevel.FUZZY.weight == 0.6
