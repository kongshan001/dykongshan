#!/usr/bin/env bash
# test_clean_archived.sh -- Tests for kanban_clean_archived() (ST-002)
# Run: bash .claude/skills/kanban/test/test_clean_archived.sh

set -e

# ============================================================
# Test framework helpers
# ============================================================
PASS_COUNT=0
FAIL_COUNT=0

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  local msg="$1"
  echo "FAIL: $msg"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

assert_equals() {
  local expected="$1"
  local actual="$2"
  local label="${3:-assertion}"
  if [ "$expected" = "$actual" ]; then
    pass
  else
    fail "$label: expected='$expected' actual='$actual'"
  fi
}

assert_not_empty() {
  local val="$1"
  local label="${2:-assertion}"
  if [ -n "$val" ]; then
    pass
  else
    fail "$label: value is empty"
  fi
}

assert_file_exists() {
  local file="$1"
  local label="${2:-assertion}"
  if [ -e "$file" ]; then
    pass
  else
    fail "$label: file '$file' does not exist"
  fi
}

assert_file_not_exists() {
  local file="$1"
  local label="${2:-assertion}"
  if [ ! -e "$file" ]; then
    pass
  else
    fail "$label: file '$file' should NOT exist"
  fi
}

# ============================================================
# Setup: create temp kanban environment
# ============================================================
REAL_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG_DIR="$(pwd)"
TEST_TMPDIR=$(mktemp -d /tmp/test_clean_archived_XXXXXX)

cleanup() {
  cd "$ORIG_DIR"
  rm -rf "$TEST_TMPDIR"
}
trap cleanup EXIT

# Create a minimal git repo as working directory
cd "$TEST_TMPDIR"
git init -q
git config user.email "test@test.com"
git config user.name "Test"

# Copy only the lib files needed for testing
mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates/reports
mkdir -p .kanban

# Copy library files
cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true

