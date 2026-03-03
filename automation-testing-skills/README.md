# automation-testing-skills - 自动化测试 Skills

> AI 驱动的现代测试自动化实战指南

## 📋 文档信息

- **Skill 类别**: 自动化测试
- **来源**: Antigravity Awesome Skills (968+ Skills)
- **定位**: 全链路测试自动化
- **状态**: ✅ 已调研

---

## 1. Skill 背景需求

### 问题痛点

- 测试维护成本高，UI 变化导致测试频繁失败
- 传统自动化缺乏智能，需要 AI 增强
- 游戏客户端测试特殊，需要游戏特定框架
- 单元测试、集成测试、E2E 测试需要统一策略

### 目标

提供覆盖各类型测试的 Skills，从 AI 驱动测试到传统框架，从单元测试到 E2E。

---

## 2. 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| test-automator | AI 驱动测试自动化 | 智能测试生成 |
| testing-qa | 综合 QA 工作流 | 质量保证 |
| e2e-testing-patterns | Playwright/Cypress | 端到端测试 |
| python-testing-patterns | pytest 最佳实践 | Python 测试 |
| testing-patterns | Jest 测试模式 | JS/TS 测试 |
| unit-testing-test-generate | 单元测试生成 | 测试覆盖 |
| test-driven-development | TDD 开发流程 | 测试先行 |
| webapp-testing | Web 应用测试 | 本地测试 |
| api-testing-observability | API Mock | API 测试 |

---

## 3. Test Automator 详解

### 3.1 核心能力

```markdown
### AI 驱动测试
- Self-healing tests (Testim, Applitools)
- NLP 测试生成
- ML 失败预测
- 视觉 AI 测试

### 现代化框架
- Playwright 跨浏览器
- Appium 移动测试
- API 测试 (Postman, Karate)
- 性能测试 (K6, JMeter)

### CI/CD 集成
- Jenkins/GitLab CI/GitHub Actions
- 并行执行优化
- 容器化测试环境
- 动态测试选择

### 高级测试
- 混沌工程
- 安全测试集成
- 属性测试和模糊测试
- 变异测试
```

### 3.2 TDD 特别支持

```markdown
### 红绿重构循环
1. 写失败的测试 (Red)
2. 验证失败原因 (Verify)
3. 最小代码通过 (Green)
4. 重构改进 (Refactor)

### TDD 模式
- Chicago School: 状态测试
- London School: 交互测试
- Outside-in: 验收驱动
- Inside-out: 单元驱动
- Double-loop: 双循环
```

### 3.3 适用场景

- ✅ 构建企业级测试自动化
- ✅ AI 增强测试维护
- ✅ 大规模测试套件管理
- ✅ CI/CD 质量门禁

### 3.4 典型交互

```
"Design a comprehensive test automation strategy"
"Set up self-healing tests with Testim"
"Implement parallel test execution in CI/CD"
```

---

## 4. E2E Testing Patterns 详解

### 4.1 Playwright 核心

```markdown
### 基础操作
- 元素定位和等待
- 表单交互
- 导航和路由
- 截图和录制

### 高级特性
- 视觉回归测试
- 跨浏览器测试
- 移动端模拟
- API 拦截

### 最佳实践
- 可靠的元素选择器
- 智能等待策略
- Page Object 模式
- 测试隔离
```

### 4.2 Cypress 核心

```markdown
### 特性
- 实时重载
- 自动等待
- 调试友好
- 网络控制
```

### 4.3 适用场景

- ✅ Web 应用 E2E 测试
- ✅ 视觉回归检测
- ✅ 跨浏览器兼容性
- ✅ 持续集成测试

---

## 5. Python Testing Patterns 详解

### 5.1 pytest 核心

```markdown
### 基础
- 测试发现规则
- assert 语句
- fixture 生命周期
- parametrize 参数化

### 高级
- 标记 (markers)
- 钩子 (hooks)
- 插件系统
- 配置 pytest.ini

### Mock
- unittest.mock
- pytest-mock
- 依赖注入
```

### 5.2 测试策略

```markdown
### 测试金字塔
       /\
      /  \     E2E (少量)
     /----\   Integration (中等)
    /      \  Unit (大量)
   /________\

### 测试分类
- 单元测试: 快速、独立
- 集成测试: 模块交互
- E2E: 完整用户流程
```

