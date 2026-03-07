# Claude Code Skills 深度调研报告 - 2026年3月（第六十六周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + ClawHub 排行榜 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 📡 持续更新

---

## 📊 调研概要

本次调研聚焦以下四个核心方向，基于 Claude Code 生态系统中最新、最热门的 Skills 进行深度分析：

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 25+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 70+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 140+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 35+ | ⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱概览

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog, game-development | 全引擎 |
| Unity 开发 | unity-developer, unity-ecs-patterns, unity-mcp | Unity |
| Godot 开发 | godot-gdscript-patterns, godot-mcp | Godot |
| Unreal 开发 | unreal-engine-cpp-pro, unreal-engine-skills | Unreal |
| Roblox 开发 | roblox-game-skill | Roblox |
| 2D/3D 游戏 | 2d-games, 3d-games | 通用 |
| 游戏 AI | game-ai, game-audio, game-art | 通用 |

### 1.2 重点 Skills 深度分析

#### 🎯 Claude-Code-Game-Studios (⭐ 30+)

**仓库**: https://github.com/Donchitos/Claude-Code-Game-Studios  
**定位**: 完整游戏开发工作室

**核心能力**:
- 48 个专业 AI Agents (策划/美术/程序/音频)
- 36 个 Workflow Skills
- 多引擎支持: Unity, Unreal, Godot, Roblox

**适用场景**:
- 大型游戏项目开发
- 团队协作工作流
- 完整游戏开发生命周期

#### 🎯 Unity-MCP (⭐ 6580)

**仓库**: https://github.com/Volaly/unity-mcp  
**定位**: AI 连接 Unity 编辑器的桥梁

**核心功能**:
| 功能模块 | 说明 |
|---------|------|
| 场景操作 | 创建/修改场景对象 |
| 组件管理 | 添加/配置 Unity 组件 |
| 资源操作 | 导入/管理资源 |
| 构建自动化 | 自动构建项目 |

#### 🎯 Godot-MCP (⭐ 480)

**仓库**: https://github.com/nicbarker/Godot-MCP  
**定位**: Godot 游戏引擎 MCP 服务器

#### 🎯 Unity AI Workflow 2026 (⭐ 新增)

**仓库**: https://github.com/David-GD13/unity-ai-workflow  
**定位**: Unity 6.2+ AI 优先开发工作流

**核心特性**:
- AI-first 开发流程
- 规则、agents、skills、slash commands 完整配置
- 支持 Claude Code 和 Antigravity

#### 🎯 Unreal Engine Skills (⭐ 新增)

**仓库**: https://github.com/quodsoler/unreal-engine-skills  
**定位**: Unreal Engine C++ 开发技能

**核心内容**:
- 27 个覆盖游戏机制、渲染、网络、动画的 Skills
- 支持 Claude Code, Cursor, Windsurf

### 1.3 ClawHub 游戏开发 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | game-ai | 3.133 | 游戏 AI 系统 |
| 2 | unity | 3.033 | Unity 开发 |
| 3 | game-cog | 1.133 | 游戏开发编排器 |
| 4 | game-developer-skill | 0.985 | Claude 游戏开发者 |
| 5 | game-engine | 0.925 | 游戏引擎 |

### 1.4 新增游戏开发 Skills

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| robotics-agent-skills | 118 | 机器人/ROS 开发技能，支持游戏机器人 |
| axiom | 562 | xOS (iOS/iPadOS/watchOS/tvOS) 开发技能 |

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱概览

| 分类 | 核心 Skills | 热度 |
|------|-------------|------|
| 框架开发 | fastapi, django-ai-plugins, flask-pro | ⭐⭐⭐⭐⭐ |
| 异步编程 | async-python, asyncio-patterns | ⭐⭐⭐⭐ |
| 类型安全 | python-type-safety, pyright, mypy | ⭐⭐⭐⭐ |
| AI 集成 | pydantic-ai-skills, langgraph-python | ⭐⭐⭐⭐⭐ |
| 代码质量 | claude-code-clean, python-linting | ⭐⭐⭐ |

### 2.2 重点 Skills 深度分析

#### 🎯 claudex (⭐ 224)

**仓库**: https://github.com/Mng-dev-ai/claudex  
**定位**: 你的私有 Claude Code UI、沙盒、浏览器内 VS Code

**核心功能**:
- 多提供商支持 (Anthropic, OpenAI, GitHub Copilot, OpenRouter)
- 自定义 Skills 和 MCP 服务器
- 浏览器内终端
- Python/TypeScript 开发

#### 🎯 beagle (⭐ 37)

**仓库**: https://github.com/existential-birds/beagle  
**定位**: Claude Code 代码审查插件

**核心能力**:
- Python, Go, React 代码审查
- FastAPI, BubbleTea 验证工作流
- Pydantic AI, LangGraph 框架支持
- 代码审查技能和验证流程

#### 🎯 security-antipatterns-python (⭐ 新增)

