# Claude Code Skills 深度调研报告 - 2026年3月（第七十七周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (968+ Skills) + ClawHub  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 🆕 持续更新

---

## 📊 调研概要

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 50+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 130+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 200+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 80+ | ⭐⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog (1.134⭐) | 全引擎 |
| Unity 开发 | unity-mcp (6580⭐), unity-developer, unity-ai-workflow-2026 | Unity |
| Godot 开发 | godot-mcp (480⭐), godot-gdscript-patterns | Godot |
| Unreal 开发 | unreal-engine-skills (27 Skills) | Unreal |
| Roblox 开发 | roblox-game-skill | Roblox |
| 游戏 AI | game-ai (3.133⭐ TOP 1) | 通用 |
| 完整工作室 | Claude-Code-Game-Studios (31⭐) | 全引擎 |
| RPG 冒险游戏 | Claude-Code-Game-Master (86⭐) | 持久世界 |

### 1.2 重点 Skills 深度分析

#### 🎯 Claude-Code-Game-Master (⭐ 86) - RPG 冒险游戏新星

**仓库**: https://github.com/Sstobo/Claude-Code-Game-Master

**核心能力**:
- RAG 技术驱动的故事情节
- RPG 规则集 API 集成
- 持久世界冒险
- 书籍/世界改编游戏

**适用场景**:
- 互动小说游戏
- 桌游电子化
- 角色扮演冒险

#### 🎯 Claude-Code-Game-Studios (⭐ 31+) - 完整游戏工作室

**仓库**: https://github.com/Donchitos/Claude-Code-Game-Studios

| 组件 | 数量 | 说明 |
|------|------|------|
| Agents | 48 | 专业化 AI 团队 |
| Skills | 36 | 工作流命令 |
| Hooks | 8 | 自动化验证 |
| Rules | 11 | 编码标准 |
| Templates | 28 | 文档模板 |

**三层架构**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**支持的引擎**:
- Godot 4: GDScript, Shaders, GDExtension
- Unity: DOTS/ECS, Shaders/VFX, Addressables, UI Toolkit
- Unreal Engine 5: GAS, Blueprints, Replication, UMG/CommonUI

**Slash Commands**:
- Reviews: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt
- Production: /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report
- Project: /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems
- Release: /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix
- Creative: /brainstorm, /playtest-report, /prototype, /onboard, /localize

#### 🎯 Game AI (评分 3.133) - ClawHub TOP 1

**核心能力**:
- 游戏 AI 系统设计
- NPC 行为模式
- 决策树与状态机
- 机器学习游戏 AI

#### 🎯 Unity AI Workflow 2026

**仓库**: https://github.com/David-GD13/unity-ai-workflow

| 特性 | 说明 |
|------|------|
| Unity 6.2+ 支持 | 最新 LTS 版本 |
| DOTS/ECS | 数据导向设计 |
| AI 代码生成 | 自动化开发 |

### 1.3 游戏开发 Skills 排行榜

| 排名 | Skill | 安装量/评分 |
|------|-------|-------------|
| 1 | game-ai | 3.133 ⭐ |
| 2 | unity | 3.033 ⭐ |
| 3 | game-cog | 1.132 ⭐ |
| 4 | game-engine | 3.878K |
| 5 | godot-gdscript-patterns | 3.019K |

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱

| 分类 | 核心 Skills | 评分 |
|------|-------------|------|
| Web 框架 | fastapi-pro, django-pro | 1.121+ |
| 异步编程 | async-python-patterns, temporal-python-pro | 高 |
| 数据科学 | python-dataviz (3.433⭐), python-executor (3.484⭐) | 高 |
| AI Agent | pydantic-ai-skills (140⭐), claudex (223⭐) | 高 |
| 类型安全 | python-type-safety, mypy-best | 高 |

### 2.2 重点 Skills

#### 🎯 Claudex (⭐ 223) - 自托管 Claude Code 工作区

