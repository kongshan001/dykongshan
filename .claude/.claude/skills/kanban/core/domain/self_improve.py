from __future__ import annotations
from enum import Enum
from core.infra.consts import Consts


class IterationAction(Enum):
    PASS = "user_decision"
    HOT = "hot_iteration"
    FULL = "full_iteration"
    MAX_ITER = "max_iterations"


class IterationDecider:
    @staticmethod
    def decide(
        avg_score: float,
        iteration: int,
        max_iter: int = Consts.MAX_ITERATIONS,
        pass_threshold: float = Consts.PASS_THRESHOLD,
        hot_min_score: float = Consts.HOT_ITERATION_MIN_SCORE,
    ) -> IterationAction:
        if iteration >= max_iter:
            return IterationAction.MAX_ITER
        if avg_score >= pass_threshold:
            return IterationAction.PASS
        if avg_score >= hot_min_score:
            return IterationAction.HOT
        return IterationAction.FULL
