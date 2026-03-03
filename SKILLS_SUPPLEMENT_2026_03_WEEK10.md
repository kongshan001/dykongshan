# Claude Code Skills 调研补充 - 2026年3月（第十周）

> 游戏客户端开发、Python 开发、自动化测试、开发者工具

## 📋 文档信息

- **调研日期**: 2026-03-04
- **Skill 来源**: Antigravity Awesome Skills (970+ Skills) + 社区精选
- **目标仓库**: https://github.com/kongshan001/cc_skills
- **状态**: ✅ 调研完成

---

## 一、 Antigravity Awesome Skills v6.7.0 最新更新

### 1.1 仓库概览

**Antigravity Awesome Skills** 是最大的 Claude Code Skills 集合，目前包含 **970+ 个 Skills**，覆盖 10+ AI 助手平台。

| 统计 | 数值 |
|------|------|
| Skills 总数 | 970+ |
| 支持平台 | 10+ |
| 文档页面 | V6.7.0 Interactive Web Edition |
| 更新频率 | 持续更新 |

### 1.2 支持的平台

```markdown
| 平台 | 类型 | 技能路径 |
|------|------|---------|
| Claude Code | CLI | .claude/skills/ |
| Gemini CLI | CLI | .gemini/skills/ |
| Codex CLI | CLI | .codex/skills/ |
| Kiro CLI/IDE | CLI/IDE | ~/.kiro/skills/ |
| Antigravity IDE | IDE | ~/.gemini/antigravity/skills/ |
| Cursor | IDE | .cursor/skills/ |
| GitHub Copilot | Extension | N/A |
| OpenCode | CLI | .agents/skills/ |
| AdaL CLI | CLI | .adal/skills/ |
```

### 1.3 v6.7.0 新增 Skills (2026-03)

```markdown
### 游戏开发类
- game-development: 游戏开发编排器 (2026-02-27 新增)
- unity-developer: Unity 6 LTS 完整指南 (2026-02-27 新增)
- unity-ecs-patterns: DOTS/ECS 架构 (2026-02-27 新增)

### Python 开发类
- python-pro: Python 3.12+ 专家指南 (2026-02-27 新增)
- async-python-patterns: 异步编程模式 (2026-02-27 新增)
- fastapi-pro: FastAPI 高级特性 (新增)
- temporal-python-pro: Temporal 工作流 (新增)

### 测试类
- playwright-skill: Playwright 浏览器自动化 (2026-02-27 新增)
- test-driven-development: TDD 开发流程 (2026-02-27 新增)
- ai-test-automation: AI 驱动测试 (新增)

### 开发者工具类
- workflow-automation: CI/CD 自动化 (新增)
- deployment-engineer: 部署工程师 (新增)
- debugging-strategies: 调试策略 (新增)
```

---

## 二、游戏客户端开发 Skills 深度分析

### 2.1 核心 Skills 完整列表

| Skill ID | 名称 | 核心能力 | 适用引擎 | 评分 |
|---------|------|---------|---------|------|
| 901 | unity-developer | Unity 6 LTS、URP/HDRP、跨平台 | Unity | ⭐⭐⭐⭐⭐ |
| 902 | unity-ecs-patterns | DOTS、Jobs System、Burst | Unity | ⭐⭐⭐⭐⭐ |
| 903 | unreal-engine-cpp-pro | UE5 C++、UObject、网络 | Unreal | ⭐⭐⭐⭐⭐ |
| 494 | godot-gdscript-patterns | Godot 4、GDScript 2.0 | Godot | ⭐⭐⭐⭐ |
| 493 | godot-4-migration | Godot 3→4 迁移 | Godot | ⭐⭐⭐⭐ |
| 950 | bevy-ecs-expert | Bevy ECS (Rust) | Bevy | ⭐⭐⭐⭐⭐ |
| 472 | game-development | 游戏开发编排器 | 通用 | ⭐⭐⭐⭐ |

### 2.2 Game Development 编排器详解

> **路由型 Skill**，根据项目需求自动路由到特定子 Skills

```markdown
### 子技能路由矩阵

| 目标平台 | 子技能 |
|---------|--------|
| Web 浏览器 (HTML5, WebGL) | game-development/web-games |
| 移动端 (iOS, Android) | game-development/mobile-games |
| PC (Steam, Desktop) | game-development/pc-games |
| VR/AR 头显 | game-development/vr-ar |

| 游戏维度 | 子技能 |
|---------|--------|
| 2D (精灵、瓦片地图) | game-development/2d-games |
| 3D (网格、着色器) | game-development/3d-games |

| 专业领域 | 子技能 |
|---------|--------|
| GDD、平衡、玩家心理 | game-development/game-design |
| 多人游戏、网络 | game-development/multiplayer |
| 视觉风格、资产管线 | game-development/game-art |
| 音效、音乐、动态音频 | game-development/game-audio |
```

