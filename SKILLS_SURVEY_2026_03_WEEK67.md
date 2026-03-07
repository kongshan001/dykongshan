# Claude Code Skills 深度调研报告 - 2026年3月（第六十七周）

**调研日期**: 2026-03-05  
**技能来源**: GitHub API 实时搜索 + ClawHub 排行榜 + skills.sh 官方榜单  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: 📡 持续更新

---

## 📊 调研概要

本次调研聚焦以下四个核心方向，基于 Claude Code 生态系统中最新、最热门的 Skills 进行深度分析：

| 方向 | Skills 数量 | 热度评级 |
|------|-------------|----------|
| 🎮 游戏客户端开发 | 25+ | ⭐⭐⭐⭐⭐ |
| 🐍 Python 开发 | 80+ | ⭐⭐⭐⭐⭐ |
| 🧪 自动化测试 | 150+ | ⭐⭐⭐⭐⭐ |
| 🛠️ 开发者工具 | 45+ | ⭐⭐⭐⭐⭐ |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 技能图谱概览

| 分类 | 核心 Skills | 适用引擎 |
|------|-------------|----------|
| 游戏开发编排器 | game-cog, game-development | 全引擎 |
| Unity 开发 | unity-developer, unity-ecs-patterns, unity-mcp (6580⭐) | Unity |
| Godot 开发 | godot-gdscript-patterns, godot-mcp (480⭐) | Godot |
| Unreal 开发 | unreal-engine-cpp-pro, unreal-engine-skills | Unreal |
| Roblox 开发 | roblox-game-skill | Roblox |
| 2D/3D 游戏 | 2d-games, 3d-games | 通用 |
| 游戏 AI | game-ai, game-audio, game-art | 通用 |

### 1.2 重点 Skills 深度分析

#### 🎯 Claude-Code-Game-Studios (⭐ 30+)

**仓库**: https://github.com/Donchitos/Claude-Code-Game-Studios  
**定位**: 完整游戏开发工作室

**核心能力**:
- 48 个专业 AI Agents (策划/美术/程序/音频)
- 36 个 Workflow Skills
- 多引擎支持: Unity, Unreal, Godot, Roblox

**适用场景**:
- 大型游戏项目开发
- 团队协作工作流
- 完整游戏开发生命周期

#### 🎯 Unity-MCP (⭐ 6580)

**仓库**: https://github.com/Volaly/unity-mcp  
**定位**: AI 连接 Unity 编辑器的桥梁

**核心功能**:
| 功能模块 | 说明 |
|---------|------|
| 场景操作 | 创建/修改场景对象 |
| 组件管理 | 添加/配置 Unity 组件 |
| 资源操作 | 导入/管理资源 |
| 构建自动化 | 自动构建项目 |

#### 🎯 Godot-MCP (⭐ 480)

**仓库**: https://github.com/nicbarker/Godot-MCP  
**定位**: Godot 游戏引擎 MCP 服务器

#### 🎯 Unity AI Workflow 2026 (⭐ 新增)

**仓库**: https://github.com/David-GD13/unity-ai-workflow  
**定位**: Unity 6.2+ AI 优先开发工作流

**核心特性**:
- AI-first 开发流程
- 规则、agents、skills、slash commands 完整配置
- 支持 Claude Code 和 Antigravity

#### 🎯 Unreal Engine Skills (⭐ 新增)

**仓库**: https://github.com/quodsoler/unreal-engine-skills  
**定位**: Unreal Engine C++ 开发技能

**核心内容**:
- 27 个覆盖游戏机制、渲染、网络、动画的 Skills
- 支持 Claude Code, Cursor, Windsurf

### 1.3 skills.sh 游戏开发 Skills 排行榜 (Top 20)

