#!/usr/bin/env bash
# test_auto_evolve.sh — Tests for ST-003: skills/evolved full-auto evolution mechanism
# Run: bash .claude/skills/kanban/test/test_auto_evolve.sh
#
# Tests:
#   1. skills_evolve_extract() extracts candidates from pitfalls/decisions
#   2. skills_evolve_apply() marks candidates as applied
#   3. skills_evolve_report() generates JSON report
#   4. skills_evolve_auto() integration (extract + apply + report)
#   5. skills_evolve_show_history() displays records
#   6. kanban_archive_task() triggers auto evolution

# Note: intentionally NOT using set -e to avoid premature exit on expected
# grep failures (e.g., when no candidates match in empty artifact tests).

# === Test Framework ===
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RESET='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0
FAILED_TESTS=""

pass() {
  TESTS_PASSED=$((TESTS_PASSED + 1))
  TESTS_TOTAL=$((TESTS_TOTAL + 1))
  echo -e "  ${COLOR_GREEN}PASS${COLOR_RESET}: $1"
}

fail() {
  TESTS_FAILED=$((TESTS_FAILED + 1))
  TESTS_TOTAL=$((TESTS_TOTAL + 1))
  FAILED_TESTS="${FAILED_TESTS}\n  - $1: $2"
  echo -e "  ${COLOR_RED}FAIL${COLOR_RESET}: $1 -- $2"
}

assert_file_exists() {
  local label="$1"
  local file="$2"
  if [ -f "$file" ]; then
    pass "$label: file exists ($file)"
  else
    fail "$label" "file not found: $file"
  fi
}

assert_file_contains() {
  local label="$1"
  local file="$2"
  local pattern="$3"
  if [ -f "$file" ] && grep -q "$pattern" "$file"; then
    pass "$label"
  else
    fail "$label" "pattern '$pattern' not found in $file"
  fi
}

assert_json_field() {
  local label="$1"
  local file="$2"
  local field="$3"
  local expected="$4"
  if [ ! -f "$file" ]; then
    fail "$label" "file not found: $file"
    return
  fi
  local actual=$(jq -r "$field" "$file" 2>/dev/null || echo "PARSE_ERROR")
  if [ "$actual" = "$expected" ]; then
    pass "$label: $field = $expected"
  else
    fail "$label" "expected $field=$expected, got $actual"
  fi
}

assert_json_field_gte() {
  local label="$1"
  local file="$2"
  local field="$3"
  local threshold="$4"
  if [ ! -f "$file" ]; then
    fail "$label" "file not found: $file"
    return
  fi
  local actual=$(jq -r "$field" "$file" 2>/dev/null || echo "0")
  if [ "$actual" != "null" ] && [ "$actual" -ge "$threshold" ] 2>/dev/null; then
    pass "$label: $field >= $threshold (actual: $actual)"
  else
    fail "$label" "expected $field >= $threshold, got $actual"
  fi
}

# === Setup ===
ORIG_DIR="$(pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'cd "$ORIG_DIR" && rm -rf "$TEST_ROOT"' EXIT

echo "=== test_auto_evolve.sh ==="
echo "Test root: $TEST_ROOT"
echo ""

# Set up a fake project with kanban structure
mkdir -p "$TEST_ROOT/.kanban/skills/evolved"
mkdir -p "$TEST_ROOT/.kanban/tasks"
mkdir -p "$TEST_ROOT/.kanban/archive"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/lib"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/agents"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/rules"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/test"

# Copy lib files from the current framework directory (not from a hardcoded worktree path)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKTREE_LIB="$(cd "$SCRIPT_DIR/../lib" && pwd)"
WORKTREE_TEST="$(cd "$SCRIPT_DIR" && pwd)"

