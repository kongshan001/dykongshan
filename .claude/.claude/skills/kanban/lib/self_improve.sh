#!/usr/bin/env bash
# self_improve.sh — 自迭代逻辑 + Skills 演化
# 依赖: jq
#
# ST-003: 全自动演化机制
# - skills_evolve_extract(): 从 pitfalls/decisions 中提取框架改进点
# - skills_evolve_apply(): 自动应用 agent/rule 类改进, lib 类创建任务
# - skills_evolve_report(): 生成演化报告 JSON
# - skills_evolve_auto(): 自动执行 extract + apply + report
# - skills_evolve_show_history(): 显示历史演化记录

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# 检查是否需要迭代
self_improve_check() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local iteration=$(jq -r '.iteration' "$tf")
  local max_iter=$(jq -r '.max_iterations // 6' "$tf")

  # 检查是否全部通过
  local all_pass=true
  for role in code_reviewer qa pm designer; do
    local passed=$(jq -r ".scores.${role}.passed // false" "$tf")
    [ "$passed" = "false" ] && all_pass=false
  done

  if [ "$all_pass" = "true" ]; then
    echo "all_pass"
    return 0
  fi

  if [ "$iteration" -ge "$max_iter" ]; then
    echo "max_reached"
    return 0
  fi

  echo "iterate"
  return 0
}

# ============================================================================
# ST-003: 全自动 Skills 演化机制
# ============================================================================

# Framework keyword list used for matching framework-related improvements
_SKILLS_EVOLVE_FRAMEWORK_KEYWORDS="框架|framework|kanban|guard|worktree|agent|rule|评估|调度|workflow|evaluate|executor|planner|archive|symlink|inbox|dashboard"

# FR-006: Negative context patterns -- lines matching these are NOT framework improvements
_SKILLS_EVOLVE_NEGATIVE_CONTEXT="no framework|not framework|unrelated|非框架|无框架|不是框架|no.*keywords? here|not.*related|nothing relevant|nothing to do|pure.*project|project-specif|纯粹|仅是"

# Specific action keywords that indicate genuine framework improvement intent
_SKILLS_EVOLVE_ACTION_KEYWORDS="bug|fix|should|need|must|add|remove|improve|refactor|update|change|enhance|broken|missing|error|fail|repair|优化|改进|完善|增强|缺少|缺失|需要|必须|修复"

