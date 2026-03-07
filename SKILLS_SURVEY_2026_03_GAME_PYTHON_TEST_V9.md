# Claude Code Skills 深度调研报告 - 2026年3月 (第十一轮)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub 实时搜索 + Antigravity Awesome Skills (970+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成 (第十一轮更新)

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，覆盖以下方向：
1. **游戏客户端开发** (Unity/Godot/Unreal)
2. **Python 开发** (FastAPI/异步/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化)
4. **开发者工具** (浏览器自动化/GitHub 自动化/Docker)

### 数据来源

| 来源 | Skills 数量 | 说明 |
|------|-------------|------|
| Antigravity Awesome Skills | 970+ | 10+ AI 助手平台支持 |
| ClawHub Registry | 实时 | 最新热门 Skills |
| 官方 Claude Code | 50+ | 官方 Skills |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 评分/星标 |
|------------|------|---------|----------|
| game-development | antigravity | 游戏开发编排器 | 18.5K⭐ |
| openclaw-godot-skill | ClawHub | Godot 场景管理、节点操作 | **3.497** 🆕 |
| godot-dev-guide | ClawHub | Godot 4 开发指南 | **3.442** 🆕 |
| unity-developer | antigravity | Unity 6 LTS 专家 | 高 |
| unity | ClawHub | Unity 开发 | **3.030** 🆕 |
| openclaw-unreal-skill | ClawHub | Unreal 技能 | **3.376** 🆕 |
| godot-gdscript-patterns | antigravity | Godot 4 GDScript | 高 |
| godot-4-migration | antigravity | Godot 3→4 迁移 | 高 |
| unity-ecs-patterns | antigravity | Unity ECS 模式 | 高 |
| unreal-engine-cpp-pro | antigravity | UE5 C++ 开发 | 高 |
| bevy-ecs-expert | antigravity | Bevy ECS (Rust) | 中 |
| game-audio | antigravity | 游戏音频 | 中 |
| game-art | antigravity | 游戏美术管线 | 中 |
| game-developer-skill | ClawHub | 游戏开发者 | **3.241** |

### 1.2 OpenClaw Godot Skill 详解 (评分: 3.497)

**来源**: ClawHub

```markdown
### 核心能力
- 场景管理 (Scene Tree)
- 节点操作 (Node operations)
- 信号系统 (Signals)
- 资源加载 (Resource loading)
- GDScript 编写

### 适用场景
- ✅ Godot 4 项目开发
- ✅ 2D/3D 游戏制作
- ✅ 跨平台部署 (Windows/Linux/macOS/Android/iOS)
- ✅ 开源游戏开发
```

### 1.3 Godot Dev Guide 详解 (评分: 3.442)

**来源**: ClawHub

```markdown
### 核心能力
- Godot 4 完整开发指南
- 项目架构设计
- 最佳实践
- 性能优化

### 适用场景
- ✅ Godot 初学者入门
- ✅ 项目架构规划
- ✅ 性能调优
```

### 1.4 OpenClaw Unreal Skill 详解 (评分: 3.376)

**来源**: ClawHub

```markdown
### 核心能力
- Unreal Engine 开发
- C++ / Blueprint 集成
- 蓝图可视化编程
- 引擎定制

### 适用场景
- ✅ UE5 项目开发
- ✅ AAA 游戏制作
- ✅ 虚拟制作
```

### 1.5 Unity Skill 详解 (评分: 3.030)

**来源**: ClawHub

```markdown
### 核心能力
- Unity 基础开发
- C# 脚本编写
- 组件系统
- 场景管理

### 适用场景
- ✅ Unity 初学者
- ✅ 快速原型开发
- ✅ 跨平台发布
```

### 1.6 Game Development Orchestrator 详解

**来源**: Antigravity Awesome Skills

**核心能力**: 智能路由到子 Skills，实现全栈游戏开发支持

```markdown
### 子技能路由矩阵

#### 平台选择
| 目标平台 | 子技能 |
|---------|--------|
| Web 浏览器 (HTML5/WebGL) | game-development/web-games |
| 移动端 (iOS/Android) | game-development/mobile-games |
| PC (Steam/Desktop) | game-development/pc-games |
| VR/AR 头显 | game-development/vr-ar |

#### 游戏类型
| 游戏类型 | 子技能 |
|---------|--------|
| 2D (精灵/瓦片地图) | game-development/2d-games |
| 3D (网格/着色器) | game-development/3d-games |

#### 专业领域
| 需求 | 子技能 |
|------|--------|
| GDD/平衡/玩家心理 | game-development/game-design |
| 多人/网络 | game-development/multiplayer |
| 视觉风格/资产管线 | game-development/game-art |
| 音效/音乐 | game-development/game-audio |
```

