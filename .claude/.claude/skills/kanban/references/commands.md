# Kanban 命令实现参考

> 此文件从 SKILL.md 拆分出来，用于渐进式加载。
> 编排器在需要查看具体命令实现时按需读取此文件。

## 环境设置

框架使用 Python CLI 执行所有命令。所有命令输出 JSON 到 stdout，无需 jq。

**Python 解释器选择 (首次初始化时确定):**

```
kanban_init_python:
  1. 询问用户: "是否指定已有的 Python 解释器？（输入路径，或回车跳过使用 venv）"
  2. 如果用户提供路径:
     - 验证该解释器可执行: <path> --version
     - 通过 → 写入 .kanban/config.json 的 python_bin 字段
     - 失败 → 提示用户重新输入或回退到 venv
  3. 如果用户跳过 (默认):
     - Check if venv/bin/python exists; if not, run `python3 -m venv venv --clear`
     - 写入 "python_bin": "venv/bin/python" 到 config.json
  4. 所有后续命令使用 config.json 中的 python_bin:
     <python_bin> -m core <command> [args]
```

**为什么需要这个选择:**
- 用户可能已有 conda/pyenv/系统 Python 环境，无需额外创建 venv
- 避免 venv 中的旧版 pip 导致的安装问题
- 复用已有环境中的依赖（pytest 等），减少重复安装

## 规则按需加载

编排器规则加载:
- `.claude/rules/kanban-rules.md` 由 Claude Code 自动注入上下文（IR-01~17 + R-001~006）
- `.claude/skills/kanban/references/` 下的参考文档按需查阅（config/ workflow/ language/ version）

---

## 环境设置

框架使用 Python CLI 执行所有命令。所有命令输出 JSON 到 stdout，无需 jq。

**Python 解释器选择 (首次初始化时确定):**

```
kanban_init_python:
  1. 询问用户: "是否指定已有的 Python 解释器？（输入路径，或回车跳过使用 venv）"
  2. 如果用户提供路径:
     - 验证该解释器可执行: <path> --version
     - 通过 → 写入 .kanban/config.json 的 python_bin 字段
     - 失败 → 提示用户重新输入或回退到 venv
  3. 如果用户跳过 (默认):
     - Check if venv/bin/python exists; if not, run `python3 -m venv venv --clear`
     - 写入 "python_bin": "venv/bin/python" 到 config.json
  4. 所有后续命令使用 config.json 中的 python_bin:
     <python_bin> -m core <command> [args]
```

**为什么需要这个选择:**
- 用户可能已有 conda/pyenv/系统 Python 环境，无需额外创建 venv
- 避免 venv 中的旧版 pip 导致的安装问题（如本 session 遇到的 pip 21.2.4 不支持 pyproject.toml editable install）
- 复用已有环境中的依赖（pytest 等），减少重复安装

## 规则按需加载

编排器规则加载:
- `.claude/rules/kanban-rules.md` 由 Claude Code 自动注入上下文（IR-01~17 + R-001~006）
- `.claude/skills/kanban/references/` 下的参考文档按需查阅（config/ workflow/ language/ version）

---

## 各命令实现

### `/kanban init`

**首次运行必须完成 Python 解释器选择。** 已初始化过的项目 (`.kanban/config.json` 中已有 `python_bin`) 可跳过此步骤。

1. **选择 Python 解释器 (首次):**
   - 询问用户: "是否指定已有的 Python 解释器？例如系统 python3、conda 环境的 python、pyenv 的 python 等。输入完整路径或回车跳过（将自动创建 venv）。"
   - 用户提供路径 → 验证 `"<path>" --version` 返回 0 → 写入 `python_bin` 到 config.json
   - 用户跳过 → 检查 `venv/bin/python` 是否存在；不存在则 `python3 -m venv venv --clear`；写入 `"python_bin": "venv/bin/python"`
2. 执行 `python3 -m core init`
3. **初始化 CLAUDE.md（如不存在）:**
   - 如果 CLAUDE.md 不存在 → 创建新文件，写入 `Kanban 多 Agent 编排框架项目。规则由 .claude/rules/ 自动注入。`
   - 如果 CLAUDE.md 存在 → 跳过（幂等，不修改用户已有的 CLAUDE.md）
4. **安装框架依赖文件 (agents/rules 使用符号链接):**
   ```bash
   SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
   # agents: .claude/agents/kanban-planner.md -> ../skills/kanban/agents/kanban-planner.md
   mkdir -p .claude/agents
   for agent in "$SKILL_DIR"/agents/*.md; do
     name=$(basename "$agent")
     ln -sf "../skills/kanban/agents/$name" ".claude/agents/$name"
   done
   # rules: 单个规则文件 .claude/rules/kanban-rules.md
   mkdir -p .claude/rules
   ln -sf "../skills/kanban/rules/kanban-rules.md" ".claude/rules/kanban-rules.md"
   ```
