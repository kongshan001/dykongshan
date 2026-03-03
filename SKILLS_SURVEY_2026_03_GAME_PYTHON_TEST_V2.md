# Claude Code Skills 调研报告 - 游戏客户端开发、Python 与自动化测试

> 调研时间: 2026-03-04 (第十三周更新)
> 来源: ClawHub ( Antigravity Awesome Skills )
> 最新更新: 补充 Git/Docker/K8s 热门 Skills、游戏客户端自动化测试

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
| openclaw-godot-skill | Godot | 场景管理、节点操作、输入模拟、调试 | 0.944 |
| agent-arcade | 游戏开发 | Arcade 游戏开发 | 0.942 |
| chessmaster | 棋类游戏 | Chess/Poker 等棋牌游戏开发 | 0.935 |
| imitationgame-agent | 游戏 AI | 游戏 AI 智能体 | 0.930 |
| clawarcade | 游戏开发 | Arcade 游戏框架 | 0.871 |

### 1.2 Godot Skill 详解

**Skill**: `openclaw-godot-skill`
**所有者**: TomLeeLive
**最新版本**: 1.2.7

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

#### 适用场景
- ✅ Godot 4.x 游戏开发
- ✅ 2D/3D 游戏原型
- ✅ 游戏逻辑调试

---

### 1.3 Arcade 游戏开发

**Skill**: `agent-arcade`
**评分**: 0.942

#### 核心能力
```markdown
### 🎮 游戏开发
- Arcade 风格游戏
- 经典游戏复刻
- 快速原型开发

### 🕹️ 游戏机制
- 碰撞检测
- 分数系统
- 生命值管理
```

---

## 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| python-executor | 安全沙箱执行 Python 代码 | 数据分析、脚本运行 | 0.956 |
| clean-pytest | pytest 最佳实践 | 测试质量提升 | 0.862 |
| statistics-2 | 统计分析 | 数据分析 | 0.856 |
| python-dataviz | 数据可视化 | 图表生成 | 3.427 |

### 2.2 Python Executor 详解

**Skill**: `python-executor`
**所有者**: okaris

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

### 2.3 Clean Pytest 详解

**Skill**: `clean-pytest`
**所有者**: marcoracer
**评分**: 0.862

#### 核心能力
```markdown
### 🧪 测试模式
- Fake-based testing
- Contract testing
- Dependency injection

### 📝 pytest 最佳实践
- 清晰的测试结构
- 可维护的测试代码
- 测试隔离和并行
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
| api-tester | API 测试 | REST API | 0.940 |
| ai-api-test | AI API 测试 | 智能 API 测试 | 0.900 |
| afrexai-qa-testing-engine | QA 测试引擎 | 游戏/应用测试 | 0.885 |
| code-qc | 代码质量审计 | 代码审查 | 0.826 |

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

### 3.4 API Tester 详解

**Skill**: `api-tester`
**评分**: 0.940

#### 核心能力
```markdown
### 🔌 API 测试
- REST API 测试
- GraphQL 测试
- 自动化测试生成

### 📊 报告
- 测试结果分析
- 性能指标
```

---

### 3.5 游戏客户端测试

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

## 五、推荐 Skills 组合

### 5.1 游戏客户端开发组合
```
推荐组合:
- openclaw-godot-skill (Godot 开发)
- agent-arcade (Arcade 游戏)
- chessmaster (棋类游戏)
- imitationgame-agent (游戏 AI)

# Antigravity Skills 新增:
- game-development (游戏开发编排器)
- game-development/2d-games (2D 游戏开发)
- game-development/3d-games (3D 游戏开发)
- game-development/multiplayer (多人游戏)
- game-development/mobile-games (移动游戏)
- game-development/pc-games (PC 游戏)
- game-development/game-art (游戏美术)
- game-development/game-audio (游戏音频)
- game-development/game-design (游戏设计)
- unity-developer (Unity 开发)
- godot-gdscript-patterns (Godot 4 GDScript)
- bevy-ecs-expert (Bevy ECS Rust 游戏引擎)
- unreal-engine-cpp-pro (Unreal Engine 5 C++)
- game-development/vr-ar (VR/AR 开发)
```

### 5.2 Python 开发组合
```
推荐组合:
- python-executor (代码执行)
- clean-pytest (测试)
- python-dataviz (数据可视化)
- statistics-2 (统计分析)

# Antigravity Skills 新增:
- python-pro (Python 3.12+ 大师)
- python-patterns (Python 开发原则)
- python-development-python-scaffold (项目脚手架)
- python-packaging (包发布)
- python-performance-optimization (性能优化)
- python-testing-patterns (pytest 测试)
- async-python-patterns (异步编程)
- fastapi-pro (FastAPI 高性能 API)
- fastapi-router-py (FastAPI 路由)
- fastapi-templates (FastAPI 模板)
- python-fastapi-development (FastAPI 开发)
- uv-package-manager (uv 包管理器)
- dbos-python (DBOS Python SDK)
- temporal-python-pro (Temporal 工作流)
- n8n-code-python (n8n 代码节点)
- trailofbits-modern-python (现代 Python 工具链)
```

### 5.3 测试与质量保证组合
```
推荐组合:
- test-runner (测试运行)
- test-patterns (测试模式)
- e2e-testing-patterns (E2E 测试)
- api-tester (API 测试)
- afrexai-qa-testing-engine (游戏测试)
- code-qc (代码质量)

