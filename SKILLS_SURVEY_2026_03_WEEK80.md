# Claude Code Skills 深度调研报告 - 2026年3月（第八十周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + ClawHub 搜索 + 社区推荐  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 持续更新

---

## 📊 调研概要

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 60+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 140+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 220+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 100+ | ⭐⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog (1.134⭐) | 全引擎 |
| Unity 开发 | unity-mcp (6580⭐), unity-developer, unity-ai-workflow-2026 | Unity |
| Godot 开发 | godot-mcp (480⭐), godot-gdscript-patterns | Godot |
| Unreal 开发 | unreal-engine-skills (27 Skills) | Unreal |
| Roblox 开发 | roblox-game-skill | Roblox |
| 游戏 AI | game-ai (3.133⭐ TOP 1) | 通用 |
| 完整工作室 | Claude-Code-Game-Studios (31⭐/48 Agents) | 全引擎 |
| RPG 冒险游戏 | Claude-Code-Game-Master (86⭐) | 持久世界 |
| 格斗游戏 | IKEMEN Forge (新增) | IKEMEN Go |
| 特定游戏模组 | Space Engineers Development | Space Engineers |

### 1.2 重点 Skills 深度分析

#### 🎯 Claude-Code-Game-Studios (⭐ 31+) - 完整游戏工作室

**仓库**: https://github.com/Donchitos/Claude-Code-Game-Studios

| 组件 | 数量 | 说明 |
|------|------|------|
| Agents | 48 | 专业化 AI 团队 |
| Skills | 36 | 工作流命令 |
| Hooks | 8 | 自动化验证 |
| Rules | 11 | 编码标准 |
| Templates | 28 | 文档模板 |

**三层架构**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**支持的引擎**:
- Godot 4: GDScript, Shaders, GDExtension
- Unity: DOTS/ECS, Shaders/VFX, Addressables, UI Toolkit
- Unreal Engine 5: GAS, Blueprints, Replication, UMG/CommonUI

**Slash Commands**:
- Reviews: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt
- Production: /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report
- Project: /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems
- Release: /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix
- Creative: /brainstorm, /playtest-report, /prototype, /onboard, /localize

#### 🎯 Claude-Code-Game-Master (⭐ 86) - RPG 冒险游戏新星

**仓库**: https://github.com/Sstobo/Claude-Code-Game-Master

**核心能力**:
- RAG 技术驱动的故事情节
- RPG 规则集 API 集成
- 持久世界冒险
- 书籍/世界改编游戏

**适用场景**:
- 互动小说游戏
- 桌游电子化
- 角色扮演冒险

#### 🎯 Unity AI Workflow 2026

**仓库**: https://github.com/David-GD13/unity-ai-workflow

| 特性 | 说明 |
|------|------|
| Unity 6.2+ 支持 | 最新 LTS 版本 |
| DOTS/ECS | 数据导向设计 |
| AI 代码生成 | 自动化开发 |

#### 🎯 IKEMEN Forge - 格斗游戏开发 (新增)

**仓库**: https://github.com/nategarelik/ikemen-forge

**核心能力**:
- IKEMEN Go 格斗游戏开发 Claude Code 插件
- 9 agents, 13 commands, 13 skill domains
- 覆盖完整游戏开发生命周期

#### 🎯 Godot MCP Server (⭐ 10) - AI 辅助 Godot 开发

**仓库**: https://github.com/toasted-iron-studios/godot-agent-mcp

**核心能力**:
- 专为 Claude Code、Zed、Cursor 等 Agentic 代码编辑优化的 Godot MCP 服务器
- 支持 Godot 4.x

#### 🎯 Space Engineers Development (⭐ 2) - 特定游戏模组开发

**仓库**: https://github.com/viktor-ferenczi/se-dev-skills

**核心能力**:
- Space Engineers 插件、模组和游戏内脚本开发
- 兼容 Claude Code、Cline 和其他 agentic coding harnesses

#### 🎯 RenderDoc Skill (⭐ 85) - GPU 帧调试

**仓库**: https://github.com/rudybear/renderdoc-skill

**核心能力**:
- Claude Code skill 用于通过 rdc-cli 进行 GPU 帧调试
- 游戏开发者专用

### 1.3 游戏开发 Skills 排行榜

| 排名 | Skill | 安装量/评分 |
|------|-------|-------------|
| 1 | game-ai | 3.133 ⭐ |
| 2 | unity | 3.033 ⭐ |
| 3 | game-cog | 1.132 ⭐ |
| 4 | game-engine | 3.878K |
| 5 | godot-gdscript-patterns | 3.019K |

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱

