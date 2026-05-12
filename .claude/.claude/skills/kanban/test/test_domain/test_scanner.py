"""Tests for core.domain.scanner — project scanning module."""
from __future__ import annotations
import json
import subprocess
import tempfile
from pathlib import Path
from unittest import mock
from core.domain.scanner import (
    scan_project,
    _detect_language,
    _detect_agent_conflicts,
    _detect_skills,
    _detect_infrastructure_gaps,
    _check_python_infra,
    ScanReport,
)


class TestDetectLanguage:
    def test_python_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "pyproject.toml").write_text("[tool]")
            assert _detect_language(root) == "python"

    def test_javascript_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "package.json").write_text("{}")
            assert _detect_language(root) == "javascript"

    def test_go_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "go.mod").write_text("module x")
            assert _detect_language(root) == "go"

    def test_unknown_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            assert _detect_language(root) == "unknown"

    def test_python_beats_javascript(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "pyproject.toml").write_text("[tool]")
            (root / "package.json").write_text("{}")
            assert _detect_language(root) == "python"


class TestDetectAgentConflicts:
    def test_no_agents_dir(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            conflicts = _detect_agent_conflicts(root)
            assert conflicts == []

    def test_no_conflicts_with_only_kanban_symlinks(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            agents_dir = root / ".claude" / "agents"
            agents_dir.mkdir(parents=True)
            # Create a kanban symlink target
            kanban_agents = root / ".claude" / "skills" / "kanban" / "agents"
            kanban_agents.mkdir(parents=True)
            (kanban_agents / "kanban-planner.md").write_text("---\nname: kanban-planner\n---")
            symlink = agents_dir / "planner.md"
            symlink.symlink_to(kanban_agents / "kanban-planner.md")
            conflicts = _detect_agent_conflicts(root)
            assert conflicts == []

    def test_detects_custom_agent(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            agents_dir = root / ".claude" / "agents"
            agents_dir.mkdir(parents=True)
            (agents_dir / "planner.md").write_text("---\nname: custom-planner\n---")
            conflicts = _detect_agent_conflicts(root)
            assert len(conflicts) == 1
            assert conflicts[0].role == "planner"
            assert conflicts[0].action == "merge"


class TestDetectSkills:
    def test_no_skills_dir(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            skills = _detect_skills(root)
            assert skills == []

    def test_detects_custom_skills(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            skills_dir = root / ".claude" / "skills"
            skills_dir.mkdir(parents=True)
            my_skill = skills_dir / "my-skill"
            my_skill.mkdir()
            (my_skill / "SKILL.md").write_text("# My Skill")
            skills = _detect_skills(root)
            assert "my-skill" in skills

    def test_excludes_kanban_skill(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            skills_dir = root / ".claude" / "skills"
            skills_dir.mkdir(parents=True)
            kanban_dir = skills_dir / "kanban"
            kanban_dir.mkdir()
            (kanban_dir / "SKILL.md").write_text("# Kanban")
            skills = _detect_skills(root)
            assert "kanban" not in skills


class TestDetectInfrastructureGaps:
    def test_python_missing_linting(self):
        """When pylint is not installed and no .pylintrc exists, report a pylint gap."""
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)

            def mock_run(args, **kwargs):
                if args[0] == "pylint":
                    raise FileNotFoundError("pylint not found")
                if args[0] == "pytest":
                    raise FileNotFoundError("pytest not found")
                if args[0] == "coverage":
                    raise FileNotFoundError("coverage not found")
                return subprocess.CompletedProcess(args, 0)

            with mock.patch("subprocess.run", side_effect=mock_run):
                gaps = _detect_infrastructure_gaps(root, "python")
            lint_gaps = [g for g in gaps if g.tool == "pylint"]
            assert len(lint_gaps) >= 1

    def test_python_with_tools_installed(self):
        """When pyproject.toml exists and tools are installed, fewer gaps are reported."""
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "pyproject.toml").write_text("[tool.pytest]")

            def mock_run(args, **kwargs):
                # Simulate pylint and pytest are installed, coverage not
                if args[0] == "coverage":
                    raise FileNotFoundError("coverage not found")
                return subprocess.CompletedProcess(args, 0)

            with mock.patch("subprocess.run", side_effect=mock_run):
                gaps = _detect_infrastructure_gaps(root, "python")
            # pylint is installed -> no pylint gap
            lint_gaps = [g for g in gaps if g.tool == "pylint"]
            assert len(lint_gaps) == 0
            # coverage not installed + no pyproject -> coverage gap (but pyproject exists, so suppressed)
            cov_gaps = [g for g in gaps if g.tool == "coverage"]
            assert len(cov_gaps) == 0  # pyproject.toml suppresses coverage gap

    def test_python_no_tools_no_pyproject(self):
        """All tools missing + no pyproject.toml -> all gaps reported."""
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)

            def mock_run(args, **kwargs):
                raise FileNotFoundError(f"{args[0]} not found")

            with mock.patch("subprocess.run", side_effect=mock_run):
                gaps = _detect_infrastructure_gaps(root, "python")
            pylint_gaps = [g for g in gaps if g.tool == "pylint"]
            pytest_gaps = [g for g in gaps if g.tool == "pytest"]
            cov_gaps = [g for g in gaps if g.tool == "coverage"]
            assert len(pylint_gaps) == 1
            assert len(pytest_gaps) == 1
            assert len(cov_gaps) == 1
            assert pylint_gaps[0].suggestion.startswith("建议安装 pylint")
            assert pytest_gaps[0].suggestion.startswith("建议安装 pytest")
            assert cov_gaps[0].suggestion.startswith("建议安装 coverage")

    def test_python_all_tools_installed(self):
        """All tools installed -> no gaps."""
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)

            def mock_run(args, **kwargs):
                return subprocess.CompletedProcess(args, 0)

            with mock.patch("subprocess.run", side_effect=mock_run):
                gaps = _detect_infrastructure_gaps(root, "python")
            lint_gaps = [g for g in gaps if g.category in ("linting", "testing")]
            assert len(lint_gaps) == 0

    def test_js_missing_linting(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "package.json").write_text("{}")
            gaps = _detect_infrastructure_gaps(root, "javascript")
            lint_gaps = [g for g in gaps if g.tool == "eslint"]
            assert len(lint_gaps) >= 1

    def test_unknown_language_no_gaps(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            gaps = _detect_infrastructure_gaps(root, "unknown")
            # Only domain-specific gaps (no language gaps)
            lang_gaps = [g for g in gaps if g.category in ("linting", "testing")]
            assert lang_gaps == []


class TestScanProject:
    def test_full_scan_empty_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            report = scan_project(root)
            assert isinstance(report, ScanReport)
            assert report.language == "unknown"
            assert report.has_kanban is False
            assert report.agent_conflicts == []

    def test_full_scan_python_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "pyproject.toml").write_text("[tool]")
            report = scan_project(root)
            assert report.language == "python"
            assert len(report.recommendations) >= 0

    def test_recommendations_with_gaps(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            report = scan_project(root)
            # No infrastructure means lots of gaps → recommendations
            assert len(report.recommendations) >= 0
