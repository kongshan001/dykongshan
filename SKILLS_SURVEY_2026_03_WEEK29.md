# Claude Code Skills 调研报告 - 2026年3月 (第二十九周)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub 实时搜索  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研继续聚焦 Claude Code 热门 Skills，基于 GitHub API 搜索，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/GameMaker)
2. **Python 开发** (FastAPI/异步/类型安全)
3. **游戏客户端自动化测试** (Playwright/移动端/E2E)
4. **开发者工具** (Docker/GitHub/安全审计)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 热门 Skills 概览

| Skill | 来源 | 核心能力 | Stars |
|-------|------|---------|-------|
| game-cog | Antigravity | 游戏开发编排器，DeepResearch Bench 第一名 | 18.5K |
| Claude-Code-Game-Studios | GitHub | 48 agents + 36 skills 游戏工作室 | 28 |
| OH-Unity-GameDev-Skills | GitHub | Unity 游戏开发 agent skills 集合 | 6 |
| unity-ai-workflow | GitHub | Unity 6.2+ AI 驱动开发工作流 | 4 |
| gamemaker-skills | GitHub | GameMaker Studio 2 和 GML 开发 | 2 |
| godot-resources | GitHub | Godot 游戏开发自定义 agents | 3 |
| cc-plugin-unity-gamedev | GitHub | 21 Unity 开发 skills | 1 |

### 1.2 Claude Code Game Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

完整的 AI 游戏开发工作室架构：

- **48 个专业 Agents**：模拟真实游戏工作室层级
- **36 个 Workflow Skills**：覆盖完整开发流程
- **三层架构**：Directors → Leads → Specialists

### 1.3 Unity AI Workflow 2026 ⭐4

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

核心特性：
- **Game Feel 优先**：AI 在写代码前询问 VFX、SFX、相机反馈
- **三种 Dev Modes**：Assistant / Mix / Automatic
- **TCREI Prompting**：Task-Context-References-Evaluate-Iterate 方法论
- **验证系统**：[VERIFIED]/[SYNTHESIZED]/[UNVERIFIED] 标记

### 1.4 Unity GameDev Skills ⭐6

