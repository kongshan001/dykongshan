# claude-code-game-studios 游戏开发工作室

> 将单个 Claude Code 会话转变为完整的游戏开发工作室

## 1. 背景需求

独立使用 AI 构建游戏很强大，但单个聊天会话缺乏结构。没有人阻止你硬编码魔法数字、跳过设计文档或编写意大利面条式代码。没有 QA 通行证、没有设计审查、没有人问"这真的符合游戏的愿景吗？"

Claude Code Game Studios 通过为你的 AI 会话提供真实工作室的结构来解决这个问题。

## 2. 目标

实现 48 个专门代理 + 36 个工作流技能的完整游戏开发工作室。

## 3. 设计方案

### 3.1 工作室层级

**Tier 1 - 总监 (Opus)**
- creative-director (创意总监)
- technical-director (技术总监)
- producer (制作人)

**Tier 2 - 部门主管 (Sonnet)**
- game-designer (游戏设计师)
- lead-programmer (首席程序员)
- art-director (美术总监)
- audio-director (音频总监)
- narrative-director (叙事总监)
- qa-lead (QA 主管)
- release-manager (发布经理)
- localization-lead (本地化主管)

**Tier 3 - 专家 (Sonnet/Haiku)**
- gameplay-programmer (游戏玩法程序员)
- engine-programmer (引擎程序员)
- ai-programmer (AI 程序员)
- network-programmer (网络程序员)
- tools-programmer (工具程序员)
- ui-programmer (UI 程序员)
- systems-designer (系统设计师)
- level-designer (关卡设计师)
- economy-designer (经济设计师)
- technical-artist (技术美术)
- sound-designer (音效设计师)
- writer (编剧)
- world-builder (世界构建师)
- ux-designer (UX 设计师)
- prototyper (原型师)
- performance-analyst (性能分析师)
- devops-engineer (DevOps 工程师)
- analytics-engineer (分析工程师)
- security-engineer (安全工程师)
- qa-tester (QA 测试员)
- accessibility-specialist (无障碍专家)
- live-ops-designer (长线运营设计师)
- community-manager (社区经理)

### 3.2 引擎支持

| 引擎 | 主代理 | 子专家 |
|------|--------|--------|
| Godot 4 | godot-specialist | GDScript, Shaders, GDExtension |
| Unity | unity-specialist | DOTS/ECS, Shaders/VFX, Addressables, UI Toolkit |
| Unreal Engine 5 | unreal-specialist | GAS, Blueprints, Replication, UMG/CommonUI |

### 3.3 36 个斜杠命令

**Reviews & Analysis**
- /design-review - 设计审查
- /code-review - 代码审查
- /balance-check - 平衡性检查
- /asset-audit - 资产审计
- /scope-check - 范围检查
- /perf-profile - 性能分析
- /tech-debt - 技术债务

**Production**
- /sprint-plan - 冲刺计划
- /milestone-review - 里程碑审查
- /estimate - 估算
- /retrospective - 回顾
- /bug-report - Bug 报告

**Project Management**
- /start - 开始
- /project-stage-detect - 项目阶段检测
- /reverse-document - 反向文档
- /gate-check - 门禁检查
- /design-systems - 系统设计

**Release**
- /release-checklist - 发布清单
- /launch-checklist - 启动清单
- /changelog - 变更日志
- /patch-notes - 补丁说明
- /hotfix - 热修复

**Creative**
- /brainstorm - 头脑风暴
- /playtest-report - 游戏测试报告
- /prototype - 原型
- /onboard - 入职
- /localize - 本地化

**Team Orchestration**
- /team-combat - 战斗团队
- /team-narrative - 叙事团队
- /team-ui - UI 团队
- /team-release - 发布团队
- /team-polish - 打磨团队
- /team-audio - 音频团队
- /team-level - 关卡团队

### 3.4 自动化钩子

