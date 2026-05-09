---
name: kanban
description: "多 Agent 看板编排系统 -- 任务创建、FSM 工作流、多角色评估、自迭代、并行调度"
---

# Kanban 多 Agent 编排系统

基于 FSM 的任务编排框架，将需求分析、编码执行、多角色评估、自迭代整合为标准化流程。

## 命令路由

### 自然语言路由

系统支持两种命令输入方式: **精确命令** 和 **自然语言**。路由优先级如下:

1. **优先匹配精确命令格式** -- 如果用户输入匹配 `/kanban <command>` 的精确格式 (如 `/kanban status`、`/kanban run TASK-001`)，直接进入对应命令的执行流程
2. **自然语言解析（LLM 推理）** -- 如果精确匹配失败，调用 `python3 -m core nlp` 获取命令列表，由当前 LLM 直接推理用户意图并映射到对应命令。

#### 自然语言解析流程

```
1. python3 -m core nlp "$user_input"  → 返回 {"input": "...", "interpret_by_llm": true, "available_commands": [...]}
2. 当前 LLM 根据 input 语义 + available_commands 列表推理最匹配的命令
3. 直接执行匹配到的精确命令
```

不再使用关键词匹配。LLM 直接理解语义，覆盖所有自然表达。

---

### 精确命令列表

当用户调用 `/kanban` 时，解析子命令并执行:

```
/kanban init                                    # 初始化 .kanban/ 目录
/kanban create "<title>" [--desc "<desc>"]      # 创建任务
/kanban status                                  # 查看看板状态
/kanban show <task_id>                          # 查看任务详情
/kanban run <task_id>                           # 运行任务 (完整 FSM 循环)
/kanban run <task_id> --phase <phase>           # 从指定阶段运行
/kanban decide <task_id> --action <action>      # 用户决策
/kanban clean <task_id>                         # 清理指定已归档任务
/kanban clean --all                             # 清理所有已归档任务
/kanban clean --before <date>                   # 清理指定日期前的归档任务
/kanban recover [<task_id>]                     # 崩溃恢复
/kanban resume <task_id>                        # 恢复中断的任务
/kanban rollback <task_id>                      # 回滚中断的任务
/kanban evolve-skills                           # 查看 Skills 演化历史
/kanban score <task_id>                         # 查看评分
/kanban summary <task_id>                       # 迭代摘要
/kanban feedback <task_id>                      # 分析归档 inbox 反馈
/kanban time [<task_id>]                        # 查看任务执行耗时
/kanban tokens <task_id>                        # 查看任务 Token 消耗
/kanban dashboard [start|stop|status|restart]   # 启动/停止 Dashboard
/kanban version list                            # 查看版本历史
/kanban version record <version> [--title ...] [--task TASK-NNN]  # 记录版本
/kanban subtask start <task_id> <subtask_id>   # 标记 subtask 开始
/kanban subtask done <task_id> <subtask_id>    # 标记 subtask 完成
/kanban progress <task_id>                      # 查看任务进度
/kanban knowledge search <keyword> [--tag <分类>] [--task <TASK-ID>]  # 搜索知识库
```

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

---

## 各命令实现

### `/kanban init`

**首次运行必须完成 Python 解释器选择。** 已初始化过的项目 (`.kanban/config.json` 中已有 `python_bin`) 可跳过此步骤。

1. **选择 Python 解释器 (首次):**
   - 询问用户: "是否指定已有的 Python 解释器？例如系统 python3、conda 环境的 python、pyenv 的 python 等。输入完整路径或回车跳过（将自动创建 venv）。"
   - 用户提供路径 → 验证 `"<path>" --version` 返回 0 → 写入 `python_bin` 到 config.json
   - 用户跳过 → 检查 `venv/bin/python` 是否存在；不存在则 `python3 -m venv venv --clear`；写入 `"python_bin": "venv/bin/python"`
2. 执行 `python3 -m core init`
3. **注入 Iron Rules 到目标项目的 CLAUDE.md:**
   - 读取目标项目的 CLAUDE.md（如存在）
   - 如果 CLAUDE.md 不存在 → 创建新文件，写入 `# Iron Rules -- Kanban 框架铁律\n\n` 开头的铁律摘要 + 指向 `.claude/rules/iron-rules.md` 的引用
   - 如果 CLAUDE.md 存在但无 kanban 铁律 → 在文件末尾追加 `\n\n---\n\n` 分隔符 + 铁律摘要
   - 如果 CLAUDE.md 已包含 kanban 铁律 → 跳过（幂等）
   - 铁律摘要内容取自 kanban 框架自身的 CLAUDE.md 模板，IR 编号与 `.claude/rules/iron-rules.md` 保持同步
