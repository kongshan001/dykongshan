# Unity AI Workflow 2026

> 专为 Claude Code 和 Google Antigravity IDE 设计的 Unity 6.2+ AI 开发工作流

## 项目信息

- **项目地址**: [David-GD13/unity-ai-workflow](https://github.com/David-GD13/unity-ai-workflow)
- **GitHub Stars**: ⭐ 4
- **技能类别**: 游戏客户端开发 / Unity
- **状态**: ✅ 已调研

---

## 核心特性

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

---

## 项目阶段

1. 00: Ideation — 从想法到 GDD + GFD
2. 01: Pre-Production — 技术选型、栈定义、命名规范
3. 02: Technical Design — 架构、程序集定义、模式
4. 03: Project Setup — 自动文件夹脚手架和包安装

---

## 评分

- **综合评分**: ⭐⭐⭐⭐
- **推荐指数**: ⭐⭐⭐⭐⭐

---

## 替代方案

| 技能 | 特点 |
|------|------|
| cc-plugin-unity-gamedev | 21 个专业 Unity 技能 |
| OH-Unity-GameDev-Skills | Unity + DoTween + MediaPipe |
| unity-developer | Unity 6 LTS 专家 |

---

## 安装方式

```bash
# 通过 ClawHub 安装
clawhub install David-GD13/unity-ai-workflow

# 或手动克隆
git clone https://github.com/David-GD13/unity-ai-workflow ~/.claude/skills/
```
