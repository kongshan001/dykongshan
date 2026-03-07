# episodic-memory - Claude Code 跨会话语义搜索

> 让 AI 编程助手记住跨会话的讨论、决策和模式

## 📋 文档信息

- **Skill 名称**: episodic-memory
- **GitHub**: [obra/episodic-memory](https://github.com/obra/episodic-memory)
- **作者**: Jesse Vincent (jesse@fsck.com)
- **版本**: 1.0.15
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 记忆工具 / Claude Code 扩展

---

## 1. Skill 背景需求

### 问题痛点

Claude Code 虽然功能强大，但每次会话都是**独立的**：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **无记忆** | 每次新会话都是白纸 | 需要重复解释上下文 |
| **丢上下文** | 上次讨论的决策无法追溯 | 重复踩坑 |
| **查历史难** | 只能搜索关键词 | 无法语义理解意图 |
| **断点难续** | 长项目中断后很难接上 | 需要大量时间回顾 |

### 目标

**让 Claude Code 拥有真正的记忆能力**：

1. **语义搜索** - 理解意图而非只匹配关键词
2. **跨会话记忆** - 记住之前的讨论、决策、偏好
3. **自动索引** - 会话结束后自动归档和索引
4. **可排除敏感内容** - 保护隐私

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Episodic Memory 工作流                     │
└─────────────────────────────────────────────────────────────┘

     ┌──────────┐
     │ 用户会话  │
     └────┬─────┘
          ▼
     ┌──────────┐
     │ session- │───▶ 复制对话到归档
     │ end hook │
     └────┬─────┘
          ▼
     ┌──────────┐     ┌──────────┐
     │  Parse   │────▶│  Embed   │
     │ 解析对话 │     │ 生成向量  │
     └──────────┘     └────┬─────┘
                           ▼
                    ┌──────────────┐
                    │   Index      │
                    │ 存入 SQLite  │
                    └───────┬──────┘
                            ▼
                    ┌──────────────┐
                    │   Search     │
                    │  语义搜索    │
                    └──────────────┘
```

### 技术栈

| 组件 | 技术 | 说明 |
|-----|------|------|
| 向量嵌入 | Transformers.js | 本地离线生成，无需 API |
| 存储 | SQLite + sqlite-vec | 快速向量相似度搜索 |
| 协议 | MCP | Model Context Protocol |
| 索引 | 会话结束自动 | 无需手动操作 |

### 核心功能

| 功能 | 说明 |
|-----|------|
| **语义搜索** | 用自然语言搜索，非关键词匹配 |
| **自动索引** | 会话结束后自动归档和索引 |
| **MCP 工具** | 提供 search_conversations 工具 |
| **排除机制** | 可标记不索引的敏感会话 |
| **本地运行** | 完全离线，保护隐私 |

### 支持的搜索模式

```
单概念搜索:
  "React Router authentication"

多概念 AND 搜索:
  ["React Router", "authentication", "JWT"]

精确文本搜索:
  --text "exact phrase"

时间范围搜索:
  --after 2025-09-01 "refactoring"
```

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Node.js** | 18+ 版本 |
| **Claude Code** | 最新版本 |
| **npm** | 包管理器 |

### 安装步骤

#### 方式 1: Claude Code 插件市场（推荐）

```bash
# 添加 superpowers 市场
/plugin marketplace add obra/superpowers-marketplace

# 安装 episodic-memory
/plugin install episodic-memory@superpowers-marketplace

# 重启 Claude Code
```

#### 方式 2: npm 全局安装

```bash
# 全局安装
npm install -g episodic-memory

# 同步对话
episodic-memory sync

# 搜索对话
episodic-memory search "React Router authentication"

# 查看统计
episodic-memory stats
```

### 配置 session-end hook

在项目 `.claude/hooks/session-end` 添加：

```bash
#!/bin/bash
episodic-memory sync
```

### 配置说明

| 环境变量 | 说明 | 默认值 |
|---------|------|-------|
| `EPISODIC_MEMORY_API_MODEL` | 总结模型 | haiku |
| `EPISODIC_MEMORY_API_MODEL_FALLBACK` | 备用模型 | sonnet |
| `EPISODIC_MEMORY_API_BASE_URL` | 自定义 API 端点 | - |
| `EPISODIC_MEMORY_API_TOKEN` | API Token | - |
| `EPISODIC_MEMORY_API_TIMEOUT_MS` | 超时时间(ms) | 300000 |

### 验证安装

```bash
# 查看索引统计
episodic-memory stats

# 测试搜索
episodic-memory search "authentication"
```

### Windows 部署

```powershell
# PowerShell 中运行
npm install -g episodic-memory
episodic-memory sync
episodic-memory stats
```

---

## 4. 效果展示

### 使用示例

#### 示例 1: 自然语言搜索

```
用户: "上次我们怎么做用户认证的？"

AI (触发 episodic-memory):
"让我搜索一下之前的对话..."

找到相关讨论:

## 2025-10-15: 用户认证实现

讨论内容:
- 决定使用 JWT token + Redis session
- 密码用 bcrypt 哈希
- OAuth 支持 Google 和 GitHub

文件: src/auth/AuthService.ts
决策: "使用 JWT 作为主要认证方式"

→ 无需重复解释，直接找到之前的决策
```

#### 示例 2: 避免重复踩坑

```
用户: "帮我加一个支付功能"

AI:
"在开始之前，让我检查一下我们之前是否讨论过类似的功能..."

搜索结果:
## 2025-10-20: 支付功能尝试

讨论: 曾尝试集成 Stripe，但发现：
- 需要企业资质
- API 限制复杂
- 已搁置

建议: "不建议现在做支付，建议用第三方支付聚合平台"

→ 避免重复调研，节省时间
```

#### 示例 3: 理解项目演进

```
用户: "这个 API 为什么要这样设计？"

AI:
"让我查一下之前的讨论..."

## 2025-09-10: API 设计决策

讨论: REST vs GraphQL
结论: 继续用 REST，因为团队熟悉、文档完善

后续演进:
- 2025-09-15: 添加分页支持
- 2025-10-01: 添加缓存层

→ 理解设计背后的原因
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **真正的记忆** | 跨会话语义搜索，不是简单的关键词 |
| **本地运行** | 完全离线，保护隐私安全 |
| **自动索引** | 无需手动操作，会话结束自动处理 |
| **向量搜索** | 理解意图，而非字面匹配 |
| **MIT 许可** | 开源免费 |
| **可排除敏感** | 标记不想索引的内容 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **存储占用** | 对话历史会占用磁盘空间 |
| **首次索引慢** | 首次需要处理所有历史对话 |
| **配置复杂** | 需要设置 hook 才能自动同步 |
| **不查代码** | 只搜索对话，不搜索代码库 |
| **依赖 Claude Code** | 主要是 Claude Code 插件 |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 长期项目开发 | ⭐⭐⭐⭐⭐ |
| 复杂代码库 | ⭐⭐⭐⭐⭐ |
| 团队知识传承 | ⭐⭐⭐⭐ |
| 个人项目 | ⭐⭐⭐⭐ |
| 简单脚本/工具 | ⭐⭐ |

---

## 6. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **episodic-memory** | 语义搜索对话历史 | 跨会话记忆 |
| **CLAUDE.md** | 项目规范文档 | 单一项目上下文 |
| **Memory Nodes** | OpenClaw 记忆节点 | 持久化知识库 |
| **MCP Servers** | 工具集成 | 扩展能力 |

### episodic-memory vs 其他

| 特性 | episodic-memory | CLAUDE.md | Memory Nodes |
|-----|-----------------|-----------|--------------|
| 搜索范围 | 对话历史 | 项目规范 | 知识库 |
| 搜索方式 | 语义向量 | 精确匹配 | 语义搜索 |
| 自动索引 | ✅ | ❌ | ❌ |
| 跨会话 | ✅ | ❌ | ✅ |
| 离线可用 | ✅ | ✅ | ✅ |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

episodic-memory 是一个**跨会话语义记忆系统**，通过向量嵌入和 SQLite 实现对话历史的语义搜索能力。

#### 📝 关键发现

1. **语义搜索 vs 关键词**
   - 搜索"provider catalog"能找到关于 API 设计模式的讨论
   - 即使关键词不完全匹配

2. **自动归档机制**
   - session-end hook 自动同步对话
   - 增量更新，只处理新对话

3. **隐私保护**
   - 可用标记排除敏感对话
   - 本地存储，不上传云端

4. **向量嵌入本地化**
   - 使用 Transformers.js
   - 无需 API，无需联网

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | npm 安装正常 |
| 自动索引 | ✅ | hook 配置后自动同步 |
| 语义搜索 | ✅ | 向量搜索工作正常 |
| 隐私保护 | ✅ | 支持排除敏感对话 |
| MCP 集成 | ✅ | Claude Code 集成正常 |

### 使用建议

1. **配置 session-end hook** - 实现自动同步
2. **定期清理** - 删除不需要的旧对话
3. **标记敏感** - 保护隐私
4. **结合 CLAUDE.md** - episodic-memory + 项目规范 = 完整上下文

---

## 8. 常见问题

### Q: episodic-memory 会保存所有对话吗？
A: 默认会索引所有对话。可用 `<INSTRUCTIONS-TO-EPISODIC-MEMORY>DO NOT INDEX THIS CHAT</INSTRUCTIONS-TO-EPISODIC-MEMORY>` 标记排除。

### Q: 搜索结果准确吗？
A: 使用向量相似度搜索，默认返回 top 10 结果。置信度较高。

### Q: 占用多少存储空间？
A: 取决于对话长度和数量。每个对话大约占用几十KB。

### Q: 首次同步需要多久？
A: 首次需要处理所有历史对话，后续只处理新增内容。

### Q: 支持中文对话吗？
A: 支持。语义搜索与语言无关。

---

## 9. 命令参考

```bash
# 同步对话到归档
episodic-memory sync

# 手动索引
episodic-memory index --cleanup

# 语义搜索
episodic-memory search "query"
episodic-memory search --text "exact phrase"
episodic-memory search --after 2025-09-01 "query"

# 查看对话
episodic-memory show conversation.jsonl

# 查看统计
episodic-memory stats

# MCP 服务器（独立使用）
episodic-memory-mcp-server
```

---

## 📎 相关链接

- [GitHub](https://github.com/obra/episodic-memory)
- [superpowers-marketplace](https://githubuperpowers-marketplace.com/obra/s)
- [Transformers.js](https://huggingface.co/docs/transformers.js)
- [sqlite-vec](https://github.com/asg017/sqlite-vec)

---

*让 Claude Code 记住你们的共同旅程* 🧠
