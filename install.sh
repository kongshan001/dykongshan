#!/bin/bash

# DevEnv AI Installer
# 一键安装 AI 开发环境

set -e

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
INSTALL_OPENCODE=false
INSTALL_CURSOR=false
INSTALL_CLAUDE_CODE=false
OPENAI_API_KEY=""
CLAUDE_API_KEY=""
MINIMAX_API_KEY=""

# 检测系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            echo "macos-apple"
        else
            echo "macos-intel"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            echo "linux-ubuntu"
        elif command -v yum &> /dev/null; then
            echo "linux-centos"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# 安装 Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}正在安装 Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# 安装 OpenCode
install_opencode() {
    if ! command -v opencode &> /dev/null; then
        echo -e "${YELLOW}正在安装 OpenCode...${NC}"
        brew install opencode
    else
        echo -e "${GREEN}OpenCode 已安装${NC}"
    fi
    
    # 配置 API Keys
    if [ -n "$OPENAI_API_KEY" ]; then
        opencode config set openai "$OPENAI_API_KEY" 2>/dev/null || echo "配置 OpenAI Key"
    fi
    if [ -n "$CLAUDE_API_KEY" ]; then
        opencode config set claude "$CLAUDE_API_KEY" 2>/dev/null || echo "配置 Claude Key"
    fi
    if [ -n "$MINIMAX_API_KEY" ]; then
        opencode config set minimax "$MINIMAX_API_KEY" 2>/dev/null || echo "配置 MiniMax Key"
    fi
}

# 安装 Cursor
install_cursor() {
    if [[ ! -d "/Applications/Cursor.app" ]] && [[ ! -d "$HOME/Applications/Cursor.app" ]]; then
        echo -e "${YELLOW}正在安装 Cursor...${NC}"
        brew install --cask cursor
    else
        echo -e "${GREEN}Cursor 已安装${NC}"
    fi
}

# 安装 Claude Code
install_claude_code() {
    if ! command -v claude &> /dev/null; then
        echo -e "${YELLOW}正在安装 Claude Code...${NC}"
        npm install -g @anthropic-ai/claude-code
    else
        echo -e "${GREEN}Claude Code 已安装${NC}"
    fi
    
    if [ -n "$CLAUDE_API_KEY" ]; then
        export CLAUDE_API_KEY="$CLAUDE_API_KEY"
    fi
}

# 主函数
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       DevEnv AI 一键安装器${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    local os=$(detect_os)
    echo -e "检测到系统: ${GREEN}$os${NC}"
    echo ""
    
    # 检查是否需要安装 Homebrew (macOS/Linux)
    if [[ "$os" == macos-* ]] || [[ "$os" == linux-* ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}需要安装 Homebrew${NC}"
            install_homebrew
        fi
    fi
    
    # 安装选中的工具
    if [ "$INSTALL_OPENCODE" = true ]; then
        install_opencode
    fi
    
    if [ "$INSTALL_CURSOR" = true ]; then
        install_cursor
    fi
    
    if [ "$INSTALL_CLAUDE_CODE" = true ]; then
        install_claude_code
    fi
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}       安装完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "下一步："
    echo "  1. 打开已安装的应用"
    echo "  2. 在设置中配置 API Key（如果需要）"
    echo ""
}

# 从配置文件读取配置
load_config() {
    local config_file="$HOME/.devenv-ai/config.txt"
    if [ -f "$config_file" ]; then
        source "$config_file"
    fi
}

# 运行
main