**项目地址**: [OstrichHermit/OH-Unity-GameDev-Skills](https://github.com/OstrichHermit/OH-Unity-GameDev-Skills)

21 个 Unity 开发 skills，覆盖：
- Addressables 资源管理
- Behavior Designer 行为树
- Cinemachine 虚拟相机
- GAS (Gameplay Ability System)
- VContainer 依赖注入
- UniTask 异步编程
- Wwise 音频

### 1.5 GameMaker Skills ⭐2

**项目地址**: [leihaht/gamemaker-skills](https://github.com/leihaht/gamemaker-skills)

完整 GML 开发覆盖：
- Object Creation Workflow
- GML Language Essentials
- Data Structures (Structs, Arrays, ds_*)
- File System & 存档系统
- Event System & 执行顺序
- Drawing & Graphics (Shader, 粒子)
- Collision & Movement
- Performance Optimization
- Networking

### 1.6 Godot  Skills ⭐3

**项目地址**: [kwhitejr/claude-resources](https://github.com/kwhitejr/claude-resources)

- 自定义 Claude Code agents
- GDScript 最佳实践
- Godot 4.x 开发工作流

### 1.7 游戏开发 Skills 推荐

```bash
# 核心 Skills 安装
clawhub install game-development
clawhub install openclaw-godot-skill
clawhub install godot-dev-guide
clawhub install unity
clawhub install openclaw-unreal-skill
```

---

## 🐍 二、Python 开发 Skills

### 2.1 热门 Skills 概览

| Skill | 来源 | 核心能力 | Stars |
|-------|------|---------|-------|
| fastapi | ClawHub | FastAPI RESTful 开发 | 3.523 |
| python-executor | ClawHub | 安全沙箱执行 Python | 3.480 |
| python-dataviz | ClawHub | 数据可视化 | 3.428 |
| beagle-python | GitHub | Python 代码审查 | 34 |
| python-security | GitHub | Python 安全编码 | 3 |

### 2.2 FastAPI Skill ⭐⭐⭐⭐⭐ (评分: 3.523)

核心能力：
- RESTful API 设计
- Pydantic 数据验证
- 依赖注入
- 自动文档生成 (Swagger/ReDoc)
- 异步支持
- 中间件系统
- 认证/授权 (OAuth2, JWT)

### 2.3 Python Testing Patterns

核心能力：
- pytest 测试框架
- Fixtures 测试夹具
- Mocking 模拟对象
- Parameterization 参数化
- Property-based testing

### 2.4 Async Python Patterns

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

### 2.5 Python 开发 Skills 推荐

```bash
# 核心 Skills
clawhub install fastapi
clawhub install python-executor
clawhub install python-dataviz

# 可选增强
clawhub install python-script-generator
clawhub install lsp-python
```

---

## 🧪 三、自动化测试 Skills

### 3.1 Playwright Skills 专题

| Skill | 来源 | Stars | 评分 |
|-------|------|-------|------|
| playwright-skill | GitHub | 1848 | 3.584 |
| playwright-mcp | ClawHub | - | 3.581 |
| playwright-scraper-skill | ClawHub | - | 3.584 |
| playwright | ClawHub | - | 3.538 |

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

核心特性：
- **Model-invoked**：Claude 自主编写和执行自动化脚本
- 浏览器自动化测试和验证
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 默认使用可见浏览器
- URL 参数化配置

### 3.2 QA Skills Directory ⭐71

**项目地址**: [PramodDutta/qaskills](https://github.com/PramodDutta/qaskills)

测试专用 Skills 目录：
- Claude Code, Cursor, Copilot 等平台
- 完整的 QA 工作流
- 测试最佳实践

### 3.3 Playwright E2E Agents ⭐11

**项目地址**: [yusuftayman/playwright-cli-agents](https://github.com/yusuftayman/playwright-cli-agents)

- 自动 Playwright E2E 测试生成
- 调试和规划
- Page Object Model 模式

### 3.4 移动端测试 Skills

| Skill | 评分 |
|-------|------|
| mobile-appium-test | 3.189 |
| android-remote-control | 3.304 |
| ios-simulator | 3.456 |
| android_control | 3.204 |

### 3.5 测试 Skills 推荐

```bash
# 测试运行器
clawhub install test-runner
clawhub install test-master
clawhub install test-patterns

# Playwright
clawhub install playwright
clawhub install playwright-mcp

# 移动端测试
clawhub install mobile-appium-test
clawhub install android-remote-control
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 GitHub 专题

| Skill | 评分 | 说明 |
|-------|------|------|
| github | 3.790 | GitHub 基础操作 |
| github-cli | 3.501 | GitHub CLI |
| code-review | 3.620 | 代码审查 |
| openclaw-github-assistant | 3.615 | GitHub 助手 |

### 4.2 Docker 专题

| Skill | 评分 |
|-------|------|
| docker-essentials | 3.694 |
| docker | 3.577 |
| docker-sandbox | 3.548 |
| docker-compose | 3.511 |

### 4.3 安全审计 Skills

| Skill | 评分 |
|-------|------|
| security-auditor | 3.556 |
| perseus | - |
| security-audit-toolkit | 3.513 |

### 4.4 开发者工具 Skills 推荐

```bash
# GitHub
clawhub install github
clawhub install github-cli
clawhub install code-review

# Docker
clawhub install docker-essentials
clawhub install docker-compose

# 浏览器自动化
clawhub install browser-automation
clawhub install playwright
```

---

## 📈 五、趋势分析

### 5.1 本周新增 Skills 汇总

| Skill | 类别 | Stars | 核心能力 |
|-------|------|-------|---------|
| Claude-Code-Game-Studios | 游戏开发 | 28 | 48 agents + 36 skills |
| OH-Unity-GameDev-Skills | 游戏开发 | 6 | 21 Unity skills |
| unity-ai-workflow | 游戏开发 | 4 | Unity 6 AI 工作流 |
| gamemaker-skills | 游戏开发 | 2 | GML 完整开发 |
| qaskills | 测试 | 71 | QA Skills 目录 |
| playwright-cli-agents | 测试 | 11 | Playwright E2E |
| beagle-python | Python | 34 | 代码审查 |
| Claudex | 工具 | 223 | 自定义 UI |

### 5.2 趋势亮点

1. **游戏工作室架构化**
   - Claude Code Game Studios 引入完整工作室层级
   - 48 agents 模拟真实团队分工

2. **测试自动化增强**
   - Playwright E2E 测试成为主流
   - QA Skills 专业目录出现

3. **Python 专业化**
   - FastAPI 成为 Web 开发标准
   - 安全编码意识提升

---

## 📝 附录

### A. Skills 安装命令汇总

```bash
# 游戏开发
clawhub install game-development
clawhub install unity
clawhub install openclaw-godot-skill
clawhub install openclaw-unreal-skill

# Python 开发
clawhub install fastapi
clawhub install python-executor
clawhub install python-dataviz

# 测试
clawhub install playwright
clawhub install playwright-mcp
clawhub install test-runner

# 开发者工具
clawhub install github
clawhub install docker-essentials
clawhub install security-auditor
```

### B. 文档格式参考

参考 cc_skills 仓库已有文档格式：
- 每类 Skills 独立章节
- 包含 Stars 数量和评分
- 提供安装命令
- 趋势分析

---

*文档更新于 2026-03-04*