**仓库**: https://github.com/Mng-dev-ai/claudex

**核心功能**:
- 多提供商路由 (Anthropic, OpenAI, GitHub Copilot, OpenRouter)
- 浏览器内 VS Code
- 沙盒执行环境
- MCP 服务器集成
- 自定义 Skills 和 Agents

**技术栈**:
- FastAPI Backend (PostgreSQL + Redis / SQLite)
- React/Vite Frontend
- Docker/Host Sandbox Runtime

#### 🎯 Pydantic AI Skills (⭐ 140)

**仓库**: https://github.com/DougTrajano/pydantic-ai-skills

- 类型安全 Agent
- 结构化输出
- 工具定义

#### 🎯 AI Guide (⭐ 8975)

**仓库**: https://github.com/liyupi/ai-guide

- 综合 AI 开发指南
- 多场景覆盖

### 2.3 Python Skills.sh 排行榜

| 排名 | Skill | 安装量 |
|------|-------|--------|
| 1 | python-executor | 1.8K |
| 2 | python-sdk | 1.7K |
| 3 | python-performance-optimization | 7.3K |
| 4 | python-dataviz | - |
| 5 | fastapi | - |

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱

| 分类 | 核心 Skills | 评分 |
|------|-------------|------|
| 浏览器自动化 | playwright (1.231⭐), playwright-mcp | 高 |
| E2E 测试 | e2e-testing-patterns | 高 |
| 单元测试 | pytest-master, unittest-pro | 高 |
| 移动端测试 | android-adb (1.220⭐), ios-simulator-skill (567⭐) | 高 |
| AI 测试 | agentic-qe (218⭐) | 新兴 |
| 游戏测试 | game-testing | 新增 |

### 3.2 重点 Skills

#### 🎯 Playwright Skill (⭐ 1869)

**仓库**: https://github.com/lackeyjb/playwright-skill

| 功能 | 说明 |
|------|------|
| 通用自动化 | 模型驱动的浏览器自动化 |
| 可见浏览器 | headless: false 默认 |
| 零模块错误 | 通用执行器确保模块访问 |
| 渐进式披露 | 精简 SKILL.md + 完整 API 参考 |
| 安全清理 | 智能临时文件管理 |
| 综合助手 | 常用任务工具函数 |

**安装方式**:
```bash
# 作为插件安装（推荐）
/plugin marketplace add lackeyjb/playwright-skill
/plugin install playwright-skill@playwright-skill

# 独立技能安装
npm install -g playwright
```

#### 🎯 iOS Simulator Skill (⭐ 567)

**仓库**: https://github.com/conorluddy/ios-simulator-skill

- iOS 应用构建
- 模拟器控制
- UI 测试

#### 🎯 Agentic QE (⭐ 218)

**仓库**: https://github.com/proffesor-for-testing/agentic-qe

- AI 生成测试用例
- 智能测试选择
- 自动缺陷检测

### 3.3 Skills.sh 测试排行榜

| 排名 | Skill | 评分 |
|------|-------|--------|
| 1 | playwright | 1.231 |
| 2 | testing | 1.089 |
| 3 | test-automation | 0.987 |
| 4 | automated-testing | 0.956 |
| 5 | qa-testing | 0.923 |

### 3.4 游戏客户端测试专题

**需求分析**:

| 需求 | 优先级 |
|------|--------|
| Unity 客户端测试 | ⭐⭐⭐⭐⭐ |
| 帧同步测试 | ⭐⭐⭐⭐⭐ |
| Unreal 客户端测试 | ⭐⭐⭐⭐ |
| 游戏性能基准 | ⭐⭐⭐⭐ |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱

