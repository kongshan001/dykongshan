# Claude Code Skills 补充调研报告 - 2026年3月 (Week 41)

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (900+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 持续调研更新

---

## 📊 调研概要

本次调研基于 GitHub API 实时搜索和 Antigravity Awesome Skills 仓库获取的最新热门 Skills，持续关注以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/CI/CD/GitHub 自动化)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 GitHub 实时搜索结果 (Top 10)

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| Claude-Code-Game-Studios | 28⭐ | 48 agents 完整游戏开发工作室，36 workflow skills | 2026-03-03 |
| skills-weaver | 15⭐ | RPG 角色扮演游戏 Claude Code Agent SDK | 2026-02-28 |
| love2d-pocket-bomber-game | 11⭐ | 使用 Claude Code 和 Love2D vibe coding Bomberman clone | 2026-02-23 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能集 | 2026-02-15 |
| solana-game-skill | 5⭐ | Solana Unity SDK 游戏技能 | 2026-02-21 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 | 2026-02-18 |
| hytale-claude-code-marketplace | 3⭐ | Hytale 游戏 MOD 市场的 Claude Code 插件和 Skills | 2026-01-28 |
| claude-resources | 3⭐ | Godot 游戏开发自定义 agents 和 skills | 2026-02-03 |
| gamemaker-skills | 2⭐ | GameMaker Studio 2 和 GML 开发技能 | 2026-02-06 |
| se-dev-skills | 2⭐ | Space Engineers 插件、MOD 和游戏脚本开发技能库 | 2026-02-11 |

### 1.2 Antigravity 游戏开发 Skills 深度分析

#### 1.2.1 game-development (编排器) ⭐⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/game-development`

> 游戏开发编排器，根据项目需求路由到平台特定技能。

**子技能路由表**:

| 游戏目标平台 | 使用子技能 |
|-------------|-----------|
| Web 浏览器 (HTML5, WebGL) | `game-development/web-games` |
| 移动端 (iOS, Android) | `game-development/mobile-games` |
| PC (Steam, Desktop) | `game-development/pc-games` |
| VR/AR 头显 | `game-development/vr-ar` |

**核心原则**:
- 游戏循环模式：INPUT → UPDATE (固定时间步) → RENDER (插值)
- 模式选择矩阵：状态机 → 对象池 → 观察者 → ECS → 命令 → 行为树

**推荐理由**: 入门游戏开发的首选技能，提供完整的学习路径和最佳实践。

#### 1.2.2 unity-developer ⭐⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/unity-developer`

> 构建 Unity 游戏，优化 C# 脚本，高效渲染，proper asset management。掌握 Unity 6 LTS、URP/HDRP 管道和跨平台部署。

**核心能力**:
- Unity 6 LTS 特性与长期支持
- URP/HDRP 渲染管道优化
- 性能优化 (Profiler, Frame Debugger, Memory Profiler)
- DOTS/ECS 架构与 Job System
- 跨平台构建优化

**适用场景**:
- Unity 游戏开发任务和工作流
- 需要 Unity 开发和最佳实践指导

#### 1.2.3 unity-ecs-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/unity-ecs-patterns`

> Unity DOTS/ECS 开发模式和最佳实践。

**核心内容**:
- Entity Component System 架构
- Burst Compiler 优化
- Job System 多线程编程
- 数据导向设计模式

#### 1.2.4 unreal-engine-cpp-pro ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/unreal-engine-cpp-pro`

> Unreal Engine C++ 专业开发技能，覆盖游戏框架、内存管理、网络同步和性能优化。

#### 1.2.5 godot-gdscript-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/godot-gdscript-patterns`

> Godot 4 GDScript 开发模式和最佳实践。

#### 1.2.6 godot-4-migration ⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/godot-4-migration`

> Godot 3 到 Godot 4 迁移指南。

### 1.3 GitHub 热点项目详解

#### 1.3.1 Claude-Code-Game-Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

> 🚀 Turn Claude Code into a full game dev studio — 48 AI agents, 36 workflow skills, and a complete coordination system mirroring real studio hierarchy.

**核心架构 (三层体系)**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists (Sonnet/Haiku)**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**36 个 Slash Commands**: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt, /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report, /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems, /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix, /brainstorm, /playtest-report, /prototype, /onboard, /localize, /team-combat, /team-narrative, /team-ui, /team-release, /team-polish, /team-audio, /team-level

**推荐理由**: 最完整的游戏开发多代理系统，适合大型商业游戏项目。

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 实时搜索结果 (Top 10)