5. 确认输出: "Initialized kanban at .kanban/" + "Linked agents and rules"
6. **工程基础设施检查 (Issue #106):**
   - 读取 `python3 -m core init` 返回的 `scan.infrastructure_gaps` 数组
   - 如果 `infrastructure_gaps` 为空或所有项 `detected=true` → 跳过此步骤
   - 如果有 `detected=false` 的项，**使用 `AskUserQuestion` 展示缺失项并询问用户**:
     ```
     AskUserQuestion(
       questions: [{
         question: "检测到以下工程基础设施缺失，是否需要搭建？
                   {列出每个 gap 的 tool + category + suggestion}",
         header: "基础设施",
         options: [
           {label: "全部搭建（推荐）", description: "为所有缺失项生成配置文件"},
           {label: "选择搭建", description: "逐项确认是否搭建"},
           {label: "跳过", description: "不搭建，后续可通过 /kanban check-env 查看"}
         ]
       }]
     )
     ```
   - 用户选择"全部搭建" → 为每个缺失项生成对应配置文件：
     - **linting (pylint)**: 生成 `.pylintrc`（Python）或 `.eslintrc.json`（JS）或 `.golangci.yml`（Go）
     - **testing (pytest)**: 生成 `pytest.ini` 或 `conftest.py`（Python）或 `jest.config.js`（JS）
     - **coverage**: 生成 `.coveragerc` 或在 `pyproject.toml` 中添加 coverage 配置
     - **domain (gm_commands)**: 生成 `gm_commands.py` 模板
   - 用户选择"选择搭建" → 逐项 `AskUserQuestion` 确认
   - 用户选择"跳过" → 仅记录到 scan 报告
   - **配置文件生成**由编排器直接写入（不创建 kanban 任务），因为这是项目初始化的一次性设置

### `/kanban create "<title>" [--desc "<desc>"] [--auto-mode <flags...>]`

1. 解析 title 和可选 description
2. **自动模式询问（硬性要求）：**
   - 如果用户**未**显式传入 `--auto-mode` 参数，**必须**使用 `AskUserQuestion` 询问用户是否开启自动模式：
     ```
     AskUserQuestion(
       questions: [{
         question: "是否为该任务开启自动模式？自动模式将在指定决策点跳过用户确认，由 kanban-auto-decider Agent 自动决策。",
         header: "自动模式",
         options: [
           {label: "全部自动", description: "启用所有自动决策点（brainstorm + iteration + lightweight），归档决策始终需用户确认（IR-11）"},
           {label: "选择决策点", description: "仅启用部分自动决策点，下一轮将逐项确认"},
           {label: "不开启（推荐）", description: "所有决策点均由用户手动确认，保持完整控制"}
         ],
         multiSelect: false
       }]
     )
     ```
   - 用户选择「全部自动」→ 设置 flags = `["all"]`
   - 用户选择「选择决策点」→ 追加一轮 `AskUserQuestion`（multiSelect: true）：
     ```
     AskUserQuestion(
       questions: [{
         question: "请选择需要自动化的决策点：",
         header: "决策点",
         options: [
           {label: "需求澄清 (brainstorm)", description: "仍执行 brainstorming 完整流程，AskUserQuestion 由 auto-decider 自动回答"},
           {label: "自迭代判断 (iteration)", description: "自迭代已自动执行（IR-17），此标记确保不询问用户"},
           {label: "轻量模式 (lightweight)", description: "由 Agent 评估任务复杂度并自动选择轻量/标准模式"},
         ],
         multiSelect: true
       }]
     )
     ```
     用户选中的选项映射为对应的 flag 名称。
   - 用户选择「不开启」→ 不设置任何 flags，所有决策点保持手动
   - 如果用户**已**显式传入 `--auto-mode` 参数（如 `/kanban create "title" --auto-mode all`），**跳过询问**，直接使用用户指定的 flags
3. 执行 `python3 -m core create "$title" --desc "$description" --auto-mode $flags`
4. 展示创建结果（含 auto_mode 配置）

**auto_mode 决策表：**

| 决策点 | 字段 | auto_mode 开启时的行为 |
|--------|------|----------------------|
| 需求澄清 | `auto_brainstorm` | 仍执行完整 brainstorming 流程，但 AskUserQuestion 替换为 kanban-auto-decider Agent 自动回答。置信度 < 0.7 降级回用户确认 |
| 自迭代判断 | `auto_iteration` | 已由 IR-17 自动执行，此标记仅确保不额外询问用户 |
| 轻量模式 | `auto_lightweight` | 跳过 AskUserQuestion，由 kanban-auto-decider Agent 评估复杂度自动选择 |

如果用户未传 `--auto-mode`，必须用 `AskUserQuestion` 询问（选项: 全部自动 / 选择决策点 / 不开启）。用户显式传入则跳过询问。

### `/kanban status`

执行 `python3 -m core status`，展示所有活跃任务的状态。

### `/kanban show <task_id>`

执行 `python3 -m core show "$task_id"`，展示任务详情。

### `/kanban run <task_id> [--phase <phase>]`

这是核心编排命令。按 FSM 流程执行:

#### Phase 1: Plan

**触发条件:** `--phase plan` 或任务处于 pending/planning 状态

Plan 阶段分两步：**需求澄清（brainstorming）** → **任务拆解（writing-plans）**。两步均复用 superpowers 技能。

##### Plan Step A: 需求澄清 (superpowers:brainstorming)

> **铁律 (IR-16): Plan 阶段必须先完成需求澄清方可进入任务拆解。禁止无需用户确认的需求直接进入正式规划。**

1. `python3 -m core workflow transition "$task_id" plan`
2. 读取任务 title + description
3. **评估需求充分性 (Pass-through Gate):**
   - 判断 description 是否已包含：技术栈选型、核心功能清单、验收标准、约束条件
   - **如果 4 项都明确** → 可 skip brainstorming，直接跳到 Plan Step B（跳过的原因写入 task history）
   - **如果任何一项缺失** → 必须进入步骤 4，不可跳过
4. **调用 `Skill("superpowers:brainstorming")` 进行需求澄清:**
   - 按 brainstorming 技能标准流程执行：探索上下文 → 逐一提问 → 方案比较 → 设计审批
   - 澄清内容包括但不限于: 技术栈选择、功能边界、约束条件、验收标准
   - **必须遵循 brainstorming 的 HARD-GATE:** 设计方案获得用户批准后才算澄清完成
   - **所有提问必须使用 `AskUserQuestion` 工具**（禁止纯文本提问），带 header/options/description
   - 方案选择类问题用单选，多选用于非互斥选项
   - **auto_mode 覆盖 (auto_brainstorm):** 如果 `task.auto_mode.auto_brainstorm == True`，仍然执行完整 brainstorming 流程（探索代码上下文、需求分析、方案比较），但每个 `AskUserQuestion` 调用改为调度 `kanban-auto-decider` Agent 自动回答。Agent 接收问题选项和上下文，输出 decision/reasoning/confidence，置信度 < 0.7 时降级回用户确认。编排器按 auto-decider 的回答继续推进 brainstorming 后续步骤，直到生成 design.md。
5. 产出 `{task_dir}/design.md` — 用户确认后的设计文档
   - brainstorming 技能自动将设计文档写入 `docs/superpowers/specs/`，kanban 将其复制或引用到 `{task_dir}/design.md`
   - 对于简单任务 design.md 可以很简短（几段文字也算），但**不能为空**
6. **Brainstorming Gate 通不过的情况:**
   - 用户说"取消"/"不做了" → 标记 task 为 `error`，记录原因，退出
   - 用户一直不回复 → 保持 plan 阶段，等待用户反馈

##### Plan Step B: 任务拆解 (superpowers:writing-plans)

> **设计决策: 用 `superpowers:writing-plans` 替代 kanban-planner agent 的任务拆解。writing-plans 产出 bite-sized step + 完整代码 + 测试用例 + 精确命令，是 task_breakdown.json 的超集。**

7. **调用 `Skill("superpowers:writing-plans")` 生成实现计划:**
   - 输入: Step A 产出的 `design.md` + 项目结构 + kanban 约束（output_dir、worktree、评估标准）
   - writing-plans 按标准流程产出 bite-sized 任务，每个 step 含:
     - 精确文件路径 + 完整代码
     - 测试代码（TDD: 先写失败测试 → 实现 → 验证通过）
     - 验证命令 + 期望输出
     - commit 命令
   - 产出 `plan.md` 到 `{task_dir}/plan.md`

   **并行执行设计 (强制):**
   - subtask 必须按独立文件拆分，最大化无依赖 subtask 数
   - 共享文件的 subtask 自动串行化 (由 `check_parallel_conflicts` 检测)
   - `file_ownership` 必须精确列出该 subtask 独占的文件
   - `parallelizable: true` 用于无依赖 + 无文件冲突的 subtask
   - `dependencies` 只填真正有逻辑依赖的前置 subtask ID
   - 目标: 至少 40% 的 subtask 标记为 parallelizable

8. **从 plan.md 生成 task_breakdown.json (LLM 驱动):**
   - writing-plans 已产出 bite-sized tasks，每个 Task 章节包含完整文件路径、代码和依赖信息
   - 使用 LLM 从 plan.md 提取 task_breakdown.json，作为机器可读索引:
     - task_name: 从 plan.md 标题提取
     - subtasks: 每个 Task 章节映射为一个 subtask
     - estimated_files: 从 Task 的 "Files:" 块提取路径列表（Create/Modify/Test）
     - dependencies: 从 Task 描述中的前置引用推断
     - parallelizable: 无依赖 + 无共享文件冲突的 task 标记为 true
   - **注意**: task_breakdown.json 只含元数据（id/title/files/deps/parallelizable），
     不重复 plan.md 中已有的具体代码和实现细节
9. **从 plan.md + design.md 生成 requirements.md (LLM 驱动):**
   - 同样用 LLM 从 design.md 和 plan.md 提取: 功能需求 (FR-N)、非功能需求、技术约束、验收标准
   - 产出 `{task_dir}/requirements.md`
10. 检查产物:
   ```bash
   python3 -m core guard check-artifacts "$task_id" plan
   ```
   必须存在: `design.md`、`plan.md`、`requirements.md`、`task_breakdown.json`
11. `python3 -m core workflow complete-phase "$task_id"`

##### Plan Step B2: Plan 质量门禁 (plan_review)

12. `python3 -m core workflow transition "$task_id" plan_review`
13. **并行调度 6 个维度评审 Agent（或串行回退）:**
   ```bash
   python3 -m core workflow get-phase-agents plan_review
   ```
   **并行模式**（当 workflow.json plan_review agents 含 `parallel: true`）:
   对每个维度并行启动独立 Agent:

   ```
   对每个 dimension (从 workflow.json plan_review.agents 获取):
   Agent(
     subagent_type="general-purpose",
     run_in_background=true,
     prompt: """
       你是 Plan Review Agent。请独立评审任务 {task_id} 的 Plan 产物。

       **单维度模式**: 你仅需评审以下维度:
       - dimension: {dimension_name}

       评分标准（0-10分）:
       {对应维度的 checklist 内容}

       审核文件:
       - {task_dir}/requirements.md
       - {task_dir}/task_breakdown.json

       产出: {report_dir}/{dimension_name}_report.json
       格式: {"dimension": "...", "score": N, "findings": [...], "issues": [...], "applicable": true/false}
     """
   )
   ```

   等待所有 Agent 完成后，收集各维度报告:
   ```bash
   python3 -m core evaluator collect-plan-review "$task_id"
   ```
   汇总维度报告为完整 `plan_review_report.json`。

   **串行回退**（当 workflow.json plan_review 阶段未定义 agents 数组）: 使用单个 kanban-plan-reviewer Agent 串行评审全部 6 个维度，产出完整 plan_review_report.json（原有模式）。
14. Guard 验证报告:
   ```bash
   python3 -m core guard check-plan-quality "$task_id" "$report_dir"
   python3 -m core guard check-artifacts "$task_id" plan_review
   ```
   **并行 Guard 模式**: 可使用 `python3 -m core guard batch-check "$task_id"` 一次运行所有独立检查，结果与串行一致。
   - 总分 >= `pass_threshold` (默认 7.0) 通过
   - 不达标 → agent 修订 plan.md 后重试，最多 `max_rounds` (默认 3) 轮
   - 超限 → user_decision
15. `python3 -m core workflow complete-phase "$task_id"`

##### Plan Step C: 测试用例规格 (qa_spec)

13. `python3 -m core workflow complete-phase "$task_id"` (from plan_review)
14. **调度 QA Subagent 生成 test_spec.md (subagent_required: true — 必须使用 Agent 工具调度):**
   <HARD-GATE>
   禁止编排器自行生成 test_spec.md。必须通过 Agent 工具调度 kanban-qa subagent。
   编排器自行生成 = 违反 IR-01，产物无效。
   </HARD-GATE>

   ```bash
   python3 -m core workflow get-phase-agents qa_spec
   ```
   从 `workflow.json` 的 `qa_spec` 阶段读取 Agent 配置。
   默认: `{"role": "qa", "required": true, "agent_type": "kanban-qa", "mode": "spec", "subagent_required": true}`
   - 输入: `plan.md` + `requirements.md`
   - 产出: `{task_dir}/test_spec.md`
   - 内容: 单元测试用例列表 + 手动验证清单
15. Guard check: `python3 -m core guard check-artifacts "$task_id" qa_spec`
16. `python3 -m core workflow complete-phase "$task_id"`

##### Plan Step D: 测试用例评审 (spec_review)

17. `python3 -m core workflow complete-phase "$task_id"` (from qa_spec)
18. **调度 test-spec-reviewer Subagent 评审 test_spec.md:**

   <HARD-GATE>
   禁止编排器自行评审 test_spec.md。必须通过 Agent 工具调度 kanban-test-spec-reviewer subagent。
   编排器自行评审 = 违反 IR-01，评审结果无效。
   </HARD-GATE>

   ```bash
   python3 -m core workflow get-phase-agents spec_review
   ```
   默认: `{"role": "test_spec_reviewer", "required": true, "agent_type": "kanban-test-spec-reviewer", "subagent_required": true}`
   - 多维度评分: 覆盖率、边界用例、可执行性
   - 产出: `{report_dir}/spec_review_report.json`
   - 不达标 → 回到 qa_spec 修改（最多 `max_rounds` 轮）
19. Guard check: `python3 -m core guard check-artifacts "$task_id" spec_review`
20. `python3 -m core workflow complete-phase "$task_id"`

#### Phase 2: Execute

**触发条件:** Plan 完成后自动进入，或 `--phase execute`

**Agent 配置:** Executor 角色从 `workflow.json` 的 `execute` 阶段 `agents` 数组中读取。默认配置为 `{"role": "executor", "required": true, "subagent_required": true}`。可通过在该数组中添加条目来引入额外的 execute 阶段 agent（如专用的测试 agent 或文档生成 agent）。

**轻量模式 (Lightweight Mode):** Plan 完成后，系统自动评估任务复杂度（改动范围、风险大小、影响面），若符合以下条件可建议轻量模式：
- 改动文件数 <= 5 个
- 不涉及架构变更
- 不涉及破坏性 API 变更
- 风险较低（清理、命名修正、简单配置等）

轻量模式调整：
- Execute 阶段：**跳过 git worktree**，直接在当前分支工作
- Evaluate 阶段：**简化为用户自验收**，跳过 4 Agent 并行评估

**轻量模式触发条件与硬性门控：**

轻量模式条件（全部满足才触发）：改动文件 <= 5 + 无架构变更 + 无破坏性 API 变更 + 低风险。

当 `cmd_run` 返回 `lightweight_available: true` 且 `requires_confirmation: true` 时：
- 用户显式传入 `--lightweight` → 跳过询问，直接启用
- `auto_lightweight == True` → kanban-auto-decider Agent 自动评估选择
- 其他情况 → **必须** AskUserQuestion（启用轻量模式 / 走标准流程），禁止自动启用

**强制 worktree 约束 (标准模式):** Worktree 路径统一为 `.kanban/tasks/TASK-NNN/worktree/`。Guard 自动创建。轻量模式下跳过。

**Execute 阶段流程：**

0. **轻量模式确认（不可跳过）：** `python3 -m core run "$task_id" --phase execute` 返回 lightweight 状态。按上方门控规则处理。

1. 创建 worktree (幂等，路径: `.kanban/tasks/{task_id}/worktree/`):
   ```bash
   python3 -m core worktree create "$task_id"
   ```
2. `python3 -m core workflow transition "$task_id" execute`
3. 准备调度上下文:
   ```bash
   python3 -m core prepare-dispatch "$task_id"
   ```
4. 读取 Plan 产物:
   - `plan.md` — writing-plans 产出的 bite-sized 实现步骤（**executor 的主要工作指南**）
   - `task_breakdown.json` — 元数据（依赖排序、并行调度、文件追踪）
5. **按 plan.md 中的 Task 逐步调度 executor Subagent (subagent_required: true — 必须使用 Agent 工具调度):**
   - **禁止编排器自行编写代码** — 每个 subtask 必须通过 Agent 工具调度独立的 executor subagent
   - 用 task_breakdown.json 做依赖排序和并行分组
   - 无依赖 + 无文件冲突的 subtask 并行调度多个 executor subagent (不超过 config.scheduler.max_parallel)
   - 有依赖或共享文件的 subtask 等待前序完成后串行执行
   - 每个 subtask 的执行流程:
     a. `python3 -m core subtask update "$task_id" "$subtask_id" in_progress`
     b. 调度 **executor Agent**:
        ```
        Agent(subagent_type="general-purpose", mode="bypassPermissions")
        prompt: 你是 Executor Agent。任务信息:
        - task_id: {task_id}
        - subtask: {subtask_id} -- {subtask_title}
        - worktree_path: {wt_path}
        - output_dir: {output_dir}
        - plan_path: {task_dir}/plan.md
        - test_spec_path: {task_dir}/test_spec.md
        - spec_review_path: {report_dir}/spec_review_report.json
        - requirements_path: {task_dir}/requirements.md
        - report_dir: {report_dir}

        项目结构约定（强制）:
        - 所有代码必须放在 {output_dir}/{task-name}/ 目录下
        - 测试文件必须放在 {output_dir}/{task-name}/test/ 或 __tests__/ 目录下

        请执行 plan.md 中此 Task 的所有 step:
        1. 读取 {task_dir}/plan.md，找到你的 Task 对应的章节
        2. 读取 {task_dir}/test_spec.md，确认你负责的测试用例规格
        3. 读取 {report_dir}/spec_review_report.json，关注 Critical Issues
        4. 按 plan.md 中每个 step 逐一执行: 写测试 → 验证失败 → 写实现 → 验证通过 → commit
        5. 确保 test_spec.md 中相关用例全部覆盖，spec_review 的 Critical Issues 已处理
        6. 测试文件必须放在 {output_dir}/{task-name}/test/ 或 __tests__/ 目录下
        7. 所有 step 完成后，记录完成状态
        ```
     c. 检查 plan.md 中该 Task 指定的文件是否已生成
     d. **每个 subtask 完成后强制执行 git commit + progress 更新 (Issue #123):**
        ```bash
        cd "{wt_path}"
        git add {changed_files}
        git commit -m "feat({subtask_id}): {subtask_title} ({task_id}, iteration {iter})"
        COMMIT_HASH=$(git rev-parse HEAD)
        python3 -m core subtask done "{task_id}" "{subtask_id}" --commit-hash "$COMMIT_HASH"
        ```
        目的: 崩溃后可基于 progress.json 和 git log 恢复进度 (Issue #123)。
        progress.json 记录: commit hash、文件清单、完成时间。
     e. 成功 -> `python3 -m core subtask update "$task_id" "$subtask_id" completed`
     f. 失败 -> `python3 -m core subtask update "$task_id" "$subtask_id" failed`
   - 缺失文件则重试该 Task (最多 2 次，每次提供更详细提示)
6. 所有 subtask 完成后，单独调度一个 **报告 Agent**:
   ```
   Agent(subagent_type="general-purpose", mode="bypassPermissions")
   prompt: 为任务 {task_id} 编写执行报告:
   - 读取 worktree 中的所有代码变更
   - 编写 {report_dir}/execution_summary.md (实现了什么、文件清单)
   - 编写 {report_dir}/execution_pitfalls.md (遇到的问题和解决方法)
   - 编写 {report_dir}/execution_decisions.md (技术决策和原因)
   ```
7. 检查产物:
   ```bash
   python3 -m core guard check-artifacts "$task_id" execute
   ```
   如果产物不完整，提示 Agent 补全
8. **提交代码到 worktree 的 git 分支:**
   ```bash
   cd "$wt_path"
   git add "{output_dir}/"
   git commit -m "feat: implement {title} ({task_id}, iteration {iter})

   {简要描述本次迭代实现的内容}

   Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>"
   ```
   - 仅 add `{output_dir}/` 目录，不要 add 其他文件
   - commit message 格式: `feat: {任务标题} ({task_id}, iteration {N})`
   - hot iteration 使用: `fix: {修复摘要} ({task_id}, iteration {N})`
9. `python3 -m core workflow complete-phase "$task_id"`

#### Phase 3: Evaluate

**触发条件:** Execute 完成后自动进入，或 `--phase evaluate`

**轻量模式 (Lightweight Mode):** 若已启用轻量模式，简化为用户自验收：
- **先生成验收文档 (acceptance.md)** — 读取 requirements.md 中的验收标准，汇总执行结果，写入 `{task_dir}/acceptance.md`（包含快速验收清单、按需求验收、文件变更一览、已知遗留）
- 展示 acceptance.md 内容和变更摘要给用户
- 用户确认通过 → 直接进入 User Decision
- 用户发现问题 → 回到 Execute 修正

**标准模式:**

1. `python3 -m core workflow transition "$task_id" evaluate`
2. **动态读取评估角色列表:**
   ```bash
   python3 -m core workflow get-roles evaluate
   ```
   角色列表从 `workflow.json` 的 `evaluate` 阶段 `agents` 数组中动态读取。默认配置包含 4 个内置角色 (code_reviewer, qa, pm, designer)，但可通过 `agents` 数组添加自定义评估 agent 或移除内置 agent。Python CLI 内部提供完整的 agent 配置解析（含 parallel/required/file 等字段）。未定义 `agents` 时回退到内置默认 4 角色。
3. `python3 -m core evaluator prepare-all "$task_id"` -- 基于动态角色列表准备调度上下文，为每个角色生成 dispatch JSON
4. **并行启动评估 Agent:**

   对每个角色（从 workflow.json 中 evaluate.agents 配置获取）启动独立 Agent:

   ```
   Agent(subagent_type="general-purpose", run_in_background=true)
   prompt: 扮演 {role} 角色，评估任务 {task_id} 的实现。
           - task_id: {task_id}
           - worktree_path: {wt_path}
           - report_dir: {report_dir}
           - dispatch_dir: {dispatch_dir}
           读取 dispatch 文件: {dispatch_dir}/{task_id}-{role}.json
           按照角色定义的评分标准评估代码。
           将报告写入: {report_dir}/{role}_report.json
   ```

   **默认内置角色职责** (可通过 `workflow.json` 的 `evaluate.agents` 数组自定义，由 Python agent registry 动态解析):
   - code_reviewer: 审核 architecture, code_quality, security, test_coverage
   - qa: 验证 test_completeness, boundary_coverage, error_handling, acceptance_criteria
   - pm: 验证 requirement_coverage, user_experience, completeness, acceptance_criteria
   - designer: 评审 api_design, module_structure, extensibility, consistency

   以上 4 个角色是 `workflow.json` 中 `evaluate` 阶段的默认配置。用户可通过修改 `evaluate.agents` 数组添加自定义评估角色（如安全审计、性能分析）、移除或替换内置角色。Python CLI 在运行时返回实际配置的角色列表，而非硬编码值。

5. 等待所有 Agent 完成
6. 收集评分: `python3 -m core evaluator record-score "$task_id"` → `collect-scores "$task_id"`
7. 提取 improvement_suggestions → C 类条目写入 progress.json
8. `python3 -m core workflow complete-phase "$task_id"`
9. **立即进入自迭代判断**

#### 自迭代判断

<HARD-GATE>
EVALUATE 完成后必须自动进入自迭代判断。hot/full 时自动跳回，禁止询问用户。
任意时刻都不可绕过此门禁。唯一合法出口：all_pass 或 max_reached。
</HARD-GATE>

> **铁律 (IR-04/08/09/17): Evaluate 完成后必须自动进入自迭代判断。hot/full 时自动跳回，禁止询问用户。**

1. **计算平均分:** required 角色报告的各维度算术平均值，缺失报告维度 = 0
2. **执行判断:** `python3 -m core workflow self-improve-check "$task_id" --avg-score "$avg"` → all_pass | max_reached | hot | full
3. **自动执行（禁止询问）:**

| 结果 | 条件 | 动作 |
|------|------|------|
| **all_pass** | 所有 required >= pass_threshold（默认 9.0） | → Retrospective |
| **max_reached** | 迭代 >= 6 | → Retrospective → User Decision |
| **hot** | >= 7.0 且无架构问题 | → 自动 `start-iteration hot`，跳回 Execute |
| **full** | < 7.0 或有架构问题 | → 自动 `start-iteration full`，跳回 Plan |

**架构问题判定:** designer 的 architecture < 5/10，或 code_reviewer 标记 `architectural_issue: true`。

**HARD-GATE 禁止事项:** 禁止在 hot/full 时询问用户、禁止绕过自迭代、迭代未达上限且未通过时唯一合法路径是自动跳回。

**异常处理:** 若 `self-improve-check` 失败，编排器自行计算平均分按上表规则决策，不得跳过。

#### Phase 4: Retrospective（必经阶段 — all_pass 或 max_reached 后自动进入）

> **触发时机:** 仅在自迭代判断返回 all_pass 或 max_reached 后进入。hot/full 时不可进入此阶段。

**前置条件:** 评估报告已全部生成，评分已记录。

1. `python3 -m core workflow transition "$task_id" retrospective`
2. **调度 Retrospective Agent：** 从 workflow.json 读取 retrospective agents 配置。
   - **并行模式**（含 `parallel: true`）：3 个 Agent（retrospective_writer / acceptance_writer / knowledge_extractor）以 `run_in_background=true` 并行启动，收集 knowledge_extractor 输出后调用 `python3 -m core knowledge add`
   - **串行回退**（未定义 agents）：单个 knowledge-manager Agent 串行执行全部工作
3. **复盘文档内容:** 任务目标回顾、需求分析摘要、技术方案摘要、评分趋势、经验教训（from pitfalls）、技术决策（from decisions）、知识沉淀（IR-06，至少 1 条新条目）
4. **验收文档 (acceptance.md):** 含快速验收清单（表格，状态 + 可复制 bash 命令）、按 FR 分组的验收点、文件变更一览、已知遗留
5. Guard: `python3 -m core guard check-artifacts "$task_id" retrospective`
6. `python3 -m core workflow complete-phase "$task_id"`
7. 自动进入 User Decision

#### Phase 5: User Decision

<HARD-GATE>
归档须用户显式执行 approve_and_archive（IR-11）。禁止自动归档。
此阶段仅当自迭代已用尽（all_pass 或 max_reached）时才可达。
</HARD-GATE>

**触发条件:** Retrospective 完成后自动进入。

**前置条件:** retrospective.md + acceptance.md 必须已生成。

1. `python3 -m core workflow transition "$task_id" user_decision`
2. **展示验收文档** — 读取 `{task_dir}/acceptance.md` 内容展示给用户
3. **展示复盘总结文档** — 读取 `{task_dir}/retrospective.md` 内容展示给用户
4. `python3 -m core summary "$task_id"` -- 展示迭代摘要（评分趋势、扣分项）
5. Python CLI 输出结构化 JSON 展示变更摘要
6. 等待用户决策（仅以下两个选项）:
   - **用户确认归档** → 执行 `approve_and_archive`（合并 worktree + 归档）
   - **用户放弃归档** → 执行 `abort`（仅归档，不合并代码）

   > **注意:** 如果用户在 max_reached 状态下觉得质量不够，可以手动执行 `/kanban decide TASK-NNN --action restart_from_execute` 或 `restart_from_plan` 额外迭代。但编排器不应主动提供这些选项 — 它们仅作为用户知晓的逃生舱口存在。

---

## FSM 流转总览

```
Plan (brainstorming + writing-plans)
  │  ├─ design.md + plan.md + requirements.md + task_breakdown.json
  │  └─ Guard: check-artifacts plan
  ▼
Plan Review (6 维度并行评审 / 串行回退)
  │  ├─ plan_review_report.json
  │  └─ Guard: score >= pass_threshold, max max_rounds 轮
  ▼
QA Spec (kanban-qa subagent 生成 test_spec.md)
  │  └─ Guard: check-artifacts qa_spec
  ▼
Spec Review (kanban-test-spec-reviewer subagent 评审)
  │  ├─ spec_review_report.json
  │  └─ Guard: score >= pass_threshold, max max_rounds 轮
  ▼
Execute (编码实现 + 测试)
  │  ├─ subtask 按 plan.md 逐步执行 + git commit
  │  ├─ execution_summary/pitfalls/decisions
  │  └─ Guard: check-artifacts execute
  ▼
Evaluate (4 角色并行评估)
  │  ├─ code_reviewer/qa/pm/designer 报告
  │  └─ collect-scores → record-score
  ▼
自迭代判断 (HARD-GATE — 禁止询问用户)
  ├─ all_pass (all >= pass_threshold) ──→ Retrospective → User Decision → Archive
  ├─ max_reached (iter >= max_iterations) ──→ Retrospective → User Decision → Archive
  ├─ hot (>= 7.0, 无架构问题) ─→ Execute (iter N+1)  ← 自动
  └─ full (< 7.0 或架构问题) ──→ Plan (iter N+1)      ← 自动
```

**编排器在每个阶段转换前必须对照「编排器决策清单」逐项核实。** 清单位于本文档顶部（环境设置之前）。

<HARD-GATE>
阶段顺序不可跳过。`complete-phase` 自动验证 history 包含全部前置阶段。
跳过任何阶段（如 plan → execute 跳过 plan_review/qa_spec/spec_review）→ Guard 拦截 → 必须回退到正确阶段。
不可将错就错。
</HARD-GATE>

**关键约束:**
- hot/full 自动跳转时**禁止**展示选项给用户
- Retrospective 仅在 all_pass/max_reached 时可达
- User Decision 仅在自迭代用尽后可达

---

#### Phase 6: Archive

1. `python3 -m core workflow transition "$task_id" archive`
2. **动态调度 archive 阶段 Agent:**
   Archive 阶段的 agent 列表从 `workflow.json` 的 `archive` 阶段 `agents` 数组中读取。默认配置包含 `{"role": "knowledge-manager", "required": false}`。Knowledge-manager 负责从本次任务的执行产物中提取经验教训，沉淀到 `knowledge-log.md`。未定义 `agents` 时跳过 archive 阶段的 agent 调度。
3. **Retrospective 存在性检查 (Guard 第6层):**
   ```bash
   # 归档前强制验证 retrospective.md 存在
   # 双路径检查: 任务根目录优先，iteration 子目录回退
   ```
4. **Inbox 待处理检查 (Guard 第7层):**
   ```bash
   python3 -m core guard check-inbox "$task_id"
   ```
   - 检查 inbox.md 的 "## 待处理" section 下是否有任何非空非注释行 (支持 `- [ ]`、`1.`、`* ` 等所有格式)
   - 有待处理反馈 -> 阻止归档，提示用户先运行 `/kanban feedback`
   - inbox 不存在或无待处理 -> 通过
   - abort 操作时跳过此检查
   **Inbox 归档纪律:**
   - Agent 无权自行将 inbox 待处理内容移到已归档区
   - 待处理反馈必须在当前任务中实际处理完成，才能标记为已归档
   - 不属于当前任务范围的反馈，需用户确认后才能标记为"迁移至其他任务"
   - 只有"## 待处理"区为空（或仅有注释/空行）时才允许归档
   - **迁移回标**: inbox 反馈迁移到其他任务处理时，原条目必须标记为 `[x]` 并追加 `→ 已迁移至 TASK-NNN 处理`，确保跨任务追踪闭环
   - **Planner 禁止否决反馈**: Planner 在需求分析阶段不得自行将 inbox 反馈标记为"无需变更"或"已满足"，如有争议须标注 `[待用户确认]` 由用户最终决定
5. **框架自评估 (如果 enabled):**
   ```bash
   python3 -m core framework assess "$task_id"
   ```
   - 读取当前任务的 pitfalls 和 decisions
   - 检查框架规则完整性、agent 能力覆盖、shell 函数质量
   - 输出评估报告到 report_dir/framework_assessment.json
   - 评估不阻塞归档
6. **在 worktree 中提交最新代码 (如有未提交变更):**
   ```bash
   cd "$wt_path"
   if [ -n "$(git status --porcelain)" ]; then
     git add "{output_dir}/"
     git commit -m "fix: final fixes before merge ({task_id})"
   fi
   ```
7. 如果 worktree 存在，执行合并:
   ```bash
   python3 -m core worktree merge "$task_id"
   python3 -m core worktree cleanup "$task_id"
   ```
8. **如果 worktree 不存在 (兜底逻辑):**
   - 检查主目录是否有未提交变更
   - 如果有，创建 fixup commit: `git commit -m "fixup: {task_id} changes (worktree unavailable)"`
   - 记录到 task history
9. **归档前综合执行产物（多迭代任务）：**
   如果任务经历过多次迭代，归档前需综合所有迭代的执行产物：
   ```bash
   python3 -m core workflow collect-iteration-artifacts "$task_id"
   ```
   返回所有迭代的 `execution_summary.md`、`execution_pitfalls.md`、`execution_decisions.md` 内容。
   编排器使用 LLM 综合所有迭代轮次的产物，生成最终版本写入任务根目录：
   - `execution_summary.md` — 跨迭代的综合执行摘要
   - `execution_pitfalls.md` — 跨迭代的问题汇总
   - `execution_decisions.md` — 跨迭代的决策总结
   单迭代任务无需此步骤（根目录已有最终版本）。
10. `python3 -m core archive "$task_id"`
   - 将整个 `tasks/{task_id}/` 目录移动到 `archive/{task_id}/`
   - 包含 Inbox 待处理检查的二次防线 (非 abort 操作时)
   - 包含 Inbox 待处理检查的二次防线 (非 abort 操作时)

### `/kanban decide <task_id> --action <action> [--feedback "..."]`

1. 执行 `python3 -m core decide "$task_id" --action "$action" --feedback "$feedback"`
2. 根据 action 执行后续:
   - approve_and_archive -> 合并 + 归档
   - restart_from_plan -> 重新运行从 plan 开始
   - restart_from_execute -> 重新运行从 execute 开始
   - abort -> 直接归档

### `/kanban recover [<task_id>]`

1. 如果指定 task_id: `python3 -m core recover "$task_id"`
2. 如果不指定: `python3 -m core recover --list` -> 列出所有中断任务
3. 超时检测: `python3 -m core recover --check-timeout "$task_id"`

### `/kanban resume <task_id>`

恢复中断任务，从 last_known_phase 继续执行。支持 Subtask 级检查点恢复 (ST-008, GitHub Issue #37)。

1. 执行 `python3 -m core resume "$task_id"`
2. 内部调用 `recover_resume_task`: 读取 task.json 中的 last_known_phase，清除 interrupted 标记，将 phase_lock 重置为中断前的阶段
3. **Checkpoint 读取 (ST-008):** 扫描 `checkpoints/` 目录，识别已完成 (status=completed) 和进行中 (status=in_progress) 的 subtask，展示每个 subtask 的文件完成情况
4. **Subtask 断点恢复 (ST-008):** 调用 `recovery_restore_subtask` 读取 in_progress 检查点，列出已完成的文件，自动跳过已完成文件从下一个文件继续
5. 输出恢复路径引导信息 (如 `/kanban run TASK-NNN --phase execute`)
6. 验证 worktree (如恢复到 execute 阶段)

**检查点文件位置:** `.kanban/tasks/{task_id}/checkpoints/{subtask_id}.json`
**检查点数据结构:** `{"subtask", "started_at", "files_written": [], "status": "in_progress|completed", "completed_at", "git_commit_hash"}`

### `/kanban rollback <task_id>`

回滚中断任务到最近的安全检查点（上一阶段完成点）。

1. 执行 `python3 -m core rollback "$task_id"`
2. 内部调用 `recover_rollback_task`: 确定安全回滚点 (pending/plan/execute)，清空中断阶段的产物文件
3. 将 task.json 重置为回滚点状态
4. 输出回滚路径引导信息

### `/kanban score <task_id>`

执行 `python3 -m core score "$task_id"`，展示各维度评分和总分。

### `/kanban summary <task_id>`

执行 `python3 -m core summary "$task_id"`，展示迭代摘要（评分趋势、扣分项）。

### `/kanban evolve-skills`

执行 `python3 -m core evolve-skills`，列出候选 Skill 改进的状态 (applied/pending)。归档时自动提取 framework_assessment.json。

### `/kanban time [<task_id>]`

展示任务各阶段耗时。指定 task_id 显示该任务详情；不指定扫描所有活跃任务。

### `/kanban tokens <task_id>`

展示 Token 消耗（按阶段 + 按 Agent 分解 + 预算状态）。注意：token 消耗无法自动获取，需使用方在 Agent 调用后手动记录。

### `/kanban feedback <task_id>`

分析归档 inbox 中的用户反馈。

1. `python3 -m core feedback read-pending "$task_id"` -- 读取待处理反馈
2. 如果无待处理项，提示 "无待处理反馈" 并退出
3. 启动 **planner Agent** 分析每条反馈:
   ```
   Agent(subagent_type="general-purpose", mode="bypassPermissions")
   prompt: 你是反馈分析 Agent。任务信息:
   - task_id: {task_id}
   - title: {title}
   - feedbacks: {待处理反馈列表}

   请分析每条反馈:
   1. 分类为: 需求 / 问题 / 优化建议 / 其他
   2. 给出处理建议:
      - 需求 -> 追加到 requirements.md 的功能需求
      - 问题 -> 作为新 subtask 加入 task_breakdown.json
      - 优化建议 -> 记录到 execution_decisions.md
      - 其他 -> 仅归档记录
   3. 输出 JSON 格式的分析结果到 {report_dir}/feedback_analysis.json
   ```
4. 展示分析结果，等待用户确认
5. 确认后对每条反馈调用 `python3 -m core feedback archive` 归档
6. 根据分类执行后续操作:
   - 需求类 -> 追加到任务根目录的 `requirements.md` 末尾
   - 问题类 -> 提示用户可运行 `/kanban run {task_id} --phase execute` 处理

### `/kanban inbox <subcommand>`

管理任务级别的用户反馈渠道。

- `inbox list` — 列出全局 inbox
- `inbox add <task_id> "<反馈内容>"` — 向任务 inbox.md 添加待办事项（格式 `- [ ] 反馈内容`）
- `inbox archive <task_id>` — 将已勾选项移到 inbox-archive.md

inbox.md 在任务创建时自动生成模板。归档纪律见 IR-11 和 Guard check-inbox 说明。

### `/kanban dashboard [start|stop|status|restart]`

1. 解析子命令（默认 start）
2. 执行 `python3 -m core dashboard "$action"`
3. start: 从 skills 源目录启动 Dashboard 服务器并打开浏览器
4. stop: 停止 Dashboard 服务器
5. status: 显示 Dashboard 运行状态

默认端口: 3000 (可在 config.json dashboard.port 中配置)
Dashboard 源路径: .claude/skills/kanban/dashboard/ (server.js 从此目录启动)
运行时数据目录: .kanban/dashboard/ (仅存放 .pid, .log 文件)

### `/kanban version list`

1. 执行 `python3 -m core version list`

### `/kanban version record <version> [--title "..."] [--task TASK-NNN]`

1. 执行 `python3 -m core version record "$version" --title "$title" --task "$task_id"`
2. 自动生成版本记录文件 `.kanban/versions/v{version}.md`
3. 更新 `.kanban/versions/CHANGELOG.md` 索引
4. 更新 `.kanban/config.json` 中的 `version` 字段
5. 同步更新 `.claude-plugin/plugin.json` 中的 `version` 字段
6. 创建 git tag `v{version}`

**版本记录触发条件:**
- 每次任务归档后（task merge 到 main），如果涉及框架文件变更（.claude/skills/、.claude/agents/、.claude/rules/），应执行 `/kanban version record`
- 版本号遵循语义化版本: PATCH 用于 bug 修复，MINOR 用于功能增强，MAJOR 用于破坏性变更

### `/kanban subtask start <task_id> <subtask_id>`

标记 subtask 开始，写入 progress.json。

1. 执行 `python3 -m core subtask start "$task_id" "$subtask_id"`
2. 在 `{task_dir}/progress.json` 中记录 subtask 开始时间和状态

### `/kanban subtask done <task_id> <subtask_id> [--commit-hash <hash>]`

标记 subtask 完成，记录 commit 信息到 progress.json。

1. 执行 `python3 -m core subtask done "$task_id" "$subtask_id" [--commit-hash "$hash"]`
2. 更新 `{task_dir}/progress.json`，记录:
   - `status: "completed"` — 完成状态
   - `commit_hash` — git commit SHA（通过 --commit-hash 传入）
   - `files` — 变更文件列表（通过 --files 传入）
   - `completed_at` — 完成时间戳
3. 崩溃恢复用途: 可基于 progress.json + git log 恢复进度 (Issue #123)

### `/kanban progress <task_id>`

查看任务进度明细。

1. 执行 `python3 -m core progress "$task_id"`
2. 读取 `{task_dir}/progress.json` 展示每个 subtask 的状态、时间、commit hash
3. 如果没有 progress.json，回退到迭代评分趋势展示

**C 类前缀（评估建议条目）:**
- 格式: C-001, C-002, ...
- 来源: Evaluate 阶段从评估报告自动提取
- 处理: 编排器在下次迭代前列出 C 类待办，决定是否纳入 subtask
- 记录在 progress.json 中，与 subtask 进度并列

### `/kanban clean <task_id>|--all|--before <date>`

清理已归档任务的磁盘资源。支持三种模式:

```
/kanban clean TASK-001              # 清理指定已归档任务
/kanban clean --all                 # 清理所有已归档任务
/kanban clean --before 2026-04-01   # 清理指定日期前归档的任务
```

**实现流程:**

1. 解析参数: task_id / --all / --before date
2. 收集候选任务列表 (从 `.kanban/archive/` 目录扫描)
3. **安全检查**: 仅清理 `user_decision.action` 为 `approve_and_archive` 或 `abort` 的任务，跳过异常状态任务
4. 显示预览列表 (任务 ID、大小、操作类型、标题)
5. 执行清理:
   - 删除归档目录 `.kanban/archive/TASK-NNN/`
   - 清理残留 worktree 目录
   - 清理残留 git 分支
   - 清理残留 candidate JSON
6. 显示清理结果 (清理数量、释放空间)
7. 更新 index.json

**安全性:** 清理前验证归档状态，不删除未完成归档的任务。幂等: 已清理的任务跳过不报错。

### `/kanban knowledge search <keyword> [--tag <tag>] [--task <TASK-ID>]`

搜索知识库。`--tag` 支持 架构/流程/工具/踩坑/优化（含英文别名），`--task` 按来源任务过滤。不区分大小写，结果按编号排序。

---

