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

### 2a. A second, independently-live "legacy bulk approve" mechanism sits alongside the chain engine above (new, this revision)

Reading the Doctor-module stored procedures directly (not just the C# call sites) surfaced a
**second approval mechanism**, structurally simpler than the routing-chain engine in §1, that is
genuinely live for several of the same entity types listed in the table above:

| Legacy proc | Entity | Shape | Live from UI? |
|---|---|---|---|
| `sp_ApproveTourPlanInformation` | Tour plan (`tbl_TourPlanMaster`) | Single bulk `UPDATE ... WHERE Id IN (fnSplit(@Ids,','))`, no chain | **Live** — `TourPlannedApprovalList.aspx.cs:98` |
| `sp_ApproveVisitPlanInformation` | Doctor visit plan (`tbl_DoctorTourPlanMaster` — a **different table** from the one above) | Same bulk shape; `@Status='3'` (Reject) also resets `IsFinalSubmit=0`, unlocking the plan for edit/resubmit | **Live** — `VisitPlannedApprovalList.aspx.cs:101` |
| `sp_ApprovePrescriptionInformation` | Prescription | Same bulk shape | **Live** — `DoctorModule_UI/Setup.aspx.cs:72-75` |
| `sp_ApproveAttendanceInformation` | Attendance | Same bulk shape | **Live** — `AttendanceListApproval.aspx.cs:474`, alongside that same page's chain-based approval (two approve mechanisms on one page) |
| `sp_Approve_DoctorInformation` | Doctor master | Hardcodes `ApprovalStatus='Approved'`, no `@Status`/reject path | Dead — caller commented out (`Setup.aspx.cs:1556`) |
| `sp_Approve_TADAClaim` | TA/DA claim | Same, no reject path | Dead — caller commented out (`Setup.aspx.cs:1571`) |
| `sp_ApproveExpenseClaimInformation` | Expense claim | Same bulk shape | Dead — caller commented out (`Setup.aspx.cs:89-92`) |
| `sp_ApproveMileageClaimInformation` | Mileage claim | Same bulk shape | Dead — caller commented out (`Setup.aspx.cs:97-100`) |

**Practical implication**: for Tour Plan, Visit Plan, Prescription, and Attendance, there are **two
independently-reachable code paths that can each mutate the same approval status** — the chain-based
engine in §1 (multi-step, role-routed, append-only audit log) and this flat single-step bulk-approve
mechanism (§1's `hfToRoleTypeId` gate does not apply here at all). Which one a given user actually
hits depends entirely on which page they're on (`Approval_UI/TourPlanApproval.aspx` vs.
`DoctorModule_UI/TourPlannedApprovalList.aspx`, for example) — both are real, live pages. For Doctor
and TADA claim approval specifically, only the chain-based engine is reachable today; the bulk-approve
proc exists but its only caller is commented out.

Also newly confirmed: `tbl_DoctorTourPlanMaster`/`tbl_DoctorTourPlanDetail` (doctor-visit tour plans)
and `tbl_TourPlanMaster`/`tbl_TourPlanInfo` (general/market tour plans) are **two separate master
tables**, both using the identical `0=Pending,1=Verified,2=Approved,3=Rejected` status vocabulary —
easy to conflate as one feature, but they are independent entities with independent approval
mechanics (the general one gets the bulk proc above; the market one gets `workflow.md` §1's chain via
`sp_webapi_SaveVisitPlanAppLog`, per the `DCPCVPApproval` row in the table above).

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

### 3.4 SAP Chalan → Requisition → Stock Receive sync, and two confirmed open findings (new, this revision)

Distinct from §3.1-3.3's DC/Sub-Depot/Warehouse approval flows, this is the pipeline behind
**Stock Receive against a Chalan/DC** on
`Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx`. Investigated and written up in full
at [`docs/ReceiveQty_RootCause_Analysis.md`](../docs/ReceiveQty_RootCause_Analysis.md) — **not
fixed**, investigation only, per explicit instruction to review the root cause before any fix.
Both findings below are open, not resolved.

```
SAP (external, not in this repo)
  -> SAP_API_Data.tblSAP_StockMovementMaster/Detail   (keyed only by free-text challan_code,
                                                        no unique constraint, no SAP document/
                                                        line number, no movement-type column)
  -> staff clicks "Receive" on SAP_Integration/SAP_StockReceive.aspx
     -> SAP_IntrigationPointDAL.SaveStockReceive(challanNo) -> sp_SAP_StockReceive, which
        orchestrates, in order:
          sp_SAP_WhStockInMaster   (INSERT tblWHStockInMaster; guard: challan_code NOT IN
                                     existing ChallanNo values -- literal-string match only)
          sp_SAP_WhStockInDetails  (INSERT tblWHStockInDetail, one row per Master x Detail match)
          sp_SAP_WHStockInApprove
          sp_SAP_STOMaster         (INSERT tblRequisition -> creates ReqId)
          sp_SAP_STODetails        (INSERT tblRequsitionChild, ReqQty = tblWHStockInDetail.Qty)
          sp_SAP_StockInTransfer   (INSERT tblStockInTransfar, Quantity = ReqQty, via a CTE join
                                     keyed on ProductCode+BatchNo; "already inserted?" guard is a
                                     plain check-then-insert, no lock/unique constraint)
  -> ReceiveProductByChalanByDC.aspx.cs binds tblStockInTransfar rows (WHERE IsTransfared IS
     NULL AND ReqId=@ReqId) verbatim; RcvQty = Eval("Quantity") with no independent cross-check
  -> clerk confirms Receive -> tblDCStore/tblDCStoreFreeze updated, tblStockInTransfar.IsTransfared='OK'
```

**Open finding 1 — no duplicate-shipment detection anywhere in this chain (CRITICAL)**: the SAP
side can (and, in a confirmed live example, did) sync the exact same physical shipment twice under
two different `challan_code` strings 10 days apart. Each independently matches the app's
literal-string `NOT IN` guard, so each becomes its own fully-valid, independently-processed
`tblRequisition`/`tblStockInTransfar` chain — one already received into `tblDCStore`, the other
still sitting pending, both showing identical products/batches/quantities. Nothing on
`ReceiveProductByChalanByDC.aspx` distinguishes the still-pending duplicate from a genuine new
delivery; receiving it would silently double-count stock already received. See
`docs/ReceiveQty_RootCause_Analysis.md` §8-10, §16 root cause #1 (CONFIRMED), §19.

**Open finding 2 — `sp_SAP_StockInTransfer`'s duplicate-insert guard is unsafe under repeated/
concurrent execution (HIGH)**: its guard is a plain `WHERE ReqChildId NOT IN (SELECT DISTINCT
ReqChildId FROM tblStockInTransfar ...)` check with no application lock, no transaction scope, and
no uniqueness constraint on `tblStockInTransfar(ReqChildId)` — safe only if the proc never runs
twice for the same input without the first run's inserts being visible yet. Confirmed live
consequence: one product/batch line within a single, still-pending Chalan is represented by 4
`tblStockInTransfar` rows instead of 2, even though the upstream `tblRequsitionChild` table holds
only the correct 2 source rows — the duplication was introduced by this proc's own insert, not by
duplicated source data. This is the same class of check-then-insert-without-a-lock bug as the DA
delivery-invoice double-stock-return race documented in `spec/business-rules.md` §1 ("DA Delivery
Invoice Submission") — that one **was** fixed (2026-08-11, by widening a `sp_getapplock` to span
the whole commit); this one has not been. See `docs/ReceiveQty_RootCause_Analysis.md` §14-16 root
cause #2 (CONFIRMED as to the duplicate rows and their consequence; the exact trigger — repeated
manual click vs. a genuine concurrency race — is unconfirmed, no execution/audit log was
available).

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

