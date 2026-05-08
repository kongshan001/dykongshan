# TASK-237 旅行花费记录器 — Plan

## 需求
旅途中实时记录花费，支持多币种、分类统计、预算对比。

## 功能
1. **花费记录** — 金额/币种/分类/备注/日期
2. **多币种支持** — 自动转换为基准币种
3. **分类统计** — 餐饮/交通/住宿/门票/购物/其他
4. **预算对比** — 设定预算，实时对比剩余
5. **持久化** — JSON文件存储，旅行结束可回顾

## 技术方案
- Python 3.11+, urllib标准库
- 存储: JSON文件
- 汇率: 复用travel_currency的rates模块
- 入口: travel_expense/__main__.py

## 文件结构
```
travel_expense/
├── __main__.py    # CLI入口+demo
├── models.py      # 数据模型
├── storage.py     # JSON持久化
├── stats.py       # 统计分析
└── report.py      # 格式化输出
```
