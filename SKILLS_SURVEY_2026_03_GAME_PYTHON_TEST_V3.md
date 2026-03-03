# Claude Code Skills 调研报告 - 游戏客户端开发、Python 与自动化测试

> 调研时间: 2026-03-04 (第十四周更新)
> 来源: ClawHub (Antigravity Awesome Skills)
> 最新更新: 游戏客户端开发、Python 开发、自动化测试、开发者工具 Skills 完整调研

---

## 📋 调研概述

本次调研覆盖以下方向：
1. 游戏客户端开发 (Unity, Unreal, Godot)
2. Python 开发
3. 自动化测试与质量保证
4. 开发者工具 (Docker, Kubernetes, Git)

---

## 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 引擎 | 核心能力 | 评分 |
|-----------|------|---------|------|
| unity-developer | Unity 6 LTS | C# 优化、URP/HDRP、ECS、DOTS、跨平台 | ⭐⭐⭐⭐⭐ |
| unity-ai-workflow | Unity 6.2+ | AI 辅助开发、Dev Modes、Game Feel | ⭐⭐⭐⭐⭐ |
| godot-gdscript-patterns | Godot 4 | GDScript 2.0、信号、状态机、优化 | ⭐⭐⭐⭐ |
| unreal-engine-cpp-pro | Unreal 5.x | C++ 开发、UObject、性能模式 | ⭐⭐⭐⭐⭐ |
| unity-ecs-patterns | Unity DOTS | ECS 架构、Jobs、Burst 编译 | ⭐⭐⭐⭐ |
| openclaw-godot-skill | Godot | 场景管理、节点操作、输入模拟、调试 | 0.944 |
| agent-arcade | 游戏开发 | Arcade 游戏开发 | 0.942 |
| chessmaster | 棋类游戏 | Chess/Poker 等棋牌游戏开发 | 0.935 |
| imitationgame-agent | 游戏 AI | 游戏 AI 智能体 | 0.930 |
| clawarcade | 游戏开发 | Arcade 游戏框架 | 0.871 |

### 1.2 Unity AI Workflow 详解 (2026 新增)

**Skill**: `unity-ai-workflow`
**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)
**GitHub Stars**: 4⭐ (2026-03 新增)

#### 核心能力
```markdown
### 🎮 Dev Modes (三种开发模式)
| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建文档和解释 | 学习、创意控制，AI 辅助 |
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

#### 适用场景
- ✅ Unity 6.2+ 项目开发
- ✅ AI 辅助游戏开发工作流
- ✅ 团队协作开发规范
- ✅ 快速原型和游戏 jam

---

### 1.3 Unity Developer 详解

**Skill**: `unity-developer`
**所有者**: Antigravity Skills
**评分**: ⭐⭐⭐⭐⭐

#### 核心能力
```markdown
### 现代渲染管线
- URP (Universal Render Pipeline) 优化定制
- HDRP 高保真图形
- Shader Graph 可视化着色器
- 自定义渲染通道

### 性能优化
- Unity Profiler (CPU/GPU/内存分析)
- Frame Debugger 渲染管线调试
- LOD 系统自动生成
- 遮挡剔除和视锥剔除

### C# 游戏编程
- C# 9.0+ 现代特性
- Job System 和 Burst Compiler
- DOTS/ECS 架构
- async/await 替代 Coroutine

### 跨平台部署
- Mobile (iOS/Android) 性能调优
- WebGL 浏览器部署
- Console (PS/Xbox/Switch) 优化
- VR/AR XR Toolkit
```

---

### 1.4 Godot Skill 详解

**Skill**: `openclaw-godot-skill`
**所有者**: TomLeeLive
**最新版本**: 1.2.7
**评分**: 0.944

#### 核心能力
```markdown
### 🎮 场景管理
- 节点创建和操作
- 场景切换和加载
- 层级结构管理

### 🎯 节点操作
- 属性编辑
- 信号连接
- 脚本附加

### 🕹️ 输入模拟
- 键盘/鼠标输入
- 手柄支持
- 自定义输入映射

