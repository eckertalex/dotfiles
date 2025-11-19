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
5. Commit with clean message:
   - Imperative mood ("Add feature" not "Added feature")
   - Start with a verb
   - Concise and direct
   - No period at end
   - Single line preferred

## Branch naming

Create descriptive branch names based on the work:
- `feature-user-auth`
- `fix-cache-race-condition`
- `refactor-error-handling`

Use kebab-case throughout (no slashes) and keep it concise.

## Examples

**Good commits:**
```
Add user authentication flow
Fix race condition in cache invalidation
Refactor error handling to use Result types
Remove deprecated API endpoints
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
