#!/usr/bin/env bash
# test_workflow_dynamic_roles_st005.sh -- Tests for ST-005: workflow_self_improve_check dynamic roles
# Covers: dynamic role resolution, backward compat fallback, architecture issue check preserved,
#         hot/full iteration decision with custom roles, required=false roles excluded
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIB_DIR="$SKILL_DIR/lib"

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

_TEST_TMPDIR=""
_TEST_KANBAN_DIR=""

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

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -q "$needle"; then
    echo "  FAIL: $label"
    echo "    string: '$haystack'"
    echo "    unexpectedly found: '$needle'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Setup: create isolated test environment
setup() {
  _TEST_TMPDIR=$(mktemp -d /tmp/kanban_test_st005.XXXXXX)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch,worktrees}

  # Create minimal config
  cat > "$_TEST_KANBAN_DIR/config.json" << 'EOF'
{
  "project": "test",
  "trunk": "main",
  "output_dir": "games",
  "framework_assessment": { "enabled": false }
}
EOF

  # Default workflow.json WITHOUT agents field (backward compat baseline)
  cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    { "id": "evaluate", "name": "Evaluation", "pass_threshold": 9.0 },
    { "id": "retrospective", "name": "Retrospective" },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

  cat > "$_TEST_KANBAN_DIR/index.json" << 'EOF'
{ "project": "test", "trunk": "main", "tasks": [] }
EOF

  # Initialize git repo in tmpdir
  cd "$_TEST_TMPDIR"
  git init -q 2>/dev/null || true
  git config user.email "test@test.com" 2>/dev/null || true
  git config user.name "Test" 2>/dev/null || true
  echo "init" > README.md 2>/dev/null
  git add . 2>/dev/null || true
  git commit -m "init" -q 2>/dev/null || true

  # Source all libs (agent_registry.sh is loaded via glob in kanban_init_env)
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
  source "$LIB_DIR/kanban.sh"
  kanban_init_env 2>/dev/null || true
  KANBAN_DIR="$_TEST_KANBAN_DIR"
}

teardown() {
  if [ -n "$_TEST_TMPDIR" ] && [ -d "$_TEST_TMPDIR" ]; then
    cd /
    rm -rf "$_TEST_TMPDIR"
  fi
}

# Helper: create a new-format task with scores
create_task_with_scores() {
  local task_id="$1"
  shift
  local now=$(date -u +%FT%TZ)
  mkdir -p "$_TEST_KANBAN_DIR/tasks/${task_id}"
  local scores_json="{}"
  # Build scores from remaining args: role:score pairs
  while [ $# -gt 0 ]; do
    local pair="$1"
    local role="${pair%%:*}"
    local score="${pair##*:}"
    scores_json=$(echo "$scores_json" | jq --arg r "$role" --arg s "$score" '. + {($r): {score: ($s | tonumber)}}')
    shift
  done
  jq -n \
    --arg id "$task_id" --arg title "Test task" --arg now "$now" \
    --argjson scores "$scores_json" \
    '{
      id: $id, title: $title, description: "", engine: "claude-code",
      status: "pending", phase: "evaluate", phase_lock: "evaluate", assignee: null,
      worktree: { branch: "feature/'$task_id'", path: "", base: "main" },
      iteration: 1, max_iterations: 6, token_budget: 500000, token_used: 0,
      scores: $scores, depends_on: [], modified_files: [],
      task_breakdown: { file: "", subtasks: [] }, history: [],
      user_decision: null, requires_archive_confirmation: false,
      created_at: $now, updated_at: $now, entered_at: $now
    }' > "$_TEST_KANBAN_DIR/tasks/${task_id}/task.json"
}

# Helper: create plan artifacts for hot iteration eligibility
create_plan_artifacts() {
  local task_id="$1"
  mkdir -p "$_TEST_KANBAN_DIR/tasks/${task_id}"
  echo "# Requirements" > "$_TEST_KANBAN_DIR/tasks/${task_id}/requirements.md"
  echo '{ "task_id": "'$task_id'", "subtasks": [] }' > "$_TEST_KANBAN_DIR/tasks/${task_id}/task_breakdown.json"
}

# ============================================================
echo "========================================="
echo "ST-005: workflow_self_improve_check dynamic roles"
echo "========================================="

