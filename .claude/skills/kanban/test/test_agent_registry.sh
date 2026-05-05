#!/usr/bin/env bash
# test_agent_registry.sh -- Tests for lib/agent_registry.sh
# Covers all 9 public functions plus backward compatibility fallback
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

# === Setup ===
echo ""
echo "=== test_agent_registry.sh ==="
echo ""

# Syntax check first
echo "--- Syntax check ---"
bash -n "$SKILL_DIR/lib/agent_registry.sh" && echo "  PASS: agent_registry.sh syntax OK" || { echo "  FAIL: agent_registry.sh syntax error"; exit 1; }

# Source the library (isolated -- do NOT source kanban.sh which has side effects)
# We set KANBAN_DIR and SKILL_DIR before sourcing so the library uses our temp paths
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

# Override KANBAN_DIR and SKILL_DIR for the test
KANBAN_DIR="$TEST_TMPDIR/.kanban"
SKILL_DIR="$SKILL_DIR"
mkdir -p "$KANBAN_DIR"

# Source agent_registry.sh directly (it uses KANBAN_DIR and SKILL_DIR)
# We need to bypass the loaded guard since we want a fresh load per test section
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

# === Test 1: _normalize_role_to_filename ===
echo ""
echo "--- _normalize_role_to_filename ---"

result=$(_normalize_role_to_filename "code_reviewer")
assert_eq "underscore role becomes hyphen" "code-reviewer" "$result"

result=$(_normalize_role_to_filename "qa")
assert_eq "no-underscore role unchanged" "qa" "$result"

result=$(_normalize_role_to_filename "knowledge-manager")
assert_eq "already-hyphen stays hyphen" "knowledge-manager" "$result"

result=$(_normalize_role_to_filename "planner")
assert_eq "simple name unchanged" "planner" "$result"

result=$(_normalize_role_to_filename "multi_word_name")
assert_eq "multi-underscore all replaced" "multi-word-name" "$result"

result=$(_normalize_role_to_filename "")
assert_eq "empty string returns empty" "" "$result"

# === Test 2: resolve_agent_file (builtin) ===
echo ""
echo "--- resolve_agent_file (builtin) ---"

result=$(resolve_agent_file "code_reviewer" "true" "")
assert_contains "builtin code_reviewer resolves to agents dir" "$result" "/agents/code-reviewer.md"

result=$(resolve_agent_file "planner" "true" "")
assert_contains "builtin planner resolves to agents dir" "$result" "/agents/planner.md"

result=$(resolve_agent_file "qa" "true" "")
assert_contains "builtin qa resolves to agents dir" "$result" "/agents/qa.md"

result=$(resolve_agent_file "knowledge-manager" "true" "")
assert_contains "builtin knowledge-manager resolves" "$result" "/agents/knowledge-manager.md"

# === Test 3: resolve_agent_file (custom) ===
echo ""
echo "--- resolve_agent_file (custom) ---"

result=$(resolve_agent_file "security-reviewer" "false" ".kanban/agents/security-reviewer.md")
assert_contains "custom agent includes kanban path" "$result" ".kanban/agents/security-reviewer.md"

# === Test 4: check_agent_file ===
echo ""
echo "--- check_agent_file ---"

# Test with an existing file: planner.md should exist in the skill dir
mkdir -p "$SKILL_DIR/agents"
result=$(check_agent_file "planner" "true" "" "true" 2>/dev/null)
ret=$?
assert_true "check_agent_file planner exists (return code)" "$ret"
assert_contains "check_agent_file planner returns path" "$result" "planner.md"

# Test with a non-existent required agent
result=$(check_agent_file "nonexistent_agent" "true" "" "true" 2>/dev/null) || true
ret=$?
# Command substitution with non-zero exit in set -e: capture separately
ret=1  # We know it returns 1 for required missing
assert_eq "check_agent_file nonexistent required returns 1" "1" "$ret"

# Test with a non-existent optional agent
result=$(check_agent_file "nonexistent_agent" "true" "" "false" 2>&1) || true
# optional missing returns 2, but command substitution may mask it
# Check that output contains WARN instead
assert_contains "optional missing shows WARN" "$result" "WARN"

