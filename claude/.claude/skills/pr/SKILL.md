---
name: pr
description: Create PR
argument-hint: "[base-branch]"
---

Arguments: `$ARGUMENTS` (optional base branch)

## Process

1. Run tests first to ensure they pass
2. Push the branch to the remote
3. Create the PR with `gh pr create --web` (opens in browser to review before submitting)

## PR description

- Be precise about the actual implementation — no embellishment
- Do NOT describe implementation details that aren't in the code
- Keep it concise and accurate