# ============================================================
echo ""
echo "--- Test 1: Backward compat -- no agents field, all scores pass ---"
setup

create_task_with_scores "TASK-T1" "code_reviewer:9.5" "qa:9.2" "pm:9.0" "designer:9.1"
result=$(workflow_self_improve_check "TASK-T1")
assert_eq "backward compat all pass returns all_pass" "all_pass" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 2: Backward compat -- no agents field, one score below threshold ---"
setup

create_task_with_scores "TASK-T2" "code_reviewer:8.0" "qa:9.5" "pm:9.0" "designer:9.1"
create_plan_artifacts "TASK-T2"
result=$(workflow_self_improve_check "TASK-T2")
# min_score=8.0 >= 7.0 and no arch issues -> hot iteration
assert_eq "backward compat low score returns hot" "hot" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 3: Backward compat -- very low score triggers full iteration ---"
setup

create_task_with_scores "TASK-T3" "code_reviewer:5.0" "qa:9.5" "pm:9.0" "designer:9.1"
create_plan_artifacts "TASK-T3"
result=$(workflow_self_improve_check "TASK-T3")
# min_score=5.0 < 7.0 -> full iteration
assert_eq "backward compat very low score returns full" "full" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 4: Backward compat -- architecture issues triggers full iteration ---"
setup

# Create task with arch issues (score >= 7.0 but has architecture issues)
create_task_with_scores "TASK-T4" "code_reviewer:8.0" "qa:9.5" "pm:9.0" "designer:9.1"
create_plan_artifacts "TASK-T4"
# Add architecture issues to code_reviewer score
tf="$_TEST_KANBAN_DIR/tasks/TASK-T4/task.json"
tmp=$(mktemp)
jq '.scores.code_reviewer.report_architecture_issues = ["circular dependency"]' "$tf" > "$tmp" && mv "$tmp" "$tf"

result=$(workflow_self_improve_check "TASK-T4")
# Has architecture issues -> full iteration (not hot)
assert_eq "arch issues triggers full iteration" "full" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 5: Dynamic roles with agents field -- all pass ---"
setup

# Write workflow.json WITH agents field (standard 4 required roles)
cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    {
      "id": "evaluate",
      "name": "Evaluation",
      "pass_threshold": 9.0,
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true}
      ]
    },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

create_task_with_scores "TASK-T5" "code_reviewer:9.5" "qa:9.2" "pm:9.0" "designer:9.1"
result=$(workflow_self_improve_check "TASK-T5")
assert_eq "dynamic roles all pass returns all_pass" "all_pass" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 6: Dynamic roles -- extra optional agent score does not affect threshold ---"
setup

# Write workflow.json with 4 required + 1 optional agent
cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    {
      "id": "evaluate",
      "name": "Evaluation",
      "pass_threshold": 9.0,
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true},
        {"role": "security-reviewer", "builtin": false, "file": ".kanban/agents/security-reviewer.md", "parallel": true, "required": false}
      ]
    },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

# 4 required agents pass, optional agent has low score
create_task_with_scores "TASK-T6" "code_reviewer:9.5" "qa:9.2" "pm:9.0" "designer:9.1" "security-reviewer:3.0"
result=$(workflow_self_improve_check "TASK-T6")
# Optional agent's low score should NOT prevent all_pass
assert_eq "optional low score does not block all_pass" "all_pass" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 7: Dynamic roles -- required agent low score still triggers iteration ---"
setup

# Same config as Test 6 with optional agent
cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    {
      "id": "evaluate",
      "name": "Evaluation",
      "pass_threshold": 9.0,
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true},
        {"role": "security-reviewer", "builtin": false, "file": ".kanban/agents/security-reviewer.md", "parallel": true, "required": false}
      ]
    },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

# Required agent qa has low score, optional has high score
create_task_with_scores "TASK-T7" "code_reviewer:9.5" "qa:7.5" "pm:9.0" "designer:9.1" "security-reviewer:10.0"
create_plan_artifacts "TASK-T7"
result=$(workflow_self_improve_check "TASK-T7")
# Required qa=7.5 < 9.0 threshold, but >= 7.0 -> hot iteration
assert_eq "required low score triggers hot iteration" "hot" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 8: Dynamic roles -- architecture issue check still references code_reviewer ---"
setup

