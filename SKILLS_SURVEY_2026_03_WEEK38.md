# Claude Code Skills 补充调研报告 - 2026年3月 (Week 38)

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (900+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 新增调研

---

## 📊 调研概要

本次调研基于 GitHub API 实时搜索和 Antigravity Awesome Skills 仓库获取的最新热门 Skills，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/CI/CD/代码审查)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 GitHub 实时搜索结果 (Top 5)

| 项目 | Stars | 描述 |
|-----|-------|------|
| Claude-Code-Game-Studios | 28⭐ | 48 agents 完整游戏开发工作室 |
| The1Studio/theone-training-skills | 44⭐ | Unity 工程师训练技能集 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能 |
| solana-game-skill | 5⭐ | Solana Unity SDK 游戏技能 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 |

### 1.2 Antigravity 游戏开发 Skills

#### 1.2.1 game-development (编排器)

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

---

#### 1.2.2 unity-developer

**Skill 路径**: `antigravity-awesome-skills/skills/unity-developer`

> 构建 Unity 游戏，优化 C# 脚本，高效渲染，proper asset management。掌握 Unity 6 LTS、URP/HDRP 管道和跨平台部署。

**核心能力**:
- Unity 6 LTS 特性与长期支持
- URP/HDRP 渲染管道优化
- 性能优化 (Profiler, Frame Debugger, Memory Profiler)
- 跨平台构建优化

**适用场景**:
- Unity 游戏开发任务和工作流
- 需要 Unity 开发和最佳实践指导

---

#### 1.2.3 unreal-engine-cpp-pro

**Skill 路径**: `antigravity-awesome-skills/skills/unreal-engine-cpp-pro`

> Unreal Engine C++ 专业开发技能，覆盖游戏框架、内存管理、网络同步和性能优化。

---

### 1.3 Claude Code Game Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

> 🚀 Turn Claude Code into a full game dev studio — 48 AI agents, 36 workflow skills, and a complete coordination system mirroring real studio hierarchy.

**核心架构 (三层体系)**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists (Sonnet/Haiku)**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**36 个 Slash Commands**: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt, /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report, /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems, /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix, /brainstorm, /playtest-report, /prototype, /onboard, /localize, /team-combat, /team-narrative, /team-ui, /team-release, /team-polish, /team-audio, /team-level

**推荐理由**: 最完整的游戏开发多代理系统，适合大型商业游戏项目。

---

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

---

### 1.5 游戏开发 Skills 汇总

| Skill | 来源 | 评分/Stars | 描述 |
|-------|------|-----------|------|
| game-development | Antigravity | N/A | 游戏开发编排器，路由到子技能 |
| game-cog | ClawHub | 1.132 | 游戏开发编排器 TOP 1 |
| unity-developer | Antigravity | N/A | Unity 开发者专业技能 |
| unity-ecs-patterns | Antigravity | N/A | Unity ECS 架构模式 |
| unreal-engine-cpp-pro | Antigravity | N/A | Unreal C++ 专业开发 |
| game-art | Antigravity | N/A | 游戏美术与资产管道 |
| game-audio | Antigravity | N/A | 游戏音频设计 |
| multiplayer | Antigravity | N/A | 多人游戏网络开发 |
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

### 2.2 Antigravity Python Skills

#### 2.2.1 async-python-patterns

**Skill 路径**: `antigravity-awesome-skills/skills/async-python-patterns`

> 掌握 Python asyncio、并发编程和 async/await 模式，用于高性能应用。

**适用场景**:
- 构建异步 Web APIs (FastAPI, aiohttp, Sanic)
- 实现并发 I/O 操作 (数据库、文件、网络)
- 开发实时应用 (WebSocket 服务器、聊天系统)
- 处理多个独立任务

**核心模式**:
- asyncio tasks, gather, queues, pools
- 结构化并发与取消规则
- 超时、背压、错误处理

**推荐理由**: Python 异步编程权威指南，适合构建高性能 I/O 密集型应用。

---

#### 2.2.2 python-testing-patterns

**Skill 路径**: `antigravity-awesome-skills/skills/python-testing-patterns`

> 使用 pytest、fixtures、mocking 和测试驱动开发实现全面的测试策略。

**适用场景**:
- 为 Python 代码编写单元测试
- 设置测试套件和测试基础设施
- 实现测试驱动开发 (TDD)
- 为 API 和服务创建集成测试
- Mock 外部依赖和服务
- 测试异步代码和并发操作

**核心内容**:
- pytest fixtures 和参数化
- unittest.mock 使用
- 异步代码测试
- 属性测试 (property-based testing)

---

#### 2.2.3 dbos-python

**Skill 路径**: `antigravity-awesome-skills/skills/dbos-python`

> DBOS (Database-Oriented Operating System) Python 框架，提供事务性内存、可靠调度和可观测性。

