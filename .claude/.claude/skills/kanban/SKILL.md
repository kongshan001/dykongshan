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
2. **自然语言解析** -- 如果精确匹配失败，调用 `kanban_nl_parse` 进行自然语言意图识别

#### 自然语言解析流程

```bash
# 1. 调用 NL 解析器
result=$(kanban_nl_parse "$user_input")

# 2. 判断解析是否成功
success=$(echo "$result" | jq -r '.success')

if [ "$success" = "true" ]; then
  # 3. 提取解析结果字段
  command=$(echo "$result" | jq -r '.command')
  task_id=$(echo "$result" | jq -r '.task_id')
  action=$(echo "$result" | jq -r '.action')
  args=$(echo "$result" | jq -c '.args')

  # 4. 按 command 字段进入对应命令的执行流程
  #    (与精确命令走完全相同的实现代码)
  case "$command" in
    init) ... ;;
    create) ... ;;
    status) ... ;;
    show) ... ;;
    run) ... ;;
    decide) ... ;;
    score) ... ;;
    summary) ... ;;
    clean) ... ;;
    recover) ... ;;
    dashboard) ... ;;
    version) ... ;;
  esac
else
  # 5. 解析失败时显示建议
  suggestion=$(echo "$result" | jq -r '.suggestion')
  echo "无法识别命令: $user_input"
  echo "$suggestion"
fi
```

#### 自然语言示例映射

| 用户自然语言 | 解析结果命令 |
|---|---|
| 帮我初始化看板 | /kanban init |
| 创建一个新任务叫"用户登录" | /kanban create "用户登录" |
| 看一下看板状态 | /kanban status |
| TASK-001的详情 | /kanban show TASK-001 |
| 跑一下TASK-001 | /kanban run TASK-001 |
| 帮我归档TASK-001 | /kanban decide TASK-001 --action approve_and_archive |
| 批准并归档 | /kanban decide TASK-001 --action approve_and_archive |
| 重新规划TASK-001 | /kanban decide TASK-001 --action restart_from_plan |
| 看看TASK-001评分 | /kanban score TASK-001 |
| TASK-001的摘要 | /kanban summary TASK-001 |
| 恢复任务 | /kanban recover |
| 打开Dashboard | /kanban dashboard start |
| 查看版本历史 | /kanban version list |
| 清理归档任务 | /kanban clean --all |
| 清理TASK-001 | /kanban clean TASK-001 |

#### 回退机制

当自然语言解析无法识别用户意图时 (`success: false`)，系统会:
- 显示无法识别的提示信息
- 列出所有可用的精确命令格式供用户参考
- 用户可使用精确命令格式重新输入

