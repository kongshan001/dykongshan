# Claude Code Skills 调研报告 - 游戏客户端开发、Python 与自动化测试

> 调研时间: 2026-03-04 (持续更新)
> 来源: ClawHub ( Antigravity Awesome Skills )
> 最新更新: 补充 Unity Skill、游戏客户端自动化测试、API 测试等专题

---

## 📋 调研概述

本次调研覆盖以下方向：
1. 游戏客户端开发 (Unity, Unreal, Godot)
2. Python 开发
3. 自动化测试与质量保证
4. 开发者工具 (Docker, Kubernetes, GitLab)

---

## 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 引擎 | 核心能力 | 评分 |
|-----------|------|---------|------|
| openclaw-godot-skill | Godot | 场景管理、节点操作、输入模拟、调试 | 0.924 |
| openclaw-unreal-skill | Unreal | 级别管理、Actor 操作、组件控制、调试 | 0.922 |
| game-developer-skill | Unity/Unreal | 游戏系统开发、ECS、物理、性能优化 | 0.861 |
| level-design-patterns | Unity | 场景创建、地形自动化、编辑器工作流 | 0.768 |
| ue57-gamepiece-designer | Unreal 5.7 | 游戏物体设计 | 0.811 |

### 1.2 Godot Skill 详解

**Skill**: `openclaw-godot-skill`
**所有者**: TomLeeLive
**最新版本**: 1.2.7 (2026-03-03 更新)

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

### 📸 编辑器控制
- 截图捕获
- 游戏测试
- 资源管理
```

#### 适用场景
- ✅ Godot 4.x 游戏开发
- ✅ 2D/3D 游戏原型
- ✅ 游戏逻辑调试
- ✅ 自动化编辑器工作流

#### 触发关键词
> "Godot", "inspecting scenes", "creating nodes", "taking screenshots", "testing gameplay", "controlling the editor"

---

### 1.3 Unreal Skill 详解

**Skill**: `openclaw-unreal-skill`
**所有者**: TomLeeLive
**最新版本**: 1.0.0 (2026-03-03 更新)

#### 核心能力
```markdown
### 🏗️ 级别管理
- 级别创建和切换
- 关卡流送控制
- 世界分区管理

### 🎭 Actor 操作
- Actor 创建和销毁
- 变换控制 (位置/旋转/缩放)
- 组件管理

### 🔧 组件系统
- 静态网格组件
- 碰撞组件
- 材质组件

### 🎮 输入与调试
- 控制台命令执行
- 调试渲染
- 输入模拟

### 📦 资源与资产
- 资产搜索
- 资源导入
- 蓝图操作

### 🎯 特定功能
- 变换控制 (Transform)
- 编辑器操作 (Editor)
- 调试工具 (Debug)
- 输入模拟 (Input)
- 控制台 (Console)
```

#### 适用场景
- ✅ Unreal Engine 5.x 项目开发
- ✅ 级别设计和关卡流送
- ✅ 蓝图/C++ 混合开发
- ✅ 游戏调试和性能分析

---

### 1.4 Game Developer Skill 详解

**Skill**: `game-developer-skill`
**所有者**: CryptoRabea
**最新版本**: 1.0.0 (2026-02-26 更新)

#### 核心能力
```markdown
### 🎮 Unity 开发
- 组件系统架构
- ECS 模式实现
- 物理系统集成
- UI 系统 (UI Toolkit, UGUI)

### 🎭 Unreal 开发
- Actor 生命周期
- 蓝图可视化编程
- 材质和着色器
- 动画蓝图

### ⚡ 性能优化
- 渲染优化
- 内存管理
- 对象池技术
- LOD 系统

### 📐 设计模式
- 状态机模式
- 命令模式
- 观察者模式
- 对象池模式
```

#### 适用场景
- ✅ 跨引擎游戏开发
- ✅ 游戏架构设计
- ✅ 性能敏感型游戏
- ✅ 团队协作开发规范

---

## 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| python-executor | 安全沙箱执行 Python 代码 | 数据分析、脚本运行 | 0.956 |
| clean-pytest | pytest 最佳实践 | 测试质量提升 | 0.765 |
| lsp-python | Python 语言服务器 | 代码补全、类型检查 | 0.758 |
| python-patterns | Python 设计原则 | 架构设计 | - |
| python-pro | Python 3.12+ 全栈 | 全面开发指南 | - |

### 2.2 Python Executor 详解

**Skill**: `python-executor`
**所有者**: okaris
**最新版本**: 0.1.5 (2026-03-03 更新)

#### 核心能力
```markdown
### 🐍 执行环境
- 安全沙箱执行
- 依赖预装: NumPy, Pandas, Matplotlib, requests, BeautifulSoup

