# Requirements — ePharma Order Payment Approval System

Date: 2026-08-20 · Brief: `spec/requirements.md` · Status legend: **Implemented** · **Existing**
(already true before this change, restated because the new behaviour depends on it) · **Deferred**

This document covers **both** the existing system behaviour it builds on and the new requested
behaviour, as required by the brief's Phase 10. Every requirement is traced end to end in
`docs/traceability/order-payment-approval-traceability.md`; impact in
`docs/impact-analysis/order-payment-approval-impact.md`; ambiguities and their resolutions in
`docs/OPEN-QUESTIONS.md`.

Verification, both passing on 2026-08-20 against `SalesDisDB_SMC_NEWDB`:

- `test_order_payment_approval.ps1` — **60/60** assertions at the stored-procedure layer. Section
  references below (§1–§11) point into that script's output.
- A scripted browser drive of the real pages under IIS Express, logging in as four different users —
  **34/34** assertions. Summarised in `docs/implementation/order-payment-approval-plan.md` §11; it
  found three defects, all fixed (§12 there), including a pre-existing bug in the shared
  `DataAccessManager_daaw.GetDataSet` that also affected the DA Expense Claim page.

---

## 1. Functional requirements

### FR-OPA-01 — Credit validation on the Invoice Creation list
**Description.** Every order on the Invoice Creation page is evaluated against the customer's
outstanding-invoice count, maximum due age, and credit limit, with per-customer and
per-customer-type overrides.
**Source.** Existing system; brief Phase 8 flow step "Credit Validation".
**Existing behaviour.** `sp_LoadOrderListForOrderCreationbyTerri` and
`sp_LoadOrderListForOrderRouteDayWise` emit `IsMaxOutstandingExceeded` and
`IsCreditPeriodExceeded`, computed from `tblInvoiceNotBinding` (customer rule beats
customer-type rule) with defaults 2 invoices / 45 days / 50,000.
**Required behaviour.** Unchanged.
**Impact.** None — reused as-is. `dbo.fnOrderCreditValidation` re-expresses the same rule per
order so server-side checks have an authority (see OQ-7).
**Acceptance.** Both procs still return the same rows and the same existing columns after the
change. **Status.** Existing (verified, §11).

### FR-OPA-02 — Normal order proceeds to invoice creation
**Description.** An order that passes credit validation keeps its enabled checkbox and
**Go To Invoice >>** button.
**Source.** Existing system; brief Phase 18 "Normal Order".
**Existing behaviour.** Checkbox and button enabled; button sets `Session["OrderId"]` and
redirects to `InvoiceCreationForCustomerByOrder.aspx`.
**Required behaviour.** Unchanged, plus a server-side re-check on click.
**Impact.** `gotoinvoiceButton_Click` now calls `sp_OrderPaymentApproval_CanCreateInvoice` first.
**Acceptance.** A non-blocked order returns `CanCreate = 1` and navigation succeeds.
**Status.** Implemented (§10).

### FR-OPA-03 — Credit-blocked order offers "Go for Approval"
**Description.** A blocked order shows a disabled checkbox and a **Go for Approval** button
instead of **Go To Invoice >>**.
**Source.** Brief Phase 18 "Credit Blocked".
**Existing behaviour.** Checkbox and button were disabled with a red reason label; there was no
route forward at all.
**Required behaviour.** Raise an approval request routed to the order's AM.
**Impact.** `btnGoForApproval` in the markup; `btnGoForApproval_Click`;
`sp_OrderPaymentApproval_Request`.
**Acceptance.** A blocked order creates a request at status 0 with the due amount snapshotted.
**Status.** Implemented (§2).

### FR-OPA-04 — Approver chain derived from the order's territory
**Description.** AM, DZSM and NSM are resolved per order rather than configured per request.
**Source.** Brief Phase 14; existing org structure.
**Existing behaviour.** The ladder exists — `tblTerritory.AreaId → tblASMInfo`,
`tblArea.RegionId → tblRSMInfo`, `tblRegion.GroupId → tblNSMInfo` — but no payment-approval
workflow used it.
**Required behaviour.** Resolve all three at request time and snapshot them on the request, so a
later org change cannot strand an in-flight approval.
**Impact.** `dbo.fnOrderApproverChain`; `AMEmpId`/`DZSMEmpId`/`NSMEmpId` columns.
**Acceptance.** A request cannot be created when any of the three is missing.
**Status.** Implemented (§0, §2).

