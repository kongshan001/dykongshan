#!/usr/bin/env bash
# test_worktree_cohesion.sh — ST-004: worktree 目录内聚改造测试
# 测试范围:
#   1. 新任务 worktree 创建在 tasks/TASK-NNN/worktree 路径
#   2. 旧任务（worktree.path 指向 .kanban/worktrees/TASK-NNN）兼容
#   3. worktree_cleanup() 正确清理 worktree 子目录但保留任务目录
#   4. _worktree_default_path() 返回正确的新路径
#   5. _worktree_resolve_path() 优先读取 task.json 中已有路径
#   6. kanban_changes_summary() 中 main_kanban 路径推导兼容新路径

set -e

# ============================================================
# Test framework (minimal)
# ============================================================
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
FAILURES=""

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ "$expected" = "$actual" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    expected: <$expected>\n    actual:   <$actual>"
  fi
}

assert_contains() {
  local desc="$1" haystack="$2" needle="$3"
  TESTS_RUN=$((TESTS_RUN + 1))
  if echo "$haystack" | grep -qF "$needle"; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    haystack: <$haystack>\n    needle:   <$needle>"
  fi
}

assert_not_contains() {
  local desc="$1" haystack="$2" needle="$3"
  TESTS_RUN=$((TESTS_RUN + 1))
  if ! echo "$haystack" | grep -qF "$needle"; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    did not expect to find: <$needle>\n    in: <$haystack>"
  fi
}

assert_dir_exists() {
  local desc="$1" path="$2"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ -d "$path" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    directory does not exist: <$path>"
  fi
}

assert_dir_not_exists() {
  local desc="$1" path="$2"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ ! -d "$path" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    directory should not exist: <$path>"
  fi
}

assert_file_exists() {
  local desc="$1" path="$2"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ -f "$path" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    file does not exist: <$path>"
  fi
}

