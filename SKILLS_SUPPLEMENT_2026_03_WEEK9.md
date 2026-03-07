# Claude Code Skills 调研补充 - 2026年3月（第九周）

> 游戏客户端开发、Python 开发、自动化测试、开发者工具

## 📋 文档信息

- **调研日期**: 2026-03-04
- **Skill 来源**: Antigravity Awesome Skills (968+ Skills) + 社区精选
- **目标仓库**: https://github.com/kongshan001/cc_skills
- **状态**: ✅ 调研完成

---

## 一、游戏客户端开发 Skills 深度探索

### 1.1 Unity AI Workflow 2026 专题

> 2026 年新推出的 Unity + Claude Code 集成工作流

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

### 📋 项目阶段
1. 00: Ideation — 从想法到 GDD + GFD
2. 01: Pre-Production — 技术选型、栈定义、命名规范
3. 02: Technical Design — 架构、程序集定义、模式
4. 03: Project Setup — 自动文件夹脚手架和包安装
5. 04: Production — 特性循环 (interrogate → implement → feel → commit)
6. 05: Polish — 最终调优、视觉细化、性能分析
```

### 1.2 主流游戏引擎 Skills 补充列表

| Skill ID | 名称 | 描述 | 评分 |
|---------|------|------|------|
| 901 | unity-developer | Unity 6 LTS、URP/HDRP、C# 优化、跨平台部署 | ⭐⭐⭐⭐⭐ |
| 902 | unity-ecs-patterns | DOTS、Jobs System、Burst Compiler | ⭐⭐⭐⭐⭐ |
| 903 | unreal-engine-cpp-pro | Unreal 5.x C++、UObject、性能模式 | ⭐⭐⭐⭐⭐ |
| 494 | godot-gdscript-patterns | Godot 4、GDScript 2.0、信号、状态机 | ⭐⭐⭐⭐ |
| 493 | godot-4-migration | Godot 3→4 迁移指南 | ⭐⭐⭐ |
| 950 | bevy-ecs-expert | Bevy ECS (Rust)、系统、查询、资源、并行调度 | ⭐⭐⭐⭐⭐ |
| 472 | game-dev-orchestrator | 游戏开发协调：根据项目需求路由到特定平台 Skills | ⭐⭐⭐⭐ |

### 1.3 Unity Developer 深度解析

```markdown
### 🎮 核心能力
- Unity 6 LTS 最佳实践与长期支持
- URP/HDRP 渲染管线优化
- C# 9.0+ 现代语言特性
- 跨平台部署 (iOS/Android/WebGL/Console/PC)

### ⚡ 性能优化
- Unity Profiler CPU/GPU/内存分析
- 帧调试器 (Frame Debugger)
- 内存Profiler 分析堆和原生内存
- 物理优化和碰撞检测效率

### 🏗️ 架构模式
- ECS/DOTS 架构实现
- MVC 模式用于 UI 和游戏逻辑
- 观察者模式解耦系统通信
- 状态机管理角色和游戏状态
- 对象池性能优化场景
- Addressables 动态内容加载
```

### 1.4 Unity ECS Patterns 深度解析

```markdown
### Entity Component System
- Entities: 游戏对象数据表示
- Components: 数据组件 (无逻辑)
- Systems: 逻辑系统 (无数据)

### Jobs System
- 多线程并行处理
- Burst Compiler 编译优化
- 内存布局优化 (Data-oriented)

### 适用场景
- 大规模对象处理 (1000+ 敌人)
- 粒子系统优化
- 物理计算优化
- AI 计算优化
- RTS 单位管理
```

### 1.5 Unreal Engine C++ Pro 深度解析

```markdown
### C++ 开发
- UObject 规范和内存管理
- 智能指针和垃圾回收
- 属性系统 (UPROPERTY)
- 模块化架构

### 高级系统
- Slate UI 框架
- UMG 动画系统
- 网络复制和 RPC
- 性能分析工具

### 渲染管线
- 光照和阴影优化
- 材质和着色器
- 后处理效果
- Lumen 和 Nanite (UE5)
```

### 1.6 Godot GDScript Patterns 深度解析

```markdown
### GDScript 2.0 特性
- 类型提示
- @export 装饰器
- await/async 语法
- 信号系统