### FR-OPA-05 — AM approval
**Description.** The assigned AM approves or rejects a request at status 0.
**Source.** Brief Phase 14.
**Existing behaviour.** None.
**Required behaviour.** Approving requires a valid payment schedule and moves the request to
Pending DZSM Approval.
**Impact.** `sp_OrderPaymentApproval_Act`; `Approval_UI/OrderPaymentApprovalList.aspx`.
**Acceptance.** Status 0 → 2; two history rows ("AM Approved", "Pending DZSM Approval").
**Status.** Implemented (§5).

### FR-OPA-06 — Payment schedule captured at the AM step
**Description.** The AM enters Payment No / Payment Date / Payment Amount rows against the Total
Due, with Scheduled and Remaining amounts shown.
**Source.** Brief Phase 15.
**Existing behaviour.** None.
**Required behaviour.** Schedule is stored per plan version and validated server-side (VR-OPA-10
… VR-OPA-16).
**Impact.** `tblOrderPaymentApprovalSchedule`; XML parameter on
`sp_OrderPaymentApproval_Act`; `gvScheduleEdit` on the approval page.
**Acceptance.** A valid schedule persists with date-ordered `PaymentNo`; every invalid one is
rejected and persists nothing. **Status.** Implemented (§4, §5).

### FR-OPA-07 — DZSM approval
**Description.** The assigned DZSM approves or rejects at status 2.
**Source.** Brief Phase 14. **Existing behaviour.** None.
**Required behaviour.** Approving moves the request to Pending NSM Approval; the DZSM sees the
plan read-only and cannot alter it.
**Impact.** `sp_OrderPaymentApproval_Act` (status 2 branch).
**Acceptance.** Status 2 → 4; a schedule supplied at this step is refused.
**Status.** Implemented (§6).

### FR-OPA-08 — NSM final approval
**Description.** The assigned NSM gives final approval at status 4.
**Source.** Brief Phase 14. **Existing behaviour.** None.
**Required behaviour.** Status becomes Fully Approved and the payment schedule is locked.
**Impact.** `sp_OrderPaymentApproval_Act` (status 4 branch); `IsScheduleLocked`.
**Acceptance.** Status 4 → 5 and `IsScheduleLocked = 1`. **Status.** Implemented (§7).

### FR-OPA-09 — Rejection at any level
**Description.** Any of the three approvers may reject the request at their own step.
**Source.** Brief Phase 14 (status 6), Phase 21. **Existing behaviour.** None.
**Required behaviour.** Status becomes Rejected, a reason is mandatory, and the request is
deactivated. **Impact.** `sp_OrderPaymentApproval_Act` (`@Action = 'Reject'`).
**Acceptance.** Rejection without a reason is refused; a rejected order still cannot be invoiced.
**Status.** Implemented (§9).

### FR-OPA-10 — Cancellation by the requester
**Description.** The user who raised a request may withdraw it before it closes.
**Source.** Brief Phase 14 (status 7). **Existing behaviour.** None.
**Required behaviour.** Status 7, request deactivated, only the original requester permitted.
**Impact.** `sp_OrderPaymentApproval_Act` (`@Action = 'Cancel'`);
`OrderPaymentApprovalService.Cancel`.
**Acceptance.** Cancel by a non-requester is refused. **Status.** Implemented at the
service/procedure layer; **no UI button** — the brief describes no screen for it (see OQ-3).

