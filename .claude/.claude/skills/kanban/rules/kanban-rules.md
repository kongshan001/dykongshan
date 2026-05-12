# Kanban 框架规则

## 铁律 (IR-01 ~ IR-17)

- **IR-01**: Guard 三层保护（阶段转换、产物完整性、评分标准）不可绕过。
- **IR-02**: 每阶段必须产出规定文档产物，缺失时阻止进入下一阶段。
- **IR-03**: Evaluate 必须调度 code_reviewer、qa、pm、designer 四角色，缺一不可。
- **IR-04**: Hot iteration 仅限评分 >= 7.0 且无架构问题；否则 Full iteration 回 Plan。
- **IR-05**: 文档是第一类产出物，任何阶段完成后必须有对应文档记录。
- **IR-06**: 每次迭代从 pitfalls/decisions 提取经验至 knowledge-log.md，至少 1 条。经验须标注分类标签：tdd（TDD 实践相关）、bdd（BDD 场景设计相关）、architecture（架构）、process（流程）、testing（测试通用）。无标签条目不计入最低条数要求。
- **IR-07**: 任务归档后必须清理 worktree 和分支。
- **IR-08**: 自迭代不超过 max_iterations（默认 6 次），达上限强制 user_decision。
- **IR-09**: 所有评估使用统一 10 分制，pass_threshold 由 workflow.json 定义。
- **IR-10**: 任何代码变更必须伴随测试。新功能需新测试，Bug 修复需回归测试。
- **IR-11**: 归档须用户显式执行 approve_and_archive，禁止自动归档。
- **IR-12**: 所有代码修改必须走 Plan → Execute → Evaluate 标准流程，禁止绕过。
- **IR-13**: 多个同类修改须整合为一个任务，以 subtask 组织。
- **IR-14**: git commit 后必须 git push 同步到远程。
- **IR-15**: 归档前必须产出 retrospective.md，缺失时阻止归档。
- **IR-16**: Plan 阶段须先完成 brainstorming 需求澄清并获确认，方可进入正式规划。
- **IR-17**: Evaluate 后评分未达标且未达上限时，自动跳回 Execute/Plan，禁止询问用户。

## 实施规则 (R-001 ~ R-006)

**R-001 产出目录**: 代码放 `{output_dir}/{task-name}/`。task-name 用下划线（Python 导入兼容）。output_dir 从 config.json 读取。

**R-002 Agent 调度**: Evaluate 阶段 4 角色并行启动（run_in_background=true）。缺失任一报告阻止进入 user_decision。

**R-003 文档先行**: Plan → design.md/requirements.md/task_breakdown.json；Execute → execution_summary/pitfalls/decisions；Evaluate → 4 份角色报告 JSON；Retrospective → retrospective.md/acceptance.md。

**R-004 测试随代码**: 测试文件放 `test/` 或 `__tests__/`。新增代码覆盖率 >= 80%。QA 在 test_completeness 维度评分。

**R-005 归档确认**: 仅 `/kanban decide --action approve_and_archive` 可触发归档合并。abort 跳过合并直接归档。automatic archive 禁止。

**R-006 看板强制**: 所有变更走 `/kanban create` → `/kanban run` → `/kanban decide`。轻量模式需用户同意，仍走完整 FSM。
