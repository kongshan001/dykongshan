# TASK-232 旅行天气预警集成 — Plan

## 需求
集成天气API，在旅行前和旅途中提供目的地天气预警和建议。

## 功能设计
1. **天气查询** — 调用 Open-Meteo API（免费，无需key）获取目的地7天预报
2. **预警判断** — 基于温度/降水/风速自动生成出行建议
3. **打包建议** — 根据天气推荐携带物品
4. **格式化输出** — 终端表格展示天气预报+预警

## 技术方案
- Python 3.11+, urllib标准库
- API: Open-Meteo forecast API (免费)
- 入口: `travel_weather/__main__.py`

## 文件结构
```
travel_weather/
├── __main__.py   # CLI入口+demo
├── models.py     # 数据模型
├── api.py        # 天气API调用
├── alerts.py     # 预警逻辑
└── report.py     # 报告输出
```
