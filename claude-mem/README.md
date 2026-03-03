# claude-mem - Claude Code 智能记忆系统

> 自动捕获会话内容，AI 压缩摘要，跨会话注入上下文

## 📋 文档信息

- **Skill 名称**: claude-mem
- **GitHub**: [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem)
- **作者**: Alex Newman (@thedotmack)
- **许可证**: AGPL-3.0
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 记忆工具 / Claude Code 扩展

---

## 1. Skill 背景需求

### 问题痛点

Claude Code 虽然功能强大，但每次会话都是**独立的**：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **上下文丢失** | 会话结束即丢失所有上下文 | 重复解释项目背景 |
| **历史难追溯** | 无法高效查找过去的操作记录 | 重复踩坑 |
| **记忆碎片化** | 重要的决策和发现无法累积 | 项目知识流失 |
| **手动整理累** | 需要人工记录和维护笔记 | 增加额外负担 |

### 目标

**让 Claude Code 拥有真正的持久记忆能力**：

1. **自动捕获** - 无需手动操作，自动记录所有工具使用
2. **AI 压缩** - 用 AI 生成语义摘要，高效存储
3. **智能检索** - 支持自然语言搜索和向量语义查询
4. **渐进披露** - 按需获取详情，避免上下文膨胀

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude-Mem 工作流                          │
└─────────────────────────────────────────────────────────────┘

     ┌──────────┐
     │ 用户会话  │
     └────┬─────┘
          ▼
     ┌──────────┐     ┌──────────┐     ┌──────────┐
     │  Hooks   │────▶│   AI     │────▶│ Database │
     │ 捕获观察 │     │ 压缩摘要 │     │  存储    │
     └────┬─────┘     └──────────┘     └────┬─────┘
          │                                 │
          ▼                                 ▼
     ┌──────────┐                   ┌──────────────┐
     │ Worker   │                   │   Chroma     │
     │ Service  │                   │ 向量数据库    │
     └────┬─────┘                   └──────┬───────┘
          │                                 │
          ▼                                 ▼
     ┌──────────┐                   ┌──────────────┐
     │   Web    │◀───────────────────│   Search     │
     │ Viewer   │    MCP 工具查询    │   语义搜索    │
     └──────────┘                   └──────────────┘
```

### 技术栈

| 组件 | 技术 | 说明 |
|-----|------|------|
| 运行时 | Bun | 高性能 JavaScript 运行时 |
| 数据库 | SQLite | 持久化存储 + FTS5 全文搜索 |
| 向量库 | Chroma | 混合语义 + 关键词搜索 |
| AI | Claude Agent SDK | 自动生成摘要 |
| 协议 | MCP + Hooks | 生命周期钩子集成 |
| Web | 内置 HTTP Server | 实时内存流查看器 |

### 5 个生命周期 Hook

| Hook | 触发时机 | 功能 |
|-----|---------|------|
| **SessionStart** | 会话开始 | 加载历史记忆，注入上下文 |
| **UserPromptSubmit** | 用户提交提示词 | 记录用户意图 |
| **PostToolUse** | 工具使用后 | 捕获观察结果 |
| **Stop** | 停止时 | 中断处理 |
| **SessionEnd** | 会话结束 | 生成摘要，保存记忆 |

### 核心功能

| 功能 | 说明 |
|-----|------|
| **自动捕获** | 5 个生命周期钩子自动记录所有操作 |
| **AI 压缩** | 使用 Claude AI 生成语义摘要 |
| **渐进披露** | 3 层工作流：search → timeline → get_observations |
| **向量搜索** | Chroma 向量数据库，语义理解 |
| **Web 查看器** | http://localhost:37777 实时查看 |
| **隐私控制** | 标签排除敏感内容 |
| **MCP 工具** | 4 个搜索工具供 Claude 调用 |

### 搜索工作流 (3-Layer)

```
┌─────────────────────────────────────────────────────────────┐
│                  3-Layer 渐进披露模式                         │
└─────────────────────────────────────────────────────────────┘

  Layer 1: search()
  ┌─────────────────┐
  │  获取紧凑索引    │  ~50-100 tokens/result
  │  ID + 摘要      │  快速浏览大量结果
  └────────┬────────┘
           ▼
  Layer 2: timeline()
  ┌─────────────────┐
  │  时间上下文      │  了解周围发生了什么
  │  围绕特定观察    │
  └────────┬────────┘
           ▼
  Layer 3: get_observations()
  ┌─────────────────┐
  │  获取完整详情    │  ~500-1000 tokens/result
  │  按 ID 精确获取  │  只获取相关内容
  └─────────────────┘

  → 节省约 10x tokens
```

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Node.js** | 18.0.0+ |
| **Claude Code** | 最新版本 (支持插件) |
| **Bun** | JavaScript 运行时 (自动安装) |
| **uv** | Python 包管理器 (向量搜索用) |

### 安装步骤

#### 方式 1: Claude Code 插件市场（推荐）

```bash
# 添加 claude-mem 市场
/plugin marketplace add thedotmack/claude-mem

