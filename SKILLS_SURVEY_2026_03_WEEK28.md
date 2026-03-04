# Claude Code Skills 完整调研报告 - 2026年3月 (第二十八周)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + skills.sh 实时搜索  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研继续聚焦 Claude Code 热门 Skills，基于 GitHub API 搜索和 skills.sh 平台，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/GameMaker/Love2D)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/代码审查/安全评估/CI/CD)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 本周新增热门 Skills

#### 1.1.1 Claude Code Game Studios ⭐28 (2026年3月)

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

```markdown
## 核心特性
- 48 个 AI agents，专门针对游戏开发
- 36 个 workflow skills，覆盖完整游戏开发流程
- 完整的协调系统，模拟真实游戏工作室层级结构
- 支持 Unity/Unreal/Godot 多引擎

## Studio Hierarchy (三层架构)

### Tier 1 — Directors (Opus)
- creative-director: 创意总监，守护游戏愿景
- technical-director: 技术总监，技术决策
- producer: 制作人，项目管理

### Tier 2 — Department Leads (Sonnet)
- game-designer: 游戏设计师
- lead-programmer: 主程
- art-director: 美术总监
- audio-director: 音频总监
- narrative-director: 叙事总监
- qa-lead: QA 负责人
- release-manager: 发布经理
- localization-lead: 本地化负责人

### Tier 3 — Specialists (Sonnet/Haiku)
- gameplay-programmer: 玩法程序员
- engine-programmer: 引擎程序员
- ai-programmer: AI 程序员
- network-programmer: 网络程序员
- tools-programmer: 工具程序员
- ui-programmer: UI 程序员
- systems-designer: 系统设计师
- level-designer: 关卡设计师
- economy-designer: 经济系统设计师
- technical-artist: 技术美术
- sound-designer: 音效设计师
- writer: 编剧
- world-builder: 世界构建师
- ux-designer: UX 设计师
- prototyper: 原型师
- performance-analyst: 性能分析师
- devops-engineer: DevOps 工程师
- analytics-engineer: 数据分析工程师
- security-engineer: 安全工程师
- qa-tester: QA 测试员
- accessibility-specialist: 无障碍专家
- live-ops-designer: 长线运营设计师
- community-manager: 社区经理

## Slash Commands (36个)
### Reviews & Analysis
/design-review /code-review /balance-check /asset-audit
/scope-check /perf-profile /tech-debt

### Production
/sprint-plan /milestone-review /estimate /retrospective /bug-report

### Project Management
/start /project-stage-detect /reverse-document /gate-check /design-systems

### Release
/release-checklist /launch-checklist /changelog /patch-notes /hotfix

### Creative
/brainstorm /playtest-report /prototype /onboard /localize

### Team Orchestration
/team-combat /team-narrative /team-ui /team-release /team-polish
/team-audio /team-level
```

#### 1.1.2 Unity AI Workflow 2026 ⭐4

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

```markdown
## 核心哲学: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

## Dev Modes (三种开发模式)
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、game jam |

## 技术架构
- TCREI Prompting: Task-Context-References-Evaluate-Iterate 方法论
- 验证系统: [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED] 标记
- 专家 Skills: UI Toolkit、ScriptableObject、Netcode、game feel、测试、调试
```

#### 1.1.3 GameMaker Skills ⭐2