### 🐛 调试功能
- 断点设置
- 变量监视
- 性能分析
```

---

### 1.5 Unreal Engine C++ Pro 详解

**Skill**: `unreal-engine-cpp-pro`
**评分**: ⭐⭐⭐⭐⭐

#### 核心能力
```markdown
### C++ 开发最佳实践
- UObject 规范和内存管理
- 性能优化模式
- 智能指针和垃圾回收

### 高级系统
- Slate UI 框架
- UMG 动画
- 网络复制和 RPC
- 模块化架构
```

---

## 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| python-pro | Python 3.12+ 全栈指南 | 通用 Python 开发 | 1.128 |
| python-executor | 安全沙箱执行 Python 代码 | 数据分析、脚本运行 | 0.956 |
| python-patterns | 开发原则和决策 | 架构设计 | ⭐⭐⭐⭐ |
| python-fastapi-development | FastAPI 后端开发 | API 服务 | 1.072 |
| clean-pytest | pytest 最佳实践 | 测试质量提升 | 0.862 |
| python-testing-patterns | pytest 测试策略 | 质量保证 | ⭐⭐⭐⭐ |
| async-python-patterns | asyncio 异步编程 | 高并发 | ⭐⭐⭐⭐ |
| python-performance-optimization | 性能分析和优化 | 性能调优 | ⭐⭐⭐⭐ |
| python-dataviz | 数据可视化 | 图表生成 | 3.427 |
| statistics-2 | 统计分析 | 数据分析 | 0.856 |
| python-packaging | PyPI 发布 | 库分发 | ⭐⭐⭐⭐ |
| temporal-python-pro | Temporal 工作流 | 分布式事务 | ⭐⭐⭐⭐ |

### 2.2 Python Pro 详解

**Skill**: `python-pro`
**评分**: 1.128

#### 核心能力
```markdown
### 现代 Python 特性
- Python 3.12+ 改进的错误消息
- 模式匹配 (match statement)
- 高级类型提示和泛型
- Descriptors 和元类

### 现代工具链
- uv: 2024 最快包管理器
- ruff: 替代 black/isort/flake8
- mypy/pyright: 类型检查
- pyproject.toml: 现代标准

### Web 开发
- FastAPI 高性能 API
- Pydantic 数据验证
- SQLAlchemy 2.0+ 异步支持
- WebSocket 支持

### 性能优化
- cProfile, py-spy 性能分析
- asyncio 异步 I/O
- 多进程 CPU 并行
- 内存优化和 GC 调优
```

---

### 2.3 Python Executor 详解

**Skill**: `python-executor`
**所有者**: okaris
**评分**: 0.956

#### 核心能力
```markdown
### 🐍 执行环境
- 安全沙箱执行
- 依赖预装: NumPy, Pandas, Matplotlib, requests, BeautifulSoup

### 📊 数据分析
- 数据处理和分析
- 可视化图表生成
- 文件 I/O 操作
```

---

### 2.4 FastAPI Pro 详解

**Skill**: `python-fastapi-development`
**评分**: 1.072

#### 核心能力
```markdown
### FastAPI 核心
- 路由和依赖注入
- Pydantic 模型验证
- 异步 SQLAlchemy
- JWT 认证

### 生产级特性
- OpenAPI 自动文档
- 错误处理中间件
- 日志和监控
- 部署和 Docker
```

---

### 2.5 Async Python Patterns 详解

**Skill**: `async-python-patterns`
**评分**: ⭐⭐⭐⭐

#### 核心能力
```markdown
### asyncio 基础
- async/await 语法
- Event loop 管理
- Task 和 Future
- 取消和超时

