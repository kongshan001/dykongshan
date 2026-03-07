# Claude Code Skills 调研报告 - 第十三周

**调研日期**: 2026-03-04  
**技能来源**: Antigravity Awesome Skills (970+ Skills) + 社区精选  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本周继续深入分析 Claude Code 热门 Skills，优先调研以下方向：
1. 游戏客户端开发 (Unity 6 AI Workflow 2026)
2. Python 开发 (异步/测试/工具链)
3. 游戏客户端自动化测试 (Unity/移动端)
4. 其他开发者工具 (GitHub/CI/CD)

### 统计概览

| 指标 | 数值 |
|------|------|
| Skills 总数 | 970+ |
| 支持平台 | 10+ |
| 最新版本 | V6.8.0 (2026-03-02) |

---

## 🎮 游戏客户端开发 Skills

### 核心 Skills 矩阵 (最新搜索结果)

| Skill ID | 名称 | 核心能力 | 适用引擎 | 评分 |
|----------|------|---------|---------|------|
| openclaw-godot-skill | Godot Skill | 场景管理、节点操作、输入模拟 | Godot | ⭐⭐⭐⭐⭐ (0.911) |
| the-flip-publish | The Flip Publish | 游戏发布 | 通用 | ⭐⭐⭐⭐⭐ (0.985) |
| clawland | Clawland | 游戏 Land | 通用 | ⭐⭐⭐⭐⭐ (0.957) |
| clawplay-skill | ClawPlay | 游戏播放 | 通用 | ⭐⭐⭐ (0.720) |
| agent-rpg | Agent RPG | RPG 游戏开发 | 通用 | ⭐⭐⭐⭐ (0.809) |

| Skill ID | 名称 | 核心能力 | 适用引擎 | 评分 |
|----------|------|---------|---------|------|
| unity-developer | Unity 6 LTS 专家 | URP/HDRP、跨平台部署 | Unity | ⭐⭐⭐⭐⭐ |
| unity-ai-workflow | Unity AI Workflow 2026 | Dev Modes、AI 辅助开发 | Unity 6.2+ | ⭐⭐⭐⭐⭐ |
| unity-ecs-patterns | DOTS/ECS 架构 | Jobs System、Burst | Unity | ⭐⭐⭐⭐⭐ |
| unreal-engine-cpp-pro | UE5 C++ 开发 | UObject、网络同步 | Unreal | ⭐⭐⭐⭐⭐ |
| godot-gdscript-patterns | Godot 4 专家 | GDScript 2.0、信号系统 | Godot | ⭐⭐⭐⭐ |
| bevy-ecs-expert | Bevy ECS | Rust 游戏引擎 | Bevy | ⭐⭐⭐⭐⭐ |
| game-development | 游戏开发编排器 | 自动路由到子 Skills | 通用 | ⭐⭐⭐⭐ |
| multiplayer | 多人游戏 | 网络同步、延迟补偿 | 通用 | ⭐⭐⭐⭐⭐ |

### Unity AI Workflow 2026 深入解析

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

#### 三大开发模式

| 模式 | 角色 | 适用场景 |
|------|------|---------|
| **Assistant** | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| **Mix (默认)** | 协作模式，AI 建议，你确认 | 大多数项目 |
| **Automatic** | AI 构建，短的 onboarding Q&A | 快速原型、游戏 jam |

#### 核心哲学: Game Feel 不是可选的

```markdown
每项功能使用 /implement-feature 完整构建:
1. Interrogate (询问): AI 询问 VFX、SFX、相机反馈和触觉
2. Implement (实现): 编写功能代码
3. Feel (打磨): 迭代游戏手感
4. Commit (提交): 代码提交

迭代打磨不是单独阶段，而是贯穿整个开发流程
```

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

| 技术点 | 说明 | 实现方式 |
|--------|------|---------|
| **帧同步** | 相同输入 → 相同输出，确定性 | 客户端预测 + 服务器验证 |
| **状态同步** | 服务器权威，状态差异同步 | 快照插值 + 预测 |
| **延迟补偿** | Jitter: 0-200ms, 丢包: 5%-20% | 客户端插值 + 服务器回溯 |
| **客户端预测** | 本地先行，回滚机制 | 确定性锁步 |

#### 帧同步实现要点

```csharp
// 确定性帧循环
public class FrameSyncManager
{
    public void Update()
    {
        // 1. 收集输入
        var inputs = CollectInputs();
        
        // 2. 发送到服务器
        network.SendFrameInput(inputs);
        
        // 3. 执行帧逻辑 (确定性)
        ExecuteFrame(inputs);
        
        // 4. 渲染插值
        RenderInterpolate();
    }
}
```

### ECS/DOTS 架构 (Unity)

