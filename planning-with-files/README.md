# planning-with-files - Manus 风格持久化规划系统

> 实现 Manus-style 持久化 Markdown 规划 — 价值 20 亿美元收购的工作流模式

## 📋 文档信息

- **Skill 名称**: planning-with-files
- **GitHub**: [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)
- **作者**: Ahmad Othman Ammar Adi (@OthmanAdi)
- **许可证**: MIT
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 工作流 / 上下文工程
- **Stars**: 15,063 ⭐
- **Forks**: 1,390

---

## 1. Skill 背景需求

### 问题痛点

Claude Code（及大多数 AI Agent）面临以下挑战：

| 问题 | 描述 | 后果 |
|-----|------|------|
| ** volatile memory** | TodoWrite 工具在上下文重置后消失 | 丢失任务进度 |
| **目标漂移** | 50+ 工具调用后忘记原始目标 | 偏离任务方向 |
| **隐藏错误** | 失败未被追踪，重复踩坑 | 效率降低 |
| **上下文塞满** | 一切塞入上下文而非存储 | 上下文膨胀 |

### 目标

**将文件系统作为持久化记忆系统**：

1. **持久化存储** - 将重要信息写入磁盘而非上下文
2. **注意力控制** - 决策前重新阅读计划（通过 hooks）
3. **错误持久化** - 记录失败以便未来参考
4. **目标追踪** - 复选框显示进度
5. **完成验证** - Stop hook 检查所有阶段

---

## 2. 设计方案

### 核心架构：三文件模式

对于每个复杂任务，创建三个文件：

```
task_plan.md      → 追踪阶段和进度
findings.md       → 存储研究和发现
progress.md       → 会话日志和测试结果
```

### 核心原则

```
上下文窗口 = RAM（易失性，有限）
文件系统 = 磁盘（持久化，无限）

→ 任何重要内容都写入磁盘
```

### Manus 工作流原理

| 原理 | 实现方式 |
|-----|---------|
| 文件系统即记忆 | 存储在文件中，而非上下文中 |
| 注意力操作 | 决策前重新阅读计划（PreToolUse hook） |
| 错误持久化 | 记录失败到计划文件 |
| 目标追踪 | 复选框显示进度 |
| 完成验证 | Stop hook 检查所有阶段 |

### 支持平台（16 个）

| IDE | 状态 | 安装格式 |
|-----|------|---------|
| Claude Code | ✅ 全支持 | Plugin + SKILL.md |
| Gemini CLI | ✅ 全支持 | Agent Skills |
| OpenClaw | ✅ 全支持 | Workspace/Local Skills |
| Kiro | ✅ 全支持 | Steering Files |
| Cursor | ✅ 全支持 | Skills + Hooks |
| Continue | ✅ 全支持 | Skills + Prompt files |
| Kilocode | ✅ 全支持 | Skills |
| OpenCode | ✅ 全支持 | Personal/Project Skill |
| Codex | ✅ 全支持 | Personal Skill |
| FactoryAI Droid | ✅ 全支持 | Workspace/Personal Skill |
| Antigravity | ✅ 全支持 | Workspace/Personal Skill |
| CodeBuddy | ✅ 全支持 | Workspace/Personal Skill |
| AdaL CLI | ✅ 全支持 | Personal/Project Skills |
| Pi Agent | ✅ 全支持 | Agent Skills |
| GitHub Copilot | ✅ 全支持 | Hooks |
| Mastra Code | ✅ 全支持 | Skills + Hooks |

---

## 3. 本地部署

### 快速安装（Claude Code）

在 Claude Code 中运行：

```
/plugin marketplace add OthmanAdi/planning-with-files
/plugin install planning-with-files@planning-with-files
```

### 替代安装

**macOS/Linux:**
```bash
cp -r ~/.claude/plugins/cache/planning-with-files/planning-with-files/*/skills/planning-with-files ~/.claude/skills/
```

**Windows (PowerShell):**
```powershell
Copy-Item -Recurse -Path "$env:USERPROFILE\.claude\plugins\cache\planning-with-files\planning-with-files\*\skills\planning-with-files" -Destination "$env:USERPROFILE\.claude\skills\"
```

### OpenClaw 安装

1. 将 skills 复制到 OpenClaw 工作空间：
```bash
mkdir -p ~/.openclaw/workspace/skills
cp -r planning-with-files ~/.openclaw/workspace/skills/
```

2. 重启 OpenClaw

---

## 4. 使用方法

### 命令

