#!/bin/bash
# 安装开发相关的 ClawHub Skills

SKILLS_DIR="/usr/lib/node_modules/openclaw/skills"
LOG_FILE="/root/.openclaw/workspace/skills-install.log"

echo "=== 开始安装 Skills $(date) ===" >> "$LOG_FILE"

SKILLS=(
  "code"
  "git-essentials"
  "docker-essentials"
  "test-runner"
  "python-executor"
  "database-operations"
  "mcp-skill"
  "playwright-mcp"
)

for skill in "${SKILLS[@]}"; do
  echo "正在安装: $skill" >> "$LOG_FILE"
  clawhub install "$skill" --dir "$SKILLS_DIR" --force >> "$LOG_FILE" 2>&1
  
  if [ $? -eq 0 ]; then
    echo "✅ $skill 安装成功" >> "$LOG_FILE"
  else
    echo "❌ $skill 安装失败" >> "$LOG_FILE"
  fi
  
  # 避免速率限制
  sleep 10
done

echo "=== 安装完成 $(date) ===" >> "$LOG_FILE"

# 通知 OpenClaw
openclaw system event --text "✅ 开发 Skills 安装完成！已安装: code, git-essentials, docker-essentials, test-runner, python-executor, database-operations, mcp-skill, playwright-mcp" --mode now