### 高级模式
- 并发任务管理
- 异步生成器
- 异步上下文管理器
- 错误处理

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis 异步客户端
```

---

## 三、自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| test-runner | 测试运行器 | 测试执行 | 1.174 |
| test-patterns | 测试模式 | 测试设计 | 1.143 |
| test-master | 测试策略与框架 | 全面测试 | 1.069 |
| e2e-testing-patterns | E2E 测试模式 | Playwright/Cypress | 1.025 |
| testing-patterns | 测试模式 | 测试设计 | 0.985 |
| senior-qa | 高级 QA | 专业测试 | 0.975 |
| playwright-skill | Playwright 浏览器自动化 | 测试/爬虫 | 1.115 |
| testing-qa | 综合 QA 工作流 | 质量保证 | ⭐⭐⭐⭐ |
| test-automator | AI 驱动测试自动化 | 智能测试生成 | ⭐⭐⭐⭐ |
| api-tester | API 测试 | REST API | 0.940 |
| ai-api-test | AI API 测试 | 智能 API 测试 | 0.900 |
| afrexai-qa-testing-engine | QA 测试引擎 | 游戏/应用测试 | 0.885 |
| code-qc | 代码质量审计 | 代码审查 | 0.826 |
| test-driven-development | TDD 开发流程 | 测试先行 | ⭐⭐⭐⭐ |
| unit-testing-test-generate | 单元测试生成 | 测试覆盖 | ⭐⭐⭐⭐ |

### 3.2 Test Runner 详解

**Skill**: `test-runner`
**评分**: 1.174

#### 核心能力
```markdown
### 🧪 测试执行
- 单元测试运行
- 集成测试运行
- 测试套件管理

### ⚡ 性能
- 并行执行
- 快速反馈
- CI/CD 集成
```

---

### 3.3 E2E Testing Patterns 详解

**Skill**: `e2e-testing-patterns`
**评分**: 1.025

#### 核心能力
```markdown
### 🎯 测试策略
- 关键用户旅程覆盖
- flaky test 消除
- CI/CD 集成

### 🛠️ 工具支持
- Playwright
- Cypress
```

---

### 3.4 Playwright Skill 详解

**Skill**: `playwright-skill`
**评分**: 1.115

#### 核心能力
```markdown
### 自动化能力
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 默认使用可见浏览器
- URL 参数化配置

### 常见模式
- 页面测试 (多视口)
- 登录流程测试
- 表单填写和提交
- 链接检查
- 响应式设计测试
```

---

### 3.5 Test Automator 详解

**Skill**: `test-automator`
**评分**: ⭐⭐⭐⭐

#### 核心能力
```markdown
### AI 驱动测试
- Self-healing tests (Testim, Applitools)
- NLP 测试生成
- ML 失败预测
- 视觉 AI 测试

### 现代化框架
- Playwright 跨浏览器
- Appium 移动测试
- API 测试 (Postman, Karate)
- 性能测试 (K6, JMeter)

### CI/CD 集成
- Jenkins/GitLab CI/GitHub Actions
- 并行执行优化
- 容器化测试环境
- 动态测试选择
```

---

### 3.6 游戏客户端测试专题

**Skill**: `afrexai-qa-testing-engine`
**评分**: 0.885

#### 核心能力
```markdown
### 🎮 游戏测试
- UI 自动化测试
- 功能测试
- 回归测试

### 🤖 AI 驱动
- 智能测试生成
- 自动化执行
- 结果分析
```

#### Unity Test Framework 详解

```markdown
### 测试类型
- Edit Mode: 纯 C# 逻辑测试，无需运行游戏
- Play Mode: 集成测试，运行游戏场景

### 核心组件
- TestRunner: 测试运行器
- NUnit: 测试框架
- UnityTestAttribute: 协程测试
- UnityWebRequest: 网络测试

### 最佳实践
- 分离单元测试和集成测试
- 使用 ScriptableObject 存储测试数据
- 使用 Addressables 加载测试资源
- CI 集成 (GitHub Actions)
```

#### 网络同步测试专题

```markdown
### 帧同步测试
- 确定性验证: 相同输入 → 相同输出
- 断线重连测试
- 录像回放验证

### 状态同步测试
- 状态一致性验证
- 增量同步效率
- 预测回滚测试

