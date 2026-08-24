# Implementation Plan — Order Payment Approval System

Date: 2026-08-25 (rebuilt on the shared approval framework; first version 2026-08-20) ·
Requirement IDs: `requirements.md` ·
Impact: `docs/impact-analysis/order-payment-approval-impact.md` ·
Traceability: `docs/traceability/order-payment-approval-traceability.md`

Status on the dev database (`SalesDisDB_SMC_NEWDB`), 2026-08-25:

- `test_order_payment_approval.ps1` — **46/46** procedure-layer assertions.
- `msbuild Solution.sln` — **0 errors**, including the `AspNetCompiler` pass over every `.aspx`.
- **Browser drive not re-run** since the rebuild. The 34/34 pass recorded on 2026-08-20 covered
  the withdrawn design (§11). NFR-OPA-08 is open.

---

## 0. What this rebuild changed, and why

The first version was standalone: `dbo.fnOrderApproverChain` hardcoded AM → DZSM → NSM, resolved a
named employee per level out of `tblASMInfo` / `tblRSMInfo` / `tblNSMInfo`, and ran its own 0–7
status machine over three tables and a trigger.

It now runs on the framework the other twelve `Approval_UI` pages use:

| Piece | Where |
|---|---|
| MenuId | `tblMainMenuNew.SL = 383`, `IsApprovalPage = 1` |
| The chain | `tblApprovalMapMaster` / `tblApprovalMapDetail`, configured on `UserPermission/ApprovalStepMap.aspx` |
| Role ids | `tblRoleType` |
| State + audit | `tblOrderPaymentApprovalLog` (mirrors `tblCustomerApprovalLog`) |
| Status words | `Posted` → `Verified` … → `Accepted` / `Rejected` |

Two measurements drove it. The territory-derived chain needed a named employee for the order's
exact area, region **and** group: live, 230 of 526 active territories had no `tblNSMInfo` row for
their group and 41 had no `tblRSMInfo` row — 18,471 orders in 90 days that could never have raised
a request. And three employees sitting in `tblASMInfo` as AM have a login role of DZSM, so 18 more
territories would have stalled at the first step. Matching on **role plus market scope** removes
all of it.

---

## 1. Files modified

| File | Change |
|---|---|
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx` | payment-commitment modal (`mpeSchedule` / `pnlSchedule`, `gvSchedule`); `btnGoForApproval` now opens it; three display-only `HiddenField`s for the modal header |
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx.cs` | `PaymentApprovalStatus` read as a string; modal handlers (open / add row / remove row / submit / close); server-side gate in `gotoinvoiceButton_Click` and `DataValidation()` |
| `Solution.Web/Approval_UI/OrderPaymentApprovalList.aspx(.cs)` | **rewritten** as a flat framework-shaped worklist |
| `Library.DAO/SInventory_Entities/OrderPaymentApprovalModels.cs` | **rewritten** — string status vocabulary; the 0–7 constants, view model and action-request class are gone |
| `Library.DAL/SInventory_DAL/OrderPaymentApprovalRepository.cs` | **rewritten** — `Post` / `Save` / `GetList` / `GetSchedule` / `GetHistory` / `CanCreateInvoice` |
| `Library.BLL/SInventory_BLL/OrderPaymentApprovalService.cs` | **rewritten** to match |
| `deploy_order_payment_approval.sql` | **rewritten**; also drops the previous implementation |
| `alter_orderlist_payment_approval.sql` | the `LEFT JOIN` on the retired header table replaced by an `OUTER APPLY … TOP 1` on the log |
| `spec/database/menu/OrderPaymentApproval_menu.sql` | idempotent; sets `IsApprovalPage = 1` |
| `test_order_payment_approval.ps1` | **rewritten** — reads the configured chain and walks it |

Unchanged from the first version and still load-bearing:
`Library.DAL/DataManager/DataAccessManager_daaw.cs` — see §12.

## 2. Files created

| File | Purpose |
|---|---|
| `spec/database/menu/OrderPaymentApproval_chain_sample.sql` | the intended default chain, written through the same two procedures ApprovalStepMap.aspx calls. **Not needed in production** — it exists so a dev database can be seeded without clicking, and so the default is written down. |

## 3. Database changes

Two tables, two inline TVFs, five procedures. The previous three tables, trigger, one TVF and four
procedures are dropped by §0 of the deploy script.

