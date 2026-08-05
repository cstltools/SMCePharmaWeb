# Troubleshooting

**No support-ticket history, incident log, or bug tracker export exists in this repository** — the entries below are gotchas identified by static code analysis (things that *will* trip you up, verified against the actual code), not a record of past incidents. If you hit something not covered here, it isn't necessarily undocumented on purpose — this list reflects what surfaced during one documentation pass, not exhaustive coverage.

## "I get redirected to Login.aspx even though I'm testing a specific page"

The page's master page (`MasterPage.master`, `MainMasterPage.master`, or `NewMasterPage.master`) checks `Session["UserId"]` in its own `Page_Load` and redirects if unset. Log in through the UI first; there's no way to bypass this short of removing the master-page reference. See [`docs/security.md`](../docs/security.md).

## "I get a `NullReferenceException` calling a web-service/autocomplete method directly"

Several `SInventoryWebService.asmx` methods read `Session["ComUnitId"]`, `Session["UserType"]`, `Session["CompIDD"]`, etc. with no null check (`Session["ComUnitId"].ToString()` — throws if the key is unset). These are meant to be called from an already-authenticated browser session, not invoked standalone. See [`spec/api-spec.md`](../spec/api-spec.md).

## "My connection string change didn't take effect"

There are **three independent hardcoded connection-string sources** (`Solution.Web/web.config`, `Library.DAL/DataManager/SqlUserAccess.cs`, `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs`), plus every root `*.ps1` script has its own. Changing one does not change the others. Figure out which one the specific DAL class/script you're running actually reads — see [`docs/database.md`](../docs/database.md).

## "A query behaves differently than I expected / TLS-related connection error"

Check which of the four `DataAccessManager*` classes (`DataAccessManager`, `DataAccessManagerAsync`, `DataAccessManagerOld`, `DataAccessManager_daaw`) the DAL class in question actually uses — only one variant sets `Encrypt=True;TrustServerCertificate=True` on its connection string. See [`docs/database.md`](../docs/database.md).

## "I can't find `Solution.Web.csproj`"

There isn't one. `Solution.Web` is an AspNetCompiler **Website** project (see its entry in `Solution.sln`) — build/compile settings live in the `.sln` file's embedded `AspNetCompiler.*` properties and `Solution.Web/website.publishproj`, not a `.csproj`. See [`docs/deployment.md`](../docs/deployment.md).

## "The build/package versions don't line up"

`Solution.Web/packages.config` targets `net40` for every package, while all four `Library.*.csproj` files target `.NET Framework v4.8`. This mismatch is checked-in as-is; it hasn't been reported to break the build in this analysis, but it's worth knowing about if you hit a package-compatibility error. See [`docs/deployment.md`](../docs/deployment.md).

## "Why does a menu item I added not show up for a test user?"

Menu visibility is granted **per user**, not per role, via `Solution.Web/CommonUI/UserPermission.aspx` (`SaveMainMenu(sl, userId)`). A new menu entry has to be explicitly granted to each user who should see it — there's no "give this to everyone with role X" shortcut in the UI, and `UserId == 1` is the only account that bypasses the grant check entirely. See [`docs/security.md`](../docs/security.md).

## "An approval I expect to be pending shows as already resolved, or vice versa"

Approval routing (`ApprovalMapMaster`/`ApprovalMapDetail`) is role-sequenced — a record only becomes actionable by the role at its current `Step`. If your test user's `RoleTypeId` doesn't match the record's current `ToRoleTypeId`, the Approve/Reject buttons are disabled and the row shows "Waiting for Another Approver," which can look like a stuck/broken state if you don't know the routing table exists. See [`spec/workflow.md`](../spec/workflow.md). Also note: role `"5"` and employee ID `"496"` are hardcoded fast-path approvers in several workflows — if a record you expected to require multiple approvals resolves in one step, check whether that user/role triggered the bypass.

## "CI didn't run / deploy didn't happen"

There is no `.github/workflows/` directory in this repository, despite `docs/CI-CD-README.md` describing a full pipeline. The pipeline is designed but not implemented — see [`docs/deployment.md`](../docs/deployment.md). This is not a broken CI run; there is no CI configured yet.

## "A test script failed with a login/permission error against SQL Server"

Every root `*.ps1` test/utility script uses `sa` or another hardcoded SQL login. If that account's password has since been rotated on the target server (which `docs/CI-CD-README.md` explicitly recommends doing), the scripts will fail until updated — see [`docs/security.md`](../docs/security.md).

## "Where do I even find the automated tests to run before my change?"

There aren't any (see [`docs/testing.md`](../docs/testing.md)). If you need to verify a stored-proc-backed change, adapt `test_crud_invoice_not_binding.ps1` as a template and point it at a dev/staging database.

## "`docker-compose up` fails, the file isn't there"

`docker-compose.yml` and `docker-compose.prod.yml` are tracked by git but were found missing from
the working tree during this documentation pass (confirmed via `git status` showing them, and ~45
other root scripts, as locally deleted). Run `git checkout -- docker-compose.yml
docker-compose.prod.yml` to restore the last-committed version if you need them — but confirm with
whoever deleted them first, since it's a large simultaneous deletion, not an isolated accident. See
[`docs/deployment.md`](../docs/deployment.md).

## "I want to read a specific stored procedure's actual logic, not just its name"

You don't need database access for this anymore. Every procedure/function/view's full `CREATE`
source is checked into [`spec/database/`](../spec/database/) — `procs/<name>.sql`,
`functions/<name>.sql`, `views/<name>.sql`. Open the file directly instead of connecting to SQL
Server or asking for it to be re-pulled.
