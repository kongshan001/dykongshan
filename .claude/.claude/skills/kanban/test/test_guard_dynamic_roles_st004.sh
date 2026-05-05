#!/usr/bin/env bash
# test_guard_dynamic_roles_st004.sh -- Tests for ST-004: guard.sh dynamic roles refactor
# Covers: guard_check_artifacts (evaluate branch) and guard_check_evaluation
# Uses dynamic role lookup via agent_registry.sh with backward compatibility fallback
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
echo "=== test_guard_dynamic_roles_st004.sh ==="
echo ""

# Syntax check
echo "--- Syntax check ---"
bash -n "$SKILL_DIR/lib/guard.sh" && echo "  PASS: guard.sh syntax OK" || { echo "  FAIL: guard.sh syntax error"; exit 1; }
bash -n "$SKILL_DIR/lib/agent_registry.sh" && echo "  PASS: agent_registry.sh syntax OK" || { echo "  FAIL: agent_registry.sh syntax error"; exit 1; }

# Create temp directory for test isolation
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

# Setup environment
KANBAN_DIR="$TEST_TMPDIR/.kanban"
SKILL_DIR_ORIG="$SKILL_DIR"
mkdir -p "$KANBAN_DIR/tasks/TASK-099/iteration-1"

# We need to source guard.sh which depends on task_file, report_dir, and agent_registry.sh.
# Rather than sourcing the full kanban.sh (heavy side effects), we provide minimal stubs.

# Stub: task_file returns path to the task JSON
task_file() {
  echo "$KANBAN_DIR/tasks/$1/task.json"
}

# Stub: report_dir returns path to iteration directory
report_dir() {
  echo "$KANBAN_DIR/tasks/$1/iteration-$2"
}

# Source agent_registry.sh
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

# Source guard.sh (it re-declares KANBAN_DIR at top-level, so we override after)
source "$SKILL_DIR/lib/guard.sh"

# Override KANBAN_DIR again since guard.sh sets it to ".kanban"
KANBAN_DIR="$TEST_TMPDIR/.kanban"

# Helper: create a minimal task.json
create_task_json() {
  local task_id="$1"
  local task_dir="$KANBAN_DIR/tasks/$task_id"
  mkdir -p "$task_dir"
  cat > "$task_dir/task.json" <<EOF
{
  "id": "$task_id",
  "title": "Test Task",
  "phase": "evaluate",
  "iteration": 1
}
EOF
}

# Helper: create a valid report JSON for a role
create_report_json() {
  local rdir="$1"
  local role="$2"
  shift 2
  # Remaining args are extra fields as key=value pairs
  mkdir -p "$rdir"

  local extra_fields=""
  while [ $# -gt 0 ]; do
    local key="$1"; shift
    local val="$1"; shift
    extra_fields="${extra_fields}, \"$key\": $val"
  done

  # Build role-specific required fields
  local role_fields=""
  case "$role" in
    code_reviewer)
      role_fields=', "architecture_issues": [], "code_style_violations": []'
      ;;
    qa)
      role_fields=', "missing_tests": [], "test_coverage": 0.8'
      ;;
    pm)
      role_fields=', "extended_requirements": [], "requirement_coverage": 0.9'
      ;;
    designer)
      role_fields=', "visual_score": 8, "interaction_score": 7'
      ;;
  esac

  cat > "$rdir/${role}_report.json" <<EOF
{
  "role": "$role",
  "score": 9.0,
  "improvements": ["imp1"],
  "risks": ["risk1"]${role_fields}${extra_fields}
}
EOF
}

# ============================================================
# Test Group 1: guard_check_artifacts -- evaluate branch (backward compat)
# ============================================================
echo ""
echo "--- guard_check_artifacts: evaluate branch (backward compat, no agents config) ---"

# No workflow.json at all -- should use hardcoded defaults
create_task_json "TASK-099"
local_rdir="$KANBAN_DIR/tasks/TASK-099/iteration-1"

result=$(guard_check_artifacts "TASK-099" "evaluate")
# Should list all 4 default reports as missing
assert_contains "no reports, no workflow -- missing code_reviewer" "$result" "code_reviewer_report.json"
assert_contains "no reports, no workflow -- missing qa" "$result" "qa_report.json"
assert_contains "no reports, no workflow -- missing pm" "$result" "pm_report.json"
assert_contains "no reports, no workflow -- missing designer" "$result" "designer_report.json"

