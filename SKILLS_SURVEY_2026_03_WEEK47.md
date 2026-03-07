# Claude Code Skills 调研报告 - 2026年3月 Week 47

**调研日期**: 2026-03-04  
**技能来源**: GitHub API 实时搜索 + Antigravity Awesome Skills (968+ Skills) + ClawHub 排行榜  
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

#### 1.2.2 skills-weaver ⭐⭐⭐

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

#### 1.2.3 OH-Unity-GameDev-Skills ⭐⭐⭐

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

#### 1.2.4 unity-ai-workflow ⭐⭐

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

---

#### 1.2.5 unreal-engine-skills ⭐⭐

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

---

### 1.3 Antigravity Skills 游戏开发分类

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

### 1.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Claude-Code-Game-Studios | 完整的工作流、48 agents 协作 | 配置复杂、学习曲线陡峭 |
| skills-weaver | RPG 框架完整、Agent SDK 集成 | 主题单一、适用范围有限 |
| OH-Unity-GameDev-Skills | 轻量级、专注于 Unity | 功能有限、仅脚本开发 |
| unity-ai-workflow | 最新 Unity 版本支持 | Stars 较低、验证不足 |
| unreal-engine-skills | 覆盖全面、C++ 深入 | 文档可能不完整 |

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| everything-claude-code | 59,962⭐ | 50K⭐ AI Agent 性能优化系统，13 agents, 56 skills | 2026-03-04 |
| antigravity-awesome-skills | 19,191⭐ | 968+ 通用 Skills 集合，Python 开发技能丰富 | 2026-03-03 |
| claude-scientific-skills | 12,494⭐ | 148+ 科学研究 Skills，Python 数据分析 | 2026-03-02 |
| python-type-safety | - | Python 类型安全最佳实践 | 2026-03-04 |
| python-dev-skills | - | Python 3.12+ 现代工具链 | 2026-03-04 |

### 2.2 重点 Skills 深度分析

#### 2.2.1 Python Type Safety ⭐⭐⭐⭐

**Skill 类型**: Python 开发最佳实践  
**状态**: ✅ 已收录

> Python 类型安全最佳实践，10 个核心模式，mypy/pyright 严格检查。

**核心模式**:

| 模式 | 描述 |
|------|------|
| Strict Typing | mypy --strict 模式 |
| Type Guards | 运行时类型 narrowing |
| Generic Types | 泛型编程实践 |
| Protocol | 鸭子类型安全实现 |
| Literal Types | 字面量类型精确控制 |

**适用场景**:
- 大型 Python 项目类型安全要求
- 团队协作代码规范
- 静态分析集成

**本地部署**:
```bash
# 复制到 ~/.claude/skills/
cp -r python-type-safety ~/.claude/skills/
```

---

#### 2.2.2 Python Dev Skills ⭐⭐⭐⭐

**Skill 类型**: Python 开发工具链  
**状态**: ✅ 已收录

> Python 3.12+ 现代工具链，FastAPI/异步/测试/性能优化。

**核心能力**:

| 类别 | 技能 |
|------|------|
| 异步编程 | asyncio, async/await 最佳实践 |
| FastAPI | RESTful API 开发 |
| 测试 | pytest, unittest, coverage |
| 性能优化 | profiling, caching, async |

**适用场景**:
- 现代 Python Web 开发
- 异步 I/O 应用
- 高性能服务开发

---

#### 2.2.3 FastAPI Pro ⭐⭐⭐

**Skill 类型**: FastAPI 专业开发  
**状态**: ✅ 已收录

> FastAPI 专业技能包，包含中间件、依赖注入、性能优化。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 中间件系统 | 认证、日志、性能监控 |
| 依赖注入 | 生命周期管理 |
| 数据库集成 | SQLAlchemy, asyncpg |
| 部署 | Docker, uvicorn, gunicorn |

---

#### 2.2.4 Developer Kit - Python Plugin ⭐⭐

**GitHub**: https://github.com/giuseppe-trisciuoglio/developer-kit  
**Stars**: 132  
**更新**: 2026-03-04

> Developer Kit for Claude Code - 模块化插件系统，包括 Java/Spring Boot/LangChain4J、TypeScript/NestJS/React、Python 等。

**Python 能力**:

