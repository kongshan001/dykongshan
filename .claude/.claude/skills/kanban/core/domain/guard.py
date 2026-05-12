from __future__ import annotations
from dataclasses import dataclass, field
from pathlib import Path

from core.types import Task, Phase
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.infra.scheduler import Scheduler


@dataclass
class CheckResult:
    passed: bool
    failures: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)

    @staticmethod
    def combine(results: list[CheckResult]) -> CheckResult:
        all_failures: list[str] = []
        all_warnings: list[str] = []
        for r in results:
            all_failures.extend(r.failures)
            all_warnings.extend(r.warnings)
        return CheckResult(
            passed=len(all_failures) == 0,
            failures=all_failures,
            warnings=all_warnings,
        )


class Guard:
    def __init__(self, fs: Filesystem, config: Config):
        self._fs = fs
        self._cfg = config

    # Hardcoded fallback when workflow.json lacks required_artifacts
    _DEFAULT_ARTIFACTS: dict[str, list[str]] = {
        "plan": ["design.md", "requirements.md", "task_breakdown.json"],
        "plan_review": ["plan_review_report.json"],
        "qa_spec": ["test_spec.md"],
        "spec_review": ["spec_review_report.json"],
        "execute": ["execution_summary.md", "execution_pitfalls.md", "execution_decisions.md"],
        "retrospective": ["retrospective.md", "acceptance.md"],
    }

    def _get_required_artifacts(self, phase: Phase) -> list[str]:
        """Read required_artifacts from workflow.json; fall back to hardcoded defaults."""
        workflow = self._cfg.workflow
        for p in workflow.get("phases", []):
            if p.get("id") == phase.value:
                artifacts = p.get("required_artifacts")
                if artifacts:
                    return artifacts
        return self._DEFAULT_ARTIFACTS.get(phase.value, [])

    def check_artifacts(self, task: Task, phase: Phase) -> CheckResult:
        # Evaluate phase: only check evaluation reports (acceptance.md checked in retrospective)
        if phase == Phase.EVALUATE:
            return self.check_evaluation(task, task.iteration)

        required = self._get_required_artifacts(phase)
        if not required:
            return CheckResult(passed=True)

        results = [self._check_file(task, filename) for filename in required]
        if phase == Phase.EXECUTE:
            results.append(self._check_test_files(task))
            results.append(self._check_tdd_evidence(task))
        combined = CheckResult.combine(results)

        if phase == Phase.EXECUTE and task.worktree_path is None:
            if task.lightweight:
                combined.warnings.append("worktree not set (lightweight mode)")
            else:
                combined.failures.append(
                    "worktree not set — Execute phase requires git worktree isolation. "
                    "Use --lightweight flag only if the task qualifies for lightweight mode."
                )

        return combined

    def check_evaluation(self, task: Task, iteration: int) -> CheckResult:
        missing = []
        report_dir = self._fs.report_dir(task.id, iteration)
        for role_def in Scheduler.eval_roles():
            role = role_def["name"]
            report_file = report_dir / f"{role}_report.json"
            if not self._fs.file_exists(report_file):
                missing.append(role)

        return CheckResult(
            passed=len(missing) == 0,
            failures=[f"missing {r} report" for r in missing],
        )

    def check_plan_quality(self, task: Task, report_dir: Path) -> CheckResult:
        requirements_file = self._fs.task_dir(task.id) / "requirements.md"
        breakdown_file = self._fs.task_dir(task.id) / "task_breakdown.json"

        failures = []
        if not self._fs.file_exists(requirements_file):
            failures.append("requirements.md missing")
        if not self._fs.file_exists(breakdown_file):
            failures.append("task_breakdown.json missing")

        return CheckResult(passed=len(failures) == 0, failures=failures)

    def check_spec(self, task: Task, report_dir: Path) -> CheckResult:
        spec_file = self._fs.task_dir(task.id) / "test_spec.md"
        if not self._fs.file_exists(spec_file):
            return CheckResult(passed=False, failures=["test_spec.md missing"])
        if spec_file.stat().st_size == 0:
            return CheckResult(passed=False, failures=["test_spec.md is empty"])
        # IR-119: verify acceptance criteria have test case coverage
        req_file = self._fs.task_dir(task.id) / "requirements.md"
        if self._fs.file_exists(req_file):
            spec_content = spec_file.read_text(encoding="utf-8")
            req_content = req_file.read_text(encoding="utf-8")
            warnings: list[str] = []
            import re
            ac_section = re.search(r'## 验收标准\n\n(.*?)(?:\n##|\Z)', req_content, re.DOTALL)
            if ac_section:
                for line in ac_section.group(1).split('\n'):
                    line = line.strip()
                    if line.startswith('- AC-'):
                        ac_id = line.split(':', 1)[0].lstrip('- ').strip()
                        ac_text = line.split(':', 1)[1].strip()[:60] if ':' in line else line
                        if ac_text.lower() not in spec_content.lower():
                            warnings.append(f"{ac_id} not covered by test spec")
            if warnings:
                return CheckResult(passed=True, warnings=warnings)
        return CheckResult(passed=True)

    def check_parallel_conflicts(self, task: Task) -> CheckResult:
        breakdown_file = self._fs.task_dir(task.id) / "task_breakdown.json"
        if not self._fs.file_exists(breakdown_file):
            return CheckResult(passed=False, failures=["task_breakdown.json missing"])

        import json
        data = json.loads(breakdown_file.read_text(encoding="utf-8"))
        subtasks = data.get("subtasks", [])

        parallelizable = [
            s for s in subtasks
            if s.get("parallelizable") and not s.get("dependencies")
        ]
        conflicts = []
        for i in range(len(parallelizable)):
            for j in range(i + 1, len(parallelizable)):
                a_files = set(parallelizable[i].get("file_ownership", []))
                b_files = set(parallelizable[j].get("file_ownership", []))
                overlap = a_files & b_files
                if overlap:
                    conflicts.append(
                        f"{parallelizable[i]['id']} <-> {parallelizable[j]['id']}: "
                        f"{', '.join(sorted(overlap))}"
                    )

        if conflicts:
            return CheckResult(
                passed=False,
                failures=[f"parallel conflict: {c}" for c in conflicts],
            )
        return CheckResult(passed=True)

    def check_cross_task_conflicts(self) -> CheckResult:
        """Check file ownership conflicts across all active (non-archived) tasks."""
        import json
        conflicts = []
        task_files = {}

        # Scan all task.json files in tasks/ directory
        tasks_dir = self._fs.kanban_dir / "tasks"
        if not tasks_dir.exists():
            return CheckResult(passed=True, warnings=["no tasks directory"])

        for tf in tasks_dir.glob("TASK-*.json"):
            data = json.loads(tf.read_text(encoding="utf-8"))
            tid = data.get("id", tf.stem)
            status = data.get("status", "")
            if status in ("archived", "cancelled"):
                continue

            bf = self._fs.task_dir(tid) / "task_breakdown.json"
            if not self._fs.file_exists(bf):
                continue
            breakdown = json.loads(bf.read_text(encoding="utf-8"))
            all_files = set()
            for st in breakdown.get("subtasks", []):
                for f in st.get("file_ownership", []):
                    all_files.add(f)
            if all_files:
                task_files[tid] = all_files

        tids = sorted(task_files.keys())
        for i in range(len(tids)):
            for j in range(i + 1, len(tids)):
                overlap = task_files[tids[i]] & task_files[tids[j]]
                if overlap:
                    conflicts.append(
                        f"{tids[i]} <-> {tids[j]}: {', '.join(sorted(overlap))}"
                    )

        if conflicts:
            return CheckResult(
                passed=False,
                failures=[f"cross-task conflict: {c}" for c in conflicts],
            )
        return CheckResult(passed=True)

    def check_phase_completeness(self, task: Task) -> CheckResult:
        """Verify no phases were skipped in the task's history.

        Compares the task's history against PHASE_ORDER —
        every phase before the current one must appear in history.
        """
        from core.infra.scheduler import Scheduler
        completed_phases = {
            h["phase"] for h in task.history
            if h.get("status") == "completed"
        }
        missing = []
        for p in Scheduler.PHASE_ORDER:
            if p == task.phase:
                break
            if p.value not in completed_phases:
                missing.append(p.value)

        if missing:
            return CheckResult(
                passed=False,
                failures=[f"skipped phases: {', '.join(missing)}"],
            )
        return CheckResult(passed=True)

    def check_brainstorming(self, task: Task) -> CheckResult:
        """IR-16: Verify brainstorming was completed — design.md must exist and be non-empty."""
        design_file = self._fs.task_dir(task.id) / "design.md"
        if not self._fs.file_exists(design_file):
            return CheckResult(
                passed=False,
                failures=["design.md missing — Plan Step A (superpowers:brainstorming) must be completed before plan_review"],
            )
        if design_file.stat().st_size == 0:
            return CheckResult(
                passed=False,
                failures=["design.md is empty — brainstorming must produce a non-empty design document"],
            )
        return CheckResult(passed=True)

    def check_retrospective(self, task: Task) -> CheckResult:
        retro_file = self._fs.task_dir(task.id) / "retrospective.md"
        accept_file = self._fs.task_dir(task.id) / "acceptance.md"

        failures = []
        if not self._fs.file_exists(retro_file):
            failures.append("retrospective.md missing")
        elif retro_file.stat().st_size == 0:
            failures.append("retrospective.md is empty")

        if not self._fs.file_exists(accept_file):
            failures.append("acceptance.md missing")
        elif accept_file.stat().st_size == 0:
            failures.append("acceptance.md is empty")

        return CheckResult(passed=len(failures) == 0, failures=failures)

    def check_evaluation_score(self, task: Task) -> CheckResult:
        """Check if evaluation score meets pass_threshold.

        Uses IterationDecider to determine action:
        - PASS → passed=True
        - MAX_ITER → passed=True (forced user_decision per IR-17)
        - HOT/FULL → passed=False with iteration suggestion
        """
        from core.domain.self_improve import IterationDecider

        if not task.score_history:
            return CheckResult(passed=False, failures=["no score_history recorded"])

        avg_score = task.score_history[-1].get("average", 0.0)
        pass_threshold = self._cfg.pass_threshold
        max_iterations = self._cfg.max_iterations

        # Check evaluate phase specific threshold
        for p in self._cfg.phases_detail:
            if p.get("id") == "evaluate":
                pt = p.get("pass_threshold")
                if pt is not None:
                    pass_threshold = pt
                break

        action = IterationDecider.decide(
            avg_score, task.iteration, max_iterations, pass_threshold
        )

        if action.value in ("user_decision", "max_iterations"):
            warnings = []
            if action.value == "max_iterations":
                warnings.append(
                    f"max iterations ({max_iterations}) reached, forcing user_decision"
                )
            return CheckResult(passed=True, warnings=warnings)

        return CheckResult(
            passed=False,
            failures=[
                f"score {avg_score} < threshold {pass_threshold}, "
                f"auto-iteration required: {action.value}"
            ],
        )

    def batch_check(
        self, task: Task, report_dir: Path
    ) -> dict[str, CheckResult]:
        """Run multiple independent guard checks and return results by name.

        Each check runs independently -- one failure does not block others.
        """
        return {
            "check_artifacts": self.check_artifacts(task, task.phase),
            "check_plan_quality": self.check_plan_quality(task, report_dir),
            "check_parallel_conflicts": self.check_parallel_conflicts(task),
            "check_phase_completeness": self.check_phase_completeness(task),
            "check_brainstorming": self.check_brainstorming(task),
        }

    def batch_check_combined(
        self, task: Task, report_dir: Path
    ) -> CheckResult:
        """Run batch_check and combine all results into single CheckResult."""
        results = self.batch_check(task, report_dir)
        return CheckResult.combine(list(results.values()))

    def _check_file(self, task: Task, filename: str) -> CheckResult:
        task_dir = self._fs.task_dir(task.id)
        candidates = [
            task_dir / filename,
        ]
        iteration_dir = self._fs.iteration_dir(task.id, task.iteration)
        candidates.append(iteration_dir / filename)
        report_dir = iteration_dir / "reports"
        candidates.append(report_dir / filename)

        for filepath in candidates:
            if self._fs.file_exists(filepath):
                if filepath.stat().st_size == 0:
                    return CheckResult(passed=False, failures=[f"{filename} is empty"])
                return CheckResult(passed=True)

        return CheckResult(passed=False, failures=[f"{filename} missing"])

    def _check_test_files(self, task: Task) -> CheckResult:
        """IR-10: Verify test files exist alongside implementation files."""
        if not task.worktree_path:
            return CheckResult(passed=True)
        wt = Path(task.worktree_path)
        cfg = self._cfg
        output_dir = cfg.raw.get("output_dir", "src")
        code_dir = wt / output_dir
        if not code_dir.exists():
            return CheckResult(passed=True)
        test_patterns = ["test_*.py", "*_test.py", "*.test.js", "*.spec.ts"]
        source_patterns = ["*.py", "*.js", "*.ts"]
        source_files: list[Path] = []
        for pat in source_patterns:
            source_files.extend(code_dir.rglob(pat))
        test_files: list[Path] = []
        for pat in test_patterns:
            test_files.extend(code_dir.rglob(pat))
        if source_files and not test_files:
            return CheckResult(
                passed=False,
                failures=["no test files found — IR-10 requires tests for all code changes"],
            )
        return CheckResult(passed=True)

    def _check_tdd_evidence(self, task: Task) -> CheckResult:
        """Verify TDD evidence table in execution_summary.md.

        Checks that the TDD evidence table exists and each row shows
        RED=FAIL (not PASS), proving tests were written before code.
        """
        summary_file = (
            self._fs.iteration_dir(task.id, task.iteration)
            / "execution_summary.md"
        )
        if not self._fs.file_exists(summary_file):
            return CheckResult(
                passed=False,
                failures=["execution_summary.md missing — cannot verify TDD evidence"],
            )
        content = summary_file.read_text(encoding="utf-8")

        # Look for the TDD evidence table header
        if "## TDD 执行证据" not in content:
            return CheckResult(
                passed=False,
                failures=[
                    "TDD evidence table missing in execution_summary.md — "
                    "must contain '## TDD 执行证据' section with per-feature RED→GREEN evidence"
                ],
            )

        # Extract table rows (lines starting with | after the header)
        tdd_section = content.split("## TDD 执行证据")[1]
        if "## " in tdd_section:
            tdd_section = tdd_section.split("## ")[0]

        rows = [line.strip() for line in tdd_section.split("\n")
                if line.strip().startswith("|") and "RED" not in line
                and "---|---" not in line and "功能点" not in line]

        if not rows:
            return CheckResult(
                passed=False,
                failures=["TDD evidence table has no data rows — each feature point needs a RED→GREEN evidence row"],
            )

        # Check each row for RED=FAIL evidence
        failures = []
        for row in rows:
            cells = [c.strip() for c in row.split("|")[1:-1]]
            if len(cells) < 5:
                continue
            feature = cells[0]
            red_result = cells[2]
            if "PASS" in red_result.upper() and "FAIL" not in red_result.upper():
                failures.append(
                    f"{feature}: RED phase was PASS — test did not fail before implementation, "
                    "TDD not correctly executed (test didn't catch missing feature)"
                )
            elif "FAIL" not in red_result.upper():
                failures.append(
                    f"{feature}: RED phase result unclear — must show FAIL with reason, got '{red_result}'"
                )

        if failures:
            return CheckResult(passed=False, failures=failures)
        return CheckResult(passed=True)
