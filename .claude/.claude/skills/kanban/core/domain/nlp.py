from __future__ import annotations
import re
from core.types import NLPResult


def extract_task_id(text: str) -> str | None:
    """Extract TASK-NNN from natural language text. Useful utility for LLM-assisted routing."""
    m = re.search(r"TASK-(\d{1,3})", text, re.IGNORECASE)
    if m:
        return f"TASK-{int(m.group(1)):03d}"
    return None


# Work-intent patterns: verbs that imply "do/create/implement something"
_WORK_VERBS = re.compile(
    r"(?:帮我|处理|实现|做|开发|写|添加|增加|修复|fix|create|build|implement|add|refactor|重构|改进|优化|新增|搭建)",
    re.IGNORECASE,
)

# Query-intent patterns: verbs that imply "show/check status"
_QUERY_VERBS = re.compile(
    r"(?:看看|查看|状态|进度|怎么样|什么|有没有|show|status|list|list)",
    re.IGNORECASE,
)


def detect_work_intent(text: str) -> dict:
    """Detect whether natural language input expresses work intent or query intent.

    Returns dict with:
      - intent: "work" | "query" | "ambiguous"
      - suggested_command: "create" | "status" | None
      - has_task_id: bool
    """
    lower = text.lower()
    has_task_id = extract_task_id(text) is not None
    is_work = bool(_WORK_VERBS.search(lower))
    is_query = bool(_QUERY_VERBS.search(lower))

    if has_task_id and is_work:
        return {"intent": "work", "suggested_command": "run", "has_task_id": True}
    if is_work and not is_query:
        return {"intent": "work", "suggested_command": "create", "has_task_id": has_task_id}
    if is_query and not is_work:
        return {"intent": "query", "suggested_command": "status", "has_task_id": has_task_id}
    return {"intent": "ambiguous", "suggested_command": None, "has_task_id": has_task_id}


def parse_nlp(text: str) -> NLPResult:
    """Deprecated: keyword matching replaced by LLM inference via cmd_nlp."""
    return NLPResult(success=False, command="unknown", task_id=extract_task_id(text))
