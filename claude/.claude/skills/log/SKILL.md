---
name: log
description: Append a log entry for recent work.
argument-hint: "[TICKET-ID or group name]"
---

Arguments: `$ARGUMENTS` (optional ticket ID or group name, e.g. `ATTPOL-9256` or `"Time bank compensation"`)

## What is a log entry?

A log entry is a **named group** representing a body of work (e.g., "Time bank compensation", "DX improvements"). A group:

- Has a descriptive name (not a ticket ID)
- Lists associated Jira tickets (optional)
- Lists PRs as markdown links
- Has a summary that scales with scope (see entry format below)

Groups get updated over time as more work lands.

## Log file layout

Monthly files at `~/code/work/logs/YYYY-MM-worklog.md`.

Create the file if it doesn't exist:

```markdown
# YYYY-MM Work Log

---
```

## Entry format

**Always prepend** new entries at the top (after the header). Entries within a file are separated by `---`.

```markdown
## Feature name

Summary that scales with scope: 2-3 sentences for small groups,
a short bullet list of key milestones for larger groups.

**Tickets:** [PROJ-123](https://jira-base-url/PROJ-123), [PROJ-456](https://jira-base-url/PROJ-456)
**PRs:** [#12345](https://github.com/org/repo/pull/12345), [#12350](https://github.com/org/repo/pull/12350)

---
```

Omit **Tickets** or **PRs** lines if there are none.

## Two modes

### A) With argument

`/log "Time bank compensation"` or `/log ATTPOL-9256`

1. Open the current month's log file
2. Search for a matching group: by name, or by ticket ID in any group's **Tickets** list
3. **Ask the user what to add.** Don't assume -- ask what happened, what context to include, any PRs/tickets to link. Then write or update the entry based on their answer.
4. If no matching group found: create a new one. If only a ticket ID was provided, ask the user for a descriptive group name.

### B) Without argument

`/log`

1. Find git repos under the current directory (or the current repo if already in one). For bare checkouts, check all worktrees.
2. Scan for recent commits by the user (use `git config user.email` to identify) and recent PRs via `gh pr list --author @me`.
3. Cross-reference against existing log entries (current and previous month) to find unlogged work.
4. For each unlogged item: ask the user which group it belongs to, or offer to create a new one.
5. Update existing entries with any new commits/PRs discovered.

## Rules

- **Scale detail with scope.** Small groups: 2-3 sentences. Larger groups: a short bullet list of key milestones.
- **Links are markdown links.** PRs: `[#123](https://github.com/org/repo/pull/123)`. Tickets: `[PROJ-123](https://jira-url/PROJ-123)`. Check the project CLAUDE.md for the Jira base URL. Use `gh pr list` to find PR numbers.
- **Never duplicate.** Check before adding PRs or tickets that already appear.
- **One group per body of work.** Don't split related work into separate groups.
- **Cross-month work:** If a group spans months, create/update the entry in the month where the most recent work happened. Reference the earlier month if needed.
