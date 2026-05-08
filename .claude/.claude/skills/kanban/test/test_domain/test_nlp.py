from __future__ import annotations
import json
import pytest
from core.domain.nlp import NLPRouter


@pytest.fixture
def nlp_patterns_file(tmp_path):
    patterns = {
        "commands": {
            "create": {"keywords": ["create", "new", "start"]},
            "run": {"keywords": ["run", "execute", "start"]},
            "status": {"keywords": ["status", "list"]},
        },
        "task_id_patterns": {
            "chinese_number": {"mappings": {"one": 1, "two": 2, "three": 3}}
        },
        "fallback": {"default_command": "unknown"},
    }
    f = tmp_path / "nlp_patterns.json"
    f.write_text(json.dumps(patterns, ensure_ascii=False))
    return f


class TestNLPRouter:
    def test_exact_match_create(self, nlp_patterns_file):
        router = NLPRouter(nlp_patterns_file)
        result = router.parse("create a new task")
        assert result.success is True
        assert result.command == "create"

    def test_extract_standard_task_id(self, nlp_patterns_file):
        router = NLPRouter(nlp_patterns_file)
        tid = router._extract_task_id("check TASK-005 progress")
        assert tid == "TASK-005"

    def test_no_match_returns_unknown(self, nlp_patterns_file):
        router = NLPRouter(nlp_patterns_file)
        result = router.parse("what is the weather")
        assert result.success is False

    def test_match_with_task_id_in_context(self, nlp_patterns_file):
        router = NLPRouter(nlp_patterns_file)
        result = router.parse("run TASK-002")
        assert result.success is True
        assert result.command == "run"
        assert result.task_id == "TASK-002"

    def test_empty_input(self, nlp_patterns_file):
        router = NLPRouter(nlp_patterns_file)
        result = router.parse("")
        assert result.success is False

    def test_nested_keywords_structure(self, tmp_path):
        """Real nlp_patterns.json uses {exact, synonyms, fuzzy} not flat lists."""
        patterns = {
            "commands": {
                "create": {
                    "keywords": {
                        "exact": ["create"],
                        "synonyms": ["新建任务", "创建任务", "添加任务"],
                        "fuzzy": ["帮我开个", "我有个需求"],
                    }
                },
                "status": {
                    "keywords": {
                        "exact": ["status"],
                        "synonyms": ["查看状态", "看板状态"],
                        "fuzzy": ["任务跑到哪了"],
                    }
                },
            }
        }
        f = tmp_path / "nlp_patterns.json"
        f.write_text(json.dumps(patterns, ensure_ascii=False))
        router = NLPRouter(f)
        result = router.parse("帮我新建任务吧")
        assert result.success is True
        assert result.command == "create"

    def test_nested_synonym_match(self, tmp_path):
        patterns = {
            "commands": {
                "run": {
                    "keywords": {
                        "exact": ["run"],
                        "synonyms": ["运行任务", "执行任务"],
                        "fuzzy": ["开始做"],
                    }
                },
            }
        }
        f = tmp_path / "nlp_patterns.json"
        f.write_text(json.dumps(patterns, ensure_ascii=False))
        router = NLPRouter(f)
        result = router.parse("请执行任务 TASK-003")
        assert result.success is True
        assert result.command == "run"
        assert result.task_id == "TASK-003"

    def test_flat_keywords_still_work(self, nlp_patterns_file):
        """Backward compatibility: flat lists should still match."""
        router = NLPRouter(nlp_patterns_file)
        result = router.parse("new task please")
        assert result.success is True
        assert result.command == "create"
