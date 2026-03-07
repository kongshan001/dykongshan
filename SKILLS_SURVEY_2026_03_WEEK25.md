# Claude Code Skills 完整调研报告 - 2026年3月 (第二十五周)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub 实时搜索 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，基于 GitHub 热门项目搜索和 ClawHub 实时排行，覆盖以下方向：
1. **游戏客户端开发** (Unity/Godot/Unreal/Love2D)
2. **Python 开发** (FastAPI/异步/类型安全)
3. **游戏客户端自动化测试** (移动端/UI 自动化)
4. **开发者工具** (浏览器自动化/GitHub 自动化/Docker)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| game-cog | **1.132** | 游戏开发编排器，DeepResearch Bench 第一名 | 通用游戏开发 |
| game-developer-skill | **0.975** | Claude 游戏开发者 | AI 辅助开发 |
| fivem-dev | **0.958** | Fivem 开发 | GTA5 Mod 开发 |
| blender | **0.925** | Blender 3D 建模 | 3D 资产制作 |
| game-engine | **0.920** | 游戏引擎架构 | 引擎原理 |
| unity | **0.961** | Unity 最佳实践 | Unity 开发 |
| unreal-engine | **0.935** | Unreal Engine 开发 | UE 开发 |
| godot-dev-guide | **0.983** | Godot 4.x 完整开发指南 | Godot 开发 |

### 1.2 2026年3月新增游戏开发 Skills

#### 1.2.1 Claude Code Game Studios

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)  
**GitHub Stars**: 28⭐ (2026年2月新增)

```markdown
## 核心特性
- 48 个 AI agents，专门针对游戏开发
- 36 个 workflow skills，覆盖完整游戏开发流程
- 完整的协调系统，模拟真实游戏工作室层级结构
- 支持 Unity/Unreal/Godot 多引擎

## Agent 类型
- 游戏设计师 Agent
- 程序员 Agent (客户端/服务器)
- 美术/动画 Agent
- 音效 Agent
- QA 测试 Agent
- 项目管理 Agent
```

#### 1.2.2 Unity AI Workflow 2026

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)  
**GitHub Stars**: 4⭐ (2026年3月新增)

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

#### 1.2.3 CellCog / Game-Cog 深度解析

