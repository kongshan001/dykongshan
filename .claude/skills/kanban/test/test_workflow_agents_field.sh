#!/usr/bin/env bash
# test_workflow_agents_field.sh
# Verify that both workflow.json files contain correct agents arrays
# ST-002: Add agents arrays to workflow.json templates

set -euo pipefail

# --- Test Setup ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Determine project root: walk up from SKILL_DIR until we find .kanban/workflow.json
PROJECT_ROOT="$SKILL_DIR"
while [ "$PROJECT_ROOT" != "/" ]; do
  if [ -f "$PROJECT_ROOT/.kanban/workflow.json" ]; then
    break
  fi
  PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

# Files under test
TEMPLATE_WF="$SKILL_DIR/templates/workflow.json"
RUNTIME_WF="$PROJECT_ROOT/.kanban/workflow.json"

PASS=0
FAIL=0
TESTS=0

pass() {
  PASS=$((PASS + 1))
  TESTS=$((TESTS + 1))
  echo "  PASS: $1"
}

fail() {
  FAIL=$((FAIL + 1))
  TESTS=$((TESTS + 1))
  echo "  FAIL: $1"
}

assert_equals() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    pass "$label"
  else
    fail "$label -- expected='$expected', actual='$actual'"
  fi
}

assert_json_equals() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    pass "$label"
  else
    fail "$label -- expected='$expected', actual='$actual'"
  fi
}

# --- Phase 1: File existence ---
echo "=== Phase 1: File existence ==="

if [ -f "$TEMPLATE_WF" ]; then
  pass "Template workflow.json exists at $TEMPLATE_WF"
else
  fail "Template workflow.json missing at $TEMPLATE_WF"
fi

if [ -f "$RUNTIME_WF" ]; then
  pass "Runtime workflow.json exists at $RUNTIME_WF"
else
  fail "Runtime workflow.json missing at $RUNTIME_WF"
fi

# Validate JSON parseability
for wf in "$TEMPLATE_WF" "$RUNTIME_WF"; do
  label=$(basename "$(dirname "$wf")")/$(basename "$wf")
  if jq . "$wf" > /dev/null 2>&1; then
    pass "$label is valid JSON"
  else
    fail "$label is not valid JSON"
  fi
done

# --- Phase 2: agents arrays exist for each phase ---
echo ""
echo "=== Phase 2: agents arrays in each phase ==="

EXPECTED_AGENTS_PLAN='[{"role":"planner","required":true},{"role":"researcher","required":false,"trigger_condition":{"keywords":["调研","选型","对比","analysis","research","技术选型","竞品"],"match_field":"description"}}]'
EXPECTED_AGENTS_EXECUTE='[{"role":"executor","required":true}]'
EXPECTED_AGENTS_EVALUATE='[{"role":"code_reviewer","required":true},{"role":"qa","required":true},{"role":"pm","required":true},{"role":"designer","required":true}]'
EXPECTED_AGENTS_RETROSPECTIVE='[{"role":"knowledge-manager","required":true}]'
EXPECTED_AGENTS_ARCHIVE='[{"role":"knowledge-manager","required":false}]'

for wf in "$TEMPLATE_WF" "$RUNTIME_WF"; do
  label=$(basename "$(dirname "$wf")")/$(basename "$wf")

  # plan
  actual=$(jq -c '.phases[] | select(.id=="plan") | .agents' "$wf")
  assert_json_equals "$label plan agents" "$EXPECTED_AGENTS_PLAN" "$actual"

  # execute
  actual=$(jq -c '.phases[] | select(.id=="execute") | .agents' "$wf")
  assert_json_equals "$label execute agents" "$EXPECTED_AGENTS_EXECUTE" "$actual"

  # evaluate
  actual=$(jq -c '.phases[] | select(.id=="evaluate") | .agents' "$wf")
  assert_json_equals "$label evaluate agents" "$EXPECTED_AGENTS_EVALUATE" "$actual"

  # retrospective
  actual=$(jq -c '.phases[] | select(.id=="retrospective") | .agents' "$wf")
  assert_json_equals "$label retrospective agents" "$EXPECTED_AGENTS_RETROSPECTIVE" "$actual"

  # archive
  actual=$(jq -c '.phases[] | select(.id=="archive") | .agents' "$wf")
  assert_json_equals "$label archive agents" "$EXPECTED_AGENTS_ARCHIVE" "$actual"
done

# --- Phase 3: required field is boolean ---
echo ""
echo "=== Phase 3: required field is boolean ==="

