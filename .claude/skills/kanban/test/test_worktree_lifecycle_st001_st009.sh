#!/usr/bin/env bash
# test_worktree_lifecycle_st001_st009.sh -- Tests for ST-001~ST-009
# Worktree lifecycle fixes, guard checks, archive tolerance, gitignore
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

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -q "$needle"; then
    echo "  FAIL: $label"
    echo "    string: $haystack"
    echo "    should not contain: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_file_contains() {
  local label="$1" filepath="$2" needle="$3"
  if grep -qF "$needle" "$filepath" 2>/dev/null; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    file: $filepath"
    echo "    not found: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_exit_code() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected exit: $expected"
    echo "    actual exit:   $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Create a fresh, isolated temp KANBAN_DIR for each test
setup() {
  _TEST_TMPDIR=$(mktemp -d)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch,worktrees}
  jq -n '{project:"test",trunk:"main",output_dir:"src"}' > "$_TEST_KANBAN_DIR/config.json"
  jq -n '{project:"test",trunk:"main",tasks:[]}' > "$_TEST_KANBAN_DIR/index.json"
  # Initialize git repo in tmpdir for worktree tests
  cd "$_TEST_TMPDIR"
  git init -q 2>/dev/null || true
  git config user.email "test@test.com" 2>/dev/null || true
  git config user.name "Test" 2>/dev/null || true
  echo "init" > README.md 2>/dev/null
  git add . 2>/dev/null || true
  git commit -m "init" -q 2>/dev/null || true
}

teardown() {
  if [ -n "$_TEST_TMPDIR" ] && [ -d "$_TEST_TMPDIR" ]; then
    cd /
    rm -rf "$_TEST_TMPDIR"
  fi
}

