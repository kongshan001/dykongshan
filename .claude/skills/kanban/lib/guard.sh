#!/usr/bin/env bash
# guard.sh — 三层流程约束检查 (Bash 3.2 兼容, 不使用 declare -A)
# 依赖: jq

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# === 层1: Phase Gate — 合法阶段转换表 (case 语句替代 declare -A) ===
guard_check_transition() {
  local from="$1" to="$2"

  # 向后兼容: 检查 retrospective 阶段是否存在于 workflow.json
  local has_retrospective=false
  if [ -f "$KANBAN_DIR/workflow.json" ]; then
    local phase_ids=$(jq -r '.phases[].id' "$KANBAN_DIR/workflow.json" 2>/dev/null)
    echo "$phase_ids" | grep -qx -- "retrospective" && has_retrospective=true
  fi

  case "$from" in
    plan)         [ "$to" = "execute" ] && return 0 ;;
    execute)      [ "$to" = "evaluate" ] && return 0 ;;
    evaluate)
      # Fix 4: evaluate can go to plan/execute (self-iteration) or retrospective/user_decision
      # but NOT directly to archive -- that would bypass user_decision (IR-11)
      case "$to" in
        plan|execute) return 0 ;;
        retrospective) [ "$has_retrospective" = "true" ] && return 0 ;;
        user_decision) [ "$has_retrospective" = "false" ] && return 0 ;;
      esac
      ;;
    retrospective)
      # retrospective 只能转到 user_decision
      case "$to" in
        user_decision) return 0 ;;
        plan|execute) return 0 ;;  # 允许从 retrospective 回退到迭代
      esac
      ;;
    user_decision) case "$to" in archive|plan|execute) return 0 ;; esac ;;
    "")           [ "$to" = "plan" ] && return 0 ;;  # 初始状态
  esac
  return 1
}

# === 层2: Artifact Guard — 必需产物检查 ===
guard_check_artifacts() {
  local task_id="$1" phase="$2"
  local tf=$(task_file "$task_id")
  local iter=$(jq -r '.iteration // 1' "$tf")
  local rdir=$(report_dir "$task_id" "$iter")
  local missing=""

  local tdir="$KANBAN_DIR/tasks/$task_id"

  case "$phase" in
    plan)
      # 任务级文档: 同时检查任务根目录和 iteration 子目录（向后兼容）
      if [ ! -f "${tdir}/requirements.md" ] && [ ! -f "${rdir}/requirements.md" ]; then
        missing="${missing} requirements.md"
      fi
      if [ ! -f "${tdir}/task_breakdown.json" ] && [ ! -f "${rdir}/task_breakdown.json" ]; then
        missing="${missing} task_breakdown.json"
      fi
      ;;
    execute)
      [ ! -f "${rdir}/execution_summary.md" ] && missing="${missing} execution_summary.md"
      [ ! -f "${rdir}/execution_pitfalls.md" ] && missing="${missing} execution_pitfalls.md"
      [ ! -f "${rdir}/execution_decisions.md" ] && missing="${missing} execution_decisions.md"
      ;;
    evaluate)
      for role in code_reviewer qa pm designer; do
        [ ! -f "${rdir}/${role}_report.json" ] && missing="${missing} ${role}_report.json"
      done
      ;;
    retrospective)
      # 任务级文档: 同时检查任务根目录和 iteration 子目录（向后兼容）
      if [ ! -f "${tdir}/retrospective.md" ] && [ ! -f "${rdir}/retrospective.md" ]; then
        missing="${missing} retrospective.md"
      fi
      ;;
  esac

  echo "$missing" | xargs
}

# === 层3: Score Validator -- 评估报告完整性检查 ===
guard_check_evaluation() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local iter=$(jq -r '.iteration // 1' "$tf")
  local rdir=$(report_dir "$task_id" "$iter")

  for role in code_reviewer qa pm designer; do
    local report="${rdir}/${role}_report.json"
    [ ! -f "$report" ] && echo "missing_report:${role}" && return 1

    # 评分必须存在
    local score=$(jq -r '.score // -1' "$report")
    [ "$score" = "null" ] || [ "$score" = "-1" ] && { echo "no_score:${role}"; return 1; }

    # 通用字段: improvements + risks
    local imp_len=$(jq '.improvements | length' "$report")
    local risk_len=$(jq '.risks | length' "$report")
    [ "$imp_len" = "0" ] 2>/dev/null && { echo "no_improvements:${role}"; return 1; }
    [ "$risk_len" = "0" ] 2>/dev/null && { echo "no_risks:${role}"; return 1; }

    # 角色特有字段
    case "$role" in
      code_reviewer)
        jq -e '.architecture_issues' "$report" >/dev/null 2>&1 || { echo "missing_role_field:architecture_issues:${role}"; return 1; }
        jq -e '.code_style_violations' "$report" >/dev/null 2>&1 || { echo "missing_role_field:code_style_violations:${role}"; return 1; }
        ;;
      qa)
        jq -e '.missing_tests' "$report" >/dev/null 2>&1 || { echo "missing_role_field:missing_tests:${role}"; return 1; }
        jq -e '.test_coverage' "$report" >/dev/null 2>&1 || { echo "missing_role_field:test_coverage:${role}"; return 1; }
        ;;
      pm)
        jq -e '.extended_requirements' "$report" >/dev/null 2>&1 || { echo "missing_role_field:extended_requirements:${role}"; return 1; }
        jq -e '.requirement_coverage' "$report" >/dev/null 2>&1 || { echo "missing_role_field:requirement_coverage:${role}"; return 1; }
        ;;
      designer)
        jq -e '.visual_score' "$report" >/dev/null 2>&1 || { echo "missing_role_field:visual_score:${role}"; return 1; }
        jq -e '.interaction_score' "$report" >/dev/null 2>&1 || { echo "missing_role_field:interaction_score:${role}"; return 1; }
        ;;
    esac
  done
  echo "PASS"
  return 0
}

