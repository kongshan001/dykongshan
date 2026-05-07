from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional


class Phase(str, Enum):
    PLAN = "plan"
    EXECUTE = "execute"
    EVALUATE = "evaluate"
    USER_DECISION = "user_decision"
    ARCHIVE = "archive"


class TaskStatus(str, Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    ERROR = "error"
    ARCHIVED = "archived"


class ScoreDimension(str, Enum):
    CODE_QUALITY = "code_quality"
    TEST_COMPLETENESS = "test_completeness"
    REQUIREMENT_COVERAGE = "requirement_coverage"
    DESIGN_REVIEW = "design_review"


class MatchLevel(Enum):
    EXACT = 1.0
    SYNONYM = 0.8
    FUZZY = 0.6

    def __new__(cls, weight: float):
        obj = object.__new__(cls)
        obj._value_ = weight
        obj.weight = weight
        return obj


@dataclass
class ScoreResult:
    dimension: ScoreDimension
    score: float
    comment: str = ""


@dataclass
class Task:
    id: str
    title: str
    description: str
    status: TaskStatus = TaskStatus.PENDING
    phase: Phase = Phase.PLAN
    iteration: int = 1
    worktree_path: Optional[str] = None
    history: list[dict] = field(default_factory=list)


@dataclass
class Report:
    role: str
    task_id: str
    iteration: int
    scores: list[ScoreResult]
    summary: str


@dataclass
class NLPResult:
    success: bool
    command: str
    task_id: Optional[str] = None
    action: Optional[str] = None
    args: dict = field(default_factory=dict)
