---
name: Ship
description: Create a new branch and commit work. Use when starting new work from main/master.
---

# Ship

Create a new branch (if needed) and commit work with a proper commit message.

**Announce:** "I'm shipping this work."

## Process

1. Check `git status` - see what's uncommitted
2. Check current branch:
    - If on main/master: create a new feature branch
    - If already on feature branch: warn user they're not on main (they probably want `/commit`)
3. Review changes with `git diff`
4. Stage relevant files
5. Assess scope of changes:
    - **Simple:** Single focused change, self-explanatory from diff
    - **Substantial:** Multiple related changes, non-obvious reasoning, or significant impact
6. Commit with clean message following these rules:
    - **Summary line:** Imperative mood, start with verb, max 72 chars, no period
    - **For simple changes:** Single line is fine
    - **For substantial changes:** Add blank line + detailed body explaining what and why
    - Body should wrap at 72 characters
    - Explain the reasoning behind changes, not just what changed

## Branch naming

Create descriptive branch names based on the work:

- `feature-user-auth`
- `fix-cache-race-condition`
- `refactor-error-handling`

Use kebab-case throughout (no slashes) and keep it concise.

## Examples

**Simple changes (single line):**

```
Add user authentication flow
Fix race condition in cache invalidation
Remove deprecated API endpoints
```

**Substantial changes (with body):**

```
Refactor error handling to use Result types

The previous error handling used exceptions which made control flow
hard to follow. This changes the API to return Result<T, Error>
types instead, making error cases explicit and forcing callers to
handle them. This also eliminates silent failures in the retry logic.
```

```
Add caching layer to reduce database load

Implements Redis-based caching for user profile queries which were
causing performance issues under load. Cache invalidation happens on
profile updates via pub/sub. This reduces DB queries by ~80% in
production traffic patterns.
```

**Bad commits:**

```
Added user authentication flow    # Past tense
Fixes bug                          # Wrong mood
refactor: error handling           # No conventional commit prefixes
Update code.                       # Period at end
```

## Important

- Do not attribute Claude in commit message
- Do not add Co-Authored-By or Generated with Claude footers
- Keep it simple and descriptive
- Never force-push without explicit request
- Never commit directly to main/master without creating a branch first
- Never commit secrets or credentials
- Never skip pre-commit hooks
