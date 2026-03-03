# Claude Code Skills 调研报告 - 第十三周

**调研日期**: 2026-03-04  
**技能来源**: ClawHub + Antigravity Awesome Skills (970+ Skills)  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本周继续深入分析 Claude Code 热门 Skills，重点关注：
1. 游戏客户端开发 (Unity/Godot/Unreal 新增 Skills)
2. Python 开发 (FastAPI/异步/测试 新增)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (Docker/Git/API 工具)

### 统计概览

| 指标 | 数值 |
|------|------|
| Skills 总数 | 970+ |
| 本周新增热门 | 15+ |
| ClawHub 收录 | 持续更新 |

---

## 🎮 游戏客户端开发 Skills

### 核心 Skills 矩阵

| Skill ID | 名称 | 核心能力 | 适用引擎 | 评分 |
|----------|------|---------|---------|------|
| unity-developer | Unity 6 LTS 专家 | URP/HDRP、跨平台部署 | Unity | ⭐⭐⭐⭐⭐ |
| unity-ai-workflow | Unity AI Workflow 2026 | Dev Modes、AI 辅助开发 | Unity 6.2+ | ⭐⭐⭐⭐⭐ |
| unity-ecs-patterns | DOTS/ECS 架构 | Jobs System、Burst | Unity | ⭐⭐⭐⭐⭐ |
| openclaw-unreal-skill | Unreal Skill | UE5 C++ 开发、日志分析 | Unreal | ⭐⭐⭐⭐⭐ |
| ue-log-analyzer | UE Log Analyzer | 日志分析、性能分析 | Unreal | ⭐⭐⭐⭐ |
| ue-build-package | UE Build Package | 打包构建自动化 | Unreal | ⭐⭐⭐⭐ |
| ue-code-search | UE Code Search | 代码搜索导航 | Unreal | ⭐⭐⭐⭐ |
| ue-asset-finder | UE Asset Finder | 资源查找管理 | Unreal | ⭐⭐⭐⭐ |
| openclaw-godot-skill | Godot Skill | GDScript 开发 | Godot | ⭐⭐⭐⭐⭐ |
| godot-dev-guide | Godot Dev Guide | Godot 4 开发指南 | Godot | ⭐⭐⭐⭐⭐ |
| bevy-ecs-expert | Bevy ECS | Rust 游戏引擎 ECS | Bevy | ⭐⭐⭐⭐⭐ |
| game-development | 游戏开发编排器 | 自动路由到子 Skills | 通用 | ⭐⭐⭐⭐ |
| game-cog | Game Cog | 游戏开发编排器 | 通用 | ⭐⭐⭐⭐⭐ |
| game-engine | Game Engine | 游戏引擎概念 | 通用 | ⭐⭐⭐⭐ |

### 新增 Unreal Engine Skills 详解

#### openclaw-unreal-skill

**核心能力**:
- C++/Blueprint 混合开发
- UObject 内存管理
- 网络复制和 RPC
- UMG/Slate UI 开发
- 性能优化和 Profiling

**适用场景**:
- ✅ AAA 游戏开发
- ✅ 高度定制化引擎功能
- ✅ 大型多人游戏
- ✅ 虚拟制作

#### ue-log-analyzer

**核心能力**:
- UE 日志解析和分类
- 错误/警告自动识别
- 性能日志分析
- 崩溃报告分析

**典型交互**:
```
"Analyze this UE log file for errors"
"Find performance issues in the log"
"Extract warning patterns from this log"
```

#### ue-build-package

**核心能力**:
- 自动打包 Windows/Mac/Linux
- Cook 内容自动化
- 打包配置管理
- 多平台构建

**典型交互**:
```
"Package this UE project for Windows"
"Cook and build for iOS"
```

### 新增 Godot Skills 详解

#### openclaw-godot-skill

**核心能力**:
- GDScript 2.0 开发
- 场景和节点系统
- 信号和事件处理
- 2D/3D 游戏开发

**适用场景**:
- ✅ 2D/3D 开源游戏
- ✅ 轻量级项目
- ✅ 跨平台发布 (Linux/macOS/Windows)
- ✅ Godot 4 迁移

#### godot-dev-guide

**核心能力**:
- Godot 4 新特性指南
- 渲染优化
- GDExtension 开发
- 最佳实践