4. **安装框架依赖文件 (agents/rules 使用符号链接, dashboard 使用运行时目录):**
   ```bash
   SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
   # macOS/Linux: 创建符号链接; Windows (MINGW/MSYS): 回退到复制
   # agents: .claude/agents/kanban-planner.md -> ../skills/kanban/agents/kanban-planner.md
   mkdir -p .claude/agents
   for agent in "$SKILL_DIR"/agents/*.md; do
     name=$(basename "$agent")
     # 幂等: 已存在有效 symlink -> 跳过; regular file -> 删除后创建 symlink
     ln -sf "../skills/kanban/agents/$name" ".claude/agents/$name"
   done
   # rules: .claude/rules/output-dir-convention.md -> ../skills/kanban/rules/output-dir-convention.md
   mkdir -p .claude/rules
   for rule in "$SKILL_DIR"/rules/*.md; do
     name=$(basename "$rule")
     ln -sf "../skills/kanban/rules/$name" ".claude/rules/$name"
   done
   # dashboard: 创建运行时数据目录（不再复制源文件）
   # server.js 直接从 skills 源目录启动, .kanban/dashboard/ 仅存放 .pid, .log
   mkdir -p .kanban/dashboard
   ```
5. 确认输出: "Initialized kanban at .kanban/" + "Injected iron rules into CLAUDE.md" + "Linked N framework files (agents, rules via symlink)" + "dashboard runtime dir created"

### `/kanban create "<title>" [--desc "<desc>"]`

1. 解析 title 和可选 description
2. 执行 `python3 -m core create "$title" --desc "$description"`
3. 展示创建结果

### `/kanban status`

1. 执行 `python3 -m core status`

### `/kanban show <task_id>`

1. 执行 `python3 -m core show "$task_id"`

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
8. **从 plan.md 生成 task_breakdown.json (LLM 驱动):**
   - plan.md 由外部技能 (writing-plans) 产出，格式不可控，**禁止用 regex 解析**
   - 使用 LLM 将 plan.md 转换为 task_breakdown.json:
     1. 检查 plan.md 存在: `python3 -m core plan inspect "$task_id"`
     2. 将 plan.md 内容 + 以下 system prompt 发给当前 LLM 生成 JSON:

        ```
        You are a plan-to-JSON converter. Parse the implementation plan into task_breakdown.json.
        Output ONLY valid JSON, no markdown fences. Schema: { "task_name": "kebab-case",
        "subtasks": [{"id": "ST-001", "title": "...", "description": "...", "priority": 1,
        "estimated_files": [...], "dependencies": []}] }
        Extract every file path. Infer dependencies: if Task B modifies a file created
        in Task A, add ST-00A to Task B's dependencies.
        ```

     3. 将 LLM 输出保存: `echo '<llm_json>' | python3 -m core plan save "$task_id"`
     - CLI 自动校验 JSON schema（subtasks 非空、每个含 id/title/estimated_files）
   - 生成的 `task_breakdown.json` 供 executor 做依赖排序和并行调度
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
13. **调度 kanban-plan-reviewer Agent 独立审核 Plan 产物:**
   ```bash
   python3 -m core workflow get-phase-agents plan_review
   ```
   默认 agent: `{"role": "plan_reviewer", "required": true, "agent_type": "kanban-plan-reviewer"}`

   ```
   Agent(
     subagent_type="kanban-plan-reviewer",
     prompt: """
       你是 Plan Review Agent。请独立审核任务 {task_id} 的 Plan 产物。

       评分维度（6维，各1-10分，适用维度取均分）：
       1. requirement_clarity — 需求明确无歧义
       2. technical_feasibility — 技术方案可行、文件路径具体
       3. task_decomposition — subtask 粒度、依赖、优先级
       4. acceptance_criteria — 验收标准可测试可度量
       5. research_completeness — 调研充分性（无调研需求时不适用）
       6. parallel_safety — file_ownership 冲突检测

       审核文件：
       - {task_dir}/requirements.md
       - {task_dir}/task_breakdown.json

       产出 {report_dir}/plan_review_report.json（格式见 kanban-plan-reviewer agent 定义）
     """
   )
   ```
