# Claude Code Skills 补充调研报告 - 2026年3月 (Week 39)

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (900+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 新增调研

---

## 📊 调研概要

本次调研基于 GitHub API 实时搜索获取的最新热门 Claude Code Skills，持续关注以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/CI/CD/代码审查)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 GitHub 实时搜索结果 (Top 10)

| 项目 | Stars | 描述 |
|-----|-------|------|
| Claude-Code-Game-Studios | 28⭐ | 48 agents 完整游戏开发工作室 |
| skills-weaver | 15⭐ | RPG 风格 Claude Code 技能 |
| love2d-pocket-bomber-game | 11⭐ | Love2D 游戏开发技能 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能 |
| solana-game-skill | 5⭐ | Solana Unity SDK 游戏技能 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 |
| hytale-claude-code-marketplace | 3⭐ | Hytale 游戏模组市场 |
| claude-resources | 3⭐ | Godot 游戏开发资源 |
| game-day-dashboard | 2⭐ | 体育比分看板技能 |
| gamemaker-skills | 2⭐ | GameMaker Studio 2 技能 |

### 1.2 Claude Code Game Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

> Turn Claude Code into a full game dev studio — 48 AI agents, 36 workflow skills, and a complete coordination system mirroring real studio hierarchy.

**核心架构 (三层体系)**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists (Sonnet/Haiku)**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**36 个 Slash Commands**: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt, /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report, /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems, /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix, /brainstorm, /playtest-report, /prototype, /onboard, /localize, /team-combat, /team-narrative, /team-ui, /team-release, /team-polish, /team-audio, /team-level

**推荐理由**: 最完整的游戏开发多代理系统，适合大型商业游戏项目。

---

### 1.3 Unity AI Workflow 2026 ⭐4

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

> AI-first Unity 6.2+ game development workflow

**核心哲学**: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

**Dev Modes (三种开发模式)**:
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、game jam |

**TCREI Prompting**: Task-Context-References-Evaluate-Iterate 方法论

---

### 1.4 游戏开发 Skills 汇总

| Skill | 来源 | 评分/Stars | 描述 |
|-------|------|-----------|------|
| game-development | Antigravity | N/A | 游戏开发编排器，路由到子技能 |
| game-cog | ClawHub | 1.132 | 游戏开发编排器 TOP 1 |
| unity-developer | Antigravity | N/A | Unity 开发者专业技能 |
| Claude-Code-Game-Studios | GitHub | 28⭐ | 48 agents 完整游戏工作室 |
| unity-ai-workflow | GitHub | 4⭐ | Unity 6.2+ AI 工作流 |

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 实时搜索结果

| 项目 | Stars | 描述 |
|-----|-------|------|
| ai-guide (程序员鱼皮) | 8855⭐ | AI 资源大全 + Vibe Coding 教程 |
| pydantic-ai-skills | 139⭐ | Pydantic AI Agent Skills |
| developer-kit | 132⭐ | 多语言开发工具包 |
| python-rope-refactor | 36⭐ | Python 代码重构技能 |
| claude-skills-collection-2026 | 23⭐ | 2026 完整技能集合 |

### 2.2 Python 开发 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| async-python-patterns | Antigravity | 异步 Python 模式 |
| python-testing-patterns | Antigravity | Python 测试模式 |
| python-rope-refactor | GitHub | Python 代码重构 |
| dbos-python | Antigravity | DBOS Python 框架 |
| temporal-python-pro | Antigravity | Temporal Python 工作流 |
| fastapi | cc_skills | FastAPI 开发技能 |

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 GitHub 热门测试 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| playwright-skill | 1853⭐ | Playwright 浏览器自动化 |
| antigravity-awesome-skills | 18898⭐ | 900+ Agentic Skills 集合 |
| axiom | 546⭐ | xOS (iOS/watchOS) 开发技能 |
| agentic-qe | 216⭐ | AI 驱动的 QA/QE 平台 |
| ios-simulator-skill | 559⭐ | iOS 模拟器测试 |

### 3.2 测试 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| playwright-skill | GitHub (1853⭐) | Playwright 浏览器自动化 |
| e2e-testing | Antigravity | E2E 测试工作流 |
| test-driven-development | Antigravity | TDD 测试驱动开发 |
| ios-simulator-skill | GitHub (559⭐) | iOS 模拟器测试 |
| android-adb | cc_skills | Android ADB 测试 |

---

## 🔧 四、开发者工具 Skills

### 4.1 GitHub 热门开发者工具 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| awesome-claude-skills | 40408⭐ | Claude Skills 精选列表 |
| refly | 6893⭐ | 开源 Agent Skills 构建器 |
| notebooklm-skill | 4064⭐ | Google NotebookLM 集成 |
| claude-code-plugins-plus-skills | 1498⭐ | 270+ 插件，739 Skills |
| agentsys | 515⭐ | 自动化系统 14插件/43agents/30skills |

### 4.2 开发者工具 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| awesome-claude-skills | GitHub (40408⭐) | Claude Skills 精选 |
| refly | GitHub (6893⭐) | Agent Skills 构建器 |
| playwright-skill | GitHub (1853⭐) | 浏览器自动化 |
| agentsys | GitHub (515⭐) | 自动化系统 |
| docker-essentials | cc_skills | Docker 容器化 |

---

## 📈 五、Skills 缺口与建议

### 5.1 当前 Skills 覆盖情况

| 方向 | 覆盖程度 | 主要 Skills |
|------|---------|-------------|
| 游戏客户端开发 | ✅ 完整 | game-cog, Claude-Code-Game-Studios, unity-ai-workflow |
| Python 开发 | ✅ 完整 | async-python, fastapi, python-testing |
| 自动化测试 | ✅ 完整 | playwright, e2e-testing, ios-simulator |
| 开发者工具 | ✅ 完整 | docker, git, agentsys |

### 5.2 建议补充的 Skills

1. **游戏客户端测试**: 目前缺少专门的游戏客户端自动化测试 Skills
2. **游戏引擎特定测试**: Unity Test Framework、Unreal Automation System
3. **移动端游戏测试**: Firebase Test Lab、GameBench

---

## 📎 参考链接

- [ClawHub](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Awesome Claude Skills](https://github.com/ComposioHQ/awesome-claude-skills)

---

*文档更新于 2026-03-04*