**核心特性**:
- 事务性内存管理
- 可靠的后台任务调度
- 内置可观测性
- 声明式工作流

---

#### 2.2.4 temporal-python-pro

**Skill 路径**: `antigravity-awesome-skills/skills/temporal-python-pro`

> Temporal 工作流 Python 专业技能，覆盖持久化执行、状态管理和复杂业务逻辑。

---

### 2.3 Python 开发 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| async-python-patterns | Antigravity | 异步 Python 模式 |
| python-testing-patterns | Antigravity | Python 测试模式 |
| python-rope-refactor | GitHub | Python 代码重构 |
| dbos-python | Antigravity | DBOS Python 框架 |
| temporal-python-pro | Antigravity | Temporal Python 工作流 |
| temporal-python-testing | Antigravity | Temporal 测试模式 |
| pydantic-ai-skills | GitHub | Pydantic AI Skills |

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 GitHub 热门测试 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| playwright-skill | 1853⭐ | Playwright 浏览器自动化 |
| antigravity-awesome-skills | 18898⭐ | 900+ Agentic Skills 集合 |
| axiom | 546⭐ | xOS (iOS/watchOS) 开发技能 |
| agentic-qe | 216⭐ | AI 驱动的 QA/QE 平台 |
| robotics-agent-skills | 115⭐ | 机器人软件测试技能 |

### 3.2 Antigravity 测试 Skills

#### 3.2.1 e2e-testing

**Skill 路径**: `antigravity-awesome-skills/skills/e2e-testing`

> 使用 Playwright 进行端到端测试的工作流，包括浏览器自动化、视觉回归、跨浏览器测试和 CI/CD 集成。

**工作流阶段**:

1. **Phase 1: Test Setup**
   - 安装 Playwright
   - 配置测试框架
   - 设置测试目录
   - 配置浏览器

2. **Phase 2: Test Implementation**
   - 编写 E2E 测试用例
   - 实现视觉回归测试
   - 配置跨浏览器测试

3. **Phase 3: CI/CD Integration**
   - 集成到 CI/CD 流水线
   - 配置测试报告
   - 设置失败告警

---

#### 3.2.2 playwright-skill ⭐1853

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

> Claude Code Skill for browser automation with Playwright. Model-invoked - Claude autonomously writes and executes custom automation for testing and validation.

**核心特性**:
- 模型驱动：Claude 自主编写和执行自定义自动化
- 测试和验证
- 浏览器自动化

**推荐理由**: 最流行的 Playwright 自动化技能，1853 Stars 验证其可靠性。

---

#### 3.2.3 test-driven-development

**Skill 路径**: `antigravity-awesome-skills/skills/test-driven-development`

> 测试驱动开发实践，指导从测试编写到重构的完整 TDD 循环。

---

#### 3.2.4 e2e-testing-patterns

**Skill 路径**: `antigravity-awesome-skills/skills/e2e-testing-patterns`

> E2E 测试模式最佳实践，覆盖测试结构、选择器策略、等待策略和断言模式。

---

#### 3.2.5 testing-qa

**Skill 路径**: `antigravity-awesome-skills/skills/testing-qa`

> QA 测试综合技能，覆盖测试计划、缺陷管理和质量保证流程。

---

### 3.3 游戏客户端测试 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| playwright-skill | GitHub (1853⭐) | Playwright 浏览器自动化 |
| e2e-testing | Antigravity | E2E 测试工作流 |
| e2e-testing-patterns | Antigravity | E2E 测试模式 |
| test-driven-development | Antigravity | TDD 测试驱动开发 |
| testing-qa | Antigravity | QA 测试综合技能 |
| test-automator | Antigravity | 测试自动化 |
| azure-microsoft-playwright-testing-ts | Antigravity | Azure Playwright 测试 |
| api-security-testing | Antigravity | API 安全测试 |
| web-security-testing | Antigravity | Web 安全测试 |

---

## 🔧 四、开发者工具 Skills

### 4.1 GitHub 热门开发者工具 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| awesome-claude-skills | 40408⭐ | Claude Skills 精选列表 |
| refly | 6893⭐ | 开源 Agent Skills 构建器 |
| notebooklm-skill | 4064⭐ | Google NotebookLM 集成 |
| claude-code-plugins-plus-skills | 1498⭐ | 270+ 插件，739 Skills |
| agent-sh/agentsys | 515⭐ | 自动化系统 14插件/43agents/30skills |

### 4.2 Antigravity 开发者工具 Skills

#### 4.2.1 cloud-devops

**Skill 路径**: `antigravity-awesome-skills/skills/cloud-devops`

> 云基础设施和 DevOps 工作流，涵盖 AWS、Azure、GCP、Kubernetes、Terraform、CI/CD、监控和云原生开发。

**核心技能**:
- 云架构设计
- 基础设施即代码 (Terraform)
- Kubernetes 容器编排
- CI/CD 流水线
- 监控和可观测性

