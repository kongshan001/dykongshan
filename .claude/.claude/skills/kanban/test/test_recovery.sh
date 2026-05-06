#!/usr/bin/env bash
# test_recovery.sh -- Tests for ST-003: Task interruption recovery mechanism
# Covers:
#   1. recover_list_interrupted detects process liveness via PID file
#   2. _recovery_mark_interrupted writes interrupted_at / last_known_phase / recovery_context
#   3. recover_resume_task restores task to last_known_phase
#   4. recover_rollback_task rolls back to safe checkpoint and clears artifacts
#   5. guard_check allows transition for resumed/rolled_back tasks
#   6. kanban_decide blocks on interrupted tasks
#   7. recover_record_pid / recover_clear_pid PID file management
# Run: bash .claude/skills/kanban/test/test_recovery.sh

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

assert_contains() {
  local needle="$1"
  local haystack="$2"
  local label="${3:-assertion}"
  if echo "$haystack" | grep -q "$needle"; then
    pass
  else
    fail "$label: '$needle' not found in output"
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
  local f="$1"
  local label="${2:-assertion}"
  if [ -f "$f" ]; then
    pass
  else
    fail "$label: file '$f' does not exist"
  fi
}

assert_file_not_exists() {
  local f="$1"
  local label="${2:-assertion}"
  if [ ! -f "$f" ]; then
    pass
  else
    fail "$label: file '$f' should not exist"
  fi
}

# ============================================================
# Setup: create temp kanban environment
# ============================================================
REAL_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG_DIR="$(pwd)"
TEST_TMPDIR=$(mktemp -d /tmp/test_recovery_XXXXXX)

cleanup() {
  cd "$ORIG_DIR"
  rm -rf "$TEST_TMPDIR"
}
trap cleanup EXIT

cd "$TEST_TMPDIR"
git init -q
git config user.email "test@test.com"
git config user.name "Test"

mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates
mkdir -p .kanban/tasks

# Copy all lib files for full functionality
cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/
# Remove any misplaced test files from the lib directory
rm -f .claude/skills/kanban/lib/test_*.sh

