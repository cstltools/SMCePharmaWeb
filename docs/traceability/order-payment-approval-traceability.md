# Requirement Traceability — Order Payment Approval System

Date: 2026-08-20 · Requirement IDs defined in `requirements.md` ·
Test suites: `test_order_payment_approval.ps1` (procedure layer, 60 assertions) and a scripted
browser drive of the real pages (34 assertions) — both passing.

Each row traces **Requirement → UI → Service → Repository → Stored procedure → Database → Test**.
Nothing in `requirements.md` is absent from this table.

`§n` references point into `test_order_payment_approval.ps1`'s output. `UI§n` references point into
the browser drive, summarised in `docs/implementation/order-payment-approval-plan.md` §11.

---

## Functional

| ID | UI | Service | Repository | Stored procedure | Database | Test |
|---|---|---|---|---|---|---|
| FR-OPA-01 Credit validation gates invoice creation | `InvoiceCreationByOrder_daaw.aspx.cs` `orderGridView_RowDataBound` | — (proc-computed) | — | `sp_LoadOrderListForOrderCreationbyTerri`, `sp_LoadOrderListForOrderRouteDayWise` | `tblOrder`, `tblInvoice`, `tblInvoiceDetail`, `tblCustPayDetail`, `tblInvoiceNotBinding` | §1, §10, §11 |
| FR-OPA-02 Normal order → **Go To Invoice >>** | `gotoinvoiceButton` (`.aspx:493`) | `OrderPaymentApprovalService.CanCreateInvoice` | `OrderPaymentApprovalRepository.CanCreateInvoice` | `sp_OrderPaymentApproval_CanCreateInvoice` | `tblOrderPaymentApproval` (left join)  | §10 "Normal order can create an invoice", UI§6 |
| FR-OPA-03 Blocked order → **Go for Approval** | `btnGoForApproval` + `btnGoForApproval_Click` | `.Request` | `.Request` | `sp_OrderPaymentApproval_Request` | `tblOrderPaymentApproval`, `…History`  | §2 "Request created", UI§1–2 |
| FR-OPA-04 Approver chain resolved from the order's territory | — | — | — | `dbo.fnOrderApproverChain` inside `_Request` | `tblTerritory`, `tblArea`, `tblRegion`, `tblASMInfo`, `tblRSMInfo`, `tblNSMInfo` | §0 seed + §2 |
| FR-OPA-05 AM approval | `OrderPaymentApprovalList.aspx` `btnApprove_Click` | `.Approve` | `.Act` | `sp_OrderPaymentApproval_Act` (status 0) | `tblOrderPaymentApproval`, `…Schedule`, `…History`  | §5, UI§3 |
| FR-OPA-06 Payment schedule captured at the AM step | `gvScheduleEdit` + `btnAddRow_Click` | `.Approve(schedule)` | `.Act` → `BuildScheduleXml` | `sp_OrderPaymentApproval_Act` `@ScheduleXml` | `tblOrderPaymentApprovalSchedule`  | §4, §5, UI§3 |
| FR-OPA-07 DZSM approval | same page, role-scoped | `.Approve` | `.Act` | `sp_OrderPaymentApproval_Act` (status 2) | as above  | §6, UI§4 |
| FR-OPA-08 NSM final approval | same page, role-scoped | `.Approve` | `.Act` | `sp_OrderPaymentApproval_Act` (status 4 → 5) | `IsScheduleLocked = 1`  | §7, UI§5 |
| FR-OPA-09 Rejection at any level | `btnReject_Click` | `.Reject` | `.Act` | `sp_OrderPaymentApproval_Act` (`@Action='Reject'`) | status 6, `IsActive = 0` | §9 |
| FR-OPA-10 Cancellation by the requester | (service/proc ready; no button — see OQ-3) | `.Cancel` | `.Act` | `sp_OrderPaymentApproval_Act` (`@Action='Cancel'`) | status 7, `IsActive = 0` | proc path covered by the closed-request assertion, §7 |
| FR-OPA-11 Fully approved → invoice allowed | `orderGridView_RowDataBound` status 5 branch | `.CanCreateInvoice` | `.CanCreateInvoice` | `sp_OrderPaymentApproval_CanCreateInvoice` | `tblOrderPaymentApproval.ApprovalStatus = 5`  | §7 "Invoice creation now allowed", UI§6 |
| FR-OPA-12 Re-submission after rejection | `btnGoForApproval` reappears (status resolves to −1) | `.Request` | `.Request` | `sp_OrderPaymentApproval_Request` | filtered unique index on `IsActive = 1` | §9 "Re-submission after rejection is allowed" |
| FR-OPA-13 Approver worklist | `OrderPaymentApprovalList.aspx` `gvApprovalList` | `.GetList` | `.GetList` | `sp_OrderPaymentApproval_GetList` | all three tables  | §3 IDOR + UI§3–5 (AM/DZSM/NSM each saw only their own step) |
| FR-OPA-14 Request detail: header + schedule + history | `pnlDetail`, `gvScheduleView`, `gvHistory` | `.GetDetail` | `.GetDetail` | `sp_OrderPaymentApproval_GetDetail` | all three tables  | §3 "Stranger cannot read…", UI§3–5 |
| FR-OPA-15 Status visible on the Invoice Creation grid | `lblApprovalStatus` | — | — | the two list procs' `PaymentApprovalStatus` | `tblOrderPaymentApproval`  | §11 "PaymentApprovalStatus column present", UI§2 |
| FR-OPA-16 Menu entry | `tblMainMenuNew` SL 383 | — | — | — | `tblMainMenuNew`, `tblMenuRole` | verified live after applying the menu script |

