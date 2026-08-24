# Requirements — ePharma Order Payment Approval System

Date: 2026-08-25 (rebuilt on the shared approval framework; first version 2026-08-20) ·
Brief: `spec/requirements.md` · Status legend: **Implemented** · **Existing** (already true before
this change, restated because the new behaviour depends on it) · **Withdrawn** (was in the first
version, deliberately removed by the rebuild) · **Deferred**

This document covers **both** the existing system behaviour it builds on and the new requested
behaviour. Every requirement is traced end to end in
`docs/traceability/order-payment-approval-traceability.md`; impact in
`docs/impact-analysis/order-payment-approval-impact.md`; ambiguities and their resolutions in
`docs/OPEN-QUESTIONS.md`.

## What changed on 2026-08-25, and why

The first version implemented the workflow **standalone**: `dbo.fnOrderApproverChain` hardcoded
AM → DZSM → NSM, resolved a named employee per level from `tblASMInfo`/`tblRSMInfo`/`tblNSMInfo`,
and ran its own 0–7 status machine.

It has been rebuilt on the **approval framework the other twelve `Approval_UI` pages already
use** — `tblApprovalMapMaster`/`tblApprovalMapDetail`, configured per page on
`UserPermission/ApprovalStepMap.aspx`, with `tblRoleType` role ids and a
`tbl<X>ApprovalLog` table per module. Three reasons:

1. **The chain becomes configuration.** Changing who approves is a change on
   ApprovalStepMap.aspx, not a code deployment.
2. **It survives incomplete org data.** The old chain needed a named employee in
   `tblASMInfo`/`tblRSMInfo`/`tblNSMInfo` for the order's exact area/region/group. Measured live,
   230 of 526 active territories had no `tblNSMInfo` row for their group and 41 had no
   `tblRSMInfo` row — 18,471 orders in 90 days that could never have raised a request. The
   framework matches on **role plus market scope**, so any NSM in the group can act.
3. **One shape to maintain.** An approval page in this system now looks like every other one.

The framework's own weaknesses were **not** inherited — see §4 and
`docs/implementation/order-payment-approval-plan.md` §3.

## Verification status

- `test_order_payment_approval.ps1` — **46/46** assertions at the stored-procedure layer, against
  `SalesDisDB_SMC_NEWDB`, 2026-08-25. Section references below (§1–§12) point into that script's
  output. The suite reads the configured chain and walks whatever it finds; it asserts no
  particular sequence of roles.
- `msbuild Solution.sln` — 0 errors, including the `AspNetCompiler` pass over every `.aspx`.
- **Browser drive: not re-run since the rebuild.** The first version's 34/34 browser pass
  (2026-08-20) covered pages that no longer exist in that form. NFR-OPA-08 is therefore **open**.

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
change. **Status.** Existing (verified, §12).

### FR-OPA-02 — Normal order proceeds to invoice creation
**Description.** An order that passes credit validation keeps its enabled checkbox and
**Go To Invoice >>** button.
**Source.** Existing system; brief Phase 18 "Normal Order".
**Existing behaviour.** Checkbox and button enabled; button sets `Session["OrderId"]` and
redirects to `InvoiceCreationForCustomerByOrder.aspx`.
**Required behaviour.** Unchanged, plus a server-side re-check on click.
**Impact.** `gotoinvoiceButton_Click` calls `sp_OrderPaymentApproval_CanCreateInvoice` first.
**Acceptance.** A non-blocked order returns `CanCreate = 1` and navigation succeeds.
**Status.** Implemented (§2).

### FR-OPA-03 — Credit-blocked order offers "Go for Approval"
**Description.** A blocked order shows a disabled checkbox and a **Go for Approval** button
instead of **Go To Invoice >>**. Clicking it opens the payment commitment modal (FR-OPA-06).
**Source.** Brief Phase 18 "Credit Blocked".
**Existing behaviour.** Checkbox and button were disabled with a red reason label; there was no
route forward at all.
**Required behaviour.** Capture the payment commitment, then open a round routed to the first
role in the configured chain.
**Changed 2026-08-25.** The button no longer posts the request directly; it opens the modal, and
the modal's **Send for Approval** posts it. The `sweetAlertConfirm_Submit` confirm was removed
from the button — the modal is the confirmation step.
**Impact.** `btnGoForApproval` + `pnlSchedule`/`mpeSchedule` in the markup;
`btnGoForApproval_Click` and the modal handlers; `sp_Post_OrderPaymentApp`.
**Acceptance.** A blocked order creates a `Posted` row at Round *n*, Step 1, pointing at the
first configured approver, with the plan stored at `PlanVersion = n`. **Status.** Implemented (§4).

