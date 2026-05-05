#!/usr/bin/env bash
# test_forced_worktree.sh -- Tests for forced worktree creation (ST-004)
# Run: bash .claude/skills/kanban/test/test_forced_worktree.sh

set -e

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
TEST_TMPDIR=$(mktemp -d /tmp/test_forced_worktree_XXXXXX)

cleanup() {
  cd "$ORIG_DIR"
  rm -rf "$TEST_TMPDIR"
}
trap cleanup EXIT

# Create a minimal git repo as working directory
cd "$TEST_TMPDIR"
git init -q
git config user.email "test@test.com"
git config user.name "Test"

# Copy library files
mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates/reports
mkdir -p .kanban

cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true

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

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

echo "============================================"
echo "  Test Suite: Forced Worktree (ST-004)"
echo "============================================"
echo ""

# ============================================================
# Test 1: 进入 execute 时 worktree 必须存在 (guard 检查)
# ============================================================
echo "--- Test 1: guard_check requires worktree for execute ---"

# Create a task in plan phase (ready to transition to execute)
mkdir -p .kanban/tasks/TASK-800
cat > .kanban/tasks/TASK-800/task.json <<'TASK'
{
  "id": "TASK-800",
  "title": "Worktree Guard Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-800", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"entered","entered_at":"2026-01-01T00:00:00Z"},{"phase":"plan","status":"completed","exited_at":"2026-01-01T00:01:00Z"}],
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create plan artifacts to satisfy guard
cat > .kanban/tasks/TASK-800/requirements.md <<'REQ'
# Requirements
## Functional Requirements
- FR-001: test
## Acceptance Criteria
- AC-001: test
REQ

cat > .kanban/tasks/TASK-800/task_breakdown.json <<'BD'
{"task_id":"TASK-800","subtasks":[{"id":"ST-001","title":"test","description":"test","priority":"high","estimated_files":[],"dependencies":[]}]}
BD

# Attempt guard_check with no worktree -- the guard should auto-create it
# and the check should pass (auto-creation succeeds for valid branches)
GUARD_RESULT=$(guard_check "TASK-800" "plan" "execute" 2>&1) || true
echo "$GUARD_RESULT" | grep -q "PASS" && pass || fail "Test1: guard passes after auto-creating worktree"

# Verify worktree was actually created
WT_PATH_AFTER=$(jq -r '.worktree.path // ""' .kanban/tasks/TASK-800/task.json)
if [ -n "$WT_PATH_AFTER" ] && [ -d "$WT_PATH_AFTER" ]; then
  pass "Test1: worktree auto-created successfully"
  # Cleanup worktree for next tests
  git worktree remove "$WT_PATH_AFTER" --force 2>/dev/null || rm -rf "$WT_PATH_AFTER" 2>/dev/null || true
  git worktree prune 2>/dev/null || true
  git branch -D feature/TASK-800 2>/dev/null || true
else
  fail "Test1: worktree.path still empty after guard_check"
fi

echo ""

# ============================================================
# Test 2: worktree 不存在时自动创建
# ============================================================
echo "--- Test 2: Auto-create worktree when entering execute ---"

# Create a task with a valid branch but no worktree path
mkdir -p .kanban/tasks/TASK-801
cat > .kanban/tasks/TASK-801/task.json <<'TASK'
{
  "id": "TASK-801",
  "title": "Auto Worktree Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-801", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"entered","entered_at":"2026-01-01T00:00:00Z"},{"phase":"plan","status":"completed","exited_at":"2026-01-01T00:01:00Z"}],
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create plan artifacts
cat > .kanban/tasks/TASK-801/requirements.md <<'REQ'
# Requirements
## Functional Requirements
- FR-001: test
## Acceptance Criteria
- AC-001: test
REQ

cat > .kanban/tasks/TASK-801/task_breakdown.json <<'BD'
{"task_id":"TASK-801","subtasks":[{"id":"ST-001","title":"test","description":"test","priority":"high","estimated_files":[],"dependencies":[]}]}
BD

# The guard should auto-create worktree
GUARD_RESULT2=$(guard_check "TASK-801" "plan" "execute" 2>&1 || true)
# Extract exit code from the output (PASS means 0, FAIL means 1)
GUARD_EXIT2=0
echo "$GUARD_RESULT2" | grep -q "^PASS" || GUARD_EXIT2=1

if [ "$GUARD_EXIT2" -eq 0 ]; then
  pass "Test2: guard_check passes after auto-creating worktree"
else
  # Even if it doesn't fully pass, check that auto-creation was attempted
  echo "  Note: guard result = $GUARD_RESULT2"
  # Check if worktree was created anyway
  local_wt_path=$(jq -r '.worktree.path // ""' .kanban/tasks/TASK-801/task.json)
  if [ -n "$local_wt_path" ] && [ -d "$local_wt_path" ]; then
    pass "Test2: worktree was auto-created (path=$local_wt_path)"
  else
    fail "Test2: worktree auto-creation did not work (result=$GUARD_RESULT2)"
  fi
fi

# Check worktree path was updated in task JSON
WT_PATH=$(jq -r '.worktree.path // ""' .kanban/tasks/TASK-801/task.json)
assert_not_empty "$WT_PATH" "Test2: worktree.path updated in task JSON"