**仓库**: https://github.com/subhashdasyam/security-antipatterns-python  
**定位**: Python 安全最佳实践

**核心功能**:
- SQL 注入检测
- Pickle 攻击防护
- 硬编码密钥检测
- OWASP Top 10 模式检测
- 支持 Django, Flask, FastAPI

#### 🎯 software-dev-ai-claude-toolkit (⭐ 8)

**仓库**: https://github.com/Ashfaqbs/software-dev-ai-claude-toolkit  
**定位**: 后端/全栈开发者生产级配置

**核心内容**:
- 9 条规则、8 个命令、5 个 Agents、13 个 Skills
- Java/Spring Boot, Python/FastAPI, JS/React
- PostgreSQL, MongoDB, Redis, Kafka
- Docker, K8s, AI/ML

#### 🎯 python_model_visualizer_skills (⭐ 新增)

**仓库**: https://github.com/navill/python_model_visualizer_skills  
**定位**: Python Web 框架 ORM 模型可视化

**核心功能**:
- Django ORM 模型可视化
- FastAPI ORM 模型可视化
- Claude Code Skill 格式

### 2.3 ClawHub Python 开发 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | python | 1.651 | Python 核心开发 |
| 2 | fastapi | 1.075 | FastAPI Web 框架 |
| 3 | django | 0.975 | Django Web 框架 |
| 4 | py | 1.051 | Python 工具链 |
| 5 | ai-guide | 0.892 | AI 集成指南 |

### 2.4 Python 开发 Skills 完整列表

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| ai-guide | 8922+ | AI 集成全面指南 |
| pydantic-ai-skills | 140 | Pydantic AI 开发技能 |
| claudex | 224 | Claude Code UI + Python 开发环境 |
| beagle | 37 | 代码审查和验证工作流 |
| fastapi | 1075 | FastAPI 专业开发 |
| django | 975 | Django 专业开发 |
| python-executor | 3.484 | Python 代码执行器 |
| pyccsl | 81 | Python CCSL 工具 |

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱概览

| 分类 | 核心 Skills | 热度 |
|------|-------------|------|
| E2E 测试 | playwright-skill, cypress-skill | ⭐⭐⭐⭐⭐ |
| 单元测试 | pytest-pro, pytest-ai | ⭐⭐⭐⭐ |
| API 测试 | tap-test-skill, rest-api-testing | ⭐⭐⭐⭐ |
| 游戏测试 | game-client-testing, unity-test-automation | ⭐⭐⭐ |
| AI 测试 | agentic-qe, eval-view | ⭐⭐⭐⭐ |

### 3.2 重点 Skills 深度分析

#### 🎯 playwright-skill (⭐ 1863)

**仓库**: https://github.com/lackeyjb/playwright-skill  
**定位**: Playwright 浏览器自动化

**核心功能**:
- 模型驱动自动化
- Claude 自主编写和执行自定义自动化
- 测试和验证工作流

#### 🎯 agentic-qe (⭐ 218)

**仓库**: https://github.com/proffesor-for-testing/agentic-qe  
**定位**: Agentic QE Fleet 开源 QA/QE 平台

**核心能力**:
- 专门化 Agents 和 Skills 支持测试活动
- 产品 SDLC 任何阶段的支持
- 专为 Claude Code 优化
- 免费使用、Fork、构建和贡献

#### 🎯 qaskills (⭐ 71)

**仓库**: https://github.com/PramodDutta/qaskills  
**定位**: QA Skills 目录

**核心功能**:
- AI 编码代理测试专用 Skills 目录
- 支持 Claude Code, Cursor, Copilot
- 测试特定技能集合

#### 🎯 eval-view (⭐ 49)

**仓库**: https://github.com/hidai25/eval-view  
**定位**: AI Agent 回归测试

**核心功能**:
- 金基线回归测试
- 工具调用差异检测
- 输出漂移检测
- MCP 服务器 + Claude Code Skills
- 支持 LangGraph, CrewAI, Anthropic, OpenAI

#### 🎯 vibe-testing (⭐ 15)

**仓库**: https://github.com/knot0-com/vibe-testing  
**定位**: 规范压力测试

**核心功能**:
- LLM 推理规范压力测试
- 编写代码前验证规范
- 支持 Claude Code, Codex, Gemini CLI, 14+ 编码代理

#### 🎯 playwright-cli-agents (⭐ 11)

**仓库**: https://github.com/yusuftayman/playwright-cli-agents  
**定位**: Playwright E2E 测试自动化

**核心功能**:
- 自动 Playwright E2E 测试生成
- 调试和规划
- Page Object Model 模式

#### 🎯 tap-test-skill (⭐ 8)

**仓库**: https://github.com/aviz85/tap-test-skill  
**定位**: 真实 API 集成测试

**核心功能**:
- 无 Mock 真实 HTTP 测试
- 真实数据库测试
- 实际 API 集成测试

