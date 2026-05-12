# workflow.json 字段说明

## 编号
R-010

## 描述
`.kanban/workflow.json` 定义 kanban 任务看板系统的 FSM（有限状态机）流程结构。控制阶段顺序、各阶段的 Agent 调度、质量门禁、自迭代策略。所有字段可按需定制，缺失时回退到内置默认值。

## 顶层字段

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `pass_threshold` | float | 8.5 | 全局评分通过阈值（10 分制）。Evaluate 阶段所有 required 角色评分 >= 此值才视为通过。可被各 phase 内的 `pass_threshold` 覆盖 |
| `max_iterations` | int | 6 | 最大自迭代次数。达到上限后即使评分未通过也必须进入 User Decision（IR-08） |
| `phases` | array | （见下方） | 阶段定义数组，按 FSM 流转顺序排列。每个元素定义该阶段的 Agent、产物、质量门禁等 |

---

## phases[] — 阶段定义

### 通用字段（所有阶段共用）

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `id` | string | 是 | 阶段标识符。必须为以下之一：`plan`, `plan_review`, `qa_spec`, `spec_review`, `execute`, `evaluate`, `retrospective`, `archive` |
| `name` | string | 否 | 阶段显示名称（中文），用于 dashboard 和日志展示 |
| `description` | string | 否 | 阶段描述文本 |
| `agents` | array | 否 | 该阶段要调度的 Agent 列表。不定义时使用内置默认 Agent |
| `required_artifacts` | string[] | 否 | 该阶段必须产出的文件列表。Guard 在阶段完成时验证这些文件存在且非空 |
| `required_checks` | string[] | 否 | 该阶段必须通过的检查项列表（如 `tests_run`、`framework_check`） |
| `exit_condition` | string | 否 | 阶段退出条件的可读描述 |

### agents[] — Agent 定义

每个阶段通过 `agents` 数组定义要调度的 Agent。每个 Agent 条目可包含：

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `role` | string | 是 | Agent 角色标识。用于日志标识和报告文件命名（如 `qa_report.json`）。Evaluate 阶段内置角色：`code_reviewer`, `qa`, `pm`, `designer` |
| `required` | bool | 是 | 是否为必需 Agent。`true` 时该 Agent 评分影响 pass_threshold 判断；`false` 时标记为 optional，评分仅供参考不阻塞流程。缺失报告不触发 Guard 拦截 |
| `parallel` | bool | 否 | 是否与该阶段其他 Agent 并行启动。`true` 时通过 `run_in_background=true` 并行调度。默认 `false`（串行） |
| `agent_type` | string | 否 | 调用的 Agent 类型名，映射到 `.claude/agents/{agent_type}.md`。不指定时使用 `role` 值作为 agent_type |
| `mode` | string | 否 | Agent 工作模式。某些 Agent 支持多种模式：qa Agent 在 `qa_spec` 阶段使用 `"spec"`（生成 test_spec.md），在 `evaluate` 阶段使用 `"eval"`（评估测试质量） |
| `file` | string | 否 | 自定义 Agent 定义文件的相对路径。用于引入非内置的评估角色，如 `"agents/my-security-auditor.md"` |
| `trigger_condition` | object | 否 | 条件调度控制。仅在 `required: false` 时有意义 |

#### trigger_condition — 条件调度

`required: false` 的 Agent 默认被跳过（不调度），除非其 `trigger_condition` 关键词匹配任务描述。

| 字段 | 类型 | 说明 |
|------|------|------|
| `keywords` | string[] | 触发关键词数组。任一关键词在任务描述中出现即触发 Agent 调度（不区分大小写） |
| `match_field` | string | 匹配目标字段，当前仅支持 `"description"`（匹配 task description） |

**示例**（researcher Agent 按需调度）：
```json
{
  "role": "researcher",
  "required": false,
  "agent_type": "kanban-researcher",
  "trigger_condition": {
    "keywords": ["调研", "选型", "对比", "analysis", "research", "技术选型", "竞品"],
    "match_field": "description"
  }
}
```

### quality_gate — 质量门禁

