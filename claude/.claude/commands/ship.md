---
name: Ship
description: Branch (if needed), commit, and log work.
argument-hint: "[TICKET-ID]"
---

Arguments: `$ARGUMENTS` (optional ticket ID, e.g. `ATTPOL-8979`)

## Process

1. Check `git status` and `git diff` to understand changes
2. Check current branch:
    - If on main/master: create a new feature branch
    - If already on feature branch: commit directly
3. Stage relevant files
4. Commit with clean message
5. Log to `.claude/LOG.md`

## Ticket ID

If a ticket ID is provided via `$ARGUMENTS`, use it in:

- **Branch name:** `TICKET-ID-description` (e.g. `ATTPOL-8979-add-user-auth`)
- **Commit message:** `[TICKET-ID] message` (e.g. `[ATTPOL-8979] Add user authentication flow`)
- **Log entry:** include ticket ID in the heading

If no ticket ID is provided, omit it from all three.

## Commit messages

- **Summary line:** Imperative mood, start with verb, max 72 chars, no period
- **Simple changes:** Single line is fine
- **Substantial changes:** Add blank line + body explaining what and why, wrapped at 72 chars
- No Claude attribution, no Co-Authored-By footers
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

## Branch naming

Kebab-case, no slashes, concise:

- `ATTPOL-8979-user-auth`
- `feature-user-auth`
- `fix-cache-race-condition`

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
