# Claude Code Skills 完整调研报告 - 2026年3月 (第三十一周)

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + 实时搜索  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研继续聚焦 Claude Code 热门 Skills，基于 GitHub API 实时搜索，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/GameMaker/Love2D)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (浏览器自动化/代码审查/安全评估/CI/CD)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 Claude Code Game Studios ⭐28

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)

> 🚀 Turn Claude Code into a full game dev studio — 48 AI agents, 36 workflow skills, and a complete coordination system mirroring real studio hierarchy.

```markdown
## 核心架构 (三层体系)

### Tier 1 — Directors (Opus)
- creative-director: 创意总监，守护游戏愿景
- technical-director: 技术总监，技术决策
- producer: 制作人，项目管理

### Tier 2 — Department Leads (Sonnet)
- game-designer, lead-programmer, art-director
- audio-director, narrative-director, qa-lead
- release-manager, localization-lead

### Tier 3 — Specialists (Sonnet/Haiku)
- gameplay-programmer, engine-programmer, ai-programmer
- network-programmer, tools-programmer, ui-programmer
- systems-designer, level-designer, economy-designer
- technical-artist, sound-designer, writer
- world-builder, ux-designer, prototyper
- performance-analyst, devops-engineer, analytics-engineer
- security-engineer, qa-tester, accessibility-specialist
- live-ops-designer, community-manager

## 36 个 Slash Commands
### Reviews & Analysis
/design-review /code-review /balance-check /asset-audit
/scope-check /perf-profile /tech-debt

### Production
/sprint-plan /milestone-review /estimate /retrospective /bug-report

### Project Management
/start /project-stage-detect /reverse-document /gate-check /design-systems

### Release
/release-checklist /launch-checklist /changelog /patch-notes /hotfix

### Creative
/brainstorm /playtest-report /prototype /onboard /localize

### Team Orchestration
/team-combat /team-narrative /team-ui /team-release /team-polish
/team-audio /team-level
```

**推荐理由**: 最完整的游戏开发多代理系统，适合大型商业游戏项目。

---

### 1.2 Unity AI Workflow 2026 ⭐4

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

> AI-first Unity 6.2+ game development workflow — rules, agents, skills, and slash commands for Claude Code and Antigravity

```markdown
## 核心哲学: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

## Dev Modes (三种开发模式)
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、game jam |

## 技术架构
- TCREI Prompting: Task-Context-References-Evaluate-Iterate
- 验证系统: [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED] 标记
- 专家 Skills: UI Toolkit、ScriptableObject、Netcode、game feel
```

---

### 1.3 OH-Unity-GameDev-Skills ⭐6

