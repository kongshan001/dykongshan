#!/usr/bin/env bash
# test_archive_inbox_guard.sh -- Tests for TASK-038: Inbox pending check before archive
# Covers ST-001 (guard_check_inbox) and ST-002 (integration in guard_check)
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
  if echo "$haystack" | grep -qF -- "$needle"; then
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

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -qF -- "$needle"; then
    echo "  FAIL: $label"
    echo "    string: $haystack"
    echo "    found (should not): $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Create a fresh, isolated temp KANBAN_DIR for each test
setup() {
  _TEST_TMPDIR=$(mktemp -d /tmp/kanban_test_inbox_guard.XXXXXX)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch,worktrees}

  # Create minimal config
  cat > "$_TEST_KANBAN_DIR/config.json" << 'EOF'
{
  "project": "test",
  "trunk": "main",
  "output_dir": "src"
}
EOF

  # Create minimal workflow with archive phase
  cat > "$_TEST_KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    { "id": "plan", "name": "Plan" },
    { "id": "execute", "name": "Execute" },
    { "id": "evaluate", "name": "Evaluate", "pass_threshold": 9.0 },
    { "id": "user_decision", "name": "User Decision" },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
EOF

  cat > "$_TEST_KANBAN_DIR/index.json" << 'EOF'
{ "project": "test", "trunk": "main", "tasks": [] }
EOF

  # Source all libs
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  source "$LIB_DIR/kanban.sh"
  kanban_init_env 2>/dev/null || true

  # Override KANBAN_DIR for isolated testing
  KANBAN_DIR="$_TEST_KANBAN_DIR"
}

teardown() {
  if [ -n "$_TEST_TMPDIR" ] && [ -d "$_TEST_TMPDIR" ]; then
    rm -rf "$_TEST_TMPDIR"
  fi
}

# ============================================================
echo "=========================================="
echo "TASK-038: Archive Inbox Guard Tests"
echo "=========================================="

# ============================================================
echo ""
echo "--- TC-001: guard_check_inbox with pending items -> FAIL ---"
setup

# Create a task with inbox that has pending items
kanban_create_task "Test pending inbox" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"

# Append pending items under ## 待处理
cat >> "$inbox_path" << 'PEND_EOF'
- [ ] Fix this bug
- [ ] Improve that feature
PEND_EOF

result=$(guard_check_inbox "$task_id" || true)
assert_contains "FAIL result for pending items" "$result" "FAIL:inbox_pending:"
assert_contains "count is 2" "$result" "FAIL:inbox_pending:2"

teardown

# ============================================================
echo ""
echo "--- TC-002: guard_check_inbox with no pending items -> PASS ---"
setup

kanban_create_task "Test clean inbox" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"

# inbox.md has no pending items by default (just the template)
result=$(guard_check_inbox "$task_id")
assert_eq "PASS for inbox with no pending items" "PASS" "$result"

teardown

# ============================================================
echo ""
echo "--- TC-003: guard_check_inbox with no inbox file -> PASS ---"
setup

# Create a task directory manually without inbox.md
mkdir -p "$_TEST_KANBAN_DIR/tasks/TASK-099"
jq -n '{id:"TASK-099",title:"test",status:"pending"}' > "$_TEST_KANBAN_DIR/tasks/TASK-099/task.json"

result=$(guard_check_inbox "TASK-099")
assert_eq "PASS when inbox does not exist" "PASS" "$result"

teardown

# ============================================================
echo ""
echo "--- TC-004: guard_check_inbox without '## 待处理' section -> PASS ---"
setup

kanban_create_task "Test no section" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"

# Overwrite inbox with content that has no "## 待处理" section
cat > "$inbox_path" << 'NOSECTION_EOF'
# TASK-XXX Inbox

Some random content without the expected section headers.

## 已归档

Some archived item.
NOSECTION_EOF

result=$(guard_check_inbox "$task_id")
assert_eq "PASS when no 待处理 section" "PASS" "$result"

teardown

# ============================================================
echo ""
echo "--- TC-005: guard_check_inbox with empty '## 待处理' section -> PASS ---"
setup

kanban_create_task "Test empty section" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"

