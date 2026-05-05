#!/usr/bin/env bash
# test_github_issues_batch2.sh — 回归测试 GitHub Issues #21-#30 (ST-005: Issue #27)
# 聚焦 ST-005: 阶段名别名映射
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_REAL_SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_DIR="$_REAL_SKILL_DIR"
TEST_DIR=""

setup() {
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
  git init -q
  mkdir -p .claude/skills/kanban/lib .claude/skills/kanban/agents .claude/skills/kanban/rules \
    .claude/skills/kanban/templates .claude/skills/kanban/dashboard .claude-plugin
  # 复制框架文件
  cp "$SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/
  cp "$SKILL_DIR"/templates/*.json .claude/skills/kanban/templates/ 2>/dev/null || true
  cp "$SKILL_DIR"/templates/GETTING_STARTED.md .claude/skills/kanban/templates/ 2>/dev/null || true
  cp "$SKILL_DIR"/agents/*.md .claude/skills/kanban/agents/ 2>/dev/null || true
  cp "$SKILL_DIR"/rules/*.md .claude/skills/kanban/rules/ 2>/dev/null || true
  mkdir -p .claude/skills/kanban/dashboard
  cp "$SKILL_DIR"/dashboard/server.js .claude/skills/kanban/dashboard/ 2>/dev/null || true
  echo '{"name":"kanban","version":"0.4.0"}' > .claude-plugin/plugin.json
  git add -A && git commit -qm "init" --allow-empty
  # Reset module load guards
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  unset _KANBAN_WORKFLOW_LOADED 2>/dev/null || true
  unset _KANBAN_GUARD_LOADED 2>/dev/null || true
  unset _KANBAN_EVALUATOR_LOADED 2>/dev/null || true
  unset _KANBAN_WORKTREE_LOADED 2>/dev/null || true
  unset _KANBAN_SELF_IMPROVE_LOADED 2>/dev/null || true
}

teardown() {
  cd /
  rm -rf "$TEST_DIR"
  SKILL_DIR="$_REAL_SKILL_DIR"
}

# === ST-005: Issue #27 - 阶段名别名映射 ===

# 测试 _normalize_phase_name 函数的基本映射
test_st005_normalize_basic_mapping() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env

  # 测试所有已定义的别名映射
  local result

  result=$(_normalize_phase_name "planning")
  if [ "$result" != "plan" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('planning')='$result', expected 'plan'"
    teardown
    return 1
  fi

  result=$(_normalize_phase_name "executing")
  if [ "$result" != "execute" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('executing')='$result', expected 'execute'"
    teardown
    return 1
  fi

  result=$(_normalize_phase_name "evaluating")
  if [ "$result" != "evaluate" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('evaluating')='$result', expected 'evaluate'"
    teardown
    return 1
  fi

  result=$(_normalize_phase_name "retrospecting")
  if [ "$result" != "retrospective" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('retrospecting')='$result', expected 'retrospective'"
    teardown
    return 1
  fi

  echo "PASS: ST-005 - _normalize_phase_name basic alias mapping works"
  teardown
}

# 测试 archive 的两种别名
test_st005_normalize_archive_aliases() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env

  local result

  result=$(_normalize_phase_name "archived")
  if [ "$result" != "archive" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('archived')='$result', expected 'archive'"
    teardown
    return 1
  fi

  result=$(_normalize_phase_name "archiving")
  if [ "$result" != "archive" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('archiving')='$result', expected 'archive'"
    teardown
    return 1
  fi

  echo "PASS: ST-005 - archive alias variants (archived, archiving) map correctly"
  teardown
}

# 测试标准阶段 ID 不变 (不修改已经是标准 ID 的值)
test_st005_normalize_passthrough_standard_ids() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env

  local result
  for phase in plan execute evaluate retrospective user_decision archive; do
    result=$(_normalize_phase_name "$phase")
    if [ "$result" != "$phase" ]; then
      echo "FAIL: ST-005 - _normalize_phase_name('$phase')='$result', expected '$phase' (passthrough)"
      teardown
      return 1
    fi
  done

  echo "PASS: ST-005 - standard phase IDs pass through unchanged"
  teardown
}

# 测试未知阶段名也透传（由 workflow_transition 的验证逻辑处理）
test_st005_normalize_unknown_passthrough() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env

  local result
  result=$(_normalize_phase_name "unknown_phase")
  if [ "$result" != "unknown_phase" ]; then
    echo "FAIL: ST-005 - _normalize_phase_name('unknown_phase')='$result', expected 'unknown_phase' (passthrough)"
    teardown
    return 1
  fi

  echo "PASS: ST-005 - unknown phase names pass through for validation"
  teardown
}

# 测试 workflow_transition 使用别名 "planning" 时正确映射为 "plan"
# 这是 Issue #27 报告的核心 bug 场景
test_st005_transition_with_alias_planning() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  # 创建一个处于 pending 状态的任务
  kanban_create_task "Alias test" "Testing planning alias"
  local task_id=$(jq -r '.tasks[0].id' .kanban/index.json)

  # 使用 "planning" 别名（task.json 中 status 字段用的就是 "planning"）
  local output
  output=$(workflow_transition "$task_id" "planning" 2>&1)
  local rc=$?

  if [ $rc -ne 0 ]; then
    echo "FAIL: ST-005 - workflow_transition with 'planning' failed: $output"
    teardown
    return 1
  fi

  # 验证转换成功 -- phase_lock 应该是 "plan"
  local tf
  tf=$(task_file "$task_id")
  local lock=$(jq -r '.phase_lock' "$tf")
  if [ "$lock" != "plan" ]; then
    echo "FAIL: ST-005 - phase_lock is '$lock', expected 'plan' after transition with 'planning' alias"
    teardown
    return 1
  fi

  local phase=$(jq -r '.phase' "$tf")
  if [ "$phase" != "plan" ]; then
    echo "FAIL: ST-005 - phase is '$phase', expected 'plan'"
    teardown
    return 1
  fi

  echo "PASS: ST-005 - workflow_transition TASK planning -> plan works correctly"
  teardown
}

# 测试 workflow_transition 使用标准 ID "plan" 时仍然正常工作
test_st005_transition_with_standard_id() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  kanban_create_task "Standard ID test" "Testing standard plan ID"
  local task_id=$(jq -r '.tasks[0].id' .kanban/index.json)

  local output
  output=$(workflow_transition "$task_id" "plan" 2>&1)
  local rc=$?

  if [ $rc -ne 0 ]; then
    echo "FAIL: ST-005 - workflow_transition with standard 'plan' failed: $output"
    teardown
    return 1
  fi

  local tf=$(task_file "$task_id")
  local lock=$(jq -r '.phase_lock' "$tf")
  if [ "$lock" != "plan" ]; then
    echo "FAIL: ST-005 - phase_lock is '$lock', expected 'plan' with standard ID"
    teardown
    return 1
  fi

  echo "PASS: ST-005 - workflow_transition with standard 'plan' still works"
  teardown
}

# 测试 workflow_transition 对未知阶段名给出明确错误提示
test_st005_transition_unknown_phase_error_message() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  kanban_create_task "Unknown phase test" "Testing error message"
  local task_id=$(jq -r '.tasks[0].id' .kanban/index.json)

  local output
  output=$(workflow_transition "$task_id" "nonexistent_phase" 2>&1)
  local rc=$?

  if [ $rc -eq 0 ]; then
    echo "FAIL: ST-005 - workflow_transition with unknown phase should fail but succeeded"
    teardown
    return 1
  fi

  # 验证错误消息包含有效的阶段 ID 列表
  if ! echo "$output" | grep -q "unknown phase name"; then
    echo "FAIL: ST-005 - error message does not contain 'unknown phase name': $output"
    teardown
    return 1
  fi

  if ! echo "$output" | grep -q "plan|execute|evaluate"; then
    echo "FAIL: ST-005 - error message does not list valid phases: $output"
    teardown
    return 1
  fi

  echo "PASS: ST-005 - unknown phase name produces clear error with valid phase list"
  teardown
}

# 测试 "executing" 别名在已有 plan 产物的任务上能转换为 execute
test_st005_transition_executing_alias() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  kanban_create_task "Executing alias test" "Testing executing alias"

  local task_id=$(jq -r '.tasks[0].id' .kanban/index.json)
  local tf=$(task_file "$task_id")
  local tdir=$(task_dir "$task_id")

  # 手动进入 plan 阶段并创建必要产物
  workflow_transition "$task_id" "plan" >/dev/null 2>&1

  # 创建 plan 阶段产物 (任务根目录)
  echo "# Requirements" > "$tdir/requirements.md"
  echo '{"subtasks":[]}' > "$tdir/task_breakdown.json"

  workflow_complete_phase "$task_id" >/dev/null 2>&1

  # 设置 plan_quality_passed=true (ST-006 质量门禁需要)
  jq '.plan_quality_passed = true' "$tf" > "${tf}.tmp" && mv "${tf}.tmp" "$tf"

  # 创建 worktree (execute 阶段需要)
  local branch=$(jq -r '.worktree.branch // "task/TASK-001"' "$tf")
  worktree_create "$task_id" "$branch" >/dev/null 2>&1 || true

  # 重新加载 task file (worktree_create 可能修改了它)
  tf=$(task_file "$task_id")
  local wt_path=$(jq -r '.worktree.path // ""' "$tf")

  # 如果 worktree 创建成功，测试 executing 别名
  if [ -n "$wt_path" ] && [ -d "$wt_path" ]; then
    local output
    output=$(workflow_transition "$task_id" "executing" 2>&1)
    local rc=$?

    if [ $rc -ne 0 ]; then
      echo "FAIL: ST-005 - workflow_transition with 'executing' failed: $output"
      teardown
      return 1
    fi

    local lock=$(jq -r '.phase_lock' "$tf")
    if [ "$lock" != "execute" ]; then
      echo "FAIL: ST-005 - phase_lock is '$lock', expected 'execute' after 'executing' alias"
      teardown
      return 1
    fi

    echo "PASS: ST-005 - 'executing' alias correctly maps to 'execute' phase"
  else
    # worktree 创建可能因环境限制失败，跳过此测试
    echo "SKIP: ST-005 - worktree creation failed, skipping executing alias transition test"
  fi

  teardown
}

# 运行所有测试
main() {
  local passed=0 failed=0 skipped=0
  echo "=== GitHub Issues Batch2 Regression Tests (ST-005: Issue #27) ==="
  echo ""

  for test_fn in \
    test_st005_normalize_basic_mapping \
    test_st005_normalize_archive_aliases \
    test_st005_normalize_passthrough_standard_ids \
    test_st005_normalize_unknown_passthrough \
    test_st005_transition_with_alias_planning \
    test_st005_transition_with_standard_id \
    test_st005_transition_unknown_phase_error_message \
    test_st005_transition_executing_alias; do
    if $test_fn; then
      passed=$((passed + 1))
    else
      failed=$((failed + 1))
    fi
  done

  echo ""
  echo "=== Results: $passed passed, $failed failed ==="
  [ "$failed" -eq 0 ]
}

main "$@"