### FR-OPA-04 — The approval chain is configuration, not code
**Description.** Who approves, in what order, is read from the approval-map configuration for
this page; no role is hardcoded anywhere in SQL or C#.
**Source.** Rebuild decision, 2026-08-25 (replaces the territory-derived chain).
**Previous behaviour (withdrawn).** `dbo.fnOrderApproverChain` walked
`tblTerritory.AreaId → tblASMInfo`, `tblArea.RegionId → tblRSMInfo`,
`tblRegion.GroupId → tblNSMInfo` and snapshotted three named employees on the request.
**Required behaviour.** `tblApprovalMapMaster` (MenuId 383, FromRoleId = the role that raised the
request) joined to `tblApprovalMapDetail` (`[Order]`, `ToRoleId`) is the chain. `[Order] = 1` is
the raising role itself; the approver at Step *n* is the row at `[Order] = n + 1`, exactly as in
`sp_webapi_SaveCustomerAppLog`. The only constant in the code is `MenuId = 383`.
**Impact.** `sp_Post_OrderPaymentApp`, `sp_Save_OrderPaymentAppLog`;
`spec/database/menu/OrderPaymentApproval_chain_sample.sql` records the intended default.
**Acceptance.** Changing the chain on `UserPermission/ApprovalStepMap.aspx` changes the runtime
behaviour with no deployment. The test suite reads the configuration rather than assuming it.
**Status.** Implemented (§0, §7).

> **Naming trap.** ApprovalStepMap.aspx shows `tblRoleType.DisplayName`; the approval pages match
> on `tblRoleType.RoleType`. They disagree for two rows: RoleTypeId 4 is `RoleType = 'NSM'` but
> `DisplayName = 'Regional Head'`, and RoleTypeId 14 is `RoleType = 'Head of NSM'` but
> `DisplayName = 'NSM'`. Picking "NSM" in the dropdown configures RoleTypeId **14**.

### FR-OPA-05 — An approver acts only at their own step
**Description.** The role the request is currently waiting on approves or rejects; every other
role is refused.
**Source.** Brief Phase 14, generalised by the rebuild.
**Previous behaviour (withdrawn).** Three fixed branches: AM at status 0, DZSM at 2, NSM at 4.
**Required behaviour.** The current row's `ToRoleTypeId` is the gate. Approving writes the next
log row with `Status = 'Verified'` and the next configured role; the last role in the chain
writes `Status = 'Accepted'`. The status vocabulary is the framework's:
`Posted` → `Verified` … → `Accepted` / `Rejected`.
**Impact.** `sp_Save_OrderPaymentAppLog`; `Approval_UI/OrderPaymentApprovalList.aspx`.
**Acceptance.** A later-stage approver cannot jump the queue; the same approver cannot act twice.
**Status.** Implemented (§5, §7).

### FR-OPA-06 — Payment commitment is captured with the request
**Description.** The instalment plan (Payment Date / Amount, against the Total Due) is entered by
the person raising the request, in a modal on the Invoice Creation page.
**Source.** Brief Phase 15; placement decided 2026-08-25.
**Previous behaviour (withdrawn).** The plan was authored by the AM inside the approval page, with
a per-request editor, plan versions and an `IsScheduleLocked` flag.
**Required behaviour.** The plan belongs to the round. Approvers see it **read-only** and either
accept it or reject with a reason; a rejected round is reworked by the requester and resubmitted
as a new round with its own `PlanVersion`.
**Rationale.** The framework's grid is one-click by design, and its own answer for "this record
needs more than yes/no" is to open the entry page (`CustomerApproveList` → `CustomerEntry.aspx`).
Data entry belongs on the entry side. It also gives "what exactly did the last approver approve?"
one answer, and removes any question of two approvers editing one plan.
**Cost, accepted.** An approver who wants a different date must reject and let the requester
change it — one extra round trip.
**Impact.** `pnlSchedule` modal on `InvoiceCreationByOrder_daaw.aspx`; `tblOrderPaymentSchedule`;
`@ScheduleXml` on `sp_Post_OrderPaymentApp`.
**Acceptance.** A valid plan persists with date-ordered `PaymentNo`; every invalid one is refused
and persists nothing. **Status.** Implemented (§3, §4).

