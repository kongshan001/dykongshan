from __future__ import annotations
import json
import os
import subprocess
import sys
from pathlib import Path

# Derive the kanban package root (skills/kanban/)
_KANBAN_SRC = str(Path(__file__).resolve().parent.parent.parent)


class TestTriggerCondition:
    """Unit tests for _apply_trigger_conditions (#116)."""

    @staticmethod
    def _apply_trigger_conditions(agents, description):
        from core.cli.run import _apply_trigger_conditions
        return _apply_trigger_conditions(agents, description)

    def test_required_agents_always_include(self):
        agents = [{"role": "planner", "required": True}]
        result = self._apply_trigger_conditions(agents, "")
        assert len(result) == 1
        assert result[0]["role"] == "planner"

    def test_optional_with_matching_keyword_included(self):
        agents = [{
            "role": "researcher", "required": False,
            "trigger_condition": {
                "keywords": ["调研", "选型", "research"],
                "match_field": "description",
            },
        }]
        result = self._apply_trigger_conditions(agents, "需要进行技术调研")
        assert len(result) == 1
        assert result[0]["role"] == "researcher"

    def test_optional_without_matching_keyword_skipped(self):
        agents = [{
            "role": "researcher", "required": False,
            "trigger_condition": {
                "keywords": ["调研", "选型", "research"],
                "match_field": "description",
            },
        }]
        result = self._apply_trigger_conditions(agents, "fix a simple typo")
        assert len(result) == 0

    def test_optional_without_trigger_condition_skipped(self):
        agents = [{"role": "knowledge-manager", "required": False}]
        result = self._apply_trigger_conditions(agents, "any description")
        assert len(result) == 0

    def test_mixed_agents_filtered_correctly(self):
        agents = [
            {"role": "planner", "required": True},
            {"role": "researcher", "required": False,
             "trigger_condition": {
                 "keywords": ["调研", "research"],
                 "match_field": "description",
             }},
            {"role": "extra", "required": False},
        ]
        result = self._apply_trigger_conditions(agents, "simple task")
        assert len(result) == 1
        assert result[0]["role"] == "planner"

        result2 = self._apply_trigger_conditions(agents, "需要调研分析")
        assert len(result2) == 2
        roles = [a["role"] for a in result2]
        assert "planner" in roles
        assert "researcher" in roles
        assert "extra" not in roles

    def test_case_insensitive_matching(self):
        agents = [{
            "role": "researcher", "required": False,
            "trigger_condition": {
                "keywords": ["ANALYSIS", "Research"],
                "match_field": "description",
            },
        }]
        result = self._apply_trigger_conditions(agents, "This task needs analysis")
        assert len(result) == 1


def _run(*args, cwd):
    env = os.environ.copy()
    existing = env.get("PYTHONPATH", "")
    env["PYTHONPATH"] = _KANBAN_SRC + (f":{existing}" if existing else "")
    result = subprocess.run(
        [sys.executable, "-m", "core"] + list(args),
        capture_output=True, text=True, cwd=str(cwd), env=env,
    )
    if not result.stdout.strip():
        return {"success": False, "error": "no output", "stderr": result.stderr[:500]}
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError:
        return {"success": False, "error": f"json decode failed: {result.stdout[:200]}", "stderr": result.stderr[:500]}


def _read_task(tmp_kanban, task_id="TASK-001"):
    """Read task JSON from disk with proper encoding."""
    # New format: tasks/TASK-NNN/task.json
    new_path = tmp_kanban / ".kanban" / "tasks" / task_id / "task.json"
    if new_path.is_file():
        return json.loads(new_path.read_text(encoding="utf-8"))
    # Old format fallback
    old_path = tmp_kanban / ".kanban" / "tasks" / f"{task_id}.json"
    return json.loads(old_path.read_text(encoding="utf-8"))


def _set_phase(tmp_kanban, task_id, phase):
    """Directly set task phase in JSON (bypasses workflow transition)."""
    # New format: tasks/TASK-NNN/task.json
    new_path = tmp_kanban / ".kanban" / "tasks" / task_id / "task.json"
    if new_path.is_file():
        data = json.loads(new_path.read_text(encoding="utf-8"))
        data["phase"] = phase
        new_path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")
        return
    # Old format fallback
    old_path = tmp_kanban / ".kanban" / "tasks" / f"{task_id}.json"
    data = json.loads(old_path.read_text(encoding="utf-8"))
    data["phase"] = phase
    old_path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")


