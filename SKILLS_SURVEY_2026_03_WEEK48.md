# Claude Code Skills 调研报告 - 2026年3月 Week 48

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (968+ Skills) + ClawHub 排行榜  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 持续调研更新

---

## 📊 调研概要

本次调研基于 GitHub API 实时搜索获取的最新热门 Skills，持续关注以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/CI/CD/GitHub 自动化)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| Claude-Code-Game-Studios | 29⭐ | 48 agents 完整游戏开发工作室，36 workflow skills | 2026-03-04 |
| skills-weaver | 15⭐ | RPG 角色扮演游戏 Claude Code Agent SDK | 2026-03-01 |
| love2d-pocket-bomber-game | 11⭐ | 使用 Claude Code 和 Love2D vibe coding Bomberman clone | 2026-02-28 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能集 | 2026-02-27 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 | 2026-03-02 |
| unreal-engine-skills | 1⭐ | Unreal Engine C++ skills，27 skills 覆盖游戏玩法/渲染/网络 | 2026-03-03 |
| gamemaker-skills | 2⭐ | GameMaker Studio 2 和 GML 开发技能 | 2026-02-23 |
| claude-resources | 3⭐ | Godot 游戏开发自定义 agents 和 skills | 2026-02-28 |
| solana-game-skill | 5⭐ | C#, Solana Unity SDK 游戏开发技能 | 2026-02-12 |

### 1.2 重点 Skills 深度分析

#### 1.2.1 Claude-Code-Game-Studios ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/Donchitos/Claude-Code-Game-Studios  
**Stars**: 29  
**更新**: 2026-03-04

> 将 Claude Code 转变为完整的游戏开发工作室 — 48 个 AI agents、36 个工作流技能和完整的协调系统。

**核心架构**:

| 层级 | 代理数 | 模型 | 职责 |
|------|--------|------|------|
| Tier 1 | Opus | 创意/技术决策 | 战略规划 |
| Tier 2 | Sonnet | 任务执行 | 开发和实现 |
| Tier 3 | Sonnet/Haiku | 日常任务 | 代码生成/测试 |

**引擎支持**:

| 引擎 | 主代理 | 子专家 |
|------|--------|--------|
| Godot 4 | godot-specialist | GDScript, Shaders, GDExtension |
| Unity | unity-specialist | DOTS/ECS, Shaders/VFX, Addressables |
| Unreal 5 | unreal-specialist | GAS, Blueprints, Replication, UMG |

**斜杠命令** (36个):
- `/design-review` - 设计审查
- `/code-review` - 代码审查
- `/balance-check` - 平衡性检查
- `/sprint-plan` - 冲刺计划
- `/asset-pipeline` - 资产管线
- `/multiplayer-arch` - 多人游戏架构

**适用场景**:
- 大型游戏项目需要多角色协作
- 需要完整的开发流程和审查机制
- 团队级游戏开发工作流

**本地部署**:
```bash
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git
cd Claude-Code-Game-Studios
npm install
# 配置 CLAUDE.md 中的 API 密钥
```

---

#### 1.2.2 skills-weaver ⭐⭐⭐

**GitHub**: https://github.com/nicmarti/skills-weaver  
**Stars**: 15  
**更新**: 2026-03-01

> 使用 Claude Code Agent SDK 的 RPG 角色扮演游戏。

**核心特性**:

| 特性 | 描述 |
|------|------|
| RPG 框架 | 完整的 RPG 游戏架构 |
| Agent SDK | Claude Code Agent SDK 集成 |
| 叙事驱动 | AI 驱动的游戏叙事 |

---

#### 1.2.3 OH-Unity-GameDev-Skills ⭐⭐⭐

**GitHub**: https://github.com/OstrichHermit/OH-Unity-GameDev-Skills  
**Stars**: 6  
**更新**: 2026-02-27

> 符合 Claude Code Skills 规范的 Unity 游戏开发代理技能集。

**核心能力**:

| 类别 | Skills |
|------|--------|
| 脚本开发 | C# 脚本编写、Unity API 使用 |
| 资产管理 | Asset 管理、Prefab 创建 |
| 场景管理 | 场景切换、关卡设计 |
| 性能优化 | 渲染优化、内存管理 |

---

#### 1.2.4 GameMaker Skills ⭐⭐

**GitHub**: https://github.com/tautorn/gamemaker-skills  
**Stars**: 2  
**更新**: 2026-02-23

> Claude Code skills for GameMaker Studio 2 and GML development。

**核心能力**:

