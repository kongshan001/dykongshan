# Antigravity Awesome Skills - 968+ 通用 Agentic Skills 集合

> 迄今为止最全面的 AI 编程助手技能库，支持 Claude Code、Gemini CLI、Codex、Cursor 等 10+ 平台

## 📋 文档信息

- **Skill 名称**: Antigravity Awesome Skills
- **GitHub**: [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)
- **Star**: 18,269⭐
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 多平台支持 / 技能集合 / Claude Code 扩展
- **版本**: V6.7.0

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **AI 能力不全面** | AI 编程助手（如 Claude Code）缺乏特定领域的专业知识 | 无法处理专业任务 |
| **多平台碎片化** | 每个 AI 助手有不同的技能格式和调用方式 | 学习成本高 |
| **技能分散** | 好的技能散落在各处，没有统一收集 | 难以发现和使用 |
| **缺乏系统性** | 没有针对特定角色的技能包 | 新手无从下手 |

### 目标

构建一个**通用、全面、易用**的技能库：

1. **多平台支持** - 一次安装，10+ AI 助手可用
2. **角色化 bundles** - 按角色（Web Dev、Security、Full-Stack）打包技能
3. **968+ 技能** - 覆盖开发、设计、安全、AI/ML 等领域
4. **标准化格式** - 统一的 SKILL.md 格式

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────────────┐
│              Antigravity Awesome Skills 架构                         │
└─────────────────────────────────────────────────────────────────────┘

     ┌──────────────────────────────────────────────────────────────┐
     │                      技能分类 (12 大类)                       │
     ├──────────────────────────────────────────────────────────────┤
     │  🏗 architecture (67)   📊 business (43)    🤖 data-ai (177)  │
     │  🎨 design (45)        🔒 security (52)      🚀 devops (44)   │
     │  📱 mobile (23)        🎮 game-dev (16)     🌐 ai-agents (38) │
     │  ⚙️  engineering (67)  📝 meta (36)         🔬 research (22)  │
     └──────────────────────────────────────────────────────────────┘

     ┌──────────────────────────────────────────────────────────────┐
     │                      10+ 平台支持                             │
     ├──────────────────────────────────────────────────────────────┤
     │  Claude Code  ·  Gemini CLI  ·  Codex CLI  ·  Kiro CLI/IDE │
     │  Antigravity IDE  ·  Cursor  ·  GitHub Copilot  ·  OpenCode │
     │  AdaL CLI                                                        │
     └──────────────────────────────────────────────────────────────┘

     ┌──────────────────────────────────────────────────────────────┐
     │                      Starter Bundles                         │
     ├──────────────────────────────────────────────────────────────┤
     │  Essentials · Security Engineer · Web Wizard · Full-Stack   │
     │  Mobile Dev · AI/ML Engineer · Data Analyst · DevOps        │
     └──────────────────────────────────────────────────────────────┘
```

### 技能分类统计

| 分类 | 技能数量 | 说明 |
|-----|---------|------|
| **data-ai** | 177 | AI/ML、RAG、数据库、LLM 应用开发 |
| **engineering** | 67 | 架构、编码模式、工程最佳实践 |
| **architecture** | 67 | 系统架构、DDD、C4、 monolith/monorepo |
| **security** | 52 | 安全审计、渗透测试、合规 |
| **business** | 43 | 市场营销、SEO、财务、业务分析 |
| **design** | 45 | UI/UX、设计系统、品牌 |
| **devops** | 44 | 部署、监控、容器、云原生 |
| **ai-agents** | 38 | Agent 模式、多Agent 系统 |
| **meta** | 36 | 技能开发、工作流、提示工程 |
| **mobile** | 23 | iOS、Android、React Native |
| **game-dev** | 16 | 游戏开发、Unity、Unreal |
| **research** | 22 | 学术研究、文献综述 |

### 多平台调用方式

| 工具 | 类型 | 调用示例 | 路径 |
|-----|------|---------|------|
| **Claude Code** | CLI | `>> /skill-name help me...` | `.claude/skills/` |
| **Gemini CLI** | CLI | `Use skill-name...` | `.gemini/skills/` |
| **Codex CLI** | CLI | `Use skill-name...` | `.codex/skills/` |
| **Kiro CLI/IDE** | CLI/IDE | `/skill-name` 或自动加载 | `~/.kiro/skills/` |
| **Antigravity** | IDE | `Use skill...` | `~/.gemini/antigravity/skills/` |
| **Cursor** | IDE | `@skill-name` | `.cursor/skills/` |
| **OpenCode** | CLI | `opencode run @skill-name` | `.agents/skills/` |
| **AdaL CLI** | CLI | 自动加载 | `.adal/skills/` |

### Starter Bundles (精选包)

| Bundle | 目标用户 | 核心技能 |
|--------|---------|---------|
| **Essentials** | 所有人 | concise-planning, lint-and-validate, git-pushing, kaizen, systematic-debugging |
| **Security Engineer** | 安全专家 | ethical-hacking-methodology, burp-suite-testing, top-web-vulnerabilities |
| **Web Wizard** | Web 开发者 | frontend-design, react-best-practices, nextjs-best-practices, tailwind-patterns |
| **Full-Stack Developer** | 全栈工程师 | senior-fullstack, frontend-developer, backend-dev-guidelines, database-design |
| **Mobile Dev** | 移动端开发 | ios-developer, android-developer, react-native-expert |
| **AI/ML Engineer** | AI/ML 工程师 | ai-engineer, rag-engineer, langchain-architecture, llm-evaluation |
| **Data Analyst** | 数据分析师 | data-scientist, postgresql, business-analyst |
| **DevOps** | 运维工程师 | docker-kubernetes, aws-deployment, ci-cd-pipelines |

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Node.js** | 18+ 版本 |
| **至少一个 AI 编程助手** | Claude Code / Gemini CLI / Codex / Cursor 等 |
| **网络** | 访问 npm 和 GitHub |

### 安装步骤

#### 方式 1: npx 安装（推荐）

```bash
# 默认安装到 Antigravity 全局
npx antigravity-awesome-skills

