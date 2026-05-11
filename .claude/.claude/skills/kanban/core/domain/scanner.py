"""
Project Scanner — 在 kanban init 时分析项目已有 agent/skills/基础设施。

检测维度:
1. Agent 冲突检测 — 项目自有的 agent 与 kanban 默认 agent 合并建议
2. Skills 关联分析 — 项目已有的 skills
3. 语言/框架基建 — Python/JS/TS/Go 等项目所需工具
4. 领域特定基建 — 游戏/Web/CLI 等领域所需工具
"""

from __future__ import annotations
from dataclasses import dataclass, field
from pathlib import Path


KANBAN_DEFAULT_AGENTS = [
    "kanban-planner",
    "kanban-executor",
    "kanban-code-reviewer",
    "kanban-designer",
    "kanban-pm",
    "kanban-qa",
    "kanban-researcher",
    "kanban-knowledge-manager",
    "kanban-plan-reviewer",
    "kanban-test-spec-reviewer",
]

KANBAN_SKILL_NAME = "kanban"


@dataclass
class AgentConflict:
    role: str
    kanban_agent: str
    project_agent_file: str
    action: str  # "merge" | "replace" | "keep_both"
    description: str


@dataclass
class InfrastructureGap:
    category: str  # "language" | "domain" | "testing" | "linting"
    tool: str
    config_file: str
    detected: bool
    suggestion: str


@dataclass
class ScanReport:
    project_root: str
    language: str = "unknown"
    has_kanban: bool = False
    agent_conflicts: list[AgentConflict] = field(default_factory=list)
    existing_skills: list[str] = field(default_factory=list)
    infrastructure_gaps: list[InfrastructureGap] = field(default_factory=list)
    recommendations: list[str] = field(default_factory=list)


def scan_project(root: Path) -> ScanReport:
    report = ScanReport(project_root=str(root))

    report.language = _detect_language(root)
    report.has_kanban = (root / ".kanban").exists()
    report.agent_conflicts = _detect_agent_conflicts(root)
    report.existing_skills = _detect_skills(root)
    report.infrastructure_gaps = _detect_infrastructure_gaps(root, report.language)
    report.recommendations = _generate_recommendations(report)

    return report


def _detect_language(root: Path) -> str:
    indicators = {
        "python": ["pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile"],
        "typescript": ["tsconfig.json"],
        "javascript": ["package.json", "package-lock.json", "yarn.lock"],
        "go": ["go.mod", "go.sum"],
        "rust": ["Cargo.toml"],
    }
    scores = {}
    for lang, files in indicators.items():
        scores[lang] = sum(1 for f in files if (root / f).exists())

    if any(scores.values()):
        return max(scores, key=scores.get)  # type: ignore[arg-type]

    # Fallback: scan top-level source files
    for f in root.iterdir():
        if f.is_file() and f.suffix in (".py",):
            return "python"
        if f.is_file() and f.suffix in (".js", ".jsx"):
            return "javascript"
        if f.is_file() and f.suffix in (".ts", ".tsx"):
            return "typescript"
        if f.is_file() and f.suffix == ".go":
            return "go"
    return "unknown"


def _detect_agent_conflicts(root: Path) -> list[AgentConflict]:
    agents_dir = root / ".claude" / "agents"
    if not agents_dir.exists():
        return []

    conflicts = []
    kanban_role_map = {
        "planner": "kanban-planner",
        "executor": "kanban-executor",
        "code-reviewer": "kanban-code-reviewer",
        "designer": "kanban-designer",
        "pm": "kanban-pm",
        "qa": "kanban-qa",
        "researcher": "kanban-researcher",
        "knowledge-manager": "kanban-knowledge-manager",
    }

    for agent_file in agents_dir.glob("*.md"):
        if agent_file.is_symlink():
            try:
                target = agent_file.resolve()
                # Path-based check: works on both Unix (/) and Windows (\)
                target_parts = [p.lower() for p in target.parts]
                if "kanban" in target_parts and "agents" in target_parts:
                    continue
            except OSError:
                continue

        name = agent_file.stem
        if name.startswith("kanban-"):
            continue

        if name in kanban_role_map:
            conflicts.append(AgentConflict(
                role=name,
                kanban_agent=kanban_role_map[name],
                project_agent_file=str(agent_file.relative_to(root)),
                action="merge",
                description=f"项目已有 {name} agent，建议与 kanban 默认 {kanban_role_map[name]} 合并",
            ))

    return conflicts


def _detect_skills(root: Path) -> list[str]:
    skills_dir = root / ".claude" / "skills"
    if not skills_dir.exists():
        return []

    skills = []
    for skill_dir in skills_dir.iterdir():
        if skill_dir.is_dir() and skill_dir.name != KANBAN_SKILL_NAME:
            skill_file = skill_dir / "SKILL.md"
            if skill_file.exists():
                skills.append(skill_dir.name)
    return sorted(skills)


