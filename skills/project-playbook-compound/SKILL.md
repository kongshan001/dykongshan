# 项目从零到一 Playbook (Compound)

> **层级**: Compound（化合物技能 / Playbook）
> **编排**: skill-research-molecule + coding-agent + code-fix-molecule + exec(git/github)
> **用途**: 从调研到开发到部署的完整项目流程，需要人类驱动

## 触发条件

- "帮我做一个 XXX 项目"
- "从零开始 XXX"
- "我想开发一个 XXX"

## 前置条件

- 用户已明确项目目标和大致需求
- 人类处于驾驶位，在关键决策点需要确认

## 执行流程

### Phase 1: 调研（Molecule: research-report-molecule）
1. 调研相关技术栈和竞品
2. 生成调研报告，推送到 research-reports 仓库
3. **检查点**：向用户展示调研结论，确认方向

### Phase 2: 设计（原子：write）
1. 基于调研结果，编写设计文档（docs/design.md）
2. 包含：架构图、技术选型、目录结构、API 设计
3. **检查点**：用户审阅设计文档

### Phase 3: 开发（Molecule: coding-agent）
1. 用 sessions_spawn 启动 coding agent 实现功能
2. 监控 agent 进度，遇到问题及时干预
3. 代码完成后自动推送到 GitHub

### Phase 4: 质量保障（Molecule: code-fix-molecule）
1. 运行 lint 和测试
2. 自动修复发现的问题
3. 如有测试失败，反馈给 coding agent 修复

### Phase 5: 部署
1. 根据项目类型选择部署方式（Vercel/GitHub Pages/服务器）
2. 验证部署结果
3. **检查点**：用户确认部署成功

## 人类决策点

每个 Phase 结束后必须等用户确认再进入下一阶段。
除了自动 git push（按用户偏好）外，所有外部操作需要确认。

## 适用项目类型

- Web 应用
- 工具/CLI
- 游戏原型
- 文档站点
