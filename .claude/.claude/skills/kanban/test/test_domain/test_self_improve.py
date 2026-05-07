from __future__ import annotations
from core.domain.self_improve import IterationDecider, IterationAction


class TestIterationDecider:
    def test_hot_iteration_when_above_min(self):
        result = IterationDecider.decide(avg_score=7.5, iteration=2, max_iter=6)
        assert result == IterationAction.HOT

    def test_full_iteration_when_low_score(self):
        result = IterationDecider.decide(avg_score=5.0, iteration=2, max_iter=6)
        assert result == IterationAction.FULL

    def test_user_decision_when_passing(self):
        result = IterationDecider.decide(avg_score=9.5, iteration=2, max_iter=6)
        assert result == IterationAction.PASS

    def test_user_decision_when_max_iterations(self):
        result = IterationDecider.decide(avg_score=6.0, iteration=6, max_iter=6)
        assert result == IterationAction.MAX_ITER
