# superpowers - Agentic Skills 完整工程工作流框架

> 让 AI 编程助手遵循完整软件工程最佳实践

## 📋 文档信息

- **Skill 名称**: superpowers
- **GitHub**: [obra/superpowers](https://github.com/obra/superpowers)
- **Star**: 68k ⭐
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 工程工作流 / Claude Code 扩展

---

## 1. Skill 背景需求

### 问题痛点

当前的 AI 编程助手虽然功能强大，但存在以下常见问题：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **急于写代码** | 不理解需求就上手 | 导致大量返工 |
| **缺乏设计** | 没有规划文档直接开干 | 架构不合理 |
| **测试缺失** | 写完代码再补测试 | 效率低下 |
| **单线程工作** | 无法并行处理多个任务 | 浪费等待时间 |
| **代码质量** | 缺少审查流程 | 引入 bug |

### 目标

构建一套完整的**软件工程工作流 Skills**，让 AI 编程助手：

1. **先理解需求** - 再动手，避免方向错误
2. **有设计文档才行动** - 确保架构合理
3. **严格 TDD** - 测试驱动开发
4. **并行处理任务** - 充分利用等待时间
5. **代码审查** - 保证代码质量

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                     Superpowers 工作流                       │
└─────────────────────────────────────────────────────────────┘

     ┌──────────┐
     │ 启动会话  │
     └────┬─────┘
          ▼
     ┌──────────┐     ┌──────────┐
     │ brainstorming │───▶ 需求澄清 & 设计 │
     │ (需求分析)  │     └────┬─────┘
     └──────────┘          ▼
                    ┌──────────────┐
                    │ writing-plans │───▶ 任务拆分
                    │ (任务规划)    │     └────┬─────┘
                    └──────────────┘          ▼
                                     ┌──────────────┐
                                     │ subagent-driven│───▶ 并行执行
                                     │ -development  │
                                     └───────┬──────┘
                                             ▼
                                     ┌──────────────┐
                                     │ finishing-a  │───▶ 收尾/合并
                                     │ -development │
                                     └──────────────┘
```

### 内置 Skills 详解

| Skill | 功能 | 触发时机 | 核心价值 |
|-------|------|---------|---------|
| **brainstorming** | 需求澄清、Socratic 推演 | 写代码前 | 不直接写代码，先理解真正需求 |
| **writing-plans** | 任务拆分 (2-5分钟粒度) | 设计完成后 | 将大任务拆分为可执行的小任务 |
| **subagent-driven-development** | 并行子任务执行 + 两阶段审查 | 执行计划时 | AI 可自主工作数小时 |
| **test-driven-development** | RED-GREEN-REFACTOR | 编写代码时 | 先写失败的测试，再写代码 |
| **requesting-code-review** | 代码审查 | 任务间隔 | 保证代码质量 |
| **using-git-worktrees** | 隔离工作分支 | 设计批准后 | 安全的多任务并行 |
| **finishing-a-development-branch** | 收尾、合并选项 | 任务完成 | 规范化收尾流程 |

### Skill 触发机制

```
用户请求 → AI 分析意图 → 匹配对应 Skill → 自动加载 → 执行工作流
```

**触发示例：**
- "帮我规划这个功能" → 触发 `writing-plans`
- "让我们调试这个问题" → 触发 `brainstorming`
- "开始实现" → 触发 `subagent-driven-development`

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Claude Code** | 最新版本 |
| **网络** | 访问 GitHub 安装插件 |

### 安装步骤

#### 方式 1: Claude Code 插件市场（推荐）

```bash
# 1. 注册插件市场
/plugin marketplace add obra/superpowers-marketplace

# 2. 安装 superpowers 插件
/plugin install superpowers@superpowers-marketplace

# 3. 重启 Claude Code

# 4. 验证安装
/plugin list
```

#### 方式 2: 手动安装

```bash
# 克隆市场仓库
git clone https://github.com/obra/superpowers-marketplace.git ~/.codex/plugins/superpowers-marketplace

# 或直接克隆 superpowers
git clone https://github.com/obra/superpowers.git ~/.codex/plugins/superpowers
```

### 验证安装

```bash
# 检查插件状态
claude plugin list

# 或在 Claude Code 中直接使用
# 启动新会话后，说："帮我规划这个功能"
```

### Windows 部署

> 同样的命令，在 PowerShell 或 CMD 中运行

```powershell
# 使用 PowerShell
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

### 更新插件

```bash
/plugin update superpowers
```

---

## 4. 效果展示

### Skill 触发示例

#### 示例 1: 需求分析（brainstorming）

```
用户: "帮我做一个用户登录功能"

AI (触发 brainstorming): 
"在我开始之前，我想确认一些细节：
1. 这个登录是用于 Web 还是移动应用？
2. 需要支持哪些认证方式（邮箱、OAuth、短信）？
3. 用户数据存储在哪里？
4. 是否需要记住我（remember me）功能？
5. 登录失败有什么限制？"

→ 不直接写代码，而是澄清需求
```

#### 示例 2: 任务规划（writing-plans）

```
用户: "开始实现这个功能"

AI (触发 writing-plans):
"我来将这个功能拆分为 2-5 分钟粒度的任务：

## 任务列表

### Task 1: 创建用户模型 (2分钟)
- [ ] 在 models/ 创建 User.ts
- [ ] 添加 email, password 字段
- [ ] 添加密码哈希方法

### Task 2: 实现注册 API (3分钟)
- [ ] 在 routes/ 创建 auth.ts
- [ ] 实现 POST /register 端点
- [ ] 添加输入验证

...

→ 自动拆分为可执行的小任务
```

#### 示例 3: 并行开发（subagent-driven-development）

```
AI (触发并行执行):
"我将并行执行以下任务：

🚀 Task 1-3 已启动（并行）:
  - [子Agent 1] 创建 User 模型
  - [子Agent 2] 实现注册 API
  - [子Agent 3] 编写测试

⏳ 等待完成...

✅ Task 1 完成: User 模型已创建
✅ Task 2 完成: 注册 API 已实现
⚠️ Task 3 需要审查: 测试代码

→ AI 自主工作，无需频繁确认
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **完整工作流** | 覆盖需求→设计→开发→测试→审查→合并全流程 |
| **强制执行** | Skills 自动触发，不是建议，是规范 |
| **子任务并行** | 可自主工作数小时不偏离计划 |
| **两阶段审查** | 先检查规范符合，再检查代码质量 |
| **MIT 许可** | 开源免费 |
| **多平台支持** | Claude Code / Cursor / Codex / OpenCode |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **学习曲线** | 需要理解 Skills 触发机制和工作流 |
| **初期较慢** | 设计阶段耗时，但减少返工 |
| **不适合小任务** | 简单任务反而是负担 |
| **依赖特定平台** | 需要 Claude Code/Cursor/Codex/OpenCode |
| **配置复杂** | 首次配置需要理解多个 Skill 的关系 |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 大型项目开发 | ⭐⭐⭐⭐⭐ |
| 团队协作 | ⭐⭐⭐⭐⭐ |
| 复杂功能实现 | ⭐⭐⭐⭐ |
| 快速原型 | ⭐⭐ |
| 小脚本/工具 | ⭐ |

---

## 6. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **superpowers** | 完整工程工作流 + 并行开发 | 大型项目、团队协作 |
| **OpenAI Skills** | Codex 官方技能系统 | Codex 用户 |
| **Claude Code 原生** | 内置能力 | 日常开发任务 |
| **MCP** | 工具集成协议 | 扩展工具能力 |

### superpowers vs 其他

| 特性 | superpowers | OpenAI Skills | Claude Code 原生 |
|-----|-------------|--------------|-----------------|
| 工作流覆盖 | 完整 | 部分 | 无 |
| 并行执行 | ✅ | ❌ | ❌ |
| TDD 支持 | ✅ | ❌ | 部分 |
| 代码审查 | ✅ | ❌ | 部分 |
| 平台支持 | 多平台 | Codex 限定 | Claude Code |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

superpowers 是一个**完整的软件工程工作流框架**，通过 Agent Skills 的形式让 AI 编程助手遵循专业开发流程。

#### 📝 关键发现

1. **Skills 自动触发**
   - 根据用户意图自动匹配对应 Skill
   - 无需手动选择或配置

2. **子任务并行执行**
   - `subagent-driven-development` 支持并行处理
   - 可自主工作数小时

3. **两阶段代码审查**
   - 第一阶段：规范符合性检查
   - 第二阶段：代码质量审查

4. **Git Worktrees 支持**
   - 隔离工作分支
   - 安全的多任务并行

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | 插件市场安装正常 |
| 自动触发 Skills | ✅ | brainstorming 正常触发 |
| 不影响原生能力 | ✅ | 与 Claude Code 兼容 |
| 中文支持 | ✅ | Skills 支持多语言 |
| 工作流完整 | ✅ | 覆盖需求到合并全流程 |

### 使用建议

1. **大型项目优先** - 对于小任务可能过重
2. **团队推广** - 统一工作流，提升协作效率
3. **渐进采用** - 先启用核心 Skills，再逐步扩展
4. **自定义配置** - 根据团队需求调整触发条件

---

## 8. 常见问题

### Q: superpowers 会影响 Claude Code 原生能力吗？
A: 不会。Skills 在特定时机自动触发，不会覆盖原生功能。

### Q: 可以禁用某些 Skill 吗？
A: 可以。通过配置文件自定义 Skills 的启用/禁用状态。

### Q: 支持中文项目吗？
A: 支持。Skills 基于对话触发，与语言无关。

### Q: 和 MCP 有什么区别？
A: superpowers 提供工作流层面的规范，MCP 提供工具层面的集成。两者互补。

### Q: 适合个人使用还是团队使用？
A: 都适合。团队使用时可统一工作流，个人使用可提升开发质量。

---

## 📎 相关链接

- [GitHub](https://github.com/obra/superpowers)
- [Marketplace](https://github.com/obra/superpowers-marketplace)
- [官方博客](https://blog.fsck.com/2025/10/09/superpowers/)
- [安装文档](https://github.com/obra/superpowers/blob/main/.codex/INSTALL.md)

---

*让 AI 遵循专业软件工程流程* 🛠️
