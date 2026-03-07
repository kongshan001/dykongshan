# Claude Code Skills 调研报告 - 2026年3月 Week 45

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (968+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 持续调研更新

---

## 📊 调研概要

本次调研基于 GitHub API 实时搜索获取的最新热门 Skills，持续关注以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/CI/CD/GitHub 自动化)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| Claude-Code-Game-Studios | 29⭐ | 48 agents 完整游戏开发工作室，36 workflow skills | 2026-03-04 |
| skills-weaver | 15⭐ | RPG 角色扮演游戏 Claude Code Agent SDK | 2026-03-01 |
| love2d-pocket-bomber-game | 11⭐ | 使用 Claude Code 和 Love2D vibe coding Bomberman clone | 2026-02-28 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能集 | 2026-02-27 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 | 2026-03-02 |
| unreal-engine-skills | 1⭐ | Unreal Engine C++ skills，27 skills 覆盖游戏玩法/渲染/网络 | 2026-03-03 |
| Godot-Skills | - | Godot 4.x GDScript 开发技能 | - |

### 1.2 重点 Skills 深度分析

#### 1.2.1 Claude-Code-Game-Studios ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/Donchitos/Claude-Code-Game-Studios  
**Stars**: 29  
**更新**: 2026-03-04

> 将 Claude Code 转变为完整的游戏开发工作室 — 48 个 AI agents、36 个工作流技能和完整的协调系统。

**核心架构**:

| 层级 | 代理数 | 模型 | 职责 |
|------|--------|------|------|
| Tier 1 | Opus | 创意/技术决策 | 战略规划 |
| Tier 2 | Sonnet | 任务执行 | 开发和实现 |
| Tier 3 | Sonnet/Haiku | 日常任务 | 代码生成/测试 |

**引擎支持**:

| 引擎 | 主代理 | 子专家 |
|------|--------|--------|
| Godot 4 | godot-specialist | GDScript, Shaders, GDExtension |
| Unity | unity-specialist | DOTS/ECS, Shaders/VFX, Addressables |
| Unreal 5 | unreal-specialist | GAS, Blueprints, Replication, UMG |

**斜杠命令** (36个):
- `/design-review` - 设计审查
- `/code-review` - 代码审查
- `/balance-check` - 平衡性检查
- `/sprint-plan` - 冲刺计划
- `/asset-pipeline` - 资产管线
- `/multiplayer-arch` - 多人游戏架构

**适用场景**:
- 大型游戏项目需要多角色协作
- 需要完整的开发流程和审查机制
- 团队级游戏开发工作流

**本地部署**:
```bash
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git
cd Claude-Code-Game-Studios
npm install
# 配置 CLAUDE.md 中的 API 密钥
```

---

#### 1.2.2 OH-Unity-GameDev-Skills ⭐⭐⭐

**GitHub**: https://github.com/OstrichHermit/OH-Unity-GameDev-Skills  
**Stars**: 6  
**更新**: 2026-02-27

> 符合 Claude Code Skills 规范的 Unity 游戏开发代理技能集。

**核心能力**:

| 类别 | Skills |
|------|--------|
| 脚本开发 | C# 脚本编写、Unity API 使用 |
| 资产管理 | Asset 管理、Prefab 创建 |
| 场景管理 | 场景切换、关卡设计 |
| 性能优化 | 渲染优化、内存管理 |

**适用场景**:
- Unity 项目快速原型开发
- C# 脚本自动化生成
- Unity 最佳实践指导

**本地部署**:
```bash
git clone https://github.com/OstrichHermit/OH-Unity-GameDev-Skills.git
# 复制到 ~/.claude/skills/ 目录
```

---

#### 1.2.3 unity-ai-workflow ⭐⭐

**GitHub**: https://github.com/David-GD13/unity-ai-workflow  
**Stars**: 4  
**更新**: 2026-03-02

> AI-first Unity 6.2+ 游戏开发工作流 — 为 Claude Code 和 Antigravity 设计的规则、代理、技能和斜杠命令。

**核心特性**:

| 特性 | 描述 |
|------|------|
| Unity 6.2+ 支持 | 最新 Unity 版本特化 |
| AI 工作流 | AI 驱动的开发流程 |
| 斜杠命令 | 快速触发开发任务 |
| Antigravity 兼容 | 支持 Antigravity 平台 |