| 项目 | Stars | 描述 |
|-----|-------|------|
| liyupi/ai-guide | 8884⭐ | 程序员鱼皮 AI 资源大全，含 Claude Code 教程 |
| jlevy/repren | 370⭐ | 强大重命名/重构工具，支持 Claude Code skill |
| Mng-dev-ai/claudex | 223⭐ | 自定义 Claude Code UI，支持 custom skills |
| giuseppe-trisciuoglio/developer-kit | 132⭐ | 多语言开发工具包，含 Python/TypeScript/Java |
| existential-birds/beagle | 35⭐ | Python/Go/FastAPI 代码审查技能和验证工作流 |
| borghei/Claude-Skills | 17⭐ | 97 个专家 AI Skills，178 个 Python 工具 |
| majiayu000/claude-arsenal | 9⭐ | 39+ 战斗测试 Claude Code skills |

### 2.2 Antigravity Python 开发 Skills 深度分析

####.1 python-fast 2.2api-development ⭐⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-fastapi-development`

> Python FastAPI 后端开发，包含 async patterns, SQLAlchemy, Pydantic, authentication 和生产级 API 模式。

**工作流阶段**:

1. **Phase 1: 项目设置**
   - 使用 uv/poetry 设置 Python 环境
   - 创建项目结构
   - 配置 FastAPI 应用
   - 设置日志和环境变量

2. **Phase 2: 数据库设置**
   - 设计数据库 schema
   - 设置 SQLAlchemy models
   - 配置 Alembic migrations
   - 设置 session 管理

3. **Phase 3: API Routes**
   - FastAPI routers
   - API 设计原则
   - 错误处理和验证

**推荐理由**: Python Web 开发首选技能，覆盖完整开发流程。

#### 2.2.2 python-development-python-scaffold ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-development-python-scaffold`

> Python 项目脚手架和标准项目结构。

#### 2.2.3 python-pro ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-pro`

> 专业 Python 开发技能，涵盖高级模式和最佳实践。

#### 2.2.4 python-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-patterns`

> Python 设计模式和惯用法。

#### 2.2.5 async-python-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/async-python-patterns`

> Python 异步编程模式和最佳实践。

**核心内容**:
- asyncio 基础和高级用法
- async/await 模式
- 并发和并行处理
- 异步数据库操作
- 异步 HTTP 请求

#### 2.2.6 python-testing-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-testing-patterns`

> Python 测试模式和最佳实践。

#### 2.2.7 python-performance-optimization ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-performance-optimization`

> Python 性能优化技能。

#### 2.2.8 python-packaging ⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/python-packaging`

> Python 包打包和发布。

#### 2.2.9 temporal-python-pro ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/temporal-python-pro`

> Temporal Python 专业开发，工作流编排。

#### 2.2.10 temporal-python-testing ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/temporal-python-testing`

> Temporal Python 测试模式。

#### 2.2.11 dbos-python ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/dbos-python`

> DBOS (Database-Oriented Operating System) Python 开发。

### 2.3 热点项目详解

#### 2.3.1 existential-birds/beagle ⭐35

