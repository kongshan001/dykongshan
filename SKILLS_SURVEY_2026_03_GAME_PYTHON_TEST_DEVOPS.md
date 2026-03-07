# Claude Code Skills 完整调研报告 - 游戏客户端开发/Python 开发/游戏客户端自动化测试/开发者工具

**调研日期**: 2026-03-04  
**技能来源**: ClawHub 实时搜索 + GitHub 热门仓库 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，基于 ClawHub 实时搜索排行和 GitHub 热门项目，覆盖以下方向：
1. **游戏客户端开发** (Unity/Godot/Unreal)
2. **Python 开发** (FastAPI/Django/异步)
3. **游戏客户端自动化测试** (移动端/UI 自动化)
4. **开发者工具** (浏览器自动化/GitHub 自动化/Docker)

### 数据来源

| 来源 | 描述 |
|------|------|
| ClawHub Registry | 实时热门 Skills 搜索评分 |
| GitHub Trending | 近期热门项目 |
| Antigravity Awesome | 970+ Skills 分类集合 |
| Claude Code 官方 | Claude Code 内置 Skills |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| game-cog | **1.102** | 游戏开发编排器，DeepResearch Bench 第一名 | 通用游戏开发 |
| openclaw-unity-skill | **1.013** | Unity 开发技能 | Unity 开发 |
| godot-dev-guide | **0.983** | Godot 4.x 完整开发指南 | Godot 开发 |
| game-developer-skill | **0.976** | Claude 游戏开发者 | AI 辅助开发 |
| blender | **0.965** | Blender 3D 建模 | 3D 资产制作 |
| unity | **0.961** | Unity 最佳实践 | Unity 开发 |
| fivem-dev | **0.950** | Fivem 开发 | GTA5 Mod 开发 |
| unreal-engine | **0.935** | Unreal Engine 开发 | UE 开发 |
| openclaw-unreal-skill | **0.908** | Unreal 开发技能 | UE 开发 |
| game-engine | **0.900** | 游戏引擎架构 | 引擎原理 |

### 1.2 热门游戏引擎 Skills 详解

#### 1.2.1 Unity 开发 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| unity | 3.030 | Unity 最佳实践和开发指南 |
| openclaw-unity-skill | 1.013 | OpenClaw Unity 开发技能 |

**Unity AI Workflow 2026** - ⭐ 重点推荐

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

### 🧠 技术架构
- TCREI Prompting: Task-Context-References-Evaluate-Iterate 方法论
- 验证系统: 每个 AI 推荐标记 [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED]
- 专家 Skills: UI Toolkit、ScriptableObject、Netcode、game feel、测试、调试
```

#### 1.2.2 Godot 开发 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| openclaw-godot-skill | 3.497 | OpenClaw Godot 开发技能 |
| godot-dev-guide | 3.442 | Godot 4.x 完整开发指南 |

**Godot 4.x 核心能力**:

```markdown
### GDScript 2.0 特性
- 改进的类型推断
- @export 注解
- await/awaited signals
- 更好的性能

### 核心模式
- Signal 信号系统
- Scene 场景管理
- State Machine 状态机
- 对象池和优化
```

#### 1.2.3 Unreal Engine 开发 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| openclaw-unreal-skill | 3.376 | OpenClaw Unreal 开发技能 |
| unreal-engine | 0.935 | Unreal Engine 开发 |
| ue-log-analyzer | 0.552 | UE 日志分析 |
| ue-build-package | 0.550 | UE 打包构建 |
| ue-code-search | 0.544 | UE 代码搜索 |

**Unreal Engine 5.x 核心能力**:

```markdown
### C++ 开发最佳实践
- UObject 规范和内存管理
- 性能优化模式
- 智能指针和垃圾回收

