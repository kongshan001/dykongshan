# Claude Code Skills 补充调研报告（第四周）

> 游戏客户端开发 / Python 开发 / 测试自动化 / 开发者工具

**更新日期**: 2026-03-03
**调研范围**: Antigravity Awesome Skills (968+ Skills) + GitHub 热门项目

---

## 📋 目录

1. [游戏客户端开发](#1-游戏客户端开发)
2. [Python 开发](#2-python-开发)
3. [游戏客户端自动化测试](#3-游戏客户端自动化测试)
4. [开发者工具](#4-开发者工具)
5. [本周新增 Skills](#5-本周新增-skills)
6. [快速开始指南](#6-快速开始指南)

---

## 1. 游戏客户端开发

### 1.1 核心 Skills 矩阵

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

### 1.2 Unity AI Workflow 2026 (新增)

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

```markdown
### 三种开发模式
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助 | 学习、创意控制 |
| Mix (默认) | 协作模式 | 大多数项目 |
| Automatic | AI 构建 | 快速原型、游戏 jam |

### 核心哲学: Game Feel
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈
- 迭代打磨，不是单独阶段

### 项目阶段
00: Ideation → 01: Pre-Production → 02: Technical Design
→ 03: Project Setup → 04: Production → 05: Polish
```

### 1.3 Multiplayer 游戏开发专题

```markdown
### 架构选择
| 架构 | 延迟 | 成本 | 安全性 |
|------|------|------|--------|
| 专属服务器 | 低 | 高 | 强 |
| P2P | 变化 | 低 | 弱 |
| 主机模式 | 中 | 低 | 中 |

### 同步方案
| 方案 | 同步内容 | 适用场景 |
|------|---------|---------|
| 状态同步 | 游戏状态 | 简单物体少 |
| 输入同步 | 玩家输入 | 动作游戏 |
| 混合 | 两者结合 | 大多数 |

### 延迟补偿技术
- 预测: 客户端预测服务器结果
- 插值: 平滑远程玩家移动
- 调解: 修正错误预测
- 延迟补偿: 回滚用于命中检测
```

### 1.4 移动端游戏开发

```markdown
### 平台约束
| 约束 | 策略 |
|------|------|
| 触控输入 | 大点击区域、手势 |
| 电池 | 限制 CPU/GPU |
| 热节流 | 热时降级 |
| 屏幕尺寸 | 响应式 UI |

### 性能目标
- 帧率: 30 FPS 通常足够
- 触控目标: 最小 44x44 点
- 优化: 暂停时睡眠、最小化网络
```

---

## 2. Python 开发

### 2.1 核心 Skills 矩阵

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

### 2.2 Python 3.12+ 现代工具链

```markdown
### 2024/2025 主流工具
| 工具 | 用途 | 替代 |
|------|------|------|
| uv | 包管理 | pip |
| ruff | 格式化/lint | black/isort/flake8 |
| mypy/pyright | 类型检查 | - |
| pyproject.toml | 项目配置 | setup.py |

### uv 优势
- 10-100x 更快 than pip
- 依赖解析更准确
- 内置虚拟环境管理
- 锁文件支持
```

### 2.3 FastAPI 生产级实践

```markdown
### 核心特性
- Pydantic v2 数据验证
- SQLAlchemy 2.0 异步支持
- OpenAPI 自动文档
- 依赖注入系统

### 认证方案
- JWT Bearer
- OAuth2 密码流
- API Key

### 部署
- Uvicorn/Gunicorn
- Docker 多阶段构建
- K8s 健康检查
```

### 2.4 Async Python 模式

```markdown
### 适用场景
- 高并发 I/O 密集型服务
- 实时 WebSocket 应用
- 爬虫和数据采集
- 微服务间通信

### 生态库
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis (aioredis)
```

---

## 3. 游戏客户端自动化测试

### 3.1 核心 Skills 矩阵

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| `test-automator` | AI 驱动测试自动化 | 智能测试生成 |
| `e2e-testing-patterns` | Playwright/Cypress | 端到端测试 |
| `playwright-skill` | Playwright 专项 | 浏览器自动化 |
| `python-testing-patterns` | pytest 最佳实践 | Python 测试 |
| `testing-patterns` | Jest 测试模式 | JS/TS 测试 |
| `test-driven-development` | TDD 开发流程 | 测试先行 |
| `test-fixing` | 测试修复 | 失败测试 |
| `testing-qa` | 综合 QA 工作流 | 质量保证 |

### 3.2 Unity Test Framework

```markdown
### 测试类型
- Edit Mode: 纯 C# 逻辑测试，无需运行游戏
- Play Mode: 集成测试，运行游戏场景

### 核心组件
- TestRunner: 测试运行器
- NUnit: 测试框架
- UnityTestAttribute: 协程测试

### 示例测试
```csharp
[UnityTest]
public IEnumerator PlayerMove_Test()
{
    var player = new GameObject("Player");
    var mover = player.AddComponent<PlayerMover>();
    
    mover.Move(Vector2.right);
    yield return null;
    
    Assert.AreEqual(Vector2.right, mover.Velocity);
}
```
```

### 3.3 游戏网络同步测试

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

### 3.4 移动端游戏测试

```markdown
### Android UI 自动化
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

### 3.5 Playwright 高级专题

```markdown
### 核心特性
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 默认使用可见浏览器
- URL 参数化配置

### 常见模式
- 页面测试 (多视口)
- 登录流程测试
- 表单填写和提交
- 响应式设计测试
```

---

## 4. 开发者工具

### 4.1 核心 Skills 矩阵

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

### 4.2 GitHub Actions 自动化

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

### 4.3 Docker 专家

```markdown
### 最佳实践
- 多阶段构建
- 最小化镜像
- 层缓存优化
- 安全扫描

### Python Docker
- 基础镜像选择
- 依赖安装优化
- 非 root 用户
- 健康检查
```

### 4.4 DevOps 排错

```markdown
### 常见场景
- Pod 启动失败
- 内存/CPU 过高
- 网络连接问题
- 日志分析

### 工具
- kubectl 调试
- 日志聚合
- 监控告警
```

---

## 5. 本周新增 Skills

### 5.1 新增 Skills 列表

| Skill 名称 | 类别 | 描述 | 日期 |
|-----------|------|------|------|
| `android_ui_verification` | 移动端测试 | Android E2E UI 测试 | 2026-02-28 |
| `azure-microsoft-playwright-testing-ts` | 云测试 | Azure Playwright 云测 | 2026-02-27 |
| `agent-evaluation` | AI 代理 | LLM 代理测试和基准 | 2026-02-27 |
| `agent-manager-skill` | 代理管理 | 多 CLI 代理管理 | 2026-02-27 |
| `agent-memory-mcp` | 代理记忆 | MCP 记忆系统 | 2026-02-27 |
| `agent-orchestration-multi-agent-optimize` | 多代理 | 多代理编排优化 | 2026-02-27 |

### 5.2 重点新增 Skills 详解

#### azure-microsoft-playwright-testing-ts

```markdown
### 功能
- Playwright 云端规模化测试
- Azure Playwright Workspaces
- 跨浏览器云测试

### 适用场景
- 大规模并行测试
- 无需自建测试基础设施
- CI/CD 集成
```

#### agent-evaluation

```markdown
### 功能
- LLM 代理行为测试
- 能力评估
- 可靠性指标
- 生产环境测试

### 评估维度
- 任务完成率
- 响应时间
- 错误率
- 成本效率
```

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

# Python 开发
>> /python-pro 设置现代 Python 项目
>> /fastapi-pro 创建生产级 API

# 测试
>> /e2e-testing-patterns 设置 Playwright 测试
>> /test-driven-development 使用 TDD 开发

# 开发者工具
>> /github-automation 创建 CI 工作流
>> /docker-expert 优化 Dockerfile
```

### 6.3 推荐学习路径

```
游戏开发:
1. 2d-games / 3d-games (基础)
2. unity-developer / godot-gdscript-patterns (引擎)
3. multiplayer (网络)
4. mobile-games (移动端)

Python 开发:
1. python-patterns (原则)
2. python-pro (现代工具链)
3. python-fastapi-development (Web)
4. async-python-patterns (高并发)

测试:
1. testing-patterns / python-testing-patterns (基础)
2. e2e-testing-patterns (E2E)
3. test-driven-development (TDD)
4. test-automator (AI 驱动)

开发者工具:
1. browser-automation (浏览器)
2. github-automation (GitHub)
3. cicd-automation-workflow-automate (CI/CD)
4. docker-expert (容器)
```

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)
- [Unity AI Workflow 2026](https://github.com/David-GD13/unity-ai-workflow)

---

*持续更新中...*
