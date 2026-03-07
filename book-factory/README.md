# book-factory - 非小说类书籍创作流水线

> 让 AI 复制传统出版基础设施，实现从创意到章节架构的完整书籍创作

## 📋 文档信息

- **Skill 名称**: book-factory (Non-Fiction Book Factory)
- **GitHub**: [robertguss/claude-code-toolkit](https://github.com/robertguss/claude-code-toolkit)
- **Star**: ⭐ (part of claude-code-toolkit)
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 书籍创作 / 写作工具

---

## 1. Skill 背景需求

### 问题痛点

写一本书是一个庞大的工程，尤其是非小说类书籍，需要：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **创意模糊** | 想法很多但无法结构化 | 难以形成完整概念 |
| **市场不明** | 不知道是否有读者买单 | 投入大量时间却无人问津 |
| **结构混乱** | 写着写着就偏题了 | 书籍缺乏逻辑连贯性 |
| **研究无序** | 资料太多无法整合 | 内容碎片化 |
| **章节规划粗糙** | 大纲不够细致 | 写作时反复修改 |

### 目标

构建一套**非小说类书籍创作流水线 Skills**，让 AI 帮助作者：

1. **概念开发** - 将模糊想法转化为结构化书籍概念
2. **市场验证** - 在投入大量时间前评估商业可行性
3. **架构设计** - 设计书籍的结构和情感弧线
4. **研究规划** - 系统性地规划和验证研究
5. **章节规划** - 创建细粒度的章节蓝图

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     NON-FICTION BOOK FACTORY                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  PHASE 1: CONCEPT DEVELOPMENT                                           │
│  ┌────────────────┐                                                     │
│  │ book-ideation  │ Develop raw ideas into structured concepts          │
│  └───────┬────────┘                                                     │
│          │ Outputs: Book Concept Document                               │
│          ▼                                                              │
│  PHASE 2: VALIDATION                                                    │
│  ┌───────────────────┐     ┌────────────────────┐                       │
│  │ book-idea-        │────▶│ book-market-       │                       │
│  │ validator         │     │ research           │                       │
│  │ (Research check)  │     │ (KDP viability)    │                       │
│  └─────────┬─────────┘     └──────────┬─────────┘                       │
│            │                          │                                 │
│            └────────────┬─────────────┘                                 │
│                         ▼                                               │
│                [GO/NO-GO DECISION]                                      │
│                         │                                               │
│                         ▼                                               │
│  PHASE 3: ARCHITECTURE                                                  │
│  ┌────────────────┐                                                     │
│  │ book-architect │ Design structural & emotional architecture          │
│  └────────────────┘                                                     │
│          │ Outputs: Master Architecture, Section Blueprints             │
│          ▼                                                              │
│  PHASE 4: RESEARCH                                                      │
│  ┌─────────────────────┐                                                │
│  │ book-research-      │ Plan & validate deep research                  │
│  │ assistant           │                                                │
│  └─────────────────────┘                                                │
│          │ Outputs: Research Synthesis, Chapter Summaries                │
│          ▼                                                              │
│  PHASE 5: CHAPTER PLANNING                                              │
│  ┌─────────────────────┐                                                │
│  │ chapter-architect   │ Plan chapters at beat-level granularity        │
│  └─────────────────────┘                                                │
│          │ Outputs: Chapter Outline Documents                           │
│          ▼                                                              │
│                                                                         │
│                    [READY TO DRAFT]                                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 内置 Skills 详解

| Skill | 功能 | 阶段 | 核心价值 |
|-------|------|------|---------|
| **book-ideation** | 将原始想法转化为结构化书籍概念 | 概念开发 | 定义读者、转变、论点、作者角度等核心元素 |
| **book-idea-validator** | 压力测试书籍概念 | 验证 | 两层研究模型，识别"死亡信号" |
| **book-market-research** | 评估商业可行性 | 验证 | KDP 市场分析，可行性评分卡 |
| **book-architect** | 设计书籍结构 | 架构 | 创建章节级蓝图和情感弧线 |
| **book-research-assistant** | 规划深度研究 | 研究 | 生成研究提示，验证研究输出 |
| **chapter-architect** | 规划单个章节 | 章节规划 | 节拍级大纲，引导写作 |

### Skill 触发机制

```
用户请求 → 匹配对应 Skill → 加载 SKILL.md → 执行工作流
```

**触发示例：**
- "帮我把想法整理成书籍概念" → 触发 `book-ideation`
- "帮我验证这个想法是否值得写" → 触发 `book-idea-validator`
- "做一下市场调研" → 触发 `book-market-research`
- "设计书籍结构" → 触发 `book-architect`
- "规划这一章的大纲" → 触发 `chapter-architect`

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Claude Code** | 最新版本 |
| **网络** | 访问 GitHub 克隆仓库 |
| **Python** | 用于打包 skill (可选) |

### 安装步骤

#### 方式 1: 克隆仓库

```bash
# 克隆 claude-code-toolkit 仓库
git clone https://github.com/robertguss/claude-code-toolkit.git ~/claude-code-toolkit

# 在项目的 CLAUDE.md 中添加引用
echo "When working on a book, read ~/claude-code-toolkit/skills/non-fiction-book-factory/README.md" >> CLAUDE.md
```

#### 方式 2: 打包为 Claude.ai Skill

```bash
# 安装依赖
pip install uv  # 或 pip install uv

# 打包 skill
cd claude-code-toolkit
python build.py non-fiction-book-factory

# 上传到 Claude.ai
# Settings → Skills → Upload dist/non-fiction-book-factory.skill
```

### 配置使用

在 `CLAUDE.md` 中添加：

```markdown
# Book Factory Integration

When working on book projects:
- Use book-ideation for concept development
- Use book-idea-validator for validation
- Use book-market-research for market analysis
- Use book-architect for architecture design
- Use chapter-architect for chapter planning

Reference: ~/claude-code-toolkit/skills/non-fiction-book-factory/
```

### Windows 部署

```powershell
# PowerShell 中执行
git clone https://github.com/robertguss/claude-code-toolkit.git $env:USERPROFILE\claude-code-toolkit
```

### 验证安装

```bash
# 检查目录结构
ls -la ~/claude-code-toolkit/skills/non-fiction-book-factory/

# 在 Claude Code 中测试
# 说："帮我用 book-ideation 整理一个关于 Python 编程的书"
```

---

## 4. 效果展示

### Skill 触发示例

#### 示例 1: 书籍概念开发（book-ideation）

```
用户: "我想写一本关于 Python 异步编程的书"

AI (触发 book-ideation):
"让我帮你将这个想法转化为结构化的书籍概念。

## 核心元素分析

### 1. 目标读者 (The Reader)
谁会读这本书？
- 已有 Python 基础的开发者
- 想深入理解 asyncio 的中高级程序员
- 需要构建高性能 I/O 应用的工程师

### 2. 转变 (Transformation)
读者读完后会发生什么变化？
- 从只会同步编程 → 能够设计和实现异步系统
- 从模糊理解 async/await → 深入理解事件循环原理

### 3. 论点 (Thesis)
你的核心论点是什么？
- 异步编程不是可选技能，而是现代 Python 开发的必备能力

...

→ 输出结构化的 Book Concept Document
```

#### 示例 2: 市场调研（book-market-research）

```
用户: "帮我做一下市场调研"

AI (触发 book-market-research):
"我来分析这本书的商业可行性。

## 市场分析

### 竞争书籍
- 《Fluent Python》: 偏向高级特性，异步只是其中一章
- 《Async Python》: 2024 年新书，偏向入门
- 你的差异化: 实战项目驱动，聚焦生产环境

### 定价分析
- 同类书籍: $39.99-$49.99
- 建议: $44.99

### 可行性评分卡

| 指标 | 得分 | 说明 |
|-----|------|------|
| 市场需求 | 8/10 | 异步是热点话题 |
| 竞争程度 | 6/10 | 有竞争但有差异化 |
| 作者资历 | 7/10 | 需要突出背景 |
| 定价空间 | 7/10 | 中等偏高 |
| KDP 潜力 | 8/10 | 技术书销量稳定 |

**综合评分: 72/100 → 建议出版**

→ 输出市场调研报告
```

#### 示例 3: 章节规划（chapter-architect）

```
用户: "帮我规划第一章"

AI (触发 chapter-architect):
"我来为第一章创建节拍级大纲。

## 第一章：异步编程入门

### 章节上下文
- 位置: 第 1 章 (全书开篇)
- 目标: 激发兴趣，建立基础

### 读者旅程
```
好奇 → 惊讶 → 理解 → 期待
```

### 节拍序列

#### Beat 1: 场景引入 (500字)
- 开场场景: 一个同步阻塞导致的性能问题
- 展示痛苦: "为什么我的 API 这么慢？"

#### Beat 2: 对比展示 (800字)
- 同步 vs 异步代码对比
- 直观展示异步的优势

#### Beat 3: 核心概念 (1200字)
- 事件循环介绍
- 协程 vs 线程

#### Beat 4: 第一个例子 (800字)
- 最小可运行的 async 代码
- 手把手教学

#### Beat 5: 小结与过渡 (400字)
- 本章要点回顾
- 下一章预告

→ 输出详细的 Chapter Outline Document
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **完整流水线** | 覆盖从概念到章节规划全流程 |
| **质量保证** | 每个阶段有明确产出物 |
| **决策科学** | Go/No-Go 决策基于数据 |
| **模块化** | 可单独使用某个 Skill |
| **研究支持** | 深度研究规划和验证 |
| **情感设计** | 关注读者阅读体验 |
| **MIT 许可** | 开源免费 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **不包括写作** | 流水线只到章节规划，不含实际写作 |
| **需要人工投入** | 验证和研究阶段需要作者参与 |
| **KDP 聚焦** | 市场调研主要针对亚马逊自助出版 |
| **非小说限定** | 不适合小说创作 |
| **学习曲线** | 需要理解 6 个 Skill 的关系 |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 技术书籍创作 | ⭐⭐⭐⭐⭐ |
| 商业/管理书籍 | ⭐⭐⭐⭐⭐ |
| 教程/指南编写 | ⭐⭐⭐⭐ |
| 学术著作 | ⭐⭐⭐ |
| 小说创作 | ⭐ |

---

## 6. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **book-factory** | 完整出版流水线 | 非小说书籍创作 |
| **writing skill** | 写作和幽灵写作 | 内容创作 |
| **ebook-factory** | 电子书创建 | 快速出版 |
| **Claude 原生** | 通用写作辅助 | 日常写作 |

### book-factory vs 其他

| 特性 | book-factory | ebook-factory | writing skill |
|-----|-------------|--------------|---------------|
| 覆盖范围 | 概念→规划 | 规划→出版 | 写作辅助 |
| 市场调研 | ✅ | ❌ | ❌ |
| 研究规划 | ✅ | ❌ | ❌ |
| 章节架构 | ✅ | ❌ | ❌ |
| 出版支持 | ❌ | ✅ | ❌ |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

book-factory 是一套**非小说类书籍创作流水线**，通过 6 个专业化 Skills 复制传统出版基础设施。

#### 📝 关键发现

1. **阶段化工作流**
   - 5 个主要阶段：概念开发→验证→架构→研究→章节规划
   - 每个阶段产出明确的文档

2. **Go/No-Go 决策**
   - book-idea-validator 提供学术可行性
   - book-market-research 提供商业可行性
   - 两个报告一起支撑决策

3. **结构与情感并重**
   - book-architect 不仅设计内容结构
   - 还设计读者的情感旅程

4. **研究系统化**
   - book-research-assistant 生成研究提示
   - 可与 Claude/Gemini 配合执行研究

5. **节拍级规划**
   - chapter-architect 提供非常细粒度的大纲
   - 包括开场/收尾设计

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 仓库可访问 | ✅ | GitHub 仓库正常 |
| 文档完整 | ✅ | 6 个 Skills 都有 README |
| 架构清晰 | ✅ | 流水线设计合理 |
| 模块化 | ✅ | 可单独使用 |
| 与 Claude Code 兼容 | ✅ | 标准 Skill 格式 |

### 使用建议

1. **从概念开始** - 按流水线顺序使用，不要跳阶段
2. **认真对待验证** - 市场调研和概念验证值得投入
3. **迭代优化** - 概念和架构可以多轮迭代
4. **结合写作** - 完成规划后可使用 writing skill 开始写作

---

## 8. 常见问题

### Q: book-factory 会帮我写书吗？
A: 不会。它只负责到章节规划为止。写作阶段可以使用同仓库的 `writing` skill。

### Q: 可以只用其中某个 Skill 吗？
A: 可以。每个 Skill 都是独立的，可以按需使用。

### Q: 适合中文书籍吗？
A: 适合。流水线是通用的，但市场调研主要针对英文 KDP 市场。

### Q: 和专业的写作软件有什么区别？
A: book-factory 专注于非小说类书籍的前期规划，不涉及实际写作和出版。

### Q: 需要多少时间完成整个流水线？
A: 取决于书籍复杂度和个人速度。一般而言：
- 概念开发: 1-2 小时
- 验证: 2-4 小时
- 架构: 2-3 小时
- 研究: 数天到数周
- 章节规划: 每章 30 分钟

---

## 📎 相关链接

- [GitHub](https://github.com/robertguss/claude-code-toolkit)
- [Book Factory 文档](https://robertguss.github.io/claude-skills/skills/non-fiction-book-factory/)
- [在线文档](https://robertguss.github.io/claude-skills/)

---

*让 AI 成为你的书籍创作合伙人* 📚