# Standard 4-role dynamic config
cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    {
      "id": "evaluate",
      "name": "Evaluation",
      "pass_threshold": 9.0,
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true}
      ]
    },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

# Scores are >= 7.0 but code_reviewer has arch issues -> full iteration
create_task_with_scores "TASK-T8" "code_reviewer:8.0" "qa:9.0" "pm:9.0" "designer:9.0"
create_plan_artifacts "TASK-T8"
tf="$_TEST_KANBAN_DIR/tasks/TASK-T8/task.json"
tmp=$(mktemp)
jq '.scores.code_reviewer.report_architecture_issues = ["bad design"]' "$tf" > "$tmp" && mv "$tmp" "$tf"

result=$(workflow_self_improve_check "TASK-T8")
assert_eq "arch issues with dynamic roles still triggers full" "full" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 9: Max iterations reached ---"
setup

create_task_with_scores "TASK-T9" "code_reviewer:5.0" "qa:9.0" "pm:9.0" "designer:9.0"
# Set iteration to max
tf="$_TEST_KANBAN_DIR/tasks/TASK-T9/task.json"
tmp=$(mktemp)
jq '.iteration = 6' "$tf" > "$tmp" && mv "$tmp" "$tf"

result=$(workflow_self_improve_check "TASK-T9")
assert_eq "max iterations returns max_reached" "max_reached" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 10: Verify hardcoded code_reviewer reference preserved in source ---"
# Grep that the architecture issues check still references code_reviewer directly
arch_check=$(grep -c 'scores\.code_reviewer\.report_architecture_issues' "$LIB_DIR/workflow.sh" || true)
assert_eq "code_reviewer arch issue check preserved in source" "1" "$arch_check"

# Verify no remaining hardcoded role loops (the old pattern)
# Count occurrences of "for role in code_reviewer qa pm designer" in workflow.sh
hardcoded_count=$(grep -c 'for role in code_reviewer qa pm designer' "$LIB_DIR/workflow.sh" || true)
assert_eq "no hardcoded role loops remain in workflow.sh" "0" "$hardcoded_count"

# ============================================================
echo ""
echo "--- Test 11: Custom required roles only (no standard 4) ---"
setup

# Config with only 2 custom required roles
cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    {
      "id": "evaluate",
      "name": "Evaluation",
      "pass_threshold": 9.0,
      "agents": [
        {"role": "custom_reviewer_a", "builtin": false, "file": ".kanban/agents/custom-a.md", "parallel": true, "required": true},
        {"role": "custom_reviewer_b", "builtin": false, "file": ".kanban/agents/custom-b.md", "parallel": true, "required": true}
      ]
    },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

# Both custom roles pass
create_task_with_scores "TASK-T11" "custom_reviewer_a:9.5" "custom_reviewer_b:9.2"
result=$(workflow_self_improve_check "TASK-T11")
assert_eq "custom required roles all pass returns all_pass" "all_pass" "$result"

teardown

# ============================================================
echo ""
echo "--- Test 12: Custom required roles -- one below threshold triggers hot ---"
setup

cat > "$_TEST_KANBAN_DIR/workflow.json" << 'WEOF'
{
  "phases": [
    { "id": "plan", "name": "Planning" },
    { "id": "execute", "name": "Execution" },
    {
      "id": "evaluate",
      "name": "Evaluation",
      "pass_threshold": 9.0,
      "agents": [
        {"role": "custom_reviewer_a", "builtin": false, "file": ".kanban/agents/custom-a.md", "parallel": true, "required": true},
        {"role": "custom_reviewer_b", "builtin": false, "file": ".kanban/agents/custom-b.md", "parallel": true, "required": true}
      ]
    },
    { "id": "archive", "name": "Archive" }
  ],
  "self_improve": { "max_iterations": 6 }
}
WEOF

create_task_with_scores "TASK-T12" "custom_reviewer_a:7.5" "custom_reviewer_b:9.2"
create_plan_artifacts "TASK-T12"
result=$(workflow_self_improve_check "TASK-T12")
assert_eq "custom required roles low score triggers hot" "hot" "$result"

teardown

# ============================================================
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
