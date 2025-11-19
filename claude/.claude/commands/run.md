---
name: Run Implementation Plan
description: Load and run a persisted plan in batches with review checkpoints. Often run in a new session.
---

# Run Implementation Plan

Load plan, review critically, run in batches with checkpoints.

## Process

### 1. Load and Review

1. Ask which plan if not specified (list `.claude/plans/`)
2. Read plan and review critically
3. Raise concerns before starting
4. Create TodoWrite with all tasks from plan

### 2. Run Batch (2-3 tasks)

For each task:

**Start:**

1. Mark `in_progress` in TodoWrite
2. Follow plan phases: Skeleton → Logic → Validation → Tests → Verification
3. Run all verifications

**Complete:**

1. Edit plan file: change `- [ ] Task N` to `- [x] Task N`
2. Mark `completed` in TodoWrite
3. Verify checkbox is checked by reading plan file

### 3. Report Between Batches

```markdown
## Batch [N] Complete

**Implemented:**

- Task 1: [description] ✓ Plan updated
- Task 2: [description] ✓ Plan updated

**Verification:**

- Task 1: [Pass/Fail + details]
- Task 2: [Pass/Fail + details]

**Issues:** [Deviations or problems, if any]

Ready for feedback.
```

### 4. Continue

Wait for feedback, apply changes if needed, then continue next batch.

### 5. Complete

When all tasks done, append to `.claude/LOG.md` in project repo:

```markdown
## YYYY-MM-DD - [Feature Name]

**Type:** Feature | Bugfix | Refactor

**Action:** Ran implementation plan

**Branch:** [branch-name]

**Plan:** `.claude/plans/YYYY-MM-DD-<feature-name>.md`

**Overview:**
[2-3 sentences about what was implemented]

**Completed:**

- [High-level list of accomplishments]

**Decisions Made:**

- [Implementation decisions that differed from plan]
- [Technical approaches chosen during implementation]

**Problems Encountered:**

- [Issues faced and how resolved]
- [Blockers and workarounds]

**Test Results:** [If significant]

**Next Steps:** [What remains]

**Commits:** [commit-hash] or [X commits on branch-name]

---
```

Focus on decisions, problems, and outcomes - not file lists.

Confirm: "All tasks complete and logged. Ready for `/finish` when you are."

Do not automatically trigger `/finish`.

## Handling Problems

- **Plan doesn't work:** Resolve if possible, document deviation, continue
- **Missing info:** Make reasonable decision, document it
- **Blocked:** Stop batch, report blocker
- **Tests fail:** Fix if obvious, otherwise report and stop

Never skip verification steps.