### 游戏开发推荐 Skills 组合

```
推荐组合:
/game-cog (编排器)
/unity-developer + /unity-ai-workflow
/openclaw-unreal-skill + /ue-log-analyzer + /ue-build-package
/godot-dev-guide + /openclaw-godot-skill
/bevy-ecs-expert (Rust 游戏引擎)
```

---

## 🐍 Python 开发 Skills

### Python Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| python-pro | Python 3.12+ 专家 | 现代特性、生产级实践 | ⭐⭐⭐⭐⭐ |
| py | Python | 基础开发 | ⭐⭐⭐⭐⭐ |
| python | Python Coding Guidelines | 编码规范 | ⭐⭐⭐⭐⭐ |
| python-executor | Python Executor | 代码执行 | ⭐⭐⭐⭐ |
| python-development-python-scaffold | 项目脚手架 | uv 工具链 | ⭐⭐⭐⭐ |
| fastapi | FastAPI | API 开发 | ⭐⭐⭐⭐⭐ |
| python-fastapi-development | FastAPI 开发 | SQLAlchemy、Pydantic | ⭐⭐⭐⭐⭐ |
| async-python-patterns | 异步编程 | asyncio、高并发 | ⭐⭐⭐⭐ |
| dbos-python | DBOS 工作流 | 持久化工作流、容错 | ⭐⭐⭐⭐⭐ |
| temporal-python-pro | Temporal 工作流 | 分布式事务、Saga 模式 | ⭐⭐⭐⭐⭐ |
| python-patterns | 设计模式 | 类型提示、最佳实践 | ⭐⭐⭐⭐ |
| python-testing-patterns | 测试模式 | pytest、fixtures、TDD | ⭐⭐⭐⭐⭐ |
| python-performance-optimization | 性能优化 | cProfile、py-spy | ⭐⭐⭐⭐ |
| python-packaging | PyPI 发布 | 包管理、版本控制 | ⭐⭐⭐⭐ |
| python-sdk | Python Sdk | SDK 开发 | ⭐⭐⭐⭐ |
| fastapi-pro | FastAPI Pro | 高级特性 | ⭐⭐⭐⭐⭐ |

### 新增 FastAPI Skill 详解

#### fastapi (ClawHub 高分)

**核心能力**:
- RESTful API 设计
- Pydantic 数据验证
- 依赖注入系统
- 异步 SQLAlchemy
- JWT/ OAuth2 认证
- WebSocket 支持
- OpenAPI 自动文档

**典型交互**:
```
"Create a FastAPI endpoint for user management"
"Add authentication to this API"
"Set up SQLAlchemy with async engine"
```

**快速开始**:
```bash
# 安装
clawhub install fastapi

# 使用
>> /fastapi 帮助我创建一个用户管理 API
```

### Python 开发推荐 Skills 组合

```
推荐组合:
/python-pro + /python-fastapi-development + /python-testing-patterns
/fastapi (ClawHub)
/dbos-python + /python-testing-patterns (DBOS 工作流)
/temporal-python-pro + /temporal-python-testing (Temporal 工作流)
/python-performance-optimization (性能优化)
/clean-pytest (pytest 最佳实践)
```

---

## 🧪 自动化测试 Skills

### 测试 Skills 矩阵

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| playwright-skill | Playwright 浏览器自动化 | E2E 测试、可视化 | ⭐⭐⭐⭐⭐ |
| test-master | Test Master | 综合测试 | ⭐⭐⭐⭐⭐ |
| e2e-testing-patterns | E2E 测试模式 | 最佳实践 | ⭐⭐⭐⭐ |
| e2e-testing | Cypress E2E | 端到端测试 | ⭐⭐⭐⭐ |
| python-testing-patterns | pytest 测试 | 单元/集成测试 | ⭐⭐⭐⭐⭐ |
| test-patterns | Test Patterns | 测试模式 | ⭐⭐⭐⭐ |
| clean-pytest | Clean Pytest | pytest 最佳实践 | ⭐⭐⭐⭐⭐ |
| test-case-generator | Test Case Generator | 测试用例生成 | ⭐⭐⭐⭐ |
| ai-test-automation | AI 驱动测试 | 自愈测试 | ⭐⭐⭐⭐⭐ |
| testing-qa | 综合 QA 工作流 | 完整流程 | ⭐⭐⭐⭐⭐ |
| tdd-orchestrator | TDD 协调器 | 红绿重构 | ⭐⭐⭐⭐ |
| android-adb | ADB Connection | Android 测试 | ⭐⭐⭐⭐⭐ |
| mobile-appium-test | Mobile Appium Test | 移动端自动化 | ⭐⭐⭐⭐⭐ |
| android_ui_verification | Android UI 测试 | ADB 自动化 | ⭐⭐⭐⭐ |
| api-tester | API Tester | API 测试 | ⭐⭐⭐⭐ |

