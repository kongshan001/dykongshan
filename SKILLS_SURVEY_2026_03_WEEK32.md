# Claude Code Skills 补充调研报告 - 2026年3月 (Week 32)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 实时搜索 + ClawHub 官方排行榜  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 新增调研

---

## 📊 调研概要

本次调研继续聚焦 Claude Code 热门 Skills，基于 ClawHub 实时搜索和 GitHub API，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/代码审查/CI/CD)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 Claude Code Game Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

> 🚀 Turn Claude Code into a full game dev studio — 48 AI agents, 36 workflow skills, and a complete coordination system mirroring real studio hierarchy.

**核心架构 (三层体系)**:
- **Tier 1 — Directors (Opus)**: creative-director, technical-director, producer
- **Tier 2 — Department Leads (Sonnet)**: game-designer, lead-programmer, art-director, audio-director, narrative-director, qa-lead, release-manager, localization-lead
- **Tier 3 — Specialists (Sonnet/Haiku)**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer, systems-designer, level-designer, economy-designer, technical-artist, sound-designer, writer, world-builder, ux-designer, prototyper, performance-analyst, devops-engineer, analytics-engineer, security-engineer, qa-tester, accessibility-specialist, live-ops-designer, community-manager

**36 个 Slash Commands**: /design-review, /code-review, /balance-check, /asset-audit, /scope-check, /perf-profile, /tech-debt, /sprint-plan, /milestone-review, /estimate, /retrospective, /bug-report, /start, /project-stage-detect, /reverse-document, /gate-check, /design-systems, /release-checklist, /launch-checklist, /changelog, /patch-notes, /hotfix, /brainstorm, /playtest-report, /prototype, /onboard, /localize, /team-combat, /team-narrative, /team-ui, /team-release, /team-polish, /team-audio, /team-level

**推荐理由**: 最完整的游戏开发多代理系统，适合大型商业游戏项目。

---

### 1.2 game-cog (评分 1.132, TOP 1)

