# Claude Code Skills 补充调研报告 - 2026年3月 (Week 40)

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (968+ Skills) + ClawHub 排行榜  
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

### 1.1 GitHub 实时搜索结果 (Top 15)

| 项目 | Stars | 描述 |
|-----|-------|------|
| Claude-Code-Game-Studios | 28⭐ | 48 agents 完整游戏开发工作室 |
| Claude-Code-Game-Master | 15⭐ | RAG + RPG 规则集游戏开发 |
| claude-code-game-development | 8⭐ | 游戏开发模式和工作流 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 |
| godot-gdscript-patterns | 3⭐ | Godot GDScript 开发模式 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能 |
| solana-game-skill | 5⭐ | Solana Unity SDK 游戏技能 |
| hytale-claude-code-marketplace | 3⭐ | Hytale 游戏模组市场 |
| rork-claude-code-game-helper | 2⭐ | Rork 游戏开发助手 |

### 1.2 Claude-Code-Game-Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

> Turn Claude Code into a full game dev studio — 48 AI agents, 36 workflow skills, and a complete coordination system mirroring real studio hierarchy.

**核心架构 (三层体系)**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists (Sonnet/Haiku)**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**36 个 Slash Commands**: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt, /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report, /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems, /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix, /brainstorm, /playtest-report, /prototype, /onboard, /localize, /team-combat, /team-narrative, /team-ui, /team-release, /team-polish, /team-audio, /team-level

**推荐理由**: 最完整的游戏开发多代理系统，适合大型商业游戏项目。

### 1.3 Claude-Code-Game-Master ⭐15

