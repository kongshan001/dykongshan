from __future__ import annotations
from pathlib import Path
from core.infra.filesystem import Filesystem
from core.infra.config import Config
from core.domain.task import TaskManager


def dispatch(args: list[str]) -> dict:
    if not args:
        return {"error": "subcommand required: collect-scores, record-score, collect-plan-review"}
    sub = args[0]
    task_id = args[1] if len(args) > 1 else "unknown"
    root = Filesystem.find_project_root()
    fs = Filesystem(root=root)
    cfg = Config(fs)
    tm = TaskManager(fs, cfg)

    if sub == "collect-scores":
        return _collect_scores(fs, tm, task_id)
    if sub == "record-score":
        return _record_score(fs, tm, task_id)
    if sub == "collect-plan-review":
        return _collect_plan_review_scores(fs, tm, task_id)
    return {"error": f"unknown evaluator subcommand: {sub}"}


def _collect_scores(fs: Filesystem, tm: TaskManager, task_id: str) -> dict:
    try:
        task = tm.show(task_id)
    except Exception:
        return {"task_id": task_id, "scores": [], "average": None}

    scores = []
    for it in range(1, task.iteration + 1):
        it_dir = fs.iteration_dir(task_id, it)
        if not it_dir.exists():
            continue

        for role in ["code_reviewer", "qa", "pm", "designer"]:
            rf = it_dir / f"{role}_report.json"
            if fs.file_exists(rf):
                data = fs.read_json(rf)
                scores.append({
                    "role": role,
                    "iteration": it,
                    "total": data.get("total",
                                       data.get("score",
                                                data.get("overall", 0))),
                })

    avg = round(sum(s["total"] for s in scores) / len(scores), 2) if scores else None
    return {"task_id": task_id, "scores": scores, "average": avg}


def _record_score(fs: Filesystem, tm: TaskManager, task_id: str) -> dict:
    scores_data = _collect_scores(fs, tm, task_id)
    try:
        task = tm.show(task_id)
    except Exception:
        return {"task_id": task_id, "error": "task not found"}

    avg = scores_data["average"]
    if avg is None:
        return {"task_id": task_id, "recorded": False, "error": "no scores to record"}

    # Build per-iteration role scores dict
    role_scores = {s["role"]: s["total"] for s in scores_data["scores"]
                   if s["iteration"] == task.iteration}

    # Append to score_history
    entry = {
        "iteration": task.iteration,
        "average": avg,
        "roles": role_scores,
    }
    new_history = list(task.score_history)
    # Replace existing entry for same iteration; otherwise append
    replaced = False
    for i, h in enumerate(new_history):
        if h.get("iteration") == task.iteration:
            new_history[i] = entry
            replaced = True
            break
    if not replaced:
        new_history.append(entry)

    tm.update(task_id, scores=role_scores, score_history=new_history)

    return {
        "task_id": task_id,
        "recorded": True,
        "iteration": task.iteration,
        "average": avg,
    }


_PLAN_REVIEW_DIMENSIONS = [
    "requirement_clarity", "technical_feasibility",
    "task_decomposition", "acceptance_criteria",
    "research_completeness", "parallel_safety",
]


def _collect_plan_review_scores(
    fs: Filesystem, tm: TaskManager, task_id: str
) -> dict:
    try:
        task = tm.show(task_id)
    except Exception:
        return {"task_id": task_id, "dimensions": [], "average": None}

    dimensions = []
    for it in range(1, task.iteration + 1):
        it_dir = fs.iteration_dir(task_id, it)
        if not it_dir.exists():
            continue

        for dim in _PLAN_REVIEW_DIMENSIONS:
            rf = it_dir / f"{dim}_report.json"
            if fs.file_exists(rf):
                data = fs.read_json(rf)
                applicable = data.get("applicable", True)
                if applicable:
                    dimensions.append({
                        "dimension": dim,
                        "iteration": it,
                        "score": data.get("score", 0),
                        "findings": data.get("findings", []),
                        "issues": data.get("issues", []),
                    })

    avg = round(
        sum(d["score"] for d in dimensions) / len(dimensions), 2
    ) if dimensions else None
    return {"task_id": task_id, "dimensions": dimensions, "average": avg}