### 3.3 ClawHub 自动化测试 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | playwright | 1.931 | Playwright 测试框架 |
| 2 | testing | 1.523 | 通用测试技能 |
| 3 | qa-workflow | 1.412 | QA 工作流 |
| 4 | cypress | 1.025 | Cypress E2E 测试 |
| 5 | automated-testing | 0.875 | 自动化测试 |

### 3.4 游戏客户端自动化测试 Skills

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| game-client-testing | 新增 | 游戏客户端测试框架 |
| unity-test-automation | 新增 | Unity 测试自动化 |
| game-cog | 1.133 | 游戏开发编排器（含测试） |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱概览

| 分类 | 核心 Skills | 热度 |
|------|-------------|------|
| Git 工具 | git-essentials, github-automation | ⭐⭐⭐⭐⭐ |
| Docker/K8s | docker-essentials, kubernetes-pro | ⭐⭐⭐⭐ |
| CI/CD | github-actions, gitlab-ci | ⭐⭐⭐⭐ |
| IDE 配置 | claude-codex-settings, vscode-pro | ⭐⭐⭐⭐ |
| 云服务 | aws-pro, gcp-pro, azure-pro | ⭐⭐⭐ |

### 4.2 重点 Skills 深度分析

#### 🎯 claude-codex-settings (⭐ 448)

**仓库**: https://github.com/fcakyon/claude-codex-settings  
**定位**: 个人 Claude Code 和 OpenAI Codex 配置

**核心内容**:
- 日常使用的 Battle-tested Skills
- 命令、Hooks、Agents 和 MCP 服务器
- 生产测试模式

#### 🎯 claude-skills-marketplace (⭐ 431)

**仓库**: https://github.com/mhattingpete/claude-skills-marketplace  
**定位**: 软件工程工作流 Skills

**核心功能**:
- Git 自动化
- 测试
- 代码审查

#### 🎯 claude-code-toolkit (⭐ 44)

**仓库**: https://github.com/applied-artificial-intelligence/claude-code-toolkit  
**定位**: 生产测试命令和工作流模式

**核心能力**:
- 6+ 个月日常使用开发
- explore→plan→next→ship 工作流
- 会话切换
- MCP 集成
- 领域 Skills

#### 🎯 claude-arsenal (⭐ 9)

**仓库**: https://github.com/majiayu000/claude-arsenal  
**定位**: 39+ 生产测试 Skills + 9 专业 Agents

**核心功能**:
- 专业软件开发全面技能库
- Claude Code 最全面技能库

#### 🎯 skillnote (⭐ 5)

**仓库**: https://github.com/luna-prompts/skillnote  
**定位**: AI 编码代理开源技能注册表

**核心功能**:
- 创建、管理、分发 SKILL.md 文件
- 支持 Claude Code, Cursor, Codex, OpenHands, Windsurf
- 跨平台技能管理

#### 🎯 terramate-io/agent-skills (⭐ 26)

**仓库**: https://github.com/terramate-io/agent-skills  
**定位**: Terraform, OpenTofu, Terramate 技能

**核心内容**:
- 状态分割（Stacks 方式）
- 测试
- 模块
- CI/CD
- 漂移协调
- 生产测试最佳实践

### 4.3 ClawHub 开发者工具 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | git-essentials | 1.299 | Git 基础工具 |
| 2 | docker | 1.175 | Docker 容器化 |
| 3 | github | 1.052 | GitHub 自动化 |
| 4 | vscode | 0.985 | VS Code 配置 |
| 5 | mcp | 0.875 | MCP 服务器 |

---

## 📈 五、Skills 缺口与建议

### 5.1 游戏客户端开发

**缺口**:
- 缺乏针对游戏特定场景的自动化测试 Skills
- Unity/Godot/Unreal 的 MCP 服务器集成不够完善
- 多人游戏/网络同步测试 Skills 几乎空白

**建议**:
- 开发游戏客户端集成测试 Skills
- 补充游戏性能分析 Skills
- 创建游戏 AI 测试框架

### 5.2 Python 开发

**缺口**:
- 异步编程测试 Skills 不足
- 数据科学/机器学习管道 Skills 较少
- 安全审计 Skills 需要加强

**建议**:
- 开发 FastAPI + WebSocket 测试 Skills
- 补充 Pydantic v2 类型安全 Skills
- 创建 Python 安全审计 Skills

### 5.3 自动化测试

**缺口**:
- 游戏客户端自动化测试 Skills 几乎空白
- 移动端测试 Skills 不够丰富
- AI 模型测试 Skills 刚起步

**建议**:
- 开发 Unity/Godot 自动化测试 Skills
- 补充移动端游戏测试框架
- 创建 LLM 输出验证 Skills

---

## 📚 六、参考资料

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills) - 900+ Skills 集合
- [ClawHub](https://clawhub.com) - Skills 评分排行
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)

---

**调研周期**: 每周更新  
**贡献方式**: Fork 仓库并提交 PR  
**许可协议**: MIT
