#!/usr/bin/env bash
# kanban.sh — 任务 CRUD 层 (核心: 任务管理 + index 更新)
# 依赖: jq, git
# 注意: _update_index 只在此文件定义，其他 lib 不再重复

# zsh/bash glob 兼容: 无匹配时不报错
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 防止重复加载
[ -n "${_KANBAN_CORE_LOADED:-}" ] && return 0
_KANBAN_CORE_LOADED=1

# === ST-006: Dynamic evaluate roles helpers ===
# These functions provide backward-compatible access to evaluate phase roles.
# When agent_registry.sh is loaded and workflow.json has agents config for
# the evaluate phase, roles are read dynamically. Otherwise, hardcoded defaults
# are used for backward compatibility.

_get_eval_roles() {
  if type has_agents_config >/dev/null 2>&1 && has_agents_config "evaluate"; then
    get_all_roles "evaluate"
  else
    echo "code_reviewer qa pm designer"
  fi
}

_get_eval_required_roles() {
  if type has_agents_config >/dev/null 2>&1 && has_agents_config "evaluate"; then
    get_required_roles "evaluate"
  else
    echo "code_reviewer qa pm designer"
  fi
}

# === ST-011: 任务目录内聚化 helper 函数 ===
# 这些函数提供统一的路径管理，支持新旧两种目录结构的兼容。

# task_dir(task_id) -- 返回任务目录路径
# 新格式: .kanban/tasks/TASK-NNN/ (内聚目录)
# 旧格式: .kanban/tasks/TASK-NNN.json (散落文件)
# 自动检测并返回正确的路径
task_dir() {
  local task_id="$1"
  local new_dir="$KANBAN_DIR/tasks/${task_id}"
  local old_file="$KANBAN_DIR/tasks/${task_id}.json"
  if [ -d "$new_dir" ]; then
    echo "$new_dir"
  elif [ -f "$old_file" ]; then
    # 旧格式: 返回 tasks/ 目录 (不包含文件名)
    echo "$KANBAN_DIR/tasks"
  else
    echo "$new_dir"
  fi
}

# task_file(task_id) -- 返回 task JSON 文件路径
# 新格式: .kanban/tasks/TASK-NNN/task.json
# 旧格式: .kanban/tasks/TASK-NNN.json
task_file() {
  local task_id="$1"
  local new_file="$KANBAN_DIR/tasks/${task_id}/task.json"
  local old_file="$KANBAN_DIR/tasks/${task_id}.json"
  if [ -f "$new_file" ]; then
    echo "$new_file"
  elif [ -f "$old_file" ]; then
    echo "$old_file"
  else
    # 默认返回新格式路径 (用于创建)
    echo "$new_file"
  fi
}

# report_dir(task_id, iter) -- 返回迭代产物目录路径
# 新格式: .kanban/tasks/TASK-NNN/iteration-N/
# 旧格式: .kanban/reports/TASK-NNN/iteration-N/
report_dir() {
  local task_id="$1"
  local iter="${2:-}"
  if [ -z "$iter" ]; then
    local tf=$(task_file "$task_id")
    iter=$(jq -r '.iteration // 1' "$tf" 2>/dev/null || echo 1)
  fi
  local new_dir="$KANBAN_DIR/tasks/${task_id}/iteration-${iter}"
  local old_dir="$KANBAN_DIR/reports/${task_id}/iteration-${iter}"
  if [ -d "$new_dir" ]; then
    echo "$new_dir"
  elif [ -d "$old_dir" ]; then
    echo "$old_dir"
  else
    # 默认返回新格式路径 (用于创建)
    echo "$new_dir"
  fi
}

# dispatch_dir(task_id) -- 返回 dispatch 目录路径
# 始终使用新格式: .kanban/tasks/TASK-NNN/dispatch/ 并自动创建
dispatch_dir() {
  local task_id="$1"
  local new_dir="$KANBAN_DIR/tasks/${task_id}/dispatch"
  mkdir -p "$new_dir"
  echo "$new_dir"
}

# inbox_file(task_id) -- 返回 inbox 文件路径
# 新格式: .kanban/tasks/TASK-NNN/inbox.md
# 旧格式: .kanban/reports/TASK-NNN/inbox.md
inbox_file() {
  local task_id="$1"
  local new_file="$KANBAN_DIR/tasks/${task_id}/inbox.md"
  local old_file="$KANBAN_DIR/reports/${task_id}/inbox.md"
  if [ -f "$new_file" ]; then
    echo "$new_file"
  elif [ -f "$old_file" ]; then
    echo "$old_file"
  else
    echo "$new_file"
  fi
}

# is_new_layout() -- 检查指定 task_id 是否已使用新目录结构
# 返回 0=新结构, 1=旧结构
is_new_layout() {
  local task_id="$1"
  [ -d "$KANBAN_DIR/tasks/${task_id}" ] && [ -f "$KANBAN_DIR/tasks/${task_id}/task.json" ]
}

# archive_dir(task_id) -- 返回归档目录路径
# 新格式: .kanban/archive/TASK-NNN/
# 旧格式: .kanban/archive/TASK-NNN.json
archive_dir() {
  local task_id="$1"
  local new_dir="$KANBAN_DIR/archive/${task_id}"
  local old_file="$KANBAN_DIR/archive/${task_id}.json"
  if [ -d "$new_dir" ]; then
    echo "$new_dir"
  elif [ -f "$old_file" ]; then
    echo "$old_file"
  else
    echo "$new_dir"
  fi
}

# archive_task_file(task_id) -- 返回归档后的 task JSON 路径
archive_task_file() {
  local task_id="$1"
  local new_file="$KANBAN_DIR/archive/${task_id}/task.json"
  local old_file="$KANBAN_DIR/archive/${task_id}.json"
  if [ -f "$new_file" ]; then
    echo "$new_file"
  elif [ -f "$old_file" ]; then
    echo "$old_file"
  else
    echo "$new_file"
  fi
}

# migrate_task_dir(task_id) -- 将旧格式任务迁移到新格式
# 幂等: 已迁移的任务不会重复迁移
# 返回 0=成功, 1=失败
migrate_task_dir() {
  local task_id="$1"
  local old_file="$KANBAN_DIR/tasks/${task_id}.json"
  local new_dir="$KANBAN_DIR/tasks/${task_id}"

  # 已经是新格式: 跳过
  [ -d "$new_dir" ] && [ -f "$new_dir/task.json" ] && return 0

  # 旧文件不存在: 无需迁移
  [ ! -f "$old_file" ] && return 0

  # 创建新目录
  mkdir -p "$new_dir"

  # 移动 task JSON
  mv "$old_file" "$new_dir/task.json"

  # 迁移 inbox.md (如果存在)
  local old_inbox="$KANBAN_DIR/reports/${task_id}/inbox.md"
  [ -f "$old_inbox" ] && mv "$old_inbox" "$new_dir/inbox.md"

  # 迁移 iteration 目录 (如果存在)
  local old_reports="$KANBAN_DIR/reports/${task_id}"
  if [ -d "$old_reports" ]; then
    for iter_dir in "$old_reports"/iteration-*; do
      [ -d "$iter_dir" ] && mv "$iter_dir" "$new_dir/"
    done
  fi

  # 迁移 dispatch 文件 (如果存在)
  local old_dispatch_files=$(ls "$KANBAN_DIR/dispatch/${task_id}"-*.json 2>/dev/null || true)
  if [ -n "$old_dispatch_files" ]; then
    mkdir -p "$new_dir/dispatch"
    for f in "$KANBAN_DIR/dispatch/${task_id}"-*.json; do
      [ -f "$f" ] && mv "$f" "$new_dir/dispatch/"
    done
  fi

  echo "Migrated $task_id to new directory layout"
  return 0
}

# migrate_all_tasks() -- 迁移所有旧格式任务
# 包括 active tasks 和 archived tasks
migrate_all_tasks() {
  local count=0

  # 迁移 active tasks
  for old_file in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$old_file" ] || continue
    local task_id=$(basename "$old_file" .json)
    migrate_task_dir "$task_id" && count=$((count + 1))
  done

  # 迁移 archived tasks
  for old_file in "$KANBAN_DIR"/archive/TASK-*.json; do
    [ -f "$old_file" ] || continue
    local task_id=$(basename "$old_file" .json)
    local new_dir="$KANBAN_DIR/archive/${task_id}"
    [ -d "$new_dir" ] && [ -f "$new_dir/task.json" ] && continue  # 已迁移
    mkdir -p "$new_dir"
    mv "$old_file" "$new_dir/task.json"
    # 迁移归档任务的 reports
    local old_reports="$KANBAN_DIR/reports/${task_id}"
    if [ -d "$old_reports" ]; then
      for iter_dir in "$old_reports"/iteration-*; do
        [ -d "$iter_dir" ] && mv "$iter_dir" "$new_dir/"
      done
      # 迁移 inbox
      [ -f "$old_reports/inbox.md" ] && mv "$old_reports/inbox.md" "$new_dir/inbox.md"
    fi
    # 迁移归档任务的 dispatch
    local old_dispatch_files=$(ls "$KANBAN_DIR/dispatch/${task_id}"-*.json 2>/dev/null || true)
    if [ -n "$old_dispatch_files" ]; then
      mkdir -p "$new_dir/dispatch"
      for f in "$KANBAN_DIR/dispatch/${task_id}"-*.json; do
        [ -f "$f" ] && mv "$f" "$new_dir/dispatch/"
      done
    fi
    count=$((count + 1))
  done

  echo "Migrated $count tasks to new directory layout"
  return 0
}

# 统一初始化入口: 加载所有 lib
kanban_init_env() {
  local lib_dir="$SKILL_DIR/lib"
  for lib in "$lib_dir"/*.sh; do
    case "$(basename "$lib")" in
      kanban.sh) ;;  # 已加载，跳过
      *) source "$lib" ;;
    esac
  done

  # ST-012: 自动检测并迁移旧格式任务
  if [ -d "$KANBAN_DIR" ]; then
    local old_format_count=$(ls "$KANBAN_DIR"/tasks/TASK-*.json 2>/dev/null | wc -l | tr -d ' ')
    if [ "$old_format_count" -gt 0 ]; then
      migrate_all_tasks >/dev/null 2>&1 || true
    fi
  fi

  echo "Kanban env loaded ($SKILL_DIR)"
}

# 诊断: 检查环境是否正常
kanban_check_env() {
  echo "KANBAN_DIR=$KANBAN_DIR"
  echo "SKILL_DIR=$SKILL_DIR"
  echo "jq: $(command -v jq || echo 'NOT FOUND')"
  echo "git: $(command -v git || echo 'NOT FOUND')"
  echo "project: $(jq -r '.project // "N/A"' "$KANBAN_DIR/config.json" 2>/dev/null || echo 'config missing')"
  echo "tasks: $(ls -d "$KANBAN_DIR"/tasks/TASK-*/ 2>/dev/null | wc -l | tr -d ' ') active"
}

