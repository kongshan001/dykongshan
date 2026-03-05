# Claude Code Skills 深度调研报告 - 2026年3月（第六十五周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + ClawHub 排行榜 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 📡 持续更新

---

## 📊 调研概要

本次调研聚焦以下四个核心方向，基于 Claude Code 生态系统中最新、最热门的 Skills 进行深度分析：

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 20+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 60+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 130+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 30+ | ⭐⭐⭐⭐ |

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

### 1.4 GitHub 新增游戏开发 Skills

| 技能 | ⭐ | 说明 |
|------|-----|------|
| OH-Unity-GameDev-Skills | 6 | Unity 游戏开发 agent skills |
| unity-ai-workflow | 4 | Unity 6.2+ AI 开发工作流 |
| claude-resources | 3 | Godot 游戏开发自定义 agents |
| gamemaker-skills | 2 | GameMaker Studio 2 GML 开发 |
| roblox-game-skill | 1 | Roblox 游戏开发 |
| ikemen-forge | 0 | IKEMEN Go 格斗游戏开发 (9 agents) |

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱概览

| 分类 | 核心 Skills | 应用场景 |
|------|-------------|----------|
| Web 框架 | FastAPI, Django, Flask | API 开发 |
| 异步编程 | async-python-patterns | 高性能并发 |
| 数据科学 | python-dataviz, pandas, numpy | 数据分析 |
| SDK 开发 | python-sdk | 工具库开发 |
| 脚本工具 | python-script-generator | 自动化脚本 |
| Azure 集成 | azure-*-py (50+) | 云服务集成 |
| 类型安全 | python-type-safety | mypy/pyright |

### 2.2 重点 Skills 深度分析

#### 🐍 Developer Kit (⭐ 133)

**仓库**: https://github.com/giuseppe-trisciuoglio/developer-kit  
**定位**: Claude Code 开发者工具包

**核心能力**:
- 模块化插件系统
- 独立插件覆盖: Java/Spring Boot/LangChain4J, TypeScript/NestJS/React, Python, PHP/WordPress, AWS CloudFormation
- 多 CLI 支持

#### 🐍 Claude Skills Collection 2026 (⭐ 23)

**仓库**: https://github.com/inollp7855/claude-skills-collection-2026  
**定位**: 2026 年完整技能集合

**核心能力**:
- 100+ 生产就绪 Skills
- 开发、生产力、研究、自动化全覆盖
- 教育开源项目

#### 🐍 Claude Arsenal (⭐ 9)

**仓库**: https://github.com/majiayu000/claude-arsenal  
**定位**: 专业开发技能库

**核心能力**:
- 39+ 经过验证的 Skills
- 9 个专业 Agents
- 完整技能库

#### 🐍 Python Developer Tooling Handbook (⭐ 新增)

**仓库**: https://github.com/python-developer-tooling-handbook/claude-plugins  
**定位**: Python 项目现代工具链

**核心内容**:
- uv 包管理
- pytest 测试
- ruff 代码检查
- pre-commit 钩子

### 2.3 ClawHub Python 开发 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | fastapi | 1.121 | FastAPI Web 框架 |
| 2 | python-executor | 3.484 | Python 代码执行器 |
| 3 | python-type-safety | 高 | Python 类型安全 |
| 4 | async-python-patterns | 高 | 异步编程模式 |

### 2.4 GitHub 新增 Python 开发 Skills

| 技能 | ⭐ | 说明 |
|------|-----|------|
| developer-kit | 133 | 模块化插件系统，多语言支持 |
| claude-skills-collection-2026 | 23 | 100+ 生产就绪 Skills |
| spoon-awesome-skill | 12 | SpoonOS 开发 + Web3 集成 |
| claude-arsenal | 9 | 39+ 专业 Skills |
| popkit-claude | 4 | 开发流程自动化 (23 commands) |
| langchain-community-plugin | 3 | LangChain/LangGraph 开发 |
| claude-awesome-stack | 2 | 可安装栈包 |

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱概览

| 分类 | 核心 Skills | 应用场景 |
|------|-------------|----------|
| 浏览器自动化 | playwright, patchright | Web 测试 |
| E2E 测试 | e2e-testing-patterns | 端到端测试 |
| 测试运行器 | test-runner, pytest | 单元/集成测试 |
| 移动端测试 | android-adb, ios-testing | 移动应用测试 |
| 游戏测试 | game-testing, unity-test-automation | 游戏客户端测试 |
| AI 测试 | agentic-qe | AI 驱动测试 |

### 3.2 重点 Skills 深度分析

#### 🧪 Playwright Skill (⭐ 1862)

**仓库**: https://github.com/lackeyjb/playwright-skill  
**定位**: Playwright 浏览器自动化

**核心能力**:
- 模型驱动的浏览器自动化
- 自动编写和执行自定义自动化
- 测试和验证

**ClawHub 评分**: 1.9k+ ⭐, TOP 测试 Skills

#### 🧪 Claude Skills Marketplace (⭐ 431)

**仓库**: https://github.com/mhattingpete/claude-skills-marketplace  
**定位**: 软件工程工作流

**核心能力**:
- Git 自动化
- 测试Skills
- 代码审查

#### 🧪 QA WorkFlow (⭐ 新增)

**仓库**: https://github.com/islam-mamdouh/Qa-WorkFlow  
**定位**: AI 驱动 QA 自动化框架

**核心能力**:
- 完整 QA 生命周期自动化
- IEEE 829 测试计划
- 测试用例生成
- Bug 报告
- Figma 设计验证
- Jira & Figma 集成

