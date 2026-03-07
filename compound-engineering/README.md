# Compound Engineering Plugin - 复合工程插件

> AI 驱动的开发工具，让每次工程工作都比上一次更容易

## 📋 文档信息

- **Skill 名称**: compound-engineering
- **GitHub**: [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin)
- **Star**: 9,782 ⭐ (Claude Code 热门插件排行榜 Top 1)
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 工程工作流 / 多平台兼容

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **技术债务累积** | 传统开发每加一个功能复杂度就增加 | 代码库越来越难维护 |
| **知识流失** | 解决问题的经验没有被记录 | 类似问题重复踩坑 |
| **开发周期长** | 前期规划和后期审查占比低 | 代码质量差、返工多 |
| **单人作战** | 缺乏系统性代码审查 | 遗漏关键问题 |
| **多工具割裂** | Claude Code 配置无法同步到其他 AI 工具 | 重复配置工作 |

### 目标

**核心理念：让每个工程单元都比前一个更容易**

- 80% 时间用于规划和审查，20% 用于执行
- 通过系统化的规划、审查、知识固化来实现"复合增长"
- 支持跨 AI 编程工具的配置同步

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│              Compound Engineering 工作流                     │
└─────────────────────────────────────────────────────────────┘

     ┌──────────┐
     │   Plan   │ ──▶ 将功能想法转化为详细实施计划
     └────┬─────┘
          ▼
     ┌──────────┐
     │   Work   │ ──▶ 使用 git worktrees 和任务跟踪执行计划
     └────┬─────┘
          ▼
     ┌──────────┐
     │  Review  │ ──▶ 多代理代码审查，合并前全面检查
     └────┬─────┘
          ▼
     ┌──────────┐
     │ Compound │ ──▶ 记录学习成果，让未来工作更容易
     └────┬─────┘
          │
          └─▶ 循环迭代：计划→执行→审查→复合
