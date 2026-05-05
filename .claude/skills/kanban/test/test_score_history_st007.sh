#!/usr/bin/env bash
# test_score_history_st007.sh -- Tests for ST-007: score tracking enhancements
# Tests: evaluator_record_score history append, evaluator_collect_scores average, kanban_score_history
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
  if echo "$haystack" | grep -q "$needle"; then
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

# Create a fresh, isolated temp KANBAN_DIR for each test
setup() {
  _TEST_TMPDIR=$(mktemp -d)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch}
  jq -n '{project:"test",trunk:"main",output_dir:"src"}' > "$_TEST_KANBAN_DIR/config.json"
  jq -n '{project:"test",trunk:"main",tasks:[]}' > "$_TEST_KANBAN_DIR/index.json"
  # Create a minimal workflow.json with pass_threshold
  jq -n '{
    phases: [
      {name:"plan",max_retries:2},
      {name:"execute",max_retries:2},
      {name:"evaluate",pass_threshold:9.0},
      {name:"user_decision"},
      {name:"archive"}
    ]
  }' > "$_TEST_KANBAN_DIR/workflow.json"
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
  # Source evaluator.sh functions (kanban_init_env would do this but we want explicit control)
  source "$LIB_DIR/evaluator.sh"
  # evaluator.sh resets KANBAN_DIR to ".kanban" at the top, so restore it
  KANBAN_DIR="$_TEST_KANBAN_DIR"
}

# Helper: get the task ID from the most recently created task file
# Supports both new format (tasks/TASK-NNN/task.json) and old format (tasks/TASK-NNN.json)
get_latest_task_id() {
  local latest=""
  # New format: tasks/TASK-NNN/task.json
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    [ -f "$d/task.json" ] || continue
    latest=$(basename "$d")
  done
  # Old format fallback: tasks/TASK-NNN.json
  if [ -z "$latest" ]; then
    for f in "$KANBAN_DIR"/tasks/TASK-*.json; do
      [ -f "$f" ] || continue
      latest=$(basename "$f" .json)
    done
  fi
  echo "$latest"
}

# Helper: create a fake task with iteration set
create_test_task() {
  local title="${1:-Test task}"
  local iter="${2:-1}"
  kanban_create_task "$title" "Test description" > /dev/null 2>&1
  local tid=$(get_latest_task_id)
  local task_file=$(task_file "$tid")
  local tmp=$(mktemp)
  jq --argjson iter "$iter" '.iteration = $iter' "$task_file" > "$tmp" && mv "$tmp" "$task_file"
  echo "$tid"
}

# Helper: create a fake report file
create_report() {
  local dir="$1"
  local role="$2"
  local score="$3"
  mkdir -p "$dir"
  jq -n --arg role "$role" --argjson score "$score" \
    '{role: $role, score: $score, summary: "test report"}' > "${dir}/${role}_report.json"
}

# ============================================================
# Test Group 1: evaluator_record_score appends to history
# ============================================================
test_record_score_appends_history() {
  echo "--- test_record_score_appends_history ---"
  setup
  source_lib

  local tid=$(create_test_task "History test" 2)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-2"
  create_report "$report_dir" "code_reviewer" 8.5

  evaluator_record_score "$tid" "code_reviewer" "$report_dir/code_reviewer_report.json" > /dev/null 2>&1

  local task_file=$(task_file "$tid")

  # Verify history has 1 entry
  assert_json_eq "history length is 1" "$task_file" ".history | length" "1"

  # Verify history entry content
  assert_json_eq "history event" "$task_file" ".history[0].event" "score_recorded"
  assert_json_eq "history phase" "$task_file" ".history[0].phase" "evaluate"
  assert_json_eq "history iteration" "$task_file" ".history[0].iteration" "2"
  assert_json_eq "history role" "$task_file" ".history[0].role" "code_reviewer"
  assert_json_eq "history score" "$task_file" ".history[0].score" "8.5"
  assert_json_eq "history timestamp exists" "$task_file" ".history[0].timestamp | length > 0" "true"
}

