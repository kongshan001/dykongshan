#!/usr/bin/env bash
# test_inbox_guard_enhanced.sh — Tests for enhanced guard_check_inbox
# Validates that any non-empty, non-comment line in "## 待处理" section triggers the guard
# Run from the worktree root directory

set +e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$(dirname "$SCRIPT_DIR")/lib"
WORKTREE_DIR="$(cd "$(dirname "$SCRIPT_DIR")/../../.." && pwd)"
KANBAN_DIR="$WORKTREE_DIR/.kanban"

# Source the files under test (suppress init output)
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
    echo "  FAIL: $desc (expected='$expected', actual='$actual')"
    fail=$((fail + 1))
  fi
}

assert_rc() {
  local desc="$1" expected="$2"
  shift 2
  total=$((total + 1))
  if "$@" >/dev/null 2>&1; then
    actual=0
  else
    actual=1
  fi
  if [ "$expected" -eq "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected rc=$expected, got rc=$actual)"
    fail=$((fail + 1))
  fi
}

echo "=== Enhanced Inbox Guard Tests ==="
echo ""

# Create a temp task for testing
TEST_TASK="TEST-INBOX-ENHANCED"
TEST_TASK_DIR="$KANBAN_DIR/tasks/${TEST_TASK}"
TEST_INBOX="$TEST_TASK_DIR/inbox.md"

setup() {
  rm -rf "$TEST_TASK_DIR"
  mkdir -p "$TEST_TASK_DIR"
  cat > "$TEST_TASK_DIR/task.json" <<'TASKJSON'
{"task_id":"TEST-INBOX-ENHANCED","iteration":1,"phase":"archive","phase_lock":"archive","status":"archived"}
TASKJSON
}

cleanup() {
  rm -rf "$TEST_TASK_DIR"
}

# ---- Test Group 1: Original "- [ ]" format still detected ----
echo "--- Test: Original checkbox format ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

- [ ] 需要修复按钮颜色
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "detects - [ ] format" "FAIL:inbox_pending:1" "$result"
cleanup

# ---- Test Group 2: Numbered list "1." format detected ----
echo "--- Test: Numbered list format ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

1. 需要修复按钮颜色
2. 增加排序功能
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "detects numbered list format" "FAIL:inbox_pending:2" "$result"
cleanup

# ---- Test Group 3: Chinese numbered "1、" format detected ----
echo "--- Test: Chinese numbered format ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

1、需要修复按钮颜色
2、增加排序功能
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "detects Chinese numbered format" "FAIL:inbox_pending:2" "$result"
cleanup

# ---- Test Group 4: Bullet "* " format detected ----
echo "--- Test: Bullet list format ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

* 需要修复按钮颜色
* 增加排序功能
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "detects bullet list format" "FAIL:inbox_pending:2" "$result"
cleanup

# ---- Test Group 5: Mixed formats detected ----
echo "--- Test: Mixed formats ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

- [ ] 需要修复按钮颜色
1. 增加排序功能
* 优化响应速度
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "detects mixed formats" "FAIL:inbox_pending:3" "$result"
cleanup

# ---- Test Group 6: Only comments (lines starting with >) pass ----
echo "--- Test: Only comments ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

> 这是一条注释
> 另一条注释
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "only comments passes" "PASS" "$result"
cleanup

# ---- Test Group 7: Only empty lines pass ----
echo "--- Test: Only empty lines ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理



EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "only empty lines passes" "PASS" "$result"
cleanup

# ---- Test Group 8: No inbox file passes ----
echo "--- Test: No inbox file ---"
setup
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "no inbox file passes" "PASS" "$result"
cleanup

# ---- Test Group 9: Empty pending section passes ----
echo "--- Test: Empty pending section ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

## 其他
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "empty pending section passes" "PASS" "$result"
cleanup

# ---- Test Group 10: Archived section items not counted ----
echo "--- Test: Items in archived section not counted ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

- [ ] 这个已处理了
1. 这个也处理了

## 待处理

EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "archived items not counted" "PASS" "$result"
cleanup

# ---- Test Group 11: Plain text without prefix detected ----
echo "--- Test: Plain text detected ---"
setup
cat > "$TEST_INBOX" <<'EOF'
# TEST-INBOX-ENHANCED Inbox

## 已归档

## 待处理

需要修复按钮颜色
EOF
result=$(guard_check_inbox "$TEST_TASK")
assert_eq "detects plain text" "FAIL:inbox_pending:1" "$result"
cleanup

echo ""
echo "=== Results ==="
echo "Total: $total, Passed: $pass, Failed: $fail"
if [ "$fail" -eq 0 ]; then
  echo "ALL TESTS PASSED"
  exit 0
else
  echo "SOME TESTS FAILED"
  exit 1
fi