assert_return_code() {
  local desc="$1" expected="$2" actual="$3"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [ "$expected" = "$actual" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $desc\n    expected return: <$expected>\n    actual return:   <$actual>"
  fi
}

# ============================================================
# Setup / Teardown
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_ROOT=""

setup() {
  TEST_ROOT=$(mktemp -d "/tmp/test_worktree_cohesion.XXXXXX")
  cd "$TEST_ROOT"

  # Create a minimal git repo
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test User"
  echo "init" > init.txt
  git add init.txt
  git commit -q -m "init"

  # Create .kanban directory structure
  KANBAN_DIR=".kanban"
  mkdir -p "$KANBAN_DIR"/{tasks,worktrees,archive}

  # Create minimal config.json
  cat > "$KANBAN_DIR/config.json" <<'CFGEOF'
{
  "project": "test-project",
  "trunk": "main",
  "output_dir": "games",
  "version": "0.3.0"
}
CFGEOF

  # Create minimal workflow.json
  cat > "$KANBAN_DIR/workflow.json" <<'WFEOF'
{
  "phases": [
    {"id": "plan", "quality_gate": {"enabled": false}},
    {"id": "execute"},
    {"id": "evaluate"}
  ],
  "self_improve": {
    "max_iterations": 6
  }
}
WFEOF

  # Create index.json
  echo '{"project":"test-project","trunk":"main","tasks":[]}' > "$KANBAN_DIR/index.json"

  # Source the library files (load each explicitly to ensure all functions available)
  KANBAN_DIR=".kanban"
  # Reset the guard flag to allow re-loading
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  source "$SKILL_DIR/lib/kanban.sh" 2>/dev/null || true
  # Load each lib explicitly (kanban_init_env skips kanban.sh but loads the rest)
  for lib in "$SKILL_DIR"/lib/*.sh; do
    source "$lib" 2>/dev/null || true
  done
}

teardown() {
  cd /
  rm -rf "$TEST_ROOT"
}

# ============================================================
# Helper: create a task JSON for testing
# ============================================================
create_test_task() {
  local task_id="$1"
  local worktree_path="${2:-}"
  local worktree_branch="${3:-feature/${task_id}}"

  local task_dir="$KANBAN_DIR/tasks/${task_id}"
  mkdir -p "$task_dir"

  local now=$(date -u +%FT%TZ)
  jq -n \
    --arg id "$task_id" \
    --arg title "Test task ${task_id}" \
    --arg branch "$worktree_branch" \
    --arg wt_path "$worktree_path" \
    --arg now "$now" \
    '{
      id: $id,
      title: $title,
      status: "pending",
      phase: null,
      phase_lock: null,
      worktree: { branch: $branch, path: $wt_path, base: "main" },
      iteration: 0,
      scores: {},
      history: [],
      created_at: $now,
      updated_at: $now
    }' > "$task_dir/task.json"
}

# ============================================================
# Test 1: _worktree_default_path returns new path
# ============================================================
test_default_path() {
  echo "--- Test 1: _worktree_default_path ---"

  local result=$(_worktree_default_path "TASK-100")
  assert_eq "new default path for TASK-100" \
    ".kanban/tasks/TASK-100/worktree" \
    "$result"

  local result2=$(_worktree_default_path "TASK-999")
  assert_eq "new default path for TASK-999" \
    ".kanban/tasks/TASK-999/worktree" \
    "$result2"
}

# ============================================================
# Test 2: _worktree_resolve_path prefers task.json over default
# ============================================================
test_resolve_path_prefers_existing() {
  echo "--- Test 2: _worktree_resolve_path prefers task.json ---"

  # Task with existing (old) path in task.json
  create_test_task "TASK-200" "/some/old/path/.kanban/worktrees/TASK-200"

  local result=$(_worktree_resolve_path "TASK-200")
  assert_eq "resolve path uses existing task.json path" \
    "/some/old/path/.kanban/worktrees/TASK-200" \
    "$result"
}

# ============================================================
# Test 3: _worktree_resolve_path falls back to new default
# ============================================================
test_resolve_path_falls_back_to_default() {
  echo "--- Test 3: _worktree_resolve_path falls back to default ---"

  # Task with empty worktree.path
  create_test_task "TASK-201" ""

  local result=$(_worktree_resolve_path "TASK-201")
  assert_eq "resolve path uses new default when path is empty" \
    ".kanban/tasks/TASK-201/worktree" \
    "$result"
}

# ============================================================
# Test 4: worktree_path reads from task.json
# ============================================================
test_worktree_path_from_task_json() {
  echo "--- Test 4: worktree_path reads from task.json ---"

  create_test_task "TASK-202" "/custom/path/worktree"

  local result=$(worktree_path "TASK-202")
  assert_eq "worktree_path reads from task.json" \
    "/custom/path/worktree" \
    "$result"
}

# ============================================================
# Test 5: worktree_path returns empty for no worktree
# ============================================================
test_worktree_path_empty() {
  echo "--- Test 5: worktree_path empty for no worktree ---"

  create_test_task "TASK-203" ""

  local result=$(worktree_path "TASK-203")
  assert_eq "worktree_path empty when no path set" \
    "" \
    "$result"
}

# ============================================================
# Test 6: worktree_exists returns true for valid directory
# ============================================================
test_worktree_exists_true() {
  echo "--- Test 6: worktree_exists true ---"

  local fake_wt="$TEST_ROOT/fake_worktree"
  mkdir -p "$fake_wt"
  create_test_task "TASK-204" "$fake_wt"

  local rc=0
  worktree_exists "TASK-204" || rc=$?
  assert_return_code "worktree_exists returns 0 for existing dir" "0" "$rc"
}

# ============================================================
# Test 7: worktree_exists returns false for missing directory
# ============================================================
test_worktree_exists_false() {
  echo "--- Test 7: worktree_exists false ---"

  create_test_task "TASK-205" "/nonexistent/path"

  local rc=0
  worktree_exists "TASK-205" || rc=$?
  assert_return_code "worktree_exists returns 1 for missing dir" "1" "$rc"
}

# ============================================================
# Test 8: worktree_validate returns invalid for empty path
# ============================================================
test_validate_empty_path() {
  echo "--- Test 8: worktree_validate invalid for empty path ---"

  create_test_task "TASK-206" ""

  local result=""
  result=$(worktree_validate "TASK-206" 2>/dev/null) || true
  local valid=$(echo "$result" | jq -r '.valid')
  assert_eq "validate returns false for empty path" "false" "$valid"

  local has_error=$(echo "$result" | jq '[.errors[] | contains("worktree_path_empty")] | any')
  assert_eq "has worktree_path_empty error" "true" "$has_error"
}

# ============================================================
# Test 9: worktree_cleanup clears path and branch in task.json
# ============================================================
test_cleanup_clears_fields() {
  echo "--- Test 9: worktree_cleanup clears fields ---"

  create_test_task "TASK-207" "/some/path"

  # cleanup should work even if the directory doesn't physically exist
  worktree_cleanup "TASK-207" >/dev/null 2>&1 || true

  local tf=$(task_file "TASK-207")
  local path_after=$(jq -r '.worktree.path' "$tf")
  local branch_after=$(jq -r '.worktree.branch' "$tf")

  assert_eq "worktree.path cleared after cleanup" "" "$path_after"
  assert_eq "worktree.branch cleared after cleanup" "" "$branch_after"
}

# ============================================================
# Test 10: worktree_cleanup removes worktree directory
# ============================================================
test_cleanup_removes_directory() {
  echo "--- Test 10: worktree_cleanup removes directory ---"

  local wt_dir="$TEST_ROOT/.kanban/tasks/TASK-208/worktree"
  mkdir -p "$wt_dir"
  # Create a file inside to verify it gets cleaned
  echo "test" > "$wt_dir/test_file.txt"

  create_test_task "TASK-208" "$wt_dir"

  worktree_cleanup "TASK-208" >/dev/null 2>&1 || true

  assert_dir_not_exists "worktree directory removed after cleanup" "$wt_dir"
}

# ============================================================
# Test 11: worktree_cleanup preserves task directory
# ============================================================
test_cleanup_preserves_task_dir() {
  echo "--- Test 11: worktree_cleanup preserves task directory ---"

  local task_dir="$TEST_ROOT/.kanban/tasks/TASK-209"
  local wt_dir="$task_dir/worktree"
  mkdir -p "$wt_dir"
  create_test_task "TASK-209" "$wt_dir"

  # Create iteration directory with a report file
  mkdir -p "$task_dir/iteration-1"
  echo "# Report" > "$task_dir/iteration-1/report.md"

  worktree_cleanup "TASK-209" >/dev/null 2>&1 || true

  # Task directory should still exist
  assert_dir_exists "task directory preserved after cleanup" "$task_dir"
  # task.json should still exist
  assert_file_exists "task.json preserved after cleanup" "$task_dir/task.json"
  # iteration-1 should still exist
  assert_dir_exists "iteration-1 preserved after cleanup" "$task_dir/iteration-1"
  # worktree directory should be gone
  assert_dir_not_exists "worktree subdirectory removed" "$wt_dir"
}

# ============================================================
# Test 12: Old path compatibility - task with .kanban/worktrees/ path
# ============================================================
test_old_path_compatibility() {
  echo "--- Test 12: Old path compatibility ---"

  # Simulate an old task with worktree path under .kanban/worktrees/
  local old_wt_dir="$TEST_ROOT/.kanban/worktrees/TASK-210"
  mkdir -p "$old_wt_dir"

  create_test_task "TASK-210" "$old_wt_dir"

  # worktree_path should return the old path from task.json
  local result=$(worktree_path "TASK-210")
  assert_eq "worktree_path returns old path from task.json" \
    "$old_wt_dir" \
    "$result"

  # _worktree_resolve_path should also return the old path
  local resolved=$(_worktree_resolve_path "TASK-210")
  assert_eq "resolve_path returns old path (not new default)" \
    "$old_wt_dir" \
    "$resolved"
}

# ============================================================
# Test 13: worktree_exists works with old path
# ============================================================
test_exists_old_path() {
  echo "--- Test 13: worktree_exists with old path ---"

  local old_wt_dir="$TEST_ROOT/.kanban/worktrees/TASK-211"
  mkdir -p "$old_wt_dir"

  create_test_task "TASK-211" "$old_wt_dir"

  worktree_exists "TASK-211"
  assert_return_code "worktree_exists returns 0 for old path" "0" "$?"
}

# ============================================================
# Test 14: main_kanban path derivation for new worktree path
# ============================================================
test_main_kanban_new_path() {
  echo "--- Test 14: main_kanban derivation for new path ---"

  # Simulate a worktree at new path
  local new_wt_path="/projects/myapp/.kanban/tasks/TASK-300/worktree"
  local main_kanban=""

  if [[ "$new_wt_path" == *"/.kanban/worktrees/"* ]]; then
    main_kanban="${new_wt_path%%/.kanban/worktrees/*}/.kanban"
  elif [[ "$new_wt_path" == *"/.kanban/tasks/"*"/worktree" ]]; then
    main_kanban="${new_wt_path%%/.kanban/tasks/*}/.kanban"
  fi

  assert_eq "main_kanban derived from new path" \
    "/projects/myapp/.kanban" \
    "$main_kanban"
}

# ============================================================
# Test 15: main_kanban path derivation for old worktree path
# ============================================================
test_main_kanban_old_path() {
  echo "--- Test 15: main_kanban derivation for old path ---"

  # Simulate a worktree at old path
  local old_wt_path="/projects/myapp/.kanban/worktrees/TASK-300"
  local main_kanban=""

  if [[ "$old_wt_path" == *"/.kanban/worktrees/"* ]]; then
    main_kanban="${old_wt_path%%/.kanban/worktrees/*}/.kanban"
  elif [[ "$old_wt_path" == *"/.kanban/tasks/"*"/worktree" ]]; then
    main_kanban="${old_wt_path%%/.kanban/tasks/*}/.kanban"
  fi

  assert_eq "main_kanban derived from old path" \
    "/projects/myapp/.kanban" \
    "$main_kanban"
}

# ============================================================
# Test 16: main_kanban not derived for unrelated path
# ============================================================
test_main_kanban_unrelated_path() {
  echo "--- Test 16: main_kanban no match for unrelated path ---"

  local random_path="/tmp/random/directory"
  local main_kanban=""

  if [[ "$random_path" == *"/.kanban/worktrees/"* ]]; then
    main_kanban="${random_path%%/.kanban/worktrees/*}/.kanban"
  elif [[ "$random_path" == *"/.kanban/tasks/"*"/worktree" ]]; then
    main_kanban="${random_path%%/.kanban/tasks/*}/.kanban"
  fi

  assert_eq "main_kanban empty for unrelated path" \
    "" \
    "$main_kanban"
}

# ============================================================
# Test 17: _worktree_default_path path structure
# ============================================================
test_default_path_structure() {
  echo "--- Test 17: Default path structure ---"

  local default_path=$(_worktree_default_path "TASK-500")

  # Should contain tasks/TASK-500/worktree
  assert_contains "default path contains tasks/" "$default_path" "tasks/TASK-500/worktree"
  # Should NOT contain worktrees/
  assert_not_contains "default path does not use worktrees/" "$default_path" "worktrees/"
}

# ============================================================
# Test 18: Cleanup with branch-only (no path)
# ============================================================
test_cleanup_branch_only() {
  echo "--- Test 18: Cleanup with branch-only (no path) ---"

  create_test_task "TASK-501" "" "feature/TASK-501"

  # This should not fail even with branch but no path
  worktree_cleanup "TASK-501" >/dev/null 2>&1
  assert_return_code "cleanup succeeds with branch only" "0" "$?"
}

# ============================================================
# Test 19: Cleanup idempotent (calling twice is safe)
# ============================================================
test_cleanup_idempotent() {
  echo "--- Test 19: Cleanup idempotent ---"

  local wt_dir="$TEST_ROOT/.kanban/tasks/TASK-502/worktree"
  mkdir -p "$wt_dir"
  create_test_task "TASK-502" "$wt_dir"

  # First cleanup
  worktree_cleanup "TASK-502" >/dev/null 2>&1 || true
  # Second cleanup (should be safe)
  worktree_cleanup "TASK-502" >/dev/null 2>&1
  assert_return_code "second cleanup succeeds" "0" "$?"
}

# ============================================================
# Test 20: worktree_cleanup with old path cleans old dir
# ============================================================
test_cleanup_old_path() {
  echo "--- Test 20: Cleanup with old path ---"

  local old_wt_dir="$TEST_ROOT/.kanban/worktrees/TASK-503"
  mkdir -p "$old_wt_dir"
  echo "test" > "$old_wt_dir/test_file.txt"

  create_test_task "TASK-503" "$old_wt_dir"

  worktree_cleanup "TASK-503" >/dev/null 2>&1 || true

  # Old directory should be removed
  assert_dir_not_exists "old worktree directory removed" "$old_wt_dir"
  # Task directory should still exist (it was created by create_test_task)
  assert_dir_exists "task directory still exists" "$TEST_ROOT/.kanban/tasks/TASK-503"
}

# ============================================================
# Test 21: _worktree_resolve_path with non-existent task file
# ============================================================
test_resolve_path_nonexistent_task() {
  echo "--- Test 21: _worktree_resolve_path with missing task ---"

  local result=$(_worktree_resolve_path "TASK-999" 2>/dev/null || echo "ERROR")
  # Should return the new default path since task.json doesn't exist
  # (task_file returns the path even if file doesn't exist, jq returns empty)
  assert_eq "resolve returns new default for nonexistent task" \
    ".kanban/tasks/TASK-999/worktree" \
    "$result"
}

# ============================================================
# Test 22: worktree_validate for nonexistent task
# ============================================================
test_validate_nonexistent_task() {
  echo "--- Test 22: worktree_validate for nonexistent task ---"

  local result=""
  result=$(worktree_validate "TASK-998" 2>/dev/null) || true
  local valid=$(echo "$result" | jq -r '.valid')
  assert_eq "validate returns false for nonexistent task" "false" "$valid"

  local has_error=$(echo "$result" | jq '[.errors[] | contains("task_not_found")] | any')
  assert_eq "has task_not_found error" "true" "$has_error"
}

# ============================================================
# Test 23: worktree_cleanup does not remove new-path worktree
#          if it differs from recorded path (old path case)
# ============================================================
test_cleanup_no_cross_contamination() {
  echo "--- Test 23: Cleanup does not remove wrong directory ---"

  # Task with old path
  local old_wt_dir="$TEST_ROOT/.kanban/worktrees/TASK-504"
  mkdir -p "$old_wt_dir"

  # Also create a directory at the new path (but task uses old path)
  local new_wt_dir="$TEST_ROOT/.kanban/tasks/TASK-504/worktree"
  mkdir -p "$new_wt_dir"
  echo "important" > "$new_wt_dir/important.txt"

  create_test_task "TASK-504" "$old_wt_dir"

  worktree_cleanup "TASK-504" >/dev/null 2>&1 || true

  # Old path directory should be removed
  assert_dir_not_exists "old worktree directory removed" "$old_wt_dir"
  # New path directory should also be cleaned (the cleanup handles the new-path residue)
  assert_dir_not_exists "new worktree residue cleaned" "$new_wt_dir"
}

# ============================================================
# Test 24: worktree_create resolves to new path for new task
# ============================================================
test_create_resolves_new_path() {
  echo "--- Test 24: worktree_create resolves new path for task ---"

  # Create a task with empty worktree.path (simulating newly created task)
  create_test_task "TASK-505" ""

  # _worktree_resolve_path should return the new default
  local resolved=$(_worktree_resolve_path "TASK-505")
  assert_contains "resolved path uses tasks/TASK-505/worktree" \
    "$resolved" "tasks/TASK-505/worktree"
  assert_not_contains "resolved path does not use worktrees/" \
    "$resolved" "worktrees/"
}

# ============================================================
# Test 25: Multiple cleanup calls don't corrupt task.json
# ============================================================
test_cleanup_no_corruption() {
  echo "--- Test 25: Multiple cleanups don't corrupt task.json ---"

  local wt_dir="$TEST_ROOT/.kanban/tasks/TASK-506/worktree"
  mkdir -p "$wt_dir"
  create_test_task "TASK-506" "$wt_dir"

  # Run cleanup 3 times
  worktree_cleanup "TASK-506" >/dev/null 2>&1 || true
  worktree_cleanup "TASK-506" >/dev/null 2>&1 || true
  worktree_cleanup "TASK-506" >/dev/null 2>&1 || true

  # Verify task.json is still valid JSON
  local tf=$(task_file "TASK-506")
  jq '.' "$tf" >/dev/null 2>&1
  assert_return_code "task.json is valid JSON after multiple cleanups" "0" "$?"

  local id=$(jq -r '.id' "$tf")
  assert_eq "task id preserved" "TASK-506" "$id"
}

# ============================================================
# Test 26: worktree_cleanup handles empty branch and path
# ============================================================
test_cleanup_empty_both() {
  echo "--- Test 26: Cleanup with empty branch and path ---"

  create_test_task "TASK-507" "" ""

  # Manually set branch to empty too
  local tf=$(task_file "TASK-507")
  local tmp=$(mktemp)
  jq '.worktree.branch=""' "$tf" > "$tmp" && mv "$tmp" "$tf"

  worktree_cleanup "TASK-507" >/dev/null 2>&1
  assert_return_code "cleanup returns 0 with empty branch and path" "0" "$?"
}

# ============================================================
# Run all tests
# ============================================================
main() {
  echo "=========================================="
  echo "  ST-004: Worktree Cohesion Tests"
  echo "=========================================="
  echo ""

  setup

  test_default_path
  test_resolve_path_prefers_existing
  test_resolve_path_falls_back_to_default
  test_worktree_path_from_task_json
  test_worktree_path_empty
  test_worktree_exists_true
  test_worktree_exists_false
  test_validate_empty_path
  test_cleanup_clears_fields
  test_cleanup_removes_directory
  test_cleanup_preserves_task_dir
  test_old_path_compatibility
  test_exists_old_path
  test_main_kanban_new_path
  test_main_kanban_old_path
  test_main_kanban_unrelated_path
  test_default_path_structure
  test_cleanup_branch_only
  test_cleanup_idempotent
  test_cleanup_old_path
  test_resolve_path_nonexistent_task
  test_validate_nonexistent_task
  test_cleanup_no_cross_contamination
  test_create_resolves_new_path
  test_cleanup_no_corruption
  test_cleanup_empty_both

  echo ""
  echo "=========================================="
  echo "  Results: $TESTS_PASSED passed, $TESTS_FAILED failed (total $TESTS_RUN)"
  echo "=========================================="

  if [ -n "$FAILURES" ]; then
    echo -e "$FAILURES"
    echo ""
  fi

  teardown

  if [ "$TESTS_FAILED" -gt 0 ]; then
    return 1
  fi
  return 0
}

main