### FR-OPA-11 — Fully approved order may be invoiced
**Description.** Once fully approved, the order's checkbox and **Go To Invoice >>** are enabled
again despite the credit block.
**Source.** Brief Phase 18 "Final Approved". **Existing behaviour.** None — a blocked order was
blocked permanently.
**Required behaviour.** `CanCreateInvoice` returns true only at status 5.
**Impact.** `sp_OrderPaymentApproval_CanCreateInvoice`; the status-5 branch in
`orderGridView_RowDataBound`.
**Acceptance.** Gate flips from false to true exactly at NSM approval. **Status.** Implemented
(§1 → §7).

### FR-OPA-12 — Re-submission after rejection
**Description.** A rejected order may be re-submitted for approval.
**Source.** Brief Phase 21 "Re-submission". **Existing behaviour.** None.
**Required behaviour.** A new request row is created; the rejected one and its history survive.
**Impact.** `IsActive = 0` on close; filtered unique index only covers live rows.
**Acceptance.** After rejection a new request succeeds and exactly one live request exists.
**Status.** Implemented (§9). Unlimited — see OQ-5.

### FR-OPA-13 — Approver worklist
**Description.** AM, DZSM and NSM see the requests routed to them, filterable by status and
request date, with Total Due / Scheduled / Remaining per row.
**Source.** Brief Phases 15, 17, 18. **Existing behaviour.** None.
**Required behaviour.** One page serving all three levels; scope derived from the caller.
**Impact.** `Approval_UI/OrderPaymentApprovalList.aspx`; `sp_OrderPaymentApproval_GetList`.
**Acceptance.** A user sees only their own level's rows; `CanAct` is true only on their step.
**Status.** Implemented.

### FR-OPA-14 — Request detail: header, schedule, history
**Description.** Opening a request shows customer and amounts, the payment schedule, and the
full approval history.
**Source.** Brief Phases 15, 16. **Existing behaviour.** None.
**Required behaviour.** Three result sets from one procedure, authorization-checked.
**Impact.** `sp_OrderPaymentApproval_GetDetail`; `pnlDetail`.
**Acceptance.** An unrelated user requesting the id is refused. **Status.** Implemented (§3).

### FR-OPA-15 — Approval status visible on the Invoice Creation grid
**Description.** A blocked order in flight shows "Pending AM / DZSM / NSM Approval" in place of
the button.
**Source.** Brief Phase 18. **Existing behaviour.** None.
**Required behaviour.** Status comes from the list procs, not a second round-trip.
**Impact.** `PaymentApprovalStatus` / `PaymentApprovalId` columns; `lblApprovalStatus`.
**Acceptance.** Both list procs expose the column and row counts are unchanged.
**Status.** Implemented (§11).

### FR-OPA-16 — Navigation
**Description.** The approval page is reachable from the sidebar.
**Source.** Existing menu convention. **Existing behaviour.** N/A.
**Required behaviour.** `tblMainMenuNew` SL 383 under "Approval Operation" (347), granted to the
Order Approval List's roles plus AM.
**Impact.** `spec/database/menu/OrderPaymentApproval_menu.sql`.
**Acceptance.** The row and six role grants exist. **Status.** Implemented (verified live).

---

## 2. Business rules

| ID | Rule | Existing behaviour | Required behaviour | Enforced in | Status |
|---|---|---|---|---|---|
| BR-OPA-01 | Approval may only be requested for a genuinely credit-blocked order | n/a | request refused otherwise, recomputed server-side | `sp_OrderPaymentApproval_Request` | Implemented (§10) |
| BR-OPA-02 | At most one live request per order | n/a | second attempt refused, race-safe | filtered unique index + 2601/2627 catch | Implemented (§2) |
| BR-OPA-03 | A complete AM/DZSM/NSM chain is required | n/a | request refused with a "contact MIS" message | `sp_OrderPaymentApproval_Request` | Implemented |
| BR-OPA-04 | Transitions are strictly 0→2→4→5, or →6 / →7 | n/a | any other transition refused | `sp_OrderPaymentApproval_Act` | Implemented (§5–§7) |
| BR-OPA-05 | A closed request (5/6/7) is immutable | n/a | further actions refused | `sp_OrderPaymentApproval_Act` | Implemented (§7) |
| BR-OPA-06 | An already-invoiced order cannot enter the workflow | n/a | request refused | `sp_OrderPaymentApproval_Request` | Implemented |
| BR-OPA-07 | NSM final approval locks the payment schedule | n/a | `IsScheduleLocked = 1` | `sp_OrderPaymentApproval_Act` | Implemented (§7) |
| BR-OPA-08 | Only the AM step authors the payment plan | n/a | schedule at any other step refused | `sp_OrderPaymentApproval_Act` | Implemented (§6) |
| BR-OPA-09 | Total Due is snapshotted at request time | n/a | later payments do not move the target the AM planned against | `sp_OrderPaymentApproval_Request` | Implemented (§2) |
| BR-OPA-10 | Existing invoice-creation behaviour for non-blocked orders is unchanged | current behaviour | unchanged | additive `LEFT JOIN` only | Implemented (§10, §11) |

