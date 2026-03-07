# Claude Code Skills 调研报告 - 2026年3月 Week 49

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
| Unity-MCP | 390+⭐ | AI-powered Unity Editor 连接 MCP | 2026-03-04 |
| MiAO-MCP-for-Unity | 25⭐ | Unity Editor 和游戏的 MCP Server + Plugin | 2026-03-04 |
| webxr-dev-skill | 22⭐ | WebXR/VR 开发技能 - Three.js + Meta Quest | 2026-03-03 |

### 1.2 新增重点 Skills 深度分析

#### 1.2.1 Unity-MCP ⭐⭐⭐⭐

**GitHub**: https://github.com/IvanMurzak/Unity-MCP  
**Stars**: 390+  
**更新**: 2026-03-04

> AI-powered bridge connecting LLMs and advanced AI agents to the Unity Editor via the Model Context Protocol (MCP).

**核心功能**:

| 功能 | 描述 |
|------|------|
| Unity Editor 集成 | 通过 MCP 协议连接 Unity 编辑器 |
| 代码生成 | AI 驱动的代码生成 |
| 调试辅助 | 错误调试和问题解决 |
| 任务自动化 | 游戏开发任务自动化 |

**适用场景**:
- Unity 游戏项目 AI 辅助开发
- 自动化代码生成
- 游戏玩法快速原型

**本地部署**:
```bash
git clone https://github.com/IvanMurzak/Unity-MCP.git
# 按照 README 配置 MCP 服务器
```

---

#### 1.2.2 MiAO-MCP-for-Unity ⭐⭐⭐

**GitHub**: https://github.com/MiAO-AI-Lab/MiAO-MCP-for-Unity  
**Stars**: 25  
**更新**: 2026-03-04

> MCP Server + Plugin for Unity Editor and Unity game. The Plugin allows to connect to MCP clients like Claude Desktop or others.

**核心功能**:

| 功能 | 描述 |
|------|------|
| Unity Editor MCP | 编辑器级别的 MCP 支持 |
| 游戏运行时连接 | 游戏内 MCP 通信 |
| 多客户端支持 | Claude Desktop 等 |

---

#### 1.2.3 WebXR Dev Skill ⭐⭐⭐

**GitHub**: https://github.com/danielcanton/webxr-dev-skill  
**Stars**: 22  
**更新**: 2026-03-03

> WebXR/VR development skill for Claude Code — Three.js + Meta Quest guide

**核心功能**:

| 功能 | 描述 |
|------|------|
| Three.js 集成 | Web 3D 开发 |
| Meta Quest 支持 | VR 设备支持 |
| WebXR 标准 | 沉浸式体验开发 |

---

### 1.3 MCP 游戏开发服务器

| 项目 | Stars | 描述 |
|-----|-------|------|
| gamedev-mcp-hub | 1⭐ | 165+ 游戏开发 MCP 工具聚合 |
| unity_code_mcp | 9⭐ | Unity 代码 MCP 服务器 |
| gameplay-mcp | 0⭐ | Unity Gameplay MCP 服务器 |
| mimir-mcp | 1⭐ | Unity 游戏内 MCP 库 |

---

### 1.4 Antigravity Skills 游戏开发分类

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

### 1.5 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Claude-Code-Game-Studios | 完整的工作流、48 agents 协作 | 配置复杂、学习曲线陡峭 |
| Unity-MCP | 官方维护、功能全面 | 需要 Unity 2020+ |
| MiAO-MCP | 游戏内通信支持 | Stars 较低 |
| WebXR Dev Skill | VR/AR 新兴领域 | 适用场景有限 |

---

## 🐍 二、Python 开发 Skills

### 2.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| ai-guide | 8,909⭐ | 程序员鱼皮的 AI 资源大全，Vibe Coding 零基础教程 | 2026-03-04 |
| pydantic-ai-skills | 140⭐ | Pydantic AI Agent Skills 支持 | 2026-03-04 |
| developer-kit | 132⭐ | Claude Code 模块化插件系统，Python 支持 | 2026-03-04 |
| python-rope-refactor | 36⭐ | Python 代码重构工具 rope | 2026-02-01 |
| beagle | 35⭐ | Claude Code 代码审查技能，Python/Go/React | 2026-03-04 |
| Agently | 3,600+⭐ | GenAI 应用开发框架 | 2026-03-04 |
| Perseus | 26⭐ | AI 驱动的安全评估 Skills，多语言支持 | 2026-03-04 |

### 2.2 重点 Skills 深度分析

#### 2.2.1 Agently ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/AgentEra/Agently  
**Stars**: 3,600+  
**更新**: 2026-03-04

> [GenAI Application Development Framework] Build GenAI application quick and easy

**核心功能**:

