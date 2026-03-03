# Fullstack Dev Skills (Claude Skills)

> **66+ Skills** | **9 Workflows** | **Full-Stack Development Framework**

## 项目概述

**Fullstack Dev Skills** (jeffallan/claude-skills) 是一个全面的 Claude Code 技能集合，专为全栈开发者设计。该项目提供了 66 个专业技能，覆盖 12 个类别，包括语言、框架、后端/前端基础设施、API、测试、DevOps、安全、数据/ML 和平台专家。

这个项目不仅仅是一组技能的集合，还提供了完整的工作流命令系统，支持从需求发现到回顾的全流程项目管理，并且与 Jira 和 Confluence 有深度集成。

### 核心特性

- **66 个专业技能** - 覆盖几乎所有主流技术栈
- **上下文感知激活** - 根据请求自动激活相关技能
- **多技能工作流** - 复杂任务自动组合多个技能
- **9 个项目工作流** - 从发现到回顾的完整流程
- **Jira/Confluence 集成** - 与 Atlassian 生态深度集成
- **Common Ground 机制** - 验证 Claude 对项目的假设

---

## 统计数据

| 指标 | 数值 |
|------|------|
| Stars | 9k+ |
| Skills | 66 |
| Workflow Commands | 9 |
| Categories | 12 |
| Version | 0.4.9 |

---

## 目录结构

```
claude-skills/
├── skills/                     # 66 个专业技能
│   ├── angular-architect/       # Angular 架构
│   ├── api-designer/           # API 设计
│   ├── architecture-designer/  # 架构设计
│   ├── cloud-architect/       # 云架构
│   ├── debugging-wizard/       # 调试专家
│   ├── devops-engineer/       # DevOps 工程师
│   ├── django-expert/         # Django 专家
│   ├── fastapi-expert/        # FastAPI 专家
│   ├── feature-forge/          # 功能开发
│   ├── fullstack-guardian/     # 全栈守护者
│   ├── javascript-pro/        # JavaScript 专家
│   ├── nestjs-expert/         # NestJS 专家
│   ├── nextjs-developer/      # Next.js 开发者
│   ├── postgres-pro/          # PostgreSQL 专家
│   ├── python-pro/            # Python 专家
│   ├── react-expert/          # React 专家
│   ├── secure-code-guardian/  # 安全代码守护
│   ├── test-master/           # 测试大师
│   ├── typescript-pro/        # TypeScript 专家
│   ├── vue-expert/            # Vue 专家
│   └── ...                    # 40+ 更多技能
│
├── commands/                   # 9 个工作流命令
│   ├── workflow-start.md      # 项目启动
│   ├── workflow-plan.md       # 计划制定
│   ├── workflow-build.md      # 构建执行
│   ├── workflow-review.md     # 代码审查
│   ├── workflow-test.md       # 测试管理
│   ├── workflow-deploy.md     # 部署执行
│   ├── workflow-monitor.md    # 监控运维
│   ├── workflow-incident.md   # 事故处理
│   └── workflow-retro.md      # 回顾改进
│
├── docs/                       # 文档
│   ├── COMMON_GROUND.md        # 上下文验证
│   ├── WORKFLOW_COMMANDS.md   # 工作流命令参考
│   └── ATLASSIAN_MCP_SETUP.md # Atlassian MCP 设置
│
├── .claude/                    # Claude Code 配置
│   └── commands/              # 斜杠命令定义
│
├── SKILLS_GUIDE.md            # 技能指南
├── QUICKSTART.md              # 快速开始
└── CLAUDE.md                  # 项目元信息
```

---

## 安装指南

### 方式一：插件市场安装（推荐）

```bash
# 添加插件市场
/plugin marketplace add jeffallan/claude-skills

# 安装完整技能包
/plugin install fullstack-dev-skills@jeffallan
```

### 方式二：手动安装

```bash
# 克隆仓库
git clone https://github.com/jeffallan/claude-skills.git
cd claude-skills

# 复制 skills 到 Claude Code
cp -r skills/* ~/.claude/skills/

# 或使用 Makefile
make install
```

### 方式三：选择性安装

```bash
# 只安装特定技能
cp -r skills/react-expert ~/.claude/skills/
cp -r skills/typescript-pro ~/.claude/skills/
```

---

## 技能分类详解

### 1. 前端框架

| 技能 | 描述 |
|------|------|
| react-expert | React 专家，支持 Server Components、Hooks、状态管理 |
| nextjs-developer | Next.js 开发者，全栈 React 框架 |
| vue-expert | Vue 3 专家，Composition API |
| vue-expert-js | Vue JavaScript 变体 |
| angular-architect | Angular 架构师 |
| svelte-developer | Svelte 开发者 |
| react-native-expert | React Native 专家 |

