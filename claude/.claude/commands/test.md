---
name: Write Tests
description: Examine code and write comprehensive tests following TDD principles. Use after implementing features. Auto-logs to unified session log.
---

# Write Tests

Examine code, write comprehensive tests, verify they pass.

## Process

### 1. Identify Code

Ask which components need tests, or:

- Check git status for recent changes
- Look for files without test files
- Identify untested functionality

### 2. Analyze

For each component:

- What does it do? (inputs, outputs, side effects)
- What are the edge cases?
- What can go wrong?
- What are the critical paths?

### 3. Write Tests

**Must cover:**

- Happy path (expected inputs → expected outputs)
- Edge cases (empty, null, undefined, boundary values)
- Error conditions (invalid inputs, failures, exceptions)
- Integration points (API calls, database, external dependencies)

**Principles:**

- Test behavior, not implementation details
- Never test mocked behavior (use real logic)
- Never mock in end-to-end tests (use real data, real APIs)
- Each test independent and isolated
- Pristine output - no unexpected logs/errors

**Naming:**

```javascript
// Good
test("returns empty array when no items match filter");
test("throws error when user is not authenticated");

// Bad
test("it works");
test("test filter");
```

### 4. Run Tests

Verify:

- All new tests pass
- All existing tests still pass
- No unexpected output/errors
- Coverage increased

### 5. Log

Append to `.claude/LOG.md` in project repo:

```markdown
## YYYY-MM-DD - [Feature Name]

**Type:** Feature | Bugfix | Refactor

**Action:** Wrote comprehensive tests

**Overview:**
[What functionality was tested and why]

**Test Coverage:**

- Happy paths: [What was covered]
- Edge cases: [Boundary conditions, empty states]
- Error conditions: [Invalid inputs, failures]

**Test Approach:**

- [Testing strategy: unit, integration, behavioral]
- [Key testing patterns applied]
- [Mocking decisions and rationale]

**Test Results:** [If notable]

**Commits:** [commit-hash] if applicable

---
```

Focus on test approach and coverage decisions.

Confirm: "Tests written and verified. Logged to LOG.md. Ready for `/finish` when you are."

## Red Flags

- Test failures are your responsibility - fix them
- Never delete tests because they're failing
- Never reduce test coverage
- Never ignore test output
- If tests trigger errors intentionally, capture and validate error output