### 节点系统
- 场景树结构
- 节点引用和组
- 资源复用

### 最佳实践
- 信号解耦
- 状态机模式
- 对象池技术
- 着色器优化
```

### 1.7 Bevy ECS Expert (Rust 游戏引擎)

```markdown
### ECS 架构
- Components: 数据结构
- Systems: 逻辑函数
- Resources: 全局数据

### 核心概念
- Query: 数据查询
- Commands: 命令队列
- Events: 事件系统

### 并行执行
- 系统调度
- 线程安全
- 缓存优化
```

### 1.8 Game Development 编排器

```markdown
### 子技能路由

| 游戏类型 | 子技能 |
|---------|--------|
| Web 游戏 | game-development/web-games |
| 移动游戏 | game-development/mobile-games |
| PC 游戏 | game-development/pc-games |
| VR/AR | game-development/vr-ar |

| 维度 | 子技能 |
|------|--------|
| 2D 游戏 | game-development/2d-games |
| 3D 游戏 | game-development/3d-games |

| 专业领域 | 子技能 |
|---------|--------|
| 游戏设计 | game-development/game-design |
| 多人游戏 | game-development/multiplayer |
| 游戏美术 | game-development/game-art |
| 游戏音频 | game-development/game-audio |
```

### 1.9 通用游戏开发 Skills

| Skill ID | 名称 | 描述 |
|---------|------|------|
| 2 | 2d-games | 2D 游戏开发原理：精灵、瓦片地图、物理、相机 |
| 3 | 3d-games | 3D 游戏开发原理：渲染、着色器、物理 |
| 469 | game-art | 游戏美术原理：视觉风格、资产管线、动画流程 |
| 470 | game-audio | 游戏音频：音效设计、音乐集成、动态音频 |
| 471 | game-design | 游戏设计：GDD 结构、平衡性、玩家心理 |
| 623 | mobile-game | 移动游戏开发：触控输入、电池优化、性能 |
| 635 | multiplayer-game | 多人游戏开发：架构、网络、同步 |
| 678 | pc-console-game | PC/主机游戏开发：引擎选择、平台特性、优化 |
| 804 | glsl-shaders | GLSL 着色器：Vertex/Fragment 着色、通用效果 |

---

## 二、Python 开发 Skills 深度探索

### 2.1 核心 Python Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 727 | python-pro | Python 3.12+、现代特性、生产级实践 | ⭐⭐⭐⭐⭐ |
| 723 | python-fastapi-development | FastAPI、SQLAlchemy、Pydantic、认证 | ⭐⭐⭐⭐⭐ |
| 950 | fastapi-pro | FastAPI 高性能、SQLAlchemy 2.0、Pydantic V2、微服务 | ⭐⭐⭐⭐⭐ |
| 722 | python-project-architecture | 项目脚手架、现代化工具 (uv/FastAPI/Django) | ⭐⭐⭐⭐ |
| 725 | python-patterns | 开发原则、框架选择、类型提示 | ⭐⭐⭐⭐ |
| 726 | python-performance-optimization | cProfile、性能分析、瓶颈优化 | ⭐⭐⭐⭐ |
| 728 | python-testing-patterns | pytest、fixtures、Mock、TDD | ⭐⭐⭐⭐⭐ |
| 73 | async-python-patterns | asyncio、高并发、async/await | ⭐⭐⭐⭐ |
| 724 | python-packaging | PyPI 发布、项目结构、CLI 工具 | ⭐⭐⭐⭐ |
| 866 | temporal-python-pro | Temporal 工作流、分布式事务 | ⭐⭐⭐⭐ |
| 867 | dbos-python | DBOS 持久化工作流、容错应用 | ⭐⭐⭐⭐ |
| 950 | django-pro | Django 现代开发、REST API、认证 | ⭐⭐⭐⭐ |

### 2.2 Python 3.12+ 核心特性详解

```markdown
### 🐍 现代特性
- 改进的错误消息 (better error messages)
- 模式匹配 (match statement)
- 高级类型提示和泛型
- Descriptors 和元类
- Python 3.12 perf improvements