控制阶段的评分审核机制。主要用在 `plan`（需求评审）、`plan_review`（Plan 6维评审）、`spec_review`（测试规格评审）等评审性质阶段。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `enabled` | bool | true | 是否启用品控门禁。`false` 时跳过评分审核直接进入下一阶段 |
| `pass_threshold` | float | 继承全局 | 本阶段的评分通过阈值（10 分制），优先于顶层 `pass_threshold` |
| `max_rounds` | int | 3 | 本阶段最多审核轮数。超限后不继续修订，进入 User Decision |
| `dimensions` | array | — | 评分维度列表。每个维度含 `id`（标识符）、`name`（显示名）、`description`（描述）、`weight`（权重，各维度 weight 之和应为 1.0） |

**plan_review 阶段 dimenions 示例**：
```json
"dimensions": [
  {"id": "requirement_clarity",   "name": "需求清晰度",       "weight": 0.2},
  {"id": "technical_feasibility",  "name": "技术可行性",       "weight": 0.2},
  {"id": "task_decomposition",     "name": "任务拆解合理性",    "weight": 0.2},
  {"id": "acceptance_criteria",    "name": "验收标准完整性",    "weight": 0.2},
  {"id": "research_completeness",  "name": "调研完整性",       "weight": 0.0},
  {"id": "parallel_safety",        "name": "并行安全性",       "weight": 0.2}
]
```

**注意**：`weight: 0.0` 的维度为纯参考维度，不影响加权总分。

---

## 各阶段默认配置

以下为 workflow.json 模板中各阶段的完整配置示例及可定制点。

### plan — 规划阶段

涉及需求澄清 + 任务拆解。包含 `quality_gate` 进行 4 维需求审核。

**可定制点**：
- `quality_gate.pass_threshold`: 需求质量门槛，默认 8.5。严格项目可调高到 9.0
- `quality_gate.max_rounds`: 最多修订轮数，默认 3
- `agents[]`: 可添加额外的 plan 阶段 Agent（如专用调研 Agent）。researcher Agent 通过 `trigger_condition` 按需触发

### plan_review — Plan 评审阶段

6 维并行评审需求文档和任务拆解质量。所有 Agent 标记 `"parallel": true` 同时运行。

**可定制点**：
- `agents[]`: 每个维度一个 agent 条目。可增删维度（如不需要 `research_completeness` 可移除）
- `quality_gate.dimensions[].weight`: 调整各维度权重
- `quality_gate.pass_threshold`: 评审通过门槛

### qa_spec — 测试规格生成

由 QA Agent 从 plan.md + requirements.md 生成 `test_spec.md`。

**可定制点**：
- `agents[]`: QA Agent 使用 `"mode": "spec"` 模式。可替换为自定义测试规格生成 Agent

### spec_review — 测试规格评审

对 test_spec.md 进行多维度审核（覆盖率、边界用例、可执行性）。

**可定制点**：
- `quality_gate.pass_threshold`: 测试规格质量门槛，低于此值触发修订

### execute — 执行阶段

编码实现 + 测试。这是唯一产生代码变更的阶段。

**可定制点**：
- `agents[]`: 默认仅 executor。可添加专用测试 Agent、文档生成 Agent 等
- `required_checks`: 添加额外检查项（如 `lint_check`、`coverage_check`）

### evaluate — 评估阶段

4 角色并行评估（code_reviewer, qa, pm, designer），各角色均 `"parallel": true`。

**重要**：`pass_threshold` 在此阶段覆盖全局值（模板默认为 9.0）。

**可定制点**：
- `agents[]`: 核心定制点。可：
  - 添加自定义评估角色（如安全审计：`"role": "security_auditor"`，`"agent_type": "my-security-agent"`，`"required": true`）
  - 移除内置角色（如小型项目只需 code_reviewer + qa）
  - 调整 `required` 标志：将某角色标记为 `false` 使其评分可选
- `pass_threshold`: 通过门槛，默认 9.0
- `report_required_fields`: 要求报告必须包含的字段列表

**添加自定义评估角色示例**：
```json
{
  "role": "security_auditor",
  "required": true,
  "parallel": true,
  "agent_type": "kanban-code-reviewer",
  "mode": "security"
}
```

