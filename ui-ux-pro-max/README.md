# ui-ux-pro-max - AI UI/UX 设计智能助手

> 让 AI 编程助手具备专业级 UI/UX 设计能力

## 📋 文档信息

- **Skill 名称**: ui-ux-pro-max
- **GitHub**: [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- **Star**: 36318 ⭐
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / UI/UX 设计 / Claude Code 扩展

---

## 1. Skill 背景需求

### 问题痛点

AI 编程助手虽然能生成代码，但在 UI/UX 设计方面存在明显不足：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **设计感缺失** | 生成界面缺乏专业设计感 | 看起来像"AI 生成"的廉价感 |
| **风格不统一** | 缺少系统化的设计规范 | 界面风格杂乱 |
| **配色随意** | 不懂行业配色趋势 | 不符合产品调性 |
| **排版混乱** | 字体搭配不协调 | 阅读体验差 |
| **不懂行业** | 不理解不同行业的设计规范 | 医疗/金融等产品设计不当 |

### 目标

让 AI 编程助手具备**专业级 UI/UX 设计能力**：

1. **智能设计系统生成** - 根据产品类型自动生成完整设计规范
2. **67+ 主流 UI 风格** - 覆盖现代主流设计趋势
3. **100+ 行业规则** - 针对不同行业的设计最佳实践
4. **100+ 推理规则** - 基于产品特征的智能推荐

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                   UI UX Pro Max 工作流                        │
└─────────────────────────────────────────────────────────────┘

   用户请求              推理引擎                    输出
  ┌─────────┐         ┌──────────┐              ┌──────────┐
  │ "Build  │ ──────▶ │ 多域搜索  │ ──────────▶ │ 设计系统 │
  │  a SaaS │         │ +推理     │              │ +代码    │
  │ landing │         │ +规则     │              │ +验证    │
  └─────────┘         └──────────┘              └──────────┘
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
         ┌─────────┐  ┌─────────┐  ┌─────────┐
         │产品类型  │  │风格推荐  │  │配色选择  │
         │匹配      │  │(67种)   │  │(96种)   │
         └─────────┘  └─────────┘  └─────────┘
              ▼             ▼             ▼
         ┌─────────┐  ┌─────────┐  ┌─────────┐
         │落地页模式│  │字体搭配  │  │行业规范  │
         │(24种)   │  │(57种)   │  │(100+)   │
         └─────────┘  └─────────┘  └─────────┘
```

### 智能设计系统生成 (v2.0)

```
+----------------------------------------------------------------------------------------+
|  TARGET: Serenity Spa - RECOMMENDED DESIGN SYSTEM                                      |
+----------------------------------------------------------------------------------------+
|                                                                                        |
|  PATTERN: Hero-Centric + Social Proof                                                  |
|     Conversion: Emotion-driven with trust elements                                     |
|     CTA: Above fold, repeated after testimonials                                       |
|                                                                                        |
|  STYLE: Soft UI Evolution                                                              |
|     Keywords: Soft shadows, subtle depth, calming, premium feel                        |
|     Performance: Excellent | Accessibility: WCAG AA                                    |
|                                                                                        |
|  COLORS:                                                                               |
|     Primary:    #E8B4B8 (Soft Pink)                                                    |
|     Secondary:  #A8D5BA (Sage Green)                                                   |
|     CTA:        #D4AF37 (Gold)                                                         |
|                                                                                        |
|  TYPOGRAPHY: Cormorant Garamond / Montserrat                                           |
|     Mood: Elegant, calming, sophisticated                                              |
|                                                                                        |
|  PRE-DELIVERY CHECKLIST:                                                               |
|     [ ] No emojis as icons (use SVG: Heroicons/Lucide)                                |
|     [ ] cursor-pointer on all clickable elements                                        |
|     [ ] Hover states with smooth transitions (150-300ms)                               |
|     [ ] Light mode: text contrast 4.5:1 minimum                                       |
|                                                                                        |
+----------------------------------------------------------------------------------------+
```

### 核心功能

| 功能 | 数量 | 说明 |
|-----|------|------|
| **UI 风格** | 67+ | Glassmorphism, Neumorphism, Bento Grid, AI-Native UI 等 |
| **配色方案** | 96 | 行业特定的配色组合 |
| **字体搭配** | 57 | Google Fonts 字体组合推荐 |
| **图表类型** | 25 | 仪表板可视化推荐 |
| **技术栈** | 13 | React, Next.js, Vue, SwiftUI 等 |
| **UX 指南** | 99 | 最佳实践和反模式 |
| **推理规则** | 100 | 行业特定的设计系统生成 |

### UI 风格分类

| 类别 | 代表风格 |
|-----|---------|
| **现代主流** | Glassmorphism, Bento Grid, Soft UI |
| **复古怀旧** | Y2K, Vaporwave, Retro-Futurism |
| **极简主义** | Minimalism, Swiss Style, Flat Design |
| **创意风格** | Brutalism, Neubrutalism, 3D & Hyperrealism |
| **特定场景** | Dark Mode, AI-Native UI, Spatial UI (VisionOS) |
| **仪表板** | Data-Dense, Executive Dashboard, Real-Time Monitoring |

### 100+ 行业推理规则

| 行业类别 | 示例 |
|---------|------|
| **科技 & SaaS** | SaaS, Micro SaaS, B2B Enterprise, Developer Tools |
| **金融** | Fintech, Banking, Crypto, Insurance, Trading Dashboard |
| **医疗** | Medical Clinic, Pharmacy, Dental, Veterinary |
| **电商** | General, Luxury, Marketplace, Subscription Box |
| **服务** | Beauty/Spa, Restaurant, Hotel, Legal, Consulting |
| **创意** | Portfolio, Agency, Photography, Gaming |
| **新兴科技** | Web3/NFT, Spatial Computing, Autonomous Systems |

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Python** | 3.x (用于搜索脚本) |
| **Node.js** | 用于 CLI 安装 |
| **Claude Code** | 最新版本 |

### 安装步骤

#### 方式 1: Claude Code 插件市场（推荐）

```bash
# 添加插件市场
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill

# 安装插件
/plugin install ui-ux-pro-max@ui-ux-pro-max-skill

# 重启 Claude Code

# 验证安装
/plugin list
```

#### 方式 2: CLI 安装（推荐）

```bash
# 全局安装 CLI
npm install -g uipro-cli

# 进入项目目录
cd /path/to/your/project

# 为 Claude Code 安装
uipro init --ai claude

# 或为其他 AI 助手安装
uipro init --ai cursor      # Cursor
uipro init --ai windsurf   # Windsurf
uipro init --ai antigravity # Antigravity
uipro init --ai codex      # Codex CLI
```

#### 方式 3: 手动安装

```bash
# 克隆仓库
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git

# 复制到 Claude Code skills 目录
cp -r ui-ux-pro-max-skill/.claude/skills/* ~/.claude/skills/
```

### 验证安装

```bash
# 检查 CLI 版本
uipro --version

# 在 Claude Code 中直接使用
# "帮我设计一个 SaaS 产品的落地页"
```

### Python 依赖

```bash
# macOS
brew install python3

# Ubuntu/Debian
sudo apt update && sudo apt install python3

# Windows
winget install Python.Python.3.12
```

### Windows 部署

> 同样的命令，在 PowerShell 或 CMD 中运行

```powershell
# PowerShell
npm install -g uipro-cli
uipro init --ai claude
```

---

## 4. 效果展示

### Skill 触发示例

#### 示例 1: SaaS 落地页

```
用户: "帮我做一个 SaaS 产品的落地页"

AI (触发 ui-ux-pro-max):
"我来为你设计一个专业的 SaaS 落地页。

🎨 设计系统生成中...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TARGET: SaaS Product Landing Page
PATTERN: Conversion-Optimized
STYLE: Glassmorphism + Bento Grid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📐 布局结构:
1. Hero Section (含 CTA)
2. Features Showcase (Bento Grid)
3. Social Proof (Testimonials)
4. Pricing
5. CTA Final

🎨 配色:
Primary: #6366F1 (Indigo)
Secondary: #8B5CF6 (Violet)
Background: #0F172A (Dark)

🔤 字体:
Headings: Inter
Body: Inter

✅ 预交付检查清单已应用
   - 所有可点击元素 cursor-pointer
   - 平滑过渡动画 (150-300ms)
   - 键盘导航焦点状态
   - 响应式断点 (375/768/1024/1440)

→ 正在生成代码..."
```

#### 示例 2: 医疗仪表板

```
用户: "创建一个医疗分析仪表板"

AI:
"我来为你设计一个专业的医疗分析仪表板。

🎨 设计系统生成中...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TARGET: Healthcare Analytics Dashboard
PATTERN: Data-Dense + Executive Summary
STYLE: Clean Medical + Accessible
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏥 行业特定规则已应用:
- 符合 HIPAA 合规的隐私设计
- 高对比度配色 (WCAG AA)
- 数据可视化最佳实践
- 医疗级配色 (蓝/绿/白)

📊 图表配置:
- 患者趋势折线图
- 科室分布饼图
- 就诊预约日历
- 关键指标卡片

→ 正在生成代码..."
```

### 支持的技术栈

| 类别 | 技术栈 |
|-----|-------|
| **Web** | HTML + Tailwind (默认) |
| **React** | React, Next.js, shadcn/ui |
| **Vue** | Vue, Nuxt.js, Nuxt UI |
| **其他** | Svelte, Astro |
| **iOS** | SwiftUI |
| **Android** | Jetpack Compose |
| **跨平台** | React Native, Flutter |

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **专业设计系统** | 自动生成完整的配色、字体、布局规范 |
| **67+ UI 风格** | 覆盖现代主流设计趋势 |
| **100+ 行业规则** | 针对不同行业的设计最佳实践 |
| **v2.0 推理引擎** | 基于多域搜索的智能推荐 |
| **多平台支持** | Claude Code, Cursor, Windsurf, Codex 等 |
| **持续更新** | 活跃维护，功能不断完善 |
| **免费使用** | 核心功能完全免费 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **Python 依赖** | 需要 Python 3.x 运行搜索脚本 |
| **学习曲线** | 需要理解设计系统的工作方式 |
| **风格选择** | 有时推荐的风格可能不完全符合预期 |
| **生成速度** | 复杂设计系统生成需要更长时间 |
| **需要网络** | 风格搜索需要访问 GitHub |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 快速原型开发 | ⭐⭐⭐⭐⭐ |
| 落地页设计 | ⭐⭐⭐⭐⭐ |
| 仪表板开发 | ⭐⭐⭐⭐⭐ |
| 移动端 UI | ⭐⭐⭐⭐ |
| 品牌设计 | ⭐⭐⭐⭐ |
| 大型复杂项目 | ⭐⭐⭐ |

---

## 6. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **ui-ux-pro-max** | 专业 UI/UX 设计智能 | 界面开发、设计系统 |
| **superpowers** | 完整工程工作流 | 大型项目开发 |
| **pinme** | 前端部署 | 静态网站部署 |
| **Cursor 内置** | AI 辅助编码 | 日常开发 |
| **Figma** | 专业设计工具 | 设计师使用 |

### ui-ux-pro-max vs 其他

| 特性 | ui-ux-pro-max | superpowers | Claude Code 原生 |
|-----|--------------|------------|-----------------|
| UI 设计 | 67+ 风格 | ❌ | 基础 |
| 行业规则 | 100+ | ❌ | ❌ |
| 设计系统生成 | ✅ | ❌ | ❌ |
| 工作流覆盖 | 部分 | 完整 | 无 |
| 多平台 | ✅ | ✅ | 限定 |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

ui-ux-pro-max 是一个**专业级 UI/UX 设计智能助手**，通过 Agent Skill 的形式让 AI 编程助手具备专业设计师级别的界面开发能力。

#### 📝 关键发现

1. **v2.0 推理引擎**
   - 5 个并行搜索域（产品类型、风格、配色、布局、字体）
   - BM25 排名算法
   - JSON 条件决策规则
   - 输出完整设计系统

2. **多平台支持**
   - Claude Code, Cursor, Windsurf
   - Antigravity, Codex CLI, Gemini CLI
   - Kiro, Qoder, Roo Code, OpenCode
   - Continue, CodeBuddy, Droid

3. **设计系统持久化**
   - 支持保存到 `design-system/MASTER.md`
   - 支持页面级覆盖 `design-system/pages/*.md`
   - 跨会话层级检索

4. **预交付检查清单**
   - emoji 禁止作为图标（用 SVG）
   - cursor-pointer 样式
   - 平滑过渡动画
   - 对比度检查
   - 键盘导航支持
   - 响应式断点

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | CLI 安装正常 |
| Skill 触发 | ✅ | UI/UX 请求自动激活 |
| 设计系统生成 | ✅ | 推理引擎正常工作 |
| 多风格支持 | ✅ | 67+ 风格可用 |
| 多平台兼容 | ✅ | 支持主流 AI 助手 |

### 使用建议

1. **原型开发** - 先让 AI 生成设计系统，再开发代码
2. **风格指定** - 可以明确指定风格如 "Glassmorphism"
3. **行业说明** - 说明产品行业以获得更准确的推荐
4. **技术栈** - 明确指定 React/Vue/HTML+Tailwind

---

## 8. 常见问题

### Q: ui-ux-pro-max 是免费的吗？
A: 是的，核心功能完全免费。

### Q: 需要设计背景才能使用吗？
A: 不需要。Skill 自动处理设计决策，你只需描述需求。

### Q: 支持中文项目吗？
A: 支持。Skill 基于对话触发，与语言无关。

### Q: 和 Figma 有什么区别？
A: ui-ux-pro-max 直接生成代码，Figma 是设计工具需要手动实现。

### Q: 适合专业设计师使用吗？
A: 适合。可以作为快速原型工具，生成代码后再细化。

### Q: 支持自定义设计系统吗？
A: 支持。可以使用 `--persist` 保存设计系统到本地文件。

---

## 📎 相关链接

- [GitHub](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [官网](https://uupm.cc)
- [npm CLI](https://www.npmjs.com/package/uipro-cli)
- [NextLevelBuilder](https://nextlevelbuilder.io)

---

*让 AI 具备专业级 UI/UX 设计能力* 🎨
