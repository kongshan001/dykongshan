# Claude Code Skills 补充调研报告 - 2026年3月 (Week 35)

**调研日期**: 2026-03-04  
**技能来源**: ClawHub 实时搜索 + Antigravity Awesome Skills (968+ Skills) + GitHub 热门仓库  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 新增调研

---

## 📊 调研概要

本次调研继续聚焦 Claude Code 热门 Skills，基于 ClawHub 实时搜索排行榜和 Antigravity Awesome Skills 仓库，覆盖以下方向：

1. **游戏客户端开发** (Unity/Godot/Unreal/游戏引擎)
2. **Python 开发** (FastAPI/异步/类型安全/测试)
3. **游戏客户端自动化测试** (移动端/UI 自动化/E2E)
4. **开发者工具** (Docker/GitHub/CI/CD)

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 ClawHub Top 游戏开发 Skills

| Skill 名称 | 评分 | 描述 |
|-----------|------|------|
| game-cog | 1.132 | 游戏开发认知架构 |
| game-developer-skill | 0.976 | Claude Game Developer 专业开发 |
| fivem-dev | 0.958 | Fivem 模组开发 |
| game-engine | 0.921 | 通用游戏引擎 |
| godot-gdscript-patterns | - | Godot 4 GDScript 最佳实践 |
| unity-developer | - | Unity 6 LTS 专业开发 |
| unity-ecs-patterns | - | Unity ECS + DOTS 高性能架构 |
| unreal-engine-cpp-pro | - | Unreal Engine 5.x C++ 开发 |

### 1.2 核心游戏开发 Skills 详解

#### game-cog (评分: 1.132) 🆕 新增
**分类**: 游戏开发 / 认知架构  
**来源**: ClawHub 搜索

**核心功能**:
- 游戏开发思维模型
- 架构决策框架
- 游戏循环与状态管理
- 渲染管线理解

**适用场景**:
- 游戏原型设计
- 技术选型决策
- 团队技术沟通

#### game-developer-skill (评分: 0.976)
**分类**: Unity 开发  
**来源**: ClawHub 搜索

**核心功能**:
- Unity C# 脚本开发
- URP/HDRP 渲染管线
- 跨平台部署
- 性能优化

**适用场景**:
- 商业游戏开发
- Unity 项目维护

### 1.3 Antigravity 游戏开发 Skills

| Skill | 描述 | 分类 |
|-------|------|------|
| game-development | 游戏开发编排器，路由到平台特定 Skills | 编排 |
| 2d-games | 2D 游戏开发原理（精灵、瓦片地图、物理） | 原理 |
| 3d-games | 3D 游戏开发原理（渲染、着色器、物理） | 原理 |
| mobile-games | 移动游戏开发（触控输入、电池优化） | 平台 |
| pc-games | PC/主机游戏开发 | 平台 |
| web-games | Web 游戏开发（WebGPU、PWA） | 平台 |
| game-art | 游戏美术原理 | 美术 |
| game-audio | 游戏音频设计 | 音频 |
| game-design | 游戏设计原理（GDD、平衡性、玩家心理） | 设计 |
| unity-developer | Unity 6 LTS + URP/HDRP | 引擎 |
| unity-ecs-patterns | ECS + DOTS 高性能架构 | 架构 |
| godot-gdscript-patterns | Godot 4 GDScript 最佳实践 | 引擎 |
| godot-4-migration | Godot 3→4 迁移指南 | 迁移 |
| unreal-engine-cpp-pro | Unreal Engine 5.x C++ 开发 | 引擎 |
| multiplayer | 多人游戏开发（网络架构、同步） | 网络 |
| vr-ar | VR/AR 游戏开发 | 平台 |

### 1.4 2D Games Skill 详解

**来源**: Antigravity Awesome Skills

**核心内容**:

#### 精灵系统 (Sprite Systems)
- **Atlas**: 合并纹理，减少 draw calls
- **Animation**: 帧序列动画
- **Pivot**: 旋转/缩放原点
- **Layering**: Z 轴顺序控制

#### 瓦片地图设计 (Tilemap Design)
| 因素 | 推荐 |
|------|------|
| Size | 16x16, 32x32, 64x64 |
| Auto-tiling | 用于地形 |
| Collision | 简化碰撞形状 |

#### 2D 物理引擎
- Box: 矩形物体
- Circle: 球类、圆形
- Capsule: 角色
- Polygon: 复杂形状

#### 相机系统
- Follow: 追踪玩家
- Look-ahead: 预判移动方向
- Multi-target: 双人游戏
- Room-based: 类银河恶魔城

### 1.5 游戏开发 Skills 缺口分析

**已覆盖**:
- ✅ Unity/Godot/Unreal 主流引擎
- ✅ ECS/DOTS 架构
- ✅ 2D/3D/移动/Web 多平台
- ✅ 游戏音频/美术/设计

**需要补充**:
- ⚠️ 游戏测试自动化（专门针对游戏客户端）
- ⚠️ 游戏客户端性能分析
- ⚠️ 游戏网络同步（帧同步/状态同步）
- ⚠️ 游戏 AI 行为树

---

