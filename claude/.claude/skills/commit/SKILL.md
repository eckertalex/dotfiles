---
name: commit
description: Stage and commit changes with a clean message.
argument-hint: "[TICKET-ID]"
---

Arguments: `$ARGUMENTS` (optional ticket ID, e.g. `ATTPOL-8979`)

## Process

1. Check `git status` and `git diff` to understand changes
2. Stage relevant files
3. Commit with clean message
4. Log to `.claude/LOG.md`

## Ticket ID

If a ticket ID is provided via `$ARGUMENTS`, prefix the commit summary line:

- `[TICKET-ID] message` (e.g. `[ATTPOL-8979] Add user authentication flow`)

If no ticket ID is provided, omit the prefix.

## Commit messages

- **Summary line:** Imperative mood, start with verb, max 72 chars, no period
- **Simple changes:** Single line is fine
- **Substantial changes:** Add blank line + body explaining what and why, wrapped at 72 chars
- No conventional commit prefixes (the ticket ID prefix is not a conventional commit prefix)

```
Add user authentication flow
```

```
[ATTPOL-8979] Refactor error handling to use Result types

The previous error handling used exceptions which made control flow
hard to follow. Result types make error cases explicit and force
callers to handle them.
```

## Logging

After committing, prepend an entry to `.claude/LOG.md` in the project repo.

Create the file if it doesn't exist:

```markdown
# Development Log

---
```

Prepend new entries immediately after the `---` separator (newest first):

```markdown
## YYYY-MM-DD - [TICKET-ID] [Feature/Bug Name]

[2-3 sentences: what was done and why. Key decisions or problems worth remembering.]

**Commits:** [commit-hash]

---
```

Omit `[TICKET-ID]` from the heading if none was provided.
