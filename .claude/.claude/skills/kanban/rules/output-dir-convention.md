# Output Directory Convention

## 编号
R-001

## 描述
所有产出代码必须放在 `config.json` 中 `output_dir` 字段指定的根目录下的 `<task-name>/` 子目录中。

- `output_dir` 的值从 `.kanban/config.json` 的 `output_dir` 字段读取
- `<task-name>` 使用英文小写短横线命名（如 `snake`, `minesweeper`, `data-pipeline`）
- 完整路径模式: `{worktree_path}/{output_dir}/{task-name}/`
- 禁止将代码放在 worktree 根目录或其他未指定的位置

示例:
- `output_dir=games` 时，代码放 `games/snake/`、`games/minesweeper/`
- `output_dir=scripts` 时，代码放 `scripts/data-pipeline/`
- `output_dir=src`（默认值）时，代码放 `src/my-feature/`

此规则适用于所有由 executor agent 产出的代码文件，包括源代码、测试文件、配置文件和静态资源。唯一的例外是框架本身（`.claude/` 和 `.kanban/` 目录）的增强任务，这类任务不产出应用代码。

## 检查方法
executor agent 完成编码后，`Guard.check_artifacts()` 验证阶段产物完整性:

1. 读取 `.kanban/config.json` 中的 `output_dir` 值
2. 检查 Execute 阶段要求的产物文件（`execution_summary.md`、`execution_pitfalls.md`、`execution_decisions.md`）存在且非空
3. 验证 `worktree_path` 已设置（发出 warning 如未设置）

**注意:** 当前版本的 Guard 验证产物文件的存在性和非空，但不做文件路径合规校验（即不验证变更文件是否在 `{output_dir}/{task-name}/` 路径下）。路径合规由 executor agent 在调度时通过 prompt 约束实现。

## 违反后果
产物文件缺失时，Guard 阻止任务进入 Evaluate 阶段。executor agent 必须补全缺失产物后才能继续流程。如文件放错路径，在 Evaluate 阶段由评估 agent 发现并扣分。
