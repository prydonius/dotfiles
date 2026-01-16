---
description: Set description on current revision
---

Update the description of the current jj revision (or another revision if specified).

**IMPORTANT: ALWAYS check for PR template first - this is required!**

1. Read `.github/pull_request_template.md` to check if a PR template exists
2. Show the current revision info with `jj log -r @ --no-graph`

If $ARGUMENTS is provided:
- If it specifies a revision (e.g. "parent", "@-"), update that revision's description
- Otherwise use $ARGUMENTS as the description for the current revision
- Run: `jj describe -m "$ARGUMENTS"` (or `jj describe -r <rev> -m "..."` for other revisions)

If no arguments provided:
1. Show current changes: `jj diff --stat`
2. Based on our planning discussion, generate a description
3. **The first line MUST be a short PR title / commit message** (e.g., "Add user authentication middleware"). This becomes the commit message and PR title.
4. **If a PR template exists, the description MUST follow that template's exact format/structure. Fill in all sections from the template after the title line.**
5. If no PR template exists, use a concise description after the title
6. Ask me to confirm before running `jj describe -m "..."`

NOTE: This sets the description on the main feature revision. Iterative changes after this should NOT get descriptions - they will be squashed into this revision when the user explicitly requests it (do NOT squash automatically).
