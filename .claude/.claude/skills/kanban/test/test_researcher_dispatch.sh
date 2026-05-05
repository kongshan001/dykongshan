#!/usr/bin/env bash
# test_researcher_dispatch.sh -- Tests for researcher trigger_condition and dispatch (ST-011)
# Run: bash .claude/skills/kanban/test/test_researcher_dispatch.sh

set -e

# ============================================================
# Test framework helpers
# ============================================================
PASS_COUNT=0
FAIL_COUNT=0

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  local msg="$1"
  echo "FAIL: $msg"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

assert_equals() {
  local expected="$1"
  local actual="$2"
  local label="${3:-assertion}"
  if [ "$expected" = "$actual" ]; then
    pass
  else
    fail "$label: expected='$expected' actual='$actual'"
  fi
}

assert_not_empty() {
  local val="$1"
  local label="${2:-assertion}"
  if [ -n "$val" ]; then
    pass
  else
    fail "$label: value is empty"
  fi
}

assert_file_exists() {
  local file="$1"
  local label="${2:-assertion}"
  if [ -e "$file" ]; then
    pass
  else
    fail "$label: file '$file' does not exist"
  fi
}

assert_file_not_exists() {
  local file="$1"
  local label="${2:-assertion}"
  if [ ! -e "$file" ]; then
    pass
  else
    fail "$label: file '$file' should NOT exist"
  fi
}

# ============================================================
# Setup: create temp kanban environment
# ============================================================
REAL_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG_DIR="$(pwd)"
TEST_TMPDIR=$(mktemp -d /tmp/test_researcher_dispatch_XXXXXX)

cleanup() {
  cd "$ORIG_DIR"
  rm -rf "$TEST_TMPDIR"
}
trap cleanup EXIT

cd "$TEST_TMPDIR"
git init -q
git config user.email "test@test.com"
git config user.name "Test"

mkdir -p .claude/skills/kanban/lib
mkdir -p .claude/skills/kanban/templates/reports
mkdir -p .kanban

cp "$REAL_SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/
cp "$REAL_SKILL_DIR"/lib/nlp_patterns.json .claude/skills/kanban/lib/ 2>/dev/null || true

