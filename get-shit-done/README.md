# get-shit-done (GSD) - 轻量级 Spec 驱动开发系统

> 让 AI 编程助手真正"把事情做好"的上下文工程框架

## 📋 文档信息

- **Skill 名称**: get-shit-done (GSD)
- **GitHub**: [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done)
- **Star**: 未知（热门项目）
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 元提示工程 / Claude Code 扩展 / 生产力工具

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **Context Rot** | 上下文窗口质量随时间下降 | AI 输出质量越来越差 |
| **Vibecoding 陷阱** | 描述想要什么就生成代码 | 结果不一致、难以扩展 |
| **缺乏系统性** | 没有规范的需求分析流程 | 建出不想要的东西 |
| **企业化过重** | 其他工具太复杂 | 个人开发者不需要 Jira 那套 |
| **上下文丢失** | 长会话中 AI"健忘" | 需要反复解释 |

### 目标

构建一套**轻量但强大**的元提示和上下文工程系统，让 AI 编程助手：

1. **Spec 驱动开发** - 基于规范而非猜测
2. **保持上下文新鲜** - 每个任务使用全新上下文
3. **Wave 并行执行** - 独立任务并行，有依赖顺序执行
4. **原子提交** - 每个任务独立提交
5. **零企业化** - 没有故事点、回顾会、Sprint 仪式

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                    GSD 工作流系统                             │
└─────────────────────────────────────────────────────────────┘

     ┌──────────────┐
     │ /gsd:new-project │
     └──────┬───────┘
            ▼
     ┌──────────────┐
     │   需求澄清    │───▶ Questions → Research → Requirements
     │ /gsd:discuss │
     └──────┬───────┘
            ▼
     ┌──────────────┐
     │ /gsd:plan    │───▶ Research → Plan → Verify
     └──────┬───────┘
            ▼
     ┌──────────────┐
     │ /gsd:execute │───▶ Wave 1 (并行) → Wave 2 (并行) → ...
     └──────┬───────┘
            ▼
     ┌──────────────┐
     │ /gsd:verify  │───▶ 人工验收测试
     └──────────────┘
```

### 核心命令

| 命令 | 功能 | 触发时机 |
|-----|------|---------|
| `/gsd:new-project` | 完整初始化：提问→研究→需求→路线图 | 新项目开始 |
| `/gsd:discuss-phase N` | 收集实现决策 | 规划前 |
| `/gsd:plan-phase N` | 研究+规划+验证 | 制定计划 |
| `/gsd:execute-phase N` | 波次并行执行 | 执行计划 |
| `/gsd:verify-work N` | 人工验收测试 | 完成后 |
| `/gsd:quick` | 快速任务（bug修复、小功能） | 临时任务 |
| `/gsd:map-codebase` | 分析现有代码库 | 老项目 |
| `/gsd:progress` | 查看进度和下一步 | 任意时刻 |

### 关键文件

| 文件 | 作用 |
|-----|------|
| `PROJECT.md` | 项目愿景，始终加载 |
| `research/` | 生态系统知识（栈、特性、架构、陷阱） |
| `REQUIREMENTS.md` | 范围化的 v1/v2 需求 |
| `ROADMAP.md` | 方向和进度 |
| `STATE.md` | 决策、阻塞、位置 |
| `PLAN.md` | 原子任务，XML 结构化 |
| `SUMMARY.md` | 发生了什么，提交历史 |

### Wave 执行机制

```
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE EXECUTION                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│ WAVE 1 (并行)     WAVE 2 (并行)     WAVE 3                        │
│ ┌─────────┐       ┌─────────┐       ┌─────────┐                   │
│ │ Plan 01 │       │ Plan 03 │  ──▶  │ Plan 05 │                   │
│ │ User    │       │ Orders  │       │Checkout │                   │
│ │ Model   │       │   API   │       │   UI    │                   │
│ └─────────┘       └─────────┘       └─────────┘                   │
│      │                 │                 │                        │
│      └────────┬────────┘         (依赖前面所有)                     │
│               ▼                                               │
│ ┌─────────┐       ┌─────────┐                                      │
│ │ Plan 02 │       │ Plan 04 │                                      │
│ │ Product │       │  Cart   │                                      │
│ │ Model   │       │   API   │                                      │
│ └─────────┘       └─────────┘                                      │
│                                                                     │
│ Plan 03 依赖 Plan 01                                               │
│ Plan 04 依赖 Plan 02                                               │
│ Plan 05 依赖 Plans 03 + 04                                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Node.js** | 18+ 版本 |
| **Claude Code / OpenCode / Gemini CLI / Codex** | 至少一个 |
| **网络** | 访问 npm 和 GitHub |