# 初始化 .kanban/ 目录 (从 templates 复制配置)
kanban_init() {
  # IR-09-FIX: 强制要求 git 仓库
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "ERROR: kanban requires a git repository. Please run 'git init' first."
    return 1
  fi

  if [ -d "$KANBAN_DIR" ]; then
    echo "Kanban already initialized at $KANBAN_DIR/"
    _kanban_install_deps
    return 0
  fi

  local project=$(basename "$(pwd)")
  local trunk=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ "$trunk" == "HEAD" || -z "$trunk" ]] && trunk=$(git config --get init.defaultBranch 2>/dev/null || echo "main")

  mkdir -p "$KANBAN_DIR"/{tasks,reports,skills/evolved,archive,worktrees,versions}

  # 从模板复制配置（使用 jq 替代 sed，跨平台兼容）
  cp "$SKILL_DIR/templates/workflow.json" "$KANBAN_DIR/workflow.json"
  jq --arg p "$project" --arg t "$trunk" \
    '.project = $p | .trunk = $t' \
    "$SKILL_DIR/templates/config.json" > "$KANBAN_DIR/config.json"

  # 创建 index.json
  jq -n --arg p "$project" --arg t "$trunk" \
    '{project:$p, trunk:$t, tasks:[]}' > "$KANBAN_DIR/index.json"

  _kanban_install_deps
  echo "Initialized kanban at $KANBAN_DIR/ (project=$project, trunk=$trunk)"
}

# 检测当前平台是否支持符号链接
# 返回 0=支持 (macOS/Linux), 1=不支持 (Windows MINGW/MSYS)
_kanban_supports_symlinks() {
  local uname_out="$(uname -s 2>/dev/null || echo "")"
  case "$uname_out" in
    MINGW*|MSYS*|CYGWIN*) return 1 ;;
    *) return 0 ;;
  esac
}

# 为单个文件创建符号链接（或 Windows 下回退到复制）
# 用法: _kanban_link_file <target_dir> <name> <relative_target>
#   target_dir    -- 链接所在目录 (如 .claude/agents)
#   name          -- 文件名 (如 planner.md)
#   relative_target -- 从 target_dir 到源文件的相对路径 (如 ../skills/kanban/agents/planner.md)
# 返回: 0=创建/更新, 1=跳过 (已有效), 2=错误
_kanban_link_file() {
  local target_dir="$1"
  local name="$2"
  local relative_target="$3"
  local link_path="$target_dir/$name"

  # 情况 1: 已存在 symlink 且指向同一目标 -> 跳过
  if [ -L "$link_path" ]; then
    local current_target
    current_target=$(readlink "$link_path" 2>/dev/null || echo "")
    if [ "$current_target" = "$relative_target" ]; then
      return 1  # 跳过，无需更新
    fi
    # symlink 指向不同目标 -> 先删除再重建
    rm -f "$link_path"
  fi

  # 情况 2: 已存在 regular file -> 先删除
  if [ -f "$link_path" ]; then
    rm -f "$link_path"
  fi

  # 创建 symlink 或回退到 copy
  if _kanban_supports_symlinks; then
    ln -sf "$relative_target" "$link_path" || return 2
  else
    # Windows: 解析实际路径后复制
    local source_file="$target_dir/$relative_target"
    cp "$source_file" "$link_path" || return 2
  fi
  return 0
}

