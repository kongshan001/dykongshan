# Claude Code Skills 调研报告 - 2026年3月 Week 44

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

### 1.1 Antigravity Skills 分类

| Skill ID | 名称 | 描述 |
|----------|------|------|
| game-development | 游戏开发编排器 | 基于项目需求路由到平台特定 Skills |
| 2d-games | 2D 游戏开发 | Sprite、tilemap、物理、相机 |
| 3d-games | 3D 游戏开发 | 渲染、shader、物理、相机 |
| game-art | 游戏美术 | 视觉风格、资产管线、动画流程 |
| game-audio | 游戏音频 | 声音设计、音乐集成、自适应音频 |
| game-design | 游戏设计 | GDD 结构、平衡、玩家心理学 |
| godot-gdscript-patterns | Godot GDScript 模式 | 信号、场景、状态机 |
| unity-developer | Unity 开发者 | 优化 C# 脚本、渲染、资产管理 |
| unity-ecs-patterns | Unity ECS 模式 | DOTS、Jobs、Burst 优化 |
| mobile-games | 移动端游戏 | 触摸输入、电池、性能 |
| multiplayer | 多人游戏 | 架构、网络、同步 |
| pc-games | PC/主机游戏 | 引擎选择、平台特性 |
| vr-ar | VR/AR 开发 | 舒适度、交互、性能 |
| web-games | 网页游戏 | 框架选择、WebGPU、优化 |
| shader-programming-glsl | GLSL 着色器 | 顶点/片段着色器 |

### 1.2 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| Claude-Code-Game-Studios | 28⭐ | 48 agents 完整游戏开发工作室，36 workflow skills | 2026-03-03 |
| skills-weaver | 15⭐ | RPG 角色扮演游戏 Claude Code Agent SDK | 2026-02-28 |
| love2d-pocket-bomber-game | 11⭐ | 使用 Claude Code 和 Love2D vibe coding Bomberman clone | 2026-02-23 |
| OH-Unity-GameDev-Skills | 6⭐ | Unity 游戏开发代理技能集 | 2026-02-15 |
| unity-ai-workflow | 4⭐ | Unity 6.2+ AI 开发工作流 | 2026-03-02 |

### 1.3 重点 Skills 深度分析

#### 1.3.1 Claude-Code-Game-Studios ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/saveur/Claude-Code-Game-Studios  
**Stars**: 28  
**更新**: 2026-03-03

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

**适用场景**:
- 大型游戏项目需要多角色协作
- 需要完整的开发流程和审查机制
- 团队级游戏开发工作流

**本地部署**:
```bash
# 克隆仓库
git clone https://github.com/saveur/Claude-Code-Game-Studios.git
cd Claude-Code-Game-Studios

# 安装依赖
npm install

# 配置 Claude Code
# 在 CLAUDE.md 中配置 API 密钥
```

---

## 🐍 二、Python 开发 Skills

### 2.1 Antigravity Python 相关 Skills

| Skill ID | 描述 |
|----------|------|
| async-python-patterns | Python asyncio、并发编程、async/await 模式 |
| azure-cosmos-db-py | Azure Cosmos DB NoSQL + Python/FastAPI |
| azure-functions | Azure Functions 开发（隔离工作进程模型） |
| azure-identity-py | Azure Identity SDK 认证 |
| azure-keyvault-py | 密钥/证书管理 |

### 2.2 GitHub 热门 Python 开发 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| ai-guide | 8887⭐ | 程序员鱼皮的 AI 资源大全 |
| claudex | 223⭐ | Claude Code UI，sandbox，多提供商支持 |
| developer-kit | 132⭐ | 多语言开发工具包 |
| claude-starter-kit | 61⭐ | Claude Code 入门模板 |
| Claude-Skills | 17⭐ | 97 Expert AI Skills，178 Python 工具 |

### 2.3 重点 Skills 深度分析

#### 2.3.1 Claude-Skills (borghei) ⭐⭐⭐⭐

