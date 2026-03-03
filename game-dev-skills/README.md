# game-dev-skills - 游戏客户端开发 Skills

> 主流游戏引擎开发实战指南

## 📋 文档信息

- **Skill 类别**: 游戏客户端开发
- **来源**: Antigravity Awesome Skills (968+ Skills)
- **定位**: 游戏引擎开发全覆盖
- **状态**: ✅ 已调研

---

## 1. Skill 背景需求

### 问题痛点

- 游戏开发涉及多个引擎（Unity、Godot、Unreal），各有一套开发范式
- 客户端性能优化是游戏开发的核心挑战
- 跨平台部署需要了解各平台特性
- 游戏架构设计（ECS、状态机、对象池）需要专业指导

### 目标

提供覆盖主流游戏引擎的完整开发工作流，包括架构设计、性能优化、跨平台部署等。

---

## 2. 核心 Skills 概览

| Skill 名称 | 引擎 | 核心能力 | 评分 |
|-----------|------|---------|------|
| unity-developer | Unity 6 LTS | C# 优化、URP/HDRP、ECS、DOTS、跨平台 | ⭐⭐⭐⭐⭐ |
| godot-gdscript-patterns | Godot 4 | GDScript 2.0、信号、状态机、优化 | ⭐⭐⭐⭐ |
| unreal-engine-cpp-pro | Unreal 5.x | C++ 开发、UObject、性能模式 | ⭐⭐⭐⭐⭐ |
| unity-ecs-patterns | Unity DOTS | ECS 架构、Jobs、Burst 编译 | ⭐⭐⭐⭐ |
| 2d-games | 通用 | 精灵、瓦片地图、物理、相机 | ⭐⭐⭐ |
| 3d-games | 通用 | 渲染、着色器、物理、相机 | ⭐⭐⭐ |

---

## 3. Unity Developer 详解

### 3.1 核心能力

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

### 3.2 适用场景

- ✅ 构建 Unity 6 LTS 游戏项目
- ✅ 性能优化和跨平台部署
- ✅ ECS/DOTS 架构设计
- ✅ 自定义渲染效果
- ✅ Unity Netcode 多人游戏

### 3.3 典型交互

```
"Architect a multiplayer game with Unity Netcode and dedicated servers"
"Optimize mobile game performance using URP and LOD systems"
"Create a custom shader with Shader Graph for stylized rendering"
"Implement ECS architecture for high-performance gameplay systems"
```

---

## 4. Godot GDScript Patterns 详解

### 4.1 核心能力

```markdown
### GDScript 2.0 特性
- 改进的类型推断
- @export 注解
- await/awaited signals
- 更好的性能

### 核心模式
- Signal 信号系统
- Scene 场景管理
- State Machine 状态机
- 对象池和优化
```

### 4.2 适用场景

- ✅ 2D/3D 游戏开发
- ✅ 开源引擎项目
- ✅ 轻量级游戏原型
- ✅ Godot 3→4 迁移

---

## 5. Unreal Engine C++ Pro 详解

### 5.1 核心能力

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

### 5.2 适用场景

- ✅ AAA 游戏开发
- ✅ 高度定制化引擎功能
- ✅ 大型多人游戏
- ✅ 虚拟制作

---

## 6. 通用游戏开发 Skills

### 6.1 2D Games

```markdown
## 精灵系统
- Atlas: 合并纹理，减少绘制调用
- Animation: 帧序列动画
- Pivot: 旋转/缩放原点
- Layering: Z 轴顺序控制

## 瓦片地图设计
- 尺寸: 16x16, 32x32, 64x64
- Auto-tiling: 地形自动匹配
- Collision: 简化碰撞形状

## 2D 物理
- Box: 矩形物体
- Circle: 球形/圆润
- Capsule: 角色
- Polygon: 复杂形状

## 相机系统
- Follow: 跟踪玩家
- Look-ahead: 预判移动
- Multi-target: 双人模式
- Room-based: 类银河战士
```