# Classify a line from pitfalls/decisions into a category
# Input: text line
# Output: agent_improvement | rule_improvement | lib_improvement | ""
# FR-006: Improved to avoid false positives:
#   1. Skip lines with negative context ("No framework keywords here")
#   2. Require either 2+ framework keywords or 1 framework + 1 action keyword
#   3. Skip very short/generic lines (< 20 chars)
_skills_classify_line() {
  local line="$1"

  # Skip very short lines -- likely noise
  [ ${#line} -lt 20 ] && { echo ""; return 0; }

  # Check for negative context (e.g., "No framework keywords here")
  if echo "$line" | grep -qiE -- "$_SKILLS_EVOLVE_NEGATIVE_CONTEXT"; then
    echo ""
    return 0
  fi

  # Count how many framework keywords are present
  local fw_count=0
  for kw in 框架 framework kanban guard worktree agent rule 评估 调度 workflow evaluate executor planner archive symlink inbox dashboard; do
    if echo "$line" | grep -qi -- "$kw"; then
      fw_count=$((fw_count + 1))
    fi
  done

  # Check if any action keyword is present
  local has_action=false
  if echo "$line" | grep -qiE -- "$_SKILLS_EVOLVE_ACTION_KEYWORDS"; then
    has_action=true
  fi

  # Classification threshold: need either 2+ framework keywords OR
  # 1+ framework keyword + 1 action keyword
  if [ "$fw_count" -lt 1 ]; then
    echo ""
    return 0
  fi
  if [ "$fw_count" -lt 2 ] && [ "$has_action" = "false" ]; then
    echo ""
    return 0
  fi

  # agent-related keywords
  if echo "$line" | grep -qi -- "agent\|planner\|executor\|code_reviewer\|qa.*agent\|pm.*agent\|designer.*agent\|角色\|调度"; then
    echo "agent_improvement"
    return 0
  fi
  # rule-related keywords
  if echo "$line" | grep -qi -- "rule\|规则\|铁律\|约束\|检查方法\|违反后果"; then
    echo "rule_improvement"
    return 0
  fi
  # lib-related keywords (code-level changes)
  if echo "$line" | grep -qi -- "lib\|函数\|shell\|script\|\.sh\|代码\|bug\|修复\|refactor\|重构"; then
    echo "lib_improvement"
    return 0
  fi
  # Default: lib_improvement (safest category -- will create a task rather than direct change)
  echo "lib_improvement"
}

# Determine confidence level based on source and content
# Input: source_file, text
# Output: high | medium | low
_skills_determine_confidence() {
  local source_file="$1"
  local text="$2"
  # Higher confidence if text contains specific file references
  if echo "$text" | grep -qi -- "\.sh\|\.js\|\.md\|\.json"; then
    echo "high"
    return 0
  fi
  # Medium confidence if text is from execution_decisions (curated content)
  if [ "$source_file" = "execution_decisions.md" ]; then
    echo "medium"
    return 0
  fi
  echo "low"
}

# Suggest a target file based on category and content
# Input: category, text
# Output: suggested file path (relative to project root)
_skills_suggest_file() {
  local category="$1"
  local text="$2"
  case "$category" in
    agent_improvement)
      # Try to find a specific agent file
      if echo "$text" | grep -qi -- "planner"; then
        echo ".claude/skills/kanban/agents/planner.md"
      elif echo "$text" | grep -qi -- "executor"; then
        echo ".claude/skills/kanban/agents/executor.md"
      elif echo "$text" | grep -qi -- "code_reviewer\|code-reviewer"; then
        echo ".claude/skills/kanban/agents/code_reviewer.md"
      elif echo "$text" | grep -qi -- "qa"; then
        echo ".claude/skills/kanban/agents/qa.md"
      elif echo "$text" | grep -qi -- "pm"; then
        echo ".claude/skills/kanban/agents/pm.md"
      elif echo "$text" | grep -qi -- "designer"; then
        echo ".claude/skills/kanban/agents/designer.md"
      else
        echo ".claude/skills/kanban/agents/"
      fi
      ;;
    rule_improvement)
      if echo "$text" | grep -qi -- "test\|测试"; then
        echo ".claude/skills/kanban/rules/test-with-code.md"
      elif echo "$text" | grep -qi -- "output\|产出\|目录"; then
        echo ".claude/skills/kanban/rules/output-dir-convention.md"
      elif echo "$text" | grep -qi -- "文档\|documentation"; then
        echo ".claude/skills/kanban/rules/documentation-first.md"
      elif echo "$text" | grep -qi -- "archive\|归档"; then
        echo ".claude/skills/kanban/rules/archive-requires-confirmation.md"
      else
        echo ".claude/skills/kanban/rules/"
      fi
      ;;
    lib_improvement)
      if echo "$text" | grep -qi -- "workflow"; then
        echo ".claude/skills/kanban/lib/workflow.sh"
      elif echo "$text" | grep -qi -- "guard"; then
        echo ".claude/skills/kanban/lib/guard.sh"
      elif echo "$text" | grep -qi -- "worktree"; then
        echo ".claude/skills/kanban/lib/worktree.sh"
      elif echo "$text" | grep -qi -- "evaluator"; then
        echo ".claude/skills/kanban/lib/evaluator.sh"
      elif echo "$text" | grep -qi -- "self_improve\|self-improve"; then
        echo ".claude/skills/kanban/lib/self_improve.sh"
      else
        echo ".claude/skills/kanban/lib/kanban.sh"
      fi
      ;;
    *)
      echo ""
      ;;
  esac
}

