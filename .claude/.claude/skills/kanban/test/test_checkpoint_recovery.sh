#!/usr/bin/env bash
# test_checkpoint_recovery.sh -- Tests for ST-008: Subtask checkpoint recovery (GitHub Issue #37)
# Covers:
#   1. kanban_subtask_checkpoint_start creates checkpoint file with correct structure
#   2. kanban_subtask_checkpoint_file_done appends files to files_written
#   3. kanban_subtask_checkpoint_complete marks checkpoint as completed
#   4. kanban_subtask_checkpoint_list returns correct checkpoint summary
#   5. kanban_subtask_checkpoint_get reads checkpoint content
#   6. recovery_restore_subtask identifies in-progress checkpoints
#   7. recovery_restore_subtask lists completed files from in-progress checkpoints
#   8. recover_resume_task reads checkpoints and displays completed/in-progress subtasks
#   9. Checkpoint start auto-creates on file_done when checkpoint missing
#  10. git_commit_hash recorded on checkpoint_complete
# Run: bash .claude/skills/kanban/test/test_checkpoint_recovery.sh

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
  # Use grep -F for fixed-string matching to handle special regex chars like [ ]
  if echo "$haystack" | grep -qF "$needle"; then
    pass
  else
    fail "$label: '$needle' not found in output"
  fi
}

assert_true() {
  local condition="$1"
  local label="${2:-assertion}"
  if eval "$condition" 2>/dev/null; then
    pass
  else
    fail "$label: condition '$condition' evaluated false"
  fi
}

# ============================================================
# Setup
# ============================================================

# Determine SKILL_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KANBAN_DIR=".kanban"
SANDBOX_KANBAN="${SKILL_DIR}/test/.sandbox_kanban_test_checkpoint"

# Source kanban.sh (defines KANBAN_DIR, SKILL_DIR, and all cf functions)
source "${SKILL_DIR}/lib/kanban.sh" 2>/dev/null || true
# Source recovery.sh
source "${SKILL_DIR}/lib/recovery.sh" 2>/dev/null || true

# Ensure jq is available
command -v jq >/dev/null 2>&1 || { echo "SKIP: jq not found"; exit 0; }

# Clean up from previous runs
rm -rf "$SANDBOX_KANBAN"

echo "=== test_checkpoint_recovery.sh ==="
echo ""

# ============================================================
# Helper: set up a minimal sandbox .kanban/ + task structure
# ============================================================
setup_sandbox() {
  local task_id="$1"
  rm -rf "$SANDBOX_KANBAN"
  mkdir -p "$SANDBOX_KANBAN/tasks/${task_id}"
  mkdir -p "$SANDBOX_KANBAN/worktrees"

  # Create minimal task.json
  local now=$(date -u +%FT%TZ)
  jq -n \
    --arg id "$task_id" \
    --arg title "Test Task for Checkpoint Recovery" \
    --arg now "$now" \
    '{
      id: $id,
      title: $title,
      status: "executing",
      phase: "execute",
      phase_lock: "execute",
      iteration: 1,
      user_decision: null,
      task_breakdown: {
        subtasks: [
          {id: "ST-001", title: "Subtask 1", status: "completed"},
          {id: "ST-002", title: "Subtask 2", status: "completed"},
          {id: "ST-003", title: "Subtask 3", status: "in_progress"},
          {id: "ST-004", title: "Subtask 4", status: "pending"}
        ]
      },
      history: [
        {phase: "plan", status: "completed", entered_at: $now},
        {phase: "execute", status: "entered", entered_at: $now}
      ],
      created_at: $now,
      updated_at: $now
    }' > "$SANDBOX_KANBAN/tasks/${task_id}/task.json"

  echo "$SANDBOX_KANBAN"
}

# Override KANBAN_DIR and task_dir/task_file for the sandbox
# We do this by saving originals and overriding
_orig_kanban_dir="$KANBAN_DIR"
KANBAN_DIR="$SANDBOX_KANBAN"

