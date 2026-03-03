# Claude Code Skills 调研报告 V7 - 游戏/Python/测试/开发者工具

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub + Antigravity Awesome Skills (970+ Skills) + VoltAgent  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，覆盖以下方向：
1. 游戏客户端开发 (Unity/Godot/Unreal)
2. Python 开发 (FastAPI/异步/测试)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (浏览器自动化/GitHub 自动化)

### 统计概览

| 指标 | 数值 |
|------|------|
| ClawHub Skills 搜索 | 50+ 相关结果 |
| 本周重点分析 | 20+ Skills |
| 分类覆盖 | 4 大类 |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 安装量 |
|------------|------|---------|--------|
| game-engine | github/awesome-copilot | 游戏引擎通用指南 | 2.9K |
| game-development | sickn33/antigravity | 游戏开发编排器 | 929 |
| game-development | davila7/claude-code-templates | Claude Code 游戏模板 | 231 |
| roblox-game-development | greedychipmunk/agent-skills | Roblox 游戏开发 | 176 |
| threejs-game | natea/fitfinder | Three.js 游戏 | 171 |
| game-development | vudovn/antigravity-kit | Antigravity 游戏工具包 | 75 |
| game-developer | 404kidwiz/claude-supercode | Claude 超级代码游戏开发 | 79 |
| game-development | miles990/claude-software | 游戏开发软件技能 | 64 |
| game-engines | pluginagentmarketplace | 游戏引擎插件 | 53 |
| game-engine-resources | gmh5225/awesome-game-security | 游戏安全资源 | 105 |

### 1.2 Unity AI Workflow (2026 新增) 详解

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

**核心特性**:
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

### 🎯 快速开始
```bash
# 1. 创建工作区
mkdir MyGame && cd MyGame

# 2. 复制工具包
git clone https://github.com/David-GD13/unity-ai-workflow.git .

# 3. 通过 Unity Hub 创建 Unity 项目 (如 MyGameUnity/)

# 4. 在终端或 VS Code 中打开工作区
# CLAUDE.md 会自动加载

# 5. 运行 /setup-project
# AI 引导你完成开发模式选择和项目初始化
```
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
| pc-games | PC/主机游戏开发 | 引擎选择、多平台 | PC/主机 |

### 1.4 Unity Developer 核心能力

```markdown
### 现代渲染管线
- URP (Universal Render Pipeline) 优化定制
- HDRP 高保真图形
- Shader Graph 可视化着色器
- 自定义渲染通道

### 性能优化
- Unity Profiler (CPU/GPU/内存分析)
- Frame Debugger 渲染管线调试
- LOD 系统自动生成
- 遮挡剔除和视锥剔除

### C# 游戏编程
- C# 9.0+ 现代特性
- Job System 和 Burst Compiler
- DOTS/ECS 架构
- async/await 替代 Coroutine

### 跨平台部署
- Mobile (iOS/Android) 性能调优
- WebGL 浏览器部署
- Console (PS/Xbox/Switch) 优化
- VR/AR XR Toolkit
```

### 1.5 Godot GDScript Patterns 核心能力

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

### 1.6 Roblox 游戏开发

**Skill**: `greedychipmunk/agent-skills@roblox-game-development` (176 installs)

```markdown
### Roblox Studio 集成
- Luau 脚本开发
- 游戏框架搭建
- 多人游戏同步
- 虚拟货币系统

### 核心能力
- 数据存储 (DataStore)
- 排行榜系统
- 好友和社交
- 虚拟形象
```

### 1.7 Three.js 游戏开发

**Skill**: `natea/fitfinder@threejs-game` (171 installs)

```markdown
### 3D Web 游戏
- Three.js 核心概念
- 场景图和对象
- 材质和光照
- 动画系统
- 物理引擎集成 (Cannon.js/Ammo.js)
```

### 1.8 典型交互示例