| 分类 | 核心 Skills | 评分 |
|------|-------------|------|
| Git/GitHub | git (1.342⭐), github (1.287⭐) | 高 |
| Docker | docker-essentials (1.297⭐), docker | 高 |
| CI/CD | cicd-pipeline, gitlab-cli-skills | 中 |
| MCP | claude-code-mcp (1153⭐), mcp-adapter | 高 |
| 云服务 | aws, azure, gcp | 中 |
| 部署工具 | pinme (2970⭐), vercel-deploy | 高 |
| 上下文工程 | planning-with-files (15292⭐), context-engineering-kit (575⭐) | 高 |
| 安全工具 | skills-TrailOfBits (3274⭐) | 高 |

### 4.2 GitHub 热门开发者工具 Skills (实时)

| 仓库 | ⭐ | 说明 |
|------|-----|------|
| planning-with-files | 15292 | Manus 风格持久化规划 |
| awesome-agent-skills | 9280 | 500+ Agent Skills 集合 |
| humanizer | 7737 | 消除 AI 写作痕迹 |
| skills (Trail of Bits) | 3274 | 安全研究技能 |
| pinme | 2970 | 前端一键部署 |
| Claudeception | 1926 | 自主技能提取学习 |
| skill-codex | 753 | Codex 任务委托 |
| claude-code-skills | 621 | 专业技能市场 |
| context-engineering-kit | 575 | 上下文工程工具包 |
| dotnet-skills | 461 | .NET 开发技能 |
| solana-dev-skill | 375 | Solana 开发技能 |

### 4.2 重点 Skills

#### 🎯 Docker Essentials (评分 1.297) - DevOps TOP 1

- Dockerfile 最佳实践
- 镜像优化
- 容器编排
- 多阶段构建

#### 🎯 Git (评分 1.342) - ClawHub TOP 1

- 版本控制基础
- 分支管理
- 协作工作流

#### 🎯 Claude Code MCP (⭐ 1153)

**仓库**: https://github.com/steipete/claude-code-mcp

- AI Agent 嵌套调用
- 上下文跨会话传递
- 工具调用编排

### 4.3 Skills.sh 开发者工具排行榜

| 排名 | Skill | 评分 |
|------|-------|--------|
| 1 | git | 1.342 |
| 2 | github | 1.287 |
| 3 | docker | 1.156 |
| 4 | cli | 1.089 |
| 5 | bash | 1.023 |

---

## 📈 五、趋势分析

### 5.1 本周趋势

1. **游戏开发**: Claude-Code-Game-Studios 成为明星项目，48 Agents 完整工作室架构
2. **Python 开发**: Claudex 自托管方案崛起，多提供商支持成为热点
3. **自动化测试**: Playwright 持续火爆，Model-invoked 自动化新范式
4. **开发者工具**: MCP 集成成为新趋势

### 5.2 新兴 Skills

| 技能 | 方向 | 热度 |
|------|------|------|
| Claude-Code-Game-Studios | 游戏开发 | 31+⭐ |
| claudex | Python/AI | 223⭐ |
| playwright-skill | 测试 | 1869⭐ |
| pydantic-ai-skills | Python/AI | 140⭐ |
| agentic-qe | 测试 | 218⭐ |

---

## 📚 参考资源

- [ClawHub](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/anthracite-org/awesome-claude-skills)
- [Awesome Claude Skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [Everything Claude Code](https://github.com/affaan-m/everything-claude-code)

---

## 📥 安装命令

```bash
# 游戏开发
npx skillsadd Donchitos/Claude-Code-Game-Studios
npx skillsadd nicbarker/Godot-MCP
npx skillsadd David-GD13/unity-ai-workflow

# Python 开发
npx skillsadd Mng-dev-ai/claudex
npx skillsadd DougTrajano/pydantic-ai-skills

# 自动化测试
npx skillsadd lackeyjb/playwright-skill
npx skillsadd conorluddy/ios-simulator-skill

# 开发者工具
npx skillsadd steipete/claude-code-mcp
```

---

**下次更新**: 2026-03-12

---

*本报告由 Claude Code 自动生成并推送到 GitHub*