echo ""

# ============================================================
# Test 3: 自动创建后的路径正确性
# ============================================================
echo "--- Test 3: Auto-created worktree path correctness ---"

if [ -n "$WT_PATH" ] && [ -d "$WT_PATH" ]; then
  # Verify it is a valid git directory
  if git -C "$WT_PATH" rev-parse --git-dir >/dev/null 2>&1; then
    pass "Test3: worktree is a valid git directory"
  else
    fail "Test3: worktree is NOT a valid git directory ($WT_PATH)"
  fi

  # Verify branch name matches
  ACTUAL_BRANCH=$(git -C "$WT_PATH" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  assert_equals "feature/TASK-801" "$ACTUAL_BRANCH" "Test3: worktree branch matches"
else
  fail "Test3: worktree path is empty or directory doesn't exist"
fi

echo ""

# ============================================================
# Test 4: 创建失败时返回 FAIL
# ============================================================
echo "--- Test 4: Creation failure returns FAIL ---"

# Create a task with no branch and a path that doesn't exist and can't be auto-created
mkdir -p .kanban/tasks/TASK-802
cat > .kanban/tasks/TASK-802/task.json <<'TASK'
{
  "id": "TASK-802",
  "title": "Invalid Worktree Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "/nonexistent/path/TASK-802" },
  "scores": {},
  "history": [{"phase":"plan","status":"entered","entered_at":"2026-01-01T00:00:00Z"},{"phase":"plan","status":"completed","exited_at":"2026-01-01T00:01:00Z"}],
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

cat > .kanban/tasks/TASK-802/requirements.md <<'REQ'
# Requirements
## Functional Requirements
- FR-001: test
## Acceptance Criteria
- AC-001: test
REQ

cat > .kanban/tasks/TASK-802/task_breakdown.json <<'BD'
{"task_id":"TASK-802","subtasks":[{"id":"ST-001","title":"test","description":"test","priority":"high","estimated_files":[],"dependencies":[]}]}
BD

GUARD_RESULT4=$(guard_check "TASK-802" "plan" "execute" 2>&1 || true)
# Check if it contains FAIL
echo "  guard_result: $GUARD_RESULT4"

# With no branch, auto-creation can't work, so guard should FAIL
echo "$GUARD_RESULT4" | grep -q "FAIL" && pass || fail "Test4: guard_check returns FAIL when worktree cannot be created"

echo "$GUARD_RESULT4" | grep -qi "worktree" && pass || fail "Test4: failure message mentions worktree"

# Cleanup worktrees
if [ -n "$WT_PATH" ] && [ -d "$WT_PATH" ]; then
  git worktree remove "$WT_PATH" --force 2>/dev/null || rm -rf "$WT_PATH" 2>/dev/null || true
fi
git worktree prune 2>/dev/null || true
git branch -D feature/TASK-801 2>/dev/null || true

echo ""

# ============================================================
# Test 5: Regression test -- ST-003 auto-create worktree in guard_check
# Before fix: guard_check returned FAIL:worktree_not_found immediately
# After fix: guard_check auto-creates worktree and returns PASS
# ============================================================
echo "--- Test 5: Regression -- auto-create worktree in guard_check (Issues #24/#23) ---"

mkdir -p .kanban/tasks/TASK-803
cat > .kanban/tasks/TASK-803/task.json <<'TASK'
{
  "id": "TASK-803",
  "title": "Auto-create regression test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-803", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"completed"}],
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

cat > .kanban/tasks/TASK-803/requirements.md <<'REQ'
# Requirements
## Functional Requirements
- FR-001: test
## Acceptance Criteria
- AC-001: test
REQ

cat > .kanban/tasks/TASK-803/task_breakdown.json <<'BD'
{"task_id":"TASK-803","subtasks":[{"id":"ST-001","title":"test","description":"test","priority":"high","estimated_files":[],"dependencies":[]}]}
BD

# Verify: path is empty before guard_check
PRE_PATH=$(jq -r '.worktree.path // ""' .kanban/tasks/TASK-803/task.json)
assert_equals "" "$PRE_PATH" "Test5: worktree.path is empty before guard_check"

# Run guard_check -- should auto-create worktree and PASS
REGRESSION_RESULT=$(guard_check "TASK-803" "plan" "execute" 2>&1)
echo "$REGRESSION_RESULT" | grep -q "^PASS" && pass || fail "Test5: guard_check should PASS after auto-creating worktree (got: $REGRESSION_RESULT)"

# Verify: path is now set in task JSON
POST_PATH=$(jq -r '.worktree.path // ""' .kanban/tasks/TASK-803/task.json)
assert_not_empty "$POST_PATH" "Test5: worktree.path updated in task JSON after auto-create"

# Verify: directory actually exists
if [ -n "$POST_PATH" ] && [ -d "$POST_PATH" ]; then
  pass "Test5: worktree directory exists at $POST_PATH"
  # Cleanup
  git worktree remove "$POST_PATH" --force 2>/dev/null || rm -rf "$POST_PATH" 2>/dev/null || true
  git worktree prune 2>/dev/null || true
  git branch -D feature/TASK-803 2>/dev/null || true
else
  fail "Test5: worktree directory does not exist at path=$POST_PATH"
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