# === 主入口: guard_check ===
# 输出: PASS 或 FAIL:<reason>:<detail>
# 返回: 0=通过, 1=不通过
guard_check() {
  local task_id="$1" from="$2" to="$3"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "FAIL:task_not_found:${task_id}"; return 1; }

  # 1. 阶段顺序合法性
  if ! guard_check_transition "$from" "$to"; then
    echo "FAIL:invalid_transition:${from}->${to}"
    return 1
  fi

  # 2. phase_lock 一致性 (from 为空时跳过，用于初始进入 plan)
  if [ -n "$from" ]; then
    local lock=$(jq -r '.phase_lock // ""' "$tf")
    if [ "$lock" != "$from" ]; then
      echo "FAIL:phase_lock_mismatch:expected=${lock},got=${from}"
      return 1
    fi
  fi

  # 3. 必需产物检查 (from 为空时跳过，首次进入 plan 无前序产物)
  if [ -n "$from" ]; then
    local missing=$(guard_check_artifacts "$task_id" "$from")
    if [ -n "$missing" ]; then
      echo "FAIL:missing_artifacts:${missing}"
      return 1
    fi
  fi

  # 4. 评估阶段特殊检查
  if [ "$from" = "evaluate" ]; then
    local eval_result=$(guard_check_evaluation "$task_id")
    if [ "$eval_result" != "PASS" ]; then
      echo "FAIL:evaluation:${eval_result}"
      return 1
    fi
  fi

  # 5. worktree 存在性检查: 进入 execute 阶段时必须存在 worktree
  if [ "$to" = "execute" ]; then
    local wt_path=$(jq -r '.worktree.path // ""' "$tf")
    if [ -z "$wt_path" ] || [ ! -d "$wt_path" ]; then
      echo "FAIL:worktree_not_found:${wt_path:-empty}"
      return 1
    fi
    # 验证是有效 git worktree
    if ! git -C "$wt_path" rev-parse --git-dir >/dev/null 2>&1; then
      echo "FAIL:worktree_invalid:${wt_path}"
      return 1
    fi
  fi

  # 6. Inbox 待处理检查 (仅当目标阶段为 archive)
  if [ "$to" = "archive" ]; then
    local inbox_result
    inbox_result=$(guard_check_inbox "$task_id")
    if [ "$inbox_result" != "PASS" ]; then
      echo "FAIL:inbox_pending:$(echo "$inbox_result" | sed 's/FAIL:inbox_pending://')"
      return 1
    fi
  fi

  echo "PASS"
  return 0
}