### 延迟模拟
- 网络抖动 (Jitter): 0-200ms 随机延迟
- 丢包模拟: 5%-20% 丢包率
- 高延迟环境: 200-500ms RTT
```

---

## 四、开发者工具 Skills

### 4.1 Git Skills (热门)

| Skill 名称 | 核心能力 | 评分 |
|-----------|---------|------|
| git-essentials | Git 基础操作 | 1.212 |
| git | Git 全套工具 | 1.140 |
| git-workflows | Git 工作流 | 1.085 |
| gitflow | GitFlow 支持 | 1.061 |
| git-helper | Git 辅助工具 | 1.024 |

### 4.2 Docker/K8s Skills (热门)

| Skill 名称 | 核心能力 | 评分 |
|-----------|---------|------|
| docker-essentials | Docker 基础 | 1.224 |
| kubernetes | K8s 管理 | 1.179 |
| docker | Docker 全套 | 1.125 |
| container-debug | 容器调试 | 1.071 |
| docker-sandbox | Docker 沙箱 | 1.059 |
| docker-ctl | Docker 控制 | 1.045 |
| kubectl | kubectl 工具 | 1.053 |

### 4.3 Docker 详解

**Skill**: `docker-essentials`
**评分**: 1.224

#### 核心能力
```markdown
### 🐳 镜像构建
- 多阶段构建
- 镜像优化
- 体积缩小

### 🔒 安全
- 安全最佳实践
- 漏洞扫描
- 权限控制
```

---

### 4.4 Kubernetes 详解

**Skill**: `kubernetes`
**评分**: 1.179

#### 核心能力
```markdown
### ☸️ 集群管理
- Pod 管理
- Service 配置
- 部署管理

### 🚨 故障排查
- 健康检查
- 日志分析
- 资源诊断
```

---

### 4.5 Git Essentials 详解

**Skill**: `git-essentials`
**评分**: 1.212

#### 核心能力
```markdown
### 📦 版本控制
- 提交管理
- 分支操作
- 合并冲突

### 🔄 工作流
- Git Flow
- GitHub Flow
- trunk-based
```

---

### 4.6 Browser Automation 详解

**Skill**: `browser-automation`
**评分**: ⭐⭐⭐⭐

#### 核心能力
```markdown
### 基础原理
- 元素定位策略 (CSS/XPath/ARIA)
- 等待策略 (显式/隐式/智能)
- 页面对象模式
- 测试隔离

### 工具对比
| 工具 | 特点 | 适用场景 |
|------|------|---------|
| Playwright | 跨浏览器、API 丰富 | 现代 Web 测试 |
| Puppeteer | Chrome 专用、轻量 | 爬虫/截图 |
| Selenium | 历史悠久、生态广 | 遗留项目 |
| Cypress | 调试友好、实时重载 | 开发测试 |
```

---

### 4.7 GitHub Automation 详解

**Skill**: `github-automation`
**评分**: ⭐⭐⭐⭐

#### 核心能力
```markdown
### 仓库管理
- 创建/删除仓库
- 分支保护规则
- 团队和权限管理

### Issue 管理
- 创建/关闭/编辑
- 标签管理
- 指派和里程碑

### Pull Request
- 创建和审查
- 自动合并
- 冲突解决
- CI 状态检查
```

---

## 五、推荐 Skills 组合

### 5.1 游戏客户端开发组合
```
推荐组合:
- unity-ai-workflow (Unity 6.2+ AI 开发)
- unity-developer (Unity 开发)
- openclaw-godot-skill (Godot 开发)
- agent-arcade (Arcade 游戏)
- chessmaster (棋类游戏)
- imitationgame-agent (游戏 AI)
- unreal-engine-cpp-pro (Unreal 开发)
- unity-ecs-patterns (ECS 架构)

# Antigravity Skills:
- game-development (游戏开发编排器)
- game-development/2d-games (2D 游戏开发)
- game-development/3d-games (3D 游戏开发)
- game-development/multiplayer (多人游戏)
- game-development/mobile-games (移动游戏)
- godot-gdscript-patterns (Godot 4 GDScript)
- bevy-ecs-expert (Bevy ECS Rust 游戏引擎)
```

### 5.2 Python 开发组合
```
推荐组合:
- python-pro (Python 3.12+ 大师)
- python-executor (代码执行)
- python-fastapi-development (FastAPI 开发)
- async-python-patterns (异步编程)
- python-testing-patterns (pytest 测试)
- python-performance-optimization (性能优化)