# 安装框架依赖文件 (agents, rules, dashboard) 到项目 .claude/ 目录
# agents 和 rules 使用符号链接 (Windows 回退到复制), dashboard 使用复制
_kanban_install_deps() {
  local agents_dir=".claude/agents"
  local rules_dir=".claude/rules"
  local dashboard_dir="$KANBAN_DIR/dashboard"
  local count=0
  local linked=0
  local skipped=0
  local use_symlink="yes"

  # 检测 symlink 支持
  if _kanban_supports_symlinks; then
    use_symlink="yes"
  else
    use_symlink="no"
  fi

  # 安装 agents (symlink or copy on Windows)
  if [ -d "$SKILL_DIR/agents" ]; then
    mkdir -p "$agents_dir"
    for agent in "$SKILL_DIR"/agents/*.md; do
      [ -f "$agent" ] || continue
      local name=$(basename "$agent")
      if [ "$use_symlink" = "yes" ]; then
        local rel_target="../skills/kanban/agents/$name"
        local ret=0
        _kanban_link_file "$agents_dir" "$name" "$rel_target" || ret=$?
        if [ $ret -eq 0 ]; then
          linked=$((linked + 1))
          count=$((count + 1))
        elif [ $ret -eq 1 ]; then
          skipped=$((skipped + 1))
        fi
      else
        # Windows fallback: copy
        if [ ! -f "$agents_dir/$name" ]; then
          cp "$agent" "$agents_dir/$name"
          count=$((count + 1))
        fi
      fi
    done
  fi

  # 安装 rules (symlink or copy on Windows)
  if [ -d "$SKILL_DIR/rules" ]; then
    mkdir -p "$rules_dir"
    for rule in "$SKILL_DIR"/rules/*.md; do
      [ -f "$rule" ] || continue
      local name=$(basename "$rule")
      if [ "$use_symlink" = "yes" ]; then
        local rel_target="../skills/kanban/rules/$name"
        local ret=0
        _kanban_link_file "$rules_dir" "$name" "$rel_target" || ret=$?
        if [ $ret -eq 0 ]; then
          linked=$((linked + 1))
          count=$((count + 1))
        elif [ $ret -eq 1 ]; then
          skipped=$((skipped + 1))
        fi
      else
        # Windows fallback: copy
        if [ ! -f "$rules_dir/$name" ]; then
          cp "$rule" "$rules_dir/$name"
          count=$((count + 1))
        fi
      fi
    done
  fi

  # 安装 dashboard (always copy -- not suitable for symlink)
  if [ -d "$SKILL_DIR/dashboard" ] && [ ! -f "$dashboard_dir/server.js" ]; then
    mkdir -p "$dashboard_dir"
    cp -r "$SKILL_DIR"/dashboard/* "$dashboard_dir/" 2>/dev/null || true
    count=$((count + 1))
  fi

  # 初始化 versions 目录（幂等）
  if [ "$(type -t kanban_version_init 2>/dev/null)" = "function" ]; then
    kanban_version_init
  fi

  # 复制 plugin.json（仅当目标不存在时）
  local plugin_src="$SKILL_DIR/../../.claude-plugin/plugin.json"
  local plugin_dst=".claude-plugin/plugin.json"
  if [ -f "$plugin_src" ] && [ ! -f "$plugin_dst" ]; then
    mkdir -p "$(dirname "$plugin_dst")"
    cp "$plugin_src" "$plugin_dst"
    count=$((count + 1))
  fi

  # 复制 GETTING_STARTED.md（仅当目标不存在时，避免覆盖用户自定义）
  local gs_src="$SKILL_DIR/templates/GETTING_STARTED.md"
  if [ -f "$gs_src" ] && [ ! -f "GETTING_STARTED.md" ]; then
    cp "$gs_src" "GETTING_STARTED.md"
    count=$((count + 1))
  fi

  if [ $count -gt 0 ] || [ $skipped -gt 0 ]; then
    if [ "$use_symlink" = "yes" ]; then
      echo "Linked $linked framework files (agents, rules via symlink)"
      if [ $skipped -gt 0 ]; then
        echo "  ($skipped already linked, skipped)"
      fi
    else
      echo "Installed $count framework files (agents, rules, dashboard)"
    fi
  fi
}

# 生成下一个 TASK-NNN ID
_next_task_id() {
  local max=0
  # 新格式: tasks/TASK-NNN/task.json
  for d in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$d" ] || continue
    local num=$(basename "$d" | sed 's/TASK-//')
    [ $(( 10#$num )) -gt "$max" ] 2>/dev/null && max=$(( 10#$num ))
  done
  # 新格式: archive/TASK-NNN/task.json
  for d in "$KANBAN_DIR"/archive/TASK-*/; do
    [ -d "$d" ] || continue
    local num=$(basename "$d" | sed 's/TASK-//')
    [ $(( 10#$num )) -gt "$max" ] 2>/dev/null && max=$(( 10#$num ))
  done
  # 旧格式兼容: tasks/TASK-NNN.json
  for f in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$f" ] || continue
    local num=$(basename "$f" .json | sed 's/TASK-//')
    [ $(( 10#$num )) -gt "$max" ] 2>/dev/null && max=$(( 10#$num ))
  done
  # 旧格式兼容: archive/TASK-NNN.json
  for f in "$KANBAN_DIR"/archive/TASK-*.json; do
    [ -f "$f" ] || continue
    local num=$(basename "$f" .json | sed 's/TASK-//')
    [ $(( 10#$num )) -gt "$max" ] 2>/dev/null && max=$(( 10#$num ))
  done
  printf "TASK-%03d" $((max + 1))
}

# 创建任务
kanban_create_task() {
  local title="$1"
  local description="${2:-}"

  [ -z "$title" ] && { echo "ERROR: title required"; return 1; }
  [ ! -d "$KANBAN_DIR" ] && { echo "ERROR: run kanban_init first"; return 1; }

  local task_id=$(_next_task_id)
  local now=$(date -u +%FT%TZ)
  local branch="feature/${task_id}"

  # ST-002 (Issue #21): 从 config.json 读取 trunk 作为 worktree.base，而非硬编码 "main"
  local trunk_base
  trunk_base=$(jq -r '.trunk // "main"' "$KANBAN_DIR/config.json" 2>/dev/null || echo "main")

  # ST-011: 使用新的内聚目录结构
  local task_dir_path="$KANBAN_DIR/tasks/${task_id}"
  mkdir -p "$task_dir_path"

  jq -n \
    --arg id "$task_id" \
    --arg title "$title" \
    --arg desc "$description" \
    --arg branch "$branch" \
    --arg trunk_base "$trunk_base" \
    --arg now "$now" \
    '{
      id: $id,
      title: $title,
      description: $desc,
      engine: "claude-code",
      status: "pending",
      phase: null,
      phase_lock: null,
      assignee: null,
      worktree: { branch: $branch, path: "", base: $trunk_base },
      iteration: 0,
      max_iterations: 6,
      token_budget: 500000,
      token_used: 0,
      scores: {},
      depends_on: [],
      modified_files: [],
      task_breakdown: { file: "", subtasks: [] },
      history: [],
      user_decision: null,
      requires_archive_confirmation: true,
      created_at: $now,
      updated_at: $now,
      entered_at: null
    }' > "$task_dir_path/task.json"

  # 防御性直接追加到 index.json（避免 glob 扫描时序问题）
  # ST-002 (Issues #29/#22): 使用 jq -n + --arg 安全构建 JSON，避免 --argjson 传入无效 JSON
  local idx="$KANBAN_DIR/index.json"
  if [ -f "$idx" ]; then
    local _itmp=$(mktemp)
    local _s
    _s=$(jq -n --arg id "$task_id" '{id:$id, status:"pending", phase:null, iteration:0}')
    jq --argjson _s "$_s" '.tasks += [$_s]' "$idx" > "$_itmp" && mv "$_itmp" "$idx"
  fi

  _update_index
  kanban_create_inbox "$task_id" "$title"
  echo "Created $task_id: $title"
  echo "  Branch: $branch"
  echo "  Status: pending"
}

# 原子更新任务 JSON
kanban_update_task() {
  local task_id="$1"
  shift
  local task_file_path=$(task_file "$task_id")

  [ ! -f "$task_file_path" ] && { echo "ERROR: $task_id not found"; return 1; }

  # Collect --arg/--argjson pairs and the final jq expression
  local jq_args=()
  local jq_expr=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --arg|--argjson)
        jq_args+=("$1" "$2" "$3")
        shift 3
        ;;
      *)
        jq_expr="$1"
        shift
        ;;
    esac
  done

  local now=$(date -u +%FT%TZ)
  local tmp=$(mktemp)
  if [[ ${#jq_args[@]} -gt 0 ]]; then
    jq --arg t "$now" "${jq_args[@]}" "$jq_expr | .updated_at=\$t" "$task_file_path" > "$tmp" \
      && mv "$tmp" "$task_file_path"
  else
    jq --arg t "$now" "$jq_expr | .updated_at=\$t" "$task_file_path" > "$tmp" \
      && mv "$tmp" "$task_file_path"
  fi
}

# 展示看板状态
kanban_status() {
  [ ! -f "$KANBAN_DIR/index.json" ] && { echo "ERROR: kanban not initialized"; return 1; }

  local project=$(jq -r '.project' "$KANBAN_DIR/index.json")
  local trunk=$(jq -r '.trunk' "$KANBAN_DIR/index.json")
  echo "=== Kanban: $project (trunk: $trunk) ==="
  echo ""

  # 支持 new format (tasks/TASK-NNN/task.json) 和 old format (tasks/TASK-NNN.json)
  local has_tasks=false
  printf "%-12s %-12s %-12s %-5s %-8s %s\n" "ID" "STATUS" "PHASE" "ITER" "ENGINE" "TITLE"
  echo "-------------------------------------------------------------------------"
  for task_dir_entry in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$task_dir_entry" ] || continue
    local tf="$task_dir_entry/task.json"
    [ -f "$tf" ] || continue
    has_tasks=true
    local id=$(jq -r '.id' "$tf")
    local task_status=$(jq -r '.status' "$tf")
    local phase=$(jq -r '.phase // "—"' "$tf")
    local iter=$(jq -r '.iteration' "$tf")
    local engine=$(jq -r '.engine' "$tf")
    local title=$(jq -r '.title' "$tf" | head -c 30)
    printf "%-12s %-12s %-12s %-5s %-8s %s\n" "$id" "$task_status" "$phase" "$iter" "$engine" "$title"
  done
  # 旧格式兼容
  for task_file_entry in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$task_file_entry" ] || continue
    has_tasks=true
    local id=$(jq -r '.id' "$task_file_entry")
    local task_status=$(jq -r '.status' "$task_file_entry")
    local phase=$(jq -r '.phase // "—"' "$task_file_entry")
    local iter=$(jq -r '.iteration' "$task_file_entry")
    local engine=$(jq -r '.engine' "$task_file_entry")
    local title=$(jq -r '.title' "$task_file_entry" | head -c 30)
    printf "%-12s %-12s %-12s %-5s %-8s %s\n" "$id" "$task_status" "$phase" "$iter" "$engine" "$title"
  done
  if [ "$has_tasks" = "false" ]; then
    echo "(no tasks)"
  fi
}

# 展示单个任务详情
kanban_show_task() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local title=$(jq -r '.title' "$tf")
  local task_status=$(jq -r '.status' "$tf")
  local phase=$(jq -r '.phase // "—"' "$tf")
  local iteration=$(jq -r '.iteration // 0' "$tf")

  echo "=== $task_id: $title ==="
  echo "Status: $task_status  Phase: $phase  Iteration: $iteration"
  echo ""

  # 展示子任务进度
  local subtask_count=$(jq '.task_breakdown.subtasks | length' "$tf")
  if [ "$subtask_count" -gt 0 ] 2>/dev/null; then
    echo "--- Subtasks ($subtask_count) ---"
    local completed=0
    for i in $(seq 0 $((subtask_count - 1))); do
      local st_id=$(jq -r ".task_breakdown.subtasks[$i].id" "$tf")
      local st_title=$(jq -r ".task_breakdown.subtasks[$i].title" "$tf")
      local st_status=$(jq -r ".task_breakdown.subtasks[$i].status // \"pending\"" "$tf")
      local icon=""
      case "$st_status" in
        completed)   icon="✅"; completed=$((completed + 1)) ;;
        in_progress) icon="🔄" ;;
        failed)      icon="❌" ;;
        *)           icon="⬜" ;;
      esac
      printf "  %-8s %-40s %s %s\n" "$st_id" "$(echo "$st_title" | head -c 40)" "$icon" "$st_status"
    done
    echo ""
    echo "Progress: $completed / $subtask_count completed"
  else
    echo "(no subtasks tracked)"
  fi

  echo ""
  # 展示评分（如有）
  local has_scores=$(jq '.scores | length' "$tf")
  if [ "$has_scores" -gt 0 ] 2>/dev/null; then
    echo "--- Scores ---"
    for role in $(_get_eval_roles); do
      local score=$(jq -r --arg r "$role" '.scores[$r].score // ""' "$tf")
      local passed=$(jq -r --arg r "$role" '.scores[$r].passed // ""' "$tf")
      [ -z "$score" ] && continue
      local pass_icon=""
      [ "$passed" = "true" ] && pass_icon="PASS" || pass_icon="FAIL"
      printf "  %-15s %s  [%s]\n" "$role" "$score" "$pass_icon"
    done
  fi
}

# 处理用户决策
kanban_decide() {
  local task_id="$1"
  shift
  local action=""
  local feedback=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --action) action="$2"; shift 2 ;;
      --feedback) feedback="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  [ -z "$action" ] && { echo "ERROR: --action required"; return 1; }

  case "$action" in
    approve_and_archive|restart_from_plan|restart_from_execute|abort) ;;
    *) echo "ERROR: invalid action '$action'. Valid: approve_and_archive restart_from_plan restart_from_execute abort"; return 1 ;;
  esac

  # 归档确认检查: requires_archive_confirmation 为 true 时，确保用户已通过显式 decide 触发
  if [ "$action" = "approve_and_archive" ]; then
    local tf=$(task_file "$task_id")
    local requires_confirm=$(jq -r '.requires_archive_confirmation // false' "$tf" 2>/dev/null)
    if [ "$requires_confirm" = "true" ]; then
      # 确认是用户显式调用（非自动流程），通过检查调用上下文判断
      # kanban_decide 由 /kanban decide 命令路由调用，属于显式触发
      echo "Archive confirmation: user explicitly approved via /kanban decide"
    fi
  fi

  local now=$(date -u +%FT%TZ)
  kanban_update_task "$task_id" \
    --arg action "$action" --arg feedback "$feedback" --arg decided_at "$now" \
    '.user_decision={action:$action, feedback:$feedback, decided_at:$decided_at}'

  # Bug #17 fix: abort 可从任意状态触发，直接更新 status/phase 并触发归档
  if [ "$action" = "abort" ]; then
    local tf_abort=$(task_file "$task_id")
    local abort_tmp=$(mktemp)
    jq --arg now "$now" \
      '.status="aborted" | .phase="aborted" | .phase_lock="aborted" | .updated_at=$now | .history += [{"phase":"aborted","status":"entered","entered_at":$now}]' \
      "$tf_abort" > "$abort_tmp" && mv "$abort_tmp" "$tf_abort"
    _update_index
    echo "Decision recorded: abort"
    echo "Task $task_id aborted, triggering archive..."
    if [ -n "$feedback" ]; then
      echo "Feedback: $feedback"
    fi
    kanban_archive_task "$task_id"
    return $?
  fi

  # Bug #12 fix: transition to user_decision phase so that phase/phase_lock are updated
  # Only transition if not already in user_decision phase
  if type workflow_transition >/dev/null 2>&1; then
    local tf_check=$(task_file "$task_id")
    local current_phase=$(jq -r '.phase_lock // ""' "$tf_check" 2>/dev/null)
    if [ "$current_phase" != "user_decision" ]; then
      workflow_transition "$task_id" "user_decision" 2>/dev/null || true
    fi
  fi

  echo "Decision recorded: $action"
  if [ -n "$feedback" ]; then
    echo "Feedback: $feedback"
  fi
}

