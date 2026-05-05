# Kanban Framework - Quick Start Guide

## 5-Step Quick Start

1. **Initialize**: `/kanban init`
2. **Create task**: `/kanban create "Task title" --desc "Description"`
3. **Run task**: `/kanban run TASK-NNN`
4. **Review results**: Check evaluation scores and iteration summary
5. **Archive**: `/kanban decide TASK-NNN --action approve_and_archive`

## Core Commands

| Command | Description |
|---------|-------------|
| `/kanban init` | Initialize .kanban/ directory |
| `/kanban create "<title>"` | Create a new task |
| `/kanban status` | View kanban board |
| `/kanban show TASK-NNN` | View task details |
| `/kanban run TASK-NNN` | Run task through FSM flow |
| `/kanban decide TASK-NNN --action <action>` | User decision |
| `/kanban score TASK-NNN` | View evaluation scores |
| `/kanban dashboard start` | Start web dashboard |

## FSM Flow

```
Plan → Execute → Evaluate → User Decision → Archive
  ↑__________________|                        ↓
  (hot/full iteration)
```

## Agent Roles

| Role | Responsibility |
|------|---------------|
| **planner** | Requirements analysis, task breakdown |
| **executor** | Code implementation |
| **code_reviewer** | Architecture, code quality, security |
| **qa** | Test completeness, boundary coverage |
| **pm** | Requirement coverage, completeness |
| **designer** | API design, module structure, consistency |

## Directory Structure

```
.kanban/
  config.json          # Project config
  workflow.json         # FSM definition
  index.json            # Board index
  tasks/TASK-NNN/       # Task directory
    task.json           # Task state
    inbox.md            # User feedback
    iteration-N/        # Iteration artifacts
    dispatch/           # Agent dispatch files
  archive/TASK-NNN/     # Archived tasks
  versions/             # Version history
```

## Dashboard

```bash
cd .kanban/dashboard
npm install
node server.js
# Open http://localhost:3000
```

## FAQ

**Q: How to restart a failed task?**
A: `/kanban run TASK-NNN --phase execute` to restart from execute phase.

**Q: How to check why a task scored low?**
A: `/kanban score TASK-NNN` to see per-role scores, then read the report files in `iteration-N/`.

**Q: How to provide feedback?**
A: Edit `.kanban/tasks/TASK-NNN/inbox.md` and add items under `## 待处理`.

## Documentation

- Full documentation: `.claude/skills/kanban/SKILL.md`
- Iron rules: `CLAUDE.md`
- Version history: `.kanban/versions/CHANGELOG.md`