| 类别 | 功能 |
|------|------|
| Web 框架 | FastAPI, Flask, Django |
| 数据处理 | pandas, numpy |
| 测试 | pytest, unittest |
| 类型检查 | mypy, pyright |

---

### 2.3 Antigravity Skills Python 分类

| Skill ID | 名称 | 描述 |
|----------|------|------|
| python-programming | Python 编程 | 基础到高级 Python 模式 |
| fastapi-development | FastAPI 开发 | RESTful API 构建 |
| django-development | Django 开发 | 全栈 Web 框架 |
| async-programming | 异步编程 | asyncio, 事件循环 |
| data-analysis-python | Python 数据分析 | pandas, numpy, matplotlib |
| ml-python | Python 机器学习 | scikit-learn, pytorch |

---

### 2.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Python Type Safety | 类型检查严格、团队协作好 | 学习曲线陡峭 |
| Python Dev Skills | 工具链完整、覆盖全面 | 可能过于复杂 |
| FastAPI Pro | 专业深度好、部署完善 | 依赖特定框架 |
| Developer Kit | 多语言支持、模块化 | Python 仅是子集 |

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 领域特点与挑战

游戏客户端自动化测试相比传统 Web/移动端测试有其独特挑战：

| 挑战 | 描述 | 解决方案 |
|------|------|---------|
| 图形渲染 | 游戏画面难以通过 DOM 解析 | 图像识别、OCR、事件注入 |
| 性能要求 | 60fps 流畅度要求 | 帧率监控、内存分析 |
| 平台多样 | iOS/Android/PC/Console | 多平台测试框架 |
| 状态复杂 | 游戏状态难以同步 | 状态快照、回放 |

### 3.2 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| agentic-qe | 217⭐ | Agentic QE Fleet 开源 AI 驱动的 QA/QE 平台 | 2026-03-04 |
| playwright-skill | 1,858⭐ | Playwright 浏览器自动化技能 | 2026-03-04 |
| playwright-undetected-skill | 4⭐ | 绕过机器人检测的 Playwright | 2026-01-13 |
| playwright-py-skill | 1⭐ | Playwright Python 版本 | 2026-02-26 |
| automation-testing-skills | - | 自动化测试 Skills 合集 | 2026-03-04 |

### 3.3 重点 Skills 深度分析

#### 3.3.1 Playwright Skill ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/anthropics/playwright-skill  
**Stars**: 1,858  
**更新**: 2026-03-04

> Claude Code Skill for browser automation with Playwright. Model-invoked browser automation。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 浏览器控制 | 启动、导航、截图 |
| 元素交互 | 点击、输入、悬停 |
| 等待策略 | 智能等待元素出现 |
| 多标签页 | 跨标签页操作 |

**适用场景**:
- Web 游戏测试
- UI 自动化
- E2E 测试

**本地部署**:
```bash
npm install -g playwright
# 安装 Claude Code Playwright Skill
```

---

#### 3.3.2 Agentic QE ⭐⭐⭐⭐

**GitHub**: https://github.com/Agentic-QE/agentic-qe  
**Stars**: 217  
**更新**: 2026-03-04

> Agentic QE Fleet is an open-source AI-powered QA/QE platform designed。

**核心特性**:

| 特性 | 描述 |
|------|------|
| AI 驱动测试 | LLM 生成测试用例 |
| 自动修复 | 失败测试自动重试 |
| 智能断言 | AI 判断测试结果 |
| 多框架支持 | Playwright, Cypress, Selenium |

---

#### 3.3.3 Automation Testing Skills ⭐⭐⭐

**Skill 类型**: 自动化测试综合  
**状态**: ✅ 已收录

> 自动化测试 Skills，AI 驱动测试、Playwright/Cypress E2E、pytest、TDD。

**核心能力**:

| 类别 | Skills |
|------|--------|
| E2E 测试 | Playwright, Cypress |
| 单元测试 | pytest, unittest |
| API 测试 | REST, GraphQL |
| 性能测试 | Locust, k6 |

---

#### 3.3.4 Playwright Undetected Skill ⭐⭐

**GitHub**: https://github.com/dalbit-mir/playwright-undetected-skill  
**Stars**: 4  
**更新**: 2026-01-13

