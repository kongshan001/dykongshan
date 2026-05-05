# 技能调研与安装评估 (Molecule)

> **层级**: Molecule（分子技能）
> **组合**: exec(clawhub) + web_search + web_fetch + write + exec(git)
> **用途**: 调研 ClawHub/GitHub 上的 Agent 技能，评估是否值得安装，生成调研文档

## 触发条件

- "调研 XXX 技能"
- "看看 clawhub 上有什么好用的"
- "评估一下 XXX 插件"
- ClawHub 热门技能调研 cron 任务

## 执行流程

### Step 1: 获取技能列表（原子：exec clawhub）
- `clawhub explore` 或 `clawhub search {keyword}` 获取列表
- 按热门度/评分筛选 Top N

### Step 2: 逐个深入（原子：exec clawhub inspect）
- 对每个技能执行 `clawhub inspect {slug}` 获取详细信息
- 提取：描述、作者、安装数、依赖、脚本内容

### Step 3: 补充搜索（原子：web_search + web_fetch）
- 对感兴趣的技能，搜索 GitHub 仓库
- 查看是否有替代品或类似工具
- 评估社区活跃度（stars, issues, last commit）

### Step 4: 生成报告（原子：write）
每个技能生成独立 MD 文件，包含：
1. **技能描述** - 一句话总结
2. **功能列表** - 核心能力
3. **安装方式** - clawhub install 命令
4. **推荐评估** - 本地安装 / ECS 部署 / 不推荐
5. **替代方案** - 类似技能对比

更新 README.md 添加索引表格。

### Step 5: 推送（原子：exec）
- git push 到目标仓库

## 输出目录

- 默认: `/root/.openclaw/workspace/cc_skills/skills/`
- README: `/root/.openclaw/workspace/cc_skills/README.md`
- 推送: https://github.com/kongshan001/cc_skills