### 2.3 Unity Developer 核心能力

```markdown
### 🎮 开发能力
- Unity 6 LTS 最佳实践
- URP/HDRP 渲染管线
- C# 9.0+ 现代特性
- 跨平台部署 (iOS/Android/WebGL/Console/PC)

### ⚡ 性能优化
- Unity Profiler CPU/GPU/内存分析
- 帧调试器 (Frame Debugger)
- LOD 系统和遮挡剔除
- 内存 Profiler 分析

### 🏗️ 架构模式
- ECS/DOTS 架构
- MVC 模式
- 观察者模式
- 状态机
- 对象池
- Addressables 动态加载
```

### 2.4 Unity ECS Patterns 深度解析

```markdown
### Entity Component System
- Entities: 游戏对象数据表示
- Components: 数据组件 (无逻辑)
- Systems: 逻辑系统 (无数据)

### Jobs System
- 多线程并行处理
- Burst Compiler 编译优化
- 数据导向内存布局

### 适用场景
- 大规模对象处理 (1000+ 单位)
- 粒子系统优化
- 物理计算
- AI 计算
- RTS 单位管理
```

### 2.5 游戏性能预算 (60 FPS = 16.67ms)

| 系统 | 预算 | 优化优先级 |
|------|------|-----------|
| 输入处理 | 1ms | 算法优化 |
| 物理计算 | 3ms | 批处理 |
| AI 计算 | 2ms | 对象池 |
| 游戏逻辑 | 4ms | LOD |
| 渲染 | 5ms | 遮挡剔除 |
| 缓冲 | 1.67ms | - |

---

## 三、Python 开发 Skills 完整分析

### 3.1 核心 Python Skills 列表

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 727 | python-pro | Python 3.12+、现代特性、生产级实践 | ⭐⭐⭐⭐⭐ |
| 723 | python-fastapi-development | FastAPI、SQLAlchemy、Pydantic | ⭐⭐⭐⭐⭐ |
| 950 | fastapi-pro | FastAPI 高性能、微服务 | ⭐⭐⭐⭐⭐ |
| 722 | python-project-architecture | 项目脚手架、uv 工具链 | ⭐⭐⭐⭐ |
| 725 | python-patterns | 开发原则、类型提示 | ⭐⭐⭐⭐ |
| 726 | python-performance-optimization | 性能分析、优化 | ⭐⭐⭐⭐ |
| 728 | python-testing-patterns | pytest、fixtures、TDD | ⭐⭐⭐⭐⭐ |
| 73 | async-python-patterns | asyncio、高并发 | ⭐⭐⭐⭐ |
| 724 | python-packaging | PyPI 发布 | ⭐⭐⭐⭐ |
| 866 | temporal-python-pro | Temporal 工作流 | ⭐⭐⭐⭐ |
| 867 | dbos-python | DBOS 持久化 | ⭐⭐⭐⭐ |
| 950 | django-pro | Django 现代开发 | ⭐⭐⭐⭐ |

### 3.2 Python Pro 核心能力

```markdown
### 🐍 Python 3.12+ 特性
- 改进的错误消息
- 模式匹配 (match statement)
- 高级类型提示和泛型
- Descriptors 和元类
- 性能优化改进

### 🛠️ 现代工具链
- uv: 2024 最快包管理器 (10-100x pip)
- ruff: 替代 black/isort/flake8
- mypy/pyright: 类型检查
- pyproject.toml: 现代标准

### 🌐 Web 开发
- FastAPI 高性能 API
- Pydantic 数据验证
- SQLAlchemy 2.0+ 异步
- WebSocket 支持
```

### 3.3 Async Python Patterns 详解

```markdown
### asyncio 基础
- async/await 语法
- Event loop 管理
- Task 和 Future
- 取消和超时

### 高级模式
- 并发任务管理 (asyncio.gather)
- 异步生成器
- 异步上下文管理器
- 错误处理和重试

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis (aioredis)
- httpx: 异步 HTTP 客户端
```

### 3.4 FastAPI Pro 高级特性

```markdown
### 核心能力
- FastAPI 0.100+ 新特性
- Pydantic V2 数据验证
- 自动 OpenAPI/Swagger
- WebSocket 实时通信
- 后台任务 (BackgroundTasks)

### 数据管理
- SQLAlchemy 2.0+ 异步
- Alembic 迁移
- Repository 模式
- Redis 缓存

### API 设计
- RESTful 原则
- GraphQL (Strawberry)
- 微服务架构
- 限流和熔断
```