# Extract improvement candidates from a task's iteration artifacts
# Input: task_id, iteration (optional, defaults to current iteration)
# Output: writes candidate JSON files to .kanban/skills/evolved/
# Returns: number of candidates extracted
skills_evolve_extract() {
  local task_id="$1"
  local iter="${2:-}"
  local tf=$(task_file "$task_id")

  if [ ! -f "$tf" ]; then
    # Try archive
    tf=$(archive_task_file "$task_id")
  fi
  [ ! -f "$tf" ] && { echo "WARNING: cannot find task file for $task_id"; return 0; }

  if [ -z "$iter" ]; then
    iter=$(jq -r '.iteration // 1' "$tf")
  fi

  local rdir=$(report_dir "$task_id" "$iter")

  # FR-001: Archive path fallback -- when task is archived, report_dir() returns
  # the tasks/ path which no longer exists. Fall back to archive/ path (same logic
  # as skills_evolve_report, lines 419-430).
  if [ ! -d "$rdir" ]; then
    local archive_rdir="$KANBAN_DIR/archive/${task_id}/iteration-${iter}"
    if [ -d "$archive_rdir" ]; then
      rdir="$archive_rdir"
    fi
  fi

  local candidates_dir="$KANBAN_DIR/skills/evolved"
  mkdir -p "$candidates_dir"

  local candidate_count=0
  local candidate_idx=1

  # Find next available candidate index
  for existing in "$candidates_dir"/candidate-*.json; do
    [ -f "$existing" ] || continue
    local existing_num=$(basename "$existing" .json | sed 's/candidate-//' | sed 's/^0*//' )
    [ -z "$existing_num" ] && existing_num=0
    # Use arithmetic comparison with base-10 stripping
    [ "$((10#$existing_num))" -ge "$candidate_idx" ] 2>/dev/null && candidate_idx=$((10#$existing_num + 1))
  done

  # FR-002: Fix pipeline subshell issue -- `echo "$matching_lines" | while read`
  # runs in a subshell, so candidate_idx increments are lost. Instead, use a
  # temp file to pass matching lines, and process them in the main shell.

  # --- Extract from execution_pitfalls.md ---
  local pitfalls_file="$rdir/execution_pitfalls.md"
  if [ -f "$pitfalls_file" ]; then
    # Extract lines matching framework keywords
    local matching_lines
    matching_lines=$(grep -E -- "$_SKILLS_EVOLVE_FRAMEWORK_KEYWORDS" "$pitfalls_file" 2>/dev/null || true)
    if [ -n "$matching_lines" ]; then
      # Write matching lines to a temp file to avoid subshell variable loss
      local tmp_match
      tmp_match=$(mktemp)
      echo "$matching_lines" > "$tmp_match"
      while IFS= read -r line; do
        [ -z "$line" ] && continue
        # Skip lines that are just markdown headers with no content
        echo "$line" | grep -qE '^- \[|^###|^##|^#' && continue
        local trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//' | head -c 200)
        [ -z "$trimmed_line" ] && continue

        local category=$(_skills_classify_line "$trimmed_line")
        # FR-006: Skip lines that are classified as non-framework (empty category)
        [ -z "$category" ] && continue
        local confidence=$(_skills_determine_confidence "execution_pitfalls.md" "$trimmed_line")
        local suggested_file=$(_skills_suggest_file "$category" "$trimmed_line")
        local cid=$(printf "C-%03d" "$candidate_idx")

        jq -n \
          --arg id "$cid" \
          --arg source_task "$task_id" \
          --argjson source_iteration "$iter" \
          --arg source_file "execution_pitfalls.md" \
          --arg category "$category" \
          --arg description "$trimmed_line" \
          --arg suggested_file "$suggested_file" \
          --arg suggested_change "Review and incorporate the insight from: $trimmed_line" \
          --arg confidence "$confidence" \
          '{
            id: $id,
            source_task: $source_task,
            source_iteration: $source_iteration,
            source_file: $source_file,
            category: $category,
            description: $description,
            suggested_file: $suggested_file,
            suggested_change: $suggested_change,
            confidence: $confidence,
            status: "pending",
            created_at: (now | todate)
          }' > "$candidates_dir/candidate-$(printf '%03d' $candidate_idx).json"

        candidate_idx=$((candidate_idx + 1))
        candidate_count=$((candidate_count + 1))
      done < "$tmp_match"
      rm -f "$tmp_match"
    fi
  fi

  # --- Extract from execution_decisions.md ---
  local decisions_file="$rdir/execution_decisions.md"
  if [ -f "$decisions_file" ]; then
    # Extract lines matching framework keywords or under framework-related sections
    local matching_lines
    matching_lines=$(grep -E -- "$_SKILLS_EVOLVE_FRAMEWORK_KEYWORDS" "$decisions_file" 2>/dev/null || true)
    if [ -n "$matching_lines" ]; then
      # Write matching lines to a temp file to avoid subshell variable loss
      local tmp_match
      tmp_match=$(mktemp)
      echo "$matching_lines" > "$tmp_match"
      while IFS= read -r line; do
        [ -z "$line" ] && continue
        echo "$line" | grep -qE '^###|^##|^#' && continue
        local trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//' | head -c 200)
        [ -z "$trimmed_line" ] && continue

        local category=$(_skills_classify_line "$trimmed_line")
        # FR-006: Skip lines that are classified as non-framework (empty category)
        [ -z "$category" ] && continue
        local confidence=$(_skills_determine_confidence "execution_decisions.md" "$trimmed_line")
        local suggested_file=$(_skills_suggest_file "$category" "$trimmed_line")
        local cid=$(printf "C-%03d" "$candidate_idx")

        jq -n \
          --arg id "$cid" \
          --arg source_task "$task_id" \
          --argjson source_iteration "$iter" \
          --arg source_file "execution_decisions.md" \
          --arg category "$category" \
          --arg description "$trimmed_line" \
          --arg suggested_file "$suggested_file" \
          --arg suggested_change "Consider generalizing this decision: $trimmed_line" \
          --arg confidence "$confidence" \
          '{
            id: $id,
            source_task: $source_task,
            source_iteration: $source_iteration,
            source_file: $source_file,
            category: $category,
            description: $description,
            suggested_file: $suggested_file,
            suggested_change: $suggested_change,
            confidence: $confidence,
            status: "pending",
            created_at: (now | todate)
          }' > "$candidates_dir/candidate-$(printf '%03d' $candidate_idx).json"

        candidate_idx=$((candidate_idx + 1))
        candidate_count=$((candidate_count + 1))
      done < "$tmp_match"
      rm -f "$tmp_match"
    fi
  fi

  # Report how many candidates were extracted
  echo "Extracted $candidate_count candidates from $task_id iteration $iter"
  return 0
}

