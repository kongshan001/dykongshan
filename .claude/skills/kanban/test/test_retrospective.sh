#!/usr/bin/env bash
# test_retrospective.sh — Tests for retrospective phase FSM extension
# Run from the worktree root directory

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$(dirname "$SCRIPT_DIR")/lib"
WORKTREE_DIR="$(cd "$(dirname "$SCRIPT_DIR")/../../.." && pwd)"
KANBAN_DIR="$WORKTREE_DIR/.kanban"

# Source the files under test
source "$LIB_DIR/guard.sh"
source "$LIB_DIR/workflow.sh"

pass=0
fail=0
total=0

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  total=$((total + 1))
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected='$expected', actual='$actual')"
    fail=$((fail + 1))
  fi
}

assert_rc() {
  local desc="$1" expected="$2"
  shift 2
  total=$((total + 1))
  if "$@" >/dev/null 2>&1; then
    actual=0
  else
    actual=1
  fi
  if [ "$expected" -eq "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected rc=$expected, got rc=$actual)"
    fail=$((fail + 1))
  fi
}

echo "=== Retrospective FSM Extension Tests ==="
echo ""

# ---- Test Group 1: Transition Validity ----
echo "--- Transition Validity ---"

# evaluate -> retrospective (should succeed, workflow.json has retrospective)
assert_rc "evaluate -> retrospective (with retrospective in config)" 0 \
  guard_check_transition "evaluate" "retrospective"

# retrospective -> user_decision
assert_rc "retrospective -> user_decision" 0 \
  guard_check_transition "retrospective" "user_decision"

# retrospective -> plan (allow iteration fallback)
assert_rc "retrospective -> plan" 0 \
  guard_check_transition "retrospective" "plan"

# retrospective -> execute (allow iteration fallback)
assert_rc "retrospective -> execute" 0 \
  guard_check_transition "retrospective" "execute"

# retrospective -> archive (should fail)
assert_rc "retrospective -> archive (invalid)" 1 \
  guard_check_transition "retrospective" "archive"

# retrospective -> evaluate (should fail)
assert_rc "retrospective -> evaluate (invalid)" 1 \
  guard_check_transition "retrospective" "evaluate"

# evaluate -> user_decision (should fail when retrospective exists in config)
assert_rc "evaluate -> user_decision (blocked when retrospective present)" 1 \
  guard_check_transition "evaluate" "user_decision"

# Plan -> execute still works
assert_rc "plan -> execute (unchanged)" 0 \
  guard_check_transition "plan" "execute"

# execute -> evaluate still works
assert_rc "execute -> evaluate (unchanged)" 0 \
  guard_check_transition "execute" "evaluate"

# user_decision -> archive still works
assert_rc "user_decision -> archive (unchanged)" 0 \
  guard_check_transition "user_decision" "archive"

echo ""

# ---- Test Group 2: Backward Compatibility ----
echo "--- Backward Compatibility (no retrospective phase) ---"

# Temporarily override workflow.json to one without retrospective
ORIG_WORKFLOW="$KANBAN_DIR/workflow.json"
BACKUP_WORKFLOW="$KANBAN_DIR/workflow.json.bak_test"
cp "$ORIG_WORKFLOW" "$BACKUP_WORKFLOW"

# Create a workflow without retrospective
cat > "$ORIG_WORKFLOW" <<'NOWF'
{
  "phases": [
    {"id": "plan"},
    {"id": "execute"},
    {"id": "evaluate"},
    {"id": "archive"}
  ],
  "self_improve": {"max_iterations": 6},
  "user_decision": {"trigger": "all_pass OR max_iterations_reached", "options": ["approve_and_archive"]}
}
NOWF

# evaluate -> user_decision (should succeed, no retrospective in config)
assert_rc "evaluate -> user_decision (no retrospective in config)" 0 \
  guard_check_transition "evaluate" "user_decision"

# evaluate -> retrospective (should fail, no retrospective in config)
assert_rc "evaluate -> retrospective (no retrospective in config)" 1 \
  guard_check_transition "evaluate" "retrospective"

# Restore original workflow.json
mv "$BACKUP_WORKFLOW" "$ORIG_WORKFLOW"

echo ""

# ---- Test Group 3: workflow_has_retrospective ----
echo "--- workflow_has_retrospective ---"

# With current workflow.json (has retrospective)
assert_rc "workflow_has_retrospective (has retrospective)" 0 \
  workflow_has_retrospective

# Without retrospective in config
cp "$ORIG_WORKFLOW" "$BACKUP_WORKFLOW"
cat > "$ORIG_WORKFLOW" <<'NOWF'
{
  "phases": [{"id": "plan"}, {"id": "execute"}, {"id": "evaluate"}, {"id": "archive"}]
}
NOWF

assert_rc "workflow_has_retrospective (no retrospective)" 1 \
  workflow_has_retrospective

mv "$BACKUP_WORKFLOW" "$ORIG_WORKFLOW"

echo ""

# ---- Test Group 4: workflow_next_after_evaluate ----
echo "--- workflow_next_after_evaluate ---"

# With retrospective
result=$(workflow_next_after_evaluate "TASK-001")
assert_eq "next after evaluate (with retrospective)" "retrospective" "$result"

# Without retrospective
cp "$ORIG_WORKFLOW" "$BACKUP_WORKFLOW"
cat > "$ORIG_WORKFLOW" <<'NOWF'
{
  "phases": [{"id": "plan"}, {"id": "execute"}, {"id": "evaluate"}, {"id": "archive"}]
}
NOWF

result=$(workflow_next_after_evaluate "TASK-001")
assert_eq "next after evaluate (without retrospective)" "user_decision" "$result"

mv "$BACKUP_WORKFLOW" "$ORIG_WORKFLOW"

echo ""

# ---- Test Group 5: workflow_next_after_retrospective ----
echo "--- workflow_next_after_retrospective ---"

result=$(workflow_next_after_retrospective)
assert_eq "next after retrospective" "user_decision" "$result"

echo ""

# ---- Test Group 6: Artifact Checks ----
echo "--- Artifact Checks ---"

# Create a temp task for artifact testing
TEST_TASK="TEST-RETRO-001"
TEST_TASK_FILE="$KANBAN_DIR/tasks/${TEST_TASK}.json"
mkdir -p "$KANBAN_DIR/tasks"
cat > "$TEST_TASK_FILE" <<'TASKJSON'
{"task_id":"TEST-RETRO-001","iteration":1,"phase":"retrospective","phase_lock":"retrospective","status":"retrospecting"}
TASKJSON

TEST_REPORT_DIR="$KANBAN_DIR/reports/${TEST_TASK}/iteration-1"
mkdir -p "$TEST_REPORT_DIR"

# Without retrospective.md - should report missing
missing=$(guard_check_artifacts "$TEST_TASK" "retrospective")
assert_eq "retrospective artifact missing" "retrospective.md" "$missing"

# With retrospective.md - should report nothing missing
echo "# Retrospective" > "$TEST_REPORT_DIR/retrospective.md"
missing=$(guard_check_artifacts "$TEST_TASK" "retrospective")
assert_eq "retrospective artifact present" "" "$missing"

# Cleanup test artifacts
rm -f "$TEST_TASK_FILE"
rm -rf "$KANBAN_DIR/reports/${TEST_TASK}"

echo ""

# ---- Test Group 7: workflow.json structure validation ----
echo "--- workflow.json Structure ---"

# Verify retrospective phase is in the right position (after evaluate, before archive)
retro_index=$(jq '[.phases[].id] | index("retrospective")' "$KANBAN_DIR/workflow.json")
eval_index=$(jq '[.phases[].id] | index("evaluate")' "$KANBAN_DIR/workflow.json")
archive_index=$(jq '[.phases[].id] | index("archive")' "$KANBAN_DIR/workflow.json")

total=$((total + 1))
if [ "$retro_index" -gt "$eval_index" ] && [ "$retro_index" -lt "$archive_index" ]; then
  echo "  PASS: retrospective positioned between evaluate and archive (index=$retro_index)"
  pass=$((pass + 1))
else
  echo "  FAIL: retrospective not between evaluate($eval_index) and archive($archive_index), got index=$retro_index"
  fail=$((fail + 1))
fi

# Verify user_decision has prerequisite_phase
prereq=$(jq -r '.user_decision.prerequisite_phase // ""' "$KANBAN_DIR/workflow.json")
assert_eq "user_decision prerequisite_phase" "retrospective" "$prereq"

# Verify retrospective required_artifacts
artifacts=$(jq -r '.phases[] | select(.id=="retrospective") | .required_artifacts[0]' "$KANBAN_DIR/workflow.json")
assert_eq "retrospective required_artifacts[0]" "retrospective.md" "$artifacts"

# Verify retrospective agent
agent=$(jq -r '.phases[] | select(.id=="retrospective") | .agent' "$KANBAN_DIR/workflow.json")
assert_eq "retrospective agent" "knowledge-manager" "$agent"

echo ""
echo "=== Results ==="
echo "Total: $total, Passed: $pass, Failed: $fail"
if [ "$fail" -eq 0 ]; then
  echo "ALL TESTS PASSED"
  exit 0
else
  echo "SOME TESTS FAILED"
  exit 1
fi
