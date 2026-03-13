---
name: log
description: Append a log entry for recent work.
argument-hint: "[TICKET-ID]"
---

Arguments: `$ARGUMENTS` (optional ticket ID, e.g. `PROJ-123`)

## Process

1. Determine the project name from the basename of the repo (e.g., `dotfiles`, `my-project`)
2. Append an entry to `~/code/work/claude/logs/<project>.md`

Create the file if it doesn't exist:

```markdown
# <project> Log
```

## Entry format

Append new entries at the end:

```markdown
## YYYY-MM-DD - [TICKET-ID] Summary

[2-3 sentences: what was done and why.]

**Commits:** [commit-hash]
```

Omit `[TICKET-ID]` from the heading if none was provided.
