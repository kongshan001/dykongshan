#!/usr/bin/env bash
# test_integration_st010_st017.sh -- End-to-end integration tests for ST-010~ST-017
# Covers: archive fixup commit, directory cohesion, data migration, plan quality gate,
#         workflow plan iteration, framework self-assess, SKILL.md updates
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIB_DIR="$SKILL_DIR/lib"

# Track test results
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Per-test temp directory
_TEST_TMPDIR=""
_TEST_KANBAN_DIR=""

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label"
    echo "    expected: $expected"
    echo "    actual:   $actual"
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
    echo "    string: $haystack"
    echo "    not found: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -q "$needle"; then
    echo "  FAIL: $label"
    echo "    string: $haystack"
    echo "    found (should not): $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_file_exists() {
  local label="$1" filepath="$2"
  if [ -f "$filepath" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label (file not found: $filepath)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_dir_exists() {
  local label="$1" dirpath="$2"
  if [ -d "$dirpath" ]; then
    echo "  PASS: $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $label (dir not found: $dirpath)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# Setup: create isolated test environment
# Sources all lib scripts from the test worktree, then overrides KANBAN_DIR
# to point at our temp directory
setup() {
  _TEST_TMPDIR=$(mktemp -d /tmp/kanban_test_st010.XXXXXX)
  _TEST_KANBAN_DIR="$_TEST_TMPDIR/.kanban"
  mkdir -p "$_TEST_KANBAN_DIR"/{tasks,reports,archive,dispatch,worktrees}

  # Create minimal config
  cat > "$_TEST_KANBAN_DIR/config.json" << 'EOF'
{
  "project": "test",
  "trunk": "main",
  "output_dir": "games",
  "framework_assessment": { "enabled": true }
}
EOF

  # Create minimal workflow
  cat > "$_TEST_KANBAN_DIR/workflow.json" << 'EOF'
{
  "phases": [
    {
      "id": "plan",
      "name": "规划阶段",
      "required_artifacts": ["requirements.md", "task_breakdown.json"],
      "quality_gate": { "enabled": true, "max_rounds": 3, "pass_threshold": 9.0 }
    },
    { "id": "execute", "name": "执行阶段" },
    { "id": "evaluate", "name": "评估阶段", "pass_threshold": 9.0 }
  ],
  "self_improve": { "max_iterations": 6 }
}
EOF

  cat > "$_TEST_KANBAN_DIR/index.json" << 'EOF'
{ "project": "test", "trunk": "main", "tasks": [] }
EOF

  # Source all libs (this sets KANBAN_DIR=".kanban" inside functions)
  # We use the existing functions but will call them with our overridden KANBAN_DIR
  # Since the functions reference $KANBAN_DIR as a global, we override it after sourcing
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  source "$LIB_DIR/kanban.sh"
  # kanban_init_env loads all other libs from SKILL_DIR
  kanban_init_env 2>/dev/null || true

  # Now override KANBAN_DIR - functions will use this value
  KANBAN_DIR="$_TEST_KANBAN_DIR"
}

teardown() {
  rm -rf "$_TEST_TMPDIR"
}

# Create a test task in OLD format for migration tests
create_old_task() {
  local task_id="$1"
  local title="$2"
  local now=$(date -u +%FT%TZ)
  jq -n \
    --arg id "$task_id" --arg title "$title" --arg now "$now" \
    '{
      id: $id, title: $title, description: "", engine: "claude-code",
      status: "pending", phase: null, phase_lock: null, assignee: null,
      worktree: { branch: "feature/'$task_id'", path: "", base: "main" },
      iteration: 0, max_iterations: 6, token_budget: 500000, token_used: 0,
      scores: {}, depends_on: [], modified_files: [],
      task_breakdown: { file: "", subtasks: [] }, history: [],
      user_decision: null, requires_archive_confirmation: true,
      created_at: $now, updated_at: $now, entered_at: null
    }' > "$_TEST_KANBAN_DIR/tasks/${task_id}.json"
}

# Create a test task in NEW format
create_new_task() {
  local task_id="$1"
  local title="$2"
  local now=$(date -u +%FT%TZ)
  mkdir -p "$_TEST_KANBAN_DIR/tasks/${task_id}"
  jq -n \
    --arg id "$task_id" --arg title "$title" --arg now "$now" \
    '{
      id: $id, title: $title, description: "", engine: "claude-code",
      status: "pending", phase: null, phase_lock: null, assignee: null,
      worktree: { branch: "feature/'$task_id'", path: "", base: "main" },
      iteration: 1, max_iterations: 6, token_budget: 500000, token_used: 0,
      scores: {}, depends_on: [], modified_files: [],
      task_breakdown: { file: "", subtasks: [] }, history: [],
      user_decision: null, requires_archive_confirmation: true,
      created_at: $now, updated_at: $now, entered_at: null
    }' > "$_TEST_KANBAN_DIR/tasks/${task_id}/task.json"
}

