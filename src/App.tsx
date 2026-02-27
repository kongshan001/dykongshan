import { useState } from 'react';
import { Monitor, Key, Code, Copy, Check, Cpu, Download } from 'lucide-react';

type System = 'macos-intel' | 'macos-apple' | 'linux-ubuntu' | 'linux-centos' | 'windows-wsl' | 'windows';

interface Tool {
  id: string;
  name: string;
  icon: string;
}

const tools: Tool[] = [
  { id: 'opencode', name: 'OpenCode', icon: '⚡' },
  { id: 'cursor', name: 'Cursor', icon: '💻' },
  { id: 'claude-code', name: 'Claude Code', icon: '🧠' },
  { id: 'vscode-copilot', name: 'VS Code + Copilot', icon: '📝' },
  { id: 'windsurf', name: 'Windsurf', icon: '🌊' },
  { id: 'jan', name: 'Jan', icon: '⚙️' }
];

const modelProviders = [
  { id: 'openai', name: 'OpenAI (GPT-4)', keyPlaceholder: 'sk-xxxxxxxxxxxxxxxx' },
  { id: 'claude', name: 'Anthropic (Claude)', keyPlaceholder: 'sk-ant-xxxxxxxxxxxxxxxx' },
  { id: 'minimax', name: 'MiniMax', keyPlaceholder: 'xxxxxxxxxxxxxxxx' },
  { id: 'qwen', name: '阿里 (通义千问)', keyPlaceholder: 'sk-xxxxxxxxxxxxxxxx' }
];

const systemLabels: Record<System, { label: string; isMac: boolean; isLinux: boolean; isWindows: boolean }> = {
  'macos-intel': { label: 'macOS (Intel)', isMac: true, isLinux: false, isWindows: false },
  'macos-apple': { label: 'macOS (Apple Silicon)', isMac: true, isLinux: false, isWindows: false },
  'linux-ubuntu': { label: 'Linux (Ubuntu/Debian)', isMac: false, isLinux: true, isWindows: false },
  'linux-centos': { label: 'Linux (CentOS)', isMac: false, isLinux: true, isWindows: false },
  'windows-wsl': { label: 'Windows (WSL2)', isMac: false, isLinux: true, isWindows: true },
  'windows': { label: 'Windows (原生)', isMac: false, isLinux: false, isWindows: true }
};

function generateBashScript(_system: System, selectedTools: string[], apiKeys: Record<string, string>): string {
  const sys = systemLabels[_system];
  const isMac = sys.isMac;
  
  let script = `#!/bin/bash

# DevEnv AI Installer - 一键安装脚本
# 生成时间: ${new Date().toLocaleString()}

set -e

echo "========================================"
echo "       DevEnv AI 一键安装器"
echo "========================================"
echo ""

# 配置
INSTALL_OPENCODE=${selectedTools.includes('opencode')}
INSTALL_CURSOR=${selectedTools.includes('cursor')}
INSTALL_CLAUDE_CODE=${selectedTools.includes('claude-code')}
OPENAI_API_KEY="${apiKeys.openai || ''}"
CLAUDE_API_KEY="${apiKeys.claude || ''}"
MINIMAX_API_KEY="${apiKeys.minimax || ''}"

# 检测系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    else
        echo "unknown"
    fi
}

echo "检测到系统: $(detect_os)"
echo ""

# 安装 Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "正在安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

${selectedTools.includes('opencode') ? `
# 安装 OpenCode
install_opencode() {
    echo "正在安装 OpenCode..."
    if command -v brew &> /dev/null; then
        brew install opencode
    fi
    
    # 配置 API Keys
    if [ -n "$OPENAI_API_KEY" ]; then
        echo "配置 OpenAI API Key..."
    fi
    if [ -n "$CLAUDE_API_KEY" ]; then
        echo "配置 Claude API Key..."
    fi
    if [ -n "$MINIMAX_API_KEY" ]; then
        echo "配置 MiniMax API Key..."
    fi
}
` : ''}

${selectedTools.includes('cursor') ? `
# 安装 Cursor
install_cursor() {
    echo "正在安装 Cursor..."
    if command -v brew &> /dev/null; then
        brew install --cask cursor
    fi
}
` : ''}

${selectedTools.includes('claude-code') ? `
# 安装 Claude Code
install_claude_code() {
    echo "正在安装 Claude Code..."
    npm install -g @anthropic-ai/claude-code
    
    if [ -n "$CLAUDE_API_KEY" ]; then
        echo "配置 Claude API Key..."
    fi
}
` : ''}

# 安装 Homebrew (macOS/Linux)
${isMac ? `install_homebrew` : ''}

# 安装选中的工具
${selectedTools.includes('opencode') ? `install_opencode` : ''}
${selectedTools.includes('cursor') ? `install_cursor` : ''}
${selectedTools.includes('claude-code') ? `install_claude_code` : ''}

echo ""
echo "========================================"
echo "       安装完成！"
echo "========================================"
echo ""
echo "下一步："
echo "  1. 打开已安装的应用"
echo "  2. 在设置中配置 API Key"
echo ""
`;

  return script;
}

