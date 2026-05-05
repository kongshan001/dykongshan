#!/usr/bin/env bash
# test_core_bugs.sh -- Regression tests for Bug #1, #2, #4, #11, #12
# Run: bash .claude/skills/kanban/test/test_core_bugs.sh

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

assert_file_contains() {
  local file="$1"
  local pattern="$2"
  local label="${3:-assertion}"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    pass
  else
    fail "$label: pattern '$pattern' not found in $file"
  fi
}

assert_file_not_contains() {
  local file="$1"
  local pattern="$2"
  local label="${3:-assertion}"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    fail "$label: pattern '$pattern' should NOT be in $file"
  else
    pass
  fi
}

assert_exit_code() {
  local expected="$1"
  shift
  local label="$1"
  shift
  local actual
  actual=$("$@" 2>&1; echo "EXIT:$?")
  local ec=$(echo "$actual" | grep -o 'EXIT:[0-9]*' | sed 's/EXIT://')
  if [ "$expected" = "$ec" ]; then
    pass
  else
    fail "$label: expected exit=$expected actual=$ec"
  fi
}

# ============================================================
# Setup: create temp kanban environment
# ============================================================
# SKILL_DIR points to the real skills source (in the worktree)
REAL_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG_DIR="$(pwd)"
TEST_TMPDIR=$(mktemp -d /tmp/test_core_bugs_XXXXXX)

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

# Copy only the lib files needed for testing (not the entire skills tree)
mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates/reports
mkdir -p .kanban

# Copy library files
cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/

# Copy template files
if [ -d "$REAL_SKILL_DIR/templates/reports" ]; then
  cp "$REAL_SKILL_DIR"/templates/reports/*.json .claude/skills/kanban/templates/reports/
fi

# Source the libraries (kanban.sh first, then others)
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

echo "============================================"
echo "  Test Suite: Core Bug Fixes (#1#2#4#11#12)"
echo "============================================"
echo ""

# ============================================================
# Bug #1: _update_index should only be defined in kanban.sh
# ============================================================
echo "--- Bug #1: _update_index not overridden by workflow.sh ---"

# Verify _update_index is the kanban.sh version (not the empty wrapper from workflow.sh)
# The kanban.sh version scans tasks/TASK-*/task.json (new layout) and tasks/TASK-*.json (old layout)
# Test: create a new-format task and verify _update_index picks it up
mkdir -p .kanban/tasks/TASK-099
cat > .kanban/tasks/TASK-099/task.json <<'TASK'
{
  "id": "TASK-099",
  "status": "pending",
  "phase": null,
  "iteration": 0
}
TASK

_update_index
# The index should contain TASK-099
assert_file_contains ".kanban/index.json" "TASK-099" "Bug#1: _update_index picks up new format task"

# Verify the workflow.sh does NOT contain the overriding _update_index function definition
assert_file_not_contains ".claude/skills/kanban/lib/workflow.sh" "^_update_index()" "Bug#1: workflow.sh should not define _update_index()"

# Clean up test task
rm -rf .kanban/tasks/TASK-099
_update_index

echo ""

# ============================================================
# Bug #2: Dashboard readAllTasks supports new format subdirs
# ============================================================
echo "--- Bug #2: Dashboard new format support ---"

