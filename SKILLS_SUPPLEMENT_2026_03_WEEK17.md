# Claude Code Skills 补充调研报告 - 2026年3月 (第十七周)

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
4. 开发者工具 (GitHub/Docker/K8s)

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

**Level Design Patterns** (评分: 0.774)
- Unity 关卡设计模式
- 场景布局和游戏节奏

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

**Godot Engine 3D Developer** (评分: 0.672)
- Godot 3D 专用开发技能

### 1.4 Unreal Engine Skills

**Unreal Engine** (评分: 0.925)
```markdown
### 核心能力
- Unreal 5.x C++ 开发
- Blueprint 可视化编程
- UObject 内存管理
- Slate/UMG UI 开发
- 网络复制和 RPC
- 模块化架构设计
```

**UE Build Package** (评分: 0.636)
- UE 项目构建和打包

**UE Asset Finder** (评分: 0.631)
- UE 资产生成工具

**UE Code Search** (评分: 0.624)
- UE 代码搜索工具

**UE Log Analyzer** (评分: 0.598)
- UE 日志分析工具

### 1.5 游戏开发 Workflow Skills

**game-cog** (评分: 1.132) - 游戏开发编排器
- 通用游戏开发工作流编排
- 多引擎协调开发

---

## 🐍 二、Python 开发 Skills

### 2.1 Python Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| py | **1.049** | Python 开发 | 通用 Python |
| python | **1.000** | Python 编码规范 | 规范开发 |
| python-executor | **0.973** | Python 执行器 | 代码执行 |
| python-dataviz | **0.888** | Python 数据可视化 | 数据分析 |
| fastapi | **1.079** | FastAPI 开发 | Web API |
| django | **0.959** | Django 开发 | Web 框架 |
| async-task | **0.899** | 异步任务处理 | 并发编程 |

### 2.2 FastAPI Skills 详解

**fastapi** (评分: 1.079)
```markdown
### 核心能力
- FastAPI 完整开发工作流
- Pydantic 数据验证
- 依赖注入系统
- SQLAlchemy 集成
- 异步数据库操作
- JWT 认证
- OpenAPI 自动生成
```

**afrexai-fastapi-production** (评分: 0.812)
- FastAPI 生产级工程实践
- 部署和运维最佳实践

### 2.3 Django Skills 详解

**django** (评分: 0.959)
```markdown
### 核心能力
- Django 完整开发周期
- ORM 模型设计
- Admin 后台管理
- 表单和验证
- CBV/FBV 开发
- 中间件开发
- REST Framework 集成
```

**afrexai-django-production** (评分: 0.769)
- Django 生产级工程实践

**Django REST Framework** (评分: 0.841)
- RESTful API 开发

### 2.4 Python 工具链 Skills

**python-dataviz** (评分: 0.888)
- Matplotlib/Seaborn/Plotly
- Pandas 数据处理
- Jupyter Notebook 集成

**async-task** (评分: 0.899)
- asyncio 异步编程
- 任务队列集成
- 后台任务处理

---

## 🧪 三、自动化测试 Skills

### 3.1 测试 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| playwright-mcp | **1.213** | Playwright MCP | 浏览器自动化 |
| playwright-scraper-skill | **1.206** | Playwright 爬虫 | 数据抓取 |
| playwright | **1.197** | Playwright 测试 | E2E 测试 |
| e2e-testing-patterns | **1.188** | E2E 测试模式 | 测试最佳实践 |
| playwright-browser-automation | **1.150** | 浏览器自动化 | 自动化操作 |
| test-master | **1.149** | 测试大师 | 综合测试 |
| clawbrowser | **1.147** | 浏览器控制 | 自动化 |
| senior-qa | **1.021** | 高级 QA | 质量保证 |
| playwright-npx | **1.003** | Playwright 脚本 | 测试脚本 |
| playwright-headless-browser | **0.994** | 无头浏览器 | 自动化 |

### 3.2 Playwright Skills 详解

**playwright-mcp** (评分: 1.213)
```markdown
### 核心能力
- Playwright MCP 服务器集成
- 浏览器自动化
- 网页截图和录制
- 网络请求拦截
- 状态管理
```

**playwright** (评分: 1.197)
```markdown
### 核心能力
- Playwright E2E 测试
- 多浏览器支持 (Chromium/Firefox/WebKit)
- 自动等待和重试
- 截图和视频录制
- CI/CD 集成
- 测试报告生成
```

**playwright-scraper-skill** (评分: 1.206)
- 数据抓取和爬虫
- 动态网页采集

**e2e-testing-patterns** (评分: 1.188)
```markdown
### 核心能力
- E2E 测试最佳实践
- Page Object 模式
- 测试数据管理
- 并行测试执行
- 测试环境隔离
```

### 3.3 游戏客户端测试 Skills

**android-adb** (评分: 1.210)
- Android ADB 连接
- 移动端游戏测试

**midscene-android-automation** (评分: 1.006)
- Android 自动化测试
- 移动游戏 UI 测试

**midscene-ios-automation** (评分: 0.960)
- iOS 自动化测试