---

## 四、自动化测试 Skills 完整分析

### 4.1 核心测试 Skills 列表

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 873 | ai-test-automation | AI 驱动、自愈测试 | ⭐⭐⭐⭐⭐ |
| 877 | testing-qa | 综合 QA 工作流 | ⭐⭐⭐⭐⭐ |
| 728 | python-testing-patterns | pytest、fixtures | ⭐⭐⭐⭐⭐ |
| 405 | playwright-skill | Playwright E2E | ⭐⭐⭐⭐⭐ |
| 406 | e2e-testing | Cypress E2E | ⭐⭐⭐⭐ |
| 693 | e2e-testing-patterns | 测试模式 | ⭐⭐⭐⭐ |
| 876 | javascript-testing-patterns | Jest 模式 | ⭐⭐⭐⭐ |
| 852 | tdd-orchestrator | TDD 协调器 | ⭐⭐⭐⭐ |
| 853 | tdd-red-phase | TDD 红阶段 | ⭐⭐⭐⭐ |
| 855 | tdd-green-phase | TDD 绿阶段 | ⭐⭐⭐⭐ |
| 900 | unit-test-generation | 单元测试生成 | ⭐⭐⭐⭐ |

### 4.2 Test-Driven Development 详解

> **核心原则**: 先写测试，看它失败，再写最小代码通过

```markdown
### 红绿重构循环

| 阶段 | 动作 | 必须执行 |
|------|------|---------|
| RED | 写失败的测试 | ✅ |
| VERIFY | 验证失败原因 | ✅ |
| GREEN | 最小代码通过 | ✅ |
| VERIFY | 验证测试通过 | ✅ |
| REFACTOR | 重构改进 | 可选 |

### TDD 铁律
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

### 测试命名规范
- ✅ test('retries failed operations 3 times')
- ❌ test('test1')
- ❌ test('retry works')
```

### 4.3 Playwright Skill 详解

```markdown
### 核心工作流

**Step 1: 检测开发服务器**
```bash
cd $SKILL_DIR && node -e "require('./lib/helpers').detectDevServers().then(s => console.log(JSON.stringify(s)))"
```

**Step 2: 编写测试脚本到 /tmp**
```javascript
// /tmp/playwright-test-example.js
const { chromium } = require('playwright');
const TARGET_URL = 'http://localhost:3001';

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();
  await page.goto(TARGET_URL);
  console.log('Page title:', await page.title());
  await browser.close();
})();
```

**Step 3: 执行测试**
```bash
cd $SKILL_DIR && node run.js /tmp/playwright-test-example.js
```

### 核心特性
- ✅ 自动检测开发服务器
- ✅ 测试脚本写入 /tmp (不污染项目)
- ✅ 默认可见浏览器 (headless: false)
- ✅ URL 参数化配置
- ✅ 智能等待策略
```

### 4.4 游戏客户端测试专题

```markdown
### Unity Test Framework
- Edit Mode: 纯 C# 逻辑测试
- Play Mode: 集成测试 (运行游戏)
- NUnit 测试框架
- UnityTestAttribute 协程测试

### 网络同步测试
- 帧同步确定性: 相同输入 → 相同输出
- 状态同步一致性
- 延迟模拟 (Jitter: 0-200ms)
- 丢包模拟 (5%-20%)

### 性能基准测试
- 帧率: 目标 60 FPS (16.67ms)
- 内存: 堆监控、泄漏检测
- 加载时间: 场景切换、热更新
```

---

## 五、开发者工具 Skills 完整分析

### 5.1 核心开发者工具 Skills 列表

| Skill ID | 名称 | 核心能力 | 评分 |
|---------|------|---------|------|
| 267 | workflow-automation | CI/CD 流水线 | ⭐⭐⭐⭐⭐ |
| 376 | deployment-engineer | GitOps、部署自动化 | ⭐⭐⭐⭐⭐ |
| 413 | dev-environment-setup | 开发环境配置 | ⭐⭐⭐⭐ |
| 369 | debugging-strategies | 系统化调试 | ⭐⭐⭐⭐⭐ |
| 847 | bug-fixing-workflow | Bug 修复工作流 | ⭐⭐⭐⭐ |
| 375 | dependency-upgrade | 依赖升级 | ⭐⭐⭐⭐ |
| 455 | dependency-management | 依赖管理 | ⭐⭐⭐⭐ |
| 219 | defensive-bash | 生产级 Bash | ⭐⭐⭐⭐ |
| 220 | bash-scripting-workflow | Bash 脚本 | ⭐⭐⭐⭐ |
| 221 | bats-testing | Shell 测试 | ⭐⭐⭐⭐ |

