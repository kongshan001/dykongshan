from __future__ import annotations
import time

from core.types import Task, Phase
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.infra.scheduler import Scheduler
from core.domain.self_improve import IterationDecider, IterationAction


class TransitionError(Exception):
    pass


class WorkflowEngine:
    def __init__(self, fs: Filesystem, config: Config):
        self._fs = fs
        self._cfg = config

    def transition(self, task: Task, target: Phase) -> Phase:
        current_idx = Scheduler.PHASE_ORDER.index(task.phase)
        target_idx = Scheduler.PHASE_ORDER.index(target)
        if target_idx == current_idx:
            return target
        if target_idx < current_idx:
            raise TransitionError(
                f"Cannot transition backward from {task.phase.value} to {target.value}"
            )
        if target_idx > current_idx + 1:
            raise TransitionError(
                f"Cannot skip phase: {task.phase.value} -> {target.value}"
            )
        return target

    def complete_phase(self, task: Task) -> Task:
        task.history.append(
            {
                "phase": task.phase.value,
                "status": "completed",
                "completed_at": time.time(),
                "iteration": task.iteration,
            }
        )
        next_p = self.next_phase(task.phase)
        if next_p:
            task.phase = next_p
        return task

    def next_phase(self, phase: Phase) -> Phase | None:
        return Scheduler.next_phase(phase)

    def is_terminal(self, phase: Phase) -> bool:
        return phase == Phase.ARCHIVE

    def self_improve_check(self, task: Task, avg_score: float) -> dict:
        action = IterationDecider.decide(
            avg_score,
            task.iteration,
            self._cfg.max_iterations,
            self._cfg.pass_threshold,
        )
        return {"action": action.value, "reason": f"IterationAction.{action.name}"}

    def quality_gate_check(
        self,
        task: Task,
        score: float,
        gate_phase: Phase,
        round_num: int,
    ) -> dict:
        """Check quality gate result for plan_review or spec_review phases.

        Returns decision dict with action and whether to proceed, retry, or abort.
        """
        workflow = self._cfg.workflow
        phase_config = None
        for p in workflow.get("phases", []):
            if p.get("id") == gate_phase.value:
                phase_config = p
                break

        pass_threshold = 7.0
        max_rounds = 3
        if phase_config:
            pass_threshold = phase_config.get("pass_threshold", 7.0)
            max_rounds = phase_config.get("max_rounds", 3)

        action = IterationDecider.decide_quality_gate(
            score, round_num, max_rounds, pass_threshold
        )

        result = {
            "action": action.value,
            "score": score,
            "threshold": pass_threshold,
            "round": round_num,
            "max_rounds": max_rounds,
        }

        if action == IterationAction.PASS:
            result["next_phase"] = self.next_phase(gate_phase).value if self.next_phase(gate_phase) else None
        elif action == IterationAction.RETRY_PREV:
            # Go back to the phase before the gate
            try:
                idx = Scheduler.PHASE_ORDER.index(gate_phase)
                result["retry_phase"] = Scheduler.PHASE_ORDER[idx - 1].value
            except (ValueError, IndexError):
                result["retry_phase"] = Phase.PLAN.value
        elif action == IterationAction.MAX_ITER:
            result["next_phase"] = Phase.USER_DECISION.value

        return result

    def previous_phase(self, phase: Phase) -> Phase | None:
        try:
            idx = Scheduler.PHASE_ORDER.index(phase)
            if idx > 0:
                return Scheduler.PHASE_ORDER[idx - 1]
        except ValueError:
            pass
        return None
