#!/usr/bin/env bash
# test_worktree_config_sync.sh -- Unit tests for _worktree_sync_config (ST-002)
# Validates that worktree_create auto-copies workflow.json and config.json
# to the newly created worktree directory.
#
# Usage: bash test_worktree_config_sync.sh
# Returns: 0 if all tests pass, 1 if any test fails

set -euo pipefail

# ---------------------------------------------------------------------------
# Test framework helpers
# ---------------------------------------------------------------------------
PASS_COUNT=0
FAIL_COUNT=0
TESTS_RUN=0

assert_equals() {
  local description="$1" expected="$2" actual="$3"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ "$expected" = "$actual" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description"
    echo "    expected: $expected"
    echo "    actual:   $actual"
  fi
}

assert_file_exists() {
  local description="$1" filepath="$2"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ -f "$filepath" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description -- file not found: $filepath"
  fi
}

assert_file_not_exists() {
  local description="$1" filepath="$2"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ ! -f "$filepath" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description -- file should not exist: $filepath"
  fi
}

assert_contains() {
  local description="$1" haystack="$2" needle="$3"
  TESTS_RUN=$((TESTS_RUN + 1))
  if echo "$haystack" | grep -q "$needle"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description"
    echo "    expected to contain: $needle"
    echo "    actual output: $haystack"
  fi
}

# ---------------------------------------------------------------------------
# Setup: Create isolated test environment
# ---------------------------------------------------------------------------
TEST_TEMP_DIR=""
cleanup() {
  if [ -n "$TEST_TEMP_DIR" ] && [ -d "$TEST_TEMP_DIR" ]; then
    cd /tmp
    if [ -d "$TEST_TEMP_DIR/main" ]; then
      cd "$TEST_TEMP_DIR/main"
      git worktree prune 2>/dev/null || true
    fi
    rm -rf "$TEST_TEMP_DIR"
  fi
}
trap cleanup EXIT

TEST_TEMP_DIR="$(mktemp -d /tmp/test_worktree_config_sync.XXXXXX)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KANBAN_DIR=".kanban"

echo "=== test_worktree_config_sync.sh ==="
echo ""

# ---------------------------------------------------------------------------
# Stub out dependencies that worktree.sh needs but we don't want to pull in
# We extract only _worktree_sync_config by sourcing worktree.sh with stubs.
# ---------------------------------------------------------------------------

# Stub: task_file (needed by worktree_create but not by _worktree_sync_config)
task_file() {
  echo "$TEST_TEMP_DIR/main/.kanban/tasks/$1/task.json"
}

# Stub: kanban_update_task (needed by worktree_create but not by _worktree_sync_config)
kanban_update_task() {
  local task_id="$1" jq_expr="$2"
  local tf="$(task_file "$task_id")"
  local tmp=$(mktemp)
  jq "$jq_expr" "$tf" > "$tmp" && mv "$tmp" "$tf"
}

# Source only worktree.sh (KANBAN_DIR is already set)
source "$SCRIPT_DIR/worktree.sh" 2>/dev/null || true

# ---------------------------------------------------------------------------
# Helper: Create a minimal "main repo" with .kanban/ structure
# ---------------------------------------------------------------------------
setup_main_repo() {
  local repo_dir="$TEST_TEMP_DIR/main"
  rm -rf "$repo_dir"
  mkdir -p "$repo_dir"
  cd "$repo_dir"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"

  # Create .kanban/ with workflow.json and config.json
  mkdir -p .kanban/tasks/TASK-TEST01
  cat > .kanban/workflow.json <<'WFEOF'
{
  "phases": [
    {"id": "plan", "name": "test plan"},
    {"id": "execute", "name": "test execute"}
  ]
}
WFEOF
  cat > .kanban/config.json <<'EOF'
{"project": "test-project", "trunk": "main", "output_dir": "games"}
EOF

  # Create a minimal task.json for TASK-TEST01
  cat > .kanban/tasks/TASK-TEST01/task.json <<'TEOF'
{
  "task_id": "TASK-TEST01",
  "title": "Test Task",
  "status": "pending",
  "worktree": {"branch": "", "path": ""}
}
TEOF

  # Add everything and commit so worktree add works
  git add -A
  git commit -qm "initial commit" --no-gpg-sign 2>/dev/null || true
}

# ---------------------------------------------------------------------------
# Test 1: _worktree_sync_config copies workflow.json from main repo
# ---------------------------------------------------------------------------
test_sync_copies_workflow_json() {
  echo "--- Test 1: _worktree_sync_config copies workflow.json ---"
  setup_main_repo

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  local output
  output=$(_worktree_sync_config "$wt_dir" 2>&1)

  assert_file_exists "workflow.json copied to worktree" "$wt_dir/.kanban/workflow.json"
  assert_contains "output mentions synced workflow.json" "$output" "Synced workflow.json"
}

# ---------------------------------------------------------------------------
# Test 2: _worktree_sync_config copies config.json from main repo
# ---------------------------------------------------------------------------
test_sync_copies_config_json() {
  echo "--- Test 2: _worktree_sync_config copies config.json ---"
  setup_main_repo

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  local output
  output=$(_worktree_sync_config "$wt_dir" 2>&1)

  assert_file_exists "config.json copied to worktree" "$wt_dir/.kanban/config.json"
  assert_contains "output mentions synced config.json" "$output" "Synced config.json"
}