| 功能 | 描述 |
|------|------|
| 结构化数据交互 | 与 GenAI agent 轻松交互 |
| 链式调用语法 | 简洁的 API 设计 |
| 事件驱动流 | TriggerFlow 管理复杂工作流 |
| 模型无关 | 切换模型无需重写代码 |

**适用场景**:
- GenAI 应用快速开发
- 多模型集成
- 复杂 AI 工作流构建

---

#### 2.2.2 Pydantic AI Skills ⭐⭐⭐⭐

**GitHub**: https://github.com/niccolox/pydantic-ai-skills  
**Stars**: 140  
**更新**: 2026-03-04

> Agent Skills (agentskills.io) 支持，Pydantic AI 渐进式披露。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 文件系统 Skills | 程序化 Skills 支持 |
| 渐进式披露 | 复杂 API 简化使用 |
| 类型安全 | Pydantic 模型集成 |

---

#### 2.2.3 Perseus ⭐⭐⭐

**GitHub**: https://github.com/kaivyy/perseus  
**Stars**: 26  
**更新**: 2026-03-04

> AI-powered security assessment SKILLS for your codebase.

**核心功能**:

| 功能 | 描述 |
|------|------|
| 多语言支持 | JS, Go, Python, Rust, Java, PHP, Ruby, C# |
| Claude Code 集成 | 无缝配合 Claude Code |
| Codex 支持 | 支持 OpenCode |
| 安全评估 | 代码安全扫描 |

---

### 2.3 Python 开发 Skills 最佳实践

| Skill 类型 | 描述 | 状态 |
|-----------|------|------|
| Python Type Safety | mypy/pyright 严格类型检查 | ✅ 已收录 |
| Python Dev Skills | Python 3.12+ 现代工具链 | ✅ 已收录 |
| FastAPI Development | RESTful API 开发 | ✅ 已收录 |
| Async Programming | asyncio 异步编程 | ✅ 已收录 |

---

### 2.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Agently | 框架完整、生态丰富 | 学习曲线 |
| Pydantic AI Skills | 类型安全、现代 AI 框架 | 特定于 Pydantic AI |
| Python Type Safety | 类型检查严格 | 需要团队配合 |
| Perseus | 多语言安全评估 | Stars 较低 |

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
| playwright-skill | 1,858⭐ | Playwright 浏览器自动化技能 | 2026-03-04 |
| agent-skills | 9⭐ | 86 specialized AI agents，bug fixing, testing | 2026-03-04 |
| fieldwork-skills | 12⭐ | Battle-tested skills for AI agents | 2026-02-26 |
| playwright-undetected-skill | 4⭐ | 绕过机器人检测的 Playwright | 2026-01-13 |
| Qa-WorkFlow | 2⭐ | AI-powered QA automation framework | 2026-02-13 |
| casely-qa-skill | 2⭐ | PDF Requirements → TestRail Excel test cases | 2026-03-04 |
| qa-test-automation-skill | 1⭐ | 从规格自动生成测试计划/用例 | 2026-03-03 |
| ios-simulator-skill | 560⭐ | iOS 模拟器技能 - 构建/运行/交互 | 2026-03-04 |

### 3.3 重点 Skills 深度分析

#### 3.3.1 Playwright Skill ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/anthropics/playwright-skill  
**Stars**: 1,858  
**更新**: 2026-03-04

> Claude Code Skill for browser automation with Playwright.

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

---

#### 3.3.2 iOS Simulator Skill ⭐⭐⭐⭐

**GitHub**: https://github.com/saturnboy/ios-simulator-skill  
**Stars**: 560  
**更新**: 2026-03-04

> An IOS Simulator Skill for ClaudeCode. Use it to optimise Claude's ability to build, run and interact with your apps.

**核心功能**:

| 功能 | 描述 |
|------|------|
| 构建优化 | iOS 应用构建 |
| 运行测试 | 模拟器中运行 |
| 应用交互 | 应用内交互测试 |
| Token 节省 | 优化上下文使用 |

**适用场景**:
- iOS 游戏测试
- 移动端 UI 自动化
- 跨平台测试

---

#### 3.3.3 QA Test Automation Skill ⭐⭐⭐

**Skill 类型**: QA 自动化测试  
**状态**: ✅ 已收录

> 自动从规格和源代码生成测试计划、测试设计和测试用例。

**核心功能**:

| 功能 | 描述 |
|------|------|
| 规格分析 | 需求文档解析 |
| 测试计划 | IEEE 829 标准 |
| 测试用例 | 自动生成 |
| 导出 | TestRail 格式支持 |

---

### 3.4 游戏客户端测试 Skills 缺口分析

