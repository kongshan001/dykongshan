#!/usr/bin/env bash
# test_token_tracking.sh -- Tests for ST-005: Token 消耗追踪 (GitHub Issue #34)
# Tests: kanban_track_token, kanban_check_token_budget, kanban_token_report
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIB_DIR="$SKILL_DIR/lib"

# Track test results
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Per-test temp directory
_TEST_TMPDIR=""
_TEST_KANBAN_DIR=""

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected: $expected"
    echo "    actual:   $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -qF "$needle"; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    string: $haystack"
    echo "    not found: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_json_eq() {
  local label="$1" filepath="$2" jq_expr="$3" expected="$4"
  local actual
  actual=$(jq -r "$jq_expr" "$filepath" 2>/dev/null || echo "JSON_ERROR")
  if [ "$actual" = "$expected" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected: $expected"
    echo "    actual:   $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_gt() {
  local label="$1" actual="$2" threshold="$3"
  if [ "$actual" -gt "$threshold" ] 2>/dev/null; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected > $threshold, got: $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Create a fresh, isolated temp KANBAN_DIR for each test
setup() {
  _TEST_TMPDIR=$(mktemp -d)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch}
  jq -n '{
    project:"test",
    trunk:"main",
    output_dir:"src",
    budget: { per_task: 500000, warning_threshold: 0.8, hard_limit: true }
  }' > "$_TEST_KANBAN_DIR/config.json"
  jq -n '{project:"test",trunk:"main",tasks:[]}' > "$_TEST_KANBAN_DIR/index.json"
  jq -n '{
    phases: [
      {name:"plan",max_retries:2},
      {name:"execute",max_retries:2},
      {name:"evaluate",pass_threshold:9.0},
      {name:"user_decision"},
      {name:"archive"}
    ]
  }' > "$_TEST_KANBAN_DIR/workflow.json"
  # Ensure .claude/agents dir exists (kanban_create_task may reference it)
  mkdir -p "$_TEST_TMPDIR/.claude/agents"
}

teardown() {
  if [ -n "$_TEST_TMPDIR" ] && [ -d "$_TEST_TMPDIR" ]; then
    rm -rf "$_TEST_TMPDIR"
  fi
}

# Source the library with KANBAN_DIR overridden
source_lib() {
  _KANBAN_CORE_LOADED=""
  source "$LIB_DIR/kanban.sh"
  KANBAN_DIR="$_TEST_KANBAN_DIR"
}

# Helper: create a task and return its ID
create_test_task() {
  local title="${1:-Test task}"
  local token_budget="${2:-500000}"
  local tid
  # Create task in new layout format directly
  tid=$(_next_task_id)
  local task_dir_path="$KANBAN_DIR/tasks/${tid}"
  mkdir -p "$task_dir_path"

  local now=$(date -u +%FT%TZ)
  jq -n \
    --arg id "$tid" \
    --arg title "$title" \
    --arg desc "Test description" \
    --arg branch "feature/${tid}" \
    --arg now "$now" \
    --argjson token_budget "$token_budget" \
    '{
      id: $id,
      title: $title,
      description: $desc,
      engine: "claude-code",
      status: "pending",
      phase: null,
      phase_lock: null,
      assignee: null,
      worktree: { branch: $branch, path: "", base: "main" },
      iteration: 1,
      max_iterations: 6,
      token_budget: $token_budget,
      token_used: 0,
      token_stats: {
        per_phase: { plan: 0, execute: 0, evaluate: 0, retrospective: 0, user_decision: 0, archive: 0 },
        per_subtask: {},
        per_agent: { planner: 0, executor: 0, code_reviewer: 0, qa: 0, pm: 0, designer: 0 },
        total_estimated: 0
      },
      scores: {},
      depends_on: [],
      modified_files: [],
      task_breakdown: { file: "", subtasks: [] },
      history: [],
      user_decision: null,
      requires_archive_confirmation: true,
      created_at: $now,
      updated_at: $now,
      entered_at: null
    }' > "$task_dir_path/task.json"

  echo "$tid"
}

