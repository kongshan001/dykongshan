"""
Subtask executor — parallel batch scheduling with dependency resolution.

Reads task_breakdown.json and produces a parallel execution plan:
- Subtasks with no dependencies and no file conflicts → same parallel batch
- Subtasks with dependencies → serialized after their dependencies complete
- File ownership conflicts detected → forced serialization
"""

from __future__ import annotations
import json
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager


def _resolve(task_id: str) -> tuple[Filesystem, TaskManager, dict]:
    root = Path.cwd()
    fs = Filesystem(root=root)
    tm = TaskManager(fs, Config(fs))
    task = tm.show(task_id)
    breakdown_path = fs.task_dir(task.id) / "task_breakdown.json"
    if not fs.file_exists(breakdown_path):
        raise FileNotFoundError(f"task_breakdown.json not found for {task_id}")
    breakdown = json.loads(breakdown_path.read_text(encoding="utf-8"))
    return fs, tm, breakdown


def plan_batches(task_id: str) -> dict:
    """Compute parallel execution batches from task_breakdown.json."""
    _, _, breakdown = _resolve(task_id)
    subtasks = breakdown.get("subtasks", [])

    if not subtasks:
        return {"task_id": task_id, "batches": [], "total_subtasks": 0}

    # Build dependency graph
    deps: dict[str, set[str]] = {}
    for st in subtasks:
        deps[st["id"]] = set(st.get("dependencies", []))

    # Topological sort into batches
    remaining = set(deps.keys())
    batches: list[list[str]] = []
    completed: set[str] = set()

    while remaining:
        ready = sorted(
            sid for sid in remaining
            if deps[sid].issubset(completed)
        )
        if not ready:
            return {
                "task_id": task_id,
                "error": "circular dependency detected",
                "remaining": sorted(remaining),
                "batches": [[s] for s in remaining],
            }

        # Among ready subtasks, check for file conflicts
        st_map = {s["id"]: s for s in subtasks}
        current_batch: list[str] = []
        conflict_free: set[str] = set()

        for sid in ready:
            st = st_map[sid]
            if not st.get("parallelizable"):
                # Non-parallelizable tasks go alone
                if current_batch:
                    batches.append(current_batch)
                    current_batch = []
                    conflict_free = set()
                batches.append([sid])
                remaining.discard(sid)
                completed.add(sid)
                continue

            # Check file conflicts with current batch
            my_files = set(st.get("file_ownership", []))
            batch_files = set()
            for b_sid in current_batch:
                batch_files.update(st_map[b_sid].get("file_ownership", []))

            if my_files & batch_files:
                # Conflict — close current batch, start new one
                if current_batch:
                    batches.append(current_batch)
                    current_batch = []
                    conflict_free = set()
                current_batch.append(sid)
                conflict_free = my_files
                remaining.discard(sid)
                completed.add(sid)
            else:
                current_batch.append(sid)
                conflict_free.update(my_files)
                remaining.discard(sid)
                completed.add(sid)

        if current_batch:
            batches.append(current_batch)

    return {
        "task_id": task_id,
        "batches": batches,
        "total_subtasks": len(subtasks),
        "total_batches": len(batches),
        "parallel_subtasks": sum(len(b) for b in batches if len(b) > 1),
        "serial_subtasks": sum(1 for b in batches if len(b) == 1),
    }


def batch_details(task_id: str) -> dict:
    """Return detailed batch plan with file_ownership per subtask."""
    _, _, breakdown = _resolve(task_id)
    subtasks = breakdown.get("subtasks", [])
    st_map = {s["id"]: s for s in subtasks}

    plan = plan_batches(task_id)
    if "error" in plan:
        return plan

    detailed_batches = []
    for i, batch in enumerate(plan["batches"]):
        detailed_batches.append({
            "batch_index": i,
            "size": len(batch),
            "subtasks": [
                {
                    "id": sid,
                    "title": st_map.get(sid, {}).get("title", ""),
                    "file_ownership": st_map.get(sid, {}).get("file_ownership", []),
                    "dependencies": st_map.get(sid, {}).get("dependencies", []),
                }
                for sid in batch
            ],
        })

    return {
        "task_id": task_id,
        "batches": detailed_batches,
        "total_batches": len(detailed_batches),
        "total_subtasks": plan["total_subtasks"],
    }


# CLI dispatch
def dispatch(args: list[str]) -> dict:
    if not args:
        return {"error": "subcommand required (start, done, plan, details)"}

    sub = args[0]

    if sub == "plan":
        if len(args) < 2:
            return {"error": "task_id required"}
        return plan_batches(args[1])

    if sub == "details":
        if len(args) < 2:
            return {"error": "task_id required"}
        return batch_details(args[1])

    if sub == "start":
        if len(args) < 3:
            return {"error": "task_id and subtask_id required"}
        return {
            "subcommand": "start",
            "task_id": args[1],
            "subtask_id": args[2],
            "status": "in_progress",
        }

    if sub == "done":
        if len(args) < 3:
            return {"error": "task_id and subtask_id required"}
        return {
            "subcommand": "done",
            "task_id": args[1],
            "subtask_id": args[2],
            "status": "completed",
        }

    return {"error": f"unknown subtask subcommand: {sub}"}
