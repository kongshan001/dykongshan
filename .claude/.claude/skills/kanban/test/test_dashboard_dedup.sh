#!/usr/bin/env bash
# test_dashboard_dedup.sh — ST-045: Dashboard 去重测试
# 验证:
#   1. _DASHBOARD_SRC_DIR 指向 skills 目录 (而非 .kanban/dashboard/)
#   2. _DASHBOARD_RUNTIME_DIR 指向 .kanban/dashboard/ (仅运行时数据)
#   3. _kanban_install_deps 不再复制 dashboard 源文件到 .kanban/dashboard/
#   4. .gitignore 中 .kanban/dashboard/ 条目存在且未被注释

set -e

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$TEST_DIR/.." && pwd)"
LIB_DIR="$SKILL_DIR/lib"

PASS=0
FAIL=0
TOTAL=0

pass() { PASS=$((PASS + 1)); TOTAL=$((TOTAL + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); TOTAL=$((TOTAL + 1)); echo "  FAIL: $1"; }

echo "=========================================="
echo "Test: Dashboard 去重 (ST-045)"
echo "=========================================="
echo ""

# === Test 1: _DASHBOARD_SRC_DIR points to skills directory ===
echo "--- Test 1: _DASHBOARD_SRC_DIR 路径检查 ---"

# Source dashboard.sh to read variable values
KANBAN_DIR=".kanban"
source "$LIB_DIR/dashboard.sh" 2>/dev/null || true

if [ -n "${_DASHBOARD_SRC_DIR:-}" ]; then
  if echo "$_DASHBOARD_SRC_DIR" | grep -q "skills/kanban/dashboard"; then
    pass "_DASHBOARD_SRC_DIR points to skills directory: $_DASHBOARD_SRC_DIR"
  else
    fail "_DASHBOARD_SRC_DIR does not point to skills dir: $_DASHBOARD_SRC_DIR"
  fi
else
  fail "_DASHBOARD_SRC_DIR variable is not defined"
fi

# Test that _DASHBOARD_RUNTIME_DIR is the runtime data directory
if [ -n "${_DASHBOARD_RUNTIME_DIR:-}" ]; then
  if echo "$_DASHBOARD_RUNTIME_DIR" | grep -q ".kanban/dashboard"; then
    pass "_DASHBOARD_RUNTIME_DIR points to runtime data dir: $_DASHBOARD_RUNTIME_DIR"
  else
    fail "_DASHBOARD_RUNTIME_DIR does not point to .kanban/dashboard: $_DASHBOARD_RUNTIME_DIR"
  fi
else
  fail "_DASHBOARD_RUNTIME_DIR variable is not defined"
fi

# Verify SRC_DIR and RUNTIME_DIR are different
if [ "${_DASHBOARD_SRC_DIR:-}" != "${_DASHBOARD_RUNTIME_DIR:-}" ]; then
  pass "_DASHBOARD_SRC_DIR != _DASHBOARD_RUNTIME_DIR (去重生效)"
else
  fail "_DASHBOARD_SRC_DIR == _DASHBOARD_RUNTIME_DIR (源目录与运行时目录相同, 去重未生效)"
fi

# Verify PID and log files go to runtime dir
if [ -n "${_DASHBOARD_PID_FILE:-}" ]; then
  if echo "$_DASHBOARD_PID_FILE" | grep -q ".kanban/dashboard/.dashboard.pid"; then
    pass "PID file in runtime dir: $_DASHBOARD_PID_FILE"
  else
    fail "PID file not in runtime dir: $_DASHBOARD_PID_FILE"
  fi
else
  fail "_DASHBOARD_PID_FILE variable is not defined"
fi

if [ -n "${_DASHBOARD_LOG_FILE:-}" ]; then
  if echo "$_DASHBOARD_LOG_FILE" | grep -q ".kanban/dashboard/.dashboard.log"; then
    pass "Log file in runtime dir: $_DASHBOARD_LOG_FILE"
  else
    fail "Log file not in runtime dir: $_DASHBOARD_LOG_FILE"
  fi
else
  fail "_DASHBOARD_LOG_FILE variable is not defined"
fi

echo ""

# === Test 2: _kanban_install_deps no longer copies dashboard source files ===
echo "--- Test 2: _kanban_install_deps 不复制源文件 ---"

# Check that the install_deps function does NOT contain the old copy pattern
if grep -q 'cp -r.*dashboard/\*.*dashboard/' "$LIB_DIR/kanban.sh" 2>/dev/null; then
  fail "_kanban_install_deps still contains old copy logic (cp -r dashboard/*)"
else
  pass "_kanban_install_deps no longer copies dashboard source files"
fi

# Check that the install_deps function contains mkdir -p for dashboard dir (runtime dir only)
if grep -q 'mkdir -p.*dashboard_dir' "$LIB_DIR/kanban.sh" 2>/dev/null; then
  pass "_kanban_install_deps creates runtime dir with mkdir -p"
else
  fail "_kanban_install_deps does not create dashboard runtime dir"
fi

# Check that the old conditional pattern (checking for server.js before copy) is removed
# Pattern: '-f "$dashboard_dir/server.js"' was the old guard against copying if already present
if grep -q '"$dashboard_dir/server.js"' "$LIB_DIR/kanban.sh" 2>/dev/null; then
  fail "_kanban_install_deps still has old guard condition for server.js copy"
else
  pass "_kanban_install_deps removed old server.js guard condition (no copy logic)"
fi

# Check that old cp command for dashboard is removed
if grep -q 'cp.*dashboard/\*.*dashboard/' "$LIB_DIR/kanban.sh" 2>/dev/null; then
  fail "_kanban_install_deps still has cp dashboard copy command"
else
  pass "_kanban_install_deps removed cp command for dashboard copy"
fi

echo ""

# === Test 3: _dashboard_start uses source dir ===
echo "--- Test 3: _dashboard_start 使用源目录路径 ---"

if grep -q '_DASHBOARD_SRC_DIR/server.js' "$LIB_DIR/dashboard.sh" 2>/dev/null; then
  pass "_dashboard_start checks server.js from _DASHBOARD_SRC_DIR"
else
  fail "_dashboard_start does not check server.js in _DASHBOARD_SRC_DIR"
fi

if grep -q 'nohup node.*_DASHBOARD_SRC_DIR/server.js' "$LIB_DIR/dashboard.sh" 2>/dev/null; then
  pass "_dashboard_start launches node from _DASHBOARD_SRC_DIR"
else
  fail "_dashboard_start does not launch node from _DASHBOARD_SRC_DIR"
fi

if grep -q 'mkdir -p.*_DASHBOARD_RUNTIME_DIR' "$LIB_DIR/dashboard.sh" 2>/dev/null; then
  pass "_dashboard_start creates runtime data dir before launch"
else
  fail "_dashboard_start does not create runtime data dir"
fi

# Verify no reference to old _DASHBOARD_DIR pattern (without SRC or RUNTIME suffix)
# We should still see _DASHBOARD_PID_FILE and _DASHBOARD_LOG_FILE references
# but NOT bare _DASHBOARD_DIR for server.js or node_modules
if grep -n '_DASHBOARD_DIR' "$LIB_DIR/dashboard.sh" 2>/dev/null | grep -v 'SRC\|RUNTIME'; then
  fail "_dashboard_start still uses bare _DASHBOARD_DIR (not _SRC or _RUNTIME)"
elif grep -q 'SRC_DIR\|RUNTIME_DIR' "$LIB_DIR/dashboard.sh" 2>/dev/null; then
  pass "_dashboard_start uses only _DASHBOARD_SRC_DIR and _DASHBOARD_RUNTIME_DIR"
else
  fail "Cannot determine _DASHBOARD_DIR usage"
fi

echo ""

# === Test 4: .gitignore has .kanban/dashboard/ uncommented ===
echo "--- Test 4: .gitignore 检查 ---"

GITIGNORE_FILE="$(cd "$SKILL_DIR/../.." && pwd)/.gitignore"
# Also check project root (worktree root)
PROJECT_ROOT="$(cd "$SKILL_DIR/../../.." && pwd)"
GITIGNORE_ROOT="$PROJECT_ROOT/.gitignore"

# Try both locations
GITIGNORE=""
if [ -f "$GITIGNORE_FILE" ]; then
  GITIGNORE="$GITIGNORE_FILE"
elif [ -f "$GITIGNORE_ROOT" ]; then
  GITIGNORE="$GITIGNORE_ROOT"
fi

if [ -z "$GITIGNORE" ]; then
  fail ".gitignore not found at expected locations"
else
  # Check for .kanban/dashboard/ line that is NOT commented out
  if grep -E '^[[:space:]]*\.kanban/dashboard/' "$GITIGNORE" 2>/dev/null; then
    pass ".gitignore contains active .kanban/dashboard/ entry"
  elif grep -E '^[[:space:]]*#.*\.kanban/dashboard/' "$GITIGNORE" 2>/dev/null; then
    fail ".gitignore has .kanban/dashboard/ but it is COMMENTED OUT"
  else
    fail ".gitignore does not contain .kanban/dashboard/ entry"
  fi

  # Also check .kanban/worktrees/ is active (related to this task)
  if grep -E '^[[:space:]]*\.kanban/worktrees/' "$GITIGNORE" 2>/dev/null; then
    pass ".gitignore also contains active .kanban/worktrees/ entry"
  fi
fi

echo ""

# === Test 5: SKILL.md updated ===
echo "--- Test 5: SKILL.md 描述更新 ---"

SKILLMD="$SKILL_DIR/SKILL.md"
if [ -f "$SKILLMD" ]; then
  # Check that old "dashboard: 使用复制" wording is removed
  if grep -q 'dashboard: 使用复制' "$SKILLMD" 2>/dev/null; then
    fail "SKILL.md still says 'dashboard: 使用复制'"
  else
    pass "SKILL.md no longer describes dashboard copy behavior"
  fi

  # Check that new wording is present
  if grep -q '运行时数据目录' "$SKILLMD" 2>/dev/null; then
    pass "SKILL.md describes dashboard as runtime data directory"
  fi

  # Check dashboard path description is updated
  if grep -q 'skills 源目录' "$SKILLMD" 2>/dev/null; then
    pass "SKILL.md mentions skills source directory for dashboard"
  fi

  # Check that dashboard init section describes mkdir -p without copy
  if grep -q '不再复制源文件' "$SKILLMD" 2>/dev/null; then
    pass "SKILL.md explicitly states source files are no longer copied"
  fi
else
  fail "SKILL.md not found"
fi

echo ""
echo "=========================================="
echo "Results: $PASS passed, $FAIL failed ($TOTAL total)"
echo "=========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
