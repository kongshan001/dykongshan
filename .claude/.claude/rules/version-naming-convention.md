# Version Naming Convention

## 编号
R-007

## 描述
版本记录文件必须使用 `v{X.Y.Z}.md` 命名格式，其中:
- `v` 前缀为必须（小写）
- `X.Y.Z` 为语义化版本号（MAJOR.MINOR.PATCH）
- 文件名必须匹配正则: `^v\d+\.\d+\.\d+\.md$`

示例:
- `v0.1.0.md` — 正确
- `v1.2.3.md` — 正确
- `0.5.0.md` — 错误（缺少 v 前缀）
- `V0.1.0.md` — 错误（v 必须小写）

## 适用范围
- `.claude/skills/kanban/versions/` 目录（`.kanban/versions/` 为指向该目录的 symlink）下的所有版本记录文件
- `kanban_version_record` 函数生成的文件自动遵循此规范
- CHANGELOG.md 中的引用路径应使用相同的 `v{X.Y.Z}.md` 格式

## 检查方法
`kanban_check_version_naming` 函数扫描 `.claude/skills/kanban/versions/` 目录（`.kanban/versions/` 为指向该目录的 symlink），报告不符合规范的文件。`kanban_version_list` 在列出版本时自动执行此检查，输出命名警告。

`kanban_version_record` 函数在传入 version 参数时自动补全 v 前缀（如果缺失），确保生成的文件名始终符合规范。

## 违反后果
命名不规范的文件会在 `kanban_version_list` 输出中产生警告。长期遗留的不规范文件应在下一个涉及版本记录的任务中修正。
