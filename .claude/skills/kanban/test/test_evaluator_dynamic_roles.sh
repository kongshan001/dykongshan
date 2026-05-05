#!/usr/bin/env bash
# test_evaluator_dynamic_roles.sh -- Tests for evaluator.sh dynamic role resolution
# Covers: evaluator_prepare_all, evaluator_check_pass, evaluator_collect_scores
# with dynamic roles from workflow.json and backward compatibility fallbacks
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

assert_false() {
  local label="$1" actual="$2"
  if [ "$actual" != "0" ] && [ "$actual" != "true" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected false, got: '$actual'"
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

# === Setup ===
echo ""
echo "=== test_evaluator_dynamic_roles.sh ==="
echo ""

# Syntax check
echo "--- Syntax check ---"
bash -n "$SKILL_DIR/lib/evaluator.sh" && echo "  PASS: evaluator.sh syntax OK" || { echo "  FAIL: evaluator.sh syntax error"; exit 1; }

# Create isolated test environment
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

# Set up KANBAN_DIR and SKILL_DIR for isolated testing
KANBAN_DIR="$TEST_TMPDIR/.kanban"
TEST_SKILL_DIR="$TEST_TMPDIR/.claude/skills/kanban"
mkdir -p "$KANBAN_DIR"
mkdir -p "$TEST_SKILL_DIR/lib"
mkdir -p "$TEST_SKILL_DIR/templates/reports"
mkdir -p "$TEST_SKILL_DIR/agents"

# Copy the real agent_registry.sh and evaluator.sh into the test skill dir
cp "$SKILL_DIR/lib/agent_registry.sh" "$TEST_SKILL_DIR/lib/agent_registry.sh"
cp "$SKILL_DIR/lib/evaluator.sh" "$TEST_SKILL_DIR/lib/evaluator.sh"
# Copy report templates
cp "$SKILL_DIR/templates/reports/"*.json "$TEST_SKILL_DIR/templates/reports/" 2>/dev/null || true

# Source agent_registry.sh first (evaluator.sh depends on its functions)
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$TEST_SKILL_DIR/lib/agent_registry.sh"

# Define stub/mock helper functions that evaluator.sh depends on
# These match the signatures in kanban.sh but use our isolated KANBAN_DIR
task_file() {
  local task_id="$1"
  echo "$KANBAN_DIR/tasks/${task_id}/task.json"
}

report_dir() {
  local task_id="$1"
  local iter="${2:-}"
  if [ -z "$iter" ]; then
    iter=$(jq -r '.iteration // 1' "$(task_file "$task_id")" 2>/dev/null || echo 1)
  fi
  echo "$KANBAN_DIR/tasks/${task_id}/iteration-${iter}"
}

dispatch_dir() {
  local task_id="$1"
  local dir="$KANBAN_DIR/tasks/${task_id}/dispatch"
  mkdir -p "$dir"
  echo "$dir"
}

kanban_update_task() {
  local task_id="$1" update="$2"
  # Minimal stub for evaluator_record_score testing
}

# Override SKILL_DIR to point to our test copy (for template resolution)
# Must be set BEFORE eval-ing the functions since they capture $SKILL_DIR at eval time
SKILL_DIR="$TEST_SKILL_DIR"

# Now extract and eval the evaluator functions into our environment
eval "$(sed -n '/^evaluator_prepare_all()/,/^}/p' "$TEST_SKILL_DIR/lib/evaluator.sh")"
eval "$(sed -n '/^evaluator_check_pass()/,/^}/p' "$TEST_SKILL_DIR/lib/evaluator.sh")"
eval "$(sed -n '/^evaluator_collect_scores()/,/^}/p' "$TEST_SKILL_DIR/lib/evaluator.sh")"
eval "$(sed -n '/^evaluator_record_score()/,/^}/p' "$TEST_SKILL_DIR/lib/evaluator.sh")"

# =====================================================================
# Test 1: evaluator_prepare_all with dynamic roles (has agents config)
# =====================================================================
echo ""
echo "--- evaluator_prepare_all with dynamic roles ---"

# Set up workflow.json with custom agents
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
      ],
      "pass_threshold": 9.0
    }
  ]
}
WFEOF

# Set up task directory and task.json
TASK_ID="TEST-099"
TASK_DIR="$KANBAN_DIR/tasks/$TASK_ID"
mkdir -p "$TASK_DIR/dispatch"

cat > "$TASK_DIR/task.json" << 'TJSON'
{
  "title": "Test task",
  "description": "A test task for dynamic roles",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake-worktree"},
  "scores": {}
}
TJSON

# Create the config.json
cat > "$KANBAN_DIR/config.json" << 'CFG'
{"output_dir": "games"}
CFG