| Object | Role |
|---|---|
| `tblOrderPaymentApprovalLog` | one row per action; **the state lives here and nowhere else** |
| `tblOrderPaymentSchedule` | the instalment plan, one version per round |
| `fnOrderCreditValidation` | unchanged; "is this order blocked and by how much" |
| `fnOrderPaymentApprovalState` | "where is this order now" — one definition, so the gate, the list and the action proc cannot disagree |
| `sp_Post_OrderPaymentApp` | Go for Approval + plan validation |
| `sp_Get_OrderPaymentApp` | worklist, fully parameterised |
| `sp_Save_OrderPaymentAppLog` | Approve / Reject |
| `sp_OrderPaymentApproval_CanCreateInvoice` | the invoice gate |
| `sp_Get_OrderPaymentSchedule`, `sp_Get_OrderPaymentAppHistory` | plan rows, audit trail |

**No column is added to `tblOrder`.** The current state of order *X* is the log row with the
highest `(Round, Step)` for `TableId = X`.

### Deliberate differences from `tblCustomerApprovalLog`

1. **`Round`.** Customer approval treats `Rejected` as terminal — the record vanishes from the
   list and is never resubmitted. An order can be reworked, so each submission is a Round with
   `Step` restarting at 1. Without it the map lookup (`[Order] > @Step`) walks off the end of the
   configured chain on the second submission.
2. **Server-side authorization.** `sp_webapi_SaveCustomerAppLog` trusts the caller: "is it your
   turn" is a `HiddenField` comparison in the page, and the proc verifies nothing. Here the acting
   role, the acting employee and the market scope are all resolved from the database using the
   session `UserId`.
3. **No auto-approve on missing config.** The customer proc reads "no next role" as "chain
   finished" and stamps `Accepted` — so a page with no map rows self-approves on the first click.
   Here a missing map is an error (FR-OPA-14).
4. **Parameterised list proc.** `sp_Get_CustomerApp` concatenates a `@param` string built in the
   code-behind and `EXEC`s it. `sp_Get_OrderPaymentApp` takes typed parameters.
5. **Lean columns.** The customer log carries `ToGroupId`, `ToRegionId`, `ToAreaId`,
   `ToTerritoryId`, `EntryTimeS`, `ApproveByS`, `ApproveTimeS`, `EntryByApp`, `ApproveByApp` and
   more that nothing reads. Only the columns this workflow uses are kept.
6. **Market position of the ORDER, not of the actor.** `sp_webapi_SaveCustomerAppLog` overwrites
   `GroupId`/`RegionId`/`AreaId` with the *acting employee's* own market and does its filtering by
   joining the field-force view on the record's originator. Storing the order's own territory,
   area, region and group is what the scope checks actually need, and needs no join to answer.

