# Requirement Traceability — Order Payment Approval System

Date: 2026-08-25 (rebuilt on the shared approval framework; first version 2026-08-20) ·
Requirement IDs defined in `requirements.md` ·
Test suite: `test_order_payment_approval.ps1` — 46 assertions at the procedure layer, passing.

Each row traces **Requirement → UI → Service → Repository → Stored procedure → Database → Test**.
Nothing in `requirements.md` is absent from this table.

`§n` references point into `test_order_payment_approval.ps1`'s output.

A browser drive is **not** recorded here: the 2026-08-20 pass covered pages the rebuild replaced,
so `UI§n` references have been removed rather than left pointing at a withdrawn design. NFR-OPA-08
is open.

---

## Functional

| ID | UI | Service | Repository | Stored procedure | Database | Test |
|---|---|---|---|---|---|---|
| FR-OPA-01 Credit validation gates invoice creation | `InvoiceCreationByOrder_daaw.aspx.cs` `orderGridView_RowDataBound` | — (proc-computed) | — | `sp_LoadOrderListForOrderCreationbyTerri`, `sp_LoadOrderListForOrderRouteDayWise` | `tblOrder`, `tblInvoice`, `tblInvoiceDetail`, `tblCustPayDetail`, `tblInvoiceNotBinding` | §2, §12 |
| FR-OPA-02 Normal order → **Go To Invoice >>** | `gotoinvoiceButton` | `.CanCreateInvoice` | `.CanCreateInvoice` | `sp_OrderPaymentApproval_CanCreateInvoice` | `fnOrderCreditValidation`, `fnOrderPaymentApprovalState` | §2 |
| FR-OPA-03 Blocked order → **Go for Approval** → commitment modal | `btnGoForApproval` → `pnlSchedule` / `mpeSchedule`; `btnScheduleSubmit_Click` | `.Post` | `.Post` → `BuildScheduleXml` | `sp_Post_OrderPaymentApp` | `tblOrderPaymentApprovalLog`, `tblOrderPaymentSchedule` | §4 |
| FR-OPA-04 The chain is configuration, not code | `UserPermission/ApprovalStepMap.aspx` (existing page, unchanged) | — | — | `sp_Post_OrderPaymentApp`, `sp_Save_OrderPaymentAppLog` read `tblApprovalMapMaster`/`Detail` | `tblApprovalMapMaster`, `tblApprovalMapDetail`, `tblRoleType` | §0 reads the live chain; §7 walks whatever it finds |
| FR-OPA-05 An approver acts only at their own step | `loadGridView_RowCommand` `ApproveData` | `.Approve` | `.Save` | `sp_Save_OrderPaymentAppLog` | `tblOrderPaymentApprovalLog.ToRoleTypeId` | §5, §7 |
| FR-OPA-06 Payment commitment captured with the request | `gvSchedule` + `btnAddScheduleRow_Click` / `gvSchedule_RowCommand` | `.Post(schedule)` | `.Post` → `@ScheduleXml` | `sp_Post_OrderPaymentApp` | `tblOrderPaymentSchedule` | §3, §4 |
| FR-OPA-07 Rejection closes the round | `loadGridView_RowCommand` `RejectData` + per-row `txtRemarks` | `.Reject` | `.Save` | `sp_Save_OrderPaymentAppLog` (`@Action='Reject'`) | `Status = 'Rejected'`, `ToRoleTypeId = NULL` | §5, §10 |
| FR-OPA-08 Re-submission after rejection | `btnGoForApproval` reappears (status resolves to `Rejected`) | `.Post` | `.Post` | `sp_Post_OrderPaymentApp` | new `Round`, new `PlanVersion` | §10 |
| FR-OPA-09 Approved order → invoice allowed | `orderGridView_RowDataBound` `Accepted` branch | `.CanCreateInvoice` | `.CanCreateInvoice` | `sp_OrderPaymentApproval_CanCreateInvoice` | `fnOrderPaymentApprovalState` | §8 |
| FR-OPA-10 Approver worklist | `OrderPaymentApprovalList.aspx` `loadGridView` + `IVMarketStructureInvoSearch.ascx` | `.GetList` | `.GetList` | `sp_Get_OrderPaymentApp` | `tblOrderPaymentApprovalLog`, `tblOrderPaymentSchedule`, `View_Webapi_EmployeeFieldForceInfo` | §6 |
| FR-OPA-11 Approval history | `lbHistory` → `pnlHistory` / `gvHistory` | `.GetHistory` | `.GetHistory` | `sp_Get_OrderPaymentAppHistory` | `tblOrderPaymentApprovalLog` | §9 |
| FR-OPA-12 Status visible on the Invoice Creation grid | `lblApprovalStatus` | — | — | the two list procs' `PaymentApprovalStatus` / `PaymentApprovalWaitingRole` | `tblOrderPaymentApprovalLog` (via `OUTER APPLY … TOP 1`) | §12 |
| FR-OPA-13 Menu entry and configurability | `tblMainMenuNew` SL 383, `IsApprovalPage = 1` | — | — | `sp_GET_MainMenuByType` (existing) reads the flag | `tblMainMenuNew`, `tblMenuRole` | verified live after applying the menu script |
| FR-OPA-14 Missing configuration must never auto-approve | error alert on the modal | `.Post` returns the proc message | `.Post` → `SqlException 50000` | `sp_Post_OrderPaymentApp`, `sp_Save_OrderPaymentAppLog` | `tblApprovalMapMaster` absence | §11 |