## Business rules

| ID | Rule | Enforced in | Test |
|---|---|---|---|
| BR-OPA-01 | Approval may only be requested for a genuinely credit-blocked order | `sp_OrderPaymentApproval_Request` via `dbo.fnOrderCreditValidation` | §10 "not credit blocked" |
| BR-OPA-02 | At most one live request per order | filtered unique index + 2601/2627 catch | §2 "Duplicate request rejected" |
| BR-OPA-03 | A request needs a complete AM/DZSM/NSM chain | `sp_OrderPaymentApproval_Request` | §0 seed requires it; negative path is proc-guarded |
| BR-OPA-04 | Strict transitions 0→2→4→5, or →6/→7 | `sp_OrderPaymentApproval_Act` | §5–§7 |
| BR-OPA-05 | A closed request (5/6/7) is immutable | `sp_OrderPaymentApproval_Act` | §7 "already closed" |
| BR-OPA-06 | An already-invoiced order cannot enter the workflow | `sp_OrderPaymentApproval_Request` (`IsInvoice = 1` guard) | proc-guarded |
| BR-OPA-07 | NSM final approval locks the schedule | `sp_OrderPaymentApproval_Act` sets `IsScheduleLocked` | §7 "Payment schedule is locked" |
| BR-OPA-08 | Only the AM step authors the payment plan | `sp_OrderPaymentApproval_Act` | §6 "DZSM cannot rewrite the payment schedule" |
| BR-OPA-09 | Total due is snapshotted at request time | `sp_OrderPaymentApproval_Request` | §2 "Total due snapshotted" |

## Validation rules (payment schedule — all server-side)

| ID | Rule | Enforced in | Test |
|---|---|---|---|
| VR-OPA-10 | At least one instalment | `sp_OrderPaymentApproval_Act` | §4 "Empty schedule rejected" |
| VR-OPA-11 | Payment date ≥ today | " | §4 "Past payment date rejected", UI§3 |
| VR-OPA-12 | Payment amount > 0 | " + `CK_tblOPASchedule_Amount` | §4 zero + negative |
| VR-OPA-13 | No duplicate payment date | " + `UX_tblOPASchedule_Date` | §4 "Duplicate payment date rejected" |
| VR-OPA-14 | Dates ascending (`PaymentNo` assigned by date order) | `ROW_NUMBER() OVER (ORDER BY d, a)` | §5 "Payment numbers are date-ordered" |
| VR-OPA-15 | `SUM(PaymentAmount) = TotalDueAmount` (±0.005) | `sp_OrderPaymentApproval_Act` | §4 "not equal to total due", §5 "Scheduled total equals total due", UI§3 (message surfaced verbatim in the browser) |
| VR-OPA-16 | Schedule accepted only on the AM step | " | §6 "Only the AM step", UI§4 (DZSM gets no editor at all) |
| VR-OPA-17 | Rejection requires a reason | `sp_OrderPaymentApproval_Act` + `OrderPaymentApprovalService.Reject` | §9 "Rejection without a reason is refused" |
| VR-OPA-18 | Malformed date/amount text reported per instalment | `OrderPaymentApprovalList.aspx.cs` `ParseSchedule` | UI-level; proc rejects anything that gets past it |

