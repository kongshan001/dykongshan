# developer-tools-skills - 开发者工具 Skills

> 提升开发效率的自动化工具集

## 📋 文档信息

- **Skill 类别**: 开发者工具
- **来源**: Antigravity Awesome Skills (968+ Skills)
- **定位**: 开发工作流自动化
- **状态**: ✅ 已调研

---

## 1. Skill 背景需求

### 问题痛点

- 重复性开发任务消耗大量时间
- GitHub/GitLab 操作需要手动完成
- 浏览器自动化测试和爬虫需要专业指导
- CI/CD 工作流配置复杂

### 目标

提供覆盖开发全链路的自动化 Skills，从代码管理到部署，从浏览器自动化到 API 集成。

---

## 2. 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 | 评分 |
|-----------|---------|---------|------|
| browser-automation | 浏览器自动化 | 测试/爬虫 | 高 |
| github | GitHub 基础操作 | PR/Issue/Workflow | 3.790 |
| openclaw-github-assistant | OpenClaw GitHub 助手 | 增强 GitHub 操作 | **3.615** 🆕 |
| github-cli | GitHub CLI | 命令行操作 | 3.501 |
| github-workflow-automation | GitHub Actions | CI/CD | 高 |
| docker-essentials | Docker 基础 | 容器化 | 3.694 |
| docker | Docker 完整版 | 容器管理 | 3.577 |
| docker-sandbox | Docker 沙箱 | 安全测试 | 3.548 |
| docker-ctl | Docker 控制 | 容器控制 | **3.531** 🆕 |
| docker-compose | Docker Compose | 多容器编排 | 3.511 |
| docker-diag | Docker 诊断 | 问题排查 | **3.474** 🆕 |
| gitlab-automation | GitLab 自动化 | 项目管理 | 高 |
| cicd-automation-workflow-automate | CI/CD 自动化 | 流水线 | 高 |
| changelog-automation | Changelog 生成 | 版本发布 | 高 |
| test-fixing | 测试修复 | 失败测试 | 高 |
| cli-tool-development | CLI 工具开发 | 工具构建 | 高 |

---

## 3. Browser Automation 详解

### 3.1 核心概念

```markdown
### 基础原理
- 元素定位策略 (CSS/XPath/ARIA)
- 等待策略 (显式/隐式/智能)
- 页面对象模式
- 测试隔离
```

### 3.2 工具对比

| 工具 | 特点 | 适用场景 |
|------|------|---------|
| **Playwright** | 跨浏览器、API 丰富 | 现代 Web 测试 |
| **Puppeteer** | Chrome 专用、轻量 | 爬虫/截图 |
| **Selenium** | 历史悠久、生态广 | 遗留项目 |
| **Cypress** | 调试友好、实时重载 | 开发测试 |

### 3.3 核心模式

```markdown
### 可靠的选择器
1. data-testid (推荐)
2. ARIA roles
3. 文本内容
4. CSS 类名 (慎用)

### 等待策略
- 避免硬编码 sleep
- 使用智能等待
- 显式等待条件

### 反模式
- 避免脆弱的 XPath
- 避免顺序依赖
- 避免全局状态
```

### 3.4 适用场景

- ✅ Web 应用自动化测试
- ✅ 浏览器爬虫
- ✅ 截图和文档生成
- ✅ 表单自动填写

---

## 4. GitHub Automation 详解

### 4.1 核心能力

```markdown
### 仓库管理
- 创建/删除仓库
- 分支保护规则
- 团队和权限管理

### Issue 管理
- 创建/关闭/编辑
- 标签管理
- 指派和里程碑

### Pull Request
- 创建和审查
- 自动合并
- 冲突解决
- CI 状态检查

### Actions
- 触发工作流
- 查看运行状态
- Artifacts 管理
```

### 4.2 典型交互

```
"Create a new issue for the bug"
"Automatically label new PRs"
"Run tests on PR and report results"
"Set up branch protection rules"
```

### 4.3 OpenClaw GitHub Assistant 详解 (评分: 3.615)

**来源**: ClawHub

```markdown
### 核心能力
- 增强 GitHub 操作
- PR 管理
- Issue 自动化
- 仓库配置

### 适用场景
- ✅ 自动化 PR 流程
- ✅ Issue 管理和分类
- ✅ 仓库维护
```

### 4.4 适用场景

- ✅ 自动化 PR 流程
- ✅ Issue 管理和分类
- ✅ CI/CD 触发
- ✅ 仓库配置

---

## 5. GitHub Workflow Automation 详解

### 5.1 核心能力

```markdown
### 工作流设计
- 触发条件配置
- Matrix 构建
- 依赖缓存
- Artifacts

### 自动化
- PR 自动审查
- Issue 分类
- 自动标签
- 发布管理

### 最佳实践
- 失败快速反馈
- 并行执行
- 缓存优化
- 安全扫描
```

### 5.2 适用场景

- ✅ CI/CD 流水线
- ✅ 自动化代码审查
- ✅ 发布自动化
- ✅ 安全扫描

