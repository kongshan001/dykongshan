# cc_devops_skills - DevOps 工程技能集

> 31 个 Claude Code DevOps 技能，覆盖 IaC、CI/CD、容器编排、可观测性等

## 📋 文档信息

- **Skill 名称**: cc-devops-skills
- **GitHub**: [akin-ozer/cc-devops-skills](https://github.com/akin-ozer/cc-devops-skills)
- **作者**: akin-ozer (@akin-ozer)
- **许可证**: Apache 2.0
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / DevOps / 自动化工具
- **功能**: 基础设施即代码生成与验证、CI/CD 流水线、容器编排、可观测性配置

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **配置复杂** | DevOps 工具配置项繁多，学习成本高 | 配置错误导致部署失败 |
| **最佳实践难寻** | 各技术栈最佳实践分散 | 生成配置不符合生产标准 |
| **验证困难** | 缺少自动化验证工具 | 上线后才发现问题 |
| **版本更新快** | K8s、Terraform 等版本迭代快 | 文档过时导致配置不兼容 |

### 目标

**将 DevOps 专家知识封装为可复用的 Skill**：

1. **生成器** - 从零创建生产级配置文件
2. **验证器** - 自动检查语法、安全、最佳实践
3. **调试器** - 诊断和修复运行中的问题
4. **版本感知** - 自动获取最新文档

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code                               │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Generator   │  │  Validator   │  │   Debugger   │      │
│  │   Skills     │  │   Skills     │  │   Skills     │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                  │               │
│         ▼                 ▼                  ▼               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Context7 MCP Server                      │  │
│  │         (自动获取 CRD、Provider 文档)                  │  │
│  └──────────────────────────────────────────────────────┘  │
│         │                 │                  │               │
│         ▼                 ▼                  ▼               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Terraform   │  │ hadolint     │  │   kubectl    │      │
│  │ Ansible     │  │ tflint       │  │   kubectx    │      │
│  │ Helm        │  │ actionlint   │  │   Stern      │      │
│  │ Docker      │  │ shellcheck   │  │   k9s        │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### 技能分类

#### 按功能分类

| 类型 | 数量 | 说明 |
|------|------|------|
| **生成器** | 15 | 从零创建配置文件 |
| **验证器** | 15 | 验证语法、安全、最佳实践 |
| **调试器** | 1 | 诊断 K8s 集群问题 |

#### 按技术领域分类

```
基础设施即代码 (IaC)
├── Terraform (generator, validator)
├── Terragrunt (generator, validator)
└── Ansible (generator, validator)

容器与编排
├── Dockerfile (generator, validator)
├── Kubernetes (generator, validator, debug)
└── Helm (generator, validator)

CI/CD 流水线
├── GitHub Actions (generator, validator)
├── GitLab CI (generator, validator)
├── Jenkins (generator, validator)
└── Azure Pipelines (generator, validator)

可观测性
├── PromQL (generator, validator)
├── LogQL (generator)
├── Fluent Bit (generator, validator)
└── Loki Config (generator)

构建与脚本
├── Makefile (generator, validator)
└── Bash Script (generator, validator)
```

---

## 3. 本地部署

### 环境要求

- Claude Code 最新版
- Homebrew (macOS) 或对应 Linux 包管理器
- Python 3.8+ (部分验证工具需要)

### 安装步骤

#### 方法 1: 插件市场安装 (推荐)

```bash
# 添加插件市场
/plugin marketplace add akin-ozer/cc-devops-skills

# 安装插件
/plugin install devops-skills@akin-ozer
```

#### 方法 2: 手动安装

```bash
# 克隆仓库
git clone https://github.com/akin-ozer/cc-devops-skills.git

# 复制到 Claude Code 配置目录
cp -r cc-devops-skills/devops-skills-plugin ~/.claude/plugins/
```

### 必需工具安装

#### macOS (Homebrew)

```bash
# 核心工具
brew install terraform tflint terragrunt helm kubeconform kubectl yamllint
brew install hadolint actionlint act shellcheck prometheus

# Python 工具
pip install ansible-lint checkov yamllint

# 可选工具
brew install yq fluent-bit
helm plugin install https://github.com/databus23/helm-diff
```

#### Linux

```bash
# Python 工具
pip install ansible-lint checkov yamllint

# 其他工具 - 参照各工具官方文档
# 大多数工具在 GitHub 提供二进制发布
```

### MCP 服务器 (推荐)

| MCP Server | 用途 | 使用的 Skills |
|------------|------|---------------|
| **Context7** | 获取最新的 CRD、Terraform providers、Ansible collections 文档 | k8s-generator, helm-generator, terraform-generator, ansible-generator |

---

## 4. 使用方法

### 调用 Skill

直接在对话中请求：

```
使用 dockerfile-generator skill 为我的 Node.js 应用创建 Dockerfile
```

或验证现有文件：

```
使用 terraform-validator 验证我的 terraform 配置
```

### 生成器 + 验证器 工作流

大多数技能成对出现 (生成器 + 验证器)：

1. **生成器** 创建符合最佳实践的资源
2. **验证器** 检查语法错误、安全问题、最佳实践
3. **生成器** 修复任何验证错误
4. **最终输出** 是生产级且经过验证的

### 典型使用场景

#### 生成 Dockerfile
```
Use dockerfile-generator to create a Dockerfile for my Python FastAPI application with Python 3.11
```

#### 验证 Terraform
```
Validate my terraform configuration using terraform-validator
```

#### 调试 K8s
```
Use k8s-debug to troubleshoot my pod that's stuck in CrashLoopBackOff
```

#### 生成 GitHub Actions
```
Generate a GitHub Actions workflow for a Node.js CI/CD pipeline
```

---

## 5. 技能详情

### 基础设施即代码

| Skill | 描述 | 验证工具 |
|-------|------|---------|
| `terraform-generator` | 生成符合最佳实践的 Terraform 配置 | terraform validate, tflint, checkov |
| `terraform-validator` | 验证 Terraform 配置的语法和安全性 | terraform fmt/validate, tflint |
| `terragrunt-generator` | 为多环境部署生成 Terragrunt 配置 | terragrunt validate |
| `terragrunt-validator` | 验证 Terragrunt 配置和 DRY 模式 | terragrunt validate, hclfmt |
| `ansible-generator` | 生成生产级 Ansible playbooks、roles、tasks | ansible-lint |
| `ansible-validator` | 验证 Ansible playbooks 和 roles | ansible-lint, ansible-playbook --check |

### 容器与编排

| Skill | 描述 | 验证工具 |
|-------|------|---------|
| `dockerfile-generator` | 生成生产级 Dockerfile，含多阶段构建和安全加固 | hadolint, checkov |
| `dockerfile-validator` | 验证 Dockerfile 的安全性 | hadolint, checkov |
| `k8s-generator` | 生成 K8s YAML 清单，自动查找 CRD 文档 | kubeconform, yamllint |
| `k8s-yaml-validator` | 验证 K8s 清单 | kubeconform, yamllint |
| `k8s-debug` | 使用系统化故障排查工作流调试 K8s 集群问题 | kubectl |
| `helm-generator` | 生成 Helm charts，含正确的模板化和 values | helm lint, kubeconform |
| `helm-validator` | 验证 Helm charts | helm lint, kubeconform |

### CI/CD 流水线

| Skill | 描述 | 验证工具 |
|-------|------|---------|
| `github-actions-generator` | 生成 GitHub Actions workflows 和 custom actions | actionlint |
| `github-actions-validator` | 验证 GitHub Actions workflows | actionlint, act |
| `gitlab-ci-generator` | 生成 GitLab CI/CD pipelines | gitlab-ci-lint |
| `gitlab-ci-validator` | 验证 GitLab CI/CD 配置 | gitlab-ci-lint, yamllint |
| `jenkinsfile-generator` | 为 Declarative 和 Scripted pipeline 语法生成 Jenkinsfiles | jenkins-cli |
| `jenkinsfile-validator` | 验证 Jenkinsfile pipelines | jenkins-cli, pipeline linting |
| `azure-pipelines-generator` | 为 CI/CD 工作流生成 Azure DevOps Pipelines | az CLI |
| `azure-pipelines-validator` | 验证 Azure DevOps Pipeline 配置 | az CLI, YAML validation |

### 可观测性

| Skill | 描述 | 验证工具 |
|-------|------|---------|
| `promql-generator` | 为 Prometheus 监控和告警生成 PromQL 查询 | promtool |
| `promql-validator` | 验证 PromQL 查询的语法 | promtool |
| `logql-generator` | 为 Loki 日志分析生成 LogQL 查询 | - |
| `loki-config-generator` | 为日志聚合生成 Loki 配置文件 | - |
| `fluentbit-generator` | 为日志收集和转发 pipelines 生成 Fluent Bit 配置 | fluent-bit --dry-run |
| `fluentbit-validator` | 验证 Fluent Bit 配置 | fluent-bit --dry-run |

### 构建与脚本

| Skill | 描述 | 验证工具 |
|-------|------|---------|
| `makefile-generator` | 为构建自动化生成最佳实践 Makefiles | make -n |
| `makefile-validator` | 验证 Makefiles 的语法 | make -n |
| `bash-script-generator` | 生成具有正确错误处理和可移植性的 bash 脚本 | shellcheck |
| `bash-script-validator` | 验证 bash 脚本的语法和安全性 | shellcheck |

---

## 6. 效果展示

### 输出示例: Dockerfile Generator

```
Use dockerfile-generator to create a Dockerfile for a Node.js 20 Express API
```

生成结果：

```dockerfile
# Multi-stage build for Node.js Express API
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 3: Runner
FROM node:20-alpine AS runner
WORKDIR /app

# Security: non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodejs

COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

USER nodejs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:3000/health', r => process.exit(r.statusCode === 200 ? 0 : 1))"

CMD ["node", "dist/index.js"]
```

### 输出示例: Terraform Generator

```
Generate a Terraform configuration for an AWS ECS Fargate service with ALB
```

生成结果包含：
- main.tf (Fargate 集群、服务、任务定义)
- variables.tf (可配置参数)
- outputs.tf (输出值)
- outputs.tfstate (远程状态配置)
- .terraform-version

---

## 7. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|------|------|
| **全面覆盖** | 31 个技能，覆盖主流 DevOps 工具 |
| **自动验证** | 生成器自动运行验证器，确保输出正确 |
| **版本感知** | 通过 Context7 MCP 获取最新文档 |
| **最佳实践** | 内置安全加固、性能优化等最佳实践 |
| **成对设计** | 生成器 + 验证器确保生产就绪 |
| **多平台支持** | 支持 GitHub Actions、GitLab CI、Jenkins、Azure Pipelines |

### ❌ 缺点

| 缺点 | 说明 |
|------|------|
| **工具依赖** | 需要安装大量 CLI 工具 |
| **学习曲线** | 工具较多，需要时间熟悉 |
| **MCP 可选** | Context7 MCP 需额外配置 |
| **非中文** | 文档和 Skill 均为英文 |

---

## 8. 平替对比

| Skill | 特点 | 适用场景 |
|-------|------|---------|
| **cc-devops-skills** | 31 个 DevOps 技能，覆盖 IaC/CI/CD/可观测性 | DevOps 工程师日常 |
| **trailofbits-security** | 安全审计，CodeQL/Semgrep | 安全审计场景 |
| **fullstack-dev-skills** | 66 个全栈开发技能 | Web 应用开发 |
| **superpowers** | 68k⭐ 通用工程技能 | 通用软件开发 |

---

## 9. 错误处理

| 错误 | 原因 | 解决方案 |
|-----|------|---------|
| `command not found: terraform` | 工具未安装 | 运行 `brew install terraform` |
| `ansible-lint not found` | 验证工具缺失 | `pip install ansible-lint` |
| `Validation failed` | 生成的配置有问题 | Skill 会自动修复，或检查需求是否合理 |
| `Context7 MCP not configured` | 未配置 MCP | 跳过自动文档查找，或配置 MCP |

---

## 10. 落地过程

### 安装验证

1. **安装插件**
   ```bash
   /plugin marketplace add akin-ozer/cc-devops-skills
   /plugin install devops-skills@akin-ozer
   ```

2. **安装必要工具**
   ```bash
   brew install terraform helm kubectl hadolint actionlint shellcheck
   pip install ansible-lint checkov yamllint
   ```

3. **验证安装**
   ```bash
   # 测试 Terraform
   /test terraform-validator
   
   # 测试 Docker
   /test dockerfile-validator
   ```

### 实际使用

1. 告诉 Claude 使用特定技能
2. 提供需求详情
3. 等待生成 + 自动验证
4. 检查输出，根据反馈调整

---

## 11. 相关资源

- [GitHub 仓库](https://github.com/akin-ozer/cc-devops-skills)
- [Awesome Claude Code 提及](https://github.com/hesreallyhim/awesome-claude-code)
- [Context7 MCP Server](https://context7.com)
- [Terraform 官方文档](https://www.terraform.io/docs)
- [Kubernetes 官方文档](https://kubernetes.io/docs)
- [Docker 最佳实践](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---

## 12. 按经验等级分类

| 等级 | Skills |
|------|--------|
| **入门级** | dockerfile-generator, bash-script-generator, makefile-generator |
| **中级** | terraform-generator, ansible-generator, github-actions-generator, k8s-generator |
| **高级** | helm-generator, terragrunt-generator, k8s-debug, promql-generator |

---

*让 Claude Code 成为你的 DevOps 专家助手*