| Hook | 触发器 | 功能 |
|------|--------|------|
| validate-commit.sh | git commit | 检查硬编码值、TODO 格式、JSON 有效性、设计文档章节 |
| validate-push.sh | git push | 警告推送到受保护分支 |
| validate-assets.sh | assets/ 文件写入 | 验证命名约定和 JSON 结构 |
| session-start.sh | 会话打开 | 加载冲刺上下文和最近的 git 活动 |
| detect-gaps.sh | 会话打开 | 检测新项目（建议 /start）和缺少的文档 |
| pre-compact.sh | 上下文压缩 | 保留会话进度笔记 |
| session-stop.sh | 会话关闭 | 记录成就 |
| log-agent.sh | 代理生成 | 所有子代理调用的审计跟踪 |

### 3.5 路径规则

| 路径 | 强制规则 |
|------|---------|
| src/gameplay/** | 数据驱动值、delta time 使用、无 UI 引用 |
| src/core/** | 热路径零分配、线程安全、API 稳定性 |
| src/ai/** | 性能预算、可调试性、数据驱动参数 |
| src/networking/** | 服务器权威、版本化消息、安全 |
| src/ui/** | 无游戏状态所有权、本地化就绪、无障碍 |
| design/gdd/** | 必需 8 个章节、公式格式、边缘情况 |
| tests/** | 测试命名、覆盖要求、fixture 模式 |
| prototypes/** | 宽松标准、需要 README、记录假设 |

## 4. 本地部署

```bash
# 克隆或使用模板
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game
cd my-game

# 打开 Claude Code
claude

# 运行 /start 开始
```

## 5. 效果展示

- GitHub Stars：⭐ 28
- Agents：48 个专门代理
- Skills：36 个斜杠命令
- Hooks：8 个自动化钩子
- Rules：11 个路径规则
- Templates：28 个文档模板

## 6. 优缺点

✅ 完整的工作室架构 ✅ 三层代理层级 ✅ 多引擎支持 ✅ 自动化验证  
⚠️ 学习曲线陡峭 ⚠️ 配置复杂

## 7. 平替

| 项目 | 特点 |
|------|------|
| unity-ai-workflow-2026 | 专为 AI 设计的 Unity 工作流 |
| cc-plugin-unity-gamedev | 21 个专业技能 |

## 8. 设计哲学

1. **MDA Framework** - 机制、动态、美学分析
2. **Self-Determination Theory** - 自主性、胜任感、关联感
3. **Flow State Design** - 挑战-技能平衡
4. **Bartle Player Types** - 玩家类型分析
5. **Verification-Driven Development** - 测试先行

## 9. 典型工作流

### 9.1 新项目开始

```
/start
→ 系统询问你处于哪个阶段（没有想法、模糊概念、清晰设计、现有工作）
→ 引导你到正确的工作流
→ 不做假设
```

### 9.2 头脑风暴

```
/brainstorm
→ 从头探索游戏想法
→ 创意总监代理协调
→ 生成游戏设计文档草稿
```

### 9.3 引擎设置

```
/setup-engine godot 4.6
→ 配置你的引擎
→ 加载 Godot 专门代理
→ 设置项目结构
```

### 9.4 代码审查

```
/code-review
→ 首席程序员代理审查代码
→ 检查编码标准
→ 提供改进建议
```

### 9.5 性能分析

```
/perf-profile
→ 性能分析师代理运行分析
→ 识别性能瓶颈
→ 提供优化建议
```

## 10. 协作协议

代理遵循严格的协作协议：

1. **Ask** - 代理在提出解决方案前先提问
2. **Present options** - 代理展示 2-4 个选项及优缺点
3. **You decide** - 用户总是做决定
4. **Draft** - 代理在完成前展示工作
5. **Approve** - 没有你的批准，什么都不会被写入

**你保持控制。代理提供结构和专业知识，而不是自主性。**

## 11. 自定义

这是一个模板，不是锁定的框架。一切都是为了自定义：

- 添加/删除代理 - 删除不需要的代理文件，为你的域添加新代理
- 编辑代理提示 - 调整代理行为，添加项目特定知识
- 修改技能 - 调整工作流以匹配你的团队流程
- 添加规则 - 为你的项目目录结构创建新的路径范围规则
- 调整钩子 - 调整验证严格性，添加新检查
- 选择你的引擎 - 使用 Godot、Unity 或 Unreal 代理集（或无）

---

*项目地址*: https://github.com/Donchitos/Claude-Code-Game-Studios  
*许可证*: MIT  
*更新时间*: 2026-03-04