```
"Architect a multiplayer game with Unity Netcode and dedicated servers"
"Optimize mobile game performance using URP and LOD systems"
"Create a custom shader with Shader Graph for stylized rendering"
"Implement ECS architecture for high-performance gameplay systems"
"Set up a Roblox multiplayer game with data persistence"
"Create a Three.js game with physics and animations"
```

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 安装量 |
|------------|------|---------|--------|
| python-executor | inference-sh-9/skills | Python 执行器 | 13.1K |
| python-sdk | inference-sh-9/skills | Python SDK | 12.9K |
| python-performance-optimization | wshobson/agents | Python 性能优化 | 7.1K |
| python-testing-patterns | wshobson/agents | pytest 测试策略 | 5.8K |
| async-python-patterns | wshobson/agents | asyncio 异步编程 | 4.6K |
| python-design-patterns | wshobson/agents | Python 设计模式 | 3.5K |
| flask | bobmatnyc/claude-mpm-skills | Flask Web 开发 | 76 |
| celery | bobmatnyc/claude-mpm-skills | Celery 任务队列 | 73 |
| mypy | bobmatnyc/claude-mpm-skills | MyPy 类型检查 | 103 |

### 2.2 Python Executor 核心能力

**项目地址**: [inference-sh-9/skills](https://github.com/inference-sh-9/skills)
**安装量**: 13,100+ (Python 类最高)

```markdown
### 核心功能
- Python 代码执行环境
- 依赖管理
- 虚拟环境支持
- 脚本自动生成

### 使用场景
- 数据分析
- API 调用
- 自动化脚本
- 快速原型开发
```

### 2.3 Python Performance Optimization 核心能力

**安装量**: 7,100+

```markdown
### 性能分析工具
- cProfile: 函数级性能分析
- py-spy: 生产环境性能分析
- line_profiler: 行级性能分析
- memory_profiler: 内存分析

### 优化技术
- 算法优化: 时间复杂度降低
- 缓存策略: LRU/Memcached
- 并行化: multiprocessing/threading
- 异步 I/O: asyncio

### 性能模式
- 批量处理
- 流式处理
- 预计算和物化视图
- 连接池复用
```

### 2.4 Async Python Patterns 核心能力

**安装量**: 4,600+

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
- aiohttp: 异步 HTTP 客户端
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis 异步客户端 (aioredis)
- FastAPI: 异步 Web 框架
```

### 2.5 Python Testing Patterns 核心能力

**安装量**: 5,800+

```markdown
### 测试框架
- pytest: 主流测试框架
- Hypothesis: 属性测试
- pytest-cov: 覆盖率分析
- pytest-asyncio: 异步测试

### 测试策略
- 单元测试: 函数/类级别
- 集成测试: 模块/服务级别
- 端到端测试: 完整流程
- TDD 开发流程

### Mock 和 Fixture
- unittest.mock: 模拟对象
- pytest fixtures: 测试夹具
- Factory patterns: 工厂模式
- Test databases: 测试数据库
```

### 2.6 Python Design Patterns 核心能力

**安装量**: 3,500+

```markdown
### 创建型模式
- Singleton: 单例模式
- Factory: 工厂模式
- Builder: 构建器模式
- Prototype: 原型模式

### 结构型模式
- Adapter: 适配器模式
- Decorator: 装饰器模式
- Proxy: 代理模式
- Facade: 外观模式

### 行为型模式
- Observer: 观察者模式
- Strategy: 策略模式
- Command: 命令模式
- State: 状态模式
```

### 2.7 Flask Skill 核心能力

**Skill**: `bobmatnyc/claude-mpm-skills@flask` (76 installs)

```markdown
### Flask 核心
- 路由和视图函数
- 蓝图 (Blueprints)
- 模板渲染 (Jinja2)
- 表单处理 (WTForms)

### 扩展生态
- Flask-SQLAlchemy: ORM
- Flask-Migrate: 数据库迁移
- Flask-Login: 用户认证
- Flask-RESTful: REST API

### 生产部署
- Gunicorn/uWSGI
- Nginx 配置
- Docker 容器化
- 监控和日志
```

### 2.8 Celery 任务队列

**Skill**: `bobmatnyc/claude-mpm-skills@celery` (73 installs)

```markdown
### 核心概念
- Task: 异步任务定义
- Worker: 任务执行器
- Broker: 消息队列 (Redis/RabbitMQ)
- Backend: 结果存储

### 使用场景
- 后台数据处理
- 定时任务 (Celery Beat)
- 邮件发送
- 图像处理
- API 限流

### 最佳实践
- 任务重试机制
- 任务超时设置
- 任务链和组
- 优先级队列
```

### 2.9 典型交互示例

```
"Help me migrate from pip to uv for package management"
"Design a FastAPI application with proper error handling"
"Set up a modern Python project with ruff, mypy, pytest"
"Implement a high-performance data processing pipeline"
"Create a Flask application with SQLAlchemy ORM"
"Set up Celery for background task processing"
"Optimize this Python code for better performance"
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 安装量 |
|------------|------|---------|--------|
| playwright-cli | microsoft/playwright-cli | Playwright CLI | 3.2K |
| playwright-generate-test | github/awesome-copilot | Playwright 测试生成 | 2.9K |
| playwright-explore-website | github/awesome-copilot | 网站探索自动化 | 2.9K |
| playwright-automation-fill-in-form | github/awesome-copilot | 表单自动化 | 2.9K |
| playwright-best-practices | currents-dev/playwright-best-practices | Playwright 最佳实践 | 2.4K |
| playwright-skill | sickn33/antigravity | Playwright 自动化 | 2.2K |
| e2e-testing-automation | aj-geddes/useful-ai-prompts | E2E 测试自动化 | 146 |
| playwright-testing | chongdashu/phaserjs-oakwoods | Phaser.js Playwright 测试 | 42 |
| test-automation-expert | erichowens/some_claude_skills | 测试自动化专家 | 35 |
| qa-expert | personamanagmentlayer/pcl | QA 专家 | 33 |
| test-automation | vladm3105/aidoc-flow-framework | 测试自动化框架 | 33 |

### 3.2 Playwright CLI 详解

**项目地址**: [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli)
**安装量**: 3,200+ (测试类最高)

```markdown
### 核心功能
- 浏览器自动化
- 测试生成
- 截图和录制
- 性能分析

### CLI 命令
- playwright codegen: 录制脚本
- playwright screenshot: 截图
- playwright pdf: PDF 生成
- playwright install: 安装浏览器

### 快速开始
```bash
# 安装
npm install -g @playwright/cli

# 录制测试
playwright codegen

# 生成测试
playwright generate-tests

# 截图
playwright screenshot https://example.com screenshot.png
```
```

### 3.3 Playwright Best Practices

**Skill**: `currents-dev/playwright-best-practices-skill@playwright-best-practices` (2,400 installs)

```markdown
### 测试架构
- Page Object Model (POM)
- 测试分组和标记
- 并行执行
- 测试隔离

### 等待策略
- 智能等待 (waitForSelector)
- 网络请求等待
- 条件等待
- 避免硬等待

### 断言最佳实践
- 软断言 (soft assertions)
- 截图对比
- 性能断言
- 可访问性断言

### CI/CD 集成
- GitHub Actions
- GitLab CI
- Jenkins
- Docker 容器
```

### 3.4 Playwright Skill (Antigravity)

**Skill**: `sickn33/antigravity-awesome-skills@playwright-skill` (2,200 installs)

```markdown
### 功能
- Model-invoked: Claude 自主编写和执行自定义自动化
- 测试和验证的浏览器自动化
- 跨浏览器测试支持

### 快速开始
# 首次安装
cd $SKILL_DIR && npm run setup

# 检测开发服务器
cd $SKILL_DIR && node -e "require('./lib/helpers').detectDevServers().then(s => console.log(JSON.stringify(s)))"

# 执行测试
cd $SKILL_DIR && node run.js /tmp/playwright-test-*.js
```

### 3.5 E2E Testing Automation

**Skill**: `aj-geddes/useful-ai-prompts@e2e-testing-automation` (146 installs)

```markdown
### 测试类型
- 端到端测试
- 用户流测试
- 回归测试
- 可用性测试

### 自动化策略
- AI 生成测试用例
- 自动修复失败测试
- 视觉回归测试
- 性能监控
```

### 3.6 游戏客户端测试专题

#### Unity Test Framework

```markdown
### 测试类型
- Edit Mode: 纯 C# 逻辑测试，无需运行游戏
- Play Mode: 集成测试，运行游戏场景

### 核心组件
- TestRunner: 测试运行器
- NUnit: 测试框架
- UnityTestAttribute: 协程测试
- UnityWebRequest: 网络测试

### 示例测试
[UnityTest]
public IEnumerator PlayerMove_Test()
{
    var player = new GameObject("Player");
    var mover = player.AddComponent<PlayerMover>();
    
    mover.Move(Vector2.right);
    
    yield return null; // 等待一帧
    
    Assert.AreEqual(Vector2.right, mover.Velocity);
}
```

#### 网络同步测试

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

#### 性能基准测试

```markdown
### 帧率测试
- 目标: 60 FPS (16.67ms/帧)
- 最低: 30 FPS (33.33ms/帧)
- 测量工具: Unity Profiler, UnityFrameTimingManager

### 内存测试
- 堆内存监控
- 资源泄漏检测
- GC 频率分析

### 加载时间测试
- 场景切换时间
- 资源预加载
- 热更新验证
```

### 3.7 移动端游戏测试

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

### 3.8 典型交互示例

```
"测试这个登录流程"
"检查响应式设计"
"验证表单提交"
"Generate tests for this website"
"Set up Playwright with CI/CD"
"Run E2E tests on multiple browsers"
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 安装量 |
|------------|------|---------|--------|
| docker-expert | sickn33/antigravity | Docker 专家 | 4.7K |
| github-actions-expert | cin12211/orca-q | GitHub Actions 专家 | 83 |
| github-automation | sickn33/antigravity | GitHub 自动化 | 60 |
| github-workflow-automation | ruvnet/claude-flow | GitHub 工作流自动化 | 44 |
| devops-expert | personamanagmentlayer/pcl | DevOps 专家 | 38 |
| github-workflow-automation | proffesor-for-testing/agentic-qe | GitHub 工作流自动化 | 28 |
| github-automation | davepoon/buildwithclaude | GitHub 自动化 | 17 |

### 4.2 Docker Expert 核心能力

**Skill**: `sickn33/antigravity-awesome-skills@docker-expert` (4,700 installs - 最高!)

```markdown
### Docker 基础
- 镜像构建 (Dockerfile)
- 容器运行和管理
- 网络和存储
- 多阶段构建

### 最佳实践
- 镜像优化 (层缓存、压缩)
- 安全最佳实践
- 健康检查
- 日志管理

### Docker Compose
- 多服务编排
- 开发环境设置
- 测试环境隔离

### 生态集成
- Kubernetes
- Docker Swarm
- AWS ECS
- GCP Cloud Run
```

### 4.3 GitHub Actions Expert

**Skill**: `cin12211/orca-q@github-actions-expert` (83 installs)

```markdown
### 工作流配置
- 触发条件 (push, PR, schedule)
- Matrix 构建策略
- 依赖缓存
- Artifacts 管理

### 自动化
- 自动代码审查
- Issue 自动化
- 发布管理
- 安全扫描集成

### 高级特性
- 自定义 Actions
- Reusable workflows
- 条件执行
- 秘密管理
```

### 4.4 GitHub Automation 核心能力

```markdown
### 仓库管理
- 创建/删除仓库
- 分支保护规则
- 团队和权限管理

### Issue 管理
- 创建/关闭/编辑
- 标签管理
- 指派和里程碑

### Pull Request
- 创建和审查
- 自动合并
- 冲突解决
- CI 状态检查
```

### 4.5 DevOps Expert

**Skill**: `personamanagmentlayer/pcl@devops-expert` (38 installs)

```markdown
### CI/CD 流水线
- Jenkins 配置
- GitLab CI
- GitHub Actions
- ArgoCD

### 基础设施即代码
- Terraform
- Ansible
- CloudFormation

### 监控和日志
- Prometheus + Grafana
- ELK Stack
- Jaeger 追踪
```

### 4.6 典型交互示例

```
"Create a new issue for the bug"
"Automatically label new PRs"
"Run tests on PR and report results"
"Set up branch protection rules"
"Deploy with Docker Compose"
"Configure GitHub Actions workflow"
```

---

## 📈 五、综合对比分析

### 5.1 游戏开发 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| game-engine (awesome-copilot) | 通用游戏引擎指南 | 2.9K 热门 |
| game-development (antigravity) | 游戏开发编排器 | 929 安装 |
| unity-developer | Unity 6 全面指南 | Unity 项目开发 |
| unity-ai-workflow | 2026 AI 工作流 | 快速原型/协作 |
| godot-gdscript-patterns | Godot 4 最佳实践 | 开源/轻量游戏 |
| roblox-game-development | Roblox 开发 | 176 安装 |
| threejs-game | Three.js 游戏 | 171 安装 |
| unreal-engine-cpp-pro | UE5 C++ 开发 | AAA 级游戏 |

### 5.2 Python 开发 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| python-executor | Python 执行器 | 13.1K 最高 |
| python-sdk | Python SDK | 12.9K |
| python-performance-optimization | 性能优化 | 7.1K |
| python-testing-patterns | pytest 最佳实践 | 5.8K |
| async-python-patterns | 异步编程 | 4.6K |
| python-design-patterns | 设计模式 | 3.5K |
| flask | Flask Web 开发 | 76 |
| celery | Celery 任务队列 | 73 |

### 5.3 测试 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| playwright-cli | 官方 CLI | 3.2K 热门 |
| playwright-best-practices | 最佳实践 | 2.4K |
| playwright-skill (antigravity) | 浏览器自动化 | 2.2K |
| e2e-testing-automation | E2E 测试 | 146 |
| test-automation-expert | 测试专家 | 35 |
| qa-expert | QA 专家 | 33 |

### 5.4 开发者工具 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| docker-expert | Docker 专家 | 4.7K 最高 |
| github-actions-expert | GitHub Actions | 83 |
| github-automation | GitHub 自动化 | 60 |
| github-workflow-automation | 工作流自动化 | 44 |
| devops-expert | DevOps 专家 | 38 |

---

## ✅ 六、落地过程

### 6.1 快速开始

```bash
# 安装 Skills
npx skills add sickn33/antigravity-awesome-skills@unity-developer
npx skills add sickn33/antigravity-awesome-skills@game-development
npx skills add wshobson/agents@python-performance-optimization
npx skills add wshobson/agents@python-testing-patterns
npx skills add wshobson/agents@async-python-patterns
npx skills add microsoft/playwright-cli@playwright-cli
npx skills add currents-dev/playwright-best-practices-skill@playwright-best-practices

# 游戏开发
>> /unity-developer 帮助我设计一个多人游戏架构
>> /godot-gdscript-patterns 创建状态机系统

# Python 开发
>> /python-performance-optimization 优化这段代码
>> /python-testing-patterns 编写单元测试
>> /async-python-patterns 实现异步处理

# 测试
>> /playwright-cli 生成测试脚本
>> /playwright-best-practices 设置测试框架

# 开发者工具
>> /docker-expert 创建 Dockerfile
>> /github-actions-expert 配置 CI/CD
```

### 6.2 推荐学习路径

```
游戏开发:
1. 基础: game-engine (通用原理)
2. 引擎选择:
   - Unity → unity-developer → unity-ecs-patterns
   - Godot → godot-gdscript-patterns
   - Unreal → unreal-engine-cpp-pro
   - Roblox → roblox-game-development
   - Web → threejs-game
3. 进阶: 性能优化 → 跨平台部署

Python 开发:
1. 基础: python-design-patterns (设计原则)
2. 工具: python-executor (执行环境)
3. 性能: python-performance-optimization (性能优化)
4. 测试: python-testing-patterns (质量保证)
5. 进阶: async-python-patterns (高并发)
6. Web: flask (Web 开发)
7. 异步任务: celery (任务队列)

测试:
1. 基础: playwright-cli (工具掌握)
2. 最佳实践: playwright-best-practices
3. E2E: e2e-testing-automation
4. 游戏测试: playwright-testing (Phaser.js)
5. 流程: test-driven-development

开发者工具:
1. 容器化: docker-expert
2. CI/CD: github-actions-expert
3. 自动化: github-automation
4. DevOps: devops-expert
```

### 6.3 项目实践

对于 game-frame-sync 项目：
- 使用 `unity-developer` 优化帧同步网络同步
- 使用 `python-executor` / `python-sdk` 搭建 Python 后端
- 使用 `python-fastapi-development` 开发 API
- 使用 `python-testing-patterns` 编写同步逻辑测试
- 使用 `playwright-best-practices` 测试 Web 管理后台
- 使用 `github-actions-expert` 设置 CI/CD
- 使用 `docker-expert` 容器化部署

---

## 📚 七、相关资源

### ClawHub Skills

| 技能 | 安装量 | 描述 |
|------|--------|------|
| python-executor | 13.1K | Python 执行器 |
| python-sdk | 12.9K | Python SDK |
| playwright-cli | 3.2K | Playwright CLI |
| playwright-generate-test | 2.9K | 测试生成 |
| docker-expert | 4.7K | Docker 专家 |
| python-performance-optimization | 7.1K | 性能优化 |
| python-testing-patterns | 5.8K | 测试模式 |
| async-python-patterns | 4.6K | 异步编程 |

### GitHub 热门仓库

| 仓库 | Stars | 描述 |
|------|-------|------|
| everything-claude-code | 58,717⭐ | Agent 性能优化系统 |
| awesome-claude-code | 26,048⭐ | Skills 精选列表 |
| antigravity-awesome-skills | 18,542⭐ | 900+ Skills 集合 |
| planning-with-files | 15,118⭐ | Markdown 规划 |

### 官方文档

- [ClawHub Skills](https://skills.sh/)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Microsoft Playwright CLI](https://github.com/microsoft/playwright-cli)
- [Unity 官方文档](https://docs.unity.com/)
- [Python 官方文档](https://docs.python.org/3/)
- [FastAPI 文档](https://fastapi.tiangolo.com/)
- [Playwright 文档](https://playwright.dev/)

---

## 📅 更新日志

### 2026-03-04 (V7)
- 新增 Roblox 游戏开发 Skills (176 安装)
- 新增 Three.js 游戏开发 Skills (171 安装)
- 新增 Python Executor (13.1K 安装) - Python 类最高
- 新增 Python SDK (12.9K 安装)
- 新增 Python 性能优化 Skills (7.1K 安装)
- 新增 Python 测试模式 Skills (5.8K 安装)
- 新增异步 Python Skills (4.6K 安装)
- 新增 Playwright CLI (3.2K 安装) - 测试类最高
- 新增 Docker Expert (4.7K 安装) - 开发者工具最高
- 新增 GitHub Actions Expert (83 安装)
- 新增 DevOps Expert (38 安装)
- 新增 Flask Skills (76 安装)
- 新增 Celery Skills (73 安装)
- 更新 Antigravity 游戏开发 Skills 矩阵

---

**调研完成**: 2026-03-04