# === ST-013: Plan 质量门禁 ===
# guard_check_plan_quality(task_id, report_dir)
# 对 Plan 产物进行结构性质量评分
# 评分维度 (每项 0-10 分):
#   1. requirement_clarity: requirements.md 是否包含功能需求/非功能需求/验收标准
#   2. technical_feasibility: 技术约束和 estimated_files 是否具体
#   3. task_decomposition: subtask 数量/字段/依赖关系合理性
#   4. acceptance_criteria: 验收标准是否可验证
# 输出: JSON 格式 {pass:bool, total_score:float, dimensions:{...}, issues:[]}
# 返回: 0=pass, 1=fail
guard_check_plan_quality() {
  local task_id="$1"
  local rdir="$2"

  # 如果未传入 report_dir，自动计算
  if [ -z "$rdir" ]; then
    local tf_path=$(task_file "$task_id")
    local iter=$(jq -r '.iteration // 1' "$tf_path")
    rdir=$(report_dir "$task_id" "$iter")
  fi

  # 任务级文档: 优先检查任务根目录，回退到 iteration 子目录（向后兼容）
  local tdir="$KANBAN_DIR/tasks/$task_id"
  local req_file="$tdir/requirements.md"
  local breakdown_file="$tdir/task_breakdown.json"
  [ ! -f "$req_file" ] && req_file="$rdir/requirements.md"
  [ ! -f "$breakdown_file" ] && breakdown_file="$rdir/task_breakdown.json"
  local issues="[]"

  # === 维度1: 需求清晰度 ===
  local req_score=0
  if [ -f "$req_file" ]; then
    # 检查功能需求标题
    if grep -qi -- "功能需求\|functional" "$req_file" 2>/dev/null; then
      req_score=$((req_score + 3))
    else
      issues=$(echo "$issues" | jq '. + ["requirements:missing_functional_requirements"]')
    fi
    # 检查非功能需求标题
    if grep -qi -- "非功能需求\|non-functional\|NFR" "$req_file" 2>/dev/null; then
      req_score=$((req_score + 3))
    else
      issues=$(echo "$issues" | jq '. + ["requirements:missing_non_functional_requirements"]')
    fi
    # 检查验收标准标题
    if grep -qi -- "验收标准\|acceptance" "$req_file" 2>/dev/null; then
      req_score=$((req_score + 4))
    else
      issues=$(echo "$issues" | jq '. + ["requirements:missing_acceptance_criteria"]')
    fi
  else
    issues=$(echo "$issues" | jq '. + ["requirements:file_not_found"]')
  fi

  # === 维度2: 技术可行性 ===
  local tech_score=0
  if [ -f "$breakdown_file" ]; then
    # 检查技术约束
    if [ -f "$req_file" ] && grep -qi -- "技术约束\|technical.constraint\|TC-" "$req_file" 2>/dev/null; then
      tech_score=$((tech_score + 5))
    else
      issues=$(echo "$issues" | jq '. + ["technical:missing_constraints"]')
    fi
    # 检查 subtask 的 estimated_files 是否具体
    local files_with_est=$(jq '[.subtasks[] | select(.estimated_files | length > 0)] | length' "$breakdown_file" 2>/dev/null || echo 0)
    local total_subtasks=$(jq '.subtasks | length' "$breakdown_file" 2>/dev/null || echo 0)
    if [ "$total_subtasks" -gt 0 ] && [ "$files_with_est" -ge "$total_subtasks" ]; then
      tech_score=$((tech_score + 5))
    elif [ "$files_with_est" -gt 0 ]; then
      tech_score=$((tech_score + 2))
      issues=$(echo "$issues" | jq '. + ["technical:some_subtasks_missing_estimated_files"]')
    else
      issues=$(echo "$issues" | jq '. + ["technical:no_estimated_files"]')
    fi
  else
    issues=$(echo "$issues" | jq '. + ["technical:breakdown_not_found"]')
  fi

  # === 维度3: 任务拆解合理性 ===
  local decomp_score=0
  if [ -f "$breakdown_file" ]; then
    local subtask_count=$(jq '.subtasks | length' "$breakdown_file" 2>/dev/null || echo 0)
    if [ "$subtask_count" -ge 1 ]; then
      decomp_score=$((decomp_score + 3))
    else
      issues=$(echo "$issues" | jq '. + ["decomposition:no_subtasks"]')
    fi
    # 检查每个 subtask 有必要字段
    local subtasks_with_fields=$(jq '[.subtasks[] | select(.id != null and .title != null and .description != null)] | length' "$breakdown_file" 2>/dev/null || echo 0)
    if [ "$subtask_count" -gt 0 ] && [ "$subtasks_with_fields" -eq "$subtask_count" ]; then
      decomp_score=$((decomp_score + 4))
    else
      decomp_score=$((decomp_score + 1))
      issues=$(echo "$issues" | jq '. + ["decomposition:subtasks_missing_required_fields"]')
    fi
    # 检查依赖无环 (简单检查: 无循环自引用)
    local self_deps=$(jq '[.subtasks[] | select(.dependencies // [] | contains([.id]))] | length' "$breakdown_file" 2>/dev/null || echo 0)
    if [ "$self_deps" -eq 0 ]; then
      decomp_score=$((decomp_score + 3))
    else
      issues=$(echo "$issues" | jq '. + ["decomposition:circular_self_dependency"]')
    fi
  fi

  # === 维度4: 验收标准完整性 ===
  local ac_score=0
  if [ -f "$req_file" ]; then
    # 统计验收标准条目数 (以 AC- 或 ### AC 开头的行)
    local ac_count=$(grep -c -- "^- AC-\|^### AC-\|^AC-\|^- \*\*AC-" "$req_file" 2>/dev/null || true)
    if [ "$ac_count" -ge 3 ]; then
      ac_score=10
    elif [ "$ac_count" -ge 1 ]; then
      ac_score=6
    else
      # 回退: 检查 "验收标准" 标题下是否有内容
      local ac_section_lines=$(sed -n '/^## 验收标准/,/^## /{ /^## /!p; }' "$req_file" 2>/dev/null | grep -c "." || true)
      if [ "$ac_section_lines" -ge 3 ]; then
        ac_score=7
      else
        ac_score=2
        issues=$(echo "$issues" | jq '. + ["acceptance:insufficient_criteria"]')
      fi
    fi
  fi

  # === 计算总分 (Fix 2: 使用 workflow.json 中的加权评分) ===
  local total_score
  if [ -f "$KANBAN_DIR/workflow.json" ]; then
    # 读取各维度权重
    local w_req=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.dimensions[] | select(.id=="requirement_clarity") | .weight // 0.25' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "0.25")
    local w_tech=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.dimensions[] | select(.id=="technical_feasibility") | .weight // 0.25' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "0.25")
    local w_decomp=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.dimensions[] | select(.id=="task_decomposition") | .weight // 0.25' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "0.25")
    local w_ac=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.dimensions[] | select(.id=="acceptance_criteria") | .weight // 0.25' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "0.25")
    total_score=$(echo "scale=2; ($req_score * $w_req) + ($tech_score * $w_tech) + ($decomp_score * $w_decomp) + ($ac_score * $w_ac)" | bc 2>/dev/null || echo "0")
  else
    # Fallback: simple average when no workflow.json
    total_score=$(echo "scale=2; ($req_score + $tech_score + $decomp_score + $ac_score) / 4" | bc 2>/dev/null || echo "0")
  fi

  # 获取 pass_threshold
  local threshold=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.pass_threshold // 9.0' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "9.0")
  local is_pass="true"
  if [ "$(echo "$total_score < $threshold" | bc 2>/dev/null || echo 1)" = "1" ]; then
    is_pass="false"
  fi

  # Fix 3: Write JSON result to file instead of stdout for clean function contract
  # stdout outputs human-readable summary only
  local json_file="$rdir/.plan_quality.json"
  jq -n \
    --argjson pass "$is_pass" \
    --argjson total "$total_score" \
    --argjson req_s "$req_score" \
    --argjson tech_s "$tech_score" \
    --argjson decomp_s "$decomp_score" \
    --argjson ac_s "$ac_score" \
    --argjson issues "$issues" \
    --arg threshold "$threshold" \
    '{
      pass: $pass,
      total_score: $total,
      threshold: ($threshold | tonumber),
      dimensions: {
        requirement_clarity: $req_s,
        technical_feasibility: $tech_s,
        task_decomposition: $decomp_s,
        acceptance_criteria: $ac_s
      },
      issues: $issues
    }' > "$json_file"

  # Human-readable summary to stdout
  echo "Plan quality: score=${total_score}, threshold=${threshold}, pass=${is_pass}"

  if [ "$is_pass" = "true" ]; then
    return 0
  else
    return 1
  fi
}