# Apply pending candidates automatically
# - agent_improvement: append suggestion as comment to the agent definition file
# - rule_improvement: append suggestion to the rule file or note it
# - lib_improvement: create a kanban task (respecting IR-12)
# Returns: number of candidates applied
skills_evolve_apply() {
  local task_id="$1"
  local candidates_dir="$KANBAN_DIR/skills/evolved"

  [ ! -d "$candidates_dir" ] && { echo "No candidates directory"; return 0; }

  local applied_count=0
  local pending_count=0
  local created_task_ids=""

  for candidate_file in "$candidates_dir"/candidate-*.json; do
    [ -f "$candidate_file" ] || continue

    local status=$(jq -r '.status // "pending"' "$candidate_file")
    [ "$status" = "applied" ] && continue

    local category=$(jq -r '.category // ""' "$candidate_file")
    local description=$(jq -r '.description // ""' "$candidate_file")
    local suggested_file=$(jq -r '.suggested_file // ""' "$candidate_file")
    local suggested_change=$(jq -r '.suggested_change // ""' "$candidate_file")
    local candidate_id=$(jq -r '.id // ""' "$candidate_file")
    local source_task=$(jq -r '.source_task // ""' "$candidate_file")

    case "$category" in
      agent_improvement)
        # Append as a comment to the agent definition file
        if [ -n "$suggested_file" ] && [ -f "$suggested_file" ]; then
          # Append suggestion as a trailing comment block
          {
            echo ""
            echo "<!-- skills_evolve: auto-suggested from $source_task -->"
            echo "<!-- $suggested_change -->"
          } >> "$suggested_file"

          # Mark as applied
          local tmp=$(mktemp)
          jq --arg applied_at "$(date -u +%FT%TZ)" '.status = "applied" | .applied_at = $applied_at' \
            "$candidate_file" > "$tmp" && mv "$tmp" "$candidate_file"
          applied_count=$((applied_count + 1))
        else
          pending_count=$((pending_count + 1))
        fi
        ;;

      rule_improvement)
        # Append suggestion to the rule file or note it in the candidate
        if [ -n "$suggested_file" ] && [ -f "$suggested_file" ]; then
          {
            echo ""
            echo "<!-- skills_evolve: auto-suggested from $source_task -->"
            echo "<!-- $suggested_change -->"
          } >> "$suggested_file"

          local tmp=$(mktemp)
          jq --arg applied_at "$(date -u +%FT%TZ)" '.status = "applied" | .applied_at = $applied_at' \
            "$candidate_file" > "$tmp" && mv "$tmp" "$candidate_file"
          applied_count=$((applied_count + 1))
        else
          pending_count=$((pending_count + 1))
        fi
        ;;

      lib_improvement)
        # Do NOT directly modify lib files (IR-12 compliance).
        # Instead, create a kanban task for the improvement.
        if type kanban_create_task >/dev/null 2>&1; then
          local create_output
          create_output=$(kanban_create_task "Framework lib improvement: $candidate_id" "$suggested_change (source: $source_task)" 2>&1) || true
          if echo "$create_output" | grep -q -- "Created TASK-"; then
            local new_task_id=$(echo "$create_output" | grep -o -- 'TASK-[0-9]*' | head -1)
            local tmp=$(mktemp)
            jq --arg applied_at "$(date -u +%FT%TZ)" --arg created_task "$new_task_id" \
              '.status = "applied" | .applied_at = $applied_at | .created_task = $created_task' \
              "$candidate_file" > "$tmp" && mv "$tmp" "$candidate_file"
            applied_count=$((applied_count + 1))
            if [ -n "$created_task_ids" ]; then
              created_task_ids="${created_task_ids}, \"${new_task_id}\""
            else
              created_task_ids="\"${new_task_id}\""
            fi
          else
            # Task creation failed, leave as pending
            pending_count=$((pending_count + 1))
          fi
        else
          # kanban_create_task not available, leave as pending
          pending_count=$((pending_count + 1))
        fi
        ;;

      *)
        # Unknown category, leave as pending
        pending_count=$((pending_count + 1))
        ;;
    esac
  done

  echo "Applied $applied_count candidates ($pending_count pending)"
  # Output the created_task_ids for use by report function
  if [ -n "$created_task_ids" ]; then
    echo "CREATED_TASKS:[$created_task_ids]"
  fi
  return 0
}

