# DevEnv AI Installer for Windows
# 一键安装 AI 开发环境 (Windows)

$ErrorActionPreference = "Stop"

# 颜色
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    $colors = @{
        "Red" = [ConsoleColor]::Red
        "Green" = [ConsoleColor]::Green
        "Yellow" = [ConsoleColor]::Yellow
        "Blue" = [ConsoleColor]::Blue
        "White" = [ConsoleColor]::White
    }
    Write-Host $Message -ForegroundColor $colors[$Color]
}

# 配置
$INSTALL_OPENCODE = $false
$INSTALL_CURSOR = $false
$OPENAI_API_KEY = ""
$CLAUDE_API_KEY = ""

# 检测系统
function Detect-OS {
    if ($env:OS -eq "Windows_NT") {
        if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
            return "windows-wsl"
        }
        return "windows"
    }
    return "unknown"
}

# 安装 winget
function Install-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "正在安装 Winget..." "Yellow"
        # Winget 通常随 Windows 10/11 提供
        Write-ColorOutput "请确保系统已更新到最新版本" "Yellow"
    }
}

# 安装 OpenCode
function Install-OpenCode {
    $opencodePath = "$env:LOCALAPPDATA\Programs\opencode"
    if (-not (Test-Path $opencodePath)) {
        Write-ColorOutput "正在安装 OpenCode..." "Yellow"
        winget install -e --id opencode.OpenCode --silent --accept-source-agreements --accept-package-agreements
    } else {
        Write-ColorOutput "OpenCode 已安装" "Green"
    }
    
    # 配置 API Key
    if ($OPENAI_API_KEY) {
        $configPath = "$env:APPDATA\opencode\config.json"
        # 配置逻辑
    }
}

# 安装 Cursor
function Install-Cursor {
    $cursorPath = "$env:LOCALAPPDABLE\Programs\Cursor"
    if (-not (Test-Path $cursorPath)) {
        Write-ColorOutput "正在安装 Cursor..." "Yellow"
        winget install -e --id Cursor.Cursor --silent --accept-source-agreements --accept-package-agreements
    } else {
        Write-ColorOutput "Cursor 已安装" "Green"
    }
}

# 主函数
function Main {
    Write-ColorOutput "========================================" "Blue"
    Write-ColorOutput "       DevEnv AI 一键安装器" "Blue"
    Write-ColorOutput "========================================" "Blue"
    Write-Host ""
    
    $os = Detect-OS
    Write-ColorOutput "检测到系统: $os" "Green"
    Write-Host ""
    
    # 安装 Winget (如需要)
    Install-Winget
    
    # 安装选中的工具
    if ($INSTALL_OPENCODE) {
        Install-OpenCode
    }
    
    if ($INSTALL_CURSOR) {
        Install-Cursor
    }
    
    Write-Host ""
    Write-ColorOutput "========================================" "Green"
    Write-ColorOutput "       安装完成！" "Green"
    Write-ColorOutput "========================================" "Green"
    Write-Host ""
    Write-Host "下一步："
    Write-Host "  1. 打开已安装的应用"
    Write-Host "  2. 在设置中配置 API Key（如果需要）"
    Write-Host ""
}

# 运行
Main
