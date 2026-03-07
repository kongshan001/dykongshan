# AgentSys - 模块化 AI Agent 编排系统

> 14 个插件 · 43 个 agents · 30 个 skills · 30k 行代码 · 3,750 测试

## 📋 文档信息

- **Skill 名称**: AgentSys
- **GitHub**: [agent-sh/agentsys](https://github.com/agent-sh/agentsys)
- **Star**: ⭐ 热门项目
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 工作流编排 / DevOps 自动化 / 代码质量

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **上下文丢失** | 长会话中 AI"健忘"，需要反复解释 | 效率下降 |
| **压缩失忆** | 上下文被压缩后丢失关键状态 | 工作需要重做 |
| **任务漂移** | 没有结构化，agent 会偏离目标 | 产出与需求不符 |
| **跳过步骤** | Agent 不执行 review、tests 或清理 | 质量问题 |
| **Token 浪费** | 用 LLM 做静态分析能做的事 | 成本增加 |
| **重复请求** | 每次会话都要重复相同的工作流 | 效率低下 |
| **人工干预过多** | 手动orchestrating每个阶段 | 无法规模化 |

### 目标

构建一个**模块化的运行时和编排系统**，让 AI Agent 能够：

1. **完整生命周期管理** - 从任务发现到生产部署
2. **结构化管道** - 带门控的阶段化执行
3. **专业化分工** - 每个 agent 只做一件事
4. **持久化状态** - 跨会话恢复
5. **Token 优化** - 静态分析优先，LLM 只做需要判断的事

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                        AgentSys 架构                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐           │
│   │  Plugins   │     │   Agents    │     │   Skills    │           │
│   │   (14)     │────▶│    (43)     │────▶│    (30)     │           │
│   └─────────────┘     └─────────────┘     └─────────────┘           │
│                                                                     │
│   独立仓库分布在 agent-sh 组织下，agentsys 是市场 + 安装器            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 核心命令

| 命令 | 功能 | 描述 |
|-----|------|------|
| `/next-task` | 任务到生产工作流 | 完整流程：任务发现→实现→审查→交付 |
| `/ship` | 提交到合并 | 代码提交→PR→CI→审查→合并 |
| `/agnix` | 配置 linting | 155 条规则验证 agent 配置 |
| `/deslop` | 清理 AI 垃圾 | 检测并删除调试语句、占位符等 |
| `/perf` | 性能调查 | 10 阶段结构化性能分析 |
| `/drift-detect` | 文档代码偏离检测 | 比较文档与实际代码 |
| `/audit-project` | 多 agent 代码审查 | 最多 10 个专业化审查 agent |
| `/enhance` | 提示增强 | 分析并改进 prompts 和配置 |
| `/repo-map` | 代码库映射 | AST 符号和导入图 |
| `/sync-docs` | 文档同步 | 检测并修复文档与代码的不一致 |
| `/learn` | 主题研究 | 在线研究并创建学习指南 |
| `/consult` | 咨询其他 AI | 获取其他 CLI 工具的意见 |
| `/debate` | AI 辩论 | 多工具结构化辩论 |
| `web-ctl` | 浏览器自动化 | 无头浏览器控制 |

### 设计哲学

1. **单一职责** - 一个 agent 只做一件事
2. **管道门控** - 每个阶段通过才能进入下一阶段
3. **工具 vs Agent** - 静态分析用工具，LLM 只做需要判断的事
4. **模型匹配** - Opus 用于规划/实现，Sonnet 用于验证，Haiku 用于简单操作

---

## 3. 核心命令详解

### /next-task - 完整任务到生产工作流

```
Phase 1: 任务发现 → Phase 2: 工作树设置 → Phase 3: 探索
    → Phase 4: 规划 → Phase 5: 实施 → Phase 6: 预审
    → Phase 7: 审查循环 → Phase 8: 交付验证 → Phase 9: 文档更新 → Phase 10: Ship
```

关键 agents:
- `task-discoverer` (sonnet) - 查找和排序任务
- `exploration-agent` (opus) - 深度代码库分析
- `planning-agent` (opus) - 设计实现计划
- `implementation-agent` (opus) - 编写代码
- `ci-fixer` (sonnet) - 修复 CI 失败

### /ship - 自动提交到合并

完整的 CI/CD 流程：
1. 检测 CI 平台 (GitHub Actions, GitLab CI, CircleCI, Jenkins, Travis)
2. 检测部署平台 (Railway, Vercel, Netlify, Fly.io, Render)
3. 提交 → 推送 → PR → 等待 CI → 处理评论 → 合并 → 部署

### /deslop - AI 代码清理

三阶段检测：
1. **Regex 模式** (高确信度) - console.log, TODO, 空 catch 块
2. **多通道分析器** (中确信度) - 文档代码比、冗长注释
3. **CLI 工具** (低确信度，可选) - jscpd, pylint, clippy

### /audit-project - 多 agent 代码审查

最多 10 个专业化 agent:
- `code-quality-reviewer` - 代码质量
- `security-expert` - 安全漏洞
- `performance-engineer` - 性能问题
- `test-quality-guardian` - 测试覆盖
- `architecture-reviewer` (50+ 文件时) - 架构审查
- `database-specialist` (检测到 DB 时) - 数据库审查
- 等等...

### /drift-detect - 文档代码偏离

**Token 减少 77%** vs 多 agent 方案：
- JavaScript 收集器收集数据 (快速、token 高效)
- 单次 Opus 调用进行语义分析
- 匹配概念而非字符串

---

## 4. 本地部署

### 方式一：npm 全局安装

```bash
npm install -g agentsys
agentsys
```

### 方式二：Claude Code 插件安装

```bash
/plugin marketplace add agent-sh/agentsys
/plugin install next-task@agentsys
/plugin install ship@agentsys
```

### 方式三：交互式安装

```bash
agentsys --tool claude        # Claude Code
agentsys --tool opencode      # OpenCode
agentsys --tool cursor        # Cursor
agentsys --tool kiro          # Kiro
agentsys --tools "claude,opencode"  # 多个工具
```

### 依赖要求

**必需**:
- Git
- Node.js 18+

**可选**（取决于功能）:
- GitHub CLI (`gh`) - GitHub 工作流
- GitLab CLI (`glab`) - GitLab 工作流
- ast-grep (`sg`) - `/repo-map` 功能
- agnix CLI - `/agnix` 功能

### 验证安装

```bash
npm run detect   # 平台检测
npm run verify   # 工具可用性检查
```

---

## 5. 效果展示

### 完整工作流示例

```bash
# 开始新任务
/next-task

# 输出示例：
# Phase 1: 任务发现
# - 发现 5 个高优先级任务
# - 请选择要处理的任务

# 选择后自动执行：
# - 创建 git worktree 和分支
# - 深度代码库分析
# - 设计实现计划
# - 人工审批计划
# - 执行实现
# - 多 agent 审查循环
# - 交付验证
# - 更新文档
# - 创建 PR 并合并
```

### 单一命令使用

```bash
# 单独清理代码
/deslop apply src/ 10

# 单独检查文档一致性
/sync-docs report src/

# 单独审查代码库
/audit-project --quick

# 单独发送 PR
/ship --dry-run
```

---

## 6. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **完整性** | 覆盖任务发现→生产部署完整流程 |
| **模块化** | 每个命令可独立使用 |
| **Token 高效** | 静态分析优先，77% token 减少 |
| **多平台支持** | Claude Code, OpenCode, Codex, Cursor, Kiro |
| **确定性检测** | Regex/AST 分析，不需要 LLM 判断 |
| **持久化状态** | 跨会话恢复，无需从头开始 |
| **专业分工** | 43 个 agents 各自专注特定任务 |
| **测试完备** | 3,750 个测试通过 |

### ⚠️ 缺点

| 缺点 | 说明 |
|-----|------|
| **学习曲线** | 14 个插件、43 个 agents，功能复杂 |
| **配置要求** | 需要 Git、Node.js、认证工具等 |
| **平台限制** | 部分功能依赖 GitHub/GitLab CLI |
| **资源消耗** | 多 agent 并行运行，资源占用较高 |
| **初始设置** | 需要时间配置和理解系统 |

---

## 7. 平替对比

| 项目 | 特点 | 适用场景 |
|-----|------|---------|
| **Superpowers** | 轻量级工程最佳实践 | 个人开发者快速上手 |
| **Fullstack Dev Skills** | 65 个 skills，覆盖全栈 | 大型项目开发 |
| **cc-devops-skills** | DevOps IaC 工具 | 基础设施工程师 |
| **Trail of Bits** | 安全审查 | 安全敏感项目 |
| **AgentSys** | 完整生命周期编排 | 企业级自动化 |

---

## 8. 落地过程

### 实践记录

**日期**: 2026-03-03

**测试场景**: 在一个现有项目中运行 `/next-task`

**步骤**:
1. 安装: `npm install -g agentsys`
2. 初始化: `agentsys --tool claude`
3. 运行: `/next-task`

**结果**:
- 成功发现并分析任务
- 自动创建 worktree 和分支
- 多阶段审查循环
- 自动创建 PR

### 注意事项

1. **建议先单独测试各命令** - `/deslop`, `/sync-docs` 等可以独立使用
2. **认证配置** - GitHub/GitLab CLI 需要提前认证
3. **模型选择** - 部分功能需要 Opus 模型配额

---

## 9. 总结

AgentSys 是一个**功能完备的企业级 AI Agent 编排系统**，通过模块化设计和专业化分工，实现了从任务发现到生产部署的完整自动化。

**适合场景**:
- 需要完整软件开发流程自动化的团队
- 希望减少人工干预的 DevOps 工作流
- 大型代码库的多 agent 审查需求
- 需要跨会话持久化状态的项目

**不适合场景**:
- 个人开发者的简单任务
- 资源受限的环境
- 快速原型开发

---

*让 AI 编程助手真正实现端到端自动化*
