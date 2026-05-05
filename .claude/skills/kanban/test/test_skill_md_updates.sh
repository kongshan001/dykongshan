#!/usr/bin/env bash
# test_skill_md_updates.sh — Tests for SKILL.md updates (ST-004, ST-005, ST-006)
# Validates that retrospective phase, inbox discipline, and version trigger conditions are documented

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="$(dirname "$SCRIPT_DIR")/SKILL.md"

pass=0
fail=0
total=0

assert_contains() {
  local desc="$1" needle="$2"
  total=$((total + 1))
  if grep -q "$needle" "$SKILL_FILE"; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected to find '$needle' in SKILL.md)"
    fail=$((fail + 1))
  fi
}

echo "=== SKILL.md Update Tests ==="
echo ""

# ---- Test Group 1: Retrospective Phase (ST-004) ----
echo "--- Retrospective Phase ---"

assert_contains "retrospective phase heading" "Retrospective"
assert_contains "retrospective trigger condition" "retrospective 阶段"
assert_contains "knowledge-log requirement" "knowledge-log"
assert_contains "retrospective artifact check" "guard_check_artifacts.*retrospective"
assert_contains "execution_pitfalls reference" "execution_pitfalls"
assert_contains "execution_decisions reference" "execution_decisions"

# ---- Test Group 2: Inbox Discipline (ST-005) ----
echo "--- Inbox Discipline ---"

assert_contains "inbox discipline section" "Inbox 归档纪律"
assert_contains "agent no self-archive rule" "Agent 无权自行"
assert_contains "empty pending check rule" "待处理.*为空"

# ---- Test Group 3: Version Trigger Conditions (ST-006) ----
echo "--- Version Trigger Conditions ---"

assert_contains "version trigger section" "版本记录触发条件"
assert_contains "semantic versioning" "语义化版本"
assert_contains "framework file reference" ".claude/skills"
assert_contains "PATCH description" "PATCH"
assert_contains "MINOR description" "MINOR"
assert_contains "MAJOR description" "MAJOR"

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