---

## 3. Validation rules — payment schedule

All are enforced **server-side** in `sp_OrderPaymentApproval_Act`. Client-side checks exist only
to give faster feedback and are not the gate.

| ID | Rule | Acceptance | Status |
|---|---|---|---|
| VR-OPA-10 | At least one instalment | empty schedule refused | Implemented (§4) |
| VR-OPA-11 | Payment date ≥ today | yesterday refused | Implemented (§4) |
| VR-OPA-12 | Payment amount > 0 | 0 and −10 refused; also a CHECK constraint | Implemented (§4) |
| VR-OPA-13 | No duplicate payment date | duplicate refused; also a unique index | Implemented (§4) |
| VR-OPA-14 | Payment dates ascending | `PaymentNo` assigned by date order; no out-of-order pair persists | Implemented (§5) |
| VR-OPA-15 | `SUM(PaymentAmount) = TotalDueAmount` (±0.005) | mismatch refused with both figures in the message | Implemented (§4, §5) |
| VR-OPA-16 | Schedule accepted only at the AM step | DZSM attempt refused | Implemented (§6) |
| VR-OPA-17 | Rejection requires a reason | blank reason refused | Implemented (§9) |
| VR-OPA-18 | Unparseable date/amount reported per instalment | message names the instalment number | Implemented (UI) |
| VR-OPA-20 | Server-side validation messages reach the user verbatim, not as a generic failure | confirmed in the browser: *"Total scheduled amount (1.00) must equal total due amount (2926.59)."* | Implemented |
| VR-OPA-19 | Payment date and amount are both mandatory on a filled row | refused | Implemented |

---

## 4. Security requirements

| ID | Requirement | Existing behaviour | Required behaviour | Status |
|---|---|---|---|---|
| SEC-OPA-01 | Identity and role are resolved from the session's `UserId` inside the database; no role, employee id or level is a procedure parameter | many existing procs accept caller-supplied scope parameters (`spec/business-rules.md` BR-DRB-10) | new procs take `@ActionUserId` only | Implemented (§3) |
| SEC-OPA-02 | The caller's role type must own the current status | n/a | AM only at 0, DZSM only at 2, NSM only at 4 | Implemented (§3, §5–§7) |
| SEC-OPA-03 | The caller must be the employee the request was routed to | n/a | right role but wrong person is refused | Implemented (§3) |
| SEC-OPA-04 | No approval level may be skipped | n/a | the status is the gate; there is no "approve to" parameter | Implemented (§3) |
| SEC-OPA-05 | Detail refuses an unrelated request id (IDOR) | n/a | refused with an authorization error | Implemented (§3) |
| SEC-OPA-06 | The invoice gate is re-checked server-side on every path into invoice creation | UI-only disabling | per-row click, bulk `DataValidation()`, and the invoice screen's `Page_Load` | Implemented (§1, §7, §9) |
| SEC-OPA-07 | No dynamic SQL; all parameters bound | mixed across the codebase | no dynamic SQL added | Implemented |
| SEC-OPA-08 | Procedure messages are JavaScript-encoded before display (XSS) | `RegisterClientAlert` already does this on the invoice page | same helper on the new page | Implemented |
| SEC-OPA-09 | The approval page is behind the standard menu-permission check | pattern exists on other Approval_UI pages | `UserPermissionValidation()` | Implemented |
| SEC-OPA-10 | Admin gets read-only oversight, not the ability to act on a level | n/a | `CanAct` false for role type 5 | Implemented |
| SEC-OPA-11 | CSRF | ASP.NET ViewState MAC + `sessionState InProc`, as elsewhere in the app | unchanged; no new anonymous or GET-mutating endpoint | Existing |

