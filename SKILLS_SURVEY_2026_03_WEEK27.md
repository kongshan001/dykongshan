# Claude Code Skills 完整调研报告 - 2026年3月 (第二十七周)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub 实时搜索 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研继续聚焦 Claude Code 热门 Skills，基于 GitHub 热门项目搜索和 ClawHub 实时排行，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/Love2D)
2. **Python 开发** (FastAPI/异步/类型安全)
3. **游戏客户端自动化测试** (移动端/UI 自动化)
4. **开发者工具** (浏览器自动化/GitHub 自动化/Docker)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| game-cog | **1.132** | 游戏开发编排器，DeepResearch Bench 第一名 | 通用游戏开发 |
| game-developer-skill | **0.975** | Claude 游戏开发者 | AI 辅助开发 |
| fivem-dev | **0.958** | Fivem 开发 | GTA5 Mod 开发 |
| blender | **0.925** | Blender 3D 建模 | 3D 资产制作 |
| game-engine | **0.920** | 游戏引擎架构 | 引擎原理 |
| unity | **0.961** | Unity 最佳实践 | Unity 开发 |
| unreal-engine | **0.935** | Unreal Engine 开发 | UE 开发 |
| godot-dev-guide | **0.983** | Godot 4.x 完整开发指南 | Godot 开发 |

### 1.2 2026年3月新增/更新游戏开发 Skills

#### 1.2.1 Claude Code Game Studios

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)  
**GitHub Stars**: 28⭐ (2026年2月新增)

```markdown
## 核心特性
- 48 个 AI agents，专门针对游戏开发
- 36 个 workflow skills，覆盖完整游戏开发流程
- 完整的协调系统，模拟真实游戏工作室层级结构
- 支持 Unity/Unreal/Godot 多引擎

## Agent 类型
- 游戏设计师 Agent
- 程序员 Agent (客户端/服务器)
- 美术/动画 Agent
- 音效 Agent
- QA 测试 Agent
- 项目管理 Agent
```

#### 1.2.2 Unity AI Workflow 2026

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)  
**GitHub Stars**: 4⭐ (2026年3月新增)

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

#### 1.2.3 Unity Developer (评分 0.945-1.013)

```markdown
### 核心功能
- Unity 6 LTS 支持
- URP/HDRP 渲染管线
- DOTS/ECS 架构
- Netcode 网络同步

### 适用场景
- 3D 游戏开发
- 移动端游戏
- VR/AR 应用
- 多人游戏
```

#### 1.2.4 Godot GDScript Patterns

```markdown
### Godot 4 特性
- GDScript 2.0 语法
- 节点系统最佳实践
- 信号机制
- 资源管理

### 适用项目
- 2D/3D 游戏
- 独立游戏
- 跨平台发布
```

### 1.3 Antigravity 游戏开发 Skills 完整列表

```json
[
  {"id": "game-development", "description": "游戏开发编排器，根据项目需求路由到平台特定 Skills"},
  {"id": "2d-games", "description": "2D 游戏开发原理：精灵、瓦片地图、物理、相机"},
  {"id": "3d-games", "description": "3D 游戏开发原理：渲染、着色器、物理、相机"},
  {"id": "mobile-games", "description": "移动端游戏开发：触控输入、电池、性能、应用商店"},
  {"id": "pc-games", "description": "PC 和主机游戏开发：引擎选择、平台特性、优化策略"},
  {"id": "web-games", "description": "网页游戏开发：框架选择、WebGPU、优化、PWA"},
  {"id": "game-design", "description": "游戏设计原理：GDD 结构、平衡、玩家心理学、进度系统"},
  {"id": "game-art", "description": "游戏美术原理：视觉风格选择、资产管线、动画工作流"},
  {"id": "game-audio", "description": "游戏音频原理：音效设计、音乐集成、自适应音频系统"}
]
```

### 1.4 游戏客户端开发 Skills 详细分类

#### 1.4.1 Unity Skills

| Skill | 核心能力 | 评分 |
|-------|---------|------|
| unity-developer | Unity 6 LTS 专家，URP/HDRP，Profiler，DOTS/ECS | 0.945-1.013 |
| unity-ai-workflow-2026 | AI 驱动开发，三种模式 | 2026 新增 |
| unity-ecs-patterns | Unity DOTS/ECS 架构，性能优化 | - |
| unity-netcode | Unity Netcode 多人游戏 | - |
| unity-shader-graph | Shader Graph 可视化着色器 | - |

#### 1.4.2 Godot Skills

