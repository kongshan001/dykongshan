# Claude Code Skills 调研报告 - 第十四周续 (2026年3月)

**调研日期**: 2026-03-04  
**技能来源**: ClawHub 实时搜索 + Antigravity Awesome Skills  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 本周调研概要

本周继续深入分析 Claude Code 热门 Skills，基于 ClawHub 实时搜索结果，重点覆盖：
1. 游戏客户端开发 (Unity/Godot/Unreal/移动端)
2. Python 开发 (最新工具链)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (GitHub/Docker/K8s/CI/CD)

---

## 🎮 游戏客户端开发 Skills

### Unity 相关 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| unity | Unity | Unity 游戏开发 | ⭐⭐⭐⭐⭐ (3.030) |

**核心能力**:
- Unity 6 LTS 开发
- C# 脚本编写
- URP/HDRP 渲染管线
- 跨平台部署

### Unreal 相关 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| openclaw-unreal-skill | Unreal Skill | UE 引擎操作 | ⭐⭐⭐⭐⭐ (3.376) |
| ue-log-analyzer | UE Log Analyzer | 日志分析 | ⭐⭐⭐ (0.552) |
| ue-build-package | UE Build Package | 打包构建 | ⭐⭐⭐ (0.550) |
| ue-code-search | UE Code Search | 代码搜索 | ⭐⭐⭐ (0.544) |
| ue-asset-finder | UE Asset Finder | 资产查找 | ⭐⭐⭐ (0.539) |

**OpenCLAW Unreal Skill 详解**:

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
```

### 移动端游戏开发 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| android-remote-control | Android Remote Control | 远程控制 | ⭐⭐⭐⭐⭐ (3.304) |
| android-3d-developer | Android 3D Development | 3D 开发 | ⭐⭐⭐⭐⭐ (3.270) |
| android-sms-gateway | Android SMS Gateway | SMS 网关 | ⭐⭐⭐⭐⭐ (3.209) |
| android-studio | Android Studio | Android 开发 | ⭐⭐⭐⭐⭐ (3.209) |
| android-control-2 | Android Control | 控制工具 | ⭐⭐⭐⭐⭐ (3.204) |
| mobile-appium-test | Mobile Appium Test | 移动测试 | ⭐⭐⭐⭐⭐ (3.189) |
| mobile-app-analytics | Mobile App Analytics | 应用分析 | ⭐⭐⭐⭐⭐ (3.147) |
| mobile | Mobile | 移动开发 | ⭐⭐⭐⭐⭐ (3.041) |

---

## 🧪 游戏客户端自动化测试 Skills

### 移动端测试 Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| mobile-appium-test | Mobile Appium Test | Appium 移动测试 | ⭐⭐⭐⭐⭐ (3.189) |
| android-remote-control | Android Remote Control | ADB 远程控制 | ⭐⭐⭐⭐⭐ (3.304) |
| android-adb | ADB Connection | ADB 连接 | ⭐⭐⭐⭐ (1.063) |

### Android UI 自动化测试详解

```markdown
### 🤖 ADB 命令基础
- adb devices: 列出设备
- adb shell: 执行命令
- adb install: 安装 APK
- adb logcat: 日志抓取

### 📱 UI 自动化
- uiautomator dump: UI 检查
- input tap: 触摸模拟
- input swipe: 滑动模拟
- screencap: 截图

### 🎮 游戏测试
- 触控响应延迟测试
- 陀螺仪/重力感应测试
- 内存/电量消耗监控
- 网络切换测试 (WiFi → 4G)
```

### Appium 移动测试详解

```markdown
### 📱 支持平台
- Android 5.0+
- iOS 12.0+

### 🔧 核心功能
- 元素定位
- 手势操作
- 多设备并行
- CI/CD 集成

### 🎮 游戏测试
- 游戏启动时间
- 帧率监控
- 内存泄漏检测
- 崩溃日志分析
```

---

## 🛠️ 开发者工具 Skills

### Kubernetes Skills

| Skill ID | 名称 | 核心能力 | 评分 |
|----------|------|---------|------|
| kubernetes-devops | Kubernetes DevOps | K8s 运维 | ⭐⭐⭐⭐⭐ (3.489) |
| k8-multicluster | K8 MultiCluster | 多集群管理 | ⭐⭐⭐⭐ (2.183) |
| k8s | Kubernetes | K8s 基础 | ⭐⭐⭐⭐ (2.142) |
| k8s-browser | K8s Browser | K8s 浏览器 | ⭐⭐⭐⭐ (2.140) |
| k8-autoscaling | K8 Autoscaling | 自动扩缩 | ⭐⭐⭐⭐ (2.128) |
| k8s-backup | K8s Backup | 备份恢复 | ⭐⭐⭐⭐ (2.105) |
| k8s-certs | K8s Certs | 证书管理 | ⭐⭐⭐⭐ (2.098) |
| kubectl | kubectl | 命令行工具 | ⭐⭐⭐⭐ (1.076) |
| kube-medic | kube-medic | 集群诊断 | ⭐⭐⭐ (0.889) |

### Kubernetes DevOps 详解

```markdown
### 🏗️ 集群管理
- 集群创建和配置
- 节点管理
- 命名空间隔离

