import { useState } from 'react';
import { Monitor, Key, Code, Terminal, Copy, Check, Cpu } from 'lucide-react';

type System = 'macos-intel' | 'macos-apple' | 'linux-ubuntu' | 'linux-centos' | 'windows-wsl' | 'windows';

interface Tool {
  id: string;
  name: string;
  icon: string;
  installCmd: (system: System) => string;
}

interface ModelProvider {
  id: string;
  name: string;
  keyPlaceholder: string;
}

const tools: Tool[] = [
  {
    id: 'opencode',
    name: 'OpenCode',
    icon: '⚡',
    installCmd: (system) => {
      if (system.startsWith('macos')) return 'brew install opencode';
      if (system.startsWith('linux')) return 'brew install opencode';
      if (system.startsWith('windows-wsl')) return 'brew install opencode';
      return 'winget install opencode';
    }
  },
  {
    id: 'cursor',
    name: 'Cursor',
    icon: '💻',
    installCmd: (system) => {
      if (system.startsWith('macos')) return 'brew install --cask cursor';
      if (system.startsWith('linux')) return 'brew install --cask cursor';
      if (system.startsWith('windows-wsl')) return 'winget install Cursor';
      return 'winget install Cursor';
    }
  },
  {
    id: 'claude-code',
    name: 'Claude Code',
    icon: '🧠',
    installCmd: (system) => {
      if (system.startsWith('macos')) return 'npm install -g @anthropic-ai/claude-code';
      if (system.startsWith('linux')) return 'npm install -g @anthropic-ai/claude-code';
      return 'npm install -g @anthropic-ai/claude-code';
    }
  },
  {
    id: 'vscode-copilot',
    name: 'VS Code + Copilot',
    icon: '📝',
    installCmd: (system) => {
      if (system.startsWith('macos')) return 'code --install-extension github.copilot';
      if (system.startsWith('linux')) return 'code --install-extension github.copilot';
      return 'code --install-extension github.copilot';
    }
  },
  {
    id: 'windsurf',
    name: 'Windsurf',
    icon: '🌊',
    installCmd: (system) => {
      if (system.startsWith('macos')) return 'brew install --cask windsurf';
      if (system.startsWith('linux')) return 'brew install --cask windsurf';
      return 'winget install Windsurf';
    }
  },
  {
    id: 'jan',
    name: 'Jan',
    icon: '⚙️',
    installCmd: (system) => {
      if (system.startsWith('macos')) return 'brew install jan';
      if (system.startsWith('linux')) return 'curl -fsSL https://jan.ai/install.sh | bash';
      return 'curl -fsSL https://jan.ai/install.sh | bash';
    }
  }
];

const modelProviders: ModelProvider[] = [
  { id: 'openai', name: 'OpenAI (GPT-4)', keyPlaceholder: 'sk-xxxxxxxxxxxxxxxx' },
  { id: 'claude', name: 'Anthropic (Claude)', keyPlaceholder: 'sk-ant-xxxxxxxxxxxxxxxx' },
  { id: 'gemini', name: 'Google (Gemini)', keyPlaceholder: 'xxxxxxxxxxxxxxxx' },
  { id: 'qwen', name: '阿里 (通义千问)', keyPlaceholder: 'sk-xxxxxxxxxxxxxxxx' },
  { id: 'minimax', name: 'MiniMax', keyPlaceholder: 'xxxxxxxxxxxxxxxx' },
  { id: 'wenxin', name: '百度 (文心一言)', keyPlaceholder: 'xxxxxxxxxxxxxxxx' }
];

const systemLabels: Record<System, string> = {
  'macos-intel': 'macOS (Intel)',
  'macos-apple': 'macOS (Apple Silicon)',
  'linux-ubuntu': 'Linux (Ubuntu/Debian)',
  'linux-centos': 'Linux (CentOS)',
  'windows-wsl': 'Windows (WSL2)',
  'windows': 'Windows (Native)'
};