# Overwrite inbox with empty 待处理 section (only whitespace/blank lines)
cat > "$inbox_path" << 'EMPTY_EOF'
# TASK-XXX Inbox

## 已归档

Some archived content.

## 待处理



EMPTY_EOF

result=$(guard_check_inbox "$task_id")
assert_eq "PASS when 待处理 section is empty" "PASS" "$result"

teardown

# ============================================================
echo ""
echo "--- TC-006: guard_check to=archive triggers inbox check ---"
setup

# Create a task, set up for archive transition
kanban_create_task "Test guard archive" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

# Add pending items to inbox
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"
cat >> "$inbox_path" << 'PEND2_EOF'
- [ ] Outstanding feedback
PEND2_EOF

# Set up task state to be in user_decision (valid transition to archive)
tf=$(task_file "$task_id")
local_tmp=$(mktemp)
jq '.phase_lock="user_decision" | .phase="user_decision"' "$tf" > "$local_tmp" && mv "$local_tmp" "$tf"

# Call guard_check with to=archive
result=$(guard_check "$task_id" "user_decision" "archive") || true
assert_contains "guard_check FAIL for archive with pending" "$result" "FAIL:inbox_pending:"

teardown

# ============================================================
echo ""
echo "--- TC-007: guard_check to!=archive skips inbox check ---"
setup

# Create a task with pending inbox items
kanban_create_task "Test non-archive" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

# Add pending items
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"
cat >> "$inbox_path" << 'PEND3_EOF'
- [ ] Should not block non-archive
PEND3_EOF

# Set up task state for plan->execute transition
tf=$(task_file "$task_id")
local_tmp=$(mktemp)
jq '.phase_lock="plan" | .phase="plan" | .worktree.path="/tmp/fake_worktree"' "$tf" > "$local_tmp" && mv "$local_tmp" "$tf"

# Create a fake worktree directory (guard_check checks worktree for execute)
mkdir -p /tmp/fake_worktree
git init /tmp/fake_worktree >/dev/null 2>&1

# Call guard_check with to=execute (not archive) -- should not check inbox
result=$(guard_check "$task_id" "plan" "execute") || true
# The inbox pending check should NOT trigger for non-archive transitions
assert_not_contains "inbox check skipped for execute" "$result" "inbox_pending"

# Clean up fake worktree
rm -rf /tmp/fake_worktree

teardown

# ============================================================
echo ""
echo "--- TC-008: kanban_archive_task blocked by inbox pending ---"
setup

kanban_create_task "Test archive blocked" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

# Add pending items
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"
cat >> "$inbox_path" << 'PEND4_EOF'
- [ ] Must process before archive
PEND4_EOF

# Approve the task for archive
kanban_decide "$task_id" --action approve_and_archive > /dev/null 2>&1

# Try to archive -- should be blocked by inbox check
output=$(kanban_archive_task "$task_id" 2>&1) || true
assert_contains "archive blocked by inbox" "$output" "GUARD BLOCKED"
assert_contains "mentions pending inbox" "$output" "inbox_pending"

teardown

# ============================================================
echo ""
echo "--- TC-009: kanban_archive_task allowed when inbox is clean ---"
setup

kanban_create_task "Test archive clean" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

# No pending items -- approve and archive should succeed
kanban_decide "$task_id" --action approve_and_archive > /dev/null 2>&1

output=$(kanban_archive_task "$task_id" 2>&1)
assert_contains "archive succeeded" "$output" "Archived $task_id"

teardown

# ============================================================
echo ""
echo "--- TC-010: kanban_archive_task abort skips inbox check ---"
setup

kanban_create_task "Test abort bypass" "desc" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

# Add pending items
inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"
cat >> "$inbox_path" << 'PEND5_EOF'
- [ ] Should not block abort
PEND5_EOF

# Abort the task -- should skip inbox check
output=$(kanban_decide "$task_id" --action abort 2>&1) || true
assert_contains "abort completed" "$output" "Archived $task_id"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total:  $TESTS_RUN"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"

if [ "$TESTS_FAILED" -gt 0 ]; then
  echo ""
  echo "SOME TESTS FAILED"
  exit 1
else
  echo ""
  echo "ALL TESTS PASSED"
  exit 0
fi
