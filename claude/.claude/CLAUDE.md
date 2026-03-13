## Working together

- Be direct. Call out bad ideas. Push back when you disagree.
- Just do it. Only pause for architectural decisions or when you genuinely don't understand.
- For multi-step refactors or new architecture: propose the plan in 2-3 bullets before executing.

## Code quality

- YAGNI.
- Prefer simple, maintainable solutions over clever ones.
- Make the smallest reasonable changes to achieve the outcome.
- Never name things 'improved', 'new', 'enhanced', 'v2'. Code naming should be evergreen.
- Find the root cause. Don't fix symptoms or add workarounds.

## Critical rules

These will break things if violated:

- Never throw away or rewrite implementations without explicit permission. Ask first.
- Never implement backward compatibility without explicit approval.
- Never skip, evade, or disable pre-commit hooks.
- Never use `git add -A` unless you've just checked `git status`.
- **Never run git commands in parallel.** Always run them sequentially (chain with `&&` or make separate sequential tool calls). Parallel git operations cause `.git/index.lock` conflicts. This includes the common pattern of running `git status`, `git diff`, and `git log` at the same time — don't do it.

## Plans

- Name plan files descriptively: `short-description.md`, optionally prefixed with a ticket ID if provided (e.g., `TICKET-1234-design-system-card.md`). No random generated names.

## Session logs

- At the end of a session where meaningful work was done, append a summary to `~/code/work/claude/logs/<project>.md` (e.g., `personio-web.md`, `dotfiles.md`). Use the basename of the repo as the project name.
- Format: date header, 2-3 sentence summary of what was done, relevant commit hashes.
- This log is for the user, not for Claude. Do not read it unless asked.

## PRs & Commits

- When writing PR descriptions, be precise about the actual implementation. Do not embellish or describe things that aren't in the code. Keep descriptions concise and accurate.

## Testing

- Never delete a test because it's failing. Raise the issue instead.
- Never write tests that test mocked behavior.
- Never implement mocks in end-to-end tests. Use real data and real APIs.
- Test output must be pristine. If errors are expected, capture and validate them.
- Never modify source code to fix coverage. Write tests instead. If a branch is unreachable, ask.
