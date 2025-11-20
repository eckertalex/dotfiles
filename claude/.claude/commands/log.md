---
name: Log Session Entry
description: Manually add entry to unified session log at <repo>/.claude/LOG.md. Use anytime to record work. Auto-triggered by /plan, /execute, /test.
---

# Log Session Entry

Manually add entry to unified session log at `.claude/LOG.md` in project repo.

**Note:** Auto-triggered by `/plan`, `/execute`, `/test`. Use manually for other work.

## Process

1. **Ask for context** if not obvious:
    - What feature/bug/project?
    - What type of work?
    - What was done and why?
    - What decisions were made and what alternatives?
    - What problems occurred and how solved?

2. **ALWAYS PREPEND entry at the beginning:**

   **CRITICAL:** New entries MUST be inserted at the BEGINNING of the file, immediately after the header and separator line (`---`). NEVER append to the end. Most recent entries should always be at the top.

   Entry format:

```markdown
## YYYY-MM-DD - [Feature/Bug/Project Name]

**Type:** Feature | Bugfix | Refactor | Research | Other

**Action:** [Specific description]

**Branch:** [branch-name if applicable]

**Overview:**
[2-3 sentences describing work and context]

**Completed:**

- [What was accomplished]

**Decisions Made:**

- [Key decisions with rationales]
- [Alternatives considered]

**Problems Encountered:**

- [Issues faced and how resolved]

**Test Results:** [If notable]

**Next Steps:** [If applicable]

**Commits:** [commit-hash or count if applicable]

---
```

3. **Create file if doesn't exist:**

```markdown
# Development Session Log

Unified log of all development work across sessions.

---

[new entry goes here - always after the separator]
```

   **Remember:** When adding to existing file, insert new entry immediately after the `---` line.

4. **Confirm:** "Entry logged to LOG.md"

## Guidelines

- **ALWAYS prepend new entries at the beginning** - Insert immediately after the `---` separator, NEVER at the end
- Clear feature/project name in each entry
- Focus on decisions and outcomes - not file lists
- Omit empty sections
- Never modify existing entries
- Reference commits by hash when relevant

Focus on why decisions were made, what problems occurred, what was learned.

**REMINDER:** Most recent work must always appear first in the log file.
