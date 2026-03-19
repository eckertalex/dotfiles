---
name: branch
description: Create a feature branch and commit changes.
argument-hint: "[TICKET-ID] [description]"
---

Arguments: `$ARGUMENTS` (optional ticket ID and description, e.g. `PROJ-123 add user auth`)

## Process

1. Create a new feature branch from the current branch
2. Run `/commit $ARGUMENTS`

## Ticket ID

If a ticket ID is provided via `$ARGUMENTS`, use it in the branch name:

- `TICKET-ID-description` (e.g. `PROJ-123-add-user-auth`)

If no ticket ID is provided, omit it.

## Branch naming

Kebab-case, no slashes, concise:

- `PROJ-123-user-auth`
- `feature-user-auth`
- `fix-cache-race-condition`