关键词匹配配置文件: `lib/nlp_patterns.json`，支持三级匹配: exact (置信度 1.0)、synonym (0.8)、fuzzy (0.6)。

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
/kanban evolve-skills                           # 查看 Skills 演化历史
/kanban score <task_id>                         # 查看评分
/kanban summary <task_id>                       # 迭代摘要
/kanban feedback <task_id>                      # 分析归档 inbox 反馈
/kanban dashboard [start|stop|status|restart]   # 启动/停止 Dashboard
/kanban version list                            # 查看版本历史
/kanban version record <version> [--title ...] [--task TASK-NNN]  # 记录版本
```

## 环境设置

每次执行前，source 核心库 (自动加载所有依赖):

```bash
KANBAN_DIR=".kanban"
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"  # Note: actual impl uses BASH_SOURCE[0] for reliable resolution
source "$SKILL_DIR/lib/kanban.sh"
# nlp_router.sh is auto-loaded by kanban_init_env via lib/*.sh glob
kanban_init_env
```

---

## 各命令实现

### `/kanban init`

1. 执行 `kanban_init`
2. **安装框架依赖文件 (agents/rules 使用符号链接, dashboard 使用复制):**
   ```bash
   SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
   # macOS/Linux: 创建符号链接; Windows (MINGW/MSYS): 回退到复制
   # agents: .claude/agents/planner.md -> ../skills/kanban/agents/planner.md
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
   # dashboard: 使用复制 (不适合 symlink)
   if [ ! -d ".kanban/dashboard/server.js" ]; then
     mkdir -p .kanban/dashboard
     cp -r "$SKILL_DIR"/dashboard/* .kanban/dashboard/ 2>/dev/null || true
   fi
   ```
3. 确认输出: "Initialized kanban at .kanban/" + "Linked N framework files (agents, rules via symlink)"

### `/kanban create "<title>" [--desc "<desc>"]`

1. 解析 title 和可选 description
2. 执行 `kanban_create_task "$title" "$description"`
3. 展示创建结果

### `/kanban status`

1. 执行 `kanban_status`

### `/kanban show <task_id>`

1. 执行 `kanban_show_task "$task_id"`

### `/kanban run <task_id> [--phase <phase>]`

这是核心编排命令。按 FSM 流程执行:

#### Phase 1: Plan

**触发条件:** `--phase plan` 或任务处于 pending/planning 状态

1. `workflow_transition "$task_id" "plan"`
2. 读取任务 title + description
3. 准备 dispatch 上下文:
   ```bash
   iter=$(jq -r '.iteration // 1' $(task_file "$task_id"))
   mkdir -p $(report_dir "$task_id" "$iter")
   ```
4. 使用 **planner Agent** (原生 `.claude/agents/planner.md`) 执行规划:
   - 传入任务上下文: task_id, title, description, worktree_path, report_dir, iteration
   - Agent 读取项目结构，分析需求
   - 产出 `requirements.md` + `task_breakdown.json` 到**任务根目录** (`.kanban/tasks/TASK-NNN/`)
5. 检查产物:
   ```bash
   missing=$(guard_check_artifacts "$task_id" "plan")
   ```
   如果产物不完整，提示 Agent 补全
6. **Plan 质量门禁 (如果 enabled):**
   ```bash
   quality_result=$(guard_check_plan_quality "$task_id" "$report_dir")
   ```
   - Plan 质量门禁通过 `workflow.json` 中 plan 阶段的 `quality_gate` 配置启用:
     ```json
     {
       "id": "plan",
       "quality_gate": {
         "enabled": true,
         "pass_threshold": 7.0,
         "max_rounds": 3,
         "dimensions": [
           {"id": "requirement_clarity", "name": "需求清晰度", "weight": 0.25},
           {"id": "technical_feasibility", "name": "技术可行性", "weight": 0.25},
           {"id": "task_decomposition", "name": "任务拆解合理性", "weight": 0.25},
           {"id": "acceptance_criteria", "name": "验收标准完整性", "weight": 0.25}
         ]
       }
     }
     ```
   - 评分维度:
     1. **需求清晰度** (requirement_clarity): requirements.md 是否包含功能需求、非功能需求、验收标准
     2. **技术可行性** (technical_feasibility): 技术约束和 estimated_files 是否具体
     3. **任务拆解合理性** (task_decomposition): subtask 数量、字段完整性、依赖关系
     4. **验收标准完整性** (acceptance_criteria): 验收标准是否可验证
     5. **需求前置调研完整性** (research_completeness, 可选加分项): 有调研需求时是否包含调研结论
   - 总分 >= `pass_threshold` (配置默认 7.0) 通过
   - `pass_threshold` 不达标时自动重试 Plan (最多 `max_rounds` 轮，默认 3)
   - 每次评分和 issues 追加到 task JSON 的 `history` 数组中 (plan_quality_check 事件)
   - 超过 `max_rounds` 仍不达标 -> 进入 user_decision，提示用户选择
   - `quality_gate` 配置缺失时回退到默认值 (enabled=false, threshold=9.0, max_rounds=3)
7. **需求前置调研 (如果触发条件匹配):**
   - 当 `workflow.json` plan 阶段配置了 researcher agent 且 `trigger_condition` 匹配时，自动调度 researcher
   - `trigger_condition` 配置示例:
     ```json
     {"role": "researcher", "required": false, "trigger_condition": {"keywords": ["调研", "选型", "对比", "analysis", "research", "技术选型", "竞品"], "match_field": "description"}}
     ```
   - 当任务 description 包含任一关键词时，自动生成 researcher dispatch JSON 并调度
   - Planner 应在 requirements.md 中包含"调研需求"小节，明确调研目标和约束
   - researcher 的调研结论应被 Plan 质量门禁的维度5 (research_completeness) 识别
8. `workflow_complete_phase "$task_id"`

#### Phase 2: Execute

**触发条件:** Plan 完成后自动进入，或 `--phase execute`

**Agent 配置:** Executor 角色从 `workflow.json` 的 `execute` 阶段 `agents` 数组中读取。默认配置为 `{"role": "executor", "required": true}`。可通过在该数组中添加条目来引入额外的 execute 阶段 agent（如专用的测试 agent 或文档生成 agent）。

**强制 worktree 约束:** 所有任务（包括框架增强任务）进入 Execute 阶段时必须创建 worktree。guard.sh 第5层自动创建: 如果 worktree 不存在，自动尝试 `worktree_create`。创建失败时阻止进入 Execute 阶段，返回 `FAIL:worktree_not_found`。这确保每个任务都有独立的工作目录，避免代码变更互相污染。

1. 创建 worktree (幂等):
   ```bash
   worktree_create "$task_id" "$(jq -r '.worktree.branch' $(task_file "$task_id"))"
   ```
2. `workflow_transition "$task_id" "execute"`
3. 准备调度上下文:
   ```bash
   dispatch_file=$(kanban_prepare_dispatch "$task_id")
   ```
4. 读取 Plan 产物 (requirements.md, task_breakdown.json) 中的 subtasks
5. **按 subtask 逐步调度 executor Agent:**
   - 无依赖的 subtask 可并行执行 (不超过 config.scheduler.max_parallel)
   - 有依赖的 subtask 等待前序完成后串行执行
   - 每个 subtask 的执行流程:
     a. `kanban_update_subtask "$task_id" "$subtask_id" "in_progress"`
     b. 调度 **executor Agent**:
        ```
        Agent(subagent_type="executor", mode="bypassPermissions")
        prompt: 你是 Executor Agent。任务信息:
        - task_id: {task_id}
        - subtask: {subtask_id} -- {subtask_title}
        - description: {subtask_description}
        - worktree_path: {wt_path}
        - report_dir: {report_dir}

        请执行此子任务:
        1. 读取 {task_dir}/requirements.md 了解整体需求（任务根目录）
        2. 在 {wt_path} 中完成此子任务的编码
        3. 确认文件已写入: {subtask.estimated_files}

        必须产出的文件清单:
        {subtask.estimated_files 列表}
        ```
     c. 检查 estimated_files 是否已生成
     d. 成功 -> `kanban_update_subtask "$task_id" "$subtask_id" "completed"`
     e. 失败 -> `kanban_update_subtask "$task_id" "$subtask_id" "failed"`
   - 缺失文件则重试该 subtask (最多 2 次，每次提供更详细提示)
6. 所有 subtask 完成后，单独调度一个 **报告 Agent**:
   ```
   Agent(subagent_type="executor", mode="bypassPermissions")
   prompt: 为任务 {task_id} 编写执行报告:
   - 读取 worktree 中的所有代码变更
   - 编写 {report_dir}/execution_summary.md (实现了什么、文件清单)
   - 编写 {report_dir}/execution_pitfalls.md (遇到的问题和解决方法)
   - 编写 {report_dir}/execution_decisions.md (技术决策和原因)
   ```
7. 检查产物:
   ```bash
   missing=$(guard_check_artifacts "$task_id" "execute")
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
9. `workflow_complete_phase "$task_id"`

#### Phase 3: Evaluate

**触发条件:** Execute 完成后自动进入，或 `--phase evaluate`

1. `workflow_transition "$task_id" "evaluate"`
2. **动态读取评估角色列表:**
   ```bash
   roles=$(get_all_roles "evaluate")
   required_roles=$(get_required_roles "evaluate")
   ```
   角色列表从 `workflow.json` 的 `evaluate` 阶段 `agents` 数组中动态读取。默认配置包含 4 个内置角色 (code_reviewer, qa, pm, designer)，但可通过 `agents` 数组添加自定义评估 agent 或移除内置 agent。`get_phase_agents` 提供完整的 agent 配置（含 parallel/required/file 等字段），`get_all_roles` 仅返回 role 列表，`get_required_roles` 仅返回 required=true 的角色。未定义 `agents` 时回退到内置默认 4 角色。
3. `evaluator_prepare_all "$task_id"` -- 基于动态角色列表准备调度上下文，为每个角色生成 dispatch JSON
4. **并行启动评估 Agent:**

   对每个角色（从 `get_all_roles "evaluate"` 获取）启动独立 Agent:

   ```
   Agent(subagent_type="general-purpose", run_in_background=true)
   prompt: 扮演 {role} 角色，评估任务 {task_id} 的实现。
           读取 dispatch 文件: {dispatch_dir}/{task_id}-{role}.json
           按照角色定义的评分标准评估代码。
           将报告写入: {report_dir}/{role}_report.json
   ```

   **默认内置角色职责** (可通过 `workflow.json` 的 `evaluate.agents` 数组自定义，由 `lib/agent_registry.sh` 动态解析):
   - code_reviewer: 审核 architecture, code_quality, security, test_coverage
   - qa: 验证 test_completeness, boundary_coverage, error_handling, acceptance_criteria
   - pm: 验证 requirement_coverage, user_experience, completeness, acceptance_criteria
   - designer: 评审 api_design, module_structure, extensibility, consistency

   以上 4 个角色是 `workflow.json` 中 `evaluate` 阶段的默认配置。用户可通过修改 `evaluate.agents` 数组添加自定义评估角色（如安全审计、性能分析）、移除或替换内置角色。`get_all_roles("evaluate")` 在运行时返回实际配置的角色列表，而非硬编码值。

5. 等待所有 Agent 完成
6. 收集评分（基于动态角色列表）:
   ```bash
   for role in $(get_all_roles "evaluate"); do
     evaluator_record_score "$task_id" "$role" "$report_dir/${role}_report.json"
   done
   ```
7. `evaluator_collect_scores "$task_id"` -- 展示评分
8. `workflow_complete_phase "$task_id"`
9. 进入自迭代判断

#### 自迭代判断

1. `workflow_self_improve_check "$task_id"` -- 返回 all_pass / max_reached / hot / full
2. 根据结果:
   - **all_pass** -> 进入 user_decision 阶段
   - **max_reached** -> 进入 user_decision 阶段，标记达到最大轮次
   - **hot** -> `workflow_start_iteration "$task_id" "hot"` -> 跳回 Execute 阶段
   - **full** -> `workflow_start_iteration "$task_id" "full"` -> 跳回 Plan 阶段

#### Phase 4: User Decision

**触发条件:** Retrospective 完成后自动进入

**前置条件:** retrospective.md 必须已生成（Guard 在 archive 时强制检查）

1. `workflow_transition "$task_id" "user_decision"`
2. **展示复盘总结文档** — 读取 `{task_dir}/retrospective.md` 内容展示给用户
3. `kanban_iteration_summary "$task_id"` -- 展示迭代摘要（评分趋势、扣分项）
4. `kanban_changes_summary "$task_id"` -- 展示变更摘要（提交记录、文件变更、关键改动、产物文件、评估报告链接）
5. 等待用户执行 `/kanban decide`:
   - `approve_and_archive` -> 合并 worktree + 归档（Guard 会验证 retrospective.md 存在）
   - `restart_from_plan` -> 重置到 Plan 阶段
   - `restart_from_execute` -> 重置到 Execute 阶段
   - `abort` -> 归档任务（跳过 retrospective 检查）

#### Phase 4.5: Retrospective（必经阶段）

**触发条件:** Evaluate 通过后自动进入（retrospective 是归档前的必经阶段，Guard 在 archive 时强制检查 retrospective.md 存在性）

1. `workflow_transition "$task_id" "retrospective"`
2. **读取迭代产物:**
   - 读取 `execution_pitfalls.md` -- 遇到的问题和解决方法
   - 读取 `execution_decisions.md` -- 技术决策和原因
3. **生成复盘文档:**
   ```bash
   # 基于模板生成 retrospective.md
   cp "$SKILL_DIR/templates/retrospective.md" "$(task_dir $task_id)/retrospective.md"
   # 填充内容 (由 Agent 完成)
   ```
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
   - 调用 `kanban_knowledge_add` 写入 `knowledge-log.md`
   - 必须产出至少1条新知识条目
5. 检查产物:
   ```bash
   missing=$(guard_check_artifacts "$task_id" "retrospective")
   ```
6. `workflow_complete_phase "$task_id"`
7. 进入 user_decision 阶段

#### Phase 5: Archive

1. `workflow_transition "$task_id" "archive"`
2. **动态调度 archive 阶段 Agent:**
   Archive 阶段的 agent 列表从 `workflow.json` 的 `archive` 阶段 `agents` 数组中读取。默认配置包含 `{"role": "knowledge-manager", "required": false}`。Knowledge-manager 负责从本次任务的执行产物中提取经验教训，沉淀到 `knowledge-log.md`。未定义 `agents` 时跳过 archive 阶段的 agent 调度。
3. **Retrospective 存在性检查 (Guard 第6层):**
   ```bash
   # 归档前强制验证 retrospective.md 存在
   # 双路径检查: 任务根目录优先，iteration 子目录回退
   ```
4. **Inbox 待处理检查 (Guard 第7层):**
   ```bash
   guard_check_inbox "$task_id"
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
   framework_self_assess "$task_id"
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
   worktree_merge "$task_id"
   worktree_cleanup "$task_id"
   ```
8. **如果 worktree 不存在 (兜底逻辑):**
   - 检查主目录是否有未提交变更
   - 如果有，创建 fixup commit: `git commit -m "fixup: {task_id} changes (worktree unavailable)"`
   - 记录到 task history
9. `kanban_archive_task "$task_id"`
   - 将整个 `tasks/{task_id}/` 目录移动到 `archive/{task_id}/`
   - 包含 Inbox 待处理检查的二次防线 (非 abort 操作时)

### `/kanban decide <task_id> --action <action> [--feedback "..."]`

1. 执行 `kanban_decide "$task_id" --action "$action" --feedback "$feedback"`
2. 根据 action 执行后续:
   - approve_and_archive -> 合并 + 归档
   - restart_from_plan -> 重新运行从 plan 开始
   - restart_from_execute -> 重新运行从 execute 开始
   - abort -> 直接归档

### `/kanban recover [<task_id>]`

1. 如果指定 task_id: `recover_task "$task_id"`
2. 如果不指定: `recover_list_interrupted` -> 列出所有中断任务
3. 超时检测: `recover_check_timeout "$task_id"`

### `/kanban score <task_id>`

1. `evaluator_collect_scores "$task_id"`

### `/kanban summary <task_id>`

1. `kanban_iteration_summary "$task_id"`

### `/kanban evolve-skills`

显示 Skills 演化历史记录 (扫描 `.kanban/skills/evolved/` 中的已应用 candidates)。

1. `skills_evolve_show_history` -- 列出所有候选改进及其状态 (applied/pending)

**自动触发**: 任务归档时自动执行 `skills_evolve_auto`:
1. `skills_evolve_extract` -- 从 execution_pitfalls.md 和 execution_decisions.md 提取框架改进点
2. `skills_evolve_apply` -- agent/rule 类改进直接应用; lib 类改进创建 kanban 任务 (IR-12)
3. `skills_evolve_report` -- 生成 `skills_evolution_report.json` 存入 iteration 目录

### `/kanban feedback <task_id>`

分析归档 inbox 中的用户反馈。

1. `kanban_read_pending_feedback "$task_id"` -- 读取待处理反馈
2. 如果无待处理项，提示 "无待处理反馈" 并退出
3. 启动 **planner Agent** 分析每条反馈:
   ```
   Agent(subagent_type="planner", mode="bypassPermissions")
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
5. 确认后对每条反馈调用 `kanban_write_archived_feedback` 归档
6. 根据分类执行后续操作:
   - 需求类 -> 追加到任务根目录的 `requirements.md` 末尾
   - 问题类 -> 提示用户可运行 `/kanban run {task_id} --phase execute` 处理

### `/kanban dashboard [start|stop|status|restart]`

1. 解析子命令（默认 start）
2. 执行 `kanban_dashboard "$action"`
3. start: 启动 Dashboard 服务器并打开浏览器
4. stop: 停止 Dashboard 服务器
5. status: 显示 Dashboard 运行状态

默认端口: 3000 (可在 config.json dashboard.port 中配置)
Dashboard 路径: .kanban/dashboard/

### `/kanban version list`

1. 执行 `kanban_version_list`

### `/kanban version record <version> [--title "..."] [--task TASK-NNN]`

1. 执行 `kanban_version_record "$version" --title "$title" --task "$task_id"`
2. 自动生成版本记录文件 `.kanban/versions/v{version}.md`
3. 更新 `.kanban/versions/CHANGELOG.md` 索引
4. 更新 `.kanban/config.json` 中的 `version` 字段
5. 同步更新 `.claude-plugin/plugin.json` 中的 `version` 字段
6. 创建 git tag `v{version}`

**版本记录触发条件:**
- 每次任务归档后（task merge 到 main），如果涉及框架文件变更（.claude/skills/、.claude/agents/、.claude/rules/），应执行 `/kanban version record`
- 版本号遵循语义化版本: PATCH 用于 bug 修复，MINOR 用于功能增强，MAJOR 用于破坏性变更

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

---

## Agent 调度规范

Agent 调度基于 `workflow.json` 的 `agents` 数组动态进行，而非硬编码。每个阶段的 `agents` 数组定义了该阶段需要调度的 agent 列表，包含 `role`、`required`、`parallel`、`file`、`output` 等配置字段。通过 `get_phase_agents`、`get_required_roles`、`get_all_roles` 等 `lib/agent_registry.sh` 提供的函数在运行时动态解析。

Agent 定义在 `.claude/agents/` 目录，使用 Claude Code 原生 Agent 机制。
每个 agent 的 YAML frontmatter 定义了 model、tools、disallowedTools。

**动态调度机制:**
- `get_phase_agents "<phase>"` -- 返回指定阶段的完整 agent 配置列表（含 role, required, parallel 等）
- `get_all_roles "<phase>"` -- 返回指定阶段所有 agent 的 role 名称
- `get_required_roles "<phase>"` -- 仅返回 required=true 的 agent role 名称
- `resolve_agent_file "<role>"` -- 将 role 解析为 agent 文件路径（内置 agent 从 `agents/` 目录加载，自定义 agent 支持相对路径）
- `has_agents_config "<phase>"` -- 检查该阶段是否定义了 `agents` 数组，未定义时回退到内置默认行为

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
  subagent_type="planner",
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
  subagent_type="executor",
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

评估 Agent 列表从 `workflow.json` 的 `evaluate` 阶段 `agents` 数组动态读取。**默认配置**包含 4 个内置角色 (code_reviewer, qa, pm, designer)，均以 `run_in_background=true` 并行启动。这 4 个角色不是硬编码的固定列表，而是 `workflow.json` 中的默认值。用户可通过修改 `agents` 数组添加自定义评估角色、调整 `required` 标志、或移除/替换内置角色。`lib/agent_registry.sh` 提供的 `get_phase_agents`、`get_all_roles`、`get_required_roles` 等函数在运行时动态解析实际配置，框架不假设任何特定角色一定存在。

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

## 路径 Helper 函数

框架提供统一的路径 helper 函数，所有路径引用应通过这些函数获取:

```bash
task_dir(task_id)          # 任务目录: .kanban/tasks/TASK-NNN/
task_file(task_id)         # 任务 JSON: .kanban/tasks/TASK-NNN/task.json
report_dir(task_id, iter)  # 迭代产物目录: .kanban/tasks/TASK-NNN/iteration-N/
dispatch_dir(task_id)      # Dispatch 目录: .kanban/tasks/TASK-NNN/dispatch/
inbox_file(task_id)        # Inbox 文件: .kanban/tasks/TASK-NNN/inbox.md
archive_dir(task_id)       # 归档目录: .kanban/archive/TASK-NNN/
archive_task_file(task_id) # 归档 JSON: .kanban/archive/TASK-NNN/task.json
is_new_layout(task_id)     # 检查是否使用新目录结构 (0=新, 1=旧)
```

所有 helper 函数自动兼容新旧两种目录格式，优先检测新格式。

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
- 框架自动检测并兼容旧格式，`kanban_init_env` 自动执行迁移