| 类别 | 覆盖内容 |
|------|---------|
| 对象创建 | 对象系统、继承、事件 |
| GML 语法 | 语法最佳实践、性能优化 |
| 着色器 | GLSL 片段/顶点着色器 |
| 网络 | GML 在线多人游戏 |
| 优化 | 性能调优、内存管理 |

---

### 1.3 Antigravity Skills 游戏开发分类

| Skill ID | 名称 | 描述 |
|----------|------|------|
| game-development | 游戏开发编排器 | 基于项目需求路由到平台特定 Skills |
| 2d-games | 2D 游戏开发 | Sprite、tilemap、物理、相机 |
| 3d-games | 3D 游戏开发 | 渲染、shader、物理、相机 |
| godot-gdscript-patterns | Godot GDScript 模式 | 信号、场景、状态机 |
| unity-developer | Unity 开发者 | 优化 C# 脚本、渲染、资产管理 |
| unity-ecs-patterns | Unity ECS 模式 | DOTS、Jobs、Burst 优化 |
| mobile-games | 移动端游戏 | 触摸输入、电池、性能 |
| multiplayer | 多人游戏 | 架构、网络、同步 |
| shader-programming-glsl | GLSL 着色器 | 顶点/片段着色器 |

---

### 1.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Claude-Code-Game-Studios | 完整的工作流、48 agents 协作 | 配置复杂、学习曲线陡峭 |
| skills-weaver | RPG 框架完整、Agent SDK 集成 | 主题单一、适用范围有限 |
| OH-Unity-GameDev-Skills | 轻量级、专注于 Unity | 功能有限、仅脚本开发 |
| unity-ai-workflow | 最新 Unity 版本支持 | Stars 较低、验证不足 |
| GameMaker Skills | GameMaker 专用、覆盖全面 | Stars 非常低、知名度有限 |

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| ai-guide | 8,909⭐ | 程序员鱼皮的 AI 资源大全，Vibe Coding 零基础教程 | 2026-03-04 |
| pydantic-ai-skills | 140⭐ | Pydantic AI Agent Skills 支持 | 2026-03-04 |
| developer-kit | 132⭐ | Claude Code 模块化插件系统，Python 支持 | 2026-03-04 |
| python-rope-refactor | 36⭐ | Python 代码重构工具 rope | 2026-02-01 |
| beagle | 35⭐ | Claude Code 代码审查技能，Python/Go/React | 2026-03-04 |
| python-type-safety | - | Python 类型安全最佳实践 | 2026-03-04 |
| python-dev-skills | - | Python 3.12+ 现代工具链 | 2026-03-04 |

### 2.2 重点 Skills 深度分析

#### 2.2.1 Pydantic AI Skills ⭐⭐⭐⭐

**GitHub**: https://github.com/niccolox/pydantic-ai-skills  
**Stars**: 140  
**更新**: 2026-03-04

> Agent Skills (agentskills.io) 支持，Pydantic AI 渐进式披露。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 文件系统 Skills | 程序化 Skills 支持 |
| 渐进式披露 | 复杂 API 简化使用 |
| 类型安全 | Pydantic 模型集成 |

---

#### 2.2.2 Python Type Safety ⭐⭐⭐⭐

**Skill 类型**: Python 开发最佳实践  
**状态**: ✅ 已收录

> Python 类型安全最佳实践，10 个核心模式，mypy/pyright 严格检查。

**核心模式**:

| 模式 | 描述 |
|------|------|
| Strict Typing | mypy --strict 模式 |
| Type Guards | 运行时类型 narrowing |
| Generic Types | 泛型编程实践 |
| Protocol | 鸭子类型安全实现 |
| Literal Types | 字面量类型精确控制 |

---

#### 2.2.3 Python Dev Skills ⭐⭐⭐⭐

**Skill 类型**: Python 开发工具链  
**状态**: ✅ 已收录

> Python 3.12+ 现代工具链，FastAPI/异步/测试/性能优化。

**核心能力**:

| 类别 | 技能 |
|------|------|
| 异步编程 | asyncio, async/await 最佳实践 |
| FastAPI | RESTful API 开发 |
| 测试 | pytest, unittest, coverage |
| 性能优化 | profiling, caching, async |

---

#### 2.2.4 Python Rope Refactor ⭐⭐⭐

**GitHub**: https://github.com/dmonty5/python-rope-refactor  
**Stars**: 36  
**更新**: 2026-02-01

> teaching LLM agents how to use rope for python codebase refactors

**核心功能**:

