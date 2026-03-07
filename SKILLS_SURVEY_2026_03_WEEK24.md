# Claude Code Skills 完整调研报告 - 2026年3月 (第二十四周)

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
| game-developer-skill | **0.974** | Claude 游戏开发者 | AI 辅助开发 |
| fivem-dev | **0.957** | Fivem 开发 | GTA5 Mod 开发 |
| blender | **0.925** | Blender 3D 建模 | 3D 资产制作 |
| game-engine | **0.920** | 游戏引擎架构 | 引擎原理 |
| unity | **0.961** | Unity 最佳实践 | Unity 开发 |
| unreal-engine | **0.935** | Unreal Engine 开发 | UE 开发 |
| godot-dev-guide | **0.983** | Godot 4.x 完整开发指南 | Godot 开发 |

### 1.2 2026年2-3月新增游戏开发 Skills

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

#### 1.2.3 OH-Unity-GameDev-Skills

**项目地址**: [OstrichHermit/OH-Unity-GameDev-Skills](https://github.com/OstrichHermit/OH-Unity-GameDev-Skills)  
**GitHub Stars**: 6⭐ (2026年2月新增)

```markdown
## 特点
- 符合 Claude Code Skills 规范
- 专注于 Unity 游戏开发
- 包含最佳实践和工作流
```

#### 1.2.4 Love2D Game Development

**项目地址**: [chongdashu/love2d-pocket-bomber-game](https://github.com/chongdashu/love2d-pocket-bomber-game)  
**GitHub Stars**: 11⭐ (2026年2月新增)

```markdown
## 特点
- Vibe coding 风格的 Love2D 游戏开发
- Bomberman 克隆示例
- 完整的游戏开发工作流
```

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| py | **1.049** | Python 核心开发 | 通用 Python |
| python | **1.000** | Python 编程 | 基础开发 |
| python-executor | **0.973** | Python 代码执行 | 脚本运行 |
| fastapi-pro | **0.985** | FastAPI 高级开发 | API 开发 |
| django-pro | **0.912** | Django 完整开发 | Web 开发 |

### 2.2 2026年2-3月新增 Python 相关 Skills

#### 2.2.1 Pydantic AI Skills

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

#### 2.2.2 Python Rope Refactor

**项目地址**: [brian-yu/python-rope-refactor](https://github.com/brian-yu/python-rope-refactor)  
**GitHub Stars**: 36⭐

```markdown
## 核心功能
- 教 LLM agents 如何使用 rope 进行 Python 代码重构
- 安全的大规模代码重构
- 跨文件重命名和移动
- 提取方法/变量
```

#### 2.2.3 Beagle - Code Review Skills

**项目地址**: [existential-birds/beagle](https://github.com/existential-birds/beagle)  
**GitHub Stars**: 34⭐

```markdown
## 核心功能
- Code review skills 和验证工作流
- 支持 Python, Go, React, FastAPI
- BubbleTea 和 AI 框架支持
- Pydantic AI, LangGraph, Vercel AI SDK 集成
```

---

## 🧪 三、自动化测试 Skills

### 3.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| playwright-scraper-skill | **3.584** | Playwright 爬虫 | 数据抓取 |
| playwright-mcp | **3.581** | Playwright MCP | 浏览器自动化 |
| playwright | **3.538** | Playwright 核心 | E2E 测试 |
| playwright-browser-automation | **3.509** | 浏览器自动化 | UI 测试 |
| manikantasai-playwright-automation | **3.369** | Playwright 自动化 | 测试框架 |
| test-master | **1.158** | 测试大师 | 综合测试 |
| e2e-testing-patterns | **1.119** | E2E 测试模式 | 测试设计 |
| windows-ui-automation | **1.100** | Windows UI 自动化 | 桌面测试 |
| atl-mobile | **0.996** | Agent Touch Layer | 移动端测试 |

### 3.2 游戏客户端测试 Skills 缺口

**当前缺口**:
1. 缺少 Unity/Unreal 引擎内置测试 Skills
2. 缺少游戏性能测试 Skills (帧率/内存/CPU)
3. 缺少游戏网络同步测试 Skills

**建议方向**:
- 开发 Unity Test Framework 集成 Skills
- 开发 Unreal Automation System Skills
- 开发游戏性能基准测试 Skills

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| mcp-adapter | **1.074** | MCP 适配器 | 工具集成 |
| tools-ui | **1.036** | 工具 UI | UI 开发 |
| browserautomation-skill | **1.058** | 浏览器自动化 | Web 自动化 |
| ai-web-automation | **1.097** | AI Web 自动化 | 智能自动化 |
| devtopia | **0.938** | 开发者工具 | 开发环境 |
| apple-developer-toolkit | **0.928** | Apple 开发者工具 | iOS/macOS |
| openclaw-docker | **0.866** | Docker | 容器化 |

### 4.2 2026年2-3月新增开发者工具 Skills

#### 4.2.1 Excalidraw Diagram Skill

**项目地址**: [coleam00/excalidraw-diagram-skill](https://github.com/coleam00/excalidraw-diagram-skill)  
**GitHub Stars**: 319⭐ (2026年3月1日新增)

```markdown
## 核心功能
- 为 Claude Code 生成精美实用的 Excalidraw 图表
- 支持多种图表类型
- AI 辅助的图表生成
```

#### 4.2.2 X Research Skill

**项目地址**: [rohunvora/x-research-skill](https://github.com/rohunvora/x-research-skill)  
**GitHub Stars**: 890⭐

```markdown
## 核心功能
- X/Twitter 研究技能
- Agentic 搜索，线程跟踪
- 深度分析，有来源的简报
- 支持 Claude Code 和 OpenClaw
```

#### 4.2.3 Claude Forge

**项目地址**: [sangrokjung/claude-forge](https://github.com/sangrokjung/claude-forge)  
**GitHub Stars**: 380⭐

```markdown
## 核心功能
- 11 个 AI agents
- 36 个命令
- 15 个 skills
- 灵感来自 oh-my-zsh 的插件框架
- 6 层安全钩子
- 5 分钟安装
```

#### 4.2.4 Skills Manager

**项目地址**: [jiweiyeah/Skills-Manager](https://github.com/jiweiyeah/Skills-Manager)  
**GitHub Stars**: 292⭐

```markdown
## 核心功能
- 高性能桌面应用，管理多个 AI 编码助手的 Skills
- 无缝组织、同步、共享 Skills
- 支持 Claude Code、Codex、Opencode 等
- 基于 Tauri 2.0、React 19、Rust 构建
```

#### 4.2.5 Awesome Claude Code Toolkit

**项目地址**: [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit)  
**GitHub Stars**: 626⭐

```markdown
## 核心功能
- 最全面的 Claude Code 工具包
- 135 个 agents
- 35 个精选 Skills (+15,000 通过 SkillKit)
- 42 个命令
- 120 个插件
- 19 个钩子
- 15 个规则
- 7 个模板
- 6 个 MCP 配置
```

---

## 📈 五、2026年2-3月新增 Skills 完整列表

| 项目名称 | Stars | 描述 | 类别 |
|---------|-------|------|------|
| claude-seo | 1498 | 通用 SEO 技能 | 营销 |
| x-research-skill | 890 | X/Twitter 研究技能 | 工具 |
| Product-Manager-Skills | 807 | 产品管理技能框架 | 工具 |
| awesome-claude-code-toolkit | 626 | 最全工具包 (135 agents) | 工具 |
| claude-ads | 607 | 广告审计与优化技能 | 营销 |
| MedgeClaw | 498 | 开源生物医学 AI 研究助手 | 科学 |
| claude-forge | 380 | 11 agents + 36 commands | 工具 |
| napkin | 332 | 持久记忆错误的技能 | 工具 |
| excalidraw-diagram-skill | 319 | Excalidraw 图表生成 | 工具 |
| Skills-Manager | 292 | Skills 桌面管理应用 | 工具 |
| Product-Manager-Skills | 807 | 产品管理框架 | 工具 |

---

## 🎯 六、总结与建议

### 6.1 本周调研亮点

1. **Playwright 生态主导**: Playwright 相关 Skills 持续占据 Top 10，浏览器自动化是热门方向
2. **游戏开发多元化**: 从 Unity 扩展到 Love2D、Fivem 等多类型游戏开发
3. **开发者工具爆发**: Skills Manager、Claude Forge 等工具类 Skills 涌现
4. **AI 研究工具**: X Research、MedgeClaw 等垂直领域 Skills 增长明显

### 6.2 Skills 缺口分析

**游戏客户端开发**:
- 缺少 Unity Test Framework 集成 Skills
- 缺少 Unreal Automation System Skills  
- 缺少游戏性能基准测试 Skills

**Python 开发**:
- 缺少 asyncio 深度集成 Skills
- 缺少类型检查 (pyright/mypy) 最佳实践 Skills

**测试自动化**:
- 缺少游戏专用测试 Skills
- 缺少 VR/AR 测试 Skills

**开发者工具**:
- 缺少 VS Code 插件开发 Skills
- 缺少 Kubernetes 深度集成 Skills

### 6.2 建议方向

1. **优先开发**: 游戏性能测试 Skills (帧率/内存/CPU 监控)
2. **优先开发**: Unity Test Framework 集成 Skills
3. **关注**: AI Agent 编排 Skills (多 Agent 协作)
4. **关注**: 科学计算/生物医学垂直领域 Skills

---

## 📚 参考资源

- [ClawHub Skills Registry](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [GitHub Trending](https://github.com/trending)

---

*文档更新时间: 2026-03-04*