| Skill | 核心能力 | 评分 |
|-------|---------|------|
| godot-gdscript-patterns | Godot 4 GDScript 2.0 最佳实践 | - |
| godot-4-dev | Godot 4 完整开发指南 | 0.983 |
| godot-state-machine | Godot 状态机模式 | - |

#### 1.4.3 Unreal Skills

| Skill | 核心能力 |
|-------|---------|
| unreal-engine-cpp-pro | Unreal 5.x C++ 开发 |
| unreal-blueprint-visual | Blueprint 可视化编程 |
| unreal-slate-ui | Slate UI 框架开发 |

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Python Skills 列表

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| python-pro | Python 3.12+ 现代特性，uv/ruff | 通用 Python 开发 |
| python-patterns | 框架选择、类型提示、项目结构 | 架构设计 |
| python-fastapi-development | FastAPI 后端开发 | API 服务 |
| async-python-patterns | asyncio 异步编程 | 高并发 |
| python-testing-patterns | pytest 测试策略 | 质量保证 |
| python-performance-optimization | 性能分析和优化 | 性能调优 |
| temporal-python-pro | Temporal 工作流编排 | 分布式事务 |
| dbos-python | DBOS 可靠工作流 | 持久化工作流 |
| uv-global | uv 包管理器 | 快速包管理 |

### 2.2 Python Skills 详细解析

#### 2.2.1 FastAPI (评分: 1.054-1.121)

```markdown
### 核心特性
- 高性能: 与 Node.js 和 Go 相当
- 自动文档: Swagger UI/ReDoc
- 类型安全: Pydantic 集成
- 异步支持: async/await

### 适用场景
- REST API 开发
- 微服务
- 实时应用 (WebSocket)
- 数据处理管道
```

#### 2.2.2 Python Pro

```markdown
### 现代 Python 特性
- Python 3.12+ 改进的错误消息
- 模式匹配 (match statement)
- 高级类型提示和泛型
- Descriptors 和元类

### 现代工具链
- uv: 2024 最快包管理器
- ruff: 替代 black/isort/flake8
- mypy/pyright: 类型检查
- pyproject.toml: 现代标准
```

#### 2.2.3 Async Python Patterns

```markdown
### asyncio 基础
- async/await 语法
- Event loop 管理
- Task 和 Future
- 取消和超时

### 高级模式
- 并发任务管理
- 异步生成器
- 异步上下文管理器
- 错误处理

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
```

#### 2.2.4 Temporal Python Pro

```markdown
### 核心能力
- 持久化工作流
- Saga 模式
- 分布式事务
- 活动重试和超时

### 测试策略
- 时间跳过测试
- Mock 策略
- Replay 测试
```

#### 2.2.5 DBOS Python (2026 新增)

