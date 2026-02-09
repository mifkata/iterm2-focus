# Commit changes and update issues

TICKET_STATUS="In Review"

1. If branch `main`, set bead status `closed`, otherwise to `in_progress`
2. If the bead has origin ticket URL or #ID from https://github.com/orgs/TrickyClick/projects/5, update ticket status to `in_review` or to `done`, if branch is `main`
3. Commit changes
4. Push branch
5. If branch not `main`, open pull request with status "ready for review"
6. Run `bd sync`
7. Generate report. Example:

  ┌───────────────┬────────────────────────────────────────────┐
  │     Step      │                   Result                   │
  ├───────────────┼────────────────────────────────────────────┤
  │ Commit        │ feat: add /publish slash command (9b6d484) │
  ├───────────────┼────────────────────────────────────────────┤
  │ Push          │ main pushed to origin/main (fea72c7)       │
  ├───────────────┼────────────────────────────────────────────┤
  │ Branch        │ main — no PR needed                        │
  ├───────────────┼────────────────────────────────────────────┤
  │ Bead pl-24y   │ Closed (was on main, so status = done)     │
  ├───────────────┼────────────────────────────────────────────┤
  │ Project board │ No linked ticket — skipped                 │
  └───────────────┴────────────────────────────────────────────┘