**项目地址**: [syedhassaanahmed/game-cog](https://github.com/syedhassaanahmed/game-cog)

> Game Development Orchestrator - DeepResearch Top 1 Skill

**核心功能**:
- 游戏开发全流程编排
- 从概念到发布的完整工作流
- 多引擎支持 (Unity, Godot, Unreal)

---

### 1.3 Unity AI Workflow 2026 ⭐4

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

> AI-first Unity 6.2+ game development workflow — rules, agents, skills, and slash commands

**核心哲学**: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

**Dev Modes (三种开发模式)**:
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、game jam |

---

### 1.4 game-developer-skill (评分 0.976)

**项目地址**: Claude Code Game Developer Skill

> Claude Code 游戏开发专家技能

**功能**:
- GDScript/Unity C#/Unreal C++ 开发
- 游戏架构设计
- 性能优化建议

---

### 1.5 godot-dev-guide (评分 0.983)

> Godot 4 开发完整指南

**核心内容**:
- GDScript 最佳实践
- 节点系统详解
- 信号与事件处理

---

### 1.6 primitives-dsl (评分 0.877)

> Universal Game Primitives - 通用游戏原语

**功能**:
- 跨引擎游戏对象定义
- 统一资源管理

---

## 🐍 二、Python 开发 Skills

### 2.1 py / python (评分 1.049/1.001)

**项目地址**: Python Skills on ClawHub

**核心功能**:
- Python 3.12+ 现代语法
- 类型提示最佳实践
- 异步编程模式

---

### 2.2 fastapi (评分 0.873)

**项目地址**: FastAPI Skill

> High-performance Web API Framework

**核心功能**:
- RESTful API 设计
- Pydantic 数据验证
- 依赖注入
- 自动文档生成

---

### 2.3 python-executor (评分 0.974)

> Python Executor Skill

**功能**:
- 安全代码执行
- 沙箱环境
- 单元测试生成

---

### 2.4 uv-priority (评分 0.728)

> uv Package Manager Priority

**功能**:
- 极速 Python 包管理
- 虚拟环境管理
- 依赖解析优化

---

### 2.5 neo-py-test-creator (评分 0.719)

> Pytest Test Creator

**功能**:
- 自动生成测试用例
- Mock 对象创建
- 测试覆盖率优化

---

### 2.6 python-dataviz (评分 0.889)

> Python Data Visualization

**功能**:
- Matplotlib/Seaborn/Plotly
- 数据分析可视化
- 图表生成

---

## 🧪 三、自动化测试 Skills

### 3.1 test-master (评分 1.169)

**项目地址**: Test Master Skill

> 完整测试管理解决方案

**核心功能**:
- 测试计划管理
- 测试用例设计
- 测试报告生成

---

### 3.2 android-adb (评分 1.118)

> ADB Connection Skill

**核心功能**:
- Android 设备连接
- 应用安装/卸载
- 日志抓取
- 自动化操作

---

### 3.3 e2e-testing-patterns (评分 1.116)

> E2E Testing Patterns

**功能**:
- 端到端测试最佳实践
- 测试架构设计
- 跨浏览器测试

---

### 3.4 testing-patterns (评分 1.078)

> Testing Patterns

**功能**:
- 测试设计模式
- 单元测试/集成测试
- Mock 与 Stub

---

### 3.5 ai-web-automation (评分 1.073)

> AI Web Automation

**功能**:
- 智能页面元素识别
- 自然语言测试描述
- 自动测试脚本生成

---

### 3.6 api-tester (评分 0.994)

> API Tester

**功能**:
- HTTP 请求构建
- 响应验证
- API 文档测试

---

### 3.7 clean-pytest (评分 0.874)

> Clean Pytest

**功能**:
- pytest 最佳实践
- 测试组织结构
- Fixtures 优化

---

### 3.8 mobile-appium-test (评分 0.840)

> Mobile Appium Test

**功能**:
- iOS/Android 原生应用测试
- 跨平台测试
- 设备农场集成

---

## 🛠 四、开发者工具 Skills

### 4.1 mcp-adapter (评分 1.074)

> MCP Adapter Skill

**功能**:
- MCP 工具适配
- 协议转换
- 跨平台集成

---

### 4.2 meow-finder (评分 1.063)

> Meow Finder

**功能**:
- 代码搜索与发现
- 语义搜索
- 代码片段管理

---

### 4.3 tools-ui (评分 1.036)

> Tools UI Skill

**功能**:
- 开发者工具 UI
- 命令行界面增强
- 可视化工具集成

---

### 4.4 openclaw-docker (评分 0.867)

> Docker Skill

**功能**:
- 容器化最佳实践
- Docker Compose
- 多阶段构建

---

### 4.5 api-tester (评分 0.994) - 见上

---

## 📈 五、ClawHub 排行榜分析

### Top 10 Skills (本周)

| 排名 | Skill | 评分 | 分类 |
|------|-------|------|------|
| 1 | game-cog | 1.132 | 游戏开发 |
| 2 | py | 1.049 | Python |
| 3 | python | 1.001 | Python |
| 4 | test-master | 1.169 | 测试 |
| 5 | mcp-adapter | 1.074 | 开发者工具 |
| 6 | android-adb | 1.118 | 移动测试 |
| 7 | e2e-testing-patterns | 1.116 | 测试 |
| 8 | testing-patterns | 1.078 | 测试 |
| 9 | ai-web-automation | 1.073 | 自动化 |
| 10 | meow-finder | 1.063 | 开发者工具 |

### 分类趋势

1. **游戏开发**: game-cog 保持 TOP 1，显示游戏开发是热门方向
2. **测试自动化**: 多个测试相关 Skills 进入 TOP 10，需求旺盛
3. **Python 开发**: py/python 保持高分，Python 开发者活跃
4. **开发者工具**: mcp-adapter, meow-finder 等工具类 Skills 增长明显

---

## 🔍 六、本周更新亮点

### 新增 Skills

1. **multi-agent-orchestration**: 多代理任务编排
2. **context-sentinel**: 会话上下文监控
3. **skill-publish**: 安全发布 Skills 到 ClawHub
4. **browser-secure**: 安全浏览器自动化

### 趋势分析

- **游戏开发**: Unity AI Workflow 2026 发布，Claude Code Game Studios 持续更新
- **Python**: uv 成为默认包管理工具推荐
- **测试**: AI 驱动测试成为主流趋势
- **开发者工具**: MCP 协议集成成为热点

---

## 📝 七、Skills 缺口与建议

### 当前缺口

1. **游戏客户端自动化测试**: 专门针对游戏客户端的自动化测试 Skills 较少
2. **Unity/Unreal 性能分析**: 专业的游戏性能分析 Skills 不多
3. **游戏 AI**: 游戏 AI 开发相关 Skills 有限
4. **跨平台游戏测试**: 多平台游戏测试 Skills 需要加强

### 建议方向

1. 开发游戏客户端 E2E 测试 Skills
2. 创建 Unity/Unreal 性能分析工具包
3. 构建游戏 AI 开发工作流
4. 完善移动端游戏测试方案

---

## 📚 参考资源

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills) - 968+ Skills
- [ClawHub Registry](https://clawhub.com) - 官方 Skills 市场
- [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
- [game-cog](https://github.com/syedhassaanahmed/game-cog)

---

*让 AI 助手真正记住你*
