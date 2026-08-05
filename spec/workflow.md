# Workflow

Exhaustive reference for every multi-step business workflow in the system: the generic
approval-routing engine, each of the ~10 `Approval_UI` screens built on it, the order-to-cash
lifecycle, the stock/warehouse approval flows, and the leave approval flow. Rule-level detail
(individual validations, field checks) lives in [`business-rules.md`](business-rules.md) and is not
repeated here — this document is about *sequencing*: what state a record moves through and what
proc/table enforces each transition. Schema lives in [`database-tables.md`](database-tables.md);
proc bodies referenced below are in [`spec/database/procs/`](database/procs/).

---

## 1. The approval-routing engine

Every approval workflow in this system (order, leave, expense, DA claim, mileage, DCR, tour plan,
visit plan, RX/prescription, doctor master, customer master) is driven by the **same** two-table
routing map plus a **per-entity approval-log table**. There is no single generic "workflow engine"
class — each entity type has its own near-duplicate `sp_*SaveXAppLog` procedure and its own
`tblXApprovalLog` table, but they all read the same routing map and follow the same shape.

### 1.1 Routing map tables

- **`tblApprovalMapMaster`** (`ApprovalMapMasterId` PK) — one row per `(MenuId, FromRoleId)` pair.
  `MenuId` identifies the workflow/menu (e.g. 381 = Order, 356 = Expense — see the `MenuId` list in
  §2). `FromRoleId` is the **originating role** (the role of the employee who submitted the record).
- **`tblApprovalMapDetail`** (`ApprovalMapDetailId` PK) — child rows per master: `ToRoleId` (a role
  allowed to approve at this step) + `Order` (the step's sequence number, ascending).

So for a given submitter role and menu, there can be N detail rows, each naming the role that must
approve at step `Order = 1, 2, 3, …`. This is a **linear per-role chain**, not a per-record
configurable chain — the same submitter role always routes through the same sequence of approver
roles for that menu, regardless of the individual record's other attributes (amount, territory,
etc. are not inputs to the routing decision itself, only to *who within that role* sees the row via
territory/area filters applied at the UI/DAL level).

- **`tblApprovalStepMaster`** (`AppMasterId` PK, `SL`, `Steps`) — maps a `MenuId` (`SL`) to a total
  step count (`Steps`, stored oddly as `nchar(10)`). Read by several `SaveXAppLog` procs into
  `@FinalStep`, but in the procs actually inspected (`sp_webapi_SaveOrderAppLog`,
  `sp_SaveLeaveAppLog`) **`@FinalStep` is computed and then never used** — the real "is this the
  last step" decision is made differently (see §1.3). This looks like dead/vestigial logic kept
  from an earlier design.
- **`tblApprovalStepsNew`** / `tblApprovalStep` — separate, apparently older/parallel step-definition
  tables (`PageName`/`Page`, `StepOrder`/`Step`, `RoleName`). Referenced only in commented-out code
  in the procs inspected — **dead in the current save path**, kept for reference/rollback.

### 1.2 CRUD procs over the routing map

| Proc | Purpose |
|---|---|
| `sp_GET_ApprovalMapLoad` (`@FromRoleId`, `@MenuId`) | Loads the routing chain for one submitter role + menu: `ToRoleId`, `Order`, `FromRoleId`, `ApprovalMapMasterId`, `RoleTypeId`/`RoleType` (joined display name). Used by `UserPermission` admin UI and by `Library.DAL/UserRoleDAL/ApprovalMapDAL.cs`. |
| `sp_Get_ApprovalMapData` (`@MenuId`) | Loads the *entire* map for a menu (all submitter roles), for the admin grid. |
| `sp_Save_ApprovalMapMaster` (`@MenuId`, `@MenuName`, `@FromRoleId`) | Upsert-by-existence: if no `(MenuId, FromRoleId)` row exists, inserts one and returns the new `ApprovalMapMasterId` via `SCOPE_IDENTITY()`. If one already exists, it **deletes all existing `tblApprovalMapDetail` rows** for that master (full chain replacement) and returns the existing master's Id — the caller is expected to then re-insert detail rows via `sp_Save_ApprovalMapDetail` for every step. |
| `sp_Save_ApprovalMapDetail` (`@ApprovalMapMasterId`, `@ToRoleId`, `@Order`) | Plain insert of one chain step; no de-dup check (a commented-out `DELETE` suggests de-dup was previously attempted and removed). |