### 高级系统
- Slate UI 框架
- UMG 动画
- 网络复制和 RPC
- 模块化架构
```

### 1.3 Antigravity 游戏开发 Skills 矩阵

**来源**: [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) (18,542⭐)

| Skill ID | 名称 | 核心能力 | 适用引擎 |
|----------|------|---------|---------|
| unity-developer | Unity 6 LTS 专家 | URP/HDRP、跨平台部署 | Unity |
| unity-ecs-patterns | DOTS/ECS 架构 | Jobs System、Burst | Unity |
| godot-gdscript-patterns | Godot 4 GDScript | 信号、场景、状态机 | Godot |
| godot-4-migration | Godot 4 迁移 | 3.x → 4.x 迁移 | Godot |
| unreal-engine-cpp-pro | UE5 C++ 开发 | UObject、Slate、网络复制 | Unreal |
| 2d-games | 2D 游戏开发 | 精灵、瓦片地图、物理 | 通用 |
| 3d-games | 3D 游戏开发 | 渲染、着色器、物理 | 通用 |
| game-development | 游戏开发编排器 | 自动路由到子 Skills | 通用 |
| mobile-games | 移动游戏开发 | 触控输入、电池优化 | 移动端 |
| multiplayer | 多人游戏开发 | 网络架构、延迟补偿 | 通用 |

### 1.4 游戏开发学习路径

```
入门级:
  1. 2d-games → 基础 2D 游戏开发
  2. 3d-games → 基础 3D 游戏开发
  3. game-design → 游戏设计原理

进阶级:
  1. unity-developer → Unity 6 LTS 开发
  2. godot-gdscript-patterns → Godot 4 开发
  3. unreal-engine-cpp-pro → Unreal 5 开发

高级:
  1. unity-ecs-patterns → DOTS 架构
  2. multiplayer → 网络同步
  3. game-cog → AI 编排开发
```

---

## 🐍 二、Python 开发 Skills

### 2.1 Python Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| python-executor | **3.480** | Python 代码执行器 | 代码执行 |
| python-dataviz | **3.428** | Python 数据可视化 | 数据分析 |
| strava-python | **3.334** | Strava Python SDK | API 集成 |
| python-sdk | **3.333** | Python SDK 开发 | SDK 开发 |
| lsp-python | **3.289** | LSP Python | 语言服务器 |
| python-script-generator | **3.220** | Python 脚本生成器 | 脚本生成 |
| python | **3.174** | Python 编码规范 | 规范开发 |
| python-pro | - | Python 3.12+ 全栈指南 | 通用 Python |
| fastapi | **1.108** | FastAPI 开发 | Web API |
| django | **0.960** | Django 开发 | Web 框架 |
| senior-backend | **0.948** | 高级后端开发 | 企业级后端 |
| test-patterns | **0.942** | 测试模式 | 测试开发 |

### 2.2 Python 开发 Skills 矩阵

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| python-pro | Python 3.12+ 全栈指南 | 通用 Python 开发 |
| python-patterns | 开发原则和决策 | 架构设计 |
| python-fastapi-development | FastAPI 后端开发 | API 服务 |
| python-development-python-scaffold | 项目脚手架 | 项目初始化 |
| python-testing-patterns | pytest/测试策略 | 质量保证 |
| python-performance-optimization | 性能分析和优化 | 性能调优 |
| python-packaging | PyPI 发布 | 库分发 |
| async-python-patterns | asyncio 异步编程 | 高并发 |
| temporal-python-pro | Temporal 工作流 | 分布式事务 |

### 2.3 FastAPI 专题详解

**FastAPI (评分: 1.108)** - ⭐ 重点推荐

```markdown
### 核心能力
- FastAPI 完整开发工作流
- Pydantic 数据验证
- 依赖注入系统
- SQLAlchemy 集成
- 异步数据库操作
- JWT 认证
- OpenAPI 自动生成
- 类型提示和验证
- 异步支持