# 归档任务
kanban_archive_task() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  # 归档确认检查: 如果 requires_archive_confirmation 为 true，必须有 user_decision 记录
  local requires_confirm=$(jq -r '.requires_archive_confirmation // false' "$tf" 2>/dev/null)
  if [ "$requires_confirm" = "true" ]; then
    local user_decision=$(jq -r '.user_decision.action // ""' "$tf" 2>/dev/null)
    if [ "$user_decision" != "approve_and_archive" ] && [ "$user_decision" != "abort" ]; then
      echo "ERROR: 归档需要用户确认。请使用 /kanban decide ${task_id} --action approve_and_archive"
      return 1
    fi
  fi

  # Inbox 待处理检查 (二次防线)
  # 注意: abort 操作跳过此检查 (abort 是用户明确决定, 与 IR-11 一致)
  local archive_action=$(jq -r '.user_decision.action // ""' "$tf" 2>/dev/null)
  if [ "$archive_action" != "abort" ]; then
    if type guard_check_inbox >/dev/null 2>&1; then
      local inbox_result
      inbox_result=$(guard_check_inbox "$task_id")
      if [ "$inbox_result" != "PASS" ]; then
        echo "GUARD BLOCKED: Cannot archive task with pending inbox feedback."
        echo "  $inbox_result"
        echo "  Run: /kanban feedback $task_id"
        return 1
      fi
    fi
  fi

  # ST-015: 框架自评估 (在归档前执行，不阻塞归档)
  if type framework_self_assess >/dev/null 2>&1; then
    framework_self_assess "$task_id" 2>/dev/null || echo "WARNING: framework_self_assess failed (non-blocking)"
  fi

  # Worktree 容错处理: 检查 worktree 是否存在
  local wt_path=$(jq -r '.worktree.path // ""' "$tf")
  local wt_branch=$(jq -r '.worktree.branch // ""' "$tf")

  if [ -n "$wt_path" ] && [ -d "$wt_path" ]; then
    # worktree 存在: 提交未提交变更 + 合并
    local has_changes
    has_changes=$(cd "$wt_path" && git status --porcelain 2>/dev/null)
    if [ -n "$has_changes" ]; then
      echo "INFO: committing pending changes in worktree..."
      local output_dir=$(jq -r '.output_dir // "src"' "$KANBAN_DIR/config.json")
      cd "$wt_path" && git add "$output_dir/" 2>/dev/null
      cd "$wt_path" && git commit -m "fix: final changes before archive (${task_id})" 2>/dev/null || true
    fi
    # 合并 worktree 到主干
    worktree_merge "$task_id" 2>/dev/null || echo "WARNING: worktree merge failed, continuing archive"
    # 清理 worktree
    worktree_cleanup "$task_id"
  else
    # worktree 不存在: 警告并跳过 merge
    if [ -n "$wt_branch" ]; then
      echo "WARNING: worktree directory not found for $task_id, skipping merge (branch: $wt_branch)"
    fi

    # ST-010: 兜底 commit -- 当 worktree 不存在时，检查主目录是否有未提交的变更
    # 场景: worktree 隔离失败，代码变更可能留在主工作目录
    # Fix 8: 只在 worktree.path 非空（说明之前确实有 worktree）时才执行兜底 commit
    # 如果 worktree.path 本来就是空的，说明任务从未使用 worktree，不需要 fixup
    if [ -n "$wt_path" ]; then
      local main_changes
      main_changes=$(git status --porcelain 2>/dev/null | head -20)
      if [ -n "$main_changes" ]; then
        echo "INFO: uncommitted changes found in main working directory, creating fixup commit"
        local output_dir=$(jq -r '.output_dir // "src"' "$KANBAN_DIR/config.json")
        # Stage only the output_dir and framework files (not .kanban runtime data)
        git add "$output_dir/" ".claude/" ".kanban/config.json" ".kanban/workflow.json" 2>/dev/null || true
        git commit -m "fixup: ${task_id} changes (worktree unavailable)" 2>/dev/null || true
        echo "INFO: fixup commit created for ${task_id}"
        # Record to task history
        local now_hist=$(date -u +%FT%TZ)
        local tmp_hist=$(mktemp)
        jq --arg now "$now_hist" \
          '.history += [{"event":"fixup_commit", "phase":"archive", "reason":"worktree_unavailable", "timestamp":$now}]' \
          "$tf" > "$tmp_hist" && mv "$tmp_hist" "$tf" || { echo "ERROR: failed to update task history"; return 1; }
      fi
    fi

    # 确保清空残留的 worktree 字段
    local tmp=$(mktemp)
    jq '.worktree.path="" | .worktree.branch=""' "$tf" > "$tmp" \
      && mv "$tmp" "$tf" || { echo "ERROR: failed to clear worktree fields"; return 1; }
  fi

  # ST-011: 使用新的内聚目录结构归档
  # 新格式: mv tasks/TASK-NNN/ archive/TASK-NNN/
  # 旧格式兼容: mv tasks/TASK-NNN.json archive/TASK-NNN.json
  mkdir -p "$KANBAN_DIR/archive" || { echo "ERROR: failed to create archive directory"; return 1; }
  local task_dir_path="$KANBAN_DIR/tasks/${task_id}"
  local old_file="$KANBAN_DIR/tasks/${task_id}.json"
  if [ -d "$task_dir_path" ]; then
    # 新格式目录已存在（可能由 framework_self_assess 创建）
    # 如果旧格式 JSON 也存在，先移入目录
    if [ -f "$old_file" ]; then
      mv "$old_file" "$task_dir_path/task.json" || { echo "ERROR: failed to merge old format file into task directory"; return 1; }
    fi
    mv "$task_dir_path" "$KANBAN_DIR/archive/" || { echo "ERROR: failed to archive task directory"; return 1; }
  elif [ -f "$old_file" ]; then
    # 纯旧格式，无新格式目录
    mv "$old_file" "$KANBAN_DIR/archive/" || { echo "ERROR: failed to archive old format task file"; return 1; }
  fi
  _update_index
  echo "Archived $task_id"

  # ST-003: 自动触发 Skills 演化 (在归档完成后执行)
  # 遵循 IR-12: lib 类改进会创建 kanban 任务而非直接修改
  if type skills_evolve_auto >/dev/null 2>&1; then
    skills_evolve_auto "$task_id" 2>/dev/null || echo "WARNING: skills_evolve_auto failed (non-blocking)"
  fi
}

# 生成迭代摘要 (供用户决策时展示)
kanban_iteration_summary() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local iterations=$(jq -r '.iteration // 0' "$tf")
  iterations=${iterations:-0}

  echo "=== $task_id 迭代摘要 ==="
  echo "总迭代轮次: $iterations"
  echo ""

  echo "--- 评分趋势 ---"
  for i in $(seq 1 "$iterations"); do
    local dir=$(report_dir "$task_id" "$i")
    echo "Iteration ${i}:"
    for role in $(_get_eval_roles); do
      local report="${dir}/${role}_report.json"
      if [ -f "$report" ]; then
        local score=$(jq -r '.score // "N/A"' "$report")
        echo "  ${role}: ${score}"
      fi
    done
  done

  echo ""
  echo "--- 最近一轮扣分项 ---"
  local last_dir=$(report_dir "$task_id" "$iterations")
  for role in $(_get_eval_roles); do
    local report="${last_dir}/${role}_report.json"
    [ -f "$report" ] || continue
    local score=$(jq -r '.score // 0' "$report")
    if [ "$(echo "$score < 9.0" | bc 2>/dev/null || echo 0)" = "1" ]; then
      echo "  ${role} (${score}分):"
      jq -r '.improvements[]? | "    - " + .' "$report" 2>/dev/null
    fi
  done

  echo ""
  echo "--- 可选操作 ---"
  echo "  /kanban decide $task_id --action approve_and_archive"
  echo "  /kanban decide $task_id --action restart_from_plan --feedback \"...\""
  echo "  /kanban decide $task_id --action restart_from_execute --feedback \"...\""
  echo "  /kanban decide $task_id --action abort"
}