# Create all 4 default reports
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "qa"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"

result=$(guard_check_artifacts "TASK-099" "evaluate")
assert_eq "all 4 reports present, no workflow -- no missing" "" "$result"

# ============================================================
# Test Group 2: guard_check_artifacts -- evaluate branch (with agents config)
# ============================================================
echo ""
echo "--- guard_check_artifacts: evaluate branch (with agents config) ---"

# Write workflow.json with 4 required + 1 optional agent
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

# Re-source to pick up new workflow
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

# Clean and recreate only required reports (no security-reviewer report)
rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "qa"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"

result=$(guard_check_artifacts "TASK-099" "evaluate")
# security-reviewer is optional (required=false), so get_required_roles should not include it
# Only required roles are checked
assert_eq "with agents config, all 4 required reports present -- no missing" "" "$result"

# Remove one required report
rm -f "$local_rdir/qa_report.json"
result=$(guard_check_artifacts "TASK-099" "evaluate")
assert_contains "missing qa report detected via dynamic roles" "$result" "qa_report.json"
assert_not_contains "security-reviewer not checked (optional)" "$result" "security-reviewer_report.json"

# ============================================================
# Test Group 3: guard_check_artifacts -- evaluate branch (custom required agents)
# ============================================================
echo ""
echo "--- guard_check_artifacts: evaluate branch (custom required agents) ---"

# Write workflow with a custom required agent
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF2'
{
  "phases": [
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "custom-auditor", "builtin": false, "file": ".kanban/agents/custom-auditor.md", "parallel": true, "required": true}
      ]
    }
  ]
}
WFEOF2

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "qa"
# custom-auditor report NOT created

result=$(guard_check_artifacts "TASK-099" "evaluate")
assert_contains "custom required agent missing detected" "$result" "custom-auditor_report.json"
assert_not_contains "pm not required, not checked" "$result" "pm_report.json"
assert_not_contains "designer not required, not checked" "$result" "designer_report.json"

# Now create the custom-auditor report
create_report_json "$local_rdir" "custom-auditor"
result=$(guard_check_artifacts "TASK-099" "evaluate")
assert_eq "all required agents present with custom config" "" "$result"

# ============================================================
# Test Group 4: guard_check_evaluation -- backward compat (no agents config)
# ============================================================
echo ""
echo "--- guard_check_evaluation: backward compat (no agents config) ---"

# Remove workflow.json to test fallback
rm -f "$KANBAN_DIR/workflow.json"
unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

# Create all 4 required reports with valid fields
rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "qa"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"

result=$(guard_check_evaluation "TASK-099")
assert_eq "all 4 valid reports, no workflow -- PASS" "PASS" "$result"

# Missing one report
rm -f "$local_rdir/designer_report.json"
result=$(guard_check_evaluation "TASK-099") || true
assert_contains "missing designer report detected" "$result" "missing_report:designer"

# ============================================================
# Test Group 5: guard_check_evaluation -- with agents config, only required roles checked
# ============================================================
echo ""
echo "--- guard_check_evaluation: with agents config (only required roles) ---"

# Restore workflow.json with 4 required + 1 optional
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
      ]
    }
  ]
}
WFEOF3

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

# Only create required reports (no security-reviewer)
rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "qa"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"

result=$(guard_check_evaluation "TASK-099")
assert_eq "4 required reports valid, optional missing ignored -- PASS" "PASS" "$result"

# ============================================================
# Test Group 6: guard_check_evaluation -- role-specific field validation
# ============================================================
echo ""
echo "--- guard_check_evaluation: role-specific field validation preserved ---"

# Test code_reviewer missing architecture_issues
rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "qa"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"

# Remove architecture_issues from code_reviewer report
cr_report="$local_rdir/code_reviewer_report.json"
cat > "$cr_report" << 'EOF'
{
  "role": "code_reviewer",
  "score": 9.0,
  "improvements": ["imp1"],
  "risks": ["risk1"],
  "code_style_violations": []
}
EOF

result=$(guard_check_evaluation "TASK-099") || true
assert_contains "code_reviewer missing architecture_issues detected" "$result" "missing_role_field:architecture_issues:code_reviewer"