### 2. 后端框架

| 技能 | 描述 |
|------|------|
| django-expert | Django 全栈专家 |
| fastapi-expert | FastAPI 专家，现代 Python API 框架 |
| nestjs-expert | NestJS 专家，Node.js 企业级框架 |
| spring-boot-engineer | Spring Boot 工程师 |
| rails-expert | Ruby on Rails 专家 |
| laravel-specialist | Laravel PHP 专家 |
| express-pro | Express.js 专家 |

### 3. 编程语言

| 技能 | 描述 |
|------|------|
| python-pro | Python 专家，数据科学/Web/脚本 |
| typescript-pro | TypeScript 专家 |
| javascript-pro | JavaScript 专家 |
| golang-pro | Go 专家，高性能服务 |
| rust-engineer | Rust 工程师，系统编程 |
| java-architect | Java 架构师 |
| kotlin-specialist | Kotlin 专家 |
| cpp-pro | C++ 专家 |
| csharp-developer | C# 开发者 |
| swift-expert | Swift 专家 |

### 4. 数据库

| 技能 | 描述 |
|------|------|
| postgres-pro | PostgreSQL 专家 |
| sql-pro | SQL 专家 |
| database-optimizer | 数据库优化专家 |
| mongodb-expert | MongoDB 专家 |

### 5. 云与基础设施

| 技能 | 描述 |
|------|------|
| cloud-architect | 云架构师 |
| aws-specialist | AWS 专家 |
| kubernetes-specialist | Kubernetes 专家 |
| terraform-engineer | Terraform 工程师 |
| devops-engineer | DevOps 工程师 |
| sre-engineer | SRE 工程师 |

### 6. 测试与质量

| 技能 | 描述 |
|------|------|
| test-master | 测试大师，全栈测试策略 |
| playwright-expert | Playwright E2E 测试专家 |
| security-reviewer | 安全审查员 |
| code-reviewer | 代码审查员 |
| debugging-wizard | 调试巫师 |

### 7. API 与集成

| 技能 | 描述 |
|------|------|
| api-designer | API 设计师 |
| graphql-architect | GraphQL 架构师 |
| rest-api-expert | REST API 专家 |
| websocket-engineer | WebSocket 工程师 |

### 8. 架构与设计

| 技能 | 描述 |
|------|------|
| architecture-designer | 架构设计师 |
| microservices-architect | 微服务架构师 |
| fullstack-guardian | 全栈守护者，确保代码质量 |
| spec-miner | 需求挖掘 |

### 9. 特殊领域

| 技能 | 描述 |
|------|------|
| ml-pipeline | 机器学习流水线 |
| pandas-pro | Pandas 数据分析 |
| spark-engineer | Spark 工程师 |
| rag-architect | RAG 架构师 |
| embedded-systems | 嵌入式系统 |
| game-developer | 游戏开发者 |
| flutter-expert | Flutter 专家 |

---

## 核心功能详解

### 1. 上下文感知激活

技能会根据用户的请求自动激活，加载相关的参考资料：

```bash
# 后端开发请求
"Implement JWT authentication in my NestJS API"
→ Activates: NestJS Expert
→ Loads: references/authentication.md

# 前端开发请求
"Build a React component with Server Components"
→ Activates: React Expert
→ Loads: references/server-components.md

# 数据库优化
"Optimize slow PostgreSQL queries"
→ Activates: Postgres Pro
→ Loads: references/performance-tuning.md
```

### 2. 多技能工作流

复杂任务会自动组合多个技能：

```
功能开发流程:
Feature Forge → Architecture Designer → Fullstack Guardian → Test Master → DevOps Engineer

调试流程:
Debugging Wizard → Framework Expert → Test Master → Code Reviewer

安全加固流程:
Secure Code Guardian → Security Reviewer → Test Master
```

### 3. Common Ground 机制

`/common-ground` 命令可以验证 Claude 对项目的假设：

```bash
# 触发上下文验证
/common-ground

# 输出示例:
# ✓ Assumes: React 18 with TypeScript
# ✓ Assumes: Next.js App Router
# ✗ Assumes: Redux (实际使用 Zustand)
# ✓ Assumes: PostgreSQL database
```

### 4. 项目工作流命令

9 个工作流命令覆盖完整项目生命周期：

