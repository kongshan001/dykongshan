# 代码问题修复器 (Molecule)

> **层级**: Molecule（分子技能）
> **组合**: read + exec(lint/test) + edit + exec(test) + exec(git)
> **用途**: 自动发现并修复代码质量问题，确保测试通过后提交

## 触发条件

- 用户报告某个代码问题（bug、lint 错误、测试失败）
- HEARTBEAT 触发代码质量检查
- 用户说"修复这个 bug"、"lint 报错了"等

## 执行流程

### Step 1: 定位问题（原子：read + exec）
- 如果有错误信息，先定位到具体文件和行号
- 用 `read` 查看问题代码上下文（前后各 20 行）
- 用 `exec` 运行 lint/test 复现问题

### Step 2: 修复（原子：edit）
- 用 `edit` 精确修改，不要重写整个文件
- 一次只修一个问题，修完立即验证
- 如果修复涉及多处，按依赖顺序逐个修改

### Step 3: 验证（原子：exec）
- 重新运行失败的 lint/test
- 如果仍有失败，回到 Step 2
- 最多重试 3 轮，超过则报告给用户

### Step 4: 提交（原子：exec）
- git add -A && git commit -m "fix: {简短描述}" && git push
- 自动推送，不需要询问

## 质量控制

- 修改前必须先复现问题
- 修改后必须验证问题已解决
- 不引入新的 lint 警告
- 不降低测试覆盖率