### 安装步骤

#### 方式 1: npm 全局安装（推荐）

```bash
# 安装 GSD
npx get-shit-done-cc@latest

# 安装过程会提示选择:
# - Runtime: Claude Code / OpenCode / Gemini / Codex / All
# - Location: Global (所有项目) / Local (当前项目)
```

#### 方式 2: 非交互式安装

```bash
# Claude Code 全局
npx get-shit-done-cc --claude --global

# Claude Code 本地
npx get-shit-done-cc --claude --local

# OpenCode 全局
npx get-shit-done-cc --opencode --global

# Gemini CLI
npx get-shit-done-cc --gemini --global

# Codex
npx get-shit-done-cc --codex --global

# 所有运行时
npx get-shit-done-cc --all --global
```

#### 方式 3: 开发安装

```bash
# 克隆仓库并本地安装
git clone https://github.com/gsd-build/get-shit-done.git
cd get-shit-done
node bin/install.js --claude --local
```

### 验证安装

```bash
# Claude Code / Gemini
/gsd:help

# OpenCode
/gsd-help

# Codex
$gsd-help
```

### Windows 部署

> 在 PowerShell 中运行同样的命令

```powershell
npx get-shit-done-cc@latest
```

### 更新 GSD

```bash
npx get-shit-done-cc@latest
```

### 卸载 GSD

```bash
# 全局卸载
npx get-shit-done-cc --claude --global --uninstall
npx get-shit-done-cc --opencode --global --uninstall
npx get-shit-done-cc --codex --global --uninstall

# 本地卸载
npx get-shit-done-cc --claude --local --uninstall
```

---

## 4. 效果展示

### 命令触发示例

#### 新项目流程

```
用户: "帮我做一个任务管理应用"

GSD (触发 /gsd:new-project):
"让我先了解你的想法：

1. 这是 Web 应用还是移动端？
2. 主要用户是谁？个人还是团队？
3. 核心功能有哪些？（任务创建、分类、截止日期...）
4. 有偏好的技术栈吗？
5. 需要用户认证吗？

→ 提问直到完全理解需求
→ 接着进行研究、需求分析、路线图规划"
```

#### 快速任务

```
用户: "修复登录页面的 bug"

GSD (触发 /gsd:quick):
"好的，这是一个快速任务。

我需要知道：
- 具体是什么 bug？登录失败？页面显示错误？
- 之前能正常工作吗？

→ 不需要完整的研究规划流程
→ 直接执行并原子提交"
```

#### 查看进度

