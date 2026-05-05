#!/usr/bin/env bash
# test_dashboard_retrospective.sh — Tests for retrospective API endpoints
# Validates the server.js retrospective API endpoints
# Run from the worktree root directory

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKTREE_DIR="$(cd "$(dirname "$SCRIPT_DIR")/../../.." && pwd)"
KANBAN_DIR="$WORKTREE_DIR/.kanban"
SERVER_JS="$(dirname "$SCRIPT_DIR")/dashboard/server.js"

pass=0
fail=0
total=0

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  total=$((total + 1))
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected='$expected', actual='$actual')"
    fail=$((fail + 1))
  fi
}

assert_contains() {
  local desc="$1" needle="$2" haystack="$3"
  total=$((total + 1))
  if echo "$haystack" | grep -q "$needle"; then
    echo "  PASS: $desc"
    pass=$((pass + 1))
  else
    echo "  FAIL: $desc (expected to contain '$needle' in output)"
    fail=$((fail + 1))
  fi
}

echo "=== Dashboard Retrospective API Tests ==="
echo ""

# ---- Test Group 1: Server.js contains retrospective endpoints ----
echo "--- Server.js endpoint existence ---"

server_content=$(cat "$SERVER_JS")

assert_contains "archived-tasks/:id/retrospective endpoint" "archived-tasks/:id/retrospective" "$server_content"
assert_contains "tasks/:id/retrospective endpoint" "tasks/:id/retrospective" "$server_content"
assert_contains "retrospective.md file lookup" "retrospective.md" "$server_content"
assert_contains "latest iteration selection" "latestIter" "$server_content"

# ---- Test Group 2: api.js has getRetrospective method ----
echo "--- api.js retrospective method ---"

api_js="$(dirname "$SCRIPT_DIR")/dashboard/js/utils/api.js"
api_content=$(cat "$api_js")

assert_contains "getRetrospective method" "getRetrospective" "$api_content"
assert_contains "archived parameter" "archived ? 'archived-tasks' : 'tasks'" "$api_content"

# ---- Test Group 3: useTaskDetail.js has retrospectiveContent ref ----
echo "--- useTaskDetail.js retrospective support ---"

detail_js="$(dirname "$SCRIPT_DIR")/dashboard/js/composables/useTaskDetail.js"
detail_content=$(cat "$detail_js")

assert_contains "retrospectiveContent ref" "retrospectiveContent" "$detail_content"
assert_contains "fetch retrospective" "getRetrospective" "$detail_content"
assert_contains "return retrospectiveContent" "retrospectiveContent" "$detail_content"

# ---- Test Group 4: KanbanBoard.js uses retrospectiveContent ---"
echo "--- KanbanBoard.js retrospective integration ---"

board_js="$(dirname "$SCRIPT_DIR")/dashboard/js/components/KanbanBoard.js"
board_content=$(cat "$board_js")

assert_contains "retrospectiveContent in return" "retrospectiveContent" "$board_content"
assert_contains "renderRetrospective in return" "renderRetrospective" "$board_content"
assert_contains "retrospective section in template" "retrospectiveContent" "$board_content"
assert_contains "escapeNewlines helper" "escapeNewlines" "$board_content"

# ---- Test Group 5: CSS has modal and retrospective styles ----
echo "--- CSS modal and retrospective styles ---"

css_file="$(dirname "$SCRIPT_DIR")/dashboard/css/style.css"
css_content=$(cat "$css_file")

assert_contains "task-detail-backdrop" "task-detail-backdrop" "$css_content"
assert_contains "task-detail-modal" "task-detail-modal" "$css_content"
assert_contains "retrospective-content" "retrospective-content" "$css_content"
assert_contains "no old task-detail-overlay" "task-detail-modal" "$css_content"

echo ""
echo "=== Results ==="
echo "Total: $total, Passed: $pass, Failed: $fail"
if [ "$fail" -eq 0 ]; then
  echo "ALL TESTS PASSED"
  exit 0
else
  echo "SOME TESTS FAILED"
  exit 1
fi
