from __future__ import annotations
from enum import IntEnum


class _Consts:
    PASS_THRESHOLD: float = 9.0
    HOT_ITERATION_MIN_SCORE: float = 7.0
    MAX_ITERATIONS: int = 6
    TASK_ID_PREFIX: str = "TASK-"
    KNOWLEDGE_LOG: str = "knowledge-log.md"
    OUTPUT_DIR_DEFAULT: str = "src"


Consts = _Consts()


class ExitCode(IntEnum):
    SUCCESS = 0
    GUARD_FAILED = 1
    MISSING_ARTIFACT = 2
    TASK_NOT_FOUND = 3
