#!/usr/bin/env bash
# worktree.sh — Git Worktree 管理 (wt + 原生 git 回退)
# 依赖: git
#
# ST-004: worktree 目录内聚改造
# 新任务默认路径: $KANBAN_DIR/tasks/${task_id}/worktree
# 旧任务兼容: 读取 task.json 中 worktree.path (指向 .kanban/worktrees/TASK-NNN)
# task.json 的 worktree.path 是路径的真实来源 (source of truth)

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# 系统初始化检查
check_prerequisites() {
  command -v jq >/dev/null 2>&1 || { echo "ERROR: jq required"; return 1; }
  command -v git >/dev/null 2>&1 || { echo "ERROR: git required"; return 1; }
  command -v wt >/dev/null 2>&1 || echo "INFO: agent-worktree not installed, using native git worktree"
  return 0
}

# 计算新任务默认 worktree 路径: $KANBAN_DIR/tasks/${task_id}/worktree
# 这是 ST-004 引入的新默认路径，实现任务目录内聚
_worktree_default_path() {
  local task_id="$1"
  echo "$KANBAN_DIR/tasks/${task_id}/worktree"
}

# 获取 worktree 路径 (兼容新旧路径)
# 优先从 task.json 的 worktree.path 读取（旧任务可能指向 .kanban/worktrees/TASK-NNN）
# 如果 worktree.path 为空，使用新默认路径
_worktree_resolve_path() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local existing_path=$(jq -r '.worktree.path // ""' "$tf" 2>/dev/null)
  if [ -n "$existing_path" ]; then
    echo "$existing_path"
  else
    _worktree_default_path "$task_id"
  fi
}

