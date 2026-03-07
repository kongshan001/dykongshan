# Claude Code Skills 深度调研报告 - 2026年3月（第七十周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + ClawHub 排行榜 + Antigravity Awesome Skills (968+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 📡 持续更新

---

## 📊 调研概要

本次调研聚焦以下四个核心方向，基于 Claude Code 生态系统中最新、最热门的 Skills 进行深度分析：

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 30+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 90+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 160+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 50+ | ⭐⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱概览

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog, game-development | 全引擎 |
| Unity 开发 | unity-developer, unity-ecs-patterns, unity-mcp (6580⭐) | Unity |
| Godot 开发 | godot-gdscript-patterns, godot-mcp (480⭐), godot-dev-guide, godot-shader | Godot |
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

#### 🎯 Godot 开发系列 Skills (ClawHub 新发现)

| Skill ID | 评分 | 说明 |
|----------|------|------|
| openclaw-godot-skill | 3.498 | Godot Skill 基础 |
| godot-dev-guide | 3.447 | Godot 开发指南 |
| godot-dev | 3.160 | Godot 4.6 C# 开发 |
| godot-mcp | 3.130 | Godot MCP 集成 |
| godot-shader | 3.119 | Godot Shader 开发 |

### 1.3 skills.sh 游戏开发 Skills 排行榜 (Top 20)

| 排名 | Skill ID | 安装量 | 说明 |
|------|----------|--------|------|
| 1 | game-engine | 3.878K | 游戏引擎基础 |
| 2 | game-ai | - | 游戏 AI 系统 |
| 3 | unity | - | Unity 开发 |
| 4 | game-cog | - | 游戏开发编排器 |
| 5 | godot-gdscript-patterns | 3.019K | Godot GDScript 模式 |
| 6 | game-developer-skill | - | Claude 游戏开发者 |
| 7 | godot-mcp | - | Godot MCP 服务器 |
| 8 | unity-mcp | - | Unity MCP 服务器 |
| 9 | roblox-game-skill | - | Roblox 开发 |
| 10 | skills-weaver | - | RPG 游戏 Agent SDK |

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| Web 框架 | fastapi, fastapi-patterns, django, drf | REST API, Web 应用 |
| 异步编程 | asyncio-patterns, async-python | 高并发 I/O |
| 数据科学 | python-dataviz, pandas-pro | 数据分析/可视化 |
| 类型安全 | python-type-safety, mypy-best | 类型检查/代码质量 |
| 脚本工具 | python-script-generator, lsp-python | 自动化脚本 |
| 测试 | pytest-master, unittest-pro, clean-pytest | 单元测试/集成测试 |

### 2.2 重点 Skills 深度分析

#### 🎯 FastAPI Skill (评分 3.526)

**仓库**: https://github.com/anthropics/skills  
**定位**: FastAPI 高性能 Web 框架开发

**核心能力**:
- RESTful API 设计模式
- 依赖注入最佳实践
- 异步请求处理
- OpenAPI 自动文档生成

#### 🎯 FastAPI Patterns (评分 3.122)

**定位**: FastAPI 生产环境最佳实践

**核心内容**:
- 中间件配置
- 错误处理
- 性能优化
- 安全最佳实践

#### 🎯 Django Skills 系列 (ClawHub 新发现)

| Skill ID | 评分 | 说明 |
|----------|------|------|
| django | 3.475 | Django 基础开发 |
| afrexai-django-production | 3.224 | Django 生产工程 |
| senior-django-developer | 3.184 | 高级 Django 开发者 |
| django-claw-skill | 3.129 | Django Claw 集成 |
| drf | 1.889 | Django REST Framework |

#### 🎯 Python Type Safety (评分 3.335)

**仓库**: https://github.com/anthropics/skills  
**定位**: Python 类型安全最佳实践

**核心能力**:
- mypy 配置和高级用法
- TypedDict, Protocol, Generic
- 运行时类型验证
- 类型装饰器模式

#### 🎯 Python Executor (评分 3.484)

**定位**: Python 代码执行器

**核心能力**:
- 动态代码执行
- 沙箱环境
- 结果捕获

#### 🎯 ClaudeX (⭐ 224)

**仓库**: https://github.com/anthropics/claudex  
**定位**: 专家级 Python 开发助手

**核心能力**:
- Python 3.12+ 特性
- 异步编程专家
- 类型系统深入
- 性能优化

#### 🎯 Clean Pytest (评分 3.316)

**定位**: Pytest 最佳实践

**核心能力**:
- 测试组织结构
- Fixtures 最佳实践
- 参数化测试
- Mocking 技巧

### 2.3 Python 开发 Skills 排行榜

