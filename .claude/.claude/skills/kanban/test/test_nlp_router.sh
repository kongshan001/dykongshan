#!/usr/bin/env bash
# test_nlp_router.sh -- Unit tests for NLP router (nlp_router.sh)
# Covers: kanban_nl_extract_task_id, kanban_nl_classify_intent,
#         kanban_nl_parse, edge cases, and backward compatibility.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIB_DIR="$SKILL_DIR/lib"

# ============================================================
# Test framework
# ============================================================
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  ok - $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - $label"
    echo "    expected: $expected"
    echo "    actual:   $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -qF -- "$needle"; then
    echo "  ok - $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - $label"
    echo "    string: $haystack"
    echo "    not found: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -qF -- "$needle"; then
    echo "  not ok - $label"
    echo "    string: $haystack"
    echo "    unexpectedly found: $needle"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  else
    echo "  ok - $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_json_eq() {
  local label="$1" json_string="$2" jq_path="$3" expected="$4"
  local actual
  actual=$(echo "$json_string" | jq -r "$jq_path" 2>/dev/null)
  if [ "$actual" = "$expected" ]; then
    echo "  ok - $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - $label"
    echo "    path: $jq_path"
    echo "    expected: $expected"
    echo "    actual:   $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

assert_json_true() {
  local label="$1" json_string="$2" jq_path="$3"
  local actual
  actual=$(echo "$json_string" | jq -r "$jq_path" 2>/dev/null)
  if [ "$actual" = "true" ]; then
    echo "  ok - $label"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - $label"
    echo "    path: $jq_path"
    echo "    expected: true"
    echo "    actual:   $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

# ============================================================
# Source the NLP router library
# ============================================================
source_nlp_lib() {
  # Reset loaded flags so we can re-source cleanly
  _KANBAN_NLP_ROUTER_LOADED=""
  _KANBAN_NLP_PATTERNS_CACHE=""
  source "$LIB_DIR/nlp_router.sh"
}

source_nlp_lib

# ============================================================
# 1. kanban_nl_extract_task_id tests (8+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 1. kanban_nl_extract_task_id tests"
echo "# ============================================================"

test_extract_standard_task_id() {
  echo "## test_extract_standard_task_id"
  local result
  result=$(kanban_nl_extract_task_id "帮我归档TASK-001")
  assert_eq "standard TASK-001 format" "TASK-001" "$result"
}

test_extract_multi_digit_task_id() {
  echo "## test_extract_multi_digit_task_id"
  local result
  result=$(kanban_nl_extract_task_id "看看TASK-026的详情")
  assert_eq "multi-digit TASK-026" "TASK-026" "$result"
}

test_extract_numeric_chinese() {
  echo "## test_extract_numeric_chinese"
  local result
  result=$(kanban_nl_extract_task_id "任务1")
  assert_eq "pure numeric after 任务 -> TASK-001" "TASK-001" "$result"
}

test_extract_ordinal_arabic() {
  echo "## test_extract_ordinal_arabic"
  local result
  result=$(kanban_nl_extract_task_id "第3个任务")
  assert_eq "ordinal 第3个 -> TASK-003" "TASK-003" "$result"
}

test_extract_chinese_number() {
  echo "## test_extract_chinese_number"
  local result
  result=$(kanban_nl_extract_task_id "任务二十六")
  assert_eq "Chinese number 二十六 -> TASK-026" "TASK-026" "$result"
}

test_extract_no_task_id() {
  echo "## test_extract_no_task_id"
  local result
  result=$(kanban_nl_extract_task_id "看看状态")
  assert_eq "no task_id returns empty" "" "$result"
}

test_extract_multiple_takes_first() {
  echo "## test_extract_multiple_takes_first"
  local result
  result=$(kanban_nl_extract_task_id "把TASK-001合并到TASK-002")
  assert_eq "multiple IDs returns first" "TASK-001" "$result"
}

test_extract_ordinal_first() {
  echo "## test_extract_ordinal_first"
  local result
  result=$(kanban_nl_extract_task_id "第一个任务")
  assert_eq "ordinal 第一个 -> TASK-001" "TASK-001" "$result"
}

test_extract_single_chinese_number() {
  echo "## test_extract_single_chinese_number"
  local result
  result=$(kanban_nl_extract_task_id "任务三")
  assert_eq "Chinese number 三 -> TASK-003" "TASK-003" "$result"
}

# ============================================================
# 2. kanban_nl_classify_intent tests (22+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 2. kanban_nl_classify_intent tests"
echo "# ============================================================"

# --- init ---
test_classify_init_zh() {
  echo "## test_classify_init_zh"
  local result
  result=$(kanban_nl_classify_intent "帮我初始化")
  assert_json_eq "init from 帮我初始化" "$result" ".command" "init"
  assert_json_eq "init confidence > 0" "$result" ".confidence" "0.8"
}

test_classify_init_en() {
  echo "## test_classify_init_en"
  local result
  result=$(kanban_nl_classify_intent "setup kanban")
  assert_json_eq "init from setup kanban" "$result" ".command" "init"
  assert_json_eq "init confidence > 0" "$result" ".confidence" "0.8"
}

# --- create ---
test_classify_create_zh() {
  echo "## test_classify_create_zh"
  local result
  result=$(kanban_nl_classify_intent "新建一个任务")
  assert_json_eq "create from 新建一个任务" "$result" ".command" "create"
  assert_json_eq "create from synonyms" "$result" ".match_type" "synonym"
}

test_classify_create_alt() {
  echo "## test_classify_create_alt"
  local result
  result=$(kanban_nl_classify_intent "创建任务")
  assert_json_eq "create from 创建任务" "$result" ".command" "create"
}

# --- status ---
test_classify_status_zh() {
  echo "## test_classify_status_zh"
  local result
  result=$(kanban_nl_classify_intent "查看状态")
  assert_json_eq "status from 查看状态 (exact match)" "$result" ".command" "status"
  assert_json_eq "status exact confidence" "$result" ".confidence" "1"
}

test_classify_status_en() {
  echo "## test_classify_status_en"
  local result
  result=$(kanban_nl_classify_intent "kanban status")
  assert_json_eq "status from kanban status" "$result" ".command" "status"
}

# --- show ---
test_classify_show_zh() {
  echo "## test_classify_show_zh"
  local result
  result=$(kanban_nl_classify_intent "任务详情")
  assert_json_eq "show from 任务详情" "$result" ".command" "show"
}

test_classify_show_alt() {
  echo "## test_classify_show_alt"
  local result
  result=$(kanban_nl_classify_intent "查看任务信息")
  assert_json_eq "show from 查看任务信息" "$result" ".command" "show"
}

# --- run ---
test_classify_run_zh() {
  echo "## test_classify_run_zh"
  local result
  result=$(kanban_nl_classify_intent "跑一下任务")
  assert_json_eq "run from 跑一下任务" "$result" ".command" "run"
}

test_classify_run_with_task() {
  echo "## test_classify_run_with_task"
  local result
  result=$(kanban_nl_classify_intent "执行任务")
  assert_json_eq "run from 执行任务" "$result" ".command" "run"
}

# --- decide ---
test_classify_decide_archive() {
  echo "## test_classify_decide_archive"
  local result
  result=$(kanban_nl_classify_intent "归档任务")
  assert_json_eq "decide from 归档任务" "$result" ".command" "decide"
  assert_json_eq "decide action is approve_and_archive" "$result" ".args.action" "approve_and_archive"
}

test_classify_decide_approve() {
  echo "## test_classify_decide_approve"
  local result
  result=$(kanban_nl_classify_intent "批准并归档")
  assert_json_eq "decide from 批准并归档" "$result" ".command" "decide"
  assert_json_eq "decide action approve_and_archive" "$result" ".args.action" "approve_and_archive"
}

# --- score ---
test_classify_score_zh() {
  echo "## test_classify_score_zh"
  local result
  result=$(kanban_nl_classify_intent "看评分")
  assert_json_eq "score from 看评分" "$result" ".command" "score"
}

test_classify_score_alt() {
  echo "## test_classify_score_alt"
  local result
  result=$(kanban_nl_classify_intent "分数多少")
  assert_json_eq "score from 分数多少" "$result" ".command" "score"
}

# --- summary ---
test_classify_summary_zh() {
  echo "## test_classify_summary_zh"
  local result
  result=$(kanban_nl_classify_intent "摘要")
  assert_json_eq "summary from 摘要" "$result" ".command" "summary"
}

test_classify_summary_alt() {
  echo "## test_classify_summary_alt"
  local result
  result=$(kanban_nl_classify_intent "迭代总结")
  assert_json_eq "summary from 迭代总结" "$result" ".command" "summary"
}

# --- recover ---
test_classify_recover_zh() {
  echo "## test_classify_recover_zh"
  local result
  result=$(kanban_nl_classify_intent "恢复")
  assert_json_eq "recover from 恢复" "$result" ".command" "recover"
}

test_classify_recover_alt() {
  echo "## test_classify_recover_alt"
  local result
  result=$(kanban_nl_classify_intent "resume")
  assert_json_eq "recover from resume" "$result" ".command" "recover"
}

# --- dashboard ---
test_classify_dashboard_zh() {
  echo "## test_classify_dashboard_zh"
  local result
  result=$(kanban_nl_classify_intent "打开仪表盘")
  assert_json_eq "dashboard from 打开仪表盘" "$result" ".command" "dashboard"
  assert_json_eq "dashboard subcommand start" "$result" ".args.subcommand" "start"
}

test_classify_dashboard_en() {
  echo "## test_classify_dashboard_en"
  local result
  result=$(kanban_nl_classify_intent "dashboard")
  assert_json_eq "dashboard from dashboard" "$result" ".command" "dashboard"
}

# --- version ---
test_classify_version_zh() {
  echo "## test_classify_version_zh"
  local result
  result=$(kanban_nl_classify_intent "版本")
  assert_json_eq "version from 版本" "$result" ".command" "version"
}

test_classify_version_en() {
  echo "## test_classify_version_en"
  local result
  result=$(kanban_nl_classify_intent "version list")
  assert_json_eq "version from version list" "$result" ".command" "version"
}

# ============================================================
# 3. kanban_nl_parse end-to-end tests (10+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 3. kanban_nl_parse end-to-end tests"
echo "# ============================================================"

test_parse_archive_task() {
  echo "## test_parse_archive_task"
  local result
  result=$(kanban_nl_parse "帮我归档TASK-001")
  assert_json_eq "command is decide" "$result" ".command" "decide --action approve_and_archive"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_eq "action is approve_and_archive" "$result" ".action" "approve_and_archive"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_status() {
  echo "## test_parse_status"
  local result
  result=$(kanban_nl_parse "看板状态怎么样")
  assert_json_eq "command is status" "$result" ".command" "status"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_restart_plan() {
  echo "## test_parse_restart_plan"
  local result
  result=$(kanban_nl_parse "重新规划TASK-003")
  assert_json_eq "command includes decide" "$result" ".command" "decide --action restart_from_plan"
  assert_json_eq "task_id is TASK-003" "$result" ".task_id" "TASK-003"
  assert_json_eq "action is restart_from_plan" "$result" ".action" "restart_from_plan"
}

test_parse_create_title() {
  echo "## test_parse_create_title"
  local result
  result=$(kanban_nl_parse "创建任务叫用户登录")
  assert_json_eq "command is create" "$result" ".command" "create"
  assert_json_eq "title extracted" "$result" ".args.title" "叫用户登录"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_create_title_quoted_double() {
  echo "## test_parse_create_title_quoted_double"
  local result
  result=$(kanban_nl_parse '创建任务叫"用户登录"')
  assert_json_eq "command is create" "$result" ".command" "create"
  assert_json_eq "title extracted from double quotes" "$result" ".args.title" "用户登录"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_create_title_quoted_single() {
  echo "## test_parse_create_title_quoted_single"
  local result
  result=$(kanban_nl_parse "创建任务叫'数据导入'")
  assert_json_eq "command is create" "$result" ".command" "create"
  assert_json_eq "title extracted from single quotes" "$result" ".args.title" "数据导入"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_create_title_chinese_bracket() {
  echo "## test_parse_create_title_chinese_bracket"
  local result
  result=$(kanban_nl_parse '创建任务叫「文件上传」')
  assert_json_eq "command is create" "$result" ".command" "create"
  assert_json_eq "title extracted from Chinese brackets" "$result" ".args.title" "文件上传"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_create_title_explicit_marker() {
  echo "## test_parse_create_title_explicit_marker"
  local result
  result=$(kanban_nl_parse '创建一个任务叫做邮件通知')
  assert_json_eq "command is create" "$result" ".command" "create"
  assert_json_eq "title extracted via 叫做 marker" "$result" ".args.title" "邮件通知"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_create_title_named() {
  echo "## test_parse_create_title_named"
  local result
  result=$(kanban_nl_parse '新建任务名为报表导出')
  assert_json_eq "command is create" "$result" ".command" "create"
  assert_json_eq "title extracted via 名为 marker" "$result" ".args.title" "报表导出"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_run_task() {
  echo "## test_parse_run_task"
  local result
  result=$(kanban_nl_parse "跑一下TASK-001")
  assert_json_eq "command is run" "$result" ".command" "run"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_dashboard_start() {
  echo "## test_parse_dashboard_start"
  local result
  result=$(kanban_nl_parse "打开Dashboard")
  assert_json_eq "command is dashboard start" "$result" ".command" "dashboard start"
  assert_json_eq "subcommand is start" "$result" ".args.subcommand" "start"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_version_list() {
  echo "## test_parse_version_list"
  local result
  result=$(kanban_nl_parse "版本历史")
  assert_json_eq "command is version list" "$result" ".command" "version list"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_abort_task() {
  echo "## test_parse_abort_task"
  local result
  result=$(kanban_nl_parse "这个任务不做了")
  assert_json_eq "command includes decide" "$result" ".command" "decide --action abort"
  assert_json_eq "action is abort" "$result" ".action" "abort"
  # When exactly one active task exists, task_id is inferred automatically
  local inferred_task_id
  inferred_task_id=$(kanban_nl_infer_task_id)
  if [ -n "$inferred_task_id" ]; then
    assert_eq "task_id inferred from single active task" "$inferred_task_id" "$(echo "$result" | jq -r '.task_id')"
  else
    assert_json_eq "task_id is null (no explicit ID)" "$result" ".task_id" "null"
  fi
}

test_parse_score_task() {
  echo "## test_parse_score_task"
  local result
  result=$(kanban_nl_parse "查看TASK-005评分")
  assert_json_eq "command is score" "$result" ".command" "score"
  assert_json_eq "task_id is TASK-005" "$result" ".task_id" "TASK-005"
}

test_parse_summary_task() {
  echo "## test_parse_summary_task"
  local result
  result=$(kanban_nl_parse "TASK-010的摘要")
  assert_json_eq "command is summary" "$result" ".command" "summary"
  assert_json_eq "task_id is TASK-010" "$result" ".task_id" "TASK-010"
}

# ============================================================
# 4. Edge case tests (6+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 4. Edge case tests"
echo "# ============================================================"

test_parse_empty_input() {
  echo "## test_parse_empty_input"
  local result
  result=$(kanban_nl_parse "")
  assert_json_eq "success is false for empty input" "$result" ".success" "false"
  assert_json_eq "command is null" "$result" ".command" "null"
}

test_parse_whitespace_input() {
  echo "## test_parse_whitespace_input"
  local result
  result=$(kanban_nl_parse "   ")
  # After normalization, this becomes empty string
  # kanban_nl_parse normalizes but classify_intent gets "   " trimmed
  # Let's check: the normalized result should be a failure
  assert_json_eq "success is false for whitespace" "$result" ".success" "false"
}

test_parse_unrecognized_input() {
  echo "## test_parse_unrecognized_input"
  local result
  result=$(kanban_nl_parse "天气怎么样")
  assert_json_eq "success is false" "$result" ".success" "false"
  # suggestion should be non-null
  local suggestion
  suggestion=$(echo "$result" | jq -r '.suggestion')
  assert_not_contains "suggestion is present (non-empty)" "$suggestion" "null"
}

test_parse_missing_task_id_for_decide() {
  echo "## test_parse_missing_task_id_for_decide"
  local result
  result=$(kanban_nl_parse "帮我归档")
  # When exactly one active task exists, task_id is inferred automatically
  local inferred_task_id
  inferred_task_id=$(kanban_nl_infer_task_id)
  if [ -n "$inferred_task_id" ]; then
    assert_json_true "success is true (task_id inferred)" "$result" ".success"
    assert_json_eq "task_id is inferred" "$result" ".task_id" "$inferred_task_id"
  else
    assert_json_eq "success is false (missing task_id)" "$result" ".success" "false"
    assert_contains "suggestion mentions task ID" "$result" "task ID"
  fi
}

test_parse_mixed_zh_en() {
  echo "## test_parse_mixed_zh_en"
  local result
  result=$(kanban_nl_parse "帮我approve TASK-001")
  # "approve" should trigger decide with approve_and_archive
  # TASK-001 should be extracted
  assert_json_eq "command includes decide" "$result" ".command" "decide --action approve_and_archive"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_extra_whitespace() {
  echo "## test_parse_extra_whitespace"
  local result
  result=$(kanban_nl_parse "  查看状态  ")
  assert_json_eq "command is status with extra whitespace" "$result" ".command" "status"
  assert_json_true "success is true" "$result" ".success"
}

# ============================================================
# 5. Backward compatibility tests (4+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 5. Backward compatibility tests"
echo "# ============================================================"

test_compat_kanban_status() {
  echo "## test_compat_kanban_status"
  local result
  result=$(kanban_nl_parse "/kanban status")
  assert_json_eq "command is status" "$result" ".command" "status"
  assert_json_true "success is true" "$result" ".success"
}

test_compat_kanban_run() {
  echo "## test_compat_kanban_run"
  local result
  result=$(kanban_nl_parse "/kanban run TASK-001")
  assert_json_eq "command is run" "$result" ".command" "run"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_true "success is true" "$result" ".success"
}

test_compat_kanban_decide() {
  echo "## test_compat_kanban_decide"
  local result
  result=$(kanban_nl_parse "/kanban decide TASK-001 --action approve_and_archive")
  assert_json_eq "command includes decide" "$result" ".command" "decide --action approve_and_archive"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_eq "action is approve_and_archive" "$result" ".action" "approve_and_archive"
  assert_json_true "success is true" "$result" ".success"
}

test_compat_kanban_init() {
  echo "## test_compat_kanban_init"
  local result
  result=$(kanban_nl_parse "/kanban init")
  assert_json_eq "command is init" "$result" ".command" "init"
  assert_json_true "success is true" "$result" ".success"
}

# ============================================================
# 6. Traditional Chinese (繁體中文) tests (4+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 6. Traditional Chinese (繁體中文) tests"
echo "# ============================================================"

test_parse_traditional_archive() {
  echo "## test_parse_traditional_archive"
  local result
  result=$(kanban_nl_parse "幫我歸檔TASK-001")
  assert_json_eq "command is decide for traditional archive" "$result" ".command" "decide --action approve_and_archive"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_traditional_status() {
  echo "## test_parse_traditional_status"
  local result
  result=$(kanban_nl_parse "查看狀態")
  assert_json_eq "command is status for traditional 狀態" "$result" ".command" "status"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_traditional_create() {
  echo "## test_parse_traditional_create"
  local result
  result=$(kanban_nl_parse "創建任務")
  assert_json_eq "command is create for traditional 創建任務" "$result" ".command" "create"
  assert_json_true "success is true" "$result" ".success"
}

test_parse_traditional_score() {
  echo "## test_parse_traditional_score"
  local result
  result=$(kanban_nl_parse "查看TASK-002評分")
  assert_json_eq "command is score for traditional 評分" "$result" ".command" "score"
  assert_json_eq "task_id is TASK-002" "$result" ".task_id" "TASK-002"
}

test_parse_traditional_execute() {
  echo "## test_parse_traditional_execute"
  local result
  result=$(kanban_nl_parse "執行任務TASK-003")
  assert_json_eq "command is run for traditional 執行任務" "$result" ".command" "run"
  assert_json_eq "task_id is TASK-003" "$result" ".task_id" "TASK-003"
}

# ============================================================
# 7. Typo tolerance tests (3+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 7. Typo tolerance tests"
echo "# ============================================================"

test_typo_kanbn_status() {
  echo "## test_typo_kanbn_status"
  local result
  result=$(kanban_nl_parse "kanbn status")
  assert_json_eq "command is status despite 'kanbn' typo" "$result" ".command" "status"
  assert_json_true "success is true" "$result" ".success"
}

test_typo_dashbord() {
  echo "## test_typo_dashbord"
  local result
  result=$(kanban_nl_parse "打开dashbord")
  # "打开" triggers dashboard start subcommand
  assert_json_eq "command starts with dashboard despite 'dashbord' typo" "$result" ".command" "dashboard start"
  assert_json_true "success is true" "$result" ".success"
}

test_typo_kaban_init() {
  echo "## test_typo_kaban_init"
  local result
  result=$(kanban_nl_parse "kaban init")
  assert_json_eq "command is init despite 'kaban' typo" "$result" ".command" "init"
  assert_json_true "success is true" "$result" ".success"
}

test_typo_deside() {
  echo "## test_typo_deside"
  local result
  result=$(kanban_nl_parse "deside TASK-001")
  # "deside" corrected to "decide", default action is approve_and_archive
  assert_json_eq "command includes decide despite 'deside' typo" "$result" ".command" "decide --action approve_and_archive"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
}

# ============================================================
# 8. Module loading integration tests (3+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 8. Module loading integration tests"
echo "# ============================================================"

test_functions_exist() {
  echo "## test_functions_exist"
  local all_exist=true
  for func in kanban_nl_parse kanban_nl_extract_task_id kanban_nl_classify_intent kanban_nl_build_command kanban_nl_load_patterns kanban_nl_apply_typos kanban_nl_apply_traditional_chinese kanban_nl_infer_task_id; do
    if ! type "$func" >/dev/null 2>&1; then
      echo "  not ok - function $func is missing"
      all_exist=false
      TESTS_FAILED=$((TESTS_FAILED + 1))
      TESTS_RUN=$((TESTS_RUN + 1))
    else
      echo "  ok - function $func exists"
      TESTS_PASSED=$((TESTS_PASSED + 1))
      TESTS_RUN=$((TESTS_RUN + 1))
    fi
  done
}

test_patterns_loadable() {
  echo "## test_patterns_loadable"
  local patterns
  patterns=$(kanban_nl_load_patterns)
  local cmd_count
  cmd_count=$(echo "$patterns" | jq '.commands | keys | length' 2>/dev/null)
  if [ "$cmd_count" -ge 11 ]; then
    echo "  ok - patterns loaded with $cmd_count commands"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - expected >= 11 commands, got $cmd_count"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

test_cache_mechanism() {
  echo "## test_cache_mechanism"
  # Test cache behavior: loading patterns multiple times returns identical content.
  # The cache variable (_KANBAN_NLP_PATTERNS_CACHE) is set inside subshells via $(),
  # so we verify correctness by confirming consistent output rather than inspecting
  # the variable directly from the parent process.
  local first
  first=$(kanban_nl_load_patterns)

  # Second load should return identical content (consistency check)
  local second
  second=$(kanban_nl_load_patterns)
  if [ "$first" = "$second" ]; then
    echo "  ok - patterns content is consistent across loads"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - patterns content differs between loads"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))

  # Verify the loaded content is valid JSON with expected structure
  local has_commands
  has_commands=$(echo "$first" | jq -r '.commands | keys | length' 2>/dev/null)
  if [ "$has_commands" -ge 11 ]; then
    echo "  ok - loaded patterns contain $has_commands commands"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  not ok - expected >= 11 commands, got $has_commands"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  TESTS_RUN=$((TESTS_RUN + 1))
}

test_traditional_chinese_helper() {
  echo "## test_traditional_chinese_helper"
  local result
  result=$(kanban_nl_apply_traditional_chinese "歸檔任務")
  assert_contains "traditional 歸檔 converted to 归档" "$result" "归档任务"
}

test_typo_helper() {
  echo "## test_typo_helper"
  local result
  result=$(kanban_nl_apply_typos "kanbn status")
  assert_contains "kanbn corrected to kanban" "$result" "kanban"
}

test_infer_task_id_empty() {
  echo "## test_infer_task_id_empty"
  # When no .kanban/index.json exists in current dir, should return empty
  local result
  result=$(kanban_nl_infer_task_id "/nonexistent/path")
  assert_eq "infer returns empty for nonexistent dir" "" "$result"
}

test_infer_task_id_single() {
  echo "## test_infer_task_id_single"
  # Create a temp kanban dir with exactly one task
  local tmpdir
  tmpdir=$(mktemp -d)
  mkdir -p "$tmpdir"
  jq -n '{project:"test", trunk:"main", tasks:[{id:"TASK-005",status:"pending",phase:null,iteration:0}]}' > "$tmpdir/index.json"
  local result
  result=$(kanban_nl_infer_task_id "$tmpdir")
  assert_eq "infer returns TASK-005 for single active task" "TASK-005" "$result"
  rm -rf "$tmpdir"
}

test_infer_task_id_multiple() {
  echo "## test_infer_task_id_multiple"
  # Create a temp kanban dir with multiple tasks
  local tmpdir
  tmpdir=$(mktemp -d)
  mkdir -p "$tmpdir"
  jq -n '{project:"test", trunk:"main", tasks:[{id:"TASK-001",status:"pending",phase:null,iteration:0},{id:"TASK-002",status:"pending",phase:null,iteration:0}]}' > "$tmpdir/index.json"
  local result
  result=$(kanban_nl_infer_task_id "$tmpdir")
  assert_eq "infer returns empty for multiple active tasks" "" "$result"
  rm -rf "$tmpdir"
}

# ============================================================
# 9. kanban_nl_build_command isolated tests (4+ cases)
# ============================================================

echo ""
echo "# ============================================================"
echo "# 9. kanban_nl_build_command isolated tests"
echo "# ============================================================"

test_build_command_null_command() {
  echo "## test_build_command_null_command"
  local null_intent='{"command":null,"confidence":0.0,"match_type":"none","args":{}}'
  local result
  result=$(kanban_nl_build_command "$null_intent" "" "天气怎么样")
  assert_json_eq "success is false for null command" "$result" ".success" "false"
  assert_json_eq "command is null" "$result" ".command" "null"
}

test_build_command_missing_task_id() {
  echo "## test_build_command_missing_task_id"
  # Intent for 'decide' but no task_id provided
  local decide_intent='{"command":"decide","confidence":0.8,"match_type":"synonym","args":{"action":"approve_and_archive"}}'
  local result
  result=$(kanban_nl_build_command "$decide_intent" "" "帮我归档")
  assert_json_eq "success is false when task_id required but missing" "$result" ".success" "false"
  assert_contains "suggestion mentions task ID" "$result" "task ID"
}

test_build_command_unknown_command() {
  echo "## test_build_command_unknown_command"
  # An intent with an unrecognized command name
  local unknown_intent='{"command":"foobar","confidence":0.5,"match_type":"fuzzy","args":{}}'
  local result
  result=$(kanban_nl_build_command "$unknown_intent" "" "foobar something")
  # task_id_required for unknown command defaults to false, so it should succeed
  assert_json_eq "command is foobar" "$result" ".command" "foobar"
  assert_json_eq "success is true (unknown command, no task_id required)" "$result" ".success" "true"
}

test_build_command_with_action() {
  echo "## test_build_command_with_action"
  local decide_intent='{"command":"decide","confidence":0.8,"match_type":"synonym","args":{"action":"approve_and_archive"}}'
  local result
  result=$(kanban_nl_build_command "$decide_intent" "TASK-001" "帮我归档TASK-001")
  assert_json_true "success is true" "$result" ".success"
  assert_json_eq "command includes decide and action" "$result" ".command" "decide --action approve_and_archive"
  assert_json_eq "task_id is TASK-001" "$result" ".task_id" "TASK-001"
  assert_json_eq "action is approve_and_archive" "$result" ".action" "approve_and_archive"
}

# ============================================================
# Run all tests
# ============================================================

echo ""
echo "========================================="
echo "Running NLP Router tests"
echo "========================================="
echo ""

# 1. extract_task_id
test_extract_standard_task_id
test_extract_multi_digit_task_id
test_extract_numeric_chinese
test_extract_ordinal_arabic
test_extract_chinese_number
test_extract_no_task_id
test_extract_multiple_takes_first
test_extract_ordinal_first
test_extract_single_chinese_number

# 2. classify_intent
test_classify_init_zh
test_classify_init_en
test_classify_create_zh
test_classify_create_alt
test_classify_status_zh
test_classify_status_en
test_classify_show_zh
test_classify_show_alt
test_classify_run_zh
test_classify_run_with_task
test_classify_decide_archive
test_classify_decide_approve
test_classify_score_zh
test_classify_score_alt
test_classify_summary_zh
test_classify_summary_alt
test_classify_recover_zh
test_classify_recover_alt
test_classify_dashboard_zh
test_classify_dashboard_en
test_classify_version_zh
test_classify_version_en

# 3. kanban_nl_parse end-to-end
test_parse_archive_task
test_parse_status
test_parse_restart_plan
test_parse_create_title
test_parse_create_title_quoted_double
test_parse_create_title_quoted_single
test_parse_create_title_chinese_bracket
test_parse_create_title_explicit_marker
test_parse_create_title_named
test_parse_run_task
test_parse_dashboard_start
test_parse_version_list
test_parse_abort_task
test_parse_score_task
test_parse_summary_task

# 4. Edge cases
test_parse_empty_input
test_parse_whitespace_input
test_parse_unrecognized_input
test_parse_missing_task_id_for_decide
test_parse_mixed_zh_en
test_parse_extra_whitespace

# 5. Backward compatibility
test_compat_kanban_status
test_compat_kanban_run
test_compat_kanban_decide
test_compat_kanban_init

# 6. Traditional Chinese
test_parse_traditional_archive
test_parse_traditional_status
test_parse_traditional_create
test_parse_traditional_score
test_parse_traditional_execute

# 7. Typo tolerance
test_typo_kanbn_status
test_typo_dashbord
test_typo_kaban_init
test_typo_deside

# 8. Module loading integration
test_functions_exist
test_patterns_loadable
test_cache_mechanism
test_traditional_chinese_helper
test_typo_helper
test_infer_task_id_empty
test_infer_task_id_single
test_infer_task_id_multiple

# 9. kanban_nl_build_command isolated
test_build_command_null_command
test_build_command_missing_task_id
test_build_command_unknown_command
test_build_command_with_action

echo ""
echo "========================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_RUN total"
echo "========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
  exit 1
fi
