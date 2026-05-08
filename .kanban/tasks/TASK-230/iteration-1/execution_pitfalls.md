# 执行陷阱记录
1. guard.sh 需要前置加载 worktree.sh，否则 worktree 校验失败
2. plan->execute 需要创建 requirements.md 和 task_breakdown.json 产物
3. execute->evaluate 需要创建 execution_summary.md、execution_pitfalls.md、execution_decisions.md