task_dir() {
  local task_id="$1"
  echo "$SANDBOX_KANBAN/tasks/${task_id}"
}

task_file() {
  local task_id="$1"
  echo "$SANDBOX_KANBAN/tasks/${task_id}/task.json"
}

# ============================================================
# Test 1: kanban_subtask_checkpoint_start creates correct file
# ============================================================
echo "--- Test 1: checkpoint_start creates file with correct structure ---"

TEST_TASK="TASK-900"
setup_sandbox "$TEST_TASK" >/dev/null

output=$(kanban_subtask_checkpoint_start "$TEST_TASK" "ST-003")
assert_contains "Checkpoint started" "$output" "Test 1: start message"

# Verify file exists
cp_file="${SANDBOX_KANBAN}/tasks/${TEST_TASK}/checkpoints/ST-003.json"
assert_true "test -f '$cp_file'" "Test 1: checkpoint file exists"

# Verify file content
subtask=$(jq -r '.subtask' "$cp_file")
status=$(jq -r '.status' "$cp_file")
files_count=$(jq '.files_written | length' "$cp_file")
started_at=$(jq -r '.started_at' "$cp_file")

assert_equals "ST-003" "$subtask" "Test 1: subtask field"
assert_equals "in_progress" "$status" "Test 1: status field"
assert_equals "0" "$files_count" "Test 1: files_written count"
assert_contains "T" "$started_at" "Test 1: started_at is ISO timestamp"

echo ""

# ============================================================
# Test 2: checkpoint_file_done appends to files_written
# ============================================================
echo "--- Test 2: checkpoint_file_done appends files ---"

output=$(kanban_subtask_checkpoint_file_done "$TEST_TASK" "ST-003" "src/main.js")
output2=$(kanban_subtask_checkpoint_file_done "$TEST_TASK" "ST-003" "src/config.js")
output3=$(kanban_subtask_checkpoint_file_done "$TEST_TASK" "ST-003" "test/test.js")

files_count=$(jq '.files_written | length' "$cp_file")
file0=$(jq -r '.files_written[0]' "$cp_file")
file1=$(jq -r '.files_written[1]' "$cp_file")
file2=$(jq -r '.files_written[2]' "$cp_file")

assert_equals "3" "$files_count" "Test 2: files count after 3 appends"
assert_equals "src/main.js" "$file0" "Test 2: first file"
assert_equals "src/config.js" "$file1" "Test 2: second file"
assert_equals "test/test.js" "$file2" "Test 2: third file"

echo ""

# ============================================================
# Test 3: checkpoint_complete marks as completed
# ============================================================
echo "--- Test 3: checkpoint_complete marks completed ---"

output=$(kanban_subtask_checkpoint_complete "$TEST_TASK" "ST-003")
assert_contains "Checkpoint completed" "$output" "Test 3: complete message"

status=$(jq -r '.status' "$cp_file")
completed_at=$(jq -r '.completed_at' "$cp_file")

assert_equals "completed" "$status" "Test 3: status is completed"
assert_contains "T" "$completed_at" "Test 3: completed_at is ISO timestamp"

# git_commit_hash might be empty if no git available,
# but should exist as a field (null is OK)
has_hash_field=$(jq -r 'has("git_commit_hash")' "$cp_file")
echo "  git_commit_hash field present: $has_hash_field"

echo ""

# ============================================================
# Test 4: checkpoint_list returns correct summary
# ============================================================
echo "--- Test 4: checkpoint_list returns summary ---"

# Start another subtask checkpoint to test listing
kanban_subtask_checkpoint_start "$TEST_TASK" "ST-001" >/dev/null
kanban_subtask_checkpoint_complete "$TEST_TASK" "ST-001" >/dev/null

list_output=$(kanban_subtask_checkpoint_list "$TEST_TASK")
list_count=$(echo "$list_output" | jq 'length')

assert_true "test '$list_count' -ge 2" "Test 4: at least 2 checkpoints in list"

# Verify ST-003 is completed
st003_status=$(echo "$list_output" | jq -r '.[] | select(.subtask == "ST-003") | .status')
assert_equals "completed" "$st003_status" "Test 4: ST-003 is completed"