test_record_score_multiple_roles_accumulate_history() {
  echo "--- test_record_score_multiple_roles_accumulate_history ---"
  setup
  source_lib

  local tid=$(create_test_task "Multi role" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "code_reviewer" 9.0
  create_report "$report_dir" "qa" 8.0
  create_report "$report_dir" "pm" 7.5
  create_report "$report_dir" "designer" 9.5

  evaluator_record_score "$tid" "code_reviewer" "$report_dir/code_reviewer_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "qa" "$report_dir/qa_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "pm" "$report_dir/pm_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "designer" "$report_dir/designer_report.json" > /dev/null 2>&1

  local task_file=$(task_file "$tid")

  # Verify history has 4 entries
  assert_json_eq "history length is 4" "$task_file" ".history | length" "4"

  # Verify each role is present in history
  assert_json_eq "history[0] role" "$task_file" ".history[0].role" "code_reviewer"
  assert_json_eq "history[1] role" "$task_file" ".history[1].role" "qa"
  assert_json_eq "history[2] role" "$task_file" ".history[2].role" "pm"
  assert_json_eq "history[3] role" "$task_file" ".history[3].role" "designer"
}

test_record_score_preserves_existing_history() {
  echo "--- test_record_score_preserves_existing_history ---"
  setup
  source_lib

  local tid=$(create_test_task "Preserve test" 1)

  # Manually add a pre-existing history entry
  local task_file=$(task_file "$tid")
  local tmp=$(mktemp)
  jq '.history += [{"event": "phase_transition", "phase": "plan", "iteration": 1, "timestamp": "2026-01-01T00:00:00Z"}]' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "qa" 9.0

  evaluator_record_score "$tid" "qa" "$report_dir/qa_report.json" > /dev/null 2>&1

  # Verify history now has 2 entries (1 old + 1 new)
  assert_json_eq "history length is 2" "$task_file" ".history | length" "2"
  assert_json_eq "first entry preserved" "$task_file" ".history[0].event" "phase_transition"
  assert_json_eq "second entry is score" "$task_file" ".history[1].event" "score_recorded"
}

test_record_score_still_writes_scores_field() {
  echo "--- test_record_score_still_writes_scores_field ---"
  setup
  source_lib

  local tid=$(create_test_task "Score field" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "pm" 9.5

  evaluator_record_score "$tid" "pm" "$report_dir/pm_report.json" > /dev/null 2>&1

  local task_file=$(task_file "$tid")

  # Verify the existing .scores field is still written correctly
  assert_json_eq "scores.pm.score" "$task_file" ".scores.pm.score" "9.5"
  assert_json_eq "scores.pm.passed" "$task_file" ".scores.pm.passed" "true"
}

# ============================================================
# Test Group 2: evaluator_collect_scores shows average
# ============================================================
test_collect_scores_shows_average() {
  echo "--- test_collect_scores_shows_average ---"
  setup
  source_lib

  local tid=$(create_test_task "Average test" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "code_reviewer" 8.0
  create_report "$report_dir" "qa" 9.0
  create_report "$report_dir" "pm" 10.0
  create_report "$report_dir" "designer" 9.0

  evaluator_record_score "$tid" "code_reviewer" "$report_dir/code_reviewer_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "qa" "$report_dir/qa_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "pm" "$report_dir/pm_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "designer" "$report_dir/designer_report.json" > /dev/null 2>&1

  local output
  output=$(evaluator_collect_scores "$tid" 2>&1)

  assert_contains "shows code_reviewer" "$output" "code_reviewer: 8"
  assert_contains "shows qa" "$output" "qa: 9"
  assert_contains "shows pm" "$output" "pm: 10"
  assert_contains "shows designer" "$output" "designer: 9"
  assert_contains "shows average line" "$output" "Average:"
  assert_contains "shows 4 roles scored" "$output" "4/4 roles scored"
}

test_collect_scores_partial_average() {
  echo "--- test_collect_scores_partial_average ---"
  setup
  source_lib

  local tid=$(create_test_task "Partial average" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "code_reviewer" 8.0
  create_report "$report_dir" "qa" 10.0

  evaluator_record_score "$tid" "code_reviewer" "$report_dir/code_reviewer_report.json" > /dev/null 2>&1
  evaluator_record_score "$tid" "qa" "$report_dir/qa_report.json" > /dev/null 2>&1

  local output
  output=$(evaluator_collect_scores "$tid" 2>&1)

  assert_contains "shows average" "$output" "Average:"
  assert_contains "shows 2 roles scored" "$output" "2/4 roles scored"
}

test_collect_scores_no_scores_no_average() {
  echo "--- test_collect_scores_no_scores_no_average ---"
  setup
  source_lib

  local tid=$(create_test_task "No scores" 1)

  local output
  output=$(evaluator_collect_scores "$tid" 2>&1)

  # When no scores recorded, average line should NOT appear
  if echo "$output" | grep -q "Average:"; then
    echo "  FAIL: should not show Average when no scores"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: no Average line when no scores"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# ============================================================
# Test Group 3: kanban_score_history
# ============================================================
test_score_history_basic() {
  echo "--- test_score_history_basic ---"
  setup
  source_lib

  local tid=$(create_test_task "History table" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "code_reviewer" 8.5
  create_report "$report_dir" "qa" 9.0
  create_report "$report_dir" "pm" 7.5
  create_report "$report_dir" "designer" 10.0

  local output
  output=$(kanban_score_history "$tid" 2>&1)

  assert_contains "shows header" "$output" "Score History: ${tid}"
  assert_contains "shows column headers" "$output" "code_reviewer"
  assert_contains "shows iteration line" "$output" "iter-1"
  assert_contains "shows code_reviewer score" "$output" "8.5"
  assert_contains "shows pm score" "$output" "7.5"
  assert_contains "shows designer score" "$output" "10"
}

test_score_history_multiple_iterations() {
  echo "--- test_score_history_multiple_iterations ---"
  setup
  source_lib

  local tid=$(create_test_task "Multi iter" 2)
  local report_dir_1="$KANBAN_DIR/tasks/${tid}/iteration-1"
  local report_dir_2="$KANBAN_DIR/tasks/${tid}/iteration-2"
  create_report "$report_dir_1" "code_reviewer" 7.0
  create_report "$report_dir_1" "qa" 8.0
  create_report "$report_dir_2" "code_reviewer" 9.0
  create_report "$report_dir_2" "qa" 9.5

  local output
  output=$(kanban_score_history "$tid" 2>&1)

  assert_contains "shows iter-1" "$output" "iter-1"
  assert_contains "shows iter-2" "$output" "iter-2"
}

test_score_history_missing_report_shows_na() {
  echo "--- test_score_history_missing_report_shows_na ---"
  setup
  source_lib

  local tid=$(create_test_task "Missing report" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  # Only create code_reviewer report, others are missing
  create_report "$report_dir" "code_reviewer" 8.0

  local output
  output=$(kanban_score_history "$tid" 2>&1)

  assert_contains "shows code_reviewer score" "$output" "8"
  assert_contains "shows N/A for missing roles" "$output" "N/A"
}

test_score_history_no_reports() {
  echo "--- test_score_history_no_reports ---"
  setup
  source_lib

  local tid=$(create_test_task "No reports" 1)

  local output
  output=$(kanban_score_history "$tid" 2>&1)

  # Should show header but no iteration rows
  assert_contains "shows header" "$output" "Score History: ${tid}"
  if echo "$output" | grep -q "iter-"; then
    echo "  FAIL: should not show iteration rows when no reports"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: no iteration rows when no reports"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

test_score_history_task_not_found() {
  echo "--- test_score_history_task_not_found ---"
  setup
  source_lib

  local output
  output=$(kanban_score_history "TASK-999" 2>&1) || true
  assert_contains "not found message" "$output" "Task TASK-999 not found"
}

test_score_history_archived_task() {
  echo "--- test_score_history_archived_task ---"
  setup
  source_lib

  local tid=$(create_test_task "Archived" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "code_reviewer" 9.0

  kanban_decide "$tid" --action approve_and_archive > /dev/null 2>&1
  kanban_archive_task "$tid" > /dev/null 2>&1

  local output
  output=$(kanban_score_history "$tid" 2>&1)
  assert_contains "finds archived task" "$output" "Score History: ${tid}"
  assert_contains "shows score from report" "$output" "9"
}

# ============================================================
# Test Group 4: record_score output unchanged
# ============================================================
test_record_score_output_format() {
  echo "--- test_record_score_output_format ---"
  setup
  source_lib

  local tid=$(create_test_task "Output format" 1)
  local report_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  create_report "$report_dir" "code_reviewer" 8.5

  local output
  output=$(evaluator_record_score "$tid" "code_reviewer" "$report_dir/code_reviewer_report.json" 2>&1)
  assert_contains "recorded message" "$output" "Recorded: code_reviewer = 8.5"
  assert_contains "pass status" "$output" "false"
}

test_record_score_missing_report_errors() {
  echo "--- test_record_score_missing_report_errors ---"
  setup
  source_lib

  local tid=$(create_test_task "Missing report" 1)

  local output
  output=$(evaluator_record_score "$tid" "code_reviewer" "/nonexistent/report.json" 2>&1) || true
  assert_contains "error message" "$output" "ERROR: report not found"
}

# ============================================================
# Run all tests
# ============================================================
echo "========================================="
echo "Running ST-007 Score History tests"
echo "========================================="
echo ""

test_record_score_appends_history
teardown
test_record_score_multiple_roles_accumulate_history
teardown
test_record_score_preserves_existing_history
teardown
test_record_score_still_writes_scores_field
teardown
test_collect_scores_shows_average
teardown
test_collect_scores_partial_average
teardown
test_collect_scores_no_scores_no_average
teardown
test_score_history_basic
teardown
test_score_history_multiple_iterations
teardown
test_score_history_missing_report_shows_na
teardown
test_score_history_no_reports
teardown
test_score_history_task_not_found
teardown
test_score_history_archived_task
teardown
test_record_score_output_format
teardown
test_record_score_missing_report_errors
teardown

echo ""
echo "========================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_RUN total"
echo "========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
  exit 1
fi
