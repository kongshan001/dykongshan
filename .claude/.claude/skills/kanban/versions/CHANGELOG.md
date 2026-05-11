# Kanban Framework — Changelog

所有版本的迭代记录索引。每个版本有对应的详细记录文件 `v{X.Y.Z}.md`。

## [v0.12.0] - 2026-05-10

### Added
- **Plan Review 6 维度并行调度**: 6 个评审维度并行 Agent + collect-plan-review 收集报告
- **Retrospective 3 角色并行调度**: retrospective_writer / acceptance_writer / knowledge_extractor 并行
- **Guard 批量并行检查**: batch_check + batch_check_combined
- **Evaluate 阶段分数门槛硬性门控**: complete-phase 自动检查 score vs threshold，不达标时阻止转换
- **History 自动记录**: create/transition/complete-phase 自动追加 history 条目
- **Version CLI 命令**: version list + record 子命令

### Fixed
- 新旧 Task Format 不一致导致 5 个测试 stale data（_write_task 清理旧格式）
- Windows symlink 检测失败（path-parts 匹配替代字符串匹配）
- Windows GBK 编码错误（统一 encoding="utf-8"）
- check-env 测试环境隔离
- SKILL.md 自定义 subagent_type 无法调度（统一改为 general-purpose）

### Changed
- cmd_workflow transition/complete-phase 持久化 history
- SKILL.md: Plan Review 6 并行维度 + Retrospective 3 并行角色 + 串行回退

详细记录见 `v0.12.0.md`

## [v0.11.0] - 2026-05-09

