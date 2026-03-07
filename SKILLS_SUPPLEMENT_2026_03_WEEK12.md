# Claude Code Skills 调研报告 - 第十二周

**调研日期**: 2026-03-04  
**技能来源**: Antigravity Awesome Skills (970+ Skills) + 社区精选  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本周继续深入分析 Claude Code 热门 Skills，重点关注：
1. 游戏客户端开发 (Unity 6 AI Workflow 2026)
2. Python 开发 (DBOS/Temporal 工作流)
3. 游戏客户端自动化测试 (Playwright 高级)
4. 开发者工具 (GitHub 自动化)

### 统计概览

| 指标 | 数值 |
|------|------|
| Skills 总数 | 970+ |
| 支持平台 | 10+ |
| 最新版本 | V6.8.0 (2026-03-02) |

---

## 🎮 游戏客户端开发 Skills

### 核心 Skills 矩阵

| Skill ID | 名称 | 核心能力 | 适用引擎 | 评分 |
|----------|------|---------|---------|------|
| unity-developer | Unity 6 LTS 专家 | URP/HDRP、跨平台部署 | Unity | ⭐⭐⭐⭐⭐ |
| unity-ai-workflow | Unity AI Workflow 2026 | Dev Modes、AI 辅助开发 | Unity 6.2+ | ⭐⭐⭐⭐⭐ |
| unity-ecs-patterns | DOTS/ECS 架构 | Jobs System、Burst | Unity | ⭐⭐⭐⭐⭐ |
| unreal-engine-cpp-pro | UE5 C++ 开发 | UObject、网络同步 | Unreal | ⭐⭐⭐⭐⭐ |
| godot-gdscript-patterns | Godot 4 专家 | GDScript 2.0、信号系统 | Godot | ⭐⭐⭐⭐ |
| bevy-ecs-expert | Bevy ECS | Rust 游戏引擎 | Bevy | ⭐⭐⭐⭐⭐ |
| game-development | 游戏开发编排器 | 自动路由到子 Skills | 通用 | ⭐⭐⭐⭐ |

### Unity AI Workflow 2026 (新增)

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

#### 三大开发模式

| 模式 | 角色 | 适用场景 |
|------|------|---------|
| **Assistant** | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| **Mix (默认)** | 协作模式，AI 建议，你确认 | 大多数项目 |
| **Automatic** | AI 构建，短的 onboarding Q&A | 快速原型、游戏 jam |

#### 核心哲学: Game Feel 不是可选的

- 每项功能使用 `/implement-feature` 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

#### 技术架构

- **TCREI Prompting**: Task-Context-References-Evaluate-Iterate 方法论
- **验证系统**: 每个 AI 推荐标记 [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED]
- **专家 Skills**: UI Toolkit、ScriptableObject、Netcode、game feel、测试、调试

#### 项目阶段

```
1. 00: Ideation — 从想法到 GDD + GFD
2. 01: Pre-Production — 技术选型、栈定义、命名规范
3. 02: Technical Design — 架构、程序集定义、模式
4. 03: Project Setup — 自动文件夹脚手架和包安装
5. 04: Production — 特性循环 (interrogate → implement → feel → commit)
6. 05: Polish — 最终调优、视觉细化、性能分析
```

### 网络同步专题

| 技术点 | 说明 |
|--------|------|
| 帧同步 | 相同输入 → 相同输出，确定性 |
| 状态同步 | 服务器权威，状态差异同步 |
| 延迟补偿 | Jitter: 0-200ms, 丢包: 5%-20% |
| 客户端预测 | 本地先行，回滚机制 |

---

## 🐍 Python 开发 Skills