### 6.2 3D Games

```markdown
## 渲染技术
- PBR 材质工作流
- 光照和阴影优化
- 后处理效果

## 物理系统
- 刚体和碰撞检测
- 布料模拟
- 车辆物理

## 相机控制
- 第三人称跟随
- 第一人称
- 电影级运镜
```

---

## 7. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **全引擎覆盖** | Unity、Godot、Unreal 全面覆盖 |
| **现代特性** | 紧跟各引擎最新版本 (Unity 6 LTS, Godot 4, UE5) |
| **性能优化** | 包含 Profiler、ECS、DOTS 等高级优化内容 |
| **跨平台** | 涵盖移动端、主机、WebGL、VR/AR |
| **架构模式** | 提供 ECS、状态机、对象池等设计模式 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **学习曲线** | 每个引擎都有独特范式，需要时间适应 |
| **文档分散** | 部分 Skills 依赖外部 implementation-playbook.md |
| **版本兼容性** | 引擎版本更新可能导致 API 变化 |

---

## 8. 平替对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| **unity-developer** | Unity 6 全面指南 | Unity 项目开发 |
| **godot-gdscript-patterns** | Godot 4 最佳实践 | 开源/轻量游戏 |
| **unreal-engine-cpp-pro** | UE5 C++ 开发 | AAA 级游戏 |
| **Unity 官方文档** | 权威但分散 | 深入特定功能 |
| **Game Programming Patterns** | 经典设计模式 | 架构学习 |

---

## 9. 落地过程

### 9.1 快速开始

```bash
# 安装 Skills
npx antigravity-awesome-skills --claude

# 使用 Unity 开发
>> /unity-developer 帮助我设计一个多人游戏架构

# 使用 Godot 开发
>> /godot-gdscript-patterns 创建状态机系统
```

### 9.2 推荐学习路径

```
1. 基础: 2d-games / 3d-games (通用原理)
2. 引擎选择:
   - Unity → unity-developer → unity-ecs-patterns
   - Godot → godot-gdscript-patterns
   - Unreal → unreal-engine-cpp-pro
3. 进阶: 性能优化 → 跨平台部署
```

### 9.3 项目实践

对于 game-frame-sync 项目：
- 使用 `unity-developer` 优化帧同步网络同步
- 参考 `multiplayer` 设计延迟补偿
- 参考 `performance-optimization` 优化客户端性能

---

## 10. Multiplayer 游戏开发专题

### 10.1 架构选择

| 架构 | 延迟 | 成本 | 安全性 |
|------|------|------|--------|
| **专属服务器** | 低 | 高 | 强 |
| **P2P** | 变化 | 低 | 弱 |
| **主机模式** | 中 | 低 | 中 |

### 10.2 同步原理

| 方案 | 同步内容 | 适用场景 |
|------|---------|---------|
| **状态同步** | 游戏状态 | 简单，物体少 |
| **输入同步** | 玩家输入 | 动作游戏 |
| **混合** | 两者结合 | 大多数游戏 |

### 10.3 延迟补偿技术

| 技术 | 用途 |
|------|------|
| **预测** | 客户端预测服务器 |
| **插值** | 平滑远程玩家 |
| **调解** | 修正错误预测 |
| **延迟补偿** | 回滚用于命中检测 |

### 10.4 网络安全原则

```
客户端: "我击中了敌人"
服务器: 验证 → 投射物真的命中了?
       → 玩家状态是否有效?
       → 时间是否可能?
```

### 10.5 反作弊

| 作弊方式 | 防御方法 |
|---------|---------|
| 速度作弊 | 服务器验证移动 |
| 自瞄 | 服务器验证视线 |
| 物品复制 | 服务器拥有库存 |
| 穿墙 | 不发送隐藏数据 |

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Unity 官方文档](https://docs.unity.com/)
- [Godot 文档](https://docs.godotengine.org/)
- [Unreal Engine 文档](https://docs.unrealengine.com/)