**适用场景**:
- Unity 6 新项目启动
- AI 辅助游戏开发
- 现代 Unity 开发实践

---

#### 1.2.4 unreal-engine-skills ⭐⭐

**GitHub**: https://github.com/quodsoler/unreal-engine-skills  
**Stars**: 1  
**更新**: 2026-03-03

> Unreal Engine C++ skills for AI coding agents。27 skills 覆盖游戏玩法、渲染、网络、动画等。

**技能覆盖**:

| 类别 | Skills 数量 |
|------|-------------|
| Gameplay | Actor、Component、Pawn、Character |
| Rendering | Material、Shader、Light、Post-process |
| Networking | Replicate、RPC、Session |
| Animation | Anim BP、Montage、Blend Space |

**适用场景**:
- Unreal Engine C++ 开发
- AAA 级游戏项目
- 网络同步实现

---

#### 1.2.5 skills-weaver ⭐⭐⭐

**GitHub**: https://github.com/nicmarti/skills-weaver  
**Stars**: 15  
**更新**: 2026-03-01

> 使用 Claude Code Agent SDK 的 RPG 角色扮演游戏。

**核心特性**:

| 特性 | 描述 |
|------|------|
| RPG 框架 | 完整的 RPG 游戏架构 |
| Agent SDK | Claude Code Agent SDK 集成 |
| 叙事驱动 | AI 驱动的游戏叙事 |

---

### 1.3 Antigravity Skills 分类

| Skill ID | 名称 | 描述 |
|----------|------|------|
| game-development | 游戏开发编排器 | 基于项目需求路由到平台特定 Skills |
| 2d-games | 2D 游戏开发 | Sprite、tilemap、物理、相机 |
| 3d-games | 3D 游戏开发 | 渲染、shader、物理、相机 |
| godot-gdscript-patterns | Godot GDScript 模式 | 信号、场景、状态机 |
| unity-developer | Unity 开发者 | 优化 C# 脚本、渲染、资产管理 |
| unity-ecs-patterns | Unity ECS 模式 | DOTS、Jobs、Burst 优化 |
| mobile-games | 移动端游戏 | 触摸输入、电池、性能 |
| multiplayer | 多人游戏 | 架构、网络、同步 |
| shader-programming-glsl | GLSL 着色器 | 顶点/片段着色器 |

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| pydantic-ai-skills | 140⭐ | Pydantic AI 的 Agent Skills 支持 | 2026-03-04 |
| python-rope-refactor | 36⭐ | 使用 rope 进行 Python 重构的技能 | 2026-02-01 |
| fastapi-mcp-server | -⭐ | FastAPI MCP 服务器技能 | - |

### 2.2 重点 Skills 深度分析

#### 2.2.1 pydantic-ai-skills ⭐⭐⭐⭐

**GitHub**: https://github.com/DougTrajano/pydantic-ai-skills  
**Stars**: 140  
**更新**: 2026-03-04

> 为 Pydantic AI 实现 Agent Skills 支持，支持渐进式展示。支持文件系统和编程式技能。

**核心特性**:

| 特性 | 描述 |
|------|------|
| 渐进式展示 | Progressive Disclosure 模式 |
| 文件系统支持 | 本地文件操作 |
| 编程式技能 | 代码定义的技能 |

**适用场景**:
- Pydantic AI 集成开发
- LLM Agent 开发
- 类型安全的 AI 应用

---

#### 2.2.2 python-rope-refactor ⭐⭐⭐

**GitHub**: https://github.com/brian-yu/python-rope-refactor  
**Stars**: 36  
**更新**: 2026-02-01

> 教 LLM agents 如何使用 rope 进行 Python 代码库重构的技能。

**核心能力**:

| 能力 | 描述 |
|------|------|
| 重构指导 | rope 工具使用指南 |
| 模式识别 | Python 代码模式 |
| 安全重构 | 风险评估和验证 |

**适用场景**:
- 大型 Python 代码库重构
- 自动化重构任务
- 代码质量提升

---

### 2.3 Python 开发 Skills 专题

