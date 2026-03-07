# Claude Code Skills 补充调研报告（第五周）

> 游戏客户端开发 / Python 开发 / 测试自动化 / 开发者工具

**更新日期**: 2026-03-04
**调研范围**: Antigravity Awesome Skills (968+ Skills) + GitHub 热门项目

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
| `hig-inputs` | Apple | Apple 输入设备集成 | Apple 平台游戏 |

### 1.2 Unity AI Workflow 2026 (重点更新)

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

```markdown
### 三种开发模式
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、游戏 jam |

### 核心哲学: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

### TCREI Prompting 方法论
- Task: 明确任务
- Context: 提供上下文
- References: 提供参考
- Evaluate: 评估结果
- Iterate: 迭代改进

### 验证系统
- [VERIFIED]: 已验证的 AI 推荐
- [SYNTHESIZED]: 综合多个来源
- [UNVERIFIED]: 未验证的推荐
```

### 1.3 Multiplayer 游戏开发专题（更新）

```markdown
### 架构选择
| 架构 | 延迟 | 成本 | 安全性 | 适用场景 |
|------|------|------|--------|---------|
| 专属服务器 | 低 | 高 | 强 | MMO、竞技 |
| P2P | 变化 | 低 | 弱 | 休闲多人 |
| 主机模式 | 中 | 低 | 中 | 本地多人 |

### 同步方案
| 方案 | 同步内容 | 带宽需求 | 适用场景 |
|------|---------|---------|---------|
| 状态同步 | 游戏状态 | 高 | RTS、SLG |
| 输入同步 | 玩家输入 | 低 | FPS、ACT |
| 预测+回滚 | 两者 | 中 | 格斗、竞技 |

### 延迟补偿技术详解
- **客户端预测**: 客户端预测服务器结果，立即显示
- **服务器调解**: 修正客户端错误预测
- **插值**: 平滑远程玩家移动（过去位置）
- **外推**: 预测远程玩家未来位置
- **延迟补偿**: 回滚用于命中检测（枪击判定）

### 帧同步特别专题
```
确定性要求:
- 相同初始状态 + 相同输入 = 相同结果
- 禁止: Random based on time, Float precision, Thread race

帧同步实现:
- 帧编号: 每帧递增
- 输入帧: 每个输入包带帧号
- 确定性随机: 预计算随机数种子
- 录像回放: 记录所有输入
```
```

### 1.4 移动端游戏开发（更新）

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