**GitHub**: https://github.com/borghei/Claude-Skills  
**Stars**: 17  
**更新**: 2026-03-03

> 97 Expert AI Skills for Every AI Coding Assistant

**核心组成**:

| 类别 | 数量 | 覆盖范围 |
|------|------|----------|
| AI Skills | 97 | 专家级技能 |
| Python Tools | 178 | 各类工具库 |
| CI/CD | 12 | 自动化工作流 |

**Python 工具覆盖**:

- **Web 开发**: FastAPI, Django, Flask
- **数据处理**: Pandas, NumPy
- **测试**: pytest, unittest
- **类型检查**: mypy, pyright

**本地部署**:
```bash
git clone https://github.com/borghei/Claude-Skills.git
cd Claude-Skills

# 查看可用 skills
ls skills/

# 复制到 Claude Code skills 目录
cp -r skills/* ~/.claude/skills/
```

#### 2.3.2 developer-kit ⭐⭐⭐⭐

**GitHub**: https://github.com/giuseppe-trisciuoglio/developer-kit  
**Stars**: 132

> 模块化插件系统，提供可重用的 skills、agents 和 commands

**支持语言**:

| 语言 | 框架 |
|------|------|
| Java | Spring Boot, LangChain4J |
| TypeScript | NestJS, React |
| Python | - |
| PHP | WordPress |
| AWS | CloudFormation |

---

## 🧪 三、自动化测试 Skills

### 3.1 Antigravity 测试相关 Skills

| Skill ID | 描述 |
|----------|------|
| e2e-testing | Playwright E2E 测试，视觉回归，跨浏览器 |
| e2e-testing-patterns | Playwright 和 Cypress 可靠测试套件 |
| browser-automation | 浏览器自动化，网页测试，AI 代理交互 |
| playwright-mcp | Playwright MCP 服务器 |
| android-adb | Android ADB 自动化测试 |
| test-master | 测试主管，AI 驱动测试策略 |
| test-runner | 测试运行器，pytest/unittest 集成 |

### 3.2 GitHub 热门测试 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| playwright-skill | 1855⭐ | Playwright 浏览器自动化 |
| claude-skills-marketplace | 429⭐ | Git 自动化、测试、代码审查 |
| agentkits-marketing | 335⭐ | 企业级营销自动化 |
| claude-office-skills | 331⭐ | Office 文档自动化 |

### 3.3 重点 Skills 深度分析

#### 3.3.1 playwright-skill ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/lackeyjb/playwright-skill  
**Stars**: 1855  
**更新**: 2026-03-04

> Claude Code Skill for browser automation with Playwright

**核心特性**:

| 功能 | 描述 |
|------|------|
| 模型驱动执行 | Claude 自动编写和执行测试 |
| 浏览器自动化 | 跨浏览器测试 |
| 验证工作流 | 自动验证功能 |
| 视觉回归 | 截图比对 |

**游戏客户端测试应用**:

- Web 游戏自动化测试
- 社交功能测试
- 登录流程自动化

**本地部署**:
```bash
# 安装 Playwright
npm install -g playwright

# 克隆 skill
git clone https://github.com/lackeyjb/playwright-skill.git
cd playwright-skill

# 安装依赖
npm install

# 运行测试示例
playwright test examples/
```

#### 3.3.2 android-adb ⭐⭐⭐

**GitHub**: https://github.com/pengdev/claude-adb-skill  
**Stars**: 0

> ADB 设备操作自动化

**核心功能**:

| 操作 | 描述 |
|------|------|
| 构建安装 | build, install |
| UI 操作 | tap, swipe, pinch zoom |
| 截图 | screenshot |
| 日志 | logcat |
| 视觉验证 | visually verify UI |

**游戏客户端测试应用**:
- Android 游戏客户端自动化测试
- UI 交互测试
- 性能日志收集