# Run evaluator_prepare_all
result=$(evaluator_prepare_all "$TASK_ID" 2>&1)
ret=$?
assert_true "evaluator_prepare_all succeeds" "$ret"
assert_contains "prepare all mentions code_reviewer" "$result" "Prepared: code_reviewer"
assert_contains "prepare all mentions security-reviewer" "$result" "Prepared: security-reviewer"
assert_contains "prepare all mentions qa" "$result" "Prepared: qa"
assert_contains "prepare all mentions pm" "$result" "Prepared: pm"
assert_contains "prepare all mentions designer" "$result" "Prepared: designer"

# Verify dispatch files were created
DDIR="$TASK_DIR/dispatch"
assert_file_exists "dispatch for code_reviewer created" "$DDIR/${TASK_ID}-code_reviewer.json"
assert_file_exists "dispatch for qa created" "$DDIR/${TASK_ID}-qa.json"
assert_file_exists "dispatch for pm created" "$DDIR/${TASK_ID}-pm.json"
assert_file_exists "dispatch for designer created" "$DDIR/${TASK_ID}-designer.json"
assert_file_exists "dispatch for security-reviewer created" "$DDIR/${TASK_ID}-security-reviewer.json"

# Verify the custom agent dispatch JSON has default required_fields
security_dispatch=$(cat "$DDIR/${TASK_ID}-security-reviewer.json")
assert_contains "security-reviewer dispatch has required_fields" "$security_dispatch" "score"
assert_contains "security-reviewer dispatch has role field" "$security_dispatch" "security-reviewer"

# Verify builtin agent dispatch JSON has template-based fields
cr_dispatch=$(cat "$DDIR/${TASK_ID}-code_reviewer.json")
assert_contains "code_reviewer dispatch has role" "$cr_dispatch" "code_reviewer"
assert_contains "code_reviewer dispatch has task_id" "$cr_dispatch" "TEST-099"

# =====================================================================
# Test 2: evaluator_prepare_all backward compatibility (no agents config)
# =====================================================================
echo ""
echo "--- evaluator_prepare_all backward compatibility ---"

# Remove agents config from workflow.json (use old format without agents)
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF2'
{
  "phases": [
    {
      "id": "evaluate",
      "roles": ["code_reviewer", "qa", "pm", "designer"],
      "pass_threshold": 9.0
    }
  ]
}
WFEOF2

