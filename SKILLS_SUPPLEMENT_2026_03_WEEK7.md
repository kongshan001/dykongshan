# Claude Code Skills 调研补充 - 2026年3月

> 游戏客户端开发、Python 开发、自动化测试、开发者工具

## 📋 文档信息

- **调研日期**: 2026-03-04
- **Skill 来源**: Antigravity Awesome Skills (968+ Skills)
- **目标仓库**: https://github.com/kongshan001/cc_skills
- **状态**: ✅ 调研完成

---

## 一、游戏客户端开发 Skills

### 1.1 主流游戏引擎 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 901 | unity-developer | Unity 6 LTS、URP/HDRP、C# 优化、跨平台部署 | ⭐⭐⭐⭐⭐ |
| 902 | unity-ecs-patterns | DOTS、Jobs System、Burst Compiler | ⭐⭐⭐⭐⭐ |
| 903 | unreal-engine-cpp-pro | Unreal 5.x C++、UObject、性能模式 | ⭐⭐⭐⭐⭐ |
| 494 | godot-gdscript-patterns | Godot 4、GDScript 2.0、信号、状态机 | ⭐⭐⭐⭐ |
| 493 | godot-migration | Godot 3→4 迁移指南 | ⭐⭐⭐ |

### 1.2 Unity Developer 核心能力

```markdown
### 🎮 开发能力
- Unity 6 LTS 最佳实践
- C# 脚本优化
- URP/HDRP 渲染管线
- 跨平台部署 (iOS/Android/WebGL/Console)

### ⚡ 性能优化
- Unity Profiler 分析
- 内存管理
- 资源优化
- 帧率优化

### 🏗️ 架构模式
- ECS/DOTS 架构
- ScriptableObject 数据驱动
- 状态机模式
- 对象池技术
```

### 1.3 Unity ECS Patterns 核心能力

```markdown
### Entity Component System
- Entities: 游戏对象数据
- Components: 数据组件
- Systems: 逻辑系统

### Jobs System
- 多线程并行处理
- Burst Compiler 编译优化
- 内存布局优化

### 适用场景
- 大规模对象处理 (1000+ 敌人)
- 粒子系统优化
- 物理计算优化
- AI 计算优化
```

### 1.4 Unreal Engine C++ Pro 核心能力

```markdown
### C++ 开发
- UObject 规范和内存管理
- 智能指针和垃圾回收
- 属性系统 (UPROPERTY)

### 高级系统
- Slate UI 框架
- UMG 动画系统
- 网络复制和 RPC
- 模块化架构

### 性能优化
- 性能分析工具
- 内存优化
- 渲染优化
```

### 1.5 通用游戏开发 Skills

| Skill ID | 名称 | 描述 |
|---------|------|------|
| 2 | 2d-games | 2D 游戏开发原理：精灵、瓦片地图、物理、相机 |
| 3 | 3d-games | 3D 游戏开发原理：渲染、着色器、物理 |
| 469 | game-art | 游戏美术原理：视觉风格、资产管线、动画流程 |
| 470 | game-audio | 游戏音频：音效设计、音乐集成、动态音频 |
| 471 | game-design | 游戏设计：GDD 结构、平衡性、玩家心理 |
| 472 | game-dev-orchestrator | 游戏开发协调：根据项目需求路由到特定平台 Skills |
| 623 | mobile-game | 移动游戏开发：触控输入、电池优化、性能 |
| 635 | multiplayer-game | 多人游戏开发：架构、网络、同步 |
| 678 | pc-console-game | PC/主机游戏开发：引擎选择、平台特性、优化 |
| 804 | glsl-shaders | GLSL 着色器：Vertex/Fragment 着色、通用效果 |

---

## 二、Python 开发 Skills

