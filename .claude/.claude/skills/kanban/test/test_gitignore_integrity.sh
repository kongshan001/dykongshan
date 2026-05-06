#!/usr/bin/env bash
# test_gitignore_integrity.sh -- Tests for .gitignore integrity check (ST-007)
# GitHub Issue #36: Prevent .kanban/worktrees/ from being tracked by git
# Run: bash .claude/skills/kanban/test/test_gitignore_integrity.sh

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

assert_contains() {
  local needle="$1"
  local haystack="$2"
  local label="${3:-assertion}"
  if echo "$haystack" | grep -qF "$needle"; then
    pass
  else
    fail "$label: expected '$needle' to be present"
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
TEST_TMPDIR=$(mktemp -d /tmp/test_gitignore_integrity_XXXXXX)

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

# Copy all lib files except test_worktree_config_sync.sh (auto-executes on source)
for _f in "$REAL_SKILL_DIR"/lib/*.sh; do
  case "$(basename "$_f")" in
    test_worktree_config_sync.sh) ;;
    *) cp "$_f" .claude/skills/kanban/lib/ ;;
  esac
done
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true

if [ -d "$REAL_SKILL_DIR/templates/reports" ]; then
  cp "$REAL_SKILL_DIR"/templates/reports/*.json .claude/skills/kanban/templates/reports/ 2>/dev/null || true
fi

KANBAN_DIR=".kanban"
export KANBAN_DIR

# Create minimal template files needed by kanban_init
cat > .claude/skills/kanban/templates/workflow.json <<'WF'
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

cat > .claude/skills/kanban/templates/config.json <<'CFG'
{
  "project": "",
  "trunk": "",
  "output_dir": "games",
  "dashboard": { "port": 3000 }
}
CFG

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

echo "============================================"
echo "  Test Suite: Gitignore Integrity (ST-007)"
echo "============================================"
echo ""

# ============================================================
# Test 1: .gitignore 包含所有必要条目 (kanban_init 后)
# ============================================================
echo "--- Test 1: .gitignore contains all required entries after kanban_init ---"

# Run kanban_init (it will call _kanban_check_gitignore internally)
kanban_init 2>/dev/null

GITIGNORE_CONTENT=$(cat .gitignore 2>/dev/null || echo "")

# Check each required entry
for entry in ".kanban/worktrees/" ".kanban/dashboard/" ".kanban/*.pid" ".kanban/*.log"; do
  if grep -qE "^[[:space:]]*${entry//\*/\\*}[[:space:]]*$" .gitignore 2>/dev/null; then
    pass "Test1: .gitignore contains '$entry'"
  else
    fail "Test1: .gitignore missing '$entry'"
  fi
done

echo ""

# ============================================================
# Test 2: _kanban_check_gitignore 自动补全缺失条目
# ============================================================
echo "--- Test 2: _kanban_check_gitignore auto-adds missing entries ---"

# Create a new temp dir with a clean git repo and empty .gitignore
TEST2_TMPDIR=$(mktemp -d /tmp/test_gitignore_auto_XXXXXX)
cleanup2() {
  rm -rf "$TEST2_TMPDIR"
}
trap 'cleanup; cleanup2' EXIT

cd "$TEST2_TMPDIR"
git init -q
git config user.email "test2@test.com"
git config user.name "Test2"

# Copy library files
mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates/reports
mkdir -p .kanban

# Copy all lib files except test_worktree_config_sync.sh (auto-executes on source)
for _f in "$REAL_SKILL_DIR"/lib/*.sh; do
  case "$(basename "$_f")" in
    test_worktree_config_sync.sh) ;;
    *) cp "$_f" .claude/skills/kanban/lib/ ;;
  esac
done
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/workflow.json .claude/skills/kanban/templates/workflow.json 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/config.json .claude/skills/kanban/templates/config.json 2>/dev/null || true

KANBAN_DIR=".kanban"
export KANBAN_DIR

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

# Create an empty .gitignore (no entries)
touch .gitignore

# Run _kanban_check_gitignore directly
CHECK_OUTPUT=$(_kanban_check_gitignore 2>&1) || true

# Verify all 4 entries were added
for entry in ".kanban/worktrees/" ".kanban/dashboard/" ".kanban/*.pid" ".kanban/*.log"; do
  if grep -qE "^[[:space:]]*${entry//\*/\\*}[[:space:]]*$" .gitignore 2>/dev/null; then
    pass "Test2: auto-added '$entry' to empty .gitignore"
  else
    fail "Test2: failed to auto-add '$entry'"
  fi
done

echo ""

# ============================================================
# Test 3: _kanban_check_gitignore 幂等 (重复执行不重复追加)
# ============================================================
echo "--- Test 3: _kanban_check_gitignore is idempotent ---"

