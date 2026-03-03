# Claude Code Skills 调研报告 - 2026年3月 (持续更新)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub 实时搜索 + Antigravity Awesome Skills (970+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，覆盖以下方向：
1. 游戏客户端开发 (Unity/Godot/Unreal)
2. Python 开发 (FastAPI/异步/测试)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (浏览器自动化/GitHub 自动化)

### 数据来源

| 来源 | Skills 数量 | 说明 |
|------|-------------|------|
| Antigravity Awesome Skills | 970+ | 10+ AI 助手平台支持 |
| ClawHub Registry | 实时 | 最新热门 Skills |
| 官方 Claude Code | 50+ | 官方 Skills |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 评分/星标 |
|------------|------|---------|----------|
| game-development | antigravity | 游戏开发编排器 | 18.5K⭐ |
| unity-developer | antigravity | Unity 6 LTS 专家 | 高 |
| unity-ai-workflow-2026 | antigravity | Unity AI Workflow 2026 | 高 |
| godot-gdscript-patterns | antigravity | Godot 4 GDScript | 高 |
| unreal-engine-cpp-pro | antigravity | UE5 C++ 开发 | 高 |
| bevy-ecs-expert | antigravity | Bevy ECS (Rust) | 中 |
| game-audio | antigravity | 游戏音频 | 中 |
| game-art | antigravity | 游戏美术管线 | 中 |
| openclaw-godot-skill | ClawHub | 场景管理、节点操作 | 0.911 |

### 1.2 Game Development Orchestrator 详解

**来源**: Antigravity Awesome Skills

**核心能力**: 智能路由到子 Skills，实现全栈游戏开发支持

```markdown
### 子技能路由矩阵

#### 平台选择
| 目标平台 | 子技能 |
|---------|--------|
| Web 浏览器 (HTML5/WebGL) | game-development/web-games |
| 移动端 (iOS/Android) | game-development/mobile-games |
| PC (Steam/Desktop) | game-development/pc-games |
| VR/AR 头显 | game-development/vr-ar |

#### 游戏类型
| 游戏类型 | 子技能 |
|---------|--------|
| 2D (精灵/瓦片地图) | game-development/2d-games |
| 3D (网格/着色器) | game-development/3d-games |

#### 专业领域
| 需求 | 子技能 |
|------|--------|
| GDD/平衡/玩家心理 | game-development/game-design |
| 多人/网络 | game-development/multiplayer |
| 视觉风格/资产管线 | game-development/game-art |
| 音效/音乐 | game-development/game-audio |
```

### 1.3 游戏开发核心原则

```markdown
### 1. 游戏循环 (Game Loop)
```
INPUT → UPDATE (固定时间步 50Hz) → RENDER (插值)
```

### 2. 模式选择矩阵
| 模式 | 使用场景 | 示例 |
|------|---------|------|
| **状态机** | 3-5 个离散状态 | 玩家: Idle→Walk→Jump |
| **对象池** | 频繁生成/销毁 | 子弹、粒子 |
| **ECS** | 数千相似实体 | RTS 单位 |
| **行为树** | 复杂 AI 决策 | 敌人 AI |

### 3. 性能预算 (60 FPS = 16.67ms)
| 系统 | 预算 |
|------|------|
| 输入 | 1ms |
| 物理 | 3ms |
| AI | 2ms |
| 游戏逻辑 | 4ms |
| 渲染 | 5ms |
```

### 1.4 Unity Developer 核心能力

**来源**: Antigravity Awesome Skills

```markdown
### 核心能力
- Unity 6 LTS 特性和长期支持优势
- URP/HDRP 渲染管线优化
- Shader Graph 可视化着色器
- DOTS/ECS 架构
- Job System 和 Burst Compiler
- Unity Netcode for GameObjects
- 客户端-服务器同步

### 典型交互
- "使用 Unity Netcode 架构多人游戏"
- "使用 URP 优化移动游戏性能"
- "使用 Shader Graph 创建风格化渲染"
```

### 1.5 Godot GDScript Patterns

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

### 1.6 Unreal Engine C++ Pro

```markdown
### UE5 C++ 开发专家
- UObject 卫生和生命周期
- 性能模式
- Slate UI 系统
- 网络复制
- Niagara VFX
- Lumen 和 Nanite
```

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 评分 |
|------------|------|---------|------|
| python-executor | ClawHub | 安全沙箱执行 Python | 3.480 |
| python-dataviz | ClawHub | 数据可视化 | 3.428 |
| async-python-patterns | antigravity | asyncio 异步编程 | 高 |
| python-testing-patterns | antigravity | pytest 测试策略 | 高 |
| dbos-python | antigravity | DBOS Python 框架 | 中 |
| python-script-generator | ClawHub | 脚本生成 | 3.220 |
| python-pro | antigravity | Python Pro | 高 |
| uv-python | antigravity | uv 快速包管理 | 高 |

### 2.2 Python Executor 详解 (评分: 3.480)

**来源**: ClawHub

```markdown
### 核心能力
- 安全沙箱执行
- 依赖预装: NumPy, Pandas, Matplotlib, requests, BeautifulSoup
- 数据处理和分析
- 可视化图表生成
- 文件 I/O 操作

### 适用场景
- 数据分析原型
- 快速脚本验证
- 自动化任务执行
- 数据可视化
```

