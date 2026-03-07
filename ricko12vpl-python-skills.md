# Ricko12vPL Python Skills 专业技能包

> 专业的 Claude Code Skills，符合 Anthropic 官方规范

## 1. 背景需求

需要高质量的 Python、软件工程、机器学习和量化金融 Skills，符合 Anthropic 官方规范。

## 2. 目标

提供 8 个专业技能，总计 ~135 KB，190+ 代码示例。

## 3. 设计方案

### 3.1 包含的 Skills

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

### 3.2 Python Programming Skill

**何时使用**: 编写、重构、调试 Python 代码

**包含内容**:
- ✅ PEP 8, PEP 257, PEP 484 (style, docstrings, type hints)
- ✅ Python 项目结构 (pyproject.toml)
- ✅ 现代特性 (dataclasses, context managers, async/await)
- ✅ 设计模式 (Singleton, Factory, Decorator, Observer)
- ✅ 错误处理和自定义异常
- ✅ pytest 测试 (fixtures, parametrize, mocking)
- ✅ 性能优化 (comprehensions, generators, profiling)
- ✅ 异步编程 (asyncio, async context managers)
- ✅ 依赖管理
- ✅ 最佳实践清单

**使用示例**:
```python
"写一个带类型提示的 Python 函数"
→ Claude 自动使用: python-programming

"创建一个 REST API 使用 FastAPI 和类型提示"
→ Claude 自动使用: python-programming + software-engineering
```

### 3.3 Software Engineering Skill

**何时使用**: 系统设计、代码审查、架构

**包含内容**:
- ✅ SOLID 原则（所有 5 个带示例）
- ✅ 架构模式（分层、微服务、事件驱动、CQRS）
- ✅ 设计模式（创建型、结构型、行为型）
- ✅ Clean Code 原则
- ✅ 测试策略（测试金字塔、单元、集成、E2E）
- ✅ CI/CD 最佳实践（GitHub Actions、pre-commit hooks）
- ✅ API 设计（RESTful、版本控制）
- ✅ 数据库设计（规范化、索引、迁移）
- ✅ 监控和可观测性
- ✅ 安全最佳实践

**使用示例**:
```python
"设计微服务架构"
→ Claude 自动使用: software-engineering

"部署 ML 模型到生产环境"
→ Claude 自动使用: machine-learning + software-engineering
```

### 3.4 Machine Learning Skill

**何时使用**: 构建 ML/DL 模型、训练、部署

**包含内容**:
- ✅ 完整 ML 工作流（data → deployment）
- ✅ 数据预处理（missing data, outliers, scaling, encoding）
- ✅ 特征工程（creation, selection, importance）
- ✅ 经典 ML 算法（Linear, Trees, SVM, KNN, Naive Bayes）
- ✅ 集成方法（Random Forest, XGBoost, LightGBM, CatBoost）
- ✅ 模型评估（classification & regression metrics）
- ✅ 超参数调优（Grid, Random, Bayesian）
- ✅ 深度学习 PyTorch（Neural Networks, CNN, RNN/LSTM）
- ✅ 迁移学习
- ✅ MLOps（serialization, versioning, monitoring）
- ✅ 模型部署（FastAPI, Docker）

**使用示例**:
```python
"创建一个 XGBoost 分类模型"
→ Claude 自动使用: machine-learning

"部署 ML 模型到生产环境"
→ Claude 自动使用: machine-learning + software-engineering
```

### 3.5 Quantitative Finance Skill

**何时使用**: 交易算法、量化研究、系统化交易

**包含内容**:
- ✅ 量化研究框架（alpha research, backtesting）
- ✅ 交易系统架构（OMS, execution systems）
- ✅ 统计方法（time series, GARCH, cointegration）
- ✅ 因子模型（multi-factor attribution）
- ✅ 机器学习交易（feature engineering, ML models）
- ✅ 专业回测引擎
- ✅ 市场微观结构（order book analysis, execution optimization）
- ✅ 投资组合优化（mean-variance, risk parity, Black-Litterman）
- ✅ 风险管理（VaR, position sizing, Kelly criterion）
- ✅ 生产部署（monitoring, alerting, reconciliation）
- ✅ 量化开发最佳实践

**使用示例**:
```python
"构建一个带有订单管理的交易系统"
→ Claude 自动使用: quantitative-finance + python-programming

"使用 mean-variance 优化投资组合"
→ Claude 自动使用: quantitative-finance
```

### 3.6 高级量化角色 Skills

#### Senior Quantitative Developer

**何时使用**: 低延迟基础设施、性能优化

**包含内容**:
- 低延迟基础设施（market data, execution, risk）
- 性能优化（P50/P95/P99 latency, throughput）
- 生产加固（observability, CI/CD, incident response）
- 技术栈: C++20/23, Python, Bazel/CMake, DPDK/XDP, kdb+/q

**使用示例**:
```python
"将市场数据处理器 P99 延迟降低到 < 100 µs"
→ Claude 自动使用: senior-quantitative-developer
```

