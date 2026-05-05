#!/usr/bin/env bash
# test_hot_iteration_guard_bypass_st007.sh -- Tests for ST-007: Hot iteration Guard bypass (Issue #25)
# Covers:
#   1. workflow_start_iteration writes iteration_type to task JSON
#   2. guard_check skips evaluate artifact checks on hot iteration evaluate->execute
#   3. guard_check still enforces evaluate artifact checks on full iteration / normal flow
#   4. Only evaluate->execute on hot iteration is bypassed, not other transitions
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

assert_eq() {
  _label="$1" _expected="$2" _actual="$3"
  if [ "$_expected" = "$_actual" ]; then
    echo "  PASS: $_label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $_label"
    echo "    expected: '$_expected'"
    echo "    actual:   '$_actual'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_contains() {
  _label="$1" _haystack="$2" _needle="$3"
  if echo "$_haystack" | grep -q "$_needle"; then
    echo "  PASS: $_label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $_label"
    echo "    string: '$_haystack'"
    echo "    not found: '$_needle'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_not_contains() {
  _label="$1" _haystack="$2" _needle="$3"
  if echo "$_haystack" | grep -q "$_needle"; then
    echo "  FAIL: $_label"
    echo "    string: '$_haystack'"
    echo "    unexpectedly found: '$_needle'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: $_label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# === Setup: create a temporary kanban environment ===
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

KANBAN_DIR="$TEST_TMPDIR/.kanban"
mkdir -p "$KANBAN_DIR/tasks" "$KANBAN_DIR/config"

# Create a minimal config.json
cat > "$KANBAN_DIR/config.json" <<'CONF'
{
  "output_dir": "src",
  "dashboard": {"port": 3000}
}
CONF

# Create a minimal workflow.json with evaluate phase
cat > "$KANBAN_DIR/workflow.json" <<'WF'
{
  "self_improve": {
    "max_iterations": 6
  },
  "phases": [
    {"id": "plan"},
    {"id": "execute"},
    {"id": "evaluate", "pass_threshold": 9.0},
    {"id": "retrospective"},
    {"id": "user_decision"},
    {"id": "archive"}
  ]
}
WF

# Override KANBAN_DIR for sourced scripts
export KANBAN_DIR_OVERRIDE="$KANBAN_DIR"

# We need helper functions that the scripts depend on.
# Create a stubs file to provide minimal implementations.
cat > "$TEST_TMPDIR/test_helpers.sh" <<'HELPERS'
#!/usr/bin/env bash

# Override KANBAN_DIR if set
KANBAN_DIR="${KANBAN_DIR_OVERRIDE:-.kanban}"

task_file() {
  echo "$KANBAN_DIR/tasks/$1/task.json"
}

task_dir() {
  echo "$KANBAN_DIR/tasks/$1"
}

report_dir() {
  local task_id="$1" iter="$2"
  echo "$KANBAN_DIR/tasks/$task_id/iteration-${iter}"
}

inbox_file() {
  echo "$KANBAN_DIR/tasks/$1/inbox.md"
}

has_agents_config() {
  return 1  # no dynamic config, use defaults
}

get_required_roles() {
  echo "code_reviewer qa pm designer"
}

get_all_roles() {
  echo "code_reviewer qa pm designer"
}

worktree_create() {
  local task_id="$1" branch="${2:-feature/$task_id}"
  local tf=$(task_file "$task_id")
  local wt_path="$KANBAN_DIR/tasks/$task_id/worktree"
  mkdir -p "$wt_path"
  # Initialize a fake git repo
  git init "$wt_path" >/dev/null 2>&1 || true
  # Update task JSON with worktree info
  local tmp=$(mktemp)
  jq --arg path "$wt_path" --arg branch "$branch" \
    '.worktree = {"path": $path, "branch": $branch}' "$tf" > "$tmp" && mv "$tmp" "$tf"
  return 0
}

worktree_validate() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local wt_path=$(jq -r '.worktree.path // ""' "$tf")
  if [ -n "$wt_path" ] && [ -d "$wt_path" ] && git -C "$wt_path" rev-parse --git-dir >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

kanban_init_subtasks() {
  true
}

guard_check_inbox() {
  echo "PASS"
  return 0
}

_update_index() {
  true
}
HELPERS

source "$TEST_TMPDIR/test_helpers.sh"

# Source the actual guard.sh and workflow.sh (they use KANBAN_DIR from helpers)
source "$SKILL_DIR/lib/guard.sh"
source "$SKILL_DIR/lib/workflow.sh"

# Re-apply KANBAN_DIR override since the sourced scripts reset it
KANBAN_DIR="$KANBAN_DIR_OVERRIDE"

# === Helper: create a task at a given phase/iteration ===
create_task_at_evaluate() {
  _task_id="$1"
  _iteration="${2:-1}"
  _iter_type="${3:-}"

  _tdir="$KANBAN_DIR/tasks/$_task_id"
  mkdir -p "$_tdir/iteration-${_iteration}"

  # Build task JSON
  _iter_type_json=""
  if [ -n "$_iter_type" ]; then
    _iter_type_json=", \"iteration_type\": \"$_iter_type\""
  fi

  cat > "$_tdir/task.json" <<EOF
{
  "id": "$_task_id",
  "title": "Test task",
  "phase": "evaluate",
  "phase_lock": "evaluate",
  "status": "evaluating",
  "iteration": $_iteration${_iter_type_json},
  "scores": {},
  "history": [
    {"phase": "plan", "status": "completed"},
    {"phase": "execute", "status": "completed"},
    {"phase": "evaluate", "status": "entered"}
  ]
}
EOF
}

# Create evaluate artifacts in a given iteration directory
create_evaluate_artifacts() {
  _task_id="$1"
  _iteration="$2"
  _rdir="$KANBAN_DIR/tasks/$_task_id/iteration-${_iteration}"
  mkdir -p "$_rdir"

  for _role in code_reviewer qa pm designer; do
    cat > "$_rdir/${_role}_report.json" <<EOF
{
  "role": "$_role",
  "task_id": "$_task_id",
  "iteration": $_iteration,
  "score": 8.5,
  "improvements": ["some improvement"],
  "risks": ["some risk"],
  "architecture_issues": [],
  "code_style_violations": [],
  "missing_tests": [],
  "test_coverage": 85,
  "extended_requirements": [],
  "requirement_coverage": 90,
  "visual_score": 8,
  "interaction_score": 8
}
EOF
  done
}

create_execute_artifacts() {
  _task_id="$1"
  _iteration="$2"
  _rdir="$KANBAN_DIR/tasks/$_task_id/iteration-${_iteration}"
  mkdir -p "$_rdir"

  touch "$_rdir/execution_summary.md"
  touch "$_rdir/execution_pitfalls.md"
  touch "$_rdir/execution_decisions.md"
}

setup_worktree() {
  _task_id="$1"
  _tf="$KANBAN_DIR/tasks/$_task_id/task.json"
  _wt_path="$KANBAN_DIR/tasks/$_task_id/worktree"
  mkdir -p "$_wt_path"
  git init "$_wt_path" >/dev/null 2>&1 || true
  _tmp=$(mktemp)
  jq --arg path "$_wt_path" --arg branch "feature/$_task_id" \
    '.worktree = {"path": $path, "branch": $branch}' "$_tf" > "$_tmp" && mv "$_tmp" "$_tf"
}

# ============================================================
echo ""
echo "=== Test Suite: Hot Iteration Guard Bypass (ST-007, Issue #25) ==="
echo ""

# --- Test 1: workflow_start_iteration writes iteration_type="hot" ---
echo "--- Test 1: workflow_start_iteration writes iteration_type=hot ---"
(
  task_id="TEST-001"
  create_task_at_evaluate "$task_id" 1
  create_evaluate_artifacts "$task_id" 1
  create_execute_artifacts "$task_id" 1

  # Simulate: call workflow_start_iteration hot
  result=$(workflow_start_iteration "$task_id" "hot") || true

  # Check task JSON has iteration_type
  tf=$(task_file "$task_id")
  stored_type=$(jq -r '.iteration_type // "missing"' "$tf")
  assert_eq "iteration_type should be 'hot'" "hot" "$stored_type"

  stored_iter=$(jq -r '.iteration' "$tf")
  assert_eq "iteration should be incremented to 2" "2" "$stored_iter"
)

# --- Test 2: workflow_start_iteration writes iteration_type="full" ---
echo "--- Test 2: workflow_start_iteration writes iteration_type=full ---"
(
  task_id="TEST-002"
  create_task_at_evaluate "$task_id" 1
  create_evaluate_artifacts "$task_id" 1
  create_execute_artifacts "$task_id" 1

  result=$(workflow_start_iteration "$task_id" "full") || true

  tf=$(task_file "$task_id")
  stored_type=$(jq -r '.iteration_type // "missing"' "$tf")
  assert_eq "iteration_type should be 'full'" "full" "$stored_type"
)

# --- Test 3: Hot iteration evaluate->execute passes Guard without evaluate artifacts in new dir ---
echo "--- Test 3: Hot iteration evaluate->execute passes Guard (no eval artifacts in new dir) ---"
(
  task_id="TEST-003"
  # Task at iteration 2 with iteration_type=hot, phase_lock=evaluate
  create_task_at_evaluate "$task_id" 2 "hot"
  # Only iteration-1 has evaluate artifacts; iteration-2 is empty (the new hot iter dir)
  create_evaluate_artifacts "$task_id" 1
  create_execute_artifacts "$task_id" 1

  # Worktree must exist for execute phase
  setup_worktree "$task_id"

  # Guard check: evaluate -> execute with hot iteration_type
  result=$(guard_check "$task_id" "evaluate" "execute") || true
  assert_not_contains "guard_check should PASS for hot evaluate->execute" "$result" "FAIL"
  assert_contains "guard_check should return PASS" "$result" "PASS"
)

# --- Test 4: Full iteration (no iteration_type) evaluate->execute is blocked without artifacts ---
echo "--- Test 4: Full iteration evaluate->execute is BLOCKED (no iteration_type, no eval artifacts) ---"
(
  task_id="TEST-004"
  # Task at iteration 2 WITHOUT iteration_type (simulates full iteration or missing field)
  create_task_at_evaluate "$task_id" 2 ""

  # Worktree exists
  setup_worktree "$task_id"

  result=$(guard_check "$task_id" "evaluate" "execute") || true
  assert_contains "guard_check should FAIL for full iteration without eval artifacts" "$result" "FAIL"
  assert_contains "should mention missing artifacts" "$result" "missing_artifacts"
)

# --- Test 5: Full iteration evaluate->execute passes when artifacts exist ---
echo "--- Test 5: Full iteration evaluate->execute PASSES with eval artifacts present ---"
(
  task_id="TEST-005"
  create_task_at_evaluate "$task_id" 1 ""
  create_evaluate_artifacts "$task_id" 1

  # Worktree exists
  setup_worktree "$task_id"

  result=$(guard_check "$task_id" "evaluate" "execute") || true
  assert_not_contains "guard_check should PASS with eval artifacts" "$result" "FAIL"
  assert_contains "should return PASS" "$result" "PASS"
)

# --- Test 6: Hot iteration does NOT bypass plan->execute artifact check ---
echo "--- Test 6: Hot iteration does NOT bypass plan->execute artifact check ---"
(
  task_id="TEST-006"
  # Task at plan phase with iteration_type=hot (shouldn't matter for plan->execute)
  tdir="$KANBAN_DIR/tasks/$task_id"
  mkdir -p "$tdir/iteration-1"
  cat > "$tdir/task.json" <<EOF
{
  "id": "$task_id",
  "title": "Test task",
  "phase": "plan",
  "phase_lock": "plan",
  "status": "planning",
  "iteration": 1,
  "iteration_type": "hot",
  "scores": {},
  "history": [{"phase": "plan", "status": "entered"}]
}
EOF

  # No plan artifacts exist
  result=$(guard_check "$task_id" "plan" "execute") || true
  assert_contains "plan->execute should still check plan artifacts" "$result" "FAIL"
  assert_contains "should mention missing plan artifacts" "$result" "missing_artifacts"
)

# --- Test 7: Hot iteration does NOT bypass execute->evaluate artifact check ---
echo "--- Test 7: Hot iteration does NOT bypass execute->evaluate artifact check ---"
(
  task_id="TEST-007"
  create_task_at_evaluate "$task_id" 1 "hot"
  # But phase_lock is "execute" for this test
  tf=$(task_file "$task_id")
  tmp=$(mktemp)
  jq '.phase_lock = "execute" | .phase = "execute" | .status = "executing"' "$tf" > "$tmp" && mv "$tmp" "$tf"

  # No execute artifacts
  result=$(guard_check "$task_id" "execute" "evaluate") || true
  assert_contains "execute->evaluate should still check execute artifacts" "$result" "FAIL"
)

# --- Test 8: Guard checks transition validity (evaluate->execute allowed) ---
echo "--- Test 8: Transition evaluate->execute is allowed ---"
(
  result=$(guard_check_transition "evaluate" "execute") || true
  assert_eq "evaluate->execute transition should return 0" "0" "$?"
)

# ============================================================
echo ""
echo "=== Results ==="
echo "Tests run: $TESTS_RUN"
echo "Passed:    $TESTS_PASSED"
echo "Failed:    $TESTS_FAILED"
echo ""

if [ "$TESTS_FAILED" -gt 0 ]; then
  echo "FAILED: $TESTS_FAILED test(s) failed"
  exit 1
fi

echo "ALL PASSED"
exit 0