Also **not** carried over: the customer proc's `IF (@NextRoleTypeId IS NULL **OR
@Status='Accepted'**)`. That extra `OR` is unique to `sp_webapi_SaveCustomerAppLog` — the other
eleven pages do not have it — and it is why approving a customer from the web page jumps straight
to `ActionStatus = 2` and skips the rest of the chain. `sp_webapi_SaveDoctorAppLog`'s
`IF (@NextRoleTypeId IS NULL AND @Status <> 'Rejected')` is the correct form and is what is used
here.

## 4. Stored procedure changes to existing objects

`sp_LoadOrderListForOrderCreationbyTerri` and `sp_LoadOrderListForOrderRouteDayWise` each gain one
`OUTER APPLY` and two output columns (`PaymentApprovalStatus`, `PaymentApprovalWaitingRole`).
`alter_orderlist_payment_approval.sql` was **generated from `sys.sql_modules`**, not hand-retyped,
so every other byte matches what is running. `OUTER APPLY … TOP 1` returns at most one row per
order, so the row count is provably unchanged — verified 27 → 27.

Run it only on a database whose two procs are at the current version; if they have diverged,
regenerate rather than force.

## 5. API changes

None. Deliberately: all rules live in the procedures, so a future `.asmx`/`.ashx` endpoint (for the
Flutter app) inherits every check by calling the same procs.

## 6. UI changes

### `InvoiceCreationByOrder_daaw.aspx`

| Order state | Checkbox | Button / label |
|---|---|---|
| Normal | enabled | **Go To Invoice >>** |
| Credit blocked, never submitted | disabled | **Go for Approval** + red reason text |
| `Posted` / `Verified` | disabled | badge "Waiting for &lt;role&gt;" |
| `Rejected` | disabled | badge "Payment Approval Rejected" **and Go for Approval again** |
| `Accepted` | enabled | **Go To Invoice >>** |

**Go for Approval** opens the payment commitment modal — the same `ModalPopupExtender` idiom the
page already uses for `pnl_1`. The modal shows order, customer and Total Due, an instalment grid
with Add / Remove, a running "Scheduled *x* of *y*" badge that turns green on match, and
**Send for Approval**. After a rejection it pre-fills with the previous round's plan.

### `Approval_UI/OrderPaymentApprovalList.aspx`

Shaped like `CustomerApproveList.aspx`: `IVMarketStructureInvoSearch.ascx` on top, one flat
GridView, inline ✔ / ✖ per row, and the framework's "Waiting for Another Approver" badge on rows
the caller cannot act on. Two departures:

- **The plan is a column, not a modal.** `2 instalment(s) · 31 Aug 2026 1,463.30 | 14 Sep 2026
  1,463.29`, concatenated in the list proc. The approver sees exactly what they are approving
  without opening anything, and the grid stays one-click.
- **`CanAct` is computed by the proc**, not by comparing a `HiddenField` to
  `Session["RoleTypeId"]` in the code-behind.

A **History** button expands one panel under the grid with every round and step for that order.

> Note: the sidebar row for Invoice Creation still points at the retired
> `InvoiceCreationByOrder.aspx` (`spec/modules.md`). That was true before this change and was left
> alone — see `docs/OPEN-QUESTIONS.md` Q4.

## 7. Security changes

- Procedures take `@ActionUserId` only and resolve `EmpInfoId` + `RoleTypeId` from
  `tblUser` → `tbl_UserRoleInfo`. **No role, employee id or level is accepted as a parameter.**
- Every action re-verifies (a) the caller's role is the one the request is waiting on and (b) the
  caller is inside the request's market — area / region / group / company unit per role.
- No role is special-cased. `CustomerApproveList` lets RoleTypeId 4 / 5 / 14 bypass the
  button-hiding loop entirely; here a role can act only if the configuration puts it in the chain.
- `sp_Get_OrderPaymentApp` derives row scope from the caller; the market dropdowns only narrow it.
- The invoice gate is enforced on all three paths into invoice creation: the per-row button, the
  bulk selection in `DataValidation()`, and `Page_Load` of the invoice screen itself. The bulk path
  matters most — selections live in ViewState, so the button's disabled state is not a control
  there.
- All SQL is parameterised; no dynamic SQL was added. Proc messages reach the browser through
  `HttpUtility.JavaScriptStringEncode`.

## 8. Audit changes

`tblOrderPaymentApprovalLog` records round, step, acting role, acting employee and user, status,
remarks, the order's market position, the due amount and the timestamp — one row per action.
Because the log **is** the state, there is no way to change state without writing the audit row.

The first version's separate history table and its `INSTEAD OF UPDATE, DELETE` trigger are gone.
That trigger was the only one in this schema and had to be disabled to clean up test data. Nothing
in the application issues `UPDATE` or `DELETE` against the log; re-add a trigger if the DBA wants
that enforced rather than conventional (AUD-OPA-05, withdrawn).

## 9. Test changes

`test_order_payment_approval.ps1` — 46 assertions. The important structural change: it **reads the
chain from `tblApprovalMapMaster`/`Detail` and walks whatever it finds**, and asserts no particular
sequence of roles. If MenuId 383 has no chain configured it says so and stops — the correct
outcome, not a failure of the code under test.

Sections: configured chain (§0), test-data discovery (§1), invoice gate (§2), plan validation (§3),
Go for Approval (§4), authorization (§5), worklist and `CanAct` (§6), walking the chain (§7), gate
after approval (§8), audit trail (§9), rejection and resubmission (§10), missing configuration
(§11), regression on both list procs (§12). It discovers its own test data and deletes only the
orders it touched.

## 10. Deployment

1. Back up the target database.
2. `deploy_order_payment_approval.sql` — idempotent; **also drops the first version's objects**.
3. `alter_orderlist_payment_approval.sql` — verify the two procs are at the expected version first;
   regenerate from live if not.
4. `spec/database/menu/OrderPaymentApproval_menu.sql` — check SL 383 is still free on the target
   (`SELECT * FROM tblMainMenuNew WHERE SL = 383`) before running.
5. **Configure the chain** on `UserPermission/ApprovalStepMap.aspx` → menu "Order Payment
   Approval". Nothing works until this is done, and by design nothing auto-approves in its absence.
   Mind the DisplayName trap: "NSM" in that dropdown is RoleTypeId 14; RoleTypeId 4 shows as
   "Regional Head".
6. Build: `nuget restore Solution.sln` then `msbuild Solution.sln /p:Configuration=Release`.
   Copy `Library.DAO.dll`, `Library.DAL.dll`, `Library.BLL.dll` into `Solution.Web/Bin` — the
   website compiles against that folder and the solution build does not refresh it.
7. Deploy `Solution.Web` as usual (`deploy/scripts/Deploy-WebDeploy.ps1`), then re-point the config
   with `deploy/scripts/Set-WebConfigValues.ps1` — there are no XDT transforms for this website
   project.
8. Smoke test: open Invoice Creation, confirm a credit-blocked row shows **Go for Approval** and a
   normal row still shows **Go To Invoice >>**.

Order matters: steps 2–3 before step 7, since the code-behind reads `PaymentApprovalStatus`.
Deploying the SQL early is harmless — the new columns are ignored by the old page.

## 11. Browser verification

**Open.** The first version was driven end to end in Chrome under IIS Express as four different
users (34/34, 2026-08-20), and that pass found three real defects, all fixed (§12). Those pages no
longer exist in that form, so the result does not carry over.

The driver and the environment facts are recorded here so re-running it is cheap:

- IIS Express serves the site from `.vs/Solution/config/applicationhost.config`, site
  `Solution.Web`, at `http://localhost:58461`.
