---
name: pr
description: Create PR
argument-hint: "[base-branch]"
---

Arguments: `$ARGUMENTS` (optional base branch)

## Process

1. Push the branch to the remote
2. Create the PR with `gh pr create --web` (opens in browser to review before submitting)

## PR description

- No section headers (no "Summary", "Test plan", etc.) — just a plain description of what the PR does
- Be precise about the actual implementation — no embellishment
- Do NOT describe implementation details that aren't in the code
- Keep it concise and accurate
- Do NOT run tests, lint, or type-check before opening the PR
