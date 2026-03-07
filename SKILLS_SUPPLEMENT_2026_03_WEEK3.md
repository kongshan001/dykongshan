# Claude Code Skills 补充调研报告 (2026年3月 第三周)

> 基于 Antigravity Awesome Skills (970+ Skills) 和 Claude Code 社区最新发布的 Skills

---

## 调研背景

本次调研继续分析 Claude Code 热门 Skills，重点关注：
1. **游戏客户端开发** - Unity/Godot/Unreal 主流引擎 + Unity AI Workflow 2026
2. **Python 开发** - 现代 Python 3.12+ 工具链 + uv/Ruff 工具链
3. **游戏客户端自动化测试** - Unity Test Framework + 网络同步测试 + 性能基准
4. **其他开发者工具** - GitHub/GitLab 自动化、CI/CD、浏览器自动化

---

## 一、游戏客户端开发 Skills 补充

### 1.1 Unity AI Workflow 2026 详解

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)
**GitHub Stars**: 4⭐ (2026-03 新增)

这是专为 Claude Code 和 Google Antigravity IDE 设计的 Unity 6.2+ AI 开发工作流，代表了 2026 年游戏开发自动化的最新趋势。

#### 核心特性

| 特性 | 说明 |
|------|------|
| **Dev Modes** | Assistant/Mix/Automatic 三种开发模式，适应不同开发需求 |
| **Game Feel** | 强调游戏手感，AI 实现前必须询问 VFX/SFX/相机反馈/触觉 |
| **TCREI** | Task-Context-References-Evaluate-Iterate 方法论 |
| **验证系统** | [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED] 标记，标注 AI 推荐的可信度 |

#### 开发阶段

```markdown
00: Ideation — 从想法到 GDD (Game Design Document) + GFD (Game Feel Document)
01: Pre-Production — 技术选型、栈定义、命名规范
02: Technical Design — 架构、程序集定义、模式
03: Project Setup — 自动文件夹脚手架和包安装
04: Production — 特性循环 (interrogate → implement → feel → commit)
05: Polish — 最终调优、视觉细化、性能分析
```

#### 适用场景

- ✅ Unity 6.2+ 项目开发
- ✅ AI 辅助游戏开发工作流
- ✅ 团队协作开发规范
- ✅ 快速原型和游戏 jam
- ✅ game-frame-sync 这类帧同步项目的架构设计

### 1.2 Multiplayer 游戏开发专题

#### 架构决策树

```
What type of multiplayer?
│
├── Competitive / Real-time
│   └── Dedicated Server (authoritative)
│
├── Cooperative / Casual
│   └── Host-based (one player is server)
│
├── Turn-based
│   └── Client-server (simple)
│
└── Massive (MMO)
    └── Distributed servers
```

#### 架构对比

| 架构 | 延迟 | 成本 | 安全性 | 适用场景 |
|------|------|------|--------|---------|
| **专属服务器** | 低 | 高 | 强 | MOBA、MMO、FPS |
| **P2P** | 变化 | 低 | 弱 | 休闲对战 |
| **主机模式** | 中 | 低 | 中 | 本地多人 |

#### 同步原理

| 方案 | 同步内容 | 适用场景 |
|------|---------|---------|
| **状态同步** | 游戏状态 | 简单，物体少 |
| **输入同步** | 玩家输入 | 动作游戏 |
| **帧同步** | 确定性帧 | 格斗/RTS |

#### 延迟补偿技术

```markdown
### 核心技术
- 预测 (Prediction): 客户端预测服务器结果
- 插值 (Interpolation): 平滑远程玩家表现
- 调解 (Reconciliation): 修正错误预测
- 延迟补偿 (Lag Compensation): 回滚用于命中检测

### 反作弊原则
- 速度作弊 → 服务器验证移动
- 自瞄 → 服务器验证视线
- 物品复制 → 服务器拥有库存
- 穿墙 → 不发送隐藏数据
```

### 1.3 Unity ECS Patterns 深入

#### ECS 架构核心概念

```csharp
// Entity: 唯一ID的游戏对象
// Component: 数据容器
public struct Transform : IComponentData {
    public float3 Position;
    public float3 Rotation;
    public float3 Scale;
}

public struct Velocity : IComponentData {
    public float3 Value;
}

// System: 逻辑处理
public partial struct MovementSystem : ISystem {
    public void OnUpdate(ref SystemState state) {
        foreach (var (transform, velocity) in 
                 SystemAPI.Query<RefRW<Transform>, RefRO<Velocity>>()) {
            transform.ValueRW.Position += velocity.ValueRO.Value * SystemAPI.Time.DeltaTime;
        }
    }
}
```

