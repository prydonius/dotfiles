---
description: Create a new jj workspace for this session
---

Setup and create a jj workspace for isolated parallel work.

1. Create .workspaces/ directory with .gitignore (if not exists):

!`mkdir -p .workspaces`
!`echo '/*' > .workspaces/.gitignore`

2. Create the new workspace:

!`jj workspace add ".workspaces/$1"`

3. Verify workspace was created:

!`jj workspace list`

4. Set working directory to the new workspace at `.workspaces/$1` for all subsequent operations in this session.
