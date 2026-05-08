# TASK-230 旅行预算计算器 — Plan

## 需求分析
开发一个命令行旅行预算计算工具，支持多币种、多目的地费用估算。

## 功能设计
1. **多目的地费用录入** — 支持添加多个目的地，每个目的地包含交通、住宿、餐饮、门票等费用项
2. **多币种支持** — 集成汇率API（如 exchangerate-api），自动转换为目标币种
3. **预算模板** — 内置经济/标准/豪华三种预算模板
4. **费用汇总报告** — 按目的地、类别、总计生成清晰的预算报告

## 技术方案
- 语言: Python 3.11+
- 依赖: httpx (异步HTTP), rich (终端美化输出)
- 汇率API: https://open.er-api.com/v6/latest/{base} (免费)
- 入口: `travel_budget/main.py`

## 文件结构
```
travel_budget/
├── main.py          # CLI 入口
├── budget.py        # 预算计算核心逻辑
├── currency.py      # 汇率转换
├── templates.py     # 预算模板
├── report.py        # 报告生成
└── models.py        # 数据模型 (dataclass)
```

## 验收标准
- 可通过 `python -m travel_budget` 运行
- 支持至少 5 种货币
- 输出格式化的预算报告