**项目地址**: [nitishgargiitd/CellCog](https://github.com/nitishgargiitd/CellCog)  
**ClawHub 评分**: 1.132 (排名第一)

```markdown
### 核心能力
- 游戏世界构建器，不同于传统 sprite 生成器
- DeepResearch Bench 2026年2月第一名
- 角色一致性艺术、sprite 生成
- 游戏设计推理深度能力

### 技术特点
- Cell-based 游戏世界架构
- 程序化内容生成 (PCG)
- 游戏设计模式库
- AI 驱动的游戏机制设计
```

### 1.3 游戏引擎专题

#### 1.3.1 Unity 开发 Skills

| Skill | 评分 | 说明 |
|-------|------|------|
| unity | 0.961 | Unity 最佳实践 |
| unity-ai-workflow | 0.950 | Unity AI 工作流 |
| unity-dev | 0.940 | Unity 开发指南 |

**Unity 6.2+ 新特性**:
- 改进的多线程处理
- 增强的 DOTS 支持
- WebGPU 渲染预览
- AI Navigation 2.0

#### 1.3.2 Godot 开发 Skills

| Skill | 评分 | 说明 |
|-------|------|------|
| godot-dev-guide | 0.983 | Godot 4.x 开发指南 |
| godot | 0.920 | Godot 基础 |
| gdscript-pro | 0.910 | GDScript 专业开发 |

**Godot 4.x 特性**:
- GDScript 2.0 性能提升
- Vulkan 渲染器
- 改进的节点系统
- 更好的 C# 支持

#### 1.3.3 Unreal Engine Skills

| Skill | 评分 | 说明 |
|-------|------|------|
| unreal-engine | 0.935 | Unreal Engine 开发 |
| ue5-blueprint | 0.920 | Blueprint 可视化编程 |
| ue5-cpp | 0.910 | C++ 开发指南 |

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| py | **1.049** | Python 核心开发 | 通用 Python |
| python | **1.000** | Python 编程 | 基础开发 |
| python-executor | **0.973** | Python 代码执行 | 脚本运行 |
| fastapi | **1.054** | FastAPI 开发 | API 开发 |
| uv-global | **1.092** | UV 包管理器 | 工具链 |

### 2.2 Python 开发 Skills 详解

#### 2.2.1 uv - 最快 Python 包管理器

**ClawHub 评分**: 1.092 ⭐⭐⭐⭐⭐

```markdown
## 核心特性
- 2024 年最快 Python 包管理器
- 10-100x 比 pip 快
- 内置 Python 版本管理
- 虚拟环境管理

## 安装
curl -LsSf https://astral.sh/uv/install.sh | sh

## 使用
uv pip install package-name
uv venv
uv sync
```

#### 2.2.2 FastAPI Pro - 生产级 API 开发

**ClawHub 评分**: 1.054

```markdown
## 核心能力
- FastAPI 生产级工程
- Pydantic v2 类型验证
- SQLAlchemy 2.0 异步
- JWT/SSO 认证
- OpenAPI 自动文档
- Docker/K8s 部署

## 项目结构
app/
├── api/
│   └── v1/
├── core/
├── models/
├── schemas/
├── services/
└── main.py
```

#### 2.2.3 Python Testing Patterns

```markdown
## pytest 最佳实践
- Fixture 生命周期管理
- 参数化测试
- Mock 和 Patch
- 覆盖率配置

## 测试策略
- 单元测试 (Unit)
- 集成测试 (Integration)
- E2E 测试
- 性能测试

## 工具链
- pytest
- pytest-cov
- pytest-asyncio
- hypothesis (属性测试)
```

### 2.3 2026年新增 Python Skills

#### 2.3.1 Pydantic AI Skills

**项目地址**: [DougTrajano/pydantic-ai-skills](https://github.com/DougTrajano/pydantic-ai-skills)  
**GitHub Stars**: 138⭐

```markdown
## 核心特性
- 实现 Agent Skills (https://agentskills.io) 支持
- 渐进式披露 (Progressive Disclosure) 模式
- 支持文件系统和工作流 Skills
- 专为 Pydantic AI 设计

## 使用场景
- LLM 应用开发
- AI Agent 构建
- 类型安全的 AI 工作流
```

#### 2.3.2 Temporal Python Pro

```markdown
## 工作流引擎
- 持久化执行
- 活动重试策略
- 长时间运行任务
- 分布式事务

## 核心概念
- Workflow: 业务逻辑定义
- Activity: 具体执行任务
- Temporal Client: 工作流管理
- Worker: 任务执行器
```

---

## 🧪 三、自动化测试 Skills

### 3.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| test-runner | **1.189** | 测试运行器 | 测试执行 |
| test-patterns | **1.157** | 测试模式 | 测试设计 |
| test-master | **1.107** | 测试主管 | 测试管理 |
| e2e-testing-patterns | **1.072** | E2E 测试 | 端到端 |
| playwright-browser-automation | **1.041** | Playwright 自动化 | 浏览器 |

### 3.2 测试 Skills 详解

#### 3.2.1 Test Runner - 智能测试运行

**ClawHub 评分**: 1.189 ⭐⭐⭐⭐⭐

```markdown
## 核心能力
- 智能测试选择
- 并行执行优化
- 失败重试策略
- 测试分组管理

## 特性
- 增量测试运行
- 依赖感知调度
- 资源池管理
- CI/CD 集成
```

#### 3.2.2 E2E Testing Patterns - Playwright/Cypress

**ClawHub 评分**: 1.072

```markdown
## Playwright 特性
- 跨浏览器自动化
- 自动等待机制
- 截图和录制
- 网络拦截
- 移动端模拟

## Cypress 特性
- 实时重载
- 自动等待
- 调试友好
- 网络控制
```

#### 3.2.3 Playwright Browser Automation

**ClawHub 评分**: 1.041

```markdown
## 自动化能力
- 浏览器控制
- 元素定位
- 表单交互
- 截图验证
- 性能监控

## 使用场景
- Web 应用测试
- 爬虫数据抓取
- 截图生成
- 自动化工作流
```

### 3.3 游戏客户端测试专题

#### 3.3.1 Unity Test Framework

```markdown
## 测试类型
- Edit Mode: 纯 C# 逻辑测试
- Play Mode: 集成测试

## 核心组件
- TestRunner: 测试运行器
- NUnit: 测试框架
- UnityTestAttribute: 协程测试
- UnityWebRequest: 网络测试

## 示例
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

#### 3.3.2 游戏网络同步测试

```markdown
## 帧同步测试
- 确定性验证: 相同输入 → 相同输出
- 断线重连测试
- 录像回放验证

## 状态同步测试
- 状态一致性验证
- 增量同步效率
- 预测回滚测试

## 延迟模拟
- 网络抖动 (Jitter): 0-200ms
- 丢包模拟: 5%-20%
- 高延迟环境: 200-500ms RTT
```

#### 3.3.3 移动端游戏测试

```markdown
## Android 测试
- ADB 命令基础
- uiautomator dump UI 检查
- 触摸事件模拟
- 截图验证

## iOS 测试
- XCUITest 框架
- Instruments 性能分析
- 设备兼容性测试

## 游戏特定测试
- 触控响应延迟
- 陀螺仪/重力感应
- 内存/电量消耗
- 网络切换 (WiFi → 4G)
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| git-essentials | **1.298** | Git 基础 | 版本控制 |
| docker-essentials | **1.254** | Docker 基础 | 容器化 |
| git | **1.215** | Git 完整指南 | 版本控制 |
| docker | **1.153** | Docker 完整指南 | 容器化 |
| git-workflows | **1.155** | Git 工作流 | 团队协作 |
| gitlab-cli-skills | **1.103** | GitLab CLI | GitLab 自动化 |
| container-debug | **1.095** | 容器调试 | 问题排查 |

### 4.2 开发者工具 Skills 详解

#### 4.2.1 Git Essentials - 版本控制

**ClawHub 评分**: 1.298 ⭐⭐⭐⭐⭐

```markdown
## 核心能力
- 基础命令 (add, commit, push, pull)
- 分支管理
- 冲突解决
- 历史管理

## 高级特性
- Rebase 工作流
- Cherry-pick
- Stash
- 子模块

## 团队协作
- Fork 工作流
- Pull Request
- Code Review
- 标签管理
```

#### 4.2.2 Docker Essentials - 容器化

**ClawHub 评分**: 1.254 ⭐⭐⭐⭐⭐

```markdown
## 核心概念
- 镜像和容器
- Dockerfile 最佳实践
- Docker Compose
- 网络和存储

## 开发工作流
- 开发环境容器化
- 多阶段构建
- 体积优化
- 安全扫描

## 部署
- Docker Swarm
- K8s 集成
- CI/CD 流水线
- 监控和日志
```

#### 4.2.3 Git Workflows - 团队协作

**ClawHub 评分**: 1.155

```markdown
## 工作流模式
- GitFlow: 特性/发布/热修复分支
- GitHub Flow: 主干开发
- Trunk-Based: 快速集成
- Forking: 开源协作

## 自动化
- Hooks
- CI/CD 集成
- 自动化测试
- 部署触发
```

#### 4.2.4 GitLab CLI Skills

**ClawHub 评分**: 1.103

```markdown
## 功能
- 项目管理
- CI/CD 流水线
- Merge Request
- 问题跟踪
- 代码片段

## 自动化
- 脚本化工作流
- 批量操作
- 报告生成
```

### 4.3 浏览器自动化专题

#### 4.3.1 Agent Browser (ClawDBot)

**ClawHub 评分**: 1.189

```markdown
## 核心能力
- 浏览器控制
- 页面交互
- 数据提取
- 截图/录制

## 使用场景
- Web 自动化测试
- 数据抓取
- UI 截图
- 表单填写
```

---

## 📈 五、Skills 发展趋势

### 5.1 2026年 Skills 发展特点

1. **AI 驱动**: 越来越多的 Skills 集成 AI 能力
2. **专业化**: 垂直领域 Skills 快速增长
3. **工作流**: 从单一命令到完整工作流编排
4. **多模态**: 支持文本、代码、图像等多种输入

### 5.2 ClawHub Top 30 排行榜

| 排名 | Skill | 评分 | 类别 |
|------|-------|------|------|
| 1 | git-essentials | 1.298 | 开发工具 |
| 2 | docker-essentials | 1.254 | 开发工具 |
| 3 | git | 1.215 | 开发工具 |
| 4 | test-runner | 1.189 | 测试 |
| 5 | agent-browser-clawdbot | 1.189 | 浏览器 |
| 6 | test-patterns | 1.157 | 测试 |
| 7 | git-workflows | 1.155 | 开发工具 |
| 8 | docker | 1.153 | 开发工具 |
| 9 | test-master | 1.107 | 测试 |
| 10 | uv-global | 1.092 | Python |

---

## 📝 六、平替对比

### 6.1 游戏开发 Skills 对比

| Skill | 评分 | 特点 | 适用 |
|-------|------|------|------|
| game-cog | 1.132 | 世界构建器 | 通用游戏 |
| unity-ai-workflow | 0.950 | Unity 专用 | Unity 开发 |
| godot-dev-guide | 0.983 | Godot 专用 | Godot 开发 |
| unreal-engine | 0.935 | UE 专用 | Unreal 开发 |

### 6.2 Python 开发 Skills 对比

| Skill | 评分 | 特点 | 适用 |
|-------|------|------|------|
| uv-global | 1.092 | 包管理 | 工具链 |
| fastapi | 1.054 | API 开发 | Web |
| python | 1.000 | 基础开发 | 通用 |
| py | 1.049 | 核心开发 | 通用 |

### 6.3 测试 Skills 对比

| Skill | 评分 | 特点 | 适用 |
|-------|------|------|------|
| test-runner | 1.189 | 智能运行 | 测试执行 |
| test-patterns | 1.157 | 测试设计 | 模式 |
| e2e-testing-patterns | 1.072 | E2E | Web 测试 |
| playwright-browser | 1.041 | 浏览器 | 自动化 |

---

## 🎯 七、落地建议

### 7.1 游戏开发推荐

```
优先级顺序:
1. game-cog - 通用游戏开发编排
2. unity-ai-workflow / godot-dev-guide - 引擎专用
3. blender - 3D 资产制作
```

### 7.2 Python 开发推荐

```
优先级顺序:
1. uv-global - 现代化工具链
2. fastapi - API 开发
3. python-testing-patterns - 测试
4. async-python-patterns - 高并发
```

### 7.3 测试推荐

```
优先级顺序:
1. test-patterns - 测试设计
2. e2e-testing-patterns - E2E
3. playwright-browser - 浏览器自动化
4. 游戏特定: Unity Test Framework
```

### 7.4 开发者工具推荐

```
优先级顺序:
1. git-essentials - 版本控制
2. docker-essentials - 容器化
3. git-workflows - 团队协作
```

---

## 📎 相关链接

- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [ClawHub Skills 市场](https://clawhub.com)
- [VoltAgent awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)

---

*文档更新时间: 2026-03-04*
