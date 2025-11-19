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
4. Commit with clean message:
    - Imperative mood ("Add feature" not "Added feature")
    - Start with a verb
    - Concise and direct
    - No period at end
    - Single line preferred

## Examples

**Good:**

```
Add user authentication flow
Fix race condition in cache invalidation
Refactor error handling to use Result types
Remove deprecated API endpoints
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
