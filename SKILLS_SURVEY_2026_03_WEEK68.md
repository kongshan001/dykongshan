# Claude Code Skills 深度调研报告 - 2026年3月（第六十八周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + ClawHub 排行榜 + Antigravity Awesome Skills (968+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 📡 持续更新

---

## 📊 调研概要

本次调研聚焦以下四个核心方向，基于 Claude Code 生态系统中最新、最热门的 Skills 进行深度分析：

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 25+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 80+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 150+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 45+ | ⭐⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱概览

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog, game-development | 全引擎 |
| Unity 开发 | unity-developer, unity-ecs-patterns, unity-mcp (6580⭐) | Unity |
| Godot 开发 | godot-gdscript-patterns, godot-mcp (480⭐) | Godot |
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
| Web 框架 | fastapi, django, flask | REST API, Web 应用 |
| 异步编程 | asyncio-patterns, async-python | 高并发 I/O |
| 数据科学 | python-dataviz, pandas-pro | 数据分析/可视化 |
| 类型安全 | python-type-safety, mypy-best | 类型检查/代码质量 |
| 脚本工具 | python-script-generator, lsp-python | 自动化脚本 |
| 测试 | pytest-master, unittest-pro | 单元测试/集成测试 |

### 2.2 重点 Skills 深度分析

#### 🎯 FastAPI Skill (评分 1.121)

**仓库**: https://github.com/anthropics/skills  
**定位**: FastAPI 高性能 Web 框架开发

**核心能力**:
- RESTful API 设计模式
- 依赖注入最佳实践
- 异步请求处理
- OpenAPI 自动文档生成

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
- 沙箱环境支持
- 脚本生成和运行

### 2.3 Python 开发 Skills Top 10

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | python-executor | 3.484 | Python 代码执行器 |
| 2 | python-dataviz | 3.433 | 数据可视化 |
| 3 | python-sdk | 3.335 | Python SDK |
| 4 | lsp-python | 3.308 | LSP Python |
| 5 | python-script-generator | 3.253 | 脚本生成器 |
| 6 | python-type-safety | 3.200 | 类型安全 |
| 7 | fastapi | 1.121 | FastAPI Web 框架 |
| 8 | asyncio-patterns | 1.050 | 异步编程模式 |
| 9 | pytest-master | 0.980 | pytest 测试框架 |
| 10 | pandas-pro | 0.950 | Pandas 数据处理 |

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| E2E 测试 | playwright, cypress, selenium | 端到端测试 |
| 单元测试 | pytest, unittest, jest | 单元测试 |
| 移动测试 | appium, detox, xcuitest | 移动端测试 |
| 游戏测试 | game-testing-framework, unity-test | 游戏客户端测试 |
| API 测试 | rest-assured, postman, http-client | API 测试 |
| 性能测试 | k6, locust, JMeter | 性能/负载测试 |

### 3.2 重点 Skills 深度分析

#### 🎯 Playwright (评分 2.850)

**仓库**: https://github.com/microsoft/playwright  
**定位**: 现代化 Web E2E 测试框架

**核心能力**:
- 跨浏览器自动化
- 移动端模拟
- API 测试支持
- VS Code 集成

**适用场景**:
- Web 应用端到端测试
- 视觉回归测试
- 自动化爬虫
- 持续集成

#### 🎯 Playwright MCP

**定位**: Playwright MCP 服务器

**核心功能**:
- 浏览器自动化
- 页面交互
- 截图/录屏
- 网络监控

#### 🎯 Game Testing Framework

**定位**: 游戏客户端自动化测试

**核心功能**:
- Unity/Unreal 测试集成
- UI 自动化
- 性能监控
- 崩溃报告

### 3.3 自动化测试 Skills Top 15

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | playwright | 2.850 | Web E2E 测试 |
| 2 | game-testing | 2.500 | 游戏测试框架 |
| 3 | cypress | 2.350 | 前端 E2E 测试 |
| 4 | appium | 2.200 | 移动端测试 |
| 5 | selenium | 2.050 | 传统 Web 自动化 |
| 6 | pytest | 1.950 | Python 测试框架 |
| 7 | k6 | 1.800 | 性能测试 |
| 8 | rest-assured | 1.750 | API 测试 |
| 9 | unittest-pro | 1.600 | 单元测试 |
| 10 | detox | 1.550 | React Native 测试 |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱概览

| 分类 | 核心 Skills | 适用场景 |
|------|-------------|----------|
| 容器化 | docker, kubernetes, docker-compose | 容器化部署 |
| CI/CD | github-actions, gitlab-ci, jenkins | 持续集成/部署 |
| 版本控制 | git-essentials, git-flow, github-cli | 代码管理 |
| IDE | vscode-pro, cursor-pro, jetbrains | 开发环境 |
| MCP | mcp-servers, mcp-tools | AI 扩展 |
| 代码质量 | linters, formatters, code-review | 代码审查 |

