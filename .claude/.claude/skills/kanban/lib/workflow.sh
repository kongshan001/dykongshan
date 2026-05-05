#!/usr/bin/env bash
# workflow.sh — FSM 状态机
# 依赖: guard.sh, kanban.sh

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# 加载配置
workflow_load_config() {
  if [ -f "$KANBAN_DIR/workflow.json" ]; then
    MAX_ITERATIONS=$(jq -r '.self_improve.max_iterations // 6' "$KANBAN_DIR/workflow.json")
    PASS_THRESHOLD=$(jq -r '.phases[2].pass_threshold // 9.0' "$KANBAN_DIR/workflow.json")
  fi
  if [ -f "$KANBAN_DIR/config.json" ]; then
    TIMEOUT_PLAN=$(jq -r '.timeout.plan_seconds // 300' "$KANBAN_DIR/config.json")
    TIMEOUT_EXECUTE=$(jq -r '.timeout.execute_seconds // 600' "$KANBAN_DIR/config.json")
    TIMEOUT_EVALUATE=$(jq -r '.timeout.evaluate_seconds // 300' "$KANBAN_DIR/config.json")
  fi
}

# 原子写入辅助: jq 处理后安全覆盖原文件
_atomic_jq_write() {
  local task_file="$1"
  shift
  local tmp=$(mktemp)
  jq "$@" "$task_file" > "$tmp" && mv "$tmp" "$task_file"
}

# 阶段名别名规范化 (Issue #27)
# 将用户常见的阶段名别名映射为标准阶段 ID
# 支持: planning->plan, executing->execute, evaluating->evaluate,
#       retrospecting->retrospective, archived/archiving->archive
_normalize_phase_name() {
  local phase="$1"
  case "$phase" in
    planning)           echo "plan" ;;
    executing)          echo "execute" ;;
    evaluating)         echo "evaluate" ;;
    retrospecting)      echo "retrospective" ;;
    archived|archiving) echo "archive" ;;
    *)                  echo "$phase" ;;
  esac
}