### 🛠️ 现代工具链
- uv: 2024 最快包管理器 (10-100x pip)
- ruff: 替代 black/isort/flake8/lint
- mypy/pyright: 类型检查
- pyproject.toml: 现代标准
- pytest: 测试框架

### 🌐 Web 开发
- FastAPI 高性能 API
- Pydantic 数据验证
- SQLAlchemy 2.0+ 异步支持
- WebSocket 支持
- 依赖注入
```

### 2.3 FastAPI Pro 高级特性

```markdown
### 核心能力
- FastAPI 0.100+ 新特性 (Annotated types)
- 异步/await 高并发模式
- Pydantic V2 数据验证
- 自动 OpenAPI/Swagger 文档
- WebSocket 实时通信
- 后台任务 (BackgroundTasks)

### 数据管理
- SQLAlchemy 2.0+ 异步 (asyncpg, aiomysql)
- Alembic 数据库迁移
- Repository 模式和 Unit of Work
- MongoDB (Motor, Beanie)
- Redis 缓存和会话存储
- 查询优化和 N+1 预防

### API 设计
- RESTful API 设计原则
- GraphQL (Strawberry/Graphene)
- 微服务架构模式
- API 版本控制
- 限流和节流
- 熔断器模式

### 认证与安全
- OAuth2 + JWT (python-jose, pyjwt)
- 社交登录 (Google, GitHub)
- API Key 认证
- RBAC 角色访问控制
- CORS 和安全头
```

### 2.4 Django Pro 核心能力

```markdown
### 现代 Django 开发
- Django 5.0+ 特性
- async views 和 ORM
- Pydantic 集成
- REST Framework 现代化

### 数据库
- Django ORM 优化
- 迁移管理
- PostgreSQL 特定功能

### 认证
- JWT 认证
- OAuth2
- 权限系统
```

### 2.5 Python 异步编程详解

```markdown
### asyncio 基础
- async/await 语法
- Event loop 管理
- Task 和 Future
- Coroutines

### 生态集成
- aiohttp: 异步 HTTP 客户端
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis (aioredis)
- httpx: 异步 HTTP 客户端

### 高级模式
- 并发任务管理
- 异步生成器
- 异步上下文管理器
- 错误处理和重试
- 限流和背压
```

### 2.6 Temporal 工作流 (分布式事务)

```markdown
### Temporal Python Pro
- 持久化工作流
- 活动 (Activities)
- 工作流编排
- 容错和重试
- 时间旅行调试

### 核心概念
- Workflow: 业务逻辑
- Activity: 具体操作
- Worker: 执行单元
- Client: 启动和监控
```

### 2.7 DBOS 持久化工作流

```markdown
### DBOS Python
- 持久化工作流保证
- 步骤 (Steps) 编排
- 队列并发控制
- 事件和消息通信

### 关键约束
- 工作流必须是确定性的
- 非确定性操作放在步骤中
- 不在线程中启动工作流
```

---

## 三、自动化测试 Skills 深度探索

### 3.1 核心测试 Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 873 | ai-test-automation | AI 驱动测试、自愈测试、质量工程 | ⭐⭐⭐⭐⭐ |
| 877 | testing-qa | 综合 QA 工作流、单元/集成/E2E | ⭐⭐⭐⭐⭐ |
| 728 | python-testing-patterns | pytest 最佳实践、fixtures、Mock | ⭐⭐⭐⭐⭐ |
| 405 | playwright-skill | Playwright E2E、跨浏览器、视觉回归 | ⭐⭐⭐⭐⭐ |
| 406 | e2e-testing | Cypress 端到端测试 | ⭐⭐⭐⭐ |
| 693 | e2e-testing-patterns | Playwright/Cypress 模式 | ⭐⭐⭐⭐ |
| 876 | javascript-testing-patterns | Jest 测试模式、工厂函数、Mock | ⭐⭐⭐⭐ |
| 852 | tdd-orchestrator | TDD 红绿重构协调、多代理工作流 | ⭐⭐⭐⭐ |
| 853 | tdd-red-phase | TDD 红阶段：失败测试生成 | ⭐⭐⭐⭐ |
| 855 | tdd-green-phase | TDD 绿阶段：最小代码通过 | ⭐⭐⭐⭐ |
| 856 | tdd-refactor-phase | TDD 重构阶段 | ⭐⭐⭐⭐ |
| 721 | pairwise-testing | Pairwise 测试生成 | ⭐⭐⭐ |
| 867 | temporal-python-testing | Temporal 工作流测试 | ⭐⭐⭐ |
| 34 | android-e2e-adb | Android ADB UI 自动化测试 | ⭐⭐⭐ |
| 900 | unit-test-generation | 单元测试生成、覆盖率优化 | ⭐⭐⭐⭐ |
| 950 | testing-patterns | 通用测试模式 | ⭐⭐⭐⭐ |

### 3.2 AI 驱动测试自动化详解

```markdown
### 🤖 AI 能力
- Self-healing tests (自愈测试)
- NLP 测试生成
- ML 失败预测
- 视觉 AI 测试

