from __future__ import annotations
import re
from core.types import NLPResult


def extract_task_id(text: str) -> str | None:
    """Extract TASK-NNN from natural language text. Useful utility for LLM-assisted routing."""
    m = re.search(r"TASK-(\d{1,3})", text, re.IGNORECASE)
    if m:
        return f"TASK-{int(m.group(1)):03d}"
    return None


def parse_nlp(text: str) -> NLPResult:
    """Deprecated: keyword matching replaced by LLM inference via cmd_nlp."""
    return NLPResult(success=False, command="unknown", task_id=extract_task_id(text))
