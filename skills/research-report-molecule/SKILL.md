# 调研报告生成器 (Molecule)

> **层级**: Molecule（分子技能）
> **组合**: web_search + web_fetch + sessions_spawn + write + exec(git)
> **用途**: 给定一个调研主题，自动搜索、深度阅读、生成结构化报告并推送到 GitHub

## 触发条件

用户要求调研某个主题并生成报告，例如：
- "调研 XXX 并生成报告"
- "帮我研究一下 XXX"
- "XXX 的调研报告"

## 执行流程

### Step 1: 搜索收集（原子：web_search）
- 用 web_search 搜索主题，获取 5-10 个相关链接
- 快速扫描搜索结果，筛选出最有价值的 3-5 个来源

### Step 2: 深度阅读（原子：web_fetch）
- 对筛选出的来源逐一 web_fetch，提取完整内容
- 每个来源限制 maxChars=8000，避免信息过载

### Step 3: 结构化生成（原子：write）
- 综合所有来源，生成 Markdown 报告
- 报告结构：
  1. **概述** - 一段话总结
  2. **背景** - 为什么重要
  3. **核心内容** - 分点详细阐述
  4. **实践建议** - 可落地的行动项
  5. **参考链接** - 所有来源 URL
- 保存到 `/root/.openclaw/workspace/research-reports/{topic-slug}.md`

### Step 4: 推送（原子：exec）
- git add -A && git commit -m "docs: {topic} 调研报告" && git push

## 质量控制

- 如果搜索结果不足 3 个，换关键词重试一次
- 报告字数目标：1500-3000 字
- 必须包含至少 3 个不同来源
- 推送前检查 Markdown 格式是否正确

## 目标仓库

- **默认**: https://github.com/kongshan001/research-reports
- 用户指定其他仓库时优先使用用户指定的
