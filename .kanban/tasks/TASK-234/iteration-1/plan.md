# TASK-234 旅行货币兑换助手 — Plan

## 需求
多币种实时汇率查询、历史汇率趋势、兑换建议。

## 功能
1. 实时汇率查询（Open ER API）
2. 交叉汇率计算（任意两种货币互换）
3. 常见旅行币种速查表
4. 兑换金额计算器（含手续费模拟）
5. 历史趋势简易图表（ASCII）

## 技术方案
- Python 3.11+, urllib标准库
- API: open.er-api.com (免费)
- 入口: travel_currency/__main__.py

## 文件结构
```
travel_currency/
├── __main__.py   # CLI入口+demo
├── models.py     # 数据模型
├── rates.py      # 汇率获取+缓存
├── convert.py    # 兑换计算
├── chart.py      # ASCII趋势图
└── report.py     # 格式化输出
```
