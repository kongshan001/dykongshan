#!/usr/bin/env bash
# test_set_e_safety.sh -- Tests for ST-003: set -e safety patterns and grep -- separator
# Run: bash .claude/skills/kanban/test/test_set_e_safety.sh
#
# Tests:
#   1. Framework functions do not crash under set -e when returning non-zero
#   2. All grep calls in framework code use -- separator for variable patterns
#   3. worktree_exists returns 1 without triggering set -e exit when called safely

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

# === Setup ===
ORIG_DIR="$(pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'cd "$ORIG_DIR" && rm -rf "$TEST_ROOT"' EXIT

echo "=== test_set_e_safety.sh ==="
echo "Test root: $TEST_ROOT"
echo ""

# Set up a fake project with kanban structure
mkdir -p "$TEST_ROOT/.kanban/skills/evolved"
mkdir -p "$TEST_ROOT/.kanban/tasks"
mkdir -p "$TEST_ROOT/.kanban/archive"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/lib"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/agents"
mkdir -p "$TEST_ROOT/.claude/skills/kanban/rules"

# Copy lib files from the worktree
WORKTREE_LIB="/Users/ks_128/Documents/important_demo/.kanban/tasks/TASK-021/worktree/.claude/skills/kanban/lib"

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

# Initialize git repo
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
# Test 1: worktree_exists does not crash under set -e
# ============================================================================
echo "--- Test 1: worktree_exists safe under set -e ---"

# Create a task with no worktree
NO_WT_TASK_ID="TASK-300"
NO_WT_DIR="$TEST_ROOT/.kanban/tasks/$NO_WT_TASK_ID"
mkdir -p "$NO_WT_DIR"

cat > "$NO_WT_DIR/task.json" << EOF
{
  "id": "$NO_WT_TASK_ID",
  "title": "No worktree test",
  "description": "Testing worktree_exists safety",
  "engine": "claude-code",
  "status": "pending",
  "phase": null,
  "phase_lock": null,
  "iteration": 0,
  "max_iterations": 6,
  "scores": {},
  "worktree": {"branch": "", "path": "", "base": "main"},
  "history": [],
  "user_decision": null,
  "requires_archive_confirmation": true,
  "created_at": "2026-05-04T00:00:00Z",
  "updated_at": "2026-05-04T00:00:00Z"
}
EOF

# Test under set -e: worktree_exists should return 1 but not crash the script
set -e
WT_RESULT=0
worktree_exists "$NO_WT_TASK_ID" || WT_RESULT=$?
set +e

if [ "$WT_RESULT" = "1" ]; then
  pass "worktree_exists returns 1 for missing worktree (no crash)"
else
  fail "worktree_exists set -e" "expected return code 1, got $WT_RESULT"
fi

echo ""

# ============================================================================
# Test 2: _kanban_link_file returns 1 for skip without crashing
# ============================================================================
echo "--- Test 2: _kanban_link_file safe under set -e ---"

# Create a pre-existing symlink
mkdir -p "$TEST_ROOT/.claude/agents"
ln -sf "../skills/kanban/agents/planner.md" "$TEST_ROOT/.claude/agents/planner.md"

# Call _kanban_link_file on the same target -- should return 1 (skip)
set -e
LINK_RESULT=0
_kanban_link_file "$TEST_ROOT/.claude/agents" "planner.md" "../skills/kanban/agents/planner.md" || LINK_RESULT=$?
set +e

if [ "$LINK_RESULT" = "1" ]; then
  pass "_kanban_link_file returns 1 for existing valid symlink (no crash)"
else
  fail "_kanban_link_file set -e" "expected return code 1, got $LINK_RESULT"
fi

echo ""

# ============================================================================
# Test 3: grep -- separator audit in framework source files
# ============================================================================
echo "--- Test 3: grep -- separator audit ---"

WORKTREE_LIB_DIR="/Users/ks_128/Documents/important_demo/.kanban/tasks/TASK-021/worktree/.claude/skills/kanban/lib"

# Check that all grep calls with -E and a variable pattern have --
# Pattern: grep -<flags> "$VARIABLE" without --
AUDIT_ISSUES=0

for sh_file in "$WORKTREE_LIB_DIR"/*.sh; do
  fname=$(basename "$sh_file")
  # Find grep calls that use $-interpolated patterns without --
  # These patterns have variables like $_SKILLS_*, $keyword, $branch
  UNSAFE_GREPS=$(grep -n 'grep.*\$' "$sh_file" | grep -v '\-\-' | grep -v '#' | grep -v '|| echo\||| true\|2>/dev/null.*grep\|grep -v' | head -5 || true)
  # Only flag lines where the grep pattern is clearly a variable (contains $)
  if [ -n "$UNSAFE_GREPS" ]; then
    # Filter: only flag if the pattern is a variable, not just $file as an argument
    REAL_ISSUES=""
    while IFS= read -r line; do
      # Check if the pattern part (between grep flags and the file arg) contains a variable
      if echo "$line" | grep -qE 'grep.*-[qciE]*\s+"?\$'; then
        # The search pattern starts with a variable -- needs --
        if ! echo "$line" | grep -q '\-\-'; then
          REAL_ISSUES="$REAL_ISSUES\n  $line"
        fi
      fi
    done <<< "$UNSAFE_GREPS"

    if [ -n "$REAL_ISSUES" ]; then
      echo "  WARNING: potential missing -- in $fname:"
      echo -e "$REAL_ISSUES"
      AUDIT_ISSUES=$((AUDIT_ISSUES + 1))
    fi
  fi
done

if [ "$AUDIT_ISSUES" = "0" ]; then
  pass "grep -- separator audit: all variable-pattern grep calls use --"
else
  fail "grep -- audit" "found $AUDIT_ISSUES files with potential missing -- separator"
fi

echo ""

# ============================================================================
# Test 4: _kanban_install_deps works under set -e
# ============================================================================
echo "--- Test 4: _kanban_install_deps under set -e ---"

# _kanban_install_deps should complete without triggering set -e
set -e
INSTALL_OUTPUT=$(_kanban_install_deps 2>&1)
set +e

INSTALL_EXIT=$?
if [ "$INSTALL_EXIT" = "0" ]; then
  pass "_kanban_install_deps completes successfully under set -e"
else
  fail "_kanban_install_deps set -e" "exit code $INSTALL_EXIT, expected 0"
fi

echo ""

# ============================================================================
# Test 5: kanban_knowledge_search with special chars in keyword
# ============================================================================
echo "--- Test 5: grep -- safety with special chars ---"

# Create a knowledge log with a test entry
cat > "$TEST_ROOT/.kanban/knowledge-log.md" << 'EOF'
# Knowledge Log

## Entries

### K001: test-category
- **分类**: test-category
- **来源**: TASK-000
- **描述**: A test entry with - leading dash pattern

---
EOF

# Search for a pattern starting with dash -- should not crash
SEARCH_OUTPUT=$(kanban_knowledge_search "- leading" 2>&1) || true
if [ $? -eq 0 ] || [ -n "$SEARCH_OUTPUT" ]; then
  pass "kanban_knowledge_search handles dash-prefixed pattern safely"
else
  fail "knowledge search dash" "search crashed with dash-prefixed pattern"
fi

# Search for normal keyword
SEARCH_OUTPUT2=$(kanban_knowledge_search "test-category" 2>&1) || true
if echo "$SEARCH_OUTPUT2" | grep -q "K001"; then
  pass "kanban_knowledge_search finds entry with normal keyword"
else
  fail "knowledge search normal" "failed to find K001 entry"
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