- An `IsInvoice bit` flag marks whether an order has already been converted to an invoice —
  prevents double-invoicing the same order. Confirmed present on 6 tables in
  `database-tables.md`: `tblOrder` (the live/current order), `tblOrder_Doctorrequirement`,
  `tblOrderDel`, `tblOrderDeleteArchive` (soft-delete/archive variants), `tblSampleIssue`, and
  `tblTempSalesReturnOrder`. There is no `tblOrderInfoMaster` table in this database — an earlier
  pass of this document (before live-schema verification) used that name by mistake; `tblOrder` is
  the correct table.
- Conversion procs: `sp_AutoInvoiceGeneration`, `sp_I_InvoiceMaster`,
  `sp_Process_ProformaInvoiceByOrderId` (and DC/sub-depot/sample variants) — the DC/sub-depot/sample
  variants are still not read in full; the exact trigger condition for auto vs. manual invoice
  generation is **Not Found** beyond "happens after order approval."
- `sp_Process_ProformaInvoiceByOrderId` (manual order → invoice path, called from
  `InvoiceCreationByOrder_daaw.aspx.cs` via `OrderInfoBLL_daaw.GenerateInvoiceByOrderId`) **read in
  full and fixed 2026-08-08** (see
  `spec/database/procs/sp_Process_ProformaInvoiceByOrderId.sql` FIX #5-#8, backup of the pre-fix
  definition at `spec/database/procs/_backups/`). Previously, running out of FEFO-eligible stock
  mid-allocation for a line, or failing the order-level stock pre-check for a product with **no**
  `tblDCStore` row at all (`NULL` compared with `<0` evaluates to `UNKNOWN`, not `TRUE`, so the
  pre-check silently skipped it), still hit `COMMIT` — a partial or empty invoice, reported to the
  caller as success regardless. The proc now sets `@ErrorStat=1` on both paths so they roll back,
  and gained a fail-closed `@Success BIT OUTPUT` parameter (only set to 1 on the real commit) since
  the old caller relied on `RunStoreProcedure`'s rows-affected count, which is meaningless for a
  multi-statement `SET NOCOUNT ON` proc. `GenerateInvoiceByOrderId` (BLL/DAL) now returns that
  `bool` instead of the old (also-meaningless) `Int32`, and `InvoiceCreationByOrder_daaw.aspx.cs`
  surfaces per-order success/failure instead of always showing "Invoice Generated Successfully!".