| 命令 | 自动补全 | 描述 |
|-----|---------|------|
| `/planning-with-files:plan` | 输入 `/plan` | 开始规划会话 (v2.11.0+) |
| `/planning-with-files:status` | 输入 `/plan:status` | 显示规划进度概览 (v2.15.0+) |
| `/planning-with-files:start` | 输入 `/planning` | 原始启动命令 |

### 使用流程

安装后，AI Agent 将：

1. **询问任务** - 如果未提供描述
2. **创建三个文件** - `task_plan.md`, `findings.md`, `progress.md`
3. **重新阅读计划** - 决策前（通过 PreToolUse hook）
4. **提醒更新状态** - 文件写入后（通过 PostToolUse hook）
5. **存储发现** - 存入 `findings.md` 而非塞入上下文
6. **记录错误** - 供未来参考
7. **验证完成** - 停止前（通过 Stop hook）

### 核心规则

1. **先建计划** - 无 `task_plan.md` 不开始
2. **2-操作规则** - 每 2 次 view/browser 操作后保存发现
3. **记录所有错误** - 有助于避免重复
4. **从不重复失败** - 追踪尝试，改变方法

### 何时使用

**适合：**
- 多步骤任务（3+ 步骤）
- 研究任务
- 构建/创建项目
- 跨多工具调用的任务

**跳过：**
- 简单问题
- 单文件编辑
- 快速查找

---

## 5. 效果展示

### 文件结构示例

```
project/
├── task_plan.md      # 任务规划
├── findings.md       # 研究发现  
└── progress.md       # 进度日志
```

### task_plan.md 示例

```markdown
# 任务计划：构建电商网站

## 阶段 1: 需求分析
- [x] 确定核心功能
- [x] 设计数据库架构
- [ ] 编写技术规格

## 阶段 2: 前端开发
- [ ] 实现首页
- [ ] 实现产品列表页
- [ ] 实现购物车

## 阶段 3: 后端开发
- [ ] 用户认证 API
- [ ] 产品管理 API
- [ ] 订单处理 API

## 阶段 4: 测试与部署
- [ ] 单元测试
- [ ] 集成测试
- [ ] 部署到生产环境
```

---

## 6. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **持久化记忆** | 上下文重置后仍保留任务进度 |
| **多平台支持** | 支持 16 个主流 AI 编程工具 |
| **错误追踪** | 避免重复踩坑，提高效率 |
| **目标聚焦** | 通过复选框保持任务方向 |
| **自动化 hooks** | 自动提醒更新、自动验证完成 |
| **会话恢复** | `/clear` 后自动恢复之前的会话 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **初始学习曲线** | 需要理解三文件模式 |
| **文件管理** | 项目中会增加额外文件 |
| **可能过度** | 简单任务不需要此框架 |
| **依赖 Hooks** | 需要正确配置 hooks 才能发挥全部功能 |

---

## 7. 平替对比

| Skill | Stars | 特点 | 适用场景 |
|-------|-------|------|---------|
| **planning-with-files** | 15,063 | Manus 风格持久化规划 | 多步骤复杂任务 |
| **get-shit-done** | - | 轻量级 Spec 驱动 | 快速迭代 |
| **superpowers** | 68k+ | 完整工程工作流 | 全栈开发 |
| **AB Method** | - | Spec 驱动 + 子 Agent | 大型项目拆分 |

---

## 8. 社区 Fork 扩展

| Fork | 作者 | 特性 |
|-----|------|------|
| [devis](https://github.com/st01cs/devis) | @st01cs | 面试优先工作流 |
| [multi-manus-planning](https://github.com/kmichels/multi-manus-planning) | @kmichels | 多项目支持、会话启动 git 同步 |
| [plan-cascade](https://github.com/Taoidle/plan-cascade) | @Taoidle | 多级任务编排、并行执行、多 Agent 协作 |

---

## 9. 落地过程

### 安装步骤

1. **Claude Code 安装**
   ```
   /plugin marketplace add OthmanAdi/planning-with-files
   /plugin install planning-with-files@planning-with-files
   ```

2. **验证安装**
   - 输入 `/plan` 应该触发规划流程
   - 创建 `task_plan.md`, `findings.md`, `progress.md`

### 实际使用

1. 启动任务：`/plan`
2. 描述任务目标
3. AI 自动创建三个文件
4. AI 在每个阶段前读取计划
5. 完成后自动验证所有阶段

---

## 10. 相关资源

- [Manus AI 博客：Context Engineering for AI Agents](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- [官方文档](./docs/)
- [快速入门指南](./docs/quickstart.md)
- [版本发布历史](CHANGELOG.md)

---

*让 AI 拥有真正的持久记忆，像 Manus 一样工作*