| 组件 | 用途 | 优势 |
|------|------|------|
| **Entities** | 数据容器 | 内存连续访问 |
| **Components** | 数据组件 | 组合优于继承 |
| **Systems** | 逻辑系统 | 并行执行 |
| **Jobs** | 多线程 | Burst 编译加速 |
| **Burst** | LLVM 编译器 | SIMD 优化 |

---

## 🐍 Python 开发 Skills

### Python Skills 完整列表 (最新搜索结果)

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| python-executor | Python Executor | 安全沙箱执行 Python 代码 | ⭐⭐⭐⭐⭐ (3.479) |
| python-dataviz | Python Dataviz | 数据可视化 | ⭐⭐⭐⭐⭐ (3.427) |
| python-sdk | Python SDK | Python SDK 开发 | ⭐⭐⭐⭐⭐ (3.333) |
| lsp-python | LSP Python | 语言服务器协议 | ⭐⭐⭐⭐⭐ (3.279) |
| python-script-generator | Python Script Generator | 脚本生成 | ⭐⭐⭐⭐ (3.205) |

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| python-pro | Python 3.12+ 专家 | 现代特性、生产级实践 | ⭐⭐⭐⭐⭐ |
| python-fastapi-development | FastAPI 开发 | SQLAlchemy、Pydantic | ⭐⭐⭐⭐⭐ |
| async-python-patterns | 异步编程 | asyncio、高并发 | ⭐⭐⭐⭐ |
| dbos-python | DBOS 工作流 | 持久化工作流、容错 | ⭐⭐⭐⭐⭐ |
| temporal-python-pro | Temporal 工作流 | 分布式事务、Saga 模式 | ⭐⭐⭐⭐⭐ |
| python-patterns | 设计模式 | 类型提示、最佳实践 | ⭐⭐⭐⭐ |
| python-performance-optimization | 性能优化 | cProfile、py-spy | ⭐⭐⭐⭐ |
| python-testing-patterns | 测试模式 | pytest、fixtures、TDD | ⭐⭐⭐⭐⭐ |
| uv-python | uv 包管理器 | 10-100x pip | ⭐⭐⭐⭐⭐ |
| ruff-linter | Ruff 代码检查 | 极速 linting | ⭐⭐⭐⭐⭐ |

### 异步 Python 最佳实践

#### 核心模式

```python
# 1. 基础 async/await
async def fetch_data(url: str) -> dict:
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

# 2. 并发任务管理
async def concurrent_fetch(urls: list[str]) -> list[dict]:
    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(fetch_data(url)) for url in urls]
    return [task.result() for task in tasks]

# 3. 异步生成器
async def async_data_stream():
    for i in range(100):
        await asyncio.sleep(0.1)
        yield {"index": i, "data": compute(i)}
```

#### 生产级模式

| 模式 | 用途 | 示例 |
|------|------|------|
| **Semaphore** | 限流 | API 调用限制 |
| **Timeout** | 超时控制 | 防止无限等待 |
| **TaskGroup** | 资源管理 | 优雅并发 |
| **Queue** | 生产者/消费者 | 消息处理 |

### uv 工具链 (2024/2025 最快)

```bash
# 安装 uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 创建项目
uv init my-project

# 添加依赖
uv add fastapi pytest

# 运行脚本
uv run main.py

# 虚拟环境管理
uv venv
uv sync
uv pip install -r requirements.txt
```

### FastAPI 生产级模式

```python
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel

app = FastAPI(title="Game Frame Sync API")

class RoomCreate(BaseModel):
    name: str
    max_players: int = 8

@app.post("/rooms", response_model=RoomResponse)
async def create_room(
    room: RoomCreate,
    db: AsyncSession = Depends(get_db)
):
    # 业务逻辑
    result = await db.execute(select(Room).where(Room.name == room.name))
    if result.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Room exists")
    
    new_room = Room(**room.model_dump())
    db.add(new_room)
    await db.commit()
    return new_room
```

---

## 🧪 自动化测试 Skills