#### 🧪 QA Test Automation Skill (⭐ 新增)

**仓库**: https://github.com/lify0921/qa-test-automation-skill  
**定位**: 测试自动化

**核心能力**:
- 从规格说明和源代码自动生成测试计划
- 测试设计
- 测试用例

### 3.3 ClawHub 自动化测试 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | playwright-mcp | 3.581 | Playwright MCP 服务器 TOP 1 |
| 2 | android-adb | 1.220 | 移动端测试 |
| 3 | test-runner | 1.189 | 测试运行器 |
| 4 | test-master | 1.178 | 测试管理 |
| 5 | test-patterns | 1.122 | 测试模式 |

### 3.4 GitHub 新增自动化测试 Skills

| 技能 | ⭐ | 说明 |
|------|-----|------|
| playwright-skill | 1862 | Playwright 浏览器自动化 |
| claude-skills-marketplace | 431 | Git/测试/代码审查 |
| claud-skills | 12 | 13 agents, 9 skills, 多语言 |
| fieldwork-skills | 12 | 实战验证 skills |
| agent-skills | 9 | 86 专业 AI agents |
| playwright-undetected-skill | 4 | bot 检测绕过 |
| casely-qa-skill | 2 | PDF → TestRail Excel |
| qa-test-automation-skill | 1 | 测试计划/用例自动生成 |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱概览

| 分类 | 核心 Skills | 应用场景 |
|------|-------------|----------|
| 容器化 | docker-essentials, kubernetes | 容器编排 |
| 版本控制 | git-essentials, github-actions | Git 工作流 |
| 云服务 | aws-skills, gcp-skills, azure-skills | 云平台集成 |
| API 开发 | rest-api-design, openapi | API 设计 |
| 数据库 | db-migration, sql-optimization | 数据库操作 |
| 监控 | logging, observability | 可观测性 |

### 4.2 重点 Skills 深度分析

#### 🛠️ Miro AI (⭐ 66)

**仓库**: https://github.com/miroapp/miro-ai  
**定位**: 官方 Miro AI 开发者工具

**核心能力**:
- MCP 服务器配置
- Claude Code Skills
- AI 驱动的 Miro  boards 体验

#### 🛠️ Claude Codex Settings (⭐ 448)

**仓库**: https://github.com/fcakyon/claude-codex-settings  
**定位**: 每日使用的实战配置

**核心能力**:
- 经过验证的 Skills
- Commands
- Hooks
- MCP 服务器

#### 🛠️ Claude Code Mastery (⭐ 441)

**仓库**: https://github.com/TheDecipherist/claude-code-mastery  
**定位**: Claude Code 完整指南

**核心内容**:
- CLAUDE.md
- Hooks
- Skills
- MCP 服务器
- Commands

#### 🛠️ Claudex (⭐ 224)

**仓库**: https://github.com/Mng-dev-ai/claudex  
**定位**: Claude Code UI

**核心能力**:
- 沙盒环境
- 浏览器内 VS Code
- 终端
- 多提供商支持
- 自定义 Skills
- MCP 服务器

### 4.3 ClawHub 开发者工具 Skills 排行榜

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | docker | 高 | Docker 容器化 |
| 2 | kubernetes | 高 | K8s 编排 |
| 3 | git-essentials | 高 | Git 基础 |
| 4 | github-actions | 高 | GitHub 自动化 |

### 4.4 GitHub 新增开发者工具 Skills

| 技能 | ⭐ | 说明 |
|------|-----|------|
| claude-codex-settings | 448 | 每日实战配置 |
| claude-code-mastery | 441 | 完整指南 |
| claudex | 224 | Claude Code UI |
| miro-ai | 66 | Miro AI 开发者工具 |
| eval-view | 49 | AI agent 回归测试 |
| roadmap-skill | 46 | 人类和 AI 共享路线图 |
| aguara | 45 | 安全扫描器 (173 规则) |
| skillboss-skills | 42 | 100+ AI 服务 MCP |

---

## 📈 五、Skills 缺口与建议

### 5.1 游戏客户端开发缺口

| 缺口领域 | 建议 |
|---------|------|
| 游戏 AI 测试 | 需开发专业的游戏客户端自动化测试 Skills |
| 游戏性能测试 | 需要游戏性能分析Skills |
| 游戏安全测试 | 游戏反作弊、安全测试 Skills 缺乏 |

### 5.2 Python 开发缺口

| 缺口领域 | 建议 |
|---------|------|
| 现代化工具链 | uv/ruff 等新工具 Skills 需要更新 |
| AI Python 框架 | LangChain/LangGraph 集成 Skills 需要加强 |

### 5.3 自动化测试缺口

| 缺口领域 | 建议 |
|---------|------|
| 游戏测试 | 游戏客户端自动化测试 Skills 缺乏 |
| AI 测试 | agentic-qe 等 AI 驱动测试需要发展 |

---

## 📚 六、参考资料

### 官方资源

- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Agent Skills 规范](https://github.com/anthropics/agent-skills)
- [ClawHub Skills 市场](https://clawhub.com)

### 社区资源

- [Antigravity Awesome Skills](https://github.com/manuandallan/antigravity-awesome-skills) - 970+ Skills
- [GitHub 热门 Skills 搜索](./)

---

## 📝 更新日志

| 日期 | 更新内容 |
|------|----------|
| 2026-03-05 | 第六十五周调研报告发布，新增 GitHub 实时搜索 Skills |

---

**文档版本**: v1.0  
**下次更新**: 第六十六周