# Antigravity Skills 新增:
- playwright-skill (Playwright 浏览器自动化)
- testing-qa (综合 QA 工作流)
- tdd-workflow (TDD 工作流)
- tdd-orchestrator (TDD 编排器)
- test-fixing (测试修复)
- unit-testing-test-generate (单元测试生成)
- e2e-testing (E2E 测试)
- e2e-testing-patterns (E2E 测试模式)
- webapp-testing (Web 应用测试)
- android_ui_verification (Android UI 验证)
- ab-test-setup (A/B 测试设置)
- debugging (调试专家)
- systematic-debugging (系统调试)
- web3-testing (Web3 智能合约测试)
- test-automator (AI 驱动测试自动化)
- pypict-skill (成对测试生成)
```

### 5.4 DevOps 工具组合
```
推荐组合:
- docker-essentials (容器化)
- kubernetes (K8s 管理)
- git-essentials (版本控制)
- git-workflows (工作流)
- container-debug (容器调试)

# Antigravity Skills 新增:
- cloud-devops (云端 DevOps)
- cloud-architect (云架构师)
- kubernetes-architect (K8s 架构师)
- kubernetes-deployment (K8s 部署)
- docker-essential (Docker 基础)
- terraform-infrastructure (Terraform IaC)
- terraform-specialist (Terraform 专家)
- cdk-patterns (AWS CDK 模式)
- aws-serverless (AWS 无服务器)
- gcp-cloud-run (GCP Cloud Run)
- gitops-workflow (GitOps 工作流)
- argocd (ArgoCD 部署)
- helm-chart-scaffolding (Helm Chart)
- istio-traffic-management (Istio 流量管理)
- github-actions-templates (GitHub Actions)
- gitlab-ci-patterns (GitLab CI)
- cicd-automation-workflow-automate (CI/CD 自动化)
- deployment-engineer (部署工程师)
- deployment-procedures (部署流程)
- bash-pro (Bash 脚本)
- bats-testing-patterns (Bash 测试)
- prometheus-configuration (Prometheus 监控)
- grafana-dashboards (Grafana 仪表盘)
- distributed-tracing (分布式追踪)
- observability-monitoring-monitor-setup (可观测性设置)
- sli-implementation (SLO 实现)
- code-review-ai-ai-review (AI 代码审查)
- iterate-pr (PR 迭代)
- deployment-validation-config-validate (配置验证)
```

---

## 六、使用建议

### 6.1 安装方式
```bash
# 使用 ClawHub 安装
clawhub install <skill-name>

# 例如
clawhub install openclaw-godot-skill
clawhub install test-runner
clawhub install docker-essentials
clawhub install git-essentials
```

### 6.2 触发方式
大多数 Skills 会根据关键词自动触发：
- 游戏开发: "game", "arcade", "chess"
- Python: "python", "pytest", "data"
- 测试: "test", "automation", "e2e", "api"
- DevOps: "docker", "k8s", "kubernetes", "git"

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
| 游戏开发 | 15+ | game-development, unity-developer, godot-gdscript-patterns |
| Python 开发 | 20+ | python-pro, fastapi-pro, async-python-patterns |
| 自动化测试 | 20+ | playwright-skill, testing-qa, tdd-workflow |
| 开发者工具 | 30+ | docker-essentials, kubernetes, terraform-specialist |
| 官方 Skills | 40+ | anthropics/docx, vercel-labs/react-best-practices |

### 8.2 评分 TOP 10 (Antigravity Skills)

| Skill 名称 | 类别 | 评分 |
|-----------|------|------|
| docker-essentials | DevOps | 1.224 |
| git-essentials | DevOps | 1.212 |
| kubernetes | DevOps | 1.179 |
| test-runner | 测试 | 1.174 |
| test-patterns | 测试 | 1.143 |
| python-pro | Python | 1.128 |
| playwright-skill | 测试 | 1.115 |
| cloud-devops | DevOps | 1.098 |
| game-development | 游戏 | 1.085 |
| fastapi-pro | Python | 1.072 |

### 8.3 推荐资源

- **VoltAgent/awesome-agent-skills**: https://github.com/VoltAgent/awesome-agent-skills (9000+ ⭐)
- ** Antigravity Skills**: https://github.com/sking-115/skills.sh
- ** ClawHub**: https://clawhub.com
- ** Trail of Bits Security Skills**: https://github.com/trailofbits/skills

---

*文档生成时间: 2026-03-04*
*来源: ClawHub Registry, Antigravity Skills, VoltAgent/awesome-agent-skills*
*持续更新中...*
