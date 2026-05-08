from __future__ import annotations
from core.domain.nlp import extract_task_id, parse_nlp


class TestExtractTaskId:
    def test_extract_standard_task_id(self):
        assert extract_task_id("check TASK-005 progress") == "TASK-005"

    def test_extract_task_id_case_insensitive(self):
        assert extract_task_id("run task-042 now") == "TASK-042"

    def test_no_task_id(self):
        assert extract_task_id("create a new project") is None

    def test_extract_padded_format(self):
        assert extract_task_id("TASK-001 is done") == "TASK-001"


class TestParseNlp:
    def test_parse_returns_unknown_with_task_id(self):
        """LLM-based NLP: parse_nlp no longer matches commands, just extracts task_id."""
        result = parse_nlp("run TASK-003 please")
        assert result.success is False  # no keyword matching anymore
        assert result.command == "unknown"
        assert result.task_id == "TASK-003"  # task_id still extracted

    def test_parse_unknown_input(self):
        result = parse_nlp("some random text")
        assert result.success is False
        assert result.command == "unknown"

    def test_parse_empty(self):
        result = parse_nlp("")
        assert result.success is False