class TestCLIRun:
    def test_run_task(self, tmp_kanban, sample_task_file):
        # Set up required artifacts so guard check passes
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "design.md").write_text("# Design\n\nTest design.")
        (task_dir / "requirements.md").write_text("# Requirements\n\nTest requirements.")
        (task_dir / "task_breakdown.json").write_text(json.dumps({
            "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
        }))

        # Write task.json in new format + description that passes brainstorming gate
        (task_dir / "task.json").write_text(json.dumps({
            "id": "TASK-001", "title": "测试任务",
            "description": "使用 python 实现测试功能，包含以下：验收标准 代码放在 test/",
            "status": "in_progress", "phase": "plan", "iteration": 1,
            "history": [], "scores": {},
        }, indent=2, ensure_ascii=False), encoding="utf-8")

        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True, f"run failed: {result}"
        assert result["data"]["phase"] == "plan_review"
        assert "agents_to_spawn" in result["data"]
        assert isinstance(result["data"]["agents_to_spawn"], list)

    def test_run_brainstorming_gate_blocked(self, tmp_kanban, sample_task_file):
        """IR-16: run from plan→plan_review with incomplete description must be blocked."""
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "design.md").write_text("# Design\n\nTest.")
        (task_dir / "requirements.md").write_text("# Requirements\n\nTest requirements.")
        (task_dir / "task_breakdown.json").write_text(json.dumps({
            "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
        }))
        result = _run("run", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        # Description "用于测试的示例任务" lacks all 4 elements → gate blocked
        assert result["data"]["phase"] == "plan"
        assert "brainstorming_gate" in result["data"]
        assert result["data"]["brainstorming_gate"]["passed"] is False

    def test_run_missing_task(self, tmp_kanban):
        result = _run("run", "TASK-999", cwd=tmp_kanban)
        assert result["success"] is False

    def test_decide(self, tmp_kanban, sample_task_file):
        _set_phase(tmp_kanban, "TASK-001", "user_decision")
        result = _run(
            "decide", "TASK-001", "--action", "approve_and_archive",
            cwd=tmp_kanban,
        )
        assert result.get("success") is True, f"decide failed: {result}"

    def test_complete_phase_blocked_by_guard(self, tmp_kanban, sample_task_file):
        """complete-phase must check guard first — missing artifacts = blocked."""
        result = _run("workflow", "complete-phase", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is False
        assert "guard" in str(result).lower() or "fail" in str(result).lower()

    def test_complete_phase_passes_with_artifacts(self, tmp_kanban, sample_task_file):
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "design.md").write_text("# Design\n\nTest.")
        (task_dir / "requirements.md").write_text("# Requirements\n\nTest.")
        (task_dir / "task_breakdown.json").write_text(json.dumps({
            "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
        }))
        result = _run("workflow", "complete-phase", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True

    def test_workflow_transition_persists_phase_to_disk(self, tmp_kanban, sample_task_file):
        """cmd_workflow transition must persist the new phase to task.json (#101/#100)."""
        # Set up required artifacts so guard check in transition() passes
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "design.md").write_text("# Design\n\ndesign content")
        (task_dir / "requirements.md").write_text("# Requirements\n\nreq content")
        (task_dir / "task_breakdown.json").write_text(json.dumps({
            "subtasks": [{"id": "ST-001", "title": "test", "priority": 1}]
        }))

        result = _run("workflow", "transition", "TASK-001", "plan_review", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["to"] == "plan_review"

        task_data = _read_task(tmp_kanban)
        assert task_data["phase"] == "plan_review", (
            f"Expected phase=plan_review on disk, got {task_data['phase']}"
        )

    def test_decide_persists_phase_to_disk(self, tmp_kanban, sample_task_file):
        """cmd_decide must persist phase to task.json via restart action (Issue #111)."""
        _set_phase(tmp_kanban, "TASK-001", "user_decision")

        result = _run("decide", "TASK-001", "--action", "restart_from_execute", cwd=tmp_kanban)
        assert result["success"] is True
        assert result["data"]["action"] == "restart_from_execute"

        task_data = _read_task(tmp_kanban)
        assert task_data["phase"] == "execute", (
            f"Expected phase=execute on disk, got {task_data['phase']}"
        )

    def test_decide_persists_user_decision(self, tmp_kanban, sample_task_file):
        """cmd_decide must persist user_decision field to task.json (Issue #111)."""
        _set_phase(tmp_kanban, "TASK-001", "user_decision")

        result = _run("decide", "TASK-001", "--action", "restart_from_plan", cwd=tmp_kanban)
        assert result["success"] is True

        task_data = _read_task(tmp_kanban)
        assert task_data.get("user_decision") is not None, (
            "user_decision field should be persisted"
        )
        assert task_data["user_decision"]["action"] == "restart_from_plan"

    def test_decide_rejects_invalid_phase(self, tmp_kanban, sample_task_file):
        """cmd_decide must reject decisions when task is not in a decidable phase (Issue #111)."""
        # Task is in plan phase (not user_decision/evaluate/retrospective)
        result = _run("decide", "TASK-001", "--action", "approve_and_archive", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert "error" in data, f"Should reject decide at plan phase, got: {data}"
        assert "plan" in data["error"]

    def test_guard_batch_check_missing_task(self, tmp_kanban, sample_task_file):
        """batch-check returns error when task_id is missing."""
        result = _run("guard", "batch-check", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert "error" in data

    def test_guard_batch_check_returns_result(self, tmp_kanban, sample_task_file):
        """batch-check returns combined guard result for a task."""
        result = _run("guard", "batch-check", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
        data = result["data"]
        assert data["subcommand"] == "batch-check"
        assert data["task_id"] == "TASK-001"
        assert "passed" in data
        assert "failures" in data
        assert isinstance(data["failures"], list)

    def test_complete_phase_blocked_by_low_score(self, tmp_kanban, sample_task_file):
        """complete-phase at evaluate with score < threshold is blocked."""
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "acceptance.md").write_text("# Acceptance\n\nPASS")

        # Write evaluation reports with low scores
        report_dir = task_dir / "iteration-1"
        report_dir.mkdir(parents=True, exist_ok=True)
        for role in ["code_reviewer", "qa", "pm", "designer"]:
            (report_dir / f"{role}_report.json").write_text(json.dumps({
                "role": role, "task_id": "TASK-001", "iteration": 1,
                "total": 7.0, "summary": f"{role} report",
            }))

        # Set phase to evaluate and record completed phases in history
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "task.json"
        if not task_file.exists():
            # New format
            old_task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
            if old_task_file.exists():
                import shutil
                shutil.copy(str(old_task_file), str(task_file))
            else:
                task_file.write_text(json.dumps({
                    "id": "TASK-001", "title": "Test", "description": "test",
                    "status": "in_progress", "phase": "evaluate", "iteration": 1,
                    "history": [], "scores": {}, "score_history": [],
                }))
        data = json.loads(task_file.read_text(encoding="utf-8"))
        data["phase"] = "evaluate"
        completed_phases = ["plan", "plan_review", "qa_spec", "spec_review", "execute"]
        data["history"] = [{"phase": p, "status": "completed"} for p in completed_phases]
        task_file.write_text(json.dumps(data), encoding="utf-8")

        # Record the score
        _run("evaluator", "record-score", "TASK-001", cwd=tmp_kanban)

        result = _run("workflow", "complete-phase", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is False
        assert "score gate" in result.get("error", "").lower() or "auto-iteration" in result.get("error", "").lower()

    def test_complete_phase_passes_with_high_score(self, tmp_kanban, sample_task_file):
        """complete-phase at evaluate with score >= threshold passes."""
        task_dir = tmp_kanban / ".kanban" / "tasks" / "TASK-001"
        task_dir.mkdir(exist_ok=True)
        (task_dir / "acceptance.md").write_text("# Acceptance\n\nPASS")

        # Write evaluation reports with high scores
        report_dir = task_dir / "iteration-1"
        report_dir.mkdir(parents=True, exist_ok=True)
        for role in ["code_reviewer", "qa", "pm", "designer"]:
            (report_dir / f"{role}_report.json").write_text(json.dumps({
                "role": role, "task_id": "TASK-001", "iteration": 1,
                "total": 9.5, "summary": f"{role} report",
            }))

        # Set phase to evaluate and record completed phases in history
        task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001" / "task.json"
        if not task_file.exists():
            old_task_file = tmp_kanban / ".kanban" / "tasks" / "TASK-001.json"
            if old_task_file.exists():
                import shutil
                shutil.copy(str(old_task_file), str(task_file))
            else:
                task_file.write_text(json.dumps({
                    "id": "TASK-001", "title": "Test", "description": "test",
                    "status": "in_progress", "phase": "evaluate", "iteration": 1,
                    "history": [], "scores": {}, "score_history": [],
                }))
        data = json.loads(task_file.read_text(encoding="utf-8"))
        data["phase"] = "evaluate"
        completed_phases = ["plan", "plan_review", "qa_spec", "spec_review", "execute"]
        data["history"] = [{"phase": p, "status": "completed"} for p in completed_phases]
        task_file.write_text(json.dumps(data), encoding="utf-8")

        # Record the score
        _run("evaluator", "record-score", "TASK-001", cwd=tmp_kanban)

        result = _run("workflow", "complete-phase", "TASK-001", cwd=tmp_kanban)
        assert result["success"] is True