**项目地址**: [DBOS-dev/dbos-python](https://github.com/DBOS-dev/dbos-python)

```markdown
### 核心特性
- 可靠、耐错应用构建
- 持久化工作流
- 队列支持
- 事务追踪

### 适用场景
- 微服务开发
- 分布式系统
- 事件驱动架构
```

### 2.3 uv - 最快 Python 包管理器 (评分: 1.092)

```markdown
### 核心优势
- 比 pip 快 10-100 倍
- 磁盘空间占用少
- 依赖解析优化
- 虚拟环境管理

### 安装使用
curl -LsSf https://astral.sh/uv/install.sh | sh
uv pip install fastapi
uv venv && source .venv/bin/activate
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 测试 Skills 核心列表

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| test-automator | - | AI 驱动测试自动化 | 智能测试生成 |
| e2e-testing-patterns | - | Playwright/Cypress E2E | 端到端测试 |
| playwright-skill | 3.538-3.584 | Playwright 浏览器自动化 | 测试/爬虫 |
| playwright-mcp | 3.581 | Playwright MCP 服务器 | 自动化服务器 |
| python-testing-patterns | - | pytest 最佳实践 | Python 测试 |
| test-driven-development | - | TDD 开发流程 | 测试先行 |
| testing-qa | - | 综合 QA 工作流 | 质量保证 |
| azure-playwright-testing-ts | - | Azure Playwright 云测试 | 大规模测试 |
| android-adb | 1.220 | Android ADB 测试 | 移动端测试 TOP 1 |
| test-runner | 1.189 | 测试运行器 | - |
| test-master | 1.158 | 测试管理 | - |

### 3.2 Playwright 专题

#### 3.2.1 Playwright Skill 核心功能

```markdown
### 自动化能力
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 默认使用可见浏览器
- URL 参数化配置

### 常见模式
- 页面测试 (多视口)
- 登录流程测试
- 表单填写和提交
- 链接检查
- 响应式设计测试
```

#### 3.2.2 Playwright MCP (评分: 3.581)

```markdown
### 核心能力
- MCP 服务器形式的 Playwright
- 标准化协议支持
- 易于集成

### 适用场景
- Claude Code 集成
- 自动化工作流
- 复杂测试场景
```

#### 3.2.3 Azure Playwright Testing (2026 新增)

```markdown
### 核心能力
- 云端托管浏览器大规模测试
- CI/CD 流水线集成
- 跨浏览器测试
- 视觉回归测试

### 适用场景
- 企业级 Web 应用测试
- 大规模测试套件
- 持续集成质量门禁
```

### 3.3 游戏客户端测试专题

#### 3.3.1 Unity Test Framework

```markdown
### 测试类型
- Edit Mode: 纯 C# 逻辑测试，无需运行游戏
- Play Mode: 集成测试，运行游戏场景

### 核心组件
- TestRunner: 测试运行器
- NUnit: 测试框架
- UnityTestAttribute: 协程测试

### 示例测试
[UnityTest]
public IEnumerator PlayerMove_Test()
{
    var player = new GameObject("Player");
    var mover = player.AddComponent<PlayerMover>();
    
    mover.Move(Vector2.right);
    yield return null;
    
    Assert.AreEqual(Vector2.right, mover.Velocity);
}
```

#### 3.3.2 网络同步测试

```markdown
### 帧同步测试
- 确定性验证: 相同输入 → 相同输出
- 断线重连测试
- 录像回放验证

### 状态同步测试
- 状态一致性验证
- 增量同步效率
- 预测回滚测试

### 延迟模拟
- 网络抖动 (Jitter): 0-200ms 随机延迟
- 丢包模拟: 5%-20% 丢包率
- 高延迟环境: 200-500ms RTT
```

#### 3.3.3 移动端游戏测试

```markdown
### Android UI 自动化测试
- ADB 命令基础
- uiautomator dump UI 检查
- 触摸事件模拟
- 截图验证

### iOS 自动化测试
- XCUITest 框架
- Instruments 性能分析
- 设备兼容性测试

### 游戏特定测试
- 触控响应延迟
- 陀螺仪/重力感应
- 内存/电量消耗
- 网络切换 (WiFi → 4G)
```

### 3.4 Android ADB Skill (评分: 1.220, 测试类 TOP 1)

```markdown
### 核心能力
- ADB 命令执行
- 设备管理
- 日志查看
- 应用安装/卸载
- 屏幕截图/录制

### 常用命令
adb devices
adb shell uiautomator dump
adb install app.apk
adb logcat
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 开发者工具核心 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| github | **3.790** | GitHub 基础操作 | PR/Issue/Workflow |
| openclaw-github-assistant | **3.615** | OpenClaw GitHub 助手 | 增强操作 |
| github-cli | **3.501** | GitHub CLI | 命令行操作 |
| docker-essentials | **3.694** | Docker 基础 | 容器化 TOP 1 |
| docker | **3.577** | Docker 完整版 | 容器管理 |
| docker-sandbox | **3.548** | Docker 沙箱 | 安全测试 |
| docker-ctl | **3.531** | Docker 控制 | 容器控制 |
| docker-compose | **3.511** | Docker Compose | 多容器编排 |
| docker-diag | **3.474** | Docker 诊断 | 问题排查 |
| git-essentials | **1.298** | Git 基础 | 版本控制 TOP 1 |
| agent-browser | **3.772** | 浏览器自动化 | 自动化 |
| automation-workflows | **3.699** | 工作流自动化 | 效率 |

### 4.2 GitHub 自动化专题

#### 4.2.1 GitHub Skill (评分: 3.790, 全类别 TOP 1)

```markdown
### 核心能力
- 仓库管理
- Issue 管理
- Pull Request 操作
- Actions 工作流

### 典型交互
"Create a new issue for the bug"
"Automatically label new PRs"
"Run tests on PR and report results"
```

#### 4.2.2 GitHub Workflow Automation

```markdown
### 工作流设计
- 触发条件配置
- Matrix 构建
- 依赖缓存
- Artifacts

### 自动化
- PR 自动审查
- Issue 分类
- 自动标签
- 发布管理
```

### 4.3 Docker 专题

#### 4.3.1 Docker Essentials (评分: 3.694, DevOps TOP 1)

```markdown
### 核心能力
- Dockerfile 最佳实践
- 镜像构建优化
- 多阶段构建
- 容器网络配置
- 安全加固
```

#### 4.3.2 Docker CTL (评分: 3.531)

```markdown
### 核心能力
- 容器生命周期管理
- 镜像操作
- 网络和存储管理
- 日志查看
```

### 4.4 Git 专题

#### 4.4.1 Git Essentials (评分: 1.298, 版本控制 TOP 1)

```markdown
### 核心功能
- 仓库初始化和克隆
- 分支管理
- 提交和回滚
- 合并和冲突解决

### 高级功能
- Rebase 工作流
- 子模块管理
- Git Hooks
```

### 4.5 CI/CD 专题

#### 4.5.1 CI/CD Automation Workflow

```markdown
### 流水线阶段
1. 源码检出
2. 依赖安装
3. 代码构建
4. 测试执行
5. 部署发布

### 最佳实践
- 幂等性
- 快速失败
- 日志清晰
- 制品管理
```

#### 4.5.2 GitOps Workflow

```markdown
### 核心工具
- ArgoCD
- Flux

### 特性
- 声明式 Kubernetes 部署
- 持续协调
- Git 作为单一真相来源
```

---

## 📈 五、Skills 缺口与建议

### 5.1 现有 Skills 覆盖情况

| 方向 | 覆盖程度 | 主要 Skills |
|------|---------|------------|
| 游戏客户端开发 | ⭐⭐⭐⭐⭐ | Unity/Godot/Unreal 全覆盖 |
| Python 开发 | ⭐⭐⭐⭐⭐ | FastAPI/Async/测试全覆盖 |
| 游戏客户端测试 | ⭐⭐⭐ | Unity Test Framework/移动端测试 |
| 开发者工具 | ⭐⭐⭐⭐⭐ | GitHub/Docker/CI/CD 全覆盖 |

### 5.2 Skills 缺口

1. **游戏客户端自动化测试**
   - 缺口：专门的 Unity/Unreal 自动化测试 Skills 较少
   - 建议：可自建 Unity Test Framework + Playwright 集成 Skill

2. **帧同步测试**
   - 缺口：确定性测试、录像回放测试缺乏专业指导
   - 建议：可基于项目需求开发专门的测试 Skill

3. **游戏性能基准测试**
   - 缺口：帧率、内存、加载时间测试缺乏统一方案
   - 建议：可整合 Unity Profiler 相关工具

### 5.3 建议自建的 Skills

1. **game-frame-sync-tester**: 帧同步确定性测试
2. **unity-performance-benchmark**: Unity 性能基准测试
3. **godot-4-advanced**: Godot 4 高级开发技巧

---

## 📎 附录

### A. ClawHub Top 30 Skills (2026年3月)

| 排名 | Skill | 评分 | 类别 |
|------|-------|------|------|
| 1 | github | 3.790 | 开发者工具 |
| 2 | agent-browser | 3.772 | 开发者工具 |
| 3 | automation-workflows | 3.699 | 开发者工具 |
| 4 | docker-essentials | 3.694 | DevOps |
| 5 | docker | 3.577 | DevOps |
| 6 | playwright-scraper-skill | 3.584 | 测试 |
| 7 | playwright-mcp | 3.581 | 测试 |
| 8 | docker-sandbox | 3.548 | DevOps |
| 9 | playwright | 3.538 | 测试 |
| 10 | docker-ctl | 3.531 | DevOps |

### B. 各类别 TOP 1 Skills

| 类别 | Skill | 评分 |
|------|-------|------|
| 游戏开发 | game-cog | 1.132 |
| Python 开发 | fastapi | 1.121 |
| 测试 | android-adb | 1.220 |
| 开发者工具 | github | 3.790 |
| DevOps | docker-essentials | 3.694 |
| 版本控制 | git-essentials | 1.298 |

### C. Antigravity Skills 分类统计

| 分类 | Skills 数量 |
|------|------------|
| 游戏开发 | 50+ |
| Python 开发 | 30+ |
| 测试自动化 | 40+ |
| 开发者工具 | 60+ |

---

## 📝 本周更新亮点

### 新增 Skills

1. **Claude Code Game Studios** - 48 个 AI agents 的游戏开发工作室
2. **Unity AI Workflow 2026** - 专为 AI 助手设计的 Unity 开发工作流
3. **DBOS Python** - 可靠工作流的新选择

### 评分更新

- GitHub Skill 稳居全类别 TOP 1 (3.790)
- Docker Essentials 获得 DevOps TOP 1 (3.694)
- Playwright 系列 Skills 评分稳定 (3.538-3.584)

### 趋势分析

1. **AI 原生开发工具** 越来越受欢迎
2. **游戏开发** 方向的 Skills 评分较高 (game-cog: 1.132)
3. **开发者工具** 类别竞争激烈，多个 Skills 超过 3.5 分

---

*文档更新于 2026-03-04*
