# claude-scientific-skills - AI 科学研究助手技能集

> 将 Claude Code 转变为跨学科 AI 科学家，支持生物信息、药物发现、临床研究、材料科学等领域

## 📋 文档信息

- **Skill 名称**: claude-scientific-skills
- **GitHub**: [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills)
- **Star**: ⭐ (增长中)
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: Agent Skills / 科学计算 / 跨学科研究

---

## 1. Skill 背景需求

### 问题痛点

科学研究中 AI 助手面临的核心挑战：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **环境配置复杂** | 科学计算需要大量专业库 | 研究人员浪费大量时间配置环境 |
| **数据库分散** | 250+ 生物学、化学、医学数据库 | 不知道如何高效查询 |
| **跨学科门槛高** | 需要结合多个领域知识 | 难以开展多学科交叉研究 |
| **工作流复杂** | 多步骤pipeline需要协调 | 从数据到论文产出周期长 |
| **缺乏文档** | API 和工具使用困难 | 大部分时间在读文档而非做研究 |

### 目标

Claude Scientific Skills 旨在：

1. **开箱即用** - 跳过环境配置，直接开始研究
2. **统一数据库访问** - 250+ 数据库一键查询
3. **多学科融合** - 打破生物、化学、医学、计算机之间的壁垒
4. **端到端工作流** - 从数据到发表级别图表/报告
5. **最佳实践** - 经过验证的分析流程和代码示例

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────────┐
│                Claude Scientific Skills 架构                      │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                      148+ Scientific Skills                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   生物学     │  │   化学      │  │   医学      │             │
│  │ • 生物信息学  │  │ • 化学信息学  │  │ • 临床研究   │             │
│  │ • 基因组学   │  │ • 药物发现   │  │ • 精准医学   │             │
│  │ • 蛋白质组学 │  │ • 分子对接   │  │ • 医学影像   │             │
│  │ • 多组学    │  │ • ADMET    │  │ • EHR分析   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   机器学习   │  │   材料科学   │  │   金融      │             │
│  │ • PyTorch   │  │ • 晶体结构  │  │ • SEC报告   │             │
│  │ • scikit    │  │ • 相图分析  │  │ • 美债数据   │             │
│  │ • 时间序列  │  │ • 计算化学  │  │ • 对冲基金   │             │
│  │ • 贝叶斯    │  │ • 天文学    │  │ • 市场数据   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                     250+ Data Sources                            │
├──────────────────────────────────────────────────────────────────┤
│  PubMed  │  ChEMBL  │  UniProt  │  AlphaFold  │  ClinicalTrials │
│  ClinVar │  COSMIC  │  PDB      │  KEGG      │  Reactome       │
│  Ensembl │  NCBI    │  GEO      │  OpenTargets│  ...           │
└──────────────────────────────────────────────────────────────────┘
```

### 技能分类详解

#### 🧬 生物信息学 & 基因组学

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 序列分析 | DNA/RNA/蛋白质序列处理 | BioPython, pysam, scikit-bio |
| 单细胞分析 | 10X Genomics 数据处理 | Scanpy, AnnData, scvi-tools |
| 变异注释 | VCF 文件注释 | Ensembl VEP, ClinVar, COSMIC |
| 基因发现 | 基因注释和查询 | NCBI Gene, UniProt, Ensembl |
| 网络分析 | 蛋白互作网络 | STRING, KEGG, Reactome |

#### 🧪 化学信息学 & 药物发现

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 分子操作 | 分子结构处理 | RDKit, Datamol, Molfeat |
| 虚拟筛选 | 化合物库筛选 | PubChem, ZINC, DiffDock |
| ADMET 预测 | 药物动力学预测 | DeepChem, MedChem |
| 分子对接 | 蛋白-配体结合预测 | DiffDock, AutoDock |
| 类药性分析 | 药物相似性评估 | RDKit, ZINC |

#### 🏥 临床研究 & 精准医学

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 临床试验 | 试验搜索和分析 | ClinicalTrials.gov |
| 变异解读 | 临床意义解读 | ClinVar, ClinPGx |
| 药物安全 | 不良事件查询 | FDA Databases |
| 精准治疗 | 匹配靶向治疗 | Open Targets |
| 临床决策 | 治疗方案建议 | Clinical Decision Support |

#### 🤖 机器学习 & AI

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 深度学习 | 神经网络训练 | PyTorch Lightning, Transformers |
| 经典 ML | 分类/回归/聚类 | scikit-learn, SHAP |
| 时间序列 | 时序预测分析 | aeon |
| 贝叶斯方法 | 概率建模 | PyMC |
| 图神经网络 | 图结构数据 | Torch Geometric |

#### 📊 数据分析 & 可视化

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 统计分析 | 假设检验/功效分析 | statsmodels, scipy |
| 可视化 | 出版级图表 | Matplotlib, Seaborn, Plotly |
| 网络可视化 | 生物网络图 | NetworkX |
| 文档处理 | PDF/DOCX 报告生成 | Document Skills |
| 数据处理 | 大规模数据处理 | Dask, Polars |

#### 🔬 实验室自动化

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 液体处理 | 自动化移液 | Opentrons, PyLabRobot |
| 协议管理 | 实验协议 | Protocols.io |
| LIMS 集成 | 实验室信息管理 | Benchling, LabArchives |
| 云实验室 | 云端实验执行 | Ginkgo Cloud Lab |

#### 📚 科学传播

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| 文献综述 | 论文搜索和综述 | PubMed, OpenAlex, bioRxiv |
| 科学写作 | 论文撰写 | Scientific Writing |
| 同行评审 | 审稿支持 | Peer Review |
| 演示制作 | 幻灯片/海报 | Scientific Slides, LaTeX |
| 引用管理 | 文献引用 | Citation Management |

#### 💰 金融研究 (新增)

| Skill 类别 | 覆盖内容 | 关键工具 |
|------------|---------|---------|
| SEC  filings | 公司财务报告 | edgartools |
| 美债数据 | 财政数据 | usfiscaldata |
| 对冲基金 | 基金监控 | hedgefundmonitor |
| 市场数据 | 股票/外汇 | alpha-vantage |

### Skill 结构

每个 Skill 包含：
- **SKILL.md** - 完整文档
- **代码示例** - 可运行的示例代码
- **使用案例** - 典型工作流
- **最佳实践** - 官方推荐用法
- **集成指南** - 如何与其他工具组合

---

## 3. 本地部署

### 前置要求

| 要求 | 详情 |
|------|------|
| Python | 3.9+ (推荐 3.12+) |
| 包管理器 | uv (必需) |
| 客户端 | Cursor / Claude Code / Codex |
| 系统 | macOS / Linux / Windows + WSL2 |

### 安装 uv

```bash
# macOS / Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# 或通过 pip
pip install uv
```

### 安装 Skills

#### 全局安装 (推荐)

```bash
# 克隆仓库
git clone https://github.com/K-Dense-AI/claude-scientific-skills.git

