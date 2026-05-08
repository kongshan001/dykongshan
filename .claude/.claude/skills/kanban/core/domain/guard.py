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

    def check_artifacts(self, task: Task, phase: Phase) -> CheckResult:
        if phase == Phase.PLAN:
            required = ["requirements.md", "task_breakdown.json"]
        elif phase == Phase.PLAN_REVIEW:
            required = ["plan_review_report.json"]
        elif phase == Phase.QA_SPEC:
            required = ["test_spec.md"]
        elif phase == Phase.SPEC_REVIEW:
            required = ["spec_review_report.json"]
        elif phase == Phase.EXECUTE:
            required = [
                "execution_summary.md",
                "execution_pitfalls.md",
                "execution_decisions.md",
            ]
        elif phase == Phase.EVALUATE:
            return self.check_evaluation(task, task.iteration)
        elif phase == Phase.RETROSPECTIVE:
            required = ["retrospective.md", "acceptance.md"]
        else:
            return CheckResult(passed=True)

        results = [self._check_file(task, filename) for filename in required]
        combined = CheckResult.combine(results)

        if phase == Phase.EXECUTE and task.worktree_path is None:
            combined.warnings.append("worktree not set")

        return combined

    def check_evaluation(self, task: Task, iteration: int) -> CheckResult:
        missing = []
        report_dir = self._fs.report_dir(task.id, iteration)
        legacy_dir = self._fs.task_dir(task.id) / f"iteration-{iteration}"
        for role_def in Scheduler.eval_roles():
            role = role_def["name"]
            report_file = report_dir / f"{role}_report.json"
            legacy_file = legacy_dir / f"{role}_report.json"
            if not self._fs.file_exists(report_file) and not self._fs.file_exists(legacy_file):
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

    def _check_file(self, task: Task, filename: str) -> CheckResult:
        task_dir = self._fs.task_dir(task.id)
        candidates = [
            task_dir / filename,
        ]
        report_dir = self._fs.report_dir(task.id, task.iteration)
        candidates.append(report_dir / filename)
        # Legacy flat format: iteration-N/filename (#102)
        candidates.append(task_dir / f"iteration-{task.iteration}" / filename)

        for filepath in candidates:
            if self._fs.file_exists(filepath):
                if filepath.stat().st_size == 0:
                    return CheckResult(passed=False, failures=[f"{filename} is empty"])
                return CheckResult(passed=True)

        return CheckResult(passed=False, failures=[f"{filename} missing"])
