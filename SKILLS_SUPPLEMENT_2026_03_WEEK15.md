# Claude Code Skills 补充调研报告 - 2026年3月 (第十五周)

**调研日期**: 2026-03-04  
**技能来源**: ClawHub 实时搜索 + GitHub 热门仓库  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，基于 ClawHub 实时搜索排行和 GitHub 热门项目，覆盖以下方向：
1. 游戏客户端开发 (Unity/Godot/Unreal)
2. Python 开发 (FastAPI/Django/异步)
3. 自动化测试 (Playwright/测试框架)
4. 开发者工具 (GitHub/GitLab/Docker/K8s)

### 数据来源

| 来源 | 描述 |
|------|------|
| ClawHub Registry | 实时热门 Skills 搜索评分 |
| GitHub Trending | 近期热门项目 |
| Antigravity Awesome | 970+ Skills 分类集合 |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| game-cog | **1.102** | 游戏开发编排器 | 通用游戏开发 |
| openclaw-unity-skill | **1.013** | Unity 开发专家 | Unity 项目 |
| godot-dev-guide | **0.983** | Godot 4 开发 | Godot 项目 |
| game-developer-skill | **0.976** | Claude 游戏开发者 | AI 辅助开发 |
| unity | **0.961** | Unity 技能 | Unity 6+ |
| fivem-dev | **0.950** | FiveM 开发 | GTA V MOD |
| unreal-engine | **0.935** | Unreal Engine | UE5 开发 |
| openclaw-unreal-skill | **0.908** | Unreal 技能 | UE5 项目 |
| game-engine | **0.900** | 游戏引擎 | 引擎架构 |
| level-design-patterns | **0.845** | 关卡设计模式 | Unity 关卡 |

### 1.2 Unity AI Workflow 2026 详解

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

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
```

### 1.3 Godot Skills 详解

**Godot Dev Guide** (评分: 0.983)
- 核心能力: Godot 4 完整开发指南、项目架构设计、最佳实践、性能优化
- 适用场景: Godot 初学者入门、项目架构规划、性能调优

**OpenClaw Godot Skill** (评分: 1.102+)
- 核心能力: 场景管理、节点操作、信号系统、资源加载、GDScript 编写
- 适用场景: Godot 4 项目开发、2D/3D 游戏制作

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| fastapi | **1.095** | FastAPI 开发 | REST API |
| python | **0.984** | Python 编码规范 | 通用 Python |
| django | **0.963** | Django 开发 | Web 框架 |
| afrexai-fastapi-production | **0.883** | FastAPI 生产工程 | 高性能 API |
| drf | **0.880** | Django REST Framework | REST API |
| afrexai-django-production | **0.753** | Django 生产工程 | Django 生产 |

### 2.2 FastAPI Pro 详解

**核心能力**:
- 现代异步 Python 3.12+ 工具链
- Pydantic v2 严格类型
- SQLAlchemy 2.0 async
- 依赖注入
- 认证授权 (OAuth2/JWT)
- 测试覆盖 (pytest/pytest-asyncio)
- CI/CD 流水线

```python
### 现代 FastAPI 项目结构
project/
├── app/
│   ├── api/
│   │   └── v1/
│   ├── core/
│   │   ├── config.py
│   │   ├── security.py
│   │   └── database.py
│   ├── models/
│   ├── schemas/
│   ├── services/
│   └── main.py
├── tests/
├── alembic/
├── docker/
├── pyproject.toml
└── uv.lock
```

### 2.3 Python Async 专题

**关键技能**:
- asyncio 异步编程
- aiohttp/httpx 异步 HTTP
- asyncpg/aiomysql 异步数据库
- Redis aioredis 缓存
- Celery + Redis 异步任务

---

## 🧪 三、自动化测试 Skills

### 3.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| playwright | **1.225** | Playwright 自动化 | E2E 测试 |
| playwright-mcp | **1.220** | Playwright MCP | 浏览器自动化 |
| e2e-testing-patterns | **1.214** | E2E 测试模式 | 端到端测试 |
| playwright-scraper-skill | **1.212** | Playwright 爬虫 | 数据采集 |
| playwright-browser-automation | **1.162** | 浏览器自动化 | UI 自动化 |
| clawbrowser | **1.161** | Claw 浏览器 | 浏览器控制 |
| test-master | **1.160** | 测试大师 | 综合测试 |
| testing-patterns | **1.053** | 测试模式 | 通用测试 |
| senior-qa | **1.039** | 高级 QA | 质量保证 |
| playwright-skill | **1.015** | Playwright 技能 | E2E |

### 3.2 Playwright 专题详解

**Playwright** (评分: 1.225) - 最高分测试技能

```python
### Playwright 最佳实践
# 1. Page Object 模式
class LoginPage:
    def __init__(self, page):
        self.page = page
    
    def login(self, username, password):
        self.page.goto("/login")
        self.page.fill("#username", username)
        self.page.fill("#password", password)
        self.page.click("#submit")
        return DashboardPage(self.page)