| Skill ID | 名称 | 描述 |
|----------|------|------|
| python-type-safety | Python 类型安全 | mypy/pyright 严格检查 |
| fastapi-development | FastAPI 开发 | REST API、异步、依赖注入 |
| python-testing | Python 测试 | pytest、单元测试、Mock |
| python-async | Python 异步 | asyncio、aiohttp、异步模式 |
| python-devops | Python DevOps | 部署、CI/CD、容器化 |

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| playwright-skill | 1857⭐ | Playwright 浏览器自动化技能 | 2026-03-04 |
| ios-simulator-skill | 560⭐ | iOS 模拟器技能 | 2026-03-04 |

### 3.2 重点 Skills 深度分析

#### 3.2.1 playwright-skill ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/lackeyjb/playwright-skill  
**Stars**: 1857  
**更新**: 2026-03-04

> Claude Code 浏览器自动化 Playwright 技能。模型调用 — Claude 自主编写和执行自定义自动化进行测试和验证。

**核心能力**:

| 能力 | 描述 |
|------|------|
| 浏览器自动化 | 完整浏览器控制 |
| 测试自动化 | E2E 测试编写 |
| 验证框架 | 自动验证机制 |

**适用场景**:
- Web 应用 E2E 测试
- 浏览器自动化任务
- 游戏 Web 版本测试

**本地部署**:
```bash
# 使用 claude 安装
claude install playwright-skill

# 或手动安装
git clone https://github.com/lackeyjb/playwright-skill.git
cp -r playwright-skill ~/.claude/skills/
```

---

#### 3.2.2 ios-simulator-skill ⭐⭐⭐⭐

**GitHub**: https://github.com/conorluddy/ios-simulator-skill  
**Stars**: 560  
**更新**: 2026-03-04

> iOS 模拟器技能，用于优化 Claude 构建、运行和交互应用的能力，不消耗 token/ context 预算。

**核心能力**:

| 能力 | 描述 |
|------|------|
| 构建优化 | Xcode 项目构建 |
| 运行控制 | 模拟器管理 |
| 应用交互 | UI 测试自动化 |

**适用场景**:
- iOS 游戏测试
- 移动端应用测试
- Xcode 项目自动化

---

### 3.3 游戏客户端测试 Skills 缺口

| 方向 | 现状 | 建议 |
|------|------|------|
| Unity UI 测试 | 较少 | 可开发 NUnit/Playwright 集成 |
| 游戏性能测试 | 缺少 | 可开发帧率/内存监控 Skills |
| 多人游戏测试 | 稀缺 | 可开发网络模拟 Skills |
| 游戏截图对比 | 基础 | 可开发视觉回归测试 |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| awesome-claude-skills | 40533⭐ | Claude Skills 精选列表 | 2026-03-04 |
| refly | 6898⭐ | 开源 Agent Skills 构建器 | 2026-03-04 |
| awesome-agent-skills | 2665⭐ | AI 编码代理技能列表 | 2026-03-04 |
| claude-code-plugins-plus-skills | 1502⭐ | 270+ 插件，739 agent skills | 2026-03-04 |
| agentsys | 516⭐ | 14 插件，43 agents，30 skills | 2026-03-04 |
| claude-forge | 392⭐ | 11 AI agents，36 命令，15 skills | 2026-03-04 |

### 4.2 重点 Skills 深度分析

#### 4.2.1 agentsys ⭐⭐⭐⭐

**GitHub**: https://github.com/agent-sh/agentsys  
**Stars**: 516  
**更新**: 2026-03-04

> AI 写代码，自动化其他一切 — 14 插件，43 agents，30 skills。

**核心架构**:

| 组件 | 数量 | 描述 |
|------|------|------|
| Plugins | 14 | 功能插件 |
| Agents | 43 | AI 代理 |
| Skills | 30 | 技能模块 |

**支持平台**:
- Claude Code
- OpenCode
- Codex
- Cursor
- Kiro

**适用场景**:
- 完整开发流程自动化
- 多代理协作任务
- 生产级项目部署

---

#### 4.2.2 claude-forge ⭐⭐⭐⭐

**GitHub**: https://github.com/sangrokjung/claude-forge  
**Stars**: 392  
**更新**: 2026-03-04

