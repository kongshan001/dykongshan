# config.json 字段说明

## 编号
R-009

## 描述
`.kanban/config.json` 是 kanban 框架的项目级配置文件，控制运行时行为、资源限制和调度策略。所有字段均为可选，缺失时使用默认值。

## 完整字段参考

### 基础配置

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `project` | string | `""` | 项目名称，用于 dashboard 展示和归档记录标识 |
| `version` | string | — | 当前 kanban 框架版本号，由 `/kanban version record` 自动更新 |
| `python_bin` | string | `venv/bin/python` | Python 解释器路径。`/kanban init` 首次运行时由用户指定或自动创建 venv。支持相对路径（相对于项目根目录）和绝对路径。Windows 下默认 `venv/Scripts/python.exe` |
| `trunk` | string | `"main"` | 主干分支名称。归档时 worktree 代码合并到此分支 |
| `output_dir` | string | `"src"` | 产出代码的根目录名。executor 将代码放在 `{output_dir}/{task-name}/` 下。例如：`"games"` 则代码在 `games/snake/`；`"scripts"` 则代码在 `scripts/data-pipeline/` |

### 高级路径配置

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `worktree_base_dir` | string | `null` | 自定义 worktree 根目录的绝对路径。不设置时 worktree 创建在 `.kanban/tasks/TASK-NNN/worktree/` 下。设置为其他路径（如 `/tmp/kanban-worktrees/`）可将 worktree 放到项目外，避免 IDE 重复索引 |

### engine — 执行引擎

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `engine.default` | string | `"claude-code"` | 默认执行引擎。当前仅支持 `"claude-code"`，预留扩展 |

### timeout — 超时控制

控制各阶段和单个 Agent 的最大执行时间（秒）。超时后 Agent 被强制终止，任务标记为 `interrupted`。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `timeout.plan_seconds` | int | 300 | Plan 全阶段（需求澄清 + 任务拆解 + plan_review + qa_spec + spec_review）的总超时 |
| `timeout.execute_seconds` | int | 600 | Execute 阶段的总超时。复杂任务（subtask 多）建议调大 |
| `timeout.evaluate_seconds` | int | 300 | Evaluate 阶段的总超时（含 4 角色并行评估 + 评分收集） |
| `timeout.single_agent_seconds` | int | 180 | 单个 Agent 调用的超时。影响所有阶段（plan、execute、evaluate 等）。Agent 内部执行超过此时限将被终止 |

### retry — 重试策略

Agent 调用失败时的重试行为。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `retry.max_retries` | int | 2 | 单个 Agent 调用失败后的最大重试次数。达到上限后不重试，记录错误 |
| `retry.backoff_seconds` | int[] | `[30, 60]` | 每次重试前的等待秒数，数组长度应与 `max_retries` 匹配或更大。第 1 次重试等 30s，第 2 次等 60s |

### budget — Token 预算

Token 消耗追踪与预算警报。预算数据通过 `/kanban tokens <task_id>` 查看。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `budget.per_task` | int | 500000 | 单个任务的总 token 预算上限 |
| `budget.per_phase.plan` | int | 50000 | Plan 阶段的 token 预算 |
| `budget.per_phase.execute` | int | 200000 | Execute 阶段的 token 预算 |
| `budget.per_phase.evaluate` | int | 150000 | Evaluate 阶段的 token 预算 |
| `budget.warning_threshold` | float | 0.8 | 告警阈值比例。消耗超过 `预算 × 0.8` 时触发 warning，超过 `预算 × 1.0` 时触发 critical |
| `budget.hard_limit` | bool | true | 是否在达到预算上限时强制阻断新 Agent 调用。`true` 时超预算直接报错；`false` 时仅记录警告继续执行 |

### scheduler — 调度策略

控制 Agent 并行调度行为。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `scheduler.max_parallel` | int | 3 | 同一批次最多并行启动的 Agent 数量。增大可加速执行（受 API 并发限制），减小可降低 token 消耗峰值。设为 1 即为完全串行 |
| `scheduler.poll_interval_seconds` | int | 30 | 后台 Agent 完成状态的轮询间隔。值越小响应越快但消耗更多轮询；对长时间运行的 Agent 影响小 |
| `scheduler.conflict_strategy` | string | `"serialize"` | 当多个 subtask 修改相同文件时的冲突处理策略。`"serialize"`: 降级为串行执行。仅支持该值 |

### framework_assessment — 框架自评估

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `framework_assessment.enabled` | bool | true | 归档时是否执行框架自评估。开启后自动分析当前任务的 pitfalls 和 decisions，检查框架规则完整性、agent 能力覆盖等，产出 `framework_assessment.json`。评估不阻塞归档 |

## 配置模版

以下是包含所有字段及默认值的完整模版：

```json
{
  "project": "",
  "trunk": "main",
  "output_dir": "src",
  "engine": {
    "default": "claude-code"
  },
  "timeout": {
    "plan_seconds": 300,
    "execute_seconds": 600,
    "evaluate_seconds": 300,
    "single_agent_seconds": 180
  },
  "retry": {
    "max_retries": 2,
    "backoff_seconds": [30, 60]
  },
  "budget": {
    "per_task": 500000,
    "per_phase": {
      "plan": 50000,
      "execute": 200000,
      "evaluate": 150000
    },
    "warning_threshold": 0.8,
    "hard_limit": true
  },
  "scheduler": {
    "max_parallel": 3,
    "poll_interval_seconds": 30,
    "conflict_strategy": "serialize"
  },
  "framework_assessment": {
    "enabled": true
  }
}
```

## 常见调优场景

| 场景 | 调整项 | 建议值 |
|------|--------|--------|
| 大型任务（10+ subtask） | `timeout.execute_seconds` | 1200 |
| 降低 API 费用 | `scheduler.max_parallel` | 1 |
| 加速执行 | `scheduler.max_parallel` | 5 |
| 预感到超预算 | `budget.warning_threshold` | 0.6 |
| Agent 经常超时 | `timeout.single_agent_seconds` | 300 |
| IDE 索引太慢 | `worktree_base_dir` | `/tmp/kanban-worktrees/` |
| 放到独立仓库目录 | `output_dir` | `"projects"` |

## 适用范围
- `.kanban/config.json` — 项目级配置（用户可编辑）
- `.claude/skills/kanban/templates/config.json` — 默认模版（只读参考）

## 检查方法
`Config` 类（`core/infra/config.py`）在读取时对所有字段做 `.get(key, default)` 回退，缺失字段不报错，使用 Consts 中定义的默认值。
