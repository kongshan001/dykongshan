# Claude Code Skills 调研报告 - 游戏/Python/测试/开发者工具

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub + Antigravity Awesome Skills (970+ Skills)  
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
| GitHub 热门 Skills 仓库 | 20+ |
| 本周重点分析 | 15+ |
| 分类覆盖 | 4 大类 |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | GitHub Stars |
------|--------|-----------|-|---------------|
| unity-ai-workflow | David-GD13/unity-ai-workflow | Unity 6.2+ AI 开发工作流 | 4⭐ |
| OH-Unity-GameDev-Skills | OstrichHermit | Unity 开发 agent skills | 6⭐ |
| everything-claude-code | affaan-m | 全面的 agent 性能优化系统 | 58,717⭐ |
| antigravity-awesome-skills | sickn33 | 900+ Skills 集合 | 18,542⭐ |

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
```

**快速开始**:
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

### 1.3 Antigravity 游戏开发 Skills 矩阵

**来源**: [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)

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

### 1.6 典型交互示例

```
"Architect a multiplayer game with Unity Netcode and dedicated servers"
"Optimize mobile game performance using URP and LOD systems"
"Create a custom shader with Shader Graph for stylized rendering"
"Implement ECS architecture for high-performance gameplay systems"
```

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | GitHub Stars |
|-----------|------|---------|---------------|
| python-pro | Antigravity | Python 3.12+ 全栈指南 | - |
| python-fastapi-development | Antigravity | FastAPI 后端开发 | - |
| python-testing-patterns | Antigravity | pytest 测试策略 | - |
| async-python-patterns | Antigravity | asyncio 异步编程 | - |
| python-performance-optimization | Antigravity | 性能分析和优化 | - |

### 2.2 Python Pro 核心能力

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

### Web 开发
- FastAPI 高性能 API
- Pydantic 数据验证
- SQLAlchemy 2.0+ 异步支持
- WebSocket 支持

### 性能优化
- cProfile, py-spy 性能分析
- asyncio 异步 I/O
- 多进程 CPU 并行
- 内存优化和 GC 调优
```

### 2.3 Python FastAPI Development 核心能力

```markdown
### FastAPI 核心
- 路由和依赖注入
- Pydantic 模型验证
- 异步 SQLAlchemy
- JWT 认证

### 生产级特性
- OpenAPI 自动文档
- 错误处理中间件
- 日志和监控
- 部署和 Docker
```

### 2.4 Async Python Patterns 核心能力

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
- Redis 异步客户端
```

### 2.5 Python Testing Patterns 核心能力

```markdown
### 测试框架
- pytest: 主流测试框架
- Hypothesis: 属性测试
- pytest-cov: 覆盖率分析

### 测试策略
- 单元测试
- 集成测试
- 端到端测试
- TDD 开发流程

### Mock 和 Fixture
- unittest.mock
- pytest fixtures
- Factory patterns
- Test databases
```

### 2.6 典型交互示例

```
"Help me migrate from pip to uv for package management"
"Design a FastAPI application with proper error handling"
"Set up a modern Python project with ruff, mypy, pytest"
"Implement a high-performance data processing pipeline"
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | GitHub Stars |
|-----------|------|---------|---------------|
| playwright-skill | lackeyjb/playwright-skill | 浏览器自动化测试 | 1,844⭐ |
| e2e-testing-patterns | Antigravity | Playwright/Cypress E2E | - |
| test-automator | Antigravity | AI 驱动测试自动化 | - |
| python-testing-patterns | Antigravity | pytest 测试 | - |
| testing-qa | Antigravity | 综合 QA 工作流 | - |

### 3.2 Playwright Skill (热门) 详解

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

**GitHub Stars**: 1,844⭐ (测试类热门)

**核心特性**:
```markdown
### 功能
- Model-invoked - Claude 自主编写和执行自定义自动化
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

**典型交互**:
```
"测试这个登录流程"
"检查响应式设计"
"验证表单提交"
```

### 3.3 Test Automator 核心能力

```markdown
### AI 驱动测试
- Self-healing tests (Testim, Applitools)
- NLP 测试生成
- ML 失败预测
- 视觉 AI 测试

### 现代化框架
- Playwright 跨浏览器
- Appium 移动测试
- API 测试 (Postman, Karate)
- 性能测试 (K6, JMeter)

### CI/CD 集成
- Jenkins/GitLab CI/GitHub Actions
- 并行执行优化
- 容器化测试环境
- 动态测试选择
```

### 3.4 游戏客户端测试专题

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

### 3.5 移动端游戏测试

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

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | GitHub Stars |
|-----------|------|---------|---------------|
| browser-automation | Antigravity | 浏览器自动化 | - |
| github-automation | Antigravity | GitHub 自动化 | - |
| github-workflow-automation | Antigravity | GitHub Actions | - |
| changelog-automation | Antigravity | Changelog 生成 | - |
| cli-tool-development | Antigravity | CLI 工具开发 | - |

### 4.2 Browser Automation 核心能力

```markdown
### 基础原理
- 元素定位策略 (CSS/XPath/ARIA)
- 等待策略 (显式/隐式/智能)
- 页面对象模式
- 测试隔离

