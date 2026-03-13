---
name: ship
description: Branch (if needed), commit, and log work.
argument-hint: "[TICKET-ID]"
---

Arguments: `$ARGUMENTS` (optional ticket ID, e.g. `ATTPOL-8979`)

## Process

1. Check current branch:
    - If on main/master: create a new feature branch
    - If already on feature branch: commit directly
2. Run `/commit $ARGUMENTS`

## Ticket ID

If a ticket ID is provided via `$ARGUMENTS`, use it in the branch name:

- `TICKET-ID-description` (e.g. `ATTPOL-8979-add-user-auth`)

If no ticket ID is provided, omit it.

## Branch naming

Kebab-case, no slashes, concise:

- `ATTPOL-8979-user-auth`
- `feature-user-auth`
- `fix-cache-race-condition`
