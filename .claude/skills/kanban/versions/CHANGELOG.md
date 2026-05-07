# Kanban Framework — Changelog

所有版本的迭代记录索引。每个版本有对应的详细记录文件 `v{X.Y.Z}.md`。

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