# Count occurrences before
COUNT_BEFORE=$(grep -cE '^.kanban/(worktrees/|dashboard/|\*\.pid|\*\.log)' .gitignore 2>/dev/null || echo 0)

# Run check again
_kanban_check_gitignore >/dev/null 2>&1 || true

# Count occurrences after
COUNT_AFTER=$(grep -cE '^.kanban/(worktrees/|dashboard/|\*\.pid|\*\.log)' .gitignore 2>/dev/null || echo 0)

if [ "$COUNT_BEFORE" -eq "$COUNT_AFTER" ]; then
  pass "Test3: _kanban_check_gitignore is idempotent (before=$COUNT_BEFORE, after=$COUNT_AFTER)"
else
  fail "Test3: _kanban_check_gitignore not idempotent (before=$COUNT_BEFORE, after=$COUNT_AFTER)"
fi

echo ""

# ============================================================
# Test 4: .gitignore 不存在时自动创建
# ============================================================
echo "--- Test 4: _kanban_check_gitignore creates .gitignore if missing ---"

TEST4_TMPDIR=$(mktemp -d /tmp/test_gitignore_create_XXXXXX)
cleanup4() {
  rm -rf "$TEST4_TMPDIR"
}
trap 'cleanup; cleanup2; cleanup4' EXIT

cd "$TEST4_TMPDIR"
git init -q
git config user.email "test4@test.com"
git config user.name "Test4"

mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates
mkdir -p .kanban