# Antigravity Skills:
- python-patterns (Python 开发原则)
- python-development-python-scaffold (项目脚手架)
- python-packaging (包发布)
- clean-pytest (pytest 最佳实践)
- uv-package-manager (uv 包管理器)
- fastapi-pro (FastAPI 高性能 API)
- temporal-python-pro (Temporal 工作流)
- trailofbits-modern-python (现代 Python 工具链)
```

### 5.3 测试与质量保证组合
```
推荐组合:
- test-runner (测试运行)
- test-patterns (测试模式)
- e2e-testing-patterns (E2E 测试)
- playwright-skill (Playwright 测试)
- test-automator (AI 驱动测试)
- testing-qa (综合 QA 工作流)
- api-tester (API 测试)
- afrexai-qa-testing-engine (游戏测试)
- test-driven-development (TDD 开发)

# Antigravity Skills:
- testing-patterns (测试模式)
- python-testing-patterns (pytest 测试)
- unit-testing-test-generate (单元测试生成)
- e2e-testing (E2E 测试)
- webapp-testing (Web 应用测试)
- android_ui_verification (Android UI 验证)
- debugging (调试专家)
- systematic-debugging (系统调试)
```

### 5.4 DevOps 工具组合
```
推荐组合:
- docker-essentials (容器化)
- kubernetes (K8s 管理)
- git-essentials (版本控制)
- git-workflows (工作流)
- container-debug (容器调试)
- browser-automation (浏览器自动化)
- github-automation (GitHub 自动化)
- github-workflow-automation (CI/CD)

# Antigravity Skills:
- cloud-devops (云端 DevOps)
- cloud-architect (云架构师)
- kubernetes-architect (K8s 架构师)
- terraform-infrastructure (Terraform IaC)
- terraform-specialist (Terraform 专家)
- cdk-patterns (AWS CDK 模式)
- aws-serverless (AWS 无服务器)
- gitops-workflow (GitOps 工作流)
- argocd (ArgoCD 部署)
- github-actions-templates (GitHub Actions)
- bash-pro (Bash 脚本)
- prometheus-configuration (Prometheus 监控)
- grafana-dashboards (Grafana 仪表盘)
```

---

## 六、使用建议

### 6.1 安装方式
```bash
# 使用 ClawHub 安装
clawhub install <skill-name>

# 例如
clawhub install unity-developer
clawhub install python-pro
clawhub install test-runner
clawhub install docker-essentials
clawhub install git-essentials

# Antigravity Skills 安装
npx antigravity-awesome-skills --claude
```

### 6.2 触发方式
大多数 Skills 会根据关键词自动触发：
- 游戏开发: "game", "unity", "godot", "unreal", "arcade"
- Python: "python", "pytest", "fastapi", "async"
- 测试: "test", "automation", "e2e", "api", "playwright"
- DevOps: "docker", "k8s", "kubernetes", "git", "ci/cd"

---

## 七、官方 Agent Skills (来自 VoltAgent/awesome-agent-skills)

### 7.1 Anthropic 官方 Skills

| Skill | 描述 |
|-------|------|
| anthropics/docx | 创建、编辑和分析 Word 文档 |
| anthropics/doc-coauthoring | 协作文档编辑和共同创作 |
| anthropics/pptx | 创建、编辑和分析 PowerPoint 演示文稿 |
| anthropics/xlsx | 创建、编辑和分析 Excel 电子表格 |
| anthropics/pdf | 提取文本、创建 PDF 和处理表单 |
| anthropics/algorithmic-art | 使用 p5.js 创建生成艺术 |
| anthropics/canvas-design | 设计 PNG 和 PDF 格式的视觉艺术 |
| anthropics/frontend-design | 前端设计和 UI/UX 开发工具 |
| anthropics/webapp-testing | 使用 Playwright 测试本地 Web 应用 |
| anthropics/mcp-builder | 创建 MCP 服务器以集成外部 API |
| anthropics/skill-creator | 创建扩展 Claude 能力的 Skills 指南 |

### 7.2 Vercel 官方 Skills

| Skill | 描述 |
|-------|------|
| vercel-labs/react-best-practices | React 最佳实践和模式 |
| vercel-labs/vercel-deploy-claimable | 部署项目到 Vercel |
| vercel-labs/web-design-guidelines | Web 设计指南和标准 |
| vercel-labs/composition-patterns | React 组件组合和可复用模式 |
| vercel-labs/next-best-practices | Next.js 最佳实践 |
| vercel-labs/next-cache-components | Next.js 缓存策略 |
| vercel-labs/next-upgrade | 升级 Next.js 项目 |
| vercel-labs/react-native-skills | React Native 最佳实践 |

### 7.3 Cloudflare 官方 Skills

| Skill | 描述 |
|-------|------|
| cloudflare/agents-sdk | 构建有状态的 AI 代理 |
| cloudflare/durable-objects | 有状态协调与 RPC |
| cloudflare/wrangler | 部署和管理 Workers、KV、R2、D1 等 |
| cloudflare/web-perf | 审计 Core Web Vitals |
| cloudflare/building-mcp-server-on-cloudflare | 构建 MCP 服务器 |

### 7.4 官方 Skills 安装使用

```bash
# 官方 Skills 通常通过以下方式安装
# 方式1: 克隆对应仓库
git clone https://github.com/anthropics/skills

