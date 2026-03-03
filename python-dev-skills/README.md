# python-dev-skills - Python 开发 Skills

> 现代 Python 3.12+ 开发实战指南

## 📋 文档信息

- **Skill 类别**: Python 开发
- **来源**: Antigravity Awesome Skills (968+ Skills)
- **定位**: Python 全栈开发全覆盖
- **状态**: ✅ 已调研

---

## 1. Skill 背景需求

### 问题痛点

- Python 生态工具更新快，需要跟上 2024/2025 最新工具链
- 类型安全日益重要，mypy/pyright 需要最佳实践
- 异步编程已成为高性能 Python 标配
- 测试策略和 DevOps 实践需要系统化

### 目标

提供覆盖 Python 开发全链路的 Skills，从语法到部署，从测试到性能优化。

---

## 2. 核心 Skills 概览

| Skill 名称 | 核心能力 | 适用场景 |
|-----------|---------|---------|
| python-pro | Python 3.12+ 全栈指南 | 通用 Python 开发 |
| python-patterns | 开发原则和决策 | 架构设计 |
| python-fastapi-development | FastAPI 后端开发 | API 服务 |
| python-development-python-scaffold | 项目脚手架 | 项目初始化 |
| python-testing-patterns | pytest/测试策略 | 质量保证 |
| python-performance-optimization | 性能分析和优化 | 性能调优 |
| python-packaging | PyPI 发布 | 库分发 |
| async-python-patterns | asyncio 异步编程 | 高并发 |
| temporal-python-pro | Temporal 工作流 | 分布式事务 |

---

## 3. Python Pro 详解

### 3.1 核心能力

```markdown
### 现代 Python 特性
- Python 3.12+ 改进的错误消息
- 模式匹配 (match statement)
- 高级类型提示和泛型
- Descriptors 和元类

### 现代工具链
- uv: 2024 最快包管理器
- ruff: 替代 black/isort/flake8
- mypy/pyright: 类型检查
- pyproject.toml: 现代标准

### Web 开发
- FastAPI 高性能 API
- Pydantic 数据验证
- SQLAlchemy 2.0+ 异步支持
- WebSocket 支持

### 性能优化
- cProfile, py-spy 性能分析
- asyncio 异步 I/O
- 多进程 CPU 并行
- 内存优化和 GC 调优
```

### 3.2 适用场景

- ✅ Python 3.12+ 项目开发
- ✅ 现代工具链迁移 (pip → uv)
- ✅ FastAPI/Django Web 开发
- ✅ 性能敏感型应用
- ✅ 生产级 Python 服务

### 3.3 典型交互

```
"Help me migrate from pip to uv for package management"
"Design a FastAPI application with proper error handling"
"Set up a modern Python project with ruff, mypy, pytest"
"Implement a high-performance data processing pipeline"
```

---

## 4. Python Patterns 详解

### 4.1 核心概念

```markdown
### 框架选择
- Web: FastAPI vs Django vs Flask
- 异步: asyncio vs trio
- ORM: SQLAlchemy vs Django ORM

### 项目结构
- 单一模块 vs 多包结构
- 依赖注入模式
- 配置管理

### 编码规范
- PEP 8 现代解释
- 类型提示最佳实践
- 文档字符串规范
```

### 4.2 适用场景

- ✅ 架构决策和技术选型
- ✅ 新项目技术规划
- ✅ 代码审查和规范

---

## 5. Python FastAPI Development 详解

### 5.1 核心能力

```markdown
### FastAPI 核心
- 路由和依赖注入
- Pydantic 模型验证
- 异步 SQLAlchemy
- JWT 认证

### 生产级特性
- OpenAPI 自动文档
- 错误处理中间件
- 日志和监控
- 部署和 Docker
```

### 5.2 适用场景

- ✅ 构建 RESTful API
- ✅ 微服务开发
- ✅ 实时 WebSocket 服务
- ✅ ML 模型服务化

---

## 6. Python Testing Patterns 详解

### 6.1 核心模式

