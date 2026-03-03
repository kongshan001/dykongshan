# Claude Code Skills 调研报告 V8 - 游戏/Python/测试/开发者工具

**调研日期**: 2026-03-04  
**技能来源**: GitHub 热门仓库 + ClawHub + Antigravity Awesome Skills (970+ Skills) + VoltAgent  
**目标仓库**: https://github.com/kongshan001/cc_skills  
**状态**: ✅ 调研完成

---

## 📊 调研概要

本次调研聚焦 Claude Code 热门 Skills，覆盖以下方向：
1. 游戏客户端开发 (Unity/Godot/Unreal)
2. Python 开发 (FastAPI/异步/测试)
3. 游戏客户端自动化测试 (移动端/UI 自动化)
4. 开发者工具 (浏览器自动化/GitHub 自动化)

### 统计概览

| 指标 | 数值 |
|------|------|
| Antigravity Skills 总数 | 970+ |
| 游戏开发 Skills | 15+ |
| Python 开发 Skills | 30+ |
| 测试 Skills | 25+ |
| 本周重点分析 | 35+ Skills |
| 分类覆盖 | 4 大类 |

---

## 🎮 一、游戏客户端开发 Skills

### 1.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 星标/安装 |
|------------|------|---------|---------|
| game-development | antigravity-awesome-skills | 游戏开发编排器 (Orchestrator) | 18.5K⭐ |
| unity-developer | antigravity-awesome-skills | Unity 6 LTS 专家 | 970+ Skills |
| unity-ecs-patterns | antigravity-awesome-skills | DOTS/ECS 架构 | 高 |
| godot-gdscript-patterns | antigravity-awesome-skills | Godot 4 GDScript | 高 |
| godot-4-migration | antigravity-awesome-skills | Godot 4 迁移指南 | 中 |
| unreal-engine-cpp-pro | antigravity-awesome-skills | UE5 C++ 开发 | 高 |
| shader-programming-glsl | antigravity-awesome-skills | GLSL 着色器编程 | 中 |
| 3d-web-experience | antigravity-awesome-skills | 3D Web 体验 | 中 |

### 1.2 Game Development Orchestrator 详解

**来源**: `antigravity-awesome-skills/skills/game-development`

**核心能力**: 智能路由到子 Skills

```markdown
### 子技能路由矩阵

#### 平台选择
| 目标平台 | 子技能 |
|---------|--------|
| Web 浏览器 (HTML5/WebGL) | game-development/web-games |
| 移动端 (iOS/Android) | game-development/mobile-games |
| PC (Steam/Desktop) | game-development/pc-games |
| VR/AR 头显 | game-development/vr-ar |

#### 维度选择
| 游戏类型 | 子技能 |
|---------|--------|
| 2D (精灵/瓦片地图) | game-development/2d-games |
| 3D (网格/着色器) | game-development/3d-games |

#### 专业领域
| 需求 | 子技能 |
|------|--------|
| GDD/平衡/玩家心理 | game-development/game-design |
| 多人/网络 | game-development/multiplayer |
| 视觉风格/资产管线/动画 | game-development/game-art |
| 音效/音乐/自适应音频 | game-development/game-audio |
```

### 1.3 游戏开发核心原则

```markdown
### 1. 游戏循环 (Game Loop)
```
INPUT  → 读取玩家输入
UPDATE → 处理游戏逻辑 (固定时间步)
RENDER → 渲染帧 (插值)
```

**固定时间步规则**:
- 物理/逻辑: 固定速率 (如 50Hz)
- 渲染: 尽可能快
- 在状态之间插值以获得平滑视觉效果

### 2. 模式选择矩阵
| 模式 | 使用场景 | 示例 |
|------|---------|------|
| **状态机** | 3-5 个离散状态 | 玩家: Idle→Walk→Jump |
| **对象池** | 频繁生成/销毁 | 子弹、粒子 |
| **观察者/事件** | 跨系统通信 | 生命值→UI 更新 |
| **ECS** | 数千相似实体 | RTS 单位、粒子 |
| **命令** | 撤销、重放、网络 | 输入录制 |
| **行为树** | 复杂 AI 决策 | 敌人 AI |

### 3. 输入抽象
将输入抽象为 ACTIONS，而非原始按键:
```
"jump"  → Space, 手柄 A, 触摸点击
"move"  → WASD, 左摇杆, 虚拟摇杆
```

### 4. 性能预算 (60 FPS = 16.67ms)
| 系统 | 预算 |
|------|------|
| 输入 | 1ms |
| 物理 | 3ms |
| AI | 2ms |
| 游戏逻辑 | 4ms |
| 渲染 | 5ms |
| 缓冲 | 1.67ms |

### 5. AI 复杂度选择
| AI 类型 | 复杂度 | 使用场景 |
|---------|--------|---------|
| **FSM** | 简单 | 3-5 状态，可预测行为 |
| **行为树** | 中等 | 模块化，设计师友好 |
| **GOAP** | 高 | 涌现式，基于规划 |
| **Utility AI** | 高 | 基于评分决策 |

### 6. 碰撞策略
| 类型 | 适用场景 |
|------|---------|
| **AABB** | 矩形，快速检测 |
| **圆形** | 圆形物体，廉价 |
| **空间哈希** | 大量相似大小物体 |
| **四叉树** | 大世界，变化大小 |
```