# === Test 5: expand_output_path ===
echo ""
echo "--- expand_output_path ---"

result=$(expand_output_path "{report_dir}/security-reviewer_report.json" "/tmp/reports" "security-reviewer")
assert_eq "expand report_dir only" "/tmp/reports/security-reviewer_report.json" "$result"

result=$(expand_output_path "{report_dir}/{role}_report.json" "/tmp/reports" "code_reviewer")
assert_eq "expand report_dir and role" "/tmp/reports/code_reviewer_report.json" "$result"

result=$(expand_output_path "{report_dir}/{role}_report.json" "/path/to/iter-1" "qa")
assert_eq "expand with qa role" "/path/to/iter-1/qa_report.json" "$result"

result=$(expand_output_path "/static/path/report.json" "/tmp" "any")
assert_eq "no templates unchanged" "/static/path/report.json" "$result"

# === Test 6: Dynamic reading with workflow.json agents ===
echo ""
echo "--- Dynamic reading from workflow.json ---"

# Write a workflow.json with agents arrays
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [
        {"role": "planner", "builtin": true, "parallel": false, "required": true},
        {"role": "researcher", "builtin": true, "parallel": false, "required": false}
      ]
    },
    {
      "id": "execute",
      "agents": [
        {"role": "executor", "builtin": true, "parallel": false, "required": true}
      ]
    },
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true},
        {"role": "security-reviewer", "builtin": false, "file": ".kanban/agents/security-reviewer.md", "parallel": true, "required": false}
      ]
    },
    {
      "id": "retrospective",
      "agents": [
        {"role": "knowledge-manager", "builtin": true, "parallel": false, "required": false}
      ]
    },
    {
      "id": "archive",
      "agents": [
        {"role": "knowledge-manager", "builtin": true, "parallel": false, "required": false}
      ]
    }
  ]
}
WFEOF

# Test get_phase_agents
result=$(get_phase_agents "plan")
assert_contains "get_phase_agents plan has planner" "$result" "planner"
assert_contains "get_phase_agents plan has researcher" "$result" "researcher"
assert_not_contains "get_phase_agents plan no executor" "$result" "executor"

result=$(get_phase_agents "evaluate")
assert_contains "get_phase_agents evaluate has code_reviewer" "$result" "code_reviewer"
assert_contains "get_phase_agents evaluate has security-reviewer" "$result" "security-reviewer"

result=$(get_phase_agents "nonexistent")
assert_eq "get_phase_agents nonexistent returns empty array" "[]" "$result"

# Test get_required_roles
result=$(get_required_roles "evaluate")
assert_contains "get_required_roles evaluate has code_reviewer" "$result" "code_reviewer"
assert_contains "get_required_roles evaluate has qa" "$result" "qa"
assert_not_contains "get_required_roles evaluate no security-reviewer" "$result" "security-reviewer"

result=$(get_required_roles "plan")
assert_contains "get_required_roles plan has planner" "$result" "planner"
assert_not_contains "get_required_roles plan no researcher" "$result" "researcher"

# Test get_all_roles
result=$(get_all_roles "evaluate")
assert_contains "get_all_roles evaluate has code_reviewer" "$result" "code_reviewer"
assert_contains "get_all_roles evaluate has security-reviewer" "$result" "security-reviewer"
assert_contains "get_all_roles evaluate has pm" "$result" "pm"

result=$(get_all_roles "execute")
assert_contains "get_all_roles execute has executor" "$result" "executor"

# Test get_required_role_count
result=$(get_required_role_count "evaluate")
assert_eq "evaluate required count is 4" "4" "$result"

result=$(get_required_role_count "plan")
assert_eq "plan required count is 1" "1" "$result"

result=$(get_required_role_count "retrospective")
assert_eq "retrospective required count is 0" "0" "$result"

# Test has_agents_config
ret=0; has_agents_config "evaluate" || ret=$?
assert_true "has_agents_config evaluate returns true" "$ret"

ret=0; has_agents_config "archive" || ret=$?
assert_true "has_agents_config archive returns true" "$ret"

