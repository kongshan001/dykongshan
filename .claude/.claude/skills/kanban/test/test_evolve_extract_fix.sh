#!/usr/bin/env bash
# test_evolve_extract_fix.sh -- Tests for ST-001, ST-004, ST-005 fixes
# Run: bash .claude/skills/kanban/test/test_evolve_extract_fix.sh
#
# Tests:
#   ST-001: skills_evolve_extract archive path fallback + pipeline subshell fix
#   ST-004: _skills_classify_line false positive prevention
#   ST-005: framework_self_assess actionable suggestions

# === Test Framework ===
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
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

# === Setup ===
ORIG_DIR="$(pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'cd "$ORIG_DIR" && rm -rf "$TEST_ROOT"' EXIT

echo "=== test_evolve_extract_fix.sh ==="
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

# Create some agent/rule files that can be modified during apply
cat > "$TEST_ROOT/.claude/skills/kanban/agents/planner.md" << 'EOF'
# Planner Agent

You are the planner.
EOF

cat > "$TEST_ROOT/.claude/skills/kanban/rules/test-with-code.md" << 'EOF'
# Test With Code

All code changes must have tests.
EOF

# Initialize git repo in test root
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
# ST-001 Test 1: skills_evolve_extract finds files in archive path
# ============================================================================
echo "--- ST-001 Test 1: Archive path fallback ---"

ARCHIVE_TASK_ID="TASK-200"
ARCHIVE_TASK_DIR="$TEST_ROOT/.kanban/archive/$ARCHIVE_TASK_ID"
mkdir -p "$ARCHIVE_TASK_DIR/iteration-1"

