#!/usr/bin/env bash
# nlp_router.sh -- Natural language command parsing for kanban
# Provides kanban_nl_parse and helpers to translate free-form user input
# into structured kanban commands based on keyword matching against
# the data-driven nlp_patterns.json configuration.
# Dependencies: jq, awk, bash 4.0+

# Prevent double-loading
[ -n "${_KANBAN_NLP_ROUTER_LOADED:-}" ] && return 0
_KANBAN_NLP_ROUTER_LOADED=1

# Resolve SKILL_DIR from BASH_SOURCE (same convention as kanban.sh)
_NLP_SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Cache variable for loaded patterns JSON
_KANBAN_NLP_PATTERNS_CACHE=""

# === kanban_nl_load_patterns ===
# Loads nlp_patterns.json from lib/ directory.
# Uses caching to avoid repeated file reads.
# Output: the JSON content of nlp_patterns.json (to stdout)
# Returns: 0 on success, 1 if file missing or invalid JSON
kanban_nl_load_patterns() {
  # Return cached content if available
  if [ -n "$_KANBAN_NLP_PATTERNS_CACHE" ]; then
    echo "$_KANBAN_NLP_PATTERNS_CACHE"
    return 0
  fi

  local patterns_file="$_NLP_SKILL_DIR/lib/nlp_patterns.json"

  # Check file exists
  if [ ! -f "$patterns_file" ]; then
    echo "ERROR: nlp_patterns.json not found at $patterns_file" >&2
    return 1
  fi

  # Validate it is parseable JSON
  local content
  content=$(jq '.' "$patterns_file" 2>/dev/null)
  if [ $? -ne 0 ] || [ -z "$content" ]; then
    echo "ERROR: nlp_patterns.json contains invalid JSON" >&2
    return 1
  fi

  # Cache and output
  _KANBAN_NLP_PATTERNS_CACHE="$content"
  echo "$_KANBAN_NLP_PATTERNS_CACHE"
  return 0
}

