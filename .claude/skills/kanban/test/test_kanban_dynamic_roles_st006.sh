#!/usr/bin/env bash
# test_kanban_dynamic_roles_st006.sh -- Tests for ST-006: kanban.sh dynamic roles
# Covers: _get_eval_roles, _get_eval_required_roles, dynamic header in kanban_score_history
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIB_DIR="$SKILL_DIR/lib"

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

# Helper: source libraries and override KANBAN_DIR to our test temp dir
# This follows the same pattern as test_kanban_st003.sh's source_lib()
source_lib() {
  unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  source "$LIB_DIR/kanban.sh"
  # Override KANBAN_DIR AFTER source (kanban.sh sets it to ".kanban" on line 9)
  KANBAN_DIR="$_TEST_KANBAN_DIR"
  SKILL_DIR="$_SAVED_SKILL_DIR"
}

# === Setup ===
echo ""
echo "=== test_kanban_dynamic_roles_st006.sh ==="
echo ""

# Syntax check first
echo "--- Syntax check ---"
bash -n "$LIB_DIR/kanban.sh" && echo "  PASS: kanban.sh syntax OK" || { echo "  FAIL: kanban.sh syntax error"; exit 1; }

# Create isolated test environment
_TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$_TEST_TMPDIR"' EXIT
_TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
_SAVED_SKILL_DIR="$SKILL_DIR"
mkdir -p "$_TEST_KANBAN_DIR"

# Setup: create minimal config and index
jq -n '{project:"test",trunk:"main",output_dir:"src"}' > "$_TEST_KANBAN_DIR/config.json"
jq -n '{project:"test",trunk:"main",tasks:[]}' > "$_TEST_KANBAN_DIR/index.json"

# Source libraries (KANBAN_DIR will be set to test temp dir)
source_lib

# === Test 1: _get_eval_roles fallback (no workflow.json) ===
echo ""
echo "--- _get_eval_roles fallback (no workflow.json) ---"

rm -f "$KANBAN_DIR/workflow.json"

result=$(_get_eval_roles)
assert_contains "fallback has code_reviewer" "$result" "code_reviewer"
assert_contains "fallback has qa" "$result" "qa"
assert_contains "fallback has pm" "$result" "pm"
assert_contains "fallback has designer" "$result" "designer"

# Verify the fallback output is space-separated
local_count=$(echo "$result" | wc -w | tr -d ' ')
assert_eq "fallback returns 4 roles" "4" "$local_count"

# === Test 2: _get_eval_required_roles fallback (no workflow.json) ===
echo ""
echo "--- _get_eval_required_roles fallback (no workflow.json) ---"

result=$(_get_eval_required_roles)
assert_contains "required fallback has code_reviewer" "$result" "code_reviewer"
assert_contains "required fallback has qa" "$result" "qa"
assert_contains "required fallback has pm" "$result" "pm"
assert_contains "required fallback has designer" "$result" "designer"

# === Test 3: _get_eval_roles with agents config ===
echo ""
echo "--- _get_eval_roles with agents config ---"

cat > "$KANBAN_DIR/workflow.json" << 'WFEOF'
{
  "phases": [
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true},
        {"role": "security-reviewer", "builtin": false, "file": ".kanban/agents/security-reviewer.md", "parallel": true, "required": false}
      ]
    }
  ]
}
WFEOF

# Reset agent_registry loaded guard to pick up new workflow.json
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$LIB_DIR/agent_registry.sh"

result=$(_get_eval_roles)
assert_contains "dynamic has code_reviewer" "$result" "code_reviewer"
assert_contains "dynamic has qa" "$result" "qa"
assert_contains "dynamic has pm" "$result" "pm"
assert_contains "dynamic has designer" "$result" "designer"
assert_contains "dynamic has security-reviewer" "$result" "security-reviewer"

local_count=$(echo "$result" | wc -w | tr -d ' ')
assert_eq "dynamic returns 5 roles" "5" "$local_count"

# === Test 4: _get_eval_required_roles with agents config ===
echo ""
echo "--- _get_eval_required_roles with agents config ---"

result=$(_get_eval_required_roles)
assert_contains "dynamic required has code_reviewer" "$result" "code_reviewer"
assert_contains "dynamic required has qa" "$result" "qa"
assert_not_contains "dynamic required no security-reviewer" "$result" "security-reviewer"

local_count=$(echo "$result" | wc -w | tr -d ' ')
assert_eq "dynamic required returns 4 roles" "4" "$local_count"

# === Test 5: kanban_show_task uses dynamic roles ===
echo ""
echo "--- kanban_show_task uses dynamic roles ---"

# Create a task with scores including the custom role
mkdir -p "$KANBAN_DIR/tasks/TASK-099"
jq -n '{
  id: "TASK-099",
  title: "Test dynamic roles",
  status: "completed",
  phase: "archive",
  iteration: 1,
  scores: {
    code_reviewer: {score: 9.0, passed: true},
    qa: {score: 8.5, passed: true},
    pm: {score: 9.2, passed: true},
    designer: {score: 8.8, passed: true},
    "security-reviewer": {score: 7.5, passed: false}
  },
  task_breakdown: {subtasks: []},
  history: [],
  requires_archive_confirmation: false
}' > "$KANBAN_DIR/tasks/TASK-099/task.json"

# Update index
jq '.tasks += [{id:"TASK-099",status:"completed",phase:"archive",iteration:1}]' "$KANBAN_DIR/index.json" > "$KANBAN_DIR/index.json.tmp" && mv "$KANBAN_DIR/index.json.tmp" "$KANBAN_DIR/index.json"

output=$(kanban_show_task "TASK-099" 2>/dev/null)
assert_contains "show_task shows code_reviewer score" "$output" "code_reviewer"
assert_contains "show_task shows security-reviewer score" "$output" "security-reviewer"
assert_contains "show_task shows 7.5" "$output" "7.5"