| 缺口领域 | 现有 Skills | 建议开发 |
|---------|-------------|---------|
| Unity 测试 | unity-developer | Unity Test Framework 集成 |
| Godot 测试 | godot-gdscript-patterns | GUT 测试框架 |
| 图像识别 | - | OpenCV + ML 图像对比 |
| 性能监控 | - | 帧率/内存监控 Skills |
| 移动端游戏测试 | android-adb | iOS/Android 游戏测试 |
| 游戏自动化 | - | 游戏脚本自动化 |

---

### 3.5 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Playwright Skill | 功能全面、社区活跃 | 主要针对 Web 游戏 |
| iOS Simulator | 移动端完整支持 | 仅限 Apple 平台 |
| QA Test Automation | 自动化程度高 | 新兴项目 |
| Fieldwork Skills | 实战验证、生产可用 | 文档可能不完整 |

---

## 🛠 四、开发者工具 Skills

### 4.1 GitHub 热门项目

| 项目 | Stars | 描述 | 更新日期 |
|-----|-------|------|---------|
| everything-claude-code | 59,962⭐ | 50K⭐ AI Agent 性能优化 | 2026-03-04 |
| serena | 20,985⭐ | 语义检索和编辑能力工具包 | 2026-03-04 |
| pal-mcp-server | 11,184⭐ | Claude Code 多模型支持 MCP | 2026-03-04 |
| mcp-use | 9,368⭐ | MCP 框架使用 | 2026-03-03 |
| git-mcp | 7,693⭐ | GitHub 项目 MCP 服务器 | 2026-03-04 |
| DevDocs | 2,039⭐ | 技术文档 MCP 服务器 | 2026-03-04 |
| dev-browser | 3,756⭐ | Claude Code + Playwright 浏览器自动化 | 2026-03-01 |
| pg-aiguide | 1,580⭐ | PostgreSQL 技能和文档 MCP | 2026-03-04 |
| orchestkit | 98⭐ | AI 开发工具包，70 skills, 38 agents | 2026-03-02 |
| claude-reflect-system | 71⭐ | 持续学习与自我改进系统 | 2026-03-04 |

### 4.2 重点 Skills 深度分析

#### 4.2.1 Serena ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/oraios/serena  
**Stars**: 20,985  
**更新**: 2026-03-04

> A powerful coding agent toolkit providing semantic retrieval and editing capabilities.

**核心功能**:

| 功能 | 描述 |
|------|------|
| 语义检索 | 代码语义理解 |
| 编辑能力 | 智能代码编辑 |
| MCP 集成 | 模型上下文协议 |
| 多工具支持 | 丰富的集成能力 |

---

#### 4.2.2 GitMCP ⭐⭐⭐⭐⭐

**GitHub**: https://github.com/idosal/git-mcp  
**Stars**: 7,693  
**更新**: 2026-03-04

> Put an end to code hallucinations! GitMCP is a free, open-source, remote MCP server for any GitHub project

**核心功能**:

| 功能 | 描述 |
|------|------|
| 代码幻觉终结 | 真实代码上下文 |
| GitHub 集成 | 任何 GitHub 项目 |
| 免费开源 | 社区驱动 |

---

#### 4.2.3 DevDocs MCP ⭐⭐⭐⭐

**GitHub**: https://github.com/cyberagiinc/DevDocs  
**Stars**: 2,039  
**更新**: 2026-03-04

> Completely free, private, UI based Tech Documentation MCP server.

**核心功能**:

| 功能 | 描述 |
|------|------|
| 免费私有 | 不依赖云服务 |
| 开发者友好 | 技术文档快速访问 |
| 多客户端支持 | Cursor, Windsurf, Cline, Claude |

---

#### 4.2.4 PostgreSQL AI Guide ⭐⭐⭐⭐

**GitHub**: https://github.com/timescale/pg-aiguide  
**Stars**: 1,580  
**更新**: 2026-03-04

> MCP server and Claude plugin for Postgres skills and documentation.

**核心功能**:

| 功能 | 描述 |
|------|------|
| PostgreSQL 技能 | Postgres 特定技能 |
| 文档支持 | 官方文档集成 |
| 代码生成 | 更好的 SQL 代码 |

---

#### 4.2.5 Claude Reflect System ⭐⭐⭐

**GitHub**: https://github.com/saasplatcom/claude-reflect-system  
**Stars**: 71  
**更新**: 2026-03-04

> Continual Learning & Self-improving skills system for Claude Code

**核心功能**:

| 功能 | 描述 |
|------|------|
| 持续学习 | 从修正中学习 |
| 记忆系统 | 错误不重复 |
| 自我改进 | 技能进化 |

---

#### 4.2.6 Skill Generator ⭐⭐⭐

**GitHub**: https://github.com/marketingjuliancongdanh79-pixel/skill-generator  
**Stars**: 72  
**更新**: 2026-03-03