# Test qa missing test_coverage
rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"
cat > "$local_rdir/qa_report.json" << 'EOF'
{
  "role": "qa",
  "score": 8.5,
  "improvements": ["imp1"],
  "risks": ["risk1"],
  "missing_tests": []
}
EOF

result=$(guard_check_evaluation "TASK-099") || true
assert_contains "qa missing test_coverage detected" "$result" "missing_role_field:test_coverage:qa"

# ============================================================
# Test Group 7: guard_check_evaluation -- custom agent (no role-specific validation)
# ============================================================
echo ""
echo "--- guard_check_evaluation: custom agent only generic validation ---"

# Workflow with a custom required agent (no role-specific case)
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF4'
{
  "phases": [
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "custom-auditor", "builtin": false, "file": ".kanban/agents/custom-auditor.md", "parallel": true, "required": true}
      ]
    }
  ]
}
WFEOF4

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
# custom-auditor only needs generic fields (score, improvements, risks)
cat > "$local_rdir/custom-auditor_report.json" << 'EOF'
{
  "role": "custom-auditor",
  "score": 8.0,
  "improvements": ["imp1"],
  "risks": ["risk1"]
}
EOF

result=$(guard_check_evaluation "TASK-099")
assert_eq "custom agent with only generic fields -- PASS" "PASS" "$result"

# Custom agent missing generic field (improvements empty)
cat > "$local_rdir/custom-auditor_report.json" << 'EOF'
{
  "role": "custom-auditor",
  "score": 8.0,
  "improvements": [],
  "risks": ["risk1"]
}
EOF

result=$(guard_check_evaluation "TASK-099") || true
assert_contains "custom agent empty improvements detected" "$result" "no_improvements:custom-auditor"

# ============================================================
# Test Group 8: guard_check_artifacts -- non-evaluate phases unchanged
# ============================================================
echo ""
echo "--- guard_check_artifacts: non-evaluate phases unchanged ---"

# plan phase should still work the same
create_task_json "TASK-099"
tdir="$KANBAN_DIR/tasks/TASK-099"

# No requirements.md or task_breakdown.json
result=$(guard_check_artifacts "TASK-099" "plan")
assert_contains "plan phase checks requirements.md" "$result" "requirements.md"
assert_contains "plan phase checks task_breakdown.json" "$result" "task_breakdown.json"

# Create plan artifacts
touch "$tdir/requirements.md" "$tdir/task_breakdown.json"
result=$(guard_check_artifacts "TASK-099" "plan")
assert_eq "plan phase all present" "" "$result"

# execute phase
mkdir -p "$local_rdir"
result=$(guard_check_artifacts "TASK-099" "execute")
assert_contains "execute phase checks execution_summary.md" "$result" "execution_summary.md"

touch "$local_rdir/execution_summary.md" "$local_rdir/execution_pitfalls.md" "$local_rdir/execution_decisions.md"
result=$(guard_check_artifacts "TASK-099" "execute")
assert_eq "execute phase all present" "" "$result"

# ============================================================
# Test Group 9: guard_check_evaluation -- score validation
# ============================================================
echo ""
echo "--- guard_check_evaluation: score validation ---"

# Reset to standard 4-role config
cat > "$KANBAN_DIR/workflow.json" << 'WFEOF5'
{
  "phases": [
    {
      "id": "evaluate",
      "agents": [
        {"role": "code_reviewer", "builtin": true, "parallel": true, "required": true},
        {"role": "qa", "builtin": true, "parallel": true, "required": true},
        {"role": "pm", "builtin": true, "parallel": true, "required": true},
        {"role": "designer", "builtin": true, "parallel": true, "required": true}
      ]
    }
  ]
}
WFEOF5

unset _AGENT_REGISTRY_LOADED 2>/dev/null || true
source "$SKILL_DIR/lib/agent_registry.sh"

rm -rf "$local_rdir"
mkdir -p "$local_rdir"
create_report_json "$local_rdir" "code_reviewer"
create_report_json "$local_rdir" "pm"
create_report_json "$local_rdir" "designer"

# qa with null score
cat > "$local_rdir/qa_report.json" << 'EOF'
{
  "role": "qa",
  "improvements": ["imp1"],
  "risks": ["risk1"],
  "missing_tests": [],
  "test_coverage": 0.8
}
EOF

result=$(guard_check_evaluation "TASK-099") || true
assert_contains "null score detected for qa" "$result" "no_score:qa"

# === Summary ===
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