---

## 5. Audit requirements

| ID | Requirement | Required behaviour | Status |
|---|---|---|---|
| AUD-OPA-01 | Every approval action is auditable: user, role, action, date/time, from status, to status, remarks | one `tblOrderPaymentApprovalHistory` row per logical state change | Implemented (§8) |
| AUD-OPA-02 | Payment plan version is recorded | `PaymentPlanVersion` on the header, the schedule rows and every history row | Implemented (§5) |
| AUD-OPA-03 | Old/new value recorded where applicable | the schedule text is written to `NewValue` on AM approval | Implemented (§8) |
| AUD-OPA-04 | Audit records must not be silently overwritten | `INSTEAD OF UPDATE, DELETE` trigger raises | Implemented (§8) |
| AUD-OPA-05 | A full approve-through cycle is reconstructable | 6 history rows: Requested, AM Approved, Pending DZSM, DZSM Approved, Pending NSM, NSM Approved | Implemented (§8) |

---

## 6. Non-functional requirements

| ID | Requirement | How met | Status |
|---|---|---|---|
| NFR-OPA-01 | No regression on the Invoice Creation grid | additive `LEFT JOIN` on a unique filtered index; row count verified identical | Implemented (§11) |
| NFR-OPA-02 | Multi-statement changes are transactional | `BEGIN TRANSACTION` + `XACT_ABORT ON` in both write procs | Implemented (§4) |
| NFR-OPA-03 | Concurrent approval is safe | `UPDATE … WHERE ApprovalStatus = @expected` + `@@ROWCOUNT` guard | Implemented (§5) |
| NFR-OPA-04 | Follows the existing architecture, coding standards and UI conventions | Service → Repository → stored procedure; `NewMasterPage.master`, Bootstrap 5, GridView, UpdatePanel, pickadate, SweetAlert; `"Success"`-or-message validation style | Implemented |
| NFR-OPA-05 | Deployment is idempotent; rollback is documented | `deploy_order_payment_approval.sql` re-runnable; plan §13 | Implemented |
| NFR-OPA-06 | Rules live where every future caller inherits them | all rules in stored procedures, so a later API endpoint gets them for free | Implemented |
| NFR-OPA-07 | No unrelated module is changed | only the files named in the impact analysis are modified | Implemented |
| NFR-OPA-08 | The pages work in a real browser, not just in a build | 34/34 browser assertions across the full AM → DZSM → NSM flow, screenshots reviewed | Implemented |

---

## 7. Deferred / not implemented

| ID | Item | Reason |
|---|---|---|
| FR-OPA-10 (UI) | Cancel button | The brief describes no screen for cancellation. Procedure and service support it and are authorization-checked. OQ-3. |
| FR-OPA-17 | "Last request was rejected" badge on the Invoice Creation grid | Not in the brief's Phase 18 UI table. OQ-4. |
| FR-OPA-18 | Gating the sample / doctor / sub-depot / DA invoice-creation paths | The brief names one Invoice Creation page. Extending the gate is a two-line change per page. OQ-8. |
| FR-OPA-19 | Recording actual payments against the approved schedule | Out of scope: the brief covers agreeing and approving the plan, not collecting against it. |
| NFR-OPA-09 | Collapsing the credit rule to a single definition | Perf-risky rewrite of two hot procs, outside this requirement. OQ-7. |
| PRE-1 | Fixing the pre-existing `SInventory_UI_IVMarketStructureInvoSearch` class-name collision that breaks full precompilation | Unrelated pre-existing defect. `docs/OPEN-QUESTIONS.md`. |