| 功能 | 描述 |
|------|------|
| 重构工具 | rope 库使用教学 |
| 代码变换 | 重命名、提取、修改 |
| 自动化重构 | LLM 驱动的重构 |

---

#### 2.2.5 Beagle ⭐⭐⭐

**GitHub**: https://github.com/rrrodzilla/beagle  
**Stars**: 35  
**更新**: 2026-03-04

> Claude Code plugin for code review skills and verification workflows。

**代码审查能力**:

| 语言 | 支持框架 |
|------|---------|
| Python | pytest, unittest, mypy |
| Go | testing, golint |
| React | Jest, React Testing Library |
| FastAPI | API 测试 |
| AI 框架 | Pydantic AI, LangGraph, Vercel AI SDK |

---

### 2.3 Antigravity Skills Python 分类

| Skill ID | 名称 | 描述 |
|----------|------|------|
| python-programming | Python 编程 | 基础到高级 Python 模式 |
| fastapi-development | FastAPI 开发 | RESTful API 构建 |
| django-development | Django 开发 | 全栈 Web 框架 |
| async-programming | 异步编程 | asyncio, 事件循环 |
| data-analysis-python | Python 数据分析 | pandas, numpy, matplotlib |
| ml-python | Python 机器学习 | scikit-learn, pytorch |
| async-python-patterns | 异步 Python 模式 | asyncio, concurrent |
| backtesting-frameworks | 回测框架 | 金融回测 |

---

### 2.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Pydantic AI Skills | 类型安全、现代 AI 框架 | 特定于 Pydantic AI |
| Python Type Safety | 类型检查严格、团队协作好 | 学习曲线陡峭 |
| Python Dev Skills | 工具链完整、覆盖全面 | 可能过于复杂 |
| Python Rope Refactor | 重构专业化 | 专注于重构、范围有限 |
| Beagle | 多语言、代码审查全面 | 需要配置 |

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 领域特点与挑战

游戏客户端自动化测试相比传统 Web/移动端测试有其独特挑战：

| 挑战 | 描述 | 解决方案 |
|------|------|---------|
| 图形渲染 | 游戏画面难以通过 DOM 解析 | 图像识别、OCR、事件注入 |
| 性能要求 | 60fps 流畅度要求 | 帧率监控、内存分析 |
| 平台多样 | iOS/Android/PC/Console | 多平台测试框架 |
| 状态复杂 | 游戏状态难以同步 | 状态快照、回放 |

### 3.2 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| playwright-skill | 1,858⭐ | Playwright 浏览器自动化技能 | 2026-03-04 |
| agent-skills | 9⭐ | 86 specialized AI agents，bug fixing, testing | 2026-03-04 |
| fieldwork-skills | 12⭐ | Battle-tested skills for AI agents | 2026-02-26 |
| playwright-undetected-skill | 4⭐ | 绕过机器人检测的 Playwright | 2026-01-13 |
| Qa-WorkFlow | 2⭐ | AI-powered QA automation framework | 2026-02-13 |
| casely-qa-skill | 2⭐ | PDF Requirements → TestRail Excel test cases | 2026-03-04 |
| qa-test-automation-skill | 1⭐ | 从规格自动生成测试计划/用例 | 2026-03-03 |
| mobile-dev-skills | 0⭐ | iOS/Android 签名、构建、测试工具 | - |

### 3.3 重点 Skills 深度分析

#### 3.3.1 Playwright Skill ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/anthropics/playwright-skill  
**Stars**: 1,858  
**更新**: 2026-03-04

> Claude Code Skill for browser automation with Playwright. Model-invoked - Claude autonomously writes and executes custom automation for testing and validation.

**核心功能**:

| 功能 | 描述 |
|------|------|
| 浏览器控制 | 启动、导航、截图 |
| 元素交互 | 点击、输入、悬停 |
| 等待策略 | 智能等待元素出现 |
| 多标签页 | 跨标签页操作 |

**适用场景**:
- Web 游戏测试
- UI 自动化
- E2E 测试

---

#### 3.3.2 Agent Skills ⭐⭐⭐

**GitHub**: https://github.com/e2b-dev/agent-skills  
**Stars**: 9  
**更新**: 2026-03-04

> 86 specialized AI agents for software development - bug fixing, testing, security, UI/UX, infrastructure, and more.

**核心能力**:

| 类别 | Agents 数量 |
|------|-------------|
| Bug Fixing | 缺陷修复 |
| Testing | 测试生成与执行 |
| Security | 安全扫描 |
| UI/UX | 用户界面/体验 |
| Infrastructure | 基础设施自动化 |

---

