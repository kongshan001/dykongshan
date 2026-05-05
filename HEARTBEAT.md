# HEARTBEAT.md

## 无限循环迭代：用实际业务实测 kanban-framework

### 核心逻辑
每次心跳执行一个任务的完整阶段推进。任务按 pending → planning → executing → evaluating → archived 顺序流转。归档后自动处理下一个 pending 任务。所有任务处理完后，创建新一批业务任务继续循环。

### 流程
1. 拉取最新版本：`cd /root/.openclaw/workspace/kanban-framework && git pull`
2. 部署最新框架：`cp -r /root/.openclaw/workspace/kanban-framework/.claude .claude`
3. 查找当前需要推进的任务：
   - 优先：evaluating 状态的任务（完成评估→归档）
   - 其次：executing 状态的任务（完成执行→启动评估）
   - 其次：planning 状态的任务（完成规划→启动执行）
   - 其次：pending 状态的任务（启动规划）
4. 用 kanban 框架真实命令推进该任务的下一个阶段
5. 如果没有 pending 任务了，创建新一批任务（旅行规划相关功能）
6. 遇到框架 bug 立即提交 issue 到 kongshan001/kanban-framework
7. 回归验收已关闭的 issue
8. **通过飞书消息将结果同步给用户**
