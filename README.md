# Claude Code Skills 实践指南

> 记录每个 Skill 的落地实践过程

## 📚 Skills 列表

| Skill 名称 | 描述 | 状态 |
|-----------|------|------|
| [compound-engineering](./compound-engineering/README.md) | 复合工程插件，9,782⭐，29 agents·22 commands·20 skills，完整 Plan→Work→Review→Compound 工作流，多平台配置同步 | ✅ 已调研 |
| [get-shit-done](./get-shit-done/README.md) | 轻量级 Spec 驱动开发系统，解决 Context Rot，Wave 并行执行 | ✅ 已调研 |
| [superpowers](./superpowers/README.md) | Agentic Skills 完整工程工作流框架，68k⭐ | ✅ 已调研 |
| [agentsys](./agentsys/README.md) | 14 插件·43 agents·30 skills 模块化编排系统，任务到生产完整自动化 | ✅ 已调研 |
| [pinme](./pinme/README.md) | 零配置前端部署工具，一键部署到 IPFS，2939⭐ | ✅ 已调研 |
| [ui-ux-pro-max](./ui-ux-pro-max/README.md) | AI UI/UX 设计智能助手，67+设计风格，36k⭐ | ✅ 已调研 |
| [claude-mem](./claude-mem/README.md) | 智能记忆系统，自动捕获会话内容并生成 AI 摘要 | ✅ 已调研 |
| [episodic-memory](./episodic-memory/README.md) | 跨会话语义搜索，记住之前的讨论、决策和模式 | ✅ 已调研 |
| [planning-with-files](./planning-with-files/README.md) | Manus 风格持久化 Markdown 规划系统，15k⭐ | ✅ 已调研 |
| [deep-research](./deep-research/README.md) | Gemini 深度研究技能，自主多步骤市场分析 | ✅ 已调研 |
| [trailofbits-security](./trailofbits-security/README.md) | Trail of Bits 安全技能集，20+安全插件 | ✅ 已调研 |
| [fullstack-dev-skills](./fullstack-dev-skills/README.md) | 66+ Skills 全栈开发框架，9 个工作流命令，覆盖 12 个技术类别 | ✅ 已调研 |
| [everything-claude-code](./everything-claude-code/README.md) | 50K⭐ AI Agent 性能优化系统，13 agents, 56 skills, Anthropic Hackathon Winner | ✅ 已调研 |
| [claude-scientific-skills](./claude-scientific-skills/README.md) | 148+ 科学研究 Skills，250+ 数据库，跨生物信息、药物发现、临床研究、材料科学等领域 | ✅ 已调研 |
| [python-type-safety](./python-type-safety/README.md) | Python 类型安全最佳实践，10 个核心模式，mypy/pyright 严格检查 | ✅ 已调研 |
| [antigravity-awesome-skills](./antigravity-awesome-skills/README.md) | 968+ 通用 Agentic Skills 集合，10+ AI 助手平台支持，12 大类分类 | ✅ 已调研 |
| [book-factory](./book-factory/README.md) | 非小说类书籍创作流水线，6 个 Skills 覆盖概念开发、市场验证、架构设计、研究规划、章节规划 | ✅ 已调研 |
| [cc_devops_skills](./cc_devops_skills/README.md) | 31 个 DevOps 工程技能，覆盖 IaC、CI/CD、容器编排、可观测性 | ✅ 已调研 |
| [game-dev-skills](./game-dev-skills/README.md) | 游戏客户端开发 Skills，覆盖 Unity/Godot/Unreal 主流引擎，ECS/DOTS 架构，**新增 Unity AI Workflow 2026** | ✅ 已调研 |
| [python-dev-skills](./python-dev-skills/README.md) | Python 开发 Skills，Python 3.12+ 现代工具链，FastAPI/异步/测试/性能优化 | ✅ 已调研 |
| [automation-testing-skills](./automation-testing-skills/README.md) | 自动化测试 Skills，AI 驱动测试、Playwright/Cypress E2E、pytest、TDD | ✅ 已调研 |
| [developer-tools-skills](./developer-tools-skills/README.md) | 开发者工具 Skills，浏览器自动化、GitHub/GitLab 自动化、CI/CD 流水线 | ✅ 已调研 |
| [SKILLS_SUPPLEMENT_2026_03](./SKILLS_SUPPLEMENT_2026_03.md) | Claude Code Skills 补充调研报告，2026年3月最新更新，包含 Multiplayer/Playwright/Async Python 等专题 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK2](./SKILLS_SUPPLEMENT_2026_03_WEEK2.md) | Claude Code Skills 补充调研报告（第二周），游戏开发/ Python/ 测试/ 开发者工具完整覆盖 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK3](./SKILLS_SUPPLEMENT_2026_03_WEEK3.md) | Claude Code Skills 补充调研报告（第三周），Unity AI Workflow 2026/ uv/ 移动端游戏测试 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK4](./SKILLS_SUPPLEMENT_2026_03_WEEK4.md) | Claude Code Skills 补充调研报告（第四周），游戏客户端开发/Python开发/测试自动化/开发者工具 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK5](./SKILLS_SUPPLEMENT_2026_03_WEEK5.md) | Claude Code Skills 补充调研报告（第五周），Temporal/DBOS 工作流/uv/Playwright 云测试/GitOps 专题 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK6](./SKILLS_SUPPLEMENT_2026_03_WEEK6.md) | Claude Code Skills 补充调研报告（第六周），game-development 编排 Skill/FastAPI Pro/Temporal/游戏客户端测试专题 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK7](./SKILLS_SUPPLEMENT_2026_03_WEEK7.md) | Claude Code Skills 补充调研报告（第七周），游戏客户端开发/Python开发/自动化测试/开发者工具完整覆盖 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK8](./SKILLS_SUPPLEMENT_2026_03_WEEK8.md) | Claude Code Skills 补充调研报告（第八周），游戏引擎 Unity/Unreal/Godot/Bevy、FastAPI Pro/Django Pro、TDD/Playwright、CI/CD/GitOps 完整覆盖 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK9](./SKILLS_SUPPLEMENT_2026_03_WEEK9.md) | Claude Code Skills 补充调研报告（第九周），游戏客户端开发/Python开发/自动化测试/开发者工具完整覆盖，新增近期更新亮点 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK10](./SKILLS_SUPPLEMENT_2026_03_WEEK10.md) | Claude Code Skills 补充调研报告（第十周），ClawHub 搜索发现新兴 Skills、Game Cog/Playwright/GitHub 自动化专题 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK13](./SKILLS_SUPPLEMENT_2026_03_WEEK13.md) | Claude Code Skills 补充调研报告（第十三周），游戏客户端开发/Python开发/自动化测试/开发者工具完整覆盖 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK12](./SKILLS_SUPPLEMENT_2026_03_WEEK12.md) | Claude Code Skills 补充调研报告（第十二周），Unity AI Workflow 2026/DBOS Python/Temporal/Playwright 高级专题 | 🆕 新增 |
| [SKILLS_SUPPLEMENT_2026_03_WEEK13](./SKILLS_SUPPLEMENT_2026_03_WEEK13.md) | Claude Code Skills 补充调研报告（第十三周），ClawHub 高分 Skills 专题，Docker/Git/FastAPI/Test 工具 | 🆕 新增 |
| [SKILLS_SURVEY_2026_03_GAME_PYTHON_TEST_V3](./SKILLS_SURVEY_2026_03_GAME_PYTHON_TEST_V3.md) | Claude Code Skills 完整调研报告 V3，游戏客户端开发/Python开发/自动化测试/开发者工具完整覆盖，新增 Unity AI Workflow 2026 | 🆕 新增 |
| [SKILLS_SURVEY_2026_03_GAME_PYTHON_TEST_V4](./SKILLS_SURVEY_2026_03_GAME_PYTHON_TEST_V4.md) | Claude Code Skills 完整调研报告 V4，游戏客户端开发/Python开发/自动化测试/开发者工具完整覆盖 | 🆕 新增 |
| [SKILLS_SURVEY_2026_03_GAME_PYTHON_TEST_V5](./SKILLS_SURVEY_2026_03_GAME_PYTHON_TEST_V5.md) | Claude Code Skills 完整调研报告 V5，**最新完整版**，覆盖 Antigravity 958+ Skills 和 VoltAgent 506+ 官方 Skills | 🆕 新增 |

## 📝 文档规范

每个 Skill 文档包含：

1. **Skill 背景需求** - 为什么需要这个 Skill
2. **目标** - Skill 要解决什么问题
3. **设计方案** - Skill 的技术架构
4. **本地部署** - Win/Mac/Linux 部署指南
5. **效果展示** - 实际使用效果
6. **优缺点分析** - Skill 的优势与不足
7. **平替对比** - 类似 Skill 对比
8. **落地过程** - 实践验证的完整记录

## 🔧 如何贡献

1. 在根目录下创建 Skill 文件夹
2. 按照上述规范编写 `README.md`
3. 在项目根目录 `README.md` 中添加链接
4. 提交 PR

---

*让 AI 助手真正记住你*