# Helper: create a task WITHOUT token_stats (backward compat test)
create_old_format_task() {
  local title="${1:-Old task}"
  local tid
  tid=$(_next_task_id)
  local task_dir_path="$KANBAN_DIR/tasks/${tid}"
  mkdir -p "$task_dir_path"

  local now=$(date -u +%FT%TZ)
  jq -n \
    --arg id "$tid" \
    --arg title "$title" \
    --arg desc "Test description" \
    --arg branch "feature/${tid}" \
    --arg now "$now" \
    '{
      id: $id,
      title: $title,
      description: $desc,
      engine: "claude-code",
      status: "pending",
      phase: null,
      phase_lock: null,
      assignee: null,
      worktree: { branch: $branch, path: "", base: "main" },
      iteration: 1,
      max_iterations: 6,
      token_budget: 500000,
      token_used: 0,
      scores: {},
      depends_on: [],
      modified_files: [],
      task_breakdown: { file: "", subtasks: [] },
      history: [],
      user_decision: null,
      requires_archive_confirmation: true,
      created_at: $now,
      updated_at: $now,
      entered_at: null
    }' > "$task_dir_path/task.json"

  echo "$tid"
}

# ============================================================
# Test Group 1: kanban_track_token basic accumulation
# ============================================================

test_track_token_per_phase() {
  echo "--- test_track_token_per_phase ---"
  setup
  source_lib

  local tid=$(create_test_task "Track per phase" 500000)
  local tf=$(task_file "$tid")

  # Track plan phase tokens
  kanban_track_token "$tid" "plan" "5000" 2>/dev/null
  kanban_track_token "$tid" "plan" "15000" 2>/dev/null
  # Track execute phase tokens
  kanban_track_token "$tid" "execute" "80000" 2>/dev/null

  # Verify per_phase accumulation
  assert_json_eq "plan tokens sum to 20000" "$tf" ".token_stats.per_phase.plan" "20000"
  assert_json_eq "execute tokens sum to 80000" "$tf" ".token_stats.per_phase.execute" "80000"
  assert_json_eq "evaluate tokens still 0" "$tf" ".token_stats.per_phase.evaluate" "0"
  assert_json_eq "token_used totals 100000" "$tf" ".token_used" "100000"
  assert_json_eq "total_estimated tracks" "$tf" ".token_stats.total_estimated" "100000"

  teardown
}

test_track_token_per_subtask() {
  echo "--- test_track_token_per_subtask ---"
  setup
  source_lib

  local tid=$(create_test_task "Track per subtask" 500000)
  local tf=$(task_file "$tid")

  kanban_track_token "$tid" "execute" "30000" "ST-001" 2>/dev/null
  kanban_track_token "$tid" "execute" "20000" "ST-001" 2>/dev/null
  kanban_track_token "$tid" "execute" "25000" "ST-002" 2>/dev/null

  assert_json_eq "ST-001 tokens 50000" "$tf" ".token_stats.per_subtask[\"ST-001\"]" "50000"
  assert_json_eq "ST-002 tokens 25000" "$tf" ".token_stats.per_subtask[\"ST-002\"]" "25000"
  assert_json_eq "token_used totals 75000" "$tf" ".token_used" "75000"

  teardown
}

test_track_token_per_agent() {
  echo "--- test_track_token_per_agent ---"
  setup
  source_lib

  local tid=$(create_test_task "Track per agent" 500000)
  local tf=$(task_file "$tid")

  # Explicit agent params
  kanban_track_token "$tid" "plan" "10000" "" "planner" 2>/dev/null
  kanban_track_token "$tid" "execute" "50000" "" "executor" 2>/dev/null
  kanban_track_token "$tid" "evaluate" "5000" "" "code_reviewer" 2>/dev/null

  assert_json_eq "planner tokens" "$tf" ".token_stats.per_agent.planner" "10000"
  assert_json_eq "executor tokens" "$tf" ".token_stats.per_agent.executor" "50000"
  assert_json_eq "code_reviewer tokens" "$tf" ".token_stats.per_agent.code_reviewer" "5000"

  teardown
}