cat > "$ARCHIVE_TASK_DIR/task.json" << EOF
{
  "id": "$ARCHIVE_TASK_ID",
  "title": "Archived task for path fallback test",
  "description": "Testing archive path fallback in extract",
  "engine": "claude-code",
  "status": "archived",
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

cat > "$ARCHIVE_TASK_DIR/iteration-1/execution_pitfalls.md" << 'EOF'
# Execution Pitfalls

## P-001: framework guard check too strict
The kanban guard framework rejected valid transitions because phase_lock was stale.
This needs a bug fix in the guard.sh module.

## P-002: worktree path resolution inconsistent
The worktree.sh module uses different path resolution strategies.
A refactoring is needed to unify the approach.
EOF

cat > "$ARCHIVE_TASK_DIR/iteration-1/execution_decisions.md" << 'EOF'
# Execution Decisions

## DEC-001: Used guard fallback for archive paths
Decided to add archive path fallback to the framework guard module.
This is a lib improvement for self_improve.sh.
EOF

# Run extract on the archived task
rm -f "$TEST_ROOT/.kanban/skills/evolved"/candidate-*.json
EXTRACT_OUTPUT=$(skills_evolve_extract "$ARCHIVE_TASK_ID" "1" 2>&1)
echo "  Extract output: $EXTRACT_OUTPUT"

# Verify candidates were created
CANDIDATES_DIR="$TEST_ROOT/.kanban/skills/evolved"
ARCHIVE_CANDIDATE_COUNT=0
for cf in "$CANDIDATES_DIR"/candidate-*.json; do
  [ -f "$cf" ] || continue
  c_task=$(jq -r '.source_task // ""' "$cf")
  if [ "$c_task" = "$ARCHIVE_TASK_ID" ]; then
    ARCHIVE_CANDIDATE_COUNT=$((ARCHIVE_CANDIDATE_COUNT + 1))
  fi
done

if [ "$ARCHIVE_CANDIDATE_COUNT" -gt 0 ]; then
  pass "ST-001: archive path fallback extracted $ARCHIVE_CANDIDATE_COUNT candidates from archived task"
else
  fail "ST-001 archive fallback" "no candidates extracted from archived task (files may not have been found)"
fi

echo ""

# ============================================================================
# ST-001 Test 2: Candidate index is sequential (no subshell gap)
# ============================================================================
echo "--- ST-001 Test 2: Sequential candidate index (subshell fix) ---"

# Create a task with multiple framework-related pitfalls
SEQ_TASK_ID="TASK-201"
SEQ_TASK_DIR="$TEST_ROOT/.kanban/tasks/$SEQ_TASK_ID"
mkdir -p "$SEQ_TASK_DIR/iteration-1"

cat > "$SEQ_TASK_DIR/task.json" << EOF
{
  "id": "$SEQ_TASK_ID",
  "title": "Sequential index test",
  "description": "Testing sequential candidate indexing",
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

cat > "$SEQ_TASK_DIR/iteration-1/execution_pitfalls.md" << 'EOF'
# Pitfalls

P-001: The kanban framework guard check is too strict and should be improved to fix a known bug.
P-002: The worktree agent scheduling needs enhancement to handle edge cases properly.
P-003: The framework workflow.sh module has a bug in set -e handling that needs fixing.
P-004: The guard evaluator.sh has missing error handling for jq failures.
EOF

cat > "$SEQ_TASK_DIR/iteration-1/execution_decisions.md" << 'EOF'
# Decisions

DEC-001: Decided to improve the kanban framework by adding set -e safety patterns to all lib files.
DEC-002: Chose to refactor the guard module for better error messages in the framework.
EOF

# Get the next candidate index
rm -f "$CANDIDATES_DIR"/candidate-*.json

EXTRACT_OUTPUT=$(skills_evolve_extract "$SEQ_TASK_ID" "1" 2>&1)
echo "  Extract output: $EXTRACT_OUTPUT"

# Check that the extract output reports the correct count
if echo "$EXTRACT_OUTPUT" | grep -q "Extracted [1-9]"; then
  EXTRACTED_NUM=$(echo "$EXTRACT_OUTPUT" | grep -o 'Extracted [0-9]*' | grep -o '[0-9]*')
  pass "ST-001: extract reports count=$EXTRACTED_NUM"
else
  EXTRACTED_NUM=0
  fail "ST-001 extract count" "extract did not report a positive count"
fi

# Check that candidate IDs are sequential (no gaps from subshell)
SEQ_CANDIDATE_IDS=""
for cf in "$CANDIDATES_DIR"/candidate-*.json; do
  [ -f "$cf" ] || continue
  local_id=$(jq -r '.id // ""' "$cf")
  SEQ_CANDIDATE_IDS="$SEQ_CANDIDATE_IDS $local_id"
done

# Verify we have C-001, C-002, etc. without gaps
if [ -n "$SEQ_CANDIDATE_IDS" ]; then
  pass "ST-001: candidate IDs generated: $SEQ_CANDIDATE_IDS"

  # Check that IDs start at C-001 and are sequential
  FIRST_ID=$(echo "$SEQ_CANDIDATE_IDS" | awk '{print $1}')
  if [ "$FIRST_ID" = "C-001" ]; then
    pass "ST-001: first candidate ID is C-001"
  else
    fail "ST-001 first ID" "expected C-001, got $FIRST_ID"
  fi

  # Count should match the reported number
  ACTUAL_COUNT=$(echo "$SEQ_CANDIDATE_IDS" | wc -w | tr -d ' ')
  if [ "$ACTUAL_COUNT" = "$EXTRACTED_NUM" ]; then
    pass "ST-001: actual file count ($ACTUAL_COUNT) matches reported count ($EXTRACTED_NUM)"
  else
    fail "ST-001 count mismatch" "actual=$ACTUAL_COUNT, reported=$EXTRACTED_NUM"
  fi
else
  fail "ST-001 candidate IDs" "no candidate IDs generated"
fi

echo ""

# ============================================================================
# ST-004 Test 1: Negative context lines are not classified
# ============================================================================
echo "--- ST-004 Test 1: Negative context rejection ---"

CLASS=$(_skills_classify_line "No framework keywords here -- this is unrelated")
if [ -z "$CLASS" ]; then
  pass "ST-004: 'No framework keywords here' is rejected (empty category)"
else
  fail "ST-004 negative context" "expected empty, got: $CLASS"
fi

CLASS=$(_skills_classify_line "This is not related to framework improvements")
if [ -z "$CLASS" ]; then
  pass "ST-004: 'not related to framework' is rejected"
else
  fail "ST-004 negative context 2" "expected empty, got: $CLASS"
fi

echo ""

# ============================================================================
# ST-004 Test 2: Short lines are rejected
# ============================================================================
echo "--- ST-004 Test 2: Short line rejection ---"

CLASS=$(_skills_classify_line "framework fix")
if [ -z "$CLASS" ]; then
  pass "ST-004: short line 'framework fix' (< 20 chars) is rejected"
else
  fail "ST-004 short line" "expected empty, got: $CLASS"
fi

echo ""

# ============================================================================
# ST-004 Test 3: Lines with only one keyword and no action are rejected
# ============================================================================
echo "--- ST-004 Test 3: Single keyword without action is rejected ---"

CLASS=$(_skills_classify_line "The framework was mentioned in passing without any actionable context here")
if [ -z "$CLASS" ]; then
  pass "ST-004: single keyword 'framework' with no action is rejected"
else
  fail "ST-004 single keyword" "expected empty, got: $CLASS"
fi

echo ""

# ============================================================================
# ST-004 Test 4: Genuine framework improvements are still classified
# ============================================================================
echo "--- ST-004 Test 4: Genuine improvements still classified ---"

CLASS=$(_skills_classify_line "The planner agent needs better prompts to describe the kanban workflow")
if [ "$CLASS" = "agent_improvement" ]; then
  pass "ST-004: genuine agent improvement is classified correctly"
else
  fail "ST-004 genuine agent" "expected agent_improvement, got: $CLASS"
fi

CLASS=$(_skills_classify_line "The framework guard check is too strict and should be improved to fix the bug")
if [ -n "$CLASS" ]; then
  pass "ST-004: genuine framework improvement with bug fix is classified: $CLASS"
else
  fail "ST-004 genuine framework" "expected non-empty, got empty"
fi

CLASS=$(_skills_classify_line "The rule about testing needs to be updated to require regression tests for bug fixes")
if [ "$CLASS" = "rule_improvement" ]; then
  pass "ST-004: rule improvement with action keywords is classified"
else
  fail "ST-004 genuine rule" "expected rule_improvement, got: $CLASS"
fi

CLASS=$(_skills_classify_line "Refactor the shell script to fix the bug in the worktree.sh lib module")
if [ "$CLASS" = "lib_improvement" ]; then
  pass "ST-004: lib improvement with multiple keywords is classified"
else
  fail "ST-004 genuine lib" "expected lib_improvement, got: $CLASS"
fi

echo ""

# ============================================================================
# ST-004 Test 5: Extract does not create candidates from negative context
# ============================================================================
echo "--- ST-004 Test 5: Extract filters out negative context ---"

NEG_TASK_ID="TASK-202"
NEG_TASK_DIR="$TEST_ROOT/.kanban/tasks/$NEG_TASK_ID"
mkdir -p "$NEG_TASK_DIR/iteration-1"

cat > "$NEG_TASK_DIR/task.json" << EOF
{
  "id": "$NEG_TASK_ID",
  "title": "Negative context test",
  "description": "Testing that negative context lines are not extracted",
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

cat > "$NEG_TASK_DIR/iteration-1/execution_pitfalls.md" << 'EOF'
# Pitfalls

## P-001: No framework keywords here
This is a pure project issue about CSS styling that has nothing to do with the kanban framework.

## P-002: Not related to framework
This problem is about database schema design and is unrelated to framework improvements.

## P-003: Short line with keyword
framework

## P-004: Single keyword only without action
The kanban project structure follows standard conventions.
EOF

cat > "$NEG_TASK_DIR/iteration-1/execution_decisions.md" << 'EOF'
# Decisions

DEC-001: Chose blue over red for the background color
A purely visual decision with no framework keywords at all.

DEC-002: Used simple arrays instead of hash maps
This is a project-specific decision because bash 3.2 does not support declare -A.
EOF

rm -f "$CANDIDATES_DIR"/candidate-*.json
EXTRACT_OUTPUT=$(skills_evolve_extract "$NEG_TASK_ID" "1" 2>&1)
echo "  Extract output: $EXTRACT_OUTPUT"

# Count candidates for this task -- should be 0
NEG_COUNT=0
for cf in "$CANDIDATES_DIR"/candidate-*.json; do
  [ -f "$cf" ] || continue
  c_task=$(jq -r '.source_task // ""' "$cf")
  if [ "$c_task" = "$NEG_TASK_ID" ]; then
    NEG_COUNT=$((NEG_COUNT + 1))
  fi
done

if [ "$NEG_COUNT" = "0" ]; then
  pass "ST-004: no candidates extracted from negative context pitfalls"
else
  fail "ST-004 negative extract" "expected 0 candidates, got $NEG_COUNT"
fi

echo ""

# ============================================================================
# ST-005 Test 1: framework_self_assess produces actionable suggestions
# ============================================================================
echo "--- ST-005 Test 1: Actionable suggestions in assessment ---"

ASSESS_TASK_ID="TASK-203"
ASSESS_TASK_DIR="$TEST_ROOT/.kanban/tasks/$ASSESS_TASK_ID"
mkdir -p "$ASSESS_TASK_DIR/iteration-1"

cat > "$ASSESS_TASK_DIR/task.json" << EOF
{
  "id": "$ASSESS_TASK_ID",
  "title": "Assessment test task",
  "description": "Testing framework_self_assess suggestions",
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

cat > "$ASSESS_TASK_DIR/iteration-1/execution_pitfalls.md" << 'EOF'
# Execution Pitfalls

## P-001: set -e caused script exit
The framework functions return non-zero values that trigger set -e exits unexpectedly.
This happens in worktree.sh and guard.sh when functions like worktree_exists return 1 for "not found".

## P-002: Path resolution inconsistency
The PROJECT_ROOT and KANBAN_ROOT variables in dashboard/server.js resolve to different paths.
This causes API test failures when running from the source directory.
EOF

cat > "$ASSESS_TASK_DIR/iteration-1/execution_decisions.md" << 'EOF'
# Execution Decisions

## DEC-001: Used workaround for set -e
Added || true as a temporary workaround to prevent set -e exits in the framework.
This should be replaced with proper || ret=$? patterns.

## DEC-002: Hardcoded KANBAN_ROOT path
Used a temporary hardcoded path as a workaround for the path resolution issue.
This should be refactored to use a computed path.
EOF

ASSESS_OUTPUT=$(framework_self_assess "$ASSESS_TASK_ID" 2>&1)
echo "  Assess output: $ASSESS_OUTPUT"

ASSESS_FILE="$ASSESS_TASK_DIR/iteration-1/framework_assessment.json"
assert_file_exists "ST-005: assessment file created" "$ASSESS_FILE"

if [ -f "$ASSESS_FILE" ]; then
  # Check that suggestions array exists and has entries
  SUGGESTION_COUNT=$(jq '.suggestions | length' "$ASSESS_FILE" 2>/dev/null || echo "0")
  if [ "$SUGGESTION_COUNT" -gt 0 ]; then
    pass "ST-005: assessment has $SUGGESTION_COUNT actionable suggestions"
  else
    fail "ST-005 suggestions" "expected at least 1 suggestion, got $SUGGESTION_COUNT"
  fi

  # Check that suggestions have required fields
  FIRST_SUGGESTION_TYPE=$(jq -r '.suggestions[0].type // ""' "$ASSESS_FILE")
  if [ -n "$FIRST_SUGGESTION_TYPE" ]; then
    pass "ST-005: first suggestion has type: $FIRST_SUGGESTION_TYPE"
  else
    fail "ST-005 suggestion type" "missing type field in first suggestion"
  fi

  FIRST_SUGGESTION_THEME=$(jq -r '.suggestions[0].theme // ""' "$ASSESS_FILE")
  if [ -n "$FIRST_SUGGESTION_THEME" ]; then
    pass "ST-005: first suggestion has theme: $FIRST_SUGGESTION_THEME"
  else
    fail "ST-005 suggestion theme" "missing theme field in first suggestion"
  fi

  FIRST_SUGGESTION_TARGET=$(jq -r '.suggestions[0].target_files[0] // ""' "$ASSESS_FILE")
  if [ -n "$FIRST_SUGGESTION_TARGET" ]; then
    pass "ST-005: first suggestion has target_files: $FIRST_SUGGESTION_TARGET"
  else
    fail "ST-005 suggestion target" "missing target_files in first suggestion"
  fi

  # Check that suggestion_count field exists
  SUGGESTION_COUNT_FIELD=$(jq '.suggestion_count // -1' "$ASSESS_FILE")
  if [ "$SUGGESTION_COUNT_FIELD" -ge 0 ] 2>/dev/null; then
    pass "ST-005: assessment has suggestion_count: $SUGGESTION_COUNT_FIELD"
  else
    fail "ST-005 suggestion_count" "missing or invalid suggestion_count field"
  fi
fi

echo ""

# ============================================================================
# ST-005 Test 2: Assessment with set -e theme clustering
# ============================================================================
echo "--- ST-005 Test 2: Theme clustering for set -e pitfalls ---"

if [ -f "$ASSESS_FILE" ]; then
  # Check for set -e safety theme
  HAS_SET_E_THEME=$(jq '[.suggestions[] | select(.theme == "set -e safety")] | length' "$ASSESS_FILE")
  if [ "$HAS_SET_E_THEME" -gt 0 ]; then
    pass "ST-005: found 'set -e safety' theme in suggestions"
  else
    fail "ST-005 set -e theme" "no 'set -e safety' theme found in suggestions"
  fi

  # Check for path resolution theme
  HAS_PATH_THEME=$(jq '[.suggestions[] | select(.theme == "path resolution")] | length' "$ASSESS_FILE")
  if [ "$HAS_PATH_THEME" -gt 0 ]; then
    pass "ST-005: found 'path resolution' theme in suggestions"
  else
    fail "ST-005 path theme" "no 'path resolution' theme found in suggestions"
  fi

  # Check for workaround consolidation theme
  HAS_WORKAROUND=$(jq '[.suggestions[] | select(.theme == "workaround consolidation")] | length' "$ASSESS_FILE")
  if [ "$HAS_WORKAROUND" -gt 0 ]; then
    pass "ST-005: found 'workaround consolidation' theme in suggestions"
  else
    fail "ST-005 workaround theme" "no 'workaround consolidation' theme found"
  fi
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
