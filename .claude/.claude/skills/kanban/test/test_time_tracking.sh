#!/usr/bin/env bash
# test_time_tracking.sh — 回归测试耗时追踪与可视化 (ST-004)
# 验证:
#   1. workflow_transition 写入 started_at 到 history
#   2. workflow_complete_phase 写入 completed_at 和 duration_seconds
#   3. _calc_duration_seconds 计算正确
#   4. kanban_time_report 输出格式正确
#   5. workflow_start_iteration 写入 started_at
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TESTS_RUN=0 TESTS_PASSED=0 TESTS_FAILED=0

assert_eq() {
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ "$2" = "$3" ]; then
    echo "  PASS: $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $1 (expected='$2', actual='$3')"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

assert_contains() {
  TESTS_RUN=$((TESTS_RUN + 1))
  if echo "$2" | grep -qF -- "$3"; then
    echo "  PASS: $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $1 (output does not contain '$3')"
    echo "    Output: $2"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

assert_not_contains() {
  TESTS_RUN=$((TESTS_RUN + 1))
  if ! echo "$2" | grep -qF -- "$3"; then
    echo "  PASS: $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $1 (output should NOT contain '$3')"
    echo "    Output: $2"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Create a fresh test environment in a temp directory.
# All functions are sourced exactly once within each test subshell.
make_env() {
  local tmpdir="$1"
  export KANBAN_DIR="$tmpdir/.kanban"
  mkdir -p "$KANBAN_DIR/tasks"

  echo '{"project":"test","trunk":"main","output_dir":"src"}' > "$KANBAN_DIR/config.json"
  echo '{"phases":[{"id":"plan"},{"id":"execute"},{"id":"evaluate"},{"id":"retrospective"},{"id":"user_decision"},{"id":"archive"}],"self_improve":{"max_iterations":6}}' > "$KANBAN_DIR/workflow.json"

  # Source kanban.sh (defines KANBAN_DIR=".kanban" at top, overrides ours)
  source "$SKILL_DIR/lib/kanban.sh" 2>/dev/null
  # Restore KANBAN_DIR
  KANBAN_DIR="$tmpdir/.kanban"
  export KANBAN_DIR

  # Source guard.sh and workflow.sh (each also sets KANBAN_DIR=".kanban")
  source "$SKILL_DIR/lib/guard.sh" 2>/dev/null
  KANBAN_DIR="$tmpdir/.kanban"
  export KANBAN_DIR
  source "$SKILL_DIR/lib/workflow.sh" 2>/dev/null
  KANBAN_DIR="$tmpdir/.kanban"
  export KANBAN_DIR
}

# Create a task JSON with minimal valid structure and the given fields
create_task() {
  local task_id="$1"
  local title="$2"
  local task_dir="$KANBAN_DIR/tasks/$task_id"
  mkdir -p "$task_dir"
  local now
  now=$(date -u +%FT%TZ)
  jq -n \
    --arg id "$task_id" \
    --arg title "$title" \
    --arg now "$now" \
    '{
      id: $id, title: $title, description: "", engine: "claude-code",
      status: "pending", phase: null, phase_lock: null,
      worktree: {branch: ("feature/"+$id), path: "", base: "main"},
      iteration: 0, max_iterations: 6, token_budget: 500000, token_used: 0,
      scores: {}, depends_on: [], modified_files: [],
      task_breakdown: {file: "", subtasks: []}, history: [],
      user_decision: null, requires_archive_confirmation: true,
      created_at: $now, updated_at: $now, entered_at: null
    }' > "$task_dir/task.json"
  echo "$task_dir/task.json"
}

# Update index.json
update_index() {
  local tasks_json="["
  local first=true
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    local tf="$d/task.json"
    [ -f "$tf" ] || continue
    local summary
    summary=$(jq '{id, status, phase, iteration}' "$tf")
    if [ "$first" = "true" ]; then first=false; else tasks_json="${tasks_json},"; fi
    tasks_json="${tasks_json}${summary}"
  done
  tasks_json="${tasks_json}]"
  jq -n --arg p "test" --arg t "main" --argjson tasks "$tasks_json" \
    '{project:$p, trunk:$t, tasks:$tasks}' > "$KANBAN_DIR/index.json"
}

echo "=== Time Tracking Tests (ST-004) ==="
echo ""

# ── Test 1: workflow_transition 写入 started_at ──
echo "--- Test 1: workflow_transition adds started_at to history ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Test Time Tracking"
  update_index

  workflow_transition "TASK-001" "plan" 2>/dev/null
  tf=$(task_file "TASK-001")
  hist_entry=$(jq -c '.history[0]' "$tf")
  started_at=$(jq -r '.history[0].started_at' "$tf")

  assert_contains "history entry has started_at field" "$hist_entry" "started_at"
  assert_contains "started_at is ISO 8601 (has T)" "$started_at" "T"
  assert_contains "started_at ends with Z" "$started_at" "Z"

  rm -rf "$TMPDIR"
)