# Clean up old dispatch files
rm -f "$DDIR"/*.json

result=$(evaluator_prepare_all "$TASK_ID" 2>&1)
ret=$?
assert_true "evaluator_prepare_all backward compat succeeds" "$ret"
assert_contains "backward compat prepare mentions code_reviewer" "$result" "Prepared: code_reviewer"
assert_contains "backward compat prepare mentions qa" "$result" "Prepared: qa"
assert_contains "backward compat prepare mentions pm" "$result" "Prepared: pm"
assert_contains "backward compat prepare mentions designer" "$result" "Prepared: designer"
assert_not_contains "backward compat prepare no security-reviewer" "$result" "Prepared: security-reviewer"

# =====================================================================
# Test 3: evaluator_check_pass with dynamic roles
# =====================================================================
echo ""
echo "--- evaluator_check_pass with dynamic roles ---"

# Set up workflow.json with agents including optional one
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF3'
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
      ],
      "pass_threshold": 9.0
    }
  ]
}
WFEOF3

# All required roles pass
cat > "$TASK_DIR/task.json" << 'TJSON2'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.5, "passed": true},
    "qa": {"score": 9.2, "passed": true},
    "pm": {"score": 9.8, "passed": true},
    "designer": {"score": 9.1, "passed": true},
    "security-reviewer": {"score": 5.0, "passed": false}
  }
}
TJSON2

result=$(evaluator_check_pass "$TASK_ID" 2>&1)
ret=$?
assert_eq "check_pass all required pass returns PASS" "PASS" "$result"
assert_true "check_pass all required pass exit code" "$ret"

# One required role fails (qa below threshold)
cat > "$TASK_DIR/task.json" << 'TJSON3'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.5, "passed": true},
    "qa": {"score": 7.0, "passed": false},
    "pm": {"score": 9.8, "passed": true},
    "designer": {"score": 9.1, "passed": true},
    "security-reviewer": {"score": 5.0, "passed": false}
  }
}
TJSON3

result=""
ret=0
result=$(evaluator_check_pass "$TASK_ID" 2>&1) || ret=$?
assert_contains "check_pass qa fail mentions qa" "$result" "FAIL:qa"
assert_false "check_pass qa fail exit code non-zero" "$ret"

# Verify that optional role failure does NOT cause check_pass to fail
# (security-reviewer at 5.0 is optional, only required roles matter)
cat > "$TASK_DIR/task.json" << 'TJSON4'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.5, "passed": true},
    "qa": {"score": 9.2, "passed": true},
    "pm": {"score": 9.8, "passed": true},
    "designer": {"score": 9.1, "passed": true},
    "security-reviewer": {"score": 3.0, "passed": false}
  }
}
TJSON4

result=$(evaluator_check_pass "$TASK_ID" 2>&1)
ret=$?
assert_eq "check_pass ignores optional role failure" "PASS" "$result"
assert_true "check_pass optional-only failure exit code" "$ret"

# =====================================================================
# Test 4: evaluator_check_pass backward compatibility
# =====================================================================
echo ""
echo "--- evaluator_check_pass backward compatibility ---"

# Remove agents config -- fall back to hardcoded 4 roles
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF4'
{
  "phases": [
    {
      "id": "evaluate",
      "pass_threshold": 9.0
    }
  ]
}
WFEOF4

# All 4 hardcoded roles pass
cat > "$TASK_DIR/task.json" << 'TJSON5'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.5, "passed": true},
    "qa": {"score": 9.2, "passed": true},
    "pm": {"score": 9.8, "passed": true},
    "designer": {"score": 9.1, "passed": true}
  }
}
TJSON5

result=$(evaluator_check_pass "$TASK_ID" 2>&1)
ret=$?
assert_eq "backward compat check_pass returns PASS" "PASS" "$result"
assert_true "backward compat check_pass exit code" "$ret"

# =====================================================================
# Test 5: evaluator_collect_scores with dynamic roles
# =====================================================================
echo ""
echo "--- evaluator_collect_scores with dynamic roles ---"

# Set up workflow.json with custom agent
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF5'
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
      ],
      "pass_threshold": 9.0
    }
  ]
}
WFEOF5

# Set up scores including optional agent
cat > "$TASK_DIR/task.json" << 'TJSON6'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.5, "passed": true},
    "qa": {"score": 8.5, "passed": false},
    "pm": {"score": 9.8, "passed": true},
    "designer": {"score": 9.1, "passed": true},
    "security-reviewer": {"score": 7.0, "passed": false}
  }
}
TJSON6

result=$(evaluator_collect_scores "$TASK_ID" 2>&1)
assert_contains "collect_scores shows code_reviewer" "$result" "code_reviewer"
assert_contains "collect_scores shows qa" "$result" "qa"
assert_contains "collect_scores shows pm" "$result" "pm"
assert_contains "collect_scores shows designer" "$result" "designer"
assert_contains "collect_scores shows security-reviewer" "$result" "security-reviewer"
assert_contains "collect_scores marks optional" "$result" "(optional)"
assert_contains "collect_scores shows dynamic count (5/5)" "$result" "5/5 roles scored"

# =====================================================================
# Test 6: evaluator_collect_scores backward compatibility
# =====================================================================
echo ""
echo "--- evaluator_collect_scores backward compatibility ---"

# No agents config
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF6'
{
  "phases": [
    {
      "id": "evaluate",
      "pass_threshold": 9.0
    }
  ]
}
WFEOF6

cat > "$TASK_DIR/task.json" << 'TJSON7'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.0, "passed": true},
    "qa": {"score": 9.2, "passed": true},
    "pm": {"score": 9.5, "passed": true},
    "designer": {"score": 9.1, "passed": true}
  }
}
TJSON7

result=$(evaluator_collect_scores "$TASK_ID" 2>&1)
assert_contains "backward compat collect has code_reviewer" "$result" "code_reviewer"
assert_contains "backward compat collect has designer" "$result" "designer"
assert_not_contains "backward compat collect no (optional) label" "$result" "(optional)"
assert_contains "backward compat collect shows 4/4 count" "$result" "4/4 roles scored"

# =====================================================================
# Test 7: evaluator_collect_scores with partial scores
# =====================================================================
echo ""
echo "--- evaluator_collect_scores with partial scores ---"

# Back to dynamic agents config
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF7'
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
      ],
      "pass_threshold": 9.0
    }
  ]
}
WFEOF7

# Only some roles have scores
cat > "$TASK_DIR/task.json" << 'TJSON8'
{
  "title": "Test task",
  "description": "test",
  "iteration": 1,
  "worktree": {"path": "/tmp/fake"},
  "scores": {
    "code_reviewer": {"score": 9.5, "passed": true},
    "qa": {"score": 9.2, "passed": true}
  }
}
TJSON8

result=$(evaluator_collect_scores "$TASK_ID" 2>&1)
assert_contains "partial scores shows 2/5 count" "$result" "2/5 roles scored"
assert_contains "partial scores shows N/A for missing pm" "$result" "pm: N/A"

# =====================================================================
# Test 8: evaluator_prepare_all with no workflow.json at all
# =====================================================================
echo ""
echo "--- evaluator_prepare_all with no workflow.json ---"

rm -f "$KANBAN_DIR/workflow.json"
rm -f "$DDIR"/*.json

result=$(evaluator_prepare_all "$TASK_ID" 2>&1)
ret=$?
assert_true "prepare_all no workflow succeeds" "$ret"
assert_contains "prepare_all no workflow has code_reviewer" "$result" "Prepared: code_reviewer"
assert_contains "prepare_all no workflow has designer" "$result" "Prepared: designer"
assert_not_contains "prepare_all no workflow no custom agent" "$result" "security-reviewer"

# =====================================================================
# Summary
# =====================================================================
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