- `tblUser.Password` is stored in plain text and compared literally by `PanalClsDAL.Login`, so test
  accounts can be read straight out of the database — nothing needs to be modified to log in.
- An account with `IsPasswordChange = 0` triggers the master page's force-password-change modal,
  which blocks the page. Pick accounts with `IsPasswordChange = 1` for a scripted drive.
- `loginButton` is a `LinkButton` (`__doPostBack`), so a driver must wait for the navigation rather
  than a click's own load event.
- GridView child controls render with the row index appended (`..._chkSelect_6`).

## 12. Defects found by the first version's browser test (all still fixed)

1. **`DataAccessManager_daaw.GetDataSet` dropped every second result set** — `DataTable.Load`
   already advances the reader, and the loop called `NextResult()` on top of it. Fixed at the
   shared method, which also repairs `DAExpenseClaimList.aspx.cs:244`, whose claim-details table
   had always come back empty for the same reason. This fix is **independent of the rebuild and
   still in place**; the rebuild happens not to use `GetDataSet` any more. Detail in
   `spec/business-rules.md` §0.2.
2. **Misleading error message** — a short DataSet was reported as an authorization failure.
   Moot now: the detail procedure it belonged to is gone.
3. **Blank names in the audit trail** — the history join used only `tblEmpGeneralInfo`, so accounts
   without an employee row showed a blank User column. `sp_Get_OrderPaymentAppHistory` has the same
   exposure for `Admin` (`EmpInfoId = 0`); worth a `tblUser.LoginName` fallback when the browser
   pass is redone.

## 13. Rollback

1. Redeploy the previous `Solution.Web` build and the previous three DLLs.
2. Restore the two list procs from their pre-change definitions (kept in
   `spec/database/procs/sp_LoadOrderListForOrderCreationbyTerri.sql` and the deployment snapshot
   taken in step 1). Dropping only the two added columns and the `OUTER APPLY` also suffices.
3. `DELETE FROM tblApprovalMapDetail WHERE ApprovalMapMasterId IN (SELECT ApprovalMapMasterId FROM tblApprovalMapMaster WHERE MenuId = 383);`
   then `DELETE FROM tblApprovalMapMaster WHERE MenuId = 383;`
4. `DELETE FROM tblMenuRole WHERE SL = 383; DELETE FROM tblMainMenuNew WHERE SL = 383;`
5. Leave the new tables in place. They are not referenced by anything else, they cost nothing idle,
   and dropping them destroys approval history that may be needed to explain invoices already
   created under an approval. Drop them only after a deliberate decision:

   ```sql
   DROP TABLE     dbo.tblOrderPaymentSchedule;
   DROP TABLE     dbo.tblOrderPaymentApprovalLog;
   DROP FUNCTION  dbo.fnOrderPaymentApprovalState;
   DROP FUNCTION  dbo.fnOrderCreditValidation;
   DROP PROCEDURE dbo.sp_Post_OrderPaymentApp, dbo.sp_Save_OrderPaymentAppLog,
                  dbo.sp_Get_OrderPaymentApp, dbo.sp_Get_OrderPaymentSchedule,
                  dbo.sp_Get_OrderPaymentAppHistory,
                  dbo.sp_OrderPaymentApproval_CanCreateInvoice;
   ```

Rolling back the web tier alone is safe at any time: the old page ignores the new columns, and
requests already in flight simply sit until the feature is redeployed.