### 🛠️ 框架
- Playwright 跨浏览器
- Appium 移动测试
- API 测试 (Postman, Karate)
- 性能测试 (K6, JMeter)

### 📈 CI/CD 集成
- Jenkins/GitLab CI/GitHub Actions
- 并行执行优化
- 容器化测试环境
- 动态测试选择
```

### 3.3 TDD 测试驱动开发详解

```markdown
### 🔄 红绿重构循环
1. 写失败的测试 (Red)
2. 验证失败原因 (Verify)
3. 最小代码通过 (Green)
4. 重构改进 (Refactor)

### TDD 模式
- Chicago School: 状态测试
- London School: 交互测试
- Outside-in: 验收驱动
- Inside-out: 单元驱动
- Double-loop: 双循环
```

### 3.4 Playwright 高级专题

```markdown
### 核心能力
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 使用可见浏览器 (headless: false)
- URL 参数化配置

### 常见模式
- 页面测试 (多视口)
- 登录流程测试
- 表单填写和提交
- 链接检查
- 响应式设计测试

### 最佳实践
- 可靠的元素选择器 (data-testid)
- 智能等待策略
- Page Object 模式
- 测试隔离
- 参数化测试
```

### 3.5 游戏客户端测试专题

```markdown
### Unity Test Framework
- Edit Mode: 纯 C# 逻辑测试
- Play Mode: 集成测试，运行游戏场景
- NUnit 测试框架
- UnityTestAttribute 协程测试

### 网络同步测试
- 帧同步确定性验证
- 状态同步一致性
- 延迟模拟 (Jitter/丢包)
- 断线重连测试

### 性能基准测试
- 帧率监控 (60 FPS 目标)
- 内存分析
- 加载时间测试

### 游戏特定测试
- 输入测试
- AI 行为测试
- 物理模拟测试
- UI 交互测试
```

### 3.6 Android UI 自动化测试 (新增)

```markdown
### android_ui_verification
**官方技能**: 2026-02-28 新增

**功能**:
- 自动化端到端 UI 测试
- Android 模拟器测试
- 布局问题检测
- 状态验证
- 截图捕获