14. Guard 验证报告:
   ```bash
   python3 -m core guard check-plan-quality "$task_id" "$report_dir"
   python3 -m core guard check-artifacts "$task_id" plan_review
   ```
   - 总分 >= `pass_threshold` (默认 7.0) 通过
   - 不达标 → agent 修订 plan.md 后重试，最多 `max_rounds` (默认 3) 轮
   - 超限 → user_decision
15. `python3 -m core workflow complete-phase "$task_id"`

##### Plan Step C: 测试用例规格 (qa_spec)

13. `python3 -m core workflow complete-phase "$task_id"` (from plan_review)
14. **调度 QA Agent 生成 test_spec.md:**
   ```bash
   python3 -m core workflow get-phase-agents qa_spec
   ```
   从 `workflow.json` 的 `qa_spec` 阶段读取 Agent 配置。
   默认: `{"role": "qa", "required": true, "agent_type": "kanban-qa", "mode": "spec"}`
   - 输入: `plan.md` + `requirements.md`
   - 产出: `{task_dir}/test_spec.md`
   - 内容: 单元测试用例列表 + 手动验证清单
15. Guard check: `python3 -m core guard check-artifacts "$task_id" qa_spec`
16. `python3 -m core workflow complete-phase "$task_id"`

##### Plan Step D: 测试用例评审 (spec_review)

17. `python3 -m core workflow complete-phase "$task_id"` (from qa_spec)
18. **调度 test-spec-reviewer Agent 评审 test_spec.md:**
   ```bash
   python3 -m core workflow get-phase-agents spec_review
   ```
   默认: `{"role": "test_spec_reviewer", "required": true, "agent_type": "kanban-test-spec-reviewer"}`
   - 多维度评分: 覆盖率、边界用例、可执行性
   - 产出: `{report_dir}/spec_review_report.json`
   - 不达标 → 回到 qa_spec 修改 (max_rounds=3)
19. Guard check: `python3 -m core guard check-artifacts "$task_id" spec_review`
20. `python3 -m core workflow complete-phase "$task_id"`

#### Phase 2: Execute

**触发条件:** Plan 完成后自动进入，或 `--phase execute`

**Agent 配置:** Executor 角色从 `workflow.json` 的 `execute` 阶段 `agents` 数组中读取。默认配置为 `{"role": "executor", "required": true}`。可通过在该数组中添加条目来引入额外的 execute 阶段 agent（如专用的测试 agent 或文档生成 agent）。

**轻量模式 (Lightweight Mode):** Plan 完成后，系统自动评估任务复杂度（改动范围、风险大小、影响面），若符合以下条件可建议轻量模式：
- 改动文件数 <= 5 个
- 不涉及架构变更
- 不涉及破坏性 API 变更
- 风险较低（清理、命名修正、简单配置等）

轻量模式调整：
- Execute 阶段：**跳过 git worktree**，直接在当前分支工作
- Evaluate 阶段：**简化为用户自验收**，跳过 4 Agent 并行评估

**硬性门控 — 用户确认（不可跳过）：**

当 `cmd_run` 返回 `lightweight_available: true` 且 `requires_confirmation: true` 时，编排器**必须**使用 `AskUserQuestion` 询问用户：

```
AskUserQuestion(
  questions: [{
    question: "检测到任务符合轻量模式条件，是否启用轻量模式？（跳过 worktree + 简化评估）",
    header: "轻量模式",
    options: [
      {label: "启用轻量模式", description: "跳过 git worktree，直接在当前分支工作，评估简化为自验收"},
      {label: "走标准流程（推荐）", description: "创建 worktree 隔离 + 4 Agent 并行评估"}
    ]
  }]
)
```

- 用户选择「启用轻量模式」→ 后续 `run` 传入 `--lightweight` flag
- 用户选择「走标准流程」→ 正常走完整流程
- **禁止**在未经用户确认的情况下自动启用轻量模式
- 仅当用户显式传入 `--lightweight` flag 时 (`lightweight: true`)，跳过询问直接启用