### 1.4 Unity Developer 核心能力详解

**来源**: `antigravity-awesome-skills/skills/unity-developer`

```markdown
### 现代 Unity 掌握
- Unity 6 LTS 特性和长期支持优势
- Unity 编辑器自定义和生产力工作流
- Unity Hub 项目管理和版本控制集成
- Package Manager 和自定义包开发
- Unity Asset Store 集成和资产生管线优化

### 现代渲染管线
- URP (Universal Render Pipeline) 优化和定制
- HDRP 高保真图形
- Shader Graph 可视化着色器创建
- HLSL 着色器编程
- 后处理栈配置

### 性能优化精通
- Unity Profiler (CPU/GPU/内存分析)
- Frame Debugger 渲染管线调试
- LOD 系统和自动 LOD 生成
- 遮挡剔除和视锥剔除优化
- 纹理流式加载和资产加载优化

### 高级 C# 游戏编程
- C# 9.0+ 现代特性
- Job System 和 Burst Compiler
- DOTS/ECS 架构
- async/await 替代协程
- 内存管理和 GC 优化

### 网络 & 多人
- Unity Netcode for GameObjects
- 专用服务器架构和匹配
- 客户端-服务器同步和延迟补偿
- 跨平台多人实现

### 典型交互示例
- "使用 Unity Netcode 架构多人游戏和专用服务器"
- "使用 URP 和 LOD 系统优化移动游戏性能"
- "使用 Shader Graph 创建风格化渲染的自定义着色器"
- "为高性能游戏系统实现 ECS 架构"
```

### 1.5 Godot GDScript Patterns 核心能力

**来源**: `antigravity-awesome-skills/skills/godot-gdscript-patterns`

```markdown
### GDScript 2.0 特性
- 改进的类型推断
- @export 注解
- await/awaited signals
- 更好的性能

### 核心模式
- Signal 信号系统
- Scene 场景管理
- State Machine 状态机
- 对象池和优化

### 使用场景
- 使用 Godot 4 构建游戏
- 在 GDScript 中实现游戏系统
- 设计场景架构
- 管理游戏状态
- 优化 GDScript 性能
- 学习 Godot 最佳实践
```

### 1.6 Unreal Engine C++ Pro 核心能力

**来源**: `antigravity-awesome-skills/skills/unreal-engine-cpp-pro`

```markdown
### UE5 C++ 开发专家
- UObject 卫生和生命周期
- 性能模式
- Slate UI 系统
- 网络复制
- 蓝图集成
- Niagara VFX
- Lumen 和 Nanite
```

---

## 🐍 二、Python 开发 Skills

### 2.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 类型 |
|------------|------|---------|------|
| async-python-patterns | antigravity-awesome-skills | asyncio 异步编程 | 高级 |
| python-testing-patterns | antigravity-awesome-skills | pytest 测试策略 | 中级 |
| dbos-python | antigravity-awesome-skills | DBOS Python 框架 | 中级 |
| azure-ai-*py | antigravity-awesome-skills | Azure AI Python SDK | 企业 |
| azure-cosmos-py | antigravity-awesome-skills | Azure Cosmos DB | 企业 |
| azure-eventhub-py | antigravity-awesome-skills | Azure Event Hubs | 企业 |

### 2.2 Async Python Patterns 详解

**来源**: `antigravity-awesome-skills/skills/async-python-patterns`

```markdown
### 核心能力
- asyncio 事件循环管理
- async/await 语法
- 并发任务管理
- 异步生成器
- 异步上下文管理器
- 错误处理和取消

### 使用场景
- 构建异步 Web API (FastAPI, aiohttp, Sanic)
- 实现并发 I/O 操作 (数据库/文件/网络)
- 创建并发请求的网络爬虫
- 开发实时应用 (WebSocket 服务器/聊天系统)
- 同时处理多个独立任务
- 构建异步通信的微服务
- 优化 I/O 密集型工作负载
- 实现异步后台任务和队列

### 生态集成
- aiohttp: 异步 HTTP 客户端
- asyncpg: 异步 PostgreSQL
- aiomysql: 异步 MySQL
- aioredis: Redis 异步客户端
- FastAPI: 异步 Web 框架

### 示例代码
```python
import asyncio
from typing import List