### 5.2 CI/CD 流水线 Skills 详解

```markdown
### GitHub Actions
- YML 配置
- Matrix 构建
- 依赖缓存
- Artifacts
- 自托管运行器

### GitLab CI
- .gitlab-ci.yml
- Runner 配置
- Auto DevOps
- DAG 管道

### 其他平台
- Azure DevOps
- Jenkins
- CircleCI
- Tekton
```

### 5.3 调试策略详解

```markdown
### 系统化调试流程
1. 重现问题
   - 捕获日志/追踪/环境详情
   
2. 形成假设
   - 设计受控实验
   
3. 缩小范围
   - 二分法定位
   - 针对性检测
   
4. 记录发现
   - 验证修复

### 调试技术
- 二分搜索
- 日志分析
- 断点调试
- 性能分析
- 分布式追踪
```

---

## 六、实用 Skills 组合推荐

### 6.1 游戏客户端开发组合

```
推荐 Skills 组合:
/game-development (编排器，自动路由)
/unity-developer + /unity-ecs-patterns
/godot-gdscript-patterns + /2d-games
/unreal-engine-cpp-pro + /glsl-shaders
/bevy-ecs-expert (Rust 游戏引擎)
```

### 6.2 Python 后端开发组合

```
推荐 Skills 组合:
/python-pro + /python-fastapi-development + /python-testing-patterns
/fastapi-pro + /async-python-patterns + /python-performance-optimization
/temporal-python-pro + /python-testing-patterns (分布式工作流)
/dbos-python (持久化工作流)
```

### 6.3 自动化测试组合

```
推荐 Skills 组合:
/e2e-testing-patterns + /playwright-skill + /testing-qa
/python-testing-patterns + /test-driven-development + /test-fixing
/ai-test-automation (AI 驱动测试)
unit-test-generation (测试生成)
```

### 6.4 开发者工具组合

```
推荐 Skills 组合:
/workflow-automation + /deployment-engineer + /debugging-strategies
/dependency-upgrade + /dependency-management
/defensive-bash + /bats-testing
/bug-fixing-workflow (Bug 修复)
```

---

## 七、落地实践示例

### 7.1 游戏帧同步服务器开发

```bash
# 使用 Skills 开发帧同步游戏后端

# 1. 项目初始化
>> /python-pro 创建一个新的 Python 项目，使用 uv 管理依赖

# 2. FastAPI 开发
>> /fastapi-pro 设计帧同步游戏的 REST API

# 3. 异步处理
>> /async-python-patterns 实现游戏房间管理，高并发

# 4. 测试
>> /python-testing-patterns 编写房间管理测试
>> /test-driven-development 使用 TDD 开发新功能

# 5. 部署
>> /deployment-engineer 设置 Docker 部署
>> /workflow-automation 配置 CI/CD
```

### 7.2 游戏客户端自动化测试

```bash
# 使用 Skills 测试游戏客户端

# 1. 单元测试
>> /python-testing-patterns 编写同步逻辑测试

# 2. E2E 测试
>> /playwright-skill 测试游戏 Web 管理后台
>> /e2e-testing-patterns 测试用户注册流程

# 3. 质量保证
>> /testing-qa 建立完整 QA 流程
>> /ai-test-automation 设置 AI 驱动测试
```

### 7.3 开发者工作流优化

```bash
# 使用 Skills 优化开发流程

# 1. 环境设置
>> /dev-environment-setup 配置开发环境

# 2. 调试
>> /debugging-strategies 分析这个错误

# 3. Bug 修复
>> /bug-fixing-workflow 系统化修复这个 bug

# 4. 依赖管理
>> /dependency-upgrade 升级项目依赖

# 5. 部署
>> /workflow-automation 设置 CI/CD 流水线
```

---

## 八、Skills 安装和使用

### 8.1 安装命令

```bash
# 默认安装 (Antigravity)
npx antigravity-awesome-skills

# Claude Code
npx antigravity-awesome-skills --claude

# Gemini CLI
npx antigravity-awesome-skills --gemini

# Codex CLI
npx antigravity-awesome-skills --codex

# Cursor
npx antigravity-awesome-skills --cursor

# 自定义路径
npx antigravity-awesome-skills --path ~/.my-skills
```

### 8.2 使用方式

```bash
# Claude Code
>> /skill-name 帮助我...

# Gemini CLI/Codex CLI
Use @skill-name to help me...

# Cursor
@skill-name in chat
```

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [官方 Skills 目录](./CATALOG.md)
- [Skills 使用指南](./docs/USAGE.md)
- [Bundles 精选](./docs/BUNDLES.md)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)

---

*文档更新时间: 2026-03-04*
*Claude Code Skills 调研 - 第十周*
