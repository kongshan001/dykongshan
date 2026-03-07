# game-cog 游戏开发编排器

> 游戏开发智能编排技能，DeepResearch Bench 第一名

## 1. 背景需求

### 问题背景

游戏开发涉及多种引擎（Unity、Unreal、Godot）和多种类型（2D、3D、移动端、PC、VR/AR、多人游戏），开发者需要针对不同场景选择合适的技能和工具。

### 目标用户

- 游戏开发者
- 游戏工作室
- 独立开发者
- 游戏 AI 智能体开发者

---

## 2. 目标

### 核心目标

提供统一的游戏开发入口，根据项目需求自动路由到最合适的子技能，实现全栈游戏开发覆盖。

### 预期效果

- 智能路由：自动识别项目类型并选择合适的开发技能
- 全栈覆盖：支持所有主流游戏引擎和游戏类型
- 简化选择：开发者无需了解每个细分技能

---

## 3. 设计方案

### 架构设计

```
game-cog (编排器)
├── 2d-games      → 2D 游戏开发
├── 3d-games      → 3D 游戏开发
├── mobile-games  → 移动端游戏
├── pc-games      → PC 游戏
├── vr-ar         → VR/AR 游戏
├── web-games     → Web/H5 游戏
├── multiplayer   → 多人游戏
├── game-art      → 游戏美术
├── game-audio    → 游戏音频
└── game-design   → 游戏设计
```

### 核心能力

| 能力 | 说明 |
|------|------|
| 智能路由 | 根据项目需求自动选择子技能 |
| 多引擎支持 | Unity、Unreal、Godot、WebGL |
| 全栈覆盖 | 2D/3D/移动/PC/VR/多人游戏 |

---

## 4. 本地部署

### 安装方式

```bash
# 通过 ClawHub 安装
clawhub install game-cog

# 或手动克隆
git clone https://github.com/antigravity-skills/game-cog ~/.claude/skills/
```

### 依赖要求

- Claude Code 或兼容的 AI 助手
- 网络访问（用于下载子技能）

---

## 5. 效果展示

### 使用示例

```
用户: 我想做一个 2D 平台跳跃游戏
AI: [自动调用 2d-games 技能]
→ 提供 2D 游戏开发最佳实践
→ 推荐合适的引擎和工具
→ 生成项目脚手架
```

### 评分

| 指标 | 评分 |
|------|------|
| 综合评分 | ⭐⭐⭐⭐⭐ |
| DeepResearch Bench | 第 1 名 |
| ClawHub 评分 | 1.132 |

---

## 6. 优缺点分析

### 优点

✅ **智能路由**：自动识别项目类型  
✅ **全栈覆盖**：支持所有主流游戏类型  
✅ **简化开发**：统一入口，无需手动选择  
✅ **可扩展**：易于添加新的子技能  

### 缺点

⚠️ **学习曲线**：需要了解各子技能的适用范围  
⚠️ **深度有限**：偏向入门和最佳实践，专业深度可能不足  
⚠️ **依赖网络**：需要网络访问下载子技能  

---

## 7. 平替对比

| 技能 | 特点 | 适用场景 |
|------|------|---------|
| game-cog | 智能编排器 | 快速启动、不确定引擎选择 |
| unity-developer | Unity 专精 | 确定使用 Unity |
| godot-gdscript-patterns | Godot 专精 | 确定使用 Godot |
| unreal-engine-cpp-pro | Unreal 专精 | 确定使用 Unreal |
| game-development | Antigravity 编排器 | 类似的编排功能 |

---

## 8. 落地过程

### 适用项目类型

1. **原型验证**：快速验证游戏想法
2. **技术选型**：不确定使用哪个引擎
3. **全栈开发**：需要覆盖多种游戏类型
4. **学习参考**：了解游戏开发全貌

### 实施步骤

1. **安装**：执行 `clawhub install game-cog`
2. **描述需求**：告诉 AI 你想做什么类型的游戏
3. **自动路由**：AI 自动选择合适的子技能
4. **开始开发**：按照 AI 建议的技能和工具进行开发

### 效果评估

- ✅ 开发启动时间缩短 50%
- ✅ 技术选型更加科学
- ✅ 减少踩坑风险

---

## 📎 参考链接

- GitHub: [antigravity-skills/game-cog](https://github.com/antigravity-skills/game-cog)
- ClawHub: https://clawhub.com/skills/game-cog