### FR-OPA-07 — Rejection closes the round
**Description.** Any approver may reject at their own step, with a mandatory reason.
**Source.** Brief Phase 14, Phase 21. **Existing behaviour.** None.
**Required behaviour.** A `Rejected` row is written with no `ToRoleTypeId`; the round is closed
and the order cannot be invoiced.
**Impact.** `sp_Save_OrderPaymentAppLog` (`@Action = 'Reject'`).
**Acceptance.** Rejection without a reason is refused; a rejected order still cannot be invoiced.
**Status.** Implemented (§5, §10).

### FR-OPA-08 — Re-submission after rejection
**Description.** A rejected order may be reworked and re-submitted.
**Source.** Brief Phase 21 "Re-submission". **Existing behaviour.** None.
**Required behaviour.** A new **Round** is opened with `Step` restarting at 1 and its own
`PlanVersion`; the rejected round and its history survive. The modal pre-fills with the previous
plan so a rework is an edit, not a retype.
**Changed 2026-08-25.** The first version used `IsActive = 0` on a header row plus a filtered
unique index. Rounds replace that: without them the map lookup (`[Order] > @Step`) walks off the
end of the configured chain on the second submission.
**Acceptance.** After rejection a new request succeeds as Round 2 / Step 1 / `PlanVersion = 2`.
**Status.** Implemented (§10). Unlimited — see OQ-5.

### FR-OPA-09 — Fully approved order may be invoiced
**Description.** Once the chain is exhausted, the order's checkbox and **Go To Invoice >>** are
enabled again despite the credit block.
**Source.** Brief Phase 18 "Final Approved". **Existing behaviour.** None — a blocked order was
blocked permanently.
**Required behaviour.** `CanCreateInvoice` returns true only when the current row is `Accepted`.
**Impact.** `sp_OrderPaymentApproval_CanCreateInvoice`; `orderGridView_RowDataBound`.
**Acceptance.** Gate flips from false to true exactly at the last approver's action.
**Status.** Implemented (§2 → §8).

### FR-OPA-10 — Approver worklist
**Description.** Every approver sees the requests routed to their role inside their market,
filterable by market structure, status and last-action date, with the payment plan visible on the
row.
**Source.** Brief Phases 15, 17, 18. **Existing behaviour.** None.
**Required behaviour.** One flat grid for all levels, shaped like `CustomerApproveList.aspx`:
`IVMarketStructureInvoSearch.ascx` filter, inline ✔ / ✖, and the framework's
"Waiting for Another Approver" badge on rows the caller cannot act on. The plan is rendered as a
single readable cell (`2 instalment(s) · 31 Aug 2026 1,463.30 | 14 Sep 2026 1,463.29`), so the
grid stays one-click and no modal is needed to see what is being approved.
**Row scope** (the framework rule, from `CustomerApproveList.LoadData`): AM → own `EmpAreaId`,
DZSM → own `EmpRegionId`, NSM → own `EmpGroupId`, DIC → own company units, any other role → no
market restriction. The market dropdowns only narrow this; they can never widen it.
**Impact.** `Approval_UI/OrderPaymentApprovalList.aspx`; `sp_Get_OrderPaymentApp`.
**Acceptance.** A user sees only rows in their scope; `CanAct` is true only on their step.
**Status.** Implemented (§6).

### FR-OPA-11 — Approval history
**Description.** Every action on an order is retrievable: round, step, role, person, status,
remarks, timestamp — including earlier rejected rounds.
**Source.** Brief Phase 16. **Existing behaviour.** None.
**Changed 2026-08-25.** The first version had a per-request detail panel with three result sets
from `sp_OrderPaymentApproval_GetDetail`. That is replaced by the plan-on-the-row (FR-OPA-10) plus
a **History** button that expands one panel under the grid.
**Impact.** `sp_Get_OrderPaymentAppHistory`; `pnlHistory` / `gvHistory`.
**Acceptance.** One row per action, oldest first. **Status.** Implemented (§9).

### FR-OPA-12 — Approval status visible on the Invoice Creation grid
**Description.** A blocked order in flight shows its state in place of the button.
**Source.** Brief Phase 18. **Existing behaviour.** None.
**Changed 2026-08-25.** The two list procs now emit `PaymentApprovalStatus` (the framework status
string, or NULL) and `PaymentApprovalWaitingRole` (`tblRoleType.DisplayName`) instead of the old
integer `PaymentApprovalStatus` / `PaymentApprovalId` pair. The label reads
"Waiting for &lt;role&gt;", "Payment Approved" or "Payment Approval Rejected".
**Impact.** `alter_orderlist_payment_approval.sql`; `lblApprovalStatus`.
**Acceptance.** Both list procs expose the columns and row counts are unchanged (27 → 27).
**Status.** Implemented (§12).

