#!/usr/bin/env bash
# test_plan_quality_gate_block.sh -- Regression test for Issue #26
# Bug: Plan quality gate writes PLAN_QUALITY_FAIL but doesn't block plan->execute transition
# Fix: guard_check_transition reads plan_quality_passed from task.json and blocks when false
# Run: bash .claude/skills/kanban/test/test_plan_quality_gate_block.sh

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
  local haystack="$1"
  local needle="$2"
  local label="${3:-assertion}"
  if echo "$haystack" | grep -q "$needle"; then
    pass
  else
    fail "$label: expected to contain '$needle' in '$haystack'"
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local label="${3:-assertion}"
  if echo "$haystack" | grep -q "$needle"; then
    fail "$label: expected NOT to contain '$needle' in '$haystack'"
  else
    pass
  fi
}

# ============================================================
# Setup: create temp kanban environment
# ============================================================
REAL_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG_DIR="$(pwd)"
TEST_TMPDIR=$(mktemp -d /tmp/test_plan_quality_block_XXXXXX)

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

cat > .kanban/index.json <<'IDX'
{"project":"test-project","trunk":"main","tasks":[]}
IDX

# Workflow with quality_gate enabled
cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    {
      "id": "plan",
      "quality_gate": {
        "enabled": true,
        "pass_threshold": 7.0,
        "max_rounds": 3,
        "dimensions": [
          {"id": "requirement_clarity", "weight": 0.25},
          {"id": "technical_feasibility", "weight": 0.25},
          {"id": "task_decomposition", "weight": 0.25},
          {"id": "acceptance_criteria", "weight": 0.25}
        ]
      }
    },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

git add -A
git commit -q -m "init"

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

echo "============================================"
echo "  Test Suite: Plan Quality Gate Block (Issue #26)"
echo "============================================"
echo ""

# ============================================================
# Test 1: guard_check blocks plan->execute when plan_quality_passed=false
# ============================================================
echo "--- Test 1: guard_check blocks plan->execute when plan_quality_passed=false ---"