### 2.1 核心 Python Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 727 | python-pro | Python 3.12+、现代特性、生产级实践 | ⭐⭐⭐⭐⭐ |
| 723 | python-fastapi-development | FastAPI、SQLAlchemy、Pydantic、认证 | ⭐⭐⭐⭐⭐ |
| 722 | python-project-architecture | 项目脚手架、现代化工具 (uv/FastAPI/Django) | ⭐⭐⭐⭐ |
| 725 | python-patterns | 开发原则、框架选择、类型提示 | ⭐⭐⭐⭐ |
| 726 | python-performance-optimization | cProfile、性能分析、瓶颈优化 | ⭐⭐⭐⭐ |
| 728 | python-testing-patterns | pytest、fixtures、Mock、TDD | ⭐⭐⭐⭐ |
| 73 | async-python-patterns | asyncio、高并发、async/await | ⭐⭐⭐⭐ |
| 724 | python-packaging | PyPI 发布、项目结构、CLI 工具 | ⭐⭐⭐⭐ |
| 909 | uv | uv 包管理器、快速依赖管理 | ⭐⭐⭐⭐⭐ |
| 866 | temporal-python-pro | Temporal 工作流、分布式事务 | ⭐⭐⭐⭐ |

### 2.2 Python 3.12+ 核心特性

```markdown
### 🐍 现代特性
- 改进的错误消息
- 模式匹配 (match statement)
- 高级类型提示和泛型
- Descriptors 和元类

### 🛠️ 现代工具链
- uv: 2024 最快包管理器
- ruff: 替代 black/isort/flake8
- mypy/pyright: 类型检查
- pyproject.toml: 现代标准

### 🌐 Web 开发
- FastAPI 高性能 API
- Pydantic 数据验证
- SQLAlchemy 2.0+ 异步支持
- WebSocket 支持
```

### 2.3 FastAPI 开发最佳实践

```markdown
### 核心能力
- 路由和依赖注入
- Pydantic 模型验证
- 异步 SQLAlchemy
- JWT 认证

### 生产级特性
- OpenAPI 自动文档
- 错误处理中间件
- 日志和监控
- Docker 部署

### 性能优化
- 异步 I/O
- 连接池
- 缓存策略
- 压缩传输
```

### 2.4 uv 包管理器 (2024 新贵)

```markdown
### 核心优势
- 🚀 10-100x 比 pip 快
- 📦 依赖解析更快
- 🔒 锁定文件支持
- 🐍 Python 版本管理

### 常用命令
uv pip install <package>
uv venv
uv sync
uv lock
```

### 2.5 Python 异步编程

```markdown
### asyncio 基础
- async/await 语法
- Event loop 管理
- Task 和 Future

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis 异步客户端

### 高级模式
- 并发任务管理
- 异步生成器
- 异步上下文管理器
- 错误处理
```

---

## 三、自动化测试 Skills

### 3.1 核心测试 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 873 | ai-test-automation | AI 驱动测试、自愈测试、质量工程 | ⭐⭐⭐⭐⭐ |
| 877 | testing-qa | 综合 QA 工作流、单元/集成/E2E | ⭐⭐⭐⭐⭐ |
| 728 | python-testing-patterns | pytest 最佳实践、fixtures、Mock | ⭐⭐⭐⭐⭐ |
| 405 | e2e-testing-playwright | Playwright E2E、跨浏览器、视觉回归 | ⭐⭐⭐⭐⭐ |
| 406 | e2e-testing-cypress | Cypress 端到端测试 | ⭐⭐⭐⭐ |
| 693 | playwright-testing | Playwright 完整指南 | ⭐⭐⭐⭐ |
| 876 | jest-testing-patterns | Jest 测试模式、工厂函数、Mock | ⭐⭐⭐⭐ |
| 852 | tdd-orchestrator | TDD 红绿重构协调、多代理工作流 | ⭐⭐⭐⭐ |
| 853 | tdd-red-phase | TDD 红阶段：失败测试生成 | ⭐⭐⭐⭐ |
| 855 | tdd-green-phase | TDD 绿阶段：最小代码通过 | ⭐⭐⭐⭐ |
| 856 | tdd-refactor-phase | TDD 重构阶段 | ⭐⭐⭐⭐ |
| 721 | pairwise-testing |  pairwise 测试生成 | ⭐⭐⭐ |
| 867 | temporal-testing | Temporal 工作流测试 | ⭐⭐⭐ |
| 34 | android-e2e-adb | Android ADB UI 自动化测试 | ⭐⭐⭐ |
| 900 | unit-test-generation | 单元测试生成、覆盖率优化 | ⭐⭐⭐⭐ |

### 3.2 AI 驱动测试自动化

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

### 3.3 TDD 测试驱动开发

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

### 3.4 游戏客户端测试专题

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
```

### 3.5 Playwright 高级专题

```markdown
### 核心能力
- 自动检测开发服务器
- 元素定位和等待
- 视觉回归测试
- 跨浏览器测试
- 移动端模拟