# Generate the skills evolution report JSON
# Input: task_id, iteration, extracted_count, applied_count, apply_output
# Output: writes skills_evolution_report.json to the task's iteration directory
skills_evolve_report() {
  local task_id="$1"
  local iter="${2:-}"
  local extracted_count="${3:-0}"
  local applied_count="${4:-0}"
  local created_task_ids_str="${5:-}"

  local tf=$(task_file "$task_id")
  if [ ! -f "$tf" ]; then
    tf=$(archive_task_file "$task_id")
  fi

  if [ -z "$iter" ]; then
    iter=$(jq -r '.iteration // 1' "$tf" 2>/dev/null || echo 1)
  fi

  # Determine report directory: prefer existing path, fall back to archive if task is archived
  local rdir=$(report_dir "$task_id" "$iter")
  # If the tasks/ directory does not exist (task was archived), use the archive path
  if [ ! -d "$rdir" ]; then
    local archive_rdir="$KANBAN_DIR/archive/${task_id}/iteration-${iter}"
    if [ -d "$archive_rdir" ]; then
      rdir="$archive_rdir"
    else
      # Neither tasks/ nor archive/ has the iteration dir -- create in archive
      rdir="$archive_rdir"
    fi
  fi
  mkdir -p "$rdir"

  local candidates_dir="$KANBAN_DIR/skills/evolved"

  # Collect all candidates for this task
  local candidates_json="[]"
  if [ -d "$candidates_dir" ]; then
    for candidate_file in "$candidates_dir"/candidate-*.json; do
      [ -f "$candidate_file" ] || continue
      local source_task=$(jq -r '.source_task // ""' "$candidate_file")
      if [ "$source_task" = "$task_id" ]; then
        candidates_json=$(echo "$candidates_json" | jq --slurpfile c "$candidate_file" '. + [$c[0]]')
      fi
    done
  fi

  local pending_count=$((extracted_count - applied_count))
  [ "$pending_count" -lt 0 ] && pending_count=0

  # Parse created_task_ids string into a JSON array
  local created_tasks_json="[]"
  if [ -n "$created_task_ids_str" ]; then
    # created_task_ids_str format: "TASK-019","TASK-020"
    created_tasks_json=$(echo "$created_task_ids_str" | jq -R 'split(",") | map(gsub("\""; ""))' 2>/dev/null || echo "[]")
  fi

  local report_file="$rdir/skills_evolution_report.json"
  jq -n \
    --arg task_id "$task_id" \
    --argjson iteration "$iter" \
    --arg triggered_at "$(date -u +%FT%TZ)" \
    --argjson extracted_count "$extracted_count" \
    --argjson applied_count "$applied_count" \
    --argjson pending_count "$pending_count" \
    --argjson candidates "$candidates_json" \
    --argjson created_task_ids "$created_tasks_json" \
    '{
      task_id: $task_id,
      iteration: $iteration,
      triggered_at: $triggered_at,
      extracted_count: $extracted_count,
      applied_count: $applied_count,
      pending_count: $pending_count,
      candidates: $candidates,
      created_task_ids: $created_task_ids
    }' > "$report_file"

  echo "Skills evolution report written to $report_file"
  return 0
}