### 5.3 适用场景

- ✅ Python 项目测试
- ✅ TDD 开发实践
- ✅ 测试覆盖率提升
- ✅ CI 测试集成

---

## 6. Testing QA 详解

### 6.1 完整 QA 工作流

```markdown
### 测试类型
- 单元测试
- 集成测试
- E2E 测试
- 性能测试
- 安全测试
- 可访问性测试

### 质量指标
- 测试覆盖率
- 缺陷密度
- MTTR (修复时间)
- 回归率
```

### 6.2 适用场景

- ✅ 建立 QA 流程
- ✅ 测试策略规划
- ✅ 质量度量

---

## 7. 游戏客户端测试专题

### 7.1 测试挑战

```markdown
### 游戏特定挑战
- 帧同步/状态同步测试
- 网络延迟模拟
- 随机性验证
- 性能基准测试

### 客户端测试
- UI 交互测试
- 资源加载测试
- 存档/回放测试
- 多平台兼容
```

### 7.2 测试工具

```markdown
### 自动化框架
- Unity Test Framework
- Unreal Automation System
- Godot Testing

### 性能测试
- 帧率监控
- 内存分析
- 网络带宽测试
- 加载时间测试
```

---

## 8. Playwright 高级专题

### 8.1 核心特性

```markdown
### 自动化能力
- 自动检测开发服务器
- 编写测试脚本到 /tmp
- 默认使用可见浏览器
- URL 参数化配置

### 常见模式
- 页面测试 (多视口)
- 登录流程测试
- 表单填写和提交
- 链接检查
- 响应式设计测试
```

### 8.2 快速开始

```bash
# 首次安装
cd $SKILL_DIR && npm run setup

# 检测开发服务器
cd $SKILL_DIR && node -e "require('./lib/helpers').detectDevServers().then(s => console.log(JSON.stringify(s)))"

# 执行测试
cd $SKILL_DIR && node run.js /tmp/playwright-test-*.js
```

### 8.3 典型交互

```
"测试这个登录流程"
"检查响应式设计"
"验证表单提交"
```

---

## 8. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **AI 增强** | Self-healing 和智能测试生成 |
| **全链路** | 单元到 E2E 全面覆盖 |
| **多框架** | Playwright/Cypress/pytest 都有 |
| **CI/CD** | 深度集成持续集成 |
| **TDD** | 完整测试驱动开发支持 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **复杂度** | 工具链较多，学习成本高 |
| **维护** | E2E 测试维护仍是挑战 |
| **游戏测试** | 游戏特定测试 Skills 较少 |

---

## 9. 平替对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| **test-automator** | AI 驱动企业级 | 大规模测试 |
| **e2e-testing-patterns** | Playwright/Cypress | Web E2E |
| **python-testing-patterns** | pytest 最佳实践 | Python 测试 |
| **testing-patterns** | Jest 模式 | JS/TS 测试 |
| **Selenium** | 传统框架 | 遗留项目 |
| **Cypress** | 现代框架 | Web 测试 |

---

## 10. 落地过程

### 10.1 快速开始

```bash
# 安装 Skills
npx antigravity-awesome-skills --claude

# E2E 测试
>> /e2e-testing-patterns 帮助我设置 Playwright 测试

# Python 测试
>> /python-testing-patterns 编写这个模块的单元测试

# TDD 开发
>> /test-driven-development 使用 TDD 开发这个功能
```

### 10.2 推荐学习路径

```
1. 基础: testing-patterns / python-testing-patterns
2. E2E: e2e-testing-patterns
3. 进阶: test-automator (AI 驱动)
4. 流程: test-driven-development
5. 质量: testing-qa
```

### 10.3 项目实践

对于 game-frame-sync 项目：
- 使用 `python-testing-patterns` 测试核心同步逻辑
- 使用 `e2e-testing-patterns` 测试 API 端点
- 使用 `test-driven-development` 开发新功能

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Playwright 文档](https://playwright.dev/)
- [Cypress 文档](https://www.cypress.io/)
- [pytest 文档](https://docs.pytest.org/)