```

### 组件统计

| 组件类型 | 数量 | 说明 |
|---------|------|------|
| **Agents** | 29 | 专业化 AI 代理 |
| **Commands** | 22 | 斜杠命令 |
| **Skills** | 20 | 技能模块 |
| **MCP Servers** | 1 | Context7 框架文档查询 |

### Agents 分类详解

#### 🔍 Review (15) - 代码审查代理

| Agent | 功能描述 |
|-------|---------|
| `agent-native-reviewer` | 验证功能是否遵循 Agent 原生架构 |
| `architecture-strategist` | 分析架构决策和合规性 |
| `code-simplicity-reviewer` | 最终通过，确保代码简洁极简 |
| `data-integrity-guardian` | 数据库迁移和数据完整性 |
| `data-migration-expert` | 验证 ID 映射和值交换 |
| `deployment-verification-agent` | 创建风险数据变更的 Go/No-Go 清单 |
| `dhh-rails-reviewer` | DHH 视角的 Rails 代码审查 |
| `julik-frontend-races-reviewer` | 审查 JS/Stimulus 代码的竞态条件 |
| `kieran-rails-reviewer` | Rails 代码审查，严格规范 |
| `kieran-python-reviewer` | Python 代码审查，严格规范 |
| `kieran-typescript-reviewer` | TypeScript 代码审查，严格规范 |
| `pattern-recognition-specialist` | 分析代码模式和反模式 |
| `performance-oracle` | 性能分析和优化 |
| `schema-drift-detector` | 检测 PR 中无关的 schema.rb 变更 |
| `security-sentinel` | 安全审计和漏洞评估 |

#### 📚 Research (5) - 研究代理

| Agent | 功能描述 |
|-------|---------|
| `best-practices-researcher` | 收集外部最佳实践和示例 |
| `framework-docs-researcher` | 研究框架文档和最佳实践 |
| `git-history-analyzer` | 分析 git 历史和代码演进 |
| `learnings-researcher` | 搜索知识库中的相关解决方案 |
| `repo-research-analyst` | 研究代码库结构和约定 |

#### 🎨 Design (3) - 设计代理

| Agent | 功能描述 |
|-------|---------|
| `design-implementation-reviewer` | 验证 UI 实现是否符合 Figma 设计 |
| `design-iterator` | 通过系统性设计迭代优化 UI |
| `figma-design-sync` | 将 Web 实现与 Figma 设计同步 |

#### ⚙️ Workflow (5) - 工作流代理

| Agent | 功能描述 |
|-------|---------|
| `bug-reproduction-validator` | 系统性复现和验证 bug 报告 |
| `every-style-editor` | 编辑内容符合 Every 风格指南 |
| `lint` | 运行 Ruby 和 ERB 文件的 lint 检查 |
| `pr-comment-resolver` | 处理 PR 评论并实施修复 |
| `spec-flow-analyzer` | 分析用户流程和需求规格差距 |

#### 📖 Docs (1) - 文档代理

| Agent | 功能描述 |
|-------|---------|
| `ankane-readme-writer` | 创建符合 Ankane 风格的 Ruby gem README |

### Commands 详解

#### 核心工作流命令 (ce: 前缀)

| Command | 功能 |
|---------|------|
| `/ce:brainstorm` | 规划前探索需求和方法 |
| `/ce:plan` | 创建实施计划 |
| `/ce:work` | 系统性执行工作项 |
| `/ce:review` | 运行全面代码审查 |
| `/ce:compound` | 记录已解决问题以积累团队知识 |

#### 实用命令

| Command | 功能 |
|---------|------|
| `/lfg` | 完整自主工程工作流 |
| `/slfg` | 完整自主工作流，支持 swarm 模式并行执行 |
| `/deepen-plan` | 并行研究代理增强计划 |
| `/changelog` | 为最近合并创建有趣的更新日志 |
| `/create-agent-skill` | 创建或编辑 Claude Code skills |
| `/generate_command` | 生成新的斜杠命令 |
| `/heal-skill` | 修复 skill 文档问题 |
| `/sync` | 跨机器同步 Claude Code 配置 |
| `/report-bug` | 报告插件中的 bug |
| `/reproduce-bug` | 使用日志和控制台复现 bug |
| `/resolve_parallel` | 并行解决 TODO 评论 |
| `/resolve_pr_parallel` | 并行解决 PR 评论 |
| `/triage` | 分类和优先级问题 |
| `/test-browser` | 在 PR 影响的页面上运行浏览器测试 |
| `/xcode-test` | 在模拟器上构建和测试 iOS 应用 |
| `/feature-video` | 录制视频演示并添加到 PR 描述 |

### Skills 分类

#### 架构与设计

| Skill | 功能 |
|-------|------|
| `agent-native-architecture` | 使用原生提示词架构构建 AI 代理 |

#### 开发工具

| Skill | 功能 |
|-------|------|
| `andrew-kane-gem-writer` | 按 Andrew Kane 模式编写 Ruby gem |
| `compound-docs` | 捕获已解决问题作为分类文档 |
| `create-agent-skills` | 创建 Claude Code skills 的专家指导 |
| `dhh-rails-style` | 以 DHH/37signals 风格编写 Ruby/Rails |
| `dspy-ruby` | 使用 DSPy.rb 构建类型安全的 LLM 应用 |
| `frontend-design` | 创建生产级前端界面 |
| `skill-creator` | 创建有效 Claude Code skills 的指南 |

#### 内容与工作流

| Skill | 功能 |
|-------|------|
| `brainstorming` | 通过协作对话探索需求和方法 |
| `document-review` | 通过系统性自审改进文档 |
| `every-style-editor` | 审查内容符合 Every 风格指南 |
| `file-todos` | 基于文件的待办事项跟踪系统 |
| `git-worktree` | 管理 Git worktrees 进行并行开发 |
| `proof` | 通过 Proof 协作编辑器创建、编辑和共享文档 |
| `resolve-pr-parallel` | 并行解决 PR 审查评论 |

#### 多代理编排

| Skill | 功能 |
|-------|------|
| `orchestrating-swarms` | 多代理 swarm 编排综合指南 |

#### 文件传输

| Skill | 功能 |
|-------|------|
| `rclone` | 上传文件到 S3、Cloudflare R2、Backblaze B2 |

#### 浏览器自动化

| Skill | 功能 |
|-------|------|
| `agent-browser` | 使用 Vercel 的 agent-browser 进行 CLI 浏览器自动化 |

#### 图像生成

| Skill | 功能 |
|-------|------|
| `gemini-imagegen` | 使用 Google Gemini API 生成和编辑图像 |

### MCP Servers

| Server | 功能 |
|--------|------|
| `context7` | 通过 Context7 查询框架文档，支持 100+ 框架 |

---

## 3. 本地部署

### Claude Code 安装

```bash
# 添加插件市场
/plugin marketplace add EveryInc/compound-engineering-plugin

# 安装插件
/plugin install compound-engineering
```

### Cursor 安装

```bash
/add-plugin compound-engineering
```

### 其他 AI 编程工具

该仓库包含一个 Bun/TypeScript CLI，可以将 Claude Code 插件转换为其他 AI 编码工具的格式：

```bash
# 转换为 OpenCode 格式
bunx @every-env/compound-plugin install compound-engineering --to opencode

# 转换为 Codex 格式
bunx @every-env/compound-plugin install compound-engineering --to codex

# 转换为 Windsurf 格式
bunx @every-env/compound-plugin install compound-engineering --to windsurf

# 转换为 OpenClaw 格式
bunx @every-env/compound-plugin install compound-engineering --to openclaw

# 自动检测并安装到所有支持的工具
bunx @every-env/compound-plugin install compound-engineering --to all
```

### 配置同步

将个人 Claude Code 配置同步到其他 AI 编程工具：

```bash
# 同步到所有检测到的工具
bunx @every-env/compound-plugin sync