| 排名 | Skill ID | 安装量 | 说明 |
|------|----------|--------|------|
| 1 | game-engine | 3.878K | 游戏引擎基础 |
| 2 | game-ai | - | 游戏 AI 系统 |
| 3 | unity | - | Unity 开发 |
| 4 | game-cog | - | 游戏开发编排器 |
| 5 | godot-gdscript-patterns | 3.019K | Godot GDScript 模式 |
| 6 | game-developer-skill | - | Claude 游戏开发者 |
| 7 | game-engine | - | 游戏引擎 |
| 8 | unreal-engine | - | Unreal 开发 |
| 9 | flutter-animations | 8.469K | Flutter 动画 |
| 10 | swiftui-expert-skill | 6.848K | SwiftUI 专家 |

### 1.4 新增游戏开发 Skills (2025.12 后)

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| robotics-agent-skills | 118 | 机器人/ROS 开发技能 |
| axiom | 562 | xOS 开发技能 (iOS/iPadOS/watchOS/tvOS) |
| OH-Unity-GameDev-Skills | 6 | Unity 游戏开发技能集合 |
| solana-game-skill | 5 | Solana Unity SDK 开发技能 |
| unity-ai-workflow | 4 | Unity 6.2+ AI 工作流 |
| hytale-claude-code-marketplace | 3 | Hytale 游戏模组市场 |
| claude-resources | 3 | Godot 游戏开发资源 |
| roblox-game-skill | 1 | Roblox 游戏开发技能 |
| cc-plugin-unity-gamedev | 1 | Unity 21 个游戏开发技能 |
| baxatron-git/claude-game-design-suite | 1 | 22-Skill 游戏设计框架 |

---

## 🐍 二、Python 开发 Skills

### 2.1 技能图谱概览

| 分类 | 核心 Skills | 热度 |
|------|-------------|------|
| 框架开发 | fastapi, django-ai-plugins, flask-pro | ⭐⭐⭐⭐⭐ |
| 异步编程 | async-python, asyncio-patterns | ⭐⭐⭐⭐ |
| 类型安全 | python-type-safety, pyright, mypy | ⭐⭐⭐⭐ |
| AI 集成 | pydantic-ai-skills (140⭐), langgraph-python | ⭐⭐⭐⭐⭐ |
| 代码质量 | claude-code-clean, python-linting | ⭐⭐⭐ |
| 测试 | pytest, python-testing-patterns (5.989K) | ⭐⭐⭐⭐ |

### 2.2 重点 Skills 深度分析

#### 🎯 claudex (⭐ 224)

**仓库**: https://github.com/Mng-dev-ai/claudex  
**定位**: 私有 Claude Code UI、沙盒、浏览器内 VS Code

**核心功能**:
- 多提供商支持 (Anthropic, OpenAI, GitHub Copilot, OpenRouter)
- 自定义 Skills 和 MCP 服务器
- 浏览器内终端
- Python/TypeScript 开发

#### 🎯 pydantic-ai-skills (⭐ 140)

**仓库**: https://github.com/DougTrajano/pydantic-ai-skills  
**定位**: Pydantic AI 的 Agent Skills 支持

**核心功能**:
- Progressive Disclosure 模式
- 文件系统和程序化 Skills
- 支持 Claude Code, Codex, OpenCode

#### 🎯 beagle (⭐ 37)

**仓库**: https://github.com/existential-birds/beagle  
**定位**: Claude Code 代码审查插件

**核心能力**:
- Python, Go, React 代码审查
- FastAPI, BubbleTea 验证工作流
- Pydantic AI, LangGraph 框架支持
- 代码审查技能和验证流程

#### 🎯 security-antipatterns-python (⭐ 新增)

**仓库**: https://github.com/subhashdasyam/security-antipatterns-python  
**定位**: Python 安全最佳实践

### 2.3 Python 测试相关 Skills (Top 10)

| 排名 | Skill ID | 安装量 | 说明 |
|------|----------|--------|------|
| 1 | python-testing-patterns | 5.989K | Python 测试模式 |
| 2 | pytest-coverage | 3.840K | pytest 覆盖率 |
| 3 | backend-testing | 6.198K | 后端测试 |
| 4 | testing-strategies | 6.145K | 测试策略 |
| 5 | playwright-generate-test | 3.946K | Playwright 测试生成 |
| 6 | playwright-automation-fill-in-form | 3.857K | Playwright 表单自动化 |
| 7 | playwright-explore-website | 3.902K | Playwright 网站探索 |
| 8 | playwright-cli | 3.441K | Playwright CLI |
| 9 | e2e-testing-patterns | 5.039K | E2E 测试模式 |
| 10 | javascript-testing-patterns | 4.129K | JavaScript 测试模式 |

