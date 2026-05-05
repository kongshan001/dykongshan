#!/usr/bin/env bash
# test_guard_workflow_config_st003.sh -- Tests for ST-003: guard_check_workflow_config
# Validates workflow.json configuration completeness checking
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

assert_return_code() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected return: '$expected'"
    echo "    actual return:   '$actual'"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# === Setup ===
echo ""
echo "=== test_guard_workflow_config_st003.sh ==="
echo ""

# Syntax check
echo "--- Syntax check ---"
bash -n "$SKILL_DIR/lib/guard.sh" && echo "  PASS: guard.sh syntax OK" || { echo "  FAIL: guard.sh syntax error"; exit 1; }

# Create temp directory for test isolation
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

# Setup environment
KANBAN_DIR="$TEST_TMPDIR/.kanban"
mkdir -p "$KANBAN_DIR"

# Stub: task_file returns path to the task JSON
task_file() {
  echo "$KANBAN_DIR/tasks/$1/task.json"
}

# Stub: report_dir returns path to iteration directory
report_dir() {
  echo "$KANBAN_DIR/tasks/$1/iteration-$2"
}

# Source guard.sh
source "$SKILL_DIR/lib/guard.sh"

# Override KANBAN_DIR since guard.sh sets it to ".kanban"
KANBAN_DIR="$TEST_TMPDIR/.kanban"

# ============================================================
# Test Group 1: File not found
# ============================================================
echo ""
echo "--- guard_check_workflow_config: file not found ---"

result=$(guard_check_workflow_config "$TEST_TMPDIR/nonexistent.json") && rc=$? || rc=$?
assert_contains "file not found -- FAIL output" "$result" "FAIL:file_not_found"
assert_return_code "file not found -- return 1" "1" "$rc"

# Default path (no argument) -- should use KANBAN_DIR/workflow.json which does not exist
result=$(guard_check_workflow_config) && rc=$? || rc=$?
assert_contains "default path not found -- FAIL output" "$result" "FAIL:file_not_found"
assert_return_code "default path not found -- return 1" "1" "$rc"

# ============================================================
# Test Group 2: Invalid JSON
# ============================================================
echo ""
echo "--- guard_check_workflow_config: invalid JSON ---"

echo "this is not json {{{" > "$KANBAN_DIR/workflow.json"
result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "invalid json -- FAIL output" "$result" "FAIL:invalid_json"
assert_return_code "invalid json -- return 1" "1" "$rc"

# ============================================================
# Test Group 3: Fully valid workflow.json (all checks pass)
# ============================================================
echo ""
echo "--- guard_check_workflow_config: fully valid config ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "name": "规划阶段",
      "agents": [
        {"role": "planner", "required": true}
      ],
      "quality_gate": {
        "enabled": true,
        "pass_threshold": 7.0
      }
    },
    {
      "id": "execute",
      "name": "执行阶段",
      "agents": [
        {"role": "executor", "required": true}
      ]
    },
    {
      "id": "evaluate",
      "name": "评估阶段",
      "agents": [
        {"role": "code_reviewer", "required": true},
        {"role": "qa", "required": true},
        {"role": "pm", "required": true},
        {"role": "designer", "required": true}
      ],
      "pass_threshold": 9.0
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_eq "fully valid -- PASS" "PASS" "$result"
assert_return_code "fully valid -- return 0" "0" "$rc"

# Also test with default path (no argument)
result=$(guard_check_workflow_config) && rc=$? || rc=$?
assert_eq "fully valid default path -- PASS" "PASS" "$result"
assert_return_code "fully valid default path -- return 0" "0" "$rc"

# ============================================================
# Test Group 4: Empty phases array
# ============================================================
echo ""
echo "--- guard_check_workflow_config: empty phases array ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": []
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "empty phases -- FAIL output" "$result" "FAIL:"
assert_contains "empty phases -- phases_array_missing_or_empty" "$result" "phases_array_missing_or_empty"
assert_return_code "empty phases -- return 1" "1" "$rc"

# ============================================================
# Test Group 5: Missing phases field entirely
# ============================================================
echo ""
echo "--- guard_check_workflow_config: missing phases field ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "self_improve": {
    "max_iterations": 6
  }
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "no phases -- FAIL output" "$result" "FAIL:"
assert_contains "no phases -- phases_array_missing_or_empty" "$result" "phases_array_missing_or_empty"
assert_return_code "no phases -- return 1" "1" "$rc"