# === kanban_nl_extract_task_id ===
# Extracts a TASK-NNN formatted task ID from user input.
# Supports:
#   - Standard: TASK-001, TASK-026
#   - Numeric with context: "任务1" -> TASK-001, "1号任务" -> TASK-001
#   - Ordinal: "第3个任务" -> TASK-003, "3 号" -> TASK-003
#   - Chinese number: "任务一" -> TASK-001, "二十六号" -> TASK-026
#   - Bare number near task keyword: "跑一下26" -> TASK-026
# Arguments:
#   $1 -- user input string
# Output: TASK-NNN string, or empty string if not found
kanban_nl_extract_task_id() {
  local input="$1"
  [ -z "$input" ] && return 0

  local lower
  lower=$(echo "$input" | tr '[:upper:]' '[:lower:]')

  # 1. Standard TASK-NNN pattern (highest priority)
  local standard_id
  standard_id=$(echo "$lower" | grep -oE 'task-[0-9]{1,3}' | head -1)
  if [ -n "$standard_id" ]; then
    local num
    num=$(echo "$standard_id" | sed 's/task-//')
    num=$((10#$num))
    printf "TASK-%03d" "$num"
    return 0
  fi

  # 2. Chinese number mapping (from nlp_patterns.json)
  local patterns
  patterns=$(kanban_nl_load_patterns) || return 1

  # Check for Chinese number patterns like "二十六号", "任务三", "一号任务"
  # Try longer Chinese numbers first (e.g., "二十六" before "二" and "十")
  local zh_mappings
  zh_mappings=$(echo "$patterns" | jq -r '.task_id_patterns.chinese_number.mappings // {} | to_entries | sort_by(-.value) | .[] | "\(.key)=\(.value)"' 2>/dev/null)

  if [ -n "$zh_mappings" ]; then
    while IFS='=' read -r zh_name zh_val; do
      [ -z "$zh_name" ] && continue
      # Check patterns: "任务{zh}", "{zh}号", "第{zh}个", "{zh}号任务"
      if echo "$input" | grep -qE "(任务${zh_name}|${zh_name}号|第${zh_name}|${zh_name}任务)"; then
        printf "TASK-%03d" "$zh_val"
        return 0
      fi
    done <<< "$zh_mappings"
  fi

  # 3. Ordinal/numeric expressions
  local numeric_match=""

  # "第N号" or "第N个任务" or "第N 个"
  numeric_match=$(echo "$input" | grep -oE '第([0-9]{1,3})[号个]' | grep -oE '[0-9]{1,3}' | head -1)
  if [ -n "$numeric_match" ]; then
    printf "TASK-%03d" "$((10#$numeric_match))"
    return 0
  fi

  # "N号任务" or "N号" or "N 号" (with optional space)
  numeric_match=$(echo "$input" | grep -oE '[0-9]{1,3}[[:space:]]*号' | grep -oE '[0-9]{1,3}' | head -1)
  if [ -n "$numeric_match" ]; then
    printf "TASK-%03d" "$((10#$numeric_match))"
    return 0
  fi

  # "任务N"  (task followed by digits)
  numeric_match=$(echo "$input" | grep -oE '任务([0-9]{1,3})' | grep -oE '[0-9]{1,3}' | head -1)
  if [ -n "$numeric_match" ]; then
    printf "TASK-%03d" "$((10#$numeric_match))"
    return 0
  fi

  # 4. Bare number with task-related context keywords nearby
  local task_keywords="任务|task|归档|跑|运行|执行|启动|查看|show|run|score|summary|decide"
  if echo "$lower" | grep -qE "$task_keywords"; then
    numeric_match=$(echo "$lower" | grep -oE '(^|[^a-z0-9])([0-9]{1,3})([^0-9]|$)' | grep -oE '[0-9]{1,3}' | head -1)
    if [ -n "$numeric_match" ] && [ "$numeric_match" -le 999 ]; then
      printf "TASK-%03d" "$((10#$numeric_match))"
      return 0
    fi
  fi

  # No task ID found
  return 0
}

# === kanban_nl_classify_intent ===
# Identifies user intent by matching input against nlp_patterns.json keywords.
# Matching priority: exact > synonyms > fuzzy
# Arguments:
#   $1 -- user input string (already lowercased is recommended but not required)
# Output: JSON object { "command": "...", "confidence": N, "match_type": "exact|synonym|fuzzy", "args": {} }
#         or { "command": null, "confidence": 0.0 } if no match
kanban_nl_classify_intent() {
  local input="$1"
  [ -z "$input" ] && { echo '{"command":null,"confidence":0.0,"match_type":"none","args":{}}'; return 0; }

  local lower
  lower=$(echo "$input" | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]\+/ /g' | sed 's/^ *//;s/ *$//')

  local patterns
  patterns=$(kanban_nl_load_patterns) || { echo '{"command":null,"confidence":0.0,"match_type":"none","args":{}}'; return 1; }

  # Read confidence rules from patterns
  local exact_conf synonym_conf fuzzy_conf
  exact_conf=$(echo "$patterns" | jq -r '._meta.confidence_rules.exact_match // 1.0')
  synonym_conf=$(echo "$patterns" | jq -r '._meta.confidence_rules.synonym_match // 0.8')
  fuzzy_conf=$(echo "$patterns" | jq -r '._meta.confidence_rules.fuzzy_match // 0.6')

  local best_command=""
  local best_confidence=0
  local best_match_type="none"
  local best_args="{}"

  # Get list of commands
  local commands
  commands=$(echo "$patterns" | jq -r '.commands | keys[]')

  for cmd in $commands; do
    local cmd_data
    cmd_data=$(echo "$patterns" | jq --arg c "$cmd" '.commands[$c]')

    # --- Exact match: full string equality gives highest confidence ---
    local exact_keywords
    exact_keywords=$(echo "$cmd_data" | jq -r '.keywords.exact[]? // empty')
    while IFS= read -r kw; do
      [ -z "$kw" ] && continue
      local kw_lower
      kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
      if [ "$lower" = "$kw_lower" ]; then
        # Full exact match is definitive
        best_command="$cmd"
        best_confidence="$exact_conf"
        best_match_type="exact"
        best_args="{}"
        break 2
      fi
      # Partial exact: exact keyword is a substring of input
      # This gives exact_conf but only if no higher match exists yet
      if _nlp_string_contains "$lower" "$kw_lower"; then
        if _nlp_is_higher_confidence "$exact_conf" "$best_confidence"; then
          best_command="$cmd"
          best_confidence="$exact_conf"
          best_match_type="exact"
          best_args="{}"
        fi
      fi
    done <<< "$exact_keywords"

    # --- Synonym match: keyword is contained in input ---
    local synonym_keywords
    synonym_keywords=$(echo "$cmd_data" | jq -r '.keywords.synonyms[]? // empty')
    while IFS= read -r kw; do
      [ -z "$kw" ] && continue
      local kw_lower
      kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
      if _nlp_string_contains "$lower" "$kw_lower"; then
        if _nlp_is_higher_confidence "$synonym_conf" "$best_confidence"; then
          best_command="$cmd"
          best_confidence="$synonym_conf"
          best_match_type="synonym"
          best_args="{}"
        fi
      fi
    done <<< "$synonym_keywords"

    # --- Fuzzy match: keyword is contained in input (lowest priority) ---
    local fuzzy_keywords
    fuzzy_keywords=$(echo "$cmd_data" | jq -r '.keywords.fuzzy[]? // empty')
    while IFS= read -r kw; do
      [ -z "$kw" ] && continue
      local kw_lower
      kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
      if _nlp_string_contains "$lower" "$kw_lower"; then
        if _nlp_is_higher_confidence "$fuzzy_conf" "$best_confidence"; then
          best_command="$cmd"
          best_confidence="$fuzzy_conf"
          best_match_type="fuzzy"
          best_args="{}"
        fi
      fi
    done <<< "$fuzzy_keywords"

    # --- Sub-action keyword match (for commands like decide) ---
    # Sub-action keywords can also help identify the parent command
    local has_subactions
    has_subactions=$(echo "$cmd_data" | jq -r '.subcommands.action // empty')
    if [ -n "$has_subactions" ] && [ "$has_subactions" != "null" ] && [ "$has_subactions" != "{}" ]; then
      local sub_actions
      sub_actions=$(echo "$cmd_data" | jq -r '.subcommands.action | keys[]')
      for sa in $sub_actions; do
        local sa_data
        sa_data=$(echo "$cmd_data" | jq --arg sa "$sa" '.subcommands.action[$sa]')
        # Check all keyword levels in sub-action
        for kw_type in exact synonyms fuzzy; do
          local sa_kws
          sa_kws=$(echo "$sa_data" | jq -r --arg kt "$kw_type" '.keywords[$kt][]? // empty')
          while IFS= read -r kw; do
            [ -z "$kw" ] && continue
            local kw_lower
            kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
            if _nlp_string_contains "$lower" "$kw_lower"; then
              # Sub-action match gives synonym-level confidence
              if _nlp_is_higher_confidence "$synonym_conf" "$best_confidence"; then
                best_command="$cmd"
                best_confidence="$synonym_conf"
                best_match_type="synonym"
                best_args="{}"
              fi
            fi
          done <<< "$sa_kws"
        done
      done
    fi
  done

  # No match found at all
  if [ -z "$best_command" ]; then
    echo '{"command":null,"confidence":0.0,"match_type":"none","args":{}}'
    return 0
  fi

  # --- Sub-command classification for decide ---
  if [ "$best_command" = "decide" ]; then
    local decide_action="approve_and_archive"  # default action
    local actions="approve_and_archive restart_from_plan restart_from_execute abort"
    for action in $actions; do
      local action_data
      action_data=$(echo "$patterns" | jq --arg a "$action" '.commands.decide.subcommands.action[$a]')
      [ "$action_data" = "null" ] && continue

      # Check exact
      local act_exact
      act_exact=$(echo "$action_data" | jq -r '.keywords.exact[]? // empty')
      while IFS= read -r kw; do
        [ -z "$kw" ] && continue
        local kw_lower
        kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
        if _nlp_string_contains "$lower" "$kw_lower"; then
          decide_action="$action"
          break 2
        fi
      done <<< "$act_exact"

      # Check synonyms
      local act_synonyms
      act_synonyms=$(echo "$action_data" | jq -r '.keywords.synonyms[]? // empty')
      while IFS= read -r kw; do
        [ -z "$kw" ] && continue
        local kw_lower
        kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
        if _nlp_string_contains "$lower" "$kw_lower"; then
          decide_action="$action"
          break 2
        fi
      done <<< "$act_synonyms"

      # Check fuzzy
      local act_fuzzy
      act_fuzzy=$(echo "$action_data" | jq -r '.keywords.fuzzy[]? // empty')
      while IFS= read -r kw; do
        [ -z "$kw" ] && continue
        local kw_lower
        kw_lower=$(echo "$kw" | tr '[:upper:]' '[:lower:]')
        if _nlp_string_contains "$lower" "$kw_lower"; then
          decide_action="$action"
          break 2
        fi
      done <<< "$act_fuzzy"
    done

    best_args=$(echo "$best_args" | jq --arg a "$decide_action" '. + {action: $a}')
  fi

  # --- Sub-command classification for dashboard ---
  if [ "$best_command" = "dashboard" ]; then
    local dash_sub="start"  # default
    local sub_commands="start stop status restart"
    for sub in $sub_commands; do
      local sub_kws
      sub_kws=$(echo "$patterns" | jq --arg s "$sub" -r '.commands.dashboard.subcommands.subcommand[$s].keywords[]? // empty')
      while IFS= read -r kw; do
        [ -z "$kw" ] && continue
        if _nlp_string_contains "$lower" "$(echo "$kw" | tr '[:upper:]' '[:lower:]')"; then
          dash_sub="$sub"
          break 2
        fi
      done <<< "$sub_kws"
    done
    best_args=$(echo "$best_args" | jq --arg s "$dash_sub" '. + {subcommand: $s}')
  fi

  # --- Sub-command classification for version ---
  if [ "$best_command" = "version" ]; then
    local ver_sub="list"  # default
    local record_kws
    record_kws=$(echo "$patterns" | jq -r '.commands.version.subcommands.subcommand.record.keywords[]? // empty')
    while IFS= read -r kw; do
      [ -z "$kw" ] && continue
      if _nlp_string_contains "$lower" "$(echo "$kw" | tr '[:upper:]' '[:lower:]')"; then
        ver_sub="record"
        break
      fi
    done <<< "$record_kws"

    best_args=$(echo "$best_args" | jq --arg s "$ver_sub" '. + {subcommand: $s}')

    # Extract version string if record subcommand
    if [ "$ver_sub" = "record" ]; then
      local ver_str
      ver_str=$(echo "$input" | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1)
      if [ -n "$ver_str" ]; then
        best_args=$(echo "$best_args" | jq --arg v "$ver_str" '. + {version: $v}')
      fi
    fi
  fi

  # --- Sub-command classification for run phase ---
  if [ "$best_command" = "run" ]; then
    local phase_data
    phase_data=$(echo "$patterns" | jq -r '.commands.run.subcommands.phase // {}')
    local phases="plan execute evaluate"
    for phase in $phases; do
      local phase_kws
      phase_kws=$(echo "$phase_data" | jq --arg p "$phase" -r '.[$p][]? // empty')
      while IFS= read -r kw; do
        [ -z "$kw" ] && continue
        if _nlp_string_contains "$lower" "$(echo "$kw" | tr '[:upper:]' '[:lower:]')"; then
          best_args=$(echo "$best_args" | jq --arg p "$phase" '. + {phase: $p}')
          break 2
        fi
      done <<< "$phase_kws"
    done
  fi

  # --- Extract title for create command ---
  if [ "$best_command" = "create" ]; then
    local title=""

    # Strategy 1: Check for quoted content first ("..." or '...' or 「...」)
    title=$(echo "$input" | grep -oE '"[^"]+"' | head -1 | sed 's/^"//;s/"$//')
    if [ -z "$title" ]; then
      title=$(echo "$input" | grep -oE "'[^']+'" | head -1 | sed "s/^'//;s/'$//")
    fi
    if [ -z "$title" ]; then
      title=$(echo "$input" | grep -oE '「[^」]+」' | head -1 | sed 's/^「//;s/」$//')
    fi

    # Strategy 2: Check for Chinese explicit markers (叫做, 名为, 名称是, 叫, 名字是)
    if [ -z "$title" ]; then
      title=$(echo "$input" | sed -E -n 's/.*(叫做|名为|名称是|名字是)(.*)/\2/p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    fi

    # Strategy 3: Keyword stripping for patterns like "创建任务 XXX", "新建任务 XXX"
    if [ -z "$title" ]; then
      title=$(echo "$input" | sed -E 's/.*((创建|新建|添加|帮我创建|帮我新建|加个|开个|开一个|建个)任务?)[[:space:]]*//; s/.*((create|new task|add task)[[:space:]]*)//; s/.*((帮我|我要)(创建|新建|建))//; s/^[[:space:]]+//; s/[[:space:]]+$//')
    fi

    if [ -n "$title" ]; then
      best_args=$(echo "$best_args" | jq --arg t "$title" '. + {title: $t}')
    fi
  fi

  # Build output JSON
  jq -n \
    --arg cmd "$best_command" \
    --argjson conf "$best_confidence" \
    --arg mt "$best_match_type" \
    --argjson args "$best_args" \
    '{command: $cmd, confidence: $conf, match_type: $mt, args: $args}'
}

# === kanban_nl_build_command ===
# Constructs a standardized kanban command JSON from classified intent,
# extracted task_id, and original input.
# Arguments:
#   $1 -- intent JSON (output from kanban_nl_classify_intent)
#   $2 -- task_id string (e.g., "TASK-001" or "")
#   $3 -- original user input string
# Output: JSON object with the full structured result
kanban_nl_build_command() {
  local intent_json="$1"
  local task_id="${2:-}"
  local original_input="$3"

  local command
  command=$(echo "$intent_json" | jq -r '.command')
  local confidence
  confidence=$(echo "$intent_json" | jq -r '.confidence')
  local args
  args=$(echo "$intent_json" | jq -c '.args // {}')

  # Check if command was identified
  if [ "$command" = "null" ] || [ -z "$command" ]; then
    # No command identified -- build failure response
    local fallback_msg
    fallback_msg=$(kanban_nl_load_patterns | jq -r '.fallback.unrecognized_input.message // "Unable to recognize your intent."')

    local available_cmds
    available_cmds=$(kanban_nl_load_patterns | jq -c '.fallback.unrecognized_input.available_commands // []')

    jq -n \
      --arg msg "$fallback_msg" \
      --argjson cmds "$available_cmds" \
      --arg orig "$original_input" \
      '{
        success: false,
        command: null,
        task_id: null,
        action: null,
        args: {},
        confidence: 0.0,
        original_input: $orig,
        suggestion: ($msg + " " + ($cmds | map("  " + .) | join("\n")))
      }'
    return 0
  fi

  # Determine if task_id is required for this command
  local patterns
  patterns=$(kanban_nl_load_patterns)
  local tid_required
  tid_required=$(echo "$patterns" | jq --arg c "$command" -r '.commands[$c].task_id_required // false')

  local action=""
  local suggestion=""

  # Extract action from args if present (for decide subcommands)
  local args_action
  args_action=$(echo "$args" | jq -r '.action // ""')
  if [ -n "$args_action" ]; then
    action="$args_action"
    # Remove action from generic args
    args=$(echo "$args" | jq 'del(.action)')
  fi

  # Extract subcommand from args if present (for dashboard/version)
  local subcommand
  subcommand=$(echo "$args" | jq -r '.subcommand // ""')
  if [ -n "$subcommand" ]; then
    args=$(echo "$args" | jq 'del(.subcommand)')
  fi

  # Extract phase from args if present (for run)
  local phase
  phase=$(echo "$args" | jq -r '.phase // ""')
  if [ -n "$phase" ]; then
    args=$(echo "$args" | jq 'del(.phase)')
  fi

  # Build the standardized command string
  local std_command="$command"

  # For decide, embed action into the command representation
  if [ "$command" = "decide" ] && [ -n "$action" ]; then
    std_command="decide --action $action"
  fi

  # For dashboard, embed subcommand
  if [ "$command" = "dashboard" ] && [ -n "$subcommand" ]; then
    std_command="dashboard $subcommand"
  fi

  # For version, embed subcommand
  if [ "$command" = "version" ] && [ -n "$subcommand" ]; then
    std_command="version $subcommand"
  fi

  # For run with phase, embed phase
  if [ "$command" = "run" ] && [ -n "$phase" ]; then
    std_command="run --phase $phase"
  fi

  # Check for missing task_id when required
  if [ "$tid_required" = "true" ] && [ -z "$task_id" ]; then
    suggestion="Command '$command' requires a task ID. Please specify a task (e.g., TASK-001)."
    jq -n \
      --arg cmd "$std_command" \
      --arg act "${action}" \
      --argjson conf "$confidence" \
      --arg orig "$original_input" \
      --arg sugg "$suggestion" \
      --argjson args "$args" \
      '{
        success: false,
        command: $cmd,
        task_id: null,
        action: (if $act == "" then null else $act end),
        args: $args,
        confidence: $conf,
        original_input: $orig,
        suggestion: $sugg
      }'
    return 0
  fi

  # Build success response
  local effective_task_id="${task_id}"
  [ -z "$effective_task_id" ] && effective_task_id="null"

  jq -n \
    --arg cmd "$std_command" \
    --arg tid "$effective_task_id" \
    --arg act "${action}" \
    --argjson conf "$confidence" \
    --arg orig "$original_input" \
    --argjson args "$args" \
    --arg phase "${phase}" \
    --arg subcmd "${subcommand}" \
    '{
      success: true,
      command: $cmd,
      task_id: (if $tid == "null" then null else $tid end),
      action: (if $act == "" then null else $act end),
      args: ($args + (if $phase != "" then {phase: $phase} else {} end) + (if $subcmd != "" then {subcommand: $subcmd} else {} end)),
      confidence: $conf,
      original_input: $orig,
      suggestion: null
    }'
}

