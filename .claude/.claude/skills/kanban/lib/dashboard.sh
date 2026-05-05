#!/usr/bin/env bash
# dashboard.sh — Dashboard 启动/停止管理
# 依赖: node, jq (可选)

# zsh/bash glob 兼容
setopt null_glob 2>/dev/null || shopt -s nullglob 2>/dev/null || true

KANBAN_DIR=".kanban"

# Dashboard 目录和文件路径
_DASHBOARD_DIR="$KANBAN_DIR/dashboard"
_DASHBOARD_PID_FILE="$_DASHBOARD_DIR/.dashboard.pid"
_DASHBOARD_LOG_FILE="$_DASHBOARD_DIR/.dashboard.log"

# 读取配置端口（优先级: 环境变量 PORT > config.json dashboard.port > 默认 3000）
_dashboard_get_port() {
  local port="${PORT:-}"
  if [ -z "$port" ] && [ -f "$KANBAN_DIR/config.json" ]; then
    port=$(jq -r '.dashboard.port // ""' "$KANBAN_DIR/config.json" 2>/dev/null)
  fi
  echo "${port:-3000}"
}

# 检查进程是否存活
_dashboard_is_alive() {
  local pid="$1"
  kill -0 "$pid" 2>/dev/null
}

# 检查端口是否被占用，返回占用该端口的 PID
_dashboard_check_port() {
  local port="$1"
  lsof -i :"$port" -t 2>/dev/null
}

# 启动 Dashboard 服务
_dashboard_start() {
  # 1. 检查 server.js 是否存在
  if [ ! -f "$_DASHBOARD_DIR/server.js" ]; then
    echo "ERROR: $_DASHBOARD_DIR/server.js not found"
    echo "Hint: run file migration first (ST-001)"
    return 1
  fi

  # 2. 检查 node 是否可用
  if ! command -v node >/dev/null 2>&1; then
    echo "ERROR: node is not installed or not in PATH"
    return 1
  fi

  # 3. 读取端口配置
  local port
  port=$(_dashboard_get_port)

  # 4. 检查端口是否被占用
  local occupying_pid
  occupying_pid=$(_dashboard_check_port "$port")
  if [ -n "$occupying_pid" ]; then
    echo "WARN: Port $port is already in use by PID $occupying_pid"
    # 如果 PID 文件存在且进程匹配，说明是 dashboard 自身
    if [ -f "$_DASHBOARD_PID_FILE" ]; then
      local recorded_pid
      recorded_pid=$(cat "$_DASHBOARD_PID_FILE")
      if [ "$occupying_pid" = "$recorded_pid" ] && _dashboard_is_alive "$recorded_pid"; then
        echo "Dashboard already running at http://localhost:$port"
        return 0
      fi
    fi
    echo "ERROR: Port $port is occupied by another process (PID: $occupying_pid)"
    return 1
  fi

  # 5. 检查 PID 文件 — 如果进程仍存活则跳过启动
  if [ -f "$_DASHBOARD_PID_FILE" ]; then
    local old_pid
    old_pid=$(cat "$_DASHBOARD_PID_FILE")
    if [ -n "$old_pid" ] && _dashboard_is_alive "$old_pid"; then
      echo "Dashboard already running at http://localhost:$port (PID: $old_pid)"
      return 0
    fi
    # 进程已死，清理陈旧 PID 文件
    rm -f "$_DASHBOARD_PID_FILE"
  fi

  # 6. 如果 node_modules 不存在，安装依赖
  if [ ! -d "$_DASHBOARD_DIR/node_modules" ]; then
    echo "Installing dependencies..."
    (cd "$_DASHBOARD_DIR" && npm install --production) || {
      echo "ERROR: npm install failed"
      return 1
    }
  fi

  # 7. 启动 server（后台运行）
  nohup node "$_DASHBOARD_DIR/server.js" > "$_DASHBOARD_LOG_FILE" 2>&1 &
  local pid=$!

  # 8. 写入 PID 文件
  echo "$pid" > "$_DASHBOARD_PID_FILE"

  # 9. 等待最多 3 秒检查 server 启动成功
  local waited=0
  local started=false
  while [ "$waited" -lt 3 ]; do
    sleep 1
    waited=$((waited + 1))

    # 检查进程是否还活着
    if ! _dashboard_is_alive "$pid"; then
      echo "ERROR: Dashboard process exited prematurely"
      echo "Check log: $_DASHBOARD_LOG_FILE"
      rm -f "$_DASHBOARD_PID_FILE"
      return 1
    fi

    # 用 curl 检查服务是否就绪
    if curl -s "http://localhost:$port/api/config" >/dev/null 2>&1; then
      started=true
      break
    fi
  done

  if [ "$started" = true ]; then
    echo "Dashboard started at http://localhost:$port (PID: $pid)"
  else
    echo "WARN: Dashboard process running (PID: $pid) but health check timed out"
    echo "Check log: $_DASHBOARD_LOG_FILE"
  fi

  # 10. macOS 上自动打开浏览器
  if [ "$(uname)" = "Darwin" ] && command -v open >/dev/null 2>&1; then
    open "http://localhost:$port"
  fi

  return 0
}

