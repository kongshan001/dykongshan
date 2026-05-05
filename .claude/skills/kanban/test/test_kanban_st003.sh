#!/usr/bin/env bash
# test_kanban_st003.sh -- Tests for ST-003 additions: knowledge, progress, archive confirmation
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

assert_file_contains() {
  local label="$1" filepath="$2" needle="$3"
  if grep -q "$needle" "$filepath" 2>/dev/null; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    file: $filepath"
    echo "    not found: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_true() {
  local label="$1" condition="$2"
  if eval "$condition"; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    condition was false: $condition"
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

# ============================================================
# Test Group 1: kanban_create_task includes requires_archive_confirmation
# ============================================================
test_create_task_has_archive_confirmation() {
  echo "--- test_create_task_has_archive_confirmation ---"
  setup
  source_lib

  kanban_create_task "Test task" "Test description" > /dev/null 2>&1

  local tid=$(get_latest_task_id)
  local task_file=$(task_file "$tid")
  local val=$(jq -r '.requires_archive_confirmation' "$task_file")
  assert_eq "requires_archive_confirmation is true" "true" "$val"
}

# ============================================================
# Test Group 2: kanban_archive_task blocks without confirmation
# ============================================================
test_archive_blocked_without_confirmation() {
  echo "--- test_archive_blocked_without_confirmation ---"
  setup
  source_lib

  kanban_create_task "Test task" "Test description" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  local output
  output=$(kanban_archive_task "$tid" 2>&1) || true
  assert_contains "blocked message present" "$output" "归档需要用户确认"
}

test_archive_allowed_with_user_decision() {
  echo "--- test_archive_allowed_with_user_decision ---"
  setup
  source_lib

  kanban_create_task "Test task" "Test description" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  kanban_decide "$tid" --action approve_and_archive > /dev/null 2>&1

  local output
  output=$(kanban_archive_task "$tid" 2>&1) || true
  assert_contains "archive succeeded" "$output" "Archived $tid"
}

test_archive_allowed_with_abort() {
  echo "--- test_archive_allowed_with_abort ---"
  setup
  source_lib

  kanban_create_task "Test task 2" "Another test" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  # Bug #17 fix: abort now directly archives the task
  local decide_output
  decide_output=$(kanban_decide "$tid" --action abort 2>&1)

  # Verify task was archived (moved to archive directory)
  local archive_dir="$KANBAN_DIR/archive/${tid}"
  assert_true "archive dir created after abort" "[ -d '$archive_dir' ]"
  assert_true "archive task.json exists" "[ -f '${archive_dir}/task.json' ]"

  # Verify task status was set to aborted before archive
  local archived_tf="${archive_dir}/task.json"
  local archived_status
  archived_status=$(jq -r '.status' "$archived_tf")
  assert_eq "status is aborted" "aborted" "$archived_status"
}

# ============================================================
# Test Group 3: kanban_decide with approve_and_archive confirmation
# ============================================================
test_decide_approve_and_archive_prints_confirmation() {
  echo "--- test_decide_approve_and_archive_prints_confirmation ---"
  setup
  source_lib

  kanban_create_task "Test task" "Test description" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  local output
  output=$(kanban_decide "$tid" --action approve_and_archive 2>&1)
  assert_contains "confirmation message" "$output" "Archive confirmation"
  assert_contains "decision recorded" "$output" "Decision recorded"
}

# ============================================================
# Test Group 4: kanban_knowledge_add
# ============================================================
test_knowledge_add_creates_entry() {
  echo "--- test_knowledge_add_creates_entry ---"
  setup
  source_lib

  local output
  output=$(kanban_knowledge_add "pattern" "Use mktemp for atomic writes" "TASK-001")
  assert_contains "added K001" "$output" "K001"
  assert_contains "category shown" "$output" "pattern"

  local log_file="$KANBAN_DIR/knowledge-log.md"
  assert_file_contains "log has K001" "$log_file" "K001"
  assert_file_contains "log has category" "$log_file" "pattern"
  assert_file_contains "log has source" "$log_file" "TASK-001"
  assert_file_contains "log has description" "$log_file" "Use mktemp for atomic writes"
}

test_knowledge_add_increments_id() {
  echo "--- test_knowledge_add_increments_id ---"
  setup
  source_lib

  kanban_knowledge_add "cat1" "desc1" "TASK-001"
  local output
  output=$(kanban_knowledge_add "cat2" "desc2" "TASK-002")
  assert_contains "second entry K002" "$output" "K002"
}

# ============================================================
# Test Group 5: kanban_knowledge_list
# ============================================================
test_knowledge_list_all() {
  echo "--- test_knowledge_list_all ---"
  setup
  source_lib

  kanban_knowledge_add "pattern" "Atomic writes" "TASK-001"
  kanban_knowledge_add "antipattern" "Direct mv without tmp" "TASK-002"

  local output
  output=$(kanban_knowledge_list)
  assert_contains "shows K001" "$output" "K001"
  assert_contains "shows K002" "$output" "K002"
}

test_knowledge_list_filtered() {
  echo "--- test_knowledge_list_filtered ---"
  setup
  source_lib

  kanban_knowledge_add "pattern" "Atomic writes" "TASK-001"
  kanban_knowledge_add "antipattern" "Direct mv" "TASK-002"

  local output
  output=$(kanban_knowledge_list "pattern")
  assert_contains "shows pattern entry" "$output" "Atomic writes"
}

test_knowledge_list_missing_file() {
  echo "--- test_knowledge_list_missing_file ---"
  setup
  source_lib

  local output
  output=$(kanban_knowledge_list 2>&1) || true
  assert_contains "not found message" "$output" "Knowledge log not found"
}

# ============================================================
# Test Group 6: kanban_knowledge_search
# ============================================================
test_knowledge_search() {
  echo "--- test_knowledge_search ---"
  setup
  source_lib

  kanban_knowledge_add "pattern" "Atomic writes with mktemp" "TASK-001"
  kanban_knowledge_add "antipattern" "Race condition with direct write" "TASK-002"

  local output
  output=$(kanban_knowledge_search "Atomic")
  assert_contains "finds matching entry" "$output" "K001"
  assert_contains "shows description" "$output" "Atomic writes"
}

test_knowledge_search_no_match() {
  echo "--- test_knowledge_search_no_match ---"
  setup
  source_lib

  kanban_knowledge_add "pattern" "Atomic writes" "TASK-001"

  local output
  output=$(kanban_knowledge_search "nonexistent_xyz" 2>&1) || true
  if echo "$output" | grep -q "K001"; then
    echo "  FAIL: should not match K001"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: no false match"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# ============================================================
# Test Group 7: kanban_progress (single task)
# ============================================================
test_progress_single_task_no_reports() {
  echo "--- test_progress_single_task_no_reports ---"
  setup
  source_lib

  kanban_create_task "Test task" "Test description" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  local output
  output=$(kanban_progress "$tid" 2>&1)
  assert_contains "title shown" "$output" "Progress: $tid"
  # When reports dir exists but has no iteration-* subdirs, the table is empty
  # (reports/ dir is created by kanban_create_inbox, but no iteration reports)
  assert_contains "has scores table header" "$output" "Iteration"
}

test_progress_single_task_with_scores() {
  echo "--- test_progress_single_task_with_scores ---"
  setup
  source_lib

  kanban_create_task "Test task" "Test description" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  # Use new layout path: tasks/TASK-NNN/iteration-1/
  local iter_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  mkdir -p "$iter_dir"
  jq -n '{role:"code_reviewer",score:8.5}' > "$iter_dir/code_reviewer_report.json"
  jq -n '{role:"qa",score:9.0}' > "$iter_dir/qa_report.json"

  local output
  output=$(kanban_progress "$tid" 2>&1)
  assert_contains "shows iteration header" "$output" "Iteration"
  assert_contains "shows code_reviewer score" "$output" "code_reviewer=8.5"
  # jq may output 9.0 as 9 (strips trailing zero)
  if echo "$output" | grep -q "qa=9"; then
    echo "  PASS: shows qa score (normalized)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: shows qa score"
    echo "    output: $output"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

test_progress_single_task_archived() {
  echo "--- test_progress_single_task_archived ---"
  setup
  source_lib

  kanban_create_task "Archived task" "Was archived" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  kanban_decide "$tid" --action approve_and_archive > /dev/null 2>&1
  kanban_archive_task "$tid" > /dev/null 2>&1

  local output
  output=$(kanban_progress "$tid" 2>&1)
  assert_contains "finds archived task" "$output" "Progress: $tid"
}

test_progress_nonexistent_task() {
  echo "--- test_progress_nonexistent_task ---"
  setup
  source_lib

  local output
  output=$(kanban_progress "TASK-999" 2>&1) || true
  assert_contains "not found message" "$output" "Task TASK-999 not found"
}

# ============================================================
# Test Group 8: kanban_progress (global overview)
# ============================================================
test_progress_global_overview() {
  echo "--- test_progress_global_overview ---"
  setup
  source_lib

  kanban_create_task "Archived task" "Done" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  # Use new layout path: tasks/TASK-NNN/iteration-1/
  local iter_dir="$KANBAN_DIR/tasks/${tid}/iteration-1"
  mkdir -p "$iter_dir"
  jq -n '{role:"code_reviewer",score:9.0}' > "$iter_dir/code_reviewer_report.json"
  kanban_decide "$tid" --action approve_and_archive > /dev/null 2>&1
  kanban_archive_task "$tid" > /dev/null 2>&1

  local output
  output=$(kanban_progress 2>&1)
  assert_contains "overview header" "$output" "Kanban Progress Overview"
  assert_contains "task listed" "$output" "$tid"
  # jq may output 9.0 as 9 (strips trailing zero)
  if echo "$output" | grep -q "code_reviewer=9"; then
    echo "  PASS: score shown (normalized)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: score shown"
    echo "    output: $output"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# ============================================================
# Test Group 9: Existing functions still work
# ============================================================
test_existing_status_works() {
  echo "--- test_existing_status_works ---"
  setup
  source_lib

  kanban_create_task "Test task" "desc" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  local output
  output=$(kanban_status 2>&1)
  assert_contains "status shows task" "$output" "$tid"
}

test_existing_show_task_works() {
  echo "--- test_existing_show_task_works ---"
  setup
  source_lib

  kanban_create_task "Test task" "desc" > /dev/null 2>&1
  local tid=$(get_latest_task_id)

  local output
  output=$(kanban_show_task "$tid" 2>&1)
  assert_contains "show displays title" "$output" "Test task"
}

# ============================================================
# Run all tests
# ============================================================
echo "========================================="
echo "Running ST-003 kanban.sh tests"
echo "========================================="
echo ""

test_create_task_has_archive_confirmation
teardown
test_archive_blocked_without_confirmation
teardown
test_archive_allowed_with_user_decision
teardown
test_archive_allowed_with_abort
teardown
test_decide_approve_and_archive_prints_confirmation
teardown
test_knowledge_add_creates_entry
teardown
test_knowledge_add_increments_id
teardown
test_knowledge_list_all
teardown
test_knowledge_list_filtered
teardown
test_knowledge_list_missing_file
teardown
test_knowledge_search
teardown
test_knowledge_search_no_match
teardown
test_progress_single_task_no_reports
teardown
test_progress_single_task_with_scores
teardown
test_progress_single_task_archived
teardown
test_progress_nonexistent_task
teardown
test_progress_global_overview
teardown
test_existing_status_works
teardown
test_existing_show_task_works
teardown

echo ""
echo "========================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_RUN total"
echo "========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
  exit 1
fi