# === Test 6: kanban_score_history dynamic header ===
echo ""
echo "--- kanban_score_history dynamic header ---"

# Create iteration-1 with reports for all 5 roles
mkdir -p "$KANBAN_DIR/tasks/TASK-099/iteration-1"
for role in code_reviewer qa pm designer; do
  jq -n --arg role "$role" '{role: $role, score: 9.0, improvements: [], risks: []}' \
    > "$KANBAN_DIR/tasks/TASK-099/iteration-1/${role}_report.json"
done
jq -n '{role: "security-reviewer", score: 7.5, improvements: ["test"], risks: []}' \
  > "$KANBAN_DIR/tasks/TASK-099/iteration-1/security-reviewer_report.json"

output=$(kanban_score_history "TASK-099" 2>/dev/null)
assert_contains "score_history header has code_reviewer" "$output" "code_reviewer"
assert_contains "score_history header has security-reviewer" "$output" "security-reviewer"
assert_contains "score_history shows Avg" "$output" "Avg"

# === Test 7: kanban_score_history fallback header (no workflow.json) ===
echo ""
echo "--- kanban_score_history fallback header (no workflow.json) ---"

rm -f "$KANBAN_DIR/workflow.json"
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$LIB_DIR/agent_registry.sh"

output=$(kanban_score_history "TASK-099" 2>/dev/null)
assert_contains "fallback header has code_reviewer" "$output" "code_reviewer"
assert_contains "fallback header has qa" "$output" "qa"
assert_not_contains "fallback header no security-reviewer" "$output" "security-reviewer"

# === Test 8: kanban_iteration_summary uses dynamic roles ===
echo ""
echo "--- kanban_iteration_summary uses dynamic roles ---"

# Restore workflow.json with 5 agents
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF2'
{
  "phases": [
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true},
        {"role": "security-reviewer", "builtin": false, "file": ".kanban/agents/security-reviewer.md", "parallel": true, "required": false}
      ]
    }
  ]
}
WFEOF2

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$LIB_DIR/agent_registry.sh"

output=$(kanban_iteration_summary "TASK-099" 2>/dev/null)
assert_contains "iteration_summary shows code_reviewer" "$output" "code_reviewer"
assert_contains "iteration_summary shows security-reviewer" "$output" "security-reviewer"

# === Test 9: kanban_changes_summary uses dynamic roles ===
echo ""
echo "--- kanban_changes_summary uses dynamic roles ---"

# Reset worktree path to empty to avoid git operations in test env
jq '.worktree.path = "" | .worktree.branch = ""' "$KANBAN_DIR/tasks/TASK-099/task.json" > "$_TEST_TMPDIR/task099_tmp.json" && mv "$_TEST_TMPDIR/task099_tmp.json" "$KANBAN_DIR/tasks/TASK-099/task.json"

output=$(kanban_changes_summary "TASK-099" 2>/dev/null)
assert_contains "changes_summary shows code_reviewer" "$output" "code_reviewer"
assert_contains "changes_summary shows security-reviewer" "$output" "security-reviewer"

# === Test 10: Verify no hardcoded for loops remain ===
echo ""
echo "--- Verify no hardcoded role loops remain ---"

hardcoded_count=$(grep -c 'for role in code_reviewer qa pm designer' "$LIB_DIR/kanban.sh" || true)
assert_eq "no hardcoded role loops in kanban.sh" "0" "$hardcoded_count"

# Verify dynamic calls are present
dynamic_count=$(grep -c 'for role in \$(_get_eval_roles)' "$LIB_DIR/kanban.sh" || true)
assert_eq "8 dynamic role loops in kanban.sh" "8" "$dynamic_count"

# Verify helper functions exist
helper_count=$(grep -c '_get_eval_roles()' "$LIB_DIR/kanban.sh" || true)
assert_eq "_get_eval_roles function defined" "1" "$helper_count"

helper_required_count=$(grep -c '_get_eval_required_roles()' "$LIB_DIR/kanban.sh" || true)
assert_eq "_get_eval_required_roles function defined" "1" "$helper_required_count"

# === Test 11: Backward compat - workflow.json without agents field ===
echo ""
echo "--- Backward compat: workflow.json without agents field ---"

cat > "$KANBAN_DIR/workflow.json" << 'WFEOF3'
{
  "phases": [
    {"id": "evaluate", "roles": ["code_reviewer", "qa", "pm", "designer"]}
  ]
}
WFEOF3

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$LIB_DIR/agent_registry.sh"

result=$(_get_eval_roles)
assert_contains "no-agents field fallback has code_reviewer" "$result" "code_reviewer"
assert_contains "no-agents field fallback has qa" "$result" "qa"
assert_contains "no-agents field fallback has pm" "$result" "pm"
assert_contains "no-agents field fallback has designer" "$result" "designer"

local_count=$(echo "$result" | wc -w | tr -d ' ')
assert_eq "no-agents field fallback returns 4 roles" "4" "$local_count"

# === Test 12: kanban_progress uses dynamic roles ===
echo ""
echo "--- kanban_progress uses dynamic roles ---"

# Restore workflow.json with 5 agents for progress test
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF4'
{
  "phases": [
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true},
        {"role": "security-reviewer", "builtin": false, "file": ".kanban/agents/security-reviewer.md", "parallel": true, "required": false}
      ]
    }
  ]
}
WFEOF4

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$LIB_DIR/agent_registry.sh"

output=$(kanban_progress "TASK-099" 2>/dev/null)
assert_contains "progress shows security-reviewer" "$output" "security-reviewer"
assert_contains "progress shows code_reviewer" "$output" "code_reviewer"

# === Summary ===
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
