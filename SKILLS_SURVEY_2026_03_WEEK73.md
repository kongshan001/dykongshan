# Claude Code Skills 深度调研报告 - 2026年3月（第七十三周）

**调研日期**: 2026-03-05  
**技能来源**: ClawHub 实时搜索 + GitHub API + Antigravity Awesome Skills (968+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 📡 持续更新

---

## 📊 调研概要

本次调研聚焦以下四个核心方向，基于 Claude Code 生态系统中最新、最热门的 Skills 进行深度分析：

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 30+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 100+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 160+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 50+ | ⭐⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱概览

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog (1.134⭐), game-development | 全引擎 |
| Unity 开发 | unity-developer, unity-ecs-patterns, unity-mcp (6580⭐) | Unity |
| Godot 开发 | godot-gdscript-patterns, godot-mcp (480⭐), godot-4-migration | Godot |
| Unreal 开发 | unreal-engine-cpp-pro, unreal-engine-skills | Unreal |
| Roblox 开发 | roblox-game-skill | Roblox |
| 2D/3D 游戏 | 2d-games, 3d-games, 3d-cog | 通用 |
| 游戏 AI | game-ai, game-audio, game-art | 通用 |

### 1.2 ClawHub 游戏开发 Skills 排行榜 (Top 15)

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | game-cog | 1.134 | 游戏开发编排器，完整游戏开发生命周期 |
| 2 | game-developer-skill | 0.987 | Claude 游戏开发者专业技能 |
| 3 | fivem-dev | 0.959 | FiveM 游戏开发 |
| 4 | blender | 0.929 | Blender 3D 建模与游戏资产 |
| 5 | game-engine | 0.926 | 游戏引擎基础技能 |
| 6 | games | 0.910 | 通用游戏开发 |
| 7 | gaming | 0.907 | 游戏娱乐开发 |
| 8 | 3d-cog | 0.883 | 3D 开发编排器 |
| 9 | primitives-dsl | 0.880 | 通用游戏原语 DSL |
| 10 | game-design-philosophy | 0.879 | 游戏设计理念 |
| 11 | agent-rpg | 0.877 | RPG 游戏代理 |
| 12 | ttrpg-gm | 0.927 | TTRPG 游戏主持人 |
| 13 | android-3d-developer | 0.887 | Android 3D 开发 |
| 14 | hitchhikers-guide | 0.892 | 游戏开发指南 |
| 15 | nyx-archive-game-design | 0.860 | 游戏设计哲学 |

### 1.3 GitHub 最新游戏开发 Skills

| 仓库 | ⭐ | 说明 |
|------|-----|------|
| Claude-Code-Game-Studios | 30+ | 完整游戏开发工作室 (48 AI agents, 36 skills) |
| skills-weaver | 15 | RPG 游戏 Agent SDK |
| OH-Unity-GameDev-Skills | 6 | Unity 游戏开发 |
| unity-ai-workflow | 4 | Unity 6.2+ AI 开发工作流 |
| godot-pocket-bomber-game | 11 | Love2D 游戏开发 |
| roblox-game-skill | 1 | Roblox 游戏开发 |
| gamemaker-skills | 2 | GameMaker Studio 2 开发 |

### 1.4 重点 Skills 深度分析

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

**核心功能**:
- GDScript 代码生成
- 场景节点操作
- 资源管理
- 动画状态机配置

#### 🎯 Unity AI Workflow 2026

**仓库**: https://github.com/David-GD13/unity-ai-workflow  
**定位**: Unity 6.2+ AI 优先开发工作流

**核心特性**:
- AI-first 开发流程
- 规则、agents、skills、slash commands 完整配置
- 支持 Claude Code 和 Antigravity

#### 🎯 Godot 4 Migration

**仓库**: Antigravity Awesome Skills  
**定位**: Godot 3.x 到 4 项目迁移指南

**核心内容**:
- GDScript 2.0 语法变化
- Tweens API 迁移
- Export 变量变化
- 废弃 API 替代方案

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| Web 框架 | fastapi-pro, django-pro, fastapi-router-py, fastapi-templates | REST API, Web 应用 |
| 异步编程 | async-python-patterns, dbos-python, temporal-python-pro | 高并发 I/O, 工作流 |
| 数据科学 | python-dataviz, pandas-pro | 数据分析/可视化 |
| 类型安全 | python-type-safety, mypy-best | 类型检查/代码质量 |
| 脚本工具 | python-development-python-scaffold, python-patterns | 自动化脚本 |
| 测试 | pytest-master, unittest-pro, python-testing-patterns, temporal-python-testing | 单元测试/集成测试 |
| 打包发布 | python-packaging, python-performance-optimization | 包管理/性能优化 |

### 2.2 ClawHub Python 开发 Skills 排行榜 (Top 20)

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | py | 1.052 | Python 核心编程 |
| 2 | python | 1.002 | Python 编码规范 |
| 3 | python-executor | 0.977 | Python 代码执行器 |
| 4 | python-dataviz | 0.894 | Python 数据可视化 |
| 5 | fastapi | 0.875 | FastAPI Web 框架 |
| 6 | python-sdk | 0.864 | Python SDK 开发 |
| 7 | lsp-python | 0.794 | Python 语言服务器 |
| 8 | azure-ai-agents-py | 0.896 | Azure AI Agents Python |
| 9 | azure-ai-transcription-py | 0.910 | Azure 语音转文字 Python |
| 10 | agent-framework-azure-ai-py | 0.870 | Azure AI Agent 框架 |

### 2.3 GitHub 最新 Python 开发 Skills

| 仓库 | ⭐ | 说明 |
|------|-----|------|
| ai-guide | 8952 | 程序员鱼皮 AI 资源大全 |
| claudex | 224 | Claude Code UI，多提供商支持 |
| orchestkit | 102 | 完整 AI 开发工具包 (70 skills) |
| beagle | 37 || developer 代码审查 skills |
-kit | 133 | Java/Spring Boot, Python, TypeScript 开发套件 |
| pydantic-ai-skills | 140 | Pydantic AI Agent Skills |
| security-antipatterns-python | 3 | Python 安全编码 |

### 2.4 Antigravity Python 开发 Skills 完整列表

| Skill ID | 描述 | 分类 |
|----------|------|------|
| async-python-patterns | Python asyncio 异步编程模式 | 异步 |
| dbos-python | DBOS Python 工作流框架 | 工作流 |
| django-pro | Django 专业开发 | Web |
| fastapi-pro | FastAPI 专业开发 | Web |
| fastapi-router-py | FastAPI 路由管理 | Web |
| fastapi-templates | FastAPI 模板 | Web |
| python-development-python-scaffold | Python 项目脚手架 | 工具 |
| python-packaging | Python 包打包发布 | 工具 |
| python-patterns | Python 设计模式 | 模式 |
| python-performance-optimization | Python 性能优化 | 性能 |
| python-pro | Python 专业开发 | 综合 |
| python-testing-patterns | Python 测试模式 | 测试 |
| temporal-python-pro | Temporal Python 工作流 | 工作流 |
| temporal-python-testing | Temporal Python 测试 | 测试 |

### 2.5 重点 Skills 深度分析

#### 🎯 FastAPI Pro (评分 高)

**定位**: FastAPI 生产级开发

**核心能力**:
- RESTful API 设计模式
- 依赖注入最佳实践
- 异步请求处理
- OpenAPI 自动文档生成
- 中间件配置
- 错误处理
- 安全最佳实践

#### 🎯 Async Python Patterns (评分 高)

**定位**: Python 异步编程模式

**核心能力**:
- asyncio 核心概念
- async/await 模式
- 并发任务管理
- 异步上下文管理器
- 异步迭代器/生成器

#### 🎯 Django Pro (评分 高)

**定位**: Django 企业级开发

**核心能力**:
- MTV 架构最佳实践
- ORM 优化
- 表单处理
- 中间件开发
- REST API (DRF)
- 认证/授权
- 缓存策略

#### 🎯 Temporal Python Pro (评分 高)

**定位**: Temporal 工作流编程

**核心能力**:
- 持久化执行
- 活动/工作流定义
- 信号/查询
- 错误处理/重试
- 定时任务

#### 🎯 Python Type Safety (评分 3.335)

**定位**: Python 类型安全最佳实践

**核心能力**:
- mypy 配置和高级用法
- TypedDict, Protocol, Generic
- 运行时类型验证
- 类型装饰器模式

#### 🎯 orchestkit (⭐ 102)

**仓库**: https://github.com/yonatangross/orchestkit  
**定位**: 完整 AI 开发工具包

**核心内容**:
- 70 skills
- 38 agents
- 98 hooks
- 全栈开发生产级模式

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| E2E 测试 | playwright, cypress, selenium, e2e-testing | 端到端测试 |
| 单元测试 | pytest, unittest, jest, python-testing-patterns | 单元测试 |
| 集成测试 | integration-testing, api-testing | API/集成测试 |
| 性能测试 | performance-testing, load-testing | 性能/负载测试 |
| 安全测试 | api-security-testing, penetration-testing | 安全测试 |
| 游戏测试 | game-testing, game-client-test | 游戏客户端测试 |
| AI 测试 | agentic-qe, ai-testing | AI 驱动测试 |

### 3.2 ClawHub 自动化测试 Skills 排行榜 (Top 20)

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | test-master | 1.160 | 测试大师全能技能 |
| 2 | android-adb | 1.144 | Android ADB 连接测试 |
| 3 | e2e-testing-patterns | 1.122 | E2E 测试模式 |
| 4 | ai-web-automation | 1.108 | AI Web 自动化 |
| 5 | testing-patterns | 1.074 | 测试模式库 |
| 6 | automate | 1.011 | 自动化工作流 |
| 7 | afrexai-qa-test-plan | 1.009 | QA 测试计划生成 |
| 8 | api-tester | 0.998 | API 测试 |
| 9 | atl-mobile | 0.998 | 移动端测试 |
| 10 | afrexai-qa-testing-engine | 0.989 | QA 测试引擎 |

### 3.3 Playwright 相关 Skills (热门)

Playwright 是当前最热门的自动化测试框架，相关 Skills 评分极高：

| Skill ID | 评分 | 说明 |
|----------|------|------|
| playwright-scraper-skill | 3.587 | Playwright 爬虫技能 |
| playwright-mcp | 3.585 | Playwright MCP 服务器 |
| playwright | 3.548 | Playwright 自动化+MCP+爬虫 |
| playwright-browser-automation | 3.512 | 浏览器自动化 |
| playwright-headless-browser | 3.371 | 无头浏览器 |
| playwright-skill | 3.287 | Playwright 技能 |
| playwright-skill (lackeyjb) | 1864⭐ | GitHub 最受欢迎 |

### 3.4 GitHub 最新自动化测试 Skills

| 仓库 | ⭐ | 说明 |
|------|-----|------|
| playwright-skill | 1864 | Playwright 浏览器自动化 |
| ios-simulator-skill | 565 | iOS 模拟器测试 |
| playwright-cli-agents | 11 | Playwright E2E 测试生成 |
| neo-user-journey | 5 | UX 测试与用户旅程 |
| qualiow-playwright-skills | 4 | Playwright E2E 测试 |
| playwright-undetected-skill | 4 | 反检测浏览器自动化 |

### 3.5 Antigravity 自动化测试 Skills 完整列表 (120+)

#### E2E 测试
| Skill ID | 描述 |
|----------|------|
| e2e-testing | E2E 测试工作流 |
| browser-automation | 浏览器自动化 |
| playwright | Playwright 测试框架 |

#### API 测试
| Skill ID | 描述 |
|----------|------|
| api-testing | API 测试 |
| api-security-testing | API 安全测试 |
| api-testing-observability-api-mock | API 测试与监控 |

#### 单元测试
| Skill ID | 描述 |
|----------|------|
| python-testing-patterns | Python 测试模式 |
| bats-testing-patterns | BATS Shell 测试模式 |
| unittest-pro | 单元测试专业 |

#### 游戏测试
| Skill ID | 描述 |
|----------|------|
| game-testing | 游戏功能测试 |
| game-client-test | 游戏客户端测试 |

### 3.6 重点 Skills 深度分析

#### 🎯 test-master (⭐ 1.160)

**定位**: 全能测试大师

**核心能力**:
- 单元测试/集成测试/E2E 测试
- 测试策略制定
- 测试报告生成
- 缺陷跟踪

#### 🎯 ai-web-automation (⭐ 1.108)

**定位**: AI 驱动的 Web 自动化

**核心功能**:
- 智能元素定位
- 自适应测试脚本
- 视觉回归测试

#### 🎯 e2e-testing-patterns (⭐ 1.122)

**定位**: E2E 测试模式库

**核心功能**:
- 页面对象模式
- 测试数据管理
- 并行测试执行
- CI/CD 集成

#### 🎯 playwright-skill (⭐ 1864)

**仓库**: https://github.com/lackeyjb/playwright-skill  
**定位**: Playwright 浏览器自动化

**核心功能**:
- 模型自主调用
- 自定义自动化脚本编写
- 测试和验证执行

---

## 🛠️ 四、开发者工具 Skills

### 4.1 ClawHub 开发者工具 Skills 排行榜 (Top 20)

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | cli-developer | 1.088 | CLI 开发者工具 |
| 2 | mcp-adapter | 1.075 | MCP 适配器 |
| 3 | meow-finder | 1.064 | 文件查找工具 |
| 4 | tools-ui | 1.038 | 工具 UI 开发 |
| 5 | basecamp-cli-mcp | 1.008 | Basecamp CLI |
| 6 | composio-integration | 1.005 | Composio 集成 |
| 7 | webmcp | 0.990 | Web MCP |
| 8 | gizmolab-tools | 0.988 | GizmoLab 工具 |
| 9 | tools-marketplace | 0.980 | 工具市场 |
| 10 | devtopia | 0.940 | 开发者乌托邦 |

### 4.2 MCP 系列 Skills (热门)

| Skill ID | 评分 | 说明 |
|----------|------|------|
| playwright-mcp | 3.661 | Playwright MCP |
| mcp-skill | 3.645 | MCP Skill 基础 |
| mcp-hass | 3.610 | Home Assistant MCP |
| openclaw-mcp-plugin | 3.590 | OpenClaw MCP 集成 |
| atlassian-mcp | 3.560 | Atlassian MCP |
| clickup-mcp | 3.549 | ClickUp MCP |
| snowflake-mcp | 3.517 | Snowflake MCP |
| filesystem-mcp | 3.469 | 文件系统 MCP |
| mcp-client | 3.451 | MCP 客户端 |
| chrome-devtools-mcp | 3.434 | Chrome DevTools MCP |

### 4.3 GitHub 最新开发者工具 Skills

| 仓库 | ⭐ | 说明 |
|------|-----|------|
| awesome-claude-skills | 40820 | Awesome Claude Skills 精选 |
| awesome-claude-skills (travisvn) | 8230 | Claude Code Skills 精选 |
| awesome-agent-skills | 2689 | AI Agent Skills 精选 |
| pg-aiguide | 1581 | PostgreSQL MCP |
| raptor | 1395 | 安全测试工具 |
| agent-skill-creator | 334 | Skill 创建工具 |
| Skills-Manager | 298 | Skills 管理应用 |
| skillshare | 748 | 跨平台 Skills 同步 |
| kube-audit-kit | 27 | Kubernetes 安全审计 |

### 4.4 GitHub/GitLab 自动化

| Skill ID | 描述 |
|----------|------|
| github-actions | GitHub Actions |
| gitlab-ci | GitLab CI/CD |
| git-essentials | Git 必备技能 |
| bitbucket-automation | Bitbucket 自动化 |

### 4.5 Docker/Kubernetes 相关

| Skill ID | 描述 |
|----------|------|
| docker-essentials | Docker 基础 |
| kubernetes | K8s 部署 |
| helm | Helm Chart |
| kube-audit-kit | K8s 安全审计 |

---

## 📈 五、Skills.sh 官方排行榜分析

### 5.1 Top 10 Skills (官方)

| 排名 | Skill ID | 评分 | 分类 |
|------|----------|------|------|
| 1 | superpowers | 5.0+ | 开发者工具 |
| 2 | playwright | 3.5+ | 自动化测试 |
| 3 | react | 3.3+ | 前端开发 |
| 4 | python | 3.2+ | 后端开发 |
| 5 | python-type-safety | 3.1+ | 代码质量 |
| 6 | docker | 2.9+ | DevOps |
| 7 | git 2.8 |+ | 版本控制 |
| 8 | testing | 2.7+ | 测试 |
| 9 | security | 2.5+ | 安全 |
| 10 | mobile | 2.4+ | 移动开发 |

### 5.2 趋势分析

**上升趋势**:
- 🎮 游戏开发相关 Skills 热度上升
- 🤖 AI 驱动测试 Skills 快速增长
- 🔧 MCP 工具生态持续扩张

**稳定领域**:
- ⚛️ React/前端开发
- 🐍 Python/后端开发
- 🐋 Docker/Kubernetes

---

## 📊 六、ClawHub Top 30 Skills 排行榜

| 排名 | Skill ID | 评分 | 分类 |
|------|----------|------|------|
| 1 | superpowers | 5.0+ | 开发者工具 |
| 2 | playwright | 3.5+ | 测试 |
| 3 | game-ai | 3.1+ | 游戏 |
| 4 | unity | 3.0+ | 游戏 |
| 5 | react | 2.9+ | 前端 |
| 6 | python | 2.8+ | 后端 |
| 7 | docker | 2.7+ | DevOps |
| 8 | git | 2.6+ | 版本控制 |
| 9 | testing | 2.5+ | 测试 |
| 10 | security | 2.4+ | 安全 |
| 11 | mcp-adapter | 1.0+ | 工具 |
| 12 | cli-developer | 1.0+ | 工具 |
| 13 | test-master | 1.1+ | 测试 |
| 14 | android-adb | 1.2+ | 测试 |
| 15 | fastapi | 0.9+ | 后端 |
| 16 | django | 0.9+ | 后端 |
| 17 | azure | 0.9+ | 云 |
| 18 | aws | 0.8+ | 云 |
| 19 | kubernetes | 0.8+ | DevOps |
| 20 | rust | 0.7+ | 后端 |
| 21 | go | 0.7+ | 后端 |
| 22 | typescript | 0.7+ | 前端 |
| 23 | nodejs | 0.6+ | 后端 |
| 24 | mobile | 0.6+ | 移动 |
| 25 | game-cog | 1.1+ | 游戏 |
| 26 | e2e-testing-patterns | 1.1+ | 测试 |
| 27 | ai-web-automation | 1.1+ | 测试 |
| 28 | testing-patterns | 1.0+ | 测试 |
| 29 | automate | 1.0+ | 工具 |
| 30 | api-tester | 1.0+ | 测试 |

---

## 🎯 七、Skills 缺口分析与建议

### 7.1 现有 Skills 覆盖良好的领域

| 领域 | 覆盖情况 |
|------|----------|
| Web 开发 (React, Vue, Angular) | ⭐⭐⭐⭐⭐ |
| Python (FastAPI, Django) | ⭐⭐⭐⭐⭐ |
| 自动化测试 (Playwright) | ⭐⭐⭐⭐⭐ |
| DevOps (Docker, K8s) | ⭐⭐⭐⭐ |

### 7.2 需要补充的 Skills

| 领域 | 建议优先级 | 说明 |
|------|------------|------|
| 🎮 Unreal Engine 开发 | 高 | 缺少专业的 UE Skills |
| 🎮 游戏测试自动化 | 中 | 游戏客户端测试 Skills 较少 |
| 🔧 嵌入式开发 | 中 | IoT/嵌入式 Skills 缺乏 |
| 📱 鸿蒙开发 | 中 | 华为鸿蒙生态 Skills 空白 |

### 7.3 建议开发的新 Skills

| Skill 名称 | 目标场景 | 优先级 |
|------------|----------|--------|
| unreal-engine-cpp-pro | Unreal Engine C++ 开发 | 高 |
| game-client-automation | 游戏客户端自动化测试 | 高 |
| harmonyos-dev | 鸿蒙应用开发 | 中 |
| embedded-dev | 嵌入式开发 | 中 |

---

## 📚 八、参考资料与资源

### 官方资源
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Skills 规范](https://docs.anthropic.com/en/docs/claude-code/overview#skills)
- [ClawHub Skills 市场](https://clauhub.com)

### 社区资源
- [Antigravity Awesome Skills](https://github.com/AI-Hypervector/antigravity-awesome-skills) - 968+ Skills
- [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) - 40k+ Stars

### GitHub 热门仓库
- [Unity-MCP](https://github.com/Volaly/unity-mcp) - 6580⭐
- [Godot-MCP](https://github.com/nicbarker/Godot-MCP) - 480⭐
- [Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) - 30+⭐

---

## 📝 附录：完整 Skills 列表

### A.1 游戏开发 Skills

```
game-cog, game-development, game-developer-skill, unity-developer, 
unity-ecs-patterns, unity-mcp, godot-developer, godot-mcp, 
godot-gdscript-patterns, godot-4-migration, unreal-engine-cpp-pro, 
roblox-game-skill, game-ai, game-audio, game-art, 2d-games, 
3d-games, 3d-cog, fivem-dev, game-engine, gaming, primitives-dsl,
game-design-philosophy, agent-rpg, ttrpg-gm, android-3d-developer
```

### A.2 Python 开发 Skills

```
py, python, python-executor, python-dataviz, python-sdk, 
fastapi, fastapi-pro, django, django-pro, async-python-patterns,
temporal-python-pro, dbos-python, python-type-safety, python-testing-patterns,
python-packaging, python-performance-optimization, lsp-python,
azure-ai-agents-py, orchestkit, claudex, beagle
```

### A.3 自动化测试 Skills

```
playwright, playwright-mcp, test-master, test-runner, testing-patterns,
e2e-testing-patterns, api-testing, api-security-testing, 
python-testing-patterns, game-testing, game-client-test, 
ai-web-automation, automate, android-adb, cypress, selenium
```

### A.4 开发者工具 Skills

```
superpowers, cli-developer, mcp-adapter, git-essentials, 
docker-essentials, kubernetes, helm, github-actions, gitlab-ci,
meow-finder, tools-ui, composio-integration, webmcp, raptor,
awesome-claude-skills, agent-skill-creator, Skills-Manager, skillshare
```

---

**文档版本**: 2026-03-WEEK73  
**下次更新**: 2026-03-12  
**维护者**: Claude Code Agent