### 2.4 新增 Python 开发 Skills (2025.12 后)

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| pydantic-ai-skills | 140 | Pydantic AI Agent Skills |
| PsiACE/skills | 153 | 共享技能库 |
| python-rope-refactor | 36 | Python 代码重构工具 |
| perseus | 26 | AI 安全评估多语言支持 |
| software-dev-ai-claude-toolkit | 8 | Java/Spring Boot, Python/FastAPI, JS/React 全栈工具 |
| claude-arsenal | 9 | 39+ 专业开发技能 |
| transilienceai/cldpm | 9 | CPM 多项目管理 SDK |
| security-antipatterns-python | - | Python 安全反模式 |
| python-performance-optimization | 7.323K | Python 性能优化 |
| python-design-patterns | 3.681K | Python 设计模式 |
| async-python-patterns | 4.753K | 异步 Python 模式 |
| python-packaging | 3.076K | Python 包发布 |

---

## 🧪 三、自动化测试 Skills

### 3.1 技能图谱概览

| 分类 | 核心 Skills | 热度 |
|------|-------------|------|
| E2E 测试 | Playwright (1.86k⭐), Cypress | ⭐⭐⭐⭐⭐ |
| 单元测试 | pytest, unittest, jest | ⭐⭐⭐⭐ |
| AI 驱动测试 | agentic-qe (218⭐), eval-view | ⭐⭐⭐⭐ |
| 性能测试 | lighthouse, k6 | ⭐⭐⭐ |
| 移动端测试 | appium, detox | ⭐⭐⭐ |

### 3.2 重点 Skills 深度分析

#### 🎯 Playwright 生态 (⭐ 1.86K+)

**核心 Skills**:
- `playwright-skill` - Playwright 主技能
- `playwright-cli` - Playwright CLI (3.441K 安装)
- `playwright-generate-test` - 测试生成 (3.946K 安装)
- `playwright-best-practices` - 最佳实践 (3.270K 安装)
- `playwright-explore-website` - 网站探索 (3.902K 安装)

**核心功能**:
| 功能 | 说明 |
|------|------|
| 浏览器自动化 | 跨浏览器测试 |
| 截图对比 | 视觉回归测试 |
| API 测试 | REST/GraphQL 测试 |
| 移动端模拟 | 响应式测试 |

#### 🎯 agentic-qe (⭐ 218)

**仓库**: https://github.com/qa-mentor/agentic-qe  
**定位**: AI 驱动的质量工程

**核心能力**:
- 智能测试用例生成
- 自动化的测试维护
- 测试覆盖率分析
- 缺陷预测

#### 🎯 eval-view (⭐ 49 新增)

**仓库**: https://github.com/anysphere/eval-view  
**定位**: 评估和可视化测试结果

### 3.3 skills.sh 测试 Skills 排行榜 (Top 15)

| 排名 | Skill ID | 安装量 | 说明 |
|------|----------|--------|------|
| 1 | test-driven-development | 18.368K | TDD 开发模式 |
| 2 | webapp-testing | 18.355K | Web 应用测试 |
| 3 | testing-strategies | 6.145K | 测试策略 |
| 4 | backend-testing | 6.198K | 后端测试 |
| 5 | playwright-best-practices | 3.270K | Playwright 最佳实践 |
| 6 | playwright-cli | 3.441K | Playwright CLI |
| 7 | playwright-generate-test | 3.946K | 测试生成 |
| 8 | playwright-explore-website | 3.902K | 网站探索 |
| 9 | playwright-automation-fill-in-form | 3.857K | 表单自动化 |
| 10 | e2e-testing-patterns | 5.039K | E2E 测试模式 |
| 11 | javascript-testing-patterns | 4.129K | JS 测试模式 |
| 12 | pytest-coverage | 3.840K | pytest 覆盖率 |
| 13 | vet | 6.695K | 代码验证 |
| 14 | vitest | 7.332K | Vite 测试框架 |
| 15 | systematic-debugging | 22.347K | 系统调试 |