| 分类 | 核心 Skills | 评分 |
|------|-------------|------|
| Web 框架 | fastapi-pro, django-pro, fastapi (1.075⭐) | 高 |
| 异步编程 | async-python-patterns, temporal-python-pro | 高 |
| 数据科学 | python-dataviz (3.433⭐), python-executor (3.484⭐) | 高 |
| AI Agent | pydantic-ai-skills (140⭐), claudex (223⭐) | 高 |
| 类型安全 | python-type-safety, mypy-best | 高 |
| 代码审查 | beagle (37⭐), security-antipatterns-python (3⭐) | 新增 |
| 脚本工具 | python-script-generator (3.253⭐) | 高 |

### 2.2 重点 Skills

#### 🎯 Claudex (⭐ 223) - 自托管 Claude Code 工作区

**仓库**: https://github.com/Mng-dev-ai/claudex

**核心功能**:
- 多提供商路由 (Anthropic, OpenAI, GitHub Copilot, OpenRouter)
- 浏览器内 VS Code
- 沙盒执行环境
- MCP 服务器集成
- 自定义 Skills 和 Agents

**技术栈**:
- FastAPI Backend (PostgreSQL + Redis / SQLite)
- React/Vite Frontend
- Docker/Host Sandbox Runtime

#### 🎯 Pydantic AI Skills (⭐ 140)

**仓库**: https://github.com/Fuenfgeld/pydantic-ai-skills

**核心能力**:
- 生产级 Claude Code skills
- 构建 AI agents 与 Pydantic AI
- 依赖注入、工具、验证器、流式传输、多 Agent 编排
- 评估框架模式

#### 🎯 Beagle (⭐ 37) - 代码审查技能

**仓库**: https://github.com/existential-birds/beagle

**核心能力**:
- Claude Code 插件，用于代码审查技能和验证工作流
- 支持 Python, Go, React, FastAPI, BubbleTea
- AI 框架支持（Pydantic AI, LangGraph, Vercel AI SDK）

#### 🎯 Python Executor (⭐ 3.484) - Skills.sh TOP 1

**仓库**: 官方 Skills.sh

**核心能力**:
- Python 代码执行和调试
- 支持多种 Python 版本
- 虚拟环境管理

#### 🎯 Security Antipatterns Python (⭐ 3) - 安全 Python 编码

**仓库**: https://github.com/subhashdasyam/security-antipatterns-python

**核心能力**:
- 教授 AI 编码 agents 编写安全的 Python 代码
- 捕获 SQL 注入、pickle 攻击、硬编码 secrets
- OWASP Top 10 模式检测
- 支持 Django、Flask 和 FastAPI 代码

### 2.3 Skills.sh Python 排行榜

| 排名 | Skill | 安装量 |
|------|-------|--------|
| 1 | python-executor | 1.8K |
| 2 | python-sdk | 1.7K |
| 3 | python-performance-optimization | 7.3K |
| 4 | python-dataviz | - |
| 5 | fastapi | - |

### 2.4 新增 Python 开发 Skills

#### 🎯 uv Python Tooling - 现代 Python 工具链

**核心能力**:
- uv 快速包管理
- Python 版本管理
- 虚拟环境自动化

#### 🎯 Temporal Python Pro - 工作流引擎

**核心能力**:
- Temporal 工作流 Python 开发
- 长时间运行任务编排
- 分布式事务处理

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱

| 分类 | 核心 Skills | 评分 |
|------|-------------|------|
| 浏览器自动化 | playwright (1.231⭐), playwright-mcp | 高 |
| E2E 测试 | e2e-testing-patterns (1.118⭐) | 高 |
| 单元测试 | pytest-master, unittest-pro | 高 |
| 移动端测试 | android-adb (1.220⭐), ios-simulator-skill (567⭐) | 高 |
| AI 测试 | agentic-qe (218⭐) | 新兴 |
| 游戏测试 | game-testing | 新增 |
| QA 工作流 | Qa-WorkFlow (新增) | 新增 |
| 机器人检测绕过 | playwright-undetected (4⭐) | 新增 |

### 3.2 重点 Skills

#### 🎯 Playwright Skill (⭐ 1869) - 测试 TOP 1

**仓库**: https://github.com/lackeyjb/playwright-skill

| 功能 | 说明 |
|------|------|
| 通用自动化 | 模型驱动的浏览器自动化 |
| 可见浏览器 | headless: false 默认 |
| 零模块错误 | 通用执行器确保模块访问 |
| 渐进式披露 | 精简 SKILL.md + 完整 API 参考 |
| 安全清理 | 智能临时文件管理 |
| 综合助手 | 常用任务工具函数 |