Routing chains are maintained via `Solution.Web/UserPermission/` and are **pure data** — which
roles/menus actually have chains configured, and how many levels, is **Not Found** in this repo
(seed data lives only in the database).

### 1.3 The generic per-record step-advance algorithm

Reading `sp_webapi_SaveOrderAppLog` and `sp_SaveLeaveAppLog` side by side, both implement the
identical algorithm (and every other `sp_*SaveXAppLog`/`sp_web_SaveXAppLog` proc follows the same
shape by inspection of call sites in `business-rules.md`'s prior pass):

1. **Determine the record's current step's role** (`@CurrentRoleTypeId`): look up the most recent
   row in the entity's `tblXApprovalLog` for this `TableId` (`ORDER BY <PK> DESC`, i.e. last log
   entry), and take its `ToRoleTypeId`. If there is no prior log row (first submission), fall back
   to the **submitter's own role** (`@MapRoleTypeId`, resolved via `tblUser`/`tbl_UserRoleInfo` off
   the entity's owning employee).
2. **Determine the next approver role** (`@NextRoleTypeId`): query
   `tblApprovalMapMaster`/`tblApprovalMapDetail` for `MenuId = @MenuId AND FromRoleId = @MapRoleTypeId
   AND [Order] > @Step`, ordered by `[Order] ASC`, `TOP 1`. In other words: **the chain is always
   keyed off the original submitter's role** (`@MapRoleTypeId`), not the current approver's role —
   the routing table encodes "if X submits, it goes to role A, then role B, then role C", and
   `@Step` (the step number passed in by the caller from the UI, i.e. `InStep + 1`) is used purely
   as a cursor into that fixed ordered list.