| 命令 | 描述 |
|------|------|
| /workflow-start | 项目启动和需求发现 |
| /workflow-plan | 计划制定和任务拆分 |
| /workflow-build | 代码构建和实现 |
| /workflow-review | 代码审查和质量检查 |
| /workflow-test | 测试管理和执行 |
| /workflow-deploy | 部署执行 |
| /workflow-monitor | 监控和运维 |
| /workflow-incident | 事故响应 |
| /workflow-retro | 回顾和改进 |

---

## 使用示例

### 示例 1：实现新功能

```bash
# 1. 启动工作流
/workflow-start "Build user authentication system"

# 2. 制定计划
/workflow-plan "Implement JWT auth with refresh tokens"

# 3. 激活相关技能
# → NestJS Expert 自动激活
# → Postgres Pro 自动激活
# → Security Reviewer 自动激活

# 4. 开发完成后审查
/workflow-review

# 5. 测试
/workflow-test

# 6. 部署
/workflow-deploy
```

### 示例 2：调试问题

```bash
# 激活调试技能
/debugging-wizard

# "Fix memory leak in Node.js service"
# → 自动加载 Node.js 调试参考资料
# → 建议使用 clinic.js 等工具
# → 分析堆内存快照
```

### 示例 3：代码审查

```bash
# 激活审查技能
/code-review

# 或使用专门的审查工作流
/workflow-review
# → Fullstack Guardian 检查代码质量
# → Security Reviewer 检查安全
# → Test Master 验证测试覆盖
```

---

## 与 Jira/Confluence 集成

### 设置 Atlassian MCP

```bash
# 1. 安装 Atlassian MCP
npm install -g atlassian-mcp

# 2. 配置环境变量
export ATLASSIAN_API_KEY="your-api-key"
export ATLASSIAN_EMAIL="your-email"
export ATLASSIAN_DOMAIN="your-domain"

# 3. 在 Claude Code 中启用
# 添加到 ~/.claude/settings.json
```

### 工作流集成

```bash
# 创建 Jira Issue
/workflow-start "Add payment integration"

// 自动创建:
// - Epic: Payment Integration
// - Story: Stripe setup
// - Tasks: API, Webhook, Testing

# 更新进度
/workflow-deploy

// 自动更新:
// - 转移 Jira Issue 状态
// - 记录时间日志
// - 通知相关人员
```

---

## 优缺点分析

### ✅ 优点

1. **全面覆盖** - 66 个技能覆盖主流技术栈
2. **开箱即用** - 插件市场一键安装
3. **智能激活** - 上下文感知，减少手动选择
4. **工作流完整** - 9 个命令覆盖全流程
5. **活跃维护** - 持续更新，版本活跃
6. **社区支持** - 文档完善，有贡献指南

### ⚠️ 注意事项

1. **学习曲线** - 技能众多，需要熟悉激活机制
2. **Atlassian 依赖** - 完整工作流需要 MCP 服务器
3. **资源占用** - 完整安装占用较多空间
4. **规则冲突** - 与其他规则可能存在冲突

---

## 适用场景

- **全栈开发** - 前后端技术栈多样化
- **团队协作** - 需要统一开发流程
- **企业项目** - 需要 Jira/Confluence 集成
- **快速原型** - 需要快速搭建系统架构
- **代码质量** - 需要严格代码审查

---

## 与其他 Skills 对比

| Skill | 特点 | 适用场景 |
|-------|------|----------|
| superpowers | 68k⭐ 工程工作流 | 通用软件开发 |
| **fullstack-dev-skills** | 66 技能 + 9 工作流 | 全栈项目开发 |
| everything-claude-code | 56 技能 + Token 优化 | 性能优化场景 |
| trailofbits-security | 20+ 安全插件 | 安全审计 |
| deep-research | 深度研究 | 市场分析 |

---

## 总结

Fullstack Dev Skills 是一个功能极为全面的 Claude Code 技能集合，特别适合全栈开发者。它提供了从代码编写到项目管理的完整工具链，66 个专业技能几乎覆盖了所有主流技术栈。

其独特的上下文感知激活机制和多技能工作流设计，让复杂任务的处理变得自动化和标准化。对于需要与 Jira/Confluence 集成团队协作的开发团队来说，这是一个理想的选择。

虽然完整的 Atlassian 集成需要额外配置，但其核心技能可以独立使用，非常灵活。

---

## 参考链接

- [GitHub 仓库](https://github.com/jeffallan/claude-skills)
- [技能指南](https://jeffallan.github.io/claude-skills)
- [Quick Start](https://github.com/jeffallan/claude-skills/blob/main/QUICKSTART.md)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code) 推荐

---

*调研日期: 2026-03-03*