### 1.7 游戏开发核心原则

```markdown
### 1. 游戏循环 (Game Loop)
```
INPUT → UPDATE (固定时间步 50Hz) → RENDER (插值)
```

### 2. 模式选择矩阵
| 模式 | 使用场景 | 示例 |
|------|---------|------|
| **状态机** | 3-5 个离散状态 | 玩家: Idle→Walk→Jump |
| **对象池** | 频繁生成/销毁 | 子弹、粒子 |
| **ECS** | 数千相似实体 | RTS 单位 |
| **行为树** | 复杂 AI 决策 | 敌人 AI |

### 3. 性能预算 (60 FPS = 16.67ms)
| 系统 | 预算 |
|------|------|
| 输入 | 1ms |
| 物理 | 3ms |
| AI | 2ms |
| 游戏逻辑 | 4ms |
| 渲染 | 5ms |
```

### 1.8 游戏开发 Skills 推荐安装

```bash
# 核心 Skills
clawhub install game-development
clawhub install openclaw-godot-skill
clawhub install godot-dev-guide
clawhub install unity-developer
clawhub install unity
clawhub install openclaw-unreal-skill
clawhub install game-developer-skill
```

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 评分 |
|------------|------|---------|------|
| python-executor | ClawHub | 安全沙箱执行 Python | 3.480 |
| python-dataviz | ClawHub | 数据可视化 | 3.428 |
| python-development-python-scaffold | antigravity | Python 项目脚手架 | 高 |
| python-fastapi-development | antigravity | FastAPI 开发 | 高 |
| python-patterns | antigravity | Python 设计模式 | 高 |
| python-pro | antigravity | Python Pro | 高 |
| python-performance-optimization | antigravity | 性能优化 | 高 |
| python-testing-patterns | antigravity | pytest 测试策略 | 高 |
| async-python-patterns | antigravity | asyncio 异步编程 | 高 |
| python-packaging | antigravity | 包发布 | 高 |
| lsp-python | ClawHub | LSP Python | 3.289 |
| python-script-generator | ClawHub | 脚本生成 | 3.220 |
| fastapi | ClawHub | FastAPI | 3.523 |
| async-task | ClawHub | 异步任务 | 3.544 |

### 2.2 Python Executor 详解 (评分: 3.480)

**来源**: ClawHub

```markdown
### 核心能力
- 安全沙箱执行
- 依赖预装: NumPy, Pandas, Matplotlib, requests, BeautifulSoup
- 数据处理和分析
- 可视化图表生成
- 文件 I/O 操作

### 适用场景
- 数据分析原型
- 快速脚本验证
- 自动化任务执行
- 数据可视化
```

### 2.3 Python Dataviz 详解 (评分: 3.428)

**来源**: ClawHub

```markdown
### 核心能力
- Matplotlib 可视化
- Pandas 数据处理
- 图表定制
- 导出功能

### 适用场景
- 数据分析展示
- 报告生成
- 探索性数据分析
```

### 2.4 FastAPI Skill 详解 (评分: 3.523)

**来源**: ClawHub

```markdown
### 核心能力
- RESTful API 设计
- Pydantic 数据验证
- 依赖注入
- 自动文档生成 (Swagger/ReDoc)
- 异步支持

### 适用场景
- 微服务开发
- REST API 构建
- Web 后端开发
- API 文档自动生成
```

### 2.5 Async Python Patterns 详解

**来源**: Antigravity Awesome Skills

```markdown
### 核心能力
- asyncio 事件循环管理
- async/await 语法
- 并发任务管理
- 异步生成器

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- FastAPI: 异步 Web 框架

### 示例代码
```python
import asyncio

async def fetch_data(url: str) -> dict:
    await asyncio.sleep(0.1)
    return {"url": url, "data": "result"}

async def fetch_all(urls: list) -> list:
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

asyncio.run(fetch_all(["url1", "url2"]))
```
```