### 工具对比
| 工具 | 特点 | 适用场景 |
|------|------|---------|
| Playwright | 跨浏览器、API 丰富 | 现代 Web 测试 |
| Puppeteer | Chrome 专用、轻量 | 爬虫/截图 |
| Selenium | 历史悠久、生态广 | 遗留项目 |
| Cypress | 调试友好、实时重载 | 开发测试 |
```

### 4.3 GitHub Automation 核心能力

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

### 4.4 GitHub Workflow Automation 核心能力

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

### 4.5 典型交互示例

```
"Create a new issue for the bug"
"Automatically label new PRs"
"Run tests on PR and report results"
"Set up branch protection rules"
```

---

## 📈 五、综合对比分析

### 5.1 游戏开发 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| unity-developer | Unity 6 全面指南 | Unity 项目开发 |
| unity-ai-workflow | 2026 AI 工作流 | 快速原型/协作 |
| godot-gdscript-patterns | Godot 4 最佳实践 | 开源/轻量游戏 |
| unreal-engine-cpp-pro | UE5 C++ 开发 | AAA 级游戏 |
| Unity 官方文档 | 权威但分散 | 深入特定功能 |

### 5.2 Python 开发 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| python-pro | Python 3.12+ 全面指南 | 通用开发 |
| python-fastapi-development | FastAPI 专精 | API 开发 |
| python-testing-patterns | pytest 最佳实践 | 质量保证 |
| async-python-patterns | 异步编程 | 高并发 |
| Real Python 教程 | 深入但分散 | 特定主题学习 |

### 5.3 测试 Skills 对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| playwright-skill | 浏览器自动化 | 1,844⭐ 热门 |
| test-automator | AI 驱动企业级 | 大规模测试 |
| e2e-testing-patterns | Playwright/Cypress | Web E2E |
| python-testing-patterns | pytest 最佳实践 | Python 测试 |
| Selenium | 传统框架 | 遗留项目 |

---

## ✅ 六、落地过程

### 6.1 快速开始

```bash
# 安装 Skills
npx antigravity-awesome-skills --claude

# 游戏开发
>> /unity-developer 帮助我设计一个多人游戏架构
>> /godot-gdscript-patterns 创建状态机系统

# Python 开发
>> /python-pro 帮助我设计一个 FastAPI 项目结构
>> /python-fastapi-development 开发 API 端点

# 测试
>> /playwright-skill 帮助我自动化测试
>> /python-testing-patterns 编写单元测试

# 开发者工具
>> /browser-automation 自动化表单填写
>> /github-automation 创建 release 工作流
```

### 6.2 推荐学习路径

```
游戏开发:
1. 基础: 2d-games / 3d-games (通用原理)
2. 引擎选择:
   - Unity → unity-developer → unity-ecs-patterns
   - Godot → godot-gdscript-patterns
   - Unreal → unreal-engine-cpp-pro
3. 进阶: 性能优化 → 跨平台部署

Python 开发:
1. 基础: python-patterns (开发原则)
2. 工具: python-pro (现代工具链)
3. Web: python-fastapi-development (API 开发)
4. 测试: python-testing-patterns (质量保证)
5. 进阶: async-python-patterns (高并发)
6. 优化: python-performance-optimization (性能)

测试:
1. 基础: python-testing-patterns / testing-patterns
2. E2E: e2e-testing-patterns / playwright-skill
3. 进阶: test-automator (AI 驱动)
4. 流程: test-driven-development

开发者工具:
1. 基础: browser-automation
2. Git: github-automation / github-workflow-automation
3. 部署: cicd-automation-workflow-automate
4. 发布: changelog-automation
```

### 6.3 项目实践

对于 game-frame-sync 项目：
- 使用 `unity-developer` 优化帧同步网络同步
- 使用 `python-pro` 搭建 Python 后端
- 使用 `python-fastapi-development` 开发 API
- 使用 `python-testing-patterns` 编写同步逻辑测试
- 使用 `e2e-testing-patterns` 测试 Web 管理后台
- 使用 `github-workflow-automation` 设置 CI/CD

---

## 📚 七、相关资源

### GitHub 热门仓库

| 仓库 | Stars | 描述 |
|------|-------|------|
| everything-claude-code | 58,717⭐ | Agent 性能优化系统 |
| awesome-claude-code | 26,048⭐ | Skills 精选列表 |
| antigravity-awesome-skills | 18,542⭐ | 900+ Skills 集合 |
| planning-with-files | 15,118⭐ | Markdown 规划 |
| playwright-skill | 1,844⭐ | Playwright 自动化 |

### 官方文档

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [ClawHub Skills](https://clawhub.com)
- [Unity 官方文档](https://docs.unity.com/)
- [Python 官方文档](https://docs.python.org/3/)
- [FastAPI 文档](https://fastapi.tiangolo.com/)
- [Playwright 文档](https://playwright.dev/)

---

**调研完成**: 2026-03-04