**项目地址**: [existential-birds/beagle](https://github.com/existential-birds/beagle)

> Claude Code plugin for code review skills and verification workflows. Python, Go, React, FastAPI, BubbleTea, and AI frameworks (Pydantic AI, LangGraph, Vercel AI SDK).

**核心功能**:
- 代码审查技能
- 验证工作流
- 多语言支持 (Python, Go, React)
- FastAPI 最佳实践
- Pydantic AI, LangGraph 集成

#### 2.3.2 borghei/Claude-Skills ⭐17

**项目地址**: [borghei/Claude-Skills](https://github.com/borghei/Claude-Skills)

> 97 Expert AI Skills for Every AI Coding Assistant — Production-ready frameworks, 178 Python tools, 12 CI/CD workflows.

**核心内容**:
- 97 个专家级 AI Skills
- 178 个 Python 工具
- 12 个 CI/CD 工作流
- 多平台支持 (Claude, Cursor, Copilot, Codex, Windsurf, Cline, Aider)

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 GitHub 实时搜索结果 (Top 10)

| 项目 | Stars | 描述 |
|-----|-------|------|
| lackeyjb/playwright-skill | 1855⭐ | Playwright 浏览器自动化，Claude 自主编写执行测试 |
| dalbit-mir/playwright-undetected-skill | 4⭐ | 反机器人检测 bypass，Patchright-based |
| akaihola/playwright-py-skill | 1⭐ | Python 版 Playwright skill |
| MateiMiron/ai-playwright-automation | 0⭐ | AI 驱动 Playwright 测试套件，74 tests |
| mrchevyceleb/edgetest-skill | 0⭐ | 边界案例测试，自动修复和生产部署 |
| SecurityRonin/ronin-marketplace | 0⭐ | 战斗测试 skills，浏览器自动化 |

### 3.2 Antigravity 测试 Skills 深度分析

#### 3.2.1 e2e-testing ⭐⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/e2e-testing`

> 端到端测试工作流，使用 Playwright 进行浏览器自动化、视觉回归、跨浏览器测试和 CI/CD 集成。

**工作流阶段**:

1. **Phase 1: 测试设置**
   - 安装 Playwright
   - 配置测试框架
   - 设置测试目录
   - 配置浏览器

2. **Phase 2: 测试设计**
   - 识别关键流程
   - 设计测试场景
   - 规划测试数据
   - 创建页面对象

3. **Phase 3: 测试实现**
   - 编写测试脚本
   - 添加断言
   - 实现等待
   - 处理动态内容

**推荐理由**: E2E 测试首选技能，覆盖完整测试流程。

#### 3.2.2 playwright-skill ⭐⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/playwright-skill` (参考 lackeyjb 版本)

> Playwright 浏览器自动化，Model-invoked - Claude 自主编写和执行自定义自动化进行测试和验证。

**核心能力**:
- 浏览器自动化
- 页面交互
- 截图和视频录制
- 网络请求拦截
- 移动端测试

#### 3.2.3 e2e-testing-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/e2e-testing-patterns`

> E2E 测试模式集合。

#### 3.2.4 test-automator ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/test-automator`

> 测试自动化工具。

#### 3.2.5 test-driven-development ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/test-driven-development`

> TDD 测试驱动开发。

#### 3.2.6 test-fixing ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/test-fixing>

> 测试修复技能。

#### 3.2.7 testing-patterns ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/testing-patterns>

> 测试模式集合。

#### 3.2.8 testing-qa ⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/testing-qa>

> QA 测试和质量保证。

#### 3.2.9 webapp-testing ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/webapp-testing>

> Web 应用测试。

#### 3.2.10 unit-testing-test-generate ⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/unit-testing-test-generate>

> 单元测试生成。

#### 3.2.11 api-testing-observability-api-mock ⭐⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/api-testing-observability-api-mock>

> API 测试和可观测性。

#### 3.2.12 javascript-testing-patterns ⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/javascript-testing-patterns>

> JavaScript 测试模式。

#### 3.2.13 bats-testing-patterns ⭐⭐⭐

**Skill 路径**: `antigravity-awesome-skills/skills/bats-testing-patterns>

> BATS shell 测试模式。

### 3.3 热点项目详解

#### 3.3.1 lackeyjb/playwright-skill ⭐1855

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

> Claude Code Skill for browser automation with Playwright. Model-invoked - Claude autonomously writes and executes custom automation for testing and validation.

**核心特点**:
- 模型驱动：Claude 自主编写测试代码
- 无需预设脚本
- 灵活的测试场景
- 支持复杂交互

**推荐理由**: 最流行的 Playwright 测试技能，1,855 stars 证明其价值。

#### 3.3.2 MateiMiron/ai-playwright-automation ⭐NEW

**项目地址**: [MateiMiron/ai-playwright-automation](https://github.com/MateiMiron/ai-playwright-automation)

> AI-driven Playwright test suite generated entirely by Claude Code agents — 74 tests, zero manual code.

**核心特点**:
- 完全由 AI 生成测试
- 74 个测试用例
- Explore > Plan > Generate > Heal 工作流
- 自愈能力

---

## 🛠️ 四、开发者工具 Skills

### 4.1 GitHub 实时搜索结果 (Top 10)

| 项目 | Stars | 描述 |
|-----|-------|------|
| everything-claude-code | 59714⭐ | Agent harness 性能优化系统 |
| antigravity-awesome-skills | 18993⭐ | 900+ Agentic Skills 集合 |
| planning-with-files | 15201⭐ | Manus 风格持久化 Markdown 规划 |
| marketingskills | 10670⭐ | 营销技能集合 |
| VoltAgent/awesome-agent-skills | 9154⭐ | 500+ agent skills |
| claude-code-infrastructure-showcase | 9142⭐ | Claude Code 基础设施展示 |
| claude-code-showcase | 5433⭐ | 综合配置示例 |
| AI-Research-SKILLs | 4325⭐ | AI 研究技能库 |
| awesome-agent-skills | 2662⭐ | AI 编码代理技能列表 |
| tech-leads-club/agent-skills | 1604⭐ | 安全验证技能注册表 |

### 4.2 开发者工具 Skills 分类

#### 4.2.1 GitHub 自动化

| Skill 名称 | 路径 | 描述 |
|-----------|------|------|
| github-automation | antigravity | GitHub 自动化任务 |
| github-workflow-automation | antigravity | GitHub Actions 工作流自动化 |
| github-actions-templates | antigravity | GitHub Actions 模板 |
| github-issue-creator | antigravity | GitHub Issue 创建 |
| address-github-comments | antigravity | GitHub 评论回复 |

#### 4.2.2 Docker 容器化

| Skill 名称 | 路径 | 描述 |
|-----------|------|------|
| docker-expert | antigravity | Docker 专家技能 |
| claude-deploy-service | GitHub | 一键部署到 Docker |

#### 4.2.3 CI/CD 流水线

| Skill 名称 | 路径 | 描述 |
|-----------|------|------|
| cloud-devops | antigravity | 云 DevOps 技能 |
| devops-troubleshooter | antigravity | DevOps 问题排查 |

#### 4.2.4 浏览器自动化

| Skill 名称 | 路径 | 描述 |
|-----------|------|------|
| playwright-skill | GitHub | Playwright 浏览器自动化 (1855⭐) |
| playwright-undetected-skill | GitHub | 反检测 Playwright |

#### 4.2.5 API 开发

| Skill 名称 | 路径 | 描述 |
|-----------|------|------|
| api-design-principles | antigravity | API 设计原则 |
| api-documentation | antigravity | API 文档 |
| api-documentation-generator | antigravity | API 文档生成 |
| api-documenter | antigravity | API 文档工具 |

### 4.3 热点项目详解

#### 4.3.1 outmanwt/claude-deploy-service ⭐31

**项目地址**: [outmanwt/claude-deploy-service](https://github.com/outmanwt/claude-deploy-service)

> A Claude Code skill for one-click GitHub project deployment to Docker

**核心功能**:
- 一键部署到 Docker
- GitHub 项目自动化部署
- 简化 DevOps 工作流

#### 4.3.2 ishaan-jaff/queue-release-skill ⭐NEW

**项目地址**: [ishaan-jaff/queue-release-skill](https://github.com/ishaan-jaff/queue-release-skill)

> Claude Code skill for queuing LiteLLM Docker release builds via GitHub Actions

---

## 📈 五、Skills 缺口与建议

### 5.1 游戏客户端开发

**已覆盖**:
- ✅ Unity 开发 (unity-developer, unity-ecs-patterns)
- ✅ Unreal 开发 (unreal-engine-cpp-pro)
- ✅ Godot 开发 (godot-gdscript-patterns, godot-4-migration)
- ✅ 游戏开发编排器 (game-development)
- ✅ Claude Code Game Studios (多代理系统)

**缺口**:
- ⚠️ 移动端游戏测试 (iOS/Android)
- ⚠️ 游戏性能分析专用技能
- ⚠️ 游戏 UI/UX 测试

### 5.2 Python 开发

**已覆盖**:
- ✅ FastAPI 开发 (python-fastapi-development)
- ✅ 异步编程 (async-python-patterns)
- ✅ 测试模式 (python-testing-patterns)
- ✅ 性能优化 (python-performance-optimization)
- ✅ 打包发布 (python-packaging)
- ✅ Temporal 工作流 (temporal-python-pro)

**缺口**:
- ⚠️ Django 专业开发
- ⚠️ 机器学习/数据科学工作流

### 5.3 测试自动化

**已覆盖**:
- ✅ E2E 测试 (e2e-testing)
- ✅ Playwright (playwright-skill, 1855⭐)
- ✅ TDD (test-driven-development)
- ✅ API 测试 (api-testing-observability-api-mock)

**缺口**:
- ⚠️ 游戏客户端专用测试
- ⚠️ 移动端游戏自动化测试 (Unity/Godot)
- ⚠️ 游戏性能基准测试

### 5.4 开发者工具

**已覆盖**:
- ✅ GitHub 自动化
- ✅ Docker 部署
- ✅ CI/CD 流水线

**缺口**:
- ⚠️ Kubernetes 专业化
- ⚠️ 云服务集成 (AWS/Azure/GCP)

---

## 🎯 六、本周更新亮点

1. **Claude Code Game Studios** 持续更新，48 agents 完整游戏开发工作室架构
2. **playwright-skill** 持续热门，1855 stars，模型驱动的自动化测试
3. ** Antigravity** 仓库新增多个 Python 和测试相关 Skills
4. **GitHub 热点**: 游戏开发、Python、测试自动化是三大热门方向

---

## 📚 参考资源

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills) - 900+ Skills
- [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
- [playwright-skill](https://github.com/lackeyjb/playwright-skill)
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
- [planning-with-files](https://github.com/OthmanAdi/planning-with-files)

---

*持续更新中... | 调研日期: 2026-03-04*