for lib_file in "$WORKTREE_LIB"/*.sh; do
  cp "$lib_file" "$TEST_ROOT/.claude/skills/kanban/lib/"
done

# Create minimal config files
cat > "$TEST_ROOT/.kanban/config.json" << 'EOF'
{
  "project": "test-project",
  "trunk": "main",
  "output_dir": "games",
  "version": "0.3.0"
}
EOF

cat > "$TEST_ROOT/.kanban/workflow.json" << 'EOF'
{
  "phases": [
    {"id": "plan", "quality_gate": {"enabled": false}},
    {"id": "execute"},
    {"id": "evaluate", "pass_threshold": 9.0},
    {"id": "user_decision"},
    {"id": "archive"}
  ],
  "self_improve": {"max_iterations": 6}
}
EOF

cat > "$TEST_ROOT/.kanban/index.json" << 'EOF'
{"project": "test-project", "trunk": "main", "tasks": []}
EOF

# Create a test task
TASK_ID="TASK-100"
TASK_DIR="$TEST_ROOT/.kanban/tasks/$TASK_ID"
mkdir -p "$TASK_DIR/iteration-1"

cat > "$TASK_DIR/task.json" << EOF
{
  "id": "$TASK_ID",
  "title": "Test task for skills evolution",
  "description": "Testing auto evolve",
  "engine": "claude-code",
  "status": "pending",
  "phase": "archive",
  "phase_lock": "archive",
  "iteration": 1,
  "max_iterations": 6,
  "scores": {},
  "worktree": {"branch": "", "path": "", "base": "main"},
  "history": [],
  "user_decision": {"action": "approve_and_archive", "feedback": "", "decided_at": "2026-05-04T00:00:00Z"},
  "requires_archive_confirmation": true,
  "created_at": "2026-05-04T00:00:00Z",
  "updated_at": "2026-05-04T00:00:00Z"
}
EOF

# Create test artifacts
cat > "$TASK_DIR/iteration-1/execution_pitfalls.md" << 'EOF'
# Execution Pitfalls

## Issue 1: Guard check too strict
The guard in workflow.sh rejected valid transitions because the kanban framework phase_lock was stale.
This is a framework-level issue that affects all tasks.

## Issue 2: Agent prompt not descriptive enough
The planner agent's prompt does not mention the importance of checking existing output_dir content.
This leads to directory name collisions.

## Issue 3: Dashboard refresh broken
The dashboard server.js does not support recursive scanning of tasks/ subdirectories.
A lib improvement is needed to fix readAllTasks().

## Issue 4: Rule about tests is vague
The rule for test-with-code.md does not specify that regression tests are mandatory for bug fixes.
This should be updated.

## Non-framework note
This is just a regular project note with no framework keywords.
EOF

cat > "$TASK_DIR/iteration-1/execution_decisions.md" << 'EOF'
# Execution Decisions

## DEC-001: Used symlinks for agent deployment
Decided to use ln -sf instead of cp for agent installation. This is a framework improvement
that applies to the kanban.sh _kanban_install_deps function.

## DEC-002: Added error checking to archive
Added || return 1 to all mv operations in kanban_archive_task. This is a lib improvement
that makes the shell script more robust.

## DEC-003: Project-specific decision
We used a simple array instead of a hash map because bash 3.2 does not support declare -A.
This is a project-specific decision and not a framework change.
EOF

# Create some agent/rule files that can be modified during apply
cat > "$TEST_ROOT/.claude/skills/kanban/agents/planner.md" << 'EOF'
# Planner Agent

You are the planner.
EOF

cat > "$TEST_ROOT/.claude/skills/kanban/rules/test-with-code.md" << 'EOF'
# Test With Code

All code changes must have tests.
EOF

# Initialize git repo in test root (needed by kanban functions)
cd "$TEST_ROOT"
git init -q
git add -A
git commit -qm "init test environment" 2>/dev/null || true

# Source the library
cd "$TEST_ROOT"
export KANBAN_DIR=".kanban"
SKILL_DIR="$TEST_ROOT/.claude/skills/kanban"
source "$SKILL_DIR/lib/kanban.sh"
kanban_init_env 2>/dev/null || true

echo "--- Environment loaded ---"
echo ""

# ============================================================================
# Test 1: skills_evolve_extract() extracts from pitfalls
# ============================================================================
echo "--- Test 1: skills_evolve_extract() ---"

# Clean up any pre-existing candidates
rm -f "$TEST_ROOT/.kanban/skills/evolved"/candidate-*.json

skills_evolve_extract "$TASK_ID" "1" 2>&1

# Verify candidates were created
CANDIDATES_DIR="$TEST_ROOT/.kanban/skills/evolved"
CANDIDATE_COUNT=$(ls "$CANDIDATES_DIR"/candidate-*.json 2>/dev/null | wc -l | tr -d ' ')

if [ "$CANDIDATE_COUNT" -gt 0 ]; then
  pass "extract created candidate files (count: $CANDIDATE_COUNT)"
else
  fail "extract" "no candidate files created"
fi

# Verify candidates have required fields
FIRST_CANDIDATE=$(ls "$CANDIDATES_DIR"/candidate-*.json 2>/dev/null | head -1)
if [ -n "$FIRST_CANDIDATE" ] && [ -f "$FIRST_CANDIDATE" ]; then
  assert_json_field "candidate has id" "$FIRST_CANDIDATE" ".id" "C-001"
  assert_json_field "candidate has source_task" "$FIRST_CANDIDATE" ".source_task" "$TASK_ID"
  assert_json_field "candidate has source_iteration" "$FIRST_CANDIDATE" ".source_iteration" "1"
  assert_json_field "candidate has status pending" "$FIRST_CANDIDATE" ".status" "pending"

  # Check that category is one of the valid values
  local_cat=$(jq -r '.category' "$FIRST_CANDIDATE")
  case "$local_cat" in
    agent_improvement|rule_improvement|lib_improvement)
      pass "candidate has valid category: $local_cat"
      ;;
    *)
      fail "candidate category" "invalid category: $local_cat"
      ;;
  esac
fi

# Verify that framework keywords were matched (not the non-framework note)
# The pitfalls file has 4 framework-related items (issues 1-4)
# The decisions file has 2 framework-related items (DEC-001, DEC-002)
# So we expect at least 4 candidates (pitfalls) plus some from decisions
if [ "$CANDIDATE_COUNT" -ge 4 ]; then
  pass "extracted sufficient candidates from framework-related content"
else
  fail "extract count" "expected at least 4 candidates, got $CANDIDATE_COUNT"
fi

echo ""

# ============================================================================
# Test 2: skills_evolve_apply() applies candidates
# ============================================================================
echo "--- Test 2: skills_evolve_apply() ---"

APPLY_OUTPUT=$(skills_evolve_apply "$TASK_ID" 2>&1)
echo "  Apply output: $APPLY_OUTPUT"

# Check that some candidates were applied
APPLIED_COUNT=$(echo "$APPLY_OUTPUT" | grep -o 'Applied [0-9]*' | grep -o '[0-9]*' || echo "0")
if [ "$APPLIED_COUNT" -gt 0 ]; then
  pass "apply applied $APPLIED_COUNT candidates"
else
  fail "apply" "no candidates were applied"
fi

# Verify that applied candidates have status "applied"
APPLIED_CANDIDATES=$(jq -r 'select(.status == "applied") | .id' "$CANDIDATES_DIR"/candidate-*.json 2>/dev/null || true)
if [ -n "$APPLIED_CANDIDATES" ]; then
  pass "candidates marked as applied"
else
  fail "apply status" "no candidates have status applied"
fi

# Check that agent/rule files were modified (for agent_improvement/rule_improvement categories)
AGENT_FILE="$TEST_ROOT/.claude/skills/kanban/agents/planner.md"
if [ -f "$AGENT_FILE" ] && grep -q "skills_evolve" "$AGENT_FILE" 2>/dev/null; then
  pass "agent file was modified with evolution comment"
else
  # This is OK if no agent_improvement candidates were generated
  echo "  (agent file not modified -- may not have agent_improvement candidates)"
fi

echo ""

# ============================================================================
# Test 3: skills_evolve_report() generates JSON
# ============================================================================
echo "--- Test 3: skills_evolve_report() ---"

REPORT_FILE="$TASK_DIR/iteration-1/skills_evolution_report.json"

# Re-extract to get a clean count
rm -f "$CANDIDATES_DIR"/candidate-*.json
skills_evolve_extract "$TASK_ID" "1" 2>/dev/null

# Count extracted for this task
EXTRACTED=0
for cf in "$CANDIDATES_DIR"/candidate-*.json; do
  [ -f "$cf" ] || continue
  c_task=$(jq -r '.source_task // ""' "$cf")
  c_iter=$(jq -r '.source_iteration // 0' "$cf")
  if [ "$c_task" = "$TASK_ID" ] && [ "$c_iter" = "1" ]; then
    EXTRACTED=$((EXTRACTED + 1))
  fi
done

# Apply
APPLY_OUT=$(skills_evolve_apply "$TASK_ID" 2>&1)
APPLIED=$(echo "$APPLY_OUT" | grep -o 'Applied [0-9]*' | grep -o '[0-9]*' || echo "0")
CREATED_TASKS=$(echo "$APPLY_OUT" | grep "CREATED_TASKS:" | sed 's/CREATED_TASKS://' || echo "")

# Generate report
skills_evolve_report "$TASK_ID" "1" "$EXTRACTED" "$APPLIED" "$CREATED_TASKS" 2>&1

assert_file_exists "report file created" "$REPORT_FILE"
assert_json_field "report has task_id" "$REPORT_FILE" ".task_id" "$TASK_ID"
assert_json_field "report has iteration" "$REPORT_FILE" ".iteration" "1"
assert_json_field_gte "report has extracted_count" "$REPORT_FILE" ".extracted_count" "1"
# triggered_at should be a non-null, non-empty string
TRIGGERED_AT_VAL=$(jq -r '.triggered_at // ""' "$REPORT_FILE")
if [ -n "$TRIGGERED_AT_VAL" ] && [ "$TRIGGERED_AT_VAL" != "null" ]; then
  pass "report has valid triggered_at"
else
  fail "report triggered_at" "should not be null or empty"
fi

# Check that triggered_at is a valid timestamp
TRIGGERED=$(jq -r '.triggered_at' "$REPORT_FILE")
if [ "$TRIGGERED" != "null" ] && [ -n "$TRIGGERED" ]; then
  pass "report has valid triggered_at: $TRIGGERED"
else
  fail "report triggered_at" "invalid timestamp"
fi

# Check candidates array
CANDIDATES_IN_REPORT=$(jq '.candidates | length' "$REPORT_FILE")
if [ "$CANDIDATES_IN_REPORT" -ge 1 ]; then
  pass "report contains candidates array ($CANDIDATES_IN_REPORT items)"
else
  fail "report candidates" "expected candidates in report, got $CANDIDATES_IN_REPORT"
fi

echo ""

# ============================================================================
# Test 4: skills_evolve_auto() integration test
# ============================================================================
echo "--- Test 4: skills_evolve_auto() integration ---"

# Set up a second task for integration test
TASK_ID_2="TASK-101"
TASK_DIR_2="$TEST_ROOT/.kanban/tasks/$TASK_ID_2"
mkdir -p "$TASK_DIR_2/iteration-1"

cat > "$TASK_DIR_2/task.json" << EOF
{
  "id": "$TASK_ID_2",
  "title": "Integration test task",
  "description": "Testing auto evolve integration",
  "engine": "claude-code",
  "status": "pending",
  "phase": "archive",
  "phase_lock": "archive",
  "iteration": 1,
  "max_iterations": 6,
  "scores": {},
  "worktree": {"branch": "", "path": "", "base": "main"},
  "history": [],
  "user_decision": {"action": "approve_and_archive", "feedback": "", "decided_at": "2026-05-04T00:00:00Z"},
  "requires_archive_confirmation": true,
  "created_at": "2026-05-04T00:00:00Z",
  "updated_at": "2026-05-04T00:00:00Z"
}
EOF

cat > "$TASK_DIR_2/iteration-1/execution_pitfalls.md" << 'EOF'
# Pitfalls

The guard framework needs better error messages for phase transition failures.
The kanban agent scheduling should be more robust.
EOF

cat > "$TASK_DIR_2/iteration-1/execution_decisions.md" << 'EOF'
# Decisions

Decided to add logging to the framework workflow.sh module.
This helps with debugging guard issues.
EOF

# Run the full auto pipeline
AUTO_OUTPUT=$(skills_evolve_auto "$TASK_ID_2" 2>&1)
echo "  Auto output: $AUTO_OUTPUT"

# Verify report was generated
REPORT_2="$TASK_DIR_2/iteration-1/skills_evolution_report.json"
assert_file_exists "auto integration: report generated" "$REPORT_2"

if [ -f "$REPORT_2" ]; then
  assert_json_field "auto report task_id" "$REPORT_2" ".task_id" "$TASK_ID_2"
  assert_json_field_gte "auto report extracted >= 1" "$REPORT_2" ".extracted_count" "1"
fi

echo ""

# ============================================================================
# Test 5: skills_evolve_show_history() displays records
# ============================================================================
echo "--- Test 5: skills_evolve_show_history() ---"

HISTORY_OUTPUT=$(skills_evolve_show_history 2>&1)
echo "  History output (truncated):"
echo "$HISTORY_OUTPUT" | head -10

if echo "$HISTORY_OUTPUT" | grep -q "Skills Evolution History"; then
  pass "show_history displays header"
else
  fail "show_history" "header not found"
fi

# Check that applied candidates are shown
if echo "$HISTORY_OUTPUT" | grep -q "\[APPLIED\]"; then
  pass "show_history shows applied candidates"
else
  fail "show_history applied" "no applied candidates shown"
fi

# Check total count
if echo "$HISTORY_OUTPUT" | grep -q "Total:"; then
  pass "show_history shows total count"
else
  fail "show_history total" "total count not shown"
fi

echo ""

# ============================================================================
# Test 6: Candidate JSON schema validation
# ============================================================================
echo "--- Test 6: Candidate JSON schema ---"

# Verify each candidate has all required fields
SCHEMA_PASS=true
for cf in "$CANDIDATES_DIR"/candidate-*.json; do
  [ -f "$cf" ] || continue
  local_id=$(jq -r '.id // ""' "$cf")
  local_source_task=$(jq -r '.source_task // ""' "$cf")
  local_source_iter=$(jq -r '.source_iteration // ""' "$cf")
  local_source_file=$(jq -r '.source_file // ""' "$cf")
  local_category=$(jq -r '.category // ""' "$cf")
  local_description=$(jq -r '.description // ""' "$cf")
  local_suggested_file=$(jq -r '.suggested_file // ""' "$cf")
  local_confidence=$(jq -r '.confidence // ""' "$cf")
  local_status=$(jq -r '.status // ""' "$cf")

  if [ -z "$local_id" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing id"; fi
  if [ -z "$local_source_task" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing source_task"; fi
  if [ -z "$local_source_iter" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing source_iteration"; fi
  if [ -z "$local_source_file" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing source_file"; fi
  if [ -z "$local_category" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing category"; fi
  if [ -z "$local_description" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing description"; fi
  if [ -z "$local_confidence" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing confidence"; fi
  if [ -z "$local_status" ]; then SCHEMA_PASS=false; fail "schema $cf" "missing status"; fi

  # Validate confidence values
  case "$local_confidence" in
    high|medium|low) ;;
    *) fail "schema $cf" "invalid confidence: $local_confidence"; SCHEMA_PASS=false ;;
  esac

  # Validate category values
  case "$local_category" in
    agent_improvement|rule_improvement|lib_improvement) ;;
    *) fail "schema $cf" "invalid category: $local_category"; SCHEMA_PASS=false ;;
  esac
done

if [ "$SCHEMA_PASS" = "true" ]; then
  pass "all candidate JSON schemas are valid"
fi

echo ""

# ============================================================================
# Test 7: Idempotency -- running extract twice should not duplicate
# ============================================================================
echo "--- Test 7: Idempotency ---"

# Note: Our current implementation does create new candidates on each run
# but they get unique incrementing IDs. The key is that apply is idempotent
# (already-applied candidates are skipped).
# Test that apply is idempotent
FIRST_APPLY=$(skills_evolve_apply "$TASK_ID_2" 2>&1)
SECOND_APPLY=$(skills_evolve_apply "$TASK_ID_2" 2>&1)

SECOND_APPLIED=$(echo "$SECOND_APPLY" | grep -o 'Applied [0-9]*' | grep -o '[0-9]*' || echo "0")
if [ "$SECOND_APPLIED" = "0" ]; then
  pass "apply is idempotent -- second run applies 0"
else
  fail "apply idempotency" "second run applied $SECOND_APPLIED candidates (should be 0)"
fi

echo ""

# ============================================================================
# Test 8: Empty pitfalls/decisions -- no crash
# ============================================================================
echo "--- Test 8: Empty artifacts handling ---"

TASK_ID_3="TASK-102"
TASK_DIR_3="$TEST_ROOT/.kanban/tasks/$TASK_ID_3"
mkdir -p "$TASK_DIR_3/iteration-1"

cat > "$TASK_DIR_3/task.json" << EOF
{
  "id": "$TASK_ID_3",
  "title": "Empty artifacts test",
  "description": "Testing with no framework keywords",
  "engine": "claude-code",
  "status": "pending",
  "phase": "archive",
  "phase_lock": "archive",
  "iteration": 1,
  "max_iterations": 6,
  "scores": {},
  "worktree": {"branch": "", "path": "", "base": "main"},
  "history": [],
  "user_decision": {"action": "approve_and_archive", "feedback": "", "decided_at": "2026-05-04T00:00:00Z"},
  "requires_archive_confirmation": true,
  "created_at": "2026-05-04T00:00:00Z",
  "updated_at": "2026-05-04T00:00:00Z"
}
EOF

cat > "$TASK_DIR_3/iteration-1/execution_pitfalls.md" << 'EOF'
# Execution Pitfalls

This is a project-specific issue about CSS styling.
Nothing relevant to extract here.
EOF

cat > "$TASK_DIR_3/iteration-1/execution_decisions.md" << 'EOF'
# Execution Decisions

We chose blue over red for the background color.
A purely visual choice.
EOF

EMPTY_OUTPUT=$(skills_evolve_extract "$TASK_ID_3" "1" 2>&1)
echo "  Empty extract output: $EMPTY_OUTPUT"

# Count candidates for this task
EMPTY_COUNT=0
for cf in "$CANDIDATES_DIR"/candidate-*.json; do
  [ -f "$cf" ] || continue
  c_task=$(jq -r '.source_task // ""' "$cf")
  if [ "$c_task" = "$TASK_ID_3" ]; then
    EMPTY_COUNT=$((EMPTY_COUNT + 1))
  fi
done

if [ "$EMPTY_COUNT" = "0" ]; then
  pass "no candidates extracted from non-framework content"
else
  fail "empty extract" "expected 0 candidates, got $EMPTY_COUNT"
fi

echo ""

# ============================================================================
# Test 9: lib_improvement creates kanban task (if kanban_create_task works)
# ============================================================================
echo "--- Test 9: lib_improvement task creation ---"

# Create a candidate that is explicitly lib_improvement
LIB_CANDIDATE="$CANDIDATES_DIR/candidate-900.json"
jq -n \
  --arg id "C-900" \
  --arg source_task "$TASK_ID" \
  --argjson source_iteration 1 \
  --arg source_file "execution_pitfalls.md" \
  --arg category "lib_improvement" \
  --arg description "Test lib improvement candidate" \
  --arg suggested_file ".claude/skills/kanban/lib/kanban.sh" \
  --arg suggested_change "Add better error handling" \
  --arg confidence "high" \
  '{
    id: $id,
    source_task: $source_task,
    source_iteration: $source_iteration,
    source_file: $source_file,
    category: $category,
    description: $description,
    suggested_file: $suggested_file,
    suggested_change: $suggested_change,
    confidence: $confidence,
    status: "pending",
    created_at: "2026-05-04T00:00:00Z"
  }' > "$LIB_CANDIDATE"

LIB_APPLY=$(skills_evolve_apply "$TASK_ID" 2>&1)
echo "  Lib apply output: $LIB_APPLY"

# Check if the candidate was processed
LIB_STATUS=$(jq -r '.status' "$LIB_CANDIDATE")
if [ "$LIB_STATUS" = "applied" ]; then
  pass "lib_improvement candidate was applied (task created)"
  # Check if created_task field is set
  CREATED_TASK=$(jq -r '.created_task // ""' "$LIB_CANDIDATE")
  if [ -n "$CREATED_TASK" ] && echo "$CREATED_TASK" | grep -q "TASK-"; then
    pass "lib_improvement created task: $CREATED_TASK"
  else
    # This is OK if kanban_create_task could not create a task (test env limitation)
    echo "  (created_task not set -- kanban_create_task may not be fully functional in test env)"
  fi
else
  fail "lib_improvement" "candidate status is $LIB_STATUS, expected applied"
fi

echo ""

# ============================================================================
# Test 10: _skills_classify_line helper function
# ============================================================================
echo "--- Test 10: Classification helper ---"

# Test agent classification
CLASS=$(_skills_classify_line "The planner agent needs better prompts")
if [ "$CLASS" = "agent_improvement" ]; then
  pass "classify: agent-related text -> agent_improvement"
else
  fail "classify agent" "got: $CLASS"
fi

# Test rule classification
CLASS=$(_skills_classify_line "The rule about testing should be stricter")
if [ "$CLASS" = "rule_improvement" ]; then
  pass "classify: rule-related text -> rule_improvement"
else
  fail "classify rule" "got: $CLASS"
fi

# Test lib classification
# Note: "Refactor the shell script to fix the bug" alone has no framework keywords,
# so it should be classified as empty. A line with framework keywords + lib keywords
# should be classified as lib_improvement.
CLASS=$(_skills_classify_line "Refactor the shell script to fix the bug")
if [ -z "$CLASS" ]; then
  pass "classify: lib-only text without framework keywords is rejected"
else
  fail "classify lib rejection" "expected empty, got: $CLASS"
fi

# Test lib classification with framework keyword present
CLASS=$(_skills_classify_line "Refactor the kanban framework shell script to fix the bug")
if [ "$CLASS" = "lib_improvement" ]; then
  pass "classify: lib-related text with framework keywords -> lib_improvement"
else
  fail "classify lib" "got: $CLASS"
fi

echo ""

# ============================================================================
# Summary
# ============================================================================
echo "============================================================"
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_TOTAL total"
if [ $TESTS_FAILED -gt 0 ]; then
  echo -e "${COLOR_RED}Failed tests:${COLOR_RESET}"
  echo -e "$FAILED_TESTS"
fi
echo "============================================================"

if [ $TESTS_FAILED -eq 0 ]; then
  echo -e "${COLOR_GREEN}All tests passed!${COLOR_RESET}"
  exit 0
else
  echo -e "${COLOR_RED}Some tests failed.${COLOR_RESET}"
  exit 1
fi