# 变更摘要 — 在 user_decision 阶段展示任务全景总结
# 聚合: 需求背景、技术方案、任务拆解与进度、质量评估、变更文件
kanban_changes_summary() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local wt_path=$(jq -r '.worktree.path // ""' "$tf")
  local trunk=$(jq -r '.trunk // "main"' "$KANBAN_DIR/config.json" 2>/dev/null || echo "main")
  local iter=$(jq -r '.iteration // 1' "$tf")
  iter=${iter:-1}
  local title=$(jq -r '.title // ""' "$tf")
  local rdir=$(report_dir "$task_id" "$iter")

  # 检测多级 .kanban/ 位置：CWD、worktree、main repo
  local wt_kanban=""
  if [ -n "$wt_path" ] && [ -d "$wt_path/.kanban" ]; then
    wt_kanban="$wt_path/.kanban"
  fi
  # ST-004: 推算 main repo 的 .kanban/
  # 兼容两种 worktree 路径:
  #   旧路径: .../.kanban/worktrees/TASK-NNN
  #   新路径: .../.kanban/tasks/TASK-NNN/worktree
  local main_kanban=""
  if [[ "$wt_path" == *"/.kanban/worktrees/"* ]]; then
    main_kanban="${wt_path%%/.kanban/worktrees/*}/.kanban"
  elif [[ "$wt_path" == *"/.kanban/tasks/"*"/worktree" ]]; then
    main_kanban="${wt_path%%/.kanban/tasks/*}/.kanban"
  fi
  # 在多个可能的位置查找产物文件
  _find_artifact() {
    local name="$1"
    local search_iter="${2:-$iter}"
    # CWD 的 .kanban/（当前迭代 → iteration-1）
    local d=$(report_dir "$task_id" "$search_iter")
    [ -f "$d/$name" ] && { echo "$d/$name"; return; }
    if [ "$search_iter" != "1" ]; then
      d=$(report_dir "$task_id" 1)
      [ -f "$d/$name" ] && { echo "$d/$name"; return; }
    fi
    # main repo 的 .kanban/（从 worktree 运行时，产物通常在这里）
    if [ -n "$main_kanban" ]; then
      [ -f "$main_kanban/tasks/${task_id}/iteration-${search_iter}/$name" ] && { echo "$main_kanban/tasks/${task_id}/iteration-${search_iter}/$name"; return; }
      if [ "$search_iter" != "1" ]; then
        [ -f "$main_kanban/tasks/${task_id}/iteration-1/$name" ] && { echo "$main_kanban/tasks/${task_id}/iteration-1/$name"; return; }
      fi
      [ -f "$main_kanban/reports/${task_id}/iteration-${search_iter}/$name" ] && { echo "$main_kanban/reports/${task_id}/iteration-${search_iter}/$name"; return; }
      if [ "$search_iter" != "1" ]; then
        [ -f "$main_kanban/reports/${task_id}/iteration-1/$name" ] && { echo "$main_kanban/reports/${task_id}/iteration-1/$name"; return; }
      fi
    fi
    # worktree 自身的 .kanban/
    if [ -n "$wt_kanban" ]; then
      [ -f "$wt_kanban/tasks/${task_id}/iteration-${search_iter}/$name" ] && { echo "$wt_kanban/tasks/${task_id}/iteration-${search_iter}/$name"; return; }
      [ -f "$wt_kanban/reports/${task_id}/iteration-${search_iter}/$name" ] && { echo "$wt_kanban/reports/${task_id}/iteration-${search_iter}/$name"; return; }
      if [ "$search_iter" != "1" ]; then
        [ -f "$wt_kanban/tasks/${task_id}/iteration-1/$name" ] && { echo "$wt_kanban/tasks/${task_id}/iteration-1/$name"; return; }
        [ -f "$wt_kanban/reports/${task_id}/iteration-1/$name" ] && { echo "$wt_kanban/reports/${task_id}/iteration-1/$name"; return; }
      fi
    fi
    echo ""
  }

  echo "============================================================"
  echo "  $task_id — $title"
  echo "  迭代轮次: $iter | 阶段: user_decision"
  echo "============================================================"

  # ── 1. 需求背景 ──
  echo ""
  echo "## 1. 需求背景"
  local req_file=$(_find_artifact "requirements.md")
  if [ -n "$req_file" ] && [ -f "$req_file" ]; then
    echo "  详见 → \`${req_file}\`"
    echo ""
    grep -E -- '^#{2,3} FR-' "$req_file" 2>/dev/null | sed 's/^#/  /' | head -15
    local fr_count=$(grep -cE -- '^#{2,3} FR-' "$req_file" 2>/dev/null)
    fr_count=${fr_count:-0}
    if [ "$fr_count" -eq 0 ]; then
      grep -E -- '^## ' "$req_file" 2>/dev/null | sed 's/^## /  - /' | head -10
    fi
  else
    echo "  (requirements.md 未找到)"
  fi

  # ── 2. 技术方案 ──
  echo ""
  echo "## 2. 技术方案"
  local decisions_file=$(_find_artifact "execution_decisions.md")
  if [ -n "$decisions_file" ] && [ -f "$decisions_file" ]; then
    echo "  详见 → \`${decisions_file}\`"
    echo ""
    # 提取决策标题 (### DEC-xxx 或 ## DEC-xxx)
    grep -E -- '^#{2,3} DEC-' "$decisions_file" 2>/dev/null | sed 's/^#/  /' | head -15
    local dec_count=$(grep -cE -- '^#{2,3} DEC-' "$decisions_file" 2>/dev/null)
    dec_count=${dec_count:-0}
    if [ "$dec_count" -eq 0 ]; then
      grep -E -- '^## |^### ' "$decisions_file" 2>/dev/null | sed 's/^#/  /' | head -10
    fi
  else
    echo "  (execution_decisions.md 未找到)"
  fi

  # ── 3. 任务拆解与完成进度 ──
  echo ""
  echo "## 3. 任务拆解与完成进度"
  local breakdown_file=$(_find_artifact "task_breakdown.json")
  if [ -n "$breakdown_file" ] && [ -f "$breakdown_file" ]; then
    echo "  详见 → \`${breakdown_file}\`"
    echo ""
    local total=$(jq '.subtasks | length' "$breakdown_file")
    # subtask 没有 status 字段时视为全部完成（已通过评估）
    local completed=$(jq '[.subtasks[] | select((.status // "completed") == "completed")] | length' "$breakdown_file" 2>/dev/null)
    [ -z "$completed" ] && completed="$total"
    echo "  总计: ${completed}/${total} subtasks 完成"
    echo ""
    echo "  | ID | 标题 | 优先级 | 依赖 |"
    echo "  |----|------|--------|------|"
    jq -r '.subtasks[] | "  | \(.id) | \(.title) | \(.priority) | \(.dependencies | if length > 0 then join(", ") else "-" end) |"' "$breakdown_file" 2>/dev/null | head -25
  else
    echo "  (task_breakdown.json 未找到)"
  fi

  # ── 4. 质量评估 ──
  echo ""
  echo "## 4. 质量评估"
  echo ""
  # 评分趋势
  echo "  ### 评分趋势"
  for i in $(seq 1 "$iter"); do
    local scores_line=""
    for role in $(_get_eval_roles); do
      local report=$(_find_artifact "${role}_report.json" "$i")
      if [ -n "$report" ] && [ -f "$report" ]; then
        local s=$(jq -r '.average_score // "N/A"' "$report")
        scores_line="${scores_line}${role}=${s} "
      elif [ -f "$rdir/${role}_report.json" ]; then
        local s=$(jq -r '.average_score // "N/A"' "$rdir/${role}_report.json")
        scores_line="${scores_line}${role}=${s} "
      fi
    done
    [ -n "$scores_line" ] && echo "  - Iteration ${i}: ${scores_line}"
  done

  # 当前轮次平均分
  local avg_score=$(jq -r '[.scores[] | .score] | add / length' "$tf" 2>/dev/null || echo "N/A")
  local all_pass=$(jq -r '[.scores[] | .passed] | all' "$tf" 2>/dev/null || echo "false")
  local pass_label="PASS"
  [ "$all_pass" = "false" ] && pass_label="FAIL"
  echo ""
  echo "  **当前轮次: ${avg_score}/10 (${pass_label})**"

  # 测试结果
  echo ""
  echo "  ### 测试结果"
  if [ -n "$wt_path" ] && [ -d "$wt_path" ]; then
    local test_files=$(cd "$wt_path" && find .claude/skills/kanban/test/ -name '*.sh' -type f 2>/dev/null || true)
    if [ -n "$test_files" ]; then
      cd "$wt_path"
      for tf_file in .claude/skills/kanban/test/*.sh; do
        [ -f "$tf_file" ] || continue
        local tname=$(basename "$tf_file")
        local tresult=$(bash "$tf_file" 2>/dev/null | grep -E 'passed.*failed|Passed.*Failed|Results:' | tail -1)
        echo "  - \`${tname}\`: ${tresult:-ran}"
      done
    fi
  fi

  # 各角色关键发现
  echo ""
  echo "  ### 各角色关键发现"
  for role in $(_get_eval_roles); do
    local report=$(_find_artifact "${role}_report.json")
    [ -n "$report" ] && [ -f "$report" ] || continue
    local summary=$(jq -r '.summary // ""' "$report" 2>/dev/null)
    if [ -n "$summary" ]; then
      echo "  **${role}** → \`${report}\`"
      echo "  ${summary}" | head -3
      echo ""
    fi
  done

  # ── 5. 变更文件 ──
  echo ""
  echo "## 5. 变更文件"
  if [ -n "$wt_path" ] && [ -d "$wt_path" ]; then
    local commit_count=$(cd "$wt_path" && git log --oneline "${trunk}..HEAD" 2>/dev/null | wc -l | tr -d ' ')
    local change_stat=$(cd "$wt_path" && git diff --shortstat "${trunk}...HEAD" 2>/dev/null)
    echo ""
    echo "  ${commit_count} commits, ${change_stat}"
    echo ""
    cd "$wt_path" && git diff --name-status "${trunk}...HEAD" 2>/dev/null | while IFS=$'\t' read -r chg_status filepath; do
      local status_label=""
      case "$chg_status" in
        A*) status_label="新增" ;;
        M*) status_label="修改" ;;
        D*) status_label="删除" ;;
        *)  status_label="$chg_status" ;;
      esac
      echo "  - [${status_label}] \`${filepath}\`"
    done
  else
    echo "  (worktree 不可用)"
  fi

  # ── 6. 可选操作 ──
  echo ""
  echo "## 6. 可选操作"
  echo "  - \`/kanban decide $task_id --action approve_and_archive\`  合并到主干并归档"
  echo "  - \`/kanban decide $task_id --action restart_from_plan\`    从 Plan 重新开始"
  echo "  - \`/kanban decide $task_id --action restart_from_execute\` 从 Execute 重新开始"
  echo "  - \`/kanban decide $task_id --action abort\`                终止任务"
  echo ""
}

# 准备调度上下文 — 一次性计算所有 Agent 需要的参数并写入 JSON
kanban_prepare_dispatch() {
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
  local dispatch_file="$ddir/${task_id}-execute.json"
  jq -n \
    --arg task_id "$task_id" \
    --arg title "$title" \
    --arg desc "$desc" \
    --argjson iter "$iter" \
    --arg wt_path "$wt_path" \
    --arg report_dir "$rdir" \
    --arg requirements "$( [ -f "$KANBAN_DIR/tasks/$task_id/requirements.md" ] && echo "$KANBAN_DIR/tasks/$task_id/requirements.md" || echo "${rdir}/requirements.md" )" \
    --arg breakdown "$( [ -f "$KANBAN_DIR/tasks/$task_id/task_breakdown.json" ] && echo "$KANBAN_DIR/tasks/$task_id/task_breakdown.json" || echo "${rdir}/task_breakdown.json" )" \
    --arg output_dir "$output_dir" \
    '{
      task_id: $task_id,
      title: $title,
      description: $desc,
      iteration: $iter,
      worktree_path: $wt_path,
      output_dir: $output_dir,
      report_dir: $report_dir,
      requirements_file: $requirements,
      breakdown_file: $breakdown
    }' > "$dispatch_file"

  # ST-009: 为 researcher agent 生成独立 dispatch JSON (如果配置了 trigger_condition)
  local researcher_dispatch="$ddir/${task_id}-researcher.json"
  if jq -e '[.phases[] | select(.id=="plan") | .agents[] | select(.role=="researcher")] | length > 0' "$KANBAN_DIR/workflow.json" >/dev/null 2>&1; then
    local trigger_keywords=$(jq -r '[.phases[] | select(.id=="plan") | .agents[] | select(.role=="researcher") | .trigger_condition.keywords // []] | flatten | .[]' "$KANBAN_DIR/workflow.json" 2>/dev/null)
    local need_research=false
    if [ -n "$trigger_keywords" ]; then
      for kw in $trigger_keywords; do
        if echo "$desc" | grep -qi -- "$kw"; then
          need_research=true
          break
        fi
      done
    fi
    if [ "$need_research" = "true" ]; then
      jq -n \
        --arg task_id "$task_id" \
        --arg title "$title" \
        --arg desc "$desc" \
        --argjson iter "$iter" \
        --arg report_dir "$rdir" \
        --arg output_dir "$output_dir" \
        '{
          task_id: $task_id,
          title: $title,
          research_topic: $desc,
          constraints: "Focus on feasibility, alternatives, and recommendations",
          iteration: $iter,
          report_dir: $report_dir,
          output_dir: $output_dir
        }' > "$researcher_dispatch"
      echo "Generated researcher dispatch: $researcher_dispatch"
    fi
  fi

  echo "$dispatch_file"
}

# 从 task_breakdown.json 初始化子任务状态到 TASK-NNN.json
# 用法: kanban_init_subtasks TASK-001
kanban_init_subtasks() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local breakdown_file=$(jq -r '.task_breakdown.file // ""' "$tf")

  [ -z "$breakdown_file" ] && { echo "WARN: no breakdown file for $task_id"; return 0; }
  [ ! -f "$breakdown_file" ] && { echo "WARN: $breakdown_file not found"; return 0; }

  local subtasks_with_status=$(jq '[.subtasks[] | {id, title, status: "pending"}]' "$breakdown_file")
  local count=$(echo "$subtasks_with_status" | jq 'length')

  kanban_update_task "$task_id" \
    ".task_breakdown.subtasks = $subtasks_with_status"

  echo "Initialized $count subtasks for $task_id"
}

# 更新单个子任务状态
# 用法: kanban_update_subtask TASK-001 ST-003 in_progress
kanban_update_subtask() {
  local task_id="$1"
  local subtask_id="$2"
  local subtask_status="$3"  # pending | in_progress | completed | failed
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }
  [ -z "$subtask_status" ] && { echo "ERROR: status required"; return 1; }

  local now=$(date -u +%FT%TZ)
  local tmp=$(mktemp)
  jq --arg sid "$subtask_id" --arg st "$subtask_status" --arg t "$now" \
    '(.task_breakdown.subtasks[] | select(.id == $sid)).status = $st | .updated_at = $t' \
    "$tf" > "$tmp" && mv "$tmp" "$tf"

  echo "Subtask $subtask_id -> $subtask_status"
}

# === Inbox 反馈管理 ===

# 创建任务的 inbox.md
# 用法: kanban_create_inbox TASK-001
kanban_create_inbox() {
  local task_id="$1"
  local title="$2"
  local inbox_path="$KANBAN_DIR/tasks/${task_id}/inbox.md"

  [ -f "$inbox_path" ] && return 0

  mkdir -p "$KANBAN_DIR/tasks/${task_id}"
  cat > "$inbox_path" << INBOXEOF
# ${task_id} Inbox

> 在下方「待处理」区域添加反馈，每条以 \`- [ ]\` 开头。
> 运行 \`/kanban feedback ${task_id}\` 分析归档。

## 已归档

## 待处理

INBOXEOF

  echo "Created inbox: $inbox_path"
}

# 读取 inbox.md 中的待处理反馈条目
# 输出每行一条反馈（去掉 "- [ ] " 前缀）
kanban_read_pending_feedback() {
  local task_id="$1"
  local inbox_path=$(inbox_file "$task_id")

  [ ! -f "$inbox_path" ] && { echo "ERROR: inbox not found for $task_id"; return 1; }

  # 提取 "## 待处理" 到文件末尾之间的 "- [ ] " 行
  sed -n '/^## 待处理/,$ { /^- \[ \]/p; }' "$inbox_path" \
    | sed 's/^- \[ \] //'
}

# 将一条反馈归档到 inbox.md 的已归档区
# 用法: kanban_write_archived_feedback TASK-001 "反馈内容" "需求" "已追加到 requirements.md"
#       kanban_write_archived_feedback TASK-001 "反馈内容" "需求" "已迁移" --migrate-to TASK-042
kanban_write_archived_feedback() {
  local task_id="$1"
  local feedback="$2"
  local category="$3"
  local action="$4"
  shift 4 2>/dev/null || true
  local migrate_to=""
  if [ "$1" = "--migrate-to" ] && [ -n "$2" ]; then
    migrate_to="$2"
  fi
  local inbox_path=$(inbox_file "$task_id")

  local now=$(date +%Y-%m-%d)

  # 在 "## 已归档" 后追加归档记录
  local tmp=$(mktemp)
  awk -v fb="$feedback" -v cat="$category" -v act="$action" -v dt="$now" -v mt="$migrate_to" '
    /^## 已归档/ {
      print
      print ""
      print "**反馈**: " fb
      print "**分类**: " cat
      if (mt != "") {
        print "**处理**: " act " → 已迁移至 " mt " 处理"
      } else {
        print "**处理**: " act
      }
      print ""
      next
    }
    { print }
  ' "$inbox_path" > "$tmp" && mv "$tmp" "$inbox_path"

  # 从待处理区删除该条，或标记为已迁移
  local tmp2=$(mktemp)
  awk -v fb="$feedback" -v mt="$migrate_to" '
    /^## 待处理/ { in_pending=1 }
    in_pending && $0 == "- [ ] " fb {
      if (mt != "") {
        print "- [x] " fb " → 已迁移至 " mt " 处理"
      }
      next
    }
    { print }
  ' "$inbox_path" > "$tmp2" && mv "$tmp2" "$inbox_path"
}

# === 内部函数 ===

# _update_index 只在此文件定义，其他 lib 直接调用
_update_index() {
  local tasks_summary="[]"
  # 新格式: tasks/TASK-NNN/task.json
  for task_dir_entry in "$KANBAN_DIR"/tasks/TASK-*/; do
    [ -d "$task_dir_entry" ] || continue
    local tf="$task_dir_entry/task.json"
    [ -f "$tf" ] || continue
    local summary=$(jq '{id, status, phase, iteration}' "$tf")
    tasks_summary=$(echo "$tasks_summary" | jq --argjson s "$summary" '. + [$s]')
  done
  # 旧格式兼容: tasks/TASK-NNN.json
  for task_file_entry in "$KANBAN_DIR"/tasks/TASK-*.json; do
    [ -f "$task_file_entry" ] || continue
    local summary=$(jq '{id, status, phase, iteration}' "$task_file_entry")
    tasks_summary=$(echo "$tasks_summary" | jq --argjson s "$summary" '. + [$s]')
  done
  local project=$(jq -r '.project // "unknown"' "$KANBAN_DIR/config.json")
  local trunk=$(jq -r '.trunk // "main"' "$KANBAN_DIR/config.json")
  # 使用 mktemp 实现原子写入
  local tmp=$(mktemp)
  jq -n --arg p "$project" --arg t "$trunk" --argjson tasks "$tasks_summary" \
    '{project:$p, trunk:$t, tasks:$tasks}' > "$tmp" \
    && mv "$tmp" "$KANBAN_DIR/index.json"
}

