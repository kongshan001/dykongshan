#!/usr/bin/env bash
# test_task041_feedback_loop.sh — Tests for TASK-041 enhancements
# Covers: --migrate-to parameter, dual-path guard check, task-level document paths
# Run from the worktree root directory

set +e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$(dirname "$SCRIPT_DIR")/lib"
WORKTREE_DIR="$(cd "$(dirname "$SCRIPT_DIR")/../../.." && pwd)"
KANBAN_DIR="$WORKTREE_DIR/.kanban"

source "$LIB_DIR/kanban.sh" 2>/dev/null
kanban_init_env 2>/dev/null

pass=0
fail=0
total=0

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  total=$((total + 1))
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc"
    echo "    expected: '$expected'"
    echo "    actual:   '$actual'"
    fail=$((fail + 1))
  fi
}

assert_contains() {
  local desc="$1" file="$2" pattern="$3"
  total=$((total + 1))
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (pattern '$pattern' not found in $file)"
    fail=$((fail + 1))
  fi
}

assert_not_contains() {
  local desc="$1" file="$2" pattern="$3"
  total=$((total + 1))
  if ! grep -q "$pattern" "$file" 2>/dev/null; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (pattern '$pattern' unexpectedly found in $file)"
    fail=$((fail + 1))
  fi
}