### 新增测试 Skills 详解

#### test-master (ClawHub 高分)

**核心能力**:
- 综合测试策略设计
- 测试框架选择
- 自动化测试执行
- 测试报告生成
- CI/CD 集成

**典型交互**:
```
"Design a test strategy for this project"
"Set up automated testing pipeline"
"Generate test report"
```

#### clean-pytest (ClawHub 高分)

**核心能力**:
- pytest 最佳实践
- Fixture 高级用法
- 参数化测试
- Mock 和 Stub
- 覆盖率优化
- 测试组织结构

**典型交互**:
```
"Write clean pytest tests for this module"
"Optimize test coverage"
"Refactor test fixtures"
```

#### mobile-appium-test

**核心能力**:
- Appium 移动端测试
- Android/iOS 原生应用测试
- 混合应用测试
- 设备Farm 集成
- 并行执行

**适用场景**:
- ✅ 移动端游戏测试
- ✅ APP 自动化测试
- ✅ 跨设备兼容性测试

### 游戏客户端测试方案

| 测试类型 | 工具 | 适用场景 |
|---------|------|---------|
| 单元测试 | Unity Test Framework, pytest | 游戏逻辑验证 |
| 集成测试 | Playwright, Appium | 客户端与服务端交互 |
| UI测试 | Playwright, Appium | 游戏UI交互 |
| 移动端测试 | mobile-appium-test | Android/iOS 游戏 |
| 性能测试 | Unity Profiler, RenderDoc | 帧率、内存测试 |
| 回归测试 | CI/CD + Playwright | 版本发布验证 |

### 测试推荐 Skills 组合

```
推荐组合:
/test-master + /e2e-testing-patterns + /testing-qa
/clean-pytest (ClawHub 高分)
/python-testing-patterns + /test-driven-development
/mobile-appium-test (移动端游戏测试)
/android-adb + /android_ui_verification
/api-tester (API 测试)
```

---

## 🛠️ 开发者工具 Skills

### DevOps Skills 完整列表

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| docker | Docker | 容器化最佳实践 | ⭐⭐⭐⭐⭐ |
| docker-essentials | Docker Essentials | 基础容器化 | ⭐⭐⭐⭐⭐ |
| docker-skill | Docker Skill | Docker 使用 | ⭐⭐⭐⭐⭐ |
| docker-compose | Docker Compose | 多容器编排 | ⭐⭐⭐⭐⭐ |
| docker-ctl | Docker Ctl | 容器控制 | ⭐⭐⭐⭐⭐ |
| docker-diag | Docker Diag | 诊断排错 | ⭐⭐⭐⭐⭐ |
| docker-sandbox | Docker Sandbox | 沙盒环境 | ⭐⭐⭐⭐⭐ |
| git | Git | 版本控制 | ⭐⭐⭐⭐⭐ |
| git-essentials | Git Essentials | 基础操作 | ⭐⭐⭐⭐⭐ |
| git-workflows | Git Workflows | 工作流 | ⭐⭐⭐⭐⭐ |
| git-helper | Git Helper | Git 助手 | ⭐⭐⭐⭐⭐ |
| git-summary | Git Summary | 提交摘要 | ⭐⭐⭐⭐⭐ |
| git-secrets-scanner | Git Secrets Scanner | 密钥扫描 | ⭐⭐⭐⭐⭐ |
| git-changelog-gen | Git Changelog Generator | Changelog 生成 | ⭐⭐⭐⭐⭐ |
| git-auto | Git Auto | Git 自动化 | ⭐⭐⭐⭐⭐ |
| git-flow-helper | Git Flow Helper | Git Flow | ⭐⭐⭐⭐⭐ |
| workflow-automation | CI/CD 流水线 | GitHub Actions/GitLab CI | ⭐⭐⭐⭐⭐ |
| ci-cd | CI-CD | 持续集成/部署 | ⭐⭐⭐⭐⭐ |
| deployment-engineer | 部署工程师 | GitOps、Docker | ⭐⭐⭐⭐⭐ |
| debugging-strategies | 系统化调试 | 二分搜索、日志分析 | ⭐⭐⭐⭐⭐ |
| bug-fixing-workflow | Bug 修复工作流 | 系统化修复 | ⭐⭐⭐⭐ |
| dependency-upgrade | 依赖升级 | 安全更新 | ⭐⭐⭐⭐ |
| dev-environment-setup | 开发环境配置 | 一键配置 | ⭐⭐⭐⭐ |