# ============================================================
# Test Group 6: plan phase missing quality_gate
# ============================================================
echo ""
echo "--- guard_check_workflow_config: plan quality_gate missing ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [{"role": "planner"}]
    },
    {
      "id": "execute",
      "agents": [{"role": "executor"}]
    },
    {
      "id": "evaluate",
      "agents": [{"role": "code_reviewer"}],
      "pass_threshold": 9.0
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "no quality_gate -- FAIL" "$result" "FAIL:"
assert_contains "no quality_gate -- plan_quality_gate_missing_or_disabled" "$result" "plan_quality_gate_missing_or_disabled"
assert_return_code "no quality_gate -- return 1" "1" "$rc"

# ============================================================
# Test Group 7: plan phase quality_gate enabled=false
# ============================================================
echo ""
echo "--- guard_check_workflow_config: plan quality_gate disabled ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [{"role": "planner"}],
      "quality_gate": {
        "enabled": false,
        "pass_threshold": 7.0
      }
    },
    {
      "id": "execute",
      "agents": [{"role": "executor"}]
    },
    {
      "id": "evaluate",
      "agents": [{"role": "code_reviewer"}],
      "pass_threshold": 9.0
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "quality_gate disabled -- FAIL" "$result" "FAIL:"
assert_contains "quality_gate disabled -- plan_quality_gate_missing_or_disabled" "$result" "plan_quality_gate_missing_or_disabled"
assert_return_code "quality_gate disabled -- return 1" "1" "$rc"

# ============================================================
# Test Group 8: plan phase missing agents
# ============================================================
echo ""
echo "--- guard_check_workflow_config: plan agents missing ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "quality_gate": {"enabled": true}
    },
    {
      "id": "execute",
      "agents": [{"role": "executor"}]
    },
    {
      "id": "evaluate",
      "agents": [{"role": "code_reviewer"}],
      "pass_threshold": 9.0
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "plan no agents -- FAIL" "$result" "FAIL:"
assert_contains "plan no agents -- plan_agents_missing_or_empty" "$result" "plan_agents_missing_or_empty"
assert_return_code "plan no agents -- return 1" "1" "$rc"

# ============================================================
# Test Group 9: execute phase missing agents
# ============================================================
echo ""
echo "--- guard_check_workflow_config: execute agents missing ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [{"role": "planner"}],
      "quality_gate": {"enabled": true}
    },
    {
      "id": "execute"
    },
    {
      "id": "evaluate",
      "agents": [{"role": "code_reviewer"}],
      "pass_threshold": 9.0
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "execute no agents -- FAIL" "$result" "FAIL:"
assert_contains "execute no agents -- execute_agents_missing_or_empty" "$result" "execute_agents_missing_or_empty"
assert_return_code "execute no agents -- return 1" "1" "$rc"

# ============================================================
# Test Group 10: evaluate phase missing agents
# ============================================================
echo ""
echo "--- guard_check_workflow_config: evaluate agents missing ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [{"role": "planner"}],
      "quality_gate": {"enabled": true}
    },
    {
      "id": "execute",
      "agents": [{"role": "executor"}]
    },
    {
      "id": "evaluate",
      "pass_threshold": 9.0
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "evaluate no agents -- FAIL" "$result" "FAIL:"
assert_contains "evaluate no agents -- evaluate_agents_missing_or_empty" "$result" "evaluate_agents_missing_or_empty"
assert_return_code "evaluate no agents -- return 1" "1" "$rc"

# ============================================================
# Test Group 11: evaluate phase missing pass_threshold
# ============================================================
echo ""
echo "--- guard_check_workflow_config: evaluate pass_threshold missing ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [{"role": "planner"}],
      "quality_gate": {"enabled": true}
    },
    {
      "id": "execute",
      "agents": [{"role": "executor"}]
    },
    {
      "id": "evaluate",
      "agents": [{"role": "code_reviewer"}]
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "evaluate no threshold -- FAIL" "$result" "FAIL:"
assert_contains "evaluate no threshold -- evaluate_pass_threshold_missing" "$result" "evaluate_pass_threshold_missing"
assert_return_code "evaluate no threshold -- return 1" "1" "$rc"

# ============================================================
# Test Group 12: Missing phases entirely (plan, execute, evaluate)
# ============================================================
echo ""
echo "--- guard_check_workflow_config: missing required phases ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "archive",
      "agents": [{"role": "archiver"}]
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "missing plan phase" "$result" "plan_phase_missing"
assert_contains "missing execute phase" "$result" "execute_phase_missing"
assert_contains "missing evaluate phase" "$result" "evaluate_phase_missing"
assert_return_code "missing phases -- return 1" "1" "$rc"

# ============================================================
# Test Group 13: Multiple issues at once
# ============================================================
echo ""
echo "--- guard_check_workflow_config: multiple issues combined ---"

cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "quality_gate": {"enabled": false}
    },
    {
      "id": "execute"
    },
    {
      "id": "evaluate"
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
assert_contains "combined -- plan_quality_gate" "$result" "plan_quality_gate_missing_or_disabled"
assert_contains "combined -- plan_agents" "$result" "plan_agents_missing_or_empty"
assert_contains "combined -- execute_agents" "$result" "execute_agents_missing_or_empty"
assert_contains "combined -- evaluate_agents" "$result" "evaluate_agents_missing_or_empty"
assert_contains "combined -- evaluate_pass_threshold" "$result" "evaluate_pass_threshold_missing"
assert_return_code "combined -- return 1" "1" "$rc"

# ============================================================
# Test Group 14: Custom path argument
# ============================================================
echo ""
echo "--- guard_check_workflow_config: custom path argument ---"

# Valid config at custom path
cat > "$TEST_TMPDIR/custom-workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [{"role": "planner"}],
      "quality_gate": {"enabled": true}
    },
    {
      "id": "execute",
      "agents": [{"role": "executor"}]
    },
    {
      "id": "evaluate",
      "agents": [{"role": "reviewer"}],
      "pass_threshold": 8.5
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$TEST_TMPDIR/custom-workflow.json") && rc=$? || rc=$?
assert_eq "custom path valid -- PASS" "PASS" "$result"
assert_return_code "custom path valid -- return 0" "0" "$rc"

# Invalid config at custom path
cat > "$TEST_TMPDIR/bad-workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "archive"
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$TEST_TMPDIR/bad-workflow.json") && rc=$? || rc=$?
assert_contains "custom path invalid -- FAIL" "$result" "FAIL:"
assert_return_code "custom path invalid -- return 1" "1" "$rc"

# ============================================================
# Test Group 15: Real-world workflow.json (like the actual project)
# ============================================================
echo ""
echo "--- guard_check_workflow_config: real-world config (may have issues) ---"

# This simulates the actual project's workflow.json which has roles instead of agents
cat > "$KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "name": "规划阶段",
      "required_artifacts": ["requirements.md", "task_breakdown.json"],
      "required_checks": ["worktree_exists", "framework_check"],
      "exit_condition": "all_artifacts_present AND all_checks_pass"
    },
    {
      "id": "execute",
      "name": "执行阶段",
      "required_artifacts": ["source_code_committed", "execution_summary.md", "execution_pitfalls.md", "execution_decisions.md"],
      "required_checks": ["tests_run"],
      "exit_condition": "all_artifacts_present AND all_checks_pass"
    },
    {
      "id": "evaluate",
      "name": "评估阶段",
      "roles": ["code_reviewer", "qa", "pm", "designer"],
      "pass_threshold": 9.0,
      "report_required_fields": ["score", "improvements", "risks"],
      "exit_condition": "all_roles_scored"
    },
    {
      "id": "retrospective",
      "name": "迭代复盘",
      "required_artifacts": ["retrospective.md"],
      "exit_condition": "all_artifacts_present"
    },
    {
      "id": "archive",
      "name": "归档阶段",
      "required_artifacts": ["archive_summary.md"],
      "exit_condition": "all_artifacts_present"
    }
  ]
}
EOF

result=$(guard_check_workflow_config "$KANBAN_DIR/workflow.json") && rc=$? || rc=$?
# This real config has many missing items: no quality_gate, no agents arrays
assert_contains "real config -- plan_quality_gate" "$result" "plan_quality_gate_missing_or_disabled"
assert_contains "real config -- plan_agents" "$result" "plan_agents_missing_or_empty"
assert_contains "real config -- execute_agents" "$result" "execute_agents_missing_or_empty"
assert_contains "real config -- evaluate_agents" "$result" "evaluate_agents_missing_or_empty"
assert_not_contains "real config -- evaluate has pass_threshold so OK" "$result" "evaluate_pass_threshold_missing"
assert_return_code "real config -- return 1" "1" "$rc"

# === Summary ===
echo ""
echo "=== Results: $TESTS_PASSED passed, $TESTS_FAILED failed (out of $TESTS_RUN) ==="
[ "$TESTS_FAILED" -eq 0 ] && exit 0 || exit 1