#### Jobs System 最佳实践

```csharp
// IJobEntity: 并行处理实体
[BurstCompile]
public partial struct ParallelJob : IJobEntity {
    public float DeltaTime;
    
    void Execute(ref Transform transform, in Velocity velocity) {
        transform.Position += velocity.Value * DeltaTime;
    }
}

// 调度
var job = new ParallelJob { DeltaTime = SystemAPI.Time.DeltaTime };
job.ScheduleParallel();
```

#### 适用场景

- ✅ 高性能游戏逻辑处理
- ✅ 大规模实体管理 (1000+ 同屏实体)
- ✅ 游戏 frame-sync 帧同步逻辑
- ✅ 物理计算优化

---

## 二、Python 开发 Skills 补充

### 2.1 uv 包管理器 (2024-2025 最快)

**项目地址**: [astral-sh/uv](https://github.com/astral-sh/uv)
**GitHub Stars**: 30k+ ⭐

uv 是用 Rust 编写的超快 Python 包管理器，比 pip 快 10-100 倍。

```bash
# 安装
curl -LsSf https://astral.sh/uv/install.sh | sh

# 项目初始化
uv init my-project
uv venv
uv pip install -r requirements.txt

# 性能对比
# uv: 10-100x faster than pip
# 仓库创建: 35ms vs 700ms
# 依赖解析: 100ms vs 30s
```

### 2.2 Ruff (Python Linting)

**GitHub Stars**: 28k+ ⭐

Ruff 是用 Rust 编写的超快 Python linter，替代 black/isort/flake8。

```bash
# 安装
uv add --dev ruff

# 配置 pyproject.toml
[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]

# 运行
ruff check .
ruff format .
```

### 2.3 FastAPI 生产级架构

```python
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter
from slowapi.util import get_remote_address

app = FastAPI(title="Frame Sync API")

# 限流中间件
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

@app.post("/sync/frame")
@limiter.limit("100/minute")
async def sync_frame(frame: FrameData):
    """帧同步接口"""
    result = await process_frame(frame)
    return {"status": "ok", "result": result}

# 部署配置
# Docker: tiangolo/uvicorn-gunicorn
# K8s: 健康检查 / 就绪探针
# HTTPS: certbot
```

### 2.4 Python 异步编程进阶

```python
# 异步上下文管理器
class AsyncDBConnection:
    async def __aenter__(self):
        self.conn = await asyncpg.connect(
            host="localhost",
            database="framesync"
        )
        return self.conn
    
    async def __aexit__(self, *args):
        await self.conn.close()

# 使用
async with AsyncDBConnection() as conn:
    await conn.fetch("SELECT * FROM frames WHERE room_id = $1", room_id)

# 异步生成器
async def frame_stream(room_id: str):
    """帧数据流"""
    while True:
        frames = await fetch_pending_frames(room_id)
        for frame in frames:
            yield frame
        await asyncio.sleep(0.016)  # 60 FPS

# 使用
async for frame in frame_stream("room_001"):
    process_frame(frame)
```

### 2.5 Python 测试进阶 - pytest-benchmark

```python
# pytest-benchmark
def test_frame_processing_performance(benchmark):
    sync = FrameSync()
    test_input = generate_test_frames(100)
    
    result = benchmark(sync.process_batch, test_input)
    
    assert result.avg_time < 16.67  # 60 FPS = 16.67ms/帧
    assert result.memory < 100 * 1024  # 100KB
```

---

## 三、自动化测试 Skills 补充

### 3.1 Playwright 进阶专题

#### 核心特性

```python
# 智能等待
await page.wait_for_selector(
    "#submit-btn",
    state="visible",
    timeout=5000
)

# 元素定位最佳实践 (优先级)
1. data-testid (推荐)
2. aria-label / aria-role
3. 文本内容
4. CSS 类名 (慎用)

# 截图对比
from playwright.visual_tests import compare_snapshots

# 录制生成测试
# npx playwright codegen https://example.com
```

#### Azure Playwright Testing

```typescript
// azure-microsoft-playwright-testing-ts
import { test, expect } from '@playwright/test';

test('cross-browser testing', async ({ page, browser }) => {
    // Azure 集成测试
    const contexts = await Promise.all(
        ['chromium', 'firefox', 'webkit'].map(
            browserType => browserType.launch()
        )
    );
    
    for (const context of contexts) {
        const page = await context.newPage();
        // 测试逻辑
    }
});
```

### 3.2 游戏客户端测试专题

#### Unity Test Framework

```csharp
// 单元测试 (Edit Mode)
[Test]
public void FrameSync_Deterministic_Test()
{
    var sync = new FrameSync();
    sync.Initialize();
    
    // 相同输入 → 相同输出
    var input1 = new InputFrame { x = 1, y = 0 };
    var state1 = sync.ProcessFrame(input1);
    
    sync.Initialize();  // 重置
    var state2 = sync.ProcessFrame(input1);
    
    Assert.AreEqual(state1, state2);
}

// 集成测试 (Play Mode)
[UnityTest]
public IEnumerator NetworkSync_Integration_Test()
{
    var game = new GameObject("NetworkGame");
    var sync = game.AddComponent<FrameSync>();
    
    // 模拟网络延迟
    sync.SimulateLatency(100);  // 100ms
    
    sync.Connect("server://localhost:8080");
    
    yield return new WaitForSeconds(1f);
    
    Assert.IsTrue(sync.IsConnected);
}
```

#### 网络延迟模拟

```python
# py-netem 延迟模拟
import subprocess
import pytest

def simulate_network(latency_ms: int, jitter_ms: int, loss_percent: float):
    """配置网络条件"""
    cmd = [
        "tc", "qdisc", "change", "dev", "eth0",
        "root", "netem",
        "delay", f"{latency_ms}ms", f"{jitter_ms}ms",
        "loss", f"{loss_percent}%"
    ]
    subprocess.run(cmd, check=True)

@pytest.mark.parametrize("network", [
    {"latency": 5, "jitter": 2, "loss": 0},      # 局域网
    {"latency": 100, "jitter": 20, "loss": 2},   # 4G
    {"latency": 300, "jitter": 50, "loss": 5},   # 跨国
])
def test_frame_sync_network(network):
    simulate_network(**network)
    # 测试逻辑
```

### 3.3 移动端游戏测试 (Android/iOS)

#### Android UI 自动化测试

```python
# ADB 命令基础
import subprocess

def capture_ui_hierarchy():
    """获取 UI 层次结构"""
    result = subprocess.run(
        ["adb", "shell", "uiautomator", "dump", "/sdcard/ui_dump.xml"],
        capture_output=True
    )
    subprocess.run(["adb", "pull", "/sdcard/ui_dump.xml"])
    return result

def tap_screen(x, y):
    """模拟触摸"""
    subprocess.run(["adb", "shell", "input", "tap", str(x), str(y)])

def swipe(start_x, start_y, end_x, end_y, duration=300):
    """模拟滑动"""
    subprocess.run([
        "adb", "shell", "input", "swipe",
        str(start_x), str(start_y), str(end_x), str(end_y), str(duration)
    ])
```

#### iOS 自动化测试

```swift
// XCUITest 示例
import XCTest

class GameUITests: XCTestCase {
    
    func testGameLaunch() {
        let app = XCUIApplication()
        app.launch()
        
        // 验证游戏启动
        XCTAssertTrue(app.staticTexts["Game Title"].exists)
    }
    
    func testTapToStart() {
        let app = XCUIApplication()
        app.launch()
        
        // 点击开始按钮
        app.buttons["Start Game"].tap()
        
        // 验证进入游戏
        XCTAssertTrue(app.staticTexts["Score: 0"].exists)
    }
}
```

---

## 四、开发者工具 Skills 补充

### 4.1 GitHub Actions 高级模式

```yaml
# Matrix 构建
name: CI

on: [push, pull_request]

jobs:
  test:
    strategy:
      matrix:
        python-version: ['3.11', '3.12']
        os: [ubuntu-latest, windows-latest, macos-latest]
      fail-fast: false
    
    runs-on: ${{ matrix.os }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      
      - name: Cache uv
        uses: actions/cache@v3
        with:
          path: ~/.cache/uv
          key: ${{ runner.os }}-uv-${{ hashFiles('**/requirements.txt') }}
      
      - name: Install dependencies
        run: uv pip install -r requirements.txt
      
      - name: Run tests
        run: pytest tests/ --cov=src
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

### 4.2 CI/CD 最佳实践

```markdown
### 流水线阶段
1. Lint → 快速失败 (ruff, mypy)
2. Test → 覆盖率 gate (pytest, coverage > 80%)
3. Build → 多平台产物 (wheel, docker)
4. Deploy → 蓝绿/金丝雀

### 安全扫描
- SAST: CodeQL, Semgrep
- SCA: Dependabot, Snyk
- Secret: GitLeaks, TruffleHog
- Container: Trivy
```

### 4.3 浏览器自动化

```javascript
// Playwright 高级用法
const { chromium } = require('playwright');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();
    
    // 录制交互
    // npx playwright codegen
    
    // 元素定位最佳实践
    await page.click('[data-testid="submit-btn"]');
    await page.fill('[aria-label="username"]', 'testuser');
    
    // 等待策略
    await page.waitForLoadState('networkidle');
    
    // 截图
    await page.screenshot({ path: 'screenshot.png' });
    
    await browser.close();
})();
```

---

## 五、项目实践：game-frame-sync 应用

### 5.1 技术栈

| 层级 | 技术选择 |
|------|---------|
| 后端 | Python 3.12 + FastAPI + asyncio |
| 数据库 | PostgreSQL + Redis |
| 测试 | pytest + pytest-asyncio + pytest-benchmark |
| CI/CD | GitHub Actions |
| 部署 | Docker + K8s |

### 5.2 Skills 应用映射

| 模块 | Skills | 应用场景 |
|------|--------|---------|
| 核心同步 | `python-fastapi-development` | API 架构 |
| 并发处理 | `async-python-patterns` | 帧同步处理 |
| 测试 | `python-testing-patterns` | 单元测试 |
| 网络模拟 | `e2e-testing-patterns` | 延迟测试 |
| CI/CD | `github-workflow-automation` | 自动化流水线 |
| 容器化 | `docker-expert` | Docker 镜像 |

### 5.3 实施步骤

```bash
# 1. 项目初始化
uv init game-frame-sync
cd game-frame-sync