# ============================================================
echo "=========================================="
echo "ST-010: 归档流程增加兜底 git commit"
echo "=========================================="
setup

echo "--- ST-010.1: kanban_archive_task with worktree unavailable ---"
create_new_task "TASK-100" "Test fixup commit"
# Set user decision for archive
local_tf="$_TEST_KANBAN_DIR/tasks/TASK-100/task.json"
tmp=$(mktemp)
jq '.user_decision = {action: "approve_and_archive", decided_at: "2026-01-01T00:00:00Z"}' "$local_tf" > "$tmp" && mv "$tmp" "$local_tf"
jq '.requires_archive_confirmation = true' "$local_tf" > "$tmp" && mv "$tmp" "$local_tf"

# Archive should succeed even without worktree
output=$(kanban_archive_task "TASK-100" 2>&1 || true)
assert_contains "ST-010: archive succeeds without worktree" "$output" "Archived TASK-100"
assert_dir_exists "ST-010: task moved to archive" "$_TEST_KANBAN_DIR/archive/TASK-100"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "ST-011: 任务目录结构内聚化 -- 路径层改造"
echo "=========================================="
setup

echo "--- ST-011.1: task_file helper returns new path for new layout ---"
create_new_task "TASK-200" "Path helper test"
result=$(task_file "TASK-200")
assert_eq "ST-011: task_file returns new path" "$_TEST_KANBAN_DIR/tasks/TASK-200/task.json" "$result"

echo "--- ST-011.2: task_dir helper ---"
result=$(task_dir "TASK-200")
assert_eq "ST-011: task_dir returns task directory" "$_TEST_KANBAN_DIR/tasks/TASK-200" "$result"

echo "--- ST-011.3: report_dir helper ---"
result=$(report_dir "TASK-200" 1)
assert_eq "ST-011: report_dir returns iteration dir" "$_TEST_KANBAN_DIR/tasks/TASK-200/iteration-1" "$result"

echo "--- ST-011.4: dispatch_dir helper (falls back to old when new dir not created yet) ---"
# dispatch_dir falls back to old path when new dir doesn't exist yet
# This is correct: the dispatch dir is created on demand by evaluator_prepare_all
result=$(dispatch_dir "TASK-200")
assert_contains "ST-011: dispatch_dir returns valid dispatch path" "$result" "dispatch"

echo "--- ST-011.5: inbox_file helper ---"
result=$(inbox_file "TASK-200")
assert_eq "ST-011: inbox_file returns inbox path" "$_TEST_KANBAN_DIR/tasks/TASK-200/inbox.md" "$result"

echo "--- ST-011.6: is_new_layout detects new format ---"
is_new_layout "TASK-200"
result=$?
assert_eq "ST-011: is_new_layout returns 0 for new format" "0" "$result"

echo "--- ST-011.7: old format fallback in task_file ---"
create_old_task "TASK-201" "Old format task"
result=$(task_file "TASK-201")
assert_eq "ST-011: task_file returns old path for old format" "$_TEST_KANBAN_DIR/tasks/TASK-201.json" "$result"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "ST-012: 任务目录内聚化 -- 数据迁移"
echo "=========================================="
setup

echo "--- ST-012.1: migrate_task_dir converts old to new ---"
create_old_task "TASK-300" "Migration test"
# Create old-style reports
mkdir -p "$_TEST_KANBAN_DIR/reports/TASK-300/iteration-1"
echo "# Requirements" > "$_TEST_KANBAN_DIR/reports/TASK-300/iteration-1/requirements.md"
echo "# Inbox" > "$_TEST_KANBAN_DIR/reports/TASK-300/inbox.md"