test_track_token_auto_agent_mapping() {
  echo "--- test_track_token_auto_agent_mapping ---"
  setup
  source_lib

  local tid=$(create_test_task "Auto agent mapping" 500000)
  local tf=$(task_file "$tid")

  # No agent specified - should auto-map from phase
  kanban_track_token "$tid" "plan" "10000" 2>/dev/null
  kanban_track_token "$tid" "execute" "50000" 2>/dev/null
  kanban_track_token "$tid" "evaluate" "5000" 2>/dev/null
  kanban_track_token "$tid" "retrospective" "2000" 2>/dev/null

  assert_json_eq "auto plan -> planner" "$tf" ".token_stats.per_agent.planner" "10000"
  assert_json_eq "auto execute -> executor" "$tf" ".token_stats.per_agent.executor" "50000"
  assert_json_eq "auto evaluate -> code_reviewer" "$tf" ".token_stats.per_agent.code_reviewer" "5000"
  assert_json_eq "auto retrospective -> pm" "$tf" ".token_stats.per_agent.pm" "2000"

  teardown
}

test_track_token_history_recorded() {
  echo "--- test_track_token_history_recorded ---"
  setup
  source_lib

  local tid=$(create_test_task "History record" 500000)
  local tf=$(task_file "$tid")

  kanban_track_token "$tid" "plan" "5000" "ST-001" "planner" 2>/dev/null

  # Verify history entry
  assert_json_eq "history has token_tracked event" "$tf" ".history[-1].event" "token_tracked"
  assert_json_eq "history phase" "$tf" ".history[-1].phase" "plan"
  assert_json_eq "history subtask_id" "$tf" ".history[-1].subtask_id" "ST-001"
  assert_json_eq "history tokens_used" "$tf" ".history[-1].tokens_used" "5000"
  assert_json_eq "history agent" "$tf" ".history[-1].agent" "planner"

  teardown
}

test_track_token_invalid_number() {
  echo "--- test_track_token_invalid_number ---"
  setup
  source_lib

  local tid=$(create_test_task "Invalid number" 500000)

  local output
  output=$(kanban_track_token "$tid" "plan" "abc" 2>&1) || true
  assert_contains "rejects non-numeric tokens" "$output" "ERROR"

  teardown
}

test_track_token_task_not_found() {
  echo "--- test_track_token_task_not_found ---"
  setup
  source_lib

  local output
  output=$(kanban_track_token "TASK-999" "plan" "5000" 2>&1) || true
  assert_contains "task not found error" "$output" "not found"

  teardown
}

# ============================================================
# Test Group 2: kanban_track_token backward compatibility
# ============================================================

test_track_token_initializes_stats_when_missing() {
  echo "--- test_track_token_initializes_stats_when_missing ---"
  setup
  source_lib

  local tid=$(create_old_format_task "Old task")
  local tf=$(task_file "$tid")

  # Verify token_stats does not exist initially
  local has_stats
  has_stats=$(jq -r '.token_stats // "MISSING"' "$tf")
  assert_eq "no token_stats initially" "MISSING" "$has_stats"

  # Track tokens - should auto-initialize
  kanban_track_token "$tid" "plan" "5000" 2>/dev/null

  # Verify token_stats was created
  local plan_after
  plan_after=$(jq -r '.token_stats.per_phase.plan // "STILL_MISSING"' "$tf")
  assert_eq "token_stats created and used" "5000" "$plan_after"

  teardown
}

# ============================================================
# Test Group 3: kanban_check_token_budget
# ============================================================

test_check_token_budget_normal() {
  echo "--- test_check_token_budget_normal ---"
  setup
  source_lib

  local tid=$(create_test_task "Normal budget" 500000)
  local tf=$(task_file "$tid")

  # Set token_used to 100000 (20% of budget)
  local tmp=$(mktemp)
  jq '.token_used = 100000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "budget normal at 20%" "normal" "$result"

  teardown
}

test_check_token_budget_warning() {
  echo "--- test_check_token_budget_warning ---"
  setup
  source_lib

  local tid=$(create_test_task "Warning budget" 500000)
  local tf=$(task_file "$tid")

  # Set token_used to 400000 (80% of budget) - at threshold
  local tmp=$(mktemp)
  jq '.token_used = 400000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "budget warning at 80%" "warning" "$result"

  teardown
}

test_check_token_budget_critical() {
  echo "--- test_check_token_budget_critical ---"
  setup
  source_lib

  local tid=$(create_test_task "Critical budget" 500000)
  local tf=$(task_file "$tid")

  # Set token_used to 500000 (100% of budget) - exactly at limit
  local tmp=$(mktemp)
  jq '.token_used = 500000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "budget critical at exactly 100%" "critical" "$result"

  teardown
}