**使用场景**:
- 移动游戏测试
- Android 应用 UI 测试
- 兼容性测试
```

---

## 四、开发者工具 Skills 深度探索

### 4.1 核心开发者工具 Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 267 | workflow-automation | CI/CD 流水线、GitHub Actions | ⭐⭐⭐⭐⭐ |
| 376 | deployment-engineer | 现代 CI/CD、GitOps、部署自动化 | ⭐⭐⭐⭐⭐ |
| 413 | dev-environment-setup | 开发环境配置、工具安装 | ⭐⭐⭐⭐ |
| 369 | debugging-strategies | 错误调试、测试失败分析 | ⭐⭐⭐⭐⭐ |
| 847 | bug-fixing-workflow | Bug 修复工作流、系统化修复 | ⭐⭐⭐⭐ |
| 375 | dependency-upgrade | 依赖版本升级、兼容性分析 | ⭐⭐⭐⭐ |
| 455 | dependency-management | 依赖管理、增量更新 | ⭐⭐⭐⭐ |
| 219 | defensive-bash | 生产级 Bash 脚本、安全防护 | ⭐⭐⭐⭐ |
| 220 | bash-scripting-workflow | Bash 脚本工作流、错误处理 | ⭐⭐⭐⭐ |
| 221 | bats-testing | Bats 自动化测试、Shell 测试 | ⭐⭐⭐⭐ |
| 404 | developer-experience | DX 改进、工具设置、工作流优化 | ⭐⭐⭐⭐ |
| 950 | debugging-toolkit-smart-debug | 智能调试工具包 | ⭐⭐⭐⭐ |
| 950 | error-debugging-error-analysis | 错误调试分析 | ⭐⭐⭐⭐ |
| 950 | deployment-pipeline-design | 部署流水线设计 | ⭐⭐⭐⭐ |

### 4.2 CI/CD 流水线 Skills 详解

```markdown
### GitHub Actions
- YML 配置
- Matrix 构建
- 依赖缓存
- Artifacts 管理
- 自托管运行器
- 安全扫描集成

### GitLab CI
- .gitlab-ci.yml
- Runner 配置
- Auto DevOps
- DAG 管道优化

### 其他平台
- Azure DevOps
- Jenkins
- CircleCI
- Buildkite
- Tekton
```

### 4.3 GitOps 最佳实践

```markdown
### GitOps 工具
- ArgoCD
- Flux v2
- Jenkins X

### 模式
- App-of-apps
- Mono-repo vs Multi-repo
- 环境升级

### 配置管理
- Helm
- Kustomize
- Jsonnet

### 密钥管理
- External Secrets Operator
- Sealed Secrets
- Vault 集成
```

### 4.4 调试策略详解

```markdown
### 系统化调试流程
1. 重现问题并捕获日志/追踪/环境详情
2. 形成假设并设计受控实验
3. 二分法缩小范围和针对性检测
4. 记录发现并验证修复

### 调试技术
- 二分搜索
- 日志分析
- 断点调试
- 性能分析
- 分布式追踪

### 工具
- debugger
- debugging-toolkit-smart-debug
- error-debugging-error-analysis
- distributed-debugging-debug-trace
```

### 4.5 容器和 Kubernetes 部署

```markdown
### Docker 最佳实践
- 多阶段构建
- BuildKit
- 安全最佳实践
- 镜像优化
- Distroless 镜像

### Kubernetes 部署策略
- Rolling updates
- Blue/green 部署
- Canary 部署
- Argo Rollouts
- Flagger 集成

### 零停机部署
- 健康检查
- 就绪探针
- 优雅关闭
- 数据库迁移
```

### 4.6 依赖管理 Skills

```markdown
### 依赖升级
- 版本兼容性分析
- 变更日志检查
- 自动更新 PRs
- 回滚计划

### 依赖安全
- 漏洞扫描
- SBOM 生成
- 许可合规

### 工具
- Dependabot
- Renovate
- Snyk
- OWASP Dependency Check
```

---

## 五、Skills 组合推荐

### 5.1 游戏客户端开发

```
推荐 Skills 组合:
/unity-developer + /unity-ecs-patterns + /multiplayer-game
/godot-gdscript-patterns + /2d-games
/unreal-engine-cpp-pro + /glsl-shaders
/bevy-ecs-expert (Rust 游戏开发)
/game-development (编排器，自动路由)
```

### 5.2 Python 后端开发

```
推荐 Skills 组合:
/python-pro + /python-fastapi-development + /python-testing-patterns
/fastapi-pro + /async-python-patterns + /python-performance-optimization
/temporal-python-pro + /python-testing-patterns (分布式工作流)
```

### 5.3 自动化测试

```
推荐 Skills 组合:
/e2e-testing-patterns + /playwright-skill + /testing-qa
/python-testing-patterns + /test-driven-development + /test-fixing
/ai-test-automation (AI 驱动测试)
```

### 5.4 开发者工具

```
推荐 Skills 组合:
/workflow-automation + /deployment-engineer + /debugging-strategies
/dependency-upgrade + /dependency-management (依赖管理)
/defensive-bash + /bats-testing (Shell 脚本质量)
```

---

## 六、实用场景示例

### 6.1 游戏帧同步服务器开发

```bash
# 使用 Skills 开发帧同步游戏后端