### 2.6 Async Task Skill 详解 (评分: 3.544)

**来源**: ClawHub

```markdown
### 核心能力
- 异步任务队列
- 任务调度
- 并发管理

### 适用场景
- 后台任务处理
- 定时任务
- 批处理作业
```

### 2.7 Python Testing Patterns

```markdown
### 核心能力
- pytest 测试框架
- Fixtures 测试夹具
- Mocking 模拟对象
- Parameterization 参数化
- Property-based testing

### 测试策略矩阵
| 策略 | 范围 | 速度 |
|------|------|------|
| 单元测试 | 函数/类 | 快 |
| 集成测试 | 模块/服务 | 中 |
| E2E 测试 | 完整流程 | 慢 |
```

### 2.8 Python 开发 Skills 推荐安装

```bash
# 核心 Skills
clawhub install python-executor
clawhub install python-dataviz
clawhub install fastapi
clawhub install async-task

# 可选增强
clawhub install python-script-generator
clawhub install lsp-python
```

---

## 🧪 三、自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 评分 |
|------------|------|---------|------|
| test-runner | ClawHub | 测试运行器 | 3.639 |
| test-master | ClawHub | 测试大师 | 3.576 |
| test-patterns | ClawHub | 测试模式 | 3.548 |
| test-specialist | ClawHub | 测试专家 | 3.467 |
| test-sentinel | ClawHub | 测试哨兵 | 3.347 |
| test-case-generator | ClawHub | 测试用例生成器 | 3.336 |
| playwright | ClawHub | 浏览器自动化 | 3.538 |
| playwright-mcp | ClawHub | Playwright MCP | 3.581 |
| playwright-scraper-skill | ClawHub | 网页抓取 | 3.584 |
| e2e-testing | antigravity | E2E 测试 | 高 |
| e2e-testing-patterns | antigravity | E2E 测试模式 | 高 |
| browser-automation | antigravity | 浏览器自动化 | 高 |
| testing-patterns | antigravity | 测试模式 | 高 |
| test-driven-development | antigravity | TDD | 高 |

### 3.2 Test Runner 详解 (评分: 3.639)

**来源**: ClawHub

```markdown
### 核心能力
- 多框架支持 (pytest, Jest, Mocha)
- 并行执行
- 测试选择和过滤
- JUnit XML 报告
- HTML 报告
- CI/CD 集成

### 适用场景
- 单元测试运行
- 集成测试管理
- CI/CD 流水线集成
- 测试报告生成
```

### 3.3 Test Master 详解 (评分: 3.576)

**来源**: ClawHub

```markdown
### 核心能力
- 测试策略规划
- 测试用例设计
- 质量度量
- 测试报告分析

### 适用场景
- 测试架构设计
- 质量评估
- 测试流程优化
```

### 3.4 Test Patterns 详解 (评分: 3.548)

**来源**: ClawHub

```markdown
### 核心能力
- 测试设计模式
- 最佳实践
- 代码覆盖率
- Mock 策略

### 适用场景
- 测试最佳实践
- 代码覆盖率提升
- Mock 对象使用
```

### 3.5 Playwright Skills 专题

**来源**: ClawHub 实时搜索

| Skill ID | 评分 |
|----------|------|
| playwright-scraper-skill | 3.584 |
| playwright-mcp | 3.581 |
| playwright | 3.538 |
| playwright-browser-automation | 3.509 |
| playwright-headless-browser | 3.367 |
| playwright-npx | 3.336 |
| playwright-skill | 3.278 |

```markdown
### 核心能力
- 浏览器自动化
- 表单填写和提交
- 页面截图
- 数据提取
- E2E 测试
- 视觉回归测试
- MCP 协议集成

### 适用场景
- 网页自动化
- 数据抓取
- E2E 测试
- 视觉回归测试
- 表单自动填写
```

### 3.6 移动端自动化测试 Skills

| Skill 名称 | 来源 | 核心能力 | 评分 |
|------------|------|---------|------|
| mobile-appium-test | ClawHub | Appium 移动端测试 | 3.189 |
| mobile | ClawHub | 移动端基础 | 3.041 |
| android-remote-control | ClawHub | Android 远程控制 | 3.304 |
| android-studio | ClawHub | Android Studio | 3.209 |
| android-control-2 | ClawHub | Android 控制 | 3.204 |
| android-agent | ClawHub | Android Agent | 3.327 |
| midscene-android-automation | ClawHub | Midscene Android 自动化 | 3.410 |
| ios-simulator | ClawHub | iOS 模拟器 | 3.456 |
| ios | ClawHub | iOS 开发 | 3.057 |