# Full automatic skills evolution pipeline
# Called at the end of kanban_archive_task() (after archiving completes)
# Input: task_id
skills_evolve_auto() {
  local task_id="$1"

  # Check if skills evolution is enabled
  local enabled=$(jq -r 'if .skills_evolution.enabled == false then "false" else "true" end' "$KANBAN_DIR/config.json" 2>/dev/null || echo "true")
  if [ "$enabled" = "false" ]; then
    echo "INFO: skills_evolution disabled in config.json"
    return 0
  fi

  # Determine the iteration (task is archived, so read from archive)
  local tf=$(archive_task_file "$task_id")
  if [ ! -f "$tf" ]; then
    tf=$(task_file "$task_id")
  fi
  [ ! -f "$tf" ] && { echo "WARNING: cannot find task file for $task_id, skipping skills evolution"; return 0; }

  local iter=$(jq -r '.iteration // 1' "$tf")

  echo "=== Skills Evolution Auto (task: $task_id, iteration: $iter) ==="

  # Step 1: Extract
  local extract_output
  extract_output=$(skills_evolve_extract "$task_id" "$iter" 2>&1)
  echo "$extract_output"

  # Count extracted candidates for this specific task/iteration
  local candidates_dir="$KANBAN_DIR/skills/evolved"
  local extracted_count=0
  if [ -d "$candidates_dir" ]; then
    for candidate_file in "$candidates_dir"/candidate-*.json; do
      [ -f "$candidate_file" ] || continue
      local c_task=$(jq -r '.source_task // ""' "$candidate_file")
      local c_iter=$(jq -r '.source_iteration // 0' "$candidate_file")
      if [ "$c_task" = "$task_id" ] && [ "$c_iter" = "$iter" ]; then
        extracted_count=$((extracted_count + 1))
      fi
    done
  fi

  # Step 2: Apply
  local apply_output
  apply_output=$(skills_evolve_apply "$task_id" 2>&1)
  echo "$apply_output"

  # Parse apply results
  local applied_count=$(echo "$apply_output" | grep -o -- 'Applied [0-9]*' | grep -o '[0-9]*' || echo "0")
  : "${applied_count:=0}"
  local created_task_ids_str=$(echo "$apply_output" | grep -- "CREATED_TASKS:" | sed 's/CREATED_TASKS://' || echo "")

  # Step 3: Report
  skills_evolve_report "$task_id" "$iter" "$extracted_count" "$applied_count" "$created_task_ids_str"

  echo "=== Skills Evolution Complete ==="
  return 0
}

# Show history of skills evolution
# Scans .kanban/skills/evolved/ for applied candidates
skills_evolve_show_history() {
  local candidates_dir="$KANBAN_DIR/skills/evolved"
  [ ! -d "$candidates_dir" ] && { echo "No skills evolution history found"; return 0; }

  echo "=== Skills Evolution History ==="
  echo ""

  local total=0
  local applied=0
  local pending=0
  local by_category=""

  for candidate_file in "$candidates_dir"/candidate-*.json; do
    [ -f "$candidate_file" ] || continue
    total=$((total + 1))

    local status=$(jq -r '.status // "unknown"' "$candidate_file")
    local category=$(jq -r '.category // "unknown"' "$candidate_file")
    local description=$(jq -r '.description // ""' "$candidate_file" | head -c 80)
    local source_task=$(jq -r '.source_task // ""' "$candidate_file")
    local cid=$(jq -r '.id // ""' "$candidate_file")
    local applied_at=$(jq -r '.applied_at // ""' "$candidate_file")
    local created_task=$(jq -r '.created_task // ""' "$candidate_file")

    if [ "$status" = "applied" ]; then
      applied=$((applied + 1))
      echo "  [APPLIED] $cid ($category) from $source_task"
      echo "    $description"
      if [ -n "$created_task" ]; then
        echo "    -> Created task: $created_task"
      fi
      if [ -n "$applied_at" ]; then
        echo "    Applied at: $applied_at"
      fi
    else
      pending=$((pending + 1))
      echo "  [PENDING] $cid ($category) from $source_task"
      echo "    $description"
    fi
    echo ""
  done

  echo "Total: $total (Applied: $applied, Pending: $pending)"
  return 0
}

# Legacy interface -- now delegates to the auto or history functions
# /kanban evolve-skills calls this with no args (show history)
# /kanban evolve-skills --confirm is removed (auto now)
self_improve_evolve_skills() {
  local task_id="$1"
  local mode="${2:---list}"

  if [ "$mode" = "--confirm" ]; then
    # Backward compat: --confirm now triggers auto evolution
    skills_evolve_auto "$task_id"
    return $?
  fi

  # Default (--list or no args): show history
  skills_evolve_show_history
  return 0
}

