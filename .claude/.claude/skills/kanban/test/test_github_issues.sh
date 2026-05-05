#!/usr/bin/env bash
# test_github_issues.sh — 回归测试 GitHub Issues #1-#5
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_REAL_SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_DIR="$_REAL_SKILL_DIR"
TEST_DIR=""

setup() {
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
  git init -q
  mkdir -p .claude/skills/kanban/lib .claude/skills/kanban/agents .claude/skills/kanban/rules \
    .claude/skills/kanban/templates .claude/skills/kanban/dashboard .claude-plugin
  # 复制框架文件
  cp "$SKILL_DIR"/lib/*.sh .claude/skills/kanban/lib/
  cp "$SKILL_DIR"/templates/*.json .claude/skills/kanban/templates/ 2>/dev/null || true
  cp "$SKILL_DIR"/templates/GETTING_STARTED.md .claude/skills/kanban/templates/ 2>/dev/null || true
  cp "$SKILL_DIR"/agents/*.md .claude/skills/kanban/agents/ 2>/dev/null || true
  cp "$SKILL_DIR"/rules/*.md .claude/skills/kanban/rules/ 2>/dev/null || true
  mkdir -p .claude/skills/kanban/dashboard
  cp "$SKILL_DIR"/dashboard/server.js .claude/skills/kanban/dashboard/ 2>/dev/null || true
  echo '{"name":"kanban","version":"0.4.0"}' > .claude-plugin/plugin.json
  git add -A && git commit -qm "init" --allow-empty
  # Reset module load guards
  unset _KANBAN_CORE_LOADED 2>/dev/null || true
  unset _KANBAN_WORKFLOW_LOADED 2>/dev/null || true
  unset _KANBAN_GUARD_LOADED 2>/dev/null || true
  unset _KANBAN_EVALUATOR_LOADED 2>/dev/null || true
  unset _KANBAN_WORKTREE_LOADED 2>/dev/null || true
  unset _KANBAN_SELF_IMPROVE_LOADED 2>/dev/null || true
}

teardown() {
  cd /
  rm -rf "$TEST_DIR"
  SKILL_DIR="$_REAL_SKILL_DIR"
}

# Issue #1: sed -i '' replaced by jq
test_issue1_sed_replaced_by_jq() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env

  # kanban_init should not contain sed -i ''
  if grep -q "sed -i ''" .claude/skills/kanban/lib/kanban.sh; then
    echo "FAIL: Issue #1 - sed -i '' still present in kanban.sh"
    return 1
  fi

  # config.json should have correct project name
  kanban_init
  local project=$(jq -r '.project' .kanban/config.json)
  local trunk=$(jq -r '.trunk' .kanban/config.json)

  if [ "$project" = "" ] || [ "$project" = "null" ]; then
    echo "FAIL: Issue #1 - project is empty in config.json"
    return 1
  fi

  if [ "$trunk" = "" ] || [ "$trunk" = "null" ]; then
    echo "FAIL: Issue #1 - trunk is empty in config.json"
    return 1
  fi

  echo "PASS: Issue #1 - jq replaces sed, config.json has project=$project trunk=$trunk"
  teardown
}

# Issue #2: Dashboard path comment corrected
test_issue2_dashboard_path_comment() {
  local server_js="$SCRIPT_DIR/../dashboard/server.js"
  if ! grep -q "部署" "$server_js" && ! grep -q "deploy" "$server_js"; then
    echo "FAIL: Issue #2 - Dashboard path comment not updated"
    return 1
  fi

  # Old misleading comment should be gone
  if grep -q '// .kanban/$' "$server_js"; then
    echo "FAIL: Issue #2 - Old misleading comment still present"
    return 1
  fi

  echo "PASS: Issue #2 - Dashboard path comment corrected"
}

# Issue #3: index.json updated immediately after create_task
test_issue3_index_immediate_update() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  kanban_create_task "Test task" "Description"

  local task_count=$(jq '.tasks | length' .kanban/index.json)
  if [ "$task_count" -lt 1 ]; then
    echo "FAIL: Issue #3 - index.json tasks array is empty after create_task"
    return 1
  fi

  local first_id=$(jq -r '.tasks[0].id' .kanban/index.json)
  if [ "$first_id" = "null" ] || [ "$first_id" = "" ]; then
    echo "FAIL: Issue #3 - index.json first task has no id"
    return 1
  fi

  echo "PASS: Issue #3 - index.json has $task_count task(s) immediately after create"
  teardown
}

# Issue #4: Install copies versions/ and plugin.json
test_issue4_install_copies_files() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  if [ ! -f ".kanban/versions/CHANGELOG.md" ]; then
    echo "FAIL: Issue #4 - versions/CHANGELOG.md not created by install"
    return 1
  fi

  if [ ! -f ".claude-plugin/plugin.json" ]; then
    echo "FAIL: Issue #4 - plugin.json not copied by install"
    return 1
  fi

  echo "PASS: Issue #4 - versions/CHANGELOG.md and plugin.json installed"
  teardown
}

# Issue #5: GETTING_STARTED.md template exists
test_issue5_getting_started_template() {
  if [ ! -f "$SKILL_DIR/templates/GETTING_STARTED.md" ]; then
    echo "FAIL: Issue #5 - GETTING_STARTED.md template not found"
    return 1
  fi

  # Check content has key sections
  local content=$(cat "$SKILL_DIR/templates/GETTING_STARTED.md")
  if ! echo "$content" | grep -q "Quick Start"; then
    echo "FAIL: Issue #5 - GETTING_STARTED.md missing Quick Start section"
    return 1
  fi

  if ! echo "$content" | grep -q "Agent Roles"; then
    echo "FAIL: Issue #5 - GETTING_STARTED.md missing Agent Roles section"
    return 1
  fi

  echo "PASS: Issue #5 - GETTING_STARTED.md template exists with key sections"
}

# Issue #9: kanban_init fails in non-git directory
test_issue9_init_requires_git() {
  # Use a subshell to avoid polluting the current environment
  (
    local tmpdir
    tmpdir=$(mktemp -d)
    cd "$tmpdir"

    # Reset module load guards
    unset _KANBAN_CORE_LOADED 2>/dev/null || true
    unset _KANBAN_WORKFLOW_LOADED 2>/dev/null || true
    unset _KANBAN_GUARD_LOADED 2>/dev/null || true
    unset _KANBAN_EVALUATOR_LOADED 2>/dev/null || true
    unset _KANBAN_WORKTREE_LOADED 2>/dev/null || true
    unset _KANBAN_SELF_IMPROVE_LOADED 2>/dev/null || true

    # Copy lib to a temp location for sourcing
    mkdir -p "$tmpdir/.claude/skills/kanban/lib"
    cp "$_REAL_SKILL_DIR"/lib/*.sh "$tmpdir/.claude/skills/kanban/lib/"
    mkdir -p "$tmpdir/.claude/skills/kanban/templates"
    cp "$_REAL_SKILL_DIR"/templates/*.json "$tmpdir/.claude/skills/kanban/templates/" 2>/dev/null || true
    cp "$_REAL_SKILL_DIR"/templates/GETTING_STARTED.md "$tmpdir/.claude/skills/kanban/templates/" 2>/dev/null || true

    source "$tmpdir/.claude/skills/kanban/lib/kanban.sh"
    kanban_init_env 2>/dev/null || true

    local output
    output=$(kanban_init 2>&1)
    local rc=$?

    rm -rf "$tmpdir"

    if [ "$rc" -ne 0 ]; then
      if echo "$output" | grep -q "ERROR"; then
        echo "PASS: Issue #9 - kanban_init fails with ERROR in non-git directory"
        exit 0
      else
        echo "FAIL: Issue #9 - kanban_init failed but without ERROR message: $output"
        exit 1
      fi
    else
      echo "FAIL: Issue #9 - kanban_init should fail in non-git directory but succeeded"
      exit 1
    fi
  )
}

# Issue #8: empty repo trunk is not "HEAD"
test_issue8_empty_repo_trunk() {
  (
    local tmpdir
    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    git init -q

    # Reset module load guards
    unset _KANBAN_CORE_LOADED 2>/dev/null || true
    unset _KANBAN_WORKFLOW_LOADED 2>/dev/null || true
    unset _KANBAN_GUARD_LOADED 2>/dev/null || true
    unset _KANBAN_EVALUATOR_LOADED 2>/dev/null || true
    unset _KANBAN_WORKTREE_LOADED 2>/dev/null || true
    unset _KANBAN_SELF_IMPROVE_LOADED 2>/dev/null || true

    # Copy lib and templates
    mkdir -p "$tmpdir/.claude/skills/kanban/lib"
    cp "$_REAL_SKILL_DIR"/lib/*.sh "$tmpdir/.claude/skills/kanban/lib/"
    mkdir -p "$tmpdir/.claude/skills/kanban/templates"
    cp "$_REAL_SKILL_DIR"/templates/*.json "$tmpdir/.claude/skills/kanban/templates/" 2>/dev/null || true
    cp "$_REAL_SKILL_DIR"/templates/GETTING_STARTED.md "$tmpdir/.claude/skills/kanban/templates/" 2>/dev/null || true
    mkdir -p "$tmpdir/.claude/skills/kanban/agents"
    cp "$_REAL_SKILL_DIR"/agents/*.md "$tmpdir/.claude/skills/kanban/agents/" 2>/dev/null || true
    mkdir -p "$tmpdir/.claude/skills/kanban/rules"
    cp "$_REAL_SKILL_DIR"/rules/*.md "$tmpdir/.claude/skills/kanban/rules/" 2>/dev/null || true
    mkdir -p "$tmpdir/.claude/skills/kanban/dashboard"
    cp "$_REAL_SKILL_DIR"/dashboard/server.js "$tmpdir/.claude/skills/kanban/dashboard/" 2>/dev/null || true
    mkdir -p "$tmpdir/.claude-plugin"
    echo '{"name":"kanban","version":"0.4.0"}' > "$tmpdir/.claude-plugin/plugin.json"

    source "$tmpdir/.claude/skills/kanban/lib/kanban.sh"
    kanban_init_env 2>/dev/null || true

    kanban_init > /dev/null 2>&1

    local trunk
    trunk=$(jq -r '.trunk' .kanban/config.json)

    rm -rf "$tmpdir"

    if [ "$trunk" = "HEAD" ]; then
      echo "FAIL: Issue #8 - trunk is 'HEAD' in empty repo, expected actual branch name"
      exit 1
    fi

    if [ -z "$trunk" ] || [ "$trunk" = "null" ]; then
      echo "FAIL: Issue #8 - trunk is empty/null in empty repo"
      exit 1
    fi

    echo "PASS: Issue #8 - trunk is '$trunk' in empty repo (not 'HEAD')"
    exit 0
  )
}

# Issue #7: new directory layout task queries work correctly
test_issue7_glob_new_layout() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env
  kanban_init

  # Create a task using the new layout
  kanban_create_task "New layout test" "Testing new directory layout"

  # Verify task directory exists in new format
  local task_dirs=$(ls -d .kanban/tasks/TASK-*/ 2>/dev/null | wc -l | tr -d ' ')
  if [ "$task_dirs" -lt 1 ]; then
    echo "FAIL: Issue #7 - no task directories found in new layout"
    teardown
    return 1
  fi

  # Verify task.json exists inside the directory
  local has_task_json=false
  for d in .kanban/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    if [ -f "$d/task.json" ]; then
      has_task_json=true
      break
    fi
  done

  if [ "$has_task_json" = "false" ]; then
    echo "FAIL: Issue #7 - task.json not found inside task directory"
    teardown
    return 1
  fi

  # Verify kanban_status works with new layout
  local status_output
  status_output=$(kanban_status 2>&1)
  if ! echo "$status_output" | grep -q "New layout test"; then
    echo "FAIL: Issue #7 - kanban_status cannot find task in new layout"
    teardown
    return 1
  fi

  # Verify _next_task_id works with new layout
  local next_id
  next_id=$(_next_task_id)
  if ! echo "$next_id" | grep -qE '^TASK-[0-9]+$'; then
    echo "FAIL: Issue #7 - _next_task_id failed with new layout: $next_id"
    teardown
    return 1
  fi

  echo "PASS: Issue #7 - new directory layout task queries work correctly"
  teardown
}

