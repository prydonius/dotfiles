---
description: Fetch latest and start new work on main@origin
---

Start a new coding session by fetching latest and creating a revision on main@origin.

!`jj git fetch`
!`jj new main@origin`

Confirm the new revision was created:
!`jj log -r @ --no-graph`

Now proceed with planning. Once the plan is ready, use `/jj-describe` to set the description for this revision.