# === ST-015: 框架自评估 ===
# framework_self_assess(task_id)
# 在归档前调用，执行框架自我评估
# 读取当前任务的 execution_pitfalls.md 和 execution_decisions.md
# 检查框架规则完整性、agent 能力覆盖、shell 函数质量
# 输出 JSON 报告到 report_dir，不阻塞归档
# FR-008: Enhanced to produce actionable suggestions with theme classification,
# specific pitfall/decision references, and suggested improvement types.
# 返回: 0=成功 (始终成功，评估不阻塞归档)
framework_self_assess() {
  local task_id="$1"

  # 检查是否启用框架评估
  local enabled=$(jq -r 'if .framework_assessment.enabled == false then "false" else "true" end' "$KANBAN_DIR/config.json" 2>/dev/null || echo "true")
  if [ "$enabled" = "false" ]; then
    echo "INFO: framework_assessment disabled in config.json"
    return 0
  fi

  # 读取 task 信息
  local tf=$(task_file "$task_id")
  if [ ! -f "$tf" ]; then
    # 可能是归档后的任务
    tf=$(archive_task_file "$task_id")
  fi
  [ ! -f "$tf" ] && { echo "WARNING: cannot find task file for $task_id"; return 0; }

  local iter=$(jq -r '.iteration // 1' "$tf")
  local title=$(jq -r '.title // ""' "$tf")
  local rdir=$(report_dir "$task_id" "$iter")

  # Archive path fallback (same pattern as skills_evolve_extract)
  if [ ! -d "$rdir" ]; then
    local archive_rdir="$KANBAN_DIR/archive/${task_id}/iteration-${iter}"
    if [ -d "$archive_rdir" ]; then
      rdir="$archive_rdir"
    fi
  fi

  # 确保报告目录存在
  mkdir -p "$rdir"

  local improvements="[]"
  local assessment_score=0

  # === 维度1: 规则完善度 ===
  # 检查 .claude/rules/ 是否覆盖已知坑点
  local rules_dir=".claude/rules"
  local rules_count=0
  if [ -d "$rules_dir" ]; then
    rules_count=$(ls "$rules_dir"/*.md 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "$rules_count" -lt 3 ]; then
    improvements=$(echo "$improvements" | jq '. + ["Consider adding more .claude/rules/ to cover known patterns"]')
  fi

  # === 维度2: execution_pitfalls.md 中的改进点 (enhanced FR-008) ===
  local pitfalls_file="$rdir/execution_pitfalls.md"
  local suggestions="[]"
  if [ -f "$pitfalls_file" ]; then
    # Extract specific theme clusters from pitfalls
    local set_e_count=$(grep -ci -- "set -e\|set -euo\|errexit\|non-zero.*return\|返回值" "$pitfalls_file" 2>/dev/null || true)
    [ -z "$set_e_count" ] && set_e_count=0
    if [ "$set_e_count" -gt 0 ] 2>/dev/null; then
      suggestions=$(echo "$suggestions" | jq --argjson count "$set_e_count" \
        '. + [{type: "enhancement", theme: "set -e safety", description: ("Found " + ($count | tostring) + " pitfalls related to set -e/non-zero returns. Consider adding a defensive coding rule."), target_files: [".claude/skills/kanban/lib/"]}]')
    fi

    local path_count=$(grep -ci -- "path.*resolut\|路径.*解析\|PROJECT_ROOT\|KANBAN_ROOT\|absolute.*path" "$pitfalls_file" 2>/dev/null || true)
    [ -z "$path_count" ] && path_count=0
    if [ "$path_count" -gt 0 ] 2>/dev/null; then
      suggestions=$(echo "$suggestions" | jq --argjson count "$path_count" \
        '. + [{type: "bug_fix", theme: "path resolution", description: ("Found " + ($count | tostring) + " pitfalls related to path resolution. Unify all path handling to use helper functions."), target_files: [".claude/skills/kanban/lib/kanban.sh", ".claude/skills/kanban/dashboard/server.js"]}]')
    fi

    local cross_plat_count=$(grep -ci -- "cross.platform\|macOS\|Linux\|BSD\|GNU\|兼容" "$pitfalls_file" 2>/dev/null || true)
    [ -z "$cross_plat_count" ] && cross_plat_count=0
    if [ "$cross_plat_count" -gt 0 ] 2>/dev/null; then
      suggestions=$(echo "$suggestions" | jq --argjson count "$cross_plat_count" \
        '. + [{type: "enhancement", theme: "cross-platform compatibility", description: ("Found " + ($count | tostring) + " pitfalls related to cross-platform issues. Consider adding a portability check rule."), target_files: [".claude/skills/kanban/lib/"]}]')
    fi

    # Generic framework pitfalls count (backward compatible)
    local framework_pitfalls=$(grep -ci -- "框架\|framework\|kanban\|guard\|worktree" "$pitfalls_file" 2>/dev/null || true)
    [ -z "$framework_pitfalls" ] && framework_pitfalls=0
    if [ "$framework_pitfalls" -gt 0 ] 2>/dev/null; then
      improvements=$(echo "$improvements" | jq --argjson count "$framework_pitfalls" \
        '. + ["Task had " + ($count | tostring) + " framework-related pitfalls worth reviewing"]')
    fi
  fi

  # === 维度3: execution_decisions.md 中的决策 (enhanced FR-008) ===
  local decisions_file="$rdir/execution_decisions.md"
  if [ -f "$decisions_file" ]; then
    local decision_count=$(grep -c -- "^###\|^##\|^-" "$decisions_file" 2>/dev/null || true)
    [ -z "$decision_count" ] && decision_count=0
    if [ "$decision_count" -gt 3 ] 2>/dev/null; then
      improvements=$(echo "$improvements" | jq --argjson count "$decision_count" \
        '. + ["Task had " + ($count | tostring) + " decisions that may inform framework evolution"]')
    fi

    # Classify decisions as workaround vs permanent fix
    local workaround_count=$(grep -ci -- "workaround\|临时\|暂时\|hack\|绕过" "$decisions_file" 2>/dev/null || true)
    [ -z "$workaround_count" ] && workaround_count=0
    if [ "$workaround_count" -gt 0 ] 2>/dev/null; then
      suggestions=$(echo "$suggestions" | jq --argjson count "$workaround_count" \
        '. + [{type: "refactoring", theme: "workaround consolidation", description: ("Found " + ($count | tostring) + " workaround decisions that should be generalized into permanent fixes."), target_files: [".claude/skills/kanban/lib/"]}]')
    fi
  fi

  # === 维度4: lib/ 脚本函数质量检查 ===
  local lib_dir=".claude/skills/kanban/lib"
  if [ -d "$lib_dir" ]; then
    # 检查是否有未使用 task_file helper 的硬编码路径
    local hardcoded_count=$(grep -r -- 'tasks/${task_id}.json\|tasks/\$task_id.json' "$lib_dir"/*.sh 2>/dev/null | grep -v -- 'task_file\|#.*旧格式\|旧格式兼容\|old_file=' | wc -l | tr -d ' ')
    if [ "$hardcoded_count" -gt 0 ]; then
      improvements=$(echo "$improvements" | jq --argjson count "$hardcoded_count" \
        '. + ["Found " + ($count | tostring) + " hardcoded task paths in lib/ scripts"]')
    fi
  fi

  # === 维度5: knowledge-log.md 检查 ===
  local knowledge_file="$KANBAN_DIR/knowledge-log.md"
  if [ -f "$knowledge_file" ]; then
    local knowledge_count=$(grep -c -- "^### K[0-9]" "$knowledge_file" 2>/dev/null || true)
    [ -z "$knowledge_count" ] && knowledge_count=0
    assessment_score=$((assessment_score + 5))
  else
    improvements=$(echo "$improvements" | jq '. + ["knowledge-log.md not found - knowledge may be lost"]')
  fi

  # === 维度6: workflow.json 配置完整性 ===
  if [ -f "$KANBAN_DIR/workflow.json" ]; then
    local has_quality_gate=$(jq '.phases[] | select(.id=="plan") | .quality_gate' "$KANBAN_DIR/workflow.json" 2>/dev/null)
    if [ -n "$has_quality_gate" ] && [ "$has_quality_gate" != "null" ]; then
      assessment_score=$((assessment_score + 5))
    else
      improvements=$(echo "$improvements" | jq '. + ["Plan quality gate not configured in workflow.json"]')
    fi
  fi

  # 计算总评估分
  assessment_score=$((assessment_score + 10))  # 基础分

  # 写入评估报告 (enhanced: include actionable suggestions)
  local report_file="$rdir/framework_assessment.json"
  jq -n \
    --arg task_id "$task_id" \
    --arg title "$title" \
    --argjson iter "$iter" \
    --argjson score "$assessment_score" \
    --argjson improvements "$improvements" \
    --argjson suggestions "$suggestions" \
    --arg assessed_at "$(date -u +%FT%TZ)" \
    '{
      task_id: $task_id,
      task_title: $title,
      iteration: $iter,
      assessment_score: $score,
      max_score: 20,
      improvements: $improvements,
      improvement_count: ($improvements | length),
      suggestions: $suggestions,
      suggestion_count: ($suggestions | length),
      assessed_at: $assessed_at
    }' > "$report_file"

  local suggestion_count=$(echo "$suggestions" | jq 'length')
  echo "Framework assessment complete for $task_id: score=$assessment_score/20, improvements=$(echo "$improvements" | jq 'length'), suggestions=$suggestion_count"

  # 如果发现改进点，记录到 knowledge-log
  local improvement_count=$(echo "$improvements" | jq 'length')
  if [ "$improvement_count" -gt 0 ] && type kanban_knowledge_add >/dev/null 2>&1; then
    kanban_knowledge_add "framework_assessment" "Task $task_id: $improvement_count framework improvement points identified" "$task_id" 2>/dev/null || true
  fi

  # 注意: 不在此处创建任务。skills_evolve_auto 会从 pitfalls/decisions 中提取改进并创建任务。
  # 此处仅记录改进点到 knowledge-log，避免与 skills_evolve_auto 重复创建任务。

  return 0
}