migrate_task_dir "TASK-300"

assert_dir_exists "ST-012: new task dir created" "$_TEST_KANBAN_DIR/tasks/TASK-300"
assert_file_exists "ST-012: task.json in new dir" "$_TEST_KANBAN_DIR/tasks/TASK-300/task.json"
assert_file_exists "ST-012: inbox.md migrated" "$_TEST_KANBAN_DIR/tasks/TASK-300/inbox.md"
assert_file_exists "ST-012: iteration-1 migrated" "$_TEST_KANBAN_DIR/tasks/TASK-300/iteration-1/requirements.md"
# Old file should be gone
assert_eq "ST-012: old task file removed" "0" "$( [ -f "$_TEST_KANBAN_DIR/tasks/TASK-300.json" ] && echo 1 || echo 0 )"

echo "--- ST-012.2: migrate is idempotent ---"
migrate_task_dir "TASK-300"
assert_file_exists "ST-012: task.json still exists after re-migration" "$_TEST_KANBAN_DIR/tasks/TASK-300/task.json"

echo "--- ST-012.3: migrate_all_tasks ---"
create_old_task "TASK-301" "Batch migration test 1"
create_old_task "TASK-302" "Batch migration test 2"
output=$(migrate_all_tasks 2>&1)
assert_contains "ST-012: migrate_all_tasks reports count" "$output" "Migrated"
assert_dir_exists "ST-012: TASK-301 migrated" "$_TEST_KANBAN_DIR/tasks/TASK-301"
assert_dir_exists "ST-012: TASK-302 migrated" "$_TEST_KANBAN_DIR/tasks/TASK-302"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "ST-013: Plan质量门禁 -- guard_check_plan_quality"
echo "=========================================="
setup

echo "--- ST-013.1: High quality plan passes ---"
create_new_task "TASK-400" "Plan quality test"
mkdir -p "$_TEST_KANBAN_DIR/tasks/TASK-400/iteration-1"
cat > "$_TEST_KANBAN_DIR/tasks/TASK-400/iteration-1/requirements.md" << 'REQEOF'
# Requirements

## 功能需求
- FR-001: Test feature

## 非功能需求
- NFR-001: Performance

## 验收标准
- AC-101: Feature works
- AC-102: Tests pass
- AC-103: No regressions

## 技术约束
- TC-001: Use bash
REQEOF

cat > "$_TEST_KANBAN_DIR/tasks/TASK-400/iteration-1/task_breakdown.json" << 'BKEOF'
{
  "task_id": "TASK-400",
  "subtasks": [
    { "id": "ST-001", "title": "Subtask 1", "description": "Do something", "priority": "high", "estimated_files": ["test.js"], "dependencies": [] },
    { "id": "ST-002", "title": "Subtask 2", "description": "Do more", "priority": "medium", "estimated_files": ["test2.js"], "dependencies": ["ST-001"] }
  ]
}
BKEOF

# Write quality result to temp file to avoid stdout mixing
guard_check_plan_quality "TASK-400" "$_TEST_KANBAN_DIR/tasks/TASK-400/iteration-1" 2>/dev/null || true
local_json_file="$_TEST_KANBAN_DIR/tasks/TASK-400/iteration-1/.plan_quality.json"
pass_val=$(jq -r '.pass' "$local_json_file" 2>/dev/null || echo "error")
assert_eq "ST-013: high quality plan passes" "true" "$pass_val"
total_score=$(jq -r '.total_score' "$local_json_file" 2>/dev/null || echo "0")
echo "  Plan quality score: $total_score"

echo "--- ST-013.2: Low quality plan fails ---"
create_new_task "TASK-401" "Bad plan test"
mkdir -p "$_TEST_KANBAN_DIR/tasks/TASK-401/iteration-1"
cat > "$_TEST_KANBAN_DIR/tasks/TASK-401/iteration-1/requirements.md" << 'REQEOF'
# Simple doc
Just a brief description.
REQEOF