# 1. 项目初始化
>> /python-pro 创建一个新的 Python 项目

# 2. FastAPI 开发
>> /fastapi-pro 设计帧同步游戏的 REST API

# 3. 异步处理
>> /async-python-patterns 实现游戏房间管理

# 4. 测试
>> /python-testing-patterns 编写房间管理测试

# 5. 部署
>> /deployment-engineer 设置 Docker 部署
```

### 6.2 游戏客户端测试

```bash
# 使用 Skills 测试游戏客户端

# 1. Unity 测试
>> /python-testing-patterns 编写同步逻辑测试

# 2. E2E 测试
>> /e2e-testing-patterns 测试游戏 Web 管理后台

# 3. 性能测试
>> /test-automator 设置性能测试套件
```

### 6.3 开发者工作流

```bash
# 使用 Skills 优化开发流程

# 1. 环境设置
>> /dev-environment-setup 配置开发环境

# 2. 调试
>> /debugging-strategies 分析这个错误

# 3. Bug 修复
>> /bug-fixing-workflow 修复这个 bug

# 4. 部署
>> /workflow-automation 设置 CI/CD
```

---

## 七、近期更新亮点

### 7.1 v6.8.0 (2026-03-02) 更新

```markdown
### vibe-code-auditor v2.0.0
**产品力导向的代码审计**
- 模式识别快捷方式: 10 个启发式快速问题检测
- 快速检查: 7 个审计维度各 3 秒扫描
- 执行摘要: 关键发现前置
- 确定性评分: 取代主观范围
- 代码修复块: 修复前后对比示例

### tutorial-engineer v2.0.0
**循证学习，75% 更好的保持率**
- 4-MAT 模型: Why/What/How/What If 框架
- 认知负荷管理: 7±2 法则
- 难度校准表: 包含时间估计
```

### 7.2 v6.7.0 (2026-03-01) 更新

```markdown
### apify-agent-skills
**12 个官方 Apify Skills**
- 网页抓取和数据提取
- 电子商务、潜在客户生成、社交媒体分析

### x-twitter-scraper
**高性能 X (Twitter) 数据提取**
- 搜索推文、获取个人资料、提取媒体和参与度指标
```

### 7.3 v6.6.0 (2026-02-28) 更新

```markdown
### android_ui_verification
**Android 模拟器自动化端到端 UI 测试**
- 测试布局问题
- 状态验证
- 截图捕获

### hierarchical-agent-memory
**作用域 CLAUDE.md 内存系统**
- 目录级上下文文件
- 大幅减少重复查询的 token 消耗
```

---

## 八、优缺点分析总结

### ✅ 共同优点

| 类别 | 优点 |
|-----|------|
| **全栈覆盖** | 从游戏开发到 Python 后端，从测试到 DevOps 全覆盖 |
| **现代化** | 紧跟 2024/2025/2026 最新工具链 |
| **AI 增强** | AI 驱动测试、自愈测试、智能调试 |
| **生产级** | 包含 Docker、K8s、CI/CD 最佳实践 |

### ❌ 共同缺点

| 类别 | 缺点 |
|-----|------|
| **学习曲线** | Skills 数量众多，需要时间熟悉 |
| **版本更新** | 部分工具可能已更新，需要跟进 |
| **深度有限** | 偏向概览，需要结合官方文档深入 |

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)
- [Unity AI Workflow 2026](https://github.com/David-GD13/unity-ai-workflow)
- [Unity 官方文档](https://docs.unity.com/)
- [Godot 文档](https://docs.godotengine.org/)
- [Unreal Engine 文档](https://docs.unrealengine.com/)
- [Python 官方文档](https://docs.python.org/3/)
- [FastAPI 文档](https://fastapi.tiangolo.com/)
- [uv 包管理器](https://github.com/astral-sh/uv)
- [ruff 工具](https://github.com/astral-sh/ruff)
- [Playwright 文档](https://playwright.dev/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

---

*本报告持续更新中...*