> Claude Code Skill for browser automation with bot detection bypass. Patchright-based undetected Playwright。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 反检测 | 绕过机器人检测 |
| 本地测试 | localhost 测试 |
| 截图 | 页面截图 |
| UI 交互 | 表单、点击操作 |

---

### 3.4 游戏客户端测试 Skills 缺口分析

| 缺口领域 | 现有 Skills | 建议开发 |
|---------|-------------|---------|
| Unity 测试 | unity-developer | Unity Test Framework 集成 |
| Godot 测试 | godot-gdscript-patterns | GUT 测试框架 |
| 图像识别 | - | OpenCV + ML 图像对比 |
| 性能监控 | - | 帧率/内存监控 Skills |
| 移动端游戏测试 | android-adb | iOS/Android 游戏测试 |

---

### 3.5 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Playwright Skill | 功能全面、社区活跃 | 主要针对 Web 游戏 |
| Agentic QE | AI 驱动、自动化好 | 新兴项目、文档待完善 |
| Automation Testing Skills | 覆盖全面 | 需要集成多工具 |
| Playwright Undetected | 反检测能力强 | 适用场景有限 |

---

## 🛠 四、开发者工具 Skills

### 4.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| everything-claude-code | 59,962⭐ | 50K⭐ AI Agent 性能优化 | 2026-03-04 |
| pilot-shell | 1,465⭐ | Claude Code 专业开发环境 | 2026-03-04 |
| mcp-use | 9,368⭐ | MCP 框架使用 | 2026-03-03 |
| orchestkit | 98⭐ | AI 开发工具包，70 skills, 38 agents | 2026-03-02 |
| dev-browser | 3,756⭐ | Claude Code + Playwright 浏览器自动化 | 2026-03-01 |

### 4.2 重点 Skills 深度分析

#### 4.2.1 Dev Browser ⭐⭐⭐⭐

**GitHub**: https://github.com/anthropics/dev-browser  
**Stars**: 3,756  
**更新**: 2026-03-01

> Claude Code browser automation with Playwright and MCP。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 浏览器自动化 | 截图、点击、表单填写 |
| MCP 集成 | 模型上下文协议 |
| 会话管理 | 多标签页/窗口 |
| 调试工具 | DevTools 集成 |

---

#### 4.2.2 Orchestkit ⭐⭐⭐

**GitHub**: https://github.com/saasplatcom/orchestkit  
**Stars**: 98  
**更新**: 2026-03-02

> The Complete AI Development Toolkit for Claude Code — 70 skills, 38 agents。

**工具覆盖**:

| 类别 | 工具 |
|------|------|
| 代码审查 | GitHub PR, Code Review |
| 部署 | Docker, Vercel, Netlify |
| 测试 | Jest, pytest, Playwright |
| 监控 | Sentry, Datadog |

---

#### 4.2.3 Developer Tools Skills ⭐⭐⭐

**Skill 类型**: 开发者工具合集  
**状态**: ✅ 已收录

> 开发者工具 Skills，浏览器自动化、GitHub/GitLab 自动化、CI/CD 流水线。

**核心能力**:

| 类别 | Skills |
|------|--------|
| Git 操作 | commit, branch, merge |
| GitHub | PR, Issue, Actions |
| Docker | build, run, compose |
| CLI | 开发环境配置 |

---

#### 4.2.4 Developer Kit ⭐⭐

**GitHub**: https://github.com/giuseppe-trisciuoglio/developer-kit  
**Stars**: 132  
**更新**: 2026-03-04

> 模块化插件系统，提供可重用的 skills、agents 和 commands。

**覆盖范围**:

| 类别 | 技术栈 |
|------|--------|
| Java | Spring Boot, LangChain4J |
| TypeScript | NestJS, React |
| Python | FastAPI, Django |
| PHP | WordPress |
| Cloud | AWS CloudFormation |

---

#### 4.2.5 Pilot Shell ⭐⭐⭐

**GitHub**: https://github.com/mpoon23/pilot-shell  
**Stars**: 1,465  
**更新**: 2026-03-04

> Claude Code 专业开发环境增强。

**核心功能**:

| 功能 | 描述 |
|------|------|
| Shell 集成 | 终端命令执行 |
| 环境管理 | 开发环境配置 |
| 工具链 | 常用 CLI 工具 |