**本地部署**:
```bash
# 安装 ADB
# macOS
brew install android-platform-tools

# Ubuntu
sudo apt install adb

# 克隆 skill
git clone https://github.com/pengdev/claude-adb-skill.git
cd claude-adb-skill

# 连接设备
adb devices
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 热门开发者工具 Skills

| 项目 | Stars | 描述 |
|-----|-------|------|
| sandboxed.sh | 273⭐ | AI 自主代理的沙箱编排器 |
| awesome-claude-skills | 160⭐ | 50+ 精选 Skills 集合 |
| schematic | 125⭐ | 从 git 分支反向工程产品规格 |
| SkillSync | 28⭐ | 从 Git 同步 Skills 到本地工具 |
| git-workflow-skill | 6⭐ | Git 工作流最佳实践 |

### 4.2 重点 Skills 深度分析

#### 4.2.1 sandboxed.sh ⭐⭐⭐⭐

**GitHub**: https://github.com/Th0rgal/sandboxed.sh  
**Stars**: 273

> Self-hosted orchestrator for AI autonomous agents

**核心特性**:

| 功能 | 描述 |
|------|------|
| 隔离工作空间 | 独立的 Linux 环境 |
| Git 配置管理 | 加密密钥安全管理 |
| 代理编排 | 自动化工作流 |

**适用场景**:
- 安全敏感的开发环境
- 多代理协作任务
- 代码审计和测试

#### 4.2.2 awesome-claude-skills ⭐⭐⭐⭐

**GitHub**: https://github.com/karanb192/awesome-claude-skills  
**Stars**: 160

> 50+ 验证通过的精选 Skills

**核心类别**:

| 类别 | 技能数 |
|------|--------|
| TDD 工作流 | ✓ |
| 调试技能 | ✓ |
| Git 工作流 | ✓ |
| 文档处理 | ✓ |

---

## 📈 五、Skills 缺口分析与建议

### 5.1 游戏客户端开发

**已有 Skills**:
- Claude-Code-Game-Studios (48 agents + 36 skills)
- Unity/Godot/Unreal 开发 Skills
- 游戏设计框架

**缺口**:
- ❌ 移动端游戏测试 Skills (iOS)
- ❌ 游戏性能分析 Skills
- ❌ 游戏发布/商店提交 Skills

**建议开发**:
- Unity Test Framework 集成
- 游戏客户端 UI 测试
- 游戏网络/多人对战测试

### 5.2 Python 开发

**已有 Skills**:
- FastAPI/异步开发
- 类型安全 (mypy/pyright)
- Azure 云服务集成

**缺口**:
- ❌ 数据科学/ML 专用 Skills
- ❌ 异步游戏服务器开发

### 5.3 游戏客户端自动化测试

**已有 Skills**:
- playwright-skill (浏览器自动化)
- ADB 自动化

**缺口**:
- ❌ iOS 游戏测试 (XCUITest)
- ❌ Android 游戏测试 (Espresso)
- ❌ 游戏特定测试框架

**建议开发**:
- Unity Test Framework 集成
- 游戏截图比对
- 性能监控自动化

### 5.4 开发者工具

**已有 Skills**:
- Git 自动化
- CI/CD 工作流
- 代码审查

**建议开发**:
- 游戏项目特定工具
- 资源打包自动化
- 版本管理工具

---

## 📋 六、本周更新总结

| 类别 | 热门 Skill | Stars | 趋势 |
|------|------------|-------|------|
| 游戏开发 | Claude-Code-Game-Studios | 28 | ↗️ 新增 |
| Python 开发 | developer-kit | 132 | ↗️ 稳定 |
| 测试/自动化 | playwright-skill | 1855 | ↗️ 热门 |
| 开发者工具 | sandboxed.sh | 273 | ↗️ 增长 |

---

## 🔗 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [cc_skills 仓库](https://github.com/kongshan001/cc_skills)
- [ClawHub Skills 市场](https://clawhub.com/skills)

---

*持续更新中...*