### 测试 Skills 矩阵 (最新搜索结果)

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| test-runner | Test Runner | 测试运行器 | ⭐⭐⭐⭐⭐ (1.239) |
| playwright-mcp | Playwright MCP | Playwright MCP 集成 | ⭐⭐⭐⭐⭐ (1.165) |
| playwright-scraper-skill | Playwright Scraper | 网页抓取 | ⭐⭐⭐⭐⭐ (1.161) |
| e2e-testing-patterns | E2E Testing Patterns | 端到端测试模式 | ⭐⭐⭐⭐⭐ (1.151) |
| test-master | Test Master | 测试大师 | ⭐⭐⭐⭐⭐ (1.138) |
| playwright | Playwright | 浏览器自动化 | ⭐⭐⭐⭐⭐ (1.114) |
| playwright-browser-automation | Playwright Browser | 浏览器自动化 | ⭐⭐⭐⭐⭐ (1.092) |
| test-patterns | Test Patterns | 测试模式 | ⭐⭐⭐⭐ (1.056) |
| web-qa-bot | Web QA Bot | Web QA 机器人 | ⭐⭐⭐⭐ (1.027) |
| api-tester | API Tester | API 测试 | ⭐⭐⭐⭐ (1.006) |

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| playwright-skill | Playwright 浏览器自动化 | E2E 测试、可视化 | ⭐⭐⭐⭐⭐ |
| e2e-testing-patterns | E2E 测试模式 | 最佳实践 | ⭐⭐⭐⭐ |
| python-testing-patterns | pytest 测试 | 单元/集成测试 | ⭐⭐⭐⭐⭐ |
| ai-test-automation | AI 驱动测试 | 自愈测试 | ⭐⭐⭐⭐⭐ |
| testing-qa | 综合 QA 工作流 | 完整流程 | ⭐⭐⭐⭐⭐ |
| tdd-orchestrator | TDD 协调器 | 红绿重构 | ⭐⭐⭐⭐ |
| android_ui_verification | Android UI 测试 | ADB 自动化 | ⭐⭐⭐⭐ |
| unity-test-framework | Unity 单元测试 | Edit Mode/Play Mode | ⭐⭐⭐⭐⭐ |

### Unity Test Framework 详解

#### 测试类型

| 类型 | 运行环境 | 用途 | 性能 |
|------|---------|------|------|
| **Edit Mode** | 编辑器 | 纯 C# 逻辑测试 | 快 |
| **Play Mode** | 游戏运行 | 集成测试 | 慢 |

#### 核心组件

```csharp
// 单元测试 (Edit Mode)
[Test]
public void CalculateDamage_Test()
{
    var calculator = new DamageCalculator();
    int damage = calculator.Calculate(attack: 100, defense: 50);
    
    Assert.AreEqual(50, damage);
}

// 集成测试 (Play Mode)
[UnityTest]
public IEnumerator PlayerMove_IntegrationTest()
{
    var player = new GameObject("Player");
    var mover = player.AddComponent<PlayerMover>();
    
    mover.Move(Vector2.right);
    
    yield return null; // 等待一帧
    
    Assert.AreEqual(Vector2.right, mover.Velocity);
}
```

#### 最佳实践

1. **分离测试类型**: 单元测试 (Edit Mode) vs 集成测试 (Play Mode)
2. **使用 ScriptableObject**: 存储测试数据，便于复用
3. **使用 Addressables**: 加载测试资源，避免硬编码路径
4. **CI 集成**: GitHub Actions 自动运行测试

### 游戏客户端测试专题

#### 网络同步测试

```csharp
// 帧同步确定性测试
[Test]
public void FrameSync_DeterministicTest()
{
    // 给定相同输入
    var input1 = new FrameInput { direction = Vector2.right, attack = true };
    var input2 = new FrameInput { direction = Vector2.right, attack = true };
    
    // 执行帧逻辑
    var state1 = ExecuteFrame(initialState, input1);
    var state2 = ExecuteFrame(initialState, input2);
    
    // 验证结果相同
    Assert.AreEqual(state1.playerPosition, state2.playerPosition);
    Assert.AreEqual(state1.health, state2.health);
}
```

#### 延迟模拟

| 场景 | 延迟配置 | 丢包率 |
|------|---------|--------|
| 良好网络 | 50ms | 0% |
| 一般网络 | 100-200ms | 1-5% |
| 弱网络 | 200-500ms | 5-20% |
| 极端情况 | >500ms | >20% |

### Playwright 高级特性

```typescript
// 智能等待
await page.waitForSelector('[data-testid="game-start"]', { 
  state: 'visible',
  timeout: 10000 
});

// 截图验证
await expect(page.locator('.game-board')).toHaveScreenshot('game-board.png');

// API Mock
await page.route('**/api/game/*', route => {
  route.fulfill({
    json: { status: 'ready', players: 2 }
  });
});
```

---

## 🛠️ 开发者工具 Skills