**Withdrawn from the first version** — no longer traced because the behaviour no longer exists:
`FR-OPA-10 (cancellation)`, `FR-OPA-14 (three-result-set detail panel)`, and the
territory-derived chain formerly traced through `dbo.fnOrderApproverChain` and
`tblASMInfo`/`tblRSMInfo`/`tblNSMInfo`.

## Business rules

| ID | Rule | Enforced in | Test |
|---|---|---|---|
| BR-OPA-01 | Approval may only be requested for a genuinely credit-blocked order | `sp_Post_OrderPaymentApp` via `fnOrderCreditValidation` | proc-guarded; §1 seeds only blocked orders |
| BR-OPA-02 | At most one live round per order | `sp_Post_OrderPaymentApp` + `UNIQUE (TableId, Round, Step)` | §4 "A second request while one is live is refused" |
| BR-OPA-03 | A chain must be configured for the raising role | `sp_Post_OrderPaymentApp` | §11 "An unconfigured role gets an error, not a silent auto-approve" |
| BR-OPA-04 | The request advances only to the next configured role | `sp_Save_OrderPaymentAppLog` | §7 status after each step; §5 "cannot jump the queue" |
| BR-OPA-05 | A closed round is immutable | `sp_Save_OrderPaymentAppLog` | §7 "cannot approve the same request twice" |
| BR-OPA-06 | An already-invoiced order cannot enter the workflow | `sp_Post_OrderPaymentApp` (`IsInvoice = 1` guard) | proc-guarded |
| BR-OPA-07 | The plan belongs to the round and is fixed once submitted | no update path exists | §10 (rework goes through reject → new round) |
| BR-OPA-08 | Total Due is snapshotted on the round | `DueAmount` on the log row | §4 |
| BR-OPA-09 | Existing invoice-creation behaviour is unchanged | `OUTER APPLY … TOP 1` only | §12 "did not duplicate or drop rows" (27 → 27) |

## Validation rules (payment commitment — all server-side)

| ID | Rule | Enforced in | Test |
|---|---|---|---|
| VR-OPA-10 | At least one instalment | `sp_Post_OrderPaymentApp` | §3 "No schedule at all is refused" |
| VR-OPA-11 | Payment date ≥ today | " | §3 "A date in the past is refused" |
| VR-OPA-12 | Payment amount > 0 | " + `CK_tblOPS_Amount` | §3 (client-side per-instalment check for 0 / blank) |
| VR-OPA-13 | No duplicate payment date | " + `UX_tblOPS_Order_Version_Date` | §3 "Duplicate dates are refused" |
| VR-OPA-14 | `PaymentNo` follows date order | `ROW_NUMBER() OVER (ORDER BY PaymentDate)` | §4 "Instalments stored against plan version 1" |
| VR-OPA-15 | `SUM(PaymentAmount) = DueAmount` (±0.01) | `sp_Post_OrderPaymentApp` | §3 "A total below the due amount is refused" (message carries both figures) |
| VR-OPA-17 | Rejection requires a reason | `sp_Save_OrderPaymentAppLog` + `OrderPaymentApprovalService.Reject` | §5 "Rejecting without a reason is refused" |
| VR-OPA-18 | Malformed date/amount reported per instalment | `InvoiceCreationByOrder_daaw.aspx.cs` `btnScheduleSubmit_Click` | UI-level; the proc refuses anything that gets past it |
| VR-OPA-19 | Date and amount both mandatory on a filled row | " | UI-level |
| — | Nothing is written by a refused attempt | transaction + validate-before-write ordering | §3 "Nothing was written by the refused attempts" (= 0 rows) |

