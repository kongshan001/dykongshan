from __future__ import annotations
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.evaluation import EvaluationManager


class TestEvaluationManager:
    def test_calculate_average_score(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        em = EvaluationManager(fs, cfg)
        reports = {
            "code_reviewer": {"total": 8.0},
            "qa": {"total": 7.0},
            "pm": {"total": 9.0},
            "designer": {"total": 8.0},
        }
        avg = em.calculate_average(reports)
        assert avg == 8.0

    def test_is_passing(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        em = EvaluationManager(fs, cfg)
        assert em.is_passing(9.5) is True
        assert em.is_passing(8.0) is False

    def test_should_run_parallel(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        em = EvaluationManager(fs, cfg)
        assert em.should_run_parallel() is True

    def test_round_score(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        em = EvaluationManager(fs, cfg)
        assert em.round_score(8.567) == 8.57
        assert em.round_score(8.564) == 8.56

    def test_calculate_average_empty(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        em = EvaluationManager(fs, cfg)
        assert em.calculate_average({}) == 0.0