# 安装 claude-mem
/plugin install claude-mem

# 重启 Claude Code
```

#### 方式 2: OpenClaw 一键安装

```bash
# OpenClaw 网关一键安装
curl -fsSL https://install.cmem.ai/openclaw.sh | bash
```

#### 方式 3: 手动安装（仅 SDK）

```bash
# 全局安装（仅安装 SDK，不含 hooks）
npm install -g claude-mem

# 注意：这种安装方式不会注册插件 hooks
```

### 配置说明

| 环境变量 | 说明 | 默认值 |
|---------|------|-------|
| `CMEM_AI_MODEL` | AI 摘要模型 | haiku |
| `CMEM_AI_MODEL_FALLBACK` | 备用模型 | sonnet |
| `CMEM_WORKER_PORT` | HTTP 服务端口 | 37777 |
| `CMEM_DATA_DIR` | 数据存储目录 | ~/.claude-mem |
| `CMEM_LOG_LEVEL` | 日志级别 | info |
| `CMEM_CONTEXT_LIMIT` | 上下文注入限制 | 8000 |

### 配置文件

位置：`~/.claude-mem/settings.json`（首次运行自动创建）

```json
{
  "ai": {
    "model": "haiku",
    "fallback": "sonnet"
  },
  "worker": {
    "port": 37777
  },
  "data": {
    "directory": "~/.claude-mem"
  },
  "context": {
    "maxTokens": 8000
  }
}
```

### 验证安装

```bash
# 访问 Web 查看器
open http://localhost:37777

# 使用 MCP 工具搜索
# 在 Claude Code 中直接用自然语言搜索
mem-search "上次我们怎么做认证的？"
```

### Windows 部署

```powershell
# 确保安装 Node.js 18+
# 然后在 Claude Code 中运行
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

---

## 4. 效果展示

### 使用示例

#### 示例 1: 自动记忆项目上下文

```
用户: "继续开发这个项目"

Claude Code (加载 claude-mem):
"让我先查看之前的项目状态..."

→ 自动加载历史记忆:
## 2026-03-01: 用户认证模块

观察 #123:
- 决定使用 JWT + Redis Session
- 已实现登录/登出接口
- 下一步: 完善权限校验

观察 #456:
- 发现 API 设计不符合 REST 规范
- 建议: 统一响应格式

→ 直接从上次中断的地方继续，无需重复解释
```

#### 示例 2: 自然语言搜索

```
用户: "上次处理支付 bug 是怎么解决的？"

Claude (触发 mem-search):
// Step 1: 搜索索引
search(query="支付 bug", type="bugfix", limit=10)

// Step 2: 获取时间上下文
timeline(observation_id=789)

// Step 3: 获取完整详情
get_observations(ids=[789, 790])

→ 返回完整的问题定位和修复过程
```

#### 示例 3: 渐进式获取详情

```
用户: "这个函数为什么要这样设计？"

Claude:
"让我搜索一下之前的讨论..."

// 第一步：快速获取索引（~50 tokens）
search(query="函数设计 决策")

结果:
- ID #234: "决定使用策略模式" (~50 tokens)
- ID #567: "对比了 3 种方案" (~50 tokens)

// 第二步：查看时间线
timeline(observation_id=234)

// 第三步：按需获取详情
get_observations(ids=[234])

→ 节省 90% tokens，只获取真正需要的信息
```

#### Web 查看器界面

访问 `http://localhost:37777` 可以看到：
- 实时内存流
- 所有观察记录
- 按时间/项目筛选
- 观察详情和引用

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **自动捕获** | 无需手动操作，5 个钩子自动记录 |
| **AI 压缩摘要** | Claude AI 生成语义摘要，高效存储 |
| **渐进披露** | 3 层工作流节省大量 tokens |
| **向量搜索** | Chroma 向量数据库，语义理解 |
| **Web 查看器** | 实时查看内存流，直观便捷 |
| **隐私控制** | 支持标签排除敏感内容 |
| **多平台支持** | Claude Code + Claude Desktop + OpenClaw |
| **活跃开发** | 持续更新，功能丰富 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **AGPL 许可证** | 开源但有传染性，商业使用需注意 |
| **依赖 Bun** | 需要额外安装 Bun 运行时 |
| **资源占用** | 向量数据库和 Worker 服务占用资源 |
| **首次启动慢** | 首次需要初始化多个组件 |
| **配置复杂** | 多个配置文件需要理解 |
| **网络依赖** | AI 摘要需要 API (可配置本地模型) |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 长期项目开发 | ⭐⭐⭐⭐⭐ |
| 复杂代码库维护 | ⭐⭐⭐⭐⭐ |
| 团队知识传承 | ⭐⭐⭐⭐ |
| 个人项目记录 | ⭐⭐⭐⭐ |
| 快速原型开发 | ⭐⭐⭐ |