**强制 worktree 约束 (标准模式):** 任务进入 Execute 阶段时创建 worktree。Worktree 路径统一为 `.kanban/tasks/TASK-NNN/worktree/`。Guard 自动创建: 如果 worktree 不存在，自动尝试创建。创建失败时阻止进入 Execute 阶段，返回 `FAIL:worktree_not_found`。轻量模式下跳过此约束。

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
5. **按 plan.md 中的 Task 逐步调度 executor Agent:**
   - 用 task_breakdown.json 做依赖排序和并行分组
   - 无依赖的 Task 可并行执行 (不超过 config.scheduler.max_parallel)
   - 有依赖的 Task 等待前序完成后串行执行
   - 每个 Task 的执行流程:
     a. `python3 -m core subtask update "$task_id" "$subtask_id" in_progress`
     b. 调度 **executor Agent**:
        ```
        Agent(subagent_type="kanban-executor", mode="bypassPermissions")
        prompt: 你是 Executor Agent。任务信息:
        - task_id: {task_id}
        - subtask: {subtask_id} -- {subtask_title}
        - worktree_path: {wt_path}
        - plan_path: {task_dir}/plan.md
        - report_dir: {report_dir}

        请执行 plan.md 中此 Task 的所有 step:
        1. 读取 {task_dir}/plan.md，找到你的 Task 对应的章节
        2. 按 plan.md 中每个 step 逐一执行: 写测试 → 验证失败 → 写实现 → 验证通过 → commit
        3. 所有 step 完成后，记录完成状态
        ```
     c. 检查 plan.md 中该 Task 指定的文件是否已生成
     d. 成功 -> `python3 -m core subtask update "$task_id" "$subtask_id" completed`
     e. 失败 -> `python3 -m core subtask update "$task_id" "$subtask_id" failed`
   - 缺失文件则重试该 Task (最多 2 次，每次提供更详细提示)