### 游戏特定测试
- 触控响应延迟测试
- 陀螺仪/重力感应测试
- 内存/电量消耗监控
- 网络切换 (WiFi → 4G) 测试
- 切入切出后台测试
```

---

## 2. Python 开发

### 2.1 核心 Skills 矩阵（更新）

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| `python-pro` | Python 3.12+ 全栈指南 | 通用开发 |
| `python-patterns` | 开发原则和决策 | 架构设计 |
| `python-fastapi-development` | FastAPI 后端开发 | API 服务 |
| `python-development-python-scaffold` | 项目脚手架 | 项目初始化 |
| `python-testing-patterns` | pytest/测试策略 | 质量保证 |
| `python-performance-optimization` | 性能分析和优化 | 性能调优 |
| `python-packaging` | PyPI 发布 | 库分发 |
| `async-python-patterns` | asyncio 异步编程 | 高并发 |
| `fastapi-pro` | FastAPI 专家 | 生产级 API |
| `django-pro` | Django 全栈 | Web 应用 |
| `temporal-python-pro` | Temporal 工作流 | 分布式事务 |
| `temporal-python-testing` | Temporal 测试 | 工作流测试 |
| `dbos-python` | DBOS 工作流 | 可靠执行 |
| `uv-package-manager` | uv 包管理器 | 快速依赖管理 |

### 2.2 Python 3.12+ 现代工具链（更新）

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

### 2.3 FastAPI 生产级实践（更新）

```markdown
### 核心特性
- Pydantic v2 数据验证 (，性能提升)
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
USER ["uv nonroot
CMDicorn", "main:app"]
```
```

### 2.4 Async Python 模式（更新）

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

### 2.5 Temporal 工作流（新增重点）

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

### python-temporal-pro 能力
- 工作流定义和执行
- 活动处理和重试
- 信号和查询
- 定时器和循环
- 测试和调试
```

### 2.6 DBOS 工作流（新增）

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
```

---

## 3. 测试自动化

### 3.1 核心 Skills 矩阵（更新）

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| `test-automator` | AI 驱动测试自动化 | 智能测试生成 |
| `e2e-testing-patterns` | Playwright/Cypress | 端到端测试 |
| `playwright-skill` | Playwright 专项 | 浏览器自动化 |
| `azure-microsoft-playwright-testing-ts` | Azure 云测试 | 大规模测试 |
| `python-testing-patterns` | pytest 最佳实践 | Python 测试 |
| `testing-patterns` | Jest 测试模式 | JS/TS 测试 |
| `test-driven-development` | TDD 开发流程 | 测试先行 |
| `test-fixing` | 测试修复 | 失败测试 |
| `testing-qa` | 综合 QA 工作流 | 质量保证 |
| `javascript-testing-patterns` | JS 测试策略 | 前端测试 |
| `bats-testing-patterns` | Bash 测试 | Shell 测试 |

### 3.2 Playwright 专项（更新）

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

### 3.4 游戏客户端测试专题（更新）

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
```

### 3.5 TDD 工作流专题（更新）

```markdown
### TDD 循环
1. Red: 写失败的测试
2. Green: 最小代码通过
3. Refactor: 重构改进

### tdd-workflows 系列
| Skill | 描述 |
|-------|------|
| tdd-workflows-tdd-red | 编写失败测试 |
| tdd-workflows-tdd-green | 实现通过测试 |
| tdd-workflows-tdd-refactor | 重构代码 |
| tdd-workflows-tdd-cycle | 完整循环 |

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

### 4.3 GitOps 工作流（新增）

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

### 4.4 DevOps 排错（更新）

```markdown
### devops-troubleshooter 能力
- Pod 启动失败诊断
- 内存/CPU 问题定位
- 网络连接排错
- 日志分析

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

---

## 5. 本周新增 Skills 完整列表

### 5.1 完整新增 Skills

| Skill 名称 | 类别 | 描述 | 日期 |
|-----------|------|------|------|
| `hig-inputs` | 游戏开发 | Apple HIG 输入设备指南 | 2026-03 |
| `temporal-python-pro` | Python | Temporal 工作流 | 2026-03 |
| `temporal-python-testing` | Python | Temporal 测试 | 2026-03 |
| `dbos-python` | Python | DBOS 工作流 | 2026-03 |
| `uv-package-manager` | Python | uv 包管理器 | 2026-03 |
| `azure-microsoft-playwright-testing-ts` | 测试 | Azure Playwright 云测 | 2026-02 |
| `bats-testing-patterns` | 测试 | Bash 测试 | 2026-03 |
| `javascript-testing-patterns` | 测试 | JS 测试策略 | 2026-03 |
| `git-advanced-workflows` | 开发者工具 | Git 高级工作流 | 2026-03 |
| `gitops-workflow` | 开发者工具 | GitOps | 2026-03 |
| `kubernetes-deployment` | 开发者工具 | K8s 部署 | 2026-03 |
| `go-playwright` | 开发者工具 | Go Playwright | 2026-03 |
| `agent-evaluation` | AI 代理 | LLM 代理评估 | 2026-02 |
| `agent-manager-skill` | AI 代理 | 代理管理 | 2026-02 |

### 5.2 Skills 统计

| 类别 | 数量 |
|------|------|
| 游戏开发 | 11+ |
| Python 开发 | 12+ |
| 测试自动化 | 11+ |
| 开发者工具 | 15+ |

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
>> /unity-developer 帮助我设计多人游戏架构
>> /multiplayer 实现延迟补偿
>> /unity-ecs-patterns 使用 ECS 架构

# Python 开发
>> /python-pro 设置现代 Python 项目
>> /fastapi-pro 创建生产级 API
>> /temporal-python-pro 实现可靠工作流

# 测试
>> /playwright-skill 设置 Playwright 测试
>> /test-driven-development 使用 TDD 开发
>> /python-testing-patterns 编写单元测试

# 开发者工具
>> /github-automation 创建 CI 工作流
>> /docker-expert 优化 Dockerfile
>> /gitops-workflow 设置 GitOps
```

### 6.3 推荐学习路径

```
游戏开发:
1. 2d-games / 3d-games (基础)
2. unity-developer / godot-gdscript-patterns (引擎)
3. multiplayer (网络同步)
4. Unity AI Workflow 2026 (AI 辅助开发)

Python 开发:
1. python-patterns (原则)
2. python-pro (现代工具链 + uv)
3. python-fastapi-development (Web)
4. temporal-python-pro (可靠工作流)
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
- [Unity AI Workflow 2026](https://github.com/David-GD13/unity-ai-workflow)
- [Temporal Python SDK](https://github.com/temporalio/sdk-python)
- [DBOS Python](https://github.com/dbos-inc/dbos-python)
- [uv 包管理器](https://github.com/astral-sh/uv)

---

*持续更新中...*