### Added
- **Evaluator 自动评分链路**: collect-scores / record-score / self-improve-check 自动读 score_history
- **迭代产物隔离**: workflow start-iteration hot/full + execution artifacts 迁移到 iteration-N/
- **评分趋势 UI**: score_history 可视化（Canvas 折线图 + pass_threshold 参考线 + 颜色区分）
- **轻量模式硬性门控**: requires_confirmation + AskUserQuestion 强制确认
- **Agent 调度增强**: get-phase-agents 暴露 timeout/parallel 配置
- **跨任务冲突检测**: Guard.check_cross_task_conflicts()
- **知识库语义搜索**: search_scored() 加权评分（标题×3 + 分类×2 + 内容×1）
- **Agent 注册表自动发现**: Scheduler.scan_agents() 扫描 .claude/agents/*.md
- **项目根目录自动检测**: Filesystem.find_project_root() + check-env 异常检测
- **NLP → LLM 推理**: 删除 1000 行关键词匹配，改为 interpret_by_llm

### Changed
- SKILL.md: brainstorming 强制 AskUserQuestion，LLM 推理路由
- github-issue-processing skill: 不再基于标题过滤，验收报告缺口补齐前不关闭
- Task 类型: 新增 scores + score_history 字段

### Fixed
- cmd_workflow transition 持久化阶段状态 (#100/#101)
- Dashboard 缺失 StatsOverview.js + useScoreChart.js (#103)
- Guard 兼容 iteration-N/ legacy 格式 (#102)

详细记录见 `v0.11.0.md`

## [v0.10.0] - 2026-05-08

### Added
- **Agent kanban- 前缀统一命名**: 全部 10 个 agent 使用 `kanban-` 前缀（kanban-planner, kanban-executor, kanban-code-reviewer, kanban-designer, kanban-pm, kanban-qa, kanban-researcher, kanban-knowledge-manager, kanban-plan-reviewer, kanban-test-spec-reviewer）
- **Agent 全能力化**: executor/planner/knowledge-manager/researcher 移除 tools/skills 限制，获得全部工具能力
- **Init 智能分析层** (`scanner.py`): 项目扫描模块，检测 agent 冲突、skills、语言/框架基础设施、领域特定基建
- **Plan Review 质量门禁**: 新 kanban-plan-reviewer agent，6 维度量化评分 Plan 产物
- **QA Spec 测试用例并行开发**: kanban-qa 支持 spec/eval 双模式，Plan 通过后产出 test_spec.md
- **Spec Review 质量门禁**: 新 kanban-test-spec-reviewer agent，5 维度审核测试用例文档
- **FSM 阶段扩展**: 新增 plan_review / qa_spec / spec_review / retrospective 四个阶段（共 9 阶段）
- **Execute 多 Agent 并行调度**: subtask.py 拓扑排序 + 文件冲突检测批次调度，parallelizable/file_ownership/shared_files_readonly 元数据
- **Plan Review 自动重试**: WorkflowEngine.quality_gate_check + RETRY_PREV action
- `cmd_scan` 命令：独立项目扫描
- 测试覆盖: 167 个测试全部通过（含 28 个 scanner + 12 个 guard + 9 个 subtask scheduler）

### Changed
- **Phase 枚举扩展**: PLAN_REVIEW, QA_SPEC, SPEC_REVIEW, RETROSPECTIVE 加入
- **workflow.json**: 从扁平的 4 阶段扩展到 9 阶段对象格式，含 agent_type 引用
- **SKILL.md**: 全部 subagent_type 引用更新为 kanban- 前缀，新增 4 阶段文档
- **Guard 扩展**: check_spec, check_parallel_conflicts, check_retrospective
- **Config.phases**: 向后兼容，自动从对象列表提取 id 或回退到字符串列表
- **types.py Report**: scores 字段改为 dimensions 对象格式
- **Scheduler**: PHASE_ORDER 扩展，agent_type 使用 kanban- 前缀

### Fixed
- **Stub 实现修复**: cmd_worktree/create/remove/merge/cleanup, cmd_guard/check-artifacts/evaluation/inbox/spec/parallel-conflicts, cmd_workflow/transition/complete-phase/self-improve-check/get-roles, cmd_nlp
- **代码重复消除**: CLI 层并行冲突检测委托给 Guard 领域方法
- **异常处理修复**: cmd_init scanner 异常不再吞没
- **Agent 模板路径**: $KANBAN_DIR/reports/ → tasks/${task_id}/iteration-N/
- **8 个回归测试**: conftest.py Phase 顺序、test_run/test_workflow/test_scheduler/test_config 全部适配
- **__pycache__ 清理**: 添加 .gitignore 排除规则，移除已提交缓存文件

### Security
- cmd_worktree merge/cleanup 使用原始 task_id，建议后续添加 tm.show() 校验

详细记录见 `v0.10.0.md`

## [v0.6.0] - 2026-05-04

### Added
- 自然语言命令解析层（NLP Router）：用户可用中文/英文/混合自然语言与 kanban 交互
- 数据驱动关键词配置 `nlp_patterns.json`：11 个命令类型，200+ 关键词模式
- 三层置信度匹配：精确 (1.0) / 同义词 (0.8) / 模糊 (0.6)
- Task ID 智能提取：标准格式、纯数字、中文数字、序数表达式
- 繁体中文支持（19 个繁简映射）
- 拼写容错（10 个常见拼写纠错）
- 单任务推断：仅一个活跃任务时自动推断 task_id
- Create 命令三层 title 提取（引号 > 中文标记 > 关键词剥离）
- SKILL.md 自然语言路由文档（含示例映射表）
- NLP 路由器单元测试（148 项断言，全部通过）

### Changed
- SKILL.md 命令路由章节：新增自然语言路由入口，精确命令优先匹配
- `kanban_init_env` 自动加载 `nlp_router.sh`（通过 lib/*.sh glob）

### Security
- sed 替换中正则元字符转义防护（`_nlp_sed_escape` helper）

详细记录见 `v0.6.0.md`

## [v0.2.0] - 2026-05-03

### Added
- 目录内聚化（tasks/TASK-NNN/ 新布局 + 自动迁移）
- Plan 质量门禁（4维加权评分: 需求清晰度/技术可行性/拆解合理性/验收标准完整性）
- Worktree 生命周期（validate/create/merge/cleanup 容错增强）
- 归档自演进（framework_self_assess 自动创建改进任务）
- kanban_changes_summary（user_decision 阶段变更全景展示）
- Dashboard 可视化看板
- 版本管理系统（CHANGELOG + 逐版本记录）

### Changed
- evaluator_record_score 读取 .average_score（兼容 .score 回退）
- worktree_merge 容错处理（无 worktree 时兜底 commit）
- SKILL.md 编排逻辑更新（Phase 4 增加 changes_summary）
- .gitignore 追加运行时数据规则和敏感文件模式

### Fixed
- worktree_cleanup 清空 task JSON 字段问题
- hot iteration worktree 校验/重建逻辑
- evaluate→archive 转换被阻止（IR-11 合规）
- grep -c 在 zsh 中的整数比较警告

详细记录见 `v0.2.0.md`

## [v0.1.0] - 2026-04-28

### Added
- FSM 工作流引擎（plan → execute → evaluate → user_decision → archive）
- 4 角色评估体系（code_reviewer / qa / pm / designer）
- Guard 三层防护（阶段转换/产物完整性/评分标准）
- Worktree 隔离执行（独立分支 + 合并）
- 自迭代循环（hot iteration 快速修复 / full iteration 全量重来）
- 评分系统（10分制 + pass_threshold 可配置）
- 任务 CRUD（create / status / show / decide / recover）
- 知识沉淀（knowledge-log.md）
- 崩溃恢复机制
- Inbox 反馈分析
- Iron Rules 铁律体系（11条）

详细记录见 `v0.1.0.md`