| 排名 | Skill ID | 评分/热度 | 说明 |
|------|----------|-----------|------|
| 1 | python-type-safety | 3.335 | Python 类型安全 |
| 2 | python-executor | 3.484 | Python 代码执行器 |
| 3 | fastapi | 3.526 | FastAPI 开发 |
| 4 | django | 3.475 | Django 开发 |
| 5 | claudex | 224⭐ | Python 专家助手 |
| 6 | pydantic-ai-skills | 140⭐ | Pydantic AI 集成 |

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| E2E 测试 | playwright, cypress, selenium | 端到端测试 |
| 单元测试 | pytest, unittest, jest, clean-pytest | 单元测试 |
| 集成测试 | integration-testing, api-testing | API/集成测试 |
| 性能测试 | performance-testing, load-testing | 性能/负载测试 |
| 游戏测试 | game-testing, game-client-test | 游戏客户端测试 |
| AI 测试 | agentic-qe, ai-testing | AI 驱动测试 |

### 3.2 重点 Skills 深度分析

#### 🎯 Playwright Skill (⭐ 1.86k+)

**仓库**: https://github.com/lackeyjb/playwright-skill  
**定位**: 浏览器自动化测试

**核心能力**:
- 跨浏览器测试
- 自动化脚本生成
- 截图/视频录制
- CI/CD 集成

#### 🎯 Playwright MCP (评分 3.661)

**定位**: Playwright MCP 集成

**核心特性**:
- MCP 协议支持
- 自动化测试执行
- 浏览器控制

#### 🎯 Claude Code Playwright MCP Test (新增)

**仓库**: https://github.com/terryso/claude-code-playwright-mcp-test  
**定位**: YAML 驱动的 Playwright MCP 自动化测试框架

**核心特性**:
- YAML 配置测试用例
- MCP 协议集成
- 自动化执行

#### 🎯 Agentic QE (⭐ 218)

**定位**: AI 驱动的质量工程

**核心能力**:
- 自动化测试生成
- 智能测试用例设计
- 回归测试优化

#### 🎯 QA Workflow (新增)

**定位**: QA 完整工作流

**覆盖内容**:
- 测试计划制定
- 用例管理
- 缺陷跟踪
- 报告生成

#### 🎯 Cypress Skill (评分 3.348)

**定位**: Cypress E2E 测试

**核心能力**:
- 前端测试自动化
- 组件测试
- API 测试

#### 🎯 Test Patterns (评分 1.044)

**定位**: 测试模式最佳实践

**核心内容**:
- 测试架构模式
- 测试组织结构
- 断言策略

### 3.3 自动化测试 Skills 排行榜

| 排名 | Skill ID | 热度 | 说明 |
|------|----------|------|------|
| 1 | playwright | 1.86k⭐ | E2E 测试框架 |
| 2 | playwright-mcp | 3.661 | Playwright MCP 集成 |
| 3 | agentic-qe | 218⭐ | AI 驱动测试 |
| 4 | cypress | 3.348 | E2E 测试 |
| 5 | clean-pytest | 3.316 | Pytest 最佳实践 |
| 6 | qa-workflow | - | QA 工作流 |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| Git 工具 | git-essentials, git-automation | 版本控制 |
| Docker | docker-essentials, docker-pro | 容器化 |
| CI/CD | github-actions, jenkins | 持续集成 |
| 调试 | debugger-pro, logging-pro, debug-checklist | 调试诊断 |
| 监控 | monitoring, observability | 可观测性 |
| 云服务 | aws, gcp, azure | 云平台 |
| MCP 工具 | mcp-skill, mcp-client, filesystem-mcp | MCP 协议 |

### 4.2 重点 Skills 深度分析

#### 🎯 MCP 系列 Skills (ClawHub 热门)

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

#### 🎯 Claude Code Development Kit (新增)

**仓库**: https://github.com/peterkrueck/Claude-Code-Development-Kit  
**定位**: 大规模上下文管理

**核心功能**:
- Hooks 状态维护
- MCP 执行管理
- Agent 编排

#### 🎯 Context Engineering Kit (⭐ 新增)

**仓库**: https://github.com/NeoLabHQ/context-engineering-kit  
**定位**: 提升 Agent 结果质量的上下文工程

**核心能力**:
- 上下文优化
- 工作流集成
- 多平台兼容

#### 🎯 Claude Context (新增)

**仓库**: https://github.com/zilliztech/claude-context  
**定位**: 代码搜索 MCP

**核心功能**:
- 整个代码库作为上下文
- 语义搜索
- 代码理解

#### 🎯 API Gateway (评分 3.692)

**定位**: API 网关最佳实践