6. 所有 subtask 完成后，单独调度一个 **报告 Agent**:
   ```
   Agent(subagent_type="kanban-executor", mode="bypassPermissions")
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
- 展示变更摘要和验收清单给用户
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
   Agent(subagent_type="kanban-qa", run_in_background=true)
   prompt: 扮演 {role} 角色，评估任务 {task_id} 的实现。
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
6. 收集评分（基于动态角色列表）:
   ```bash
   python3 -m core evaluator record-score "$task_id"
   ```
7. `python3 -m core evaluator collect-scores "$task_id"` -- 展示评分
8. `python3 -m core workflow complete-phase "$task_id"`
9. **立即进入自迭代判断 — 不可跳过**

#### 自迭代判断 (HARD-GATE)

> **铁律执行: Evaluate 完成后必须自动进入自迭代判断。评分未通过阈值 + 未达最大迭代次数时，必须自动迭代（hot 或 full）。禁止在此阶段询问用户"是否继续迭代"。**

**背景:** 此 Gate 联合实施 IR-04（热迭代仅限无架构问题）、IR-08（自迭代不超过上限）、IR-09（评分标准严格统一）。其目的是在评估结果不理想时自动驱动质量改进循环，而非让用户在不知情的情况下批准不合格的工作。

1. **计算平均分:** 读取所有 required 角色的评分报告，计算各维度的算术平均值。对于缺失的报告（不完整的评估），将缺失维度视为 0 分。

2. **执行自迭代判断:**
   ```bash
   python3 -m core workflow self-improve-check "$task_id" --avg-score "$avg"
   ```
   返回: `all_pass` | `max_reached` | `hot` | `full`

3. **根据结果自动执行 — 禁止询问用户:**

   | 结果 | 条件 | 动作 |
   |---|---|---|
   | **all_pass** | 所有 required 评分 >= pass_threshold (默认 9.0) | 进入 Retrospective 阶段（最终复盘 + 知识沉淀） |
   | **max_reached** | 未通过 + 迭代次数 >= max_iterations (默认 6) | 进入 User Decision 阶段（用户最终裁定） |
   | **hot** | 平均分 >= 7.0 且无架构问题 | 自动执行 `start-iteration "$task_id" hot` → 跳回 Execute 阶段 |
   | **full** | 平均分 < 7.0 或存在架构问题 | 自动执行 `start-iteration "$task_id" full` → 跳回 Plan 阶段 |

   **架构问题的判定:** 当 designer 报告的 `architecture` 维度评分 < 5/10，或 code_reviewer 报告中明确标记了 `architectural_issue: true` 时，视为存在架构问题。

4. **迭代计数器:** 每次 hot/full 跳转时自动将 `task.iteration += 1`。迭代次数记录在 `task.json` 中。

5. **HARD-GATE 禁止事项:**
   - **禁止**在 hot/full 结果时进入 User Decision 或询问用户意见
   - **禁止**绕过自迭代直接进入 Retrospective 或 User Decision
   - **禁止**将 all_pass/max_reached 以外的情况呈现为"请用户选择"
   - 迭代次数 < max_iterations 且评分未通过时，**唯一合法的下一步是自动跳回**

6. **异常处理:** 如果 `self-improve-check` 命令失败（例如因缺少参数），编排器必须读取评估报告自行计算平均分，然后按照上述规则决定下一步动作。不得因 CLI 错误而跳过自迭代 Gate。

#### Phase 4: Retrospective（必经阶段 — all_pass 或 max_reached 后自动进入）

> **触发时机:** 仅在自迭代判断返回 all_pass 或 max_reached 后进入。hot/full 时不可进入此阶段。

**前置条件:** 评估报告已全部生成，评分已记录。

1. `python3 -m core workflow transition "$task_id" retrospective`
2. **读取迭代产物:**
   - 读取 `execution_pitfalls.md` -- 遇到的问题和解决方法
   - 读取 `execution_decisions.md` -- 技术决策和原因
   - 如果存在多个迭代，汇总所有迭代的 pitfalls 和 decisions
3. **生成复盘文档:**
   复盘文档应包含:
   - 任务目标回顾
   - 需求分析摘要
   - 技术方案摘要
   - 评分趋势 (各迭代评分变化)
   - 经验教训 (from execution_pitfalls)
   - 技术决策总结 (from execution_decisions)
   - 知识沉淀 (至少1条新知识条目写入 knowledge-log.md)
4. **知识沉淀 (IR-06):**
   - 从 pitfalls 和 decisions 中提取经验教训
   - 调用 `python3 -m core knowledge add` 写入 `knowledge-log.md`
   - 必须产出至少1条新知识条目
5. **生成验收文档 (acceptance.md):**
   - 读取 `requirements.md` 中的验收标准
   - 汇总所有迭代的执行结果
   - 写入 `{task_dir}/acceptance.md`，包含：
     - **快速验收清单**: 表格，每项含状态(✅/❌)、验证方法(可复制的bash命令)
     - **按需求验收**: 按 FR 分组，每个需求下列出验收点和验证命令
     - **文件变更一览**: 表格，新增/修改/删除的文件清单
     - **已知遗留**: 推迟处理或已知问题的清单
   - 验收文档面向最终用户，验证方法应具体可执行
6. 检查产物:
   ```bash
   python3 -m core guard check-artifacts "$task_id" retrospective
   ```
7. `python3 -m core workflow complete-phase "$task_id"`
8. 自动进入 User Decision 阶段

#### Phase 5: User Decision

**触发条件:** Retrospective 完成后自动进入。**此阶段仅当自迭代已用尽（all_pass 或 max_reached）时才可达。**

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
Plan (需求澄清 + 任务拆解)
  → Plan Review (plan-reviewer agent 6维审核)
  → QA Spec (qa agent 生成 test_spec.md)
  → Spec Review (spec-reviewer agent 5维审核)
  → Execute (编码实现 + 测试)
  → Evaluate (4角色并行评估)
  → 自迭代判断 (HARD-GATE)
      ├─ all_pass ────→ Retrospective → User Decision → Archive
      ├─ max_reached ─→ Retrospective → User Decision → Archive
      ├─ hot  ──→ Execute (iteration N+1)    ← 自动，不询问用户
      └─ full ──→ Plan (iteration N+1)       ← 自动，不询问用户
```

**关键约束:**
- Retrospective 是 all_pass/max_reached 的专属后续阶段，hot/full 时不可达
- User Decision 仅在自迭代用尽（all_pass 或 max_reached）时可达
- hot/full 自动跳转时**禁止**展示选项给用户
- 迭代次数 < max_iterations 且评分未通过时，**唯一合法路径是自动跳回**

### 阶段不可跳过 (HARD-GATE)

`complete-phase` 执行时自动调用 `guard check-phase-completeness` 验证 task history 包含所有前置阶段。跳过任何阶段（如 plan → execute 跳过 plan_review/qa_spec/spec_review）将被 Guard 拦截，抛出 GuardError 阻止阶段推进。

