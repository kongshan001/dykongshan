# Everything Claude Code

> **50K+ stars** | **Anthropic Hackathon Winner** | **Complete AI Agent Optimization System**

## 项目概述

**Everything Claude Code** 是一个面向 AI Agent 框架的性能优化系统，源自 Anthropic Hackathon 获奖作品。它不仅仅是一组配置文件，而是一个完整的系统，涵盖 skills、记忆优化、持续学习、安全扫描和研究优先的开发方法。

这个项目包含了生产级就绪的 agents、hooks、commands、rules 和 MCP 配置，经过 10+ 个月的密集日常使用构建真实产品而不断演进。

### 核心特性

- **Token 优化** - 模型选择、系统提示精简、后台进程管理
- **记忆持久化** - 自动保存/加载跨会话上下文的 hooks
- **持续学习** - 从会话中自动提取模式到可重用的 skills
- **验证循环** - Checkpoint vs 持续评估、grader 类型、pass@k 指标
- **并行化** - Git worktrees、级联方法、实例扩展
- **子代理编排** - 上下文问题、迭代检索模式

### 支持平台

- Claude Code
- Codex CLI
- Cursor
- OpenCode
- Kiro
- 以及其他 AI Agent 框架

---

## 统计数据

| 指标 | 数值 |
|------|------|
| Stars | 50K+ |
| Forks | 6K+ |
| Contributors | 30+ |
| Agents | 13 |
| Skills | 56 |
| Commands | 32 |
| 支持语言 | 6 |

---

## 目录结构

```
everything-claude-code/
├── agents/              # 专业子代理，用于委托任务
│   ├── planner.md           # 功能实现规划
│   ├── architect.md         # 系统设计决策
│   ├── tdd-guide.md         # 测试驱动开发
│   ├── code-reviewer.md    # 质量和安全审查
│   ├── security-reviewer.md # 漏洞分析
│   ├── e2e-runner.md        # Playwright E2E 测试
│   └── ...
│
├── skills/             # 工作流定义和领域知识
│   ├── coding-standards/    # 语言最佳实践
│   ├── backend-patterns/    # API、数据库、缓存模式
│   ├── frontend-patterns/   # React、Next.js 模式
│   ├── tdd-workflow/        # TDD 方法论
│   ├── security-review/     # 安全检查清单
│   ├── continuous-learning/  # 自动提取模式
│   ├── python-patterns/     # Python 惯用法
│   ├── golang-patterns/     # Go 惯用法
│   └── ...
│
├── commands/           # 斜杠命令
│   ├── tdd.md              # /tdd - 测试驱动开发
│   ├── plan.md             # /plan - 实现规划
│   ├── e2e.md              # /e2e E2E 测试生成
│   ├── code-review.md      # /code-review 质量审查
│   ├── build-fix.md        # /build-fix 修复构建错误
│   └── ...
│
├── rules/              # 始终遵循的指南
│   ├── common/             # 语言无关原则
│   ├── typescript/         # TypeScript 特定
│   ├── python/             # Python 特定
│   └── golang/             # Go 特定
│
├── hooks/              # 基于触发器的自动化
│   ├── memory-persistence/ # 会话生命周期 hooks
│   └── strategic-compact/  # 精简建议
│
└── scripts/            # 跨平台 Node.js 脚本
    ├── hooks/              # Hook 实现
    └── lib/                # 共享工具
```

---

## 安装指南

### 方式一：插件安装（推荐）

```bash
# 添加市场
/plugin marketplace add affaan-m/everything-claude-code

# 安装插件
/plugin install everything-claude-code@everything-claude-code
```

### 方式二：手动安装

```bash
# 克隆仓库
git clone https://github.com/affaan-m/everything-claude-code.git
cd everything-claude-code

# 安装规则（必需）
./install.sh typescript    # 或 python、golang
# 可以传递多个语言：
# ./install.sh typescript python golang
```

### 方式三：仅安装特定组件

```bash
# 复制 skills 到项目
cp -r skills/* ~/.claude/skills/

# 复制 rules 到全局配置
cp -r rules/* ~/.claude/rules/
```

---

## 核心功能详解

### 1. Agents（子代理）

项目包含 13 个专业化的子代理，每个代理都有单一职责和特定的模型分配：

| Agent | 模型 | 用途 |
|-------|------|------|
| planner | Opus | 功能实现规划 |
| architect | Opus | 系统设计决策 |
| tdd-guide | Sonnet | 测试驱动开发 |
| code-reviewer | Sonnet | 质量和安全审查 |
| security-reviewer | Sonnet | 漏洞分析 |
| e2e-runner | Sonnet | Playwright E2E 测试 |
| refactor-cleaner | Haiku | 死代码清理 |
| doc-updater | Haiku | 文档同步 |
| go-reviewer | Sonnet | Go 代码审查 |
| python-reviewer | Sonnet | Python 代码审查 |
| database-reviewer | Sonnet | 数据库/Supabase 审查 |

### 2. Skills（技能）

项目提供 56+ 个专业技能，覆盖多个领域：

#### 开发技能
- `tdd-workflow` - TDD 方法论
- `python-patterns` - Python 惯用法和最佳实践
- `golang-patterns` - Go 惯用法和最佳实践
- `django-patterns` / `django-tdd` / `django-security` - Django 全栈
- `springboot-patterns` / `springboot-tdd` / `springboot-security` - Spring Boot
- `frontend-patterns` - React、Next.js 模式