assert_empty() {
  local desc="$1" actual="$2"
  total=$((total + 1))
  if [ -z "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected empty, got '$actual')"
    fail=$((fail + 1))
  fi
}

assert_not_empty() {
  local desc="$1" actual="$2"
  total=$((total + 1))
  if [ -n "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected non-empty)"
    fail=$((fail + 1))
  fi
}

echo "=== TASK-041 Feedback Loop Enhancement Tests ==="
echo ""

# Create a test task for inbox manipulation
TEST_TASK="TASK-T041"
TEST_TASK_DIR="$KANBAN_DIR/tasks/$TEST_TASK"
rm -rf "$TEST_TASK_DIR" 2>/dev/null
mkdir -p "$TEST_TASK_DIR/dispatch"
mkdir -p "$TEST_TASK_DIR/iteration-1"

# Create minimal task.json
cat > "$TEST_TASK_DIR/task.json" << 'TASKJSON'
{
  "id": "TASK-T041",
  "title": "Test Task",
  "status": "in_progress",
  "phase": "execute",
  "iteration": 1
}
TASKJSON

# Create inbox with pending feedback
cat > "$TEST_TASK_DIR/inbox.md" << 'INBOX'
# Inbox: Test Task

## 待处理
- [ ] Feedback item one
- [ ] Feedback item two
- [ ] Feedback item three

## 已归档
INBOX

echo "--- Test Group 1: --migrate-to parameter ---"

# Test 1.1: migrate-to archives with target annotation
kanban_write_archived_feedback "$TEST_TASK" "Feedback item one" "需求" "已迁移" --migrate-to "TASK-999"

assert_contains "1.1a: Archive has migration target TASK-999" \
  "$TEST_TASK_DIR/inbox.md" "已迁移至 TASK-999"

assert_not_contains "1.1b: Original removed from pending" \
  "$TEST_TASK_DIR/inbox.md" '- \[ \] Feedback item one'

assert_contains "1.1c: Original marked with [x]" \
  "$TEST_TASK_DIR/inbox.md" '\[x\] Feedback item one'

# Test 1.2: Without --migrate-to - normal archival removes item
kanban_write_archived_feedback "$TEST_TASK" "Feedback item two" "问题" "已修复"

assert_contains "1.2a: Normal archive has feedback info" \
  "$TEST_TASK_DIR/inbox.md" "Feedback item two"

assert_not_contains "1.2b: Original pending item removed" \
  "$TEST_TASK_DIR/inbox.md" '- \[ \] Feedback item two'

echo ""
echo "--- Test Group 2: Dual-path guard check ---"

# Test 2.1: guard_check_artifacts plan - files in task root
cat > "$TEST_TASK_DIR/requirements.md" << 'EOF'
# Requirements
test content
EOF
cat > "$TEST_TASK_DIR/task_breakdown.json" << 'EOF'
{"task_id": "TASK-T041", "subtasks": []}
EOF

result=$(guard_check_artifacts "$TEST_TASK" "plan")
assert_empty "2.1: Plan artifacts in task root - no missing" "$result"

# Test 2.2: guard_check_artifacts plan - files in iteration dir - backward compat
rm "$TEST_TASK_DIR/requirements.md" "$TEST_TASK_DIR/task_breakdown.json"
cat > "$TEST_TASK_DIR/iteration-1/requirements.md" << 'EOF'
# Requirements
test in iteration
EOF
cat > "$TEST_TASK_DIR/iteration-1/task_breakdown.json" << 'EOF'
{"task_id": "TASK-T041", "subtasks": []}
EOF

result=$(guard_check_artifacts "$TEST_TASK" "plan")
assert_empty "2.2: Plan artifacts in iteration dir - backward compat ok" "$result"

# Test 2.3: guard_check_artifacts plan - both missing
rm "$TEST_TASK_DIR/iteration-1/requirements.md" "$TEST_TASK_DIR/iteration-1/task_breakdown.json"

result=$(guard_check_artifacts "$TEST_TASK" "plan")
assert_not_empty "2.3: Both locations missing - guard reports missing" "$result"
assert_contains "2.3a: Reports requirements.md missing" \
  /dev/stdin "requirements.md" <<< "$result"
assert_contains "2.3b: Reports task_breakdown.json missing" \
  /dev/stdin "task_breakdown.json" <<< "$result"

# Test 2.4: retrospective in task root
cat > "$TEST_TASK_DIR/retrospective.md" << 'EOF'
# Retrospective
test content
EOF

result=$(guard_check_artifacts "$TEST_TASK" "retrospective")
assert_empty "2.4: Retrospective in task root - no missing" "$result"

# Test 2.5: retrospective in iteration dir - backward compat
rm "$TEST_TASK_DIR/retrospective.md"
cat > "$TEST_TASK_DIR/iteration-1/retrospective.md" << 'EOF'
# Retrospective
test in iteration
EOF

result=$(guard_check_artifacts "$TEST_TASK" "retrospective")
assert_empty "2.5: Retrospective in iteration dir - backward compat ok" "$result"

echo ""
echo "--- Test Group 3: kanban_prepare_dispatch dual-path ---"

# Put files back in task root
cat > "$TEST_TASK_DIR/requirements.md" << 'EOF'
# Requirements
test content
EOF
cat > "$TEST_TASK_DIR/task_breakdown.json" << 'EOF'
{"task_id": "TASK-T041", "subtasks": []}
EOF

kanban_prepare_dispatch "$TEST_TASK" 2>/dev/null
dispatch_file="$TEST_TASK_DIR/dispatch/${TEST_TASK}-execute.json"

if [ -f "$dispatch_file" ]; then
  req_path=$(jq -r '.requirements_file' "$dispatch_file")
  assert_contains "3.1: Dispatch requirements_file points to task root" \
    /dev/stdin "tasks/$TEST_TASK/requirements.md" <<< "$req_path"

  bd_path=$(jq -r '.breakdown_file' "$dispatch_file")
  assert_contains "3.2: Dispatch breakdown_file points to task root" \
    /dev/stdin "tasks/$TEST_TASK/task_breakdown.json" <<< "$bd_path"
else
  total=$((total + 2))
  echo "  SKIP: 3.1-3.2: Dispatch file not created"
fi

# Cleanup
rm -rf "$TEST_TASK_DIR"

echo ""
echo "=== Results: $pass passed, $fail failed, $total total ==="
[ "$fail" -eq 0 ] && echo "ALL TESTS PASSED" || echo "SOME TESTS FAILED"
exit $fail