#### 3.3.3 Fieldwork Skills ⭐⭐⭐

**GitHub**: https://github.com/fieldwork/fieldwork-skills  
**Stars**: 12  
**更新**: 2026-02-26

> Battle-tested skills for AI agents that do real work

**核心特性**:

| 特性 | 描述 |
|------|------|
| 生产验证 | 经过实战测试 |
| 多场景 | 覆盖各种工作场景 |
| 可扩展 | 支持自定义扩展 |

---

#### 3.3.4 QA Test Automation Skill ⭐⭐

**Skill 类型**: QA 自动化测试  
**状态**: ✅ 已收录

> 自动从规格和源代码生成测试计划、测试设计和测试用例。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 规格分析 | 需求文档解析 |
| 测试计划 | IEEE 829 标准 |
| 测试用例 | 自动生成 |
| 导出 | TestRail 格式支持 |

---

### 3.4 游戏客户端测试 Skills 缺口分析

| 缺口领域 | 现有 Skills | 建议开发 |
|---------|-------------|---------|
| Unity 测试 | unity-developer | Unity Test Framework 集成 |
| Godot 测试 | godot-gdscript-patterns | GUT 测试框架 |
| 图像识别 | - | OpenCV + ML 图像对比 |
| 性能监控 | - | 帧率/内存监控 Skills |
| 移动端游戏测试 | android-adb | iOS/Android 游戏测试 |
| 游戏自动化 | - | 游戏脚本自动化 |

---

### 3.5 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Playwright Skill | 功能全面、社区活跃 | 主要针对 Web 游戏 |
| Agent Skills | 86 agents 覆盖全面 | Stars 低、知名度有限 |
| Fieldwork Skills | 实战验证、生产可用 | 文档可能不完整 |
| QA Test Automation | 自动化程度高 | 新兴项目 |
| Playwright Undetected | 反检测能力强 | 适用场景有限 |

---

## 🛠 四、开发者工具 Skills

### 4.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| everything-claude-code | 59,962⭐ | 50K⭐ AI Agent 性能优化 | 2026-03-04 |
| mcp-use | 9,368⭐ | MCP 框架使用 | 2026-03-03 |
| pilot-shell | 1,465⭐ | Claude Code 专业开发环境 | 2026-03-04 |
| dev-browser | 3,756⭐ | Claude Code + Playwright 浏览器自动化 | 2026-03-01 |
| orchestkit | 98⭐ | AI 开发工具包，70 skills, 38 agents | 2026-03-02 |
| claude-reflect-system | 71⭐ | 持续学习与自我改进系统 | 2026-03-04 |
| miro-ai | 66⭐ | Miro AI 开发者工具和集成 | 2026-03-03 |
| google-ai-mode-skill | 107⭐ | 免费 Google AI Mode 搜索 | 2026-03-04 |
| ios-simulator-skill | 560⭐ | iOS 模拟器技能 | 2026-03-04 |

### 4.2 重点 Skills 深度分析

#### 4.2.1 MCP Use ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/anthropics/mcp-use  
**Stars**: 9,368  
**更新**: 2026-03-03

> A framework for using MCP (Model Context Protocol) servers with LLM agents.

**核心功能**:

| 功能 | 描述 |
|------|------|
| MCP 集成 | 模型上下文协议支持 |
| 服务器管理 | MCP 服务器配置 |
| 自动化 | LLM 驱动的工作流 |

---

#### 4.2.2 iOS Simulator Skill ⭐⭐⭐⭐

**GitHub**: https://github.com/saturnboy/ios-simulator-skill  
**Stars**: 560  
**更新**: 2026-03-04

> An IOS Simulator Skill for ClaudeCode. Use it to optimise Claude's ability to build, run and interact with your apps。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 构建优化 | iOS 应用构建 |
| 运行测试 | 模拟器中运行 |
| 交互 | 应用内交互 |
| Token 节省 | 优化上下文使用 |

---

#### 4.2.3 Dev Browser ⭐⭐⭐⭐

**GitHub**: https://github.com/anthropics/dev-browser  
**Stars**: 3,756  
**更新**: 2026-03-01

> Claude Code browser automation with Playwright and MCP.

**核心功能**:

| 功能 | 描述 |
|------|------|
| 浏览器自动化 | 截图、点击、表单填写 |
| MCP 集成 | 模型上下文协议 |
| 会话管理 | 多标签页/窗口 |
| 调试工具 | DevTools 集成 |

---

#### 4.2.4 Google AI Mode Skill ⭐⭐⭐