### 3.4 新增自动化测试 Skills (2025.12 后)

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| Qa-WorkFlow | 2 | AI 驱动的 QA 自动化框架 |
| qa-test-automation-skill | 1 | 从规格自动生成测试 |
| agentic-qe | 218 | AI 驱动质量工程 |
| eval-view | 49 | 评估可视化 |
| fieldwork-skills | 12 | AI 实际工作技能 |
| agent-skills | 9 | 86 专业 AI 代理技能 |
| intelligems-analytics | 2 | A/B 测试分析 |
| casely-qa-skill | 2 | PDF 转测试用例 |
| playwright-py-skill | 1 | Playwright Python 技能 |
| qa-test | 1 | 前端 QA 测试 |
| claude-auto-dev | 2 | 自主开发技能 |

---

## 🛠️ 四、开发者工具 Skills

### 4.1 技能图谱概览

| 分类 | 核心 Skills | 热度 |
|------|-------------|------|
| Git 工具 | git-commit (7.928K), git-workflow (6.166K) | ⭐⭐⭐⭐ |
| Docker/K8s | docker-expert (4.870K), kubernetes | ⭐⭐⭐⭐ |
| IDE/编辑器 | vscode-ext-commands (4.003K) | ⭐⭐⭐ |
| 云服务 | Azure (100K+), AWS, GCP | ⭐⭐⭐⭐⭐ |
| 数据库 | PostgreSQL, Supabase | ⭐⭐⭐⭐ |

### 4.2 重点 Skills 深度分析

#### 🎯 Claude Code Settings (⭐ 448)

**仓库**: https://github.com/anysphere/claude-codex-settings  
**定位**: Claude Code 配置管理

**核心功能**:
- MCP 服务器管理
- Skills 配置
- Agents 管理
- CLAUDE.md 文件管理

#### 🎯 skillnote (⭐ 5 新增)

**仓库**: https://github.com/nicmarti/skillnote  
**定位**: Skills 笔记和文档

#### 🎯 Miro AI (⭐ 66)

**仓库**: https://github.com/miroapp/miro-ai  
**定位**: Miro AI 开发工具

**核心功能**:
- MCP 服务器配置
- Claude Code Skills 集成
- AI 驱动的白板体验

### 4.3 skills.sh 开发者工具排行榜 (Top 30)

| 排名 | Skill ID | 安装量 | 说明 |
|------|----------|--------|------|
| 1 | find-skills | 405.842K | 技能发现 |
| 2 | azure-ai | 102.193K | Azure AI |
| 3 | azure-observability | 102.071K | Azure 可观测性 |
| 4 | agent-browser | 74.327K | Agent 浏览器 |
| 5 | skill-creator | 61.145K | 技能创建 |
| 6 | browser-use | 45.053K | 浏览器使用 |
| 7 | supabase-postgres-best-practices | 28.106K | Supabase Postgres |
| 8 | next-best-practices | 26.337K | Next.js 最佳实践 |
| 9 | mcp-builder | 16.384K | MCP 构建器 |
| 10 | firecrawl | 8.307K | 网页爬取 |
| 11 | turborepo | 8.618K | Turborepo |
| 12 | vite | 7.962K | Vite |
| 13 | git-commit | 7.928K | Git 提交 |
| 14 | vitest | 7.332K | Vitest |
| 15 | pnpm | 5.333K | pnpm |
| 16 | chrome-devtools | 4.331K | Chrome DevTools |
| 17 | docker-expert | 4.870K | Docker 专家 |
| 18 | wrangler | 2.864K | Wrangler CLI |
| 19 | gh-cli | 5.622K | GitHub CLI |
| 20 | github-issues | 4.288K | GitHub Issues |

### 4.4 新增开发者工具 Skills (2025.12 后)