# Copy all lib files except test_worktree_config_sync.sh (auto-executes on source)
for _f in "$REAL_SKILL_DIR"/lib/*.sh; do
  case "$(basename "$_f")" in
    test_worktree_config_sync.sh) ;;
    *) cp "$_f" .claude/skills/kanban/lib/ ;;
  esac
done
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/workflow.json .claude/skills/kanban/templates/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/config.json .claude/skills/kanban/templates/ 2>/dev/null || true

KANBAN_DIR=".kanban"
export KANBAN_DIR

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

# Ensure .gitignore does NOT exist
rm -f .gitignore

# Run check
_kanban_check_gitignore >/dev/null 2>&1 || true

if [ -f .gitignore ]; then
  pass "Test4: .gitignore was created when missing"
else
  fail "Test4: .gitignore was NOT created"
fi

# Verify entries exist
for entry in ".kanban/worktrees/" ".kanban/dashboard/"; do
  if grep -qF "$entry" .gitignore 2>/dev/null; then
    pass "Test4: created .gitignore contains '$entry'"
  else
    fail "Test4: created .gitignore missing '$entry'"
  fi
done

echo ""

# ============================================================
# Test 5: 新创建的 worktree 不被 git 追踪 (worktree_create 后检查)
# ============================================================
echo "--- Test 5: New worktree is not tracked by git after creation ---"

# Go back to first test dir
cd "$TEST_TMPDIR"

# Create a task
mkdir -p .kanban/tasks/TASK-900
cat > .kanban/tasks/TASK-900/task.json <<'TASK'
{
  "id": "TASK-900",
  "title": "Gitignore Worktree Test",
  "status": "pending",
  "phase": null,
  "phase_lock": null,
  "iteration": 0,
  "worktree": { "branch": "feature/TASK-900", "path": "" },
  "scores": {},
  "depends_on": [],
  "modified_files": [],
  "task_breakdown": { "file": "", "subtasks": [] },
  "history": [],
  "user_decision": null,
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# First verify .gitignore exists with required entries (needed for worktree to be ignored)
for entry in ".kanban/worktrees/" ".kanban/tasks/"; do
  if ! grep -qE "^[[:space:]]*${entry}[[:space:]]*$" .gitignore 2>/dev/null; then
    echo "$entry" >> .gitignore
  fi
done

# Create the worktree
WT_RESULT=$(worktree_create "TASK-900" "feature/TASK-900" 2>&1) || true
echo "  worktree_create output: $WT_RESULT"

# Get the worktree path
WT_PATH=$(jq -r '.worktree.path // ""' .kanban/tasks/TASK-900/task.json)

# Check if .kanban/worktrees/ is tracked by git
if git ls-files --error-unmatch ".kanban/worktrees/" >/dev/null 2>&1; then
  fail "Test5: .kanban/worktrees/ is still tracked by git after worktree_create"
else
  pass "Test5: .kanban/worktrees/ is NOT tracked by git"
fi

# Also check .kanban/tasks/
if git ls-files --error-unmatch ".kanban/tasks/" >/dev/null 2>&1; then
  fail "Test5: .kanban/tasks/ is still tracked by git after worktree_create"
else
  pass "Test5: .kanban/tasks/ is NOT tracked by git"
fi

# Cleanup worktree
if [ -n "$WT_PATH" ] && [ -d "$WT_PATH" ]; then
  git worktree remove "$WT_PATH" --force 2>/dev/null || rm -rf "$WT_PATH" 2>/dev/null || true
fi
git worktree prune 2>/dev/null || true
git branch -D feature/TASK-900 2>/dev/null || true

echo ""

# ============================================================
# Test 6: 已追踪目录被 _kanban_check_gitignore 解除追踪
# ============================================================
echo "--- Test 6: Already-tracked directories get untracked by _kanban_check_gitignore ---"

TEST6_TMPDIR=$(mktemp -d /tmp/test_gitignore_untrack_XXXXXX)
cleanup6() {
  rm -rf "$TEST6_TMPDIR"
}
trap 'cleanup; cleanup2; cleanup4; cleanup6' EXIT

cd "$TEST6_TMPDIR"
git init -q
git config user.email "test6@test.com"
git config user.name "Test6"

mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates
mkdir -p .kanban/worktrees

# Copy all lib files except test_worktree_config_sync.sh (auto-executes on source)
for _f in "$REAL_SKILL_DIR"/lib/*.sh; do
  case "$(basename "$_f")" in
    test_worktree_config_sync.sh) ;;
    *) cp "$_f" .claude/skills/kanban/lib/ ;;
  esac
done
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/workflow.json .claude/skills/kanban/templates/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/config.json .claude/skills/kanban/templates/ 2>/dev/null || true

KANBAN_DIR=".kanban"
export KANBAN_DIR

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

# Create a dummy file in .kanban/worktrees/ and track it
echo "test" > .kanban/worktrees/test_file
git add .kanban/worktrees/
git commit -q -m "add worktrees (simulate bug)"

# Verify it IS tracked before the check
if git ls-files --error-unmatch ".kanban/worktrees/" >/dev/null 2>&1; then
  pass "Test6: .kanban/worktrees/ is tracked BEFORE check (simulated bug)"
else
  fail "Test6: .kanban/worktrees/ not tracked (setup failed)"
fi

# Run the gitignore check (should untrack)
_kanban_check_gitignore >/dev/null 2>&1 || true

# Verify it is NO LONGER tracked
if git ls-files --error-unmatch ".kanban/worktrees/" >/dev/null 2>&1; then
  fail "Test6: .kanban/worktrees/ still tracked AFTER _kanban_check_gitignore"
else
  pass "Test6: .kanban/worktrees/ successfully untracked by _kanban_check_gitignore"
fi

echo ""

# ============================================================
# Test 7: .gitignore 注释行不被识别为已存在 (regression)
# ============================================================
echo "--- Test 7: Commented entries are treated as missing ---"

TEST7_TMPDIR=$(mktemp -d /tmp/test_gitignore_commented_XXXXXX)
cleanup7() {
  rm -rf "$TEST7_TMPDIR"
}
trap 'cleanup; cleanup2; cleanup4; cleanup6; cleanup7' EXIT

cd "$TEST7_TMPDIR"
git init -q
git config user.email "test7@test.com"
git config user.name "Test7"

mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates
mkdir -p .kanban

# Copy all lib files except test_worktree_config_sync.sh (auto-executes on source)
for _f in "$REAL_SKILL_DIR"/lib/*.sh; do
  case "$(basename "$_f")" in
    test_worktree_config_sync.sh) ;;
    *) cp "$_f" .claude/skills/kanban/lib/ ;;
  esac
done
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/workflow.json .claude/skills/kanban/templates/ 2>/dev/null || true
cp "$REAL_SKILL_DIR"/templates/config.json .claude/skills/kanban/templates/ 2>/dev/null || true

KANBAN_DIR=".kanban"
export KANBAN_DIR

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

# Create .gitignore with COMMENTED entries (simulating the bug scenario)
cat > .gitignore <<'GITEOF'
# .kanban/worktrees/
# .kanban/dashboard/
GITEOF

# Run check
CHECK_OUTPUT7=$(_kanban_check_gitignore 2>&1) || true

# The commented entries should be treated as missing and re-added as uncommented
UNCOMMENTED_WT=$(grep -cE '^[[:space:]]*\.kanban/worktrees/[[:space:]]*$' .gitignore 2>/dev/null || echo 0)
UNCOMMENTED_DASH=$(grep -cE '^[[:space:]]*\.kanban/dashboard/[[:space:]]*$' .gitignore 2>/dev/null || echo 0)

if [ "$UNCOMMENTED_WT" -ge 1 ]; then
  pass "Test7: .kanban/worktrees/ added as uncommented entry"
else
  fail "Test7: .kanban/worktrees/ not added as uncommented entry"
fi

if [ "$UNCOMMENTED_DASH" -ge 1 ]; then
  pass "Test7: .kanban/dashboard/ added as uncommented entry"
else
  fail "Test7: .kanban/dashboard/ not added as uncommented entry"
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