# 验证安装
test -d ~/.gemini/antigravity/skills && echo "Skills installed!"
```

#### 方式 2: 指定平台安装

```bash
# Claude Code
npx antigravity-awesome-skills --path ~/.claude/skills

# Gemini CLI
npx antigravity-awesome-skills --path ~/.gemini/skills

# Kiro CLI/IDE (全局)
npx antigravity-awesome-skills --path ~/.kiro/skills

# Cursor
npx antigravity-awesome-skills --path ~/.cursor/skills

# 工作区特定
npx antigravity-awesome-skills --path .claude/skills
```

#### 方式 3: 手动克隆

```bash
# 克隆到工作区
git clone https://github.com/sickn33/antigravity-awesome-skills.git .claude/skills

# 或全局安装
git clone https://github.com/sickn33/antigravity-awesome-skills.git ~/.claude/skills
```

### Windows 部署

> 在 PowerShell 中运行同样的命令

```powershell
npx antigravity-awesome-skills
```

### 使用技能

```bash
# Claude Code
>> /brainstorming 帮助我规划一个 SaaS
>> /lint-and-validate 检查这个文件
>> /security-auditor 审计这段代码

# Gemini CLI
使用 brainstorming skill 帮助我规划一个 SaaS

# Cursor
@brainstorming 帮助我规划一个 SaaS
```

### 更新技能库

```bash
# 重新运行安装命令
npx antigravity-awesome-skills
```

---

## 4. 效果展示

### 热门技能示例

#### 架构类
```
>> /architecture 设计一个电商系统
→ 使用 C4 模型进行架构设计

>> /ddd-strategic-design 设计 DDD 战略模型
→ 生成子域、限界上下文、通用语言
```

#### 开发类
```
>> /react-best-practice 构建 React 组件
→ 遵循 React 19+ 最佳实践

>> /nextjs-best-practice 创建 Next.js 页面
→ 使用 App Router 和 Server Components
```

#### AI/ML 类
```
>> /rag-engineer 构建 RAG 系统
→ 选择向量数据库、优化分块策略

>> /langchain-architecture 设计 LangChain 应用
→ Agent、Memory、Tools 集成
```

#### 安全类
```
>> /security-auditor 审计代码
→ OWASP Top 10 检查

>> /ethical-hacking-methodology 渗透测试
→ 系统化ethical hacking 流程
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **技能数量最多** | 968+ 技能，覆盖几乎所有开发领域 |
| **多平台支持** | 支持 10+ AI 编程助手，一次安装多处使用 |
| **分类清晰** | 12 大类，角色化 Bundles 便于选择 |
| **官方整合** | 包含 Anthropic、OpenAI、Google、Microsoft 官方技能 |
| **持续更新** | V6.7.0，持续迭代维护 |
| **社区活跃** | 18k+ stars，大量贡献者 |
| **MIT 许可** | 开源免费 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **学习曲线** | 技能太多，初学者难以选择 |
| **质量参差** | 部分技能可能不如官方或专业项目 |
| **Windows 兼容** | 使用 symlinks，Windows 需要额外处理 |
| **存储空间** | 完整克隆较大 (~100MB+) |
| **更新频繁** | 版本迭代快，需要手动更新 |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| 多平台 AI 助手使用 | ⭐⭐⭐⭐⭐ |
| 快速找到特定领域技能 | ⭐⭐⭐⭐⭐ |
| 构建开发/安全/AI 工作流 | ⭐⭐⭐⭐⭐ |
| 新手入门 AI 编程 | ⭐⭐⭐⭐ |
| 生产项目专业需求 | ⭐⭐⭐⭐ |
| 轻量级简单任务 | ⭐⭐⭐ |