#### Senior Quantitative Researcher

**何时使用**: Alpha 研究管道、偏差安全回测

**包含内容**:
- Alpha 研究管道（hypothesis → validation → production）
- 偏差安全回测（look-ahead, survivorship, costs）
- Walk-forward、容量建模、live↔backtest 跟踪
- 技术栈: Python, pandas/NumPy, scikit-learn, PyTorch, kdb+/q

**使用示例**:
```python
"为 mean-reversion 进行 walk-forward 验证并带偏差检查"
→ Claude 自动使用: senior-quantitative-researcher
```

#### Senior Systematic Trader

**何时使用**: 实时 PnL 所有权、执行管理

**包含内容**:
- 实时 PnL 所有权和执行管理
- TCA 优化（venue, order type, timing）
- Canary rollout/rollback 与治理
- 技术栈: Python, SQL/kdb+, OMS/EMS, Grafana

**使用示例**:
```python
"构建 TCA 仪表板并优化执行参数"
→ Claude 自动使用: senior-systematic-trader
```

#### Senior Quantitative Trader

**何时使用**: 投资组合级策略所有权

**包含内容**:
- 投资组合级策略所有权
- KPI 跟踪（PnL, Sharpe, MAR, maxDD）
- 归因（alpha/beta/costs）和 sizing/hedging
- 技术栈: Python, SQL/kdb+, portfolio analytics, dashboards

**使用示例**:
```python
"准备归因分析并推荐投资组合调整"
→ Claude 自动使用: senior-quantitative-trader
```

## 4. 本地部署

```bash
# 克隆仓库
git clone https://github.com/Ricko12vPL/claude-code-skills.git

# Personal Skills (全局可用)
cp -r python-programming software-engineering machine-learning quantitative-finance ~/.claude/skills/

# Project Skills (仅项目内)
mkdir -p .claude/skills
cp -r python-programming software-engineering machine-learning quantitative-finance .claude/skills/

# 验证安装
ls ~/.claude/skills/
# 应该看到:
# python-programming/
# software-engineering/
# machine-learning/
# quantitative-finance/
```

## 5. 效果展示

- GitHub Stars：⭐ 6
- Skills 数量：8 个
- 总大小：~135 KB
- 代码示例：~190+
- 章节：~105

## 6. 优缺点

✅ 符合 Anthropic 官方规范 ✅ 完整的量化金融覆盖 ✅ 详细的代码示例  
⚠️ Star 较少 ⚠️ 较新项目

## 7. 平替

| 项目 | 特点 |
|------|------|
| python-pro | 现代 Python 特性 |
| python-patterns | 框架选择 |
| temporal-python-pro | Temporal 工作流 |

## 8. Anthropic 规范合规性

所有 Skills 符合官方要求：

- ✅ Frontmatter limits: name ≤64, description ≤1024 字符
- ✅ Structured format: Instructions → Tools → Examples → References
- ✅ Progressive disclosure design
- ✅ Composable with other Skills

## 9. 典型使用场景

### 9.1 Python 开发

```
"写一个带类型提示的 Python 函数"
→ python-programming
```

### 9.2 软件工程

```
"设计微服务架构"
→ software-engineering
```

### 9.3 机器学习

```
"创建一个 XGBoost 分类模型"
→ machine-learning
```

### 9.4 量化金融

```
"构建一个带有订单管理的交易系统"
→ quantitative-finance + python-programming
```

### 9.5 高级量化

```
"将市场数据处理器 P99 延迟降低到 < 100 µs"
→ senior-quantitative-developer
```

### 9.6 复杂场景

```
"构建完整的交易系统：
1. Mean reversion 策略与统计测试
2. 回测框架与真实成本
3. 风险管理与 Kelly criterion
4. 订单管理系统
5. 生产部署与监控"

Claude 将使用:
✓ quantitative-finance (strategy, backtesting, risk, OMS)
✓ python-programming (clean code, type hints, async)
✓ software-engineering (architecture, deployment, monitoring)
```

## 10. 快速测试

### 10.1 基础测试

```python
# 在 Claude Code 中
"写一个带有交易成本和滑点建模的回测框架"
# Claude 自动使用 quantitative-finance skill! 🚀
```

### 10.2 角色特定测试

```python
# Senior Quantitative Developer
"将市场数据处理器的 P99 延迟降低到 < 100 µs 并显示分析结果"
# Claude 使用: senior-quantitative-developer

# Senior Quantitative Researcher
"为 mean-reversion 进行 walk-forward 验证并带偏差检查"
# Claude 使用: senior-quantitative-researcher

# Senior Systematic Trader
"构建 TCA 仪表板并优化执行参数"
# Claude 使用: senior-systematic-trader

# Senior Quantitative Trader
"准备归因分析并推荐投资组合调整"
# Claude 使用: senior-quantitative-trader
```

---

*项目地址*: https://github.com/Ricko12vPL/claude-code-skills  
*许可证*: Apache 2.0  
*更新时间*: 2026-03-04