cat > "$_TEST_KANBAN_DIR/tasks/TASK-401/iteration-1/task_breakdown.json" << 'BKEOF'
{ "task_id": "TASK-401", "subtasks": [] }
BKEOF

local_json_file="$_TEST_KANBAN_DIR/tasks/TASK-401/iteration-1/.plan_quality.json"
guard_check_plan_quality "TASK-401" "$_TEST_KANBAN_DIR/tasks/TASK-401/iteration-1" 2>/dev/null || true
pass_val=$(jq -r '.pass' "$local_json_file" 2>/dev/null || echo "error")
assert_eq "ST-013: low quality plan fails" "false" "$pass_val"
total_score=$(jq -r '.total_score' "$local_json_file" 2>/dev/null || echo "0")
echo "  Plan quality score: $total_score"
assert_file_exists "ST-013: issues reported for bad plan" "$local_json_file"

# ============================================================
echo ""
echo "=========================================="
echo "ST-014: Plan自迭代逻辑"
echo "=========================================="
setup

echo "--- ST-014.1: workflow_check_plan_retry returns pass for good plan ---"
create_new_task "TASK-500" "Retry test"
# Set plan_quality.pass = true
local_tf="$_TEST_KANBAN_DIR/tasks/TASK-500/task.json"
tmp=$(mktemp)
jq '.plan_quality = {pass: true, last_score: 9.5, retries: 0}' "$local_tf" > "$tmp" && mv "$tmp" "$local_tf"

result=$(workflow_check_plan_retry "TASK-500")
assert_eq "ST-014: returns pass for passing plan" "pass" "$result"

echo "--- ST-014.2: workflow_check_plan_retry returns retry for failed plan ---"
local_tf="$_TEST_KANBAN_DIR/tasks/TASK-500/task.json"
tmp=$(mktemp)
jq '.plan_quality = {pass: false, last_score: 5.0, retries: 1, max_rounds: 3}' "$local_tf" > "$tmp" && mv "$tmp" "$local_tf"

result=$(workflow_check_plan_retry "TASK-500")
assert_eq "ST-014: returns retry for failed plan under max" "retry" "$result"

echo "--- ST-014.3: workflow_check_plan_retry returns max_reached ---"
local_tf="$_TEST_KANBAN_DIR/tasks/TASK-500/task.json"
tmp=$(mktemp)
jq '.plan_quality = {pass: false, last_score: 5.0, retries: 3, max_rounds: 3}' "$local_tf" > "$tmp" && mv "$tmp" "$local_tf"

result=$(workflow_check_plan_retry "TASK-500")
assert_eq "ST-014: returns max_reached when at limit" "max_reached" "$result"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "ST-015: framework_self_assess"
echo "=========================================="
setup

echo "--- ST-015.1: framework_self_assess produces report ---"
create_new_task "TASK-600" "Self assess test"
mkdir -p "$_TEST_KANBAN_DIR/tasks/TASK-600/iteration-1"
cat > "$_TEST_KANBAN_DIR/tasks/TASK-600/iteration-1/execution_pitfalls.md" << 'EOF'
# Pitfalls
- Worktree path issues with kanban framework
- Guard check was too strict
EOF

cat > "$_TEST_KANBAN_DIR/tasks/TASK-600/iteration-1/execution_decisions.md" << 'EOF'
# Decisions
- Decision 1: Use task_file helper
- Decision 2: Add quality gate
- Decision 3: Framework evolution
EOF

output=$(framework_self_assess "TASK-600" 2>&1)
assert_contains "ST-015: assessment completes" "$output" "Framework assessment complete"
assert_file_exists "ST-015: assessment report created" "$_TEST_KANBAN_DIR/tasks/TASK-600/iteration-1/framework_assessment.json"

# Verify report content
report_score=$(jq -r '.assessment_score // 0' "$_TEST_KANBAN_DIR/tasks/TASK-600/iteration-1/framework_assessment.json")
echo "  Assessment score: $report_score"