---

## 6. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **Antigravity Awesome Skills** | 968+ 技能，10+ 平台支持 | 全栈开发，多助手用户 |
| **superpowers** | 68k⭐，完整工程工作流 | 大型项目，团队协作 |
| **everything-claude-code** | 57k⭐，50K 资源索引 | 学习资源查找 |
| **claude-scientific-skills** | 148+ 科研技能 | 科学研究领域 |
| **官方 skills (anthropics)** | 81k⭐，官方维护 | 基础能力扩展 |

### Antigravity vs superpowers

| 特性 | Antigravity | superpowers |
|-----|------------|-------------|
| 技能数量 | 968+ | 较少 |
| 多平台支持 | 10+ | 主要 Claude Code |
| 分类方式 | 12 大类 + Bundles | 工程流程 |
| 更新频率 | 高 (V6.7.0) | 中 |
| 专注领域 | 通用 | 软件工程 |
| 适合人群 | 所有用户 | 工程师 |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

Antigravity Awesome Skills 是一个**通用型 Agentic Skills 集合**，通过标准化 SKILL.md 格式实现跨平台兼容，覆盖开发、设计、安全、AI/ML 等全领域。

#### 📝 关键发现

1. **多平台统一**
   - 一次安装，多 AI 助手可用
   - 统一的技能格式 (SKILL.md)
   - 跨平台调用方式略有不同

2. **技能质量**
   - 包含官方技能（Anthropic、Microsoft 等）
   - 社区贡献质量参差
   - 建议优先使用热门/官方技能

3. **Starter Bundles 价值**
   - 解决"无从下手"问题
   - 按角色推荐技能组合
   - 降低学习成本

4. **持续维护**
   - V6.7.0 最新版本
   - 活跃的社区贡献
   - 完整的文档 (USAGE.md, BUNDLES.md 等)

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | npx 安装正常 |
| 多平台支持 | ✅ | 覆盖主流 AI 助手 |
| 文档完善 | ✅ | USAGE/BUNDLES/GUIDES |
| 技能数量 | ✅ | 968+ 实测 |
| 活跃维护 | ✅ | V6.7.0 最新 |

### 使用建议

1. **从 Bundles 开始** - 选择适合自己的 Starter Pack
2. **优先热门技能** - 使用 CATALOG.md 中标记的热门技能
3. **组合使用** - 可与其他 Skills (superpowers 等) 组合
4. **定期更新** - 运行 `npx antigravity-awesome-skills` 更新
5. **自定义技能** - 可在 skills/ 目录添加自己的技能

---

## 8. 常见问题

### Q: Antigravity Awesome Skills 和官方 skills 有什么区别？
A: 官方 skills (anthropics/skills) 只有 81k⭐ 但更基础；Antigravity 集合了社区和官方技能，更全面。

### Q: 技能质量如何保证？
A: 包含官方技能和经过审核的社区贡献，但建议对关键任务使用的技能进行人工验证。

### Q: 会覆盖其他 Skills 吗？
A: 不会。技能安装在不同目录，可以同时使用。

### Q: 支持中文吗？
A: 技能描述为英文，但调用方式和语言无关。

### Q: 占用空间大吗？
A: 完整克隆约 100MB+，包含 968 个技能文件。

### Q: 适合个人还是团队？
A: 都适合。个人可选择性安装，团队可全局部署共享。

---

## 📎 相关链接

- [GitHub](https://github.com/sickn33/antigravity-awesome-skills)
- [npm 包](https://www.npmjs.com/package/antigravity-awesome-skills)
- [Complete Usage Guide](docs/USAGE.md)
- [Skill Bundles](docs/BUNDLES.md)
- [Visual Guide](docs/VISUAL_GUIDE.md)
- [Discord 社区](https://discord.gg/antigravity)

---

*让 AI 助手真正变成全栈数字机构*