---

### 4.3 Antigravity Skills 开发者工具分类

| Skill ID | 名称 | 描述 |
|----------|------|------|
| git-commands | Git 命令 | 日常 Git 操作 |
| github-actions | GitHub Actions | CI/CD 流水线 |
| docker-kubernetes | Docker/K8s | 容器编排 |
| vscode-configuration | VS Code 配置 | 开发环境 |
| terminal-productivity | 终端效率 | CLI 工具 |
| browser-automation | 浏览器自动化 | Playwright/Selenium |

---

### 4.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Dev Browser | 功能全面、MCP 集成 | 配置复杂 |
| Orchestkit | 工具覆盖广 | 70 skills 可能过重 |
| Developer Tools Skills | 一站式解决方案 | 深度可能不足 |
| Pilot Shell | 轻量级、专注 shell | 功能有限 |

---

## 📈 五、ClawHub Top Skills 排行榜

根据 ClawHub 实时评分（截至 2026-03-04）:

| 排名 | Skill | 评分 | 分类 |
|------|-------|------|------|
| 1 | superpowers | 68k⭐ | Agentic Workflow |
| 2 | compound-engineering | 9,782⭐ | 多代理编排 |
| 3 | get-shit-done | 24k⭐ | Spec 驱动开发 |
| 4 | planning-with-files | 15k⭐ | 持久化规划 |
| 5 | agentsys | 14k⭐ | 模块化编排 |
| 6 | ui-ux-pro-max | 36k⭐ | UI/UX 设计 |
| 7 | everything-claude-code | 50k⭐ | 性能优化 |
| 8 | claude-mem | - | 智能记忆 |
| 9 | deep-research | - | 深度研究 |
| 10 | trailofbits-security | - | 安全审计 |

---

## 📋 六、本周更新亮点

### 6.1 新增 Skills

| Skill | 来源 | 描述 |
|-------|------|------|
| Claude-Code-Game-Studios | GitHub | 48 agents 完整游戏开发工作室 |
| unreal-engine-skills | GitHub | Unreal Engine C++ 27 skills |
| unity-ai-workflow | GitHub | Unity 6.2+ AI 开发工作流 |
| agentic-qe | GitHub | AI 驱动的 QA/QE 平台 |
| developer-kit | GitHub | 多语言开发者工具包 |
| orchestkit | GitHub | 70 skills, 38 agents 工具包 |

### 6.2 Skills 缺口与建议

| 领域 | 缺口 | 建议开发 |
|------|------|---------|
| 游戏客户端测试 | Unity/Godot 专用测试 Skills | Unity Test Framework, GUT 集成 |
| Python 异步 | 缺少分布式任务队列 Skills | Celery, Redis Queue 集成 |
| 性能测试 | 游戏帧率/内存监控 Skills | 自定义开发 |
| 移动端游戏 | iOS/Android 游戏测试 Skills | Appium + 图像识别 |

---

## 📚 七、参考资料

1. **Antigravity Awesome Skills**: https://github.com/sickn33/antigravity-awesome-skills (19,191⭐)
2. **Awesome Claude Code**: https://github.com/awesome-fc/awesome-claude-code (26,194⭐)
3. **Everything Claude Code**: https://github.com/anthropics/everything-claude-code (59,962⭐)
4. **ClawHub Skills**: https://clawhub.ai/skills
5. **Skills.sh**: https://skills.sh
6. **Playwright Skill**: https://github.com/anthropics/playwright-skill (1,858⭐)
7. **Dev Browser**: https://github.com/anthropics/dev-browser (3,756⭐)
8. **Claude-Code-Game-Studios**: https://github.com/Donchitos/Claude-Code-Game-Studios (29⭐)

---

## 📝 八、文档规范说明

每个 Skill 文档包含：

1. **Skill 背景需求** - 为什么需要这个 Skill
2. **目标** - Skill 要解决什么问题
3. **设计方案** - Skill 的技术架构
4. **本地部署** - Win/Mac/Linux 部署指南
5. **效果展示** - 实际使用效果
6. **优缺点分析** - Skill 的优势与不足
7. **平替对比** - 类似 Skill 对比
8. **落地过程** - 实践验证的完整记录

---

*持续更新中...下次调研时间: 2026-03-11*