# 创建 worktree (幂等: 已存在有效 worktree 时跳过)
worktree_create() {
  local task_id="$1"
  local branch="$2"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  # 幂等性检查: 如果 worktree_validate 返回 valid，跳过创建
  local validate_result
  validate_result=$(worktree_validate "$task_id" 2>/dev/null)
  if [ $? -eq 0 ]; then
    local existing_path=$(echo "$validate_result" | jq -r '. // empty' >/dev/null 2>&1 && echo "valid")
    echo "Worktree already exists for $task_id, skipping creation"
    return 0
  fi

  # 优先使用 agent-worktree
  if command -v wt >/dev/null 2>&1; then
    if wt new "$branch" 2>/dev/null; then
      local wt_path=$(wt path "$branch" 2>/dev/null || echo "")
      kanban_update_task "$task_id" ".worktree.branch=\"$branch\" | .worktree.path=\"$wt_path\""
      echo "Created worktree via wt: $branch"
      return 0
    fi
    echo "WARN: wt command failed, falling back to native git"
  fi

  # ST-004: 新默认路径 -- $KANBAN_DIR/tasks/${task_id}/worktree
  # 但如果 task.json 已有 worktree.path（旧任务迁移场景），沿用旧路径
  local wt_dir=$(_worktree_resolve_path "$task_id")

  # 安全检查: worktree 路径必须在 .kanban/ 下，防止误创建到 .claude/ 等其他位置
  case "$wt_dir" in
    .kanban/*|.kanban/tasks/*) ;;
    *)
      echo "ERROR: worktree path must be under .kanban/, got: $wt_dir"
      return 1
      ;;
  esac

  mkdir -p "$(dirname "$wt_dir")"

  if git worktree add "$wt_dir" -b "$branch" HEAD 2>/dev/null; then
    local abs_path="$(cd "$wt_dir" && pwd)"
    # source kanban.sh 的 kanban_update_task 如果可用
    if type kanban_update_task >/dev/null 2>&1; then
      kanban_update_task "$task_id" ".worktree.branch=\"$branch\" | .worktree.path=\"$abs_path\""
    else
      local now=$(date -u +%FT%TZ)
      jq --arg b "$branch" --arg p "$abs_path" --arg t "$now" \
        '.worktree.branch=$b | .worktree.path=$p | .updated_at=$t' \
        "$tf" > "/tmp/${task_id}.tmp" && mv "/tmp/${task_id}.tmp" "$tf"
    fi
    echo "Created worktree via git: $branch at $wt_dir"
    return 0
  fi

  echo "ERROR: failed to create worktree for $branch"
  return 1
}

# 合并 worktree 到主干
worktree_merge() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && { echo "ERROR: $task_id not found"; return 1; }

  local branch=$(jq -r '.worktree.branch // ""' "$tf")
  local trunk=$(jq -r '.trunk // "main"' "$KANBAN_DIR/config.json")

  # Bug #18 fix: verify trunk branch exists, fall back to actual HEAD
  if ! git show-ref --verify "refs/heads/${trunk}" >/dev/null 2>&1; then
    local actual_head=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$actual_head" ] && [ "$actual_head" != "HEAD" ] && git show-ref --verify "refs/heads/${actual_head}" >/dev/null 2>&1; then
      echo "WARNING: trunk '${trunk}' not found, falling back to actual HEAD '${actual_head}'"
      trunk="$actual_head"
    else
      echo "ERROR: neither trunk '${trunk}' nor HEAD branch found. Cannot merge."
      return 1
    fi
  fi

  # 优先使用 agent-worktree
  if command -v wt >/dev/null 2>&1; then
    if wt merge -d 2>/dev/null; then
      echo "Merged via wt: $branch -> $trunk"
      return 0
    fi
  fi

  # 回退: 原生 git merge --squash
  local wt_dir=$(jq -r '.worktree.path // ""' "$tf")
  if [ -n "$wt_dir" ] && [ -d "$wt_dir" ]; then
    git checkout "$trunk" && \
    git merge --squash "$branch" && \
    git commit -m "merge: $branch (squash)" && \
    git branch -D "$branch" && \
    git worktree prune
    echo "Merged via git: $branch -> $trunk (squash)"
    return 0
  fi

  # worktree 目录不存在时的容错处理
  if [ -z "$branch" ]; then
    echo "WARNING: no branch recorded for $task_id, skipping merge"
    return 0
  fi

  # 检查分支是否已经合并到 trunk
  if git branch --merged "$trunk" 2>/dev/null | sed 's/^[* ]*//' | grep -qx -- "$branch"; then
    echo "WARNING: worktree directory not found, but branch '$branch' is already merged into $trunk"
    git branch -D "$branch" 2>/dev/null || true
    git worktree prune 2>/dev/null || true
    return 0
  fi

  echo "ERROR: worktree directory not found and branch '$branch' is not merged into $trunk. Manual resolution required."
  return 1
}