3. **Final-step detection**: if no next-role row is found (`@NextRoleTypeId IS NULL`) and the caller
   didn't already pass `'Rejected'`, the proc **forces `@Status = 'Accepted'`** — i.e. reaching the
   end of the configured chain auto-finalizes the record regardless of what status the UI sent.
   (Leave's variant additionally sets `@NextRoleTypeId = 0` as a sentinel.)
4. **Entity status-column side effect**: the proc updates the entity's own master-table status
   column based on `@Status`:
   - Order (`sp_webapi_SaveOrderAppLog`): `tblOrder.ActionStatus` — `'2'` = Accepted, `'1'` =
     Verified, `'0'` = Posted, `'3'` = Rejected. (This finally documents the `ActionStatus`
     2/3 codes flagged as "undocumented" in the prior `business-rules.md` pass.)
   - Leave (`sp_SaveLeaveAppLog`): `Employee_LeaveApplications.ApprovalStatus` — `'2'` = Accepted,
     `'1'` = Verified, `'3'` = Rejected — **plus** a balance-deduction side effect on Accept and a
     balance-refund side effect on Reject-after-Accept (see §5).
5. **Append-only log insert**: a new row is always inserted into `tblXApprovalLog` recording
   `FromEmpId`, `ToEmpId`, `TableId`, `Status`, `Type`, `Step` (`@StepTemp`, i.e. the step number the
   caller passed in — **not** recomputed from the map), `RoleTypeId = @CurrentRoleTypeId`,
   `ToRoleTypeId = @NextRoleTypeId`. The log table is a full audit trail; nothing is ever updated or
   deleted from it on the happy path (contrast with the invoice-reject procs in §4, which do
   `DELETE` from their app-log tables).

Order's proc additionally has a **duplicate-submission guard** not present in Leave's: it counts
existing `tblOrderApprovalLog` rows for `(FromEmpId, TableId)` and no-ops entirely if
`@Countdata >= 1` (the whole body is wrapped in `IF (@Countdata < 1)`), whereas Leave has no such
guard and will happily insert a new log row on every call.

### 1.4 Role-ID bypass shortcuts (UI layer, not the proc)

As established in the prior `business-rules.md` pass, `Approval_UI` code-behind pages hardcode:
role `"5"` and/or employee ID `"496"` → immediate `Status = "Accepted"` bypassing the `"Verified"`
intermediate state that other approvers get; and role IDs `"5"`/`"4"`/`"14"` bypass the
`hfToRoleTypeId` row-level gate entirely (can act on any pending row regardless of whose turn it
is). These are UI-layer shortcuts layered **on top of** the routing algorithm above — the stored
procs themselves have no knowledge of these special role IDs; the UI simply passes
`Status = 'Accepted'` early and the proc's final-step logic (§1.3 step 3) then still correctly
detects/no-ops on that.

### 1.5 Step sequence in words (typical 2-role chain, e.g. rep → area manager → regional manager)

```
1. Rep submits record.                              Step=0  (no prior log row)
2. Area Manager's queue picks it up (ToRoleTypeId    Step=1  Status=Verified
   for step 1 in the chain resolves to Area Mgr's
   role); AM clicks Approve.
3. Proc looks up next Order>1 row for the rep's      Step=2  Status=Verified
   FromRoleId chain -> Regional Manager's role.
   Regional Manager's queue picks it up; RM clicks
   Approve.
4. Proc looks up next Order>2 row -> none found      Step=3  Status=Accepted (forced)
   -> Status forced to Accepted, entity status
   column flips to its "final approved" code.
```

A Reject at any step sets `Status='Rejected'` immediately (no further routing lookup needed) and
flips the entity's status column to its rejected code; the chain does not resume after a reject.

---

## 2. The ~10 `Approval_UI` screens

Each screen approves a different entity type but shares the mechanics documented in
`business-rules.md` (row-level `hfToRoleTypeId` gate, `lbApprove`/`lbReject` → `RowCommand` →
`Save*_ApplogDAL` → proc). This table adds the **routing `MenuId`** (the FK into
`tblApprovalMapMaster`) and confirms each proc against §1.3's algorithm.

| Screen | Entity | `MenuId` | Status values | Reject behavior | Proc |
|---|---|---|---|---|---|
| `CustomerApproveList` | Customer master change | 302 | `Accepted`/`Rejected` (string, no `Verified`) | Final in one step — no intermediate `Verified` state observed | `sp_webapi_SaveCustomerAppLog` |
| `DAApprovalList` | DA claim (TA/DA) | 376 | `Accepted` (role 5/emp 496 bypass) / `Verified` / `Rejected` | Sets `Rejected`, ends chain | `sp_web_SaveTADAAppLog` |
| `DCPCVPApproval` | DCP/CVP tour plan | 377 | `Verified` / `Rejected` | ends chain | `sp_webapi_SaveVisitPlanAppLog` |
| `DCRApprovalList` | Daily call report | 382 | `Accepted` / `Rejected` | ends chain | `sp_webapi_SaveDCRAppLog` |
| `DoctorApprovalList` | Doctor master change | 303 | `Verified` / `Rejected` | ends chain | `sp_webapi_SaveDoctorAppLog` |
| `ExpenseApprovalList` | Expense claim | 356 | `Accepted` (bypass) / `Verified` / `Rejected` | ends chain | `sp_web_SaveExpanseAppLog` |
| `LeaveApproveList` | Leave application | 381 (shared with Order — likely a bug) | `Accepted` / `Verified` / `Rejected` | balance refund if reversing an already-Accepted leave — see §5 | `sp_SaveLeaveAppLog` |
| `MillageApprovalList` | Mileage claim | 372 | Same as DA claim | ends chain | `sp_web_SaveMileageAppLog` |
| `OrderApproveList` | Sales order | 381 (shared with Leave) | `Accepted` (bypass) / `Verified` | `ActionStatus='3'`; queue filter excludes `ActionStatus IN (2,3)` — now documented: 2=Accepted, 3=Rejected (§1.3 step 4) | `sp_webapi_SaveOrderAppLog` |
| `RXApprovalList` | Prescription (RX) | 379 | `Accepted` (bypass) / `Verified` / `Rejected` | ends chain | `sp_webapi_SavePrescriptionAppLog` |
| `TourPlanApproval` | Tour plan | 371 | `Verified` / `Rejected` | ends chain | `sp_webapi_SaveTourPlanAppLog` |
| `DoctorCustomerTransferApproval` | Doctor/customer territory transfer **and** DC stock-out (two flows, one page) | n/a (not on the routing map — single-step) | Transfer: proc-internal; Stock-out: `Approved`/reject-reason text | No chain — single `UPDATE` | `sp_Update_Customer_Doctor_TransferApprove`; `sp_UD_DcStockOutApproval` (see §3) |

Only `sp_webapi_SaveOrderAppLog` and `sp_SaveLeaveAppLog` were read in full for the routing-engine
pass (§1.3); the remaining `sp_*SaveXAppLog` procs were not individually re-verified byte-for-byte
but share the `Save*_ApplogDAL` calling convention documented in `business-rules.md`, and
near-certainly share the same step-advance shape (same parameter list, same
`tblApprovalMapMaster`/`Detail` dependency) — full source for all of them is in
[`spec/database/procs/`](database/procs/) if you need to verify a specific one.

**`MenuId` 381 shared between Order and Leave**: confirmed still true from `tblApprovalStepMaster`
having one row per `SL`/`MenuId` — if both workflows really share `MenuId=381`, they also share one
`tblApprovalStepMaster` row and one `tblApprovalMapMaster` chain-per-role, meaning an Order-submitter
role and a Leave-submitter role with the same `FromRoleId` would be routed through the *same* chain
definition. Still flagged as a likely data-modeling bug, not verified as intentional.

---

## 3. Stock / warehouse approval workflows

Unlike the `Approval_UI` chain-based workflows above, the stock workflows are **single-step**
request → approve/reject flows with no `tblApprovalMapMaster` routing — the master record itself
carries the `Status` column.

### 3.1 DC stock-out approval (`DoctorCustomerTransferApproval.aspx.cs`, `sp_UD_DcStockOutApproval`)

1. A DC stock-out request is created (rows in `tblDeStockOutMaster`/`tblDeStockOutDetails`, one
   detail row per `DcStoreId` + quantity), status pending.
2. Approver reviews on `DoctorCustomerTransferApproval` and submits `Approved` or a reject-reason
   string.
3. **On approve**, `sp_UD_DcStockOutApproval` cursors every detail row and **decrements
   `tblDCStore.StockQty`** by `StackOutQty` for each store (only when qty > 0), then sets
   `tblDeStockOutMaster.Status/ApprovedBy/ApprovedDate`. Stock movement happens **only on approval**,
   not at request time — a pending/rejected request never touches `tblDCStore`.
4. **On reject**, only the `UPDATE tblDeStockOutMaster SET Status = <reject-reason text>` branch
   runs (per `DeStockOutDal.cs:138`) — no stock is moved, matching the "approve moves stock,
   reject doesn't" pattern.

### 3.2 Sub-depot stock-out approval (`sp_UD_SubDcStockOutApproval`)

Structurally identical to §3.1 but against `tblSubDepotStockOutDetails`/`tblSubDepotStore`: cursors
detail rows, decrements `tblSubDepotStore.StockQty` by `StockOutQty` per `SubDCStoreId`, then updates
`tblSubDepotStockOutMaster.Status/ApprovedBy/ApprovedDate`.

### 3.3 Warehouse stock-in approval (`WarehouseStockInApproval.aspx.cs`, `sp_SAP_WHStockInApprove`)

This one is a **receiving** approval, not an outbound one, and it moves stock **in**, not out:

1. Stock-in rows land in `tblWHStockInDetail`/`tblWHStockInMaster` (from a SAP MIGO feed or manual
   entry), unposted.
2. On approval, the proc cursors every `tblWHStockInDetail` row for the given
   `WHStockInMasterID` that hasn't already been posted (`WHStockInDetailID NOT IN (SELECT
   MigoDetailID FROM tblCentralStore WHERE MigoDetailID IS NOT NULL)` — idempotency guard against
   double-posting), and **inserts a new `tblCentralStore` row per detail line** (quantity, batch,
   expiry, pricing, `StockCondition='Available'`) — this is the actual stock-in movement into
   central warehouse inventory.
3. Master is then marked `ApproveBy = 'Auto Approve'`, `Status = 'Approved'` — note the literal
   string `'Auto Approve'` regardless of who actually clicked approve; the real approving user is
   not recorded by this proc (a gap versus the DC/sub-depot procs, which do take `@ApprovedBy`).
4. Returns `@ReceiveIdMAX` (last inserted `tblCentralStore.ReceiveId`) as the proc's return value,
   used by the caller presumably to confirm success (`0` = nothing posted).

**Stock workflow summary**: request (pending row) → approver decision → **approve triggers the
actual physical stock-quantity mutation inline in the same proc call** (decrement for stock-out,
insert-as-received for stock-in) → status column updated last. Reject never touches quantities.

---

## 4. Order-to-invoice-to-payment-to-collection lifecycle

This is the full state sequence, grounded in the actual column definitions
(`database-tables.md`) and the DA-side reject procs.

### 4.1 Order stage

- `tblOrder.ActionStatus`: `NULL`/unset → `'1'` (Verified, mid-chain) → `'2'` (Accepted, end of
  chain) → `'0'` (Posted) or `'3'` (Rejected) — see §1.3 step 4. The `'0'` (Posted) transition is
  written by the same proc but not reached via the `Approval_UI` reject/approve buttons in the code
  paths read — likely set elsewhere in the invoice-generation step (§4.2) once the accepted order is
  converted, consistent with "Posted" meaning "already turned into an invoice."
- `OrderApproveList`'s pending-queue filter `ActionStatus NOT IN (2,3)` (flagged undocumented in the
  prior `business-rules.md` pass) is now explained: it excludes orders already fully **Accepted** or
  **Rejected**, leaving unset/`'1'` (Verified, still mid-chain) rows visible to approvers.

### 4.2 Order → Invoice conversion

- `tblOrder`/`tblOrderInfoMaster`-family tables carry an `IsInvoice bit` flag (present on 6 tables
  per `database-tables.md`, including the order and invoice info-master tables) marking whether an
  order has already been converted to an invoice — prevents double-invoicing the same order.
- Conversion procs: `sp_AutoInvoiceGeneration`, `sp_I_InvoiceMaster`,
  `sp_Process_ProformaInvoiceByOrderId` (and DC/sub-depot/sample variants) — not read in full for
  this pass; the exact trigger condition for auto vs. manual invoice generation is **Not Found**
  beyond "happens after order approval."

### 4.3 Invoice DA-side sub-statuses (three independently rejectable tracks)

`tblInvoice` carries three parallel status columns that a **Delivery Associate (DA)** progresses
independently, each with its own approval-log table and its own reject proc:

| Column | Meaning | App-log table(s) | Reject proc |
|---|---|---|---|
| `DA_SalesConfirmStatus` | DA has confirmed the sale was delivered/completed | `tblSalesConfirmation_appLog`, `tblSalesConfirmation_appLogDetail` | `sp_RejectInvoiceDASalesConfirmStatus` |
| `DA_PaymentCollection` | DA has collected payment for the invoice (`DA_PaymentCollectionBy`/`Date` stamp who/when) | (payment collection app-log, not read in full) | `sp_RejectInvoiceDAPaymentCollection` |
| `DA_SalesReturn` | DA has recorded a sales return against the invoice (`DA_SalesReturnDate`/`By`/`Type` stamp) | `tblSalesReturn_appLog`, `tblSalesReturn_appLogDetail` | `sp_RejectInvoiceDASalesReturn` |

Each reject proc follows the identical shape (verified for `sp_RejectInvoiceDASalesConfirmStatus`,
assumed identical for the Payment/SalesReturn siblings by naming/column symmetry): set the relevant
`tblInvoice` status column to `'Rejected'`, then **hard-delete** the corresponding app-log and
app-log-detail rows for that invoice — the only place in this system observed to delete audit rows
rather than append a `'Rejected'` log row (contrast with §1.3 step 5's append-only pattern). A
rejected DA sub-status effectively erases its submission history, requiring the DA to resubmit from
scratch rather than see a rejected entry in their log.

### 4.4 DIC re-approval layer

On top of the DA's own confirm/reject, there is a second-level **DIC** (District/Divisional-in-Charge,
presumably) sign-off recorded directly on the app-log row rather than the invoice:

- `sp_UpdateDICApprovalStatus` (`@SalesConfirmationAppLogId`, `@DICApprovalStatus`, `@DICApproveDate`,
  `@DICApproveBy`) — updates `DICApprovalStatus`/`DICApproveDate`/`DICApproveBy` columns directly on
  the **`tblSalesConfirmation_appLog`** row (not `tblInvoice`) for that specific submission.
- `sp_UpdateDICApprovalStatus_SalesReturn` — same pattern, presumably against
  `tblSalesReturn_appLog` (name-symmetric, not independently read).

So Sales-Confirmation has a two-tier check: DA confirms (`tblInvoice.DA_SalesConfirmStatus`) →
DIC separately approves/rejects that specific confirmation entry (`DICApprovalStatus` on the log
row) — the DIC layer can disagree with an already-DA-confirmed invoice without re-opening the
DA-level status, since it's a separate column on a separate (log) table.

### 4.5 Lifecycle in words

```
Order created                                  ActionStatus = NULL
  -> chain approval (Approval_UI/OrderApproveList, MenuId 381)
     Verified (mid-chain)                       ActionStatus = '1'
     Accepted (end of chain) / Rejected         ActionStatus = '2' / '3'
  -> order converted to invoice (IsInvoice flag flips, auto/manual generation)
     Posted (implied, once invoiced)            ActionStatus = '0'