**核心能力**:
- API 路由管理
- 认证/授权
- 限流/熔断
- 日志/监控

#### 🎯 Secure API Calls (评分 3.465)

**定位**: 安全 API 调用

**核心能力**:
- HTTPS 配置
- 认证机制
- 错误处理

#### 🎯 Debug 系列 Skills

| Skill ID | 评分 | 说明 |
|----------|------|------|
| confucius-debug | 3.309 | Debug 最佳实践 |
| ui-debug-methodology | 3.290 | UI Debug 方法论 |
| debug-checklist | 3.273 | Debug 检查清单 |
| openclaw-mcp-debugger | 1.995 | OpenClaw MCP 调试器 |

#### 🎯 Awesome Claude Code Toolkit (⭐ 新增)

**仓库**: https://github.com/rohitg00/awesome-claude-code-toolkit  
**定位**: 最全面的 Claude Code 工具包

**统计数据**:
- 135 agents
- 35 curated skills (+15,000 via SkillKit)
- 42 commands
- 120 plugins
- 19 hooks

### 4.3 开发者工具 Skills 排行榜

| 排名 | Skill ID | 热度 | 说明 |
|------|----------|------|------|
| 1 | api-gateway | 3.692 | API 网关 |
| 2 | awesome-claude-code-toolkit | 新增 | 最全工具包 |
| 3 | claude-code-development-kit | 新增 | 开发工具包 |
| 4 | context-engineering-kit | 新增 | 上下文工程 |
| 5 | mcp-skill | 3.645 | MCP Skill |
| 6 | docker-essentials | - | Docker 基础 |

---

## 📈 五、ClawHub Top Skills 排行榜 (实时)

### 5.1 综合排行榜 Top 30

| 排名 | Skill ID | 分类 | 评分 |
|------|----------|------|------|
| 1 | superpowers | Agentic | 68k⭐ |
| 2 | compound-engineering | Agentic | 9.782k⭐ |
| 3 | everything-claude-code | Agentic | 50k⭐ |
| 4 | ui-ux-pro-max | Design | 36k⭐ |
| 5 | pinme | Deployment | 2.939k⭐ |
| 6 | planning-with-files | Planning | 15k⭐ |
| 7 | game-cog | Game Dev | 1.133k |
| 8 | fastapi | Web Dev | 1.075k |
| 9 | qa-testing | Testing | 1.931k |
| 10 | python-type-safety | Python | 3.335 |

### 5.2 本周新增热门 Skills

| Skill ID | 分类 | 评分 | 新增说明 |
|----------|------|------|----------|
| api-gateway | Dev Tools | 3.692 | API 网关最佳实践 |
| playwright-mcp | Testing | 3.661 | Playwright MCP 集成 |
| mcp-skill | MCP | 3.645 | MCP 基础技能 |
| openclaw-godot-skill | Game Dev | 3.498 | Godot 集成 |
| cursor-agent | Dev Tools | 3.501 | Cursor CLI Agent |

---

## 🔍 六、Skills 缺口与建议

### 6.1 发现的 Skills 缺口

| 领域 | 缺口描述 | 建议 |
|------|----------|------|
| 游戏客户端测试 | 缺乏专业的游戏自动化测试 Skills | 需要开发游戏 UI 测试、性能测试、兼容性测试 Skills |
| Python 异步 | asyncio 高级模式 Skills 较少 | 需要补充异步 I/O、并发编程Skills |
| 移动端测试 | iOS/Android 原生测试 Skills 不足 | 需要开发移动端自动化 Skills |
| 安全测试 | 安全审计 Skills 覆盖不足 | 需要加强安全扫描、渗透测试 Skills |
| 游戏 Shader | Godot Shader 开发 Skills 较少 | 需要补充 Shader 编程 Skills |

### 6.2 新兴 Skills 趋势

1. **MCP 服务器集成** - 越来越多的 Skills 通过 MCP 协议扩展能力
2. **AI 驱动测试** - Agentic QE、自动化测试生成成为热点
3. **上下文工程** - 上下文管理和优化 Skills 需求增长
4. **多平台兼容** - Skills 同时支持 Claude Code、Cursor、Windsurf 成为常态
5. **Godot 4.6+ 支持** - Godot C# 和 Shader 开发需求增长

---

## 📚 七、参考资料

- ClawHub: https://clawhub.com
- Antigravity Awesome Skills: https://github.com/VoltAgent/awesome-agent-skills
- Claude Code 官方 Skills: https://github.com/anthropics/skills
- 官方文档: https://docs.anthropic.com/en/docs/claude-code/overview

---

**调研完成时间**: 2026-03-05 12:59  
**下次更新**: 2026-03-12 (第七十一周)
