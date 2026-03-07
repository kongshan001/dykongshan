# Claude Code Skills 补充调研报告 - 2026年3月 (第二十周)

**调研日期**: 2026-03-04  
**技能来源**: ClawHub 实时搜索 + GitHub 热门仓库 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，基于 ClawHub 实时搜索排行和 GitHub 热门项目，覆盖以下方向：
1. 游戏客户端开发 (Unity/Godot/Unreal)
2. Python 开发 (FastAPI/Django/异步)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (浏览器自动化/GitHub 自动化/Docker)

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
| game-cog | **1.102** | 游戏开发编排器，DeepResearch Bench 第一名 | 通用游戏开发 |
| openclaw-unity-skill | **1.013** | Unity 开发技能 | Unity 开发 |
| godot-dev-guide | **0.983** | Godot 4.x 完整开发指南 | Godot 开发 |
| game-developer-skill | **0.976** | Claude 游戏开发者 | AI 辅助开发 |
| blender | **0.965** | Blender 3D 建模 | 3D 资产制作 |
| unity | **0.961** | Unity 最佳实践 | Unity 开发 |
| fivem-dev | **0.950** | Fivem 开发 | GTA5 Mod 开发 |
| unreal-engine | **0.935** | Unreal Engine 开发 | UE 开发 |
| openclaw-unreal-skill | **0.908** | Unreal 开发技能 | UE 开发 |
| game-engine | **0.900** | 游戏引擎架构 | 引擎原理 |

### 1.2 Antigravity 游戏开发 Skills 矩阵

**来源**: [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) (18,542⭐)

| Skill ID | 名称 | 核心能力 | 适用引擎 |
|----------|------|---------|---------|
| unity-developer | Unity 6 LTS 专家 | URP/HDRP、跨平台部署 | Unity |
| unity-ecs-patterns | DOTS/ECS 架构 | Jobs System、Burst | Unity |
| godot-gdscript-patterns | Godot 4 GDScript | 信号、场景、状态机 | Godot |
| godot-4-migration | Godot 4 迁移 | 3.x → 4.x 迁移 | Godot |
| unreal-engine-cpp-pro | UE5 C++ 开发 | UObject、Slate、网络复制 | Unreal |
| 2d-games | 2D 游戏开发 | 精灵、瓦片地图、物理 | 通用 |
| 3d-games | 3D 游戏开发 | 渲染、着色器、物理 | 通用 |
| game-development | 游戏开发编排器 | 自动路由到子 Skills | 通用 |
| mobile-games | 移动游戏开发 | 触控输入、电池优化 | 移动端 |
| multiplayer | 多人游戏开发 | 网络架构、延迟补偿 | 通用 |

### 1.3 Unity AI Workflow (2026 新增) 详解

**项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)

**核心特性**:
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

### 1.4 游戏开发学习路径

```
入门级:
  1. 2d-games → 基础 2D 游戏开发
  2. 3d-games → 基础 3D 游戏开发
  3. game-design → 游戏设计原理

进阶级:
  1. unity-developer → Unity 6 LTS 开发
  2. godot-gdscript-patterns → Godot 4 开发
  3. unreal-engine-cpp-pro → Unreal 5 开发

高级:
  1. unity-ecs-patterns → DOTS 架构
  2. multiplayer → 网络同步
  3. game-cog → AI 编排开发
```

---

## 🐍 二、Python 开发 Skills

### 2.1 Python Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| fastapi | **1.108** | FastAPI 开发 | Web API |
| python | **0.986** | Python 编码规范 | 规范开发 |
| django | **0.960** | Django 开发 | Web 框架 |
| senior-backend | **0.948** | 高级后端开发 | 企业级后端 |
| test-patterns | **0.942** | 测试模式 | 测试开发 |
| py | **0.928** | Python 开发 | 通用 Python |
| afrexai-fastapi-production | **0.895** | FastAPI 生产工程 | 部署运维 |
| drf | **0.875** | Django REST Framework | REST API |

### 2.2 Python 开发 Skills 矩阵

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| python-pro | Python 3.12+ 全栈指南 | 通用 Python 开发 |
| python-patterns | 开发原则和决策 | 架构设计 |
| python-fastapi-development | FastAPI 后端开发 | API 服务 |
| python-development-python-scaffold | 项目脚手架 | 项目初始化 |
| python-testing-patterns | pytest/测试策略 | 质量保证 |
| python-performance-optimization | 性能分析和优化 | 性能调优 |
| python-packaging | PyPI 发布 | 库分发 |
| async-python-patterns | asyncio 异步编程 | 高并发 |
| temporal-python-pro | Temporal 工作流 | 分布式事务 |

### 2.3 FastAPI 专题详解

**FastAPI (评分: 1.108)** - ⭐ 重点推荐

```markdown
### 核心能力
- FastAPI 完整开发工作流
- Pydantic 数据验证
- 依赖注入系统
- SQLAlchemy 集成
- 异步数据库操作
- JWT 认证
- OpenAPI 自动生成
- 类型提示和验证
- 异步支持

### 适用场景
- ✅ 高性能 REST API
- ✅ 微服务架构
- ✅ 实时 WebSocket 应用
- ✅ 数据处理管道
- ✅ ML 模型服务
```

