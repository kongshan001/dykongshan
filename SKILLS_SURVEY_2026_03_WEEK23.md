# Claude Code Skills 完整调研报告 - 2026年3月 (第二十三周)

**调研日期**: 2026-03-04  
**技能来源**: ClawHub 实时搜索 + GitHub 热门仓库 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，基于 ClawHub 实时搜索排行和 GitHub 热门项目，覆盖以下方向：
1. **游戏客户端开发** (Unity/Godot/Unreal)
2. **Python 开发** (FastAPI/Django/异步)
3. **游戏客户端自动化测试** (移动端/UI 自动化)
4. **开发者工具** (浏览器自动化/GitHub 自动化/Docker)

### 数据来源

| 来源 | 描述 |
|------|------|
| ClawHub Registry | 实时热门 Skills 搜索评分 |
| GitHub Trending | 近期热门项目 |
| Antigravity Awesome | 970+ Skills 分类集合 |
| Claude Code 官方 | Claude Code 内置 Skills |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| game-cog | **1.132** | 游戏开发编排器，DeepResearch Bench 第一名 | 通用游戏开发 |
| game-developer-skill | **0.974** | Claude 游戏开发者 | AI 辅助开发 |
| fivem-dev | **0.957** | Fivem 开发 | GTA5 Mod 开发 |
| blender | **0.925** | Blender 3D 建模 | 3D 资产制作 |
| game-engine | **0.920** | 游戏引擎架构 | 引擎原理 |
| unity | **0.961** | Unity 最佳实践 | Unity 开发 |
| unreal-engine | **0.935** | Unreal Engine 开发 | UE 开发 |
| game-design-philosophy | **0.873** | 游戏设计哲学 | 游戏设计 |

### 1.2 热门游戏引擎 Skills 详解

#### 1.2.1 Unity 开发 Skills

**Unity AI Workflow 2026** - 重点推荐

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

```markdown
### 🎮 Dev Modes (三种开发模式)
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、游戏 jam |

### 🧃 核心哲学: Game Feel 不是可选的
- 每项功能使用 /implement-feature 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

### 🧠 技术架构
- TCREI Prompting: Task-Context-References-Evaluate-Iterate 方法论
- 验证系统: 每个 AI 推荐标记 [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED]
- 专家 Skills: UI Toolkit、ScriptableObject、Netcode、game feel、测试、调试
```

#### 1.2.2 Godot 开发 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| godot-dev-guide | 0.983 | Godot 4.x 完整开发指南 |
| 3d-cog | 0.878 | 3D 开发编排器 |

#### 1.2.3 Unreal Engine 开发 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| unreal-engine | 0.935 | Unreal Engine 开发 |
| ue-log-analyzer | 0.552 | UE 日志分析 |
| ue-build-package | 0.550 | UE 打包构建 |

### 1.3 游戏开发 Skills 缺口与建议

**当前缺口**:
1. 缺少针对中国游戏市场的特定 Skills（如微信小游戏、抖音小游戏）
2. 缺少主流商业引擎的深度 Skills（如 Cocos Creator、Unity URP/HDRP）
3. 游戏 AI/NPC 行为树开发 Skills 较少

**建议方向**:
- 开发 Cocos Creator 中文开发 Skills
- 开发微信/抖音小游戏发布流程 Skills
- 开发 Unity DOTS/ECS 高性能架构 Skills

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| py | **1.049** | Python 核心开发 | 通用 Python |
| python | **1.000** | Python Coding Guidelines | 代码规范 |
| python-executor | **0.973** | Python Executor | 代码执行 |
| python-dataviz | **0.888** | Python Dataviz | 数据可视化 |
| fastapi | **0.872** | FastAPI | Web 开发 |
| python-script-generator | **0.720** | Python Script Generator | 脚本生成 |

### 2.2 Python Web 框架 Skills

#### 2.2.1 FastAPI Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| fastapi | 0.872 | FastAPI 开发 |
| azure-ai-agents-py | 0.894 | Azure AI Agents |

**FastAPI Pro 最佳实践**:
- 使用 Pydantic v2 进行数据验证
- 集成 SQLAlchemy 2.0 ORM
- 使用 asyncio 进行异步处理
- 部署时使用 uvicorn/gunicorn

#### 2.2.2 数据处理 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| python-dataviz | 0.888 | 数据可视化 |
| lsp-python | 0.768 | Python LSP |

### 2.3 Python 测试 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| clean-pytest | 0.869 | Clean pytest 最佳实践 |
| neo-py-test-creator | 0.718 | Python 测试生成 |

### 2.4 Python 开发 Skills 缺口与建议

**当前缺口**:
1. 缺少 Python 异步编程深入 Skills (asyncio/await)
2. 缺少 Django/Flask 大型 Web 项目 Skills
3. 缺少 Python 数据工程 Skills (pandas/spark)

**建议方向**:
- 开发 Python 异步编程深度 Skills
- 开发 Django REST Framework 完整项目 Skills
- 开发 Python ETL/数据管道 Skills

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| test-master | **1.158** | 测试大师 | 通用测试 |
| e2e-testing-patterns | **1.119** | E2E 测试模式 | 端到端测试 |
| testing-patterns | **1.070** | 测试模式 | 测试设计 |
| browser-automation | **1.058** | 浏览器自动化 | Web 测试 |
| ai-web-automation | **1.097** | AI Web 自动化 | 智能测试 |
| windows-ui-automation | **1.100** | Windows UI 自动化 | 桌面测试 |

### 3.2 Playwright 测试 Skills (热门)