### 4.2a `sp_UP_LoadingSummary` — the actual loading→delivery→payment orchestration hub (new, this revision)

Not previously documented in this file. `sp_UP_LoadingSummary` (called from `InvoiceDAL.cs`/
`InvoiceDAL_daaw.cs`/`SalesReturnDAL.cs`/`dadtlsInvoiceDAL.cs`) is the real dispatcher that sits
between order→invoice conversion (§4.2) and the DA-side sub-statuses (§4.3), branching on the
caller-supplied `@LoadingSummaryStatus`:

- **`'Rejection'`**: if the invoice isn't yet delivered, archives it to `tblRejectionInvoiceMaster`/
  `Detail`, then internally calls `sp_Delete_ProformaInvoice` (which reverses the stock deduction —
  see §4.2's proc) and sets `tblOrder.isInvoice=1, IsRejectionInvoice=1`.
- **`'Cash'`**: internally calls `sp_DeliveryConformationFull` (marks the invoice fully delivered)
  immediately followed by `sp_PaymentConformationFull` (marks it fully paid) — **cash sales skip the
  separate delivery-confirmation and payment-confirmation UI steps entirely**, both are stamped
  automatically in one call.
- **Any other value**: stamps `LoadingSummaryStatus` to whatever was passed, and still calls
  `sp_PaymentConformationFull` regardless.

**This proc chains 2-3 further procs internally with no shared transaction across the chain** — a
failure partway through (e.g. after the delete-proforma call succeeds but before the loading-summary
log write) can leave the invoice in an inconsistent intermediate state with no automatic rollback.
`sp_DeliveryConformationFull` itself exists in three near-identical versions (`_New`, `_OldData`, plus
the base version) all still referenced by live callers — which one is authoritative for a given code
path was not resolved in this pass.

### 4.3 Invoice DA-side sub-statuses (three independently rejectable tracks)

`tblInvoice` carries three parallel status columns that a **Delivery Associate (DA)** progresses
independently, each with its own approval-log table and its own reject proc:

| Column | Meaning | App-log table(s) | Reject proc |
|---|---|---|---|
| `DA_SalesConfirmStatus` | DA has confirmed the sale was delivered/completed | `tblSalesConfirmation_appLog`, `tblSalesConfirmation_appLogDetail` | `sp_RejectInvoiceDASalesConfirmStatus` |
| `DA_PaymentCollection` | DA has collected payment for the invoice (`DA_PaymentCollectionBy`/`Date` stamp who/when) | (payment collection app-log, not read in full) | `sp_RejectInvoiceDAPaymentCollection` |
| `DA_SalesReturn` | DA has recorded a sales return against the invoice (`DA_SalesReturnDate`/`By`/`Type` stamp) | `tblSalesReturn_appLog`, `tblSalesReturn_appLogDetail` | `sp_RejectInvoiceDASalesReturn` |

Two of the three reject procs follow the identical shape (verified directly for both this revision):
set the relevant `tblInvoice` status column to `'Rejected'`, then **hard-delete** the corresponding
app-log and app-log-detail rows for that invoice — the only place in this system observed to delete
audit rows rather than append a `'Rejected'` log row (contrast with §1.3 step 5's append-only
pattern). A rejected DA sub-status effectively erases its submission history, requiring the DA to
resubmit from scratch rather than see a rejected entry in their log.

**Correction (this revision) — the Payment sibling does NOT match this shape.** The prior version of
this document assumed `sp_RejectInvoiceDAPaymentCollection` mirrors
`sp_RejectInvoiceDASalesConfirmStatus` "by naming/column symmetry," without reading its body. Having
now read it directly: its `UPDATE dbo.tblInvoice SET DA_PaymentCollection='Rejected'` statement is
**commented out** — the proc only deletes the `tblPaymentCollection_appLog` row (`@InvoiceId` is
barely used, its own `WHERE`-clause reference is also commented out). **Rejecting a DA payment
collection therefore does not actually flip `tblInvoice.DA_PaymentCollection` back to `'Rejected'`**
— the invoice is left showing whatever status it had before, while the audit-log row is deleted
regardless. `sp_RejectInvoiceDASalesReturn` (the third sibling) is, by contrast, **more defensive
than the others**: it resolves `@InvoiceId` from `@SalesReturnAppLogId` when not directly passed, and
does correctly set `tblInvoice.DA_SalesReturn='Rejected'` when an invoice ID is resolvable. So of the
three "identical-looking" reject procs, one is exactly as documented, one silently fails to update
its status column, and one is more defensive than its name suggests — do not assume symmetry across
this table without checking each proc individually.

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

## 5a. Market-structure transfer workflow, and a confirmed live bug in two of its six screens (new, this revision)

`TransferUI` implements a propose→approve two-step pattern for reassigning Market/Sub-Territory/
Territory/Area/Zone nodes between organizational units — structurally distinct from both the chain
engine (§1) and the stock-approval pattern (§3): a proposal is written to `tblMarketStructureTranfer`
by `sp_Update_MarketStructure_Transfer` (`@Type` selects which hierarchy level), then a **separate**
step, `sp_Update_MarketStructure_Approve`, reads the pending row back and applies the actual mutation
to `tblMarket`/`tblSubTerritory`/`tblTerritory` only on approval — a flat single-"ApprovedBy"-stamp
approval, not a routed chain.

**Confirmed live bug**: `sp_Update_MarketStructure_Transfer`'s body only has `IF` branches for
`@Type='Market'`, `'Sub-Territory'`, and `'Territory'` — **there is no branch, and no `ELSE`, for
`@Type='Area'` or `@Type='Zone'`**. But `Area_Transfer.aspx.cs` and `Zone_Transfer.aspx.cs` both call
this same proc with exactly those two `@Type` values. When hit, none of the proc's `IF` blocks match,
so it does nothing — no row is written, no error is raised. This is compounded by
`DataAccessManager.ExecuteNonQueryVoid` (the underlying save-call wrapper), which never checks
`SqlCommand.ExecuteNonQuery()`'s rows-affected return value and reports success on "no exception
thrown" alone. **Net effect: the Area Transfer and Zone Transfer screens show a success message while
persisting nothing** — a genuine, user-facing functional defect in 2 of the 6 `TransferUI` screens,
not merely a theoretical gap. Not previously documented anywhere in this spec set.

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
- [`docs/ReceiveQty_RootCause_Analysis.md`](../docs/ReceiveQty_RootCause_Analysis.md) — full
  investigation backing §3.4's two open SAP stock-receive findings.