#### 🎯 Playwright Undetected Skill (⭐ 4) - 机器人检测绕过

**仓库**: https://github.com/dalbit-mir/playwright-undetected-skill

**核心能力**:
- 机器人检测绕过浏览器自动化
- 本地主机测试、截图、UI 交互
- 基于 Patchright 的未检测 Playwright

#### 🎯 QA WorkFlow - AI 驱动 QA 自动化

**仓库**: https://github.com/islam-mamdouh/Qa-WorkFlow

**核心能力**:
- AI 驱动的 QA 自动化框架
- 完整 QA 生命周期自动化：
  - 故事验证 (INVEST)
  - IEEE 829 测试计划
  - 测试用例生成
  - Bug 报告
  - Figma 设计验证
- 多平台和多语言测试
- Jira 和 Figma 集成

#### 🎯 iOS Simulator Skill (⭐ 567)

**仓库**: https://github.com/conorluddy/ios-simulator-skill

**核心能力**:
- iOS 应用构建
- 模拟器控制
- UI 测试

#### 🎯 Agentic QE (⭐ 218) - AI 驱动质量工程

**仓库**: https://github.com/proffesor-for-testing/agentic-qe

**核心能力**:
- AI 生成测试用例
- 智能测试选择
- 自动缺陷检测

#### 🎯 QA Test Automation Skill - 测试用例自动生成

**仓库**: https://github.com/lify0921/qa-test-automation-skill

**核心能力**:
- 从规格和源代码自动生成测试计划、测试设计和测试用例

#### 🎯 Claude Auto Dev - 自主开发测试

**仓库**: https://github.com/djnsty23/claude-auto-dev

**核心能力**:
- Claude Code 自主开发技能
- 任务循环、测试和部署自动化

### 3.3 Skills.sh 测试排行榜

| 排名 | Skill | 评分 |
|------|-------|--------|
| 1 | playwright | 1.231 |
| 2 | testing | 1.089 |
| 3 | test-automation | 0.987 |
| 4 | automated-testing | 0.956 |
| 5 | qa-testing | 0.923 |

### 3.4 游戏客户端测试专题

**需求分析**:

| 需求 | 优先级 |
|------|--------|
| Unity 客户端测试 | ⭐⭐⭐⭐⭐ |
| 帧同步测试 | ⭐⭐⭐⭐⭐ |
| Unreal 客户端测试 | ⭐⭐⭐⭐ |
| 游戏性能基准 | ⭐⭐⭐⭐ |

**现有 Skills 缺口**:
- 游戏专用自动化测试 Skills 较少
- 帧同步/网络同步测试 Skills 缺失
- Unity/Unreal 性能分析 Skills 需要补充

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱

| 分类 | 核心 Skills | 评分 |
|------|-------------|------|
| Git/GitHub | git (1.342⭐), github (1.287⭐), git-mcp-server | 高 |
| Docker | docker-essentials (1.297⭐), docker | 高 |
| CI/CD | cicd-pipeline, gitlab-cli-skills | 中 |
| MCP | claude-code-mcp (1153⭐), mcp-adapter | 高 |
| 云服务 | aws, azure, gcp | 中 |
| 部署工具 | pinme (2970⭐), vercel-deploy | 高 |
| 上下文工程 | planning-with-files (15292⭐), context-engineering-kit (575⭐) | 高 |
| 安全工具 | skills-TrailOfBits (3274⭐) | 高 |
| 开发者套件 | developer-kit (133⭐) | 新增 |

### 4.2 GitHub 热门开发者工具 Skills (实时)

| 仓库 | ⭐ | 说明 |
|------|-----|------|
| planning-with-files | 15292 | Manus 风格持久化规划 |
| awesome-agent-skills | 9284 | 500+ Agent Skills 集合 |
| humanizer | 7737 | 消除 AI 写作痕迹 |
| skills (Trail of Bits) | 3274 | 安全研究技能 |
| pinme | 2970 | 前端一键部署 |
| Generative-Media-Skills | 2812 | 多模态生成媒体 Skills |
| Claudeception | 1926 | 自主技能提取学习 |
| skill-codex | 753 | Codex 任务委托 |
| claude-code-skills | 621 | 专业技能市场 |
| context-engineering-kit | 575 | 上下文工程工具包 |

### 4.3 新增热门 Skills

#### 🎯 Awesome Agent Skills (⭐ 9284) - TOP 1