#### 质量保证
- `security-review` - 安全检查清单
- `e2e-testing` - Playwright E2E 模式和 Page Object Model
- `verification-loop` - 持续验证
- `eval-harness` - 验证循环评估

#### 生产力工具
- `continuous-learning` - 自动从会话提取模式
- `iterative-retrieval` - 子代理渐进式上下文优化
- `content-hash-cache-pattern` - SHA-256 内容哈希缓存
- `cost-aware-llm-pipeline` - LLM 成本优化

#### 商业内容
- `article-writing` - 长篇写作
- `content-engine` - 多平台社交内容
- `market-research` - 市场研究
- `investor-materials` - 投资者材料

### 3. Commands（命令）

32 个斜杠命令用于快速执行：

```bash
# 规划和开发
/plan "Add user authentication"
/tdd "Implement user login"
/e2e "Test user flow"

/# 代码质量
/code-review
/refactor-clean
/go-review
/python-review

# 验证和测试
/verify
/test-coverage
/eval

# 学习和记忆
/learn
/learn-eval
/instinct-status

# 多代理编排
/multi-plan
/multi-execute
/orchestrate
/pm2

# 会话管理
/sessions
/checkpoint
```

### 4. Rules（规则）

项目包含 80+ 个规则文件，分为：

- **common/** - 语言无关原则
  - coding-style.md - 不可变性、文件组织
  - git-workflow.md - 提交格式、PR 流程
  - testing.md - TDD、80% 覆盖率要求
  - performance.md - 模型选择、上下文管理
  - security.md - 强制性安全检查

- **语言特定规则**
  - typescript/ - TypeScript/JavaScript
  - python/ - Python
  - golang/ - Go

### 5. Hooks（钩子）

基于触发器的自动化：

```json
{
  "hooks": {
    "session_start": "加载上次会话上下文",
    "session_end": "保存当前状态",
    "pre_compact": "精简前状态保存",
    "suggest_compact": "智能精简建议"
  }
}
```

---

## 核心概念

### 1. Token 优化

项目提供多种 Token 优化策略：

- **模型选择** - 根据任务复杂度选择合适模型
- **系统提示精简** - 只包含必要的上下文
- **后台进程** - 分离耗时任务

### 2. 记忆持久化

通过 Hooks 实现跨会话的记忆保持：

```javascript
// session_start hook - 加载上下文
// session_end hook - 保存状态
// 自动恢复上次工作进度
```

### 3. 持续学习

从会话中自动提取可重用的模式：

```bash
/learn "Extract the testing pattern used"
/evolve "Create skill from instincts"
```

### 4. 验证循环

实现 Checkpoint 机制：

```bash
/checkpoint "Save verification state"
/verify "Run verification loop"
```

---

## 使用示例

### 示例 1：实现新功能

```bash
# 1. 规划功能
/plan "Add user authentication system"

# 2. TDD 开发
/tdd "Implement JWT authentication"

# 3. 代码审查
/code-review

# 4. E2E 测试
/e2e "Test login flow"
```

### 示例 2：安全审查

```bash
# 运行安全扫描
/security-scan

# 或使用专门的审查 agent
/use security-reviewer
```

### 示例 3：持续学习

```bash
# 从当前会话学习模式
/learn

# 评估并保存为 instinct
/learn-eval

# 将 instincts 演进为 skills
/evolve
```

---

## 版本历史

### v1.7.0 (Feb 2026)
- Codex CLI 支持
- frontend-slides 技能
- 5 个新的商业内容技能
- 992 个内部测试

### v1.6.0 (Feb 2026)
- AgentShield 集成
- GitHub Marketplace
- 7 个新技能

### v1.4.0 (Feb 2026)
- 交互式安装向导
- PM2 和多代理编排
- 多语言规则架构

### v1.3.0 (Feb 2026)
- OpenCode 插件支持
- Python/Django 支持
- Java Spring Boot 支持

---

## 优缺点分析

### ✅ 优点

1. **全面性** - 涵盖开发、测试、安全、部署全流程
2. **生产就绪** - 经过 10+ 个月实际使用验证
3. **多平台支持** - Claude Code、Codex、Cursor 等
4. **活跃维护** - 持续更新，功能丰富
5. **社区活跃** - 30+ 贡献者，6 种语言支持

### ⚠️ 注意事项

1. **学习曲线** - 组件较多，需要时间熟悉
2. **规则冲突** - 与现有规则可能存在冲突
3. **安装复杂** - 需要手动安装规则文件
4. **资源消耗** - 完整安装包含大量文件

---

## 适用场景

- **团队开发** - 统一代码规范和开发流程
- **个人效率** - 自动化重复性任务
- **安全敏感** - 需要安全审查的项目
- **大型项目** - 需要多代理协作的复杂系统

---

## 总结

Everything Claude Code 是一个功能极为全面的 Claude Code 优化系统，提供了从代码编写到安全审查、从测试到部署的完整工具链。对于希望最大化 Claude Code 效率的开发者来说，这是一个不可或缺的工具集。

虽然安装和配置相对复杂，但一旦熟悉其工作方式，它能显著提升开发效率和代码质量。

---

## 参考链接

- [GitHub 仓库](https://github.com/affaan-m/everything-claude-code)
- [官方指南](https://x.com/affaanmustafa/status/2012378465664745795)
- [详细文档](https://x.com/affaanmustafa/status/2014040193557471352)
- [ECC Tools Marketplace](https://github.com/marketplace/ecc-tools)

---

*调研日期: 2026-03-03*