function generatePowerShellScript(_system: System, selectedTools: string[], _apiKeys: Record<string, string>): string {
  const script = `# DevEnv AI Installer - Windows 一键安装脚本
# 生成时间: ${new Date().toLocaleString()}

$ErrorActionPreference = "Stop"

Write-Host "========================================"
Write-Host "       DevEnv AI 一键安装器"
Write-Host "========================================"
Write-Host ""

${selectedTools.includes('cursor') ? `
# 安装 Cursor
Write-Host "正在安装 Cursor..."
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install -e --id Cursor.Cursor --silent --accept-source-agreements --accept-package-agreements
} else {
    Write-Host "请手动安装 Cursor: https://cursor.sh"
}
` : ''}

${selectedTools.includes('opencode') ? `
# 安装 OpenCode
Write-Host "正在安装 OpenCode..."
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install -e --id opencode.OpenCode --silent --accept-source-agreements --accept-package-agreements
} else {
    Write-Host "请手动安装 OpenCode: https://opencode.com"
}
` : ''}

Write-Host ""
Write-Host "========================================"
Write-Host "       安装完成！"
Write-Host "========================================"
Write-Host ""
Write-Host "下一步："
Write-Host "  1. 打开已安装的应用"
Write-Host "  2. 在设置中配置 API Key"
Write-Host ""
`;

  return script;
}

