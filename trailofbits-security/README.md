# trailofbits-security - Trail of Bits 安全技能集

> Trail of Bits 出品的 Claude Code 安全技能套件，专注代码审计、漏洞检测和安全工作流

## 📋 文档信息

- **Skill 名称**: trailofbits-security
- **GitHub**: [trailofbits/skills](https://github.com/trailofbits/skills)
- **作者**: Trail of Bits (@trailofbits)
- **许可证**: CC BY-SA 4.0
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 安全工具 / 代码审计
- **功能**: 静态分析、漏洞检测、智能合约审计、供应链安全、差分审查

---

## 1. Skill 背景需求

### 问题痛点

| 问题 | 描述 | 后果 |
|-----|------|------|
| **安全人才稀缺** | 专业安全审计成本高 | 中小企业难以负担 |
| **漏洞发现滞后** | 上线后才发现安全问题 | 修复成本高、声誉受损 |
| **代码审查效率低** | 手动审查耗时且易遗漏 | 关键漏洞被忽视 |
| **供应链风险** | 依赖项安全问题频发 | supply chain attack |

### 目标

**将 Trail of Bits 专业安全能力封装为 Claude Code Skills**：

1. **静态分析** - CodeQL、Semgrep 自动化漏洞扫描
2. **智能合约审计** - 6大区块链漏洞检测
3. **供应链审计** - 依赖项风险评估
4. **差分审查** - 代码变更安全分析
5. **变体分析** - 跨代码库漏洞追踪

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Trail of Bits Skills                     │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Smart Contract│  │   Static     │  │  Supply Chain │    │
│  │   Security    │  │   Analysis   │  │    Audit      │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Differential  │  │   Variant    │  │   Security   │    │
│  │    Review     │  │   Analysis   │  │   Review     │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │      Claude Code        │
              │   (Skill Activation)     │
              └─────────────────────────┘
```

### Skills 分类

#### 🔒 安全审计类

| Skill | 描述 |
|-------|------|
| `static-analysis` | 静态分析工具箱，支持 CodeQL、Semgrep、SARIF |
| `audit-context-building` | 构建深度架构上下文，超细粒度代码分析 |
| `differential-review` | 安全导向的代码变更审查 |
| `variant-analysis` | 跨代码库模式匹配漏洞发现 |
| `insecure-defaults` | 检测不安全默认配置、硬编码凭证 |

#### ⛓️ 智能合约类

| Skill | 描述 |
|-------|------|
| `building-secure-contracts` | 智能合约安全工具箱，6大区块链漏洞扫描 |
| `entry-point-analyzer` | 识别状态变更入口点 |
| `spec-to-code-compliance` | 规范到代码合规检查 |

#### 🛡️ 供应链安全

| Skill | 描述 |
|-------|------|
| `supply-chain-risk-auditor` | 项目依赖威胁态势审计 |
| `semgrep-rule-creator` | 自定义 Semgrep 规则创建 |
| `semgrep-rule-variant-creator` | 规则跨语言移植 |

#### 🔬 高级分析

| Skill | 描述 |
|-------|------|
| `constant-time-analysis` | 检测加密代码时序侧信道 |
| `zeroize-audit` | 检测敏感数据清零缺失 |
| `sharp-edges` | 识别错误API、危险配置、"脚枪"设计 |

#### 🧪 测试

| Skill | 描述 |
|-------|------|
| `testing-handbook-skills` | 模糊测试、静态分析、清理器、覆盖率 |
| `property-based-testing` | 多语言属性测试指南 |

---

## 3. 本地部署

### 环境要求

- Claude Code 已安装
- Git
- Python 3.8+ (部分插件需要)
- Semgrep (可选)
- CodeQL (可选)

### 安装步骤

#### 方式一：Marketplace 安装（推荐）

```bash
# 添加 marketplace
/plugin marketplace add trailofbits/skills

# 或手动安装
cd /path/to/parent
git clone https://github.com/trailofbits/skills.git
cd ..
/plugins marketplace add ./skills
```

#### 方式二：手动克隆

```bash
# 克隆仓库
git clone https://github.com/trailofbits/skills.git

# 复制到 Claude Code skills 目录
# 位置: ~/.claude/skills/ 或项目 .claude/skills/
cp -r skills ~/.claude/
```

### 验证安装

```bash
# 列出已安装的 skills
/plugin menu

# 应该看到 trailofbits/skills 中的所有插件
```

---

## 4. 使用方法

### 激活 Skills

在 Claude Code 中直接使用 skill 名称：

```bash
# 激活静态分析
@static-analysis

# 激活智能合约审计
@building-secure-contracts

# 激活供应链审计
@supply-chain-risk-auditor

# 激活差分审查
@differential-review
```

### 典型使用场景

#### 静态代码分析

```
用户: 分析这个项目的安全问题
@static-analysis

Skill 将会:
1. 运行 Semgrep 扫描
2. 解析 SARIF 结果
3. 按严重性分类漏洞
4. 提供修复建议
```

#### 智能合约审计

```
用户: 审计我的 Solidity 合约
@building-secure-contracts

Skill 将会:
1. 识别区块链类型
2. 运行漏洞扫描器
3. 检测 6 类常见漏洞
4. 生成审计报告
```

#### 供应链安全

```
用户: 检查依赖项安全
@supply-chain-risk-auditor

Skill 将会:
1. 分析 package.json/package-lock.json
2. 检查已知 CVE
3. 评估依赖可信度
4. 建议安全替代
```

#### 代码变更审查

```
用户: 审查这个 PR 的安全问题
@differential-review

Skill 将会:
1. 获取 diff
2. 分析 git 历史
3. 识别新增风险
4. 提供安全建议
```

---

## 5. 效果展示

### 输出示例

#### 静态分析结果

```markdown
## 安全扫描结果

### 高危 🔴
| 文件 | 行号 | 规则 | 描述 |
|-----|------|------|------|
| src/auth.py | 42 | G204 | 命令注入风险 |
| src/db.py | 87 | G301 | 路径遍历 |

### 中危 🟡
| 文件 | 行号 | 规则 | 描述 |
|-----|------|------|------|
| src/config.py | 15 | G402 | 硬编码密码 |

### 建议
- 使用参数化查询
- 环境变量存储敏感配置
```

#### 供应链审计

```markdown
## 供应链风险评估

### 依赖概况
- 总依赖: 127
- 直接依赖: 34
- 传递依赖: 93

### 风险发现
| 依赖 | 版本 | CVE | 严重性 |
|-----|------|-----|--------|
| lodash | 4.17.15 | CVE-2021-23337 | 高 |
| minimatch | 3.0.4 | CVE-2022-3517 | 中 |

### 建议更新
- lodash: 4.17.21
- minimatch: 3.0.5
```

---

## 6. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **专业背书** | Trail of Bits 是顶级安全公司 |
| **全面覆盖** | 20+ 插件覆盖各领域安全 |
| **开箱即用** | 无需复杂配置 |
| **持续更新** | 活跃维护，发现真实漏洞 |
| **零成本** | 完全免费 |
| **可扩展** | 支持自定义 Semgrep 规则 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **工具依赖** | 部分需要安装 Semgrep/CodeQL |
| **学习曲线** | 安全术语需要熟悉 |
| **误报可能** | 自动化工具固有特性 |
| **仅静态分析** | 无法检测运行时漏洞 |
| **无 IDE 集成** | 需要手动运行 |

---

## 7. 平替对比

| Skill | 特点 | 适用场景 |
|-------|------|---------|
| **trailofbits-security** | Trail of Bits 专业安全技能 | 企业级安全审计 |
| **superpowers** | 通用工程能力 | 日常开发工作流 |
| **ui-ux-pro-max** | UI/UX 设计 | 前端设计审查 |
| **deep-research** | 深度研究 | 市场/技术调研 |

---

## 8. 实际案例

### 发现的真实漏洞

Trail of Bits Skills 已被用于发现真实漏洞：

| Skill | 发现漏洞 |
|-------|---------|
| constant-time-analysis | [ML-DSA 签名时序侧信道](https://github.com/RustCrypto/signatures/pull/1144) |

---

## 9. 相关资源

- [GitHub 仓库](https://github.com/trailofbits/skills)
- [Trail of Bits 官网](https://www.trailofbits.com/)
- [Semgrep 文档](https://semgrep.dev/)
- [CodeQL 文档](https://codeql.github.com/)
- [Testing Handbook](https://appsec.guide/)

---

## 10. 快速开始指南

```bash
# 1. 安装 skills
cd ~/.claude
git clone https://github.com/trailofbits/skills.git

# 2. 激活使用
# 在 Claude Code 中直接使用
@static-analysis 扫描当前项目
@supply-chain-risk-auditor 检查依赖
@differential-review 审查代码变更
```

---

*让 AI 成为你的安全审计专家*
