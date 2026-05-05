#!/usr/bin/env bash
# test_create_task_bugs.sh -- Regression tests for ST-002 (Issues #29/#22, #21)
# Bug 1: jq --argjson invalid JSON warning in kanban_create_task
# Bug 2: Hardcoded worktree.base "main" instead of reading from config.json

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_FILE=$(mktemp)
trap 'rm -f "$RESULTS_FILE"' EXIT

echo "0 0" > "$RESULTS_FILE"  # passed failed

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    local p f; read p f < "$RESULTS_FILE"; echo "$((p+1)) $f" > "$RESULTS_FILE"
  else
    local p f; read p f < "$RESULTS_FILE"; echo "$p $((f+1))" > "$RESULTS_FILE"
    echo "FAIL: $label"
    echo "  expected: $expected"
    echo "  actual:   $actual"
  fi
}

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -qF "$needle"; then
    local p f; read p f < "$RESULTS_FILE"; echo "$p $((f+1))" > "$RESULTS_FILE"
    echo "FAIL: $label"
    echo "  expected NOT to contain: $needle"
    echo "  actual: $haystack"
  else
    local p f; read p f < "$RESULTS_FILE"; echo "$((p+1)) $f" > "$RESULTS_FILE"
  fi
}

# --- Setup: create a fresh isolated kanban environment ---
# Returns temp dir path. Caller must clean up.
setup_kanban() {
  local trunk_val="${1:-main}"
  local td
  td=$(mktemp -d)
  (
    cd "$td"
    git init -q
    mkdir -p .kanban/tasks
    cat > .kanban/config.json <<CONFEOF
{
  "project": "test_project",
  "trunk": "$trunk_val",
  "output_dir": "src"
}
CONFEOF
    cat > .kanban/index.json <<'EOF'
{"project":"test_project","trunk":"main","tasks":[]}
EOF
    if [ -f "$SKILL_DIR/templates/workflow.json" ]; then
      cp "$SKILL_DIR/templates/workflow.json" .kanban/workflow.json
    else
      echo '{"phases":[]}' > .kanban/workflow.json
    fi
  )
  echo "$td"
}

# Run a test body in a subshell with its own kanban env.
# The test body can call assert_eq/assert_not_contains which write to RESULTS_FILE.
run_in_subshell() {
  local td="$1"
  shift
  (
    cd "$td"
    KANBAN_DIR=".kanban"
    _KANBAN_CORE_LOADED=""
    source "$SKILL_DIR/lib/kanban.sh" 2>/dev/null
    "$@"
  )
  rm -rf "$td"
}

# =====================================================
# Test bodies (each runs in isolated subshell)
# =====================================================

test_worktree_base_from_config_default() {
  kanban_create_task "Test task for base" >/dev/null 2>&1 || true

  local task_dir
  task_dir=$(ls -d .kanban/tasks/TASK-*/ 2>/dev/null | tail -1)
  [ -z "$task_dir" ] && { echo "FAIL: no task created"; return 1; }

  local base_val
  base_val=$(jq -r '.worktree.base' "$task_dir/task.json")
  assert_eq "worktree.base should be 'main' when config trunk is 'main'" "main" "$base_val"
}

test_worktree_base_from_config_custom_trunk() {
  kanban_create_task "Test task custom trunk" >/dev/null 2>&1 || true

  local task_dir
  task_dir=$(ls -d .kanban/tasks/TASK-*/ 2>/dev/null | tail -1)
  [ -z "$task_dir" ] && { echo "FAIL: no task created"; return 1; }

  local base_val
  base_val=$(jq -r '.worktree.base' "$task_dir/task.json")
  assert_eq "worktree.base should be 'develop' when config trunk is 'develop'" "develop" "$base_val"
}