编排器必须严格按 PHASE_ORDER 逐一完成每个阶段，禁止手动跳阶段。

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
9. `python3 -m core archive "$task_id"`
   - 将整个 `tasks/{task_id}/` 目录移动到 `archive/{task_id}/`
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

1. `python3 -m core score "$task_id"`

### `/kanban summary <task_id>`

1. `python3 -m core summary "$task_id"`

### `/kanban evolve-skills`

显示 Skills 演化历史记录 (扫描 `.kanban/skills/evolved/` 中的已应用 candidates)。

1. `python3 -m core evolve-skills` -- 列出所有候选改进及其状态 (applied/pending)

**自动触发**: 任务归档时自动执行:
1. 从 execution_pitfalls.md 和 execution_decisions.md 提取框架改进点
2. agent/rule 类改进直接应用; lib 类改进创建 kanban 任务 (IR-12)
3. 生成 `skills_evolution_report.json` 存入 iteration 目录

### `/kanban time [<task_id>]`

展示任务各阶段的执行耗时。

1. 如果指定 `task_id`:
   - 执行 `python3 -m core time "$task_id"`
   - 解析该任务的 history 数组，提取每个阶段的 (phase, started_at, completed_at, duration_seconds)
   - 以表格输出
2. 如果不指定参数:
   - 执行 `python3 -m core time`
   - 扫描所有活跃任务，显示每个任务的最近阶段耗时

输出格式示例:
```
=== TASK-045 执行耗时 ===
Title: 耗时追踪与可视化
Phase         Started                  Completed                Duration
plan          2026-05-05T10:00:00Z     2026-05-05T10:15:00Z     15m 0s
execute       2026-05-05T10:15:00Z     -                        (running)
```

### `/kanban tokens <task_id>`

展示任务的 Token 消耗详情，包括按阶段和按 Agent 的分解，以及预算状态。

1. 执行 `python3 -m core tokens "$task_id"`
2. 读取 task.json 的 `token_stats` 字段，解析:
   - `per_phase`: 按阶段 (plan/execute/evaluate 等) 的 token 消耗
   - `per_agent`: 按 Agent (planner/executor/code_reviewer/qa/pm/designer) 的分配
3. 内部检查预算状态
4. 以表格输出消耗详情和预算警告

输出格式示例:
```
=== TASK-045 Token 消耗 ===
Phase         Tokens     占比
plan          20,000      17%
execute       80,000      67%
evaluate      20,000      16%
─────────────────────────────────────────
总计          120,000 / 500,000 (24%)

Agent 分布:
  planner:         20,000 (17%)
  executor:        80,000 (67%)
  code_reviewer:    5,000 (4%)
  qa:               5,000 (4%)
  pm:               5,000 (4%)
  designer:         5,000 (4%)

[OK] 预算状态: normal (已消耗 24%, 告警阈值 80%)
```

**集成说明**: 框架无法自动获取 Claude Code 的 token 消耗 (无 API 访问)。token 追踪由使用方在每次 Agent 调用后手动记录消耗量。

### `/kanban feedback <task_id>`

分析归档 inbox 中的用户反馈。

1. `python3 -m core feedback read-pending "$task_id"` -- 读取待处理反馈
2. 如果无待处理项，提示 "无待处理反馈" 并退出
3. 启动 **planner Agent** 分析每条反馈:
   ```
   Agent(subagent_type="kanban-planner", mode="bypassPermissions")
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

### `/kanban subtask done <task_id> <subtask_id>`

标记 subtask 完成，触发 git commit 并记录到 progress.json。

1. 执行 `python3 -m core subtask done "$task_id" "$subtask_id"`
2. 在 worktree 中执行 `git add -A` + `git commit -m "feat(ST-xxx): subtask_title (TASK-NNN)"`
3. 将 commit hash 和变更文件列表记录到 progress.json

### `/kanban progress <task_id>`

查看任务进度明细。

1. 执行 `python3 -m core progress "$task_id"`
2. 读取 `{task_dir}/progress.json` 展示每个 subtask 的状态、时间、commit hash
3. 如果没有 progress.json，回退到迭代评分趋势展示

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

搜索知识库 (`.kanban/knowledge-log.md`) 中的条目。

1. 执行 `python3 -m core knowledge search "$keyword" --tag "$tag" --task "$task"`
3. 支持:
   - 大小写不敏感的全文关键词搜索
   - `--tag` 参数按分类标签过滤 (架构/流程/工具/踩坑/优化)，支持英文别名 (如 `--tag architecture` 等同于 `--tag 架构`)
   - `--task` 参数按来源任务过滤 (如 `--task TASK-014`)
   - 返回匹配条目的完整上下文 (标题、分类、来源任务、描述)
   - 管道输出: 可被 `grep`、`less` 等命令进一步过滤
4. 搜索结果按知识条目编号排序

输出示例 (搜索 "函数"):
```
### K001: kanban_update_task 需支持 --arg 传参
- **分类**: 踩坑
- **来源**: TASK-014 (iteration 2)
- **描述**: kanban_decide 中将变量直接拼入 JSON 表达式...