# ---------------------------------------------------------------------------
# Test 3: _worktree_sync_config is idempotent (does not overwrite existing)
# ---------------------------------------------------------------------------
test_sync_idempotent_no_overwrite() {
  echo "--- Test 3: _worktree_sync_config does not overwrite existing files ---"
  setup_main_repo

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir/.kanban"

  # Pre-create a custom workflow.json
  echo '{"custom": true}' > "$wt_dir/.kanban/workflow.json"
  echo '{"custom_config": true}' > "$wt_dir/.kanban/config.json"

  local output
  output=$(_worktree_sync_config "$wt_dir" 2>&1)

  # Verify the custom content is preserved
  local wf_content
  wf_content=$(cat "$wt_dir/.kanban/workflow.json")
  assert_equals "workflow.json not overwritten (preserved custom content)" '{"custom": true}' "$wf_content"

  local cf_content
  cf_content=$(cat "$wt_dir/.kanban/config.json")
  assert_equals "config.json not overwritten (preserved custom content)" '{"custom_config": true}' "$cf_content"
}

# ---------------------------------------------------------------------------
# Test 4: _worktree_sync_config falls back to template when main repo lacks files
# ---------------------------------------------------------------------------
test_sync_fallback_to_template() {
  echo "--- Test 4: _worktree_sync_config falls back to template ---"
  setup_main_repo

  # Remove the main repo's workflow.json to test fallback
  rm -f "$TEST_TEMP_DIR/main/.kanban/workflow.json"

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  local output
  output=$(_worktree_sync_config "$wt_dir" 2>&1)

  # Should fall back to template since SKILL_DIR is set
  if [ -f "$SKILL_DIR/templates/workflow.json" ]; then
    assert_file_exists "workflow.json created from template fallback" "$wt_dir/.kanban/workflow.json"
    assert_contains "output mentions template" "$output" "from template"
  else
    assert_contains "output warns no source found" "$output" "WARNING"
  fi
}

# ---------------------------------------------------------------------------
# Test 5: _worktree_sync_config warns when no source available
# ---------------------------------------------------------------------------
test_sync_warns_no_source() {
  echo "--- Test 5: _worktree_sync_config warns when no source ---"
  setup_main_repo

  # Remove main repo config files
  rm -f "$TEST_TEMP_DIR/main/.kanban/workflow.json"
  rm -f "$TEST_TEMP_DIR/main/.kanban/config.json"

  # Temporarily unset SKILL_DIR to test no-source path
  local saved_skill_dir="${SKILL_DIR:-}"
  SKILL_DIR=""

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  local output
  output=$(_worktree_sync_config "$wt_dir" 2>&1)

  # Restore
  SKILL_DIR="$saved_skill_dir"

  assert_contains "output warns about missing workflow.json source" "$output" "WARNING"
}

# ---------------------------------------------------------------------------
# Test 6: _worktree_sync_config creates .kanban directory if missing
# ---------------------------------------------------------------------------
test_sync_creates_kanban_dir() {
  echo "--- Test 6: _worktree_sync_config creates .kanban/ directory ---"
  setup_main_repo

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  # Ensure .kanban/ does NOT exist in the worktree dir
  assert_file_not_exists ".kanban/ dir does not exist before sync" "$wt_dir/.kanban"

  _worktree_sync_config "$wt_dir" 2>&1

  # Now .kanban/ should exist (with workflow.json inside)
  assert_file_exists ".kanban/ directory created by sync" "$wt_dir/.kanban/workflow.json"
}

# ---------------------------------------------------------------------------
# Test 7: Copied workflow.json is valid JSON
# ---------------------------------------------------------------------------
test_sync_valid_json() {
  echo "--- Test 7: Copied workflow.json is valid JSON ---"
  setup_main_repo

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  _worktree_sync_config "$wt_dir" 2>&1

  local validate_result
  validate_result=$(jq '.' "$wt_dir/.kanban/workflow.json" > /dev/null 2>&1 && echo "valid" || echo "invalid")
  assert_equals "workflow.json is valid JSON" "valid" "$validate_result"

  local validate_config
  validate_config=$(jq '.' "$wt_dir/.kanban/config.json" > /dev/null 2>&1 && echo "valid" || echo "invalid")
  assert_equals "config.json is valid JSON" "valid" "$validate_config"
}

# ---------------------------------------------------------------------------
# Test 8: Copied workflow.json content matches source
# ---------------------------------------------------------------------------
test_sync_content_matches() {
  echo "--- Test 8: Copied workflow.json content matches source ---"
  setup_main_repo

  local wt_dir="$TEST_TEMP_DIR/main/.kanban/tasks/TASK-TEST01/worktree"
  mkdir -p "$wt_dir"

  _worktree_sync_config "$wt_dir" 2>&1

  # Compare with the main repo's workflow.json
  local main_wf="$TEST_TEMP_DIR/main/.kanban/workflow.json"
  local wt_wf="$wt_dir/.kanban/workflow.json"

  if [ -f "$main_wf" ] && [ -f "$wt_wf" ]; then
    local diff_result
    diff_result=$(diff "$main_wf" "$wt_wf" > /dev/null 2>&1 && echo "match" || echo "differ")
    assert_equals "workflow.json content matches main repo" "match" "$diff_result"
  else
    echo "  SKIP: source or target file missing"
  fi
}

# ---------------------------------------------------------------------------
# Run all tests
# ---------------------------------------------------------------------------
test_sync_copies_workflow_json
echo ""
test_sync_copies_config_json
echo ""
test_sync_idempotent_no_overwrite
echo ""
test_sync_fallback_to_template
echo ""
test_sync_warns_no_source
echo ""
test_sync_creates_kanban_dir
echo ""
test_sync_valid_json
echo ""
test_sync_content_matches

echo ""
echo "=== Results ==="
echo "  Tests run:  $TESTS_RUN"
echo "  Passed:     $PASS_COUNT"
echo "  Failed:     $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "  STATUS: FAIL"
  exit 1
else
  echo "  STATUS: PASS"
  exit 0
fi