```markdown
### 测试框架
- pytest: 主流测试框架
- Hypothesis: 属性测试
- pytest-cov: 覆盖率分析

### 测试策略
- 单元测试
- 集成测试
- 端到端测试
- TDD 开发流程

### Mock 和 Fixture
- unittest.mock
- pytest fixtures
- Factory patterns
- Test databases
```

### 6.2 适用场景

- ✅ 单元测试编写
- ✅ 测试驱动开发 (TDD)
- ✅ CI/CD 测试集成
- ✅ 测试覆盖率优化

---

## 7. Async Python Patterns 详解

### 7.1 核心能力

```markdown
### asyncio 基础
- async/await 语法
- Event loop 管理
- Task 和 Future
- 取消和超时

### 高级模式
- 并发任务管理
- 异步生成器
- 异步上下文管理器
- 错误处理

### 生态集成
- aiohttp: 异步 HTTP
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- Redis 异步客户端
```

### 7.2 适用场景

- ✅ 高并发 I/O 密集型服务
- ✅ 实时应用 (WebSocket)
- ✅ 爬虫和数据采集
- ✅ 微服务间通信

---

## 8. Python Performance Optimization 详解

### 8.1 核心工具

```markdown
### 性能分析
- cProfile: CPU 分析
- py-spy: 生产环境分析
- memory_profiler: 内存分析
- line_profiler: 行级分析

### 优化技术
- 算法优化
- 缓存策略 (functools.lru_cache)
- 数据库查询优化
- NumPy/Pandas 优化
```

### 8.2 适用场景

- ✅ 性能瓶颈诊断
- ✅ 内存泄漏排查
- ✅ 延迟优化
- ✅ 吞吐量提升

---

## 9. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **现代工具链** | 涵盖 uv、ruff、pyright 等 2024 工具 |
| **全栈覆盖** | 从开发到部署，从测试到优化 |
| **Async 优先** | 强调异步编程模式 |
| **类型安全** | 全面覆盖类型提示最佳实践 |
| **生产级** | 包含 Docker、K8s、CI/CD 内容 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **工具迭代快** | 部分工具可能已更新 |
| **深度不足** | 偏向概览，需要结合文档深入 |
| **学习曲线** | 需要熟悉现代 Python 特性 |

---

## 10. 平替对比

| Skill/Tool | 特点 | 适用场景 |
|-----------|------|---------|
| **python-pro** | Python 3.12+ 全面指南 | 通用开发 |
| **python-fastapi-development** | FastAPI 专精 | API 开发 |
| **python-testing-patterns** | 测试最佳实践 | 质量保证 |
| **async-python-patterns** | 异步编程 | 高并发 |
| **python-type-safety** | 类型系统详解 | 类型安全 |
| Real Python 教程 | 深入但分散 | 特定主题学习 |

---

## 11. 落地过程

### 11.1 快速开始

```bash
# 安装 Skills
npx antigravity-awesome-skills --claude

# 使用 Python 开发
>> /python-pro 帮助我设计一个 FastAPI 项目结构

# 类型检查
>> /python-type-safety 审查这个模块的类型提示

# 性能优化
>> /python-performance-optimization 分析这个函数的性能
```

### 11.2 推荐学习路径

```
1. 基础: python-patterns (开发原则)
2. 工具: python-pro (现代工具链)
3. Web: python-fastapi-development (API 开发)
4. 测试: python-testing-patterns (质量保证)
5. 进阶: async-python-patterns (高并发)
6. 优化: python-performance-optimization (性能)
```

### 11.3 项目实践

对于 game-frame-sync 项目（Python 后端）：
- 使用 `python-pro` 搭建项目结构
- 使用 `python-fastapi-development` 开发 API
- 使用 `python-testing-patterns` 编写测试
- 使用 `async-python-patterns` 处理高并发连接

---

## 📎 相关链接

- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)
- [Python 官方文档](https://docs.python.org/3/)
- [FastAPI 文档](https://fastapi.tiangolo.com/)
- [uv 包管理器](https://github.com/astral-sh/uv)
- [ruff 工具](https://github.com/astral-sh/ruff)