# 停止 Dashboard 服务
_dashboard_stop() {
  if [ ! -f "$_DASHBOARD_PID_FILE" ]; then
    echo "Dashboard is not running (no PID file found)"
    return 0
  fi

  local pid
  pid=$(cat "$_DASHBOARD_PID_FILE")

  if [ -z "$pid" ]; then
    echo "Dashboard is not running (empty PID file)"
    rm -f "$_DASHBOARD_PID_FILE"
    return 0
  fi

  if _dashboard_is_alive "$pid"; then
    kill "$pid" 2>/dev/null
    echo "Sent SIGTERM to PID $pid"

    # 等待进程退出（最多 5 秒）
    local waited=0
    while [ "$waited" -lt 5 ] && _dashboard_is_alive "$pid"; do
      sleep 1
      waited=$((waited + 1))
    done

    # 如果进程仍在运行，强制终止
    if _dashboard_is_alive "$pid"; then
      kill -9 "$pid" 2>/dev/null
      echo "WARN: Force killed PID $pid (did not respond to SIGTERM)"
    fi
  else
    echo "Dashboard process (PID $pid) is not running"
  fi

  rm -f "$_DASHBOARD_PID_FILE"
  echo "Dashboard stopped"
  return 0
}

# 查看 Dashboard 运行状态
_dashboard_status() {
  if [ ! -f "$_DASHBOARD_PID_FILE" ]; then
    echo "Dashboard status: stopped (no PID file)"
    return 0
  fi

  local pid
  pid=$(cat "$_DASHBOARD_PID_FILE")

  if [ -z "$pid" ]; then
    echo "Dashboard status: stopped (empty PID file)"
    return 0
  fi

  local port
  port=$(_dashboard_get_port)

  if _dashboard_is_alive "$pid"; then
    echo "Dashboard status: running"
    echo "  PID:  $pid"
    echo "  URL:  http://localhost:$port"
    echo "  Log:  $_DASHBOARD_LOG_FILE"
  else
    echo "Dashboard status: stopped (PID $pid is dead, stale PID file)"
    echo "  PID file: $_DASHBOARD_PID_FILE"
  fi

  return 0
}

# 重启 Dashboard 服务
_dashboard_restart() {
  echo "Restarting Dashboard..."
  _dashboard_stop
  sleep 1
  _dashboard_start
}

# Dashboard 命令入口
# 用法: kanban_dashboard [start|stop|status|restart]
kanban_dashboard() {
  local subcmd="${1:-start}"

  case "$subcmd" in
    start)
      _dashboard_start
      ;;
    stop)
      _dashboard_stop
      ;;
    status)
      _dashboard_status
      ;;
    restart)
      _dashboard_restart
      ;;
    *)
      echo "Usage: kanban_dashboard [start|stop|status|restart]"
      echo ""
      echo "Commands:"
      echo "  start    Start the dashboard server (default)"
      echo "  stop     Stop the dashboard server"
      echo "  status   Show dashboard running status"
      echo "  restart  Restart the dashboard server"
      return 1
      ;;
  esac
}