Invoice created (tblInvoice)
  -> DA confirms sale                           DA_SalesConfirmStatus = <set> / Rejected (log deleted)
     -> DIC reviews that confirmation           tblSalesConfirmation_appLog.DICApprovalStatus
  -> DA collects payment                        DA_PaymentCollection = <set> / Rejected (log deleted)
  -> DA records a return (if any)                DA_SalesReturn = <set> / Rejected (log deleted)
```

The three DA tracks (confirm/payment/return) are independent — an invoice can have its
sales-confirmation rejected while payment collection is still pending, etc. There is no observed
single "invoice status" field that aggregates all three; each is tracked and rejected separately.

---

## 5. Leave approval workflow

`LeaveApproveList` (chain UI, §2) → `sp_SaveLeaveAppLog` (§1.3's algorithm, applied to
`Employee_LeaveApplications`/`tblLeaveApprovalLog`). Beyond the generic step-advance, leave has a
**balance side effect** not present in any other workflow read for this pass:

1. **On final `Accepted`** (chain exhausted, §1.3 step 3): `Employee_LeaveApplications.ApprovalStatus
   = '2'`, then `Employee_YearlyLeaveBalance.YearlyLeaveBalance -= Days` for that employee/leave
   type/current fiscal year, and an offsetting `-Days` row is appended to `tblLeaveOperation`
   (`DayValue`, `MonthVal`, `YearVal`) — an append-only ledger of balance movements, separate from
   the approval log.
2. **On `Verified`** (mid-chain, not yet final): `ApprovalStatus = '1'` only — **no balance
   deduction yet**. Balance is only touched once the chain fully completes.
3. **On `Rejected`**: two branches depending on whether the application had *already* been Accepted
   (`ApprovalStatus = '2'`) before this reject call:
   - If it had already been Accepted (a later reversal): `ApprovalStatus = '3'`, **and the balance
     deduction is reversed** — `YearlyLeaveBalance += Days` — refunding the days that were previously
     deducted. (No corresponding `tblLeaveOperation` credit-row insert was found in the branch read —
     possible ledger asymmetry: the debit is logged, the refund is not.)
   - If it had not yet reached Accepted (rejected mid-chain, the normal case): `ApprovalStatus = '3'`
     with no balance adjustment (none was ever deducted).

There is also a **separate, apparently distinct, single-step leave-approval path**:
`sp_Approve_EmployeeLeaveApplication` (`@LeaveApplicationId`, `@ApprovalStatus`, `@ApproveBy`,
`@ApproveDate`) — sets `ApprovalStatus`/`ApproveBy`/`ApproveDate` directly (string status, e.g.
`'Approved'`, not the chain's numeric-code convention), and on `'Approved'` inserts one row per
matching application into `Employee_YearlyLeaveTranscations` (`LeaveDays = -Days`) via a cursor —
a **different ledger table** than `tblLeaveOperation` used by the chain path above. This proc's
caller was not identified in this pass (not wired into `LeaveApproveList`'s code-behind per the
`business-rules.md` pass); it may be a legacy/alternate single-step approval path (e.g. an admin
override screen) still present in the database but not reachable from the primary UI — flagged as
**unconfirmed**, not verified dead.

### 5.1 Leave lifecycle in words

```
Employee submits leave request                  ApprovalStatus = NULL, Days reserved (not yet deducted)
  -> chain approval (LeaveApproveList, MenuId 381 - shared w/ Order)
     Verified (mid-chain)                       ApprovalStatus = '1'   (no balance change)
     Accepted (end of chain)                    ApprovalStatus = '2'   Balance -= Days, ledger row added
     Rejected (mid-chain, never Accepted)        ApprovalStatus = '3'   (no balance change)
     Rejected (after being Accepted, reversal)   ApprovalStatus = '3'   Balance += Days (refund, ledger row NOT added)
