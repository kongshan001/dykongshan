# HEARTBEAT.md

## 无限循环迭代：用实际业务实测 kanban-framework

### 核心逻辑
每次心跳执行一个任务的完整阶段推进。任务按 pending → planning → executing → evaluating → archived 顺序流转。归档后自动处理下一个 pending 任务。所有任务处理完后，创建新一批业务任务继续循环。

### 流程
1. **⚠️ 强制步骤 — 更新框架**：
   ```bash
   cd /root/.openclaw/workspace/kanban-framework && git fetch origin && git log HEAD..origin/main --oneline
   ```
   - 如果有新的 commits，输出更新内容到通知消息
   - 执行 `git pull` 拉取最新代码
   - 执行 `cp -r kanban-framework/.claude .claude` 部署最新框架

2. 查找当前需要推进的任务：
   - 优先：evaluating 状态的任务（完成评估→归档）
   - 其次：executing 状态的任务（完成执行→启动评估）
   - 其次：planning 状态的任务（完成规划→启动执行）
   - 其次：pending 状态的任务（启动规划）

3. 用 kanban 框架真实命令推进该任务的下一个阶段

4. 如果没有 pending 任务了，创建新一批任务（旅行规划相关功能）

5. 遇到框架 bug 立即提交 issue 到 kongshan001/kanban-framework

6. 回归验收已关闭的 issue（检查已关闭的 issue 是否有对应的 PR 修复，验证修复是否有效）

7. **通过飞书消息将结果同步给用户**，通知内容包含：
   - 本轮更新的框架 commits（如果有）
   - 任务归档情况
   - 新提的 issue
   - 回归验收结果