# 2. Fixtures
@pytest.fixture
async def authenticated_page(page):
    await page.goto("/login")
    # ... login logic
    yield page

# 3. 截图对比 (Applitools/Percy)
```

### 3.3 游戏客户端测试专题

**关键技能**:
- Unity Test Framework (Unity 官方)
- NUnit + Unity Test Runner
- Playwright 游戏 Web UI 测试
- Appium 移动端游戏测试
- GPU 性能基准测试
- 内存泄漏检测

---

## 🛠️ 四、开发者工具 Skills

### 4.1 GitHub/GitLab 自动化

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| gitflow | **1.188** | GitFlow 工作流 | 版本管理 |
| gitlab-cli-skills | **1.166** | GitLab CLI | GitLab 管理 |
| cicd-pipeline | **1.116** | CI/CD 流水线 | 持续集成 |
| gitlab-manager | **1.101** | GitLab 管理 | 项目管理 |
| glab-cli | **1.093** | GitLab CLI | CLI 操作 |
| gitai-skill | **1.087** | Git 提交自动化 | 智能提交 |
| gh | **1.087** | GitHub CLI | GitHub 操作 |
| ci-cd | **1.072** | CI/CD | 持续集成 |

### 4.2 Docker/Kubernetes

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| docker-essentials | **1.266** | Docker  essentials | 容器入门 |
| docker | **1.152** | Docker 进阶 | 容器化 |
| kubectl | **1.113** | K8s 命令 | K8s 管理 |
| container-debug | **1.112** | 容器调试 | 问题排查 |
| devops | **1.080** | DevOps | 运维 |
| docker-ctl | **1.077** | Docker 控制 | 容器管理 |
| k8s-browser | **1.066** | K8s 浏览器 | K8s UI |
| k8-multicluster | **1.048** | 多集群 K8s | 多集群 |

### 4.3 Docker Essentials 详解 (评分: 1.266)

**核心能力**:
```bash
### 常用命令
docker build -t myapp .
docker run -d -p 8080:80 myapp
docker-compose up -d
docker exec -it container bash

### 多阶段构建
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-slim
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/index.js"]
```

---

## 📈 五、ClawHub Top 30 Skills 排行榜

| 排名 | Skill 名称 | 评分 | 类别 |
|------|------------|------|------|
| 1 | docker-essentials | 1.266 | DevOps |
| 2 | playwright | 1.225 | 测试 |
| 3 | playwright-mcp | 1.220 | 测试 |
| 4 | e2e-testing-patterns | 1.214 | 测试 |
| 5 | playwright-scraper-skill | 1.212 | 爬虫 |
| 6 | playwright-browser-automation | 1.162 | 自动化 |
| 7 | clawbrowser | 1.161 | 浏览器 |
| 8 | test-master | 1.160 | 测试 |
| 9 | docker | 1.152 | DevOps |
| 10 | gemini-computer-use | 1.139 | AI |
| 11 | gitflow | 1.188 | Git |
| 12 | gitlab-cli-skills | 1.166 | GitLab |
| 13 | kubectl | 1.113 | K8s |
| 14 | container-debug | 1.112 | DevOps |
| 15 | fastapi | 1.095 | Python |
| 16 | devops | 1.080 | DevOps |
| 17 | docker-ctl | 1.077 | Docker |
| 18 | browser-automation-stealth | 1.082 | 自动化 |
| 19 | k8s-browser | 1.066 | K8s |
| 20 | docker-compose | 1.050 | Docker |

---

## 🔧 六、快速开始指南

### 6.1 安装 Skills

```bash
# 通过 ClawHub 安装
clawhub install game-cog
clawhub install playwright
clawhub install fastapi
clawhub install docker-essentials
clawhub install gitflow

# 查看所有已安装
clawhub list
```

### 6.2 游戏开发工作流

```bash
# 1. 创建游戏项目
mkdir my-game && cd my-game

# 2. 安装 Unity/Godot Skill
clawhub install unity

# 3. 初始化项目
# 使用 /setup-project 命令

# 4. 开发功能
# 使用 /implement-feature 开发游戏功能
```

### 6.3 Python API 开发

```bash
# 1. 安装 FastAPI Skill
clawhub install fastapi
clawhub install afrexai-fastapi-production

# 2. 创建项目
fastapi start-project my-api

# 3. 运行开发服务器
uvicorn main:app --reload
```

---

## 📚 七、相关资源

- [ClawHub Skills 市场](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/anthropics/antigravity)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code)
- [OpenClaw 文档](https://docs.openclaw.ai)

---

*持续更新中...*

**下次更新**: 2026年3月第二周