async def fetch_data(url: str) -> dict:
    """异步获取数据"""
    await asyncio.sleep(0.1)  # 模拟 I/O
    return {"url": url, "data": "result"}

async def fetch_all(urls: List[str]) -> List[dict]:
    """并发获取所有数据"""
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

# 使用 asyncio.run() 运行
async def main():
    urls = ["https://api.example.com/1", "https://api.example.com/2"]
    results = await fetch_all(urls)
    print(results)

asyncio.run(main())
```
```

### 2.3 Python Testing Patterns 详解

**来源**: `antigravity-awesome-skills/skills/python-testing-patterns`

```markdown
### 核心能力
- pytest 测试框架
- Fixtures 测试夹具
- Mocking 模拟对象
- Parameterization 参数化
- Property-based testing 属性测试
- TDD 测试驱动开发

### 使用场景
- 为 Python 代码编写单元测试
- 设置测试套件和测试基础设施
- 实现测试驱动开发 (TDD)
- 为 API 和服务创建集成测试
- 模拟外部依赖和服务
- 测试异步代码和并发操作
- 在 CI/CD 中设置持续测试
- 实现属性测试
- 测试数据库操作
- 调试失败的测试

### 测试策略矩阵
| 策略 | 范围 | 速度 | 维护成本 |
|------|------|------|---------|
| 单元测试 | 函数/类 | 快 | 低 |
| 集成测试 | 模块/服务 | 中 | 中 |
| E2E 测试 | 完整流程 | 慢 | 高 |
| 属性测试 | 边界条件 | 中 | 低 |

### 示例代码
```python
import pytest
from unittest.mock import Mock, patch

# Fixture 示例
@pytest.fixture
def database():
    """测试数据库 fixture"""
    db = Database(":memory:")
    yield db
    db.close()

# 参数化测试
@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (2, 4),
    (3, 6),
])
def test_double(input, expected):
    assert double(input) == expected

# Mock 示例
@patch('module.external_api')
def test_with_mock(mock_api):
    mock_api.return_value = {"status": "ok"}
    result = process_api_call()
    assert result["status"] == "ok"
```
```

---

## 🧪 三、游戏客户端自动化测试 Skills

### 3.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 适用场景 |
|------------|------|---------|---------|
| e2e-testing-patterns | antigravity-awesome-skills | E2E 测试模式 | Web/移动 |
| browser-automation | antigravity-awesome-skills | 浏览器自动化 | Web 游戏 |
| playwright-skill | antigravity-awesome-skills | Playwright 自动化 | 通用 |
| go-playwright | antigravity-awesome-skills | Go Playwright | Go 技术栈 |
| azure-microsoft-playwright-testing-ts | antigravity-awesome-skills | Azure Playwright | 企业 |
| javascript-testing-patterns | antigravity-awesome-skills | JS 测试模式 | Web |
| bats-testing-patterns | antigravity-awesome-skills | Bash 测试 | Shell |
| performance-testing-review-* | antigravity-awesome-skills | 性能测试 | 性能 |

### 3.2 E2E Testing Patterns 详解

**来源**: `antigravity-awesome-skills/skills/e2e-testing-patterns`

```markdown
### 核心能力
- Playwright 和 Cypress 测试
- 可靠的测试套件构建
- 跨浏览器测试
- 响应式设计测试
- 可访问性验证
- CI/CD 测试管道

### 使用场景
- 实现端到端测试自动化
- 调试不稳定或不可靠的测试
- 测试关键用户工作流
- 设置 CI/CD 测试管道
- 跨多个浏览器测试
- 验证可访问性要求
- 测试响应式设计
- 建立 E2E 测试标准

### 测试原则
1. 识别关键用户旅程和成功标准
2. 构建稳定的选择器和测试数据策略
3. 实现带有重试、跟踪和隔离的测试
4. 在 CI 中运行并行化和工件捕获

### 安全注意事项
- 避免对生产环境运行破坏性测试
- 使用专用测试数据并清理敏感输出
```

### 3.3 Browser Automation 详解

**来源**: `antigravity-awesome-skills/skills/browser-automation`

