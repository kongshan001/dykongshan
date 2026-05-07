# Kanban Framework Versions

This directory stores version records for the kanban framework.

## Location

- **Canonical path**: `.claude/skills/kanban/versions/`
- **Backward-compat symlink**: `.kanban/versions/` -> `../.claude/skills/kanban/versions`

After TASK-046 (ST-008), version management was internalized into the skills directory.
The `.kanban/versions/` symlink is maintained for backward compatibility.

## File Naming

Version files follow `v{X.Y.Z}.md` naming (per R-007):
- `v0.1.0.md` — initial release
- `v0.2.0.md` — feature enhancement
- etc.

## Auto Version Recording

When a task is archived (via `kanban_archive_task`), the system automatically:
1. Checks if the task involved framework file changes
2. Determines the bump type (PATCH for fixes, MINOR for features, MAJOR for breaking changes)
3. Computes the next version number
4. Creates a version record file and updates CHANGELOG.md

Manual recording is also available via `/kanban version record <version>`.
