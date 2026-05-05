#!/usr/bin/env bash
# evaluator.sh — 评估调度
# 依赖: jq

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"
# Fix 1: Use BASH_SOURCE[0] for reliable SKILL_DIR derivation (matches kanban.sh pattern)
# Falls back to $0 only if BASH_SOURCE is unavailable (e.g., non-bash shells)
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
elif [ -n "${0:-}" ] && [ "${0:-}" != "$BASH" ] && [ "${0:-}" != "-bash" ]; then
  SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
else
  SKILL_DIR="${SKILL_DIR:-.claude/skills/kanban}"
fi

# 评估入口: 为每个角色准备调度上下文
evaluator_prepare_all() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local iter=$(jq -r '.iteration // 1' "$tf")
  local rdir=$(report_dir "$task_id" "$iter")
  local wt_path=$(jq -r '.worktree.path // ""' "$tf")
  local title=$(jq -r '.title' "$tf")
  local desc=$(jq -r '.description // ""' "$tf")
  local output_dir=$(jq -r '.output_dir // "src"' "$KANBAN_DIR/config.json")

  mkdir -p "$rdir"

  local ddir=$(dispatch_dir "$task_id")
  mkdir -p "$ddir"

  for role in code_reviewer qa pm designer; do
    # Bug #4 fix: map role name with underscores to template filename with hyphens
    local template_role=$(echo "$role" | tr '_' '-')
    local template="$SKILL_DIR/templates/reports/${template_role}.json"
    local dispatch_file="$ddir/${task_id}-${role}.json"

    jq -n \
      --arg role "$role" \
      --arg task_id "$task_id" \
      --arg title "$title" \
      --arg desc "$desc" \
      --arg iter "$iter" \
      --arg wt_path "$wt_path" \
      --arg report_dir "$rdir" \
      --arg report_file "${rdir}/${role}_report.json" \
      --arg output_dir "$output_dir" \
      --argjson template "$(cat "$template")" \
      '{
        role: $role,
        task_id: $task_id,
        task_title: $title,
        task_description: $desc,
        iteration: ($iter | tonumber),
        worktree_path: $wt_path,
        output_dir: $output_dir,
        report_dir: $report_dir,
        report_file: $report_file,
        required_fields: $template.required_fields,
        schema: $template.schema
      }' > "$dispatch_file"

    echo "Prepared: $role -> $dispatch_file"
  done
}

# 检查是否全部通过 (≥ pass_threshold)
evaluator_check_pass() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local threshold=$(jq -r '.phases[2].pass_threshold // 9.0' "$KANBAN_DIR/workflow.json")

  for role in code_reviewer qa pm designer; do
    local score=$(jq -r ".scores.${role}.score // 0" "$tf")
    if [ "$(echo "$score < $threshold" | bc 2>/dev/null || echo 1)" = "1" ]; then
      echo "FAIL:${role}:score=${score}<${threshold}"
      return 1
    fi
  done
  echo "PASS"
  return 0
}

# 汇总当前轮评分
evaluator_collect_scores() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  echo "=== $task_id Scores ==="
  local sum=0 count=0
  for role in code_reviewer qa pm designer; do
    local score=$(jq -r ".scores.${role}.score // \"N/A\"" "$tf")
    local passed=$(jq -r ".scores.${role}.passed // false" "$tf")
    echo "  ${role}: ${score} (${passed})"
    if [[ "$score" != "N/A" && "$score" != "null" ]]; then
      sum=$(echo "$sum + $score" | bc 2>/dev/null || echo "0")
      count=$((count + 1))
    fi
  done

  # 评分汇总行: 显示4角色平均分
  if [[ $count -gt 0 ]]; then
    local avg=$(echo "scale=2; $sum / $count" | bc 2>/dev/null || echo "N/A")
    echo "  ---"
    echo "  Average: ${avg} (${count}/4 roles scored)"
  fi
}

# 将评估结果写入 task JSON
evaluator_record_score() {
  local task_id="$1"
  local role="$2"
  local report_file="$3"

  [ ! -f "$report_file" ] && { echo "ERROR: report not found: $report_file"; return 1; }

  # Fix 7: Read .average_score from report (evaluation reports use average_score),
  # fallback to .score for backward compatibility
  local score=$(jq -r '.average_score // .score // 0' "$report_file")
  local threshold=$(jq -r '.phases[2].pass_threshold // 9.0' "$KANBAN_DIR/workflow.json")
  local passed="false"
  [ "$(echo "$score >= $threshold" | bc 2>/dev/null || echo 0)" = "1" ] && passed="true"

  kanban_update_task "$task_id" \
    ".scores.${role}={score:${score}, passed:${passed}, report:\"${report_file}\"}"

  # 追加评分快照到 history 数组
  local tf=$(task_file "$task_id")
  local iter=$(jq -r '.iteration // 1' "$tf")
  local now=$(date -u +%FT%TZ)
  local tmp=$(mktemp)
  jq --arg role "$role" \
     --argjson score "$score" \
     --arg iter "$iter" \
     --arg now "$now" \
     '.history += [{
       "event": "score_recorded",
       "phase": "evaluate",
       "iteration": ($iter | tonumber),
       "role": $role,
       "score": $score,
       "timestamp": $now
     }]' "$tf" > "$tmp" && mv "$tmp" "$tf"

  echo "Recorded: ${role} = ${score} (${passed})"
}