**项目地址**: [leihaht/gamemaker-skills](https://github.com/leihaht/gamemaker-skills)

```markdown
## Skills 覆盖范围
- Object Creation Workflow: 完整4步流程模板
- GML Language Essentials: 变量、数据类型、操作符、控制流
- Data Structures: Structs、Arrays、ds_list、ds_map、ds_grid
- File System: JSON 处理、datafiles/ 结构、存档系统
- Event System: 执行顺序、事件类型、常见模式
- Drawing & Graphics: 精灵、表面、着色器、粒子、瓦片地图
- Collision & Movement: 检测算法、优化技术
- Performance Optimization: Draw call 减少、对象池、性能分析
- Networking: 客户端-服务器架构、包结构、延迟补偿
- Platform-Specific: 移动端、主机、HTML5、桌面特性
- Advanced Topics: Shader 编程 (GLSL ES)、光照系统、法线贴图
```

#### 1.1.4 Love2D Pocket Bomber Game ⭐11

**项目地址**: [chongdashu/love2d-pocket-bomber-game](https://github.com/chongdashu/love2d-pocket-bomber-game)

```markdown
## 项目描述
使用 Claude Code 和 Love2D Skills 开发 Bomberman 克隆游戏
- 展示 AI 辅助游戏开发的完整流程
- Lua/Love2D 框架实践
- 快速原型开发方法论
```

#### 1.1.5 Godot Resources ⭐3

**项目地址**: [kwhitejr/claude-resources](https://github.com/kwhitejr/claude-resources)

```markdown
## 内容
- 自定义 Claude Code agents 和 skills
- 专为 Godot 游戏开发工作流设计
- GDScript 最佳实践
```

### 1.2 游戏开发 Skills 完整分类

| Skill | 评分 | 核心能力 | Stars |
|-------|------|---------|-------|
| game-cog | 1.132 | 游戏开发编排器，DeepResearch Bench 第一名 | - |
| Claude-Code-Game-Studios | - | 48 agents + 36 skills 游戏工作室 | 28 |
| unity-ai-workflow | - | Unity 6 AI 驱动开发工作流 | 4 |
| OH-Unity-GameDev-Skills | - | Unity 游戏开发 agent skills 集合 | 6 |
| gamemaker-skills | - | GameMaker Studio 2 和 GML 开发 | 2 |
| love2d-pocket-bomber | - | Love2D 游戏开发示例 | 11 |
| godot-dev-guide | 0.983 | Godot 4.x 完整开发指南 | - |
| unreal-engine | 0.935 | Unreal Engine 开发 | - |
| solana-game-skill | - | Solana Unity SDK 区块链游戏 | 5 |

---

## 🐍 二、Python 开发 Skills

### 2.1 本周新增热门 Skills

#### 2.1.1 AI Guide (程序员鱼皮) ⭐8803

**项目地址**: [liyupi/ai-guide](https://github.com/liyupi/ai-guide)

```markdown
## 内容概述
- AI 资源大全 + Vibe Coding 零基础教程
- 大模型选择指南（DeepSeek / GPT / Gemini / Claude）
- 最新 AI 资讯、Prompt 提示词大全
- AI 知识百科（RAG / MCP / A2A）
- AI 编程教程
- AI 工具用法（Cursor / Claude Code / OpenClaw / TRAE）
- AI 开发框架教程（Spring AI / LangChain）
- AI 产品变现指南

## Claude Code 相关内容
- Claude Code 安装配置指南
- Agent Skills 开发教程
- MCP 服务器集成
```

#### 2.1.2 Developer Kit ⭐131

**项目地址**: [giuseppe-trisciuoglio/developer-kit](https://github.com/giuseppe-trisciuoglio/developer-kit)

```markdown
## 模块化插件系统
- Java/Spring Boot/LangChain4J
- TypeScript/NestJS/React
- Python (FastAPI/Django/Flask)
- PHP/WordPress
- AWS CloudFormation
- AI Patterns

## 特性
- 可复用的 skills、agents 和 commands
- 自动化开发任务
- 多 CLI 支持
```

#### 2.1.3 Beagle - Code Review ⭐34

**项目地址**: [existential-birds/beagle](https://github.com/existential-birds/beagle)

```markdown
## 插件列表 (82 skills + 27 commands)

| Plugin | Skills | Commands | 类别 |
|--------|--------|----------|------|
| beagle-core | 8 | 11 | 共享工作流、验证、git |
| beagle-python | 6 | 1 | Python、FastAPI、SQLAlchemy、pytest |
| beagle-go | 6 | 2 | Go、BubbleTea、Wish SSH、Prometheus |
| beagle-elixir | 10 | 1 | Elixir、Phoenix、LiveView |
| beagle-ios | 12 | 1 | Swift、SwiftUI、SwiftData |
| beagle-react | 15 | 1 | React、React Flow、shadcn/ui |
| beagle-ai | 13 | 0 | Pydantic AI、LangGraph、DeepAgents |
| beagle-docs | 7 | 5 | 文档质量、AI 写作检测 |
| beagle-analysis | 5 | 3 | 12-Factor、ADRs、LLM-as-judge |
| beagle-testing | 0 | 2 | 测试计划生成和执行 |

## 核心 Commands
/review-plan <path>     # 审查实现计划
/review-llm-artifacts   # 检测 LLM 编码痕迹
/fix-llm-artifacts      # 修复检测到的问题
/commit-push            # 提交并推送
/create-pr              # 创建 PR
/gen-release-notes      # 生成发布说明
/review-python          # Python 代码审查
/review-frontend        # React/TypeScript 审查
```

#### 2.1.4 Claude Reflect System ⭐70

**项目地址**: [haddock-development/claude-reflect-system](https://github.com/haddock-development/claude-reflect-system)

```markdown
## 核心理念: "Correct once, never again"
自动从用户纠正中学习的 AI 系统，创建永久性学习

## 工作原理
Session 1: Claude 使用 pip
你:       "不，用 uv"
         → /reflect → Skill 学习 ✅

Session 2: Claude 使用 uv ✨
Forever:  Claude 使用 uv ✨

## 适用场景
- 开发工作流：教 Claude 你喜欢的工具 (uv, pytest, ruff)
- 代码风格：自动强制执行编码标准
- 项目模板：记住首选项目结构
- 安全实践：永不忘记安全检查
- CI/CD 流水线：一致的部署模式

## Commands
/reflect          # 分析当前会话
/reflect-status   # 检查状态
/reflect-reset    # 重置学习
```

### 2.2 Python Skills 核心列表

| Skill | 评分 | 核心能力 | Stars |
|-------|------|---------|-------|
| fastapi | 1.054-1.121 | FastAPI 后端开发 | - |
| python-pro | - | Python 3.12+ 现代特性，uv/ruff | - |
| async-python-patterns | - | asyncio 异步编程 | - |
| python-testing-patterns | - | pytest 测试策略 | - |
| temporal-python-pro | - | Temporal 工作流编排 | - |
| dbos-python | - | DBOS 可靠工作流 | - |
| beagle-python | - | Python 代码审查 | 34 |

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 本周新增测试 Skills

#### 3.1.1 Playwright Skill ⭐1848 (测试类 TOP 1)

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

```markdown
## 核心特性
- Model-invoked: Claude 自主编写和执行自动化脚本
- 浏览器自动化测试和验证
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 默认使用可见浏览器
- URL 参数化配置

## Topics
ai-tools, automation, browser-automation, claude, claude-code,
claude-plugin, claude-skills, developer-tools, e2e-testing,
model-invoked, nodejs, playwright, web-testing

## 常见模式
- 页面测试 (多视口)
- 登录流程测试
- 表单填写和提交
- 链接检查
- 响应式设计测试
```

#### 3.1.2 Claude Skills Marketplace (测试/审查) ⭐428

**项目地址**: [mhattingpete/claude-skills-marketplace](https://github.com/mhattingpete/claude-skills-marketplace)

```markdown
## 软件工程工作流 Skills
- Git 自动化
- 测试自动化
- 代码审查

## Topics
ai-agents, anthropic, automation, claude-code, claude-skills, developer-tools
```

#### 3.1.3 Agent Skills (88 个专业 Agent) ⭐9

**项目地址**: [simota/agent-skills](https://github.com/simota/agent-skills)

```markdown
## 质量保证 Agents

| Agent | 描述 | 输出 |
|-------|------|------|
| Radar | 单元/集成测试添加，覆盖率提升 | 测试代码 |
| Voyager | E2E 测试专家，Playwright/Cypress | E2E 测试代码 |
| Sentinel | 静态安全分析 (SAST) | 安全修复 |
| Probe | 动态安全测试 (DAST) | 漏洞报告 |
| Judge | 代码审查，AI 幻觉检测 | 审查报告 |
| Zen | 重构和代码质量改进 | 代码改进 |
| Sweep | 死代码检测和清理 | 清理建议 |
| Warden | 质量标准守护者 | 质量评估报告 |
| Attest | 规格合规验证 | 合规报告 |
| Specter | 并发问题检测 (竞态/内存泄漏/死锁) | 检测报告 |
| Siege | 高级测试 (负载/契约/混沌/变异) | 测试结果 |
| Void | YAGNI 强制执行 | 削减建议 |

## Agent 链
Scout > Ripple > Builder chain: Bug 调查 > 影响分析 > 实现
Ripple > Guardian chain: 影响分析 > PR 策略
Sentinel > Canon > Builder chain: 漏洞检测 > OWASP 合规 > 修复
```

### 3.2 游戏客户端测试 Skills 完整列表

| Skill | 评分 | 核心能力 | Stars |
|-------|------|---------|-------|
| playwright-skill | 3.538-3.584 | 浏览器自动化 TOP 1 | 1848 |
| playwright-mcp | 3.581 | Playwright MCP 服务器 | - |
| android-adb | 1.220 | Android ADB 测试 TOP 1 | - |
| test-runner | 1.189 | 测试运行器 | - |
| test-master | 1.158 | 测试管理 | - |
| claude-skills-marketplace | - | Git/测试/审查 | 428 |
| agent-skills | - | 88 个专业 Agents | 9 |

### 3.3 游戏客户端测试实践方案

```markdown
## Unity Test Framework
### Edit Mode Tests
- 纯 C# 逻辑测试，无需运行游戏
- NUnit 框架
- 快速反馈

### Play Mode Tests
- 集成测试，运行游戏场景
- UnityTestAttribute 协程测试
- 场景加载测试

## 移动端测试
### Android
- ADB 命令自动化
- uiautomator dump UI 检查
- 触摸事件模拟

### iOS
- XCUITest 框架
- Instruments 性能分析

## 网络同步测试
### 帧同步
- 确定性验证: 相同输入 → 相同输出
- 断线重连测试
- 录像回放验证

### 状态同步
- 状态一致性验证
- 增量同步效率
- 预测回滚测试
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 本周新增开发者工具

#### 4.1.1 Google AI Mode Skill ⭐106

**项目地址**: [PleasePrompto/google-ai-mode-skill](https://github.com/PleasePrompto/google-ai-mode-skill)

```markdown
## 核心功能
将 Claude Code 连接到 Google AI Mode，获取 AI 综合答案
- 从 100+ 来源获取综合答案
- 内联引用 [1][2][3]
- 无需 API 密钥
- 节省 token

## 工作原理
Claude 提问 → 隐身浏览器 → Google AI Mode 搜索综合 →
提取答案+引用 → Markdown 格式 → Claude 接收

## v2.0 更新 (2026-01-08)
✅ 4 阶段完成检测
✅ 多语言支持 (DE/EN/NL/ES/FR/IT)
✅ 87% 更快检测 (4s vs 30s+)
✅ AI Mode 可用性检查
✅ 17 个引用选择器
✅ 15 个截断标记

## 示例用例
"Next.js 15 App Router best practices 2026"
"Compare PostgreSQL vs MySQL JSON performance 2026"
"Best noise-cancelling headphones under €300"
```

#### 4.1.2 Perseus Security Skills ⭐26

**项目地址**: [kaivyy/perseus](https://github.com/kaivyy/perseus)

```markdown
## 多语言支持 (8 种语言)
| 语言 | 框架 |
|------|------|
| JavaScript/TypeScript | Express, Fastify, Next.js, Nest.js, Hono, Bun |
| Go | Gin, Echo, Fiber, Chi |
| PHP | Laravel, Symfony, Slim, Lumen |
| Python | FastAPI, Django, Flask, Starlette |
| Rust | Actix-web, Axum, Rocket, Warp |
| Java | Spring Boot, Quarkus, Micronaut |
| Ruby | Rails, Sinatra, Grape |
| C# | ASP.NET Core, Minimal APIs |

## 智能 Auto-Detection
- 语言 & 框架 (Next.js, Django, Spring 等)
- 数据库 (PostgreSQL, MongoDB, Redis 等)
- 基础设施 (Docker, Kubernetes, AWS/GCP/Azure)
- CI/CD (GitHub Actions, GitLab CI, Jenkins)
- AI/LLM (OpenAI, Anthropic, LangChain)

## 安全覆盖
- API 安全: REST, GraphQL, WebSocket, gRPC, OAuth
- 注入: SQL, NoSQL, Command, SSTI, LDAP, XPath, Log4j
- 基础设施: Docker, CI/CD, Cloud, Kubernetes
- AI 安全: Prompt 注入, RAG 安全
- 客户端: React, Next.js SSR, Vue, Angular

## Engagement Modes
| Mode | 环境 | 验证风格 |
|------|------|---------|
| PRODUCTION_SAFE | 生产环境 | 被动优先检查 |
| STAGING_ACTIVE | 预发布 | 主动验证+节流 |
| LAB_FULL | 隔离实验室 | 广泛动态验证 |
| LAB_RED_TEAM | 安全实验室 | 受控对抗模拟 |
```

#### 4.1.3 Claude Skills (97 Skills) ⭐17

**项目地址**: [borghei/Claude-Skills](https://github.com/borghei/Claude-Skills)

```markdown
## 内容
- 97 个专家级 Skills
- 178 个 Python 自动化工具
- 6 个 Subagents
- 12 个 CI/CD 工作流
- 13 个专业领域

## 支持平台 (10+)
Claude Code, Cursor, Copilot, Codex, Windsurf, Cline, Aider, Goose, Jules, RooCode

## 领域覆盖
Engineering, Marketing, Product, Project Management, C-Level Advisory,
RA/QM Compliance, Business Growth, Finance, Data Analytics, HR, Sales,
Advanced Engineering, Standards

## 安装方式
# Claude Code Plugin Marketplace
/plugin marketplace add borghei/Claude-Skills
/plugin install engineering-skills@claude-code-skills

# Universal Installer
npx agent-skills-cli add borghei/Claude-Skills
```

#### 4.1.4 Claudex ⭐222

**项目地址**: [Mng-dev-ai/claudex](https://github.com/Mng-dev-ai/claudex)

```markdown
## 功能
- 自定义 Claude Code UI
- 沙箱环境
- 浏览器内 VS Code
- 终端集成
- 多提供商支持 (Anthropic, OpenAI, GitHub Copilot, OpenRouter)
- 自定义 skills
- MCP 服务器支持
```

#### 4.1.5 Claude Code Manager ⭐17

**项目地址**: [simonstrumse/claude-code-manager](https://github.com/simonstrumse/claude-code-manager)

```markdown
## 功能
- 查看 MCP servers, skills, commands, rules, CLAUDE.md
- TUI 界面
- 一站式管理
```

#### 4.1.6 Repren ⭐370

**项目地址**: [jlevy/repren](https://github.com/jlevy/repren)

```markdown
## 功能
- 强大的重命名/重构工具
- 现已支持 Claude Code skill
```

### 4.2 开发者工具 Skills 排行

| Skill | 评分 | 核心能力 | Stars |
|-------|------|---------|-------|
| github | 3.790 | GitHub 基础操作 | - |
| agent-browser | 3.772 | 浏览器自动化 | - |
| automation-workflows | 3.699 | 工作流自动化 | - |
| docker-essentials | 3.694 | Docker 基础 TOP 1 | - |
| playwright-skill | 3.584 | 浏览器自动化测试 | 1848 |
| claude-skills-marketplace | - | Git/测试/审查 | 428 |
| repren | - | 重命名/重构 | 370 |
| claudex | - | 自定义 UI + 沙箱 | 222 |
| google-ai-mode-skill | - | Google AI Mode 搜索 | 106 |
| perseus | - | 安全评估 | 26 |
| git-essentials | 1.298 | Git 基础 TOP 1 | - |

---

## 📈 五、Skills 趋势分析

### 5.1 热门趋势

1. **游戏开发工作室化**
   - Claude Code Game Studios 引入完整工作室层级
   - 48 agents + 36 skills 模拟真实团队
   - 三层架构: Directors → Leads → Specialists

2. **自学习 AI 系统**
   - claude-reflect-system 实现"纠正一次，永不重复"
   - 从用户反馈中创建永久学习
   - 解决传统 AI 会话间遗忘问题

3. **代码审查专业化**
   - beagle 提供 82 skills + 27 commands
   - 多语言审查支持 (Python/Go/Elixir/iOS/React/AI)
   - LLM 编码痕迹检测

4. **安全评估智能化**
   - perseus 支持 8 种语言 + 5 种框架
   - 智能 Auto-Detection
   - 4 种 Engagement Modes

### 5.2 Stars 排行 (本周新增)

| 仓库 | Stars | 类别 |
|------|-------|------|
| ai-guide (鱼皮) | 8803 | AI 资源大全 |
| playwright-skill | 1848 | 浏览器自动化 |
| claudex | 222 | 自定义 UI |
| repren | 370 | 重构工具 |
| claude-skills-marketplace | 428 | 测试/审查 |
| developer-kit | 131 | 模块化插件 |
| claude-reflect-system | 70 | 自学习系统 |
| google-ai-mode-skill | 106 | AI 搜索 |
| perseus | 26 | 安全评估 |
| Claude-Code-Game-Studios | 28 | 游戏开发 |

### 5.3 Skills 缺口与建议

| 缺口领域 | 现状 | 建议 |
|---------|------|------|
| 游戏客户端自动化测试 | Unity Test Framework 有覆盖，但缺乏端到端自动化 | 开发 Unity+Playwright 集成 Skill |
| 帧同步确定性测试 | 缺乏专业指导 | 开发 game-frame-sync-tester Skill |
| 游戏性能基准测试 | 缺乏统一方案 | 开发 unity-performance-benchmark Skill |
| 移动端游戏 CI/CD | 缺乏专门流水线 | 开发 mobile-game-ci Skill |

---

## 📎 附录

### A. 本周新增 Skills 汇总

| Skill | 类别 | Stars | 核心能力 |
|-------|------|-------|---------|
| Claude-Code-Game-Studios | 游戏开发 | 28 | 48 agents + 36 skills |
| GameMaker Skills | 游戏开发 | 2 | GML 完整开发 |
| Love2D Pocket Bomber | 游戏开发 | 11 | Love2D 示例 |
| AI Guide | AI 资源 | 8803 | 零基础教程 |
| Developer Kit | 模块化 | 131 | 6 技术栈插件 |
| Beagle | 代码审查 | 34 | 82 skills + 27 commands |
| Claude Reflect | 自学习 | 70 | 永久学习系统 |
| Playwright Skill | 测试 | 1848 | 浏览器自动化 |
| Claude Skills Marketplace | 测试/审查 | 428 | Git/测试/审查 |
| Agent Skills | 多功能 | 9 | 88 专业 Agents |
| Google AI Mode | 搜索 | 106 | AI 综合搜索 |
| Perseus | 安全 | 26 | 8 语言安全评估 |
| Claude Skills (97) | 综合 | 17 | 97 skills + 178 tools |
| Claudex | UI | 222 | 自定义 UI + 沙箱 |
| Claude Code Manager | 管理 | 17 | TUI 管理工具 |
| Repren | 重构 | 370 | 重命名/重构 |

### B. 按类别分类的新增 Skills

#### 游戏客户端开发
- Claude-Code-Game-Studios (28⭐)
- OH-Unity-GameDev-Skills (6⭐)
- unity-ai-workflow (4⭐)
- gamemaker-skills (2⭐)
- love2d-pocket-bomber (11⭐)
- claude-resources (Godot) (3⭐)
- solana-game-skill (5⭐)

#### Python 开发
- developer-kit (131⭐)
- beagle-python (34⭐)
- claude-reflect-system (70⭐)

#### 测试自动化
- playwright-skill (1848⭐)
- claude-skills-marketplace (428⭐)
- agent-skills (9⭐)

#### 开发者工具
- google-ai-mode-skill (106⭐)
- perseus (26⭐)
- Claude-Skills (17⭐)
- claudex (222⭐)
- claude-code-manager (17⭐)
- repren (370⭐)

---

## 📝 本周更新亮点

### 新增 Skills

1. **Claude Code Game Studios** - 48 agents + 36 skills 完整游戏工作室
2. **GameMaker Skills** - GameMaker Studio 2 和 GML 完整开发
3. **Claude Reflect System** - 自学习 AI 系统，"纠正一次，永不重复"
4. **Beagle** - 82 skills + 27 commands 代码审查插件
5. **Perseus** - 8 语言安全评估 Skills
6. **Google AI Mode Skill** - 连接 Google AI Mode 的免费研究工具

### 趋势分析

1. **游戏开发专业化**: 从单一 Skill 到完整工作室层级
2. **自学习能力**: AI 开始从用户反馈中永久学习
3. **代码审查增强**: 多语言、多框架的审查支持
4. **安全评估智能化**: Auto-Detection + 多模式验证

### 下周计划

1. 继续调研游戏客户端自动化测试 Skills
2. 深入分析帧同步确定性测试方案
3. 调研移动端游戏 CI/CD 流水线 Skills
4. 搜索更多 Godot 4 相关 Skills

---

*文档更新于 2026-03-04*