# Ensure templates exist
mkdir -p .claude/skills/kanban/templates
if [ -f "$REAL_SKILL_DIR/templates/config.json" ]; then
  cp "$REAL_SKILL_DIR"/templates/*.json .claude/skills/kanban/templates/
fi

KANBAN_DIR=".kanban"
export KANBAN_DIR

# Minimal kanban config
cat > .kanban/config.json <<'CFG'
{
  "project": "test-recovery",
  "trunk": "main",
  "output_dir": "scripts",
  "version": "0.1.0",
  "timeout": {
    "plan_seconds": 300,
    "execute_seconds": 600,
    "evaluate_seconds": 300
  }
}
CFG

# Minimal workflow.json
cat > .kanban/workflow.json <<'WF'
{
  "id": "kanban-fsm",
  "phases": [
    {"id": "plan"},
    {"id": "execute"},
    {"id": "evaluate"},
    {"id": "user_decision"},
    {"id": "archive"}
  ],
  "max_iterations": 6
}
WF

# Source the lib files
SKILL_DIR="$(pwd)/.claude/skills/kanban"
export SKILL_DIR
source "$SKILL_DIR/lib/kanban.sh" 2>/dev/null
kanban_init_env 2>/dev/null || true

echo "Test environment ready at $TEST_TMPDIR"
echo ""

# ============================================================
# Test 1: recover_record_pid and recover_clear_pid
# ============================================================
echo "=== Test 1: PID File Management ==="

TEST_TASK="TASK-001"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK"
cat > "$KANBAN_DIR/tasks/$TEST_TASK/task.json" <<'TJSON'
{
  "id": "TASK-001",
  "title": "Test Recovery Task",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "history": []
}
TJSON

# Record PID
recover_record_pid "$TEST_TASK"
pid_file=$(_recovery_pid_file "$TEST_TASK")
assert_file_exists "$pid_file" "PID file should exist after record_pid"

# Verify PID content
pid_content=$(cat "$pid_file")
assert_equals "$$" "$pid_content" "PID file should contain current shell PID"

# Check process alive detection
_recovery_is_task_process_alive "$TEST_TASK"
assert_equals "0" "$?" "Task process should be detected as alive (via PID file)"

# Clear PID
recover_clear_pid "$TEST_TASK"
assert_file_not_exists "$pid_file" "PID file should not exist after clear_pid"

# After clearing PID, process should be detected as NOT alive
# (unless there's a process with TASK-001 in its command line, which there shouldn't be)
pid_alive_after_clear=0
_recovery_is_task_process_alive "$TEST_TASK" || pid_alive_after_clear=1
assert_equals "1" "$pid_alive_after_clear" "Task process should NOT be detected as alive after clearing PID"

echo ""

# ============================================================
# Test 2: _recovery_mark_interrupted writes correct fields
# ============================================================
echo "=== Test 2: Mark Interrupted ==="

TEST_TASK2="TASK-002"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK2"
cat > "$KANBAN_DIR/tasks/$TEST_TASK2/task.json" <<'TJSON2'
{
  "id": "TASK-002",
  "title": "Interrupted Test Task",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "task_breakdown": {
    "subtasks": [
      {"id": "ST-001", "title": "Subtask 1", "status": "completed"},
      {"id": "ST-002", "title": "Subtask 2", "status": "in_progress"},
      {"id": "ST-003", "title": "Subtask 3", "status": "pending"}
    ]
  },
  "history": [
    {"phase": "plan", "status": "completed", "entered_at": "2026-05-01T00:00:00Z"},
    {"phase": "execute", "status": "entered", "entered_at": "2026-05-01T01:00:00Z"}
  ]
}
TJSON2

TF2=$(task_file "$TEST_TASK2")
_recovery_mark_interrupted "$TEST_TASK2" "$TF2"

# Verify interrupted fields
interrupted_status=$(jq -r '.status' "$TF2")
assert_equals "interrupted" "$interrupted_status" "Status should be 'interrupted'"

interrupted_at=$(jq -r '.interrupted_at' "$TF2")
assert_not_empty "$interrupted_at" "interrupted_at should be set"

last_phase=$(jq -r '.last_known_phase' "$TF2")
assert_equals "execute" "$last_phase" "last_known_phase should be 'execute'"

last_status=$(jq -r '.last_known_status' "$TF2")
assert_equals "executing" "$last_status" "last_known_status should be 'executing'"

# Verify recovery_context
current_subtask=$(jq -r '.recovery_context.current_subtask' "$TF2")
assert_equals "ST-002" "$current_subtask" "current_subtask should be ST-002 (in_progress)"

completed_count=$(jq '.recovery_context.completed_steps | length' "$TF2")
assert_equals "1" "$completed_count" "Should have 1 completed step in recovery_context"

# Verify history entry
hist_event=$(jq -r '.history[-1].status' "$TF2")
assert_equals "interrupted" "$hist_event" "Last history entry should be 'interrupted'"

echo ""

# ============================================================
# Test 3: recover_resume_task
# ============================================================
echo "=== Test 3: Resume Task ==="

# Task is already in interrupted state from Test 2
resume_output=$(recover_resume_task "$TEST_TASK2" 2>&1)
resume_rc=$?

assert_equals "0" "$resume_rc" "recover_resume_task should succeed"
assert_contains "Resume" "$resume_output" "Output should mention Resume"

# Verify cleared interrupted fields
resume_status=$(jq -r '.status' "$TF2")
assert_equals "executing" "$resume_status" "Status should be 'executing' after resume"

resume_phase=$(jq -r '.phase_lock' "$TF2")
assert_equals "execute" "$resume_phase" "phase_lock should be 'execute' after resume"

# Check interrupted_at is cleared (null)
interrupted_after=$(jq -r '.interrupted_at // "CLEARED"' "$TF2")
assert_equals "CLEARED" "$interrupted_after" "interrupted_at should be cleared (null)"

# Check last history entry is "resumed"
last_hist=$(jq -r '.history[-1].status' "$TF2")
assert_equals "resumed" "$last_hist" "Last history entry should be 'resumed'"

echo ""

# ============================================================
# Test 4: recover_rollback_task
# ============================================================
echo "=== Test 4: Rollback Task ==="

TEST_TASK3="TASK-003"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK3"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1"
# Create some artifacts to be cleared
echo "summary content" > "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/execution_summary.md"
echo "pitfalls content" > "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/execution_pitfalls.md"
echo "decisions content" > "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/execution_decisions.md"
echo '{"score":8}' > "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/code_reviewer_report.json"

cat > "$KANBAN_DIR/tasks/$TEST_TASK3/task.json" <<'TJSON3'
{
  "id": "TASK-003",
  "title": "Rollback Test Task",
  "status": "interrupted",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "interrupted_at": "2026-05-05T12:00:00Z",
  "last_known_phase": "execute",
  "last_known_status": "executing",
  "recovery_context": {
    "current_subtask": "ST-002",
    "completed_steps": ["ST-001"]
  },
  "history": [
    {"phase": "plan", "status": "completed", "entered_at": "2026-05-01T00:00:00Z"},
    {"phase": "execute", "status": "entered", "entered_at": "2026-05-01T01:00:00Z"},
    {"phase": "recovery", "status": "interrupted", "entered_at": "2026-05-05T12:00:00Z"}
  ]
}
TJSON3

TF3=$(task_file "$TEST_TASK3")

# Run rollback
rollback_output=$(recover_rollback_task "$TEST_TASK3" 2>&1)
rollback_rc=$?

assert_equals "0" "$rollback_rc" "recover_rollback_task should succeed"
assert_contains "Rollback" "$rollback_output" "Output should mention Rollback"

# Should rollback from execute to plan (plan was completed)
rollback_status=$(jq -r '.status' "$TF3")
assert_equals "planning" "$rollback_status" "Status should be 'planning' after rollback (from execute to plan)"

rollback_phase=$(jq -r '.phase_lock' "$TF3")
assert_equals "plan" "$rollback_phase" "phase_lock should be 'plan' after rollback"

# Verify execute artifacts were cleared
assert_file_not_exists "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/execution_summary.md" \
  "execution_summary.md should be cleared by rollback"
assert_file_not_exists "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/execution_pitfalls.md" \
  "execution_pitfalls.md should be cleared by rollback"
assert_file_not_exists "$KANBAN_DIR/tasks/$TEST_TASK3/iteration-1/execution_decisions.md" \
  "execution_decisions.md should be cleared by rollback"

# But evaluate artifacts (code_reviewer_report.json) should NOT be cleared since
# we're rolling back from execute, not evaluate
# (Actually, code_reviewer_report is an evaluate artifact, but it was placed
#  in the iteration dir for testing purposes -- rollback from execute only
#  clears execute artifacts, not evaluate ones)
# We don't check this file since it was placed for test setup, not the
# actual evaluation use case.

# Interrupted fields should be cleared
interrupted_cleared=$(jq -r '.interrupted_at // "CLEARED"' "$TF3")
assert_equals "CLEARED" "$interrupted_cleared" "interrupted_at should be cleared after rollback"

# History should have rolled_back entry
rollback_hist=$(jq -r '.history[-1].status' "$TF3")
assert_equals "rolled_back" "$rollback_hist" "Last history entry should be 'rolled_back'"

echo ""

# ============================================================
# Test 5: guard_check bypass for resumed tasks
# ============================================================
echo "=== Test 5: Guard Check Bypass for Resumed Tasks ==="

# TASK-002 was resumed in Test 3, so its last history entry is "resumed"
# guard_check should return PASS (0) for resumed tasks
guard_result=$(guard_check "$TEST_TASK2" "execute" "evaluate" 2>&1)
guard_rc=$?

assert_equals "0" "$guard_rc" "guard_check should PASS for resumed task"
assert_equals "PASS" "$guard_result" "guard_check should return 'PASS' for resumed task"

# Now test with rolled_back task (TASK-003)
guard_result3=$(guard_check "$TEST_TASK3" "plan" "execute" 2>&1)
guard_rc3=$?

assert_equals "0" "$guard_rc3" "guard_check should PASS for rolled_back task"
assert_equals "PASS" "$guard_result3" "guard_check should return 'PASS' for rolled_back task"

echo ""

# ============================================================
# Test 6: kanban_decide blocks on interrupted tasks
# ============================================================
echo "=== Test 6: kanban_decide Blocks Interrupted ==="

# Create a task that's in interrupted state
TEST_TASK4="TASK-004"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK4"
cat > "$KANBAN_DIR/tasks/$TEST_TASK4/task.json" <<'TJSON4'
{
  "id": "TASK-004",
  "title": "Blocked Decision Test",
  "status": "interrupted",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "interrupted_at": "2026-05-05T12:00:00Z",
  "last_known_phase": "execute",
  "last_known_status": "executing",
  "recovery_context": {},
  "history": [
    {"phase": "plan", "status": "completed"},
    {"phase": "execute", "status": "entered"},
    {"phase": "recovery", "status": "interrupted"}
  ]
}
TJSON4

# Try to decide on interrupted task -- should fail
decide_output=$(kanban_decide "$TEST_TASK4" --action "approve_and_archive" 2>&1)
decide_rc=$?

assert_equals "1" "$decide_rc" "kanban_decide should fail for interrupted task"
assert_contains "interrupted" "$decide_output" "Error should mention 'interrupted'"
assert_contains "resume" "$decide_output" "Error should suggest /kanban resume"
assert_contains "rollback" "$decide_output" "Error should suggest /kanban rollback"

echo ""

# ============================================================
# Test 7: recover_list_interrupted scanning
# ============================================================
echo "=== Test 7: recover_list_interrupted Scanning ==="

# Create multiple tasks in different states
# TASK-005: executing with no PID file (should be detected as interrupted)
TEST_TASK5="TASK-005"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK5"
cat > "$KANBAN_DIR/tasks/$TEST_TASK5/task.json" <<'TJSON5'
{
  "id": "TASK-005",
  "title": "Executing No PID",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "task_breakdown": {
    "subtasks": [
      {"id": "ST-001", "title": "Step 1", "status": "completed"},
      {"id": "ST-002", "title": "Step 2", "status": "in_progress"}
    ]
  },
  "history": []
}
TJSON5

# TASK-006: evaluating with PID file (should be detected as alive)
TEST_TASK6="TASK-006"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK6"
cat > "$KANBAN_DIR/tasks/$TEST_TASK6/task.json" <<'TJSON6'
{
  "id": "TASK-006",
  "title": "Evaluating With PID",
  "status": "evaluating",
  "phase": "evaluate",
  "phase_lock": "evaluate",
  "iteration": 1,
  "history": []
}
TJSON6

# Record PID for TASK-006 to make it appear alive
recover_record_pid "$TEST_TASK6"

# TASK-007: already interrupted (from previous detection)
TEST_TASK7="TASK-007"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK7"
cat > "$KANBAN_DIR/tasks/$TEST_TASK7/task.json" <<'TJSON7'
{
  "id": "TASK-007",
  "title": "Already Interrupted",
  "status": "interrupted",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "interrupted_at": "2026-05-04T00:00:00Z",
  "last_known_phase": "plan",
  "last_known_status": "planning",
  "recovery_context": {},
  "history": [
    {"phase": "recovery", "status": "interrupted"}
  ]
}
TJSON7

# Run scan
scan_output=$(recover_list_interrupted 2>&1)
scan_rc=$?

assert_equals "0" "$scan_rc" "recover_list_interrupted should succeed"

# TASK-005 should be detected and marked as interrupted
assert_contains "TASK-005" "$scan_output" "TASK-005 should appear in scan"
assert_contains "INTERRUPTED" "$scan_output" "TASK-005 should be marked INTERRUPTED"

# Verify TASK-005 was actually marked interrupted
tf5=$(task_file "$TEST_TASK5")
status5=$(jq -r '.status' "$tf5")
assert_equals "interrupted" "$status5" "TASK-005 status should be 'interrupted' after scan"

# TASK-006 should NOT be marked interrupted (process alive via PID)
tf6=$(task_file "$TEST_TASK6")
status6=$(jq -r '.status' "$tf6")
# Should still be 'evaluating' since PID is alive
assert_equals "evaluating" "$status6" "TASK-006 should still be 'evaluating' (process alive)"

# TASK-007 should appear as already interrupted
assert_contains "TASK-007" "$scan_output" "TASK-007 should appear in scan"
assert_contains "Recovery" "$scan_output" "Scan output should include recovery guidance"

# Clean up TASK-006 PID
recover_clear_pid "$TEST_TASK6"

echo ""

# ============================================================
# Test 8: recover_task delegates to recover_resume_task for interrupted
# ============================================================
echo "=== Test 8: recover_task for Interrupted ==="

# TASK-005 is now interrupted, recover_task should delegate to recover_resume_task
recover_output=$(recover_task "$TEST_TASK5" 2>&1)
recover_rc=$?

assert_equals "0" "$recover_rc" "recover_task should succeed for interrupted task"
assert_contains "Resume" "$recover_output" "recover_task should delegate to resume for interrupted task"

# Verify task is now executing again
tf5_recovered=$(task_file "$TEST_TASK5")
status5_recovered=$(jq -r '.status' "$tf5_recovered")
assert_equals "executing" "$status5_recovered" "TASK-005 should be 'executing' after recover_task"

echo ""

# ============================================================
# Test 9: rollback from evaluate phase
# ============================================================
echo "=== Test 9: Rollback from Evaluate ==="

TEST_TASK8="TASK-008"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK8"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK8/iteration-1"
# Create evaluate artifacts
echo '{"score":7}' > "$KANBAN_DIR/tasks/$TEST_TASK8/iteration-1/code_reviewer_report.json"
echo '{"score":8}' > "$KANBAN_DIR/tasks/$TEST_TASK8/iteration-1/qa_report.json"

cat > "$KANBAN_DIR/tasks/$TEST_TASK8/task.json" <<'TJSON8'
{
  "id": "TASK-008",
  "title": "Evaluate Rollback Test",
  "status": "interrupted",
  "phase": "evaluate",
  "phase_lock": "evaluate",
  "iteration": 1,
  "interrupted_at": "2026-05-05T14:00:00Z",
  "last_known_phase": "evaluate",
  "last_known_status": "evaluating",
  "recovery_context": {},
  "history": [
    {"phase": "plan", "status": "completed"},
    {"phase": "execute", "status": "completed"},
    {"phase": "evaluate", "status": "entered"},
    {"phase": "recovery", "status": "interrupted"}
  ]
}
TJSON8

TF8=$(task_file "$TEST_TASK8")

rollback8_output=$(recover_rollback_task "$TEST_TASK8" 2>&1)
rollback8_rc=$?

assert_equals "0" "$rollback8_rc" "Rollback from evaluate should succeed"
assert_contains "Rollback" "$rollback8_output" "Output should mention Rollback"

# Should rollback to execute (since execute was completed)
rollback8_status=$(jq -r '.status' "$TF8")
assert_equals "executing" "$rollback8_status" "Status should be 'executing' after rollback from evaluate"

rollback8_phase=$(jq -r '.phase_lock' "$TF8")
assert_equals "execute" "$rollback8_phase" "phase_lock should be 'execute' after rollback from evaluate"

# Evaluate report files should be cleared
assert_file_not_exists "$KANBAN_DIR/tasks/$TEST_TASK8/iteration-1/code_reviewer_report.json" \
  "code_reviewer_report.json should be cleared by evaluate rollback"
assert_file_not_exists "$KANBAN_DIR/tasks/$TEST_TASK8/iteration-1/qa_report.json" \
  "qa_report.json should be cleared by evaluate rollback"

echo ""

# ============================================================
# Test 10: Resume from plan phase
# ============================================================
echo "=== Test 10: Resume from Plan Phase ==="

TEST_TASK9="TASK-009"
mkdir -p "$KANBAN_DIR/tasks/$TEST_TASK9"
cat > "$KANBAN_DIR/tasks/$TEST_TASK9/task.json" <<'TJSON9'
{
  "id": "TASK-009",
  "title": "Plan Interrupted Task",
  "status": "interrupted",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "interrupted_at": "2026-05-05T10:00:00Z",
  "last_known_phase": "plan",
  "last_known_status": "planning",
  "recovery_context": {},
  "history": []
}
TJSON9

TF9=$(task_file "$TEST_TASK9")

resume9_output=$(recover_resume_task "$TEST_TASK9" 2>&1)
resume9_rc=$?

assert_equals "0" "$resume9_rc" "Resume from plan should succeed"

resume9_status=$(jq -r '.status' "$TF9")
assert_equals "planning" "$resume9_status" "Status should be 'planning' after resume from plan"

resume9_phase=$(jq -r '.phase_lock' "$TF9")
assert_equals "plan" "$resume9_phase" "phase_lock should be 'plan'"

echo ""

# ============================================================
# Results
# ============================================================
echo "========================================"
echo "  Recovery Tests: $PASS_COUNT passed, $FAIL_COUNT failed"
echo "========================================"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
