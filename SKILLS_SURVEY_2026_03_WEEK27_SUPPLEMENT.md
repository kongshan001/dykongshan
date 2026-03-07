# Claude Code Skills 补充调研报告 - 2026年3月 (第二十七周补充)

**调研日期**: 2026-03-04  
**数据来源**: skills.sh 官方排行榜 + GitHub 热门仓库  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 skills.sh 官方排行榜分析

### TOP 20 Skills (All Time)

| 排名 | Skill | 安装量 | 所属组织 | 核心能力 |
|------|-------|--------|---------|---------|
| 1 | find-skills | 391.6K | vercel-labs | 技能发现和推荐 |
| 2 | vercel-react-best-practices | 188.1K | vercel-labs | React 最佳实践 |
| 3 | web-design-guidelines | 145.2K | vercel-labs | Web 设计指南 |
| 4 | azure-ai | 123.5K | microsoft | Azure AI 服务 |
| 5 | azure-observability | 123.3K | microsoft | Azure 监控 |
| 6 | azure-cost-optimization | 123.3K | microsoft | Azure 成本优化 |
| 7 | azure-storage | 123.3K | microsoft | Azure 存储 |
| 8 | azure-deploy | 123.3K | microsoft | Azure 部署 |
| 9 | azure-diagnostics | 123.3K | microsoft | Azure 诊断 |
| 10 | microsoft-foundry | 123.2K | microsoft | Microsoft Foundry |
| 11 | entra-app-registration | 123.2K | microsoft | Entra 应用注册 |
| 12 | remotion-best-practices | 123.2K | remotion-dev | Remotion 视频开发 |
| 13 | appinsights-instrumentation | 123.2K | microsoft | App Insights |
| 14 | azure-resource-visualizer | 123.2K | microsoft | Azure 资源可视化 |
| 15 | azure-kusto | 123.2K | microsoft | Azure Kusto |
| 16 | azure-compliance | 123.2K | microsoft | Azure 合规 |
| 17 | azure-validate | 123.2K | microsoft | Azure 验证 |
| 18 | azure-rbac | 123.2K | microsoft | Azure RBAC |
| 19 | azure-prepare | 123.2K | microsoft | Azure 准备 |
| 20 | azure-aigateway | 123.2K | microsoft | Azure AI Gateway |

### 关键发现

1. **Microsoft Azure 系列 Skills 占据主导地位** - 20 个中有 17 个是 Azure 相关
2. **Vercel Labs 是最大的非企业贡献者** - find-skills 排名第一 (391.6K 安装量)
3. **Web 开发 Skills 仍然最受欢迎** - React/设计指南排名靠前

---

## 🎮 一、游戏开发 Skills 深度分析

### 1.1 Claude Code Game Studios (2026 年重磅发现)

**项目地址**: [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)  
**GitHub Stars**: 28⭐ (2026年2月新增)  
**定位**: "将单个 Claude Code 会话转变为完整的游戏开发工作室"

#### 核心组成

| 组件 | 数量 | 描述 |
|------|------|------|
| Agents | 48 | 跨设计、程序、美术、音频、叙事、QA 和制作的专门子代理 |
| Skills | 36 | 常见工作流的斜杠命令 (/start, /sprint-plan, /code-review 等) |
| Hooks | 8 | 自动化验证（提交、推送、资产变更、会话生命周期等） |
| Rules | 11 | 路径范围的编码标准 |
| Templates | 28 | 文档模板（GDD、ADR、冲刺计划等） |

#### 工作室层级架构

**Tier 1 - 总监 (Opus)**
- creative-director (创意总监)
- technical-director (技术总监)
- producer (制作人)

**Tier 2 - 部门主管 (Sonnet)**
- game-designer (游戏设计师)
- lead-programmer (首席程序员)
- art-director (美术总监)
- audio-director (音频总监)
- narrative-director (叙事总监)
- qa-lead (QA 主管)
- release-manager (发布经理)
- localization-lead (本地化主管)

**Tier 3 - 专家 (Sonnet/Haiku)**
- gameplay-programmer (游戏玩法程序员)
- engine-programmer (引擎程序员)
- ai-programmer (AI 程序员)
- network-programmer (网络程序员)
- tools-programmer (工具程序员)
- ui-programmer (UI 程序员)
- systems-designer (系统设计师)
- level-designer (关卡设计师)
- economy-designer (经济设计师)
- technical-artist (技术美术)
- sound-designer (音效设计师)
- writer (编剧)
- world-builder (世界构建师)
- ux-designer (UX 设计师)
- prototyper (原型师)
- performance-analyst (性能分析师)
- devops-engineer (DevOps 工程师)
- analytics-engineer (分析工程师)
- security-engineer (安全工程师)
- qa-tester (QA 测试员)
- accessibility-specialist (无障碍专家)
- live-ops-designer (长线运营设计师)
- community-manager (社区经理)