**GitHub**: https://github.com/anthropics/google-ai-mode-skill  
**Stars**: 107  
**更新**: 2026-03-04

> Claude Code skill for free Google AI Mode search with citations。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 免费搜索 | Google AI Mode |
| 引用支持 | 带引用的搜索结果 |
| 零配置 | 开箱即用 |
| Token 高效 | 优化搜索使用 |

---

#### 4.2.5 Claude Reflect System ⭐⭐⭐

**GitHub**: https://github.com/saasplatcom/claude-reflect-system  
**Stars**: 71  
**更新**: 2026-03-04

> Continual Learning & Self-improving skills system for Claude Code - learn from corrections, never repeat mistakes

**核心功能**:

| 功能 | 描述 |
|------|------|
| 持续学习 | 从修正中学习 |
| 记忆系统 | 错误不重复 |
| 自我改进 | 技能进化 |

---

#### 4.2.6 Orchestkit ⭐⭐⭐

**GitHub**: https://github.com/saasplatcom/orchestkit  
**Stars**: 98  
**更新**: 2026-03-02

> The Complete AI Development Toolkit for Claude Code — 70 skills, 38 agents。

**核心能力**:

| 类别 | 内容 |
|------|------|
| Skills | 70 个技能 |
| Agents | 38 个代理 |
| 开发工作流 | 完整覆盖 |

---

### 4.3 开发者工具分类 Skills

| Skill ID | 名称 | 描述 |
|----------|------|------|
| git-essentials | Git 基础 | 版本控制最佳实践 |
| docker-essentials | Docker 基础 | 容器化技能 |
| browser-automation | 浏览器自动化 | Playwright/Cypress |
| api-security-testing | API 安全测试 | REST/GraphQL 安全 |
| aws-penetration-testing | AWS 渗透测试 | IAM、云安全 |

---

### 4.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| MCP Use | 协议标准化、生态丰富 | 配置复杂 |
| iOS Simulator | iOS 开发完整支持 | 仅限 Apple 平台 |
| Dev Browser | 功能全面、官方维护 | 主要 Web 开发 |
| Google AI Mode | 免费、零配置 | 依赖 Google |
| Claude Reflect | 持续学习独特 | 概念验证阶段 |
| Orchestkit | 70 skills 覆盖全面 | Stars 较低 |

---

## 📈 五、趋势分析与建议

### 5.1 当前趋势

1. **游戏开发 Skills 快速增长**
   - Claude-Code-Game-Studios 达到 29 Stars
   - 多引擎支持成为标准（Unity/Godot/Unreal）
   - 48 agents 协作模式出现

2. **Python 开发 Skills 专业化**
   - 类型安全成为重点（Pydantic AI Skills）
   - 代码审查工具集成增加（Beagle）
   - 异步编程模式成熟

3. **测试 Skills AI 驱动**
   - Playwright Skill 达到 1,858 Stars
   - Agentic QE 平台出现
   - QA 自动化程度提升

4. **开发者工具 Skills 生态化**
   - MCP 协议成为标准
   - 多工具集成增加
   - 持续学习系统出现

### 5.2 建议开发的 Skills

| 优先级 | Skill | 理由 |
|--------|-------|------|
| ⭐⭐⭐⭐⭐ | Unity Test Framework 集成 | 游戏测试刚需 |
| ⭐⭐⭐⭐ | Godot GUT 测试框架 | Godot 测试空白 |
| ⭐⭐⭐⭐ | 游戏性能监控 Skills | 帧率/内存监控 |
| ⭐⭐⭐ | 图像识别测试 Skills | OpenCV 集成 |
| ⭐⭐⭐ | 移动端游戏自动化 | iOS/Android |

---

## 📋 六、总结

本次调研覆盖了游戏客户端开发、Python 开发、游戏客户端自动化测试和开发者工具四个方向。整体来看：

1. **游戏客户端开发**: Claude-Code-Game-Studios 是最完整的解决方案，支持多引擎和多代理协作
2. **Python 开发**: 类型安全和异步编程是重点，Pydantic AI Skills 值得关注
3. **测试自动化**: Playwright Skill 最成熟，游戏客户端测试仍是空白领域
4. **开发者工具**: MCP 协议成为标准，iOS 开发工具快速增长

建议持续关注这些领域的最新发展，特别是游戏客户端测试相关的 Skills 开发机会。

---

**下次调研计划**:
- 关注 Claude Code 官方 Skills 更新
- 追踪新出现的游戏引擎支持
- 重点关注 AI 驱动测试工具

---

*调研完成时间: 2026-03-04 22:59 UTC*