### 📊 数据分析
- 数据处理和分析
- 可视化图表生成
- 文件 I/O 操作

### 🔧 脚本执行
- 快速原型开发
- 自动化任务
- 数据抓取
```

#### 适用场景
- ✅ 数据分析原型
- ✅ 快速脚本验证
- ✅ 自动化任务执行
- ✅ 数据可视化

---

### 2.3 Clean Pytest 详解

**Skill**: `clean-pytest`
**所有者**: marcoracer
**最新版本**: 0.1.0 (2026-02-25 更新)

#### 核心能力
```markdown
### 🧪 测试模式
- Fake-based testing (伪造对象测试)
- Contract testing (契约测试)
- Dependency injection (依赖注入)

### 📝 pytest 最佳实践
- 清晰的测试结构
- 可维护的测试代码
- 测试隔离和并行

### 🎯 质量保证
- 代码覆盖率分析
- 测试可读性优化
- 快速反馈循环
```

#### 适用场景
- ✅ Python 项目测试
- ✅ 单元测试和集成测试
- ✅ 测试框架搭建
- ✅ TDD 开发模式

---

## 三、自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| playwright | 浏览器自动化与网页抓取 | Web 自动化、E2E 测试 | 1.116 |
| e2e-testing-patterns | E2E 测试模式 | Playwright/Cypress | 1.112 |
| test-master | 测试策略与框架 | 全面测试 | 1.080 |
| auto-test-generator | 自动生成测试 | 单元/集成测试 | 0.794 |
| smoke-test-generator | 冒烟测试生成 | 快速回归测试 | 0.679 |

### 3.2 Playwright 详解

**Skill**: `playwright`
**所有者**: ivangdavila
**最新版本**: 1.0.2 (2026-02-26 更新)

#### 核心能力
```markdown
### 🌐 浏览器自动化
- 表单填写和提交
- 页面截图
- 数据提取
- 交互模拟

### 🕷️ 网页抓取
- 动态页面抓取
- JavaScript 渲染内容
- 反爬虫应对

### 🧪 测试集成
- E2E 测试
- 视觉回归测试
- 性能测试

### 🔌 MCP 支持
- MCP 协议集成
- 远程控制
- 自动化工作流
```

#### 适用场景
- ✅ Web 应用自动化测试
- ✅ 网页数据抓取
- ✅ 自动化表单填写
- ✅ 视觉回归测试

---

### 3.3 E2E Testing Patterns 详解

**Skill**: `e2e-testing-patterns`
**所有者**: wpank
**最新版本**: 1.0.0 (2026-02-26 更新)

#### 核心能力
```markdown
### 🎯 测试策略
- 关键用户旅程覆盖
-  flaky test 消除
- CI/CD 集成

### 🛠️ 工具支持
- Playwright
- Cypress

### 📈 最佳实践
- 测试稳定性优化
- 并行执行
- 测试报告
- 失败重试机制
```

#### 适用场景
- ✅ Web 应用 E2E 测试
- ✅ CI/CD 流程集成
- ✅ 关键路径测试
- ✅ 测试稳定性改进

---

### 3.4 Test Master 详解

**Skill**: `test-master`
**所有者**: Veeramanikandanr48
**最新版本**: 0.1.0 (2026-02-25 更新)

#### 核心能力
```markdown
### 🧪 测试类型
- 单元测试
- 集成测试
- E2E 测试

### 📊 测试分析
- 覆盖率分析
- 性能测试
- 安全测试

### 🏗️ 框架搭建
- 测试策略制定
- 自动化框架设计
- 最佳实践指导
```

#### 适用场景
- ✅ 测试策略制定
- ✅ 测试框架搭建
- ✅ 全类型测试
- ✅ 质量保证流程

---

## 四、开发者工具 Skills

### 4.1 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| docker | Docker 容器构建与部署 | 容器化 | 1.193 |
| gitlab-cli-skills | GitLab CLI 操作 | GitLab 工作流 | 1.058 |
| kube-medic | Kubernetes 集群诊断 | K8s 故障排查 | 0.930 |
| dockerfile-generator | Dockerfile 生成 | 容器镜像构建 | 0.868 |
| neo-docker-to-k8s-manifests | Docker 到 K8s 转换 | 部署自动化 | 0.995 |
| code-qc | 代码质量审计 | 代码审查 | 0.780 |

### 4.2 Docker 详解

**Skill**: `docker`
**所有者**: ivangdavila
**最新版本**: 1.0.3 (2026-02-26 更新)

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

### 🌐 网络
- 网络配置
- 服务发现
- 负载均衡

### 🚀 部署
- 生产环境部署
- 开发环境配置
- CI/CD 集成
```