> Bộ công cụ tạo AI Skill từ ý tưởng — Dành cho Antigravity, Claude Code, Cursor, Windsurf

**核心功能**:

| 功能 | 描述 |
|------|------|
| Skill 生成 | 从想法创建 AI Skill |
| 多平台支持 | Antigravity, Claude Code, Cursor |
| 评分系统 | 100/100 S-tier 评级 |

---

### 4.3 开发者工具分类 Skills

| Skill ID | 名称 | 描述 |
|----------|------|------|
| git-essentials | Git 基础 | 版本控制最佳实践 |
| docker-essentials | Docker 基础 | 容器化技能 |
| browser-automation | 浏览器自动化 | Playwright/Cypress |
| api-security-testing | API 安全测试 | REST/GraphQL 安全 |
| mcp-servers | MCP 服务器 | 各种 MCP 工具集成 |

---

### 4.4 优缺点分析

| Skill | 优点 | 缺点 |
|-------|------|------|
| Serena | 语义能力强、20K+ Stars | 配置复杂 |
| GitMCP | 免费、解决幻觉 | 依赖 GitHub |
| DevDocs | 免费私有、多支持 | 功能相对基础 |
| pg-aiguide | Postgres 专用 | 特定数据库 |
| Claude Reflect | 持续学习独特 | 概念验证阶段 |

---

## 📈 五、本周新发现 Skills (2026-03-02 后创建)

| 项目 | Stars | 描述 | 创建日期 |
|-----|-------|------|---------|
| makeownsrt | 135⭐ | 从 MKV 提取字幕并翻译成双语文SRT | 2026-03-02 |
| skill-generator | 72⭐ | AI Skill 生成工具 | 2026-03-03 |
| qiaomu-design-advisor | 72⭐ | 偏执型设计顾问 | 2026-03-02 |
| recall | 65⭐ | 记住过去的对话 | 2026-03-03 |
| ai-marketing-claude | 45⭐ | AI 营销套件，15 个营销技能 | 2026-03-02 |
| webxr-dev-skill | 22⭐ | WebXR/VR 开发技能 | 2026-03-03 |
| appstore-review-skill | 15⭐ | App Store 审核检查 | 2026-03-02 |

---

## 📋 六、趋势分析与建议

### 6.1 当前趋势

1. **游戏开发 MCP 工具爆发**
   - Unity-MCP 达到 390+ Stars
   - MiAO-MCP 提供游戏内通信
   - 165+ 游戏开发 MCP 工具聚合出现

2. **Python 开发专业化**
   - Agently 框架达到 3,600+ Stars
   - Pydantic AI Skills 类型安全
   - 安全评估 Skills 出现 (Perseus)

3. **测试 Skills 移动端扩展**
   - iOS Simulator Skill 达到 560 Stars
   - QA 自动化程度提升
   - Agentic QE 平台出现

4. **开发者工具 MCP 协议主导**
   - Serena 达到 20K+ Stars
   - GitMCP 解决代码幻觉
   - DevDocs 免费私有文档服务

### 6.2 建议开发的 Skills

| 优先级 | Skill | 理由 |
|--------|-------|------|
| ⭐⭐⭐⭐⭐ | Unity Test Framework 集成 | 游戏测试刚需 |
| ⭐⭐⭐⭐ | Godot GUT 测试框架 | Godot 测试空白 |
| ⭐⭐⭐⭐ | 游戏性能监控 Skills | 帧率/内存监控 |
| ⭐⭐⭐ | 图像识别测试 Skills | OpenCV 集成 |
| ⭐⭐⭐ | 移动端游戏自动化 | iOS/Android |

---

## 📋 七、总结

本次调研覆盖了游戏客户端开发、Python 开发、游戏客户端自动化测试和开发者工具四个方向。整体来看：

1. **游戏客户端开发**: Unity-MCP 成为新热点，MCP 协议正在改变游戏开发工作流
2. **Python 开发**: Agently 框架快速增长，类型安全和 AI 框架集成成为重点
3. **测试自动化**: iOS Simulator Skill 表现亮眼，移动端测试能力扩展
4. **开发者工具**: MCP 协议生态爆发，Serena 达到 20K+ Stars

建议持续关注这些领域的最新发展，特别是：
- Unity/Godot 引擎的 MCP 集成
- 游戏客户端专用测试 Skills
- 多模态 AI 在游戏开发中的应用

---

**下次调研计划**:
- 关注 Claude Code 官方 Skills 更新
- 追踪新出现的游戏引擎 MCP 工具
- 重点关注 AI 驱动测试工具
- 分析 Skill Generator 类工具的发展

---

*调研完成时间: 2026-03-04 23:29 UTC*
