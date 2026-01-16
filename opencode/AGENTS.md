# AGENTS.md - Jujutsu (jj) Workflow Guide

## Critical Rules

1. **NEVER use git commands** - This repository uses Jujutsu (jj) for version control. Do not use `git add`, `git commit`, `git status`, `git push`, or any other git commands.

2. **NEVER squash changes automatically** - Only squash when the user explicitly asks you to (e.g., "squash the changes", "run jj squash", or uses `/jj-squash`). Do not squash as part of a workflow or when finishing work.

3. **Do NOT set descriptions on iterative changes** - Only the main feature revision gets a description. Iterative changes will be squashed into the parent when the user requests it.

## Session Workflow

### 1. Planning Phase
Start each session by discussing and planning the work needed. Understand the requirements before writing code.

### 2. Start New Work
Use `/jj-start` to fetch latest and create a new revision on `main@origin`:

```bash
jj git fetch
jj new main@origin
```

### 3. Set Description
After planning, use `/jj-describe` to set a detailed description on the current revision. This becomes the main feature revision.

**IMPORTANT: ALWAYS check if the repo has `.github/pull_request_template.md` first.** If it exists, the description MUST follow that template's format exactly. Do not skip this check.

### 4. Iterative Changes
Make changes directly in the working copy. Do NOT create new revisions or set descriptions for iterative changes - they will be squashed into the parent revision.

Just let changes accumulate in the working copy.

### 5. Squash When Asked
**Do NOT squash automatically.** Only run `jj squash` when the user explicitly requests it (e.g., "squash the changes", "run jj squash", or `/jj-squash`).

When the user requests a squash:
```bash
jj squash
```

This leaves you in an empty revision, ready for the next iteration or to push.

## Common Commands

### Status and Information

| Command | Purpose |
|---------|---------|
| `jj status` | Show current change status (equivalent to `git status`) |
| `jj log` | Show commit history |
| `jj diff` | Show changes in the current working copy |
| `jj show` | Show the current change details |

### Managing Descriptions

| Command | Purpose |
|---------|---------|
| `jj describe -m "message"` | Set/update the current change's description |
| `jj describe` | Open editor to write a longer description |
| `jj log -r @ --no-graph` | View current change's description |

### Creating and Managing Changes

| Command | Purpose |
|---------|---------|
| `jj new` | Create a new empty change on top of current |
| `jj new main@origin` | Create new change on top of main |
| `jj new <revision>` | Create new change on top of specific revision |
| `jj edit <revision>` | Edit an existing change |
| `jj abandon` | Abandon the current change |
| `jj squash` | Squash current change into parent |
| `jj split` | Split current change into multiple |

### Working with Branches/Bookmarks

| Command | Purpose |
|---------|---------|
| `jj bookmark list` | List all bookmarks |
| `jj bookmark create <name>` | Create a bookmark at current change |
| `jj bookmark set <name>` | Move bookmark to current change |
| `jj bookmark delete <name>` | Delete a bookmark |

### Workspace Management

| Command | Purpose |
|---------|---------|
| `jj workspace list` | List all workspaces |
| `jj workspace add <path>` | Create a new workspace |
| `jj workspace forget <name>` | Remove a workspace |
| `jj workspace root` | Show workspace root directory |

### Syncing with Remote

| Command | Purpose |
|---------|---------|
| `jj git fetch` | Fetch from remote |
| `jj git push` | Push to remote |
| `jj git push -b <bookmark>` | Push specific bookmark |

### Resolving Conflicts

| Command | Purpose |
|---------|---------|
| `jj resolve` | Launch merge tool for conflicts |
| `jj restore --from <rev>` | Restore files from another revision |

### Undo and Recovery

| Command | Purpose |
|---------|---------|
| `jj undo` | Undo the last jj operation |
| `jj op log` | Show operation history |
| `jj op restore <op-id>` | Restore to a previous operation state |

## Workflow Example

```bash
# 1. Start new work - fetch and create revision on main
jj git fetch
jj new main@origin

# 2. After planning, set description (use PR template format if available)
jj describe -m "Add user authentication middleware

## Summary
- Implement JWT-based authentication for API endpoints
- Add middleware to validate tokens on protected routes

## Changes
- New auth middleware in src/middleware/
- Updated route handlers to use authentication"

# 3. Make iterative changes - just edit files, no new revisions needed
# ... edit files ...

# 4. Check status while working
jj status
jj diff

# 5. When iteration is complete, squash into parent (only when user asks!)
jj squash

# 6. Continue with more changes or push when ready
jj git push
```

## Tips

- Changes in jj are automatically tracked - no need to stage files
- Use `jj log -r 'all()'` to see all changes including hidden ones
- Use `jj log --revisions 'trunk()..@'` to see changes not yet on main
- The `@` symbol always refers to the current working copy change
- After squashing, you're left in an empty revision - this is expected