test_check_token_budget_over_critical() {
  echo "--- test_check_token_budget_over_critical ---"
  setup
  source_lib

  local tid=$(create_test_task "Over critical" 500000)
  local tf=$(task_file "$tid")

  # Set token_used to 600000 (120% of budget)
  local tmp=$(mktemp)
  jq '.token_used = 600000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "budget critical at 120%" "critical" "$result"

  teardown
}

test_check_token_budget_zero_budget() {
  echo "--- test_check_token_budget_zero_budget ---"
  setup
  source_lib

  local tid=$(create_test_task "Zero budget" 0)

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "zero budget always normal" "normal" "$result"

  teardown
}

test_check_token_budget_custom_threshold() {
  echo "--- test_check_token_budget_custom_threshold ---"
  setup
  source_lib

  # Set a custom warning threshold of 0.5
  local cfg_tmp=$(mktemp)
  jq '.budget.warning_threshold = 0.5' "$KANBAN_DIR/config.json" > "$cfg_tmp" && mv "$cfg_tmp" "$KANBAN_DIR/config.json"

  local tid=$(create_test_task "Custom threshold" 500000)
  local tf=$(task_file "$tid")

  # Set token_used to 250000 (50% of budget) - at custom threshold
  local tmp=$(mktemp)
  jq '.token_used = 250000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "budget warning at 50% custom threshold" "warning" "$result"

  teardown
}

test_check_token_budget_hard_limit_false() {
  echo "--- test_check_token_budget_hard_limit_false ---"
  setup
  source_lib

  # Set hard_limit to false
  local cfg_tmp=$(mktemp)
  jq '.budget.hard_limit = false' "$KANBAN_DIR/config.json" > "$cfg_tmp" && mv "$cfg_tmp" "$KANBAN_DIR/config.json"

  local tid=$(create_test_task "No hard limit" 500000)
  local tf=$(task_file "$tid")

  # Set token_used to 600000 (120% of budget) - should NOT be critical
  local tmp=$(mktemp)
  jq '.token_used = 600000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local result
  result=$(kanban_check_token_budget "$tid") || true
  assert_eq "no hard limit, over budget is warning not critical" "warning" "$result"

  teardown
}

# ============================================================
# Test Group 4: kanban_token_report output
# ============================================================

test_token_report_contains_header() {
  echo "--- test_token_report_contains_header ---"
  setup
  source_lib

  local tid=$(create_test_task "Report header" 500000)
  kanban_track_token "$tid" "plan" "20000" "" "planner" 2>/dev/null
  kanban_track_token "$tid" "execute" "80000" "" "executor" 2>/dev/null
  kanban_track_token "$tid" "evaluate" "20000" "" "code_reviewer" 2>/dev/null

  local output
  output=$(kanban_token_report "$tid" 2>&1) || true

  assert_contains "contains header" "$output" "=== ${tid} Token 消耗 ==="
  assert_contains "contains Phase column" "$output" "Phase"
  assert_contains "contains plan row" "$output" "plan"
  assert_contains "contains execute row" "$output" "execute"
  assert_contains "contains evaluate row" "$output" "evaluate"
  assert_contains "contains Agent header" "$output" "Agent 分布"
  assert_contains "contains budget status" "$output" "预算状态"

  teardown
}

test_token_report_shows_correct_totals() {
  echo "--- test_token_report_shows_correct_totals ---"
  setup
  source_lib

  local tid=$(create_test_task "Report totals" 500000)
  kanban_track_token "$tid" "plan" "10000" "" "planner" 2>/dev/null
  kanban_track_token "$tid" "execute" "40000" "" "executor" 2>/dev/null

  local output
  output=$(kanban_token_report "$tid" 2>&1) || true

  # Total should show 50000
  assert_contains "shows total 50000" "$output" "50000"
  # Percentage = 50000 * 100 / 500000 = 10%
  assert_contains "shows 10%" "$output" "10%"

  teardown
}

test_token_report_normal_status() {
  echo "--- test_token_report_normal_status ---"
  setup
  source_lib

  local tid=$(create_test_task "Normal status" 500000)

  local output
  output=$(kanban_token_report "$tid" 2>&1) || true

  assert_contains "normal status shows [OK]" "$output" "[OK]"
  assert_contains "normal status text" "$output" "normal"

  teardown
}