| Skill | 评分 | 描述 |
|-------|------|------|
| playwright-scraper-skill | **3.584** | Playwright 爬虫技能 |
| playwright-mcp | **3.581** | Playwright MCP |
| playwright | **3.538** | Playwright 自动化+MCP |
| playwright-browser-automation | **3.509** | Playwright 浏览器自动化 |
| playwright-headless-browser | **3.367** | Playwright 无头浏览器 |
| playwright-skill | **3.278** | Playwright 技能 |

**Playwright 最佳实践**:
```markdown
### 核心能力
- 浏览器自动化控制
- 元素定位与交互
- 截图/视频录制
- 网络请求拦截
- 并行测试执行

### 游戏客户端测试场景
- Web 游戏自动化测试
- 游戏官网 UI 测试
- 游戏登录/支付流程测试
```

### 3.3 游戏客户端测试 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| android-adb | **1.143** | ADB 连接 - Android 测试 |
| atl-mobile | 0.996 | Agent Touch Layer - 移动端测试 |
| afrexai-qa-test-plan | **1.004** | QA 测试计划生成 |
| afrexai-qa-testing-engine | **0.983** | QA 测试引擎 |

### 3.4 游戏客户端测试 Skills 缺口与建议

**当前缺口**:
1. 缺少 Unity/Unreal 引擎内置测试 Skills
2. 缺少游戏性能测试 Skills (帧率/内存/CPU)
3. 缺少游戏网络同步测试 Skills

**建议方向**:
- 开发 Unity Test Framework 集成 Skills
- 开发 Unreal Automation System Skills
- 开发游戏性能基准测试 Skills

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| mcp-adapter | **1.074** | MCP 适配器 | 工具集成 |
| tools-ui | **1.036** | 工具 UI | UI 开发 |
| devtopia | **0.938** | 开发者工具 | 开发环境 |
| apple-developer-toolkit | **0.928** | Apple 开发者工具 | iOS/macOS |
| openclaw-docker | **0.866** | Docker | 容器化 |

### 4.2 浏览器自动化 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| browserautomation-skill | **1.058** | 浏览器自动化 |
| browser-automation-stealth | **0.997** | 隐形浏览器自动化 |
| ai-web-automation | **1.097** | AI Web 自动化 |

### 4.3 API 测试 Skills

| Skill | 评分 | 描述 |
|-------|------|------|
| api-tester | **0.993** | API 测试 |
| ai-api-test | **0.888** | AI API 测试 |

### 4.4 开发者工具 Skills 缺口与建议

**当前缺口**:
1. 缺少 GitHub Actions 深度集成 Skills
2. 缺少 Kubernetes/Docker Compose 编排 Skills
3. 缺少 VS Code 插件开发 Skills

**建议方向**:
- 开发 GitHub Actions CI/CD Skills
- 开发 Kubernetes 管理 Skills
- 开发开发环境容器化 Skills

---

## 📈 五、ClawHub Top 30 Skills 排行榜

| 排名 | Skill | 评分 | 类别 |
|------|-------|------|------|
| 1 | playwright-scraper-skill | 3.584 | 测试 |
| 2 | playwright-mcp | 3.581 | 测试 |
| 3 | playwright | 3.538 | 测试 |
| 4 | playwright-browser-automation | 3.509 | 测试 |
| 5 | manikantasai-playwright-automation | 3.369 | 测试 |
| 6 | playwright-headless-browser | 3.367 | 测试 |
| 7 | playwright-npx | 3.336 | 测试 |
| 8 | playwright-skill | 3.278 | 测试 |
| 9 | pascal-playwright-mcp | 3.258 | 测试 |
| 10 | playwright-scraper-skill-1-2-0 | 3.256 | 测试 |
| 11 | game-cog | 1.132 | 游戏 |
| 12 | test-master | 1.158 | 测试 |
| 13 | e2e-testing-patterns | 1.119 | 测试 |
| 14 | windows-ui-automation | 1.100 | 测试 |
| 15 | ai-web-automation | 1.097 | 测试 |
| 16 | testing-patterns | 1.070 | 测试 |
| 17 | browserautomation-skill | 1.058 | 工具 |
| 18 | mcp-adapter | 1.074 | 工具 |
| 19 | py | 1.049 | Python |
| 20 | tools-ui | 1.036 | 工具 |
| 21 | python | 1.000 | Python |
| 22 | python-executor | 0.973 | Python |
| 23 | game-developer-skill | 0.974 | 游戏 |
| 24 | agent-evaluation | 1.016 | 测试 |
| 25 | automate | 1.008 | 工具 |

---

## 🎯 六、总结与建议

### 6.1 本周调研亮点

1. **Playwright 生态爆发**: Playwright 相关 Skills 占据 Top 10，表明浏览器自动化是当前热门方向
2. **游戏开发持续升温**: game-cog 保持 1.0+ 高分，游戏 AI 开发是重点
3. **测试自动化受关注**: test-master、e2e-testing-patterns 等测试 Skills 评分较高

### 6.2 Skills 缺口分析

| 领域 | 缺口 | 建议优先级 |
|------|------|-----------|
| 游戏开发 | 微信/抖音小游戏 | 高 |
| 游戏开发 | Unity DOTS/ECS | 高 |
| Python | 异步编程 | 中 |
| 测试 | Unity/Unreal 内置测试 | 高 |
| 开发者工具 | GitHub Actions 集成 | 中 |

### 6.3 下周调研方向

1. 深入调研 Playwright 高级应用
2. 调研游戏 AI/NPC 行为树开发 Skills
3. 调研 Python 异步编程深入 Skills
4. 调研 Kubernetes 开发 Skills

---

**文档版本**: V23  
**更新时间**: 2026-03-04  
**下次更新**: 2026-03-11
