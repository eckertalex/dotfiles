---
name: commit
description: Stage and commit changes with a clean message.
argument-hint: "[TICKET-ID]"
---

Arguments: `$ARGUMENTS` (optional ticket ID, e.g. `PROJ-123`)

## Process

1. Check `git status` and `git diff` to understand changes
2. Stage relevant files
3. Commit with clean message
4. Run `/log $ARGUMENTS`

## Ticket ID

If a ticket ID is provided via `$ARGUMENTS`, prefix the commit summary line:

- `[TICKET-ID] message` (e.g. `[PROJ-123] Add user authentication flow`)

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
[PROJ-123] Refactor error handling to use Result types

The previous error handling used exceptions which made control flow
hard to follow. Result types make error cases explicit and force
callers to handle them.
```