test_token_report_warning_status() {
  echo "--- test_token_report_warning_status ---"
  setup
  source_lib

  local tid=$(create_test_task "Warning status" 500000)
  local tf=$(task_file "$tid")

  # Set to 450000 (90%)
  local tmp=$(mktemp)
  jq '.token_used = 450000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local output
  output=$(kanban_token_report "$tid" 2>&1) || true

  assert_contains "warning status shows [WARNING]" "$output" "[WARNING]"

  teardown
}

test_token_report_critical_status() {
  echo "--- test_token_report_critical_status ---"
  setup
  source_lib

  local tid=$(create_test_task "Critical status" 500000)
  local tf=$(task_file "$tid")

  # Set to 550000 (110%)
  local tmp=$(mktemp)
  jq '.token_used = 550000' "$tf" > "$tmp" && mv "$tmp" "$tf"

  local output
  output=$(kanban_token_report "$tid" 2>&1) || true

  assert_contains "critical status shows [ERROR]" "$output" "[ERROR]"
  assert_contains "critical status text" "$output" "CRITICAL"

  teardown
}

test_token_report_task_not_found() {
  echo "--- test_token_report_task_not_found ---"
  setup
  source_lib

  local output
  output=$(kanban_token_report "TASK-999" 2>&1) || true
  assert_contains "shows not found" "$output" "not found"

  teardown
}

test_token_report_no_args() {
  echo "--- test_token_report_no_args ---"
  setup
  source_lib

  local output
  output=$(kanban_token_report "" 2>&1) || true
  assert_contains "shows usage" "$output" "Usage"

  teardown
}

# ============================================================
# Test Group 5: Integration - track then check then report
# ============================================================

test_full_flow_track_check_report() {
  echo "--- test_full_flow_track_check_report ---"
  setup
  source_lib

  local tid=$(create_test_task "Full flow" 500000)
  local tf=$(task_file "$tid")

  # Step 1: Track plan phase tokens
  kanban_track_token "$tid" "plan" "20000" "" "planner" 2>/dev/null
  local r1
  r1=$(kanban_check_token_budget "$tid") || true
  assert_eq "after 20000: normal" "normal" "$r1"

  # Step 2: Track execute phase tokens (brings to 420000, 84% -> warning)
  kanban_track_token "$tid" "execute" "400000" "" "executor" 2>/dev/null
  local r2
  r2=$(kanban_check_token_budget "$tid") || true
  assert_eq "after 420000: warning" "warning" "$r2"

  # Step 3: Track more to reach critical
  kanban_track_token "$tid" "execute" "100000" "" "executor" 2>/dev/null
  local r3
  r3=$(kanban_check_token_budget "$tid") || true
  assert_eq "after 520000: critical" "critical" "$r3"

  # Step 4: Report should show correct stats
  local output
  output=$(kanban_token_report "$tid" 2>&1) || true
  assert_contains "report shows [ERROR]" "$output" "[ERROR]"
  assert_contains "report mentions percentage" "$output" "%"

  teardown
}

# ============================================================
# Run all tests
# ============================================================
echo "========================================="
echo "Running ST-005 Token Tracking tests"
echo "========================================="
echo ""

test_track_token_per_phase
teardown
test_track_token_per_subtask
teardown
test_track_token_per_agent
teardown
test_track_token_auto_agent_mapping
teardown
test_track_token_history_recorded
teardown
test_track_token_invalid_number
teardown
test_track_token_task_not_found
teardown
test_track_token_initializes_stats_when_missing
teardown
test_check_token_budget_normal
teardown
test_check_token_budget_warning
teardown
test_check_token_budget_critical
teardown
test_check_token_budget_over_critical
teardown
test_check_token_budget_zero_budget
teardown
test_check_token_budget_custom_threshold
teardown
test_check_token_budget_hard_limit_false
teardown
test_token_report_contains_header
teardown
test_token_report_shows_correct_totals
teardown
test_token_report_normal_status
teardown
test_token_report_warning_status
teardown
test_token_report_critical_status
teardown
test_token_report_task_not_found
teardown
test_token_report_no_args
teardown
test_full_flow_track_check_report
teardown

echo ""
echo "========================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_RUN total"
echo "========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
  exit 1
fi