### Python Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| python-pro | Python 3.12+ 专家 | 现代特性、生产级实践 | ⭐⭐⭐⭐⭐ |
| python-fastapi-development | FastAPI 开发 | SQLAlchemy、Pydantic | ⭐⭐⭐⭐⭐ |
| async-python-patterns | 异步编程 | asyncio、高并发 | ⭐⭐⭐⭐ |
| dbos-python | DBOS 工作流 | 持久化工作流、容错 | ⭐⭐⭐⭐⭐ |
| temporal-python-pro | Temporal 工作流 | 分布式事务、Saga 模式 | ⭐⭐⭐⭐⭐ |
| temporal-python-testing | Temporal 测试 | 时间跳跃、Mock | ⭐⭐⭐⭐ |
| python-patterns | 设计模式 | 类型提示、最佳实践 | ⭐⭐⭐⭐ |
| python-performance-optimization | 性能优化 | cProfile、py-spy | ⭐⭐⭐⭐ |
| python-testing-patterns | 测试模式 | pytest、fixtures、TDD | ⭐⭐⭐⭐⭐ |
| python-packaging | PyPI 发布 | 包管理、版本控制 | ⭐⭐⭐⭐ |
| python-development-python-scaffold | 项目脚手架 | uv 工具链 | ⭐⭐⭐⭐ |

### DBOS Python (新增)