---

## 6. 平替对比

### Claude-Mem vs Episodic-Memory

| 特性 | claude-mem | episodic-memory |
|-----|------------|-----------------|
| **搜索方式** | 混合向量 + FTS5 | 向量嵌入 (Transformers.js) |
| **存储** | SQLite + Chroma | SQLite + sqlite-vec |
| **AI 摘要** | ✅ 自动生成 | ❌ 仅索引原始对话 |
| **渐进披露** | ✅ 3 层工作流 | ❌ 直接获取 |
| **Web 查看器** | ✅ 内置 | ❌ 无 |
| **Hook 数量** | 5 个 | 1-2 个 |
| **许可证** | AGPL-3.0 | MIT |
| **OpenClaw 支持** | ✅ 一键安装 | ❌ |

### 选择建议

| 场景 | 推荐 |
|-----|------|
| **需要 AI 摘要压缩** | claude-mem |
| **完全离线运行** | episodic-memory |
| **需要 Web 界面** | claude-mem |
| **商业项目** | episodic-memory (MIT) |
| **渐进式 token 优化** | claude-mem |
| **简单轻量** | episodic-memory |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

claude-mem 是一个**智能持久记忆系统**，通过 5 个生命周期钩子自动捕获会话中的所有操作和观察，使用 Claude AI 生成压缩摘要，并通过向量数据库实现语义搜索。

#### 📝 关键发现

1. **AI 压缩 vs 原始索引**
   - claude-mem: 使用 AI 生成摘要，存储更高效
   - episodic-memory: 索引原始对话，保留更多细节

2. **渐进披露设计**
   - 3 层工作流：search → timeline → get_observations
   - 节省约 10x tokens，避免上下文膨胀

3. **Web 查看器**
   - 内置 HTTP 服务，实时查看记忆流
   - 支持观察详情和引用链接

4. **多平台支持**
   - Claude Code (主要)
   - Claude Desktop
   - OpenClaw (一键安装)

5. **隐私控制**
   - 支持标签排除敏感内容
   - 可配置存储位置

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | /plugin 安装正常 |
| 自动捕获 | ✅ | Hooks 自动记录 |
| AI 摘要 | ✅ | 自动生成压缩摘要 |
| 向量搜索 | ✅ | Chroma 语义搜索 |
| Web 查看器 | ✅ | localhost:37777 可访问 |
| 渐进披露 | ✅ | 3 层工作流正常 |
| OpenClaw | ✅ | 支持一键安装 |

### 使用建议

1. **配置 API** - 设置 AI 模型获取更好的摘要质量
2. **合理设置上下文限制** - 根据项目复杂度调整
3. **使用标签排除敏感** - 保护隐私
4. **结合 CLAUDE.md** - claude-mem + 项目规范 = 完整上下文

---

## 8. 常见问题

### Q: claude-mem 和 episodic-memory 有什么区别？
A: claude-mem 使用 AI 自动生成摘要，支持渐进披露和 Web 查看器；episodic-memory 索引原始对话，完全离线运行。两者都是优秀的记忆工具，各有优势。

### Q: 需要配置 API Key 吗？
A: 默认使用 Claude API 进行摘要生成。可以配置环境变量使用自己的 API 或本地模型。

### Q: 占用多少存储空间？
A: 取决于对话长度和数量。AI 摘要比原始对话节省约 80% 空间。

### Q: 首次启动需要多久？
A: 首次需要初始化数据库和向量库，可能需要几分钟。后续启动较快。

### Q: 支持中文对话吗？
A: 支持。语义搜索与语言无关。

### Q: AGPL 许可证有什么限制？
A: 如果修改并部署到网络服务器，需要开源你的修改。个人使用无限制。

### Q: 如何排除敏感内容？
A: 使用标签如 `<NO-MEMORY>` 标记不想记录的内容。

---

## 9. 命令参考

```bash
# 安装 (Claude Code 中)
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem

# OpenClaw 一键安装
curl -fsSL https://install.cmem.ai/openclaw.sh | bash

# MCP 工具使用
search(query="关键词", type="类型", limit=10)
timeline(observation_id=123)
get_observations(ids=[123, 456])

# Web 查看器
open http://localhost:37777

# 调试
cd ~/.claude/plugins/marketplaces/thedotmack
npm run bug-report
```

---

## 📎 相关链接

- [GitHub](https://github.com/thedotmack/claude-mem)
- [官方文档](https://docs.claude-mem.ai/)
- [Chroma 向量数据库](https://www.trychroma.com/)
- [Bun 运行时](https://bun.sh/)
- [OpenClaw 集成](https://docs.claude-mem.ai/openclaw-integration)

---

*让 Claude Code 记住每一次编程之旅* 🧠