### 2.3 Async Python Patterns 详解

**来源**: Antigravity Awesome Skills

```markdown
### 核心能力
- asyncio 事件循环管理
- async/await 语法
- 并发任务管理
- 异步生成器

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- FastAPI: 异步 Web 框架

### 示例代码
```python
import asyncio

async def fetch_data(url: str) -> dict:
    await asyncio.sleep(0.1)
    return {"url": url, "data": "result"}

async def fetch_all(urls: list) -> list:
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

asyncio.run(fetch_all(["url1", "url2"]))
```
```

### 2.4 Python Testing Patterns

```markdown
### 核心能力
- pytest 测试框架
- Fixtures 测试夹具
- Mocking 模拟对象
- Parameterization 参数化
- Property-based testing

### 测试策略矩阵
| 策略 | 范围 | 速度 |
|------|------|------|
| 单元测试 | 函数/类 | 快 |
| 集成测试 | 模块/服务 | 中 |
| E2E 测试 | 完整流程 | 慢 |
```

---

## 🧪 三、自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 评分 |
|------------|------|---------|------|
| test-runner | ClawHub | 测试运行器 | 3.639 |
| test-master | ClawHub | 测试大师 | 3.576 |
| test-patterns | ClawHub | 测试模式 | 3.548 |
| playwright | ClawHub | 浏览器自动化 | 3.538 |
| playwright-mcp | ClawHub | Playwright MCP | 3.581 |
| playwright-scraper-skill | ClawHub | 网页抓取 | 3.584 |
| e2e-testing-patterns | antigravity | E2E 测试模式 | 2.406 |
| browser-automation | antigravity | 浏览器自动化 | 高 |

### 3.2 Test Runner (评分: 3.639)

**来源**: ClawHub

```markdown
### 核心能力
- 多框架支持 (pytest, Jest, Mocha)
- 并行执行
- 测试选择和过滤
- JUnit XML 报告
- HTML 报告
- CI/CD 集成
```

### 3.3 Playwright Skills 专题

**来源**: ClawHub 实时搜索

| Skill ID | 评分 |
|----------|------|
| playwright-scraper-skill | 3.584 |
| playwright-mcp | 3.581 |
| playwright | 3.538 |
| playwright-browser-automation | 3.509 |

```markdown
### 核心能力
- 浏览器自动化
- 表单填写和提交
- 页面截图
- 数据提取
- E2E 测试
- 视觉回归测试
- MCP 协议集成
```

### 3.4 E2E Testing Patterns

**来源**: Antigravity Awesome Skills

```markdown
### 核心能力
- Playwright 和 Cypress 测试
- 可靠的测试套件构建
- 跨浏览器测试
- 响应式设计测试
- 可访问性验证

### 测试原则
1. 识别关键用户旅程
2. 构建稳定选择器
3. 测试隔离
4. 并行化执行
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 GitHub 专题

| Skill | 评分 |
|-------|------|
| github | 3.790 |
| github-cli | 3.501 |
| github-mcp | 3.456 |
| github-actions-generator | 3.238 |

```markdown
### 核心能力
- 仓库管理
- PR 创建和审批
- Issue 管理
- GitHub Actions Workflow
- CI/CD 配置
```

### 4.2 Docker 专题

| Skill | 评分 |
|-------|------|
| docker-essentials | 3.694 |
| docker | 3.577 |
| docker-compose | 3.511 |
| docker-sandbox | 3.548 |

```markdown
### 核心能力
- Dockerfile 最佳实践
- 多阶段构建
- 容器管理
- 网络配置
- 安全最佳实践
```

### 4.3 自动化工作流

| Skill | 评分 |
|-------|------|
| automation-workflows | 3.699 |
| workflow-automation | 高 |
| windows-ui-automation | 3.536 |

---

## 📈 Skills 评分排行榜 (Top 15)

| 排名 | Skill | 类别 | 评分 |
|------|-------|------|------|
| 1 | github | DevOps | 3.790 |
| 2 | automation-workflows | Automation | 3.699 |
| 3 | docker-essentials | DevOps | 3.694 |
| 4 | test-runner | Testing | 3.639 |
| 5 | playwright-scraper-skill | Automation | 3.584 |
| 6 | playwright-mcp | Automation | 3.581 |
| 7 | test-master | Testing | 3.576 |
| 8 | docker | DevOps | 3.577 |
| 9 | test-patterns | Testing | 3.548 |
| 10 | playwright | Automation | 3.538 |
| 11 | python-executor | Python | 3.480 |
| 12 | python-dataviz | Python | 3.428 |
| 13 | docker-compose | DevOps | 3.511 |
| 14 | windows-ui-automation | Automation | 3.536 |
| 15 | github-cli | DevOps | 3.501 |

---

## 📦 安装指南

### ClawHub 安装

```bash
# 搜索 Skills
clawhub search <keyword>

# 安装 Skills
clawhub install <skill-id>
```

### Antigravity 安装

```bash
npx antigravity-awesome-skills --claude
```

---

## 🔗 资源链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [ClawHub Registry](https://clawhub.com)
- [Claude Code 官方](https://github.com/anthropics/claude-code)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)

---

**文档版本**: 2026.03.04.1  
**调研完成**: ✅