```markdown
### 核心能力
- Playwright 自动化
- Puppeteer 自动化
- 无头浏览器
- Web 爬虫
- 浏览器测试
- E2E 测试
- UI 自动化
- Selenium 替代方案

### 核心洞察
大多数自动化失败来自三个来源：
1. 糟糕的选择器
2. 缺少等待
3. 检测系统

### 模式
1. **测试隔离模式**: 每个测试在完全隔离中运行，使用全新状态
2. **面向用户的定位器模式**: 以用户看到的方式选择元素
3. **自动等待模式**: 让 Playwright 自动等待，永远不要添加手动等待

### 反模式
❌ 任意超时
❌ CSS/XPath 优先
❌ 单一浏览器上下文用于所有内容

### 常见问题解决方案
| 问题 | 严重性 | 解决方案 |
|------|--------|---------|
| 不稳定测试 | 关键 | 移除所有 waitForTimeout 调用 |
| 选择器脆弱 | 高 | 使用面向用户的定位器 |
| 被检测 | 高 | 使用隐身插件 |
| 状态泄漏 | 高 | 每个测试必须完全隔离 |
| 调试困难 | 中 | 为失败启用跟踪 |
| 视口不一致 | 中 | 设置一致的视口 |
| 速率限制 | 中 | 在请求之间添加延迟 |
| 弹出窗口时机 | 中 | 在触发弹出窗口之前等待 |

### 相关 Skills
- agent-tool-builder
- workflow-automation
- computer-use-agents
- test-architect
```

### 3.4 Playwright Skill 详解

**来源**: `antigravity-awesome-skills/skills/playwright-skill`

```markdown
### 核心能力
- 通用浏览器自动化
- 自动检测开发服务器
- 干净的测试脚本写入 /tmp
- 测试页面、填充表单、截图
- 检查响应式设计
- 验证 UX
- 测试登录流程

### 关键工作流
1. **自动检测开发服务器** - 对于 localhost 测试，始终首先运行服务器检测
2. **写入 /tmp** - 永远不要将测试文件写入技能目录
3. **默认使用可见浏览器** - 始终使用 headless: false
4. **参数化 URL** - 始终通过环境变量或脚本顶部的常量使 URL 可配置

### 执行模式
```bash
# 步骤 1: 检测开发服务器
cd $SKILL_DIR && node -e "require('./lib/helpers').detectDevServers().then(s => console.log(JSON.stringify(s)))"

# 步骤 2: 编写测试脚本到 /tmp
# /tmp/playwright-test-page.js

# 步骤 3: 执行
cd $SKILL_DIR && node run.js /tmp/playwright-test-*.js
```

### 示例代码
```javascript
const { chromium } = require('playwright');

const TARGET_URL = 'http://localhost:3001';

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  await page.goto(TARGET_URL);
  console.log('Page loaded:', await page.title());

  // 测试交互
  await page.click('button#submit');
  await page.waitForSelector('.result');

  await browser.close();
})();
```
```

### 3.5 移动端游戏测试 Skills

```markdown
### 移动端测试相关 Skills

| Skill | 描述 |
|-------|------|
| frontend-mobile-development-component-scaffold | 移动前端组件脚手架 |
| frontend-mobile-security-xss-scan | 移动安全 XSS 扫描 |
| hig-inputs | Apple HIG 输入方法指导 |
| hig-patterns | Apple HIG 交互模式 |

### 移动端测试要点
1. **触摸输入测试**: 验证手势、多点触控
2. **性能测试**: 电池优化、内存使用
3. **兼容性测试**: 不同设备/OS 版本
4. **网络测试**: 弱网/断网恢复
5. **安装测试**: 安装/卸载/更新流程
```

---

## 🛠️ 四、开发者工具 Skills

### 4.1 核心 Skills 概览

| Skill 名称 | 来源 | 核心能力 | 安装量 |
|------------|------|---------|--------|
| browser-automation | antigravity-awesome-skills | 浏览器自动化 | 高 |
| workflow-automation | antigravity-awesome-skills | 工作流自动化 | 高 |
| autonomous-agent-patterns | antigravity-awesome-skills | 自主代理模式 | 高 |
| agent-tool-builder | antigravity-awesome-skills | 代理工具构建 | 高 |
| documentation-templates | antigravity-awesome-skills | 文档模板 | 中 |
| code-refactoring-refactor-clean | antigravity-awesome-skills | 代码重构 | 中 |

### 4.2 Workflow Automation 详解

```markdown
### 核心能力
- 自动化工作流编排
- 任务调度
- 事件驱动处理
- 多服务集成

### 常用自动化场景
1. CI/CD 管道自动化
2. 代码审查工作流
3. 部署自动化
4. 监控和告警
5. 报告生成
```

