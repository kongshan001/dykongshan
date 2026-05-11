from __future__ import annotations
from core.infra.consts import Consts, ExitCode


class TestConsts:
    def test_default_values(self):
        assert Consts.PASS_THRESHOLD == 8.0
        assert Consts.HOT_ITERATION_MIN_SCORE == 7.0
        assert Consts.MAX_ITERATIONS == 6
        assert Consts.TASK_ID_PREFIX == "TASK-"
        assert Consts.KNOWLEDGE_LOG == "knowledge-log.md"


class TestExitCode:
    def test_exit_codes(self):
        assert ExitCode.SUCCESS.value == 0
        assert ExitCode.GUARD_FAILED.value == 1
        assert ExitCode.MISSING_ARTIFACT.value == 2
        assert ExitCode.TASK_NOT_FOUND.value == 3
