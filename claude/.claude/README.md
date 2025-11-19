# Claude Code Setup

## Structure

```
~/.dotfiles/claude/.claude/     # Global (all projects)
├── commands/                   # Slash commands
├── CLAUDE.md                   # Global instructions
└── README.md                   # This file

<project>/.claude/              # Per-project
├── LOG.md                      # Development log
└── plans/                      # Implementation plans
```

## Commands

- `/plan` - Brainstorm and create implementation plan (saved to `.claude/plans/`)
- `/execute` - Load and execute a plan in batches with checkpoints
- `/test` - Write comprehensive tests for code
- `/log` - Manually log session work to `.claude/LOG.md`
- `/commit` - Commit work with clean commit message
- `/ship` - Create new branch and commit (use when starting from main)

## Notes

- Plans persist across sessions in `.claude/plans/`
- `/plan`, `/execute`, `/test` auto-log to `.claude/LOG.md`
- `/commit` and `/ship` never add Claude attribution to commits
- Log and plans are per-project, not global
