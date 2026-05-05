#!/usr/bin/env bash
# scheduler.sh — 并行调度器
# 依赖: jq

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# 检查是否存在 pending 或活跃任务
has_pending_or_active_tasks() {
  # 新格式
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    local tf="$d/task.json"
    [ -f "$tf" ] || continue
    local s=$(jq -r '.status' "$tf")
    case "$s" in pending|executing|evaluating|planning) return 0 ;; esac
  done
  # 旧格式兼容
  for f in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$f" ] || continue
    local s=$(jq -r '.status' "$f")
    case "$s" in pending|executing|evaluating|planning) return 0 ;; esac
  done
  return 1
}

# 统计活跃任务数
count_active_tasks() {
  local count=0
  # 新格式
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    local tf="$d/task.json"
    [ -f "$tf" ] || continue
    local s=$(jq -r '.status' "$tf")
    case "$s" in executing|evaluating|planning) count=$((count + 1)) ;; esac
  done
  # 旧格式兼容
  for f in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$f" ] || continue
    local s=$(jq -r '.status' "$f")
    case "$s" in executing|evaluating|planning) count=$((count + 1)) ;; esac
  done
  echo "$count"
}

# 依赖检查
dependencies_met() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local deps=$(jq -r '.depends_on // [] | .[]' "$tf")
  [ -z "$deps" ] && return 0
  for dep in $deps; do
    local dep_tf=$(task_file "$dep")
    # 如果是归档任务，尝试归档路径
    if [ ! -f "$dep_tf" ]; then
      dep_tf=$(archive_task_file "$dep")
    fi
    local dep_status=$(jq -r '.status' "$dep_tf" 2>/dev/null || echo "unknown")
    [ "$dep_status" != "archived" ] && return 1
  done
  return 0
}

# 文件级冲突检测
check_file_conflict() {
  local task1="$1" task2="$2"
  local tf1=$(task_file "$task1")
  local tf2=$(task_file "$task2")
  local dir1=$(jq -r '.worktree.path // ""' "$tf1")
  local dir2=$(jq -r '.worktree.path // ""' "$tf2")
  [ -n "$dir1" ] && [ -n "$dir2" ] && [ "$dir1" != "$dir2" ] && return 0
  local files1=$(jq -r '.modified_files // [] | .[]' "$tf1")
  local files2=$(jq -r '.modified_files // [] | .[]' "$tf2")
  for f1 in $files1; do
    for f2 in $files2; do
      [ "$f1" = "$f2" ] && return 1
    done
  done
  return 0
}

# 获取下一个可启动的任务ID
scheduler_next_task() {
  # 新格式
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    local tf="$d/task.json"
    [ -f "$tf" ] || continue
    local task_id=$(jq -r '.id' "$tf")
    local task_status=$(jq -r '.status' "$tf")
    if [ "$task_status" = "pending" ] && dependencies_met "$task_id"; then
      echo "$task_id"
      return
    fi
  done
  # 旧格式兼容
  for task_file_entry in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$task_file_entry" ] || continue
    local task_id=$(jq -r '.id' "$task_file_entry")
    local task_status=$(jq -r '.status' "$task_file_entry")
    if [ "$task_status" = "pending" ] && dependencies_met "$task_id"; then
      echo "$task_id"
      return
    fi
  done
}

# 启动任务
launch_task() {
  local task_id="$1"
  local now=$(date -u +%FT%TZ)
  local tf=$(task_file "$task_id")
  local tmp=$(mktemp)
  jq --arg t "$now" \
    '.status="executing" | .phase="execute" | .phase_lock="execute" | .entered_at=$t' \
    "$tf" > "$tmp" \
    && mv "$tmp" "$tf"
  scheduler_update_index
}

# 等待活跃任务完成
wait_for_task_completion() {
  local poll_interval="${1:-30}"
  while true; do
    local all_idle=true
    # 新格式
    for d in "$KANBAN_DIR"/tasks/TASK-*/; do
      [ -d "$d" ] || continue
      local tf="$d/task.json"
      [ -f "$tf" ] || continue
      local s=$(jq -r '.status' "$tf")
      case "$s" in executing|evaluating|planning) all_idle=false; break ;; esac
    done
    # 旧格式兼容
    if [ "$all_idle" = "true" ]; then
      for f in "$KANBAN_DIR"/tasks/TASK-*.json; do
        [ -f "$f" ] || continue
        local s=$(jq -r '.status' "$f")
        case "$s" in executing|evaluating|planning) all_idle=false; break ;; esac
      done
    fi
    $all_idle && break
    sleep "$poll_interval"
  done
}

# 处理已完成任务
process_completed_tasks() {
  # 新格式
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    local tf="$d/task.json"
    [ -f "$tf" ] || continue
    local task_id=$(jq -r '.id' "$tf")
    local task_status=$(jq -r '.status' "$tf")
    case "$task_status" in
      completed|archived|user_decision)
        local wt_path=$(jq -r '.worktree.path // ""' "$tf")
        if [ -n "$wt_path" ] && [ -d "$wt_path" ]; then
          local trunk=$(jq -r '.worktree.base // "main"' "$tf")
          local modified=$(cd "$wt_path" && git diff --name-only "$trunk" 2>/dev/null | head -50)
          if [ -n "$modified" ]; then
            local tmp=$(mktemp)
            jq --arg f "$modified" '.modified_files=($f | split("\n") | map(select(length>0)))' \
              "$tf" > "$tmp" && mv "$tmp" "$tf"
          fi
        fi
        ;;
    esac
  done
  scheduler_update_index
}

# 更新 index.json (委托给 kanban.sh 的 _update_index)
scheduler_update_index() {
  if type _update_index >/dev/null 2>&1; then
    _update_index
  fi
}

# 调度器主循环
scheduler_run() {
  local max_parallel=$(jq -r '.scheduler.max_parallel // 3' "$KANBAN_DIR/config.json")
  local poll_interval=$(jq -r '.scheduler.poll_interval_seconds // 30' "$KANBAN_DIR/config.json")

  while has_pending_or_active_tasks; do
    local active=$(count_active_tasks)

    if [ "$active" -lt "$max_parallel" ]; then
      local next_task=$(scheduler_next_task)
      if [ -n "$next_task" ]; then
        echo "LAUNCH:$next_task"
      fi
    fi

    wait_for_task_completion "$poll_interval"
    process_completed_tasks
  done
  echo "ALL_DONE"
}