### FR-OPA-13 — Navigation and configurability
**Description.** The approval page is reachable from the sidebar **and** appears in the Menu
dropdown on `UserPermission/ApprovalStepMap.aspx`.
**Source.** Existing menu convention. **Existing behaviour.** N/A.
**Required behaviour.** `tblMainMenuNew` SL 383 under "Approval Operation" (347), granted to the
Order Approval List's roles plus AM, **with `IsApprovalPage = 1`** — `sp_GET_MainMenuByType`
filters the config page's dropdown on that flag, so without it the chain cannot be configured.
**Impact.** `spec/database/menu/OrderPaymentApproval_menu.sql`.
**Acceptance.** The row, the flag and six role grants exist. **Status.** Implemented (verified live).

### FR-OPA-14 — A missing chain configuration must never auto-approve
**Description.** If no chain is configured for this page and the raising role, the request is
refused with an actionable message.
**Source.** Rebuild decision, 2026-08-25.
**Framework behaviour, deliberately not inherited.** `sp_webapi_SaveCustomerAppLog` reads "no next
role" as "chain finished" and stamps `Accepted`. On a page with no map rows that means the first
click silently fully approves. On a money approval that is unacceptable.
**Required behaviour.** `sp_Post_OrderPaymentApp` refuses with *"The approval chain for this page
is not configured for your role. Please contact MIS (Approval Step Map)."*, and equally when the
chain has no approver after the raising role. `sp_Save_OrderPaymentAppLog` refuses if the map
disappears mid-flight.
**Acceptance.** A user whose role has no map row gets an error, not an approval.
**Status.** Implemented (§11).

---

## 2. Business rules

| ID | Rule | Existing behaviour | Required behaviour | Enforced in | Status |
|---|---|---|---|---|---|
| BR-OPA-01 | Approval may only be requested for a genuinely credit-blocked order | n/a | request refused otherwise, recomputed server-side | `sp_Post_OrderPaymentApp` via `fnOrderCreditValidation` | Implemented |
| BR-OPA-02 | At most one live round per order | n/a | second attempt refused while the current round is `Posted`/`Verified` | `sp_Post_OrderPaymentApp` + `UNIQUE (TableId, Round, Step)` | Implemented (§4) |
| BR-OPA-03 | A chain must be configured for the raising role | n/a | request refused with a "contact MIS" message; never auto-approved | `sp_Post_OrderPaymentApp` | Implemented (§11) |
| BR-OPA-04 | The request advances only to the next configured role | n/a | `ToRoleTypeId` is the gate; there is no "approve to" parameter | `sp_Save_OrderPaymentAppLog` | Implemented (§7) |
| BR-OPA-05 | A closed round (`Accepted`/`Rejected`) is immutable | n/a | further actions refused | `sp_Save_OrderPaymentAppLog` | Implemented (§7) |
| BR-OPA-06 | An already-invoiced order cannot enter the workflow | n/a | request refused | `sp_Post_OrderPaymentApp` | Implemented |
| BR-OPA-07 | The plan belongs to the round and is fixed once submitted | n/a | approvers see it read-only; changing it means rejecting and resubmitting | no update path exists | Implemented (§10) |
| BR-OPA-08 | Total Due is snapshotted on the round | n/a | later payments do not move the target the approvers agreed to | `DueAmount` on the log row | Implemented (§4) |
| BR-OPA-09 | Existing invoice-creation behaviour for non-blocked orders is unchanged | current behaviour | unchanged | additive `OUTER APPLY … TOP 1` only | Implemented (§12) |
| ~~BR-OPA-10~~ | ~~NSM final approval locks the payment schedule~~ | — | **Withdrawn.** `IsScheduleLocked` existed because the AM could edit the plan mid-flight. With FR-OPA-06 the plan is never editable, so there is nothing to lock. | — | Withdrawn |

---

## 3. Validation rules — payment commitment

All are enforced **server-side** in `sp_Post_OrderPaymentApp`. The modal repeats some of them for
faster feedback; the client is not the gate.

