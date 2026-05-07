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
        elif phase == Phase.EXECUTE:
            required = [
                "execution_summary.md",
                "execution_pitfalls.md",
                "execution_decisions.md",
            ]
        elif phase == Phase.EVALUATE:
            return self.check_evaluation(task, task.iteration)
        else:
            return CheckResult(passed=True)

        results = [
            self._check_file(task, filename) for filename in required
        ]
        combined = CheckResult.combine(results)

        if phase == Phase.EXECUTE and task.worktree_path is None:
            combined.warnings.append("worktree not set")

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

    def _check_file(self, task: Task, filename: str) -> CheckResult:
        filepath = self._fs.task_dir(task.id) / filename
        if not self._fs.file_exists(filepath):
            return CheckResult(passed=False, failures=[f"{filename} missing"])
        if filepath.stat().st_size == 0:
            return CheckResult(passed=False, failures=[f"{filename} is empty"])
        return CheckResult(passed=True)