mkdir -p .kanban/tasks/TASK-800
mkdir -p .kanban/tasks/TASK-800/iteration-1
cat > .kanban/tasks/TASK-800/task.json <<'TASK'
{
  "id": "TASK-800",
  "title": "Block Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "plan_quality_passed": false,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"completed","entered_at":"2026-01-01T00:00:00Z","exited_at":"2026-01-01T00:00:00Z"}],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create minimal plan artifacts to pass artifact check
cat > .kanban/tasks/TASK-800/requirements.md <<'REQ'
# Requirements
REQ

cat > .kanban/tasks/TASK-800/task_breakdown.json <<'BD'
{"task_id":"TASK-800","subtasks":[{"id":"ST-001","title":"t","description":"d","priority":"high","estimated_files":[],"dependencies":[]}]}
BD

set +e
RESULT=$(guard_check "TASK-800" "plan" "execute" 2>&1)
EXIT_CODE=$?
set -e
echo "  guard_check result: $RESULT (exit=$EXIT_CODE)"

assert_equals "1" "$EXIT_CODE" "Test1: guard_check returns 1 when plan_quality_passed=false"
assert_contains "$RESULT" "plan_quality_gate_not_passed" "Test1: output mentions plan_quality_gate_not_passed"

echo ""

# ============================================================
# Test 2: guard_check allows plan->execute when plan_quality_passed=true
# ============================================================
echo "--- Test 2: guard_check allows plan->execute when plan_quality_passed=true ---"

cat > .kanban/tasks/TASK-800/task.json <<'TASK'
{
  "id": "TASK-800",
  "title": "Block Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "plan_quality_passed": true,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"completed","entered_at":"2026-01-01T00:00:00Z","exited_at":"2026-01-01T00:00:00Z"}],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# guard_check will fail at worktree check, but should NOT fail at plan quality gate
set +e
RESULT2=$(guard_check "TASK-800" "plan" "execute" 2>&1)
EXIT_CODE2=$?
set -e
echo "  guard_check result: $RESULT2 (exit=$EXIT_CODE2)"

# It should pass the quality gate check (might fail on worktree, but that's expected)
assert_not_contains "$RESULT2" "plan_quality_gate_not_passed" "Test2: no plan_quality_gate block when plan_quality_passed=true"

echo ""

# ============================================================
# Test 3: guard_check allows plan->execute when plan_quality_passed is missing (default true)
# ============================================================
echo "--- Test 3: guard_check allows plan->execute when plan_quality_passed missing (default true) ---"

cat > .kanban/tasks/TASK-800/task.json <<'TASK'
{
  "id": "TASK-800",
  "title": "Block Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"completed","entered_at":"2026-01-01T00:00:00Z","exited_at":"2026-01-01T00:00:00Z"}],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

set +e
RESULT3=$(guard_check "TASK-800" "plan" "execute" 2>&1)
set -e
echo "  guard_check result: $RESULT3"

assert_not_contains "$RESULT3" "plan_quality_gate_not_passed" "Test3: no plan_quality_gate block when field missing"

echo ""

# ============================================================
# Test 4: workflow_complete_phase writes plan_quality_passed=false on failure
# ============================================================
echo "--- Test 4: workflow_complete_phase writes plan_quality_passed=false on quality failure ---"

mkdir -p .kanban/tasks/TASK-801
mkdir -p .kanban/tasks/TASK-801/iteration-1
cat > .kanban/tasks/TASK-801/task.json <<'TASK'
{
  "id": "TASK-801",
  "title": "Write Flag Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"entered","entered_at":"2026-01-01T00:00:00Z"}],
  "plan_quality": {},
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create minimal requirements that will fail quality gate (score below 7.0)
cat > .kanban/tasks/TASK-801/requirements.md <<'REQ'
# Requirements
## Minimal
- Some feature
REQ

cat > .kanban/tasks/TASK-801/task_breakdown.json <<'BD'
{"task_id":"TASK-801","subtasks":[{"id":"ST-001","title":"t","description":"d","priority":"low","estimated_files":[],"dependencies":[]}]}
BD

COMPLETE_OUTPUT=$(workflow_complete_phase "TASK-801" 2>&1) || true
echo "  complete_phase output: $COMPLETE_OUTPUT"

# Verify plan_quality_passed is set to false in task.json
# Note: use has()+tostring to handle jq boolean false correctly
PASSED_FLAG=$(jq -r 'if has("plan_quality_passed") then .plan_quality_passed | tostring else "missing" end' .kanban/tasks/TASK-801/task.json)
assert_equals "false" "$PASSED_FLAG" "Test4: plan_quality_passed set to false after quality failure"

echo ""

# ============================================================
# Test 5: workflow_complete_phase writes plan_quality_passed=true on success
# ============================================================
echo "--- Test 5: workflow_complete_phase writes plan_quality_passed=true on quality success ---"

mkdir -p .kanban/tasks/TASK-802
mkdir -p .kanban/tasks/TASK-802/iteration-1
cat > .kanban/tasks/TASK-802/task.json <<'TASK'
{
  "id": "TASK-802",
  "title": "Write Flag Pass Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"entered","entered_at":"2026-01-01T00:00:00Z"}],
  "plan_quality": {},
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create good requirements that will pass quality gate (score >= 7.0)
cat > .kanban/tasks/TASK-802/requirements.md <<'REQ'
# Requirements Analysis: Full Coverage

## 功能需求
- FR-001: Complete feature set
- FR-002: Edge case handling

## 非功能需求
- NFR-001: Performance >= 100ms
- NFR-002: Bash 3.2 compatible

## 技术约束
- TC-001: Must use shell scripting only

## 验收标准
- AC-001: All tests pass
- AC-002: Coverage >= 80%
- AC-003: No regressions
- AC-004: Documentation complete
REQ

cat > .kanban/tasks/TASK-802/task_breakdown.json <<'BD'
{
  "task_id": "TASK-802",
  "iteration": 1,
  "subtasks": [
    {"id": "ST-001", "title": "Core feature", "description": "Implement core", "priority": "high", "estimated_files": ["src/core.sh"], "dependencies": []},
    {"id": "ST-002", "title": "Tests", "description": "Write tests", "priority": "high", "estimated_files": ["test/all.sh"], "dependencies": ["ST-001"]}
  ]
}
BD

COMPLETE_OUTPUT2=$(workflow_complete_phase "TASK-802" 2>&1) || true
echo "  complete_phase output: $COMPLETE_OUTPUT2"

# Verify plan_quality_passed is set to true in task.json
PASSED_FLAG2=$(jq -r 'if has("plan_quality_passed") then .plan_quality_passed | tostring else "missing" end' .kanban/tasks/TASK-802/task.json)
assert_equals "true" "$PASSED_FLAG2" "Test5: plan_quality_passed set to true after quality success"

echo ""

# ============================================================
# Test 6: End-to-end: quality failure blocks transition even after complete_phase
# ============================================================
echo "--- Test 6: End-to-end: quality failure blocks subsequent transition ---"

# TASK-801 had quality failure (Test 4), verify we cannot transition to execute
set +e
RESULT6=$(guard_check "TASK-801" "plan" "execute" 2>&1)
EXIT_CODE6=$?
set -e
echo "  guard_check result: $RESULT6 (exit=$EXIT_CODE6)"

assert_equals "1" "$EXIT_CODE6" "Test6: transition blocked after quality failure"
assert_contains "$RESULT6" "plan_quality_gate_not_passed" "Test6: correct failure reason"

echo ""

# ============================================================
# Test 7: End-to-end: quality success allows transition
# ============================================================
echo "--- Test 7: End-to-end: quality success allows subsequent transition ---"

# TASK-802 had quality success (Test 5), verify transition is not blocked by quality gate
set +e
RESULT7=$(guard_check "TASK-802" "plan" "execute" 2>&1)
set -e
echo "  guard_check result: $RESULT7"

assert_not_contains "$RESULT7" "plan_quality_gate_not_passed" "Test7: no quality gate block after success"

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
