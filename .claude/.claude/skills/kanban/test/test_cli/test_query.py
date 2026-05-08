from __future__ import annotations
import json
import pytest
from core.cli.query import cmd_score, cmd_summary, cmd_progress, cmd_time, cmd_tokens


def _setup_task(fs, task_id, **kw):
    data = {
        "id": task_id, "title": kw.pop("title", "Test"),
        "status": kw.pop("status", "in_progress"),
        "phase": kw.pop("phase", "execute"),
        "iteration": kw.pop("iteration", 1),
        "description": kw.pop("description", "desc"),
    }
    data.update(kw)
    (fs.kanban_dir / "tasks" / f"{task_id}.json").write_text(
        json.dumps(data, ensure_ascii=False)
    )


class TestQueryCommands:
    def test_score_with_reports(self, tmp_kanban, monkeypatch):
        monkeypatch.chdir(tmp_kanban)
        from core.infra.filesystem import Filesystem
        fs = Filesystem(root=tmp_kanban)
        _setup_task(fs, "TASK-001")
        report_dir = fs.report_dir("TASK-001", 1)
        fs.ensure_dir(report_dir)
        (report_dir / "code_reviewer_report.json").write_text(json.dumps({
            "role": "code_reviewer", "task_id": "TASK-001", "iteration": 1,
            "scores": {"architecture": 8, "code_quality": 7},
            "summary": "ok", "total": 7.5,
        }))
        (report_dir / "qa_report.json").write_text(json.dumps({
            "role": "qa", "task_id": "TASK-001", "iteration": 1,
            "scores": {}, "summary": "good", "total": 8.0,
        }))
        result = cmd_score(["TASK-001"])
        assert result["task_id"] == "TASK-001"
        assert len(result["scores"]) == 2
        assert result["average"] is not None

    def test_score_no_reports(self, tmp_kanban, monkeypatch):
        monkeypatch.chdir(tmp_kanban)
        result = cmd_score(["TASK-001"])
        assert result["task_id"] == "TASK-001"
        assert result["scores"] == []
        assert result["average"] is None

    def test_summary_returns_task_info(self, tmp_kanban, monkeypatch):
        monkeypatch.chdir(tmp_kanban)
        from core.infra.filesystem import Filesystem
        fs = Filesystem(root=tmp_kanban)
        _setup_task(fs, "TASK-001", title="Test task")
        result = cmd_summary(["TASK-001"])
        assert result["task_id"] == "TASK-001"
        assert result["title"] == "Test task"
        assert "phase" in result

    def test_progress_returns_subtask_progress(self, tmp_kanban, monkeypatch):
        monkeypatch.chdir(tmp_kanban)
        from core.infra.filesystem import Filesystem
        fs = Filesystem(root=tmp_kanban)
        _setup_task(fs, "TASK-001")
        checkpoint = fs.task_dir("TASK-001") / "checkpoint.json"
        fs.ensure_dir(checkpoint.parent)
        checkpoint.write_text(json.dumps({
            "ST-001": {"status": "completed"},
            "ST-002": {"status": "in_progress"},
            "ST-003": {"status": "in_progress"},
        }))
        result = cmd_progress(["TASK-001"])
        assert result["task_id"] == "TASK-001"
        assert result["progress"]["total"] == 3
        assert result["progress"]["completed"] == 1

    def test_time_returns_empty_when_no_tracking(self, tmp_kanban, monkeypatch):
        monkeypatch.chdir(tmp_kanban)
        result = cmd_time(["TASK-001"])
        assert result["task_id"] == "TASK-001"
        assert result["time"]["total_seconds"] == 0

    def test_tokens_returns_empty_when_no_tracking(self, tmp_kanban, monkeypatch):
        monkeypatch.chdir(tmp_kanban)
        result = cmd_tokens(["TASK-001"])
        assert result["task_id"] == "TASK-001"
        assert result["tokens"]["total_tokens"] == 0
