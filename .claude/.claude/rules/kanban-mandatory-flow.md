# Kanban Mandatory Flow

## 编号
R-006

## 描述
所有代码修改必须通过 kanban 任务看板系统的标准 FSM 流程，包括框架自身的改造。禁止绕过看板直接在 main 分支上做未经 Plan/Execute/Evaluate 流程的变更。

轻量模式例外：系统可在 Plan 完成后评估任务复杂度，建议轻量模式（跳过 worktree + 简化评估）。轻量模式仍需走完整 Plan → Execute → Evaluate → User Decision → Archive 流程，仅 Execute 和 Evaluate 阶段的实现方式简化。**必须征得用户同意后才能启用。**

具体规则：

**必须走看板流程的变更：**
- 新功能开发
- Bug 修复
- 代码重构
- 框架自身增强（skills、agents、rules、lib 等）
- 配置变更
- 测试新增/修改

**流程要求：**
1. 先执行 `/kanban create "<title>"` 创建任务
2. 再执行 `/kanban run TASK-NNN` 走完整 Plan → Execute → Evaluate → User Decision → Archive 流程
3. 通过 `/kanban decide TASK-NNN --action approve_and_archive` 归档

**同类修改整合要求：**
- 当同时存在多个相关或同类型的修改需求时，必须整合为一个 kanban 任务，在 Plan 阶段以 subtask 形式组织
- 单一任务的粒度是「一个完整交付单元」，而非「一个修改点」
- 例如：同时收到 5 个 GitHub Issue 报告的框架 bug，应创建 1 个任务而非 5 个

**例外：**
- `/kanban init`、`/kanban status`、`/kanban show` 等纯查询操作无需任务

## 检查方法
用户或评估 Agent 在 review 阶段检查变更是否有对应的 kanban 任务记录。如果发现未经过看板流程的代码变更，应在评估报告中标记。

## 违反后果
代码变更缺少对应的 kanban 任务记录时，QA Agent 和 PM Agent 在评估阶段扣分。框架维护者应确保所有变更可追溯到具体的 TASK-NNN。
