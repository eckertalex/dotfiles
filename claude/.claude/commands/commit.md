---
name: Commit
description: Commit work with a clean, Rob Pike-style commit message. Use after completing implementation.
---

# Commit

Commit everything on the current branch with a proper commit message.

**Announce:** "I'm committing this work."

## Process

1. Check `git status` - see what's uncommitted
2. Review changes with `git diff`
3. Stage relevant files
4. Assess scope of changes:
    - **Simple:** Single focused change, self-explanatory from diff
    - **Substantial:** Multiple related changes, non-obvious reasoning, or significant impact
5. Commit with clean message following these rules:
    - **Summary line:** Imperative mood, start with verb, max 72 chars, no period
    - **For simple changes:** Single line is fine
    - **For substantial changes:** Add blank line + detailed body explaining what and why
    - Body should wrap at 72 characters
    - Explain the reasoning behind changes, not just what changed

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

**Bad:**

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
- Never commit secrets or credentials
- Never skip pre-commit hooks
