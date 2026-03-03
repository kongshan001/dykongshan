# deep-research - Gemini 深度研究技能

> 使用 Google Gemini Deep Research Agent 执行自主多步骤研究任务

## 📋 文档信息

- **Skill 名称**: deep-research
- **GitHub**: [sanjay3290/ai-skills](https://github.com/sanjay3290/ai-skills)
- **作者**: sanjay3290 (@sanjay3290)
- **许可证**: Apache 2.0
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 研究工具 / AI 助手
- **功能**: 自主多步骤研究、市场分析、竞争分析、文献综述

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **研究效率低** | 手动搜索、阅读、分析信息耗时 | 几小时的工作量 |
| **信息碎片化** | 多来源信息难以整合 | 缺乏结构化报告 |
| **缺乏深度分析** | 标准 LLM 查询缺乏迭代研究 | 结论浅尝辄止 |
| **引用困难** | 手动追踪信息来源 | 难以验证准确性 |

### 目标

**将 Gemini Deep Research 能力封装为可复用的 Skill**：

1. **自主规划** - 根据查询制定研究策略
2. **自动搜索** - 搜索网络并分析来源
3. **智能阅读** - 提取相关信息
4. **迭代优化** - 多轮搜索/阅读循环
5. **结构化输出** - 生成详细、带引用的报告

---

## 2. 设计方案

### 核心架构

```
┌─────────────────┐      ┌──────────────────────┐
│   CLI 脚本      │──────│  DeepResearchClient  │
│  (research.py)  │      │                      │
└─────────────────┘      └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │   Gemini Deep        │
                         │   Research API       │
                         │                      │
                         │  POST /interactions  │
                         │  GET  /interactions  │
                         └──────────────────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │   HistoryManager     │
                         │  (~/.cache/deep-    │
                         │   research/)        │
                         └──────────────────────┘
```

### 工作流程

1. **用户发起研究** → 运行 `--query "..."`
2. **预估时间** → 告知用户 (2-10 分钟)
3. **执行研究** → 规划 → 搜索 → 阅读 → 迭代
4. **实时监控** → 使用 `--stream` 或 `--status`
5. **返回结果** → 格式化报告
6. **跟进研究** → 使用 `--continue` 继续

### 支持的命令

| 命令 | 描述 |
|-----|------|
| `--query` / `-q` | 启动新研究任务 |
| `--stream` | 实时流式输出研究进度 |
| `--status` / `-s` | 检查运行中的任务状态 |
| `--wait` / `-w` | 等待特定任务完成 |
| `--continue` | 从之前的研究继续 |
| `--list` / `-l` | 列出最近的研究任务 |
| `--json` | JSON 格式输出 |
| `--raw` | 原始 API 响应 |

---

## 3. 本地部署

### 环境要求

- Python 3.8+
- httpx: `pip install -r requirements.txt`
- GEMINI_API_KEY 环境变量

### 安装步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/sanjay3290/ai-skills.git
   cd ai-skills/skills/deep-research
   ```

2. **安装依赖**
   ```bash
   pip install -r requirements.txt
   ```

3. **配置 API Key**
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，添加 GEMINI_API_KEY
   ```

4. **获取 Gemini API Key**
   - 访问 [Google AI Studio](https://aistudio.google.com/)
   - 点击 "Get API key"
   - 创建或使用现有密钥
   - 复制到 `.env` 文件

### 快速开始

```bash
# 基本研究查询
python3 scripts/research.py --query "Research the competitive landscape of cloud providers in 2024"

# 实时流式输出
python3 scripts/research.py --query "Compare React, Vue, and Angular frameworks" --stream

# 结构化 JSON 输出
python3 scripts/research.py --query "Analyze the EV market" --json
```

---

## 4. 使用方法

### 基础用法

```bash
# 简单查询
python3 scripts/research.py -q "Research the history of containerization"

# 指定输出格式
python3 scripts/research.py -q "Compare database solutions" \
  --format "1. Executive Summary\n2. Comparison Table\n3. Pros/Cons\n4. Recommendations"

# 不等待结果
python3 scripts/research.py -q "Research topic" --no-wait

# 等待完成
python3 scripts/research.py --wait abc123xyz

# 继续之前的研究
python3 scripts/research.py -q "Elaborate on the networking section" --continue abc123xyz
```

### 典型使用场景

**市场分析**
```bash
python3 scripts/research.py -q "Analyze the competitive landscape of EV battery manufacturers, including market share, technology, and supply chain"
```

**技术研究**
```bash
python3 scripts/research.py -q "Compare Rust vs Go for building high-performance backend services" \
  --format "1. Performance Benchmarks\n2. Memory Safety\n3. Ecosystem\n4. Learning Curve"
```

**尽职调查**
```bash
python3 scripts/research.py -q "Research Company XYZ: recent news, financial performance, leadership changes, and market position"
```

**文献综述**
```bash
python3 scripts/research.py -q "Review recent developments in large language model efficiency and optimization techniques"
```

---

## 5. 效果展示

### 输出示例

执行研究后会生成详细的 Markdown 报告，包含：

```markdown
# 研究报告：云计算竞争格局 2024

## 执行摘要
[简要总结主要发现]

## 市场概况
[市场规模、增长率]

## 主要参与者
### AWS
- 市场份额：xx%
- 核心优势
- 最新动态

### Azure
- 市场份额：xx%
- 核心优势
- 最新动态

### GCP
- 市场份额：xx%
- 核心优势
- 最新动态

## 技术趋势
[技术发展方向]

## 未来展望
[预测和建议]

## 引用来源
1. [Source 1](url)
2. [Source 2](url)
```

### 成本与性能

| 指标 | 值 |
|------|-----|
| 执行时间 | 2-10 分钟/任务 |
| 成本 | $2-5/任务 |
| Token 使用 | ~250k-900k 输入, ~60k-80k 输出 |

---

## 6. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **自主研究** | 自动规划、搜索、阅读、分析 |
| **深度分析** | 多轮迭代，类似人类研究员 |
| **带引用报告** | 自动追踪信息来源 |
| **多种输出格式** | 支持 Markdown、JSON、原始响应 |
| **会话继续** | 支持跟进问题 |
| **本地缓存** | 保存研究历史 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **成本较高** | $2-5/任务，不适合大规模使用 |
| **执行时间长** | 2-10 分钟，简单查询也需等待 |
| **无自定义工具** | 不能使用 MCP 或函数调用 |
| **输出格式依赖提示** | JSON 格式化依赖提示工程 |
| **仅限 Web 研究** | 无法访问私有/认证来源 |
| **60 分钟超时** | 非常复杂的任务可能超时 |

---

## 7. 平替对比

| Skill | 特点 | 适用场景 |
|-------|------|---------|
| **deep-research** | Gemini Deep Research API | 深度市场分析、学术研究 |
| **subagent-driven-development** | 子代理 + 代码审查 | 代码实现任务 |
| **test-driven-development** | TDD 开发模式 | 特性开发、Bug 修复 |
| **planning-with-files** | 持久化规划 | 多步骤复杂任务 |

---

## 8. 配置选项

### 环境变量

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `GEMINI_API_KEY` | (必需) | Google Gemini API 密钥 |
| `DEEP_RESEARCH_TIMEOUT` | `600` | 最大等待时间（秒） |
| `DEEP_RESEARCH_POLL_INTERVAL` | `10` | 状态轮询间隔（秒） |
| `DEEP_RESEARCH_CACHE_DIR` | `~/.cache/deep-research` | 本地历史缓存目录 |

### .env 文件格式

```bash
GEMINI_API_KEY=your-api-key-here
DEEP_RESEARCH_TIMEOUT=600
DEEP_RESEARCH_POLL_INTERVAL=10
```

---

## 9. 错误处理

| 错误 | 原因 | 解决方案 |
|-----|------|---------|
| `GEMINI_API_KEY not set` | 缺少 API 密钥 | 在 `.env` 或环境中设置 |
| `API error 429` | 速率限制 | 等待后重试 |
| `Research timed out` | 任务耗时过长 | 简化查询或增加超时 |
| `Failed to parse result` | 意外响应 | 使用 `--raw` 查看实际输出 |

---

## 10. 落地过程

### 安装验证

1. **克隆并安装**
   ```bash
   git clone https://github.com/sanjay3290/ai-skills.git
   cd ai-skills/skills/deep-research
   pip install -r requirements.txt
   ```

2. **配置 API Key**
   ```bash
   cp .env.example .env
   # 添加你的 GEMINI_API_KEY
   ```

3. **测试运行**
   ```bash
   python3 scripts/research.py -q "测试查询"
   ```

### 实际使用

1. 运行研究任务
2. 等待 2-10 分钟
3. 查看生成的报告
4. 使用 `--continue` 跟进问题

---

## 11. 相关资源

- [Gemini Deep Research 文档](https://ai.google.dev/gemini-api/docs/deep-research)
- [Google AI Studio](https://aistudio.google.com/)
- [Gemini API 定价](https://ai.google.dev/gemini-api/docs/pricing)
- [GitHub 仓库](https://github.com/sanjay3290/ai-skills)

---

*让 AI 成为你的私人研究分析师*