```

---

## 6. Known data-quality issues in the chain workflows

These were flagged from C# call sites in the prior `business-rules.md` pass; nothing in the proc
bodies read for this pass contradicts or resolves them — the procs are agnostic to the `Type` string
value passed in, so these remain UI-layer bugs, not proc-layer ones:

- `DCPCVPApproval`: `Type="DCP"` on approve vs. `Type="Leave"` on reject.
- `ExpenseApprovalList`: `Type="ExpanseClaim"` on approve vs. `Type="Expense"` on reject.
- `LeaveApproveList`: `Type="Leave"` on approve vs. `Type="Order"` on reject.
- `TourPlanApproval`: `Type="Leave"` on both approve and reject.
- `MenuId = 381` shared between `OrderApproveList` and `LeaveApproveList` (§2) — since `MenuId` is
  the join key into both `tblApprovalStepMaster` and `tblApprovalMapMaster`, this is a routing-table
  collision risk, not just cosmetic: an Order-submitter role and Leave-submitter role sharing a
  `FromRoleId` would resolve to the *same* configured approval chain row.

Since `Type` is stored on the append-only `tblXApprovalLog` row and not read back by the
step-advance query (§1.3 uses `MenuId`/`FromRoleId`/`Order`, never `Type`), these mislabels do not
affect routing correctness — they corrupt only the audit-trail `Type` column for reporting/display
purposes.

---

## Cross-references

- [`business-rules.md`](business-rules.md) — field-level and screen-level validation rules for these
  same workflows (required fields, quantity caps, session-based access gates).
- [`database-tables.md`](database-tables.md) — full DDL for `tblApprovalMapMaster`,
  `tblApprovalMapDetail`, `tblApprovalStepMaster`, `tblOrderApprovalLog`, `tblLeaveApprovalLog`,
  `tblOrder`, `tblInvoice`, and all other tables referenced above.
- [`spec/database/procs/`](database/procs/) — proc source for every stored procedure named in this
  document.