## Security

| ID | Control | Enforced in | Test |
|---|---|---|---|
| SEC-OPA-01 | Identity and role resolved from `@ActionUserId`; nothing role-shaped is a parameter | all five procs | §3 (all four bypass attempts) |
| SEC-OPA-02 | Caller's role type must own the current status | `sp_OrderPaymentApproval_Act` | §3, §5, §6, §7 |
| SEC-OPA-03 | Caller must be the employee the request was routed to | `sp_OrderPaymentApproval_Act` | §3 "MIO cannot approve anything" |
| SEC-OPA-04 | Worklist scope derived from the caller, not from a client filter | `sp_OrderPaymentApproval_GetList` | by construction |
| SEC-OPA-05 | Detail refuses an unrelated request id (IDOR) | `sp_OrderPaymentApproval_GetDetail` | §3 "Stranger cannot read the request" |
| SEC-OPA-06 | Invoice gate re-checked server-side on every path | `gotoinvoiceButton_Click`, `DataValidation()`, `InvoiceCreationForCustomerByOrder.Page_Load` | §1, §5, §7, §9, UI§1/UI§6 |
| SEC-OPA-07 | No dynamic SQL; every parameter bound | all new procs and repository methods | by construction |
| SEC-OPA-08 | Proc messages JavaScript-encoded before reaching the browser | `RegisterClientAlert` on both pages | by construction |
| SEC-OPA-09 | Page reachable only through the menu-permission gate | `UserPermissionValidation()` | matches the other Approval_UI pages |

## Audit

| ID | Requirement | Enforced in | Test |
|---|---|---|---|
| AUD-OPA-01 | User, role, action, timestamp, from/to status, remarks recorded per action | `tblOrderPaymentApprovalHistory` writes in both procs | §8 "Full history recorded" |
| AUD-OPA-02 | Payment plan version recorded | `PaymentPlanVersion` column | §5 "Payment plan version incremented" |
| AUD-OPA-03 | Old/new value recorded where applicable (the schedule text on AM approval) | `NewValue` column | §8 |
| AUD-OPA-04 | Audit rows are never silently overwritten | `trg_tblOrderPaymentApprovalHistory_NoChange` | §8 update + delete both refused |

## Non-functional

| ID | Requirement | How met | Evidence |
|---|---|---|---|
| NFR-OPA-01 | No regression on the Invoice Creation grid | additive `LEFT JOIN` on a unique filtered index | §11 "did not duplicate or drop rows" (27 → 27) |
| NFR-OPA-02 | Multi-statement changes are transactional | `BEGIN TRAN` + `XACT_ABORT ON` in both write procs | §4 "Nothing was persisted by the rejected attempts" |
| NFR-OPA-03 | Concurrent approval is safe | `UPDATE … WHERE ApprovalStatus = @expected` + `@@ROWCOUNT` | §5 "AM cannot approve twice" |
| NFR-OPA-04 | Follows existing architecture and UI conventions | Service → Repository → proc; `NewMasterPage`, Bootstrap 5, GridView, pickadate, SweetAlert | code review + UI§1–7 screenshots reviewed |
| NFR-OPA-05 | Deployment is idempotent and reversible | `deploy_order_payment_approval.sql` is re-runnable; rollback in the plan §13 | re-run verified |
