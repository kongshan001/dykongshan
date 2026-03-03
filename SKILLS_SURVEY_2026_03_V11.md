# Claude Code Skills 调研报告 - 2026年3月 (第十一轮更新)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub 实时搜索 + Antigravity Awesome Skills (970+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成 (第十一轮更新)

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，覆盖以下方向：
1. 游戏客户端开发 (Unity/Godot/Unreal)
2. Python 开发 (FastAPI/异步/测试)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (浏览器自动化/GitHub 自动化)

### 数据来源

| 来源 | Skills 数量 | 说明 |
|------|-------------|------|
| Antigravity Awesome Skills | 970+ | 10+ AI 助手平台支持 |
| GitHub Topics | 248+ | claude-code-skill 主题仓库 |
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
| unity-ai-workflow | GitHub | Unity 6.2+ AI 开发工作流 | 4⭐ 2026新 |
| bevy-ecs-expert | antigravity | Bevy ECS (Rust) | 中 |
| game-audio | antigravity | 游戏音频 | 中 |
| game-art | antigravity | 游戏美术管线 | 中 |

### 1.2 Unity AI Workflow 2026 (新增)

**来源**: GitHub - David-GD13/unity-ai-workflow

```markdown
### 🎮 Dev Modes (三种开发模式)
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、游戏 jam |

### 🧃 核心哲学: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

### 🧠 技术架构
- TCREI Prompting: Task-Context-References-Evaluate-Iterate 方法论
- 验证系统: 每个 AI 推荐标记 [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED]
```

### 1.3 游戏开发核心原则

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

### 2.2 Python 开发新发现 (从 GitHub Topics)

| 仓库 | 描述 | 语言 |
|------|------|------|
| mastering-langgraph-agent-skill | LangGraph 状态ful AI agents | Python |
| playwright-bot-bypass | 绕过机器人检测 (Google CAPTCHA) | JavaScript |
| developer-kit | 模块化插件系统 (Java/Spring/TypeScript/Python) | 多语言 |

### 2.3 Async Python Patterns 详解

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

### 3.2 游戏客户端自动化测试专题

**新增调研方向**

| 测试类型 | 工具/Skill | 适用场景 |
|---------|-----------|---------|
| UI 自动化 | Playwright, Cypress | 游戏 UI 测试 |
| 移动端测试 | Appium, Detox | iOS/Android 游戏 |
| 性能测试 | Unity Profiler, custom scripts | 帧率、内存测试 |
| 截图对比 | Playwright, Percy | 视觉回归测试 |
| 自动化构建 | GitHub Actions, fastlane | CI/CD 流水线 |

### 3.3 Playwright 专题

```markdown
### 核心能力
- 浏览器自动化
- 表单填写和提交
- 页面截图
- 数据提取
- E2E 测试
- 视觉回归测试
- MCP 协议集成

### 评分 Top 5
| Skill ID | 评分 |
|----------|------|
| playwright-scraper-skill | 3.584 |
| playwright-mcp | 3.581 |
| playwright | 3.538 |
| playwright-browser-automation | 3.509 |
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
| code-review | 3.620 | 代码审查 |
| receiving-code-review | 3.570 | 接收代码审查 |
| requesting-code-review | 3.554 | 请求代码审查 |

### 4.2 Docker 专题

| Skill | 评分 | 说明 |
|-------|------|------|
| docker-essentials | 3.694 | Docker 基础 |
| docker | 3.577 | Docker 完整版 |
| docker-sandbox | 3.548 | Docker 沙箱 |
| docker-ctl | 3.531 🆕 | Docker 控制 |
| docker-compose | 3.511 | Docker Compose |

### 4.3 浏览器自动化专题

| Skill | 评分 |
|-------|------|
| agent-browser | 3.772 |
| browser-automation | 3.700 |
| browser-use | 3.653 |
| fast-browser-use | 3.619 |
| stagehand-browser-cli | 3.597 |

### 4.4 新发现的开发者工具 (GitHub Topics)

| 仓库 | 描述 | 语言 |
|------|------|------|
| jira-skill | 智能 Jira 集成 + MCP 配置 | Python |
| git-context-controller | Git-like 上下文管理 (COMMIT/BRANCH/MERGE) | Shell |
| agent-rules-skill | AGENTS.md 文件生成 | Shell |
| token-optimizer | 上下文 token 优化，节省 50% | HTML |
| project-memory | 项目状态跟踪 | JavaScript |
| nelson | 多 Agent 团队协调 (海军指挥结构) | Python |

---

## 📈 Skills 评分排行榜 (Top 30)

| 排名 | Skill | 类别 | 评分 | 趋势 |
|------|-------|------|------|------|
| 1 | github | DevOps | 3.790 | - |
| 2 | agent-browser | Browser | 3.772 | - |
| 3 | automation-workflows | Automation | 3.699 | - |
| 4 | browser-automation | Browser | 3.700 | 🆕 |
| 5 | docker-essentials | DevOps | 3.694 | - |
| 6 | test-runner | Testing | 3.639 | 🆕 |
| 7 | code-review | DevOps | 3.620 | 🆕 |
| 8 | fast-browser-use | Browser | 3.619 | 🆕 |
| 9 | openclaw-github-assistant | DevOps | 3.615 | 🆕 |
| 10 | browser-use | Browser | 3.653 | 🆕 |
| 11 | playwright-scraper-skill | Automation | 3.584 | - |
| 12 | playwright-mcp | Automation | 3.581 | - |
| 13 | test-master | Testing | 3.576 | 🆕 |
| 14 | docker | DevOps | 3.577 | - |
| 15 | receiving-code-review | DevOps | 3.570 | 🆕 |
| 16 | docker-sandbox | DevOps | 3.548 | - |
| 17 | test-patterns | Testing | 3.548 | 🆕 |
| 18 | playwright | Automation | 3.538 | - |
| 19 | security-auditor | Security | 3.556 | 🆕 |
| 20 | docker-ctl | DevOps | 3.531 | 🆕 |
| 21 | docker-compose | DevOps | 3.511 | - |
| 22 | playwright-browser-automation | Automation | 3.509 | - |
| 23 | openclaw-godot-skill | Game | 3.497 | 🆕 |
| 24 | python-executor | Python | 3.480 | 🆕 |
| 25 | godot-dev-guide | Game | 3.442 | 🆕 |
| 26 | fastapi | Python | 3.523 | 🆕 |
| 27 | test-specialist | Testing | 3.467 | 🆕 |
| 28 | test-sentinel | Testing | 3.347 | 🆕 |
| 29 | test-case-generator | Testing | 3.336 | 🆕 |
| 30 | playwright-browser-automation | Automation | 3.509 | - |

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
- [GitHub Topics: claude-code-skill](https://github.com/topics/claude-code-skill) (248+ 仓库)

---

**文档版本**: 2026.03.04.11  
**本轮更新**: 
- 新增 GitHub Topics 新发现 Skills (jira-skill, git-context-controller, token-optimizer 等)
- 新增 Unity AI Workflow 2026 专题
- 新增 mastering-langgraph-agent-skill (LangGraph AI agents)
- 新增 developer-kit (多语言模块化插件系统)
- 新增游戏客户端自动化测试专题
- 更新 Skills 评分排行榜 Top 30
- 增加各分类 Skills 推荐安装命令

**调研完成**: ✅
