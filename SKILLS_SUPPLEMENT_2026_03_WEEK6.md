# Claude Code Skills 补充调研报告（第六周）

> 游戏客户端开发 / Python 开发 / 测试自动化 / 开发者工具

**更新日期**: 2026-03-04
**调研范围**: Antigravity Awesome Skills (968+ Skills) + GitHub 热门项目 + Claude Code 官方 Skills

---

## 📋 目录

1. [游戏客户端开发](#1-游戏客户端开发)
2. [Python 开发](#2-python-开发)
3. [测试自动化](#3-测试自动化)
4. [开发者工具](#4-开发者工具)
5. [本周新增 Skills 完整列表](#5-本周新增-skills-完整列表)
6. [快速开始指南](#6-快速开始指南)

---

## 1. 游戏客户端开发

### 1.1 核心 Skills 矩阵（更新）

| Skill 名称 | 引擎/技术 | 核心能力 | 适用场景 |
|-----------|----------|---------|---------|
| `unity-developer` | Unity 6 LTS | C# 优化、URP/HDRP、ECS、DOTS | AAA 游戏开发 |
| `unity-ecs-patterns` | Unity DOTS | ECS 架构、Jobs、Burst 编译 | 高性能游戏系统 |
| `unreal-engine-cpp-pro` | Unreal 5.x | C++ 开发、UObject、性能模式 | AAA 级游戏 |
| `godot-gdscript-patterns` | Godot 4 | GDScript 2.0、信号、状态机 | 开源/轻量游戏 |
| `godot-4-migration` | Godot 4 | 3→4 迁移指南 | 版本升级 |
| `2d-games` | 通用 | 精灵、瓦片地图、物理 | 2D 游戏 |
| `3d-games` | 通用 | 渲染、着色器、物理 | 3D 游戏 |
| `multiplayer` | 通用 | 网络架构、同步、延迟补偿 | 多人游戏 |
| `mobile-games` | 移动端 | 触控、电池、性能 | 手游开发 |
| `vr-ar` | XR | VR/AR 开发 | 沉浸式游戏 |
| `pc-games` | PC | Steam、桌面平台 | PC 游戏 |
| `web-games` | Web | HTML5、WebGL | 网页游戏 |
| `game-design` | 通用 | GDD、平衡性、玩家心理 | 游戏设计 |
| `game-art` | 通用 | 视觉风格、资产管线 | 美术 |
| `game-audio` | 通用 | 音效设计、音乐、动态音频 | 音频 |

### 1.2 game-development 编排 Skill（重点更新）

**项目地址**: [antigravity-awesome-skills/skills/game-development](https://github.com/sickn33/antigravity-awesome-skills/tree/main/skills/game-development)

```markdown
### 架构原则
game-development 是一个编排型 Skill，根据项目需求路由到专门的子 Skills。

### 子 Skill 路由矩阵

#### 平台选择
| 游戏目标平台 | 使用子 Skill |
|-------------|-------------|
| Web 浏览器 (HTML5, WebGL) | game-development/web-games |
| 移动端 (iOS, Android) | game-development/mobile-games |
| PC (Steam, 桌面) | game-development/pc-games |
| VR/AR 头显 | game-development/vr-ar |

#### 维度选择
| 游戏类型 | 使用子 Skill |
|---------|-------------|
| 2D (精灵、瓦片地图) | game-development/2d-games |
| 3D (网格、着色器) | game-development/3d-games |

#### 专业领域
| 需求 | 使用子 Skill |
|------|-------------|
| GDD、平衡、玩家心理 | game-development/game-design |
| 多人游戏、网络 | game-development/multiplayer |
| 视觉风格、资产管线、动画 | game-development/game-art |
| 音效设计、音乐、动态音频 | game-development/game-audio |
```

### 1.3 游戏开发核心原则

```markdown
### 游戏循环
INPUT → UPDATE (固定时间步) → RENDER (插值)

固定时间步规则:
- 物理/逻辑: 固定频率 (如 50Hz)
- 渲染: 尽可能快
- 状态间插值实现平滑视觉效果

### 设计模式选择矩阵
| 模式 | 使用场景 | 示例 |
|------|---------|------|
| 状态机 | 3-5 个离散状态 | 玩家: Idle→Walk→Jump |
| 对象池 | 频繁生成/销毁 | 子弹、粒子 |
| 观察者/事件 | 跨系统通信 | 生命值→UI 更新 |
| ECS | 数千相似实体 | RTS 单位、粒子 |
| 命令 | 撤销、回放、网络 | 输入录制 |
| 行为树 | 复杂 AI 决策 | 敌人 AI |

决策规则: 从状态机开始。只有性能要求时才添加 ECS。
```

### 1.4 性能预算 (60 FPS = 16.67ms)

| 系统 | 预算 |
|------|------|
| 输入 | 1ms |
| 物理 | 3ms |
| AI | 2ms |
| 游戏逻辑 | 4ms |
| 渲染 | 5ms |
| 缓冲 | 1.67ms |

**优化优先级:**
1. 算法优化 (O(n²) → O(n log n))
2. 批处理 (减少绘制调用)
3. 对象池 (避免 GC 峰值)
4. LOD (按距离细节)
5. 剔除 (跳过不可见对象)

### 1.5 Multiplayer 游戏开发专题

```markdown
### 架构决策树
├── 竞技/实时 → 专属服务器 (权威)
├── 合作/休闲 → 主机模式 (一人做服务器)
├── 回合制 → 客户端-服务器 (简单)
└── 大型 (MMO) → 分布式服务器

### 同步方案对比
| 方案 | 同步内容 | 带宽需求 | 适用场景 |
|------|---------|---------|---------|
| 状态同步 | 游戏状态 | 高 | RTS、SLG |
| 输入同步 | 玩家输入 | 低 | FPS、ACT |
| 预测+回滚 | 两者 | 中 | 格斗、竞技 |

### 延迟补偿技术
- 客户端预测: 客户端预测服务器结果，立即显示
- 服务器调解: 修正客户端错误预测
- 插值: 平滑远程玩家移动 (过去位置)
- 外推: 预测远程玩家未来位置
- 延迟补偿: 回滚用于命中检测

### 帧同步确定性要求
- 相同初始状态 + 相同输入 = 相同结果
- 禁止: 基于时间的随机、浮点精度、线程竞争
```

### 1.6 移动端游戏开发

```markdown
### 平台约束与策略
| 约束 | 策略 |
|------|------|
| 触控输入 | 大点击区域 (44x44pt 最小)、手势识别 |
| 电池 | 限制 CPU/GPU 使用率、后台暂停 |
| 热节流 | 温度检测、降级画质 |
| 屏幕尺寸 | 响应式 UI、安全区域 |

### 性能目标
| 指标 | 目标 | 底线 |
|------|------|------|
| 帧率 | 60 FPS | 30 FPS |
| 触控延迟 | < 50ms | < 100ms |
| 启动时间 | < 3s | < 5s |
| 内存 | < 500MB | < 1GB |

### AI 选择复杂度
| AI 类型 | 复杂度 | 使用场景 |
|---------|--------|---------|
| FSM | 简单 | 3-5 状态，可预测行为 |
| 行为树 | 中等 | 模块化，对设计师友好 |
| GOAP | 高 | 涌现性，基于规划 |
| Utility AI | 高 | 基于评分的决策 |
```

---

## 2. Python 开发

### 2.1 核心 Skills 矩阵（更新）

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| `python-pro` | Python 3.12+ 全栈指南 | 通用开发 |
| `python-patterns` | 开发原则和决策 | 架构设计 |
| `python-fastapi-development` | FastAPI 后端开发 | API 服务 |
| `fastapi-pro` | FastAPI 专家 | 生产级 API |
| `fastapi-templates` | FastAPI 模板 | 快速启动 |
| `fastapi-router-py` | FastAPI 路由管理 | 模块化 |
| `django-pro` | Django 全栈 | Web 应用 |
| `python-development-python-scaffold` | 项目脚手架 | 项目初始化 |
| `python-testing-patterns` | pytest/测试策略 | 质量保证 |
| `python-performance-optimization` | 性能分析和优化 | 性能调优 |
| `python-packaging` | PyPI 发布 | 库分发 |
| `async-python-patterns` | asyncio 异步编程 | 高并发 |
| `rust-async-patterns` | Rust 异步编程 | 系统级并发 |
| `temporal-python-pro` | Temporal 工作流 | 分布式事务 |
| `temporal-python-testing` | Temporal 测试 | 工作流测试 |
| `dbos-python` | DBOS 工作流 | 可靠执行 |
| `n8n-code-python` | n8n 自动化 | 工作流 |

### 2.2 FastAPI 专家 Skill（重点更新）

**项目地址**: [antigravity-awesome-skills/skills/fastapi-pro](https://github.com/sickn33/antigravity-awesome-skills/tree/main/skills/fastapi-pro)

```markdown
### 核心能力
- Pydantic v2 数据验证 (性能提升显著)
- SQLAlchemy 2.0 异步支持
- OpenAPI 自动文档
- 依赖注入系统

### 认证方案
| 方案 | 适用场景 | 复杂度 |
|------|---------|--------|
| JWT Bearer | SPA/移动端 | 中 |
| OAuth2 密码流 | 第三方登录 | 高 |
| API Key | 服务间 | 低 |

### 部署配置
```python
# uvicorn 直接运行
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4

# gunicorn + uvicorn
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
```

### Docker 多阶段构建
```dockerfile
# 构建阶段
FROM python:3.12-slim as builder
RUN pip install uv
COPY . .
RUN uv sync --frozen --no-dev

# 运行阶段
FROM python:3.12-slim
COPY --from=builder /app /app
USER ["uv", "nonroot"]
CMD ["uvicorn", "main:app"]
```
```

### 2.3 Temporal 工作流（重点更新）

**项目地址**: [temporalio/sdk-python](https://github.com/temporalio/sdk-python)

```markdown
### 核心概念
- Workflow: 业务逻辑定义
- Activity: 具体执行任务
- Worker: 执行工作流和活动
- Client: 与 Temporal 服务交互

### 适用场景
- 长时间运行的工作流
- 需要可靠执行的任务
- 分布式事务
- 批处理和 ETL

### temporal-python-pro 能力
- 工作流定义和执行
- 活动处理和重试
- 信号和查询
- 定时器和循环
- 测试和调试
```

### 2.4 DBOS 工作流（新增）

**项目地址**: [dbos-inc/dbos-python](https://github.com/dbos-inc/dbos-python)

```markdown
### 核心特性
- 声明式可靠性
- 透明事务管理
- 自动重试和恢复
- 轻量级

### 适用场景
- 微服务可靠性
- 数据一致性
- 事件驱动架构

### dbos-python 能力
- @DBOSWorkflow 装饰器
- @DBOSActivity 装饰器
- 透明事务管理
- 自动日志和追踪
```

### 2.5 Python 3.12+ 现代工具链（更新）

```markdown
### 2024/2025 主流工具
| 工具 | 用途 | 替代 | 性能 |
|------|------|------|------|
| uv | 包管理 | pip | 10-100x |
| ruff | 格式化/lint | black/isort/flake8 | 10-100x |
| mypy/pyright | 类型检查 | - | pyright 快 20x |
| pyproject.toml | 项目配置 | setup.py | 现代标准 |

### uv 快速开始
```bash
# 安装 uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 创建项目
uv init my-project
cd my-project

# 添加依赖
uv add fastapi pytest

# 运行
uv run main.py
```

### ruff 配置
```toml
[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]
```
```

### 2.6 Async Python 模式（更新）

```markdown
### 适用场景
- 高并发 I/O 密集型服务
- 实时 WebSocket 应用
- 爬虫和数据采集
- 微服务间通信

### 生态库
| 库 | 用途 | 异步支持 |
|---|------|---------|
| aiohttp | HTTP 客户端/服务器 | ✅ |
| asyncpg | PostgreSQL | ✅ |
| aiomysql | MySQL | ✅ |
| redis.asyncio | Redis | ✅ |
| SQLAlchemy 2.0 | ORM | ✅ |

### 异步模式选择
```python
# 方式 1: asyncio (推荐)
import asyncio
async def main():
    async with aiohttp.ClientSession() as session:
        await fetch_all(session, urls)

# 方式 2: 多任务并发
async def main():
    tasks = [fetch(url) for url in urls]
    results = await asyncio.gather(*tasks)
```
```

---

## 3. 测试自动化

### 3.1 核心 Skills 矩阵（更新）

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| `test-automator` | AI 驱动测试自动化 | 智能测试生成 |
| `e2e-testing-patterns` | Playwright/Cypress | 端到端测试 |
| `playwright-skill` | Playwright 专项 | 浏览器自动化 |
| `go-playwright` | Go Playwright | Go 项目 |
| `azure-microsoft-playwright-testing-ts` | Azure 云测试 | 大规模测试 |
| `python-testing-patterns` | pytest 最佳实践 | Python 测试 |
| `testing-patterns` | Jest 测试模式 | JS/TS 测试 |
| `javascript-testing-patterns` | JS 测试策略 | 前端测试 |
| `bats-testing-patterns` | Bash 测试 | Shell 测试 |
| `test-driven-development` | TDD 开发流程 | 测试先行 |
| `test-fixing` | 测试修复 | 失败测试 |
| `testing-qa` | 综合 QA 工作流 | 质量保证 |
| `unit-testing-test-generate` | 单元测试生成 | 测试覆盖 |
| `webapp-testing` | Web 应用测试 | 本地测试 |
| `api-testing-observability-api-mock` | API Mock | API 测试 |
| `e2e-testing` | E2E 测试基础 | 测试入门 |

### 3.2 Playwright 专项（重点更新）

```markdown
### playwright-skill 核心能力
- 元素定位和等待
- 表单交互和验证
- 导航和路由测试
- 截图和录制
- API 拦截和 Mock

### 最佳实践
```javascript
// 可靠的选择器
const submitButton = page.getByRole('button', { name: 'Submit' });
const emailInput = page.getByLabel('Email');

// 智能等待
await page.waitForLoadState('networkidle');
await expect(page.locator('.data')).toBeVisible();

// Page Object 模式
class LoginPage {
  constructor(page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
  }
  
  async login(email, password) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.page.getByRole('button', { name: 'Login' }).click();
  }
}
```

### go-playwright (Go 语言)
- 强类型浏览器自动化
- 适合 Go 项目集成
- 与 go testing 集成
```

### 3.3 Azure Playwright 云测试（新增）

```markdown
### azure-microsoft-playwright-testing-ts
- Playwright 云端规模化测试
- Azure Playwright Workspaces
- 跨浏览器云测试
- 无需自建基础设施

### 适用场景
- 大规模并行测试
- 跨地域测试
- CI/CD 集成
- 视觉回归测试
```

### 3.4 TDD 工作流专题（更新）

```markdown
### TDD 循环
1. Red: 写失败的测试
2. Green: 最小代码通过
3. Refactor: 重构改进

### test-driven-development 能力
- 红绿重构循环实践
- 测试先行开发
- 快速迭代

### 红绿重构实践
```python
# RED: 先写测试
def test_player_take_damage():
    player = Player(hp=100)
    player.take_damage(30)
    assert player.hp == 70  # 失败!

# GREEN: 最小实现
class Player:
    def take_damage(self, amount):
        self.hp -= amount

# REFACTOR: 改进实现
class Player:
    def __init__(self, hp=100):
        self.hp = max(0, hp)
    
    def take_damage(self, amount):
        self.hp = max(0, self.hp - amount)
```
```

### 3.5 游戏客户端测试专题（重点更新）

```markdown
### Unity Test Framework
| 测试类型 | 运行方式 | 适用场景 |
|---------|---------|---------|
| Edit Mode | 编辑器内 | 纯逻辑测试 |
| Play Mode | 游戏运行中 | 集成测试 |

### 网络同步测试
```csharp
[UnityTest]
public IEnumerator FrameSync_Deterministic_Test()
{
    // 设置相同初始状态
    var game = new GameSimulation(seed: 42);
    
    // 执行相同输入序列
    game.ProcessInput(new InputFrame(1, InputType.MoveRight));
    game.ProcessInput(new InputFrame(2, InputType.MoveRight));
    
    // 验证结果一致
    var state1 = game.GetState();
    yield return null;
    var state2 = game.GetState();
    
    Assert.AreEqual(state1.PlayerPosition, state2.PlayerPosition);
}
```

### 延迟模拟工具
- network-jitter: 0-200ms 随机延迟
- packet-loss: 5%-20% 丢包率
- high-latency: 200-500ms RTT

### 游戏特定测试挑战
- 帧同步/状态同步测试
- 网络延迟模拟
- 随机性验证
- 性能基准测试

### 移动端游戏测试
- 触控响应延迟测试
- 陀螺仪/重力感应测试
- 内存/电量消耗监控
- 网络切换 (WiFi → 4G) 测试
- 切入切出后台测试
```

---

## 4. 开发者工具

### 4.1 核心 Skills 矩阵（更新）

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| `browser-automation` | 浏览器自动化 | 测试/爬虫 |
| `github-automation` | GitHub 自动化 | PR/Issue/Workflow |
| `github-workflow-automation` | GitHub Actions | CI/CD |
| `gitlab-automation` | GitLab 自动化 | 项目管理 |
| `cicd-automation-workflow-automate` | CI/CD 自动化 | 流水线 |
| `changelog-automation` | Changelog 生成 | 版本发布 |
| `docker-expert` | Docker 专家 | 容器化 |
| `devops-troubleshooter` | DevOps 排错 | 运维 |
| `cli-tool-development` | CLI 工具开发 | 工具构建 |
| `git-advanced-workflows` | Git 高级工作流 | 版本控制 |
| `gitops-workflow` | GitOps 工作流 | 基础设施 |
| `kubernetes-deployment` | K8s 部署 | 容器编排 |
| `k8s-manifest-generator` | K8s 清单生成 | 自动化部署 |
| `cloud-devops` | 云端 DevOps | 云平台 |
| `bitbucket-automation` | Bitbucket 自动化 | 代码托管 |
| `circleci-automation` | CircleCI 自动化 | CI/CD |

### 4.2 GitHub Actions 自动化（更新）

```markdown
### 工作流设计模式
```yaml
# Matrix 构建
strategy:
  matrix:
    python-version: ['3.11', '3.12']
    os: ['ubuntu-latest', 'windows-latest']

# 依赖缓存
- uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}

# 并行执行
- run: npm test
- run: npm run lint
  continue-on-error: true
```

### 自动化示例
- PR 自动审查
- Issue 分类标签
- 自动合并依赖
- 发布管理
```

### 4.3 GitOps 工作流（更新）

```markdown
### gitops-workflow
- ArgoCD / Flux 配置
- Git 仓库即真相
- 声明式基础设施
- 自动同步和回滚

### 最佳实践
1. 应用配置分离
2. 环境分支策略
3. 自动健康检查
4. 渐进式部署
```

### 4.4 K8s 部署（更新）

```markdown
### kubernetes-deployment
- Deployment/Service/Ingress 配置
- ConfigMap/Secret 管理
- HPA 自动伸缩
- 健康检查配置

### k8s-manifest-generator
- 自动生成 K8s 清单
- 最佳实践模板
- 多环境支持

### 常用命令
```bash
# Pod 状态
kubectl get pods -n default

# 日志查看
kubectl logs -f deployment/my-app

# 事件排查
kubectl get events --sort-by='.lastTimestamp'

# 资源使用
kubectl top pods
```
```

### 4.5 浏览器自动化专题（更新）

```markdown
### browser-automation 核心概念
- 元素定位策略 (优先级: testid > ARIA > 文本 > CSS)
- 等待策略 (显式 > 智能 > 隐式)
- Page Object 模式

### 工具对比
| 工具 | 特点 | 适用场景 |
|------|------|---------|
| Playwright | 跨浏览器、API 丰富 | 现代 Web |
| Puppeteer | Chrome 专用、轻量 | 爬虫/截图 |
| Selenium | 历史悠久、生态广 | 遗留项目 |
| Cypress | 调试友好、实时重载 | 开发测试 |

### go-playwright (Go 语言)
- 强类型浏览器自动化
- 适合 Go 项目集成
```

### 4.6 DevOps 排错（更新）

```markdown
### devops-troubleshooter 能力
- Pod 启动失败诊断
- 内存/CPU 问题定位
- 网络连接排错
- 日志分析

### 常见问题快速排查
| 问题 | 排查命令 |
|------|---------|
| Pod 不启动 | kubectl describe pod <name> |
| 内存溢出 | kubectl top pods / kubectl logs |
| 网络不通 | kubectl exec -it <pod> -- curl |
| 磁盘满 | kubectl exec -it <pod> -- df -h |
```

---

## 5. 本周新增 Skills 完整列表

### 5.1 完整新增 Skills

| Skill 名称 | 类别 | 描述 | 日期 |
|-----------|------|------|------|
| `game-development` | 游戏开发 | 游戏开发编排 Skill，路由到子 Skills | 2026-02 |
| `game-design` | 游戏开发 | 游戏设计原则 | 2026-02 |
| `game-art` | 游戏开发 | 游戏美术资产 | 2026-02 |
| `game-audio` | 游戏开发 | 游戏音频设计 | 2026-02 |
| `pc-games` | 游戏开发 | PC 游戏开发 | 2026-02 |
| `web-games` | 游戏开发 | Web 游戏开发 | 2026-02 |
| `fastapi-pro` | Python | FastAPI 专家 | 2026-02 |
| `fastapi-templates` | Python | FastAPI 模板 | 2026-02 |
| `fastapi-router-py` | Python | FastAPI 路由 | 2026-02 |
| `n8n-code-python` | Python | n8n 自动化 | 2026-02 |
| `go-playwright` | 开发者工具 | Go Playwright | 2026-02 |
| `k8s-manifest-generator` | 开发者工具 | K8s 清单生成 | 2026-02 |
| `cloud-devops` | 开发者工具 | 云端 DevOps | 2026-02 |
| `circleci-automation` | 开发者工具 | CircleCI 自动化 | 2026-02 |

### 5.2 Skills 统计

| 类别 | 数量 |
|------|------|
| 游戏开发 | 15+ |
| Python 开发 | 18+ |
| 测试自动化 | 16+ |
| 开发者工具 | 20+ |

---

## 6. 快速开始指南

### 6.1 安装 Skills

```bash
# 安装 Antigravity Skills
npx antigravity-awesome-skills --claude

# 查看可用 Skills
ls ~/.claude/skills/
```

### 6.2 使用 Skills

```bash
# 游戏开发
>> /game-development 帮助我选择游戏引擎
>> /multiplayer 实现延迟补偿
>> /unity-developer 使用 Unity 开发
>> /mobile-games 开发移动端游戏

# Python 开发
>> /python-pro 设置现代 Python 项目
>> /fastapi-pro 创建生产级 API
>> /temporal-python-pro 实现可靠工作流
>> /dbos-python 使用 DBOS 工作流

# 测试
>> /playwright-skill 设置 Playwright 测试
>> /test-driven-development 使用 TDD 开发
>> /python-testing-patterns 编写单元测试
>> /e2e-testing-patterns 设置 E2E 测试

# 开发者工具
>> /github-automation 创建 CI 工作流
>> /docker-expert 优化 Dockerfile
>> /gitops-workflow 设置 GitOps
>> /kubernetes-deployment K8s 部署
```

### 6.3 推荐学习路径

```
游戏开发:
1. game-development (编排 Skill)
2. 2d-games / 3d-games (基础)
3. unity-developer / godot-gdscript-patterns (引擎)
4. multiplayer (网络同步)
5. mobile-games (移动端)

Python 开发:
1. python-patterns (原则)
2. python-pro (现代工具链 + uv)
3. fastapi-pro / python-fastapi-development (Web)
4. temporal-python-pro / dbos-python (可靠工作流)
5. async-python-patterns (高并发)

测试:
1. testing-patterns / python-testing-patterns (基础)
2. playwright-skill (E2E)
3. test-driven-development (TDD)
4. azure-microsoft-playwright-testing-ts (云测试)

开发者工具:
1. browser-automation (浏览器)
2. github-automation (GitHub)
3. docker-expert (容器)
4. gitops-workflow (GitOps)
5. kubernetes-deployment (K8s)
```

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)
- [Temporal Python SDK](https://github.com/temporalio/sdk-python)
- [DBOS Python](https://github.com/dbos-inc/dbos-python)
- [uv 包管理器](https://github.com/astral-sh/uv)
- [Playwright 文档](https://playwright.dev/)

---

*持续更新中...*