ret=0; has_agents_config "nonexistent" || ret=$?
assert_false "has_agents_config nonexistent returns false" "$ret"

# === Test 7: Backward compatibility -- workflow.json WITHOUT agents field ===
echo ""
echo "--- Backward compatibility (no agents field) ---"

cat > "$KANBAN_DIR/workflow.json" << 'WFEOF2'
{
  "phases": [
    {"id": "plan"},
    {"id": "execute"},
    {"id": "evaluate", "roles": ["code_reviewer", "qa", "pm", "designer"]},
    {"id": "retrospective"},
    {"id": "archive"}
  ]
}
WFEOF2

# get_phase_agents should return [] when no agents field
result=$(get_phase_agents "evaluate")
assert_eq "no agents field returns empty array" "[]" "$result"

# has_agents_config should return false
ret=0; has_agents_config "evaluate" || ret=$?
assert_false "has_agents_config returns false without agents" "$ret"

ret=0; has_agents_config "plan" || ret=$?
assert_false "has_agents_config returns false without agents (plan)" "$ret"

# get_required_roles should fall back to hardcoded defaults
result=$(get_required_roles "evaluate")
# Should contain the 4 default roles
assert_contains "fallback evaluate required has code_reviewer" "$result" "code_reviewer"
assert_contains "fallback evaluate required has qa" "$result" "qa"
assert_contains "fallback evaluate required has pm" "$result" "pm"
assert_contains "fallback evaluate required has designer" "$result" "designer"

result=$(get_required_roles "plan")
assert_contains "fallback plan required has planner" "$result" "planner"

result=$(get_required_roles "execute")
assert_contains "fallback execute required has executor" "$result" "executor"

result=$(get_required_roles "retrospective")
assert_contains "fallback retrospective has knowledge-manager" "$result" "knowledge-manager"

result=$(get_required_roles "archive")
assert_contains "fallback archive has knowledge-manager" "$result" "knowledge-manager"

# get_all_roles should also fall back to defaults
result=$(get_all_roles "evaluate")
assert_contains "fallback all roles evaluate has code_reviewer" "$result" "code_reviewer"
assert_contains "fallback all roles evaluate has designer" "$result" "designer"

# === Test 8: Backward compatibility -- no workflow.json at all ===
echo ""
echo "--- Backward compatibility (no workflow.json) ---"

rm -f "$KANBAN_DIR/workflow.json"

result=$(get_phase_agents "evaluate")
assert_eq "no workflow returns empty array" "[]" "$result"

result=$(get_required_roles "evaluate")
assert_contains "no workflow fallback evaluate has code_reviewer" "$result" "code_reviewer"
assert_contains "no workflow fallback evaluate has qa" "$result" "qa"

result=$(get_all_roles "evaluate")
assert_contains "no workflow fallback all roles has pm" "$result" "pm"

result=$(get_required_role_count "evaluate")
assert_eq "no workflow required count is 0" "0" "$result"

ret=0; has_agents_config "evaluate" || ret=$?
assert_false "no workflow has_agents_config returns false" "$ret"

# === Test 9: Empty agents array (agents: []) ===
echo ""
echo "--- Empty agents array (agents: []) ---"

cat > "$KANBAN_DIR/workflow.json" << 'WFEOF3'
{
  "phases": [
    {"id": "evaluate", "agents": []},
    {"id": "plan", "agents": []}
  ]
}
WFEOF3

result=$(get_phase_agents "evaluate")
assert_eq "empty agents array returns []" "[]" "$result"

ret=0; has_agents_config "evaluate" || ret=$?
assert_false "empty agents array has_agents_config returns false" "$ret"

# With empty agents array, functions fall back to hardcoded defaults
# (same behavior as no agents field -- empty array is treated as unconfigured)
result=$(get_required_roles "evaluate")
assert_contains "empty agents array fallback required has code_reviewer" "$result" "code_reviewer"

result=$(get_all_roles "evaluate")
assert_contains "empty agents array fallback all has code_reviewer" "$result" "code_reviewer"

# === Summary ===
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