## 🐍 二、Python 开发 Skills

### 2.1 ClawHub Top Python Skills

| Skill 名称 | 评分 | 描述 |
|-----------|------|------|
| fastapi | 1.121 | 高性能 API |
| python | 0.986 | Python 基础 |
| django | 0.960 | Django 框架 |
| uv-global | 1.092 | 包管理器 |
| async-python-patterns | - | 异步编程模式 |
| python-testing-patterns | - | pytest 测试模式 |

### 2.2 Python 开发 Skills 详解

#### async-python-patterns 🆕 新增
**分类**: Python 异步编程  
**来源**: Antigravity Awesome Skills

**核心功能**:
- asyncio 异步编程
- 并发编程模式
- async/await 最佳实践

**适用场景**:
- 构建异步 Web APIs (FastAPI, aiohttp, Sanic)
- 实现并发 I/O 操作
- 开发实时应用 (WebSocket 服务器)
- 处理多个独立任务

#### python-testing-patterns 🆕 新增
**分类**: Python 测试  
**来源**: Antigravity Awesome Skills

**核心功能**:
- pytest 测试框架
- Fixtures 和 mocking
- 测试驱动开发 (TDD)
- 参数化测试
- 属性测试

**适用场景**:
- 编写 Python 单元测试
- 设置测试基础设施
- API 集成测试
- 异步代码测试

### 2.3 Antigravity Python Skills 全景

| Skill | 描述 | 分类 |
|-------|------|------|
| python-pro | Python 专业开发 | 基础 |
| async-python-patterns | 异步编程模式 | 进阶 |
| python-testing-patterns | pytest 测试最佳实践 | 测试 |
| fastapi-pro | FastAPI Pro 高性能 API | 框架 |
| django-pro | Django Pro 企业级框架 | 框架 |
| python-patterns | Python 设计模式 | 进阶 |
| python-performance-optimization | 性能优化 | 进阶 |
| python-packaging | 包发布管理 | 工程化 |
| python-development-python-scaffold | 项目脚手架 | 工程化 |

### 2.4 Python 开发 Skills 缺口分析

**已覆盖**:
- ✅ FastAPI/Django 主流框架
- ✅ 异步编程
- ✅ 测试最佳实践
- ✅ 性能优化

**需要补充**:
- ⚠️ 专门的游戏服务器 Python 开发
- ⚠️ 数据科学/机器学习工程化
- ⚠️ Python 类型安全严格模式

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 ClawHub Top 测试 Skills

| Skill 名称 | 评分 | 描述 |
|-----------|------|------|
| playwright | 1.089 | E2E 测试框架 |
| playwright-skill | 1.050 | Playwright 专业技能 |
| e2e-testing | - | 端到端测试 |
| browser-automation | - | 浏览器自动化 |

### 3.2 测试自动化 Skills 详解

#### playwright (评分: 1.089)
**分类**: E2E 测试  
**来源**: ClawHub 搜索

**核心功能**:
- Web 应用端到端测试
- 跨浏览器测试
- 移动端模拟
- API 测试

**GitHub 热门**:
- lackeyjb/playwright-skill ⭐ 1850
- akaihola/playwright-py-skill ⭐ 1

#### e2e-testing-patterns 🆕 新增
**分类**: E2E 测试  
**来源**: Antigravity Awesome Skills

**核心功能**:
- 端到端测试最佳实践
- 测试金字塔策略
- 页面对象模型
- 测试数据管理

### 3.3 移动端测试 Skills

| Skill | 描述 | 平台 |
|-------|------|------|
| mobile-developer | 移动应用开发 | iOS/Android |
| android-jetpack-compose-expert | Android Jetpack Compose | Android |
| ios-developer | iOS 开发 | iOS |
| mobile-security-coder | 移动安全编码 | 通用 |

### 3.4 游戏客户端测试 Skills 缺口分析

**已覆盖**:
- ✅ Playwright Web E2E 测试
- ✅ 浏览器自动化
- ✅ 移动端开发测试

**需要补充**:
- ⚠️ 游戏客户端专门测试 (Unity/Unreal 自动化)
- ⚠️ 游戏性能基准测试
- ⚠️ 游戏网络同步测试
- ⚠️ 游戏渲染/图形测试
- ⚠️ 游戏控制器/输入设备测试

---

## 🛠️ 四、开发者工具 Skills

### 4.1 ClawHub Top 开发者工具 Skills

| Skill 名称 | 评分 | 描述 |
|-----------|------|------|
| docker | 1.078 | 容器化 |
| github-actions | 1.045 | CI/CD |
| git-essentials | - | Git 基础 |
| docker-essentials | - | Docker 基础 |

### 4.2 开发者工具 Skills 详解

#### docker-essentials 🆕 新增
**分类**: 容器化  
**来源**: cc_skills_repo

**核心功能**:
- Docker 基础命令
- Dockerfile 最佳实践
- Docker Compose
- 镜像优化

#### git-essentials 🆕 新增
**分类**: 版本控制  
**来源**: cc_skills_repo

**核心功能**:
- Git 基础工作流
- 分支管理策略
- 代码审查
- 冲突解决

