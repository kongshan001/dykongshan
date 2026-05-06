#!/usr/bin/env bash
# test_subtask_commit.sh -- Tests for ST-006: Subtask progress tracking and git commit
# Covers: kanban_subtask_start, kanban_subtask_done, kanban_progress_from_json
#   progress.json creation, git commit on subtask completion, progress display
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Track test results
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected: '$expected'"
    echo "    actual:   '$actual'"
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
    echo "    string: '$haystack'"
    echo "    not found: '$needle'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_file_exists() {
  local label="$1" filepath="$2"
  if [ -f "$filepath" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    file not found: '$filepath'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_true() {
  local label="$1" actual="$2"
  if [ "$actual" = "0" ] || [ "$actual" = "true" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected true, got: '$actual'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# === Setup ===
echo ""
echo "=== test_subtask_commit.sh ==="
echo ""

# Syntax check on the kanban.sh file
echo "--- Syntax checks ---"
bash -n "$SKILL_DIR/lib/kanban.sh" && echo "  PASS: kanban.sh syntax OK" || { echo "  FAIL: kanban.sh syntax error"; exit 1; }

# Create isolated test environment
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

# Set up KANBAN_DIR and SKILL_DIR for isolated testing
KANBAN_DIR="$TEST_TMPDIR/.kanban"
mkdir -p "$KANBAN_DIR/tasks" "$KANBAN_DIR/config.json.tmp"

# Create config.json
cat > "$KANBAN_DIR/config.json" << 'CFG'
{"output_dir": "src", "project": "test-project", "trunk": "main"}
CFG

# Create a fake git repo to simulate worktree
GIT_REPO="$TEST_TMPDIR/worktree_fake"
mkdir -p "$GIT_REPO"
cd "$GIT_REPO"
git init >/dev/null 2>&1
git config user.email "test@test.com"
git config user.name "Test User"
# Create initial commit so HEAD exists
touch .gitkeep
git add .gitkeep && git commit -m "initial" >/dev/null 2>&1

# Create task directory
TASK_ID="TEST-098"
TASK_DIR="$KANBAN_DIR/tasks/$TASK_ID"
mkdir -p "$TASK_DIR"

# Create task.json with subtasks and worktree
cat > "$TASK_DIR/task.json" << TJSON
{
  "id": "$TASK_ID",
  "title": "Test task for subtask commit",
  "description": "Testing ST-006 subtask progress tracking",
  "status": "executing",
  "phase": "execute",
  "iteration": 1,
  "worktree": {
    "branch": "feature/$TASK_ID",
    "path": "$GIT_REPO",
    "base": "main"
  },
  "task_breakdown": {
    "file": "",
    "subtasks": [
      {"id": "ST-001", "title": "First subtask", "status": "pending"},
      {"id": "ST-002", "title": "Second subtask", "status": "pending"},
      {"id": "ST-003", "title": "Third subtask with special chars: let's test", "status": "pending"}
    ]
  }
}
TJSON

# Define helpers in our test scope
task_file() {
  echo "$KANBAN_DIR/tasks/$1/task.json"
}

# =====================================================================
# Test 1: kanban_subtask_start creates progress.json and records start
# =====================================================================
echo ""
echo "--- Test 1: kanban_subtask_start ---"

# We need to source the kanban.sh functions. Let's eval just the ones we need.
# Extract and eval the progress functions from kanban.sh
eval "$(sed -n '/^_progress_file()/,/^}/p' "$SKILL_DIR/lib/kanban.sh")"
eval "$(sed -n '/^_update_progress_percentage()/,/^}/p' "$SKILL_DIR/lib/kanban.sh")"
eval "$(sed -n '/^kanban_subtask_start()/,/^}/p' "$SKILL_DIR/lib/kanban.sh")"
eval "$(sed -n '/^kanban_subtask_done()/,/^}/p' "$SKILL_DIR/lib/kanban.sh")"
eval "$(sed -n '/^kanban_progress_from_json()/,/^}/p' "$SKILL_DIR/lib/kanban.sh")"

# Run kanban_subtask_start
result=$(kanban_subtask_start "$TASK_ID" "ST-001" 2>&1)
ret=$?
assert_true "kanban_subtask_start succeeds" "$ret"
assert_contains "subtask_start output mentions ST-001" "$result" "ST-001"

# Verify progress.json was created
PF="$KANBAN_DIR/tasks/$TASK_ID/progress.json"
assert_file_exists "progress.json created" "$PF"

# Verify content
p_task_id=$(jq -r '.task_id' "$PF")
assert_eq "progress.json has correct task_id" "$TASK_ID" "$p_task_id"

subtask_status=$(jq -r '.subtasks[0].status' "$PF")
assert_eq "ST-001 status is in_progress" "in_progress" "$subtask_status"

started_at=$(jq -r '.subtasks[0].started_at' "$PF")
assert_contains "started_at is set" "$started_at" "T"

pct=$(jq -r '.completion_percentage' "$PF")
assert_eq "completion_percentage is 0" "0" "$pct"

# =====================================================================
# Test 2: kanban_subtask_start is idempotent
# =====================================================================
echo ""
echo "--- Test 2: kanban_subtask_start idempotent ---"

# Call start again for ST-001
kanban_subtask_start "$TASK_ID" "ST-001" 2>/dev/null
subtask_count=$(jq '.subtasks | length' "$PF")
assert_eq "still only 1 subtask entry after double start" "1" "$subtask_count"
assert_eq "status still in_progress" "in_progress" "$(jq -r '.subtasks[0].status' "$PF")"

# =====================================================================
# Test 3: kanban_subtask_done updates status and triggers git commit
# =====================================================================
echo ""
echo "--- Test 3: kanban_subtask_done with git commit ---"

# Create some files in the worktree to simulate work done
cd "$GIT_REPO"
echo "test content" > test_file.txt
echo "another file" > another_file.txt
cd "$TEST_TMPDIR"

result=$(kanban_subtask_done "$TASK_ID" "ST-001" 2>&1)
ret=$?
assert_true "kanban_subtask_done succeeds" "$ret"
assert_contains "subtask_done output mentions ST-001" "$result" "ST-001"
assert_contains "subtask_done output mentions completed" "$result" "completed"

# Verify progress.json updated
subtask_status=$(jq -r '.subtasks[0].status' "$PF")
assert_eq "ST-001 status is completed" "completed" "$subtask_status"

completed_at=$(jq -r '.subtasks[0].completed_at' "$PF")
assert_contains "completed_at is set" "$completed_at" "T"

commit_hash=$(jq -r '.subtasks[0].commit_hash' "$PF")
assert_contains "commit_hash is set" "$commit_hash" ""

files_count=$(jq '.subtasks[0].files_changed | length' "$PF")
assert_true "files_changed has entries" "$([ "$files_count" -gt 0 ] && echo true || echo false)"

pct=$(jq -r '.completion_percentage' "$PF")
assert_eq "completion_percentage is 100" "100" "$pct"

# =====================================================================
# Test 4: kanban_subtask_done with no changed files (no commit)
# =====================================================================
echo ""
echo "--- Test 4: kanban_subtask_done with no changes ---"

# Start ST-002 (no file changes this time)
kanban_subtask_start "$TASK_ID" "ST-002" 2>/dev/null

result=$(kanban_subtask_done "$TASK_ID" "ST-002" 2>&1)
ret=$?
assert_true "kanban_subtask_done (no changes) succeeds" "$ret"

# ST-002 should be completed with empty commit
st2_status=$(jq -r '.subtasks[1].status' "$PF")
assert_eq "ST-002 status is completed" "completed" "$st2_status"

st2_commit=$(jq -r '.subtasks[1].commit_hash' "$PF")
# commit_hash should be empty string since no changes
assert_eq "ST-002 commit_hash is empty (no changes)" "" "$st2_commit"

# =====================================================================
# Test 5: kanban_progress_from_json displays progress
# =====================================================================
echo ""
echo "--- Test 5: kanban_progress_from_json ---"

result=$(kanban_progress_from_json "$TASK_ID" 2>&1)
ret=$?
assert_true "kanban_progress_from_json succeeds" "$ret"
assert_contains "progress output shows task_id" "$result" "$TASK_ID"
assert_contains "progress output shows ST-001" "$result" "ST-001"
assert_contains "progress output shows ST-002" "$result" "ST-002"
assert_contains "progress output shows progress ratio" "$result" "subtasks completed"
assert_contains "progress output shows done" "$result" "[done]"

# =====================================================================
# Test 6: kanban_progress_from_json with no progress.json
# =====================================================================
echo ""
echo "--- Test 6: kanban_progress_from_json with no progress.json ---"

TASK_NO_PROGRESS="TEST-099"
mkdir -p "$KANBAN_DIR/tasks/$TASK_NO_PROGRESS"
result=$(kanban_progress_from_json "$TASK_NO_PROGRESS" 2>&1)
ret=$?
assert_true "kanban_progress_from_json (no file) succeeds" "$ret"
assert_contains "no progress.json message shown" "$result" "No progress.json"

# =====================================================================
# Test 7: Multiple subtasks, progress percentage
# =====================================================================
echo ""
echo "--- Test 7: Multiple subtasks progress percentage ---"

# Start ST-003
kanban_subtask_start "$TASK_ID" "ST-003" 2>/dev/null
assert_eq "ST-003 status is in_progress" "in_progress" "$(jq -r '.subtasks[2].status' "$PF")"

# Total 3 subtasks, 2 completed, 1 in progress
pct=$(jq -r '.completion_percentage' "$PF")
assert_eq "completion_percentage is 66 (2/3)" "66" "$pct"

# Complete ST-003
cd "$GIT_REPO"
echo "ST-003 work" > st003_file.txt
cd "$TEST_TMPDIR"

kanban_subtask_done "$TASK_ID" "ST-003" 2>/dev/null
pct=$(jq -r '.completion_percentage' "$PF")
assert_eq "completion_percentage is 100 (3/3)" "100" "$pct"

# =====================================================================
# Test 8: Commit message format
# =====================================================================
echo ""
echo "--- Test 8: Commit message format ---"

cd "$GIT_REPO"
last_commit_msg=$(git log -1 --format=%s 2>/dev/null)
assert_contains "last commit has feat prefix" "$last_commit_msg" "feat"
assert_contains "last commit has subtask ID" "$last_commit_msg" "ST-003"
assert_contains "last commit has task ID" "$last_commit_msg" "TEST-098"

# Verify first commit for ST-001
second_last_msg=$(git log --skip=1 -1 --format=%s 2>/dev/null)
assert_contains "second last commit for ST-001" "$second_last_msg" "feat(ST-001)"

cd "$TEST_TMPDIR"

# =====================================================================
# Test 9: kanban_subtask_start for new subtask not in progress.json
# =====================================================================
echo ""
echo "--- Test 9: kanban_subtask_start for new subtask ---"

# Remove progress.json and test fresh start
rm -f "$PF"
kanban_subtask_start "$TASK_ID" "ST-004" 2>/dev/null
assert_file_exists "progress.json recreated after start" "$PF"

st4_status=$(jq -r '.subtasks[0].status' "$PF")
assert_eq "ST-004 status is in_progress" "in_progress" "$st4_status"

st4_id=$(jq -r '.subtasks[0].id' "$PF")
assert_eq "ST-004 id is correct" "ST-004" "$st4_id"

# =====================================================================
# Summary
# =====================================================================
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
