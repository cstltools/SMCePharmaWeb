# Estimation

**Not Found.**

## Why

No effort estimates, story points, time tracking, or cost data exist anywhere in this repository. There is no historical velocity to derive an estimation baseline from (see [`sprint-plan.md`](sprint-plan.md) and [`roadmap.md`](roadmap.md) for the same two-commit-history limitation).

## What this documentation pass *can* offer instead

Not an estimate, but a rough **complexity signal** based on the scale figures gathered while producing the rest of this documentation set — useful context if someone needs to scope future work against this codebase's actual size:

| Signal | Value | Source |
|---|---|---|
| `.aspx` pages | ~700 | [`spec/modules.md`](../spec/modules.md) |
| DAL classes | ~365 | [`docs/architecture.md`](../docs/architecture.md) |
| Distinct stored procedures referenced from C# | 150+ | [`spec/database-spec.md`](../spec/database-spec.md) |
| Crystal Report definitions | 111 `.rpt` files, 94 wired to a viewer page | [`spec/reports.md`](../spec/reports.md) |
| Files with string-concatenated SQL (security remediation surface) | 44+ | [`docs/security.md`](../docs/security.md) |
| Automated test coverage | 0 | [`docs/testing.md`](../docs/testing.md) |

These numbers describe **surface area**, not effort — a single-line fix in a well-isolated file and a fix requiring changes across 44 SQL-injection sites are wildly different efforts despite both being "one row" in a hypothetical estimate table. Do not convert this table into story points without someone who knows the codebase reviewing each item individually.

## If estimation is needed going forward

Recommend a standard technique (three-point estimation, planning poker, or comparable) applied by whoever picks up specific tasks from [`tasks.md`](tasks.md) — this file cannot substitute for that judgment.
