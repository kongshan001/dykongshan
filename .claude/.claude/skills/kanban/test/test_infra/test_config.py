from __future__ import annotations
from core.infra.filesystem import Filesystem
from core.infra.config import Config


class TestConfig:
    def test_read_output_dir(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert cfg.output_dir == "src"

    def test_read_pass_threshold(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert cfg.pass_threshold == 9.0

    def test_read_max_iterations(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert cfg.max_iterations == 6

    def test_read_workflow_phases(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert "plan" in cfg.phases
        assert "archive" in cfg.phases
        assert len(cfg.phases) == 9

    def test_missing_config_returns_defaults(self, tmp_kanban):
        (tmp_kanban / ".kanban" / "config.json").unlink()
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert cfg.output_dir == "src"
        assert cfg.pass_threshold == 9.0

    def test_raw_property(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert isinstance(cfg.raw, dict)
        assert "output_dir" in cfg.raw

    def test_workflow_property(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        cfg = Config(fs)
        assert isinstance(cfg.workflow, dict)
        assert "phases" in cfg.workflow
