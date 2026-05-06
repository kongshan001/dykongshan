#!/usr/bin/env bash
# recovery.sh -- 崩溃恢复 + 超时检测 + 中断恢复机制 (ST-003)
# 依赖: jq
#
# ST-003 (GitHub Issue #32): Task execution interruption recovery mechanism.
# Enhanced with:
#   - recover_list_interrupted() now detects process liveness and marks interrupted
#   - recover_resume_task() restores execution from last_known_phase
#   - recover_rollback_task() rollbacks to safe checkpoint (previous phase)
#   - recover_record_pid() records executor PID for liveness detection
#   - recover_clear_pid() clears executor PID on phase completion

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# === PID File Management (ST-003) ===

# _recovery_pid_file(task_id) -- returns the path to the executor PID file
_recovery_pid_file() {
  local task_id="$1"
  local tdir
  tdir=$(task_dir "$task_id" 2>/dev/null) || tdir="$KANBAN_DIR/tasks/${task_id}"
  # 旧格式任务: PID 文件放在 .kanban/ 目录
  if [ "$tdir" = "$KANBAN_DIR/tasks" ]; then
    echo "$KANBAN_DIR/.executor_${task_id}.pid"
  else
    echo "$tdir/.executor_pid"
  fi
}

# recover_record_pid(task_id) -- record current shell PID as executor PID
# Called by workflow_transition when entering a phase that involves agent execution.
recover_record_pid() {
  local task_id="$1"
  [ -z "$task_id" ] && return 1
  local pid_file
  pid_file=$(_recovery_pid_file "$task_id")
  echo "$$" > "$pid_file"
}

# recover_clear_pid(task_id) -- clear executor PID (called on phase completion)
recover_clear_pid() {
  local task_id="$1"
  [ -z "$task_id" ] && return 1
  local pid_file
  pid_file=$(_recovery_pid_file "$task_id")
  rm -f "$pid_file"
}

# === Process Liveness Detection (ST-003) ===

# _recovery_is_process_alive(pid) -- check if a process with given PID exists
_recovery_is_process_alive() {
  local pid="$1"
  [ -z "$pid" ] && return 1
  # kill -0 sends no signal, just checks existence (POSIX)
  kill -0 "$pid" 2>/dev/null && return 0
  return 1
}

# _recovery_is_task_process_alive(task_id) -- check if any process related to
# this task is still alive.  Checks:
#   1. PID file (preferred, most reliable)
#   2. Process list scanning for task_id in command lines (fallback)
_recovery_is_task_process_alive() {
  local task_id="$1"

  # 1. Check PID file first (most reliable)
  local pid_file
  pid_file=$(_recovery_pid_file "$task_id")
  if [ -f "$pid_file" ]; then
    local saved_pid
    saved_pid=$(cat "$pid_file" 2>/dev/null | tr -d '[:space:]')
    if [ -n "$saved_pid" ] && _recovery_is_process_alive "$saved_pid"; then
      return 0
    fi
  fi

  # 2. Check process list for the task ID (fallback)
  # ps aux works on both macOS and Linux
  local ps_output
  ps_output=$(ps aux 2>/dev/null || ps -ef 2>/dev/null || echo "")
  if echo "$ps_output" | grep -v grep | grep -v "recover_list_interrupted" | grep -v "kanban_status" | grep -q "$task_id"; then
    return 0
  fi

  return 1
}

# === Recovery: List Interrupted Tasks (Enhanced ST-003) ===