### 4.3 自动化工作流 Skills

| Skill | 描述 | 分类 |
|-------|------|------|
| github-automation | GitHub 自动化 | CI/CD |
| github-workflow-automation | 工作流自动化 | CI/CD |
| circleci-automation | CircleCI 自动化 | CI/CD |
| gitlab-automation | GitLab 自动化 | CI/CD |
| cicd-automation-workflow-automate | CI/CD 编排 | CI/CD |

---

## 📈 五、GitHub 热门 Skills 搜索

### 5.1 游戏开发相关

| 仓库 | ⭐ | 描述 |
|------|-----|------|
| Donchitos/Claude-Code-Game-Studios | 28 | 游戏工作室 Claude Code 集成 |
| OstrichHermit/OH-Unity-GameDev-Skills | 6 | Unity 游戏开发 Skills |
| solanabr/solana-game-skill | 5 | Solana 游戏技能 |
| David-GD13/unity-ai-workflow | 4 | Unity AI 工作流 |

### 5.2 Python 开发相关

| 仓库 | ⭐ | 描述 |
|------|-----|------|
| Mng-dev-ai/claudex | 223 | Python AI 开发工具包 |
| existential-birds/beagle | 34 | Beagle Python 技能 |
| Ashfaqbs/software-dev-ai-claude-toolkit | 8 | 软件开发工具包 |

### 5.3 测试自动化相关

| 仓库 | ⭐ | 描述 |
|------|-----|------|
| lackeyjb/playwright-skill | 1850 | Playwright 测试技能 ⭐ Top |
| Interstellar-code/claud-skills | 12 | Claude 测试技能 |
| dalbit-mir/playwright-undetected-skill | 4 | Playwright 反检测技能 |
| akaihola/playwright-py-skill | 1 | Playwright Python 技能 |

---

## 📊 六、Skills 评分排行榜 (Week 35)

### 6.1 综合 Top 15

| 排名 | Skill | 评分 | 分类 |
|------|-------|------|------|
| 1 | compound-engineering | 1.245 | 复合工程 |
| 2 | game-cog | 1.132 | 游戏开发 |
| 3 | uv-global | 1.092 | Python 工具 |
| 4 | playwright | 1.089 | 测试 |
| 5 | docker | 1.078 | 开发者工具 |
| 6 | fastapi | 1.121 | Python 框架 |
| 7 | openclaw-unity-skill | 1.013 | 游戏开发 |
| 8 | get-shit-done | 0.998 | 工作流 |
| 9 | python | 0.986 | Python 基础 |
| 10 | game-developer-skill | 0.976 | 游戏开发 |
| 11 | superpowers | 0.970 | 工作流 |
| 12 | agentsys | 0.965 | 编排 |
| 13 | django | 0.960 | Python 框架 |
| 14 | fivem-dev | 0.958 | 游戏开发 |
| 15 | game-engine | 0.921 | 游戏开发 |

### 6.2 游戏开发分类 Top 5

| 排名 | Skill | 评分 |
|------|-------|------|
| 1 | game-cog | 1.132 |
| 2 | openclaw-unity-skill | 1.013 |
| 3 | game-developer-skill | 0.976 |
| 4 | fivem-dev | 0.958 |
| 5 | game-engine | 0.921分类 Top 5 |

### 6.3 Python 开发

| 排名 | Skill | 评分 |
|------| 1 | fastapi | |-------|------|
1.121 |
| 2 | uv-global | 1.092 |
| 3 |.986 |
| | 0. python | 0 4 | django960 |
| 5 | async-python-patterns | - 🎯 七、Skills |

---

##建议

###  缺口与7.1 急需补充的 Skills

| 优先级 | Skill 方向 | 描述 ||------|
| 建议 |
|--------|------------|------ 🔴 高 | 游戏客户端测试 | Unity/Unreal 自动化测试 | 从现有 Web 测试 Skills 扩展 |
| 🔴 高 | 游戏网络同步 | 帧同步/状态同步测试 | 新建专题 Skill |
| 🟡 中 | Python 类型安全 | mypy/pyright 严格模式 | 扩展现有 python-type-safety |
| 🟡 中 | 游戏性能分析 | 帧率/内存/渲染优化 | 新建专题 Skill |
| 🟢 低 | 游戏 AI 行为树 | NPC/AI 系统开发 | 社区贡献 |

### 7.2 Skills 建设建议

1. **游戏测试自动化**: 从 Playwright/Selenium 扩展到游戏引擎
2. **Python 工程化**: 补充类型安全、架构模式
3. **开发者工具**: 加强 Docker/K8s 集成
4. **持续更新**: 每周跟进 ClawHub 排行榜变化

---

## 📚 八、参考资料

- [ClawHub Skills 搜索](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/antgravity/awesome-claude-code) (968+ Skills)
- [cc_skills_repo](https://github.com/kongshan001/cc_skills)
- [skills.sh 官方](https://skills.sh)

---

**下次调研**: Week 36 将关注新兴 Skills 和社区贡献趋势

---

*文档创建时间: 2026-03-04 13:59 UTC+8*
*持续更新: https://github.com/kongshan001/cc_skills*
