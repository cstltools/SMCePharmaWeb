# Implementation Plan — Order Payment Approval System

Date: 2026-08-20 · Requirement: `spec/requirements.md` · Requirement IDs: `requirements.md`
Impact: `docs/impact-analysis/order-payment-approval-impact.md` ·
Traceability: `docs/traceability/order-payment-approval-traceability.md`

Status: **implemented and tested** on the dev database (`SalesDisDB_SMC_NEWDB`):
60/60 procedure-layer checks via `test_order_payment_approval.ps1`, plus 34/34 checks driving the
real pages in Chrome against IIS Express. Both passing as of 2026-08-20.

---

## 1. Files modified

| File | Change |
|---|---|
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx` | `btnGoForApproval` + `lblApprovalStatus` added inside the existing "Go To Invoice" template column |
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx.cs` | status-aware `orderGridView_RowDataBound`; `btnGoForApproval_Click`; server-side gate in `gotoinvoiceButton_Click` and in `DataValidation()`; bounce-back message in `Page_Load` |
| `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs` | gate at the top of `Page_Load` |
| `Library.DAL/DataManager/DataAccessManager_daaw.cs` | **Bug fix in shared code.** `GetDataSet` skipped every second result set; see §12 |
| `Library.DAO/Library.DAO.csproj`, `Library.DAL/Library.DAL.csproj`, `Library.BLL/Library.BLL.csproj` | one `<Compile Include>` each |

## 2. Files created

| File | Layer |
|---|---|
| `Library.DAO/SInventory_Entities/OrderPaymentApprovalModels.cs` | status constants, view models, `InvoiceCreationGate` |
| `Library.DAL/SInventory_DAL/OrderPaymentApprovalRepository.cs` | proc marshalling; schedule → XML; `SqlException 50000` → message |
| `Library.BLL/SInventory_BLL/OrderPaymentApprovalService.cs` | thin service, `"Success"`-or-message convention |
| `Solution.Web/Approval_UI/OrderPaymentApprovalList.aspx(.cs)` | AM/DZSM/NSM worklist, schedule editor, history |
| `deploy_order_payment_approval.sql` | tables, trigger, functions, procs (idempotent) |
| `alter_orderlist_payment_approval.sql` | the two `ALTER PROCEDURE`s, generated from live definitions |
| `spec/database/menu/OrderPaymentApproval_menu.sql` | menu row SL 383 + role grants |
| `test_order_payment_approval.ps1` | end-to-end functional / security / integrity / regression suite |

## 3. Database changes

Three tables, one trigger, two inline TVFs, five procedures — listed in the impact analysis §4.
Nothing existing is altered except the two list procs (§4 below).

Design points worth stating:

- **`ApprovalStatus` 0–7 exactly as specified.** 1 (`AM Approved`) and 3 (`DZSM Approved`) are
  audit-only: one approver action writes both the "`<role>` Approved" history row and the
  "Pending `<next>`" row inside a single transaction, so the persisted header status walks
  0 → 2 → 4 → 5. This uses every specified code without ever leaving a request parked in a
  half-finished state.
- **Transition table**, enforced in `sp_OrderPaymentApproval_Act`:

  | From | Action | To | Who |
  |---|---|---|---|
  | 0 | Approve (schedule required) | 2 | AM assigned to this request |
  | 0 | Reject (reason required) | 6 | AM |
  | 2 | Approve | 4 | DZSM |
  | 2 | Reject | 6 | DZSM |
  | 4 | Approve (locks schedule) | 5 | NSM |
  | 4 | Reject | 6 | NSM |
  | 0/2/4 | Cancel | 7 | the requester only |
  | 5/6/7 | anything | — | refused: "already closed" |

- **Concurrency**: `UPDATE … WHERE ApprovalStatus = @expected AND IsActive = 1`, then
  `IF @@ROWCOUNT = 0 → rollback + "changed by another user"`. No extra rowversion column.
- **Re-submission**: statuses 6 and 7 set `IsActive = 0`, freeing the filtered unique index so a
  fresh request can be raised while the rejected one and its history survive intact.

## 4. Stored procedure changes

`sp_LoadOrderListForOrderCreationbyTerri` and `sp_LoadOrderListForOrderRouteDayWise` each gain
one `LEFT JOIN` and two output columns. `alter_orderlist_payment_approval.sql` was **generated
from `sys.sql_modules` at deploy time**, not hand-retyped, so every other byte matches what is
running. Run it only on a database whose two procs are at the current version; if they have
diverged, regenerate rather than force.