# === _nlp_sed_escape ===
# Escapes regex metacharacters in a string so it can be used safely
# as a literal pattern in sed substitution commands.
# Arguments:
#   $1 -- raw string
# Output: escaped string (to stdout)
_nlp_sed_escape() {
  printf '%s' "$1" | sed 's/[.[\*^$()+?{|\\]/\\&/g'
}

# === kanban_nl_apply_typos ===
# Applies common spelling corrections from nlp_patterns.json typos section.
# Arguments:
#   $1 -- input string
# Output: corrected string
kanban_nl_apply_typos() {
  local input="$1"
  [ -z "$input" ] && { echo ""; return 0; }

  local patterns
  patterns=$(kanban_nl_load_patterns) || { echo "$input"; return 0; }

  local typo_mappings
  typo_mappings=$(echo "$patterns" | jq -r '._meta.typos.mappings // {} | to_entries[] | "\(.key)\t\(.value)"' 2>/dev/null)

  if [ -n "$typo_mappings" ]; then
    local result="$input"
    while IFS=$'\t' read -r typo correction; do
      [ -z "$typo" ] && continue
      # Case-insensitive replacement using sed (escape metacharacters in both typo and correction)
      local escaped_typo escaped_correction
      escaped_typo=$(_nlp_sed_escape "$typo")
      escaped_correction=$(_nlp_sed_escape "$correction")
      result=$(echo "$result" | sed "s/$escaped_typo/$escaped_correction/gI" 2>/dev/null || echo "$result")
    done <<< "$typo_mappings"
    echo "$result"
  else
    echo "$input"
  fi
  return 0
}