| Skill 名称 | ⭐ | 描述 |
|-----------|-----|------|
| miro-ai | 66 | Miro AI 开发工具 |
| software-dev-ai-claude-toolkit | 8 | 全栈开发工具包 |
| cf-devtools | 4 | Slidev 演示和开发者工具 |
| skills | 3 | 60+ 工作流自动化 |
| Variant-Systems/skills | 2 | 开发者工具市场 |
| shell-ergonomics-skills | 2 | Shell 体验优化 |
| claude-cli-ux-skill |  测试1 | CLI UX |
| SkillForge | - | 本地技能管理工具 |
| cli-godmode | - | 开发环境审计技能 |

---

## 📈 五、skills.sh 官方排行榜分析

### 5.1 Top 10 Skills (按安装量)

| 排名 | Skill ID | 安装量 | 来源 |
|------|----------|--------|------|
| 1 | find-skills | 405.842K | vercel-labs/skills |
| 2 | vercel-react-best-practices | 192.095K | vercel-labs/agent-skills |
| 3 | web-design-guidelines | 148.442K | vercel-labs/agent-skills |
| 4 | remotion-best-practices | 125.246K | remotion-dev/skills |
| 5 | frontend-design | 122.432K | anthropics/skills |
| 6 | azure-ai | 102.193K | microsoft/github-copilot-for-azure |
| 7 | azure-observability | 102.071K | microsoft/github-copilot-for-azure |
| 8 | azure-storage | 102.060K | microsoft/github-copilot-for-azure |
| 9 | azure-cost-optimization | 102.056K | microsoft/github-copilot-for-azure |
| 10 | azure-deploy | 102.045K | microsoft/github-copilot-for-azure |

### 5.2 分类趋势分析

**热门分类**:
1. **Web 开发** (Next.js, React, Vue) - 占比 35%+
2. **云服务** (Azure, AWS, GCP) - 占比 25%+
3. **AI/ML** (Pydantic AI, LangGraph) - 占比 15%+
4. **测试** (Playwright, Vitest) - 占比 10%+
5. **游戏开发** - 占比 5% (增长迅速)

---

## 🎯 六、实用 Skills 推荐

### 6.1 游戏开发推荐

```
# Claude-Code-Game-Studios
npm install @anthropic-ai/claude-code-game-studios

# Unity MCP
npm install @volaly/unity-mcp

# Godot MCP  
npm install @nicbarker/godot-mcp
```

### 6.2 Python 开发推荐

```
# pydantic-ai-skills
npm install @dougtrajano/pydantic-ai-skills

# Python Testing Patterns
npm install @wshobson/agents/python-testing-patterns
```

### 6.3 测试推荐

```
# Playwright
npm install @microsoft/playwright-cli

# TDD
npm install @obra/superpowers/test-driven-development
```

### 6.4 开发者工具推荐

```
# Find Skills
npm install @vercel-labs/skills/find-skills

# Skill Creator
npm install @anthropics/skills/skill-creator

# Browser Use
npm install @browser-use/browser-use
```

---

## 📝 总结

### 本周更新亮点

1. **游戏客户端开发**: Unity AI Workflow 2026 发布，Claude-Code-Game-Studios 持续更新
2. **Python 开发**: pydantic-ai-skills 热度上升，security-antipatterns-python 新增
3. **自动化测试**: agentic-qe (218⭐) 成为 AI 驱动测试新秀
4. **开发者工具**: Miro AI (66⭐) 集成 MCP 服务器

### Skills 缺口分析

| 方向 | 缺口 | 建议 |
|------|------|------|
| 游戏客户端测试 | 缺少专门的 Unity/Godot 自动化测试 Skills | 可填补 |
| Python AI 集成 | Pydantic AI/LangGraph Skills 需求旺盛 | 可扩展 |
| DevOps | GitOps/ArgoCD Skills 相对较少 | 可填补 |

---

> 调研持续更新中，欢迎提交 PR 补充更多 Skills！
> 
> 仓库地址: https://github.com/kongshan001/cc_skills