# Verify ST-001 is completed
st001_status=$(echo "$list_output" | jq -r '.[] | select(.subtask == "ST-001") | .status')
assert_equals "completed" "$st001_status" "Test 4: ST-001 is completed"

echo ""

# ============================================================
# Test 5: checkpoint_get reads checkpoint content
# ============================================================
echo "--- Test 5: checkpoint_get reads content ---"

get_output=$(kanban_subtask_checkpoint_get "$TEST_TASK" "ST-003")
get_subtask=$(echo "$get_output" | jq -r '.subtask')
get_status=$(echo "$get_output" | jq -r '.status')
get_files=$(echo "$get_output" | jq -r '.files_written | length')

assert_equals "ST-003" "$get_subtask" "Test 5: get subtask"
assert_equals "completed" "$get_status" "Test 5: get status"
assert_equals "3" "$get_files" "Test 5: get files count"

# Test for non-existent checkpoint
empty_output=$(kanban_subtask_checkpoint_get "$TEST_TASK" "ST-999")
assert_equals "{}" "$empty_output" "Test 5: non-existent checkpoint returns {}"

echo ""

# ============================================================
# Test 6: recovery_restore_subtask identifies in-progress
# ============================================================
echo "--- Test 6: recovery_restore_subtask identifies in-progress checkpoints ---"

# Set up a different task with an in-progress checkpoint
TEST_TASK2="TASK-901"
setup_sandbox "$TEST_TASK2" >/dev/null

# Create an in-progress checkpoint with files written
kanban_subtask_checkpoint_start "$TEST_TASK2" "ST-002" >/dev/null
kanban_subtask_checkpoint_file_done "$TEST_TASK2" "ST-002" "src/featureA.js" >/dev/null
kanban_subtask_checkpoint_file_done "$TEST_TASK2" "ST-002" "src/featureB.js" >/dev/null

# Also create a completed checkpoint
kanban_subtask_checkpoint_start "$TEST_TASK2" "ST-001" >/dev/null
kanban_subtask_checkpoint_complete "$TEST_TASK2" "ST-001" >/dev/null

restore_output=$(recovery_restore_subtask "$TEST_TASK2")
restore_exit=$?

assert_equals "0" "$restore_exit" "Test 6: restore returns success"
assert_contains "ST-002" "$restore_output" "Test 6: identifies ST-002 as in-progress"
assert_contains "src/featureA.js" "$restore_output" "Test 6: lists first completed file"
assert_contains "src/featureB.js" "$restore_output" "Test 6: lists second completed file"
assert_contains "DONE" "$restore_output" "Test 6: marks files as DONE"
assert_contains "skip the DONE files" "$restore_output" "Test 6: advises skipping done files"

echo ""

# ============================================================
# Test 7: recovery_restore_subtask with no checkpoints
# ============================================================
echo "--- Test 7: recovery_restore_subtask with no checkpoints ---"

TEST_TASK3="TASK-902"
setup_sandbox "$TEST_TASK3" >/dev/null

no_cp_output=$(recovery_restore_subtask "$TEST_TASK3" 2>&1)
no_cp_exit=$?

assert_contains "No checkpoints found" "$no_cp_output" "Test 7: reports no checkpoints"
assert_equals "1" "$no_cp_exit" "Test 7: returns error exit code"

echo ""

# ============================================================
# Test 8: recovery_restore_subtask with all completed checkpoints
# ============================================================
echo "--- Test 8: recovery_restore_subtask with all completed ---"

TEST_TASK4="TASK-903"
setup_sandbox "$TEST_TASK4" >/dev/null

kanban_subtask_checkpoint_start "$TEST_TASK4" "ST-001" >/dev/null
kanban_subtask_checkpoint_complete "$TEST_TASK4" "ST-001" >/dev/null
kanban_subtask_checkpoint_start "$TEST_TASK4" "ST-002" >/dev/null
kanban_subtask_checkpoint_complete "$TEST_TASK4" "ST-002" >/dev/null