# 清理 worktree (中止或归档时)
# ST-004: 清理后如果 worktree 是 tasks/TASK-NNN/ 下的子目录，仅删除 worktree 目录本身
# 保留 tasks/TASK-NNN/ 中的 task.json 和其他产物
worktree_cleanup() {
  local task_id="$1"
  local tf=$(task_file "$task_id")

  [ ! -f "$tf" ] && return 0

  local branch=$(jq -r '.worktree.branch // ""' "$tf")
  local wt_dir=$(jq -r '.worktree.path // ""' "$tf")

  [ -z "$branch" ] && [ -z "$wt_dir" ] && return 0

  # 安全检查: 只清理 .kanban/ 下的路径，绝不触碰 .claude/ (Claude Code 原生 worktree)
  if [ -n "$wt_dir" ] && [ -d "$wt_dir" ]; then
    local abs_wt_dir="$(cd "$wt_dir" 2>/dev/null && pwd)" || abs_wt_dir="$wt_dir"
    case "$abs_wt_dir" in
      */.kanban/*)
        git worktree remove "$wt_dir" --force 2>/dev/null || rm -rf "$wt_dir"
        ;;
      *)
        echo "WARNING: skipping cleanup of non-kanban path: $wt_dir"
        ;;
    esac
  fi

  # 删除分支
  if [ -n "$branch" ]; then
    git branch -D "$branch" 2>/dev/null || true
  fi
  git worktree prune 2>/dev/null || true

  # ST-004: 清理 worktree 子目录残留（新路径 tasks/TASK-NNN/worktree）
  # 如果 rm -rf 后目录仍残留（权限问题等），尝试再次清理
  local new_wt_dir="$KANBAN_DIR/tasks/${task_id}/worktree"
  if [ -d "$new_wt_dir" ] && [ "$new_wt_dir" != "$wt_dir" ]; then
    rm -rf "$new_wt_dir" 2>/dev/null || true
  fi

  # 清空 task JSON 中的 worktree 字段
  local tmp=$(mktemp)
  jq '.worktree.path="" | .worktree.branch=""' "$tf" > "$tmp" \
    && mv "$tmp" "$tf"

  echo "Cleaned up worktree: $branch"
}

# 获取 worktree 路径
worktree_path() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  jq -r '.worktree.path // ""' "$tf"
}

# 检查 worktree 是否存在
worktree_exists() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local wt_dir=$(jq -r '.worktree.path // ""' "$tf")
  [ -n "$wt_dir" ] && [ -d "$wt_dir" ]
}

# 统一校验 worktree 有效性
# 参数: task_id
# 返回: 0=valid, 1=invalid
# 输出: JSON 格式诊断信息 {valid:bool, errors:[], warnings:[]}
worktree_validate() {
  local task_id="$1"
  local tf=$(task_file "$task_id")
  local errors="[]"
  local warnings="[]"

  # 检查 task JSON 是否存在
  if [ ! -f "$tf" ]; then
    jq -n --argjson errs '["task_not_found"]' '{valid:false, errors:$errs, warnings:[]}'
    return 1
  fi

  local wt_path=$(jq -r '.worktree.path // ""' "$tf")
  local wt_branch=$(jq -r '.worktree.branch // ""' "$tf")

  # 检查1: path 非空
  if [ -z "$wt_path" ]; then
    local tmp_err=$(echo "$errors" | jq '. + ["worktree_path_empty"]')
    errors="$tmp_err"
  fi

  # 检查2: 目录存在
  if [ -n "$wt_path" ] && [ ! -d "$wt_path" ]; then
    local tmp_err=$(echo "$errors" | jq --arg p "$wt_path" '. + ["directory_not_found:" + $p]')
    errors="$tmp_err"
  fi

  # 检查3: 是有效 git worktree
  if [ -n "$wt_path" ] && [ -d "$wt_path" ]; then
    if ! git -C "$wt_path" rev-parse --git-dir >/dev/null 2>&1; then
      local tmp_err=$(echo "$errors" | jq --arg p "$wt_path" '. + ["not_valid_git_worktree:" + $p]')
      errors="$tmp_err"
    else
      # 检查4: worktree 分支与 task JSON branch 一致
      local actual_branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
      if [ -n "$wt_branch" ] && [ -n "$actual_branch" ] && [ "$actual_branch" != "$wt_branch" ]; then
        local tmp_warn=$(echo "$warnings" | jq --arg expected "$wt_branch" --arg actual "$actual_branch" \
          '. + ["branch_mismatch:expected=" + $expected + ",actual=" + $actual]')
        warnings="$tmp_warn"
      fi
    fi
  fi

  # 检查 branch 字段
  if [ -z "$wt_branch" ]; then
    local tmp_warn=$(echo "$warnings" | jq '. + ["worktree_branch_empty"]')
    warnings="$tmp_warn"
  fi

  # 判断有效性: 有 error 则无效
  local err_count=$(echo "$errors" | jq 'length')
  local is_valid="true"
  [ "$err_count" -gt 0 ] && is_valid="false"

  jq -n --argjson valid "$is_valid" --argjson errs "$errors" --argjson warns "$warnings" \
    '{valid:$valid, errors:$errs, warnings:$warns}'

  if [ "$is_valid" = "true" ]; then
    return 0
  else
    return 1
  fi
}
