---
name: log
description: Append a log entry for recent work.
argument-hint: "[TICKET-ID]"
---

Arguments: `$ARGUMENTS` (optional ticket ID, e.g. `PROJ-123`)

## Process

1. Determine the project name from the **git repo root basename** (e.g., `dotfiles`, `my-project`). Use the top-level repo name, not a subdirectory name.
2. **Prepend** the entry to `~/code/work/claude/logs/<project>.md`, right after the file header (title + description + `---`).

Create the file if it doesn't exist:

```markdown
# <project> Log
```

## Entry format

**Always prepend** new entries at the top (after the header), so the file is in reverse chronological order:

```markdown
## YYYY-MM-DD - [TICKET-ID] Summary

[2-3 sentences: what was done and why.]

**Commits:** [commit-hash]
```

Omit `[TICKET-ID]` from the heading if none was provided.