function App() {
  const [step, setStep] = useState(1);
  const [system, setSystem] = useState<System>('macos-apple');
  const [selectedTools, setSelectedTools] = useState<string[]>([]);
  const [apiKeys, setApiKeys] = useState<Record<string, string>>({});
  const [copied, setCopied] = useState(false);

  const toggleTool = (toolId: string) => {
    setSelectedTools(prev => 
      prev.includes(toolId) 
        ? prev.filter(t => t !== toolId)
        : [...prev, toolId]
    );
  };

  const downloadScript = () => {
    const sys = systemLabels[system];
    const isWindows = sys.isWindows;
    
    const script = isWindows 
      ? generatePowerShellScript(system, selectedTools, apiKeys)
      : generateBashScript(system, selectedTools, apiKeys);
    
    const blob = new Blob([script], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = isWindows ? 'devenv-install.ps1' : 'devenv-install.sh';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    setStep(3);
  };

  const copyCommands = () => {
    const sys = systemLabels[system];
    const isWindows = sys.isWindows;
    const script = isWindows 
      ? generatePowerShellScript(system, selectedTools, apiKeys)
      : generateBashScript(system, selectedTools, apiKeys);
    
    navigator.clipboard.writeText(script);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white">
      <div className="max-w-3xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="flex items-center justify-center gap-3 mb-4">
            <div className="w-12 h-12 bg-gradient-to-r from-purple-500 to-pink-500 rounded-xl flex items-center justify-center">
              <Cpu className="w-7 h-7" />
            </div>
            <h1 className="text-4xl font-bold">DevEnv AI</h1>
          </div>
          <p className="text-slate-400 text-lg">一键安装 AI 开发环境</p>
          <p className="text-slate-500 text-sm mt-2">无需任何技术基础，下载脚本双击即可</p>
        </div>

        {/* Progress */}
        <div className="flex items-center justify-center gap-2 mb-8">
          {[1, 2, 3].map(s => (
            <div key={s} className="flex items-center">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium ${
                step >= s ? 'bg-purple-500 text-white' : 'bg-slate-700 text-slate-400'
              }`}>
                {s}
              </div>
              {s < 3 && <div className={`w-12 h-0.5 ${step > s ? 'bg-purple-500' : 'bg-slate-700'}`} />}
            </div>
          ))}
        </div>

        {/* Step 1: System */}
        {step === 1 && (
          <div className="bg-slate-800/50 rounded-2xl p-6 backdrop-blur">
            <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
              <Monitor className="w-5 h-5 text-purple-400" />
              选择你的电脑系统
            </h2>
            
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
              {(Object.entries(systemLabels) as [System, typeof systemLabels['macos-apple']][]).map(([id, { label }]) => (
                <button
                  key={id}
                  onClick={() => setSystem(id)}
                  className={`p-3 rounded-xl text-center transition-all ${
                    system === id 
                      ? 'bg-purple-500/20 border-2 border-purple-500' 
                      : 'bg-slate-700/50 border-2 border-transparent hover:bg-slate-700'
                  }`}
                >
                  <div className="font-medium">{label}</div>
                </button>
              ))}
            </div>

            <button
              onClick={() => setStep(2)}
              className="mt-6 w-full py-3 bg-gradient-to-r from-purple-500 to-pink-500 rounded-xl font-medium hover:opacity-90 transition"
            >
              下一步 →
            </button>
          </div>
        )}

        {/* Step 2: Tools & API Keys */}
        {step === 2 && (
          <div className="space-y-6">
            {/* Tools */}
            <div className="bg-slate-800/50 rounded-2xl p-6 backdrop-blur">
              <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
                <Code className="w-5 h-5 text-purple-400" />
                选择要安装的工具（可多选）
              </h2>
              
              <div className="grid grid-cols-2 gap-3">
                {tools.map(tool => (
                  <button
                    key={tool.id}
                    onClick={() => toggleTool(tool.id)}
                    className={`p-4 rounded-xl text-center transition-all flex items-center gap-2 ${
                      selectedTools.includes(tool.id) 
                        ? 'bg-purple-500/20 border-2 border-purple-500' 
                        : 'bg-slate-700/50 border-2 border-transparent hover:bg-slate-700'
                    }`}
                  >
                    <span className="text-2xl">{tool.icon}</span>
                    <span className="font-medium">{tool.name}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* API Keys */}
            <div className="bg-slate-800/50 rounded-2xl p-6 backdrop-blur">
              <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
                <Key className="w-5 h-5 text-purple-400" />
                API Keys（可以不填，安装后手动配置）
              </h2>
              
              <div className="space-y-3">
                {modelProviders.map(provider => (
                  <div key={provider.id} className="flex items-center gap-3">
                    <label className="w-36 text-slate-300 text-sm">{provider.name}</label>
                    <input
                      type="password"
                      placeholder="选填"
                      value={apiKeys[provider.id] || ''}
                      onChange={e => setApiKeys(prev => ({ ...prev, [provider.id]: e.target.value }))}
                      className="flex-1 bg-slate-700/50 border border-slate-600 rounded-lg px-3 py-2 text-sm focus:border-purple-500 focus:outline-none"
                    />
                  </div>
                ))}
              </div>
            </div>

            <button
              onClick={downloadScript}
              disabled={selectedTools.length === 0}
              className="w-full py-4 bg-gradient-to-r from-green-500 to-emerald-500 rounded-xl font-medium hover:opacity-90 transition disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              <Download className="w-5 h-5" />
              ⬇️ 下载安装脚本
            </button>
          </div>
        )}

        {/* Step 3: Result */}
        {step === 3 && (
          <div className="bg-slate-800/50 rounded-2xl p-6 backdrop-blur">
            <div className="text-center mb-6">
              <div className="w-16 h-16 bg-green-500/20 rounded-full flex items-center justify-center mx-auto mb-4">
                <Check className="w-8 h-8 text-green-400" />
              </div>
              <h2 className="text-2xl font-bold">🎉 安装脚本已准备好！</h2>
              <p className="text-slate-400 mt-2">下载脚本后，双击运行即可自动安装</p>
            </div>

            <div className="bg-yellow-500/10 border border-yellow-500/20 rounded-xl p-4 mb-6">
              <h3 className="font-medium text-yellow-300 mb-2">📝 使用说明：</h3>
              <ul className="text-sm text-yellow-200/80 space-y-1">
                <li>1. 点击上方「下载安装脚本」按钮</li>
                <li>2. 将脚本保存到电脑</li>
                <li>3. <strong>Windows</strong>：右键点击 → 「使用 PowerShell 运行」</li>
                <li>4. <strong>Mac/Linux</strong>：打开终端 → 输入 <code>chmod +x</code> 然后运行</li>
              </ul>
            </div>

            <div className="flex gap-3">
              <button
                onClick={copyCommands}
                className="flex-1 py-3 bg-slate-700 rounded-xl font-medium hover:bg-slate-600 transition flex items-center justify-center gap-2"
              >
                {copied ? <Check className="w-5 h-5" /> : <Copy className="w-5 h-5" />}
                {copied ? '已复制!' : '复制脚本内容'}
              </button>
              
              <button
                onClick={() => { setStep(1); setSelectedTools([]); setApiKeys({}); }}
                className="flex-1 py-3 bg-purple-500/20 rounded-xl font-medium hover:bg-purple-500/30 transition"
              >
                重新配置
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