```
用户: "项目进展如何？"

GSD (触发 /gsd:progress):
"## 项目进度

### 已完成
- ✅ Phase 1: 用户注册系统
- ✅ Phase 2: 产品目录

### 进行中
- 🔄 Phase 3: 购物车 (Wave 2/3)

### 待处理
- ⏳ Phase 4: 结账流程

→ 清晰的进度追踪"
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **轻量级** | 不需要复杂配置，即装即用 |
| **多平台支持** | Claude Code / OpenCode / Gemini CLI / Codex |
| **解决 Context Rot** | 每个任务全新上下文，200k tokens 纯净空间 |
| **Wave 并行** | 独立任务并行执行，依赖顺序处理 |
| **原子提交** | 每个任务独立提交，Git 历史清晰 |
| **零企业化** | 没有 Jira、Sprint、故事点 |
| **MIT 许可** | 开源免费 |
| **可选研究** | 可跳过研究加速开发 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **学习曲线** | 多个命令需要理解使用场景 |
| **需要习惯** | 与传统开发流程不同 |
| **文件膨胀** | .planning/ 目录会积累很多文件 |
| **不适合简单任务** | 小 bug 修复也走完整流程 |
| **依赖 npm** | 需要 Node.js 环境 |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 中大型项目开发 | ⭐⭐⭐⭐⭐ |
| 个人开发者 | ⭐⭐⭐⭐⭐ |
| 快速原型验证 | ⭐⭐⭐⭐ |
| 复杂功能实现 | ⭐⭐⭐⭐⭐ |
| 小 bug 修复 | ⭐⭐⭐ |
| 简单脚本 | ⭐⭐ |

---

## 6. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **get-shit-done** | 轻量 Spec 驱动 + Wave 并行 | 个人/小型团队 |
| **superpowers** | 完整工程工作流 + TDD | 大型项目/团队协作 |
| **Codex 原生** | 内置能力 | 日常开发任务 |
| **MCP** | 工具集成协议 | 扩展工具能力 |

### GSD vs superpowers

| 特性 | GSD | superpowers |
|-----|-----|-------------|
| 设计理念 | 轻量、零企业化 | 完整工程流程 |
| Context 管理 | 每任务全新上下文 | 依赖会话累积 |
| 并行执行 | Wave 模式 | Subagent 并行 |
| TDD 支持 | 可选 | 内置 |
| 代码审查 | 无内置 | 两阶段审查 |
| 学习曲线 | 中等 | 较陡 |
| 复杂度 | 低 | 高 |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

get-shit-done 是一个**轻量级的元提示和上下文工程框架**，解决 AI 编程助手的上下文衰减问题，通过规范驱动开发提升可靠性。

#### 📝 关键发现

1. **Context Rot 解决方案**
   - 每个计划在全新上下文窗口执行
   - 200k tokens 纯净空间
   - 主会话保持在 30-40% 利用率

2. **Wave 执行机制**
   - 独立任务并行执行
   - 有依赖的任务顺序处理
   - "垂直切片"比"水平分层"更好并行

3. **原子提交**
   - 每个任务完成后立即提交
   - Git bisect 可精确定位失败任务
   - 清晰的 AI 工作历史

4. **多平台支持**
   - Claude Code
   - OpenCode
   - Gemini CLI
   - Codex

5. **可选工作流**
   - 可跳过研究 (--skip-research)
   - 可跳过验证 (--skip-verify)
   - 可配置模型质量 (quality/balanced/budget)

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | npx 安装正常 |
| 命令触发 | ✅ | /gsd:help 正常响应 |
| 多平台支持 | ✅ | 覆盖主流 AI 编程工具 |
| 文档完善 | ✅ | 用户指南详尽 |
| 活跃维护 | ✅ | 持续更新 |

### 使用建议

1. **新项目优先** - 完整流程体验最佳
2. **理解命令场景** - 不要滥用 /gsd:quick
3. **使用 --auto** - 熟悉后可自动化流程
4. **配置权限** - 建议允许自动 git 提交
5. **垂直切片** - 按功能模块拆分任务

---

## 8. 常见问题

### Q: GSD 和 superpowers 哪个更好？
A: GSD 更轻量适合个人/小型项目，superpowers 更完整适合大型团队。

### Q: GSD 会覆盖 Claude Code 原生能力吗？
A: 不会。GSD 通过命令触发，不影响原生功能。

### Q: 可以自定义工作流吗？
A: 可以。通过 /gsd:settings 配置各阶段开关。

### Q: 支持中文项目吗？
A: 支持。GSD 基于对话触发，与语言无关。

### Q: 和 MCP 有什么区别？
A: GSD 提供工作流层面的规范，MCP 提供工具层面的集成。两者互补。

### Q: 适合个人使用还是团队使用？
A: 更适合个人开发者。没有企业流程，适合快速迭代。

---

## 📎 相关链接

- [GitHub](https://github.com/gsd-build/get-shit-done)
- [npm 包](https://www.npmjs.com/package/get-shit-done-cc)
- [Discord 社区](https://discord.gg/gsd)
- [Twitter](https://x.com/gsd_foundation)

---

*让 AI "把事情做好"，而不是"把事情做砸"*