**项目地址**: [OstrichHermit/OH-Unity-GameDev-Skills](https://github.com/OstrichHermit/OH-Unity-GameDev-Skills)

| 技能名称 | 功能描述 |
|---------|---------|
| **claude_skill_unity** | Unity 基础开发技能 |
| **doTween-unity** | DoTween 动画库集成 |
| **media-pipe-unity-skill** | MediaPipe 机器视觉集成 |
| **prime-tween-unity** | PrimeTween 高性能动画 |
| **skill-creator** | 技能创建辅助工具 |

---

### 1.4 cc-plugin-unity-gamedev ⭐1

**项目地址**: [tjboudreaux/cc-plugin-unity-gamedev](https://github.com/tjboudreaux/cc-plugin-unity-gamedev)

```markdown
## 技能分类
| 类别 | 技能数量 | 包含内容 |
|-----|---------|---------|
| **工具类** | 8 | Addressables, MemoryPack, ScriptableObjects, Profiling, Package Manager, Version Control, Debugging, Asset Pipeline |
| **动画/物理** | 5 | Animation, Physics, NavMesh, Object Pooling, State Machine |
| **AI/行为** | 2 | Behavior Designer, Gameplay Ability System (GAS) |
| **音视频** | 2 | Wwise 音频, Cinemachine 相机 |
| **UI** | 2 | UGUI, Mobile Optimization |
| **测试** | 1 | Test Framework |
| **DI/异步** | 1 | VContainer, UniTask |

## 核心技能示例
// Addressables 异步加载
var handle = Addressables.LoadAssetAsync<GameObject>("Prefab");
var prefab = await handle.Task;

// GAS Ability 定义
[CreateAssetMenu(fileName = "NewAbility", menuName = "Ability/Active")]
public class GameplayAbility : AbilitySystemComponent { }
```

---

### 1.5 Godot Skills ⭐3

**项目地址**: [kwhitejr/claude-resources](https://github.com/kwhitejr/claude-resources)

Claude Code 自定义 agents 和 skills，用于 Godot 游戏开发工作流。

---

### 1.6 GameMaker Skills ⭐2

**项目地址**: [leihaht/gamemaker-skills](https://github.com/leihaht/gamemaker-skills)

```markdown
## Skills 覆盖范围
- Object Creation Workflow: 完整4步流程模板
- GML Language Essentials: 变量、数据类型、操作符、控制流
- Data Structures: Structs、Arrays、ds_list、ds_map、ds_grid
- File System: JSON 处理、datafiles/ 结构、存档系统
- Event System: 执行顺序常见模式
-、事件类型、 Drawing & Graphics: 精灵、表面、着色器、粒子、瓦片地图
- Collision & Movement: 检测算法、优化技术
- Performance Optimization: Draw call 减少、对象池、性能分析
- Networking: 客户端-服务器架构、包结构、延迟补偿
- Platform-Specific: 移动端、主机、HTML5、桌面特性
- Advanced Topics: Shader 编程 (GLSL ES)、光照系统、法线贴图
```

---

### 1.7 Solana Game Skill ⭐5

**项目地址**: [solanabr/solana-game-skill](https://github.com/solanabr/solana-game-skill)

Claude Code skills for C#, Solana Unity SDK, Solana Mobile and Playsolana Unity SDK.

---

## 🐍 二、Python 开发 Skills

### 2.1 OrchestKit ⭐98

**项目地址**: [yonatangross/orchestkit](https://github.com/yonatangross/orchestkit)

> 🚀 The Complete AI Development Toolkit for Claude Code — 61 skills, 36 agents, 86 hooks, 3 plugins.

```markdown
## 核心功能
- 69 Skills: RAG patterns, FastAPI, React 19, testing, security, database design, ML integration
- 38 Agents: Specialized personas (backend-architect, frontend-dev, security-auditor)
- 85 Hooks: Pre-commit checks, git protection, quality gates
- 3 Plugins: MCP integration

## Python 相关 Skills
- FastAPI 生产模式
- 异步 SQLAlchemy 2.0
- 测试最佳实践
- 数据库设计模式
- 安全审计
```

---

### 2.2 beagle ⭐34

**项目地址**: [existential-birds/beagle](https://github.com/existential-birds/beagle)

> Claude Code plugin for code review skills and verification workflows. Python, Go, React, FastAPI, BubbleTea, and AI frameworks

```markdown
## 核心功能
- 代码审查自动化
- 验证工作流
- Python/Go/React 审查
- FastAPI 最佳实践验证
- Pydantic 模型审查
```

---

### 2.3 python-rope-refactor ⭐36

**项目地址**: [brian-yu/python-rope-refactor](https://github.com/brian-yu/python-rope-refactor)

```markdown
## 核心功能
- 使用 rope 进行 Python 代码库重构
- 教学 LLM agents 如何使用 rope 进行重构
- 支持批量重命名、提取方法、模块重组
- 代码质量提升
```

---

### 2.4 fastmcp-builder ⭐5

**项目地址**: [husniadil/fastmcp-builder](https://github.com/husniadil/fastmcp-builder)

```markdown
## 核心功能
- 使用 FastMCP 构建生产级 MCP 服务器的完整技能
- 参考指南、可运行示例
- 完整实现包含 OAuth、测试和最佳实践
- FastMCP 框架深度集成
```

---

### 2.5 claude-arsenal ⭐9

**项目地址**: [majiayu000/claude-arsenal](https://github.com/majiayu000/claude-arsenal)

> 🚀 39+ battle-tested Claude Code skills & 9 specialized agents for professional software development.

---

### 2.6 security-antipatterns-python ⭐3

**项目地址**: [subhashdasyam/security-antipatterns-python](https://github.com/subhashdasyam/security-antipatterns-python)

```markdown
## 核心功能
- Python 安全最佳实践
- SQL 注入检测
- Pickle 攻击防护
- 硬编码密钥检测
- 安全代码审计
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 Playwright Skill ⭐1900+ (热门第一)

**项目地址**: [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)

```markdown
## 核心功能
- 模型调用的 Playwright 自动化
- Web 应用自动化测试
- UI 验证和截图捕获
- 辅助调试 UI 行为
- Bot 检测绕过 (Patchright)

## 技术架构
用户请求 → Claude Code → Playwright Skill → 浏览器自动化
                                      ↓
                            测试结果/截图 → 返回 Claude

## 适用场景
- Web 游戏测试
- H5 游戏测试
- 前端功能验证
- UI 自动化测试
- 回归测试
```

---

### 3.2 Playwright Undetected Skill ⭐4

**项目地址**: [dalbit-mir/playwright-undetected-skill](https://github.com/dalbit-mir/playwright-undetected-skill)

```markdown
## 核心功能
- Bot 检测绕过
- Localhost 测试
- 截图捕获
- UI 交互
- Patchright 支持反检测
```

---

### 3.3 iOS Simulator Skill ⭐557

**项目地址**: [conorluddy/ios-simulator-skill](https://github.com/conorluddy/ios-simulator-skill)

```markdown
## 核心功能
- 模拟器控制: 启动/停止模拟器
- 应用安装: 安装 iOS 应用
- UI 交互: 自动化 UI 测试
- 截图捕获: 状态记录
- 21 个自动化脚本用于语义导航

## 技术特点
- 语义导航: 使用 Accessibility API 而非像素坐标
- Token 优化: 相比原始工具减少 96% token 消耗
- 零配置: macOS + Xcode 上立即可用
- 结构化输出: JSON 和格式化文本

## 脚本列表
- build_and_test.py - 构建项目、运行测试
- log_monitor.py - 实时日志监控
- screen_mapper.py - 分析当前屏幕
- navigator.py - 查找并交互元素
- gesture.py - 滑动、滚动、捏合
- keyboard.py - 文本输入和硬件按钮
- app_launcher.py - 应用生命周期控制
- accessibility_audit.py - WCAG 合规检查
- visual_diff.py - 截图对比
- test_recorder.py - 自动化测试文档
```

---

### 3.4 Android ADB Skill

**项目地址**: [cc_skills/automation-testing-skills/android-adb.md](./automation-testing-skills/android-adb.md)

```markdown
## 核心功能
- Android 设备控制
- APK 安装/卸载
- UI 自动化测试
- 截图和日志捕获
- 性能监控
```

---

### 3.5 mobile-dev-skills ⭐

**项目地址**: [ryanmind/mobile-dev-skills](https://github.com/ryanmind/mobile-dev-skills)

```markdown
## 核心功能
- Claude Code Skills for mobile development automation
- iOS/Android signing
- Building tools
- Testing tools
```

---

### 3.6 QA Workflow Skill ⭐2

**项目地址**: [islam-mamdouh/Qa-WorkFlow](https://github.com/islam-mamdouh/Qa-WorkFlow)

```markdown
## AI-powered QA automation framework
- Story validation (INVEST)
- IEEE 829 test plans
- Test case generation
- Bug reporting
- Figma design validation
- Jira & Figma integrations
```

---

### 3.7 ai-playwright-automation ⭐

**项目地址**: [MateiMiron/ai-playwright-automation](https://github.com/MateiMiron/ai-playwright-automation)

```markdown
## 核心功能
- AI-driven Playwright test suite
- 74 tests, zero manual code
- Custom skills
- Browser CLI
- 自动化测试文档生成
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 cc-switch ⭐23208 (热门第一)

**项目地址**: [farion1231/cc-switch](https://github.com/farion1231/cc-switch)

```markdown
## 核心功能
跨平台桌面 All-in-One 助手工具
- Claude Code
- Codex
- OpenCode
- Gemini CLI

支持所有主流 AI 编码工具的技能管理
```

---

### 4.2 Dev Browser Skill ⭐3746

**项目地址**: [SawyerHood/dev-browser](https://github.com/SawyerHood/dev-browser)

```markdown
## 核心功能
- 赋予 AI agent 使用网页浏览器的能力
- 自动化 Web 交互
- 网页数据抓取
- UI 测试
```

---

### 4.3 Terraform Skill ⭐1267

**项目地址**: [antonbabenko/terraform-skill](https://github.com/antonbabenko/terraform-skill)

```markdown
## 核心功能
- Terraform 和 OpenTofu 支持
- 测试模式
- 模块开发
- CI/CD 集成
- 生产模式
```

---

### 4.4 Trail of Bits Security Skills ⭐3109

**项目地址**: [trailofbits/skills](https://github.com/trailofbits/skills)

```markdown
## 核心功能
- 安全研究
- 漏洞检测
- 审计工作流
- 防御性安全评估
- 对抗性思维配置
```

---

### 4.5 jira-skill ⭐

**项目地址**: [netresearch/jira-skill](https://github.com/netresearch/jira-skill)

```markdown
## 核心功能
- Agent Skill for intelligent Jira integration
- MCP config support
- Wiki markup
- Claude Code compatible
```

---

### 4.6 developer-kit ⭐

**项目地址**: [giuseppe-trisciuoglio/developer-kit](https://github.com/giuseppe-trisciuoglio/developer-kit)

```markdown
## 核心功能
- Developer Kit for Claude Code
- 模块化插件系统
- Java/Spring Boot/LangChain4j
- TypeScript/NestJS/React
- Python
- PHP/WordPress
- AWS CloudFormation
- AI patterns
```

---

### 4.7 Fieldwork Skills ⭐12

**项目地址**: [buildoak/fieldwork-skills](https://github.com/buildoak/fieldwork-skills)

```markdown
## 核心功能
- 端到端测试
- Bug 修复
- 质量保证
```

---

## 📈 五、Skills 发展趋势

### 5.1 本周更新亮点

1. **Claude Code Game Studios** - 最完整的游戏开发多代理系统 (48 agents, 36 skills)
2. **Unity AI Workflow 2026** - AI 优先的 Unity 开发工作流
3. **beagle** - 代码审查和验证工作流 (34 stars)
4. **iOS Simulator Skill** - 生产级 iOS 测试自动化 (557 stars)

### 5.2 Skills 缺口分析

| 方向 | 现状 | 建议 |
|------|------|------|
| **游戏客户端测试** | 较少 | 需要更多 Unity/Unreal 专用测试 Skills |
| **游戏服务器测试** | 缺失 | 需要网络协议测试、负载测试 Skills |
| **Python 异步测试** | 较少 | 需要 asyncio/pytest 深度集成 |
| **移动端游戏测试** | iOS 较强 | Android 游戏测试 Skills 需加强 |

---

## 📚 六、参考资料

- [Claude Code 官方文档](https://docs.claude.com/en/docs/claude-code/skills)
- [Agent Skills 规范](https://agentskills.io)
- [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills)
- [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)
- [ClawHub Skills 市场](https://clawhub.com)
- [GitHub Claude Code Skills Topic](https://github.com/topics/claude-code-skill)

---

## 🔗 快速链接

- [游戏开发 Skills](./game-dev-skills/README.md)
- [Python 开发 Skills](./python-dev-skills/README.md)
- [自动化测试 Skills](./automation-testing-skills/README.md)
- [开发者工具 Skills](./developer-tools-skills/README.md)

---

*文档更新时间: 2026-03-04*