### DevOps Skills 完整列表 (最新搜索结果)

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| github | GitHub | GitHub 自动化 | ⭐⭐⭐⭐⭐ (1.309) |
| kubernetes | Kubernetes | K8s 集群管理 | ⭐⭐⭐⭐⭐ (1.180) |
| docker-essentials | Docker Essentials | Docker 基础 | ⭐⭐⭐⭐⭐ (1.172) |
| docker | Docker | Docker 完整功能 | ⭐⭐⭐⭐⭐ (1.081) |
| gitflow | GitFlow | GitFlow 工作流 | ⭐⭐⭐⭐⭐ (1.033) |
| gh | gh | GitHub CLI | ⭐⭐⭐⭐⭐ (1.027) |
| docker-sandbox | Docker Sandbox | Docker 沙箱 | ⭐⭐⭐⭐⭐ (1.026) |
| container-debug | Container Debug | 容器调试 | ⭐⭐⭐⭐⭐ (1.017) |
| cicd-pipeline | CI/CD Pipeline | 持续集成/部署 | ⭐⭐⭐⭐⭐ (1.008) |
| kubectl | kubectl | K8s 命令行 | ⭐⭐⭐⭐ (0.996) |
| gitclassic | GitClassic | Git 经典操作 | ⭐⭐⭐⭐ (0.993) |
| docker-ctl | Docker Ctl | Docker 控制 | ⭐⭐⭐⭐ (0.992) |
| k8-multicluster | K8s MultiCluster | 多集群管理 | ⭐⭐⭐⭐ (0.984) |
| k8s-browser | K8s Browser | K8s 浏览器管理 | ⭐⭐⭐⭐ (0.981) |

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| workflow-automation | CI/CD 流水线 | GitHub Actions/GitLab CI | ⭐⭐⭐⭐⭐ |
| deployment-engineer | 部署工程师 | GitOps、Docker | ⭐⭐⭐⭐⭐ |
| docker-expert | Docker 专家 | 容器化最佳实践 | ⭐⭐⭐⭐⭐ |
| debugging-strategies | 系统化调试 | 二分搜索、日志分析 | ⭐⭐⭐⭐⭐ |
| bug-fixing-workflow | Bug 修复工作流 | 系统化修复 | ⭐⭐⭐⭐ |
| git-advanced-workflows | Git 高级工作流 | Rebase、Cherry-pick | ⭐⭐⭐⭐ |
| github-automation | GitHub 自动化 | PR/Issue/Workflow | ⭐⭐⭐⭐⭐ |

### GitHub Actions 最佳实践

```yaml
name: Game Frame Sync CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
          
      - name: Install uv
        uses: astral-sh/setup-uv@v4
        
      - name: Install dependencies
        run: uv sync
        
      - name: Run tests
        run: uv run pytest
        
      - name: Upload coverage
        uses: codecov/codecov-action@v4
```

### 系统化调试流程

```
1. 重现问题
   ├── 捕获完整日志
   ├── 记录环境详情
   └── 最小复现步骤

2. 形成假设
   ├── 分析错误堆栈
   ├── 定位相关代码
   └── 设计受控实验

3. 缩小范围
   ├── 二分查找法
   ├── 针对性检测
   └── 日志追踪

4. 验证修复
   ├── 确认修复有效
   ├── 检查副作用
   └── 记录发现
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
     /async-python-patterns + /uv-python + /ruff-linter
     /dbos-python + /python-testing-patterns (DBOS 工作流)
     /temporal-python-pro + /temporal-python-testing (Temporal 工作流)
```

### 测试组合

```
推荐: /playwright-skill + /e2e-testing-patterns + /testing-qa
     /python-testing-patterns + /test-driven-development
     /ai-test-automation (AI 驱动测试)
     /unity-test-framework (Unity 客户端测试)
```

### DevOps 组合

```
推荐: /workflow-automation + /deployment-engineer + /debugging-strategies
     /github-automation + /github-workflow-automation
     /git-advanced-workflows + /git-pr-workflows
     /docker-expert + /dependency-upgrade
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

### 案例 2: 使用 Skills 开发 Unity 游戏

```bash
# 1. 项目初始化
>> /unity-ai-workflow 创建一个新游戏项目

# 2. 选择开发模式
>> /setup-project 选择 Mix 模式

# 3. 开发功能
>> /implement-feature 玩家移动系统

# 4. 实现 ECS
>> /unity-ecs-patterns 设计敌人 AI 系统

# 5. 网络同步
>> /multiplayer 实现帧同步

# 6. 测试
>> /unity-test-framework 编写敌人 AI 测试
```

### 案例 3: 使用 Skills 测试游戏 Web 管理后台

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
- [uv 包管理器](https://github.com/astral-sh/uv)
- [ruff 工具](https://github.com/astral-sh/ruff)
- [官方 Skills 目录](../CATALOG.md)
- [Skills 使用指南](../docs/USAGE.md)
- [Bundles 精选](../docs/BUNDLES.md)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)

---

**文档更新时间**: 2026-03-04 (新增最新 ClawHub 搜索结果)
**Claude Code Skills 调研 - 第十三周**