# 阶段转换 (核心函数)
workflow_transition() {
  local task_id="$1"
  local to_phase="$2"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  # 规范化阶段名别名 (Issue #27)
  local original_input="$to_phase"
  to_phase=$(_normalize_phase_name "$to_phase")

  # 验证阶段名是合法 ID
  case "$to_phase" in
    plan|execute|evaluate|retrospective|user_decision|archive) ;;
    *)
      echo "ERROR: unknown phase name '$original_input'. Valid phases: plan|execute|evaluate|retrospective|user_decision|archive"
      return 1
      ;;
  esac

  local from_phase=$(jq -r '.phase_lock // ""' "$tf")

  # Guard 检查
  local result=$(guard_check "$task_id" "$from_phase" "$to_phase")
  if [ "$result" != "PASS" ]; then
    echo "GUARD BLOCKED: $result"
    return 1
  fi

  # 更新 task JSON
  local task_status="$to_phase"
  [ "$to_phase" = "plan" ] && task_status="planning"
  [ "$to_phase" = "execute" ] && task_status="executing"
  [ "$to_phase" = "evaluate" ] && task_status="evaluating"
  [ "$to_phase" = "retrospective" ] && task_status="retrospecting"

  local now=$(date -u +%FT%TZ)

  # 首次进入 plan 时递增 iteration (0 -> 1)
  local jq_extra=""
  local cur_iter=$(jq -r '.iteration' "$tf")
  if [ "$to_phase" = "plan" ] && [ "$cur_iter" = "0" ]; then
    jq_extra='.iteration=1 | '
  fi

  # Issue #28 fix: 确保当前 iteration 目录存在
  # 多个阶段 (plan/execute/evaluate/retrospective) 都可能写入 iteration 目录
  # 在 Guard 检查通过后、更新 task JSON 前创建目录
  local tdir=$(task_dir "$task_id")
  local iter=$(jq -r '.iteration // 1' "$tf")
  if [ "$to_phase" = "plan" ] && [ "$cur_iter" = "0" ]; then
    iter=1
  fi
  mkdir -p "$tdir/iteration-${iter}"

  _atomic_jq_write "$tf" \
    --arg phase "$to_phase" \
    --arg lock "$to_phase" \
    --arg status "$task_status" \
    --arg now "$now" \
    "${jq_extra}.phase=\$phase | .phase_lock=\$lock | .status=\$status | .entered_at=\$now |
     .history += [{\"phase\":\$phase, \"status\":\"entered\", \"entered_at\":\$now}]"

  _update_index
  echo "Transitioned: $from_phase -> $to_phase"
  return 0
}

# 完成当前阶段 (标记 completed, 记录退出时间)
workflow_complete_phase() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local now=$(date -u +%FT%TZ)

  local hist_len=$(jq '.history | length' "$tf")
  local last_idx=$((hist_len - 1))
  _atomic_jq_write "$tf" \
    --arg now "$now" --argjson idx "$last_idx" \
    '.history[$idx].status="completed" | .history[$idx].exited_at=$now'

  # Plan 完成时初始化子任务状态追踪
  local completed_phase=$(jq -r ".history[$last_idx].phase" "$tf")
  if [ "$completed_phase" = "plan" ]; then
    # 更新 task_breakdown.file 指向当前 iteration 的 task_breakdown.json
    local iter=$(jq -r '.iteration // 1' "$tf")
    local rdir=$(report_dir "$task_id" "$iter")
    local tdir="$KANBAN_DIR/tasks/$task_id"
    local breakdown_file="$tdir/task_breakdown.json"
    [ ! -f "$breakdown_file" ] && breakdown_file="$rdir/task_breakdown.json"
    if [ -f "$breakdown_file" ]; then
      _atomic_jq_write "$tf" --arg bf "$breakdown_file" \
        '.task_breakdown.file = $bf'
      kanban_init_subtasks "$task_id"
    fi

    # ST-014: Plan 质量门禁检查
    local quality_gate_enabled=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.enabled // false' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "false")
    if [ "$quality_gate_enabled" = "true" ]; then
      # guard_check_plan_quality writes JSON to $rdir/.plan_quality.json
      guard_check_plan_quality "$task_id" "$rdir" 2>/dev/null
      local quality_exit=$?
      local quality_json_file="$rdir/.plan_quality.json"

      if [ $quality_exit -ne 0 ] || [ ! -f "$quality_json_file" ]; then
        # 质量不达标 -- 从 JSON 文件读取结果
        local quality_score=0
        local quality_issues='[]'
        if [ -f "$quality_json_file" ]; then
          quality_score=$(jq -r '.total_score // 0' "$quality_json_file" 2>/dev/null)
          quality_issues=$(jq -c '.issues // []' "$quality_json_file" 2>/dev/null)
        fi

        # 获取当前已尝试的轮次
        local plan_retries=$(jq -r '.plan_quality.retries // 0' "$tf")

        # 获取最大重试轮次
        local max_rounds=$(jq -r '.phases[] | select(.id=="plan") | .quality_gate.max_rounds // 3' "$KANBAN_DIR/workflow.json" 2>/dev/null || echo "3")

        _atomic_jq_write "$tf" \
          --argjson score "$quality_score" \
          --argjson issues "$quality_issues" \
          --argjson retries "$((plan_retries + 1))" \
          --argjson max_rounds "$max_rounds" \
          '.plan_quality = {last_score: $score, issues: $issues, retries: $retries, max_rounds: $max_rounds} | .plan_quality_passed = false'

        if [ "$((plan_retries + 1))" -ge "$max_rounds" ]; then
          # 超过最大重试轮次 -- 暂停并进入 user_decision
          echo "PLAN_QUALITY_FAIL: score=$quality_score, max_rounds=$max_rounds reached"
          echo "Suggestion: enter user_decision for manual resolution"
        else
          # 未超限 -- 记录日志，返回1让调用方决定是否重试
          echo "PLAN_QUALITY_FAIL: score=$quality_score (round $((plan_retries + 1))/$max_rounds)"
        fi
      else
        # 质量通过 -- 从 JSON 文件读取结果
        local quality_score=$(jq -r '.total_score // 0' "$quality_json_file" 2>/dev/null)
        _atomic_jq_write "$tf" --argjson score "$quality_score" \
          '.plan_quality = {last_score: $score, retries: (.plan_quality.retries // 0), pass: true} | .plan_quality_passed = true'
        echo "PLAN_QUALITY_PASS: score=$quality_score"
      fi
    fi
  fi

  # 清理 iteration_type: 进入 user_decision 或 archive 时重置
  if [ "$completed_phase" = "user_decision" ] || [ "$completed_phase" = "retrospective" ]; then
    _atomic_jq_write "$tf" '.iteration_type = null'
  fi
}

# 检查 retrospective 阶段是否存在于 workflow.json
workflow_has_retrospective() {
  if [ -f "$KANBAN_DIR/workflow.json" ]; then
    local phase_ids=$(jq -r '.phases[].id' "$KANBAN_DIR/workflow.json")
    echo "$phase_ids" | grep -qx "retrospective"
    return $?
  fi
  return 1
}

# 获取 evaluate 完成后的下一阶段 (自动处理 retrospective 或 user_decision)
workflow_next_after_evaluate() {
  local task_id="$1"
  if workflow_has_retrospective; then
    echo "retrospective"
  else
    echo "user_decision"
  fi
}

# 获取 retrospective 完成后的下一阶段
workflow_next_after_retrospective() {
  echo "user_decision"
}

