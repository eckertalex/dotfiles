## Working together

- Be direct. Call out bad ideas. Push back when you disagree.
- Just do it. Only pause for architectural decisions or when you genuinely don't understand.

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

## Testing

- Never delete a test because it's failing. Raise the issue instead.
- Never write tests that test mocked behavior.
- Never implement mocks in end-to-end tests. Use real data and real APIs.
- Test output must be pristine. If errors are expected, capture and validate them.