## 5. API changes

None. Deliberately: all rules live in the procedures, so a future `.asmx`/`.ashx` endpoint (for
the Flutter app) inherits every check by calling the same procs.

## 6. UI changes

`InvoiceCreationByOrder_daaw.aspx`, per `spec/requirements.md` Phase 18:

| Order state | Checkbox | Button / label |
|---|---|---|
| Normal | enabled | **Go To Invoice >>** |
| Credit blocked, no request | disabled | **Go for Approval** + red reason text |
| Status 0 | disabled | badge "Pending AM Approval" |
| Status 2 | disabled | badge "Pending DZSM Approval" |
| Status 4 | disabled | badge "Pending NSM Approval" |
| Status 5 | enabled | **Go To Invoice >>** |

`Approval_UI/OrderPaymentApprovalList.aspx` — one page for all three levels, following the
existing Approval_UI conventions (`NewMasterPage.master`, Bootstrap 5 card + GridView +
UpdatePanel, `pickadate` on `.datepicker`, `ShowSuccesalert`/`faildalert`,
`sweetAlertConfirm_Submit`). The AM step gets the payment-schedule editor; DZSM and NSM see the
plan read-only.

> Note: the sidebar row for Invoice Creation still points at the retired
> `InvoiceCreationByOrder.aspx` (`spec/modules.md`). That was true before this change and was
> left alone — see `docs/OPEN-QUESTIONS.md` Q4.

## 7. Security changes

- Procedures take `@ActionUserId` only and resolve `EmpInfoId` + `RoleTypeId` from
  `tblUser` → `tbl_UserRoleInfo`. **No role, employee id or level is accepted as a parameter.**
- Every action re-verifies (a) the caller's role type owns the current status and (b) the caller
  is the employee this request was routed to. Admin gets read-only oversight, not the ability to
  act on a level.
- `_GetList` and `_GetDetail` derive their row scope from the caller; `_GetDetail` refuses an id
  the caller has no relationship with (IDOR).
- The invoice gate is enforced on all three paths into invoice creation: the per-row button, the
  bulk selection in `DataValidation()`, and `Page_Load` of the invoice screen itself. The bulk
  path matters most — selections live in ViewState, so the button's disabled state is not a
  control there.
- All SQL is parameterised; no dynamic SQL was added. Proc messages reach the browser through
  `HttpUtility.JavaScriptStringEncode`.

## 8. Audit changes

`tblOrderPaymentApprovalHistory` records user, employee, role type, role name, action, from/to
status, remarks, plan version, old/new value and timestamp for every state change. An
`INSTEAD OF UPDATE, DELETE` trigger makes it append-only — a later `UPDATE` fails loudly instead
of quietly rewriting approval history. A full approve-through cycle leaves 6 rows.

## 9. Test changes

`test_order_payment_approval.ps1` — 60 assertions across the requirement's Phase 21 list:
functional (request, duplicate, AM/DZSM/NSM approve and reject, re-submission, final gate),
security (level bypass ×4, unknown action, IDOR), data integrity (concurrent-state guard,
duplicate approval, total mismatch, duplicate date, past date, zero/negative amount, invalid
transition, schedule locked, audit immutability), and regression (both list procs still return
the same rows and the same existing columns). It discovers its own test data and cleans up after
itself.

## 10. Deployment

1. Back up the target database.
2. `deploy_order_payment_approval.sql` — idempotent; safe to re-run.
3. `alter_orderlist_payment_approval.sql` — **verify the two procs are at the expected version
   first**; regenerate from live if not.
4. `spec/database/menu/OrderPaymentApproval_menu.sql` — check SL 383 is still free on the target
   (`SELECT * FROM tblMainMenuNew WHERE SL = 383`) before running.
5. Build: `nuget restore Solution.sln` then `msbuild Solution.sln /p:Configuration=Release`.
   Copy `Library.DAO.dll`, `Library.DAL.dll`, `Library.BLL.dll` into `Solution.Web/Bin` — the
   website compiles against that folder and the solution build does not refresh it.
6. Deploy `Solution.Web` as usual (`deploy/scripts/Deploy-WebDeploy.ps1`), then re-point the
   config with `deploy/scripts/Set-WebConfigValues.ps1` — there are no XDT transforms for this
   website project.
7. Smoke test: open Invoice Creation, confirm a credit-blocked row shows **Go for Approval** and
   a normal row still shows **Go To Invoice >>**.