### 适用场景
- ✅ 高性能 REST API
- ✅ 微服务架构
- ✅ 实时 WebSocket 应用
- ✅ 数据处理管道
- ✅ ML 模型服务
```

### 2.4 Python 异步编程专题

**async-python-patterns** - 高并发开发

```markdown
### 核心能力
- asyncio 异步编程
- 异步上下文管理器
- 异步迭代器
- 异步生成器
- 任务调度
- 并发控制

### 适用场景
- ✅ 高并发网络服务
- ✅ 实时数据处理
- ✅ WebSocket 服务器
- ✅ 爬虫并发
- ✅ 异步微服务
```

### 2.5 Python 现代化工具链

**2024/2025 最新工具**:

```markdown
### 包管理
- uv: 2024 最快包管理器 (Rust 实现)
- pip: Python 官方包管理器
- poetry: 依赖管理和打包

### 代码质量
- ruff: 替代 black/isort/flake8 (Rust 实现)
- mypy: 静态类型检查
- pyright: Microsoft 类型检查器

### 测试
- pytest: 主流测试框架
- hypothesis: 属性测试
- pytest-cov: 覆盖率分析

### 项目配置
- pyproject.toml: 现代标准
- setuptools: 打包工具
- hatch: 现代项目管理
```

### 2.6 Python 开发学习路径

```
入门级:
  1. python → Python 基础
  2. py → 通用 Python 开发
  3. python-patterns → 设计模式

进阶级:
  1. fastapi → FastAPI Web 开发
  2. django → Django 全栈开发
  3. async-python-patterns → 异步编程

高级:
  1. senior-backend → 企业级后端
  2. temporal-python-pro → 工作流引擎
  3. python-performance-optimization → 性能优化
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 测试 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| e2e-testing-patterns | **3.526** | E2E 测试模式 | 测试最佳实践 |
| testing-patterns | **3.470** | 测试模式 | 综合测试 |
| afrexai-qa-testing-engine | **3.404** | QA 测试引擎 | AI 驱动测试 |
| testing-workflow | **3.389** | 测试工作流 | 测试流程 |
| rtfm-testing | **3.388** | RTFM 测试 | 测试文档 |
| sql-injection-testing | **3.375** | SQL 注入测试 | 安全测试 |
| qa-testing-bots | **3.235** | QA 测试机器人 | 自动化测试 |
| android-adb | **1.220** | ADB 连接 | 移动端测试 |
| playwright-scraper-skill | **1.157** | Playwright 爬虫 | 数据抓取 |
| test-master | **1.082** | 测试大师 | 综合测试 |

### 3.2 Playwright 专题 (评分最高)

**Playwright 系列 Skills** - Web 自动化测试首选

| Skill | 评分 | 描述 |
|-------|------|------|
| playwright-scraper-skill | 3.584 | Playwright 爬虫技能 |
| playwright-mcp | 3.581 | Playwright MCP 服务器 |
| playwright | 3.538 | Playwright | playwright-browser-automation | 3.509 | 浏览器自动化 |
| playwright-headless-browser | 3.367 | 无头浏览器 |
| playwright-npx | 3.336 | Playwright 脚本 |
| playwright-skill | 3.278 | Playwright 技能 |

```markdown
### 核心能力
- 跨浏览器自动化 (Chromium, Firefox, WebKit)
- 自动化测试
- 网页爬虫
- 屏幕截图
- PDF 生成
- 移动端模拟
- 网络拦截
- 视频录制

### 适用场景
- ✅ E2E 测试
- ✅ 回归测试
- ✅ 视觉回归测试
- ✅ 数据抓取
- ✅ 自动化工作流
```

### 3.3 移动端游戏测试 Skills 矩阵

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|-----------|------|---------|---------|
| android-adb | **1.220** | ADB 连接 | 设备控制 |
| android | **1.019** | Android 开发 | 移动端 |
| midscene-android-automation | **1.009** | Android 自动化 | 移动游戏测试 |
| mobile | **0.995** | 移动开发 | 移动端 |
| ios | **0.977** | iOS 开发 | iOS 开发 |
| mobile-appium-test | **0.894** | Appium 跨平台测试 | 跨平台测试 |
| atl-mobile | **0.929** | Agent Touch Layer | 移动端自动化 |
| ios-simulator | **0.930** | iOS 模拟器 | iOS 测试 |