### 4.3 Autonomous Agent Patterns 详解

**来源**: `antigravity-awesome-skills/skills/autonomous-agent-patterns`

```markdown
### 核心能力
- 构建自主编码代理的设计模式
- 工具集成
- 权限系统
- 浏览器自动化
- 人在回路工作流

### 代理类型
1. **简单代理**: 单一任务执行
2. **规划代理**: 目标分解和规划
3. **反思代理**: 自我评估和改进
4. **协作代理**: 多代理协作

### 使用场景
- 需要工具集成
- 需要权限管理
- 需要浏览器交互
- 需要人工干预
```

### 4.4 其他实用 Skills

```markdown
### 文档相关
| Skill | 描述 |
|-------|------|
| documentation-templates | README、API 文档、代码注释模板 |
| documentation-generation-doc-generate | 从代码生成文档 |

### 代码质量
| Skill | 描述 |
|-------|------|
| code-refactoring-refactor-clean | 清洁代码重构 |
| codebase-cleanup-refactor-clean | 代码库清理 |

### 架构
| Skill | 描述 |
|-------|------|
| senior-architect | 全栈架构设计 |
| monorepo-architect | Monorepo 架构 |
| multi-agent-patterns | 多代理架构 |

### 安全
| Skill | 描述 |
|-------|------|
| api-security-testing | API 安全测试 |
| sql-injection-testing | SQL 注入测试 |
| pentest-checklist | 渗透测试清单 |
```

---

## 📋 五、安装和使用指南

### 5.1 安装 Antigravity Awesome Skills

```bash
# 默认安装 (Antigravity 全局)
npx antigravity-awesome-skills

# Claude Code
npx antigravity-awesome-skills --claude

# Gemini CLI
npx antigravity-awesome-skills --gemini

# Codex CLI
npx antigravity-awesome-skills --codex

# Cursor
npx antigravity-awesome-skills --cursor

# Kiro CLI/IDE
npx antigravity-awesome-skills --kiro

# 自定义路径
npx antigravity-awesome-skills --path ./my-skills
```

### 5.2 使用示例

```markdown
### 游戏开发
"Use @game-development to architect a multiplayer VR game"
"Use @unity-developer to optimize mobile game performance"
"Use @godot-gdscript-patterns to implement a state machine"

### Python 开发
"Use @async-python-patterns to build a FastAPI application"
"Use @python-testing-patterns to set up pytest test suite"

### 自动化测试
"Use @playwright-skill to test the login workflow"
"Use @browser-automation to scrape product data"
"Use @e2e-testing-patterns to set up CI testing"

### 开发者工具
"Use @workflow-automation to automate deployment"
"Use @documentation-templates to write API docs"
```

---

## 🔗 六、资源链接

### 官方仓库
- [Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills) - 970+ Skills
- [Anthropic Claude Code](https://github.com/anthropics/claude-code) - 官方 CLI
- [VoltAgent Awesome Skills](https://github.com/VoltAgent/awesome-agent-skills) - 61 高质量 Skills

### 相关文档
- [CATALOG.md](https://github.com/sickn33/antigravity-awesome-skills/blob/main/CATALOG.md) - 完整技能目录
- [USAGE.md](https://github.com/sickn33/antigravity-awesome-skills/blob/main/docs/USAGE.md) - 使用指南
- [BUNDLES.md](https://github.com/sickn33/antigravity-awesome-skills/blob/main/docs/BUNDLES.md) - 技能包
- [WORKFLOWS.md](https://github.com/sickn33/antigravity-awesome-skills/blob/main/docs/WORKFLOWS.md) - 工作流

### 社区
- [Claude Developers Discord](https://anthropic.com/discord)
- [GitHub Issues](https://github.com/sickn33/antigravity-awesome-skills/issues)

---

## 📝 七、更新日志

### V8 更新 (2026-03-04)
- 新增 Game Development Orchestrator 完整子技能路由矩阵
- 新增游戏开发核心原则 (游戏循环、模式选择、性能预算等)
- 新增 Async Python Patterns 详细说明
- 新增 Python Testing Patterns 详细说明
- 新增 E2E Testing Patterns 完整指南
- 新增 Browser Automation 模式和反模式
- 新增 Playwright Skill 使用指南
- 新增移动端游戏测试要点
- 新增开发者工具 Skills 概览
- 新增安装和使用指南

### V7 更新 (2026-03-04)
- 初始版本，包含基础 Skills 概览

---

**调研完成** ✅  
**文档版本**: V8  
**推送状态**: 待推送