---
```

---

## Agent 调度规范

Agent 调度基于 `workflow.json` 的 `agents` 数组动态进行，而非硬编码。每个阶段的 `agents` 数组定义了该阶段需要调度的 agent 列表，包含 `role`、`required`、`parallel`、`file`、`output` 等配置字段。通过 Python CLI 内置的 agent registry 模块在运行时动态解析。

Agent 定义在 `.claude/agents/` 目录，使用 Claude Code 原生 Agent 机制。
每个 agent 的 YAML frontmatter 定义了 model、tools、disallowedTools。

**动态调度机制:**
- `python3 -m core workflow get-phase-agents "<phase>"` -- 返回指定阶段的完整 agent 配置列表
- `python3 -m core workflow get-all-roles "<phase>"` -- 返回指定阶段所有 agent 的 role 名称
- `python3 -m core workflow get-required-roles "<phase>"` -- 仅返回 required=true 的 agent role 名称
- Agent 文件路径由 Python CLI 内部解析（内置 agent 从 `agents/` 目录加载，自定义 agent 支持相对路径）
- 未定义 `agents` 数组时回退到内置默认行为

**向后兼容:** 当 `workflow.json` 中某阶段未定义 `agents` 数组时，框架回退到硬编码的默认 agent 列表，确保现有项目无需修改即可继续运行。

### 项目结构约定

`.kanban/config.json` 中的 `output_dir` 字段定义产出代码的根目录名。
- 游戏项目: `"output_dir": "games"` -> 代码放在 `games/<task-name>/`
- 脚本项目: `"output_dir": "scripts"` -> 代码放在 `scripts/<task-name>/`
- 默认值: `"src"`（未配置时）

dispatch JSON 自动注入 `output_dir`，agent 调度时必须传入。

### Planner 调度

```
Agent(
  subagent_type="kanban-planner",
  mode="bypassPermissions",
  prompt: """
  你是 Planner Agent。任务信息:
  - task_id: {task_id}
  - title: {title}
  - description: {desc}
  - report_dir: {report_dir}
  - iteration: {iter}
  - output_dir: {output_dir}

  项目结构约定:
  - 代码必须放在 {output_dir}/<task-name>/ 目录下
  - <task-name> 使用英文小写短横线命名
  - 先用 ls {output_dir}/ 检查现有内容避免目录名冲突

  请执行需求分析和任务拆解:
  1. 分析项目现有结构（检查 {output_dir}/ 目录）
  2. 确定 task-name 并在 requirements.md 中明确指定目标路径
  3. 编写 {task_dir}/requirements.md（任务根目录，非 iteration 子目录）
  4. 编写 {task_dir}/task_breakdown.json（任务根目录，非 iteration 子目录）
  """
)
```

### Executor 调度

```
Agent(
  subagent_type="kanban-executor",
  mode="bypassPermissions",
  prompt: """
  你是 Executor Agent。任务信息:
  - task_id: {task_id}
  - title: {title}
  - worktree_path: {wt_path}
  - output_dir: {output_dir}
  - code_path: {wt_path}/{output_dir}/{task-name}/
  - report_dir: {report_dir}
  - iteration: {iter}

  项目结构约定（强制）:
  - 所有代码必须放在 {output_dir}/{task-name}/ 目录下
  - 禁止将代码放在 worktree 根目录或其他位置

  请执行编码实现:
  1. 读取 {task_dir}/requirements.md（任务根目录）
  2. 读取 {task_dir}/task_breakdown.json（任务根目录）
  3. 在 {output_dir}/{task-name}/ 中完成编码
  4. 编写单元测试
  5. 运行测试确认通过
  6. 编写 {report_dir}/execution_summary.md
  7. 编写 {report_dir}/execution_pitfalls.md
  8. 编写 {report_dir}/execution_decisions.md
  """
)
```

### 评估 Agent 调度

评估 Agent 列表从 `workflow.json` 的 `evaluate` 阶段 `agents` 数组动态读取。**默认配置**包含 4 个内置角色 (code_reviewer, qa, pm, designer)，均以 `run_in_background=true` 并行启动。这 4 个角色不是硬编码的固定列表，而是 `workflow.json` 中的默认值。用户可通过修改 `agents` 数组添加自定义评估角色、调整 `required` 标志、或移除/替换内置角色。Python CLI 内置的 agent registry 模块在运行时动态解析实际配置，框架不假设任何特定角色一定存在。

以下是默认配置下的调度模板:

```
Agent(
  subagent_type="{role}",        # 从 get_all_roles("evaluate") 动态获取
  run_in_background=true,
  prompt: """
  你是 {role} Agent。任务信息:
  - task_id: {task_id}
  - worktree_path: {wt_path}
  - report_dir: {report_dir}
  - iteration: {iter}

  请执行 {role} 角色评估:
  1. 读取 dispatch 文件: {dispatch_dir}/{task_id}-{role}.json
  2. 按照角色评分标准评估代码
  3. 将报告写入: {report_dir}/{role}_report.json
  """
)
```

注意: 评估类 Agent 在 `.claude/agents/` 定义中通过 `disallowedTools: [Write, Edit]`
实现工具级只读约束，无需在调度时额外限制。`required=false` 的评估 agent 评分不影响 pass_threshold 判断，评分展示中标注 "(optional)"。

---

## 路径规范

框架统一使用以下目录结构，Python CLI 内部处理所有路径解析:

```
task_dir(task_id)          # 任务目录: .kanban/tasks/TASK-NNN/
task_file(task_id)         # 任务 JSON: .kanban/tasks/TASK-NNN/task.json
report_dir(task_id, iter)  # 迭代产物目录: .kanban/tasks/TASK-NNN/iteration-N/
dispatch_dir(task_id)      # Dispatch 目录: .kanban/tasks/TASK-NNN/dispatch/
inbox_file(task_id)        # Inbox 文件: .kanban/tasks/TASK-NNN/inbox.md
archive_dir(task_id)       # 归档目录: .kanban/archive/TASK-NNN/
archive_task_file(task_id) # 归档 JSON: .kanban/archive/TASK-NNN/task.json
```

Python CLI 自动兼容新旧两种目录格式，优先检测新格式。

---

## 错误处理

- Guard 阻止时: 输出 "GUARD BLOCKED: {reason}"，停止当前阶段
- 产物缺失时: 提示 Agent 补全缺失的文件
- Agent 失败时: 记录到 history，标记 task 为 error 状态
- Worktree 冲突时: 提示用户手动解决

## 产物路径规则

内聚目录结构 (当前版本):

```
.kanban/
  config.json                    # 项目配置
  workflow.json                  # FSM 定义
  index.json                     # 看板索引
  tasks/TASK-NNN/
    task.json                    # 任务状态
    inbox.md                     # 用户反馈入口
    requirements.md              # Plan 产物（任务级，不随迭代变化）
    task_breakdown.json          # Plan 产物（任务级，不随迭代变化）
    retrospective.md             # 复盘文档（任务级，总结所有迭代）
    dispatch/
      TASK-NNN-execute.json      # Executor 调度上下文
      TASK-NNN-code_reviewer.json
      TASK-NNN-qa.json
      TASK-NNN-pm.json
      TASK-NNN-designer.json
    iteration-1/
      execution_summary.md       # Execute 产物
      execution_pitfalls.md      # Execute 产物
      execution_decisions.md     # Execute 产物
      framework_assessment.json  # 框架自评估产物
      code_reviewer_report.json
      qa_report.json
      pm_report.json
      designer_report.json
  archive/TASK-NNN/
    task.json                    # 归档后的任务 JSON
    inbox.md
    requirements.md              # 任务级文档归档
    task_breakdown.json
    retrospective.md
    iteration-1/
      ...
```

旧版目录结构兼容:
- 旧格式: `tasks/TASK-NNN.json`, `reports/TASK-NNN/`, `dispatch/`
- 框架自动检测并兼容旧格式，Python CLI 初始化时自动执行迁移