### 2.4 Python 开发学习路径

```
入门级:
  1. python → Python 基础
  2. py → 通用 Python 开发
  3. python-patterns → 设计模式

进阶级:
  1. fastapi → FastAPI Web 开发
  2. django → Django 全栈开发
  3. async-python-patterns → 异步编程

高级:
  1. senior-backend → 企业级后端
  2. temporal-python-pro → 工作流引擎
  3. python-performance-optimization → 性能优化
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 测试 Skills 排行榜 (ClawHub)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| android-adb | **1.220** | ADB 连接 | 移动端测试 |
| playwright-scraper-skill | **1.157** | Playwright 爬虫 | 数据抓取 |
| e2e-testing-patterns | **1.101** | E2E 测试模式 | 测试最佳实践 |
| playwright | **1.096** | Playwright 自动化 | Web 自动化 |
| test-master | **1.082** | 测试大师 | 综合测试 |
| clawbrowser | **1.062** | 浏览器自动化 | 自动化操作 |
| android | **1.019** | Android 开发 | 移动端 |
| midscene-android-automation | **1.009** | Android 自动化 | 移动游戏测试 |
| mobile | **0.995** | 移动开发 | 移动端 |
| ios | **0.977** | iOS 开发 | iOS 开发 |

### 3.2 移动端游戏测试 Skills 矩阵

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| android-adb | ADB 连接管理 | 设备控制 |
| midscene-android-automation | Android 游戏自动化 | AI 驱动测试 |
| midscene-ios-automation | iOS 自动化 | iOS 测试 |
| mobile-appium-test | Appium 跨平台测试 | 跨平台测试 |
| atl-mobile | Agent Touch Layer | 移动端自动化 |
| android | Android 开发测试 | 移动端开发 |
| ios | iOS 开发测试 | iOS 开发 |

### 3.3 Android ADB 专题详解

**android-adb (评分: 1.220)** - ⭐ 重点推荐

```markdown
### 核心能力
- Android ADB 连接
- 设备管理
- 日志抓取
- APK 安装卸载
- 屏幕截图和录制
- 性能监控
- 游戏客户端测试

### 适用场景
- ✅ Android 游戏自动化测试
- ✅ 移动端性能分析
- ✅ 游戏客户端兼容性测试
- ✅ 自动化回归测试
- ✅ 游戏脚本录制回放
```

### 3.4 Midscene 专题详解

**midscene-android-automation (评分: 1.009)** - AI 驱动测试

```markdown
### 核心能力
- Android 游戏自动化
- AI 驱动测试
- 自动化脚本生成
- 跨设备测试
- 性能监控
- 回归测试

### 核心特性
- 🎮 专为游戏测试设计
- 🤖 AI 自动生成测试用例
- 📊 性能数据采集
- 🔄 支持自动化回归
```

### 3.5 游戏客户端测试学习路径

```
入门级:
  1. android-adb → ADB 基础
  2. android → Android 基础
  3. playwright → Web 自动化基础

进阶级:
  1. midscene-android-automation → AI 驱动测试
  2. e2e-testing-patterns → E2E 测试
  3. mobile-appium-test → Appium 跨平台

高级:
  1. test-master → 综合测试
  2. atl-mobile → 高级移动自动化
  3. game-cog → 游戏开发+测试
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 Docker 工具 Skills (评分最高)

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| docker-essentials | **3.694** | Docker 基础 | 容器入门 |
| docker | **3.577** | Docker 全面技能 | 容器开发 |
| docker-sandbox | **3.548** | Docker 沙箱 | 安全测试 |
| docker-ctl | **3.531** | Docker 控制 | 容器管理 |
| docker-compose | **3.511** | Docker Compose | 编排工具 |

### 4.2 云基础设施 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| aws-infra | **1.215** | AWS 基础设施 | 云服务 |
| infra-as-code | **1.098** | 基础设施即代码 | IaC |
| aws | **1.094** | AWS 全能 | 云服务 |
| azure-infra | **1.089** | Azure 基础设施 | 云服务 |
| gcloud | **1.063** | Google Cloud | 云服务 |

### 4.3 GitHub/CI 工具 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| gh-action-gen | **1.005** | GitHub Action 生成器 | CI/CD |
| jenkins | **0.948** | Jenkins 技能 | 持续集成 |
| circleci | **0.923** | CircleCI 技能 | CI/CD |
| github-actions-generator | **0.790** | GitHub Actions 生成 | CI/CD |

### 4.4 浏览器自动化 Skills

| Skill 名称 | 评分 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| playwright | **1.096** | Playwright 自动化 | Web 自动化 |
| playwright-scraper-skill | **1.157** | Playwright 爬虫 | 数据抓取 |
| clawbrowser | **1.062** | 浏览器自动化 | 自动化操作 |
| browser-automation | - | 浏览器自动化 | 测试/爬虫 |

### 4.5 开发者工具学习路径