for wf in "$TEMPLATE_WF" "$RUNTIME_WF"; do
  label=$(basename "$(dirname "$wf")")/$(basename "$wf")

  # Check that all required fields are boolean (true or false)
  non_boolean=$(jq -r '
    [.phases[].agents[]?.required] |
    map(select(type != "boolean")) |
    length
  ' "$wf")

  assert_equals "$label all required fields are boolean" "0" "$non_boolean"
done

# --- Phase 4: Existing fields preserved ---
echo ""
echo "=== Phase 4: Existing fields preserved ==="

for wf in "$TEMPLATE_WF" "$RUNTIME_WF"; do
  label=$(basename "$(dirname "$wf")")/$(basename "$wf")

  # self_improve.max_iterations
  actual=$(jq -r '.self_improve.max_iterations' "$wf")
  assert_equals "$label self_improve.max_iterations" "6" "$actual"

  # user_decision.prerequisite_phase
  actual=$(jq -r '.user_decision.prerequisite_phase' "$wf")
  assert_equals "$label user_decision.prerequisite_phase" "retrospective" "$actual"

  # evaluate.roles (old field preserved)
  actual=$(jq -c '.phases[] | select(.id=="evaluate") | .roles' "$wf")
  assert_equals "$label evaluate.roles preserved" '["code_reviewer","qa","pm","designer"]' "$actual"

  # evaluate.pass_threshold (jq may output 9 or 9.0)
  actual=$(jq '.phases[] | select(.id=="evaluate") | .pass_threshold' "$wf")
  if [ "$actual" = "9" ] || [ "$actual" = "9.0" ]; then
    pass "$label evaluate.pass_threshold"
  else
    fail "$label evaluate.pass_threshold -- expected '9' or '9.0', actual='$actual'"
  fi

  # retrospective.agent (old field preserved)
  actual=$(jq -r '.phases[] | select(.id=="retrospective") | .agent' "$wf")
  assert_equals "$label retrospective.agent preserved" "knowledge-manager" "$actual"

  # retrospective.quality_gate
  actual=$(jq -c '.phases[] | select(.id=="retrospective") | .quality_gate' "$wf")
  assert_equals "$label retrospective.quality_gate preserved" '{"dimensions":[],"pass_threshold":0}' "$actual"

  # plan.required_artifacts
  actual=$(jq -c '.phases[] | select(.id=="plan") | .required_artifacts' "$wf")
  assert_equals "$label plan.required_artifacts preserved" '["requirements.md","task_breakdown.json"]' "$actual"

  # archive.required_artifacts
  actual=$(jq -c '.phases[] | select(.id=="archive") | .required_artifacts' "$wf")
  assert_equals "$label archive.required_artifacts preserved" '["archive_summary.md"]' "$actual"
done

# --- Phase 5: user_decision has no agents ---
echo ""
echo "=== Phase 5: user_decision has no agents ==="

for wf in "$TEMPLATE_WF" "$RUNTIME_WF"; do
  label=$(basename "$(dirname "$wf")")/$(basename "$wf")

  # user_decision is a top-level key, not a phase
  has_user_decision=$(jq 'has("user_decision")' "$wf")
  assert_equals "$label has user_decision section" "true" "$has_user_decision"

  # Verify user_decision does not have agents key
  has_agents=$(jq '.user_decision | has("agents")' "$wf")
  assert_equals "$label user_decision has no agents" "false" "$has_agents"
done

# --- Phase 6: Backward compatibility - get_phase_agents without agents field ---
echo ""
echo "=== Phase 6: Backward compatibility ==="

# Create a temporary workflow.json without agents arrays
TMP_WF=$(mktemp)
trap 'rm -f "$TMP_WF"' EXIT

# Strip agents arrays from the template to simulate old workflow.json
jq '(.phases[].agents) |= empty' "$TEMPLATE_WF" > "$TMP_WF"

# Verify the stripped file is valid JSON
if jq . "$TMP_WF" > /dev/null 2>&1; then
  pass "Stripped workflow.json (no agents) is valid JSON"
else
  fail "Stripped workflow.json is not valid JSON"
fi

# Verify existing fields are intact after stripping agents
actual=$(jq -r '.self_improve.max_iterations' "$TMP_WF")
assert_equals "Stripped: self_improve.max_iterations preserved" "6" "$actual"

actual=$(jq -c '.phases[] | select(.id=="evaluate") | .roles' "$TMP_WF")
assert_equals "Stripped: evaluate.roles preserved" '["code_reviewer","qa","pm","designer"]' "$actual"

# Verify that get_phase_agents returns empty array for stripped workflow
# This simulates the backward-compatible behavior where agent_registry.sh
# functions return empty/defaults when agents field is absent
for phase in plan execute evaluate retrospective archive; do
  agents=$(jq -c ".phases[] | select(.id==\"$phase\") | .agents // []" "$TMP_WF")
  assert_equals "Stripped: $phase agents fallback to []" "[]" "$agents"
done

# --- Phase 7: Verify required role counts ---
echo ""
echo "=== Phase 7: Required role counts ==="

for wf in "$TEMPLATE_WF" "$RUNTIME_WF"; do
  label=$(basename "$(dirname "$wf")")/$(basename "$wf")

  # plan: 1 required (planner), 1 optional (researcher)
  count=$(jq '[.phases[] | select(.id=="plan") | .agents[] | select(.required==true)] | length' "$wf")
  assert_equals "$label plan required count" "1" "$count"

  # execute: 1 required (executor)
  count=$(jq '[.phases[] | select(.id=="execute") | .agents[] | select(.required==true)] | length' "$wf")
  assert_equals "$label execute required count" "1" "$count"

  # evaluate: 4 required
  count=$(jq '[.phases[] | select(.id=="evaluate") | .agents[] | select(.required==true)] | length' "$wf")
  assert_equals "$label evaluate required count" "4" "$count"

  # retrospective: 1 required
  count=$(jq '[.phases[] | select(.id=="retrospective") | .agents[] | select(.required==true)] | length' "$wf")
  assert_equals "$label retrospective required count" "1" "$count"

  # archive: 0 required (knowledge-manager is optional)
  count=$(jq '[.phases[] | select(.id=="archive") | .agents[] | select(.required==true)] | length' "$wf")
  assert_equals "$label archive required count" "0" "$count"
done

# --- Summary ---
echo ""
echo "==============================="
echo "Total: $TESTS tests, $PASS passed, $FAIL failed"
echo "==============================="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