**项目地址**: [dbos-inc/dbos-transact-py](https://github.com/dbos-inc/dbos-transact-py)

DBOS (Database-Oriented Operating System) 是一个用于构建可靠容错应用的 Python SDK。

#### 核心特性

```python
# 工作流和步骤
@DBOS.step()
def call_external_api():
    return requests.get("https://api.example.com").json()

@DBOS.workflow()
def my_workflow():
    result = call_external_api()
    return result
```

#### 关键约束

- 任何执行复杂操作或访问外部服务的函数必须是 step
- 工作流必须是确定性的 - 非确定性操作放在 step 中
- 不要从 step 中调用 `DBOS.start_workflow` 或 `DBOS.recv`
- 不要使用线程启动工作流 - 使用 `DBOS.start_workflow` 或队列

#### 应用场景

- 分布式事务处理
- 长时间运行的工作流
- 需要持久化和容错的业务流程
- 微服务间协调

### Temporal Python Pro

**核心模式**:

```python
# 1. Async Activities (asyncio)
@activity.defn
async def async_activity():
    return await async_api_call()

# 2. Sync Multithreaded (ThreadPoolExecutor)
@activity.defn
def sync_activity():
    return sync_db_query()

# 3. Sync Multiprocess (ProcessPoolExecutor)
@activity.defn
def cpu_intensive_activity():
    return heavy_computation()
```

#### Saga 模式

```python
@workflow.defn
class OrderSagaWorkflow:
    @workflow.run
    async def run(self, order_id: str) -> str:
        # 补偿事务模式
        try:
            result = await self.reserve_inventory(order_id)
            result = await self.process_payment(order_id)
            result = await self.ship_order(order_id)
            return "success"
        except Exception:
            await self.refund_payment(order_id)
            await self.release_inventory(order_id)
            return "compensated"
```

### 现代工具链

| 工具 | 用途 | 性能 |
|------|------|------|
| **uv** | 包管理器 | 10-100x pip |
| **ruff** | 格式化/lint | 替代 black/isort/flake8 |
| **mypy/pyright** | 类型检查 | 严格模式 |
| **pyproject.toml** | 项目配置 | 现代标准 |

---

## 🧪 自动化测试 Skills

### 测试 Skills 矩阵

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| playwright-skill | Playwright 浏览器自动化 | E2E 测试、可视化 | ⭐⭐⭐⭐⭐ |
| e2e-testing-patterns | E2E 测试模式 | 最佳实践 | ⭐⭐⭐⭐ |
| e2e-testing | Cypress E2E | 端到端测试 | ⭐⭐⭐⭐ |
| python-testing-patterns | pytest 测试 | 单元/集成测试 | ⭐⭐⭐⭐⭐ |
| ai-test-automation | AI 驱动测试 | 自愈测试 | ⭐⭐⭐⭐⭐ |
| testing-qa | 综合 QA 工作流 | 完整流程 | ⭐⭐⭐⭐⭐ |
| tdd-orchestrator | TDD 协调器 | 红绿重构 | ⭐⭐⭐⭐ |
| android_ui_verification | Android UI 测试 | ADB 自动化 | ⭐⭐⭐⭐ |

### Playwright 高级特性 (skill-skill)

#### 核心工作流

```bash
# Step 1: 自动检测开发服务器
cd $SKILL_DIR && node -e "require('./lib/helpers').detectDevServers()"

# Step 2: 编写测试脚本到 /tmp
# /tmp/playwright-test-example.js

# Step 3: 执行测试
cd $SKILL_DIR && node run.js /tmp/playwright-test-example.js
```

#### 高级特性

- ✅ 自动检测开发服务器
- ✅ 测试脚本写入 /tmp (不污染项目)
- ✅ 默认可见浏览器 (headless: false)
- ✅ URL 参数化配置
- ✅ 智能等待策略
- ✅ 自定义 HTTP 头
- ✅ Cookie 横幅处理

#### 自定义 HTTP 头

```bash
# 单个头信息
PW_HEADER_NAME=X-Automated-By PW_HEADER_VALUE=playwright-skill \
  cd $SKILL_DIR && node run.js /tmp/my-script.js

# 多个头信息 (JSON 格式)
PW_EXTRA_HEADERS='{"X-Automated-By":"playwright-skill","X-Debug":"true"}' \
  cd $SKILL_DIR && node run.js /tmp/my-script.js
```

### TDD 开发流程

| 阶段 | 动作 | 必须执行 |
|------|------|---------|
| RED | 写失败的测试 | ✅ |
| VERIFY | 验证失败原因 | ✅ |
| GREEN | 最小代码通过 | ✅ |
| VERIFY | 验证测试通过 | ✅ |
| REFACTOR | 重构改进 | 可选 |

**TDD 铁律**: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

### 游戏客户端测试方案

| 测试类型 | 工具 | 适用场景 |
|---------|------|---------|
| 单元测试 | Unity Test Framework, pytest | 游戏逻辑验证 |
| 集成测试 | Playwright, Selenium | 客户端与服务端交互 |
| UI测试 | Playwright, Appium | 游戏UI交互 |
| 性能测试 | Unity Profiler, RenderDoc | 帧率、内存测试 |
| 回归测试 | CI/CD + Playwright | 版本发布验证 |

---

## 🛠️ 开发者工具 Skills

### DevOps Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| workflow-automation | CI/CD 流水线 | GitHub Actions/GitLab CI | ⭐⭐⭐⭐⭐ |
| deployment-engineer | 部署工程师 | GitOps、Docker | ⭐⭐⭐⭐⭐ |
| docker-expert | Docker 专家 | 容器化最佳实践 | ⭐⭐⭐⭐⭐ |
| debugging-strategies | 系统化调试 | 二分搜索、日志分析 | ⭐⭐⭐⭐⭐ |
| bug-fixing-workflow | Bug 修复工作流 | 系统化修复 | ⭐⭐⭐⭐ |
| dependency-upgrade | 依赖升级 | 安全更新 | ⭐⭐⭐⭐ |
| dev-environment-setup | 开发环境配置 | 一键配置 | ⭐⭐⭐⭐ |
| git-advanced-workflows | Git 高级工作流 | Rebase、Cherry-pick | ⭐⭐⭐⭐ |
| git-pr-workflows | PR 工作流 | 代码审查、PR 创建 | ⭐⭐⭐⭐ |
| github-actions-templates | GitHub Actions 模板 | 自动化模板 | ⭐⭐⭐⭐ |

### GitHub 自动化 Skills

#### github-automation

- 仓库管理 (创建/删除/分支保护)
- Issue 管理 (创建/关闭/标签/指派)
- Pull Request (创建/审查/自动合并)
- Actions (触发工作流/查看状态)

#### github-workflow-automation

- PR 自动审查
- Issue 分类
- 自动标签
- 发布管理

#### git-advanced-workflows

- Rebasing 高级技巧
- Cherry-picking
- Bisect 二分查找
- Worktrees 多工作区
- Reflog 恢复

### CI/CD 平台支持

- **GitHub Actions**: YML 配置、Matrix 构建、依赖缓存
- **GitLab CI**: .gitlab-ci.yml、Runner 配置、Auto DevOps
- **其他**: Azure DevOps, Jenkins, CircleCI, Tekton

### 调试策略

```
系统化调试流程:
1. 重现问题 → 捕获日志/追踪/环境详情
2. 形成假设 → 设计受控实验
3. 缩小范围 → 二分法定位、针对性检测
4. 记录发现 → 验证修复
```

---

## 💡 推荐 Skills 组合

### 游戏开发组合

```
推荐: /game-development (编排器，自动路由)
     /unity-developer + /unity-ai-workflow (2026 新版)
     /unity-ecs-patterns + /multiplayer
     /godot-gdscript-patterns + /2d-games
     /unreal-engine-cpp-pro + /glsl-shaders
     /bevy-ecs-expert (Rust 游戏引擎)
```

### Python 后端开发组合

```
推荐: /python-pro + /python-fastapi-development + /python-testing-patterns
     /dbos-python + /python-testing-patterns (DBOS 工作流)
     /temporal-python-pro + /temporal-python-testing (Temporal 工作流)
     /fastapi-pro + /async-python-patterns + /python-performance-optimization
```

### 测试组合

```
推荐: /playwright-skill + /e2e-testing-patterns + /testing-qa
     /python-testing-patterns + /test-driven-development
     /ai-test-automation (AI 驱动测试)
     /android_ui_verification (移动端测试)
```

### DevOps 组合

```
推荐: /workflow-automation + /deployment-engineer + /debugging-strategies
     /github-automation + /github-workflow-automation
     /git-advanced-workflows + /git-pr-workflows
     /dependency-upgrade + /docker-expert
```

---

## 🚀 实战案例

### 案例 1: 使用 Skills 开发帧同步游戏后端

```bash
# 1. 项目初始化
>> /python-pro 创建一个新的 Python 项目，使用 uv 管理依赖

# 2. FastAPI 开发
>> /fastapi-pro 设计帧同步游戏的 REST API

# 3. 异步处理
>> /async-python-patterns 实现游戏房间管理，高并发

# 4. 工作流编排 (可选)
>> /temporal-python-pro 实现游戏状态持久化工作流

# 5. 测试
>> /python-testing-patterns 编写房间管理测试
>> /test-driven-development 使用 TDD 开发新功能

# 6. 部署
>> /deployment-engineer 设置 Docker 部署
>> /workflow-automation 配置 CI/CD
```

### 案例 2: 使用 Skills 测试游戏 Web 管理后台

```bash
# 1. Playwright 测试
>> /playwright-skill 测试登录流程
>> /playwright-skill 测试响应式设计

# 2. E2E 测试
>> /e2e-testing-patterns 测试用户注册流程
>> /e2e-testing-patterns 测试房间管理

# 3. 质量保证
>> /testing-qa 建立完整 QA 流程
```

### 案例 3: 使用 Skills 优化开发流程

```bash
# 1. 环境设置
>> /dev-environment-setup 配置开发环境

# 2. Git 工作流
>> /git-advanced-workflows 使用 rebase 整理提交历史
>> /git-pr-workflows 创建高质量 PR

# 3. 调试
>> /debugging-strategies 分析这个错误

# 4. Bug 修复
>> /bug-fixing-workflow 系统化修复这个 bug

# 5. 依赖管理
>> /dependency-upgrade 升级项目依赖
```

---

## 📦 安装指南

### 默认安装 (Antigravity)

```bash
npx antigravity-awesome-skills
```

### Claude Code

```bash
npx antigravity-awesome-skills --claude
```

### Gemini CLI

```bash
npx antigravity-awesome-skills --gemini
```

### Codex CLI

```bash
npx antigravity-awesome-skills --codex
```

### Cursor

```bash
npx antigravity-awesome-skills --cursor
```

---

## 🔧 使用方式

### Claude Code

```bash
>> /skill-name 帮助我...
```

### Gemini CLI/Codex CLI

```bash
Use @skill-name to help me...
```

### Cursor

```bash
@skill-name in chat
```

---

## 📚 相关资源

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Unity AI Workflow 2026](https://github.com/David-GD13/unity-ai-workflow)
- [DBOS Python SDK](https://docs.dbos.dev/)
- [Temporal Python SDK](https://docs.temporal.io/)
- [官方 Skills 目录](../CATALOG.md)
- [Skills 使用指南](../docs/USAGE.md)
- [Bundles 精选](../docs/BUNDLES.md)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)

---

**文档更新时间**: 2026-03-04  
**Claude Code Skills 调研 - 第十二周**