**仓库**: https://github.com/VoltAgent/awesome-agent-skills

**核心能力**:
- Claude Code Skills 和 500+ agent skills
- 来自官方开发团队和社区
- 兼容 Codex, Antigravity, Gemini CLI, Cursor 等

#### 🎯 Developer Kit (⭐ 133) - 模块化开发者工具包

**仓库**: https://github.com/giuseppe-trisciuoglio/developer-kit

**核心能力**:
- Claude Code 开发者工具包
- 模块化插件系统
- 覆盖 Java/Spring Boot/LangChain4J, TypeScript/NestJS/React, Python, PHP/WordPress, AWS CloudFormation, AI patterns

#### 🎯 Systemprompt Code Orchestrator (⭐ 139) - MCP 服务器编排

**仓库**: https://github.com/systempromptio/systemprompt-code-orchestrator

**核心能力**:
- AI 编码代理编排 MCP 服务器
- 支持 Claude Code CLI 和 Gemini CLI
- 任务管理、进程执行、Git 集成、动态资源发现
- 完整 TypeScript 实现，支持 Docker

#### 🎯 Claude Ads (⭐ 671) - 广告审计技能

**仓库**: https://github.com/AgriciDaniel/claude-ads

**核心能力**:
- Claude Code 综合付费广告审计和优化技能
- 186 项检查覆盖 Google、Meta、YouTube、LinkedIn、TikTok 和 Microsoft Ads
- 加权评分、并行 agents 和行业模板

#### 🎯 Git MCP Server - Git 操作 MCP 服务器

**仓库**: https://github.com/DanyelKirsch/git-mcp-server

**核心能力**:
- 为 Claude Code 和其他 MCP 客户端提供全面的 Git 操作
- 完整的 Git 工作流支持

#### 🎯 MCP Devtools Server (⭐ 5) - 开发工具服务器

**仓库**: https://github.com/rshade/mcp-devtools-server

**核心能力**:
- Claude Code 和 MCP 客户端的 AI 驱动开发工具服务器
- 40+ 工具覆盖 Go、Node.js、测试、linting、Git 工作流
- 零配置设置、智能缓存、可扩展插件

### 4.4 Skills.sh 开发者工具排行榜

| 排名 | Skill | 评分 |
|------|-------|--------|
| 1 | git | 1.342 |
| 2 | github | 1.287 |
| 3 | docker | 1.156 |
| 4 | cli | 1.089 |
| 5 | bash | 1.023 |

---

## 📈 五、趋势分析

### 5.1 本周趋势

1. **游戏开发**: 
   - Claude-Code-Game-Studios 继续完善，48 Agents 完整工作室架构
   - IKEMEN Forge 专注格斗游戏垂直领域
   - Godot MCP 服务器面向 AI 辅助开发
   - Space Engineers 开发技能面向特定游戏模组开发

2. **Python 开发**: 
   - Pydantic AI Skills 成为 AI Agent 开发标准
   - Security Antipatterns Python 关注安全编码
   - claudex 提供自托管工作区解决方案

3. **自动化测试**:
   - QA WorkFlow 实现完整 QA 生命周期自动化
   - Playwright Undetected 解决机器人检测问题
   - Agentic QE 推动 AI 驱动测试

4. **开发者工具**:
   - MCP 服务器生态持续扩展
   - Developer Kit 提供模块化开发框架
   - Claude Ads 开辟垂直领域新方向

### 5.2 Skills 缺口分析

| 领域 | 缺口 | 建议 |
|------|------|------|
| 游戏客户端测试 | 帧同步测试 Skills 缺失 | 需要开发专门的帧同步测试 Skill |
| Unity 性能分析 | 性能基准测试 Skills 不足 | 需要 Unity Profiling Skills |
| Python 安全 | 安全编码 Skills 较少 | 需要更多安全相关 Skills |
| 游戏 AI | 游戏 AI 开发 Skills 较少 | 需要 Game AI 专用 Skills |

---

## 📚 六、参考资料

- [Skills.sh](https://skills.sh) - 官方 Skills 市场
- [ClawHub](https://clawhub.com) - Skills 发现平台
- [GitHub Topics: claude-code-skill](https://github.com/topics/claude-code-skill)
- [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)

---

## 📝 更新日志

- **2026-03-05**: 第八十周调研，新增 Developer Kit、Claude Ads、Git MCP Server 等 Skills
- **2026-03-04**: 第七十九周调研，新增 Claude-Code-Game-Studios 完整分析
- **2026-03-03**: 第七十八周调研，完善游戏开发 Skills 体系

---

*持续更新中...*