**工作流阶段**:

1. **Phase 1: Cloud Infrastructure Setup**
   - 设计云架构
   - 设置账户和计费
   - 配置网络
   - 配置 IAM

2. **Phase 2: CI/CD Pipeline**
   - 配置版本控制
   - 设置自动化构建
   - 配置部署流水线

---

#### 4.2.2 github-automation

**Skill 路径**: `antigravity-awesome-skills/skills/github-automation`

> 通过 Rube MCP 自动化 GitHub 仓库管理、Issue、PR、分支、CI/CD。

**核心工作流**:

1. **Issue 管理**
   - 创建、列表、搜索 Issues
   - 添加评论和标签
   - 分配负责人

2. **Pull Request 工作流**
   - 创建和审查 PR
   - 合并和关闭 PR
   - 配置保护规则

3. **仓库管理**
   - 创建和管理仓库
   - 配置分支策略
   - 设置 Webhooks

**前置条件**:
- Rube MCP 必须已连接
- GitHub OAuth 完成

---

#### 4.2.3 cicd-automation-workflow-automate

**Skill 路径**: `antigravity-awesome-skills/skills/cicd-automation-workflow-automate`

> CI/CD 自动化工作流，覆盖主流 CI 平台配置、管道优化和部署策略。

---

#### 4.2.4 browser-automation

**Skill 路径**: `antigravity-awesome-skills/skills/browser-automation`

> 浏览器自动化技能，使用 Playwright/Selenium 进行网页抓取、表单填写、UI 测试。

---

### 4.3 Agentic QE - AI 驱动的测试平台

**项目地址**: [proffesor-for-testing/agentic-qe](https://github.com/professor-for-testing/agentic-qe)

> Agentic QE Fleet is an open-source AI-powered QA/QE platform designed for use with Coding Agents (works best with Claude Code) featuring specialized agents and skills to support testing activities for a product at any stage of the SDLC.

**核心特性**:
- 专门的测试代理
- SDLC 全阶段支持
- 免费使用

---

### 4.4 开发者工具 Skills 汇总

| Skill | 来源 | 描述 |
|-------|------|------|
| awesome-claude-skills | GitHub (40408⭐) | Claude Skills 精选列表 |
| refly | GitHub (6893⭐) | 开源 Agent Skills 构建器 |
| agent-sh/agentsys | GitHub (515⭐) | 自动化系统 |
| cloud-devops | Antigravity | 云和 DevOps |
| github-automation | Antigravity | GitHub 自动化 |
| cicd-automation | Antigravity | CI/CD 自动化 |
| browser-automation | Antigravity | 浏览器自动化 |
| devops-troubleshooter | Antigravity | DevOps 故障排除 |
| debugging-toolkit-smart-debug | Antigravity | 调试工具包 |

---

## 📈 五、Skills 缺口分析与建议

### 5.1 当前热门 Skills 趋势

1. **游戏开发**: Claude Code Game Studios (48 agents) 代表大型多代理系统的方向
2. **测试自动化**: Playwright 技能持续热门 (1853 Stars)，AI 驱动的 QE 平台兴起
3. **Python**: 异步编程和测试模式是重点，DBOS/Temporal 等工作流框架受关注
4. **开发者工具**: 自动化工作流和 MCP 集成成为主流

### 5.2 Skills 缺口

| 领域 | 缺口 | 建议 |
|------|------|------|
| 游戏客户端测试 | 专门的移动端游戏测试技能较少 | 可开发 Unity/Godot 移动端测试技能 |
| Python | 缺乏中文文档的 Python 技能 | 可补充中文版 FastAPI/异步 Python 技能 |
| 游戏引擎 | Godot 4 相关 Skills 较少 | 可开发 Godot 4 GDScript 技能集 |
| 测试 | 缺乏游戏特定的 UI 自动化技能 | 可开发游戏客户端 UI 测试框架 |

### 5.3 本周更新亮点

- **Claude-Code-Game-Studios** 新增 48 agents 游戏开发工作室架构
- **Playwright Skill** 持续热门，达到 1853 Stars
- **Antigravity** 仓库已收录 900+ Skills，覆盖 12 大类别
- **Agentic QE** 平台提供 AI 驱动的测试自动化解决方案

---

## 📋 六、参考资源

### 6.1 官方资源
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Skills 规范](https://github.com/anthropics/claude-code/tree/main/skills)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills) (18898 Stars)

### 6.2 本地资源
- [cc_skills 仓库](./README.md)
- [game-dev-skills](./game-dev-skills/README.md)
- [python-dev-skills](./python-dev-skills/README.md)
- [automation-testing-skills](./automation-testing-skills/README.md)
- [developer-tools-skills](./developer-tools-skills/README.md)

---

*文档更新于 2026-03-04*