# --- Knowledge Log Functions ---

# kanban_knowledge_add: 添加知识条目到 knowledge-log.md
# 用法: kanban_knowledge_add "分类" "描述" "来源任务ID"
kanban_knowledge_add() {
  local category="$1"
  local description="$2"
  local source="${3:-unknown}"
  local log_file="${KANBAN_DIR}/knowledge-log.md"

  # 获取下一个编号
  local next_num=1
  if [[ -f "$log_file" ]]; then
    local last_num=$(grep -o -- 'K[0-9]\{3\}' "$log_file" | tail -1 | sed 's/K//')
    if [[ -n "$last_num" ]]; then
      next_num=$((10#$last_num + 1))
    fi
  fi
  local id=$(printf "K%03d" $next_num)

  # Build entry using printf (avoids sed injection from variable interpolation)
  local entry
  entry=$(printf '\n### %s: %s\n- **分类**: %s\n- **来源**: %s\n- **描述**: %s\n\n---' \
    "$id" "$category" "$category" "$source" "$description")

  # Atomic write via mktemp
  local tmp=$(mktemp)
  if [[ -f "$log_file" ]] && grep -q -- '^## 条目' "$log_file"; then
    # Append after "## 条目" section header using awk (safe, no variable in regex)
    awk -v entry="$entry" '/^## 条目/{print; print entry; next}1' "$log_file" > "$tmp" \
      && mv "$tmp" "$log_file"
  else
    printf '%s\n' "$entry" >> "$log_file"
  fi

  echo "Added ${id}: ${category}"
}

# kanban_knowledge_list: 列出知识条目
# 用法: kanban_knowledge_list [分类]
kanban_knowledge_list() {
  local filter="${1:-}"
  local log_file="${KANBAN_DIR}/knowledge-log.md"

  if [[ ! -f "$log_file" ]]; then
    echo "Knowledge log not found"
    return 1
  fi

  if [[ -n "$filter" ]]; then
    # Extract full entry blocks (### K... through ---), then filter by category
    awk -v cat="$filter" '
      /^### K[0-9]{3}/ { block=$0; next }
      /^---/ && block != "" {
        if (block ~ cat) print block "\n---"
        block=""; next
      }
      block != "" { block = block "\n" $0 }
    ' "$log_file"
  else
    grep -A 3 -- "^### K[0-9]\{3\}" "$log_file"
  fi
}

# kanban_knowledge_search: 搜索知识条目
# 用法: kanban_knowledge_search "关键词"
kanban_knowledge_search() {
  local keyword="$1"
  local log_file="${KANBAN_DIR}/knowledge-log.md"

  if [[ ! -f "$log_file" ]]; then
    echo "Knowledge log not found"
    return 1
  fi

  # Find matching entry IDs using fixed-string match (safe for special chars)
  local matched_ids=$(grep -F -- "$keyword" "$log_file" | grep -o -- '^### K[0-9]\{3\}' | sed 's/^### //' || true)
  if [[ -z "$matched_ids" ]]; then
    matched_ids=$(grep -F -B 5 -- "$keyword" "$log_file" | grep -o -- 'K[0-9]\{3\}' | sort -u || true)
  fi
  if [[ -z "$matched_ids" ]]; then
    return 0
  fi

  for kid in $matched_ids; do
    sed -n "/^### ${kid}:/,/^---/p" "$log_file"
  done
}

# --- Progress Functions ---

# kanban_progress: 展示迭代评分趋势
# 用法: kanban_progress [task_id]
kanban_progress() {
  local task_id="${1:-}"

  if [[ -n "$task_id" ]]; then
    # 单任务趋势
    local tf=$(task_file "$task_id")
    if [[ ! -f "$tf" ]]; then
      # 尝试归档
      tf=$(archive_task_file "$task_id")
    fi
    if [[ ! -f "$tf" ]]; then
      echo "Task ${task_id} not found"
      return 1
    fi

    echo "=== Progress: ${task_id} ==="
    local title=$(jq -r '.title // empty' "$tf")
    echo "Title: ${title}"
    echo ""

    # 遍历任务目录中的 iteration 目录
    local tdir=$(task_dir "$task_id")
    if [[ ! -d "$tdir" ]]; then
      echo "No task directory found"
      return 0
    fi

    echo "Iteration | Scores"
    echo "----------|-------"
    for iter_dir in $(ls -d "${tdir}"/iteration-* 2>/dev/null | sort -t- -k2 -n); do
      local iter_num=$(basename "$iter_dir" | sed 's/iteration-//')
      local scores=""
      for role in $(_get_eval_roles); do
        local report="${iter_dir}/${role}_report.json"
        if [[ -f "$report" ]]; then
          local score=$(jq -r '.score // .overall_score // empty' "$report" 2>/dev/null)
          if [[ -n "$score" ]]; then
            scores="${scores}${role}=${score} "
          fi
        fi
      done
      if [[ -n "$scores" ]]; then
        echo "iter-${iter_num}    | ${scores}"
      fi
    done
  else
    # 全局趋势
    echo "=== Kanban Progress Overview ==="
    echo ""
    # 新格式: archive/TASK-NNN/task.json
    for archive_entry in "${KANBAN_DIR}/archive/"*; do
      local tf_entry=""
      if [ -d "$archive_entry" ] && [ -f "$archive_entry/task.json" ]; then
        tf_entry="$archive_entry/task.json"
      elif [ -f "$archive_entry" ] && [[ "$(basename "$archive_entry")" == TASK-*.json ]]; then
        tf_entry="$archive_entry"
      else
        continue
      fi
      local tid=$(jq -r '.id // empty' "$tf_entry")
      local title=$(jq -r '.title // empty' "$tf_entry")
      local final_score=""
      # 查找最后一次迭代的评分 -- 检查归档目录中的 iteration 目录
      local archive_path="$archive_entry"
      if [ -d "$archive_path" ]; then
        for iter_dir in $(ls -d "${archive_path}"/iteration-* 2>/dev/null | sort -t- -k2 -n -r); do
          for role in $(_get_eval_roles); do
            local report="${iter_dir}/${role}_report.json"
            if [[ -f "$report" ]]; then
              local score=$(jq -r '.score // .overall_score // empty' "$report" 2>/dev/null)
              if [[ -n "$score" ]]; then
                final_score="${final_score}${role}=${score} "
              fi
            fi
          done
          [[ -n "$final_score" ]] && break
        done
      fi
      echo "${tid}: ${title}"
      [[ -n "$final_score" ]] && echo "  Final: ${final_score}"
      echo ""
    done
  fi
}

# kanban_score_history: 展示评分历史趋势
# 用法: kanban_score_history <task_id>
kanban_score_history() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  [[ ! -f "$tf" ]] && tf=$(archive_task_file "$task_id")
  [[ ! -f "$tf" ]] && { echo "Task ${task_id} not found"; return 1; }

  echo "=== Score History: ${task_id} ==="
  echo ""

  # Build dynamic header from evaluate roles
  local _eval_roles=$(_get_eval_roles)
  local header="Iteration |"
  local sep="----------|"
  for role in $_eval_roles; do
    local col_name
    case "$role" in
      code_reviewer) col_name="code_reviewer" ;;
      *)             col_name="$role" ;;
    esac
    printf -v col_fmt "%-13s" "$col_name"
    header="${header} ${col_fmt}|"
    sep="${sep}---------------|"
  done
  header="${header} Avg"
  sep="${sep}-----"
  echo "$header"
  echo "$sep"

  # 从任务目录中提取评分记录
  local scores_by_iter=""
  local tdir=$(task_dir "$task_id")
  # 如果是归档任务，尝试从 archive 目录获取
  if [ ! -d "$tdir" ] || [ "$(ls -d "$tdir"/iteration-* 2>/dev/null | wc -l | tr -d ' ')" = "0" ]; then
    local adir=$(archive_dir "$task_id")
    if [ -d "$adir" ]; then
      tdir="$adir"
    fi
  fi

  # Collect iteration directories safely (avoid nullglob issues with ls -d)
  local iter_dirs=()
  while IFS= read -r d; do
    [ -d "$d" ] && iter_dirs+=("$d")
  done < <(find "${tdir}" -maxdepth 1 -type d -name 'iteration-*' 2>/dev/null | sort -t- -k2 -n)

  [[ ${#iter_dirs[@]} -eq 0 ]] && return 0

  for iter_dir in "${iter_dirs[@]}"; do
    local iter_num=$(basename "$iter_dir" | sed 's/iteration-//')
    local line="iter-${iter_num}    |"
    local sum=0 count=0

    for role in $(_get_eval_roles); do
      local report="${iter_dir}/${role}_report.json"
      if [[ -f "$report" ]]; then
        local score=$(jq -r '.score // .overall_score // "N/A"' "$report" 2>/dev/null)
        if [[ "$score" != "N/A" && "$score" != "null" ]]; then
          line="${line} ${score}        |"
          sum=$(echo "$sum + $score" | bc 2>/dev/null || echo "0")
          count=$((count + 1))
        else
          line="${line} N/A      |"
        fi
      else
        line="${line} N/A      |"
      fi
    done

    if [[ $count -gt 0 ]]; then
      local avg=$(echo "scale=2; $sum / $count" | bc 2>/dev/null || echo "N/A")
      line="${line} ${avg}"
    fi

    echo "$line"
  done
}

# ─── 版本管理 ────────────────────────────────────────

# kanban_version_init: 初始化 .kanban/versions/ 目录
kanban_version_init() {
  local vdir="${KANBAN_DIR}/versions"
  mkdir -p "$vdir"
  if [ ! -f "$vdir/CHANGELOG.md" ]; then
    cat > "$vdir/CHANGELOG.md" <<'CHANGELOG_EOF'
# Kanban Framework — Changelog

所有版本的迭代记录索引。每个版本有对应的详细记录文件 `v{X.Y.Z}.md`。

<!-- 格式:
## [vX.Y.Z] - YYYY-MM-DD
### Added / Changed / Fixed / Removed
- ...

详细记录见 `vX.Y.Z.md`
-->

CHANGELOG_EOF
    echo "Initialized versions at ${vdir}/"
  else
    echo "Versions already initialized at ${vdir}/"
  fi
}

# kanban_check_version_naming: 检查版本文件命名规范 (R-007)
kanban_check_version_naming() {
  local vdir="${KANBAN_DIR}/versions"
  [ ! -d "$vdir" ] && return 0

  local bad_files=()
  while IFS= read -r f; do
    local base=$(basename "$f")
    # 跳过 CHANGELOG.md 和目录
    [ "$base" = "CHANGELOG.md" ] && continue
    [ -d "$f" ] && continue
    # 检查是否匹配 v{X.Y.Z}.md
    if ! echo "$base" | grep -qE '^v[0-9]+\.[0-9]+\.[0-9]+\.md$'; then
      bad_files+=("$base")
    fi
  done < <(find "$vdir" -maxdepth 1 -name '*.md' -type f)

  if [ ${#bad_files[@]} -gt 0 ]; then
    echo "WARNING: Non-standard version file names detected (expected v{X.Y.Z}.md):"
    for bf in "${bad_files[@]}"; do
      echo "  $bf"
    done
    return 1
  fi
  return 0
}

# kanban_version_list: 列出版本历史
kanban_version_list() {
  local cl="${KANBAN_DIR}/versions/CHANGELOG.md"
  if [ ! -f "$cl" ]; then
    echo "No versions found. Run kanban_version_init first."
    return 1
  fi
  local current=$(jq -r '.version // "unknown"' "${KANBAN_DIR}/config.json" 2>/dev/null)
  echo "=== Kanban Framework Versions (current: v${current}) ==="
  echo ""
  grep -E -- '^## \[v' "$cl" | while read -r line; do
    local ver=$(echo "$line" | sed 's/## \[\(v[^]]*\)\].*/\1/')
    local marker=""
    [ "v${current}" = "$ver" ] && marker=" ← current"
    echo "  ${line### }${marker}"
  done
  echo ""
  local count=$(find "${KANBAN_DIR}/versions/" -name 'v*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
  echo "  共 ${count} 个版本记录"

  # R-007: 命名规范检查
  kanban_check_version_naming
}

# kanban_version_record: 记录一个版本
# 用法: kanban_version_record <version> [--title "标题"] [--task TASK-NNN]
kanban_version_record() {
  local version="$1"
  shift
  local title=""
  local task_id=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --title) title="$2"; shift 2 ;;
      --task) task_id="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  [ -z "$version" ] && { echo "Usage: kanban_version_record <version> [--title ...] [--task ...]"; return 1; }

  # R-007: 自动补全 v 前缀
  [[ "$version" != v* ]] && version="v${version}"

  local vdir="${KANBAN_DIR}/versions"
  mkdir -p "$vdir"

  # 确保 CHANGELOG.md 存在
  [ ! -f "$vdir/CHANGELOG.md" ] && kanban_version_init

  local today=$(date +%Y-%m-%d)
  local vfile="${vdir}/${version}.md"

  # 从 task_id 获取详细信息（如果提供）
  local task_title=""
  local iter="1"
  local avg_score="N/A"
  local test_summary=""
  if [ -n "$task_id" ]; then
    local tf=$(task_file "$task_id")
    if [ -f "$tf" ]; then
      task_title=$(jq -r '.title // ""' "$tf")
      iter=$(jq -r '.iteration // 1' "$tf")
      avg_score=$(jq -r '[.scores[] | .score] | add / length' "$tf" 2>/dev/null || echo "N/A")
    fi
  fi

  [ -z "$title" ] && [ -n "$task_title" ] && title="$task_title"

  # 生成版本记录文件
  cat > "$vfile" <<VEREOF
# ${version} — ${title:-版本迭代}

**日期**: ${today}
**关联任务**: ${task_id:-手动记录}
**迭代轮次**: ${iter}

## 改动摘要

（待补充）

## 模块变更清单

| 模块 | 文件 | 变更类型 |
|------|------|----------|
|  |  |  |

## 验收状态

- 评分: ${avg_score}/10
- 测试: （待补充）
- 评估: （待补充）

## 升级指南

（待补充）
VEREOF

  # 在 CHANGELOG.md 头部插入新版本条目
  local tmpfile=$(mktemp)
  awk -v ver="$version" -v date="$today" -v t="$title" '
    /^<!-- 格式:/ { print; print ""; print "## [" ver "] - " date; print "### Added"; print "- " t; print ""; print "详细记录见 `" ver ".md`"; print ""; next }
    { print }
  ' "$vdir/CHANGELOG.md" > "$tmpfile"
  mv "$tmpfile" "$vdir/CHANGELOG.md"

  # 更新 config.json 中的 version 字段
  local ver_num="${version#v}"
  local cfg="${KANBAN_DIR}/config.json"
  if [ -f "$cfg" ]; then
    local cfg_tmp=$(mktemp)
    jq --arg v "$ver_num" '. + {version: $v}' "$cfg" > "$cfg_tmp" && mv "$cfg_tmp" "$cfg"
  fi

  # 同步更新 plugin.json version
  local plugin_json="${SKILL_DIR}/../../.claude-plugin/plugin.json"
  [ ! -f "$plugin_json" ] && plugin_json=".claude-plugin/plugin.json"
  if [ -f "$plugin_json" ]; then
    local pj_tmp=$(mktemp)
    jq --arg v "$ver_num" '. + {version: $v}' "$plugin_json" > "$pj_tmp" && mv "$pj_tmp" "$plugin_json"
  fi

  # 创建 git tag
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if ! git rev-parse "$version" > /dev/null 2>&1; then
      git tag -a "$version" -m "Release ${version}: ${title:-版本迭代}"
    fi
  fi

  echo "Version ${version} recorded:"
  echo "  → ${vfile}"
  echo "  → ${vdir}/CHANGELOG.md (updated)"
  echo "  → config.json version=${ver_num}"
  [ -f "$plugin_json" ] && echo "  → plugin.json version=${ver_num}"
  git rev-parse "$version" > /dev/null 2>&1 && echo "  → git tag ${version}"
}

# === ST-001: 归档清理命令 ===
# kanban_clean_archived() -- 清理已归档任务的磁盘资源
# 用法:
#   kanban_clean_archived "TASK-001"              -- 清理单个已归档任务
#   kanban_clean_archived "--all"                  -- 清理所有已归档任务
#   kanban_clean_archived "--before" "2026-04-01"  -- 清理指定日期之前归档的任务
# 安全检查: 仅清理 user_decision.action 为 approve_and_archive 或 abort 的任务
# 幂等性: 已清理的任务跳过
kanban_clean_archived() {
  local target="$1"
  local date_filter="${2:-}"

  [ ! -d "$KANBAN_DIR" ] && { echo "ERROR: kanban not initialized"; return 1; }

  local archive_base="$KANBAN_DIR/archive"
  [ ! -d "$archive_base" ] && { echo "No archived tasks found"; return 0; }

  # 收集候选任务列表
  local candidates=""
  local task_list=""

  if [ "$target" = "--all" ]; then
    # 收集所有归档任务
    for d in "$archive_base"/TASK-*/; do
      [ -d "$d" ] || continue
      local tid=$(basename "$d")
      task_list="${task_list} ${tid}"
    done
    # 旧格式兼容
    for f in "$archive_base"/TASK-*.json; do
      [ -f "$f" ] || continue
      local tid=$(basename "$f" .json)
      echo "$task_list" | grep -qw "$tid" || task_list="${task_list} ${tid}"
    done
  elif [ "$target" = "--before" ]; then
    [ -z "$date_filter" ] && { echo "ERROR: --before requires a date argument (e.g. 2026-04-01)"; return 1; }
    # 验证日期格式
    echo "$date_filter" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' || { echo "ERROR: invalid date format, use YYYY-MM-DD"; return 1; }
    for d in "$archive_base"/TASK-*/; do
      [ -d "$d" ] || continue
      local tid=$(basename "$d")
      local tf="$d/task.json"
      [ -f "$tf" ] || continue
      local archived_date=$(jq -r '.user_decision.decided_at // .updated_at // .created_at // "1970-01-01"' "$tf" 2>/dev/null | cut -dT -f1)
      if [ "$archived_date" \< "$date_filter" ] || [ "$archived_date" = "$date_filter" ]; then
        task_list="${task_list} ${tid}"
      fi
    done
  elif echo "$target" | grep -qE '^TASK-[0-9]{3}$'; then
    # 指定单个任务
    task_list=" $target"
  else
    echo "Usage: kanban_clean_archived {TASK-NNN | --all | --before YYYY-MM-DD}"
    return 1
  fi

  # 过滤: 仅保留安全状态的任务
  local safe_list=""
  local skipped_list=""
  for tid in $task_list; do
    local tf="$archive_base/${tid}/task.json"
    # 旧格式兼容
    [ ! -f "$tf" ] && tf="$archive_base/${tid}.json"
    if [ ! -f "$tf" ]; then
      skipped_list="${skipped_list}\n  ${tid}: archive file not found, skipping"
      continue
    fi
    local action=$(jq -r '.user_decision.action // ""' "$tf" 2>/dev/null)
    if [ "$action" = "approve_and_archive" ] || [ "$action" = "abort" ]; then
      safe_list="${safe_list} ${tid}"
    else
      skipped_list="${skipped_list}\n  ${tid}: action='${action:-empty}', not safe to clean"
    fi
  done

  [ -n "$skipped_list" ] && echo -e "Skipped tasks:${skipped_list}"

  if [ -z "$safe_list" ]; then
    echo "No tasks to clean"
    return 0
  fi

  # 预览: 计算大小并显示列表
  local total_size=0
  echo ""
  echo "=== Tasks to clean ==="
  for tid in $safe_list; do
    local adir="$archive_base/${tid}"
    local size=0
    if [ -d "$adir" ]; then
      size=$(du -sk "$adir" 2>/dev/null | cut -f1 || echo 0)
    elif [ -f "$adir" ] || [ -f "$archive_base/${tid}.json" ]; then
      size=$(du -sk "${adir}.json" 2>/dev/null | cut -f1 || echo 0)
    else
      size=0
    fi
    total_size=$((total_size + size))
    local tf="$adir/task.json"
    [ ! -f "$tf" ] && tf="$archive_base/${tid}.json"
    local action=$(jq -r '.user_decision.action // "unknown"' "$tf" 2>/dev/null)
    local title=$(jq -r '.title // "unknown"' "$tf" 2>/dev/null | head -c 40)
    printf "  %-12s  %6sk  %-20s  %s\n" "$tid" "$size" "$action" "$title"
  done
  echo "  ----------------------------------------"
  printf "  Total: %d tasks, %sk disk space\n" "$(echo "$safe_list" | wc -w | tr -d ' ')" "$total_size"
  echo ""

  # 执行清理
  local cleaned=0
  local failed=0
  for tid in $safe_list; do
    local adir="$archive_base/${tid}"
    local afile="$archive_base/${tid}.json"
    local cleaned_this=false

    # 清理归档目录
    if [ -d "$adir" ]; then
      if rm -rf "$adir"; then
        echo "  [cleaned] ${tid}: archive directory removed"
        cleaned_this=true
      else
        echo "  [FAILED] ${tid}: failed to remove archive directory"
        failed=$((failed + 1))
        continue
      fi
    elif [ -f "$afile" ]; then
      if rm -f "$afile"; then
        echo "  [cleaned] ${tid}: archive file removed"
        cleaned_this=true
      else
        echo "  [FAILED] ${tid}: failed to remove archive file"
        failed=$((failed + 1))
        continue
      fi
    else
      echo "  [skip] ${tid}: already cleaned"
      cleaned=$((cleaned + 1))
      continue
    fi

    # 清理残留 git worktree
    local tf_bak="$KANBAN_DIR/tasks/${tid}/task.json"
    # 从归档前路径尝试获取 worktree 信息
    local wt_branch=""
    if [ "$cleaned_this" = "true" ]; then
      # 分支名格式: feature/TASK-NNN
      wt_branch="feature/${tid}"
    fi
    # 尝试清理残留 worktree 目录
    for wt_dir in "$KANBAN_DIR/worktrees/${tid}" "$KANBAN_DIR/tasks/${tid}/worktree"; do
      if [ -d "$wt_dir" ]; then
        rm -rf "$wt_dir" 2>/dev/null && echo "  [cleaned] ${tid}: worktree directory removed (${wt_dir})" || true
      fi
    done

    # 尝试清理残留 git 分支
    if [ -n "$wt_branch" ] && git rev-parse --git-dir >/dev/null 2>&1; then
      if git show-ref --verify --quiet "refs/heads/${wt_branch}" 2>/dev/null; then
        git branch -D "$wt_branch" 2>/dev/null && echo "  [cleaned] ${tid}: branch '${wt_branch}' deleted" || true
      fi
    fi

    # 清理残留 candidate JSON
    for cand in "$KANBAN_DIR"/skills/evolved/*-"${tid}"*.json; do
      [ -f "$cand" ] || continue
      rm -f "$cand" 2>/dev/null && echo "  [cleaned] ${tid}: candidate file removed ($(basename "$cand"))" || true
    done

    cleaned=$((cleaned + 1))
  done

  echo ""
  echo "=== Clean completed ==="
  echo "  Cleaned: ${cleaned} tasks"
  [ "$failed" -gt 0 ] && echo "  Failed: ${failed} tasks"
  echo "  Freed: ${total_size}k disk space"

  _update_index

  return 0
}
