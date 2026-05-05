#!/usr/bin/env bash
# test_plan_quality_gate.sh -- Tests for Plan quality gate (ST-008)
# Run: bash .claude/skills/kanban/test/test_plan_quality_gate.sh

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
TEST_TMPDIR=$(mktemp -d /tmp/test_plan_quality_gate_XXXXXX)

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

git add -A
git commit -q -m "init"

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

echo "============================================"
echo "  Test Suite: Plan Quality Gate (ST-008)"
echo "============================================"
echo ""

# ============================================================
# Test 1: quality_gate enabled=true 时门禁生效
# ============================================================
echo "--- Test 1: Quality gate enabled=true activates gate ---"

# Create workflow.json with quality_gate enabled
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

# Create a task with good plan artifacts
mkdir -p .kanban/tasks/TASK-700
mkdir -p .kanban/tasks/TASK-700/iteration-1
cat > .kanban/tasks/TASK-700/task.json <<'TASK'
{
  "id": "TASK-700",
  "title": "Quality Gate Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "plan_quality": {},
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create good requirements.md
cat > .kanban/tasks/TASK-700/requirements.md <<'REQ'
# Requirements Analysis: Quality Gate Test

## 功能需求
- FR-001: Feature one

## 非功能需求
- NFR-001: Performance requirement

## 技术约束
- TC-001: Must use Bash 3.2

## 验收标准
- AC-001: Test passes
- AC-002: Coverage >= 80%
- AC-003: All edge cases covered
REQ

cat > .kanban/tasks/TASK-700/task_breakdown.json <<'BD'
{
  "task_id": "TASK-700",
  "iteration": 1,
  "subtasks": [
    {"id": "ST-001", "title": "Implement feature", "description": "Description here", "priority": "high", "estimated_files": ["src/feature.sh"], "dependencies": []}
  ]
}
BD

QUALITY_RESULT=$(guard_check_plan_quality "TASK-700" ".kanban/tasks/TASK-700/iteration-1" 2>&1)
QUALITY_EXIT=$?
echo "  Quality result: $QUALITY_RESULT"

# Check JSON output
QUALITY_JSON=".kanban/tasks/TASK-700/iteration-1/.plan_quality.json"
if [ -f "$QUALITY_JSON" ]; then
  TOTAL_SCORE=$(jq -r '.total_score' "$QUALITY_JSON")
  PASS_VAL=$(jq -r '.pass' "$QUALITY_JSON")

  assert_not_empty "$TOTAL_SCORE" "Test1: total_score present"
  assert_not_empty "$PASS_VAL" "Test1: pass field present"

  # With good requirements, the gate should pass (score >= 7.0)
  if [ "$(echo "$TOTAL_SCORE >= 7.0" | bc 2>/dev/null || echo 0)" = "1" ]; then
    pass "Test1: score >= 7.0 threshold"
  else
    fail "Test1: score $TOTAL_SCORE < 7.0 threshold"
  fi

  assert_equals "true" "$PASS_VAL" "Test1: pass=true for good requirements"
else
  fail "Test1: .plan_quality.json not generated"
fi

echo ""

# ============================================================
# Test 2: quality_gate enabled=false 时门禁跳过
# ============================================================
echo "--- Test 2: Quality gate enabled=false skips gate ---"

cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    {
      "id": "plan",
      "quality_gate": {
        "enabled": false,
        "pass_threshold": 7.0,
        "max_rounds": 3
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

# Run workflow_complete_phase and check that it skips quality check
# Since quality_gate.enabled=false, the quality check block should be skipped
# We verify this by checking that guard_check_plan_quality is still callable but
# workflow_complete_phase does not invoke it

# Create a task in plan phase
mkdir -p .kanban/tasks/TASK-701
mkdir -p .kanban/tasks/TASK-701/iteration-1
cat > .kanban/tasks/TASK-701/task.json <<'TASK'
{
  "id": "TASK-701",
  "title": "No Gate Test",
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

cat > .kanban/tasks/TASK-701/requirements.md <<'REQ'
# Requirements
## 功能需求
REQ

cat > .kanban/tasks/TASK-701/task_breakdown.json <<'BD'
{"task_id":"TASK-701","subtasks":[{"id":"ST-001","title":"t","description":"d","priority":"high","estimated_files":[],"dependencies":[]}]}
BD

# Run complete_phase -- should not generate .plan_quality.json
COMPLETE_OUTPUT=$(workflow_complete_phase "TASK-701" 2>&1) || true
echo "$COMPLETE_OUTPUT" | grep -q "PLAN_QUALITY" && fail "Test2: quality gate ran when disabled" || pass "Test2: quality gate skipped when disabled"

echo ""

# ============================================================
# Test 3: 各维度评分计算正确
# ============================================================
echo "--- Test 3: Dimension scores calculated correctly ---"

# Restore quality_gate enabled for remaining tests
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

mkdir -p .kanban/tasks/TASK-702
mkdir -p .kanban/tasks/TASK-702/iteration-1
cat > .kanban/tasks/TASK-702/task.json <<'TASK'
{
  "id": "TASK-702",
  "title": "Dimension Score Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create complete requirements with all sections
cat > .kanban/tasks/TASK-702/requirements.md <<'REQ'
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

cat > .kanban/tasks/TASK-702/task_breakdown.json <<'BD'
{
  "task_id": "TASK-702",
  "iteration": 1,
  "subtasks": [
    {"id": "ST-001", "title": "Core feature", "description": "Implement core", "priority": "high", "estimated_files": ["src/core.sh", "test/core.sh"], "dependencies": []},
    {"id": "ST-002", "title": "Tests", "description": "Write tests", "priority": "high", "estimated_files": ["test/all.sh"], "dependencies": ["ST-001"]}
  ]
}
BD

guard_check_plan_quality "TASK-702" ".kanban/tasks/TASK-702/iteration-1" >/dev/null 2>&1 || true

QUALITY_JSON3=".kanban/tasks/TASK-702/iteration-1/.plan_quality.json"
if [ -f "$QUALITY_JSON3" ]; then
  # Check all 4 required dimensions are present
  local_req=$(jq -r '.dimensions.requirement_clarity' "$QUALITY_JSON3")
  local_tech=$(jq -r '.dimensions.technical_feasibility' "$QUALITY_JSON3")
  local_decomp=$(jq -r '.dimensions.task_decomposition' "$QUALITY_JSON3")
  local_ac=$(jq -r '.dimensions.acceptance_criteria' "$QUALITY_JSON3")
  local_research=$(jq -r '.dimensions.research_completeness // "missing"' "$QUALITY_JSON3")

  assert_not_empty "$local_req" "Test3: requirement_clarity dimension present"
  assert_not_empty "$local_tech" "Test3: technical_feasibility dimension present"
  assert_not_empty "$local_decomp" "Test3: task_decomposition dimension present"
  assert_not_empty "$local_ac" "Test3: acceptance_criteria dimension present"
  assert_not_empty "$local_research" "Test3: research_completeness dimension present"

  # Verify specific expected scores
  # requirement_clarity: has all 3 sections -> 3 + 3 + 4 = 10
  assert_equals "10" "$local_req" "Test3: requirement_clarity = 10 (all sections present)"

  # technical_feasibility: has TC- (5) + all subtasks have estimated_files (5) = 10
  assert_equals "10" "$local_tech" "Test3: technical_feasibility = 10"

  # task_decomposition: 2 subtasks (3) + all have fields (4) + no circular deps (3) = 10
  assert_equals "10" "$local_decomp" "Test3: task_decomposition = 10"

  # acceptance_criteria: >= 3 AC items -> 10
  assert_equals "10" "$local_ac" "Test3: acceptance_criteria = 10"

  # research_completeness: no research section -> 10 (not penalized)
  assert_equals "10" "$local_research" "Test3: research_completeness = 10 (no research needed)"
else
  fail "Test3: .plan_quality.json not generated"
fi

echo ""

# ============================================================
# Test 4: pass_threshold 阈值判断
# ============================================================
echo "--- Test 4: pass_threshold threshold judgment ---"

mkdir -p .kanban/tasks/TASK-703
mkdir -p .kanban/tasks/TASK-703/iteration-1
cat > .kanban/tasks/TASK-703/task.json <<'TASK'
{
  "id": "TASK-703",
  "title": "Threshold Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

# Create minimal requirements (should score low)
cat > .kanban/tasks/TASK-703/requirements.md <<'REQ'
# Requirements
## Minimal
- Some feature
REQ

cat > .kanban/tasks/TASK-703/task_breakdown.json <<'BD'
{"task_id":"TASK-703","subtasks":[{"id":"ST-001","title":"t","description":"d","priority":"low","estimated_files":[],"dependencies":[]}]}
BD

guard_check_plan_quality "TASK-703" ".kanban/tasks/TASK-703/iteration-1" >/dev/null 2>&1 || true

QUALITY_JSON4=".kanban/tasks/TASK-703/iteration-1/.plan_quality.json"
if [ -f "$QUALITY_JSON4" ]; then
  PASS_VAL4=$(jq -r '.pass' "$QUALITY_JSON4")
  TOTAL_SCORE4=$(jq -r '.total_score' "$QUALITY_JSON4")
  THRESHOLD4=$(jq -r '.threshold' "$QUALITY_JSON4")

  # Minimal requirements should score below 7.0
  assert_equals "7.0" "$THRESHOLD4" "Test4: threshold = 7.0 from workflow.json"

  if [ "$(echo "$TOTAL_SCORE4 < 7.0" | bc 2>/dev/null || echo 1)" = "1" ]; then
    pass "Test4: minimal requirements score below threshold"
    assert_equals "false" "$PASS_VAL4" "Test4: pass=false for minimal requirements"
  else
    fail "Test4: expected score < 7.0 but got $TOTAL_SCORE4"
  fi
else
  fail "Test4: .plan_quality.json not generated"
fi

echo ""

# ============================================================
# Test 5: max_rounds 重试逻辑
# ============================================================
echo "--- Test 5: max_rounds retry logic ---"

# Test workflow_check_plan_retry function
# Setup: task with plan_quality.pass=false and retries < max_rounds
mkdir -p .kanban/tasks/TASK-704
cat > .kanban/tasks/TASK-704/task.json <<'TASK'
{
  "id": "TASK-704",
  "title": "Retry Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "plan_quality": {"pass": false, "retries": 1, "max_rounds": 3},
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

RETRY_RESULT=$(workflow_check_plan_retry "TASK-704")
assert_equals "retry" "$RETRY_RESULT" "Test5: returns 'retry' when retries < max_rounds"

# Test max_reached
cat > .kanban/tasks/TASK-704/task.json <<'TASK'
{
  "id": "TASK-704",
  "title": "Retry Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "plan_quality": {"pass": false, "retries": 3, "max_rounds": 3},
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

MAX_RESULT=$(workflow_check_plan_retry "TASK-704")
assert_equals "max_reached" "$MAX_RESULT" "Test5: returns 'max_reached' when retries >= max_rounds"

# Test pass
cat > .kanban/tasks/TASK-704/task.json <<'TASK'
{
  "id": "TASK-704",
  "title": "Retry Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "plan_quality": {"pass": true, "retries": 0, "max_rounds": 3},
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

PASS_RESULT=$(workflow_check_plan_retry "TASK-704")
assert_equals "pass" "$PASS_RESULT" "Test5: returns 'pass' when quality passed"

echo ""

# ============================================================
# Test 6: quality_gate 配置缺失时回退到默认值
# ============================================================
echo "--- Test 6: Fallback to defaults when quality_gate config missing ---"

# Remove quality_gate from workflow.json
cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    { "id": "plan" },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

mkdir -p .kanban/tasks/TASK-705
mkdir -p .kanban/tasks/TASK-705/iteration-1
cat > .kanban/tasks/TASK-705/task.json <<'TASK'
{
  "id": "TASK-705",
  "title": "Default Config Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

cat > .kanban/tasks/TASK-705/requirements.md <<'REQ'
# Requirements
## 功能需求
- FR-001: test
## 非功能需求
- NFR-001: test
## 技术约束
- TC-001: test
## 验收标准
- AC-001: test
- AC-002: test
- AC-003: test
REQ

cat > .kanban/tasks/TASK-705/task_breakdown.json <<'BD'
{"task_id":"TASK-705","subtasks":[{"id":"ST-001","title":"t","description":"d","priority":"high","estimated_files":["f.sh"],"dependencies":[]}]}
BD

# guard_check_plan_quality should still work with defaults
QUALITY_RESULT6=$(guard_check_plan_quality "TASK-705" ".kanban/tasks/TASK-705/iteration-1" 2>&1) || true
QUALITY_JSON6=".kanban/tasks/TASK-705/iteration-1/.plan_quality.json"

if [ -f "$QUALITY_JSON6" ]; then
  # Should use default threshold 9.0 when config missing
  THRESHOLD6=$(jq -r '.threshold' "$QUALITY_JSON6")
  assert_equals "9.0" "$THRESHOLD6" "Test6: falls back to default threshold 9.0"

  # Weights should default to 0.25 each (simple average)
  TOTAL_SCORE6=$(jq -r '.total_score' "$QUALITY_JSON6")
  assert_not_empty "$TOTAL_SCORE6" "Test6: total_score calculated with default weights"
else
  fail "Test6: .plan_quality.json not generated without config"
fi

# Verify that the enabled flag defaults to false when missing
# workflow_complete_phase should skip the quality check block
mkdir -p .kanban/tasks/TASK-706
mkdir -p .kanban/tasks/TASK-706/iteration-1
cat > .kanban/tasks/TASK-706/task.json <<'TASK'
{
  "id": "TASK-706",
  "title": "No Config Test",
  "status": "planning",
  "phase": "plan",
  "phase_lock": "plan",
  "iteration": 1,
  "worktree": { "branch": "", "path": "" },
  "scores": {},
  "history": [{"phase":"plan","status":"entered","entered_at":"2026-01-01T00:00:00Z"}],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

cat > .kanban/tasks/TASK-706/requirements.md <<'REQ'
# Requirements
REQ

cat > .kanban/tasks/TASK-706/task_breakdown.json <<'BD'
{"task_id":"TASK-706","subtasks":[]}
BD

COMPLETE_OUTPUT6=$(workflow_complete_phase "TASK-706" 2>&1) || true
echo "$COMPLETE_OUTPUT6" | grep -q "PLAN_QUALITY" && fail "Test6: quality gate ran when config missing (enabled should default false)" || pass "Test6: quality gate skipped when config missing"

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