echo "--- ST-015.2: framework_self_assess respects enabled flag ---"
# Verify KANBAN_DIR is pointing to temp dir
echo "  DEBUG: KANBAN_DIR=$KANBAN_DIR"
# Write config with assessment disabled
jq '.framework_assessment.enabled = false' "$_TEST_KANBAN_DIR/config.json" > "$_TEST_KANBAN_DIR/config.json.tmp" \
  && mv "$_TEST_KANBAN_DIR/config.json.tmp" "$_TEST_KANBAN_DIR/config.json"
echo "  DEBUG: config enabled=$(jq -r '.framework_assessment.enabled' "$_TEST_KANBAN_DIR/config.json")"
output=$(framework_self_assess "TASK-600" 2>&1 || true)
assert_contains "ST-015: respects disabled flag" "$output" "disabled"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "ST-016: SKILL.md updated"
echo "=========================================="

echo "--- ST-016.1: SKILL.md references new directory structure ---"
skill_md="$SKILL_DIR/SKILL.md"
assert_file_exists "ST-016: SKILL.md exists" "$skill_md"

content=$(cat "$skill_md")
assert_contains "ST-016: references task_dir helper" "$content" "task_dir(task_id)"
assert_contains "ST-016: references plan quality gate" "$content" "guard_check_plan_quality"
assert_contains "ST-016: references framework_self_assess" "$content" "framework_self_assess"
assert_contains "ST-016: references fixup commit" "$content" "fixup commit"
assert_contains "ST-016: references worktree tolerance" "$content" "worktree"
assert_contains "ST-016: references cohesive directory" "$content" "tasks/TASK-NNN/"

# ============================================================
echo ""
echo "=========================================="
echo "ST-011/012 Full Flow: create -> archive with new layout"
echo "=========================================="
setup

echo "--- Full.1: kanban_create_task uses new layout ---"
output=$(kanban_create_task "Integration Test" "Testing full flow" 2>&1)
# Extract task_id from output
task_id=$(echo "$output" | grep -o 'TASK-[0-9]*' | head -1)
echo "  Created: $task_id"
assert_dir_exists "Full: new task dir created" "$_TEST_KANBAN_DIR/tasks/${task_id}"
assert_file_exists "Full: task.json exists" "$_TEST_KANBAN_DIR/tasks/${task_id}/task.json"
assert_file_exists "Full: inbox.md exists" "$_TEST_KANBAN_DIR/tasks/${task_id}/inbox.md"

echo "--- Full.2: task_file returns correct path ---"
result=$(task_file "$task_id")
assert_eq "Full: task_file path" "$_TEST_KANBAN_DIR/tasks/${task_id}/task.json" "$result"

echo "--- Full.3: kanban_show_task works ---"
output=$(kanban_show_task "$task_id" 2>&1)
assert_contains "Full: show_task shows title" "$output" "Integration Test"

echo "--- Full.4: kanban_archive_task moves directory ---"
# Set user decision
local_tf="$_TEST_KANBAN_DIR/tasks/${task_id}/task.json"
tmp=$(mktemp)
jq '.user_decision = {action: "approve_and_archive", decided_at: "2026-01-01T00:00:00Z"} | .requires_archive_confirmation = true' "$local_tf" > "$tmp" && mv "$tmp" "$local_tf"

output=$(kanban_archive_task "$task_id" 2>&1)
assert_contains "Full: archive succeeds" "$output" "Archived"
assert_dir_exists "Full: archived dir exists" "$_TEST_KANBAN_DIR/archive/${task_id}"
assert_file_exists "Full: archived task.json exists" "$_TEST_KANBAN_DIR/archive/${task_id}/task.json"

echo "--- Full.5: _next_task_id counts both formats ---"
# Create old format archived task
jq -n '{id: "TASK-999", title: "old archive"}' > "$_TEST_KANBAN_DIR/archive/TASK-999.json"
result=$(_next_task_id)
echo "  Next task ID: $result"
# Should be higher than 999
num=$(echo "$result" | sed 's/TASK-//')
assert_eq "Full: next_task_id > 999" "1" "$([ "$num" -gt 999 ] && echo 1 || echo 0)"

teardown

# ============================================================
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total:  $TESTS_RUN"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"

if [ "$TESTS_FAILED" -gt 0 ]; then
  echo ""
  echo "SOME TESTS FAILED"
  exit 1
else
  echo ""
  echo "ALL TESTS PASSED"
  exit 0
fi