Order matters: steps 2–3 before step 6, since the code-behind reads `PaymentApprovalStatus`.
Deploying the SQL early is harmless — the new columns are ignored by the old page.

## 11. Browser verification (what the UI test actually exercised)

Driven with Playwright against Chrome and the real IIS Express site, logging in as four different
users. Not a mock: every step is a genuine ASP.NET postback.

1. Requester opens Invoice Creation, territory-wise search → blocked row shows a disabled checkbox,
   no **Go To Invoice >>**, a **Go for Approval** button and "Credit period exceeded."
2. Clicks **Go for Approval** → success alert, row flips to the "Pending AM Approval" badge.
3. Logs in as the AM → request is in their worklist; opens it; schedule editor is present.
   A schedule totalling 1.00 is rejected with *"Total scheduled amount (1.00) must equal total due
   amount (2926.59)."*; a past date is rejected; a valid two-instalment plan is accepted.
4. DZSM → sees the plan **read-only** (no editor), 2 instalments, approves.
5. NSM → approves; status "Fully Approved"; history shows all 6 rows with names, roles, plan version
   and the schedule text.
6. Requester reopens Invoice Creation → **Go To Invoice >>** is visible and enabled again, checkbox
   re-enabled, **Go for Approval** gone.
7. AM reopens the now-closed request → no action buttons.

Three defects were found this way and fixed (§12). Screenshots were reviewed at each step.

## 12. Defects found by the browser test

1. **`DataAccessManager_daaw.GetDataSet` dropped every second result set** — `DataTable.Load` already
   advances the reader, and the loop called `NextResult()` on top of it. `_GetDetail` returns 3 sets,
   so the schedule set was swallowed. Fixed at the shared method; this also repairs
   `DAExpenseClaimList.aspx.cs:244`, whose claim-details table has always come back empty for the
   same reason. Detail in `spec/business-rules.md` §0.2.
2. **Misleading error message** — `LoadDetail` reported any short DataSet as "You are not authorized
   to view this approval request", sending the debugger down the wrong path. Authorization failure
   and load failure are now distinct messages, and the schedule/history tables are read defensively.
3. **Blank names in the audit trail** — `RequestedByName`/`ActionByName` joined only
   `tblEmpGeneralInfo`, so any account without an employee row (Admin has `EmpInfoId = 0`) showed a
   blank User column. Both now fall back to `tblUser.LoginName`.

Two environment findings, not defects: the AM test account has `IsPasswordChange = 0` in the dev
database, so the app's force-password-change modal blocks the page until that is dealt with; and
GridView child controls render with the row index appended (`..._chkSelect_6`), which matters for
anyone scripting these pages.

## 13. Rollback

Reverse order, and note that step 3 is the only one that has to be done carefully:

1. Redeploy the previous `Solution.Web` build and the previous three DLLs.
2. Restore the two list procs from their pre-change definitions (kept in
   `spec/database/procs/sp_LoadOrderListForOrderCreationbyTerri.sql` and the deployment
   snapshot taken in step 1 of the deployment). Dropping only the two added columns and the
   `LEFT JOIN` also suffices.
3. `DELETE FROM tblMenuRole WHERE SL = 383; DELETE FROM tblMainMenuNew WHERE SL = 383;`
4. Leave the new tables in place. They are not referenced by anything else, they cost nothing
   idle, and dropping them destroys approval history that may be needed to explain invoices that
   were already created under an approval. Drop them only after a deliberate decision:

   ```sql
   DROP TRIGGER  dbo.trg_tblOrderPaymentApprovalHistory_NoChange;
   DROP TABLE    dbo.tblOrderPaymentApprovalHistory;
   DROP TABLE    dbo.tblOrderPaymentApprovalSchedule;
   DROP TABLE    dbo.tblOrderPaymentApproval;
   DROP FUNCTION dbo.fnOrderApproverChain;
   DROP FUNCTION dbo.fnOrderCreditValidation;
   DROP PROCEDURE dbo.sp_OrderPaymentApproval_Request, dbo.sp_OrderPaymentApproval_Act,
                  dbo.sp_OrderPaymentApproval_GetList, dbo.sp_OrderPaymentApproval_GetDetail,
                  dbo.sp_OrderPaymentApproval_CanCreateInvoice;
   ```

Rolling back the web tier alone is safe at any time: the old page ignores the new columns, and
requests already in flight simply sit until the feature is redeployed.
