# Claude Code Skills 调研报告 - 游戏/Python/测试/开发者工具

> 调研时间: 2026-03-04 (Week 45)
> 来源: ClawHub + GitHub API + Antigravity Skills (968+)
> 目标仓库: https://github.com/kongshan001/cc_skills

---

## 📊 调研概述

本次调研覆盖以下方向：
1. **游戏客户端开发** (Unity, Unreal, Godot, Bevy)
2. **Python 开发** (FastAPI, 异步, 类型安全)
3. **游戏客户端自动化测试** (移动端, UI, E2E)
4. **开发者工具** (浏览器自动化, CI/CD, Git)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill | 引擎 | 能力 | 评分/Stars |
|-------|------|------|-----------|
| Claude-Code-Game-Studios | 多引擎 | 48 agents, 36 workflow skills | 29⭐ |
| OH-Unity-GameDev-Skills | Unity | C#脚本, 资产管理, 性能优化 | 6⭐ |
| unity-ai-workflow | Unity 6.2+ | AI 开发工作流 | 4⭐ |
| unreal-engine-skills | Unreal 5 | C++ 开发, 27 skills | 1⭐ |
| skills-weaver | RPG | Agent SDK 集成 | 15⭐ |
| Godot-Skills | Godot 4 | GDScript 开发 | - |

### 1.2 Claude-Code-Game-Studios ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/Donchitos/Claude-Code-Game-Studios

> 将 Claude Code 转变为完整的游戏开发工作室

**核心架构**:

| 层级 | 模型 | 职责 |
|------|------|------|
| Tier 1 | Opus | 战略规划/创意决策 |
| Tier 2 | Sonnet | 任务执行/开发实现 |
| Tier 3 | Haiku | 代码生成/测试 |

**引擎支持**:

| 引擎 | 主代理 | 子专家 |
|------|--------|--------|
| Godot 4 | godot-specialist | GDScript, Shaders, GDExtension |
| Unity | unity-specialist | DOTS/ECS, Shaders/VFX |
| Unreal 5 | unreal-specialist | GAS, Blueprints, Replication |

**斜杠命令** (36个):
- /design-review - 设计审查
- /code-review - 代码审查  
- /balance-check - 平衡性检查
- /asset-pipeline - 资产管线

**部署**:
```bash
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git
cd Claude-Code-Game-Studios
npm install
```

### 1.3 Antigravity 游戏开发 Skills

| Skill ID | 描述 |
|----------|------|
| game-development | 游戏开发编排器 |
| 2d-games | 2D 游戏开发 |
| 3d-games | 3D 游戏开发 |
| godot-gdscript-patterns | Godot GDScript 模式 |
| unity-developer | Unity 开发者 |
| unity-ecs-patterns | Unity ECS/DOTS |
| mobile-games | 移动端游戏 |
| multiplayer | 多人游戏 |
| shader-programming-glsl | GLSL 着色器 |

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill | Stars | 描述 |
|-------|-------|------|
| pydantic-ai-skills | 140⭐ | Pydantic AI Agent Skills |
| python-rope-refactor | 36⭐ | rope 重构工具 |
| fastapi-mcp-server | - | FastAPI MCP 服务器 |

### 2.2 Python 开发 Skills 分类

| Skill ID | 描述 |
|----------|------|
| python-type-safety | 类型安全 mypy/pyright |
| fastapi-development | FastAPI REST API |
| python-testing | pytest 测试 |
| python-async | asyncio 异步编程 |
| async-python-patterns | 异步模式 |
| fastapi-pro | FastAPI 生产级 |

### 2.3 pydantic-ai-skills ⭐⭐⭐⭐

**GitHub**: https://github.com/DougTrajano/pydantic-ai-skills

> 为 Pydantic AI 实现 Agent Skills 支持

**核心特性**:
- 渐进式展示 (Progressive Disclosure)
- 文件系统支持
- 编程式技能定义

---

## 🧪 三、自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill | Stars | 描述 |
|-------|-------|------|
| playwright-skill | 1857⭐ | 浏览器自动化 |
| ios-simulator-skill | 560⭐ | iOS 模拟器 |
| e2e-testing | - | E2E 测试 |
| test-runner | - | pytest/unittest |

### 3.2 playwright-skill ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/lackeyjb/playwright-skill

> Claude Code 浏览器自动化 Playwright 技能

**核心能力**:
- 浏览器自动化
- E2E 测试编写
- 自动验证机制
- 视觉回归测试

**部署**:
```bash
git clone https://github.com/lackeyjb/playwright-skill.git
cp -r playwright-skill ~/.claude/skills/
```

### 3.3 ios-simulator-skill ⭐⭐⭐⭐

**GitHub**: https://github.com/conorluddy/ios-simulator-skill

> iOS 模拟器自动化技能

**核心能力**:
- Xcode 项目构建
- 模拟器管理
- UI 测试自动化

### 3.4 游戏客户端测试 Skills 缺口

| 方向 | 现状 | 建议 |
|------|------|------|
| Unity UI 测试 | 较少 | 开发 NUnit/Playwright 集成 |
| 游戏性能测试 | 缺少 | 开发帧率/内存监控 |
| 多人游戏测试 | 稀缺 | 开发网络模拟 Skills |
| 视觉回归测试 | 基础 | 开发截图对比 |

---

## 🛠️ Skills

###  四、开发者工具4.1 热门开发者工具

| Skill | Stars | 描述 |
|-------|-------|------|
| awesome-claude-skills | 40533⭐ | Skills 精选列表 |
| refly | 6898⭐ | Agent 构建器 |
| awesome-agent-skills | 2665⭐ | AI 编码代理技能 |
| agentsys | 516⭐ | 14插件/43agents/30skills |
| claude-forge | 392⭐ | 插件框架 |

### 4.2 DevOps 工具 Skills

| Skill | 描述 |
|-------|------|
| docker-essentials | Docker 基础 |
| kubernetes | K8s 管理 |
| kubectl | kubectl 工具 |
| terraform-specialist | Terraform IaC |
| github-actions-templates | GitHub Actions |

---

## 📈 五、ClawHub Top 10

| 排名 | Skill | 分类 |
|------|-------|------|
| 1 | awesome-claude-skills | 资源列表 |
| 2 | refly | Agent 构建器 |
| 3 | playwright-skill | 浏览器自动化 |
| 4 | awesome-agent-skills | 资源列表 |
| 5 | claude-code-plugins-plus-skills | 插件集合 |
| 6 | ios-simulator-skill | iOS 开发 |
| 7 | agentsys | 开发自动化 |
| 8 | claude-forge | 插件框架 |
| 9 | developer-kit | 开发工具包 |
| 10 | pydantic-ai-skills | Python AI |

---

## 📋 六、使用建议

### 6.1 安装方式
```bash
# ClawHub 安装
clawhub install <skill-name>

# 手动安装
git clone <repo> ~/.claude/skills/
```

### 6.2 推荐组合

**游戏开发**: Claude-Code-Game-Studios + unity-developer + godot-gdscript-patterns

**Python 开发**: fastapi-pro + python-type-safety + python-async

**测试**: playwright-skill + ios-simulator-skill + test-runner

**DevOps**: docker-essentials + kubernetes + github-actions-templates

---

## 📱 相关资源

- **ClawHub**: https://clawhub.com
- **Antigravity**: https://github.com/topicalcode/antigravity
- **Skills.sh**: https://skills.sh

---

*文档生成时间: 2026-03-04*
*来源: GitHub API, Antigravity Skills, ClawHub*