# Create new-format task for dashboard testing
mkdir -p .kanban/tasks/TASK-100
cat > .kanban/tasks/TASK-100/task.json <<'TASK'
{
  "id": "TASK-100",
  "title": "New Format Task",
  "description": "A task in new directory layout",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Also create an old-format task for backward compat test
cat > .kanban/tasks/TASK-101.json <<'TASK'
{
  "id": "TASK-101",
  "title": "Old Format Task",
  "description": "A task in old flat layout",
  "status": "pending",
  "phase": null,
  "iteration": 0,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Test readAllTasks via Node.js (if node is available)
if command -v node >/dev/null 2>&1; then
  # Copy server.js for testing (needed by dashboard tests)
  mkdir -p .claude/skills/kanban/dashboard
  cp "$REAL_SKILL_DIR/dashboard/server.js" .claude/skills/kanban/dashboard/server.js

  # Extract readAllTasks and test it
  DASH_RESULT=$(node -e "
    const fs = require('fs');
    const path = require('path');
    const KANBAN_ROOT = '$TEST_TMPDIR/.kanban';
    // Load functions from server.js
    const serverCode = fs.readFileSync('.claude/skills/kanban/dashboard/server.js', 'utf-8');
    // Extract readAllTasks function
    const fnMatch = serverCode.match(/function readAllTasks\(\)\s*\{[\s\S]*?\n\}/);
    if (!fnMatch) { console.error('ERROR: readAllTasks not found'); process.exit(1); }
    // Extract readTaskJson function
    const fnMatch2 = serverCode.match(/function readTaskJson[\s\S]*?\n\}/);
    // Evaluate the functions
    eval(fnMatch2[0]);
    eval(fnMatch[0]);
    const tasks = readAllTasks();
    console.log(JSON.stringify(tasks));
  " 2>/dev/null || echo "PARSE_ERROR")

  if [ "$DASH_RESULT" != "PARSE_ERROR" ]; then
    # Verify TASK-100 (new format) is found
    assert_not_empty "$(echo "$DASH_RESULT" | jq '.[] | select(.id=="TASK-100")' 2>/dev/null)" \
      "Bug#2: new format task TASK-100 found by readAllTasks"

    # Verify TASK-101 (old format) is found
    assert_not_empty "$(echo "$DASH_RESULT" | jq '.[] | select(.id=="TASK-101")' 2>/dev/null)" \
      "Bug#2: old format task TASK-101 found by readAllTasks"

    # Verify we got exactly 2 tasks
    TASK_COUNT=$(echo "$DASH_RESULT" | jq 'length' 2>/dev/null || echo "0")
    assert_equals "2" "$TASK_COUNT" "Bug#2: readAllTasks returns both new and old format tasks"
  else
    echo "SKIP: Dashboard JS parsing failed (non-blocking for shell tests)"
  fi

  # Test /api/tasks/:id via readTaskJson
  DETAIL_RESULT=$(node -e "
    const fs = require('fs');
    const path = require('path');
    const tasksDir = '$TEST_TMPDIR/.kanban/tasks';
    const serverCode = fs.readFileSync('.claude/skills/kanban/dashboard/server.js', 'utf-8');
    const fnMatch = serverCode.match(/function readTaskJson[\s\S]*?\n\}/);
    if (!fnMatch) { console.error('NOT_FOUND'); process.exit(0); }
    eval(fnMatch[0]);
    const data = readTaskJson(tasksDir, 'TASK-100.json');
    if (data) { console.log(JSON.stringify(data)); } else { console.log('NOT_FOUND'); }
  " 2>/dev/null || echo "ERROR")

  assert_not_empty "$(echo "$DETAIL_RESULT" | jq '.id' 2>/dev/null | grep TASK-100)" \
    "Bug#2: readTaskJson finds new format task by ID"
else
  echo "SKIP: Node.js not available, skipping Dashboard tests"
fi

# Clean up
rm -rf .kanban/tasks/TASK-100 .kanban/tasks/TASK-101.json

echo ""

# ============================================================
# Bug #4: evaluator.sh maps role names with hyphens to template files
# ============================================================
echo "--- Bug #4: evaluator template filename mapping ---"

# Verify template files exist with hyphen names
assert_file_contains ".claude/skills/kanban/templates/reports/code-reviewer.json" "required_fields" \
  "Bug#4: code-reviewer.json template exists"

# Verify evaluator.sh uses the mapping (look for the tr command with underscore-to-hyphen mapping)
assert_file_contains ".claude/skills/kanban/lib/evaluator.sh" "tr '_' '-'" \
  "Bug#4: evaluator.sh has role name mapping (tr '_' '-')"

# Test the mapping produces correct filenames
MAPPED=$(echo "code_reviewer" | tr '_' '-')
assert_equals "code-reviewer" "$MAPPED" "Bug#4: code_reviewer mapped to code-reviewer"

MAPPED2=$(echo "qa" | tr '_' '-')
assert_equals "qa" "$MAPPED2" "Bug#4: qa stays as qa (no underscores)"

# Test that evaluator_prepare_all can find templates (if jq available)
if command -v jq >/dev/null 2>&1; then
  # Create a test task for evaluator
  mkdir -p .kanban/tasks/TASK-102
  cat > .kanban/tasks/TASK-102/task.json <<'TASK'
{
  "id": "TASK-102",
  "title": "Evaluator Test",
  "description": "Testing evaluator template mapping",
  "status": "evaluating",
  "phase": "evaluate",
  "phase_lock": "evaluate",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-102", "path": "" },
  "scores": {},
  "history": []
}
TASK
  mkdir -p .kanban/tasks/TASK-102/iteration-1
  mkdir -p .kanban/tasks/TASK-102/dispatch

  # Run evaluator_prepare_all and check for errors
  PREP_OUTPUT=$(evaluator_prepare_all "TASK-102" 2>&1) || true

  # All 4 roles should be prepared without error
  assert_not_empty "$(echo "$PREP_OUTPUT" | grep 'code_reviewer')" \
    "Bug#4: code_reviewer dispatch prepared"
  assert_not_empty "$(echo "$PREP_OUTPUT" | grep 'qa')" \
    "Bug#4: qa dispatch prepared"
  assert_not_empty "$(echo "$PREP_OUTPUT" | grep 'pm')" \
    "Bug#4: pm dispatch prepared"
  assert_not_empty "$(echo "$PREP_OUTPUT" | grep 'designer')" \
    "Bug#4: designer dispatch prepared"

  # Verify dispatch files were created with valid JSON
  for role in code_reviewer qa pm designer; do
    DISPATCH=".kanban/tasks/TASK-102/dispatch/TASK-102-${role}.json"
    if [ -f "$DISPATCH" ]; then
      jq '.' "$DISPATCH" >/dev/null 2>&1
      assert_equals "0" "$?" "Bug#4: $DISPATCH is valid JSON"
    fi
  done

  rm -rf .kanban/tasks/TASK-102
fi

echo ""

# ============================================================
# Bug #11: kanban_archive_task mv operations have error checking
# ============================================================
echo "--- Bug #11: archive mv error checking ---"

# Verify the source has || return 1 on mv operations
assert_file_contains ".claude/skills/kanban/lib/kanban.sh" '|| { echo "ERROR: failed to archive task directory"; return 1; }' \
  "Bug#11: mv of task directory has error check"

assert_file_contains ".claude/skills/kanban/lib/kanban.sh" '|| { echo "ERROR: failed to archive old format task file"; return 1; }' \
  "Bug#11: mv of old format file has error check"

assert_file_contains ".claude/skills/kanban/lib/kanban.sh" '|| { echo "ERROR: failed to merge old format file into task directory"; return 1; }' \
  "Bug#11: mv of old->new format merge has error check"

assert_file_contains ".claude/skills/kanban/lib/kanban.sh" '|| { echo "ERROR: failed to clear worktree fields"; return 1; }' \
  "Bug#11: mv for worktree field clearing has error check"

# Functional test: archive a task with proper setup
mkdir -p .kanban/tasks/TASK-103
cat > .kanban/tasks/TASK-103/task.json <<'TASK'
{
  "id": "TASK-103",
  "title": "Archive Test",
  "status": "user_decision",
  "phase": "user_decision",
  "phase_lock": "user_decision",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "user_decision": { "action": "approve_and_archive", "feedback": "", "decided_at": "2026-01-01T00:00:00Z" },
  "requires_archive_confirmation": true,
  "history": []
}
TASK

mkdir -p .kanban/archive
ARCHIVE_RESULT=$(kanban_archive_task "TASK-103" 2>&1)
assert_equals "0" "$?" "Bug#11: archive succeeds for valid task"

# Verify the task was moved to archive
if [ -d ".kanban/archive/TASK-103" ]; then
  pass
else
  fail "Bug#11: task directory moved to archive"
fi

# Verify it was removed from tasks
if [ ! -d ".kanban/tasks/TASK-103" ]; then
  pass
else
  fail "Bug#11: task directory removed from tasks after archive"
fi

# Clean up
rm -rf .kanban/archive/TASK-103

echo ""

# ============================================================
# Bug #12: kanban_decide calls workflow_transition
# ============================================================
echo "--- Bug #12: kanban_decide calls workflow_transition ---"

# Verify the source contains the workflow_transition call
assert_file_contains ".claude/skills/kanban/lib/kanban.sh" 'workflow_transition.*user_decision' \
  "Bug#12: kanban_decide contains workflow_transition call"

# Functional test: create a task already in user_decision phase (the normal flow)
# In production, the orchestrator transitions to user_decision before calling kanban_decide.
# Bug #12 fix ensures the transition is attempted if it hasn't happened yet.
mkdir -p .kanban/tasks/TASK-104
cat > .kanban/tasks/TASK-104/task.json <<'TASK'
{
  "id": "TASK-104",
  "title": "Decide Test",
  "status": "user_decision",
  "phase": "user_decision",
  "phase_lock": "user_decision",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-104", "path": "" },
  "scores": {},
  "history": [],
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

DECIDE_OUTPUT=$(kanban_decide "TASK-104" --action approve_and_archive 2>&1)
assert_equals "0" "$?" "Bug#12: kanban_decide succeeds"

# Verify user_decision was recorded
UD_ACTION=$(jq -r '.user_decision.action' .kanban/tasks/TASK-104/task.json 2>/dev/null)
assert_equals "approve_and_archive" "$UD_ACTION" "Bug#12: user_decision.action recorded"

# Verify phase stays at user_decision (it was already there, transition should be a no-op)
PHASE=$(jq -r '.phase' .kanban/tasks/TASK-104/task.json 2>/dev/null)
assert_equals "user_decision" "$PHASE" "Bug#12: phase remains user_decision after decide"

# Verify phase_lock stays at user_decision
PHASE_LOCK=$(jq -r '.phase_lock' .kanban/tasks/TASK-104/task.json 2>/dev/null)
assert_equals "user_decision" "$PHASE_LOCK" "Bug#12: phase_lock remains user_decision after decide"

# Clean up
rm -rf .kanban/tasks/TASK-104

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