---

## 6. CI/CD Automation Workflow 详解

### 6.1 核心概念

```markdown
### 流水线阶段
1. 源码检出
2. 依赖安装
3. 代码构建
4. 测试执行
5. 部署发布

### 最佳实践
- 幂等性
- 快速失败
- 日志清晰
- 制品管理
```

### 6.2 工具集成

```markdown
### GitHub Actions
- YML 配置
- Marketplace Actions
- 环境变量
- 秘密管理

### GitLab CI
- .gitlab-ci.yml
- Runner 配置
- Auto DevOps

### Jenkins
- Pipeline as Code
- 分布式构建
- 插件生态
```

### 6.3 适用场景

- ✅ 持续集成/部署
- ✅ 自动化测试
- ✅ 制品管理
- ✅ 环境配置

---

## 6.5 Docker Skills 专题

### 6.5.1 Docker Essentials (评分: 3.694)

**来源**: ClawHub

```markdown
### 核心能力
- Dockerfile 最佳实践
- 镜像构建优化
- 多阶段构建
- 容器网络配置
- 安全加固

### 适用场景
- ✅ 容器化应用部署
- ✅ 开发环境标准化
- ✅ 微服务封装
```

### 6.5.2 Docker CTL (评分: 3.531)

**来源**: ClawHub

```markdown
### 核心能力
- 容器生命周期管理
- 镜像操作
- 网络和存储管理
- 日志查看

### 适用场景
- ✅ 容器日常运维
- ✅ 快速问题排查
- ✅ 批量操作
```

### 6.5.3 Docker Diag (评分: 3.474)

**来源**: ClawHub

```markdown
### 核心能力
- 容器诊断
- 资源分析
- 问题定位
- 性能监控

### 适用场景
- ✅ 容器故障排查
- ✅ 性能瓶颈分析
- ✅ 健康检查
```

---

## 7. Changelog Automation 详解

### 7.1 核心能力

```markdown
### 自动生成
- 从 Git commits 提取
- 从 PR 合并提取
- 按类型分类 (feat/fix/docs)

### 格式标准
- Keep a Changelog 格式
- 语义化版本
- 发布说明

### 自动化
- 标签触发
- 发布时自动生成
- 多语言支持
```

### 7.2 适用场景

- ✅ 版本发布
- ✅ 变更追踪
- ✅ 发布说明生成

---

## 8. Test Fixing 详解

### 8.1 核心流程

```markdown
### 失败测试处理
1. 运行测试获取失败
2. 智能错误分组
3. 分析失败原因
4. 逐个修复
5. 验证修复

### 常见问题
- 断言错误
- 导入失败
- 异步超时
- 环境差异
```

### 8.2 适用场景

- ✅ 修复 CI 失败
- ✅ 测试维护
- ✅ 回归测试

---

## 9. CLI Tool Development 详解

### 9.1 核心能力

```markdown
### Python CLI
- Click: 命令行应用
- Argparse: 标准库
- Typer: 现代选择

### 特性
- 参数解析
- 子命令
- 样式输出
- 自动文档
```

### 9.2 适用场景

- ✅ 内部工具开发
- ✅ 自动化脚本
- ✅ DevOps 工具

---

## 10. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **全链路覆盖** | 从代码到部署全覆盖 |
| **自动化** | 减少手动重复工作 |
| **多平台** | GitHub/GitLab 都支持 |
| **最佳实践** | 包含成熟的工作流模式 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **权限限制** | 部分操作需要 Token |
| **复杂性** | CI/CD 配置学习曲线 |
| **维护** | 自动化脚本需要维护 |

---

## 11. 平替对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| **browser-automation** | 浏览器自动化 | 测试/爬虫 |
| **github-automation** | GitHub 操作 | 仓库管理 |
| **github-workflow-automation** | Actions 自动化 | CI/CD |
| **changelog-automation** | Changelog | 发布 |
| **hub CLI** | GitHub CLI | 手动操作 |
| **gh CLI** | GitHub 官方 | 基础操作 |

---

## 12. 落地过程

### 12.1 快速开始

```bash
# 安装 Skills
npx antigravity-awesome-skills --claude

# 浏览器自动化
>> /browser-automation 帮助我自动化这个表单

# GitHub 自动化
>> /github-automation 创建一个 release 工作流

# CI/CD
>> /cicd-automation-workflow-automate 设置 CI 流水线
```

### 12.2 推荐学习路径

```
1. 基础: browser-automation
2. Git: github-automation / github-workflow-automation
3. 部署: cicd-automation-workflow-automate
4. 发布: changelog-automation
5. 维护: test-fixing
```

### 12.3 项目实践

对于 game-frame-sync 项目：
- 使用 `github-workflow-automation` 设置 CI/CD
- 使用 `browser-automation` 测试 Web 管理后台
- 使用 `changelog-automation` 自动生成发布说明

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Playwright 文档](https://playwright.dev/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Keep a Changelog](https://keepachangelog.com/)