# Copy template files
if [ -d "$REAL_SKILL_DIR/templates/reports" ]; then
  cp "$REAL_SKILL_DIR"/templates/reports/*.json .claude/skills/kanban/templates/reports/ 2>/dev/null || true
fi

# Source the libraries
KANBAN_DIR=".kanban"
export KANBAN_DIR

# Create minimal config files
cat > .kanban/config.json <<'CFG'
{
  "project": "test-project",
  "trunk": "main",
  "output_dir": "games",
  "dashboard": { "port": 3000 }
}
CFG

cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    { "id": "plan", "order": 1 },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3, "pass_threshold": 9.0 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

cat > .kanban/index.json <<'IDX'
{"project":"test-project","trunk":"main","tasks":[]}
IDX

# Make initial commit
git add -A
git commit -q -m "init"

# Source the shell libraries
source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

# Helper: create a mock archived task in .kanban/archive/
create_mock_archived_task() {
  local task_id="$1"
  local action="$2"
  local date="${3:-2026-01-15T10:00:00Z}"

  mkdir -p ".kanban/archive/${task_id}"
  cat > ".kanban/archive/${task_id}/task.json" <<TASKJSON
{
  "id": "${task_id}",
  "title": "Mock archived task ${task_id}",
  "status": "archived",
  "phase": "archive",
  "phase_lock": "archive",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "user_decision": { "action": "${action}", "feedback": "", "decided_at": "${date}" },
  "requires_archive_confirmation": true,
  "history": [],
  "created_at": "${date}",
  "updated_at": "${date}"
}
TASKJSON
  # Create a dummy file to test cleanup
  echo "test data" > ".kanban/archive/${task_id}/dummy.txt"
}

echo "============================================"
echo "  Test Suite: kanban_clean_archived (ST-002)"
echo "============================================"
echo ""

# ============================================================
# Test 1: 指定任务清理 -- 清理单个已归档任务
# ============================================================
echo "--- Test 1: Clean single archived task ---"

create_mock_archived_task "TASK-900" "approve_and_archive" "2026-01-15T10:00:00Z"
assert_file_exists ".kanban/archive/TASK-900/task.json" "Test1 setup: TASK-900 exists before clean"

CLEAN_OUTPUT=$(kanban_clean_archived "TASK-900" 2>&1)
assert_equals "0" "$?" "Test1: kanban_clean_archived returns 0 for single task"

assert_file_not_exists ".kanban/archive/TASK-900" "Test1: TASK-900 directory removed after clean"

echo ""

# ============================================================
# Test 2: 全部清理 -- 清理所有已归档任务
# ============================================================
echo "--- Test 2: Clean all archived tasks ---"

create_mock_archived_task "TASK-901" "approve_and_archive" "2026-02-01T10:00:00Z"
create_mock_archived_task "TASK-902" "abort" "2026-02-02T10:00:00Z"
create_mock_archived_task "TASK-903" "approve_and_archive" "2026-02-03T10:00:00Z"

assert_file_exists ".kanban/archive/TASK-901/task.json" "Test2 setup: TASK-901 exists"
assert_file_exists ".kanban/archive/TASK-902/task.json" "Test2 setup: TASK-902 exists"
assert_file_exists ".kanban/archive/TASK-903/task.json" "Test2 setup: TASK-903 exists"

CLEAN_ALL_OUTPUT=$(kanban_clean_archived "--all" 2>&1)
assert_equals "0" "$?" "Test2: kanban_clean_archived --all returns 0"

assert_file_not_exists ".kanban/archive/TASK-901" "Test2: TASK-901 removed"
assert_file_not_exists ".kanban/archive/TASK-902" "Test2: TASK-902 removed"
assert_file_not_exists ".kanban/archive/TASK-903" "Test2: TASK-903 removed"

# Verify preview list was shown
echo "$CLEAN_ALL_OUTPUT" | grep -q "Tasks to clean" && pass || fail "Test2: preview list shown"
echo "$CLEAN_ALL_OUTPUT" | grep -q "Clean completed" && pass || fail "Test2: completion message shown"

echo ""

# ============================================================
# Test 3: 按时间范围清理 -- 清理指定日期之前的任务
# ============================================================
echo "--- Test 3: Clean by date range ---"

create_mock_archived_task "TASK-910" "approve_and_archive" "2026-01-10T10:00:00Z"
create_mock_archived_task "TASK-911" "approve_and_archive" "2026-01-20T10:00:00Z"
create_mock_archived_task "TASK-912" "approve_and_archive" "2026-02-01T10:00:00Z"

# Clean tasks before 2026-01-15 (should get TASK-910 only, since decided_at is 2026-01-10)
CLEAN_BEFORE_OUTPUT=$(kanban_clean_archived "--before" "2026-01-15" 2>&1)
assert_equals "0" "$?" "Test3: kanban_clean_archived --before returns 0"

# TASK-910 (2026-01-10) should be cleaned (date is before 2026-01-15)
assert_file_not_exists ".kanban/archive/TASK-910" "Test3: TASK-910 (before date) removed"

# TASK-911 (2026-01-20) should remain (after the cutoff date)
assert_file_exists ".kanban/archive/TASK-911/task.json" "Test3: TASK-911 (after date) NOT removed"

# TASK-912 (2026-02-01) should remain
assert_file_exists ".kanban/archive/TASK-912/task.json" "Test3: TASK-912 (after date) NOT removed"

# Clean up remaining
rm -rf .kanban/archive/TASK-911 .kanban/archive/TASK-912

echo ""

# ============================================================
# Test 4: 跳过未归档任务 -- 验证状态不是 approve_and_archive/abort 的任务被跳过
# ============================================================
echo "--- Test 4: Skip tasks with non-archive actions ---"

create_mock_archived_task "TASK-920" "approve_and_archive" "2026-03-01T10:00:00Z"
# Create a task with empty action (should be skipped)
create_mock_archived_task "TASK-921" "" "2026-03-01T10:00:00Z"
# Create a task with restart_from_plan action (should be skipped)
create_mock_archived_task "TASK-922" "restart_from_plan" "2026-03-01T10:00:00Z"

CLEAN_SKIP_OUTPUT=$(kanban_clean_archived "--all" 2>&1)
assert_equals "0" "$?" "Test4: returns 0 even with skipped tasks"

# TASK-920 should be cleaned (approve_and_archive)
assert_file_not_exists ".kanban/archive/TASK-920" "Test4: TASK-920 (approve_and_archive) removed"

# TASK-921 should be skipped (empty action)
assert_file_exists ".kanban/archive/TASK-921/task.json" "Test4: TASK-921 (empty action) NOT removed"

# TASK-922 should be skipped (restart_from_plan)
assert_file_exists ".kanban/archive/TASK-922/task.json" "Test4: TASK-922 (restart_from_plan) NOT removed"

# Verify skip message was shown
echo "$CLEAN_SKIP_OUTPUT" | grep -q "Skipped" && pass || fail "Test4: skip message shown"

# Clean up remaining
rm -rf .kanban/archive/TASK-921 .kanban/archive/TASK-922

echo ""

# ============================================================
# Test 5: 幂等性 -- 重复清理不报错
# ============================================================
echo "--- Test 5: Idempotent clean ---"

create_mock_archived_task "TASK-930" "approve_and_archive" "2026-04-01T10:00:00Z"

# First clean
CLEAN_FIRST=$(kanban_clean_archived "TASK-930" 2>&1)
assert_equals "0" "$?" "Test5: first clean returns 0"
assert_file_not_exists ".kanban/archive/TASK-930" "Test5: TASK-930 removed on first clean"

# Second clean (idempotent)
CLEAN_SECOND=$(kanban_clean_archived "TASK-930" 2>&1)
assert_equals "0" "$?" "Test5: second clean returns 0 (idempotent)"
echo "$CLEAN_SECOND" | grep -q "No tasks to clean" && pass || fail "Test5: 'No tasks to clean' message on repeat"

echo ""

# ============================================================
# Test 6: 预览列表正确性
# ============================================================
echo "--- Test 6: Preview list correctness ---"

create_mock_archived_task "TASK-940" "approve_and_archive" "2026-05-01T10:00:00Z"
create_mock_archived_task "TASK-941" "abort" "2026-05-02T10:00:00Z"

PREVIEW_OUTPUT=$(kanban_clean_archived "--all" 2>&1)

# Verify both tasks appear in preview
echo "$PREVIEW_OUTPUT" | grep -q "TASK-940" && pass || fail "Test6: TASK-940 in preview"
echo "$PREVIEW_OUTPUT" | grep -q "TASK-941" && pass || fail "Test6: TASK-941 in preview"
echo "$PREVIEW_OUTPUT" | grep -q "approve_and_archive" && pass || fail "Test6: action shown in preview"
echo "$PREVIEW_OUTPUT" | grep -q "abort" && pass || fail "Test6: abort action shown in preview"
echo "$PREVIEW_OUTPUT" | grep -q "Total:" && pass || fail "Test6: Total line in preview"
echo "$PREVIEW_OUTPUT" | grep -q "disk space" && pass || fail "Test6: disk space info in preview"

assert_file_not_exists ".kanban/archive/TASK-940" "Test6: TASK-940 cleaned"
assert_file_not_exists ".kanban/archive/TASK-941" "Test6: TASK-941 cleaned"

echo ""

# ============================================================
# Test 7: No archive directory
# ============================================================
echo "--- Test 7: No archive directory ---"

# Remove archive directory
rm -rf .kanban/archive

NO_ARCHIVE_OUTPUT=$(kanban_clean_archived "--all" 2>&1)
assert_equals "0" "$?" "Test7: returns 0 when no archive dir"
echo "$NO_ARCHIVE_OUTPUT" | grep -q "No archived tasks found" && pass || fail "Test7: appropriate message when no archive"

echo ""

# ============================================================
# Test 8: --before with missing date argument
# ============================================================
echo "--- Test 8: --before missing date argument ---"

# Recreate archive directory so the function reaches the date check
mkdir -p .kanban/archive

BEFORE_NO_DATE=$(kanban_clean_archived "--before" 2>&1) || true
echo "$BEFORE_NO_DATE" | grep -q "ERROR" && pass || fail "Test8: error when --before missing date"

echo ""

# ============================================================
# Test 9: --before with invalid date format
# ============================================================
echo "--- Test 9: --before invalid date format ---"

BEFORE_INVALID=$(kanban_clean_archived "--before" "not-a-date" 2>&1) || true
echo "$BEFORE_INVALID" | grep -q "ERROR" && pass || fail "Test9: error when invalid date format"

echo ""

# ============================================================
# Summary
# ============================================================
echo "============================================"
TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed (total ${TOTAL})"
echo "============================================"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
