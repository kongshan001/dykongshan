# Claude Code Skills 补充调研报告 - 2026年3月 (第十六周)

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
| game-cog | **1.132** | 游戏开发编排器 | 通用游戏开发 |
| game-developer-skill | **0.974** | Claude 游戏开发者 | AI 辅助开发 |
| fivem-dev | **0.957** | FiveM 开发 | GTA V MOD |
| blender | **0.925** | Blender 3D 建模 | 3D 资产制作 |
| game-engine | **0.920** | 游戏引擎架构 | 引擎原理 |
| games | **0.908** | 游戏开发 | 通用游戏 |
| gaming | **0.903** | 游戏技能 | 休闲游戏 |
| primitives-dsl | **0.876** | 通用游戏原语 | 游戏基础组件 |
| game-design-philosophy | **0.873** | 游戏设计哲学 | 设计理念 |
| android-3d-developer | **0.878** | Android 3D 开发 | 移动 3D 游戏 |
| 3d-cog | **0.878** | 3D 开发编排 | 3D 项目 |

### 1.2 Unity Skills 详解

**OpenClaw Unity Skill** (评分: 0.978)
```markdown
### 核心能力
- Unity 6 LTS 最佳实践
- C# 脚本编写和优化
- URP/HDRP 渲染管线
- 跨平台部署 (iOS/Android/WebGL/Console)
- Unity Profiler 性能分析
- 资源管理和优化
```

**Unity** (评分: 0.945)
- 官方 Unity 技能，支持 Unity 6+
- 组件系统、场景管理、资产管理

### 1.3 Godot Skills 详解

**Godot Dev Guide** (评分: 0.974)
```markdown
### 核心能力
- Godot 4 完整开发工作流
- GDScript 2.0 语法和最佳实践
- 节点和场景系统
- 信号系统实现
- 资源加载和优化
- 2D/3D 游戏开发
```

**Godot Engine 3D Developer** (评分: 0.705)
- Godot 3D 专用开发技能

### 1.4 Unreal Engine Skills

**Unreal Engine** (评分: 0.905)
```markdown
### 核心能力
- Unreal 5.x C++ 开发
- Blueprint 可视化编程
- UObject 内存管理
- Slate/UMG UI 开发
- 网络复制和 RPC
- 模块化架构设计
```

**UE5.7 Gamepiece Designer** (评分: 0.763)
- UE5.7 专用游戏片段设计

### 1.5 专用游戏开发 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| Fivem | 0.957 | GTA V MOD 开发框架 |
| TTRPG Game Master | 0.925 | RPG 游戏主持技能 |
| ChessMaster | 0.863 | 棋类游戏开发 |
| UE Asset Finder | 0.614 | UE 资产生成 |

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| python-executor | **3.480** | Python 代码执行 | 快速脚本运行 |
| python-dataviz | **3.428** | Python 数据可视化 | 数据分析 |
| python-sdk | **3.333** | Python SDK 开发 | SDK 构建 |
| lsp-python | **3.289** | Python LSP | 语言服务器 |
| python-script-generator | **3.220** | Python 脚本生成 | 代码生成 |
| fastapi | **1.067** | FastAPI 开发 | REST API |
| django | **0.943** | Django 开发 | Web 框架 |
| drf | **0.826** | Django REST Framework | REST API |
| afrexai-fastapi-production | **0.805** | FastAPI 生产工程 | 高性能 API |

### 2.2 FastAPI Pro 详解

**FastAPI** (评分: 1.067)

```python
### 现代 FastAPI 项目结构
project/
├── app/
│   ├── api/v1/
│   ├── core/
│   │   ├── config.py      # 配置管理
│   │   ├── security.py   # 安全认证
│   │   └── database.py   # 数据库连接
│   ├── models/            # SQLAlchemy 模型
│   ├── schemas/          # Pydantic schemas
│   ├── services/         # 业务逻辑
│   └── main.py           # 应用入口
├── tests/
├── alembic/              # 数据库迁移
├── docker/
├── pyproject.toml
└── uv.lock               # uv 包管理
```

### 2.3 Django Skills 详解

**Django** (评分: 0.943)
```markdown
### 核心能力
- Django 5.x 最新特性
- ORM 查询优化
- Django REST Framework
- 中间件开发
- 管理后台定制
- 测试覆盖
```

**Django REST Framework** (评分: 0.826)
- REST API 开发
- ViewSets 和 Routers
- 序列化器设计
- 认证和权限

### 2.4 Python 数据处理 Skills

**Python Dataviz** (评分: 3.428) - 高分技能
```markdown
### 数据可视化能力
- Matplotlib/Seaborn 静态图表
- Plotly 交互式图表
- Pandas 数据处理
- Jupyter Notebook 集成
```

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

**游戏测试关键技能**:
- Unity Test Framework (Unity 官方测试框架)
- NUnit 测试运行器
- 编辑器模式测试
- Play 模式测试
- 性能测试 (Profiler 集成)

### 3.4 E2E 测试模式

**E2E Testing Patterns** (评分: 1.214)
```markdown
### 核心测试模式
- Page Object Model (POM)
- Screenplay Pattern
- Behavior Driven Development (BDD)
- Visual Regression Testing
- Accessibility Testing
- Performance Testing
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| openclaw-github-assistant | **1.146** | GitHub 助手 | GitHub 自动化 |
| gitclassic | **1.095** | Git 经典操作 | Git 工作流 |
| github-cli | **1.039** | GitHub CLI | 命令行操作 |
| gh-action-gen | **1.009** | GitHub Actions 生成 | CI/CD |
| repo-analyzer | **0.965** | 仓库分析 | 代码分析 |
| devtopia | **0.978** | 开发者工具集合 | 综合开发 |
| apple-developer-toolkit | **0.951** | Apple 开发者工具 | iOS/macOS |
| basecamp-cli-mcp | **1.068** | Basecamp CLI | 项目管理 |

### 4.2 GitHub 工具链

**OpenClaw GitHub Assistant** (评分: 1.146)
```markdown
### 核心能力
- Issue 创建和管理
- PR 创建和审查
- Actions 工作流触发
- 仓库信息查询
- 自动化工单处理
```

**GitHub CLI** (评分: 1.039)
```bash
# 常用命令
gh issue create --title "Bug" --body "描述"
gh pr create --title "Feature" --head "branch"
gh run list --workflow "CI"
gh repo view
```

### 4.3 CI/CD 工具

**GitHub Actions Generator** (评分: 1.009)
```yaml
# 示例工作流
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: pip install -r requirements.txt
      - run: pytest
```

### 4.4 浏览器自动化工具

| Skill | 评分 | 描述 |
|-------|------|------|
| Clawbrowser | 1.161 | Claw 浏览器控制 |
| Browser Automation Stealth | 1.048 | 隐形浏览器自动化 |
| Web Form Automation | 0.994 | Web 表单自动化 |
| Playwright Headless Browser | 0.994 | 无头浏览器 |

---

## 📈 五、Skills 安装和使用

### 5.1 通过 ClawHub 安装

```bash
# 安装单个 Skill
clawhub install game-cog
clawhub install fastapi
clawhub install playwright

# 搜索 Skills
clawhub search "game"
clawhub search "python"
```

### 5.2 通过 GitHub 仓库使用

```bash
# 克隆仓库
git clone https://github.com/kongshan001/cc_skills.git

# 安装依赖
cd cc_skills
./install.sh
```

---

## 📚 六、参考资料

- [ClawHub Skills Registry](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/BestOfAI/antigravity-awesome-skills)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)

---

**文档状态**: ✅ 已完成  
**下次调研**: 2026-03-11 (第十七周)