test_worktree_base_fallback_when_no_config() {
  rm -f .kanban/config.json

  kanban_create_task "Test task no config" >/dev/null 2>&1 || true

  local task_dir
  task_dir=$(ls -d .kanban/tasks/TASK-*/ 2>/dev/null | tail -1)
  [ -z "$task_dir" ] && { echo "FAIL: no task created"; return 1; }

  local base_val
  base_val=$(jq -r '.worktree.base' "$task_dir/task.json")
  assert_eq "worktree.base should fallback to 'main' when config.json missing" "main" "$base_val"
}

test_no_argjson_warning_on_create() {
  local stderr_output
  stderr_output=$(kanban_create_task "Test argjson warning" 2>&1 1>/dev/null)

  assert_not_contains "No jq warning on task create" "$stderr_output" "Invalid"
  assert_not_contains "No jq JSON parse error on task create" "$stderr_output" "parse error"
  assert_not_contains "No jq argjson error on task create" "$stderr_output" "argjson"
}

test_index_json_valid_after_create() {
  kanban_create_task "Test index JSON" >/dev/null 2>&1 || true

  local valid
  valid=$(jq '.' .kanban/index.json >/dev/null 2>&1 && echo "yes" || echo "no")
  assert_eq "index.json should be valid JSON after task creation" "yes" "$valid"

  local task_count
  task_count=$(jq '.tasks | length' .kanban/index.json)
  assert_eq "index.json should have exactly 1 task" "1" "$task_count"
}

test_task_json_valid_after_create() {
  kanban_create_task "Test task JSON validity" "Some description" >/dev/null 2>&1 || true

  local task_dir
  task_dir=$(ls -d .kanban/tasks/TASK-*/ 2>/dev/null | tail -1)
  [ -z "$task_dir" ] && { echo "FAIL: no task created"; return 1; }

  local valid
  valid=$(jq '.' "$task_dir/task.json" >/dev/null 2>&1 && echo "yes" || echo "no")
  assert_eq "task.json should be valid JSON" "yes" "$valid"

  local phase_val
  phase_val=$(jq -r '.phase' "$task_dir/task.json")
  assert_eq "phase should be null" "null" "$phase_val"

  local iter_val
  iter_val=$(jq -r '.iteration' "$task_dir/task.json")
  assert_eq "iteration should be 0" "0" "$iter_val"
}

test_index_entry_matches_task() {
  kanban_create_task "Test index entry match" >/dev/null 2>&1 || true

  local task_dir
  task_dir=$(ls -d .kanban/tasks/TASK-*/ 2>/dev/null | tail -1)
  local task_id
  task_id=$(jq -r '.id' "$task_dir/task.json")

  local index_id
  index_id=$(jq -r '.tasks[0].id' .kanban/index.json)
  assert_eq "index task id should match created task id" "$task_id" "$index_id"

  local index_status
  index_status=$(jq -r '.tasks[0].status' .kanban/index.json)
  assert_eq "index task status should be pending" "pending" "$index_status"
}

# =====================================================
# Run all tests
# =====================================================

echo "=== ST-002 Regression Tests: kanban_create_task bugs ==="
echo ""

td=$(setup_kanban "main")          ; run_in_subshell "$td" test_worktree_base_from_config_default
td=$(setup_kanban "develop")       ; run_in_subshell "$td" test_worktree_base_from_config_custom_trunk
td=$(setup_kanban "main")          ; run_in_subshell "$td" test_worktree_base_fallback_when_no_config
td=$(setup_kanban "main")          ; run_in_subshell "$td" test_no_argjson_warning_on_create
td=$(setup_kanban "main")          ; run_in_subshell "$td" test_index_json_valid_after_create
td=$(setup_kanban "main")          ; run_in_subshell "$td" test_task_json_valid_after_create
td=$(setup_kanban "develop")       ; run_in_subshell "$td" test_index_entry_matches_task

echo ""
read passed failed < "$RESULTS_FILE"
echo "=== Results: $passed passed, $failed failed ==="

[ "$failed" -eq 0 ] && exit 0 || exit 1