#### 适用场景
- ✅ Docker 镜像构建
- ✅ 容器安全加固
- ✅ 开发/生产环境
- ✅ 微服务部署

---

### 4.3 Kubernetes Medic 详解

**Skill**: `kube-medic`
**所有者**: tkuehnl
**最新版本**: 1.0.3 (2026-02-25 更新)

#### 核心能力
```markdown
### 🚨 故障排查
- 集群健康检查
- Pod 状态分析
- 资源问题诊断

### 📊 快速 triage
- AI 驱动的故障分析
- kubectl 集成
- 快速问题定位

### 🔧 修复建议
- 问题根因分析
- 解决方案推荐
- 最佳实践指导
```

#### 适用场景
- ✅ Kubernetes 集群管理
- ✅ 生产故障排查
- ✅ 集群健康监控
- ✅ 性能问题诊断

---

### 4.4 GitLab CLI Skills 详解

**Skill**: `gitlab-cli-skills`
**所有者**: vince-winkintel
**最新版本**: 1.6.0 (2026-03-03 更新)

#### 核心能力
```markdown
### 🦊 GitLab 操作
- 项目管理
- MR 审批
- CI/CD 管道

### 📝 代码审查
- 代码合并
- 问题跟踪
- 审查流程

### 🔄 工作流
- 自动化脚本
- 批量操作
- 集成工具
```

#### 适用场景
- ✅ GitLab 项目管理
- ✅ CI/CD 流程
- ✅ 代码审查
- ✅ 团队协作

---

### 4.5 Code QC 详解

**Skill**: `code-qc`
**所有者**: IsonaEi
**最新版本**: 1.0.0 (2026-03-03 更新)

#### 核心能力
```markdown
### 🔍 质量审计
- 代码结构分析
- 最佳实践检查
- 安全漏洞扫描

### 📊 支持语言
- Python
- TypeScript
- JavaScript
- 以及更多

### 📈 报告生成
- 问题列表
- 改进建议
- 趋势分析
```

#### 适用场景
- ✅ 代码质量审计
- ✅ 代码审查
- ✅ 安全检查
- ✅ 技术债务评估

---

## 五、推荐 Skills 组合

### 5.1 游戏客户端开发组合
```
推荐组合:
- openclaw-godot-skill (Godot 开发)
- openclaw-unreal-skill (Unreal 开发)  
- game-developer-skill (通用游戏开发)
- level-design-patterns (Unity 关卡设计)
```

### 5.2 Python 开发组合
```
推荐组合:
- python-executor (代码执行)
- clean-pytest (测试)
- lsp-python (语言支持)
```

### 5.3 测试与质量保证组合
```
推荐组合:
- playwright (Web 自动化)
- e2e-testing-patterns (E2E 测试)
- test-master (测试策略)
- code-qc (代码质量)
```

### 5.4 DevOps 工具组合
```
推荐组合:
- docker (容器化)
- kube-medic (K8s 诊断)
- gitlab-cli-skills (GitLab 操作)
- neo-docker-to-k8s-manifests (部署自动化)
```

---

## 六、使用建议

### 6.1 安装方式
```bash
# 使用 ClawHub 安装
clawhub install <skill-name>

# 例如
clawhub install openclaw-godot-skill
clawhub install playwright
clawhub install docker
```

### 6.2 触发方式
大多数 Skills 会根据关键词自动触发：
- 游戏开发: "game", "unity", "unreal", "godot"
- Python: "python", "pytest", "pip"
- 测试: "test", "automation", "e2e"
- DevOps: "docker", "k8s", "kubernetes"

---

## 八、近期新增 Skills (2026年3月)

### 8.1 Unity 开发 (新增)

**Skill**: `unity`
**所有者**: 待确认
**评分**: 3.029

#### 核心能力
```markdown
### 🎮 Unity 开发
- 场景管理
- 组件操作
- 脚本编写
- 资源管理

### 🔧 构建与部署
- 构建配置
- 平台部署
- 性能优化
```

#### 适用场景
- ✅ Unity 游戏开发
- ✅ Unity 编辑器自动化
- ✅ 资源与资产管理

---

### 8.2 游戏引擎综合

**Skill**: `game-engine`
**评分**: 0.845

**Skill**: `game-developer-skill`
**评分**: 0.847

#### 核心能力
```markdown
### 🎮 引擎支持
- Unity 开发
- Unreal 开发
- Godot 开发
- 自定义引擎

### 🛠️ 开发工具
- 编辑器集成
- 调试工具
- 性能分析
```

---

### 8.3 Git 开发者工具

