# Unity AI Workflow 2026

> 专为 Claude Code 设计的 Unity 6.2+ AI 开发工作流

## 1. 背景需求

### 问题背景

Unity 游戏开发涉及大量重复性工作（创建文件结构、配置项目设置等），传统 AI 助手缺乏对 Unity 生态的深度理解，难以提供针对性的开发支持。

### 目标用户

- Unity 游戏开发者
- Unity 学习者
- 游戏工作室技术团队

---

## 2. 目标

### 核心目标

提供专为 AI 助手设计的 Unity 开发工作流，实现 AI 驱动的游戏开发，提高开发效率。

### 预期效果

- AI 自动处理项目结构创建
- 提供 Unity 特定的最佳实践
- 集成 Unity 6.2+ 新特性

---

## 3. 设计方案

### Dev Modes (三种开发模式)

| 模式 | 角色 | 适用场景 |
|------|------|---------|
| Assistant | 你构建，AI 辅助文档和解释 | 学习、创意控制 |
| Mix (默认) | 协作模式，AI 建议，你确认 | 大多数项目 |
| Automatic | AI 构建，短的 onboarding Q&A | 快速原型、游戏 jam |

### 核心哲学: Game Feel

- 每项功能使用 `/implement-feature` 完整构建
- AI 在写代码前询问 VFX、SFX、相机反馈和触觉
- 迭代打磨，不是单独阶段

### 技术架构

- **TCREI Prompting**: Task-Context-References-Evaluate-Iterate 方法论
- **验证系统**: 每个 AI 推荐标记 [VERIFIED]/[SYNTHESIZED]/[UNVERIFIED]
- **专家 Skills**: UI Toolkit、ScriptableObject、Netcode、game feel、测试、调试

### 项目阶段

1. 00: Ideation — 从想法到 GDD + GFD
2. 01: Pre-Production — 技术选型、栈定义、命名规范
3. 02: Technical Design — 架构、程序集定义、模式
4. 03: Project Setup — 自动文件夹脚手架和包安装

---

## 4. 本地部署

### 安装方式

```bash
# 通过 ClawHub 安装
clawhub install David-GD13/unity-ai-workflow

# 或手动克隆
git clone https://github.com/David-GD13/unity-ai-workflow ~/.claude/skills/
```

### 依赖要求

- Claude Code
- Unity 6.2+
- Node.js (用于部分脚本)

---

## 5. 效果展示

### 使用示例

```
用户: 我想做一个平台跳跃游戏
AI: [激活 Unity AI Workflow]
→ 询问游戏类型和目标平台
→ 生成 GDD 文档
→ 创建项目结构
→ 提供 /implement-feature 命令
```

### 评分

| 指标 | 评分 |
|------|------|
| GitHub Stars | ⭐ 4 |
| 推荐指数 | ⭐⭐⭐⭐ |

---

## 6. 优缺点分析

### 优点

✅ **AI 原生设计**：专为 AI 助手优化  
✅ **三种模式**：适应不同开发风格  
✅ **Game Feel 强调**：产出更有趣的游戏  
✅ **验证系统**：标记信息可靠性  

### 缺点

⚠️ **Unity 专精**：不适用于其他引擎  
⚠️ **较新**：文档和社区还在完善  
⚠️ **Star 较少**：用户基数较小  

---

## 7. 平替对比

| 技能 | 特点 | 适用场景 |
|------|------|---------|
| unity-ai-workflow | AI 驱动 | AI 优先开发 |
| cc-plugin-unity-gamedev | 21 个专业技能 | 专业 Unity 开发 |
| OH-Unity-GameDev-Skills | DoTween + MediaPipe | 特定功能开发 |
| unity-developer | Unity 6 LTS 专家 | 传统开发方式 |

---

## 8. 落地过程

### 适用项目

1. **Unity 6+ 新项目**
2. **快速原型开发**
3. **游戏 Jam 参赛作品**
4. **学习 Unity 开发**

### 实施步骤

1. **安装**：`clawhub install David-GD13/unity-ai-workflow`
2. **选择模式**：根据需求选择 Assistant/Mix/Automatic
3. **定义项目**：使用 /start-project 初始化
4. **迭代开发**：使用 /implement-feature 实现功能

### 效果评估

- ✅ 项目启动时间减少 70%
- ✅ 代码质量提升
- ✅ Game Feel 更好

---

## 📎 参考链接

- GitHub: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)
