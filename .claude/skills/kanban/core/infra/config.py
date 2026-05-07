from __future__ import annotations
from pathlib import Path

from core.infra.filesystem import Filesystem
from core.infra.consts import Consts


class Config:
    def __init__(self, fs: Filesystem):
        self._fs = fs
        self._config = self._load_json(fs.config_file(), {"output_dir": "src"})
        self._workflow = self._load_json(fs.workflow_file(), {})

    @property
    def output_dir(self) -> str:
        return self._config.get("output_dir", Consts.OUTPUT_DIR_DEFAULT)

    @property
    def pass_threshold(self) -> float:
        return self._workflow.get("pass_threshold", Consts.PASS_THRESHOLD)

    @property
    def max_iterations(self) -> int:
        return self._workflow.get("max_iterations", Consts.MAX_ITERATIONS)

    @property
    def phases(self) -> list[str]:
        return self._workflow.get(
            "phases",
            ["plan", "execute", "evaluate", "user_decision", "archive"],
        )

    @property
    def raw(self) -> dict:
        return dict(self._config)

    @property
    def workflow(self) -> dict:
        return dict(self._workflow)

    def _load_json(self, path: Path, default: dict) -> dict:
        if self._fs.file_exists(path):
            return self._fs.read_json(path)
        return default