| Skill 名称 | 评分 | 核心能力 |
|-----------|------|---------|
| git-essentials | 3.746 | Git 基础操作 |
| git-workflows | 3.683 | Git 工作流 |
| git | 3.656 | Git 全套工具 |
| git-helper | 3.598 | Git 辅助工具 |
| git-summary | 3.565 | Git 提交摘要 |
| git-secrets-scanner | 3.435 | Git 密钥扫描 |
| git-changelog-gen | 3.409 | changelog 生成 |
| git-auto | 3.377 | Git 自动化 |
| git-flow-helper | 3.333 | Git Flow 支持 |

---

### 8.4 Docker 与容器工具

| Skill 名称 | 评分 | 核心能力 |
|-----------|------|---------|
| docker-essentials | 1.231 | Docker 基础 |
| docker | 1.105 | Docker 全套 |
| kubernetes | 1.101 | K8s 管理 |
| container-debug | 1.084 | 容器调试 |
| docker-ctl | 1.074 | Docker 控制 |
| kubectl | 1.054 | kubectl 工具 |
| docker-sandbox | 1.039 | Docker 沙箱 |
| k8s-browser | 1.005 | K8s 浏览器 |

---

### 8.5 API 测试工具

| Skill 名称 | 评分 | 核心能力 |
|-----------|------|---------|
| rest-api-tester | 3.073 | REST API 测试 |
| jira-rest-v3 | 1.849 | Jira API |
| api-gateway | 1.211 | API 网关 |

---

### 8.6 Web 开发工具

| Skill 名称 | 评分 | 核心能力 |
|-----------|------|---------|
| web-deploy-github | 3.482 | GitHub Pages 部署 |
| web | 3.445 | Web 开发 |
| web-pilot | 3.441 | Web 导航 |
| ai-web-automation | 3.427 | Web 自动化 |
| web-search-free | 3.360 | Web 搜索 |

---

### 8.7 Python 数据可视化

**Skill**: `python-dataviz`
**评分**: 3.427

#### 核心能力
```markdown
### 📊 数据可视化
- 图表生成
- 数据绑定
- 交互式图表
- 导出功能

### 🐍 Python 集成
- Pandas 集成
- Matplotlib 支持
- Seaborn 支持
```

---

### 8.8 游戏客户端自动化测试

**Skill**: `qa-testing-bots`
**评分**: 3.232

**Skill**: `afrexai-qa-testing-engine`
**评分**: 0.901

#### 核心能力
```markdown
### 🧪 自动化测试
- UI 测试自动化
- 功能测试
- 回归测试
- 性能测试

### 🎮 游戏测试
- 场景测试
- AI 行为测试
- 网络同步测试
- 资源加载测试

### 🤖 AI 驱动测试
- 智能测试用例生成
- 自动化测试执行
- 测试结果分析
```

---

## 九、总结

本次调研覆盖了 30+ 个 Claude Code Skills，涵盖：

1. **游戏客户端开发**: 6+ 个核心 Skills (Godot, Unreal, Unity, 通用游戏引擎)
2. **Python 开发**: 10+ 个 Skills (执行、测试、类型检查、数据可视化)
3. **自动化测试**: 10+ 个 Skills (Playwright, E2E, 单元测试, 游戏客户端测试)
4. **开发者工具**: 20+ 个 Skills (Docker, K8s, Git, API 测试, Web 开发)

### 9.1 推荐 Skills 组合

#### 游戏客户端开发
```
推荐组合:
- openclaw-godot-skill (Godot 开发)
- openclaw-unreal-skill (Unreal 开发)
- unity (Unity 开发)
- game-developer-skill (通用游戏开发)
```

#### Python 开发
```
推荐组合:
- python-executor (代码执行)
- python-dataviz (数据可视化)
- clean-pytest (测试)
- lsp-python (语言支持)
```

#### 测试与质量保证
```
推荐组合:
- playwright (Web 自动化)
- e2e-testing-patterns (E2E 测试)
- test-master (测试策略)
- rest-api-tester (API 测试)
- qa-testing-bots (游戏客户端测试)
```

#### DevOps 工具
```
推荐组合:
- docker / docker-essentials (容器化)
- kubernetes / kube-medic (K8s 诊断)
- git / git-workflows (版本控制)
- gitlab-cli-skills (GitLab 操作)
```

### 9.2 安装方式
```bash
# 使用 ClawHub 安装
clawhub install <skill-name>

# 例如
clawhub install openclaw-godot-skill
clawhub install unity
clawhub install playwright
clawhub install docker
```

---

*文档生成时间: 2026-03-04*
*来源: ClawHub Registry*
*持续更新中...*
