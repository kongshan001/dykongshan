# Kanban Framework 自定义 Workflow 功能问题报告

## 📋 基本信息
- **问题类型**: Bug Report / Feature Request
- **影响版本**: v0.67.x 及以上
- **优先级**: High
- **组件**: Custom Workflow Extensions

## 🔍 问题描述

Kanban Framework 的自定义 workflow 功能（通过 `workflow.json` 的 `extensions` 字段配置）存在多个关键问题，严重影响用户体验和功能稳定性。

### 核心问题概述
基于深度代码分析，发现以下 5 个主要问题：

1. **配置验证问题**（High Priority）
2. **工作流状态管理问题**（High Priority）  
3. **步骤级产物验证缺陷**（Medium-High Priority）
4. **Agent类型管理问题**（Medium Priority）
5. **文档和示例不足**（Medium Priority）

## 🐛 详细问题描述

### 1. 配置验证问题 ⚠️

#### 问题描述
当前缺乏完善的配置验证机制，可能导致：
- **JSON 语法错误**：用户输入错误的 JSON 格式，框架启动时静默失败
- **字段类型不匹配**：如 `agent_type` 不是预定义类型，执行时才发现错误
- **循环依赖**：步骤间的依赖关系可能形成循环，导致死锁
- **无效阶段引用**：引用不存在的阶段名称，工作流异常终止

#### 具体表现
```json
{
  "extensions": {
    "add_steps": [
      {
        "phase": "non_existent_phase",  // 引用不存在的阶段
        "step": {
          "id": "pylint",
          "agent_type": "invalid_agent_type",  // 无效的 agent 类型
          "required_artifacts": ["non_existent_path/*.md"]  // 无效路径
        }
      }
    ]
  }
}
```

#### 影响程度
**高**：直接影响工作流程的正常执行，可能导致任务失败

### 2. 步骤级产物验证缺陷 ⚠️

#### 问题描述
`required_artifacts` 功能存在验证缺陷：
- **路径解析错误**：相对路径与绝对路径处理不一致
- **文件存在性检查延迟**：在步骤执行后才验证，而非执行前
- **产物格式验证缺失**：只检查文件存在性，不验证文件内容格式
- **清理机制缺失**：验证失败的产物没有自动清理机制

#### 具体表现
```json
{
  "extensions": {
    "add_steps": [
      {
        "phase": "execute",
        "step": {
          "id": "pylint",
          "required_artifacts": [
            "reports/pylint.json",  // 相对路径解析问题
            "reports/coverage.html"  // 格式验证缺失
          ]
        }
      }
    ]
  }
}
```

#### 影响程度
**中高**：影响任务执行效率和资源利用

### 3. Agent类型管理问题 ⚠️

#### 问题描述
自定义步骤中的 `agent_type` 管理存在问题：
- **Agent 类型枚举不完整**：没有提供可用的 Agent 类型列表
- **Agent 动态加载机制缺失**：新 Agent 的注册和发现机制不完善
- **Agent 能力匹配缺失**：没有验证 Agent 是否具备执行特定任务的能力

#### 具体表现
用户不知道可以使用哪些 Agent 类型，指定了不存在的 Agent 类型，执行时才发现错误。

#### 影响程度
**中**：影响任务执行的成功率

### 4. 工作流状态管理问题 ⚠️

#### 问题描述
自定义步骤的 FSM 状态管理存在缺陷：
- **状态转换规则不明确**：自定义步骤与 FSM 原有状态的转换规则不清晰
- **回滚机制缺失**：自定义步骤失败时缺乏有效的回滚机制
- **并发控制不足**：多个自定义步骤同时执行时的冲突处理

#### 具体表现
自定义步骤执行失败后，工作流处于不确定状态，无法回滚到之前的状态。

#### 影响程度
**高**：影响工作流程的可靠性和一致性

### 5. 文档和示例不足 ⚠️