### 新增开发者工具 Skills

#### docker-essentials (ClawHub 高分)

**核心能力**:
- Docker 基础概念
- 镜像构建和优化
- 容器运行和管理
- Docker Compose
- 网络和存储
- 最佳实践

**典型交互**:
```
"Build a Docker image for this application"
"Optimize this Dockerfile"
"Set up Docker Compose for microservices"
```

#### git-essentials (ClawHub 高分)

**核心能力**:
- 基础 Git 操作
- 分支管理
- 合并和冲突解决
- 远程仓库操作
- Git 最佳实践

**典型交互**:
```
"Help me resolve this merge conflict"
"Create a feature branch"
"Rebase onto main branch"
```

#### git-workflows (ClawHub 高分)

**核心能力**:
- Git Flow 工作流
- GitHub Flow
- trunk-based 开发
- Pull Request 工作流
- 代码审查流程

#### api-gateway (ClawHub 高分)

**核心能力**:
- API Gateway 配置
- 路由规则
- 认证和授权
- 限流和熔断
- 监控和日志

**典型交互**:
```
"Design an API Gateway architecture"
"Configure routing rules"
"Set up authentication"
```

### 开发者工具推荐 Skills 组合

```
推荐组合:
/docker + /docker-compose + /docker-essentials
/git + /git-workflows + /git-essentials
/workflow-automation + /ci-cd + /deployment-engineer
/debugging-strategies + /bug-fixing-workflow
/api-gateway (API 网关)
/git-secrets-scanner (安全扫描)
```

---

## 💡 推荐 Skills 组合

### 游戏开发组合

```
推荐: /game-cog (编排器，自动路由)
     /unity-developer + /unity-ai-workflow (2026 新版)
     /unity-ecs-patterns + /multiplayer
     /openclaw-unreal-skill + /ue-log-analyzer + /ue-build-package
     /godot-dev-guide + /openclaw-godot-skill
     /bevy-ecs-expert (Rust 游戏引擎)
```

### Python 后端开发组合

```
推荐: /python-pro + /python-fastapi-development + /python-testing-patterns
     /fastapi (ClawHub 高分)
/dbos-python + /python-testing-patterns (DBOS 工作流)
     /temporal-python-pro + /temporal-python-testing (Temporal 工作流)
/clean-pytest (pytest 最佳实践)
/python-performance-optimization (性能优化)
```

### 测试组合

```
推荐: /test-master + /e2e-testing-patterns + /testing-qa
     /clean-pytest (ClawHub 高分)
/python-testing-patterns + /test-driven-development
     /mobile-appium-test (移动端测试)
/android-adb + /android_ui_verification
     /api-tester (API 测试)
```

### DevOps 组合

```
推荐: /docker + /docker-compose + /docker-essentials (ClawHub 高分)
/git + /git-workflows + /git-essentials (ClawHub 高分)
     /workflow-automation + /ci-cd + /deployment-engineer
/debugging-strategies + /bug-fixing-workflow
     /git-secrets-scanner (安全扫描)
```

---

## 🚀 实战案例

### 案例 1: 使用 Skills 开发帧同步游戏后端