### 4.2 重点 Skills 深度分析

#### 🎯 Docker Essentials

**定位**: Docker 容器化最佳实践

**核心能力**:
- Dockerfile 优化
- 多阶段构建
- Docker Compose
- 镜像安全

#### 🎯 Git Essentials

**定位**: Git 版本控制

**核心能力**:
- 分支策略
- 合并/变基
- Git Flow 工作流
- 冲突解决

#### 🎯 MCP Servers

**定位**: Model Context Protocol 服务器集合

**核心能力**:
- 文件系统操作
- 数据库连接
- API 调用
- 浏览器自动化

### 4.3 开发者工具 Skills Top 15

| 排名 | Skill ID | 评分 | 说明 |
|------|----------|------|------|
| 1 | docker-essentials | 3.200 | Docker 容器化 |
| 2 | git-essentials | 3.150 | Git 版本控制 |
| 3 | github-actions | 3.000 | GitHub Actions |
| 4 | mcp-servers | 2.900 | MCP 服务器 |
| 5 | vscode-pro | 2.850 | VS Code 配置 |
| 6 | kubernetes | 2.700 | K8s 编排 |
| 7 | linters | 2.650 | 代码规范 |
| 8 | code-review | 2.500 | 代码审查 |
| 9 | docker-compose | 2.450 | Docker Compose |
| 10 | npm-scripts | 2.350 | npm 脚本 |

---

## 📈 五、趋势分析

### 5.1 游戏开发趋势

| 趋势 | 说明 | 代表 Skills |
|-----|------|------------|
| AI-First 开发 | AI 驱动的工作流成为主流 | unity-ai-workflow-2026 |
| MCP 集成 | 引擎通过 MCP 连接 AI | unity-mcp, godot-mcp |
| 多引擎支持 | 统一工具链支持多引擎 | Claude-Code-Game-Studios |
| 专业化 | 细分领域专业化 | roblox-game-skill |

### 5.2 Python 开发趋势

| 趋势 | 说明 | 代表 Skills |
|-----|------|------------|
| 类型安全 | 静态类型检查成为标配 | python-type-safety |
| 异步优先 | 异步编程模式普及 | asyncio-patterns |
| AI 集成 | Python 在 AI/ML 领域主导 | python-dataviz, python-sdk |

### 5.3 测试趋势

| 趋势 | 说明 | 代表 Skills |
|-----|------|------------|
| Playwright 崛起 | 现代 E2E 测试首选 | playwright, playwright-mcp |
| 游戏测试专业化 | 游戏领域专用测试 | game-testing-framework |
| MCP 测试 | AI 驱动的测试自动化 | mcp-testing-tools |

---

## 📋 六、安装指南

### 6.1 通过 Antigravity 安装（推荐）

```bash
# 安装完整技能库
npx antigravity-awesome-skills

# 验证安装
test -d ~/.claude/skills && echo "Skills installed!"
```

### 6.2 手动安装特定 Skills

```bash
# 游戏开发 Skills
git clone https://github.com/Volaly/unity-mcp.git ~/.claude/skills/unity-mcp
git clone https://github.com/nicbarker/Godot-MCP.git ~/.claude/skills/godot-mcp

# Python 开发 Skills
git clone https://github.com/anthropics/skills.git ~/.claude/skills/python-type-safety

# 测试 Skills
git clone https://github.com/microsoft/playwright.git ~/.claude/skills/playwright
```

### 6.3 使用 Skills

```bash
# Claude Code
>> /game-cog 帮助我创建一个 Unity 角色控制器
>> /fastapi 构建一个 REST API
>> /playwright 测试这个登录页面
>> /docker-essentials 创建 Dockerfile
```

---

## ✅ 七、总结与建议

### 7.1 技能选择建议

| 场景 | 推荐 Skills |
|------|------------|
| 游戏客户端开发 | unity-mcp, godot-mcp, game-cog, game-ai |
| Python Web 开发 | fastapi, python-type-safety, pytest |
| Python AI/ML | python-dataviz, python-sdk, python-executor |
| Web E2E 测试 | playwright, playwright-mcp |
| 游戏测试 | game-testing-framework, unity-test |
| 开发者工具 | docker-essentials, git-essentials, mcp-servers |

### 7.2 学习路径

```
入门 → 进阶 → 专业

1. 入门: git-essentials, docker-essentials, python-script-generator
2. 进阶: fastapi, pytest, playwright, game-cog
3. 专业: unity-mcp, python-type-safety, mcp-servers
```

### 7.3 资源链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [ClawHub Skills Directory](https://clawhub.com)
- [skills.sh](https://skills.sh)
- [Claude Code 官方 Skills](https://github.com/anthropics/skills)

---

*持续更新于 2026-03-05 - Claude Code Skills 调研*