### 📦 工作负载
- Deployment 管理
- StatefulSet 有状态应用
- DaemonSet 守护进程
- Job/CronJob 任务

### 🌐 网络
- Service 服务发现
- Ingress 入口控制
- NetworkPolicy 网络策略

### 📊 可观测性
- Prometheus 监控
- Grafana 可视化
- ELK 日志收集
```

---

## 📈 Skills 评分排行榜 (新增)

### 游戏开发类 Top 10

| 排名 | Skill ID | 名称 | 评分 |
|------|----------|------|------|
| 1 | the-flip-publish | The Flip Publish | 0.985 |
| 2 | clawland | Clawland | 0.957 |
| 3 | openclaw-godot-skill | Godot Skill | 0.911 |
| 4 | agent-rpg | Agent RPG | 0.810 |
| 5 | openclaw-unreal-skill | Unreal Skill | 3.376 |
| 6 | unity | Unity | 3.030 |
| 7 | mobile | Mobile | 3.041 |
| 8 | android-3d-developer | Android 3D | 3.270 |
| 9 | android-remote-control | Android Remote | 3.304 |
| 10 | mobile-appium-test | Mobile Appium | 3.189 |

### 测试类 Top 10

| 排名 | Skill ID | 名称 | 评分 |
|------|----------|------|------|
| 1 | test-runner | Test Runner | 3.639 |
| 2 | test-master | Test Master | 3.576 |
| 3 | test-patterns | Test Patterns | 3.548 |
| 4 | test-specialist | Test Specialist | 3.467 |
| 5 | skill-test | Skill Test | 3.435 |
| 6 | test-sentinel | Test Sentinel | 3.347 |
| 7 | test-case-generator | Test Case Generator | 3.336 |
| 8 | auto-test-generator | Auto Test Generator | 3.326 |
| 9 | ai-api-test | AI API Test | 3.305 |
| 10 | sovereign-test-generator | Sovereign Test | 3.286 |

### DevOps 类 Top 10

| 排名 | Skill ID | 名称 | 评分 |
|------|----------|------|------|
| 1 | github | GitHub | 3.790 |
| 2 | automation-workflows | Automation Workflows | 3.699 |
| 3 | docker-essentials | Docker Essentials | 3.694 |
| 4 | openclaw-github-assistant | GitHub Assistant | 3.615 |
| 5 | kubernetes-devops | Kubernetes DevOps | 3.489 |
| 6 | docker | Docker | 3.577 |
| 7 | github-cli | GitHub CLI | 3.501 |
| 8 | docker-sandbox | Docker Sandbox | 3.548 |
| 9 | docker-ctl | Docker Ctl | 3.531 |
| 10 | docker-compose | Docker Compose | 3.511 |

---

## 💡 实战案例

### 案例 1: 使用 Skills 开发移动端游戏

```bash
# 1. 项目初始化
>> /unity 创建一个新的 Unity 项目

# 2. 移动端适配
>> /mobile 配置 Android/iOS 打包

# 3. 自动化测试
>> /mobile-appium-test 设置 UI 自动化测试
>> /android-remote-control 配置 ADB 远程调试

# 4. 发布
>> /the-flip-publish 发布游戏
```

### 案例 2: 使用 Skills 构建 DevOps 流程

```bash
# 1. GitHub 集成
>> /github 设置仓库自动化

# 2. 容器化
>> /docker-essentials 创建 Dockerfile
>> /docker-compose 设置开发环境

# 3. K8s 部署
>> /kubernetes-devops 配置 K8s 部署
>> /k8-autoscaling 设置自动扩缩

# 4. 监控
>> /kube-medic 设置集群诊断
```

---

## 📦 安装指南

### ClawHub 安装

```bash
# 搜索 Skills
clawhub search <keyword>

# 安装 Skills
clawhub install <skill-id>

# 例如
clawhub install unity
clawhub install openclaw-unreal-skill
clawhub install kubernetes-devops
```

### Antigravity 安装

```bash
npx antigravity-awesome-skills --claude
```

---

## 🔧 使用方式

### Claude Code

```bash
>> /skill-name 帮助我...
```

### Gemini CLI / Codex CLI

```bash
Use @skill-name to help me...
```

---

## 📚 相关资源

- [ClawHub Registry](https://clawhub.com)
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [CC Skills 仓库](https://github.com/kongshan001/cc_skills)
- [Unity 官方文档](https://docs.unity.com/)
- [Unreal Engine 文档](https://docs.unrealengine.com/)
- [Kubernetes 文档](https://kubernetes.io/docs/)

---

**文档更新时间**: 2026-03-04 (第十四周续)
**Claude Code Skills 调研 - 实时搜索结果补充**