```markdown
### Mobile Appium Test (评分: 3.189)
### 核心能力
- Appium 测试框架
- Android/iOS 原生应用测试
- 混合应用测试
- 自动化测试脚本
- 设备农场集成

### 适用场景
- 移动端功能测试
- 跨平台测试
- 回归测试
- 性能测试
```

### 3.7 Selenium Skills 专题

| Skill 名称 | 评分 |
|------------|------|
| selenium-browser-skill | 3.290 |
| selenium-browser | 3.248 |

```markdown
### 核心能力
- Selenium WebDriver
- 浏览器自动化
- 跨浏览器测试
- 页面对象模型

### 适用场景
- Web 应用测试
- 回归测试
- 数据抓取
```

### 3.8 E2E Testing Patterns

**来源**: Antigravity Awesome Skills

```markdown
### 核心能力
- Playwright 和 Cypress 测试
- 可靠的测试套件构建
- 跨浏览器测试
- 响应式设计测试
- 可访问性验证

### 测试原则
1. 识别关键用户旅程
2. 构建稳定选择器
3. 测试隔离
4. 并行化执行
```

### 3.9 自动化测试 Skills 推荐安装

```bash
# 测试运行器
clawhub install test-runner
clawhub install test-master
clawhub install test-patterns

# Playwright
clawhub install playwright
clawhub install playwright-mcp
clawhub install playwright-scraper-skill

# Selenium
clawhub install selenium-browser-skill

# 移动端测试
clawhub install mobile-appium-test
clawhub install android-remote-control
clawhub install android-agent
clawhub install midscene-android-automation
clawhub install ios-simulator
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 GitHub 专题

| Skill | 评分 | 说明 |
|-------|------|------|
| github | 3.790 | GitHub 基础操作 |
| openclaw-github-assistant | 3.615 🆕 | OpenClaw GitHub 助手 |
| github-cli | 3.501 | GitHub CLI |
| github-trending-cn | 3.458 | GitHub 中文趋势 |
| github-ops | 3.345 | GitHub 运维 |
| github-actions-generator | 3.238 | Actions 生成器 |
| github-mcp | 3.456 | GitHub MCP Server |
| github-search | 3.310 | GitHub 搜索 |
| github-issue-resolver | 3.293 | GitHub Issue 解决器 |
| code-review | 3.620 | 代码审查 |
| receiving-code-review | 3.570 | 接收代码审查 |
| requesting-code-review | 3.554 | 请求代码审查 |

```markdown
### 核心能力
- 仓库管理
- PR 创建和审批
- Issue 管理
- GitHub Actions Workflow
- CI/CD 配置
- 代码审查
```

### 4.2 Docker 专题

| Skill | 评分 | 说明 |
|-------|------|------|
| docker-essentials | 3.694 | Docker 基础 |
| docker | 3.577 | Docker 完整版 |
| docker-sandbox | 3.548 | Docker 沙箱 |
| docker-ctl | 3.531 🆕 | Docker 控制 |
| docker-compose | 3.511 | Docker Compose |
| docker-essentials-1-0-0 | 3.498 🆕 | Docker 基础 v1.0.0 |
| docker-diag | 3.474 🆕 | Docker 诊断 |

```markdown
### 核心能力
- Dockerfile 最佳实践
- 多阶段构建
- 容器管理
- 网络配置
- 安全最佳实践
```

### 4.3 浏览器自动化专题

| Skill | 评分 |
|-------|------|
| agent-browser | 3.772 |
| browser-automation | 3.700 |
| browser-use | 3.653 |
| fast-browser-use | 3.619 |
| stagehand-browser-cli | 3.597 |
| browser-pc | 3.518 |
| browser-automation-v2 | 3.457 |
| browser-automation-stealth | 3.462 |

```markdown
### 核心能力
- 浏览器控制
- 网页交互
- 数据提取
- 截图和录制
- 表单填写
```

### 4.4 安全审计 Skills

| Skill | 评分 |
|-------|------|
| security-auditor | 3.556 |
| clawdbot-security-check | 3.514 |
| security-audit-toolkit | 3.513 |
| clawdbot-security-suite | 3.452 |
| security-audit | 3.478 |
| senior-security | 3.393 |

```markdown
### 核心能力
- 代码安全审计
- 漏洞扫描
- 安全最佳实践
- 合规检查
```

### 4.5 API 开发 Skills

| Skill | 评分 |
|-------|------|
| api-gateway | 3.684 |
| secure-api-calls | 3.459 |
| fastapi | 3.523 |
| sovereign-api-docs-generator | 3.317 |

```markdown
### 核心能力
- API 设计和开发
- 安全调用
- 文档生成
- 网关配置
```

### 4.6 开发者工具 Skills 推荐安装

```bash
# GitHub
clawhub install github
clawhub install github-cli
clawhub install github-mcp
clawhub install code-review

