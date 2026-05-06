#!/usr/bin/env bash
# test_octal_parse.sh — Regression test for GitHub Issue #31
# Bug: TASK-NNN numbers like 008, 009 are interpreted as octal by bash,
# causing "value too great for base" errors in arithmetic expressions.
# Fix: Use $(( 10#$num )) to force decimal interpretation.
# Run: bash .claude/skills/kanban/test/test_octal_parse.sh

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
  echo "  FAIL: $msg"
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

assert_numeric_ok() {
  local expression="$1"
  local label="${2:-arithmetic}"
  local result
  result=$(eval "echo \$(( $expression ))" 2>/dev/null)
  if [ -n "$result" ]; then
    pass
  else
    fail "$label: arithmetic '$expression' failed (possibly octal parse error)"
  fi
}

# ============================================================
# Core tests: direct bash arithmetic with TASK-number strings
# These simulate what happens when _next_task_id extracts
# numbers like "008", "009", "099" from TASK-NNN directory names.
# ============================================================
echo "============================================"
echo "  Test Suite: Issue #31 - Octal Parse Fix"
echo "============================================"
echo ""

# --- Test 1: TASK-008 number in arithmetic ---
echo "--- Test 1: TASK-008 number (008) in arithmetic ---"

NUM=008
# Without 10# prefix, this would fail: $(( NUM + 1 )) -> "value too great for base"
RESULT=$(( 10#$NUM + 1 ))
assert_equals "9" "$RESULT" "Test1a: 10#008 + 1 = 9"

RESULT=$(( 10#$NUM > 5 ))
assert_equals "1" "$RESULT" "Test1b: 10#008 > 5 = true"

RESULT=$(( 10#$NUM ))
assert_equals "8" "$RESULT" "Test1c: 10#008 evaluates to 8"

echo ""

# --- Test 2: TASK-009 number in arithmetic ---
echo "--- Test 2: TASK-009 number (009) in arithmetic ---"

NUM=009
RESULT=$(( 10#$NUM + 1 ))
assert_equals "10" "$RESULT" "Test2a: 10#009 + 1 = 10"

RESULT=$(( 10#$NUM > 5 ))
assert_equals "1" "$RESULT" "Test2b: 10#009 > 5 = true"

RESULT=$(( 10#$NUM ))
assert_equals "9" "$RESULT" "Test2c: 10#009 evaluates to 9"

echo ""

# --- Test 3: TASK-099 number in arithmetic ---
echo "--- Test 3: TASK-099 number (099) in arithmetic ---"

NUM=099
RESULT=$(( 10#$NUM + 1 ))
assert_equals "100" "$RESULT" "Test3a: 10#099 + 1 = 100"

RESULT=$(( 10#$NUM > 50 ))
assert_equals "1" "$RESULT" "Test3b: 10#099 > 50 = true"

RESULT=$(( 10#$NUM ))
assert_equals "99" "$RESULT" "Test3c: 10#099 evaluates to 99"

echo ""

# --- Test 4: printf "%03d" format with leading-zero numbers ---
echo "--- Test 4: printf '%03d' format correctness ---"

# The existing code uses: printf "TASK-%03d" $((max + 1))
# After 10#$num conversion, max is a decimal integer (not octal).
# This test verifies that printf "%03d" produces correct output.

FMT_RESULT=$(printf "TASK-%03d" 1)
assert_equals "TASK-001" "$FMT_RESULT" "Test4a: printf TASK-%%03d 1 = TASK-001"

FMT_RESULT=$(printf "TASK-%03d" 8)
assert_equals "TASK-008" "$FMT_RESULT" "Test4b: printf TASK-%%03d 8 = TASK-008"

FMT_RESULT=$(printf "TASK-%03d" 9)
assert_equals "TASK-009" "$FMT_RESULT" "Test4c: printf TASK-%%03d 9 = TASK-009"

FMT_RESULT=$(printf "TASK-%03d" 10)
assert_equals "TASK-010" "$FMT_RESULT" "Test4d: printf TASK-%%03d 10 = TASK-010"

FMT_RESULT=$(printf "TASK-%03d" 99)
assert_equals "TASK-099" "$FMT_RESULT" "Test4e: printf TASK-%%03d 99 = TASK-099"

FMT_RESULT=$(printf "TASK-%03d" 100)
assert_equals "TASK-100" "$FMT_RESULT" "Test4f: printf TASK-%%03d 100 = TASK-100"

echo ""

# --- Test 5: Simulate the full _next_task_id loop ---
echo "--- Test 5: Simulated _next_task_id loop logic ---"

# Create a mock scenario: TASK-001, TASK-008, TASK-009 directories exist
# Simulate the exact loop logic from _next_task_id():
#   local num=$(basename "$d" | sed 's/TASK-//')
#   [ $(( 10#$num )) -gt "$max" ] 2>/dev/null && max=$(( 10#$num ))
#   printf "TASK-%03d" $((max + 1))

MOCK_TASKS="001 002 003 004 005 006 007 008"
MAX=0
for N in $MOCK_TASKS; do
  NUM="$N"
  [ $(( 10#$NUM )) -gt "$MAX" ] 2>/dev/null && MAX=$(( 10#$NUM ))
done
NEXT_ID=$(printf "TASK-%03d" $((MAX + 1)))
assert_equals "TASK-009" "$NEXT_ID" "Test5a: With tasks 001-008, next is TASK-009"

# Extended: TASK-001 through TASK-009
MOCK_TASKS="001 002 003 004 005 006 007 008 009"
MAX=0
for N in $MOCK_TASKS; do
  NUM="$N"
  [ $(( 10#$NUM )) -gt "$MAX" ] 2>/dev/null && MAX=$(( 10#$NUM ))
done
NEXT_ID=$(printf "TASK-%03d" $((MAX + 1)))
assert_equals "TASK-010" "$NEXT_ID" "Test5b: With tasks 001-009, next is TASK-010"

# Extended: TASK-001 through TASK-099
MOCK_TASKS=$(seq -w 1 99)
MAX=0
for N in $MOCK_TASKS; do
  NUM="$N"
  [ $(( 10#$NUM )) -gt "$MAX" ] 2>/dev/null && MAX=$(( 10#$NUM ))
done
NEXT_ID=$(printf "TASK-%03d" $((MAX + 1)))
assert_equals "TASK-100" "$NEXT_ID" "Test5c: With 99 tasks, next is TASK-100"

echo ""

# --- Test 6: Verify without 10# prefix would fail (negative test) ---
echo "--- Test 6: Confirm octal parse error without 10# (negative test) ---"

# Demonstrate that raw arithmetic with 008 indeed fails in bash.
# This is the bug: bash interprets "008" as octal, and 8 is not a valid octal digit.
FAIL_008=0
eval 'echo $(( 008 ))' 2>/dev/null || FAIL_008=1
if [ "$FAIL_008" -eq 1 ]; then
  pass
else
  fail "Test6a: $(( 008 )) should fail (octal parse error)"
fi

# 009 should also fail
FAIL_009=0
eval 'echo $(( 009 ))' 2>/dev/null || FAIL_009=1
if [ "$FAIL_009" -eq 1 ]; then
  pass
else
  fail "Test6b: $(( 009 )) should fail (octal parse error)"
fi

# But with 10# prefix, it works
RESULT=$(( 10#008 ))
assert_equals "8" "$RESULT" "Test6c: 10#008 = 8 (the fix)"

RESULT=$(( 10#009 ))
assert_equals "9" "$RESULT" "Test6d: 10#009 = 9 (the fix)"

echo ""

# --- Test 7: Edge case — 077 is valid octal but should be decimal 77 ---
echo "--- Test 7: Edge case — 077 with 10# is 77, not 63 ---"

# 077 in octal = 63 in decimal
# With 10# prefix, it must be interpreted as decimal 77
NUM=077
RESULT=$(( 10#$NUM ))
assert_equals "77" "$RESULT" "Test7a: 10#077 = 77 (decimal, not octal 63)"

# Without 10# prefix: 077 is valid octal = 63 decimal
RESULT_OCTAL=$(( 077 ))
assert_equals "63" "$RESULT_OCTAL" "Test7b: raw 077 = 63 (octal, confirming the risk)"

echo ""

# --- Test 8: Source code verification ---
echo "--- Test 8: Verify source code contains the fix ---"

SRC_FILE=".claude/skills/kanban/lib/kanban.sh"
if [ -f "$SRC_FILE" ]; then
  # Count the number of 10#$num occurrences in _next_task_id function
  FUNC_LINE=$(grep -n '^_next_task_id()' "$SRC_FILE" | head -1 | cut -d: -f1)
  if [ -n "$FUNC_LINE" ]; then
    FUNC_BLOCK=$(sed -n "${FUNC_LINE},$((FUNC_LINE + 30))p" "$SRC_FILE")
    OCCURRENCES=$(echo "$FUNC_BLOCK" | grep -c '10#\$num' || true)
    OCCURRENCES=${OCCURRENCES:-0}
    if [ "$OCCURRENCES" -ge 4 ]; then
      pass
    else
      fail "Test8a: Expected >=4 occurrences of 10#\$num in _next_task_id, found $OCCURRENCES"
    fi
  else
    fail "Test8a: Could not locate _next_task_id in $SRC_FILE"
  fi

  # Also verify kanban_knowledge_add has the fix
  if grep -q '10#\$last_num' "$SRC_FILE"; then
    pass
  else
    fail "Test8b: kanban_knowledge_add should use 10#\$last_num"
  fi

  # Verify the function has the octal fix comment
  if grep -A 3 '^_next_task_id()' "$SRC_FILE" | grep -q '10#\$num' || \
     grep -B 5 '^_next_task_id()' "$SRC_FILE" | grep -q 'Issue #31'; then
    pass
  else
    fail "Test8c: _next_task_id should have octal fix documentation"
  fi
else
  fail "Test8: Source file $SRC_FILE not found"
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