# ── Test 2: workflow_complete_phase 写入 completed_at 和 duration_seconds ──
echo "--- Test 2: workflow_complete_phase adds completed_at and duration_seconds ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Test Time Tracking"
  update_index

  workflow_transition "TASK-001" "plan" 2>/dev/null
  tf=$(task_file "TASK-001")
  # Set started_at to a known past time for predictable duration
  jq '.history[0].started_at="2026-05-05T10:00:00Z" | .history[0].entered_at="2026-05-05T10:00:00Z"' "$tf" > "$tf.tmp" && mv "$tf.tmp" "$tf"

  workflow_complete_phase "TASK-001" 2>/dev/null

  completed_at=$(jq -r '.history[0].completed_at' "$tf")
  duration=$(jq -r '.history[0].duration_seconds' "$tf")

  assert_contains "history entry has completed_at" "$completed_at" "T"
  assert_not_contains "duration_seconds is not null" "$duration" "null"
  echo "  INFO: duration_seconds = $duration"

  rm -rf "$TMPDIR"
)

# ── Test 3: _calc_duration_seconds 计算正确 ──
echo "--- Test 3: _calc_duration_seconds computes correctly ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"

  r=$(_calc_duration_seconds "2026-05-05T10:00:00Z" "2026-05-05T10:01:00Z")
  assert_eq "60 seconds" "60" "$r"

  r=$(_calc_duration_seconds "2026-05-05T10:00:00Z" "2026-05-05T10:05:00Z")
  assert_eq "300 seconds (5 min)" "300" "$r"

  r=$(_calc_duration_seconds "2026-05-05T10:00:00Z" "2026-05-05T10:00:00Z")
  assert_eq "0 seconds (same time)" "0" "$r"

  rm -rf "$TMPDIR"
)

# ── Test 4: _format_duration 格式化正确 ──
echo "--- Test 4: _format_duration formats seconds correctly ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"

  r=$(_format_duration "60");   assert_eq "60s -> 1m 0s" "1m 0s" "$r"
  r=$(_format_duration "90");   assert_eq "90s -> 1m 30s" "1m 30s" "$r"
  r=$(_format_duration "900");  assert_eq "900s -> 15m 0s" "15m 0s" "$r"
  r=$(_format_duration "3600"); assert_eq "3600s -> 60m 0s" "60m 0s" "$r"
  r=$(_format_duration "0");    assert_eq "0s -> 0m 0s" "0m 0s" "$r"
  r=$(_format_duration "");     assert_eq "empty -> -" "-" "$r"
  r=$(_format_duration "null"); assert_eq "null -> -" "-" "$r"

  rm -rf "$TMPDIR"
)

# ── Test 5: kanban_time_report 用 task_id 显示任务耗时 ──
echo "--- Test 5: kanban_time_report with task_id shows phase timing ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Test Time Tracking"
  update_index

  # Directly write history entries to avoid guard issues
  tf=$(task_file "TASK-001")
  jq '.history = [
    {"phase":"plan","status":"completed","entered_at":"2026-05-05T10:00:00Z","started_at":"2026-05-05T10:00:00Z","completed_at":"2026-05-05T10:15:00Z","duration_seconds":900},
    {"phase":"execute","status":"entered","entered_at":"2026-05-05T10:15:00Z","started_at":"2026-05-05T10:15:00Z"}
  ]' "$tf" > "$tf.tmp" && mv "$tf.tmp" "$tf"

  output=$(kanban_time_report "TASK-001" 2>/dev/null)

  assert_contains "output contains TASK-001" "$output" "TASK-001"
  assert_contains "output contains title" "$output" "Test Time Tracking"
  assert_contains "output contains Phase column" "$output" "Phase"
  assert_contains "output contains Started column" "$output" "Started"
  assert_contains "output contains Completed column" "$output" "Completed"
  assert_contains "output contains Duration column" "$output" "Duration"
  assert_contains "output contains plan" "$output" "plan"
  assert_contains "output contains execute" "$output" "execute"
  assert_contains "plan shows 15m 0s" "$output" "15m 0s"
  assert_contains "execute shows running" "$output" "(running)"

  rm -rf "$TMPDIR"
)

