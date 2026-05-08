# Iron Rules -- 详细定义

本文件包含 kanban 多 Agent 编排系统的 15 条 Iron Rules (铁律) 的详细定义。
CLAUDE.md 中仅保留编号和一句话摘要，完整定义以此文件为准。

---

## IR-01: Guard 不可绕过

Guard 三层保护（阶段转换、产物完整性、评分标准）是框架的基石。任何 Agent 不允许跳过或绕过 Guard 检查。

- **违反后果**: 阶段转换被阻止，Agent 必须修正问题后重试。

## IR-02: 产物完整性不可跳过

每个阶段必须产出规定的文档产物。Plan 需要 requirements.md + task_breakdown.json；Execute 需要 execution_summary.md + execution_pitfalls.md + execution_decisions.md；Evaluate 需要4个角色报告。

- **违反后果**: Guard 阻止进入下一阶段，提示 Agent 补全缺失产物。

## IR-03: 评估必须4角色全覆盖

Evaluate 阶段必须调度 code_reviewer、qa、pm、designer 四个评估角色，缺一不可。

- **违反后果**: Guard 检测到缺失报告时阻止进入 retrospective/user_decision。

## IR-04: 热迭代仅限无架构问题

Hot iteration（快速迭代）仅当评分 >= 7.0 且无架构问题时允许，从 Execute 阶段重新开始。存在架构问题时必须使用 Full iteration 从 Plan 阶段重新开始。

- **违反后果**: 自迭代判断逻辑强制使用 Full iteration。

## IR-05: 每阶段必须产出文档

任何阶段完成后都必须有对应的文档记录。文档是第一类产出物，不是附属品。

- **违反后果**: Guard 检查产物缺失，阻止阶段转换。

## IR-06: 知识必须沉淀

每次迭代结束时必须从 execution_pitfalls 和 execution_decisions 中提取经验教训，记录到 knowledge-log.md。知识是项目最宝贵的资产。

- **违反后果**: retrospective 阶段 Knowledge Manager 必须产出至少1条新知识条目。

## IR-07: Worktree 必须清理

任务归档后必须清理对应的 worktree 和分支。不遗留未清理的 worktree。

- **违反后果**: archive 阶段的 worktree_cleanup 是必须步骤。

## IR-08: 自迭代不超过上限

自迭代最多不超过 workflow.json 中 max_iterations 设定的次数（默认6次）。达到上限后强制进入 user_decision 阶段。

- **违反后果**: workflow_self_improve_check 检测到超限时强制进入 user_decision。

## IR-09: 评分标准严格统一

所有评估角色使用统一的10分制评分，pass_threshold 由 workflow.json 定义（默认9.0）。评分必须客观、有据可依。

- **违反后果**: 评分不达标触发自迭代循环。

## IR-10: 变更必须伴随测试

任何代码变更（新功能、Bug修复、重构）必须伴随相应的测试。新功能需要新的测试用例，Bug 修复需要回归测试。

- **违反后果**: QA 评分降低，可能触发 hot iteration。

## IR-11: 归档需用户确认

任务归档操作不允许自动执行。创建任务时默认标记 requires_archive_confirmation: true。必须通过用户显式执行 /kanban decide --action approve_and_archive 才能触发归档和合并到主干的操作。禁止任何自动归档或自动合并的行为。

- **违反后果**: Guard 检测到未确认的归档请求时阻止操作，提示用户确认。

## IR-12: 所有变更必须走看板流程

任何代码修改（新功能、Bug修复、重构、框架自身增强）都必须通过 kanban 任务看板系统的标准 FSM 流程。禁止绕过看板直接在 main 分支上做未经 Plan/Execute/Evaluate 流程的变更。框架自身的改造也不例外。不允许任何形式的 fast-track 或简化流程，无论变更多小都必须走完整的 Plan -> Execute -> Evaluate 流程。

- **违反后果**: 评估阶段发现无对应 TASK 记录时扣分，变更缺少质量保障。

## IR-13: 同类修改整合为单一任务

当同时存在多个相关或同类型的修改需求时（如多个 GitHub Issue 的 bug 修复、同一模块的多项改进），必须整合为一个 kanban 任务统一处理，而非拆分为多个独立任务。在 Plan 阶段的 task_breakdown.json 中以 subtask 形式组织每个具体修改点。单一任务的粒度应该是「一个完整交付单元」，而非「一个修改点」。

- **违反后果**: Planner 在 Plan 阶段发现同类修改被拆分为多个任务时，应合并为一个任务后重新规划。

## IR-14: 提交后必须 Push

每次 git commit 完成后，必须执行 `git push` 将变更同步到远程仓库。禁止仅停留在本地提交而不推送的行为，确保远程仓库始终反映最新状态。

- **违反后果**: 发现未推送的本地提交时，Agent 必须立即执行 push 补推。

## IR-15: 归档前必须有复盘总结

任务归档前必须产出 retrospective.md 复盘总结文档，并在 user_decision 阶段展示给用户审阅。复盘总结包含：任务目标回顾、需求分析摘要、技术方案摘要、评分趋势、经验教训、技术决策总结、知识沉淀。Guard 在 archive 阶段强制检查 retrospective.md 存在性，缺失时阻止归档。abort 操作跳过此检查。

- **违反后果**: Guard 检测到 retrospective.md 缺失时阻止归档，提示先完成复盘总结。

## IR-16: Plan 阶段必须先完成需求澄清

Plan 阶段必须先在用户协同下完成需求澄清（通过 `superpowers:brainstorming` 技能），设计方案获得用户确认后，方可派发 planner agent 产出正式规划文档。禁止在未经用户确认需求的情况下直接进入正式规划。

需求澄清的 Pass-through Gate: 仅当任务 description 已包含全部 4 项要素（技术栈选型、核心功能清单、验收标准、约束条件）时，可跳过 brainstorming 直接进入正式规划。跳过原因必须写入 task history。

- **违反后果**: 直接派发 planner 的行为被阻止，必须先与用户完成 brainstorming 澄清需求。

## IR-17: 自迭代必须自动执行不可询问用户

Evaluate 阶段完成后，编排器必须自动执行自迭代判断（self-improve-check）。当评分未达到 pass_threshold（默认 9.0）且迭代次数未达到 max_iterations（默认 6）时，系统必须自动跳回 Execute（hot）或 Plan（full），禁止在此阶段询问用户"是否继续迭代"或进入 User Decision。

User Decision 仅在两种情况下可达：
- **all_pass**: 所有 required 评估角色评分均 >= pass_threshold
- **max_reached**: 迭代次数 >= max_iterations

hot/full 跳转决策依据：
- **hot**: 平均分 >= 7.0 且无架构问题 → 自动跳回 Execute
- **full**: 平均分 < 7.0 或存在架构问题 → 自动跳回 Plan

- **违反后果**: 编排器在 hot/full 时展示 User Decision 选项（如"继续迭代还是归档？"），则违反了自迭代自动执行原则。应立即停止询问，执行自动跳转。