# === kanban_nl_apply_traditional_chinese ===
# Converts Traditional Chinese keywords to Simplified Chinese equivalents
# using mappings from nlp_patterns.json.
# Uses sed for reliable multi-byte UTF-8 replacement (bash ${var//} is
# unreliable with multi-byte characters on some platforms).
# Arguments:
#   $1 -- input string
# Output: converted string
kanban_nl_apply_traditional_chinese() {
  local input="$1"
  [ -z "$input" ] && { echo ""; return 0; }

  local patterns
  patterns=$(kanban_nl_load_patterns) || { echo "$input"; return 0; }

  local tc_mappings
  tc_mappings=$(echo "$patterns" | jq -r '._meta.traditional_chinese.mappings // {} | to_entries | sort_by(-(.key | length)) | .[] | "\(.key)\t\(.value)"' 2>/dev/null)

  if [ -n "$tc_mappings" ]; then
    local result="$input"
    while IFS=$'\t' read -r tc_char sc_char; do
      [ -z "$tc_char" ] && continue
      # Use sed for reliable multi-byte replacement (sorted by length descending for safety)
      # Escape metacharacters to prevent regex injection
      local escaped_tc escaped_sc
      escaped_tc=$(_nlp_sed_escape "$tc_char")
      escaped_sc=$(_nlp_sed_escape "$sc_char")
      result=$(echo "$result" | sed "s/$escaped_tc/$escaped_sc/g")
    done <<< "$tc_mappings"
    echo "$result"
  else
    echo "$input"
  fi
  return 0
}