# === ST-001: Inbox 待处理检查 (归档前置条件) ===
# guard_check_inbox(task_id)
# 检查 inbox.md 的 "## 待处理" section 下是否有未归档的反馈条目
# 输出: PASS 或 FAIL:inbox_pending:N (N=待处理条目数)
# 返回: 0=无待处理/不存在, 1=有待处理条目
guard_check_inbox() {
  local task_id="$1"

  # 获取 inbox 文件路径 (兼容新旧目录结构)
  local inbox
  if type inbox_file >/dev/null 2>&1; then
    inbox=$(inbox_file "$task_id")
  else
    # Fallback: 尝试新格式和旧格式
    if [ -f "$KANBAN_DIR/tasks/${task_id}/inbox.md" ]; then
      inbox="$KANBAN_DIR/tasks/${task_id}/inbox.md"
    elif [ -f "$KANBAN_DIR/archive/${task_id}/inbox.md" ]; then
      inbox="$KANBAN_DIR/archive/${task_id}/inbox.md"
    else
      echo "PASS"
      return 0
    fi
  fi

  # inbox 不存在 -> 通过 (容错默认允许)
  if [ ! -f "$inbox" ]; then
    echo "PASS"
    return 0
  fi

  # 提取 "## 待处理" section 下的非空、非注释行数
  # sed: 从 "## 待处理" 开始到下一个 "## " 结束
  # grep -v: 排除空行和注释行(>开头)
  # 支持 "- [ ]"、"1."、"1、""* "等任何格式的待处理条目
  local pending_count
  pending_count=$(sed -n '/^## 待处理/,/^## /{ /^## /!p; }' "$inbox" | grep -v '^[[:space:]]*$' | grep -v '^>' | grep -c '.' || true)

  if [ "$pending_count" -gt 0 ]; then
    echo "FAIL:inbox_pending:${pending_count}"
    return 1
  fi

  echo "PASS"
  return 0
}
