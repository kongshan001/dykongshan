#!/usr/bin/env bash
# agent_registry.sh -- Agent resolution and scheduling helper functions
# Provides dynamic agent configuration reading from workflow.json
# Dependencies: jq, KANBAN_DIR, SKILL_DIR (injected by kanban_init_env)

# Prevent duplicate loading
[ -n "${_AGENT_REGISTRY_LOADED:-}" ] && return 0
_AGENT_REGISTRY_LOADED=1

# Convert role name to agent filename (code_reviewer -> code-reviewer)
# Framework convention: role names use underscores, agent filenames use hyphens
_normalize_role_to_filename() {
  local role="$1"
  echo "$role" | tr '_' '-'
}

# Resolve the agent .md file path for a given role
# Args: role builtin file
#   role    -- agent role identifier (e.g. code_reviewer)
#   builtin -- "true" for built-in agents, "false" for custom
#   file    -- custom agent file path (relative to project root), only used when builtin=false
# Returns: absolute path to the agent .md file
resolve_agent_file() {
  local role="$1"
  local builtin="$2"
  local file="$3"

  if [ "$builtin" = "true" ]; then
    local filename
    filename=$(_normalize_role_to_filename "$role")
    echo "$SKILL_DIR/agents/${filename}.md"
  else
    # Custom agent: resolve relative to project root
    # In worktree execution, use MAIN_REPO_ROOT when available
    local project_root
    if [ -n "${MAIN_REPO_ROOT:-}" ]; then
      project_root="$MAIN_REPO_ROOT"
    else
      project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    fi
    echo "$project_root/$file"
  fi
}

# Check whether an agent file exists
# Args: role builtin file [required]
# Returns:
#   0 = file exists (path printed to stdout)
#   1 = required agent missing (error to stderr)
#   2 = optional agent missing (warning to stderr)
check_agent_file() {
  local role="$1"
  local builtin="$2"
  local file="$3"
  local required="${4:-true}"
  local agent_file
  agent_file=$(resolve_agent_file "$role" "$builtin" "$file")

  if [ ! -f "$agent_file" ]; then
    if [ "$required" = "true" ]; then
      echo "ERROR: Required agent '$role' not found: $agent_file" >&2
      return 1
    else
      echo "WARN: Optional agent '$role' not found: $agent_file, skipping" >&2
      return 2
    fi
  fi
  echo "$agent_file"
  return 0
}

# Read the agent list for a given phase from workflow.json
# Args: phase_id
# Returns: JSON array of agent objects, or [] if no agents defined
get_phase_agents() {
  local phase="$1"
  local workflow_file="$KANBAN_DIR/workflow.json"

  if [ ! -f "$workflow_file" ]; then
    echo "[]"
    return 0
  fi

  local result
  result=$(jq -c ".phases[] | select(.id == \"$phase\") | .agents // []" "$workflow_file" 2>/dev/null)
  echo "${result:-[]}"
}

# Get the list of required roles for a given phase
# Args: phase_id
# Returns: newline-separated role names (one per line), only required=true agents
get_required_roles() {
  local phase="$1"
  local workflow_file="$KANBAN_DIR/workflow.json"

  if [ ! -f "$workflow_file" ]; then
    _default_roles "$phase" "required"
    return 0
  fi

  local result
  result=$(jq -r ".phases[] | select(.id == \"$phase\") | .agents // [] | .[] | select(.required == true) | .role" "$workflow_file" 2>/dev/null)

  if [ -z "$result" ]; then
    # No agents config or no required agents -- fall back to defaults
    if ! _has_agents_field "$phase" "$workflow_file"; then
      _default_roles "$phase" "required"
    fi
  else
    echo "$result"
  fi
}

# Get all roles for a given phase (alias for get_phase_agents, but returns role names)
# Args: phase_id
# Returns: newline-separated role names (one per line)
get_all_roles() {
  local phase="$1"
  local workflow_file="$KANBAN_DIR/workflow.json"

  if [ ! -f "$workflow_file" ]; then
    _default_roles "$phase" "all"
    return 0
  fi

  local result
  result=$(jq -r ".phases[] | select(.id == \"$phase\") | .agents // [] | .[].role" "$workflow_file" 2>/dev/null)

  if [ -z "$result" ]; then
    # No agents config -- fall back to defaults
    if ! _has_agents_field "$phase" "$workflow_file"; then
      _default_roles "$phase" "all"
    fi
  else
    echo "$result"
  fi
}

# Get the count of required agents for a given phase
# Args: phase_id
# Returns: integer count
get_required_role_count() {
  local phase="$1"
  local workflow_file="$KANBAN_DIR/workflow.json"

  if [ ! -f "$workflow_file" ]; then
    echo "0"
    return 0
  fi

  local count
  count=$(jq ".phases[] | select(.id == \"$phase\") | .agents // [] | map(select(.required == true)) | length" "$workflow_file" 2>/dev/null)
  echo "${count:-0}"
}

# Check whether workflow.json has agents configuration for a given phase
# Args: phase_id
# Returns: 0 = has agents config, 1 = no agents config (should fall back to hardcoded)
has_agents_config() {
  local phase="$1"
  local workflow_file="$KANBAN_DIR/workflow.json"

  if [ ! -f "$workflow_file" ]; then
    return 1
  fi

  _has_agents_field "$phase" "$workflow_file"
}

# Expand template variables in output paths
# Args: template report_dir role
#   template -- path template with {report_dir} and {role} placeholders
#   report_dir -- the report directory to substitute
#   role -- the role name to substitute
# Returns: expanded path string
expand_output_path() {
  local template="$1"
  local report_dir="$2"
  local role="$3"
  echo "$template" | sed "s|{report_dir}|$report_dir|g; s|{role}|$role|g"
}

# === Internal helpers ===

# Check if a phase has a non-null, non-empty agents array in workflow.json
# Args: phase_id workflow_file
# Returns: 0 = has agents field, 1 = no agents field
_has_agents_field() {
  local phase="$1"
  local workflow_file="$2"
  local agents
  agents=$(jq -c ".phases[] | select(.id == \"$phase\") | .agents" "$workflow_file" 2>/dev/null)
  [ -n "$agents" ] && [ "$agents" != "null" ] && [ "$agents" != "[]" ]
}

# Return hardcoded default roles for backward compatibility
# Args: phase mode
#   phase -- plan|execute|evaluate|retrospective|archive
#   mode  -- "all" or "required"
# Returns: newline-separated role names
_default_roles() {
  local phase="$1"
  local mode="$2"

  case "$phase" in
    plan)
      echo "planner"
      ;;
    execute)
      echo "executor"
      ;;
    evaluate)
      echo "code_reviewer"
      echo "qa"
      echo "pm"
      echo "designer"
      ;;
    retrospective)
      echo "knowledge-manager"
      ;;
    archive)
      echo "knowledge-manager"
      ;;
    *)
      # Unknown phase: no defaults
      ;;
  esac
}
