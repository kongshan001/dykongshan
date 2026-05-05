# Claude Code 调研 Agent

## 简介

自动化调研 Claude Code 热门 Skills 和插件的 subagent。

## 用途

- 调研 Claude Code 热门 Skills → 推送到 cc_skills 仓库
- 调研 Claude Code 热门插件 → 推送到 cc_plugin 仓库

## 四大调研方向

1. **游戏客户端开发** - Unity/Godot/Unreal/WebGL
2. **Python 开发** - FastAPI/异步/测试/类型安全
3. **自动化测试** - Playwright/E2E/移动端测试
4. **开发者工具** - Docker/K8s/GitHub/CI/CD

## 文档规范

每个技能/插件独立 MD 文件，包含 8 部分：
1. 背景需求
2. 目标
3. 设计方案
4. 本地部署
5. 效果展示
6. 优缺点分析
7. 平替对比
8. 落地过程

## 调用示例

```python
# 调研 Skills
sessions_spawn(
    runtime="subagent",
    task="完成 Claude Code Skills 调研。调研方向：游戏客户端开发、Python 开发、自动化测试、开发者工具。推送到 https://github.com/kongshan001/cc_skills"
)

# 调研 Plugins
sessions_spawn(
    runtime="subagent", 
    task="完成 Claude Code 插件调研。调研方向：游戏客户端开发、Python 开发、自动化测试、开发者工具。推送到 https://github.com/kongshan001/cc_plugin"
)
```

## Git 推送命令参考

```bash
# cc_skills
cd ~/.openclaw/workspace/cc_skills
git add -A && git commit -m "docs: 添加调研文档" && git push origin master

# cc_plugin  
cd ~/.openclaw/workspace/cc_plugin
git add -A && git commit -m "docs: 添加调研文档" && git push origin main
```
