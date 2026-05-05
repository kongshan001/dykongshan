#!/usr/bin/env bash
# test_version_naming.sh — 回归测试版本记录命名规范 (R-007)
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TESTS_RUN=0 TESTS_PASSED=0 TESTS_FAILED=0

assert_eq() {
  TESTS_RUN=$((TESTS_RUN + 1))
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label (expected='$expected', actual='$actual')"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

setup() {
  TMPDIR=$(mktemp -d)
  export KANBAN_DIR="$TMPDIR/.kanban"
  mkdir -p "$KANBAN_DIR/versions"
  [ -f "$SKILL_DIR/templates/workflow.json" ] && cp "$SKILL_DIR/templates/workflow.json" "$KANBAN_DIR/workflow.json"
  [ ! -f "$KANBAN_DIR/workflow.json" ] && echo '{"phases":[]}' > "$KANBAN_DIR/workflow.json"
  echo '{"project":"test","trunk":"main"}' > "$KANBAN_DIR/config.json"
  source "$SKILL_DIR/lib/kanban.sh" 2>/dev/null
  # Override KANBAN_DIR after init_env (which sets it to .kanban)
  KANBAN_DIR="$TMPDIR/.kanban"
  export KANBAN_DIR
}

teardown() {
  rm -rf "$TMPDIR"
}

echo "=== Version Naming Convention Tests (R-007) ==="
echo ""

# Test 1: kanban_version_record auto-adds v prefix
echo "--- Test 1: Auto v-prefix for version record ---"
(
  setup
  kanban_version_init 2>/dev/null
  kanban_version_record "0.7.0" --title "Test version" 2>/dev/null
  [ -f "$KANBAN_DIR/versions/v0.7.0.md" ] && echo "  PASS: v0.7.0.md created" || echo "  FAIL: v0.7.0.md not found"
  teardown
)

# Test 2: kanban_version_record with v prefix unchanged
echo "--- Test 2: v prefix preserved ---"
(
  setup
  kanban_version_init 2>/dev/null
  kanban_version_record "v0.8.0" --title "Test" 2>/dev/null
  [ -f "$KANBAN_DIR/versions/v0.8.0.md" ] && echo "  PASS: v0.8.0.md created" || echo "  FAIL: v0.8.0.md not found"
  teardown
)

# Test 3: kanban_check_version_naming detects bad names
echo "--- Test 3: Naming check detects violations ---"
(
  setup
  touch "$KANBAN_DIR/versions/0.5.0.md"
  touch "$KANBAN_DIR/versions/v0.1.0.md"
  result=$(kanban_check_version_naming 2>&1)
  rc=$?
  assert_eq "check returns 1 for bad names" "1" "$rc"
  echo "$result" | grep -q '0.5.0.md' && echo "  PASS: mentions 0.5.0.md" || echo "  FAIL: should mention 0.5.0.md"
  teardown
)

# Test 4: kanban_check_version_naming passes for valid names
echo "--- Test 4: Naming check passes for valid names ---"
(
  setup
  touch "$KANBAN_DIR/versions/v0.1.0.md"
  touch "$KANBAN_DIR/versions/v1.2.3.md"
  result=$(kanban_check_version_naming 2>&1)
  assert_eq "check returns 0 for valid names" "0" "$?"
  teardown
)

# Test 5: CHANGELOG reference format
echo "--- Test 5: CHANGELOG entry uses v prefix ---"
(
  setup
  kanban_version_init 2>/dev/null
  kanban_version_record "v0.9.0" --title "Test" 2>/dev/null
  grep -q 'v0.9.0' "$KANBAN_DIR/versions/CHANGELOG.md" 2>/dev/null && echo "  PASS: CHANGELOG has v0.9.0" || echo "  FAIL: CHANGELOG missing v0.9.0"
  teardown
)

echo ""
echo "=== Results ==="
echo "Tests completed. Check output above for pass/fail."