# 同步到特定工具
bunx @every-env/compound-plugin sync --target opencode
bunx @every-env/compound-plugin sync --target codex
bunx @every-env/compound-plugin sync --target windsurf
```

---

## 4. 核心工作流演示

### /ce:plan 工作流

```
1. 想法精炼
   └─▶ 检查 docs/brainstorms/ 中的相关头脑风暴
   
2. 本地研究 (并行)
   ├─▶ repo-research-analyst - 研究代码库模式
   └─▶ learnings-researcher - 搜索知识库解决方案
   
3. 研究决策
   ├─▶ 高风险主题 (安全、支付、外部 API) → 外部研究
   ├─▶ 强本地上下文 → 跳过外部研究
   └─▶ 不确定性 → 外部研究
   
4. 外部研究 (条件触发)
   ├─▶ best-practices-researcher
   └─▶ framework-docs-researcher
   
5. 问题规划
   └─▶ 生成结构化计划文档
```

### /ce:review 工作流

```
1. 分析变更范围
   └─▶ 识别 PR/提交影响的文件和模块
   
2. 选择审查代理 (基于变更类型)
   ├─▶ Rails 变更 → kieran-rails-reviewer
   ├─▶ Python 变更 → kieran-python-reviewer
   ├─▶ TypeScript 变更 → kieran-typescript-reviewer
   ├─▶ 安全相关 → security-sentinel
   └─▶ 性能相关 → performance-oracle
   
3. 并行审查
   └─▶ 多个代理同时审查不同方面
   
4. 综合报告
   └─▶ 汇总所有审查发现
```

---

## 5. 优缺点分析

### ✅ 优点

1. **完整的工程工作流**
   - 覆盖 Plan → Work → Review → Compound 完整周期
   - 强调 80% 时间用于规划和审查的理念

2. **丰富的专业化代理**
   - 29 个专业化代理覆盖审查、研究、设计、工作流
   - 针对不同语言和框架有专门的审查代理

3. **多平台支持**
   - 支持 Claude Code、Cursor、OpenCode、Codex、Windsurf、OpenClaw 等
   - 提供配置同步工具

4. **知识积累机制**
   - `/ce:compound` 命令帮助记录学习成果
   - `compound-docs` skill 用于构建知识库

5. **高质量代码审查**
   - 多代理并行审查机制
   - 专业化审查代理 (安全、性能、架构等)

### ⚠️ 缺点

1. **学习曲线陡峭**
   - 组件数量多，需要时间熟悉
   - 需要理解复合工程理念才能有效使用

2. **配置复杂**
   - 插件结构复杂，更新需要遵循严格流程
   - 组件计数需要同步更新多个文件

3. **某些功能依赖外部工具**
   - 浏览器自动化需要安装 `agent-browser`
   - 图像生成需要 `GEMINI_API_KEY`

4. **可能过度工程化**
   - 对于小型项目可能过于笨重
   - 并非所有项目都需要如此全面的审查流程

---

## 6. 平替对比

| 插件/框架 | Stars | 特点 | 适合场景 |
|----------|-------|------|---------|
| **Compound Engineering** | 9,782 | 完整工作流 + 29 代理 + 多平台 | 大型项目、团队协作 |
| **Superpowers** | 68k | 简洁的 SDLC 覆盖 | 追求简洁的开发者 |
| **Fullstack Dev Skills** | - | 65 专业技能 + Jira 集成 | 全栈开发 |
| **Everything Claude Code** | - | 广泛资源集合 | 追求全面覆盖 |
| **AgentSys** | - | 模块化编排系统 | 任务自动化 |

---

## 7. 落地实践

### 推荐的渐进式采用路径

1. **第一阶段：基础命令**
   - 开始使用 `/ce:plan` 和 `/ce:review`
   - 熟悉核心工作流

2. **第二阶段：审查代理**
   - 根据项目技术栈选择合适的审查代理
   - 集成到 PR 流程

3. **第三阶段：知识积累**
   - 使用 `/ce:compound` 记录解决方案
   - 建立团队知识库

4. **第四阶段：完整工作流**
   - 采用完整的 Plan → Work → Review → Compound 周期
   - 配置跨工具同步

### 最佳实践

- 复杂功能先使用 `/ce:brainstorm` 探索
- 每个 PR 都使用 `/ce:review` 进行代码审查
- 解决问题后使用 `/ce:compound` 记录经验
- 定期使用 `/sync` 同步配置到所有工具

---

## 8. 相关资源

- [官方文档](https://github.com/EveryInc/compound-engineering-plugin)
- [Compound Engineering 博客文章](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- [Claude Code 插件文档](https://docs.claude.com/en/docs/claude-code/plugins)
- [Plugin Marketplace 文档](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)

---

*让每次工程工作都比上一次更容易*