```bash
# 1. 项目初始化
>> /python-pro 创建一个新的 Python 项目，使用 uv 管理依赖

# 2. FastAPI 开发
>> /fastapi 设计帧同步游戏的 REST API

# 3. 异步处理
>> /async-python-patterns 实现游戏房间管理，高并发

# 4. 工作流编排 (可选)
>> /temporal-python-pro 实现游戏状态持久化工作流

# 5. 测试
>> /python-testing-patterns 编写房间管理测试
>> /clean-pytest 优化测试代码
>> /test-driven-development 使用 TDD 开发新功能

# 6. 部署
>> /docker-essentials 容器化应用
>> /deployment-engineer 设置 Docker 部署
>> /workflow-automation 配置 CI/CD
```

### 案例 2: 使用 Skills 开发 Unreal 游戏

```bash
# 1. 项目设置
>> /openclaw-unreal-skill 初始化 UE5 项目

# 2. C++ 开发
>> /openclaw-unreal-skill 创建游戏角色类

# 3. 日志分析
>> /ue-log-analyzer 分析开发日志

# 4. 打包构建
>> /ue-build-package 打包 Windows 版本
```

### 案例 3: 使用 Skills 进行移动端游戏测试

```bash
# 1. 移动端测试
>> /mobile-appium-test 设置 Android 游戏测试
>> /android-adb 连接设备

# 2. UI 验证
>> /android_ui_verification 验证游戏 UI

# 3. 测试报告
>> /test-master 生成测试报告
```

### 案例 4: 使用 Skills 优化开发流程

```bash
# 1. 环境设置
>> /docker-sandbox 创建开发沙盒

# 2. Git 工作流
>> /git-workflows 使用 Git Flow 管理
>> /git-essentials 使用 rebase 整理提交历史
>> /git-pr-workflows 创建高质量 PR

# 3. 调试
>> /debugging-strategies 分析这个错误

# 4. Bug 修复
>> /bug-fixing-workflow 系统化修复这个 bug

# 5. 依赖管理
>> /dependency-upgrade 升级项目依赖
```

---

## 📦 安装指南

### 通过 ClawHub 安装

```bash
# 安装 CLI
npm i -g clawhub

# 搜索 Skills
clawhub search "game development"
clawhub search "python"
clawhub search "testing"

# 安装 Skills
clawhub install fastapi
clawhub install test-master
clawhub install docker-essentials
```

### 通过 Antigravity 安装

```bash
# 默认安装
npx antigravity-awesome-skills

# Claude Code
npx antigravity-awesome-skills --claude
```

---

## 🔧 使用方式

### Claude Code

```bash
>> /skill-name 帮助我...
```

### Gemini CLI/Codex CLI

```bash
Use @skill-name to help me...
```

---

## 📚 相关资源

- [ClawHub Skills 市场](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Unity AI Workflow 2026](https://github.com/David-GD13/unity-ai-workflow)
- [DBOS Python SDK](https://docs.dbos.dev/)
- [Temporal Python SDK](https://docs.temporal.io/)
- [官方 Skills 目录](../CATALOG.md)
- [Skills 使用指南](../docs/USAGE.md)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)

---

## 📝 本周更新亮点

### 新增 ClawHub 高分 Skills

| Skill | 评分 | 分类 |
|-------|------|------|
| docker-essentials | 3.694 | 开发者工具 |
| git-essentials | 3.746 | 开发者工具 |
| git-workflows | 3.683 | 开发者工具 |
| fastapi | 3.523 | Python 开发 |
| test-master | 1.049 | 测试 |
| clean-pytest | 3.309 | 测试 |
| mobile-appium-test | 3.346 | 测试 |
| api-gateway | 3.684 | 开发者工具 |

### 重点 Skills 速查

| 场景 | 推荐 Skill |
|------|-----------|
| Unity 开发 | /unity-developer, /unity-ai-workflow |
| Unreal 开发 | /openclaw-unreal-skill, /ue-log-analyzer |
| Godot 开发 | /godot-dev-guide, /openclaw-godot-skill |
| Python API | /fastapi (ClawHub), /python-fastapi-development |
| Python 测试 | /clean-pytest (ClawHub), /python-testing-patterns |
| 移动端测试 | /mobile-appium-test, /android-adb |
| 容器化 | /docker-essentials (ClawHub), /docker-compose |
| Git 工作流 | /git-workflows (ClawHub), /git-essentials |
| CI/CD | /ci-cd (ClawHub), /workflow-automation |

---

**文档更新时间**: 2026-03-04  
**Claude Code Skills 调研 - 第十三周**
