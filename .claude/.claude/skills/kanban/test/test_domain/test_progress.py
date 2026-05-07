from __future__ import annotations
from core.infra.filesystem import Filesystem
from core.domain.progress import ProgressTracker


class TestProgressTracker:
    def test_subtask_start(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        pt = ProgressTracker(fs)
        pt.subtask_start("TASK-001", "st-1")
        progress = pt.progress("TASK-001")
        assert progress["total"] == 1
        assert progress["completed"] == 0

    def test_subtask_done(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        pt = ProgressTracker(fs)
        pt.subtask_start("TASK-001", "st-1")
        pt.subtask_done("TASK-001", "st-1")
        progress = pt.progress("TASK-001")
        assert progress["total"] == 1
        assert progress["completed"] == 1

    def test_subtask_start_preserves_multiple(self, tmp_kanban):
        """回归测试: 连续启动多个 subtask 后所有记录均保留，不丢失之前的数据"""
        fs = Filesystem(root=tmp_kanban)
        pt = ProgressTracker(fs)
        pt.subtask_start("TASK-001", "st-1")
        pt.subtask_start("TASK-001", "st-2")
        pt.subtask_start("TASK-001", "st-3")
        progress = pt.progress("TASK-001")
        assert progress["total"] == 3
        assert progress["completed"] == 0

    def test_progress_no_checkpoint(self, tmp_kanban):
        fs = Filesystem(root=tmp_kanban)
        pt = ProgressTracker(fs)
        progress = pt.progress("TASK-001")
        assert progress["total"] == 0
        assert progress["completed"] == 0
