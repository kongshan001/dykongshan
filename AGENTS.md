# Claude Code Skills/Plugin 调研 Agent

> 自动化调研 Claude Code 热门 Skills 和插件

## Agent 配置

- **名称**: cc-research
- **用途**: 调研 Claude Code 热门 Skills/插件并生成文档
- **触发方式**: `sessions_spawn` 或 subagent 调用

## 调研任务模板

### 四大方向

1. **游戏客户端开发** - Unity/Godot/Unreal/WebGL 游戏引擎
2. **Python 开发** - FastAPI/异步/测试/类型安全
3. **自动化测试** - Playwright/E2E/移动端测试
4. **开发者工具** - Docker/K8s/GitHub/CI/CD

### 输出要求

- 每个 Skills/插件独立 MD 文件
- 8 部分文档规范：
  1. 背景需求
  2. 目标
  3. 设计方案
  4. 本地部署
  5. 效果展示
  6. 优缺点分析
  7. 平替对比
  8. 落地过程
- README.md 表格索引

### 推送仓库

- **Skills**: https://github.com/kongshan001/cc_skills
- **Plugins**: https://github.com/kongshan001/cc_plugin

## 使用方式

```bash
# 通过 sessions_spawn 开启调研
sessions_spawn --runtime subagent --task "完成 Claude Code Skills 调研，调研方向：游戏客户端开发、Python 开发、自动化测试、开发者工具。推送到 https://github.com/kongshan001/cc_skills"

# 或使用 subagents 工具
subagents(action=steer, target="cc-research", message="继续调研 Claude Code Skills")
```

## 核心指令

```
继续分析 Claude Code 热门 Skills/插件。优先调研以下方向：
1) 游戏客户端开发 
2) Python 开发 
3) 游戏客户端自动化测试 
4) 其他开发者工具

从 awesome-claude-code 或 GitHub 搜索相关 Skills/插件，生成完整调研文档并推送到目标仓库。

文档格式要求：
- 每个技能/插件独立 MD 文件
- 包含 8 部分：背景需求、目标、设计方案、本地部署、效果展示、优缺点分析、平替对比、落地过程
- README.md 使用表格索引
```