if [ -d "$REAL_SKILL_DIR/templates/reports" ]; then
  cp "$REAL_SKILL_DIR"/templates/reports/*.json .claude/skills/kanban/templates/reports/ 2>/dev/null || true
fi

KANBAN_DIR=".kanban"
export KANBAN_DIR

cat > .kanban/config.json <<'CFG'
{
  "project": "test-project",
  "trunk": "main",
  "output_dir": "games",
  "dashboard": { "port": 3000 }
}
CFG

cat > .kanban/index.json <<'IDX'
{"project":"test-project","trunk":"main","tasks":[]}
IDX

git add -A
git commit -q -m "init"

source .claude/skills/kanban/lib/kanban.sh
kanban_init_env >/dev/null 2>&1 || true

echo "============================================"
echo "  Test Suite: Researcher Dispatch (ST-011)"
echo "============================================"
echo ""

# ============================================================
# Test 1: trigger_condition 关键词匹配
# ============================================================
echo "--- Test 1: trigger_condition keyword matching ---"

# Setup workflow.json with researcher trigger_condition
cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [
        {"role": "planner", "required": true},
        {"role": "researcher", "required": false, "trigger_condition": {"keywords": ["调研", "选型", "对比", "analysis", "research", "技术选型", "竞品"], "match_field": "description"}}
      ]
    },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

# Create a task with research-related description
mkdir -p .kanban/tasks/TASK-600
cat > .kanban/tasks/TASK-600/task.json <<'TASK'
{
  "id": "TASK-600",
  "title": "技术选型调研任务",
  "description": "需要对比分析 React 和 Vue 的优劣，进行技术选型",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-600", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

DISPATCH_OUTPUT=$(kanban_prepare_dispatch "TASK-600" 2>&1)
assert_equals "0" "$?" "Test1: kanban_prepare_dispatch returns 0"

# Check that researcher dispatch was generated
RESEARCHER_DISPATCH=".kanban/tasks/TASK-600/dispatch/TASK-600-researcher.json"
assert_file_exists "$RESEARCHER_DISPATCH" "Test1: researcher dispatch generated for research-related description"

echo ""

# ============================================================
# Test 2: researcher dispatch JSON 内容正确性
# ============================================================
echo "--- Test 2: researcher dispatch JSON content ---"

if [ -f "$RESEARCHER_DISPATCH" ]; then
  # Check required fields
  local_task_id=$(jq -r '.task_id' "$RESEARCHER_DISPATCH")
  local_title=$(jq -r '.title' "$RESEARCHER_DISPATCH")
  local_topic=$(jq -r '.research_topic' "$RESEARCHER_DISPATCH")
  local_constraints=$(jq -r '.constraints' "$RESEARCHER_DISPATCH")

  assert_equals "TASK-600" "$local_task_id" "Test2: task_id correct"
  assert_equals "技术选型调研任务" "$local_title" "Test2: title correct"
  assert_not_empty "$local_topic" "Test2: research_topic present"
  assert_not_empty "$local_constraints" "Test2: constraints present"

  # Check that research_topic matches the task description
  echo "$local_topic" | grep -qi "对比" && pass || fail "Test2: research_topic contains description content"
else
  fail "Test2: researcher dispatch file not found (depends on Test 1)"
fi

echo ""

# ============================================================
# Test 3: 不匹配时不触发 researcher
# ============================================================
echo "--- Test 3: No researcher dispatch when keywords don't match ---"

mkdir -p .kanban/tasks/TASK-601
cat > .kanban/tasks/TASK-601/task.json <<'TASK'
{
  "id": "TASK-601",
  "title": "普通开发任务",
  "description": "修复一个登录页面的按钮位置问题",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-601", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

DISPATCH_OUTPUT3=$(kanban_prepare_dispatch "TASK-601" 2>&1)
assert_equals "0" "$?" "Test3: kanban_prepare_dispatch returns 0"

RESEARCHER_DISPATCH3=".kanban/tasks/TASK-601/dispatch/TASK-601-researcher.json"
assert_file_not_exists "$RESEARCHER_DISPATCH3" "Test3: no researcher dispatch for non-research task"

# Verify execute dispatch was still created
EXECUTE_DISPATCH3=".kanban/tasks/TASK-601/dispatch/TASK-601-execute.json"
assert_file_exists "$EXECUTE_DISPATCH3" "Test3: execute dispatch still created"

echo ""

# ============================================================
# Test 4: workflow.json 无 trigger_condition 时不报错
# ============================================================
echo "--- Test 4: No error when workflow.json has no trigger_condition ---"

# Remove trigger_condition from workflow.json
cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [
        {"role": "planner", "required": true},
        {"role": "researcher", "required": false}
      ]
    },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

mkdir -p .kanban/tasks/TASK-602
cat > .kanban/tasks/TASK-602/task.json <<'TASK'
{
  "id": "TASK-602",
  "title": "No trigger_condition test",
  "description": "调研一下各种方案",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-602", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

DISPATCH_OUTPUT4=$(kanban_prepare_dispatch "TASK-602" 2>&1)
assert_equals "0" "$?" "Test4: no error without trigger_condition"

# Execute dispatch should still be created
EXECUTE_DISPATCH4=".kanban/tasks/TASK-602/dispatch/TASK-602-execute.json"
assert_file_exists "$EXECUTE_DISPATCH4" "Test4: execute dispatch created"

echo ""

# ============================================================
# Test 5: workflow.json 无 researcher agent 时不报错
# ============================================================
echo "--- Test 5: No error when no researcher agent in workflow.json ---"

cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [
        {"role": "planner", "required": true}
      ]
    },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

mkdir -p .kanban/tasks/TASK-603
cat > .kanban/tasks/TASK-603/task.json <<'TASK'
{
  "id": "TASK-603",
  "title": "No researcher test",
  "description": "调研一下各种方案",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-603", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

DISPATCH_OUTPUT5=$(kanban_prepare_dispatch "TASK-603" 2>&1)
assert_equals "0" "$?" "Test5: no error without researcher agent"

EXECUTE_DISPATCH5=".kanban/tasks/TASK-603/dispatch/TASK-603-execute.json"
assert_file_exists "$EXECUTE_DISPATCH5" "Test5: execute dispatch created"
assert_file_not_exists ".kanban/tasks/TASK-603/dispatch/TASK-603-researcher.json" "Test5: no researcher dispatch"

echo ""

# ============================================================
# Test 6: 英文关键词也能匹配
# ============================================================
echo "--- Test 6: English keywords also match ---"

cat > .kanban/workflow.json <<'WF'
{
  "phases": [
    {
      "id": "plan",
      "agents": [
        {"role": "planner", "required": true},
        {"role": "researcher", "required": false, "trigger_condition": {"keywords": ["调研", "选型", "对比", "analysis", "research", "技术选型", "竞品"], "match_field": "description"}}
      ]
    },
    { "id": "execute", "order": 2 },
    { "id": "evaluate", "order": 3 },
    { "id": "user_decision", "order": 4 },
    { "id": "archive", "order": 5 }
  ],
  "self_improve": { "max_iterations": 6 }
}
WF

mkdir -p .kanban/tasks/TASK-604
cat > .kanban/tasks/TASK-604/task.json <<'TASK'
{
  "id": "TASK-604",
  "title": "Research Task",
  "description": "Conduct a comparative analysis of authentication frameworks",
  "status": "executing",
  "phase": "execute",
  "phase_lock": "execute",
  "iteration": 1,
  "worktree": { "branch": "feature/TASK-604", "path": "" },
  "scores": {},
  "history": [],
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
TASK

DISPATCH_OUTPUT6=$(kanban_prepare_dispatch "TASK-604" 2>&1)
assert_equals "0" "$?" "Test6: kanban_prepare_dispatch returns 0"

# Should match "analysis" and/or "research" keywords
RESEARCHER_DISPATCH6=".kanban/tasks/TASK-604/dispatch/TASK-604-researcher.json"
assert_file_exists "$RESEARCHER_DISPATCH6" "Test6: researcher dispatch generated for English keywords"

echo ""

# ============================================================
# Summary
# ============================================================
echo "============================================"
TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed (total ${TOTAL})"
echo "============================================"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
