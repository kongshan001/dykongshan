#!/usr/bin/env bash
# test_iteration_dir_auto_create.sh -- Regression test for Issue #28
# Bug: iteration-N/ directory not auto-created when transitioning to execute phase
# Fix: workflow_transition auto-creates iteration-N/ for all phases that write to it
#
# Run: bash .claude/skills/kanban/test/test_iteration_dir_auto_create.sh

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

assert_dir_exists() {
  local dir="$1"
  local label="${2:-assertion}"
  if [ -d "$dir" ]; then
    pass
  else
    fail "$label: directory '$dir' does not exist"
  fi
}

assert_not_dir_exists() {
  local dir="$1"
  local label="${2:-assertion}"
  if [ ! -d "$dir" ]; then
    pass
  else
    fail "$label: directory '$dir' should NOT exist"
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
TEST_TMPDIR=$(mktemp -d /tmp/test_issue28_XXXXXX)

cleanup() {
  cd "$ORIG_DIR"
  rm -rf "$TEST_TMPDIR"
}
trap cleanup EXIT

cd "$TEST_TMPDIR"
git init -q
git config user.email "test@test.com"
git config user.name "Test"

# Copy library files
mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates/reports
cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/ || true

# Copy templates if they exist
if [ -d "$REAL_SKILL_DIR/templates/reports" ]; then
  cp "$REAL_SKILL_DIR"/templates/reports/*.json .claude/skills/kanban/templates/reports/ 2>/dev/null || true
fi

# Create the .kanban directory
mkdir -p .kanban

KANBAN_DIR=".kanban"
export KANBAN_DIR

# Minimal config
cat > .kanban/config.json <<'CFG'
{
  "project": "test-issue28",
  "trunk": "main",
  "output_dir": "src",
  "dashboard": { "port": 3000 }
}
CFG

cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    { "id": "plan", "order": 1 },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3, "pass_threshold": 9.0 },
    { "id": "retrospective", "order": 4 },
    { "id": "user_decision", "order": 5 },
    { "id": "archive", "order": 6 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

cat > .kanban/index.json <<'IDX'
{"project":"test-issue28","trunk":"main","tasks":[]}
IDX

git add -A
git commit -q -m "init" || true

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

# Helper: create a valid git worktree for testing execute transitions
_create_test_worktree() {
  local task_id="$1"
  local wt_path="$TEST_TMPDIR/.kanban/tasks/${task_id}/worktree"
  mkdir -p "$wt_path"
  git init -q "$wt_path"
  cd "$wt_path"
  git config user.email "test@test.com"
  git config user.name "Test"
  echo "init" > README.md
  git add -A && git commit -q -m "init" || true
  cd "$TEST_TMPDIR"
  echo "$wt_path"
}

# Helper: create a task JSON in a given phase
_create_task() {
  local task_id="$1"
  local phase="$2"
  local phase_lock="$3"
  local iteration="$4"
  local wt_path="${5:-}"

  mkdir -p ".kanban/tasks/${task_id}"
  cat > ".kanban/tasks/${task_id}/task.json" <<TASKJSON
{
  "id": "${task_id}",
  "title": "Test Task ${task_id}",
  "description": "Regression test for issue #28",
  "engine": "claude-code",
  "status": "planning",
  "phase": "${phase}",
  "phase_lock": "${phase_lock}",
  "assignee": null,
  "worktree": { "branch": "feature/${task_id}", "path": "${wt_path}", "base": "main" },
  "iteration": ${iteration},
  "max_iterations": 6,
  "token_budget": 500000,
  "token_used": 0,
  "scores": {},
  "depends_on": [],
  "modified_files": [],
  "task_breakdown": { "file": "", "subtasks": [] },
  "history": [],
  "user_decision": null,
  "requires_archive_confirmation": true,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z",
  "entered_at": "2026-01-01T00:00:00Z"
}
TASKJSON
}

# Helper: create plan artifacts in task root
_create_plan_artifacts() {
  local task_id="$1"
  local tdir=".kanban/tasks/${task_id}"
  cat > "${tdir}/requirements.md" <<'REQ'
# Requirements

## Functional Requirements
- FR-001: Test requirement

## Acceptance Criteria
- AC-001: Test passes
REQ

  cat > "${tdir}/task_breakdown.json" <<'BD'
{
  "task_id": "TEST",
  "iteration": 1,
  "subtasks": [
    {"id": "ST-001", "title": "Test subtask", "description": "A test", "priority": "high", "estimated_files": [], "dependencies": []}
  ]
}
BD
}

# Helper: create execute artifacts in iteration dir
_create_execute_artifacts() {
  local task_id="$1"
  local iter="$2"
  local tdir=".kanban/tasks/${task_id}"
  mkdir -p "${tdir}/iteration-${iter}"
  cat > "${tdir}/iteration-${iter}/execution_summary.md" <<'ES'
# Execution Summary
Test
ES
  cat > "${tdir}/iteration-${iter}/execution_pitfalls.md" <<'EP'
# Pitfalls
None
EP
  cat > "${tdir}/iteration-${iter}/execution_decisions.md" <<'ED'
# Decisions
None
ED
}

echo "============================================"
echo "  Test Suite: Issue #28 - iteration dir auto-creation"
echo "============================================"
echo ""

# ============================================================
# Test 1: plan->execute transition creates iteration-1 dir
# This is the core bug scenario: iteration dir not created
# when entering execute phase.
# ============================================================
echo "--- Test 1: plan->execute transition creates iteration-1 dir ---"

WT1=$(_create_test_worktree "TASK-201")
_create_task "TASK-201" "plan" "plan" 1 "$WT1"
_create_plan_artifacts "TASK-201"

# Verify iteration-1 does NOT exist before the transition
assert_not_dir_exists ".kanban/tasks/TASK-201/iteration-1" "Test1: iteration-1 should NOT exist before execute transition"

# Transition plan -> execute
RESULT=$(workflow_transition "TASK-201" "execute" 2>&1)
TRANSITION_EXIT=$?

assert_equals "0" "$TRANSITION_EXIT" "Test1: plan->execute transition should succeed"
assert_dir_exists ".kanban/tasks/TASK-201/iteration-1" "Test1: iteration-1 dir created by execute transition"

# Verify the task is now in execute phase
PHASE=$(jq -r '.phase' .kanban/tasks/TASK-201/task.json)
assert_equals "execute" "$PHASE" "Test1: phase set to execute"

echo ""

# ============================================================
# Test 2: initial plan transition (iteration 0->1) still works
# ============================================================
echo "--- Test 2: initial plan transition (iteration 0->1) ---"

_create_task "TASK-202" "" "" 0 ""

# Transition "" -> plan (initial entry)
RESULT2=$(workflow_transition "TASK-202" "plan" 2>&1)
TRANSITION2_EXIT=$?

assert_equals "0" "$TRANSITION2_EXIT" "Test2: initial plan transition should succeed"
assert_dir_exists ".kanban/tasks/TASK-202/iteration-1" "Test2: iteration-1 dir created by initial plan transition"

# Verify iteration was bumped to 1 in task JSON
ITER_VAL=$(jq -r '.iteration' .kanban/tasks/TASK-202/task.json)
assert_equals "1" "$ITER_VAL" "Test2: iteration set to 1 in task JSON"

echo ""

# ============================================================
# Test 3: execute->evaluate transition recreates iteration dir
# Verifies that even if the iteration dir was somehow removed,
# transitioning to evaluate will re-create it.
# ============================================================
echo "--- Test 3: execute->evaluate transition recreates iteration dir ---"

# TASK-201 is now in execute phase (from Test 1)
# Add execute artifacts so guard passes
_create_execute_artifacts "TASK-201" 1

# Verify artifacts exist
assert_dir_exists ".kanban/tasks/TASK-201/iteration-1" "Test3: iteration-1 dir exists with artifacts"

# Now transition to evaluate
RESULT3=$(workflow_transition "TASK-201" "evaluate" 2>&1)
TRANSITION3_EXIT=$?

assert_equals "0" "$TRANSITION3_EXIT" "Test3: execute->evaluate transition should succeed"
assert_dir_exists ".kanban/tasks/TASK-201/iteration-1" "Test3: iteration-1 dir preserved through evaluate transition"

# Verify phase is evaluate
PHASE3=$(jq -r '.phase' .kanban/tasks/TASK-201/task.json)
assert_equals "evaluate" "$PHASE3" "Test3: phase set to evaluate"

echo ""

# ============================================================
# Test 4: iteration-2 dir created for higher iteration
# Tests that non-1 iteration numbers also get auto-created.
# ============================================================
echo "--- Test 4: iteration-2 dir created for higher iteration ---"

WT4=$(_create_test_worktree "TASK-204")
_create_task "TASK-204" "plan" "plan" 2 "$WT4"
_create_plan_artifacts "TASK-204"

# Verify iteration-2 does NOT exist before transition
assert_not_dir_exists ".kanban/tasks/TASK-204/iteration-2" "Test4: iteration-2 should NOT exist before execute transition"

# Transition plan -> execute with iteration=2
RESULT4=$(workflow_transition "TASK-204" "execute" 2>&1)
TRANSITION4_EXIT=$?

assert_equals "0" "$TRANSITION4_EXIT" "Test4: plan->execute (iter=2) transition should succeed"
assert_dir_exists ".kanban/tasks/TASK-204/iteration-2" "Test4: iteration-2 dir created by execute transition"

echo ""

# ============================================================
# Test 5: report_dir helper returns correct path
# ============================================================
echo "--- Test 5: report_dir helper correctness ---"

RDIR=$(report_dir "TASK-201" 1)
assert_equals ".kanban/tasks/TASK-201/iteration-1" "$RDIR" "Test5: report_dir returns correct path for iteration-1"

RDIR2=$(report_dir "TASK-204" 2)
assert_equals ".kanban/tasks/TASK-204/iteration-2" "$RDIR2" "Test5: report_dir returns correct path for iteration-2"

# Test with omitted iter (should read from task JSON)
RDIR3=$(report_dir "TASK-201")
assert_equals ".kanban/tasks/TASK-201/iteration-1" "$RDIR3" "Test5: report_dir with no iter reads from task JSON"

echo ""

# ============================================================
# Test 6: guard_check_artifacts works with auto-created dir
# ============================================================
echo "--- Test 6: guard_check_artifacts with auto-created dir ---"

# TASK-201 iteration-1 should have execute artifacts from Test 3
MISSING=$(guard_check_artifacts "TASK-201" "execute")
assert_equals "" "$MISSING" "Test6: no missing artifacts after execute phase"

# Test with missing artifacts (remove one)
rm -f .kanban/tasks/TASK-201/iteration-1/execution_summary.md
MISSING2=$(guard_check_artifacts "TASK-201" "execute")
assert_not_empty "$MISSING2" "Test6: missing artifacts detected when file removed"

echo ""

# ============================================================
# Test 7: workflow_start_iteration creates new iteration dir
# ============================================================
echo "--- Test 7: workflow_start_iteration creates iteration-2 dir ---"

WT7=$(_create_test_worktree "TASK-207")
_create_task "TASK-207" "evaluate" "evaluate" 1 "$WT7"

# Verify iteration-1 does not exist
assert_not_dir_exists ".kanban/tasks/TASK-207/iteration-1" "Test7: iteration-1 should not exist yet"
assert_not_dir_exists ".kanban/tasks/TASK-207/iteration-2" "Test7: iteration-2 should not exist yet"

# Start a hot iteration (bumps iteration to 2)
RESULT7=$(workflow_start_iteration "TASK-207" "hot" 2>&1)
ITER7_EXIT=$?

assert_equals "0" "$ITER7_EXIT" "Test7: workflow_start_iteration should succeed"
assert_dir_exists ".kanban/tasks/TASK-207/iteration-2" "Test7: iteration-2 dir created by workflow_start_iteration"

# Verify iteration was bumped to 2
ITER7_VAL=$(jq -r '.iteration' .kanban/tasks/TASK-207/task.json)
assert_equals "2" "$ITER7_VAL" "Test7: iteration set to 2 in task JSON"

echo ""

# ============================================================
# Cleanup
# ============================================================
rm -rf .kanban/tasks/TASK-201 .kanban/tasks/TASK-202 .kanban/tasks/TASK-204 .kanban/tasks/TASK-207

# ============================================================
# Summary
# ============================================================
echo ""
echo "============================================"
TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed (total ${TOTAL})"
echo "============================================"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
