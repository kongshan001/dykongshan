#!/usr/bin/env bash
# test_next_task_id_octal.sh -- Regression test for Issue #30
# Bug: _next_task_id fails with "value too great for base" when TASK-008+ exists
# because bash interprets numbers with leading zeros as octal.
# Fix: Use $(( 10#$num )) to force decimal interpretation.
# Run: bash .claude/skills/kanban/test/test_next_task_id_octal.sh

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

# ============================================================
# Setup: create temp kanban environment
# ============================================================
REAL_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG_DIR="$(pwd)"
TEST_TMPDIR=$(mktemp -d /tmp/test_octal_bug_XXXXXX)

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
mkdir -p .claude/skills/kanban/templates/reports
mkdir -p .kanban

cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/

if [ -d "$REAL_SKILL_DIR/templates/reports" ]; then
  cp "$REAL_SKILL_DIR"/templates/reports/*.json .claude/skills/kanban/templates/reports/ 2>/dev/null || true
fi

KANBAN_DIR=".kanban"
export KANBAN_DIR

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

git add -A
git commit -q -m "init"

# Source without set -e to avoid premature exit from library internals
source .claude/skills/kanban/lib/kanban.sh 2>/dev/null || true
kanban_init_env >/dev/null 2>&1 || true

echo "============================================"
echo "  Test Suite: Issue #30 - Octal Parse Bug"
echo "============================================"
echo ""

# ============================================================
# Test 1: _next_task_id with TASK-001 through TASK-008
# This is the exact scenario from the bug report.
# Without the fix, bash treats "008" as octal, and since
# 8 is not a valid octal digit, it fails with
# "value too great for base".
# ============================================================
echo "--- Test 1: TASK-001 through TASK-008 exists (triggers octal bug) ---"

for i in 001 002 003 004 005 006 007 008; do
  mkdir -p ".kanban/tasks/TASK-${i}"
  cat > ".kanban/tasks/TASK-${i}/task.json" <<TASK
{"id":"TASK-${i}","status":"archived","phase":"archive","iteration":0}
TASK
done

# This call should NOT produce "value too great for base" error
NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test1: _next_task_id exits without error (rc=$RC)"
assert_equals "TASK-009" "$NEXT_ID" "Test1: next ID is TASK-009"

# Clean up
for i in 001 002 003 004 005 006 007 008; do
  rm -rf ".kanban/tasks/TASK-${i}"
done

echo ""

# ============================================================
# Test 2: _next_task_id with TASK-009 (octal 9 is also invalid)
# ============================================================
echo "--- Test 2: TASK-009 exists (octal 9 invalid) ---"

mkdir -p ".kanban/tasks/TASK-009"
cat > ".kanban/tasks/TASK-009/task.json" <<'TASK'
{"id":"TASK-009","status":"archived","phase":"archive","iteration":0}
TASK

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test2: _next_task_id exits without error with TASK-009"
assert_equals "TASK-010" "$NEXT_ID" "Test2: next ID is TASK-010"

rm -rf ".kanban/tasks/TASK-009"

echo ""

# ============================================================
# Test 3: Tasks in archive directory (new format)
# ============================================================
echo "--- Test 3: Archive directory with TASK-008 (new format) ---"

mkdir -p ".kanban/archive/TASK-008"
cat > ".kanban/archive/TASK-008/task.json" <<'TASK'
{"id":"TASK-008","status":"archived","phase":"archive","iteration":1}
TASK

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test3: _next_task_id works with TASK-008 in archive (new format)"
assert_equals "TASK-009" "$NEXT_ID" "Test3: next ID is TASK-009"

rm -rf ".kanban/archive/TASK-008"

echo ""

# ============================================================
# Test 4: Tasks in old format (TASK-NNN.json files)
# ============================================================
echo "--- Test 4: Old format TASK-008.json files ---"

cat > ".kanban/tasks/TASK-008.json" <<'TASK'
{"id":"TASK-008","status":"archived","phase":"archive","iteration":0}
TASK

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test4: _next_task_id works with old format TASK-008.json"
assert_equals "TASK-009" "$NEXT_ID" "Test4: next ID is TASK-009"

rm -f ".kanban/tasks/TASK-008.json"

echo ""

# ============================================================
# Test 5: Old format archive files
# ============================================================
echo "--- Test 5: Old format archive TASK-008.json ---"

cat > ".kanban/archive/TASK-008.json" <<'TASK'
{"id":"TASK-008","status":"archived","phase":"archive","iteration":0}
TASK

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test5: _next_task_id works with old format archive TASK-008.json"
assert_equals "TASK-009" "$NEXT_ID" "Test5: next ID is TASK-009"

rm -f ".kanban/archive/TASK-008.json"

echo ""

# ============================================================
# Test 6: Mixed sources with TASK-010 in tasks and TASK-007 in archive
# Should pick TASK-010 as max and return TASK-011
# ============================================================
echo "--- Test 6: Mixed sources, max across tasks and archive ---"

mkdir -p ".kanban/tasks/TASK-010"
cat > ".kanban/tasks/TASK-010/task.json" <<'TASK'
{"id":"TASK-010","status":"pending","phase":null,"iteration":0}
TASK

mkdir -p ".kanban/archive/TASK-007"
cat > ".kanban/archive/TASK-007/task.json" <<'TASK'
{"id":"TASK-007","status":"archived","phase":"archive","iteration":0}
TASK

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test6: _next_task_id works with mixed sources"
assert_equals "TASK-011" "$NEXT_ID" "Test6: next ID is TASK-011 (max was 010)"

rm -rf ".kanban/tasks/TASK-010" ".kanban/archive/TASK-007"

echo ""

# ============================================================
# Test 7: Higher numbers that also have leading zeros (e.g. TASK-099)
# ============================================================
echo "--- Test 7: TASK-099 exists (leading zero in 2-digit number) ---"

mkdir -p ".kanban/tasks/TASK-099"
cat > ".kanban/tasks/TASK-099/task.json" <<'TASK'
{"id":"TASK-099","status":"pending","phase":null,"iteration":0}
TASK

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test7: _next_task_id works with TASK-099"
assert_equals "TASK-100" "$NEXT_ID" "Test7: next ID is TASK-100"

rm -rf ".kanban/tasks/TASK-099"

echo ""

# ============================================================
# Test 8: Empty kanban (no tasks) should return TASK-001
# ============================================================
echo "--- Test 8: Empty kanban returns TASK-001 ---"

NEXT_ID=$(_next_task_id 2>/dev/null)
RC=$?
assert_equals "0" "$RC" "Test8: _next_task_id works with no tasks"
assert_equals "TASK-001" "$NEXT_ID" "Test8: next ID is TASK-001 for empty kanban"

echo ""

# ============================================================
# Test 9: Verify the fix is present in the source code
# ============================================================
echo "--- Test 9: Source code contains the fix ---"

# The fix uses $(( 10#$num )) in both the comparison and the assignment.
# In the source file, this appears as "10#$num" (the $ is literal in the grep pattern).
grep -q '10#\$num' .claude/skills/kanban/lib/kanban.sh
assert_equals "0" "$?" "Test9: Source contains 10#\$num decimal force pattern"

# Verify the pattern appears in the _next_task_id function (at least 4 times,
# once per loop iteration: tasks dir, archive dir, tasks json, archive json)
# Extract the function block by matching from _next_task_id to the closing }
FUNC_LINE=$(grep -n '^_next_task_id()' .claude/skills/kanban/lib/kanban.sh | head -1 | cut -d: -f1)
if [ -n "$FUNC_LINE" ]; then
  # Read from the function start to the next blank line followed by a non-indented line
  FUNC_BLOCK=$(sed -n "${FUNC_LINE},$((FUNC_LINE + 30))p" .claude/skills/kanban/lib/kanban.sh)
  OCCURRENCES=$(echo "$FUNC_BLOCK" | grep -c '10#\$num' || true)
  # Should have at least 4 occurrences (one per loop, in the comparison expression)
  if [ "$OCCURRENCES" -ge 4 ]; then
    pass
  else
    fail "Test9: Expected at least 4 occurrences of 10#\$num in _next_task_id, found $OCCURRENCES"
  fi
else
  fail "Test9: Could not locate _next_task_id function"
fi

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