# 自迭代判断
workflow_self_improve_check() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  local iteration=$(jq -r '.iteration' "$tf")
  workflow_load_config

  # Resolve required roles (dynamic or fallback to hardcoded defaults)
  local _required_roles
  if has_agents_config "evaluate"; then
    _required_roles=$(get_required_roles "evaluate")
  else
    _required_roles="code_reviewer qa pm designer"
  fi

  # 检查是否全部通过
  local all_pass=true
  for role in $(echo $_required_roles); do
    local score=$(jq -r ".scores.${role}.score // 0" "$tf")
    if [ "$(echo "$score < $PASS_THRESHOLD" | bc 2>/dev/null || echo 1)" = "1" ]; then
      all_pass=false
      break
    fi
  done

  if [ "$all_pass" = "true" ]; then
    echo "all_pass"
    return 0
  fi

  # 检查是否达到最大轮次
  if [ "$iteration" -ge "$MAX_ITERATIONS" ]; then
    echo "max_reached"
    return 0
  fi

  # 判断热迭代 vs 全量迭代
  local has_arch_issues=false
  local arch=$(jq -r '.scores.code_reviewer.report_architecture_issues // ""' "$tf")
  [ -n "$arch" ] && [ "$arch" != "null" ] && [ "$arch" != "[]" ] && has_arch_issues=true

  # 检查最低分 (reuse _required_roles resolved above)
  local min_score=10
  for role in $(echo $_required_roles); do
    local s=$(jq -r ".scores.${role}.score // 0" "$tf")
    [ "$(echo "$s < $min_score" | bc 2>/dev/null || echo 0)" = "1" ] && min_score=$s
  done

  # 热迭代条件: 最低分 >= 7.0 且无架构问题 且 Plan 产物仍有效
  if [ "$has_arch_issues" = "false" ] && [ "$(echo "$min_score >= 7.0" | bc 2>/dev/null || echo 0)" = "1" ]; then
    local iter=$iteration
    local plan_dir=$(report_dir "$task_id" "$iter")
    local tdir="$KANBAN_DIR/tasks/$task_id"
    local req_found=false breakdown_found=false
    [ -f "${tdir}/requirements.md" ] || [ -f "${plan_dir}/requirements.md" ] && req_found=true
    [ -f "${tdir}/task_breakdown.json" ] || [ -f "${plan_dir}/task_breakdown.json" ] && breakdown_found=true
    if [ "$req_found" = "true" ] && [ "$breakdown_found" = "true" ]; then
      echo "hot"
      return 0
    fi
  fi

  echo "full"
  return 0
}

# 执行迭代
workflow_start_iteration() {
  local task_id="$1"
  local type="$2"  # hot 或 full
  local tf=$(task_file "$task_id")

  local iteration=$(jq -r '.iteration' "$tf")
  local new_iter=$((iteration + 1))
  local now=$(date -u +%FT%TZ)

  _atomic_jq_write "$tf" \
    --argjson iter "$new_iter" --arg now "$now" --arg type "$type" \
    '.iteration=$iter | .updated_at=$now | .iteration_type=$type | .history += [{"phase":"self_improve", "iteration":$iter, "type":$type, "entered_at":$now}]'

  # 创建新一轮的 report 目录 (使用新的内聚目录结构)
  local tdir=$(task_dir "$task_id")
  mkdir -p "$tdir/iteration-${new_iter}"

  # 根据类型设置下一个阶段
  local next_phase="plan"
  if [ "$type" = "hot" ]; then
    next_phase="execute"

    # Hot iteration worktree 校验
    local validate_result
    validate_result=$(worktree_validate "$task_id" 2>/dev/null)
    local validate_exit=$?

    if [ $validate_exit -eq 0 ]; then
      # worktree 有效，跳过创建
      echo "Worktree validated OK for hot iteration"
    else
      local wt_path=$(jq -r '.worktree.path // ""' "$tf")
      local wt_branch=$(jq -r '.worktree.branch // ""' "$tf")

      if [ -n "$wt_path" ] || [ -n "$wt_branch" ]; then
        # path 或 branch 有记录但 worktree 无效，尝试重建
        echo "WARNING: worktree invalid, attempting rebuild..."
        if [ -n "$wt_branch" ]; then
          worktree_create "$task_id" "$wt_branch"
          if [ $? -eq 0 ]; then
            echo "Worktree rebuilt successfully for hot iteration"
          else
            echo "ERROR: worktree rebuild failed. Consider using full iteration instead."
            return 1
          fi
        else
          echo "ERROR: cannot rebuild worktree: branch not recorded. Consider using full iteration."
          return 1
        fi
      else
        echo "ERROR: no worktree path or branch recorded. Cannot proceed with hot iteration."
        echo "Suggestion: use full iteration (from plan) instead."
        return 1
      fi
    fi
  fi

  echo "Starting iteration $new_iter ($type) -> $next_phase"
}

# ST-014: 检查 Plan 质量是否需要重试
# 返回: "pass" / "retry" / "max_reached"
# 用法: workflow_check_plan_retry task_id
workflow_check_plan_retry() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  local plan_pass=$(jq -r '.plan_quality.pass // null' "$tf")
  if [ "$plan_pass" = "true" ]; then
    echo "pass"
    return 0
  fi

  local retries=$(jq -r '.plan_quality.retries // 0' "$tf")
  local max_rounds=$(jq -r '.plan_quality.max_rounds // 3' "$tf")

  if [ "$retries" -ge "$max_rounds" ]; then
    echo "max_reached"
    return 0
  fi

  echo "retry"
  return 0
}

# === 内部函数 ===
# _update_index 已在 kanban.sh 中定义，此处不再重复定义
# (Bug #1 fix: 删除了覆盖 kanban.sh 完整实现的空壳函数)