### 3.4 Android ADB 专题详解

**android-adb (评分: 1.220)** - ⭐ 重点推荐

```markdown
### 核心能力
- Android ADB 连接
- 设备管理
- 日志抓取
- APK 安装卸载
- 屏幕截图和录制
- 性能监控
- 游戏客户端测试

### 适用场景
- ✅ Android 游戏自动化测试
- ✅ 移动端性能分析
- ✅ 游戏客户端兼容性测试
- ✅ 自动化回归测试
- ✅ 游戏脚本录制回放
```

### 3.5 Midscene 专题详解

**midscene-android-automation (评分: 1.009)** - AI 驱动测试

```markdown
### 核心能力
- Android 游戏自动化
- AI 驱动测试
- 自动化脚本生成
- 跨设备测试
- 性能监控
- 回归测试

### 核心特性
- 🎮 专为游戏测试设计
- 🤖 AI 自动生成测试用例
- 📊 性能数据采集
- 🔄 支持自动化回归
```

### 3.6 游戏客户端测试学习路径

```
入门级:
  1. android-adb → ADB 基础
  2. android → Android 基础
  3. playwright → Web 自动化基础

进阶级:
  1. midscene-android-automation → AI 驱动测试
  2. e2e-testing-patterns → E2E 测试
  3. mobile-appium-test → Appium 跨平台

高级:
  1. test-master → 综合测试
  2. atl-mobile → 高级移动自动化
  3. game-cog → 游戏开发+测试
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 浏览器自动化 Tools (评分最高)

**Playwright 系列** - Web 自动化首选

| Skill | 评分 | 描述 |
|-------|------|------|
| playwright-scraper-skill | 3.584 | Playwright 爬虫 |
| playwright-mcp | 3.581 | Playwright MCP |
| playwright | 3.538 | Playwright 自动化 |
| playwright-browser-automation | 3.509 | 浏览器自动化 |
| selenium-browser-skill | 1.729 | Selenium 自动化 |

### 4.2 自动化工作流 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| automation-workflows | **3.699** | 自动化工作流 | 工作流编排 |
| automation-workflows-0-1-0 | **3.566** | 自动化工作流 v0.1.0 | 工作流编排 |
| windows-ui-automation | **3.536** | Windows UI 自动化 | 桌面自动化 |
| x-post-automation | **3.527** | Twitter 自动化 | 社交媒体 |
| ai-web-automation | **3.515** | AI Web 自动化 | 智能自动化 |
| ai-automation-workflows | **3.503** | AI 自动化工作流 | AI 工作流 |
| google-workspace-automation | **3.242** | Google Workspace 自动化 | 办公自动化 |

### 4.3 Docker 工具 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| docker-essentials | **3.694** | Docker 基础 | 容器入门 |
| docker | **3.577** | Docker 全面技能 | 容器开发 |
| docker-sandbox | **3.548** | Docker 沙箱 | 安全测试 |
| docker-ctl | **3.531** | Docker 控制 | 容器管理 |
| docker-compose | **3.511** | Docker Compose | 编排工具 |

### 4.4 云基础设施 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| aws-infra | **1.215** | AWS 基础设施 | 云服务 |
| infra-as-code | **1.098** | 基础设施即代码 | IaC |
| aws | **1.094** | AWS 全能 | 云服务 |
| azure-infra | **1.089** | Azure 基础设施 | 云服务 |
| gcloud | **1.063** | Google Cloud | 云服务 |

### 4.5 GitHub/CI 工具 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| gh-action-gen | **1.005** | GitHub Action 生成器 | CI/CD |
| github | 3.790 | GitHub 基础操作 | PR/Issue/Workflow |
| openclaw-github-assistant | 3.615 | OpenClaw GitHub 助手 | 增强 GitHub 操作 |
| github-cli | 3.501 | GitHub CLI | 命令行操作 |

### 4.6 开发者工具学习路径

```
入门级:
  1. docker-essentials → Docker 基础
  2. playwright → Web 自动化
  3. automation-workflows → 自动化基础