## Security

| ID | Control | Enforced in | Test |
|---|---|---|---|
| SEC-OPA-01 | Identity and role resolved from `@ActionUserId`; nothing role-shaped is a parameter | all five procs | by construction; §5 |
| SEC-OPA-02 | The caller's role must be the one the request is waiting on | `sp_Save_OrderPaymentAppLog` | §5 "A later-stage approver cannot jump the queue" |
| SEC-OPA-03 | The caller must be inside the request's market | `sp_Save_OrderPaymentAppLog` | §5 "Right role, wrong market is refused" |
| SEC-OPA-04 | No level may be skipped | the current row's `ToRoleTypeId` is the gate | §5, §7 |
| SEC-OPA-05 | The worklist never returns a row outside the caller's scope | `sp_Get_OrderPaymentApp` | §6 (a later-stage approver sees it but `CanAct` is false) |
| SEC-OPA-06 | Invoice gate re-checked server-side on every path | `gotoinvoiceButton_Click`, `DataValidation()`, `InvoiceCreationForCustomerByOrder.Page_Load` | §2, §8, §10 |
| SEC-OPA-07 | No dynamic SQL; every parameter bound | all new procs and repository methods | by construction |
| SEC-OPA-08 | Proc messages JavaScript-encoded before reaching the browser | `HttpUtility.JavaScriptStringEncode` on both pages | by construction |
| SEC-OPA-09 | Page reachable only through the menu-permission gate | `UserPersmissionValidation()` | matches the other Approval_UI pages |
| SEC-OPA-10 | Oversight roles do not gain the ability to act | no role is special-cased; the chain decides | by construction (contrast `CustomerApproveList`, which bypasses for 4 / 5 / 14) |
| SEC-OPA-11 | CSRF | ViewState MAC + `sessionState InProc` | existing platform behaviour |

## Audit

| ID | Requirement | Enforced in | Test |
|---|---|---|---|
| AUD-OPA-01 | Person, role, action, timestamp, remarks per action | `tblOrderPaymentApprovalLog` — the log **is** the state, so state cannot change without an audit row | §9 "One history row per action" |
| AUD-OPA-02 | Plan version recorded | `tblOrderPaymentSchedule.PlanVersion` = log `Round` | §10 "...with its own plan version" |
| AUD-OPA-03 | Earlier rejected attempts survive | new `Round`; nothing overwritten or deactivated | §10 |
| AUD-OPA-04 | A full cycle is reconstructable | `sp_Get_OrderPaymentAppHistory` | §9 |

## Non-functional

| ID | Requirement | How met | Evidence |
|---|---|---|---|
| NFR-OPA-01 | No regression on the Invoice Creation grid | `OUTER APPLY … TOP 1` cannot multiply rows | §12 (27 → 27) |
| NFR-OPA-02 | Multi-statement changes are transactional | `BEGIN TRAN` + `XACT_ABORT ON` in both write procs | §3 "Nothing was written by the refused attempts" |
| NFR-OPA-03 | Concurrent approval is safe | `UPDLOCK, HOLDLOCK` on the current-row read + `UNIQUE (TableId, Round, Step)` | §7 "cannot approve the same request twice" |
| NFR-OPA-04 | Follows existing architecture and UI conventions | Service → Repository → proc; page shaped like `CustomerApproveList.aspx` | code review |
| NFR-OPA-05 | Deployment is idempotent and reversible | `deploy_order_payment_approval.sql` re-runnable and drops the first version; rollback in plan §13 | re-run verified |
| NFR-OPA-06 | Rules live where every future caller inherits them | all rules in stored procedures | by construction |
| NFR-OPA-07 | No unrelated module changed | only the files in the impact analysis | `git status` |
| NFR-OPA-08 | Works in a real browser | — | **Open.** Not re-run after the rebuild. |