#### 引擎支持

| 引擎 | 主代理 | 子专家 |
|------|--------|--------|
| Godot 4 | godot-specialist | GDScript, Shaders, GDExtension |
| Unity | unity-specialist | DOTS/ECS, Shaders/VFX, Addressables, UI Toolkit |
| Unreal Engine 5 | unreal-specialist | GAS, Blueprints, Replication, UMG/CommonUI |

#### 36 个斜杠命令分类

**Reviews & Analysis**
- /design-review - 设计审查
- /code-review - 代码审查
- /balance-check - 平衡性检查
- /asset-audit - 资产审计
- /scope-check - 范围检查
- /perf-profile - 性能分析
- /tech-debt - 技术债务

**Production**
- /sprint-plan - 冲刺计划
- /milestone-review - 里程碑审查
- /estimate - 估算
- /retrospective - 回顾
- /bug-report - Bug 报告

**Project Management**
- /start - 开始
- /project-stage-detect - 项目阶段检测
- /reverse-document - 反向文档
- /gate-check - 门禁检查
- /design-systems - 系统设计

**Release**
- /release-checklist - 发布清单
- /launch-checklist - 启动清单
- /changelog - 变更日志
- /patch-notes - 补丁说明
- /hotfix - 热修复

**Creative**
- /brainstorm - 头脑风暴
- /playtest-report - 游戏测试报告
- /prototype - 原型
- /onboard - 入职
- /localize - 本地化

**Team Orchestration**
- /team-combat - 战斗团队
- /team-narrative - 叙事团队
- /team-ui - UI 团队
- /team-release - 发布团队
- /team-polish - 打磨团队
- /team-audio - 音频团队
- /team-level - 关卡团队

#### 设计哲学

1. **MDA Framework** - 机制、动态、美学分析
2. **Self-Determination Theory** - 自主性、胜任感、关联感
3. **Flow State Design** - 挑战-技能平衡
4. **Bartle Player Types** - 玩家类型分析
5. **Verification-Driven Development** - 测试先行

#### 安装使用

```bash
# 克隆或使用模板
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game
cd my-game

# 打开 Claude Code
claude

# 运行 /start 开始
```

### 1.2 Ricko12vPL/claude-code-skills (Python & 量化金融)