# 2. 安装依赖
uv add fastapi uvicorn asyncpg redis pytest pytest-asyncio
uv add --dev ruff mypy pytest-cov

# 3. 项目结构
mkdir -p src/{api,sync,models,tests}

# 4. CI 配置
# .github/workflows/ci.yml
```

---

## 六、Skills 统计汇总

| 类别 | Skills 数量 | 热门 Skills |
|------|------------|------------|
| 游戏开发 | 15+ | game-development, unity-developer, multiplayer, unity-ecs-patterns |
| Python 开发 | 18+ | python-pro, async-python-patterns, fastapi, uv-package-manager |
| 自动化测试 | 20+ | playwright-skill, e2e-testing, test-automator, python-testing-patterns |
| 开发者工具 | 25+ | github-automation, browser-automation, cicd-automation, docker-expert |

---

## 七、推荐学习路径

### 游戏客户端开发
```
1. 基础: game-development (orchestrator)
2. 2D/3D: 2d-games / 3d-games
3. 引擎: unity-developer / godot-gdscript-patterns / unreal-engine-cpp-pro
4. 架构: unity-ecs-patterns (性能优化)
5. 进阶: multiplayer (网络同步)
```

### Python 开发
```
1. 基础: python-pro (现代工具链)
2. 包管理: uv-package-manager (极速体验)
3. Web: python-fastapi-development
4. 并发: async-python-patterns
5. 测试: python-testing-patterns
6. 优化: python-performance-optimization
```

### 自动化测试
```
1. 基础: testing-patterns / python-testing-patterns
2. E2E: playwright-skill / e2e-testing
3. 进阶: test-automator (AI 驱动)
4. 流程: test-driven-development
5. 质量: testing-qa
```

### 开发者工具
```
1. Git: github-automation / gitlab-automation
2. CI/CD: github-workflow-automation / cicd-automation
3. 浏览器: browser-automation
4. 容器: docker-expert
5. 监控: sentry-automation / datadog-automation
```

---

## 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills) - 970+ Skills 集合
- [Awesome Claude Code](https://github.com/PromisedLoLo/awesome-claude-code) - 社区精选资源
- [Unity AI Workflow 2026](https://github.com/David-GD13/unity-ai-workflow) - 2026 新增
- [uv 包管理器](https://github.com/astral-sh/uv) - 极速 Python 包管理
- [Ruff linter](https://github.com/astral-sh/ruff) - 超快 Python linting
- [Playwright 文档](https://playwright.dev/)
- [FastAPI 文档](https://fastapi.tiangolo.com/)
- [Unity 官方文档](https://docs.unity.com/)
- [Godot 文档](https://docs.godotengine.org/)

---

*最后更新: 2026-03-03*
*调研周期: 2026年3月 第三周*