# ── Test 6: kanban_time_report 无参数显示活跃任务概览 ──
echo "--- Test 6: kanban_time_report without args shows overview ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Test Time Tracking"
  update_index

  # Write history with a running plan phase
  tf=$(task_file "TASK-001")
  jq '.history = [
    {"phase":"plan","status":"entered","entered_at":"2026-05-05T10:00:00Z","started_at":"2026-05-05T10:00:00Z"}
  ] | .phase="plan" | .status="planning"' "$tf" > "$tf.tmp" && mv "$tf.tmp" "$tf"

  # Use temp file for output to avoid subshell command substitution issues
  output_file="$TMPDIR/time_report_output.txt"
  kanban_time_report > "$output_file" 2>/dev/null
  output=$(cat "$output_file")

  assert_contains "output contains overview header" "$output" "活跃任务耗时概览"
  assert_contains "output contains TASK-001" "$output" "TASK-001"
  assert_contains "output contains Task column" "$output" "Task"
  assert_contains "output contains Status column" "$output" "Status"
  assert_contains "output shows (running)" "$output" "(running)"

  rm -rf "$TMPDIR"
)

# ── Test 7: workflow_start_iteration 写入 started_at ──
echo "--- Test 7: workflow_start_iteration adds started_at ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Test Time Tracking"
  update_index

  # Set up task so it can proceed through start_iteration
  tf=$(task_file "TASK-001")
  jq '.iteration=1 | .phase="evaluate" | .phase_lock="evaluate" |
    .scores.code_reviewer={score:9.5,passed:true} |
    .scores.qa={score:9.5,passed:true} |
    .scores.pm={score:9.5,passed:true} |
    .scores.designer={score:9.5,passed:true} |
    .worktree.path="/tmp"' "$tf" > "$tf.tmp" && mv "$tf.tmp" "$tf"

  workflow_start_iteration "TASK-001" "full" 2>/dev/null

  tf=$(task_file "TASK-001")
  hist_len=$(jq '.history | length' "$tf")
  last_idx=$((hist_len - 1))
  last_phase=$(jq -r ".history[$last_idx].phase" "$tf")
  last_started=$(jq -r ".history[$last_idx].started_at" "$tf")

  assert_eq "self_improve phase" "self_improve" "$last_phase"
  assert_contains "has started_at" "$last_started" "T"

  rm -rf "$TMPDIR"
)

# ── Test 8: 多阶段耗时均被记录和展示 ──
echo "--- Test 8: multi-phase timing recorded and displayed ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Multi Phase"
  update_index

  tf=$(task_file "TASK-001")
  jq '.history = [
    {"phase":"plan","status":"completed","entered_at":"2026-05-05T10:00:00Z","started_at":"2026-05-05T10:00:00Z","completed_at":"2026-05-05T10:15:00Z","duration_seconds":900},
    {"phase":"execute","status":"completed","entered_at":"2026-05-05T10:15:00Z","started_at":"2026-05-05T10:15:00Z","completed_at":"2026-05-05T10:30:00Z","duration_seconds":900},
    {"phase":"evaluate","status":"entered","entered_at":"2026-05-05T10:30:00Z","started_at":"2026-05-05T10:30:00Z"}
  ]' "$tf" > "$tf.tmp" && mv "$tf.tmp" "$tf"

  output=$(kanban_time_report "TASK-001" 2>/dev/null)

  assert_contains "has plan" "$output" "plan"
  assert_contains "has execute" "$output" "execute"
  assert_contains "has evaluate" "$output" "evaluate"
  assert_contains "plan 15m 0s" "$output" "15m 0s"
  assert_contains "evaluate running" "$output" "(running)"

  rm -rf "$TMPDIR"
)

# ── Test 9: 无 history 的任务 ──
echo "--- Test 9: task with no history entries ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  create_task "TASK-001" "Empty History"
  update_index

  output=$(kanban_time_report "TASK-001" 2>/dev/null)

  assert_contains "shows no history message" "$output" "no history entries"

  rm -rf "$TMPDIR"
)

# ── Test 10: 无活跃任务时 ──
echo "--- Test 10: no active tasks ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  # Don't create any tasks
  jq -n '{project:"test", trunk:"main", tasks:[]}' > "$KANBAN_DIR/index.json"

  # Use temp file for output to avoid subshell command substitution issues
  output_file="$TMPDIR/time_report_output.txt"
  kanban_time_report > "$output_file" 2>/dev/null
  output=$(cat "$output_file")

  assert_contains "shows no tasks" "$output" "no active tasks"

  rm -rf "$TMPDIR"
)

# ── Test 11: kanban_time_report 对不存在的 task_id 报错 ──
echo "--- Test 11: kanban_time_report with non-existent task_id ---"
(
  TMPDIR=$(mktemp -d)
  make_env "$TMPDIR"
  jq -n '{project:"test", trunk:"main", tasks:[]}' > "$KANBAN_DIR/index.json"

  output=$(kanban_time_report "TASK-999" 2>&1)

  assert_contains "shows error for missing task" "$output" "not found"

  rm -rf "$TMPDIR"
)

# ── Results ──
echo ""
echo "=== Results ==="
echo "Total:  $TESTS_RUN"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"
echo ""

if [ "$TESTS_FAILED" -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "Some tests FAILED."
  exit 1
fi