def _detect_infrastructure_gaps(root: Path, language: str) -> list[InfrastructureGap]:
    gaps = []

    if language == "python":
        gaps.extend(_check_python_infra(root))
    elif language in ("javascript", "typescript"):
        gaps.extend(_check_js_infra(root))
    elif language == "go":
        gaps.extend(_check_go_infra(root))

    gaps.extend(_check_domain_infra(root, language))
    return gaps


def _check_python_infra(root: Path) -> list[InfrastructureGap]:
    gaps = []
    has_pyproject = (root / "pyproject.toml").exists()

    if not (root / ".pylintrc").exists() and not has_pyproject:
        gaps.append(InfrastructureGap(
            category="linting", tool="pylint",
            config_file=".pylintrc",
            detected=False,
            suggestion="建议添加 pylint 配置以进行代码静态分析",
        ))

    if not (root / "pytest.ini").exists() and not (root / "setup.cfg").exists() and not has_pyproject:
        gaps.append(InfrastructureGap(
            category="testing", tool="pytest",
            config_file="pytest.ini",
            detected=False,
            suggestion="建议添加 pytest 配置以进行单元测试",
        ))

    if not (root / ".coveragerc").exists() and not has_pyproject:
        gaps.append(InfrastructureGap(
            category="testing", tool="coverage",
            config_file=".coveragerc",
            detected=False,
            suggestion="建议添加 coverage 配置以追踪测试覆盖率",
        ))

    return gaps


def _check_js_infra(root: Path) -> list[InfrastructureGap]:
    gaps = []
    pkg = root / "package.json"

    if pkg.exists():
        import json
        try:
            data = json.loads(pkg.read_text(encoding="utf-8"))
            dev_deps = {**data.get("devDependencies", {}), **data.get("dependencies", {})}

            if "eslint" not in dev_deps:
                gaps.append(InfrastructureGap(
                    category="linting", tool="eslint",
                    config_file=".eslintrc.*",
                    detected=False,
                    suggestion="建议添加 ESLint 配置以进行代码规范检查",
                ))

            if "jest" not in dev_deps and "vitest" not in dev_deps and "mocha" not in dev_deps:
                gaps.append(InfrastructureGap(
                    category="testing", tool="jest",
                    config_file="jest.config.*",
                    detected=False,
                    suggestion="建议添加测试框架配置（Jest/Vitest）",
                ))
        except (json.JSONDecodeError, OSError):
            pass

    return gaps


def _check_go_infra(root: Path) -> list[InfrastructureGap]:
    gaps = []
    if not (root / ".golangci.yml").exists():
        gaps.append(InfrastructureGap(
            category="linting", tool="golangci-lint",
            config_file=".golangci.yml",
            detected=False,
            suggestion="建议添加 golangci-lint 配置以进行代码质量检查",
        ))
    return gaps


def _check_domain_infra(root: Path, language: str) -> list[InfrastructureGap]:
    gaps = []
    cfg = root / ".kanban" / "config.json"
    output_dir = "src"
    if cfg.exists():
        import json
        try:
            data = json.loads(cfg.read_text(encoding="utf-8"))
            output_dir = data.get("output_dir", "src")
        except (json.JSONDecodeError, OSError):
            pass

    games_dir = root / "games"
    if output_dir == "games" or games_dir.exists():
        found_gm = False
        for sub in (games_dir if games_dir.exists() else root).iterdir():
            if sub.is_dir():
                for f in sub.rglob("gm*.py"):
                    found_gm = True
                    break
                for f in sub.rglob("gm*.js"):
                    found_gm = True
                    break

        if not found_gm:
            gaps.append(InfrastructureGap(
                category="domain", tool="gm_commands",
                config_file="gm_commands.py",
                detected=False,
                suggestion="游戏项目建议添加 GM 指令系统，方便 QA 调测（如创建 gm_commands.py/j模块，包含常用调试指令）",
            ))

    return gaps


def _generate_recommendations(report: ScanReport) -> list[str]:
    recs = []

    if report.agent_conflicts:
        conflict_roles = [c.role for c in report.agent_conflicts]
        recs.append(f"检测到 {len(report.agent_conflicts)} 个 agent 冲突: {', '.join(conflict_roles)}，建议合并到 kanban agent")

    if report.existing_skills:
        recs.append(f"检测到 {len(report.existing_skills)} 个自定义 skills: {', '.join(report.existing_skills)}")

    missing = [g for g in report.infrastructure_gaps if not g.detected]
    if missing:
        tools = [m.tool for m in missing]
        recs.append(f"缺少 {len(missing)} 项基础设施: {', '.join(tools)}，建议补充")

    if not report.has_kanban:
        recs.append("项目尚未初始化 kanban，运行 /kanban init 完成初始化")

    return recs
