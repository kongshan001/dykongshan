# Archive Requires Confirmation

## 编号
R-005

## 描述
任务归档操作不允许自动执行。归档涉及将 worktree 中的代码合并到主干分支，是不可逆的关键操作，必须由用户明确授权。

具体规则:

**归档保护机制:**
归档操作由 `cmd_decide()` 函数处理，仅在用户显式执行 `/kanban decide {task_id} --action approve_and_archive` 时触发。系统通过以下多层保护确保归档安全:

1. **显式用户操作**: 归档只能通过 `decide` 命令触发，且 action 必须为 `approve_and_archive`。其他任何路径无法触发归档。
2. **Retrospective 检查**: Guard 在归档前验证 `retrospective.md` 存在（IR-15）。
3. **Inbox 待处理检查**: Guard 在归档前验证 inbox.md 无待处理项。
4. **阶段门控**: 只有处于 `user_decision`、`evaluate` 或 `retrospective` 阶段的任务才允许执行 decide。

**归档操作范围:**
归档操作包括但不限于以下行为:
1. 将 worktree 的 git 分支合并到主干分支
2. 清理 worktree（删除 worktree 目录和相关元数据）
3. 将 task 目录从 `tasks/` 移动到 `archive/`
4. 更新看板索引文件

**禁止行为:**
- 禁止自动归档（auto-archive）
- 禁止在没有用户指令的情况下自动合并 worktree 到主干
- 禁止 agent 自行决定归档时机

**例外情况:**
- 用户执行 `/kanban decide --action abort` 时，任务直接归档（不合并代码），此时不需要额外的归档确认，因为 abort 本身就是用户的明确决定

## 检查方法
归档保护通过以下机制实现:

1. `cmd_decide()` 仅接受 `approve_and_archive` / `abort` / `restart_from_plan` / `restart_from_execute` 四种 action
2. 归档前 Guard 强制检查 `retrospective.md` 存在性（IR-15）
3. 归档前 Guard 检查 `inbox.md` 待处理项为空
4. `archive` 命令在执行时二次验证任务状态

## 违反后果
任何试图绕过 `cmd_decide` 直接归档的操作都会被拦截。归档操作必须经过完整的用户决策流程，确保用户始终对代码合并到主干拥有最终控制权。此规则是框架的铁律之一（IR-11），不可通过配置关闭。