function App() {
  const [step, setStep] = useState(1);
  const [system, setSystem] = useState<System>('macos-apple');
  const [selectedTools, setSelectedTools] = useState<string[]>([]);
  const [apiKeys, setApiKeys] = useState<Record<string, string>>({});
  const [generatedCommands, setGeneratedCommands] = useState<string[]>([]);
  const [copied, setCopied] = useState(false);
  // 检测系统
  useState(() => {
    const ua = navigator.userAgent;
    if (ua.includes('Mac')) {
      setSystem('macos-apple');
    } else if (ua.includes('Linux')) {
      setSystem('linux-ubuntu');
    } else if (ua.includes('Windows')) {
      setSystem('windows');
    }
  });

  const toggleTool = (toolId: string) => {
    setSelectedTools(prev => 
      prev.includes(toolId) 
        ? prev.filter(t => t !== toolId)
        : [...prev, toolId]
    );
  };

  const generateCommands = () => {
    const commands: string[] = [];
    
    // 安装工具
    selectedTools.forEach(toolId => {
      const tool = tools.find(t => t.id === toolId);
      if (tool) {
        commands.push(`# 安装 ${tool.name}`);
        commands.push(tool.installCmd(system));
        commands.push('');
      }
    });

    // 配置 API Keys
    const hasApiKeys = Object.values(apiKeys).some(v => v.trim());
    if (hasApiKeys) {
      commands.push('# 配置 API Keys');
      
      if (selectedTools.includes('opencode')) {
        if (apiKeys.openai) commands.push(`opencode config set openai ${apiKeys.openai}`);
        if (apiKeys.claude) commands.push(`opencode config set claude ${apiKeys.claude}`);
        if (apiKeys.minimax) commands.push(`opencode config set minimax ${apiKeys.minimax}`);
      }
      
      if (selectedTools.includes('cursor')) {
        commands.push('# Cursor: 在设置中输入 API Key');
      }
      
      if (selectedTools.includes('claude-code')) {
        if (apiKeys.claude) commands.push(`CLAUDE_API_KEY=${apiKeys.claude}`);
      }
    }

    setGeneratedCommands(commands);
    setStep(3);
  };

  const copyCommands = () => {
    navigator.clipboard.writeText(generatedCommands.join('\n'));
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
          <p className="text-slate-400 text-lg">一键配置 AI 开发环境</p>
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
              选择你的系统
            </h2>
            
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
              {(Object.entries(systemLabels) as [System, string][]).map(([id, label]) => (
                <button
                  key={id}
                  onClick={() => setSystem(id)}
                  className={`p-3 rounded-xl text-left transition-all ${
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
                选择要安装的工具
              </h2>
              
              <div className="grid grid-cols-2 gap-3">
                {tools.map(tool => (
                  <button
                    key={tool.id}
                    onClick={() => toggleTool(tool.id)}
                    className={`p-4 rounded-xl text-left transition-all flex items-center gap-3 ${
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
                配置 API Keys（可选）
              </h2>
              
              <div className="space-y-3">
                {modelProviders.map(provider => (
                  <div key={provider.id} className="flex items-center gap-3">
                    <label className="w-40 text-slate-300 text-sm">{provider.name}</label>
                    <input
                      type="password"
                      placeholder={provider.keyPlaceholder}
                      value={apiKeys[provider.id] || ''}
                      onChange={e => setApiKeys(prev => ({ ...prev, [provider.id]: e.target.value }))}
                      className="flex-1 bg-slate-700/50 border border-slate-600 rounded-lg px-3 py-2 text-sm focus:border-purple-500 focus:outline-none"
                    />
                  </div>
                ))}
              </div>
            </div>

            <button
              onClick={generateCommands}
              disabled={selectedTools.length === 0}
              className="w-full py-3 bg-gradient-to-r from-purple-500 to-pink-500 rounded-xl font-medium hover:opacity-90 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              ⚡ 生成配置命令
            </button>
          </div>
        )}

        {/* Step 3: Result */}
        {step === 3 && (
          <div className="bg-slate-800/50 rounded-2xl p-6 backdrop-blur">
            <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
              <Terminal className="w-5 h-5 text-purple-400" />
              配置完成！
            </h2>

            <div className="bg-slate-900 rounded-xl p-4 font-mono text-sm overflow-x-auto">
              <pre className="text-green-400">{generatedCommands.join('\n')}</pre>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={copyCommands}
                className="flex-1 py-3 bg-slate-700 rounded-xl font-medium hover:bg-slate-600 transition flex items-center justify-center gap-2"
              >
                {copied ? <Check className="w-5 h-5" /> : <Copy className="w-5 h-5" />}
                {copied ? '已复制!' : '复制命令'}
              </button>
              
              <button
                onClick={() => { setStep(1); setSelectedTools([]); setApiKeys({}); setGeneratedCommands([]); }}
                className="flex-1 py-3 bg-purple-500/20 rounded-xl font-medium hover:bg-purple-500/30 transition"
              >
                重新配置
              </button>
            </div>

            <div className="mt-6 p-4 bg-yellow-500/10 border border-yellow-500/20 rounded-xl text-sm text-yellow-200">
              <strong>⚠️ 提示：</strong>复制命令后，在终端中执行即可。API Key 会被配置到对应工具中。
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