进阶级:
  1. docker → Docker 全面技能
  2. playwright-browser-automation → 高级自动化
  3. aws-infra → 云基础设施

高级:
  1. infra-as-code → IaC 最佳实践
  2. gh-action-gen → CI/CD 优化
  3. windows-ui-automation → 桌面自动化
```

---

## 📈 五、ClawHub Top 30 Skills 排行榜

基于实时搜索评分 (2026-03-04)

| 排名 | Skill 名称 | 评分 | 类别 |
|------|-----------|------|------|
| 1 | automation-workflows | 3.699 | 自动化 |
| 2 | playwright-scraper-skill | 3.584 | 自动化 |
| 3 | playwright-mcp | 3.581 | 自动化 |
| 4 | playwright | 3.538 | 自动化 |
| 5 | playwright-browser-automation | 3.509 | 自动化 |
| 6 | automation-workflows-0-1-0 | 3.566 | 自动化 |
| 7 | windows-ui-automation | 3.536 | 自动化 |
| 8 | x-post-automation | 3.527 | 社交 |
| 9 | ai-web-automation | 3.515 | 自动化 |
| 10 | ai-automation-workflows | 3.503 | 自动化 |
| 11 | openclaw-godot-skill | 3.497 | 游戏 |
| 12 | godot-dev-guide | 3.442 | 游戏 |
| 13 | e2e-testing-patterns | 3.526 | 测试 |
| 14 | testing-patterns | 3.470 | 测试 |
| 15 | python-executor | 3.480 | Python |
| 16 | python-dataviz | 3.428 | Python |
| 17 | strava-python | 3.334 | Python |
| 18 | python-sdk | 3.333 | Python |
| 19 | lsp-python | 3.289 | Python |
| 20 | afrexai-qa-testing-engine | 3.404 | 测试 |
| 21 | testing-workflow | 3.389 | 测试 |
| 22 | rtfm-testing | 3.388 | 测试 |
| 23 | sql-injection-testing | 3.375 | 安全 |
| 24 | openclaw-unreal-skill | 3.376 | 游戏 |
| 25 | playwright-headless-browser | 3.367 | 自动化 |
| 26 | ai-automation-workflows | 3.503 | 自动化 |
| 27 | python-script-generator | 3.220 | Python |
| 28 | qa-testing-bots | 3.235 | 测试 |
| 29 | docker-essentials | 3.694 | DevOps |
| 30 | python | 3.174 | Python |

---

## 🎯 六、总结与建议

### 6.1 游戏客户端开发

- **推荐 Skills**: game-cog, unity, godot-dev-guide, unreal-engine
- **新增亮点**: Unity AI Workflow 2026 提供完整的 AI 辅助开发工作流

### 6.2 Python 开发

- **推荐 Skills**: fastapi, python, django, async-python-patterns
- **重点**: FastAPI 评分达 1.108，是 Web API 开发首选

### 6.3 游戏客户端自动化测试

- **推荐 Skills**: android-adb, midscene-android-automation, playwright
- **趋势**: AI 驱动测试越来越受欢迎

### 6.4 开发者工具

- **推荐 Skills**: playwright, automation-workflows, docker-essentials
- **热门**: 自动化工作流和浏览器自动化是当前最热门方向

---

## 📚 参考资源

- [ClawHub Skills Registry](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Unity AI Workflow](https://github.com/David-GD13/unity-ai-workflow)
- [OpenClaw Skills](https://github.com/openclaw/openclaw)