#### 问题描述
自定义 workflow 功能的文档支持不足：
- **API 文档不完整**：缺少详细的配置参数说明
- **最佳实践缺失**：没有提供配置最佳实践指导
- **错误处理指南不足**：缺乏常见错误的解决方案
- **示例配置过少**：只有基础示例，缺少复杂场景的示例

#### 共体表现
用户不知道如何正确配置，配置错误时难以排查问题，学习曲线陡峭。

#### 影响程度
**中**：影响用户体验和功能采用率

## 💡 建议的解决方案

### 1. 配置验证增强

#### 实时配置验证
```json
{
  "extensions": {
    "add_steps": [
      {
        "phase": "execute",
        "step": {
          "id": "pylint",
          "description": "执行 pylint 检查",
          "agent_type": "general-purpose",
          "spawn_prompt": "对 $output_dir/ 下所有 Python 文件执行 pylint...",
          "required_artifacts": ["pylint_report.md"],
          "validation_rules": {
            "agent_type": ["general-purpose", "specialized"],
            "required_artifacts": [".+\\.md$"],
            "phase": ["execute", "evaluate"]
          }
        }
      }
    ]
  }
}
```

#### 配置验证工具
```bash
kanban workflow validate --config workflow.json
kanban workflow lint --config workflow.json
```

### 2. 产物验证增强

#### 前置验证机制
```python
def validate_artifacts_before_execution(step_config):
    for artifact in step_config.get('required_artifacts', []):
        if not validate_artifact_format(artifact):
            raise ValidationError(f"Invalid artifact format: {artifact}")
        if not check_artifact_dependencies(artifact):
            raise ValidationError(f"Missing dependencies for artifact: {artifact}")
```

### 3. Agent 管理增强

#### Agent 类型注册机制
```json
{
  "agent_registry": {
    "general-purpose": {
      "description": "通用 Agent",
      "capabilities": ["code_generation", "file_management", "testing"],
      "load_path": "/path/to/agent.py"
    },
    "specialized": {
      "description": "专业 Agent",
      "capabilities": ["code_analysis", "performance_optimization"],
      "load_path": "/path/to/special_agent.py"
    }
  }
}
```

### 4. 工作流状态管理增强

#### 状态转换规则
```json
{
  "state_transitions": {
    "execute": {
      "custom_step": {
        "success": ["evaluate"],
        "failure": ["retry_execute"],
        "max_retries": 3
      }
    }
  }
}
```

### 5. 文档和示例增强

#### 配置模板生成
```bash
kanban workflow template --type python-lint > workflow.json
kanban workflow template --type security-scan > workflow.json
kanban workflow template --type performance-test > workflow.json
```

## 📊 实施优先级

### 高优先级（1-2周）
1. **配置验证问题** - 实现实时配置验证机制
2. **工作流状态管理问题** - 添加回滚机制和状态转换规则

### 中优先级（3-4周）
3. **步骤级产物验证缺陷** - 实现前置验证和清理机制
4. **Agent类型管理问题** - 实现Agent类型注册机制

### 低优先级（1-2个月）
5. **文档和示例不足** - 完善文档和示例

## 🔍 复现步骤

1. 创建带有无效配置的 `workflow.json`
2. 运行 `kanban dashboard start`
3. 观察配置加载时的静默失败
4. 尝试执行自定义步骤，观察异常行为

## 📈 预期收益

- **提高可靠性**：减少配置错误导致的工作流失败
- **提升用户体验**：提供清晰的错误提示和验证反馈
- **增强可维护性**：完善的文档和示例降低使用门槛
- **提高开发效率**：减少调试时间，加快问题定位

## 📎 相关文件

- 相关分析报告：https://github.com/kongshan001/research-reports/kanban-framework-custom-workflow-analysis.md
- 配置文档位置：`.claude/skills/kanban/config/workflow.json`
- Dashboard 编辑器：`dashboard-step-editor-demo.gif`

---

**报告生成时间**: 2026年5月31日  
**分析工具**: 深度代码分析 + 架构评估  
**联系人**: 基于深度分析的自动化报告