> 11 个 AI agents，36 个命令，15 个 skills — 受 oh-my-zsh 启发的 Claude Code 插件框架。

**核心特性**:

| 特性 | 数量 |
|------|------|
| AI Agents | 11 |
| Commands | 36 |
| Skills | 15 |
| Security Hooks | 6 层 |

**适用场景**:
- 开发工作流增强
- 快速命令执行
- 安全保障

---

#### 4.2.3 developer-kit ⭐⭐⭐

**GitHub**: https://github.com/giuseppe-trisciuoglio/developer-kit  
**Stars**: 132  
**更新**: 2026-03-04

> Claude Code 开发工具包 — 模块化插件系统，提供可重用的 skills、agents 和命令。

**支持技术栈**:

| 类别 | 技术 |
|------|------|
| Java | Spring Boot, LangChain4J |
| TypeScript | NestJS, React |
| Python | Python, AI 模式 |
| PHP | WordPress |
| Cloud | AWS CloudFormation |

---

### 4.3 DevOps 工具 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| kube-audit-kit | 27⭐ | Kubernetes 安全审计 |
| claude-kubeadm-skills | 4⭐ | kubeadm 集群管理 |
| infra-skills | -⭐ | 基础设施技能 |

---

## 📈 五、ClawHub Top 10 排行榜

基于 ClawHub 实时搜索评分（2026-03-04）:

| 排名 | Skill | 评分 | 分类 |
|------|-------|------|------|
| 1 | awesome-claude-skills | 高 | 资源列表 |
| 2 | refly | 高 | Agent 构建器 |
| 3 | playwright-skill | 高 | 浏览器自动化 |
| 4 | awesome-agent-skills | 高 | 资源列表 |
| 5 | claude-code-plugins-plus-skills | 高 | 插件集合 |
| 6 | ios-simulator-skill | 高 | iOS 开发 |
| 7 | agentsys | 中高 | 开发自动化 |
| 8 | claude-forge | 中高 | 插件框架 |
| 9 | developer-kit | 中 | 开发工具包 |
| 10 | pydantic-ai-skills | 中 | Python AI |

---

## 🔍 六、本周更新亮点

### 6.1 新增 Skills

| Skill | 描述 | Stars |
|-------|------|-------|
| Claude-Code-Game-Studios | 完整游戏开发工作室 | 29⭐ |
| unreal-engine-skills | Unreal C++ 开发 | 1⭐ |
| ios-simulator-skill | iOS 模拟器自动化 | 560⭐ |

### 6.2 活跃更新

| Skill | 更新内容 |
|-------|----------|
| Claude-Code-Game-Studios | 持续更新 48 agents 架构 |
| playwright-skill | 浏览器自动化能力增强 |
| agentsys | 新增自动化模式 |

---

## 📋 七、Skills 缺口与建议

### 7.1 游戏开发方向

| 缺口 | 建议优先级 | 说明 |
|------|----------|------|
| Unity ECS 深度 | 高 | DOTS/ECS 架构指导 |
| Unreal Blueprint | 中 | 可视化编程支持 |
| Godot 4.x 进阶 | 中 | GDScript 高级模式 |
| 游戏性能分析 | 高 | 帧率/内存优化 |

### 7.2 Python 开发方向

| 缺口 | 建议优先级 | 说明 |
|------|----------|------|
| FastAPI Pro | 高 | 生产级 API 开发 |
| Python 测试进阶 | 中 | 集成测试/E2E |
| 异步架构 | 中 | 高并发模式 |

### 7.3 测试方向

| 缺口 | 建议优先级 | 说明 |
|------|----------|------|
| 游戏 UI 自动化 | 高 | Unity/Godot UI 测试 |
| 性能测试 | 高 | 游戏帧率/加载测试 |
| 视觉回归测试 | 中 | 截图对比 |

---

## 📱 八、相关资源

- **ClawHub**: https://clawhub.com
- ** Antigravity**: https://github.com/topicalcode/antigravity
- **Skills.sh**: https://skills.sh
- **Awesome Claude Skills**: https://github.com/ComposioHQ/awesome-claude-skills

---

*文档更新于 2026-03-04*
