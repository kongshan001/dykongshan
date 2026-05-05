#!/usr/bin/env bash
# test_inbox_section_order_st006.sh -- Tests for ST-006: inbox.md section order fix
# Verifies that kanban_create_inbox, kanban_read_pending_feedback,
# and kanban_write_archived_feedback all work with the new order:
#   ## 已归档 (first) -> ## 待处理 (last, at end of file)
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

assert_file_exists() {
  local label="$1" filepath="$2"
  if [ -f "$filepath" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label (file not found: $filepath)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Setup: create isolated test environment
setup() {
  _TEST_TMPDIR=$(mktemp -d /tmp/kanban_test_st006.XXXXXX)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch,worktrees}

  # Create minimal config
  cat > "$_TEST_KANBAN_DIR/config.json" << 'EOF'
{
  "project": "test",
  "trunk": "main",
  "output_dir": "games"
}
EOF

  # Create minimal workflow
  cat > "$_TEST_KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    { "id": "plan", "name": "规划阶段" },
    { "id": "execute", "name": "执行阶段" },
    { "id": "evaluate", "name": "评估阶段", "pass_threshold": 9.0 }
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
  rm -rf "$_TEST_TMPDIR"
}

# ============================================================
echo "=========================================="
echo "ST-006: inbox.md section order fix"
echo "=========================================="
setup

# ============================================================
echo ""
echo "--- ST-006.1: kanban_create_inbox has correct section order ---"
kanban_create_task "Inbox order test" "Testing section order" > /dev/null 2>&1
task_id=$(ls "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

inbox_path="$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"
assert_file_exists "inbox.md created" "$inbox_path"

# Read the file content
inbox_content=$(cat "$inbox_path")

# Check that both sections exist
assert_contains "inbox has 已归档 section" "$inbox_content" "## 已归档"
assert_contains "inbox has 待处理 section" "$inbox_content" "## 待处理"

# Verify order: 已归档 must appear BEFORE 待处理
# Extract line numbers of each section header
archived_line=$(grep -n '^## 已归档' "$inbox_path" | head -1 | cut -d: -f1)
pending_line=$(grep -n '^## 待处理' "$inbox_path" | head -1 | cut -d: -f1)

if [ "$archived_line" -lt "$pending_line" ]; then
  echo "  PASS: section order correct (已归档 at line $archived_line, 待处理 at line $pending_line)"
  TESTS_PASSED=$((TESTS_PASSED + 1))
else
  echo "  FAIL: section order wrong (已归档 at line $archived_line, 待处理 at line $pending_line)"
  echo "    expected 已归档 before 待处理"
  TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

echo "  inbox.md content:"
cat -n "$inbox_path" | while IFS= read -r line; do echo "    $line"; done

# ============================================================
echo ""
echo "--- ST-006.2: kanban_read_pending_feedback reads from 待处理 section ---"
# Add pending items to the inbox (under ## 待处理, which is now at the end)
# We append items after ## 待处理
cat >> "$inbox_path" << 'PENDINGEOF'
- [ ] This is feedback item 1
- [ ] This is feedback item 2
PENDINGEOF

echo "  inbox.md with pending items:"
cat -n "$inbox_path" | while IFS= read -r line; do echo "    $line"; done

pending_output=$(kanban_read_pending_feedback "$task_id" 2>&1)
assert_contains "reads feedback item 1" "$pending_output" "This is feedback item 1"
assert_contains "reads feedback item 2" "$pending_output" "This is feedback item 2"
assert_not_contains "does not include checkbox prefix" "$pending_output" "- [ ]"

# ============================================================
echo ""
echo "--- ST-006.3: kanban_read_pending_feedback returns empty for no items ---"
# Create a new task with no pending items
kanban_create_task "Empty inbox test" "No pending items" > /dev/null 2>&1
empty_task_id=$(ls -t "$_TEST_KANBAN_DIR/tasks/" | grep 'TASK-' | head -1)

empty_output=$(kanban_read_pending_feedback "$empty_task_id" 2>&1)
if [ -z "$empty_output" ]; then
  echo "  PASS: returns empty for inbox with no pending items"
  TESTS_PASSED=$((TESTS_PASSED + 1))
else
  echo "  FAIL: expected empty output, got: $empty_output"
  TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# ============================================================
echo ""
echo "--- ST-006.4: kanban_write_archived_feedback moves item to 已归档 ---"
# Use the task with pending items from ST-006.2
kanban_write_archived_feedback "$task_id" "This is feedback item 1" "需求" "Added to requirements" > /dev/null 2>&1

# Read the inbox after archiving
inbox_after=$(cat "$inbox_path")
echo "  inbox.md after archiving item 1:"
cat -n "$inbox_path" | while IFS= read -r line; do echo "    $line"; done

# Check that the archived item is in 已归档 section
assert_contains "archived item appears in 已归档" "$inbox_after" "This is feedback item 1"
assert_contains "category appears in 已归档" "$inbox_after" "需求"
assert_contains "action appears in 已归档" "$inbox_after" "Added to requirements"

# Check that the remaining item is still in 待处理
assert_contains "remaining item stays in 待处理" "$inbox_after" "This is feedback item 2"

# Verify the archived entry is BEFORE 待处理 section
# The archived entry (feedback content + category) must appear between ## 已归档 and ## 待处理
archived_line2=$(grep -n '^## 已归档' "$inbox_path" | head -1 | cut -d: -f1)
pending_line2=$(grep -n '^## 待处理' "$inbox_path" | head -1 | cut -d: -f1)
feedback_line=$(grep -n 'This is feedback item 1' "$inbox_path" | grep -v '^\s*# ' | head -1 | cut -d: -f1)

if [ -n "$feedback_line" ] && [ "$feedback_line" -gt "$archived_line2" ] && [ "$feedback_line" -lt "$pending_line2" ]; then
  echo "  PASS: archived entry is between 已归档 and 待处理 (line $feedback_line)"
  TESTS_PASSED=$((TESTS_PASSED + 1))
else
  echo "  FAIL: archived entry not in correct position (archived=$archived_line2, feedback=$feedback_line, pending=$pending_line2)"
  TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# ============================================================
echo ""
echo "--- ST-006.5: kanban_read_pending_feedback excludes archived items ---"
# After archiving item 1, only item 2 should remain as pending
remaining_pending=$(kanban_read_pending_feedback "$task_id" 2>&1)
assert_contains "remaining item 2 is pending" "$remaining_pending" "This is feedback item 2"
assert_not_contains "archived item 1 not in pending" "$remaining_pending" "This is feedback item 1"

# ============================================================
echo ""
echo "--- ST-006.6: kanban_write_archived_feedback handles last item ---"
# Archive the remaining item
kanban_write_archived_feedback "$task_id" "This is feedback item 2" "问题" "Fixed" > /dev/null 2>&1

# No pending items should remain
final_pending=$(kanban_read_pending_feedback "$task_id" 2>&1)
if [ -z "$final_pending" ]; then
  echo "  PASS: no pending items after archiving all"
  TESTS_PASSED=$((TESTS_PASSED + 1))
else
  echo "  FAIL: expected no pending items, got: $final_pending"
  TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Both items should be in 已归档
final_inbox=$(cat "$inbox_path")
assert_contains "item 1 in 已归档" "$final_inbox" "This is feedback item 1"
assert_contains "item 2 in 已归档" "$final_inbox" "This is feedback item 2"

# ============================================================
echo ""
echo "--- ST-006.7: kanban_create_inbox is idempotent ---"
# Creating inbox again should not change existing file
inbox_before_idempotent=$(cat "$inbox_path")
kanban_create_inbox "$task_id" "Inbox order test" > /dev/null 2>&1
inbox_after_idempotent=$(cat "$inbox_path")
assert_eq "inbox unchanged on second create" "$inbox_before_idempotent" "$inbox_after_idempotent"

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
