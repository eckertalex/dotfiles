---
name: Brainstorm and Plan
description: Interactive brainstorming to create detailed implementation plan. Plans persist to .claude/plans/ for later execution. Auto-logs to unified session log.
---

# Brainstorm and Plan

Create a detailed implementation plan through interactive exploration.

## Process

### 1. Understanding

- Check current project state
- Ask one question at a time (use AskUserQuestion tool with multiple choice)
- Gather: Purpose, constraints, success criteria

### 2. Exploration

Explore 2-3 different approaches before settling. Vary:

- Data structures (array vs tree vs hash)
- Algorithms (iterative vs recursive)
- Abstractions (direct vs library)
- Responsibilities (one class vs multiple)

For each: simplicity, performance, maintainability, trade-offs.

Present alternatives and ask which resonates.

### 3. Design

Present in 200-300 word sections covering:

- Architecture, components, data flow
- Error handling, testing

Ask after each: "Does this look right?"

### 4. Write Plan

Save to: `.claude/plans/YYYY-MM-DD-<feature-name>.md`

Task granularity: One task = 15-30 min (Skeleton → Logic → Validation → Tests)

````markdown
# [Feature Name] Implementation Plan

> **For Claude:** Use `/execute` to implement this plan.

**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Tech Stack:** [Key technologies]
**Dependencies:** [Prerequisites or "None"]

## Progress Checklist

- [ ] Task 1: [Brief task name]
- [ ] Task 2: [Brief task name]

---

### Task N: [Component/Feature Name]

**Dependencies:** [Required prior tasks or "None"]

**Files:**

- Create: `path/to/new/file.tsx`
- Modify: `path/to/existing/file.tsx:123-145`

**Implementation:**
[Clear description of what to build and how]
[Pseudocode for complex logic]

**Edge Cases:**

- [Case and how to handle]

**Testing:**
[Key test cases]

**Verification:**

```bash
npm test ComponentName
```
````

Expected: All tests pass

````

### 5. Log

Append to `.claude/LOG.md` in the project repo:

```markdown
## YYYY-MM-DD - [Feature Name]

**Type:** Feature | Bugfix | Refactor

**Action:** Created implementation plan

**Plan:** `.claude/plans/YYYY-MM-DD-<feature-name>.md`

**Overview:**
[2-3 sentences describing problem and solution approach]

**Key Decisions:**
- [Architectural/technical decisions with rationales]
- [Alternatives considered and why rejected]
- [Technology choices and trade-offs]

**Success Criteria:**
- [What defines successful completion]

---
````

Focus on decisions, alternatives, and rationale - not file lists.

Confirm: "Plan saved and logged to LOG.md"

## Principles

- YAGNI - Don't add features we don't need right now
- Simplicity first - Managing complexity is the primary technical imperative
- Default to simplest approach that meets requirements
- If it feels complex, it IS complex - iterate to find simpler approach
