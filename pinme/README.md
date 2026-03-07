# pinme - 零配置前端部署工具

> 一键部署前端应用到 IPFS 网络

## 📋 文档信息

- **Skill 名称**: pinme
- **GitHub**: [glitternetwork/pinme](https://github.com/glitternetwork/pinme)
- **Star**: 2939 ⭐
- **状态**: ✅ 已调研
- **调研日期**: 2026-03-03
- **分类**: 部署工具 / Claude Code Skill / IPFS

---

## 1. Skill 背景需求

### 问题痛点

前端开发者经常面临以下部署问题：

| 问题 | 描述 | 后果 |
|-----|------|------|
| **配置复杂** | 需要手动配置服务器、域名、CDN | 部署门槛高 |
| **账号管理** | 需要注册 Vercel、Netlify 等平台账号 | 流程繁琐 |
| **版本控制** | 传统托管商可能导致静默篡改 | 安全性低 |
| **维护成本** | 需要管理服务器、监控 uptime | 运维负担 |

### 目标

让前端部署变得**极其简单**：

1. **零配置** - 无需服务器、账号、设置
2. **一键部署** - 一个命令完成上传
3. **可验证内容** - 基于 IPFS，内容可验证
4. **免费使用** - 基础功能完全免费

---

## 2. 设计方案

### 核心架构

```
┌─────────────────────────────────────────────────────────────┐
│                      PinMe 部署架构                          │
└─────────────────────────────────────────────────────────────┘

   用户代码                PinMe CLI                  IPFS 网络
  ┌─────────┐           ┌──────────┐              ┌──────────┐
  │ dist/   │ ───────▶  │ pinme    │ ──────────▶  │ 分布式    │
  │ build/  │           │ upload   │              │ 存储      │
  │ out/    │           │ dist     │              │ (内容寻址) │
  └─────────┘           └──────────┘              └──────────┘
                              │
                              ▼
                       ┌──────────┐
                       │ 预览链接  │
                       │ pinme.   │
                       │ eth.limo │
                       └──────────┘
```

### 技术特点

| 特性 | 说明 |
|-----|------|
| **IPFS 存储** | 内容寻址，文件变更自动生成新 CID |
| **ENS 域名** | 使用 ENS 子域名，Web3 原生 |
| **零服务器** | 无需维护服务器，PinMe 处理可用性 |
| **内容可验证** | 基于 IPFS hash，可验证内容未被篡改 |

### 支持的框架

| 目录 | 框架 |
|-----|------|
| `dist/` | Vite, Vue CLI, Angular |
| `build/` | Create React App |
| `out/` | Next.js (静态导出) |
| `public/` | 纯静态站点 |

### Claude Code Skill 集成

PinMe 提供了专门的 AI 执行协议，让 Claude Code 可以自动完成部署：

```json
{
  "tool": "pinme",
  "requirements": {
    "node_version": ">=16.13.0"
  },
  "install": "npm install -g pinme",
  "upload": "pinme upload {{directory}}",
  "validDirectories": ["dist", "build", "out", "public"],
  "requiredFiles": ["index.html"],
  "excludePatterns": ["node_modules", ".env", ".git", "src"],
  "output": "preview_url",
  "preview_url_format": "https://pinme.eth.limo/#/preview/*"
}
```

---

## 3. 本地部署

### 前置要求

| 要求 | 说明 |
|-----|------|
| **Node.js** | 16.13.0 或更高版本 |
| **npm/yarn** | 包管理器 |

### 安装步骤

```bash
# 使用 npm
npm install -g pinme

# 或使用 yarn
yarn global add pinme

# 验证安装
pinme --version
```

### 部署流程

#### 步骤 1: 构建项目

```bash
# Vite/React/Vue 项目
npm run build

# Next.js 静态导出
npm run build
```

#### 步骤 2: 部署

```bash
# 上传 dist 目录
pinme upload dist

# 或上传 build 目录
pinme upload build

# 或上传 out 目录 (Next.js)
pinme upload out

# 交互式上传
pinme upload
```

#### 步骤 3: 获取链接

部署成功后返回预览链接：
```
https://pinme.eth.limo/#/preview/<hash>
```

### 域名绑定（VIP）

```bash
# 绑定 PinMe 子域名
pinme bind ./dist --domain my-site
# 结果: https://my-site.pinit.eth.limo

# 绑定自定义 DNS 域名
pinme bind ./dist --domain example.com
# 结果: https://example.com
```

### Windows 部署

> 同样的命令，在 PowerShell 或 CMD 中运行

```powershell
# PowerShell
npm install -g pinme
pinme upload dist
```

### GitHub Actions 集成

```yaml
# .github/workflows/deploy.yml
name: Deploy to PinMe

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build
        
      - name: Deploy to PinMe
        run: npx pinme upload dist
```

---

## 4. 效果展示

### Skill 触发示例

```
用户: "帮我部署这个网站"

AI (自动执行):
"我来帮你部署这个前端项目。

1️⃣ 检查环境...
   ✅ Node.js v20.11.0 已安装

2️⃣ 识别构建目录...
   ✅ 发现 dist/ 目录
   ✅ 包含 index.html

3️⃣ 部署到 IPFS...
   ✅ 上传成功

🎉 部署完成！
🔗 预览链接: https://pinme.eth.limo/#/preview/bafybei...

→ 只需一个命令，网站已上线
```

### 部署对比

| 平台 | 配置要求 | 账号 | 域名 | 免费 |
|-----|---------|-----|-----|-----|
| **PinMe** | 0 | ❌ | 子域名 | ✅ |
| Vercel | 1 | ✅ | ✅ | ✅ |
| Netlify | 1 | ✅ | ✅ | ✅ |
| GitHub Pages | 2 | ✅ | ❌ | ✅ |

### 实际使用场景

#### 场景 1: AI 生成页面部署

```
用户: "用 HTML 写一个 landing page 并部署"

AI:
1. 创建 index.html
2. npm run build (或直接创建)
3. pinme upload .
4. 返回: https://pinme.eth.limo/#/preview/abc123
```

#### 场景 2: React 项目部署

```
用户: "部署这个 React 项目"

AI:
1. 检查 package.json → 发现 Vite
2. npm run build → 生成 dist/
3. pinme upload dist
4. 返回预览链接
```

---

## 5. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **零配置** | 无需任何设置，注册即可用 |
| **无需账号** | 不需要注册任何平台账号 |
| **免费使用** | 基础功能完全免费 |
| **IPFS 存储** | 内容可验证，防篡改 |
| **快速部署** | 通常 10-30 秒完成 |
| **AI 集成** | Claude Code Skill 原生支持 |
| **ENS 域名** | Web3 原生域名，无需备案 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **国内访问** | 依赖 IPFS 国内节点覆盖 |
| **域名限制** | 自定义域名需要 VIP |
| **首次加载** | IPFS 首次可能较慢（需要 P2P 节点） |
| **冷启动** | 长时间无访问可能需要重新获取 |
| **删除不彻底** | 删除只从 PinMe 节点移除，不保证全网删除 |

### 适用场景

| 场景 | 适用度 |
|-----|-------|
| AI 生成页面快速部署 | ⭐⭐⭐⭐⭐ |
| 静态网站托管 | ⭐⭐⭐⭐ |
| 演示/预览链接 | ⭐⭐⭐⭐⭐ |
| Web3 项目 | ⭐⭐⭐⭐⭐ |
| 长期运营网站 | ⭐⭐⭐ |
| 大型文件托管 | ⭐⭐ |

---

## 6. 平替对比

| 工具 | 特点 | 免费 | 账号 | IPFS |
|-----|------|-----|-----|-----|
| **PinMe** | 零配置 + AI 集成 | ✅ | ❌ | ✅ |
| **Vercel** | 功能完善 + CI/CD | ✅ | ✅ | ❌ |
| **Netlify** | 功能丰富 + 表单 | ✅ | ✅ | ❌ |
| **Cloudflare Pages** | 全球 CDN | ✅ | ✅ | ❌ |
| **IPFS.io** | 纯 IPFS | ✅ | ❌ | ✅ |

### PinMe vs Vercel

| 特性 | PinMe | Vercel |
|-----|-------|--------|
| 配置 | 零 | 少量 |
| 账号 | 不需要 | 需要 |
| CI/CD | 无 | 自动 |
| 自定义域名 | VIP | 免费 |
| Serverless | 无 | 有 |
| AI 集成 | 原生 | 无 |

---

## 7. 落地过程

### 调研日期
2026-03-03

### 调研结果

#### 🔍 技术定位

PinMe 是一个**零配置前端部署工具**，基于 IPFS 网络存储内容，提供可验证的部署方案。

#### 📝 关键发现

1. **一键部署**
   - 只需 `pinme upload <dir>`
   - 自动检测构建目录
   - 支持多种框架

2. **Claude Code 原生支持**
   - 提供 AI 执行协议
   - 自动识别静态文件目录
   - 返回标准化预览链接

3. **IPFS 优势**
   - 内容寻址，版本自动管理
   - 防篡改，可验证
   - 分布式存储

4. **VIP 功能**
   - 自定义子域名绑定
   - 自定义 DNS 域名
   - 优先支持

#### ✅ 验证结果

| 验证项 | 结果 | 说明 |
|-------|------|------|
| 安装成功 | ✅ | npm 安装正常 |
| 基本功能 | ✅ | 上传部署正常 |
| 预览链接 | ✅ | 返回正确的链接格式 |
| AI 集成 | ✅ | 支持 Claude Code Skill |
| 免费使用 | ✅ | 基础功能无需付费 |

### 使用建议

1. **快速原型** - AI 生成页面立即部署
2. **演示链接** - 临时分享非常方便
3. **Web3 项目** - 天然适合 NFT、DApp
4. **长期项目** - 考虑 VIP 域名绑定

---

## 8. 常见问题

### Q: PinMe 是免费的吗？
A: 是的，基础功能完全免费。VIP 功能（自定义域名）需要付费。

### Q: 部署的文件会永远存在吗？
A: 免费用户上传的内容会保留，但建议重要内容做好备份。VIP 内容有更好的持久性保证。

### Q: 国内访问速度如何？
A: PinMe 正在扩展国内节点。首次加载可能稍慢，之后会缓存。

### Q: 如何绑定自己的域名？
A: 需要 VIP 会员，然后使用 `pinme bind ./dist --domain your-domain` 命令。

### Q: 和 Vercel 有什么区别？
A: PinMe 更简单（零配置），但功能也相对少（无 Serverless）。适合简单静态部署。

### Q: 适合生产环境吗？
A: 对于简单静态网站可以用于生产，但对于需要高可用、功能丰富的网站，建议使用 Vercel 或 Cloudflare Pages。

---

## 📎 相关链接

- [GitHub](https://github.com/glitternetwork/pinme)
- [官网](https://pinme.eth.limo/)
- [文档](https://pinme.eth.limo/#/docs)
- [npm](https://www.npmjs.com/package/pinme)

---

*一键部署前端到 IPFS* 🚀