# 方式2: 使用 ClawHub
clawhub install anthropics/docx
clawhub install vercel-labs/react-best-practices

# 方式3: 手动复制到 skills 目录
cp -r <skill-repo>/skills/<skill-name> ~/.claude/skills/
```

---

## 八、总结

### 8.1 调研结果

| 类别 | Skills 数量 | 热门 Skills |
|-----|------------|------------|
| 游戏开发 | 20+ | unity-ai-workflow, unity-developer, godot-gdscript-patterns, unreal-engine-cpp-pro |
| Python 开发 | 20+ | python-pro, fastapi-pro, async-python-patterns, python-executor |
| 自动化测试 | 25+ | test-runner, test-patterns, playwright-skill, test-automator, e2e-testing-patterns |
| 开发者工具 | 35+ | docker-essentials, kubernetes, git-essentials, browser-automation |
| 官方 Skills | 40+ | anthropics/docx, vercel-labs/react-best-practices, cloudflare/wrangler |

### 8.2 评分 TOP 15 (Antigravity Skills)

| Skill 名称 | 类别 | 评分 |
|-----------|------|------|
| docker-essentials | DevOps | 1.224 |
| git-essentials | DevOps | 1.212 |
| kubernetes | DevOps | 1.179 |
| test-runner | 测试 | 1.174 |
| test-patterns | 测试 | 1.143 |
| python-pro | Python | 1.128 |
| playwright-skill | 测试 | 1.115 |
| docker | DevOps | 1.125 |
| cloud-devops | DevOps | 1.098 |
| test-master | 测试 | 1.069 |
| python-fastapi-development | Python | 1.072 |
| git-workflows | DevOps | 1.085 |
| game-development | 游戏 | 1.085 |
| e2e-testing-patterns | 测试 | 1.025 |
| gitflow | DevOps | 1.061 |

### 8.3 game-frame-sync 项目推荐

对于帧同步游戏框架项目，推荐以下 Skills 组合：

```
游戏客户端 (Unity):
- unity-developer
- unity-ai-workflow (2026 新增)
- unity-ecs-patterns (性能优化)

后端 (Python):
- python-pro
- python-fastapi-development
- async-python-patterns
- python-testing-patterns

测试:
- test-runner
- python-testing-patterns
- test-driven-development

DevOps:
- docker-essentials
- github-workflow-automation
```

---

## 📎 相关链接

- **VoltAgent/awesome-agent-skills**: https://github.com/VoltAgent/awesome-agent-skills (9000+ ⭐)
- **Antigravity Skills**: https://github.com/sking-115/skills.sh (968+ Skills)
- **ClawHub**: https://clawhub.com
- **Trail of Bits Security Skills**: https://github.com/trailofbits/skills
- **Unity AI Workflow**: https://github.com/David-GD13/unity-ai-workflow (2026 新增)

---

*文档生成时间: 2026-03-04*
*来源: ClawHub Registry, Antigravity Skills, VoltAgent/awesome-agent-skills*
*持续更新中...*
