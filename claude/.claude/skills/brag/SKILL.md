---
name: brag
description: Update brag document from work logs and git history.
argument-hint: "[date range]"
---

Arguments: `$ARGUMENTS` (optional date range, e.g. `2026-01 to 2026-03`. Defaults to year-to-date.)

## Process

1. Read the current brag document at `~/code/work/brag_documents/YYYY_brag_document.md`.
2. Read all log files in the specified range from `~/code/work/logs/YYYY-MM-worklog.md`.
3. Synthesize log groups into brag document sections. Map groups to sections using judgement:
    - Feature work, bug fixes, infrastructure -> **Projects**
    - Code reviews, mentoring, onboarding help -> **Collaboration & mentorship**
    - Design docs, RFCs, guides -> **Design & documentation**
    - Interviewing, process improvements -> **Company building**
    - New skills, technologies, domains -> **What you learned**
4. For each project entry, include:
    - What the contribution was
    - The impact (if known from the log)
    - Key PR links as markdown links: `[#123](https://github.com/org/repo/pull/123)`
5. **Never overwrite** manually written content. Only append new items or update existing ones.

## Rules

- **Ask before restructuring.** If existing brag doc content doesn't match log data, ask rather than overwrite.
- **PR links:** Use standard markdown links: `[#123](https://github.com/org/repo/pull/123)`. Only link key PRs, not every single one.
- **Scale detail with scope.** Use a bold heading line + bullet list for larger projects, a single bullet for small items.
- **Keep it scannable.** Bullet points over paragraphs. Focus on contributions and impact, not implementation details.
- **Group related log entries.** Multiple log groups that are part of the same larger initiative should be combined into one brag doc entry.