```
Docker 方向:
  1. docker-essentials → Docker 基础
  2. docker → 容器深入
  3. docker-compose → 编排工具

云服务方向:
  1. aws-infra → AWS 基础
  2. azure-infra → Azure 基础
  3. infra-as-code → IaC

CI/CD 方向:
  1. gh-action-gen → GitHub Actions
  2. jenkins → Jenkins
  3. circleci → CircleCI
```

---

## 📈 五、ClawHub 热门 Skills TOP 30 排行榜

| 排名 | Skill 名称 | 评分 | 分类 |
|------|------------|------|------|
| 1 | docker-essentials | 3.694 | DevOps |
| 2 | docker | 3.577 | DevOps |
| 3 | docker-sandbox | 3.548 | DevOps |
| 4 | docker-ctl | 3.531 | DevOps |
| 5 | docker-compose | 3.511 | DevOps |
| 6 | android-adb | 1.220 | 移动测试 |
| 7 | aws-infra | 1.215 | 云服务 |
| 8 | fastapi | 1.108 | Python |
| 9 | playwright-scraper-skill | 1.157 | 自动化 |
| 10 | e2e-testing-patterns | 1.101 | 测试 |
| 11 | playwright | 1.096 | 自动化 |
| 12 | test-master | 1.082 | 测试 |
| 13 | aws | 1.094 | 云服务 |
| 14 | azure-infra | 1.089 | 云服务 |
| 15 | game-cog | 1.102 | 游戏开发 |
| 16 | clawbrowser | 1.062 | 浏览器 |
| 17 | data-analysis | 1.070 | 数据科学 |
| 18 | gcloud | 1.063 | 云服务 |
| 19 | android | 1.019 | 移动开发 |
| 20 | midscene-android-automation | 1.009 | 移动测试 |
| 21 | mobile | 0.995 | 移动开发 |
| 22 | senior-ml-engineer | 0.973 | ML |
| 23 | senior-data-scientist | 0.958 | 数据科学 |
| 24 | ios | 0.977 | iOS 开发 |
| 25 | data-cog | 0.951 | 数据科学 |
| 26 | time-series-analysis | 0.950 | 数据分析 |
| 27 | analyst | 0.949 | 商业分析 |
| 28 | jenkins | 0.948 | CI/CD |
| 29 | senior-backend | 0.948 | 后端 |
| 30 | mlops | 0.883 | MLOps |

---

## 🔍 六、趋势分析

### 6.1 游戏开发领域趋势

1. **game-cog** 持续霸榜，DeepResearch Bench 第一名
2. **Unity 6** 和 **Godot 4** 成为主流开发引擎
3. 移动端 3D 游戏开发需求上升
4. AI 辅助游戏开发成为热点
5. Unity AI Workflow 2026 新增专属工作流

### 6.2 Python 开发趋势

1. **FastAPI** 评分 1.108，异步高性能 API 首选
2. **uv** 成为最快包管理器
3. 类型安全日益重要 (mypy/pyright)
4. Temporal 工作流成为分布式事务新标准

### 6.3 测试自动化趋势

1. **android-adb** 评分最高 (1.220)，游戏客户端测试需求旺盛
2. **Playwright** 全面崛起，评分 1.096
3. **AI 驱动测试** 成为新趋势 (midscene 系列)
4. 移动端跨平台测试 (Appium) 持续热门

### 6.4 开发者工具趋势

1. **Docker** 评分霸榜，前 5 名全是 Docker 相关
2. 云服务 Skills 稳定需求 (AWS/Azure/GCP)
3. **GitHub Actions** 自动化成为 CI/CD 主流
4. 浏览器自动化 Playwright 一枝独秀

---

## 📝 七、总结与建议

### 7.1 重点推荐 Skills

| 方向 | 推荐 Skill | 评分 | 理由 |
|------|-----------|------|------|
| 游戏开发 | game-cog | 1.102 | 评分最高，DeepResearch 第一名 |
| Unity 开发 | openclaw-unity-skill | 1.013 | 完整工作流，跨平台支持 |
| Python API | fastapi | 1.108 | 异步高性能 |
| 移动测试 | android-adb | 1.220 | 评分最高，游戏测试必备 |
| Web 自动化 | playwright | 1.096 | 多功能集成 |
| 容器化 | docker-essentials | 3.694 | DevOps 基础，评分最高 |

### 7.2 学习路径建议

```
游戏开发方向:
  入门: unity → godot-dev-guide
  进阶: game-cog → game-engine
  测试: android-adb → midscene-android-automation

Python 开发方向:
  入门: python → fastapi
  进阶: django → senior-backend
  测试: test-patterns → e2e-testing-patterns

DevOps 方向:
  入门: docker-essentials → docker-compose
  进阶: aws-infra → infra-as-code
  CI/CD: gh-action-gen → jenkins
```

### 7.3 本周更新亮点

1. **Unity AI Workflow 2026** - 专为 Claude Code 设计的 Unity 开发工作流
2. **midscene 系列** - AI 驱动的移动端自动化测试
3. **game-cog** 持续领跑游戏开发 Skills
4. **FastAPI** 成为 Python Web 开发首选

---

*文档更新于 2026-03-04 基于 ClawHub 实时搜索数据*
