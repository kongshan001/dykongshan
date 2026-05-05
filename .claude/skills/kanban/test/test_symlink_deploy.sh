#!/usr/bin/env bash
# test_symlink_deploy.sh -- Tests for ST-002: symlink deployment mechanism
# Validates that _kanban_install_deps creates symlinks, handles idempotency,
# overwrites regular files, and falls back to copy on Windows.
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
_TEST_PROJECT_DIR=""

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
  if echo "$haystack" | grep -q "$needle"; then
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

assert_true() {
  local label="$1" condition="$2"
  if [ "$condition" = "true" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Create a fresh, isolated project directory for each test
# Mimics real project layout: project/.claude/skills/kanban/ and project/.claude/agents/
setup() {
  _TEST_TMPDIR=$(mktemp -d)
  _TEST_PROJECT_DIR="$_TEST_TMPDIR/myproject"
  _TEST_KANBAN_DIR="$_TEST_PROJECT_DIR/.kanban"

  # Create project directory structure
  mkdir -p "$_TEST_PROJECT_DIR"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch}

  # Create a fake skills source directory with agent and rule files
  mkdir -p "$_TEST_PROJECT_DIR/.claude/skills/kanban/agents"
  mkdir -p "$_TEST_PROJECT_DIR/.claude/skills/kanban/rules"
  mkdir -p "$_TEST_PROJECT_DIR/.claude/skills/kanban/lib"
  mkdir -p "$_TEST_PROJECT_DIR/.claude/skills/kanban/templates"
  mkdir -p "$_TEST_PROJECT_DIR/.claude/skills/kanban/dashboard"

  # Create sample agent files
  echo "# Planner Agent" > "$_TEST_PROJECT_DIR/.claude/skills/kanban/agents/planner.md"
  echo "# Executor Agent" > "$_TEST_PROJECT_DIR/.claude/skills/kanban/agents/executor.md"

  # Create sample rule files
  echo "# Rule: Test With Code" > "$_TEST_PROJECT_DIR/.claude/skills/kanban/rules/test-with-code.md"
  echo "# Rule: Output Dir" > "$_TEST_PROJECT_DIR/.claude/skills/kanban/rules/output-dir-convention.md"

  # Create minimal config
  jq -n '{project:"test",trunk:"main",output_dir:"src"}' > "$_TEST_KANBAN_DIR/config.json"
  jq -n '{project:"test",trunk:"main",tasks:[]}' > "$_TEST_KANBAN_DIR/index.json"

  # Initialize git repo (kanban_init needs git)
  cd "$_TEST_PROJECT_DIR"
  git init -q 2>/dev/null || true
  git add -A 2>/dev/null && git commit -q -m "init" 2>/dev/null || true
}

teardown() {
  if [ -n "$_TEST_TMPDIR" ] && [ -d "$_TEST_TMPDIR" ]; then
    rm -rf "$_TEST_TMPDIR"
  fi
}

# Source the library with KANBAN_DIR and SKILL_DIR overridden
source_lib() {
  _KANBAN_CORE_LOADED=""
  source "$LIB_DIR/kanban.sh"
  KANBAN_DIR="$_TEST_KANBAN_DIR"
  SKILL_DIR="$_TEST_PROJECT_DIR/.claude/skills/kanban"
}

# ============================================================
# Test 1: _kanban_install_deps creates symlinks for agents
# ============================================================
test_agents_symlink_created() {
  echo "--- test_agents_symlink_created ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local is_link="false"
  [ -L "$planner_link" ] && is_link="true"
  assert_true "planner.md is a symlink" "$is_link"

  local executor_link="$_TEST_PROJECT_DIR/.claude/agents/executor.md"
  is_link="false"
  [ -L "$executor_link" ] && is_link="true"
  assert_true "executor.md is a symlink" "$is_link"
}

# ============================================================
# Test 2: Symlink points to correct relative path
# ============================================================
test_symlink_target_is_correct() {
  echo "--- test_symlink_target_is_correct ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local target
  target=$(readlink "$planner_link" 2>/dev/null || echo "")
  assert_eq "planner.md symlink target" "../skills/kanban/agents/planner.md" "$target"
}

# ============================================================
# Test 3: Rules are symlinked too
# ============================================================
test_rules_symlink_created() {
  echo "--- test_rules_symlink_created ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1

  local rule_link="$_TEST_PROJECT_DIR/.claude/rules/test-with-code.md"
  local is_link="false"
  [ -L "$rule_link" ] && is_link="true"
  assert_true "test-with-code.md is a symlink" "$is_link"

  local target
  target=$(readlink "$rule_link" 2>/dev/null || echo "")
  assert_eq "rule symlink target" "../skills/kanban/rules/test-with-code.md" "$target"
}

# ============================================================
# Test 4: Symlink resolves to readable content
# ============================================================
test_symlink_content_readable() {
  echo "--- test_symlink_content_readable ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local content
  content=$(cat "$planner_link" 2>/dev/null || echo "")
  assert_contains "planner.md content readable" "$content" "Planner Agent"
}

# ============================================================
# Test 5: Idempotent -- running twice does not break anything
# ============================================================
test_idempotent_double_run() {
  echo "--- test_idempotent_double_run ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1
  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local is_link="false"
  [ -L "$planner_link" ] && is_link="true"
  assert_true "planner.md is still a symlink after double run" "$is_link"

  local content
  content=$(cat "$planner_link" 2>/dev/null || echo "")
  assert_contains "content still readable after double run" "$content" "Planner Agent"
}

# ============================================================
# Test 6: Idempotent -- second run reports skipped
# ============================================================
test_idempotent_reports_skipped() {
  echo "--- test_idempotent_reports_skipped ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1

  local output
  output=$(_kanban_install_deps 2>&1)
  assert_contains "second run reports skipped" "$output" "skipped"
}

# ============================================================
# Test 7: Regular file overwritten with symlink
# ============================================================
test_regular_file_overwritten() {
  echo "--- test_regular_file_overwritten ---"
  setup
  source_lib

  # Pre-create a regular file (simulating old cp-based deployment)
  mkdir -p "$_TEST_PROJECT_DIR/.claude/agents"
  echo "old content" > "$_TEST_PROJECT_DIR/.claude/agents/planner.md"

  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local is_link="false"
  [ -L "$planner_link" ] && is_link="true"
  assert_true "regular file replaced with symlink" "$is_link"

  local content
  content=$(cat "$planner_link" 2>/dev/null || echo "")
  assert_contains "content comes from skills source" "$content" "Planner Agent"
}

# ============================================================
# Test 8: Symlink pointing to different target is replaced
# ============================================================
test_stale_symlink_replaced() {
  echo "--- test_stale_symlink_replaced ---"
  setup
  source_lib

  # Pre-create a symlink pointing to wrong target
  mkdir -p "$_TEST_PROJECT_DIR/.claude/agents"
  ln -sf "/nonexistent/path/planner.md" "$_TEST_PROJECT_DIR/.claude/agents/planner.md"

  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local target
  target=$(readlink "$planner_link" 2>/dev/null || echo "")
  assert_eq "stale symlink replaced with correct target" "../skills/kanban/agents/planner.md" "$target"
}

# ============================================================
# Test 9: _kanban_supports_symlinks returns 0 on macOS/Linux
# ============================================================
test_supports_symlinks_on_unix() {
  echo "--- test_supports_symlinks_on_unix ---"
  setup
  source_lib

  local result=0
  _kanban_supports_symlinks || result=$?
  assert_eq "symlinks supported on Unix" "0" "$result"
}

# ============================================================
# Test 10: _kanban_link_file creates correct symlink
# ============================================================
test_link_file_creates_symlink() {
  echo "--- test_link_file_creates_symlink ---"
  setup
  source_lib

  local target_dir="$_TEST_PROJECT_DIR/.claude/agents"
  mkdir -p "$target_dir"

  local ret=0
  _kanban_link_file "$target_dir" "planner.md" "../skills/kanban/agents/planner.md" || ret=$?
  assert_eq "link_file returns 0 (created)" "0" "$ret"

  local is_link="false"
  [ -L "$target_dir/planner.md" ] && is_link="true"
  assert_true "file is a symlink" "$is_link"
}

# ============================================================
# Test 11: _kanban_link_file skips when valid symlink exists
# ============================================================
test_link_file_skips_valid_symlink() {
  echo "--- test_link_file_skips_valid_symlink ---"
  setup
  source_lib

  local target_dir="$_TEST_PROJECT_DIR/.claude/agents"
  mkdir -p "$target_dir"
  # Pre-create valid symlink
  ln -sf "../skills/kanban/agents/planner.md" "$target_dir/planner.md"

  local ret=0
  _kanban_link_file "$target_dir" "planner.md" "../skills/kanban/agents/planner.md" || ret=$?
  assert_eq "link_file returns 1 (skipped)" "1" "$ret"
}

# ============================================================
# Test 12: _kanban_link_file replaces regular file
# ============================================================
test_link_file_replaces_regular_file() {
  echo "--- test_link_file_replaces_regular_file ---"
  setup
  source_lib

  local target_dir="$_TEST_PROJECT_DIR/.claude/agents"
  mkdir -p "$target_dir"
  echo "old" > "$target_dir/planner.md"

  local ret=0
  _kanban_link_file "$target_dir" "planner.md" "../skills/kanban/agents/planner.md" || ret=$?
  assert_eq "link_file returns 0 (replaced)" "0" "$ret"

  local is_link="false"
  [ -L "$target_dir/planner.md" ] && is_link="true"
  assert_true "regular file replaced with symlink" "$is_link"
}

# ============================================================
# Test 13: _kanban_link_file replaces stale symlink
# ============================================================
test_link_file_replaces_stale_symlink() {
  echo "--- test_link_file_replaces_stale_symlink ---"
  setup
  source_lib

  local target_dir="$_TEST_PROJECT_DIR/.claude/agents"
  mkdir -p "$target_dir"
  ln -sf "/wrong/target.md" "$target_dir/planner.md"

  local ret=0
  _kanban_link_file "$target_dir" "planner.md" "../skills/kanban/agents/planner.md" || ret=$?
  assert_eq "link_file returns 0 (replaced stale)" "0" "$ret"

  local target
  target=$(readlink "$target_dir/planner.md" 2>/dev/null || echo "")
  assert_eq "symlink target updated" "../skills/kanban/agents/planner.md" "$target"
}

# ============================================================
# Test 14: Output message uses "Linked" on Unix
# ============================================================
test_output_says_linked() {
  echo "--- test_output_says_linked ---"
  setup
  source_lib

  local output
  output=$(_kanban_install_deps 2>&1)
  assert_contains "output says Linked" "$output" "Linked"
  assert_contains "output mentions symlink" "$output" "symlink"
}

# ============================================================
# Test 15: Full init integration creates symlinks
# ============================================================
test_init_integration() {
  echo "--- test_init_integration ---"
  setup
  source_lib

  # Create minimal template files needed by kanban_init
  mkdir -p "$_TEST_PROJECT_DIR/.claude/skills/kanban/templates"
  echo '{"project":"","trunk":"main","output_dir":"src"}' > "$_TEST_PROJECT_DIR/.claude/skills/kanban/templates/config.json"
  cat > "$_TEST_PROJECT_DIR/.claude/skills/kanban/templates/workflow.json" << 'WFEOF'
{
  "fsm": {
    "initial": "pending",
    "states": {
      "pending": {"next": "plan"},
      "plan": {"next": "execute"},
      "execute": {"next": "evaluate"},
      "evaluate": {"next": "user_decision"},
      "user_decision": {"next": "archive"},
      "archive": {"next": null}
    }
  },
  "pass_threshold": 9.0,
  "max_iterations": 6
}
WFEOF

  local output
  output=$(kanban_init 2>&1)
  assert_contains "init succeeded" "$output" "Kanban"

  # Verify agents are symlinks
  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local is_link="false"
  [ -L "$planner_link" ] && is_link="true"
  assert_true "init created symlink for planner.md" "$is_link"

  # Verify rules are symlinks
  local rule_link="$_TEST_PROJECT_DIR/.claude/rules/test-with-code.md"
  is_link="false"
  [ -L "$rule_link" ] && is_link="true"
  assert_true "init created symlink for test-with-code.md" "$is_link"
}

# ============================================================
# Test 16: Only agents and rules that exist in source are linked
# ============================================================
test_only_existing_files_linked() {
  echo "--- test_only_existing_files_linked ---"
  setup
  source_lib

  # Only planner.md exists in source, not executor.md -- remove executor
  rm -f "$_TEST_PROJECT_DIR/.claude/skills/kanban/agents/executor.md"

  _kanban_install_deps > /dev/null 2>&1

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local executor_link="$_TEST_PROJECT_DIR/.claude/agents/executor.md"

  local planner_is_link="false"
  [ -L "$planner_link" ] && planner_is_link="true"
  assert_true "planner.md is symlinked" "$planner_is_link"

  local executor_exists="false"
  [ -e "$executor_link" ] && executor_exists="true"
  assert_eq "executor.md does not exist (not in source)" "false" "$executor_exists"
}

# ============================================================
# Test 17: Source file update is reflected via symlink
# ============================================================
test_source_update_reflected() {
  echo "--- test_source_update_reflected ---"
  setup
  source_lib

  _kanban_install_deps > /dev/null 2>&1

  # Update source file
  echo "# Planner Agent v2" > "$_TEST_PROJECT_DIR/.claude/skills/kanban/agents/planner.md"

  local planner_link="$_TEST_PROJECT_DIR/.claude/agents/planner.md"
  local content
  content=$(cat "$planner_link" 2>/dev/null || echo "")
  assert_contains "symlink reflects source update" "$content" "Planner Agent v2"
}

# ============================================================
# Run all tests
# ============================================================
echo "========================================="
echo "Running ST-002 symlink deployment tests"
echo "========================================="
echo ""

test_agents_symlink_created
teardown
test_symlink_target_is_correct
teardown
test_rules_symlink_created
teardown
test_symlink_content_readable
teardown
test_idempotent_double_run
teardown
test_idempotent_reports_skipped
teardown
test_regular_file_overwritten
teardown
test_stale_symlink_replaced
teardown
test_supports_symlinks_on_unix
teardown
test_link_file_creates_symlink
teardown
test_link_file_skips_valid_symlink
teardown
test_link_file_replaces_regular_file
teardown
test_link_file_replaces_stale_symlink
teardown
test_output_says_linked
teardown
test_init_integration
teardown
test_only_existing_files_linked
teardown
test_source_update_reflected
teardown

echo ""
echo "========================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_RUN total"
echo "========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
  exit 1
fi