### retrospective — 复盘阶段

生成 `retrospective.md` + `acceptance.md`，提取知识沉淀。

**可定制点**：
- `agents[]`: 默认 3 个 Agent 并行（retrospective_writer、acceptance_writer、knowledge_extractor）。简化为单 Agent 串行可删除 `"parallel": true`

### archive — 归档阶段

合并 worktree 代码到主干，清理资源，沉淀知识。

**可定制点**：
- `agents[]`: knowledge-manager 在此阶段做最终知识提取，`required: false` 表示失败不阻塞归档

---

## 全局策略配置（模板扩展字段）

workflow.json 模板还包含以下全局策略配置，可独立于 phases 数组声明：

### self_improve — 自迭代控制

控制自动迭代的触发条件和跳转目标。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `self_improve.max_iterations` | int | 6 | 覆盖顶层 `max_iterations` |
| `self_improve.exit_all_pass` | bool | true | 评分全部通过时是否立即退出迭代 |
| `self_improve.default_restart_from` | string | `"plan"` | 默认回退起点（`"plan"` 或 `"execute"`） |
| `self_improve.hot_iteration.trigger` | string | — | hot iteration 触发条件（评分 >= 7.0 且无架构问题） |
| `self_improve.hot_iteration.restart_from` | string | `"execute"` | hot iteration 回退到的阶段 |
| `self_improve.full_iteration.trigger` | string | `"DEFAULT"` | full iteration 触发条件（默认兜底） |
| `self_improve.full_iteration.restart_from` | string | `"plan"` | full iteration 回退到的阶段 |

### user_decision — 用户决策门控

| 字段 | 类型 | 说明 |
|------|------|------|
| `user_decision.trigger` | string | 何时进入 User Decision（`"all_pass OR max_iterations_reached"`） |
| `user_decision.prerequisite_phase` | string | 前置阶段（固定为 `"retrospective"`） |
| `user_decision.options` | string[] | 可用决策：`approve_and_archive`, `restart_from_plan`, `restart_from_execute`, `abort` |

---

## 配置验证

`workflow.json` 合法性在 kanban 运行时由以下机制保证：

1. **phase id 校验**：仅接受已知的 8 个阶段标识符
2. **agents[] 字段校验**：每个 agent 条目至少含 `role` 和 `required` 字段
3. **weight 加和校验**：quality_gate 各维度 weight 建议加和为 1.0（非强制）
4. **缺失回退**：未定义的阶段回退到内置默认配置

配置错误不会导致崩溃 — 违反 schema 仅触发 warning，回退到安全默认值。

## 常见定制场景

| 场景 | 调整位置 | 操作 |
|------|----------|------|
| 提高质量标准 | `pass_threshold`（全局）+ `evaluate.pass_threshold` | 调高到 9.0 或 9.5 |
| 减少迭代次数 | `max_iterations` | 降到 3 |
| 小型项目简化评估 | `evaluate.agents[]` | 保留 code_reviewer + qa，标记 pm 和 designer 为 `required: false` |
| 添加安全审计 | `evaluate.agents[]` | 追加一条 `{"role": "security_auditor", "required": true, "parallel": true, "agent_type": "..."}` |
| 关闭需求审核门禁 | `plan.quality_gate.enabled` | 设为 `false` |
| 禁用复盘文档生成 | `retrospective.agents[]` | 清空数组 |
| 加速执行（更多并行） | `scheduler.max_parallel`（在 config.json） | 增大该值 |

## 适用范围
- `.kanban/workflow.json` — 项目级 FSM 定义（用户可编辑）
- `.claude/skills/kanban/templates/workflow.json` — 模板参考（只读）

## 与 config.json 的职责划分

| 配置项 | 归属文件 | 原因 |
|--------|----------|------|
| 阶段流程、Agent 角色 | workflow.json | 流程结构定义 |
| 超时、预算、并行数 | config.json | 运行时资源控制 |
| 评分阈值 | workflow.json | 质量标准定义 |
| Python 解释器、输出目录 | config.json | 环境/路径配置 |