# _recovery_mark_interrupted(task_id, task_file) -- mark a task as interrupted
# Records interrupted_at, last_known_phase, last_known_status, and
# recovery_context (current subtask, completed steps).
_recovery_mark_interrupted() {
  local task_id="$1"
  local tf="$2"
  local now=$(date -u +%FT%TZ)

  local task_status=$(jq -r '.status' "$tf")
  local phase_lock=$(jq -r '.phase_lock // ""' "$tf")

  # 查找当前进行中的 subtask
  local current_subtask=""
  if jq -e '.task_breakdown.subtasks' "$tf" >/dev/null 2>&1; then
    current_subtask=$(jq -r '
      [.task_breakdown.subtasks[] | select(.status == "in_progress")] | .[0].id // ""' "$tf" 2>/dev/null)
    [ "$current_subtask" = "null" ] && current_subtask=""
  fi

  # 收集已完成的 subtask
  local completed_steps="[]"
  if jq -e '.task_breakdown.subtasks' "$tf" >/dev/null 2>&1; then
    completed_steps=$(jq '[.task_breakdown.subtasks[] | select(.status == "completed") | .id]' "$tf")
  fi

  local tmp=$(mktemp)
  jq --arg now "$now" \
     --arg last_phase "$phase_lock" \
     --arg last_status "$task_status" \
     --arg current_subtask "$current_subtask" \
     --argjson completed_steps "$completed_steps" \
     '.status = "interrupted" |
      .interrupted_at = $now |
      .last_known_phase = $last_phase |
      .last_known_status = $last_status |
      .recovery_context = {
        current_subtask: $current_subtask,
        completed_steps: $completed_steps
      } |
      .history += [{
        phase: "recovery",
        status: "interrupted",
        entered_at: $now,
        last_known_phase: $last_phase,
        last_known_status: $last_status
      }]' \
    "$tf" > "$tmp" && mv "$tmp" "$tf"

  # 清理 PID 文件
  recover_clear_pid "$task_id"
}

# recover_list_interrupted() -- 列出所有可能中断的任务并标记 interrupted 状态
# Enhanced ST-003: detects process liveness and marks tasks as interrupted.
# Scans all tasks with status planning/executing/evaluating, checks if the
# executor process is still alive, and marks non-alive tasks as interrupted.
recover_list_interrupted() {
  echo "=== Potentially Interrupted Tasks ==="
  local found=0
  local interrupted_count=0

  # 新格式: tasks/TASK-NNN/task.json
  for task_dir_entry in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$task_dir_entry" ] || continue
    local tf="$task_dir_entry/task.json"
    [ -f "$tf" ] || continue
    local id=$(jq -r '.id' "$tf")
    local task_status=$(jq -r '.status' "$tf")

    case "$task_status" in
      executing|evaluating|planning)
        found=$((found + 1))
        echo "  $id ($task_status)"

        # ST-003: 进程存活检测
        if ! _recovery_is_task_process_alive "$id"; then
          _recovery_mark_interrupted "$id" "$tf"
          interrupted_count=$((interrupted_count + 1))
          echo "    -> INTERRUPTED (process not alive)"
        else
          echo "    -> active (process alive)"
        fi

        recover_check_timeout "$id"
        ;;
      interrupted)
        found=$((found + 1))
        interrupted_count=$((interrupted_count + 1))
        local last_phase=$(jq -r '.last_known_phase // "unknown"' "$tf")
        local inter_at=$(jq -r '.interrupted_at // "unknown"' "$tf")
        echo "  $id (interrupted)"
        echo "    Last phase: $last_phase, interrupted at: $inter_at"
        echo "    Recovery: /kanban resume $id   or   /kanban rollback $id"
        ;;
    esac
  done

  # 旧格式兼容: tasks/TASK-NNN.json
  for task_file_entry in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$task_file_entry" ] || continue
    local id=$(jq -r '.id' "$task_file_entry")
    # 跳过已在新格式中处理的
    [ -d "$KANBAN_DIR/tasks/${id}" ] && continue
    local task_status=$(jq -r '.status' "$task_file_entry")

    case "$task_status" in
      executing|evaluating|planning)
        found=$((found + 1))
        echo "  $id ($task_status)"

        if ! _recovery_is_task_process_alive "$id"; then
          _recovery_mark_interrupted "$id" "$task_file_entry"
          interrupted_count=$((interrupted_count + 1))
          echo "    -> INTERRUPTED (process not alive)"
        else
          echo "    -> active (process alive)"
        fi

        recover_check_timeout "$id"
        ;;
      interrupted)
        found=$((found + 1))
        interrupted_count=$((interrupted_count + 1))
        local last_phase=$(jq -r '.last_known_phase // "unknown"' "$task_file_entry")
        echo "  $id (interrupted)"
        echo "    Last phase: $last_phase"
        echo "    Recovery: /kanban resume $id   or   /kanban rollback $id"
        ;;
    esac
  done

  if [ "$found" -eq 0 ]; then
    echo "  (no active or interrupted tasks found)"
  fi

  if [ "$interrupted_count" -gt 0 ]; then
    echo ""
    echo "=== Recovery Guidance ==="
    echo "  /kanban resume <task_id>   -- Resume from last known phase"
    echo "  /kanban rollback <task_id> -- Rollback to safe checkpoint"
  fi

  return 0
}

