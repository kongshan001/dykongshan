# Claude Code Skills 深度调研报告 - 2026年3月（第七十二周）

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

### 1.3 Antigravity 游戏开发 Skills 完整列表

| Skill ID | 描述 | 分类 |
|----------|------|------|
| game-development | 通用游戏开发 | 通用 |
| godot-4-migration | Godot 3.x 到 4 迁移指南 | Godot |
| godot-gdscript-patterns | Godot 4 GDScript 模式 | Godot |
| unity-developer | Unity 开发者技能 | Unity |
| unity-ecs-patterns | Unity ECS/DOTS 架构模式 | Unity |
| unreal-engine-cpp-pro | Unreal Engine C++ 专业开发 | Unreal |
| roblox-game-skill | Roblox 游戏开发 | Roblox |

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

### 2.3 Antigravity Python 开发 Skills 完整列表

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

### 2.4 重点 Skills 深度分析

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

### 3.4 Antigravity 自动化测试 Skills 完整列表 (120+)

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

### 3.5 重点 Skills 深度分析

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

### 4.3 GitHub/GitLab 自动化

| Skill ID | 描述 |
|----------|------|
| github-actions | GitHub Actions |
| gitlab-ci | GitLab CI/CD |
| git-essentials | Git 必备技能 |
| bitbucket-automation | Bitbucket 自动化 |

### 4.4 Docker/Kubernetes 相关

| Skill ID | 描述 |
|----------|------|
| docker-essentials | Docker 基础 |
| kubernetes | K8s 部署 |
| helm | Helm Chart |

---

## 📈 五、Skills.sh 官方排行榜分析

### 5.1 Top 10 Skills (2026年3月)

| 排名 | Skill | 安装量 | 分类 |
|------|-------|--------|------|
| 1 | superpowers | 68k+ | Agent 工作流 |
| 2 | compound-engineering | 9.7k | 复合工程 |
| 3 | everything-claude-code | 50k+ | 性能优化 |
| 4 | game-cog | 1.134 | 游戏开发 |
| 5 | fastapi | 1.075 | Web 框架 |
| 6 | playwright | 1.86k | 测试自动化 |
| 7 | qa-testing | 1.931 | QA 测试 |
| 8 | game-development | - | 游戏开发 |
| 9 | python | 1.052 | Python 开发 |
| 10 | developer-kit | 133+ | 开发工具包 |

### 5.2 分类热度趋势

```
游戏客户端开发: ⭐⭐⭐⭐⭐ (持续增长)
Python 开发: ⭐⭐⭐⭐⭐ (稳定热门)
自动化测试: ⭐⭐⭐⭐⭐ (快速增长)
开发者工具: ⭐⭐⭐⭐ (稳步增长)
```

---

## 🔍 六、Skills 缺口分析与建议

### 6.1 当前缺口

| 领域 | 缺口 | 建议 |
|------|------|------|
| 游戏客户端测试 | 缺乏专门的游戏自动化测试 Skills | 开发 Unity/Godot 自动化测试 Skills |
| Python 异步 | asyncio/await 模式 Skills 较少 | 补充异步编程专题 |
| 移动端测试 | Android 强,iOS 弱 | 补充 iOS 测试 Skills |
| 性能测试 | 性能分析 Skills 不足 | 开发专项性能测试 Skills |

### 6.2 新兴 Skills 机会

| 方向 | 机会 | 热度 |
|------|------|------|
| Claude Code Game Studios | 多引擎游戏开发 | ⭐⭐⭐⭐⭐ |
| Unity AI Workflow 2026 | AI-first 开发 | ⭐⭐⭐⭐⭐ |
| Playwright MCP | 浏览器自动化 | ⭐⭐⭐⭐⭐ |
| FastAPI Pro | 企业级 API 开发 | ⭐⭐⭐⭐ |
| Temporal Python | 工作流编程 | ⭐⭐⭐ 📚 七、参考资料

### 7.1 ⭐ |

---

##官方资源

- [ClawHub Skills 市场](https://clawhub.com)
- [skills.sh 官方](https://skills.sh)
- [Antigravity Awesome Skills](https://github.com/antigravity非/awesome-skills)

### 7.2 核心仓库

| 仓库 | Stars | 说明 |
|------|-------|------|
| unity-mcp | 6580⭐ | Unity MCP |
| Godot-MCP | 480⭐ | Godot MCP |
| superpowers | 68k+ | Agent 工作流 |
| everything-claude-code | 50k+ | 性能优化 |

---

## 📋 八、附录：完整 Skills 索引

### 8.1 游戏客户端开发 Skills

```
game-cog, game-developer-skill, game-engine, games, gaming, 3d-cog,
game-development, godot-gdscript-patterns, godot-4-migration,
unity-developer, unity-ecs-patterns, unity-mcp,
unreal-engine-cpp-pro, unreal-engine-skills,
roblox-game-skill, fivem-dev, blender
```

### 8.2 Python 开发 Skills

```
py, python, python-executor, python-dataviz, fastapi, python-sdk,
lsp-python, async-python-patterns, dbos-python, django-pro,
fastapi-pro, fastapi-router-py, fastapi-templates,
python-development-python-scaffold, python-packaging,
python-patterns, python-performance-optimization, python-pro,
python-testing-patterns, temporal-python-pro, temporal-python-testing,
python-type-safety, claudex, pydantic-ai-skills
```

### 8.3 自动化测试 Skills

```
test-master, android-adb, e2e-testing-patterns, ai-web-automation,
testing-patterns, automate, afrexai-qa-test-plan, api-tester,
atl-mobile, afrexai-qa-testing-engine, afrexai-qa-engine,
testing-workflow, ai-api-test, clean-pytest, playwright,
playwright-scraper-skill, playwright-mcp, playwright-browser-automation,
playwright-headless-browser, playwright-skill,
e2e-testing, browser-automation, api-security-testing,
api-testing, python-testing-patterns, bats-testing-patterns,
game-testing, game-client-test
```

---

**文档版本**: 2026.03.05.72  
**维护者**: Claude Code Skills 调研团队  
**更新频率**: 每周