# Docker
clawhub install docker-essentials
clawhub install docker-compose

# 浏览器自动化
clawhub install browser-automation
clawhub install browser-use

# 安全
clawhub install security-auditor
```

---

## 📈 Skills 评分排行榜 (Top 30)

| 排名 | Skill | 类别 | 评分 | 趋势 |
|------|-------|------|------|------|
| 1 | agent-browser | Browser | 3.772 | - |
| 2 | github | DevOps | 3.790 | - |
| 3 | automation-workflows | Automation | 3.699 | - |
| 4 | docker-essentials | DevOps | 3.694 | - |
| 5 | browser-automation | Browser | 3.700 | 🆕 |
| 6 | api-gateway | API | 3.684 | 🆕 |
| 7 | agent-browser-clawdbot | Browser | 3.684 | 🆕 |
| 8 | test-runner | Testing | 3.639 | 🆕 |
| 9 | openclaw-github-assistant | DevOps | 3.615 | 🆕 |
| 10 | code-review | DevOps | 3.620 | 🆕 |
| 11 | fast-browser-use | Browser | 3.619 | 🆕 |
| 12 | browser-use | Browser | 3.653 | 🆕 |
| 13 | playwright-scraper-skill | Automation | 3.584 | - |
| 14 | playwright-mcp | Automation | 3.581 | - |
| 15 | docker | DevOps | 3.577 | - |
| 16 | test-master | Testing | 3.576 | 🆕 |
| 17 | receiving-code-review | DevOps | 3.570 | 🆕 |
| 18 | docker-sandbox | DevOps | 3.548 | - |
| 19 | test-patterns | Testing | 3.548 | 🆕 |
| 20 | async-task | Python | 3.544 | 🆕 |
| 21 | playwright | Automation | 3.538 | - |
| 22 | agent-browser-2 | Browser | 3.538 | 🆕 |
| 23 | docker-ctl | DevOps | 3.531 | 🆕 |
| 24 | docker-compose | DevOps | 3.511 | - |
| 25 | playwright-browser-automation | Automation | 3.509 | - |
| 26 | browser-cash | Browser | 3.498 | 🆕 |
| 27 | docker-essentials-1-0-0 | DevOps | 3.498 | 🆕 |
| 28 | openclaw-godot-skill | Game | 3.497 | 🆕 |
| 29 | security-auditor | Security | 3.556 | 🆕 |
| 30 | godot-dev-guide | Game | 3.442 | 🆕 |

---

## 📦 安装指南

### ClawHub 安装

```bash
# 搜索 Skills
clawhub search <keyword>

# 安装 Skills
clawhub install <skill-id>
```

### Antigravity 安装

```bash
npx antigravity-awesome-skills --claude
```

---

## 🔗 资源链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [ClawHub Registry](https://clawhub.com)
- [Claude Code 官方](https://github.com/anthropics/claude-code)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)

---

**文档版本**: 2026.03.04.4  
**本轮更新**: 
- 新增游戏客户端开发 Skills 完整列表 (新增 game-developer-skill)
- 新增 Python 开发 Skills (新增 async-task)
- 新增自动化测试 Skills 完整列表 (新增 Selenium 专题)
- 新增移动端自动化测试 Skills (新增 android-agent, midscene-android-automation)
- 新增开发者工具 Skills (新增 GitHub MCP, docker-ctl)
- 更新 Skills 评分排行榜 Top 30
- 增加各分类 Skills 推荐安装命令

**调研完成**: ✅
