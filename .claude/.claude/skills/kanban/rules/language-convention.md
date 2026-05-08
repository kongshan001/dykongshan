# Language Convention

## 编号
R-008

## 描述
框架各阶段产物文档的语言选择遵循以下约定：

**中文（必须）：**
- requirements.md — 需求分析文档
- test_spec.md — 测试用例规格
- retrospective.md — 复盘总结
- acceptance.md — 验收文档
- design.md — 设计方案
- 所有 rules/ 下的规则文件
- SKILL.md 及 skill 文档正文

**英文优先：**
- task_breakdown.json — 任务拆解（字段名、ID 等标识符）
- 代码注释
- commit message
- Git 分支名
- 代码标识符、变量名、函数名

**容错：**
生成的 plan_review_report.json、spec_review_report.json 等评估报告 JSON 中的 summary 字段允许使用中文。

## 适用范围
- .claude/skills/kanban/ 下所有产物和文档
- 各 kanban agent 产出的 task 文档

## 违反后果
语言不一致不触发 Guard 拦截（不阻塞流程），但在 code_reviewer 评估中作为风格建议项记录。