### 最佳实践
- 可靠的元素选择器
- 智能等待策略
- Page Object 模式
- 测试隔离
```

---

## 四、开发者工具 Skills

### 4.1 核心开发者工具 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 267 | workflow-automation | CI/CD 流水线、GitHub Actions | ⭐⭐⭐⭐⭐ |
| 376 | deployment-automation | 现代 CI/CD、GitOps、部署自动化 | ⭐⭐⭐⭐⭐ |
| 413 | dev-environment-setup | 开发环境配置、工具安装 | ⭐⭐⭐⭐ |
| 369 | debugging-specialist | 错误调试、测试失败分析 | ⭐⭐⭐⭐⭐ |
| 847 | bug-fixing-workflow | Bug 修复工作流、系统化修复 | ⭐⭐⭐⭐ |
| 375 | dependency-upgrade | 依赖版本升级、兼容性分析 | ⭐⭐⭐⭐ |
| 455 | dependency-management | 依赖管理、增量更新 | ⭐⭐⭐⭐ |
| 219 | defensive-bash | 生产级 Bash 脚本、安全防护 | ⭐⭐⭐⭐ |
| 220 | bash-scripting-workflow | Bash 脚本工作流、错误处理 | ⭐⭐⭐⭐ |
| 221 | bats-testing | Bats 自动化测试、Shell 测试 | ⭐⭐⭐⭐ |
| 404 | developer-experience | DX 改进、工具设置、工作流优化 | ⭐⭐⭐⭐ |

### 4.2 CI/CD 流水线 Skills

```markdown
### GitHub Actions
- YML 配置
- Matrix 构建
- 依赖缓存
- Artifacts 管理

### GitLab CI
- .gitlab-ci.yml
- Runner 配置
- Auto DevOps

### 最佳实践
- 失败快速反馈
- 并行执行
- 缓存优化
- 安全扫描集成
```

### 4.3 调试和修复 Skills

```markdown
### Debugging Specialist
- 错误分析
- 测试失败诊断
- 堆栈跟踪解读
- 性能问题定位

### Bug Fixing Workflow
1. 运行测试获取失败
2. 智能错误分组
3. 分析失败原因
4. 逐个修复
5. 验证修复

### Dependency Management
- 安全漏洞扫描
- 版本兼容性检查
- 增量更新策略
- 回滚计划
```

### 4.4 开发环境设置

```markdown
### 环境配置
- 工具安装和版本管理
- 依赖配置
- IDE 设置
- Docker 配置

### 自动化
- 一键环境搭建
- 脚本化安装
- 多平台支持
```

---

## 五、新增热门 Skills 速查表

### 5.1 游戏开发 (Game Dev)

```
推荐 Skills 组合:
/unity-developer + /unity-ecs-patterns + /multiplayer-game
/godot-gdscript-patterns + /2d-games
/unreal-engine-cpp-pro + /glsl-shaders
```

### 5.2 Python 开发 (Python Dev)

```
推荐 Skills 组合:
/python-pro + /python-fastapi-development + /uv
/python-testing-patterns + /tdd-orchestrator
/async-python-patterns + /python-performance-optimization
```

### 5.3 自动化测试 (Testing)

```
推荐 Skills 组合:
/ai-test-automation + /playwright-testing
/python-testing-patterns + /tdd-orchestrator
/e2e-testing-playwright + /visual-validation
```

### 5.4 开发者工具 (DevTools)

```
推荐 Skills 组合:
/workflow-automation + /deployment-automation
/debugging-specialist + /bug-fixing-workflow
/dev-environment-setup + /dependency-management
```

---

## 六、Skills 安装和使用

### 6.1 安装方式

```bash
# 方式 1: 使用 Antigravity Awesome Skills
npx antigravity-awesome-skills --claude

# 方式 2: 手动安装特定 Skill
# 参考各 Skill 目录的安装说明
```

### 6.2 使用方式

```bash
# 直接调用 Skill
>> /unity-developer 帮助我设计多人游戏架构
>> /python-fastapi-development 创建 REST API
>> /playwright-testing 编写登录测试
>> /tdd-orchestrator 使用 TDD 开发功能
```

---

## 七、相关资源

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)
- [skills.sh](https://skills.sh)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code)

---

*文档生成时间: 2026-03-04*
*持续更新中...*