| ID | Rule | Acceptance | Status |
|---|---|---|---|
| VR-OPA-10 | At least one instalment | empty schedule refused | Implemented (§3) |
| VR-OPA-11 | Payment date ≥ today | yesterday refused | Implemented (§3) |
| VR-OPA-12 | Payment amount > 0 | 0 and −10 refused; also a `CHECK` constraint | Implemented (§3) |
| VR-OPA-13 | No duplicate payment date | duplicate refused; also a unique index | Implemented (§3) |
| VR-OPA-14 | `PaymentNo` follows date order | assigned by `ROW_NUMBER() OVER (ORDER BY PaymentDate)`, not by table-variable identity | Implemented (§4) |
| VR-OPA-15 | `SUM(PaymentAmount) = DueAmount` (±0.01) | mismatch refused with both figures in the message | Implemented (§3) |
| VR-OPA-17 | Rejection requires a reason | blank reason refused | Implemented (§5) |
| VR-OPA-18 | Unparseable date/amount reported per instalment | message names the instalment number | Implemented (UI) |
| VR-OPA-19 | Payment date and amount are both mandatory on a filled row | refused | Implemented (UI) |
| ~~VR-OPA-16~~ | ~~Schedule accepted only at the AM step~~ | **Withdrawn** — the schedule is no longer accepted at any approval step (FR-OPA-06) | Withdrawn |
| ~~VR-OPA-20~~ | ~~Server-side messages reach the user verbatim~~ | folded into SEC-OPA-08; the proc's `RAISERROR` text is what the modal and the grid display | Merged |

---

## 4. Security requirements

The framework's own approval pages check "is it your turn" by comparing a `HiddenField` in the
GridView row to `Session["RoleTypeId"]`, in the code-behind, and the save procedure verifies
nothing. That is client data. None of it is relied on here.

| ID | Requirement | Framework behaviour | Required behaviour | Status |
|---|---|---|---|---|
| SEC-OPA-01 | Identity and role are resolved from the session's `UserId` inside the database; no role, employee id or level is a procedure parameter | `sp_webapi_SaveCustomerAppLog` takes `@FromEmpId`, `@ToEmpId`, `@Step` from the page | new procs take `@ActionUserId` and derive the rest | Implemented (§5) |
| SEC-OPA-02 | The caller's role must be the one the request is waiting on | page-side `HiddenField` comparison only | `ToRoleTypeId <> @RoleTypeId` → refused in the proc | Implemented (§5) |
| SEC-OPA-03 | The caller must be inside the request's market | not checked at all on save | area / region / group / company-unit checked per role in the proc | Implemented (§5) |
| SEC-OPA-04 | No approval level may be skipped | — | the current row's `ToRoleTypeId` is the gate | Implemented (§5) |
| SEC-OPA-05 | The worklist never returns a row outside the caller's scope | scope built by string concatenation in the code-behind | scope derived inside `sp_Get_OrderPaymentApp` from `@ActionUserId`; dropdown values only narrow it | Implemented (§6) |
| SEC-OPA-06 | The invoice gate is re-checked server-side on every path into invoice creation | UI-only disabling | per-row click, bulk `DataValidation()`, and `InvoiceCreationForCustomerByOrder.Page_Load` | Implemented (§2, §8) |
| SEC-OPA-07 | No dynamic SQL; all parameters bound | `sp_Get_CustomerApp` concatenates a `@param` string built in the code-behind and `EXEC`s it | `sp_Get_OrderPaymentApp` takes typed parameters; no dynamic SQL anywhere in this feature | Implemented |
| SEC-OPA-08 | Procedure messages are JavaScript-encoded before display (XSS) | mixed | `HttpUtility.JavaScriptStringEncode` on both pages | Implemented |
| SEC-OPA-09 | The approval page is behind the standard menu-permission check | pattern exists on other Approval_UI pages | `UserPersmissionValidation()` | Implemented |
| SEC-OPA-10 | Oversight roles do not gain the ability to act | `CustomerApproveList` lets RoleTypeId 4 / 5 / 14 bypass the button-hiding loop entirely | no role is special-cased; a role can act only if the configuration puts it in the chain | Implemented |
| SEC-OPA-11 | CSRF | ASP.NET ViewState MAC + `sessionState InProc`, as elsewhere in the app | unchanged; no new anonymous or GET-mutating endpoint | Existing |

---

## 5. Audit requirements

