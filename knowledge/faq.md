# FAQ

Answers grounded in what this repository actually contains. Where the honest answer is "unknown," it says so rather than guessing.

**Q: What kind of application is this?**
A distribution/field-force ERP for a pharma company — order-to-cash, warehouse/stock management, and field-rep (medical rep) management, built on ASP.NET Web Forms / .NET Framework 4.8 / MS SQL Server. See [`.claude/project-context.md`](../.claude/project-context.md).

**Q: Is this a REST API / can I call it like a modern backend?**
No — there's no `ApiController`/Web API framework in this repo. The programmatic surface is
fragmented across an ASMX SOAP/ScriptService (`SInventoryWebService.asmx`, mostly autocomplete
lookups), a couple of `.ashx` file handlers, and — the bulk of it — **459 inline `[WebMethod]` page
methods spread across 116 `.aspx.cs` files**, one per feature screen, never consolidated. See
[`spec/api-spec.md`](../spec/api-spec.md) for the full catalog. The Flutter mobile app most likely
talks to the ~350 `sp_Webapi*`/`sp_SalesAPI*` stored procedures directly (not a documented HTTP
layer found in this repo) — see [`spec/integrations.md`](../spec/integrations.md) §4.

**Q: Why are there two completely different coding styles in this codebase?**
The codebase spans two eras of practice: a legacy ADO.NET/`DataTable` style (the majority) and a newer Dapper/`Service`+`Repository`/typed-model style (a small number of recent files, e.g. `CustomerInvoiceLimitService`). There's no migration in progress between them — match whichever style the file you're editing already uses. See [`docs/architecture.md`](../docs/architecture.md).

**Q: How do I know which stored procedure a given feature calls?**
Two options now. Grep the relevant `Library.DAL` module folder for string literals passed into the
DAL's execute-proc helper methods (fastest for a specific call site). Or check
[`spec/database-spec.md`](../spec/database-spec.md)'s full name catalog of all 1,866 procedures —
and once you have a name, its complete source is a file open away at
`spec/database/procs/<name>.sql` (no need to connect to the database).

**Q: Is there a diagram of the database schema?**
No ER diagram, but this is otherwise resolved. No EF migrations, no DDL dump — but the schema has
been pulled live from the database and checked in: every table and column is in
[`spec/database-tables.md`](../spec/database-tables.md) (569 tables, 7,402 columns), and every
procedure/function/view's full source is in [`spec/database/`](../spec/database/). See
[`spec/database-spec.md`](../spec/database-spec.md) for the index into both.

**Q: Are passwords hashed?**
No. Login and password-change code compares/stores passwords in plaintext (`Library.DAL/PanalCls/PanalClsDAL.cs`, `Library.DAL/UserProfileDAL/ChangePasswordDAL.cs`). See [`docs/security.md`](../docs/security.md).

**Q: If a menu item is hidden from a user, are they blocked from that page?**
No. Menu visibility is a per-user UI convenience, not access control — any authenticated user who requests a page's URL directly can reach it, regardless of menu grants. See [`docs/security.md`](../docs/security.md).

**Q: How do I run the test suite?**
There isn't one. Verification is done via standalone PowerShell scripts against a live SQL Server database (see [`docs/testing.md`](../docs/testing.md)). Point any such script at a dev/staging database, never production.

**Q: Is there a CI/CD pipeline?**
It's fully *designed* (5 documented GitHub Actions workflows, 5 deploy scripts) but the actual `.github/workflows/` YAML files don't exist in the repo. See [`docs/deployment.md`](../docs/deployment.md).

**Q: What's the roadmap / what's planned next?**
**Not Found.** This repo's git history is two commits (an initial commit and one "add full codebase" commit) — there's no incremental record, issue tracker link, or planning document to draw a roadmap from. See [`plans/roadmap.md`](../plans/roadmap.md).

**Q: Why does the connection string I changed not seem to apply?**
There are three independent hardcoded connection-string locations in the C# code plus per-script strings in every root `.ps1` file — you likely changed one that isn't read by the code path you're testing. See [`docs/database.md`](../docs/database.md) and [`knowledge/troubleshooting.md`](troubleshooting.md).

**Q: What does [acronym] mean?**
Check [`knowledge/glossary.md`](glossary.md) first — most domain acronyms (DCR, DCP, MIO, ASM, RSM, DA, etc.) are not defined anywhere in the code, only inferable from context, and the glossary marks confidence levels accordingly. Some (CVP/CVR, MIA, DWSP, MIGO) could not be confidently expanded at all.

**Q: Can I add dependency injection / a test project / an ORM without asking?**
No — these are architectural changes with no existing foundation to build on (no DI container, no interfaces on BLL/DAL classes, no test project scaffolding). Raise it explicitly rather than introducing it as a side effect of an unrelated task. See [`.claude/ai-rules.md`](../.claude/ai-rules.md).

**Q: Does this app send email?**
Yes, and some of it is live. Several `Campaign*.aspx.cs` files (`MasterSetup_UI`) and a few
Order/Transfer screens send notification emails via `smtp.gmail.com`, using a mix of hardcoded
shared credentials and per-user session-stored Gmail app passwords — none of it goes through a
secrets manager. See [`spec/integrations.md`](../spec/integrations.md) §2 (this corrects an earlier
draft of that document, which wrongly said no email code existed).

**Q: Is this documentation set itself something I should trust blindly?**
Trust it as a snapshot from static analysis on 2026-08-05, grounded in file:line citations throughout — but re-verify against the current code before relying on any specific claim for a decision, since the codebase can change after this was written and nothing here was validated against a running system or a live database.