# Source the library with KANBAN_DIR overridden
# We source each lib individually and override KANBAN_DIR after each one,
# because kanban.sh derives SKILL_DIR from $0 which is wrong in test context.
source_lib() {
  _KANBAN_CORE_LOADED=""
  KANBAN_DIR="$_TEST_KANBAN_DIR"

  # Source each lib, overriding KANBAN_DIR after each
  for lib in "$LIB_DIR"/*.sh; do
    set +e
    source "$lib"
    set -e
    KANBAN_DIR="$_TEST_KANBAN_DIR"
  done

  SKILL_DIR="$LIB_DIR/.."
}

# Helper: create a dummy task JSON
create_test_task() {
  local task_id="${1:-TASK-100}"
  local task_file="$KANBAN_DIR/tasks/${task_id}.json"
  local now=$(date -u +%FT%TZ)
  jq -n --arg id "$task_id" --arg now "$now" '{
    id: $id,
    title: "Test task",
    description: "for testing",
    engine: "claude-code",
    status: "pending",
    phase: null,
    phase_lock: null,
    assignee: null,
    worktree: { branch: "", path: "", base: "main" },
    iteration: 0,
    max_iterations: 6,
    token_budget: 500000,
    token_used: 0,
    scores: {},
    depends_on: [],
    modified_files: [],
    task_breakdown: { file: "", subtasks: [] },
    history: [],
    user_decision: null,
    requires_archive_confirmation: false,
    created_at: $now,
    updated_at: $now,
    entered_at: null
  }' > "$task_file"
  echo "$task_id"
}

# ============================================================
# ST-001: worktree_cleanup clears task JSON fields
# ============================================================

test_cleanup_clears_json_fields() {
  echo "--- test_cleanup_clears_json_fields (ST-001) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-100")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Set worktree fields
  local tmp=$(mktemp)
  jq '.worktree.path="/tmp/fake_wt" | .worktree.branch="feature/TASK-100"' "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  # Cleanup (worktree dir doesn't actually exist, but that's OK -- fields should still be cleared)
  worktree_cleanup "$tid" >/dev/null 2>&1

  local path_val=$(jq -r '.worktree.path' "$task_file")
  local branch_val=$(jq -r '.worktree.branch' "$task_file")
  assert_eq "path cleared" "" "$path_val"
  assert_eq "branch cleared" "" "$branch_val"
}

test_cleanup_noop_when_no_worktree() {
  echo "--- test_cleanup_noop_when_no_worktree (ST-001) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-101")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Cleanup with empty worktree fields should be noop
  worktree_cleanup "$tid" >/dev/null 2>&1
  # Task file should still exist
  assert_eq "task file exists" "1" "$([ -f "$task_file" ] && echo 1 || echo 0)"
}

# ============================================================
# ST-002: worktree_merge tolerates missing worktree
# ============================================================

test_merge_warns_already_merged() {
  echo "--- test_merge_warns_already_merged (ST-002) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-200")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a branch and merge it into main using normal merge (not squash)
  # so that git branch --merged correctly detects it
  git checkout -b "feature/TASK-200" -q 2>/dev/null
  echo "change" > change.txt
  git add change.txt 2>/dev/null
  git commit -m "change" -q 2>/dev/null
  git checkout main -q 2>/dev/null
  git merge "feature/TASK-200" -q 2>/dev/null

  # Set worktree fields to point at non-existent directory
  local tmp=$(mktemp)
  jq '.worktree.path="/nonexistent/path" | .worktree.branch="feature/TASK-200"' "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local output
  output=$(worktree_merge "$tid" 2>&1) || true
  assert_contains "already merged warning" "$output" "already merged"
}

test_merge_errors_unmerged_branch() {
  echo "--- test_merge_errors_unmerged_branch (ST-002) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-201")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a branch but do NOT merge it
  git checkout -b "feature/TASK-201" -q 2>/dev/null
  echo "change" > change2.txt
  git add change2.txt 2>/dev/null
  git commit -m "unmerged change" -q 2>/dev/null
  git checkout main -q 2>/dev/null

  # Set worktree fields to point at non-existent directory
  local tmp=$(mktemp)
  jq '.worktree.path="/nonexistent/path" | .worktree.branch="feature/TASK-201"' "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local output exit_code
  set +e
  output=$(worktree_merge "$tid" 2>&1)
  exit_code=$?
  set -e
  assert_contains "error message" "$output" "not merged"
  assert_exit_code "returns error" "1" "$exit_code"
}

test_merge_warns_no_branch() {
  echo "--- test_merge_warns_no_branch (ST-002) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-202")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Both worktree.path and worktree.branch are empty
  local output exit_code
  set +e
  output=$(worktree_merge "$tid" 2>&1)
  exit_code=$?
  set -e
  assert_contains "no branch warning" "$output" "no branch recorded"
  assert_exit_code "returns success" "0" "$exit_code"
}

# ============================================================
# ST-003: guard_check worktree_exists check
# ============================================================

test_guard_blocks_missing_worktree() {
  echo "--- test_guard_blocks_missing_worktree (ST-003) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-300")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Set phase_lock to "plan" so we can transition to "execute"
  # Also set iteration to 1 so guard_check_artifacts looks in iteration-1/
  local tmp=$(mktemp)
  jq '.phase_lock="plan" | .phase="plan" | .iteration=1' "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  # Create plan artifacts so artifact guard passes
  local report_dir="$KANBAN_DIR/reports/${tid}/iteration-1"
  mkdir -p "$report_dir"
  echo "# Requirements" > "$report_dir/requirements.md"
  echo '{"subtasks":[]}' > "$report_dir/task_breakdown.json"

  local result
  set +e
  result=$(guard_check "$tid" "plan" "execute" 2>&1)
  set -e
  assert_contains "blocks missing worktree" "$result" "FAIL:worktree_not_found"
}

test_guard_passes_valid_worktree() {
  echo "--- test_guard_passes_valid_worktree (ST-003) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-301")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a real git worktree
  local wt_dir="$_TEST_TMPDIR/.kanban/worktrees/${tid}"
  git worktree add "$wt_dir" -b "feature/TASK-301" HEAD 2>/dev/null

  # Set phase_lock, worktree path, and iteration
  local tmp=$(mktemp)
  jq --arg p "$wt_dir" '.phase_lock="plan" | .phase="plan" | .iteration=1 | .worktree.path=$p | .worktree.branch="feature/TASK-301"' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  # Create plan artifacts
  local report_dir="$KANBAN_DIR/reports/${tid}/iteration-1"
  mkdir -p "$report_dir"
  echo "# Requirements" > "$report_dir/requirements.md"
  echo '{"subtasks":[]}' > "$report_dir/task_breakdown.json"

  local result
  set +e
  result=$(guard_check "$tid" "plan" "execute" 2>&1)
  set -e
  assert_contains "guard passes" "$result" "PASS"

  # Cleanup the worktree
  git worktree remove "$wt_dir" --force 2>/dev/null || true
  git branch -D "feature/TASK-301" 2>/dev/null || true
}

# ============================================================
# ST-004: worktree_validate
# ============================================================

test_validate_missing_task() {
  echo "--- test_validate_missing_task (ST-004) ---"
  setup
  source_lib

  local result exit_code
  set +e
  result=$(worktree_validate "TASK-999" 2>&1)
  exit_code=$?
  set -e
  assert_contains "task_not_found error" "$result" "task_not_found"
  assert_contains "valid false" "$result" "valid.*false"
  assert_exit_code "returns 1" "1" "$exit_code"
}

test_validate_empty_path() {
  echo "--- test_validate_empty_path (ST-004) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-400")

  local result exit_code
  set +e
  result=$(worktree_validate "$tid" 2>&1)
  exit_code=$?
  set -e
  assert_contains "worktree_path_empty error" "$result" "worktree_path_empty"
  assert_contains "valid false" "$result" "valid.*false"
  assert_exit_code "returns 1" "1" "$exit_code"
}

test_validate_nonexistent_directory() {
  echo "--- test_validate_nonexistent_directory (ST-004) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-401")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Set path to nonexistent dir
  local tmp=$(mktemp)
  jq '.worktree.path="/nonexistent/dir" | .worktree.branch="feature/TASK-401"' "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local result exit_code
  set +e
  result=$(worktree_validate "$tid" 2>&1)
  exit_code=$?
  set -e
  assert_contains "directory_not_found error" "$result" "directory_not_found"
  assert_exit_code "returns 1" "1" "$exit_code"
}

test_validate_valid_worktree() {
  echo "--- test_validate_valid_worktree (ST-004) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-402")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a real git worktree
  local wt_dir="$_TEST_TMPDIR/.kanban/worktrees/${tid}"
  git worktree add "$wt_dir" -b "feature/TASK-402" HEAD 2>/dev/null

  local tmp=$(mktemp)
  jq --arg p "$wt_dir" '.worktree.path=$p | .worktree.branch="feature/TASK-402"' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local result exit_code
  set +e
  result=$(worktree_validate "$tid" 2>&1)
  exit_code=$?
  set -e
  assert_contains "valid true" "$result" "valid.*true"
  assert_exit_code "returns 0" "0" "$exit_code"

  # Cleanup
  git worktree remove "$wt_dir" --force 2>/dev/null || true
  git branch -D "feature/TASK-402" 2>/dev/null || true
}

test_validate_branch_mismatch_warning() {
  echo "--- test_validate_branch_mismatch_warning (ST-004) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-403")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a real git worktree
  local wt_dir="$_TEST_TMPDIR/.kanban/worktrees/${tid}"
  git worktree add "$wt_dir" -b "feature/TASK-403" HEAD 2>/dev/null

  # Set branch to a DIFFERENT name
  local tmp=$(mktemp)
  jq --arg p "$wt_dir" '.worktree.path=$p | .worktree.branch="wrong-branch"' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local result exit_code
  set +e
  result=$(worktree_validate "$tid" 2>&1)
  exit_code=$?
  set -e
  assert_contains "branch_mismatch warning" "$result" "branch_mismatch"
  # Should still be valid (mismatch is a warning, not error)
  assert_contains "valid true" "$result" "valid.*true"
  assert_exit_code "returns 0" "0" "$exit_code"

  # Cleanup
  git worktree remove "$wt_dir" --force 2>/dev/null || true
  git branch -D "feature/TASK-403" 2>/dev/null || true
}

# ============================================================
# ST-005: worktree_create idempotency
# ============================================================

test_create_idempotent() {
  echo "--- test_create_idempotent (ST-005) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-500")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a real git worktree manually first
  local wt_dir="$_TEST_TMPDIR/.kanban/worktrees/${tid}"
  git worktree add "$wt_dir" -b "feature/TASK-500" HEAD 2>/dev/null

  local tmp=$(mktemp)
  jq --arg p "$wt_dir" '.worktree.path=$p | .worktree.branch="feature/TASK-500"' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  # Calling worktree_create again should skip
  local output
  output=$(worktree_create "$tid" "feature/TASK-500" 2>&1)
  assert_contains "already exists" "$output" "already exists"

  # Cleanup
  git worktree remove "$wt_dir" --force 2>/dev/null || true
  git branch -D "feature/TASK-500" 2>/dev/null || true
}

test_create_new_worktree() {
  echo "--- test_create_new_worktree (ST-005) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-501")

  local output exit_code
  set +e
  output=$(worktree_create "$tid" "feature/TASK-501" 2>&1)
  exit_code=$?
  set -e
  assert_contains "created" "$output" "Created worktree"
  assert_exit_code "returns 0" "0" "$exit_code"

  # Cleanup
  local wt_dir=$(jq -r '.worktree.path // ""' "$KANBAN_DIR/tasks/${tid}.json")
  if [ -n "$wt_dir" ] && [ -d "$wt_dir" ]; then
    git worktree remove "$wt_dir" --force 2>/dev/null || true
  fi
  git branch -D "feature/TASK-501" 2>/dev/null || true
}

# ============================================================
# ST-007: kanban_archive_task worktree tolerance
# ============================================================

test_archive_skips_merge_when_no_worktree() {
  echo "--- test_archive_skips_merge_when_no_worktree (ST-007) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-700")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Set user_decision to allow archive
  local tmp=$(mktemp)
  jq '.user_decision={action:"approve_and_archive",decided_at:"2025-01-01T00:00:00Z"} | .worktree.branch="feature/TASK-700"' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local output
  set +e
  output=$(kanban_archive_task "$tid" 2>&1)
  set -e
  assert_contains "archived" "$output" "Archived $tid"
  # Should warn about skipping merge
  assert_contains "skip warning" "$output" "skipping merge"

  # Task file should be in archive (support both old flat-file and new directory formats)
  local archived=0
  [ -f "$KANBAN_DIR/archive/${tid}.json" ] && archived=1
  [ -f "$KANBAN_DIR/archive/${tid}/task.json" ] && archived=1
  assert_eq "archived file exists" "1" "$archived"
}

test_archive_with_worktree_present() {
  echo "--- test_archive_with_worktree_present (ST-007) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-701")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a real worktree with a commit
  local wt_dir="$_TEST_TMPDIR/.kanban/worktrees/${tid}"
  git worktree add "$wt_dir" -b "feature/TASK-701" HEAD 2>/dev/null

  local tmp=$(mktemp)
  jq --arg p "$wt_dir" '.worktree.path=$p | .worktree.branch="feature/TASK-701" | .user_decision={action:"approve_and_archive",decided_at:"2025-01-01T00:00:00Z"}' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  # Make a change in the worktree
  echo "new content" > "$wt_dir/newfile.txt"
  cd "$wt_dir" && git add newfile.txt && git commit -m "test change" -q 2>/dev/null
  cd "$_TEST_TMPDIR"

  local output
  set +e
  output=$(kanban_archive_task "$tid" 2>&1)
  set -e
  assert_contains "archived" "$output" "Archived $tid"

  # Task file should be in archive (support both old flat-file and new directory formats)
  local archived2=0
  [ -f "$KANBAN_DIR/archive/${tid}.json" ] && archived2=1
  [ -f "$KANBAN_DIR/archive/${tid}/task.json" ] && archived2=1
  assert_eq "archived file exists" "1" "$archived2"
}

test_archive_clears_residual_worktree_fields() {
  echo "--- test_archive_clears_residual_worktree_fields (ST-007) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-702")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Set worktree fields but don't create actual worktree
  local tmp=$(mktemp)
  jq '.user_decision={action:"approve_and_archive",decided_at:"2025-01-01T00:00:00Z"} | .worktree.path="/nonexistent" | .worktree.branch="feature/TASK-702"' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  kanban_archive_task "$tid" >/dev/null 2>&1

  # Archived task should have empty worktree fields
  local archived_file="$KANBAN_DIR/archive/${tid}.json"
  local path_val=$(jq -r '.worktree.path' "$archived_file")
  local branch_val=$(jq -r '.worktree.branch' "$archived_file")
  assert_eq "path cleared in archive" "" "$path_val"
  assert_eq "branch cleared in archive" "" "$branch_val"
}

# ============================================================
# ST-008: recovery validates worktree
# ============================================================

test_recovery_warns_invalid_worktree() {
  echo "--- test_recovery_warns_invalid_worktree (ST-008) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-800")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Set up a task that was executing with a non-existent worktree
  local tmp=$(mktemp)
  jq '.status="executing" | .phase_lock="execute" | .phase="execute" | .worktree.path="/nonexistent" | .worktree.branch="feature/TASK-800" |
    .history=[{"phase":"plan","status":"completed"},{"phase":"execute","status":"completed"}]' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local output
  output=$(recover_task "$tid" 2>&1)
  assert_contains "worktree validation failed" "$output" "worktree validation failed"
  assert_contains "recovery options" "$output" "Options:"
}

test_recovery_ok_with_valid_worktree() {
  echo "--- test_recovery_ok_with_valid_worktree (ST-008) ---"
  setup
  source_lib

  local tid=$(create_test_task "TASK-801")
  local task_file="$KANBAN_DIR/tasks/${tid}.json"

  # Create a real worktree
  local wt_dir="$_TEST_TMPDIR/.kanban/worktrees/${tid}"
  git worktree add "$wt_dir" -b "feature/TASK-801" HEAD 2>/dev/null

  local tmp=$(mktemp)
  jq --arg p "$wt_dir" '.status="executing" | .phase_lock="execute" | .phase="execute" | .worktree.path=$p | .worktree.branch="feature/TASK-801" |
    .history=[{"phase":"plan","status":"completed"},{"phase":"execute","status":"completed"}]' \
    "$task_file" > "$tmp" && mv "$tmp" "$task_file"

  local output
  output=$(recover_task "$tid" 2>&1)
  assert_contains "worktree validated OK" "$output" "Worktree validated OK"
  assert_not_contains "no warning" "$output" "worktree validation failed"

  # Cleanup
  git worktree remove "$wt_dir" --force 2>/dev/null || true
  git branch -D "feature/TASK-801" 2>/dev/null || true
}

# ============================================================
# ST-009: .gitignore verification
# ============================================================

test_gitignore_ignores_runtime_dirs() {
  echo "--- test_gitignore_ignores_runtime_dirs (ST-009) ---"
  # Read the .gitignore from the worktree
  local gitignore="$SKILL_DIR/../../../../.gitignore"
  # Fall back: check the actual worktree .gitignore
  if [ ! -f "$gitignore" ]; then
    gitignore="/Users/ks_128/Documents/important_demo/.kanban/worktrees/TASK-016/.gitignore"
  fi

  assert_file_contains "ignores .kanban/archive/" "$gitignore" ".kanban/archive/"
  assert_file_contains "ignores .kanban/reports/" "$gitignore" ".kanban/reports/"
  assert_file_contains "ignores .kanban/dispatch/" "$gitignore" ".kanban/dispatch/"
  assert_file_contains "ignores .kanban/worktrees/" "$gitignore" ".kanban/worktrees/"
  assert_file_contains "ignores .kanban/dashboard/" "$gitignore" ".kanban/dashboard/"
  assert_file_contains "ignores .kanban/*.pid" "$gitignore" ".kanban/*.pid"
  assert_file_contains "ignores .kanban/*.log" "$gitignore" ".kanban/*.log"
}

test_gitignore_preserves_config_files() {
  echo "--- test_gitignore_preserves_config_files (ST-009) ---"
  local gitignore="$SKILL_DIR/../../../../.gitignore"
  if [ ! -f "$gitignore" ]; then
    gitignore="/Users/ks_128/Documents/important_demo/.kanban/worktrees/TASK-016/.gitignore"
  fi

  # Config files should NOT be ignored -- verify they are not in the ignore list (excluding comments)
  local content
  content=$(grep -v '^#' "$gitignore" | grep -v '^$')

  # config.json, workflow.json, index.json, knowledge-log.md should NOT be listed as ignored
  if echo "$content" | grep -q "\.kanban/config\.json"; then
    echo "  FAIL: .kanban/config.json should NOT be ignored"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: .kanban/config.json is not ignored"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))

  if echo "$content" | grep -q "\.kanban/workflow\.json"; then
    echo "  FAIL: .kanban/workflow.json should NOT be ignored"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: .kanban/workflow.json is not ignored"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# ============================================================
# Run all tests
# ============================================================
echo "========================================="
echo "Running ST-001~ST-009 Worktree Lifecycle Tests"
echo "========================================="
echo ""

test_cleanup_clears_json_fields
teardown
test_cleanup_noop_when_no_worktree
teardown

test_merge_warns_already_merged
teardown
test_merge_errors_unmerged_branch
teardown
test_merge_warns_no_branch
teardown

test_guard_blocks_missing_worktree
teardown
test_guard_passes_valid_worktree
teardown

test_validate_missing_task
teardown
test_validate_empty_path
teardown
test_validate_nonexistent_directory
teardown
test_validate_valid_worktree
teardown
test_validate_branch_mismatch_warning
teardown

test_create_idempotent
teardown
test_create_new_worktree
teardown

test_archive_skips_merge_when_no_worktree
teardown
test_archive_with_worktree_present
teardown
test_archive_clears_residual_worktree_fields
teardown

test_recovery_warns_invalid_worktree
teardown
test_recovery_ok_with_valid_worktree
teardown

test_gitignore_ignores_runtime_dirs
test_gitignore_preserves_config_files

echo ""
echo "========================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_RUN total"
echo "========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
  exit 1
fi