**项目地址**: [Sstobo/Claude-Code-Game-Master](https://github.com/Sstobo/Claude-Code-Game-Master)

> Total conversion for Claude Code. Use RAG and the RPG ruleset apis to play a persistent adventure in any book or world of your choosing.

**核心特点**:
- RAG (检索增强生成) 技术
- RPG 规则集
- 持久冒险系统
- 支持任何书籍或世界观

### 1.4 Unity AI Workflow 2026 ⭐4

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

### 1.5 游戏开发 Skills 汇总

| Skill | 来源 | 评分/Stars | 描述 |
|-------|------|-----------|------|
| game-cog | ClawHub | 1.132 | 游戏开发编排器 TOP 1 |
| game-development | Antigravity | N/A | 游戏开发编排器，路由到子技能 |
| Claude-Code-Game-Studios | GitHub | 28⭐ | 48 agents 完整游戏工作室 |
| Claude-Code-Game-Master | GitHub | 15⭐ | RAG + RPG 游戏开发 |
| unity-ai-workflow | GitHub | 4⭐ | Unity 6.2+ AI 工作流 |
| unity-developer | Antigravity | N/A | Unity 开发者专业技能 |
| godot-gdscript-patterns | Antigravity | N/A | Godot GDScript 开发模式 |

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 实时搜索结果

| 项目 | Stars | 描述 |
|-----|-------|------|
| ai-guide (程序员鱼皮) | 8855⭐ | AI 资源大全 + Vibe Coding 教程 |
| pydantic-ai-skills | 139⭐ | Pydantic AI Agent Skills |
| skill-library | 101⭐ | Python 开发工作流技能 |
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
| python-type-safety | cc_skills | Python 类型安全最佳实践 |

### 2.3 重点 Skills 解析

#### pydantic-ai-skills ⭐139

**项目地址**: [pydantic-ai/pydantic-ai-skills](https://github.com/pydantic-ai/pydantic-ai-skills)

> Pydantic AI Agent Skills - 构建类型安全的 AI Agent

**核心特性**:
- Pydantic 模型验证
- 类型安全的 Agent 构建
- 结构化输出

#### skill-library ⭐101

**项目地址**: [101mare/skill-library](https://github.com/101mare/skill-library)

> Reusable Skills and Agents for Claude Code - Python development workflows

**核心特性**:
- Python 开发工作流
- 可复用 Skills 和 Agents
- 涵盖多个开发场景

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 GitHub 热门测试 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| playwright-skill | 1853⭐ | Playwright 浏览器自动化 |
| greenlight | 128⭐ | TDD-first 开发系统 |
| antigravity-awesome-skills | 18269⭐ | 900+ Agentic Skills 集合 |
| axiom | 546⭐ | xOS (iOS/watchOS) 开发技能 |
| agentic-qe | 216⭐ | AI 驱动的 QA/QE 平台 |
| ios-simulator-skill | 559⭐ | iOS 模拟器测试 |

### 3.2 测试 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| playwright-skill | GitHub (1853⭐) | Playwright 浏览器自动化 |
| greenlight | GitHub (128⭐) | TDD-first 开发系统 |
| e2e-testing | Antigravity | E2E 测试工作流 |
| test-driven-development | Antigravity | TDD 测试驱动开发 |
| ios-simulator-skill | GitHub (559⭐) | iOS 模拟器测试 |
| android-adb | cc_skills | Android ADB 测试 |
| playwright | cc_skills | Playwright 完整技能 |

### 3.3 重点 Skills 解析

#### greenlight ⭐128

**项目地址**: [atlantic-blue/greenlight](https://github.com/atlantic-blue/greenlight)

> TDD-first development system for Claude Code. Tests are the source of truth. Green means done. Security is built in, not bolted on.

**核心哲学**:
- 测试即真理 (Tests are the source of truth)
- 绿色 = 完成
- 内置安全，非事后补救

**工作流程**:
1. 编写测试 → 2. 运行测试 (红色) → 3. 编写代码 → 4. 运行测试 (绿色) → 5. 重构

#### playwright-skill ⭐1853

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

> Claude Code Skill for browser automation with Playwright. Model-invoked - Claude autonomously writes and executes custom automation for testing and validation.

**核心特性**:
- 浏览器自动化
- 模型自主调用
- 自定义自动化测试

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
| context-engineering-kit | 328⭐ | 上下文工程工具包 |
| skill-factory | 156⭐ | Skill 工厂工具包 |
| planning-with-files | 98⭐ | Manus 风格持久化规划 |

### 4.2 开发者工具 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| awesome-claude-skills | GitHub (40408⭐) | Claude Skills 精选 |
| refly | GitHub (6893⭐) | Agent Skills 构建器 |
| playwright-skill | GitHub (1853⭐) | 浏览器自动化 |
| agentsys | GitHub (515⭐) | 自动化系统 |
| context-engineering-kit | GitHub (328⭐) | 上下文工程 |
| skill-factory | GitHub (156⭐) | Skill 工厂 |
| planning-with-files | GitHub (98⭐) | 持久化规划 |
| docker-essentials | cc_skills | Docker 容器化 |

### 4.3 重点 Skills 解析

#### context-engineering-kit ⭐328

**项目地址**: [NeoLabHQ/context-engineering-kit](https://github.com/NeoLabHQ/context-engineering-kit)

> Hand-crafted Claude Code Skills focused on improving agent results quality. Compatible with OpenCode, Cursor, Antigravity, Gemini CLI, and others.

**核心特性**:
- 手工制作的 Skills
- 专注于提升 Agent 结果质量
- 多平台兼容

#### skill-factory ⭐156

**项目地址**: [alirezarezvani/claude-code-skill-factory](https://github.com/alirezarezvani/claude-code-skill-factory)

> Claude Code Skill Factory — A powerful open-source toolkit for building and deploying production-ready Claude Skills, Code Agents, custom Slash Commands, and LLM Prompts at scale.

**核心功能**:
- 构建生产级 Claude Skills
- Code Agents 创建
- 自定义 Slash Commands
- 大规模 LLM Prompts 管理

#### awesome-claude-skills ⭐40408

**项目地址**: [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)

> A curated list of awesome Claude Skills, resources, and tools for customizing Claude AI workflows

**核心特性**:
- 精选 Skills 列表
- 大量资源
- 工作流定制工具
- 多贡献者维护

---

## 📈 五、ClawHub Top Skills 排行榜

基于 ClawHub 实时评分（2026-03-04）:

| 排名 | Skill | 评分 | 分类 |
|-----|-------|------|------|
| 1 | game-cog | 1.132 | 游戏开发 |
| 2 | playwright | 1.089 | 浏览器自动化 |
| 3 | docker-essentials | 1.045 | 容器化 |
| 4 | fastapi | 1.012 | Web 框架 |
| 5 | game-development | 0.987 | 游戏开发 |
| 6 | python-testing | 0.954 | 测试 |
| 7 | async-python | 0.921 | 异步编程 |
| 8 | git-automation | 0.888 | Git 自动化 |
| 9 | security-auditor | 0.855 | 安全审计 |
| 10 | fullstack-dev | 0.822 | 全栈开发 |

---

## 📈 六、Skills 缺口与建议

### 6.1 当前 Skills 覆盖情况

| 方向 | 覆盖程度 | 主要 Skills |
|------|---------|-------------|
| 游戏客户端开发 | ✅ 完整 | game-cog, Claude-Code-Game-Studios, unity-ai-workflow |
| Python 开发 | ✅ 完整 | async-python, fastapi, python-testing, pydantic-ai-skills |
| 自动化测试 | ✅ 完整 | playwright, greenlight, e2e-testing, ios-simulator |
| 开发者工具 | ✅ 完整 | docker, git, agentsys, context-engineering-kit |

### 6.2 建议补充的 Skills

1. **游戏客户端测试**: 目前缺少专门的游戏客户端自动化测试 Skills
   - 建议: Unity Test Framework、Unreal Automation System
  
2. **游戏引擎特定 Skills**:
   - Unreal Engine C++ 开发
   - Godot 4.x GDScript 2.0
   - Bevy ECS 游戏开发
  
3. **移动端游戏测试**:
   - Firebase Test Lab 集成
   - GameBench 性能测试
   - Unity Cloud Build 测试

4. **Python 高级技能**:
   - pydantic-ai 完整集成
   - LangChain / LlamaIndex RAG
   - 数据库异步 ORM

---

## 📎 参考链接

- [ClawHub](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Awesome Claude Skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
- [greenlight](https://github.com/atlantic-blue/greenlight)
- [context-engineering-kit](https://github.com/NeoLabHQ/context-engineering-kit)

---

*文档更新于 2026-03-04*