# === kanban_nl_infer_task_id ===
# Attempts to infer the task_id when none was explicitly provided.
# If there is exactly one active task in .kanban/index.json, uses that.
# Arguments:
#   $1 -- kanban directory path (default: .kanban)
# Output: TASK-NNN string, or empty string if inference not possible
kanban_nl_infer_task_id() {
  local kanban_dir="${1:-.kanban}"
  local index_file="$kanban_dir/index.json"

  if [ ! -f "$index_file" ]; then
    return 0
  fi

  # Get list of active (non-archived) task IDs from index
  local active_count
  active_count=$(jq '.tasks | length' "$index_file" 2>/dev/null)

  # Only infer when exactly one active task exists
  if [ "$active_count" = "1" ]; then
    local single_id
    single_id=$(jq -r '.tasks[0].id // ""' "$index_file" 2>/dev/null)
    if [ -n "$single_id" ] && echo "$single_id" | grep -qE '^TASK-[0-9]{3}$'; then
      echo "$single_id"
      return 0
    fi
  fi

  # Cannot infer: return empty
  return 0
}

# === kanban_nl_parse ===
# Main entry point for natural language command parsing.
# Takes a user's natural language string and returns a JSON object
# describing the parsed kanban command.
# Arguments:
#   $1 -- user input string
# Output: JSON object with fields:
#   success, command, task_id, action, args, confidence, original_input, suggestion
kanban_nl_parse() {
  local input="$1"

  # --- Edge case: empty input ---
  if [ -z "$input" ]; then
    local available_cmds
    available_cmds=$(kanban_nl_load_patterns 2>/dev/null | jq -c '.fallback.unrecognized_input.available_commands // []' 2>/dev/null || echo '[]')
    jq -n \
      --argjson cmds "$available_cmds" \
      '{
        success: false,
        command: null,
        task_id: null,
        action: null,
        args: {},
        confidence: 0.0,
        original_input: "",
        suggestion: ("No input provided. Available commands:\n" + ($cmds | map("  " + .) | join("\n")))
      }'
    return 0
  fi

  # --- Pre-process input: normalize whitespace ---
  local normalized
  normalized=$(echo "$input" | sed 's/[[:space:]]\+/ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # --- Apply Traditional Chinese conversion ---
  normalized=$(kanban_nl_apply_traditional_chinese "$normalized")

  # --- Apply typo corrections ---
  normalized=$(kanban_nl_apply_typos "$normalized")

  # --- Step 1: Extract task ID ---
  local task_id
  task_id=$(kanban_nl_extract_task_id "$normalized")

  # --- Step 2: Classify intent ---
  local intent_json
  intent_json=$(kanban_nl_classify_intent "$normalized")

  # --- Step 2b: Infer task_id if missing and command requires one ---
  if [ -z "$task_id" ]; then
    local intent_command
    intent_command=$(echo "$intent_json" | jq -r '.command // ""')
    if [ -n "$intent_command" ] && [ "$intent_command" != "null" ]; then
      local patterns
      patterns=$(kanban_nl_load_patterns 2>/dev/null)
      local tid_required
      tid_required=$(echo "$patterns" | jq --arg c "$intent_command" -r '.commands[$c].task_id_required // false' 2>/dev/null)
      if [ "$tid_required" = "true" ]; then
        local inferred_id
        inferred_id=$(kanban_nl_infer_task_id)
        if [ -n "$inferred_id" ]; then
          task_id="$inferred_id"
        fi
      fi
    fi
  fi

  # --- Step 3: Build command ---
  kanban_nl_build_command "$intent_json" "$task_id" "$input"
}

# === Internal helper functions ===

# _nlp_string_contains: Check if a string contains a substring.
# Uses fixed-string matching (both args assumed already lowercased).
# Arguments:
#   $1 -- haystack string
#   $2 -- needle string
# Returns: 0 if found, 1 if not found
_nlp_string_contains() {
  local haystack="$1"
  local needle="$2"
  [ -z "$needle" ] && return 1
  echo "$haystack" | grep -qF -- "$needle"
}

# _nlp_is_higher_confidence: Compare two confidence values.
# Uses awk for reliable floating-point comparison (bc is unreliable
# across platforms and does not handle values like ".83" well).
# Arguments:
#   $1 -- new confidence (string representation of float)
#   $2 -- current best confidence (string representation of float)
# Returns: 0 if new > current, 1 otherwise
_nlp_is_higher_confidence() {
  local new_conf="$1"
  local old_conf="$2"
  # Ensure values are not empty; default to 0
  [ -z "$new_conf" ] && new_conf=0
  [ -z "$old_conf" ] && old_conf=0
  local result
  result=$(awk "BEGIN { print ($new_conf > $old_conf) ? 1 : 0 }" 2>/dev/null)
  [ "$result" = "1" ]
}
