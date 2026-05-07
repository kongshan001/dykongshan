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
        if target_idx <= current_idx:
            raise TransitionError(
                f"Cannot transition from {task.phase.value} to {target.value}"
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
