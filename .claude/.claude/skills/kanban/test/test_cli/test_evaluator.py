from __future__ import annotations
import json


def _run(*args, cwd):
    import os, subprocess, sys
    from pathlib import Path
    _KANBAN_SRC = str(Path(__file__).resolve().parent.parent.parent)
    env = os.environ.copy()
    existing = env.get("PYTHONPATH", "")
    env["PYTHONPATH"] = _KANBAN_SRC + (f":{existing}" if existing else "")
    result = subprocess.run(
        [sys.executable, "-m", "core"] + list(args),
        capture_output=True, text=True, cwd=str(cwd), env=env,
    )
    return json.loads(result.stdout)


class TestEvaluatorCollectScores:
    def test_collect_scores_reads_reports_and_calculates_average(self, tmp_kanban, sample_task_file):
        """evaluator collect-scores reads all 4 role reports and returns avg."""
        # Write a proper task.json with evaluate phase so collect-scores can find it
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        task_data["phase"] = "evaluate"
        task_data["iteration"] = 1
        task_file.write_text(json.dumps(task_data))

        # Write evaluation reports
        from pathlib import Path
        fs_root = tmp_kanban
        report_dir = fs_root / ".kanban" / "tasks" / "TASK-001" / "iterations" / "1" / "reports"
        report_dir.mkdir(parents=True, exist_ok=True)

        scores = {
            "code_reviewer": 8.0,
            "qa": 7.5,
            "pm": 9.0,
            "designer": 8.5,
        }
        for role, score in scores.items():
            (report_dir / f"{role}_report.json").write_text(json.dumps({
                "role": role, "task_id": "TASK-001", "iteration": 1,
                "total": score, "summary": f"{role} report",
                "dimensions": {},
            }))

        result = _run("evaluator", "collect-scores", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["task_id"] == "TASK-001"
        assert result["data"]["average"] == 8.25
        assert len(result["data"]["scores"]) == 4

    def test_collect_scores_no_reports(self, tmp_kanban, sample_task_file):
        """Returns error when no evaluation reports found."""
        result = _run("evaluator", "collect-scores", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["average"] is None
        assert result["data"]["scores"] == []


class TestEvaluatorRecordScore:
    def test_record_score_persists_to_task_json(self, tmp_kanban, sample_task_file):
        """evaluator record-score saves per-iteration scores and score_history."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        task_data["phase"] = "evaluate"
        task_data["iteration"] = 1
        task_file.write_text(json.dumps(task_data))

        # Write evaluation reports
        report_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "iterations" / "1" / "reports"
        report_dir.mkdir(parents=True, exist_ok=True)
        scores = {"code_reviewer": 8.0, "qa": 7.5, "pm": 9.0, "designer": 8.5}
        for role, score in scores.items():
            (report_dir / f"{role}_report.json").write_text(json.dumps({
                "role": role, "task_id": "TASK-001", "iteration": 1,
                "total": score, "summary": f"{role} report",
            }))

        result = _run("evaluator", "record-score", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["recorded"] is True
        assert result["data"]["average"] == 8.25

        # Verify scores persisted in task.json
        updated = json.loads(task_file.read_text())
        assert "score_history" in updated
        assert len(updated["score_history"]) == 1
        assert updated["score_history"][0]["iteration"] == 1
        assert updated["score_history"][0]["average"] == 8.25
        assert updated["scores"]["code_reviewer"] == 8.0


class TestSelfImproveCheckAutoScore:
    def test_self_improve_check_reads_scores_from_task_json(self, tmp_kanban, sample_task_file):
        """self-improve-check auto-reads score_history when no --avg-score given."""
        # Set up task with pre-recorded scores
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        task_data["phase"] = "evaluate"
        task_data["iteration"] = 1
        task_data["score_history"] = [{
            "iteration": 1,
            "average": 9.2,
            "roles": {"code_reviewer": 9.0, "qa": 9.5, "pm": 9.0, "designer": 9.3},
        }]
        task_task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_task_dir.mkdir(parents=True, exist_ok=True)
        task_file.write_text(json.dumps(task_data))

        # self-improve-check without --avg-score should read from task
        result = _run("workflow", "self-improve-check", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["action"] == "user_decision"

    def test_self_improve_check_explicit_avg_overrides_task(self, tmp_kanban, sample_task_file):
        """Explicit --avg-score takes priority over task score_history."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        task_data["phase"] = "evaluate"
        task_data["score_history"] = [{
            "iteration": 1, "average": 9.2,
            "roles": {},
        }]
        task_task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_task_dir.mkdir(parents=True, exist_ok=True)
        task_file.write_text(json.dumps(task_data))

        # Explicit avg_score=6.0 should trigger full iteration
        result = _run("workflow", "self-improve-check", "TASK-001", "6.0", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["action"] == "full_iteration"


class TestStartIteration:
    def test_start_iteration_hot_isolates_artifacts(self, tmp_kanban, sample_task_file):
        """workflow start-iteration hot: increment iter, move artifacts, reset to execute."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        task_data["phase"] = "evaluate"
        task_data["iteration"] = 1
        task_file.write_text(json.dumps(task_data))

        # Write execution artifacts in task root (current behavior)
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(parents=True, exist_ok=True)
        for fname in ["execution_summary.md", "execution_pitfalls.md", "execution_decisions.md"]:
            (task_dir / fname).write_text(f"# {fname}\n\ncontent")

        result = _run("workflow", "start-iteration", "TASK-001", "hot", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["iteration"] == 2
        assert result["data"]["phase"] == "execute"

        # Old artifacts moved to iteration-1/
        iter1 = task_dir / "iteration-1"
        assert iter1.exists()
        assert (iter1 / "execution_summary.md").exists()
        assert (iter1 / "execution_pitfalls.md").exists()
        assert (iter1 / "execution_decisions.md").exists()

        # Task root no longer has the old artifacts
        assert not (task_dir / "execution_summary.md").exists()

    def test_start_iteration_full_resets_to_plan(self, tmp_kanban, sample_task_file):
        """workflow start-iteration full: increment iter, reset to plan."""
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
        task_data = json.loads(task_file.read_text())
        task_data["phase"] = "evaluate"
        task_data["iteration"] = 1
        task_file.write_text(json.dumps(task_data))

        result = _run("workflow", "start-iteration", "TASK-001", "full", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["iteration"] == 2
        assert result["data"]["phase"] == "plan"