**mobile-appium-test** (评分: 0.931)
- Appium 移动测试
- 跨平台移动测试

---

## 🛠️ 四、开发者工具 Skills

### 4.1 开发者工具排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| github | **1.357** | GitHub 操作 | 代码管理 |
| docker-essentials | **1.268** | Docker 基础 | 容器化 |
| docker | **1.172** | Docker 高级 | 容器编排 |
| openclaw-github-assistant | **1.141** | GitHub 助手 | 自动化 |
| container-debug | **1.105** | 容器调试 | 问题排查 |
| gitclassic | **1.092** | Git 操作 | 版本控制 |
| cicd-pipeline | **1.091** | CI/CD 流水线 | 持续集成 |
| gh | **1.075** | GitHub CLI | 命令行 |
| repo-analyzer | **0.944** | 仓库分析 | 代码分析 |

### 4.2 GitHub Skills 详解

**github** (评分: 1.357)
```markdown
### 核心能力
- Issue 管理
- PR 创建和审查
- Actions 工作流
- 仓库操作
- 代码搜索
- 安全扫描
```

**openclaw-github-assistant** (评分: 1.141)
- OpenClaw GitHub 助手
- 自动化 GitHub 操作

**gh** (评分: 1.075)
- GitHub CLI 工具
- 命令行操作

### 4.3 Docker Skills 详解

**docker-essentials** (评分: 1.268)
```markdown
### 核心能力
- Docker 基础操作
- 镜像构建
- 容器运行和管理
- 网络配置
- 数据卷管理
- Docker Compose
```

**docker** (评分: 1.172)
```markdown
### 核心能力
- Docker 高级特性
- 多阶段构建
- 优化镜像大小
- 安全加固
- 集群编排
```

**container-debug** (评分: 1.105)
- 容器调试技能
- 日志分析
- 问题诊断

### 4.4 CI/CD Skills 详解

**cicd-pipeline** (评分: 1.091)
```markdown
### 核心能力
- CI/CD 流水线设计
- GitHub Actions
- GitLab CI
- Jenkins 集成
- 自动化部署
- 回滚策略
```

---

## 📈 五、综合评分排行榜

### 5.1 Top 30 Skills (ClawHub)

| 排名 | Skill 名称 | 评分 | 分类 |
|------|------------|------|------|
| 1 | github | 1.357 | 开发者工具 |
| 2 | docker-essentials | 1.268 | 开发者工具 |
| 3 | playwright-mcp | 1.213 | 自动化测试 |
| 4 | playwright-scraper-skill | 1.206 | 自动化测试 |
| 5 | playwright | 1.197 | 自动化测试 |
| 6 | e2e-testing-patterns | 1.188 | 自动化测试 |
| 7 | docker | 1.172 | 开发者工具 |
| 8 | playwright-browser-automation | 1.150 | 自动化测试 |
| 9 | test-master | 1.149 | 自动化测试 |
| 10 | clawbrowser | 1.147 | 自动化测试 |
| 11 | game-cog | 1.132 | 游戏开发 |
| 12 | openclaw-github-assistant | 1.141 | 开发者工具 |
| 13 | gemini-computer-use | 1.138 | 自动化测试 |
| 14 | container-debug | 1.105 | 开发者工具 |
| 15 | py | 1.049 | Python |
| 16 | browser-automation-stealth | 1.048 | 自动化测试 |
| 17 | python | 1.000 | Python |
| 18 | senior-qa | 1.021 | 自动化测试 |
| 19 | manikantasai-playwright-automation | 1.014 | 自动化测试 |
| 20 | playwright-npx | 1.003 | 自动化测试 |

---

## 🔍 六、Skills 趋势分析

### 6.1 热门分类

| 分类 | 热门 Skills | 趋势 |
|------|-------------|------|
| 自动化测试 | Playwright 系列 | ⬆️ 持续上升 |
| 开发者工具 | GitHub/Docker | ⬆️ 稳定热门 |
| Python | FastAPI/Django | ⬆️ 稳步增长 |
| 游戏开发 | game-cog/Unity/Godot | ↗️ 增长中 |

### 6.2 新兴 Skills

- **playwright-mcp**: Playwright MCP 服务器集成
- **game-cog**: 游戏开发编排器
- **midscene-android-automation**: 移动端游戏测试
- **async-task**: Python 异步任务处理

---

## 📝 七、总结与建议

### 7.1 重点关注 Skills

1. **游戏客户端开发**: game-cog、Unity、Godot、Unreal
2. **Python 开发**: FastAPI、Django、async-task
3. **自动化测试**: Playwright 系列、test-master
4. **开发者工具**: GitHub、Docker、CI/CD

### 7.2 学习路径建议

- **游戏开发**: 从 Unity/Godot 基础开始 → 学习 game-cog 编排
- **Python 开发**: Python 基础 → FastAPI/Django → 异步编程
- **测试技能**: Playwright 基础 → E2E 测试模式 → 移动端测试
- **DevOps**: Git → Docker → CI/CD → Kubernetes

---

*文档更新时间: 2026-03-04*
