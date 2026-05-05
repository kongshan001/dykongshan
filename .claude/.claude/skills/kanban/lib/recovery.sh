#!/usr/bin/env bash
# recovery.sh — 崩溃恢复 + 超时检测
# 依赖: jq

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# 恢复任务 (从 history 中找到最后一个 completed 阶段)
recover_task() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local task_status=$(jq -r '.status' "$tf")
  local phase_lock=$(jq -r '.phase_lock // ""' "$tf")

  echo "=== Recovery: $task_id ==="
  echo "Current status: $task_status, phase: $phase_lock"

  # 找到最后一个 completed 的 history entry
  local last_completed=$(jq -r '[.history[] | select(.status=="completed")] | last.phase // "plan"' "$tf")

  echo "Last completed phase: $last_completed"
  echo "Recovery plan: restart from $last_completed"

  # 恢复到 execute 阶段时验证 worktree
  if [ "$last_completed" = "execute" ]; then
    if type worktree_validate >/dev/null 2>&1; then
      local validate_result
      validate_result=$(worktree_validate "$task_id" 2>/dev/null)
      local validate_exit=$?

      if [ $validate_exit -ne 0 ]; then
        echo ""
        echo "WARNING: worktree validation failed for $task_id"
        echo "$validate_result" | jq '.' 2>/dev/null || echo "$validate_result"
        echo ""
        echo "Options:"
        echo "  1. Rebuild worktree: /kanban run $task_id --phase execute (will attempt rebuild)"
        echo "  2. Skip to evaluate: manually set phase to 'evaluate'"
        echo "  3. Full restart: /kanban run $task_id --phase plan"
        echo ""
        echo "Recovery proceeding with worktree issue noted."
      else
        echo "Worktree validated OK"
      fi
    fi
  fi

  # 设置恢复状态
  local now=$(date -u +%FT%TZ)
  local recovery_status="planning"
  [ "$last_completed" = "execute" ] && recovery_status="executing"
  [ "$last_completed" = "evaluate" ] && recovery_status="evaluating"

  local tmp=$(mktemp)
  jq --arg phase "$last_completed" \
     --arg lock "$last_completed" \
     --arg status "$recovery_status" \
     --arg now "$now" \
     '.phase=$phase | .phase_lock=$lock | .status=$status | .entered_at=$now |
      .history += [{"phase":"recovery", "status":"entered", "recovered_to":$phase, "entered_at":$now}]' \
    "$tf" > "$tmp" \
    && mv "$tmp" "$tf"

  echo "Recovered $task_id -> $last_completed"
}

# 超时检测 (事后检测)
recover_check_timeout() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && return 0

  local phase=$(jq -r '.phase_lock // ""' "$tf")
  local entered=$(jq -r '.entered_at // ""' "$tf")

  [ -z "$entered" ] || [ "$entered" = "null" ] && return 0

  local limit=$(jq -r ".timeout.${phase}_seconds // 300" "$KANBAN_DIR/config.json")
  local now=$(date -u +%s)

  # 解析 ISO 时间戳 (macOS 兼容)
  local entered_ts=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$entered" +%s 2>/dev/null || echo "$now")
  local elapsed=$(( now - entered_ts ))

  if [ "$elapsed" -gt "$limit" ]; then
    local now_iso=$(date -u +%FT%TZ)
    local tmp=$(mktemp)
    jq --arg now "$now_iso" --argjson elapsed "$elapsed" --argjson limit "$limit" \
      '.status="timeout" | .timeout_at=$now | .timeout_elapsed=$elapsed | .timeout_limit=$limit' \
      "$tf" > "$tmp" \
      && mv "$tmp" "$tf"
    echo "TIMEOUT: $task_id ($elapsed > $limit seconds in $phase)"
    return 1
  fi
  return 0
}

# 列出所有可能中断的任务
recover_list_interrupted() {
  echo "=== Potentially Interrupted Tasks ==="
  # 新格式: tasks/TASK-NNN/task.json
  for task_dir_entry in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$task_dir_entry" ] || continue
    local tf="$task_dir_entry/task.json"
    [ -f "$tf" ] || continue
    local id=$(jq -r '.id' "$tf")
    local task_status=$(jq -r '.status' "$tf")
    case "$task_status" in
      executing|evaluating|planning)
        echo "  $id ($task_status)"
        recover_check_timeout "$id"
        ;;
    esac
  done
  # 旧格式兼容
  for task_file_entry in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$task_file_entry" ] || continue
    local id=$(jq -r '.id' "$task_file_entry")
    local task_status=$(jq -r '.status' "$task_file_entry")
    case "$task_status" in
      executing|evaluating|planning)
        echo "  $id ($task_status)"
        recover_check_timeout "$id"
        ;;
    esac
  done
}