# 复制到 Claude Code
cp -r claude-scientific-skills/scientific-skills/* ~/.claude/skills/

# 复制到 Cursor
cp -r claude-scientific-skills/scientific-skills/* ~/.cursor/skills/
```

#### 项目级安装

```bash
# 在项目目录下
mkdir -p .claude/skills
cp -r /path/to/claude-scientific-skills/scientific-skills/* .claude/skills/
```

### 验证安装

安装完成后，Claude Code 会自动发现这些 Skills。你可以直接使用：

```
"帮我查询 ChEMBL 中 EGFR 抑制剂，并用 RDKit 分析构效关系"
```

---

## 4. 效果展示

### 示例 1: 药物发现工作流

```
用户: Find novel EGFR inhibitors for lung cancer treatment

Claude 使用 Skills:
- ChEMBL: 查询 IC50 < 50nM 的 EGFR 抑制剂
- RDKit: 分析构效关系 (SAR)
- datamol: 生成改进的化合物类似物
- DiffDock: 虚拟筛选 (对接 AlphaFold EGFR 结构)
- PubMed: 搜索耐药机制
- COSMIC: 查找癌症突变
- 可视化: 生成综合报告
```

### 示例 2: 单细胞分析

```
用户: Comprehensive analysis of 10X Genomics data with public data integration

Claude 使用 Skills:
- Scanpy: 加载 10X 数据，QC，双细胞去除
- Cellxgene Census: 整合公共数据
- NCBI Gene: 使用标记基因鉴定细胞类型
- PyDESeq2: 差异表达分析
- Arboreto: 推断基因调控网络
- Reactome/KEGG: 通路富集
- Open Targets: 识别治疗靶点
```

### 示例 3: 多组学整合

```
用户: Integrate RNA-seq, proteomics, and metabolomics to predict patient outcomes

Claude 使用 Skills:
- PyDESeq2: RNA-seq 分析
- pyOpenMS: 质谱数据处理
- HMDB/Metabolomics Workbench: 代谢物注释
- UniProt/KEGG: 蛋白-通路映射
- STRING: 蛋白互作
- statsmodels: 多组学相关性
- scikit-learn: 预测模型
- ClinicalTrials.gov: 匹配临床试验
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|------|------|
| **覆盖面极广** | 148+ Skills 覆盖几乎所有科学研究领域 |
| **250+ 数据库** | 统一的数据库访问接口 |
| **开箱即用** | 跳过环境配置，立即开始研究 |
| **跨学科融合** | 轻松组合不同领域的工具 |
| **端到端工作流** | 从数据到发表级输出的完整流程 |
| **活跃维护** | 持续更新，跟进最新科学工具 |
| **社区活跃** | Slack 社区支持，企业版可用 |

### ⚠️ 缺点

| 缺点 | 说明 |
|------|------|
| **学习曲线** | Skills 太多，需要时间了解全部能力 |
| **依赖云 GPU** | 复杂计算需要云端资源 (可选 K-Dense Web) |
| **数据库限制** | 部分数据库有 API 速率限制 |
| **认证要求** | 某些服务需要 API Key |
| **离线受限** | 数据库 Skills 需要网络连接 |

### 适用场景

| 场景 | 推荐度 |
|------|--------|
| 药物发现与虚拟筛选 | ⭐⭐⭐⭐⭐ |
| 基因组学/转录组分析 | ⭐⭐⭐⭐⭐ |
| 临床数据分析 | ⭐⭐⭐⭐ |
| 材料科学研究 | ⭐⭐⭐⭐ |
| 金融数据分析 | ⭐⭐⭐⭐ |
| 日常编程辅助 | ⭐⭐ (非科学领域可选其他 Skills) |

---

## 6. 平替对比

| Skill 集 | 特点 | 适用场景 |
|----------|------|---------|
| **Claude Scientific Skills** | 148+ Skills, 250+ DBs, 全学科覆盖 | 跨学科科学研究 |
| **trailofbits-security** | 20+ 安全技能, CodeQL/Semgrep | 代码安全审计 |
| **superpowers** | SDLC 全流程, 68k⭐ | 通用软件工程 |
| **fullstack-dev-skills** | 65+ Skills, 12 类技术栈 | Web/全栈开发 |
| **deep-research** | 深度研究, Gemini | 市场/学术研究 |

---

## 7. 落地过程

### 2026-03-03: 调研完成

- [x] 获取 Claude Scientific Skills 仓库信息
- [x] 分析 Skills 架构和覆盖领域
- [x] 整理部署方法
- [x] 编写调研文档
- [x] 推送到 cc_skills 仓库

### 下一步行动

- [ ] 在本地环境安装并测试
- [ ] 尝试一个完整的药物发现工作流
- [ ] 探索与其他 Skills 的组合可能

---

## 8. 参考资源

- [GitHub 仓库](https://github.com/K-Dense-AI/claude-scientific-skills)
- [官方文档](https://k-dense.ai)
- [Agent Skills 标准](https://agentskills.io/)
- [K-Dense Web (云端版本)](https://k-dense.ai)
- [Slack 社区](https://join.slack.com/t/k-densecommunity/)

---

*让 Claude 成为您的 AI 科学家*