| ID | Requirement | Required behaviour | Status |
|---|---|---|---|
| AUD-OPA-01 | Every action is auditable: person, role, action, timestamp, remarks | one `tblOrderPaymentApprovalLog` row per action — the log **is** the state, so there is no way to change state without writing the audit row | Implemented (§9) |
| AUD-OPA-02 | The plan version is recorded | `PlanVersion` on `tblOrderPaymentSchedule` equals the log `Round` | Implemented (§10) |
| AUD-OPA-03 | Earlier rejected attempts survive | each submission is a new `Round`; nothing is overwritten or deactivated | Implemented (§10) |
| AUD-OPA-04 | A full cycle is reconstructable | `sp_Get_OrderPaymentAppHistory` returns every round and step, oldest first | Implemented (§9) |
| ~~AUD-OPA-05~~ | ~~Audit rows cannot be updated or deleted~~ | **Withdrawn.** The first version used an `INSTEAD OF UPDATE, DELETE` trigger on a separate history table — the only trigger in this schema, and one that had to be disabled to clean up test data. State and audit are now the same append-only table; nothing in the application issues `UPDATE` or `DELETE` against it. Re-add the trigger if the DBA wants it enforced rather than conventional. | Withdrawn |

---

## 6. Non-functional requirements

| ID | Requirement | How met | Status |
|---|---|---|---|
| NFR-OPA-01 | No regression on the Invoice Creation grid | `OUTER APPLY … TOP 1` cannot multiply rows; count verified identical (27 → 27) | Implemented (§12) |
| NFR-OPA-02 | Multi-statement changes are transactional | `BEGIN TRANSACTION` + `XACT_ABORT ON` in both write procs | Implemented |
| NFR-OPA-03 | Concurrent approval is safe | `UPDLOCK, HOLDLOCK` on the current-row read, plus `UNIQUE (TableId, Round, Step)` as the backstop — two approvers computing the same step cannot both land | Implemented |
| NFR-OPA-04 | Follows the existing architecture, coding standards and UI conventions | Service → Repository → stored procedure; the page is shaped like `CustomerApproveList.aspx`; `NewMasterPage.master`, Bootstrap 5, GridView, UpdatePanel, pickadate, SweetAlert | Implemented |
| NFR-OPA-05 | Deployment is idempotent; rollback is documented | `deploy_order_payment_approval.sql` re-runnable and drops the previous implementation; plan §13 | Implemented |
| NFR-OPA-06 | Rules live where every future caller inherits them | all rules in stored procedures, so a later API endpoint gets them for free | Implemented |
| NFR-OPA-07 | No unrelated module is changed | only the files named in the impact analysis | Implemented |
| NFR-OPA-08 | The pages work in a real browser, not just in a build | **Open.** The 2026-08-20 browser pass covered the withdrawn design. Not re-run after the rebuild. | **Open** |

---

## 7. Deferred / not implemented

| ID | Item | Reason |
|---|---|---|
| ~~FR-OPA-10 (first version)~~ | Cancellation by the requester | **Withdrawn.** The framework has no cancel concept and the brief describes no screen for it. A requester who changes their mind asks the current approver to reject. OQ-3. |
| FR-OPA-17 | "Last request was rejected" badge on the Invoice Creation grid | Partly delivered: the label now reads "Payment Approval Rejected" and **Go for Approval** reappears. A distinct badge style is not in the brief's Phase 18 UI table. OQ-4. |
| FR-OPA-18 | Gating the sample / doctor / sub-depot / DA invoice-creation paths | The brief names one Invoice Creation page. Extending the gate is a two-line change per page. OQ-8. |
| FR-OPA-19 | Recording actual payments against the approved plan | Out of scope: the brief covers agreeing and approving the plan, not collecting against it. |
| NFR-OPA-09 | Collapsing the credit rule to a single definition | Perf-risky rewrite of two hot procs, outside this requirement. OQ-7. |
| PRE-1 | Fixing the pre-existing `SInventory_UI_IVMarketStructureInvoSearch` class-name collision | Unrelated pre-existing defect. `docs/OPEN-QUESTIONS.md`. |
| ENV-1 | Master-data gaps found while measuring the old design (230 territories with no `tblNSMInfo` row for their group, 41 with no `tblRSMInfo` row, 3 employees sitting in `tblASMInfo` whose login role is DZSM) | No longer blocking — the framework matches on role plus market scope, not on a named employee. Still worth MIS cleaning up, since `tblASMInfo`/`tblRSMInfo`/`tblNSMInfo` feed other reports. |