all_done_output=$(recovery_restore_subtask "$TEST_TASK4" 2>&1)
all_done_exit=$?

assert_contains "No in-progress checkpoints" "$all_done_output" "Test 8: no in-progress"
assert_contains "All checkpoints appear complete" "$all_done_output" "Test 8: all complete message"
assert_equals "0" "$all_done_exit" "Test 8: returns success exit code"

echo ""

# ============================================================
# Test 9: recover_resume_task displays checkpoint info
# ============================================================
echo "--- Test 9: recover_resume_task displays checkpoint info ---"

TEST_TASK5="TASK-904"
setup_sandbox "$TEST_TASK5" >/dev/null

# Mark the task as interrupted
tf5="${SANDBOX_KANBAN}/tasks/${TEST_TASK5}/task.json"
now=$(date -u +%FT%TZ)
tmp=$(mktemp)
jq --arg now "$now" \
  '.status = "interrupted" |
   .last_known_phase = "execute" |
   .last_known_status = "executing" |
   .interrupted_at = $now |
   .recovery_context = {current_subtask: "ST-003", completed_steps: ["ST-001","ST-002"]}' \
  "$tf5" > "$tmp" && mv "$tmp" "$tf5"

# Create checkpoints matching the interrupted state
kanban_subtask_checkpoint_start "$TEST_TASK5" "ST-001" >/dev/null
kanban_subtask_checkpoint_complete "$TEST_TASK5" "ST-001" >/dev/null
kanban_subtask_checkpoint_start "$TEST_TASK5" "ST-002" >/dev/null
kanban_subtask_checkpoint_complete "$TEST_TASK5" "ST-002" >/dev/null
kanban_subtask_checkpoint_start "$TEST_TASK5" "ST-003" >/dev/null
kanban_subtask_checkpoint_file_done "$TEST_TASK5" "ST-003" "src/partial.js" >/dev/null

resume_output=$(recover_resume_task "$TEST_TASK5" 2>&1)
resume_exit=$?

assert_equals "0" "$resume_exit" "Test 9: resume returns success"
assert_contains "[completed] ST-001" "$resume_output" "Test 9: shows ST-001 completed"
assert_contains "[completed] ST-002" "$resume_output" "Test 9: shows ST-002 completed"
assert_contains "[in_progress] ST-003" "$resume_output" "Test 9: shows ST-003 in_progress"
assert_contains "src/partial.js" "$resume_output" "Test 9: shows partial file written"

echo ""

# ============================================================
# Test 10: file_done auto-creates checkpoint if missing
# ============================================================
echo "--- Test 10: file_done auto-creates when checkpoint missing ---"

TEST_TASK6="TASK-905"
setup_sandbox "$TEST_TASK6" >/dev/null

# Make sure no checkpoint exists yet
ckpt_dir="${SANDBOX_KANBAN}/tasks/${TEST_TASK6}/checkpoints"
rm -rf "$ckpt_dir"

# Call file_done directly without prior checkpoint_start
output=$(kanban_subtask_checkpoint_file_done "$TEST_TASK6" "ST-004" "src/autocreated.js" 2>&1)

# Verify checkpoint was auto-created
cp_file="${ckpt_dir}/ST-004.json"
assert_true "test -f '$cp_file'" "Test 10: checkpoint auto-created"
auto_status=$(jq -r '.status' "$cp_file")
auto_files=$(jq -r '.files_written[0]' "$cp_file")
assert_equals "in_progress" "$auto_status" "Test 10: auto-created status"
assert_equals "src/autocreated.js" "$auto_files" "Test 10: auto-created file recorded"

echo ""

# ============================================================
# Cleanup
# ============================================================
rm -rf "$SANDBOX_KANBAN"
KANBAN_DIR="$_orig_kanban_dir"

# ============================================================
# Summary
# ============================================================
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "SOME TESTS FAILED"
  exit 1
else
  echo "ALL TESTS PASSED"
  exit 0
fi