**项目地址**: [Ricko12vPL/claude-code-skills](https://github.com/Ricko12vPL/claude-code-skills)  
**GitHub Stars**: 6⭐  
**定位**: "专业的 Claude Code Skills，符合 Anthropic 官方规范"

#### 包含的 Skills

| Skill | 大小 | 章节数 | 代码示例数 | 主要主题 |
|-------|------|--------|-----------|---------|
| Python Programming | 12 KB | 15 | 30+ | PEP 8, testing, async, patterns |
| Software Engineering | 28 KB | 20 | 40+ | SOLID, architecture, CI/CD |
| Machine Learning | 27 KB | 25 | 50+ | ML workflow, PyTorch, MLOps |
| Quantitative Finance | 58 KB | 18 | 60+ | Trading, backtesting, portfolio |
| Senior Quant Developer | 3 KB | 9 | 3 | Low-latency, observability |
| Senior Quant Researcher | 2.5 KB | 9 | 3 | Alpha research, validation |
| Senior Systematic Trader | 2 KB | 9 | 3 | TCA, execution, governance |
| Senior Quant Trader | 2 KB | 9 | 3 | Portfolio, attribution, KPIs |
| **总计** | **~135 KB** | **~105** | **~190+** | **8 Skills** |

#### Python Programming Skill 特性

```markdown
- ✅ PEP 8, PEP 257, PEP 484 (style, docstrings, type hints)
- ✅ 项目结构 (pyproject.toml)
- ✅ 现代特性 (dataclasses, context managers, async/await)
- ✅ 设计模式 (Singleton, Factory, Decorator, Observer)
- ✅ 错误处理和自定义异常
- ✅ pytest 测试 (fixtures, parametrize, mocking)
- ✅ 性能优化 (comprehensions, generators, profiling)
- ✅ 异步编程 (asyncio, async context managers)
- ✅ 依赖管理
- ✅ 最佳实践清单
```

#### Machine Learning Skill 特性

```markdown
- ✅ 完整 ML 工作流 (data → deployment)
- ✅ 数据预处理 (missing data, outliers, scaling, encoding)
- ✅ 特征工程 (creation, selection, importance)
- ✅ 经典 ML 算法 (Linear, Trees, SVM, KNN, Naive Bayes)
- ✅ 集成方法 (Random Forest, XGBoost, LightGBM, CatBoost)
- ✅ 模型评估 (classification & regression metrics)
- ✅ 超参数调优 (Grid, Random, Bayesian)
- ✅ 深度学习 PyTorch (Neural Networks, CNN, RNN/LSTM)
- ✅ 迁移学习
- ✅ MLOps (serialization, versioning, monitoring)
- ✅ 模型部署 (FastAPI, Docker)
```

#### Quantitative Finance Skill 特性

```markdown
- ✅ 量化研究框架 (alpha research, backtesting)
- ✅ 交易系统架构 (OMS, execution systems)
- ✅ 统计方法 (time series, GARCH, cointegration)
- ✅ 因子模型 (multi-factor attribution)
- ✅ 机器学习交易 (feature engineering, ML models)
- ✅ 专业回测引擎
- ✅ 市场微观结构 (order book analysis, execution optimization)
- ✅ 投资组合优化 (mean-variance, risk parity, Black-Litterman)
- ✅ 风险管理 (VaR, position sizing, Kelly criterion)
- ✅ 生产部署 (monitoring, alerting, reconciliation)
- ✅ 量化开发最佳实践
```

#### 安装使用

```bash
# Personal Skills (全局可用)
cp -r python-programming software-engineering machine-learning quantitative-finance ~/.claude/skills/

# Project Skills (仅项目内)
mkdir -p .claude/skills
cp -r python-programming software-engineering machine-learning quantitative-finance .claude/skills/
```

---

## 🐍 二、Python 开发 Skills 排行榜

### 2.1 skills.sh Python 相关 Skills

| 排名 | Skill | 安装量 | 核心能力 |
|------|-------|--------|---------|
| 1 | python-executor | 13.4K | Python 代码执行 |
| 2 | python-sdk | 13.2K | Python SDK |
| 3 | python-performance-optimization | 7.1K | Python 性能优化 |
| 4 | nodejs-backend-patterns | 7.3K | Node.js 后端模式 |
| 5 | architecture-patterns | 6.7K | 架构模式 |

### 2.2 Python 开发 Skills 详细分类

#### Python 基础 Skills

| Skill | 核心能力 | 适用场景 |
|-------|---------|---------|
| python-programming | PEP 8, testing, async, patterns | 通用 Python 开发 |
| python-pro | Python 3.12+ 现代特性，uv/ruff | 现代化项目 |
| python-patterns | 框架选择、类型提示、项目结构 | 架构设计 |
| python-testing-patterns | pytest 测试策略 | 质量保证 |
| python-performance-optimization | 性能分析和优化 | 性能调优 |

#### Python Web 框架 Skills

| Skill | 核心能力 | 安装量 |
|-------|---------|--------|
| fastapi | 高性能异步 Web 框架 | 1.054-1.121 评分 |
| django-best-practices | 全栈框架最佳实践 | - |
| flask-patterns | 轻量级框架模式 | - |

#### Python 异步 Skills

| Skill | 核心能力 |
|-------|---------|
| async-python-patterns | asyncio 异步编程 |
| temporal-python-pro | Temporal 工作流编排 |
| dbos-python | DBOS 可靠工作流 |

#### Python ML/AI Skills

| Skill | 核心能力 |
|-------|---------|
| machine-learning | 完整 ML 工作流 |
| pytorch-deep-learning | PyTorch 深度学习 |
| llm-models | LLM 模型使用 |

---

## 🧪 三、测试自动化 Skills 排行榜

### 3.1 skills.sh 测试相关 Skills

| 排名 | Skill | 安装量 | 核心能力 |
|------|-------|--------|---------|
| 1 | webapp-testing | 17.7K | Web 应用测试 |
| 2 | test-driven-development | 17.5K | TDD 开发流程 |
| 3 | verification-before-completion | 12.5K | 完成前验证 |
| 4 | requesting-code-review | 15.8K | 请求代码审查 |
| 5 | receiving-code-review | 12.6K | 接收代码审查 |
| 6 | vitest | 7.1K | Vitest 测试框架 |
| 7 | code-review-excellence | 6.3K | 代码审查卓越 |

### 3.2 测试 Skills 详细分类

#### Web 应用测试

| Skill | 核心能力 | 评分 |
|-------|---------|------|
| webapp-testing | Web 应用完整测试 | 17.7K 安装 |
| playwright | 浏览器自动化测试 | 3.538-3.584 |
| playwright-mcp | Playwright MCP 服务器 | 3.581 |
| e2e-testing-patterns | E2E 测试模式 | - |

#### TDD & 代码质量

| Skill | 核心能力 | 安装量 |
|-------|---------|--------|
| test-driven-development | TDD 开发流程 | 17.5K |
| test-automator | AI 驱动测试自动化 | - |
| systematic-debugging | 系统化调试 | 21.4K |

#### 游戏客户端测试

| Skill | 核心能力 |
|-------|---------|
| unity-test-framework | Unity 测试框架 |
| godot-testing | Godot 测试 |
| android-adb | Android ADB 测试 (1.220 评分, TOP 1) |
| mobile-game-testing | 移动端游戏测试 |

---

## 🛠️ 四、开发者工具 Skills 排行榜

### 4.1 skills.sh 开发者工具 Skills

| 排名 | Skill | 安装量 | 核心能力 |
|------|-------|--------|---------|
| 1 | find-skills | 391.6K | 技能发现和推荐 |
| 2 | agent-tools | 99.5K | 代理工具集 |
| 3 | agent-browser | 97.6K | 浏览器自动化 |
| 4 | ai-image-generation | 97.2K | AI 图像生成 |
| 5 | ai-video-generation | 96.9K | AI 视频生成 |
| 6 | twitter-automation | 96.2K | Twitter 自动化 |
| 7 | skill-creator | 58.9K | 技能创建器 |
| 8 | browser-use | 44.7K | 浏览器使用 |
| 9 | systematic-debugging | 21.4K | 系统化调试 |
| 10 | webapp-testing | 17.7K | Web 应用测试 |

### 4.2 开发者工具 Skills 详细分类

#### 代码质量

| Skill | 核心能力 | 安装量 |
|-------|---------|--------|
| systematic-debugging | 系统化调试 | 21.4K |
| code-review-excellence | 代码审查卓越 | 6.3K |
| requesting-code-review | 请求代码审查 | 15.8K |
| receiving-code-review | 接收代码审查 | 12.6K |
| verification-before-completion | 完成前验证 | 12.5K |

#### 自动化工具

| Skill | 核心能力 | 安装量 |
|-------|---------|--------|
| agent-browser | 浏览器自动化 | 97.6K |
| twitter-automation | Twitter 自动化 | 96.2K |
| ai-automation-workflows | AI 自动化工作流 | 7.4K |
| browser-use | 浏览器使用 | 44.7K |

#### 文档工具

| Skill | 核心能力 | 安装量 |
|-------|---------|--------|
| pdf | PDF 处理 | 26.9K |
| docx | Word 文档 | 20.8K |
| xlsx | Excel 表格 | 19.7K |
| pptx | PowerPoint | 22.8K |
| doc-coauthoring | 文档协作 | 11.1K |

#### 创意工具

| Skill | 核心能力 | 安装量 |
|-------|---------|--------|
| ai-image-generation | AI 图像生成 | 97.2K |
| ai-video-generation | AI 视频生成 | 96.9K |
| algorithmic-art | 算法艺术 | 11.2K |
| canvas-design | 画布设计 | 13.7K |
| theme-factory | 主题工厂 | 10.9K |

---

## 📈 五、趋势分析与建议

### 5.1 2026 年 Skills 发展趋势

1. **AI 原生开发工具持续增长**
   - agent-browser (97.6K 安装)
   - ai-image-generation (97.2K 安装)
   - ai-video-generation (96.9K 安装)

2. **游戏开发 Skills 质量提升**
   - Claude Code Game Studios (48 agents + 36 skills)
   - Unity AI Workflow 2026 (专为 AI 设计)

3. **Python 生态系统完善**
   - Python Programming (12 KB, 30+ 代码示例)
   - Machine Learning (27 KB, 50+ 代码示例)
   - Quantitative Finance (58 KB, 60+ 代码示例)

4. **测试自动化重视程度提高**
   - webapp-testing (17.7K 安装)
   - test-driven-development (17.5K 安装)

### 5.2 Skills 缺口分析

| 方向 | 缺口 | 建议方案 |
|------|------|---------|
| 游戏客户端自动化测试 | Unity/Unreal 专门测试 Skills 较少 | 开发 Unity Test Framework + Playwright 集成 Skill |
| 帧同步测试 | 确定性测试、录像回放缺乏指导 | 开发 game-frame-sync-tester Skill |
| 游戏性能基准 | 帧率、内存、加载时间测试缺乏 | 开发 unity-performance-benchmark Skill |
| 跨平台游戏测试 | 移动端/iOS/Android 测试整合 | 开发 mobile-game-testing Skill |

### 5.3 推荐自建 Skills

1. **game-frame-sync-tester** - 帧同步确定性测试
   - 确定性验证
   - 录像回放
   - 网络延迟模拟
   - 断线重连测试

2. **unity-performance-benchmark** - Unity 性能基准测试
   - 帧率监控
   - 内存分析
   - 加载时间测试
   - 性能回归检测

3. **godot-4-advanced** - Godot 4 高级开发
   - GDScript 2.0 最佳实践
   - 节点系统深入
   - 信号机制
   - 资源管理

4. **mobile-game-testing** - 移动端游戏测试
   - Android/iOS 自动化
   - 触控响应测试
   - 设备兼容性
   - 性能监控

---

## 📎 附录

### A. Anthropic 官方 Skills 列表

| Skill | 类别 | 核心能力 |
|-------|------|---------|
| algorithmic-art | Creative | 算法艺术生成 |
| brand-guidelines | Enterprise | 品牌指南 |
| canvas-design | Creative | 画布设计 |
| doc-coauthoring | Enterprise | 文档协作 |
| docx | Document | Word 文档处理 |
| frontend-design | Development | 前端设计 |
| internal-comms | Enterprise | 内部沟通 |
| mcp-builder | Development | MCP 服务器构建 |
| pdf | Document | PDF 处理 |
| pptx | Document | PowerPoint 处理 |
| skill-creator | Development | 技能创建器 |
| slack-gif-creator | Creative | Slack GIF 创建 |
| theme-factory | Creative | 主题工厂 |
| web-artifacts-builder | Development | Web 组件构建 |
| webapp-testing | Development | Web 应用测试 |
| xlsx | Document | Excel 处理 |

### B. skills.sh 安装命令

```bash
# 安装特定 Skill
npx skills add <owner/repo>

# 示例
npx skills add vercel-labs/skills/find-skills
npx skills add anthropics/skills/webapp-testing
npx skills add Ricko12vPL/claude-code-skills
```

### C. Claude Code Game Studios 快速开始

```bash
# 克隆模板
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game
cd my-game

# 启动 Claude Code
claude

# 运行开始命令
/start
```

### D. Ricko12vPL Skills 安装

```bash
# 克隆仓库
git clone https://github.com/Ricko12vPL/claude-code-skills.git

# 全局安装
cp -r python-programming software-engineering machine-learning quantitative-finance ~/.claude/skills/

# 项目安装
mkdir -p .claude/skills
cp -r python-programming software-engineering machine-learning quantitative-finance .claude/skills/
```

---

## 🎯 本周调研总结

### 核心发现

1. **skills.sh 排行榜揭示真实需求**
   - Microsoft Azure 系列 Skills 占据 TOP 20 中的 17 席
   - find-skills (391.6K) 是最受欢迎的 Skill
   - AI 自动化工具 (agent-browser, ai-image-generation) 增长迅速

2. **游戏开发 Skills 质量飞跃**
   - Claude Code Game Studios: 48 agents + 36 skills，完整工作室架构
   - Unity AI Workflow 2026: 专为 AI 助手设计的三种开发模式
   - 引擎支持全面: Godot 4 / Unity / Unreal Engine 5

3. **Python Skills 专业化程度高**
   - Ricko12vPL 提供 8 个专业 Skills，总计 ~135 KB
   - 涵盖 Python 基础、软件工程、机器学习、量化金融
   - 量化金融 Skills 包含 4 个高级角色 Skills

4. **测试自动化重视度提升**
   - webapp-testing (17.7K) 和 TDD (17.5K) 排名靠前
   - Playwright 系列 Skills 评分稳定 (3.538-3.584)
   - 游戏客户端测试仍存在缺口

### 下一步行动

1. ✅ 推送本补充报告到 cc_skills 仓库
2. 🔄 继续调研 skills.sh Trending Skills
3. 🔄 关注 AI 原生开发工具发展
4. 📝 规划自建 Skills 开发计划

---

*文档更新于 2026-03-04*
*数据来源: skills.sh + GitHub + Anthropic 官方*