# Issue #6: self_improve.sh functions can be correctly sourced
test_issue6_self_improve_sourceable() {
  setup
  source .claude/skills/kanban/lib/kanban.sh
  kanban_init_env

  # Verify self_improve.sh was loaded
  if ! type skills_evolve_extract >/dev/null 2>&1; then
    echo "FAIL: Issue #6 - skills_evolve_extract not available after sourcing"
    teardown
    return 1
  fi

  if ! type skills_evolve_apply >/dev/null 2>&1; then
    echo "FAIL: Issue #6 - skills_evolve_apply not available after sourcing"
    teardown
    return 1
  fi

  if ! type _skills_classify_line >/dev/null 2>&1; then
    echo "FAIL: Issue #6 - _skills_classify_line not available after sourcing"
    teardown
    return 1
  fi

  # Verify classification works
  local class
  class=$(_skills_classify_line "The planner agent needs better prompts to describe the kanban workflow")
  if [ "$class" != "agent_improvement" ]; then
    echo "FAIL: Issue #6 - _skills_classify_line returned '$class', expected 'agent_improvement'"
    teardown
    return 1
  fi

  echo "PASS: Issue #6 - self_improve.sh functions can be correctly sourced"
  teardown
}

# Run all tests
main() {
  local passed=0 failed=0
  echo "=== GitHub Issues Regression Tests ==="
  echo ""

  for test_fn in test_issue1_sed_replaced_by_jq test_issue2_dashboard_path_comment \
    test_issue3_index_immediate_update test_issue4_install_copies_files \
    test_issue5_getting_started_template \
    test_issue6_self_improve_sourceable \
    test_issue7_glob_new_layout \
    test_issue8_empty_repo_trunk \
    test_issue9_init_requires_git; do
    if $test_fn; then
      passed=$((passed + 1))
    else
      failed=$((failed + 1))
    fi
  done

  echo ""
  echo "=== Results: $passed passed, $failed failed ==="
  [ "$failed" -eq 0 ]
}

main "$@"
