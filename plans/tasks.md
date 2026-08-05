# Tasks

**Not Found.**

## Why

No task list, issue tracker export, `TODO.md`, or backlog file exists in this repository. `git log`'s two-commit history (see [`roadmap.md`](roadmap.md)) provides no incremental task record either.

## Scattered in-code TODOs (the only task-like evidence in the repo)

A handful of `.exclude`-suffixed files under `Solution.Web` (`Chart/Chart.aspx[.cs].exclude`, `Dashboard_UI/AdminDashboard - Copy.aspx[.cs].exclude`, and 8 retired report-viewer pages under `SInventory_RPTVIEW`, cataloged in [`spec/reports.md`](../spec/reports.md)) represent disabled-but-not-deleted work — evidence that something was retired or paused, not a documented task with an owner or status. These are the closest thing to "in-flight work markers" this repo contains, and even these only say *that* something was set aside, not *why* or *what's next*.

## What this repo does document as known, unresolved work

Pulled from documentation that does exist (not invented for this file):

- `docs/CI-CD-README.md`'s setup checklist: implement `.github/workflows/*.yml` (the pipeline is otherwise fully designed — see [`docs/deployment.md`](../docs/deployment.md)); rotate the plaintext `sa` credentials in `Solution.Web/Web.config` into GitHub Secrets.
- The risk items in [`docs/security.md`](../docs/security.md): plaintext password storage, hardcoded/drifted connection strings, string-concatenated SQL in ~44 files, missing page-level authorization.

These are findings from this documentation pass, not a prioritized or assigned task list — treat them as candidate backlog items for whoever owns this codebase to triage, not as commitments.

## If a task tracker is needed going forward

Recommend standing up an actual issue tracker (or pointing to an existing one this documentation pass wasn't given access to) and seeding it from the findings above — this file is not a substitute for one.
