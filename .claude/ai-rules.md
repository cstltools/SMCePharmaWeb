# AI Assistant Rules

Rules specific to AI coding assistants (Claude Code or otherwise) operating in this repository, on top of the general conventions in [`coding-rules.md`](coding-rules.md).

## Do not guess

- **Never invent a stored procedure name, table name, or column name.** This codebase has no schema dump or migrations — the only ground truth is (a) the C# DAO classes, (b) the ~40 loose `.sql` files at the repo root, and (c) whatever a grep across `Library.DAL` turns up. If you can't find a procedure/table/column in one of those, say so; do not assume a "probably named like this" identifier exists.
- **Never assume a numeric status code's meaning.** Several tables use bare integer status columns (e.g. `tblOrderInfoMaster.ActionStatus`, filtered as `not in (2,3)` in `Solution.Web/SInventory_UI/OrderApproveList.aspx.cs`) with no enum or comment anywhere in the repo defining what each value means. Flag these as unknown rather than picking a plausible-sounding label.
- **Never assume which of the four `DataAccessManager*` variants or which of the three connection-string sources (`web.config`, `SqlUserAccess.cs`, `DB_Authentication.cs`) is "the right one."** Match whichever the specific file you're editing already uses.

## Preserve, don't refactor opportunistically

- Preserve existing function signatures and control IDs — see [`coding-rules.md`](coding-rules.md#webforms-specifics). A rename that looks safe may break a stored-proc parameter binding or markup reference elsewhere.
- Do not "clean up" the legacy `DataTable`/ADO.NET style into the newer Dapper/Repository style as a side effect of an unrelated change. The two styles coexist deliberately (or at least, by history) — a targeted migration is a separate, larger decision for a human to make.
- Do not remove the empty `try { } catch { }` blocks you'll find throughout legacy code as "dead code cleanup" unless the specific task is about that block's behavior — some are load-bearing (they exist because a session key genuinely may be unset on first load).

## Credentials and secrets

- **Do not "fix" the hardcoded database credentials unprompted.** They're duplicated across `Solution.Web/web.config`, `Library.DAL/DataManager/SqlUserAccess.cs`, `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs`, and every root `*.ps1` script, and are already flagged in [`docs/security.md`](../docs/security.md). Changing them is an infrastructure decision (credential rotation, secret-store migration) that needs explicit user sign-off — don't do it as part of an unrelated task.
- If a task requires reading a connection string, read it; do not print full credentials into chat output or commit messages beyond what's needed.

## Root-level SQL/PowerShell scripts

- Files like `sp1.sql`, `sp2_alt.sql`, `alter_menu.sql`, `runsql.ps1`, `test_crud_invoice_not_binding.ps1` at the repo root are **working copies**, not applied by any build step (see [`docs/deployment.md`](../docs/deployment.md)). Don't treat their presence as evidence a procedure is "deployed" — the live source of truth is the database itself, which this repo does not give you access to.
- Each `.ps1` script embeds its own connection string, frequently pointing at a different server than the others. Before running one, check which server it targets and confirm that's intended — see the drift documented in [`docs/database.md`](../docs/database.md).

## When information is missing

- This documentation set marks gaps explicitly as **Not Found** rather than guessing (see `plans/` in particular, where no roadmap/task/sprint data exists in-repo). Follow the same discipline in your own output: if something can't be verified by reading a file in this repo, say so instead of inferring from typical ERP conventions.
- Domain acronyms (MIO, ASM, RSM, NSM, DA, DCR, DCP, DIC, TADA, etc. — see [`knowledge/glossary.md`](../knowledge/glossary.md)) are **not defined anywhere in the code**. Expansions given in the glossary are informed inferences from field/folder naming and pharma-industry convention, explicitly marked as such — do not present them as confirmed fact in generated docs or code comments.

## Security awareness while working

- Login passwords are compared in **plaintext** (`Library.DAL/PanalCls/PanalClsDAL.cs`) — there is no hashing anywhere in the auth path. If a task touches authentication, this is pre-existing behavior, not something you introduced; flag it rather than silently "fixing" it in an unrelated change, since a fix here needs a coordinated data migration.
- A number of DAL methods build SQL via string concatenation of user- or session-derived values (cataloged in [`docs/security.md`](../docs/security.md)). Do not copy this pattern into new code — use parameters — but also don't rewrite existing instances as a drive-by unless that's the task.

## Testing

- There is no automated test project. If you change behavior in a stored-procedure-backed flow, the existing verification method is a PowerShell script that hits a live database (see [`docs/testing.md`](../docs/testing.md)) — point it at a dev/staging database, never production, and say so explicitly if you run one.