# === Recovery: Resume Task (ST-003) ===

# recover_resume_task(task_id) -- resume an interrupted task from its
# last_known_phase.  Reads interrupted_at, last_known_phase, last_known_status
# from task.json, clears the interrupted flags, sets status back to the
# appropriate active state, and outputs recovery path guidance.
recover_resume_task() {
  local task_id="$1"
  local tf
  tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local task_status=$(jq -r '.status // ""' "$tf")

  if [ "$task_status" != "interrupted" ] && [ "$task_status" != "timeout" ]; then
    echo "ERROR: $task_id status is '$task_status', not interrupted."
    echo "Use /kanban run $task_id instead."
    return 1
  fi

  local last_phase=$(jq -r '.last_known_phase // ""' "$tf")
  local last_status=$(jq -r '.last_known_status // ""' "$tf")
  local inter_at=$(jq -r '.interrupted_at // ""' "$tf")
  local current_subtask=$(jq -r '.recovery_context.current_subtask // ""' "$tf")

  [ -z "$last_phase" ] && { echo "ERROR: no last_known_phase recorded for $task_id"; return 1; }

  echo "=== Resume: $task_id ==="
  echo "Interrupted at: $inter_at"
  echo "Last known phase: $last_phase (status: $last_status)"
  if [ -n "$current_subtask" ] && [ "$current_subtask" != "null" ]; then
    echo "Current subtask at interruption: $current_subtask"
  fi
  echo ""

  # === ST-008: Checkpoint 读取逻辑 (GitHub Issue #37) ===
  # 读取 checkpoints/ 目录，识别已完成/未完成的 subtask
  local cp_dir
  cp_dir=$(_checkpoint_dir "$task_id")
  if [ -d "$cp_dir" ] && [ "$(ls -A "$cp_dir" 2>/dev/null)" ]; then
    echo "--- Checkpoint Recovery ---"
    local completed_subtasks=""
    local in_progress_subtasks=""
    local next_subtask=""

    for cp_file in "$cp_dir"/*.json; do
      [ -f "$cp_file" ] || continue
      local cp_subtask=$(jq -r '.subtask // ""' "$cp_file")
      local cp_status=$(jq -r '.status // ""' "$cp_file")
      local cp_files=$(jq -r '.files_written | join(", ")' "$cp_file")
      [ -z "$cp_subtask" ] && continue

      case "$cp_status" in
        completed)
          completed_subtasks="${completed_subtasks} ${cp_subtask}"
          echo "  [completed] $cp_subtask"
          [ -n "$cp_files" ] && echo "    Files: $cp_files"
          ;;
        in_progress)
          in_progress_subtasks="${in_progress_subtasks} ${cp_subtask}"
          local files_count=$(jq '.files_written | length' "$cp_file")
          echo "  [in_progress] $cp_subtask ($files_count files written so far)"
          [ -n "$cp_files" ] && echo "    Files done: $cp_files"
          ;;
      esac
    done

    # 确定下一个未完成的 subtask
    if [ -n "$current_subtask" ] && [ "$current_subtask" != "null" ]; then
      next_subtask="$current_subtask"
      echo "  Next subtask to resume: $next_subtask (the one interrupted)"
    fi

    echo ""
  fi

  # 确定恢复后的状态
  local recovery_status=""
  case "$last_phase" in
    plan)     recovery_status="planning" ;;
    execute)  recovery_status="executing" ;;
    evaluate) recovery_status="evaluating" ;;
    *)        recovery_status="$last_status" ;;
  esac

  local now=$(date -u +%FT%TZ)

  # 更新 task: 清除 interrupted 标记, 设置 phase, 添加 recovery history
  local tmp=$(mktemp)
  jq --arg phase "$last_phase" \
     --arg lock "$last_phase" \
     --arg status "$recovery_status" \
     --arg now "$now" \
     '.status = $status |
      .phase = $phase |
      .phase_lock = $lock |
      .entered_at = $now |
      del(.interrupted_at) |
      del(.last_known_phase) |
      del(.last_known_status) |
      del(.recovery_context) |
      .history += [{
        phase: "recovery",
        status: "resumed",
        entered_at: $now,
        resumed_to_phase: $phase,
        resumed_to_status: $status
      }]' \
    "$tf" > "$tmp" && mv "$tmp" "$tf"

  # 记录新的 PID
  recover_record_pid "$task_id"

  echo "Task $task_id resumed to phase '$last_phase'"
  echo ""
  echo "=== Resume Guidance ==="
  echo "The task has been reset to the '$last_phase' phase."

  case "$last_phase" in
    plan)
      echo "Run: /kanban run $task_id --phase plan"
      ;;
    execute)
      # 验证 worktree
      if type worktree_validate >/dev/null 2>&1; then
        local validate_result
        validate_result=$(worktree_validate "$task_id" 2>/dev/null) || true
        if [ $? -ne 0 ]; then
          echo "WARNING: worktree validation failed. You may need to rebuild."
          echo "  To rebuild: /kanban run $task_id --phase execute"
        else
          echo "Worktree validated OK."
        fi
      fi
      echo "Run: /kanban run $task_id --phase execute"
      ;;
    evaluate)
      echo "Run: /kanban run $task_id --phase evaluate"
      ;;
    *)
      echo "Run: /kanban run $task_id --phase $last_phase"
      ;;
  esac

  return 0
}

# === Recovery: Rollback Task (ST-003) ===

# recover_rollback_task(task_id) -- rollback an interrupted task to the
# nearest safe checkpoint (the previous completed phase).  Clears the
# artifacts from the interrupted phase's iteration directory.
recover_rollback_task() {
  local task_id="$1"
  local tf
  tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local task_status=$(jq -r '.status // ""' "$tf")

  if [ "$task_status" != "interrupted" ] && [ "$task_status" != "timeout" ]; then
    echo "ERROR: $task_id status is '$task_status', not interrupted."
    echo "Use /kanban run $task_id instead."
    return 1
  fi

  local last_phase=$(jq -r '.last_known_phase // ""' "$tf")
  local last_status=$(jq -r '.last_known_status // ""' "$tf")
  local inter_at=$(jq -r '.interrupted_at // ""' "$tf")
  local iter=$(jq -r '.iteration // 1' "$tf")

  [ -z "$last_phase" ] && { echo "ERROR: no last_known_phase recorded for $task_id"; return 1; }

  # 确定安全回滚点: 上一个已完成阶段
  local rollback_phase=""
  case "$last_phase" in
    plan)
      # plan 阶段中断 -> 回到 pending
      rollback_phase="pending"
      ;;
    execute)
      # execute 中断 -> 回到 plan (如果 plan 已完成) 否则 pending
      if jq -e '.history[] | select(.phase == "plan" and .status == "completed")' "$tf" >/dev/null 2>&1; then
        rollback_phase="plan"
      else
        rollback_phase="pending"
      fi
      ;;
    evaluate)
      # evaluate 中断 -> 回到 execute (如果 execute 已完成)
      if jq -e '.history[] | select(.phase == "execute" and .status == "completed")' "$tf" >/dev/null 2>&1; then
        rollback_phase="execute"
      elif jq -e '.history[] | select(.phase == "plan" and .status == "completed")' "$tf" >/dev/null 2>&1; then
        rollback_phase="plan"
      else
        rollback_phase="pending"
      fi
      ;;
    *)
      rollback_phase="plan"
      ;;
  esac

  echo "=== Rollback: $task_id ==="
  echo "Interrupted at: $inter_at"
  echo "Interrupted phase: $last_phase"
  echo "Rollback to: $rollback_phase"
  echo ""

  # 清空中断阶段的产物
  local rdir
  rdir=$(report_dir "$task_id" "$iter" 2>/dev/null)
  local cleared_artifacts=""

  case "$last_phase" in
    execute)
      if [ -d "$rdir" ]; then
        [ -f "$rdir/execution_summary.md" ] && { rm -f "$rdir/execution_summary.md"; cleared_artifacts="$cleared_artifacts execution_summary.md"; }
        [ -f "$rdir/execution_pitfalls.md" ] && { rm -f "$rdir/execution_pitfalls.md"; cleared_artifacts="$cleared_artifacts execution_pitfalls.md"; }
        [ -f "$rdir/execution_decisions.md" ] && { rm -f "$rdir/execution_decisions.md"; cleared_artifacts="$cleared_artifacts execution_decisions.md"; }
      fi
      # 清除此阶段的 PID 文件
      recover_clear_pid "$task_id"
      ;;
    evaluate)
      if [ -d "$rdir" ]; then
        for report in "$rdir"/*_report.json; do
          [ -f "$report" ] || continue
          local rname=$(basename "$report")
          rm -f "$report"
          cleared_artifacts="$cleared_artifacts $rname"
        done
      fi
      # 清除 framework_assessment.json
      [ -f "$rdir/framework_assessment.json" ] && { rm -f "$rdir/framework_assessment.json"; cleared_artifacts="$cleared_artifacts framework_assessment.json"; }
      recover_clear_pid "$task_id"
      ;;
  esac

  if [ -n "$cleared_artifacts" ]; then
    echo "Cleared artifacts from interrupted phase:$cleared_artifacts"
  fi

  # 确定回滚后的状态
  local recovery_status=""
  case "$rollback_phase" in
    pending)  recovery_status="pending" ;;
    plan)     recovery_status="planning" ;;
    execute)  recovery_status="executing" ;;
    *)        recovery_status="pending" ;;
  esac

  local now=$(date -u +%FT%TZ)

  # 更新 task
  local tmp=$(mktemp)
  if [ "$rollback_phase" = "pending" ]; then
    jq --arg now "$now" \
      '.status = "pending" |
       .phase = null |
       .phase_lock = null |
       .entered_at = null |
       del(.interrupted_at) |
       del(.last_known_phase) |
       del(.last_known_status) |
       del(.recovery_context) |
       .history += [{
         phase: "recovery",
         status: "rolled_back",
         entered_at: $now,
         rolled_back_from: "'"$last_phase"'",
         rolled_back_to: "pending"
       }]' \
      "$tf" > "$tmp" && mv "$tmp" "$tf"
  else
    jq --arg phase "$rollback_phase" \
       --arg lock "$rollback_phase" \
       --arg status "$recovery_status" \
       --arg now "$now" \
       --arg from "$last_phase" \
      '.status = $status |
       .phase = $phase |
       .phase_lock = $lock |
       .entered_at = $now |
       del(.interrupted_at) |
       del(.last_known_phase) |
       del(.last_known_status) |
       del(.recovery_context) |
       .history += [{
         phase: "recovery",
         status: "rolled_back",
         entered_at: $now,
         rolled_back_from: $from,
         rolled_back_to: $phase
       }]' \
      "$tf" > "$tmp" && mv "$tmp" "$tf"
  fi

  echo "Task $task_id rolled back to '$rollback_phase'"
  echo ""
  echo "=== Rollback Guidance ==="

  case "$rollback_phase" in
    pending)
      echo "The task has been reset to pending."
      echo "Run: /kanban run $task_id"
      ;;
    plan)
      echo "Run: /kanban run $task_id --phase plan"
      ;;
    execute)
      echo "Run: /kanban run $task_id --phase execute"
      ;;
    *)
      echo "Run: /kanban run $task_id"
      ;;
  esac

  return 0
}

# === ST-008: Subtask 级检查点恢复 (GitHub Issue #37) ===
# _checkpoint_dir 已在 kanban.sh 中定义，此处直接引用

# recovery_restore_subtask(task_id)
# 扫描 checkpoints/ 目录中所有 status=in_progress 的检查点，
# 列出已完成的文件，自动跳过已完成的文件，从下一个文件继续。
# 用法: recovery_restore_subtask TASK-001
# 输出: 恢复摘要（已完成文件列表、待处理文件列表、下一个文件）
recovery_restore_subtask() {
  local task_id="$1"
  [ -z "$task_id" ] && { echo "ERROR: task_id required"; return 1; }

  local cp_dir
  cp_dir=$(_checkpoint_dir "$task_id")

  if [ ! -d "$cp_dir" ] || [ -z "$(ls -A "$cp_dir" 2>/dev/null)" ]; then
    echo "No checkpoints found for $task_id"
    echo "Run /kanban resume $task_id instead."
    return 1
  fi

  echo "=== Restore Subtask: $task_id ==="
  echo ""

  local found_in_progress=0
  local current_subtask=""
  local files_done=""

  for cp_file in "$cp_dir"/*.json; do
    [ -f "$cp_file" ] || continue
    local st=$(jq -r '.status // ""' "$cp_file")
    if [ "$st" = "in_progress" ]; then
      found_in_progress=$((found_in_progress + 1))
      current_subtask=$(jq -r '.subtask // ""' "$cp_file")
      local started_at=$(jq -r '.started_at // ""' "$cp_file")
      local files_count=$(jq '.files_written | length' "$cp_file")

      echo "  In-progress checkpoint: $current_subtask"
      echo "    Started: $started_at"
      echo "    Files completed so far ($files_count):"

      local idx=0
      while [ $idx -lt "$files_count" ]; do
        local fp=$(jq -r ".files_written[$idx]" "$cp_file")
        echo "      [$((idx + 1))] DONE: $fp"
        idx=$((idx + 1))
      done

      # 收集所有已完成文件
      files_done=$(jq -r '.files_written[]' "$cp_file")
      break
    fi
  done

  if [ "$found_in_progress" -eq 0 ]; then
    echo "  No in-progress checkpoints found."
    echo ""
    echo "  Completed subtasks (from checkpoints):"
    for cp_file in "$cp_dir"/*.json; do
      [ -f "$cp_file" ] || continue
      local st=$(jq -r '.status // ""' "$cp_file")
      if [ "$st" = "completed" ]; then
        local c_st=$(jq -r '.subtask // ""' "$cp_file")
        local c_at=$(jq -r '.completed_at // ""' "$cp_file")
        echo "    [completed] $c_st ($c_at)"
      fi
    done
    echo ""
    echo "  All checkpoints appear complete."
    echo "  Use /kanban resume $task_id to continue from the next phase."
    return 0
  fi

  echo ""
  echo "  === Restore Guidance ==="
  echo "  The executor should skip the DONE files above and continue"
  echo "  with the remaining files for $current_subtask."
  echo ""
  echo "  To resume execution: /kanban resume $task_id"

  # 将恢复上下文写入 task.json 的 recovery_context
  local tf
  tf=$(task_file "$task_id")
  if [ -f "$tf" ]; then
    local tmp=$(mktemp)
    jq --arg st "$current_subtask" \
       --argjson done "$( [ -n "$files_done" ] && printf '%s\n' "$files_done" | jq -R -s 'split("\n") | map(select(length > 0))' || echo "[]" )" \
       '.recovery_context.current_subtask = $st |
        .recovery_context.files_completed = $done' \
      "$tf" > "$tmp" 2>/dev/null && mv "$tmp" "$tf"
  fi

  return 0
}

# === Original: Basic Recovery ===

# 恢复任务 (从 history 中找到最后一个 completed 阶段)
recover_task() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local task_status=$(jq -r '.status' "$tf")
  local phase_lock=$(jq -r '.phase_lock // ""' "$tf")

  # ST-003: 如果任务是 interrupted 状态，使用专门的恢复逻辑
  if [ "$task_status" = "interrupted" ]; then
    recover_resume_task "$task_id"
    return $?
  fi

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

  # ST-003: 记录 PID 用于后续中断检测
  recover_record_pid "$task_id"

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

    # ST-003: 超时时也记录中断上下文信息
    local tmp=$(mktemp)
    jq --arg now "$now_iso" --argjson elapsed "$elapsed" --argjson limit "$limit" --arg phase "$phase" \
      '.status="timeout" |
       .timeout_at=$now |
       .timeout_elapsed=$elapsed |
       .timeout_limit=$limit |
       .last_known_phase=$phase |
       .last_known_status="timeout" |
       .interrupted_at=$now' \
      "$tf" > "$tmp" \
      && mv "$tmp" "$tf"
    echo "TIMEOUT: $task_id ($elapsed > $limit seconds in $phase)"
    return 1
  fi
  return 0
}
