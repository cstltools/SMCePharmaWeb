# Business Flow

High-level narrative of how work moves through the system. For the exhaustive per-workflow reference table (status values, stored procedures, gate logic), see [`spec/workflow.md`](../spec/workflow.md) and [`spec/business-rules.md`](../spec/business-rules.md).

## The approval engine, in outline

Most business processes in this system funnel through a shared **multi-level, sequential, role-routed approval pattern**, not a per-module bespoke one:

1. A record is created in a "pending" state (order, expense claim, leave request, doctor visit report, customer master change, etc.).
2. `Library.DAO/UserRoleDAO/ApprovalMapMaster.cs` + `Library.DAL/UserRoleDAL/ApprovalMapDAL.cs` define, per menu (`MenuId`) and originating role (`FromRoleId`), an **ordered list of approver roles** (`ApprovalMapDetail.ToRoleId` + `.Order`) — loaded via `sp_GET_ApprovalMapLoad`, maintained via `sp_Save_ApprovalMapMaster`/`sp_Save_ApprovalMapDetail`.
3. Every record awaiting approval carries a `Step` and a `ToRoleTypeId`. Whichever `Approval_UI` page shows that record only enables its Approve/Reject buttons when `Session["RoleTypeId"]` matches the record's current `ToRoleTypeId` — otherwise the row shows "Waiting for Another Approver" (pattern confirmed in `CustomerApproveList.aspx.cs:439-450` and repeated across the other 11 approval pages).
4. Approving increments `Step` and writes to a dedicated `sp_*AppLog` stored procedure, advancing the record to the next role in the routing table; rejecting writes a rejection status and (in some flows) deletes the in-progress app-log rows so the record can be resubmitted.
5. A `ToRoleTypeId == "5"` (or a hardcoded `EmpInfoId == "496"`) special case appears repeatedly across pages as a final/highest-authority approver bypass — e.g. `DAApprovalList.aspx.cs:144,394` — worth knowing about if a "why did this approve immediately" question comes up.

## Approval workflows catalogued

| Workflow | Page | Status values seen | Approving SP |
|---|---|---|---|
| Customer master | `Approval_UI/CustomerApproveList.aspx.cs` | `Accepted` / `Rejected` | `sp_webapi_SaveCustomerAppLog` |
| DA (delivery agent) claim (TA/DA) | `Approval_UI/DAApprovalList.aspx.cs` | `Accepted` / `Verified` / `Rejected` | `sp_web_SaveTADAAppLog` |
| DCP/CVP tour plan | `Approval_UI/DCPCVPApproval.aspx.cs` | `Verified` / `Rejected` | `sp_webapi_SaveVisitPlanAppLog` |
| DCR (daily call report) | `Approval_UI/DCRApprovalList.aspx.cs` | `Accepted` / `Rejected` | `sp_webapi_SaveDCRAppLog` |
| Doctor master | `Approval_UI/DoctorApprovalList.aspx.cs` | `Verified` / `Rejected` | `sp_webapi_SaveDoctorAppLog` |
| Doctor/customer market transfer + DC stock-out approval (two flows, one page) | `Approval_UI/DoctorCustomerTransferApproval.aspx.cs` | transfer: n/a (direct update); stock-out: `Approved` / reason text | `sp_Update_Customer_Doctor_TransferApprove`; `sp_UD_DcStockOutApproval` |
| Expense claim | `Approval_UI/ExpenseApprovalList.aspx.cs` | `Accepted` / `Verified` / `Rejected` | `sp_web_SaveExpanseAppLog` |
| Leave | `Approval_UI/LeaveApproveList.aspx.cs` | `Accepted` / `Verified` / `Rejected` | `sp_SaveLeaveAppLog` |
| Mileage claim | `Approval_UI/MillageApprovalList.aspx.cs` | same shape as DA claim | `sp_web_SaveMileageAppLog` |
| Sales order | `Approval_UI/OrderApproveList.aspx.cs` | `Accepted` / `Verified` | `sp_webapi_SaveOrderAppLog` |
| RX (prescription) | `Approval_UI/RXApprovalList.aspx.cs` | `Accepted` / `Verified` / `Rejected` | `sp_webapi_SavePrescriptionAppLog` |
| Tour plan | `Approval_UI/TourPlanApproval.aspx.cs` | `Verified` / `Rejected` | `sp_webapi_SaveTourPlanAppLog` |

**Note on data quality**: several pages set an internal `Type` field inconsistently between their approve and reject branches (e.g. `LeaveApproveList.aspx.cs` sets `Type="Leave"` on approve but `Type="Order"` on reject; `TourPlanApproval.aspx.cs` sets `Type="Leave"` on both approve *and* reject, which looks like a copy-paste artifact rather than intent). Flagged here as observed behavior, not fixed.

**Update — `ActionStatus` codes are now resolved.** Reading the actual `sp_webapi_SaveOrderAppLog`
stored procedure body (full source in [`spec/database/procs/`](../spec/database/procs/)) confirms:
`ActionStatus` `'1'` = Verified (mid-chain), `'2'` = Accepted (chain complete), `'3'` = Rejected,
`'0'` = Posted (set once the accepted order is converted to an invoice). `OrderApproveList.aspx.cs`'s
`not in (2,3)` filter simply excludes already-finalized orders from the pending queue. See
[`spec/workflow.md`](../spec/workflow.md) §1.3-§4 for the full routing algorithm this was reverse-engineered from.

## Order-to-cash lifecycle

Grounded in the live schema (previously reconstructed from DAO field lists and root-level `.sql`
scripts, which is why an earlier version of this diagram cited a table name — `tblOrderInfoMaster`
— that doesn't actually exist in the database; the real table is `tblOrder`, confirmed against
[`spec/database-tables.md`](../spec/database-tables.md)):

```
Order (tblOrder)
   │  tblOrder.IsInvoice flag flips when converted; tblOrder.ActionStatus
   │  tracks the approval chain itself (see the Update note above)
   ▼
Invoice generated (tblInvoice, linked by OrderId)
   │
   ▼
DA Sales Confirmation (tblInvoice.DA_SalesConfirmStatus + tblSalesConfirmation_appLog)
   │  + a DIC (Distribution-In-Charge) re-approval layer on top of the DA's own confirmation
   │    (tblSalesConfirmation_appLog.DICApprovalStatus, sp_UpdateDICApprovalStatus)
   ▼
Delivery Challan (ChalanInfo / tblChalanInfo — driver, track no, totals)
   │
   ▼
Payment Collection (tblInvoice.DA_PaymentCollection + tblPaymentCollection_appLog, CustPayment)
   │
   ▼
[optional] Sales Return (tblInvoice.DA_SalesReturn + tblSalesReturn_appLog,
            also DIC-reapproved via sp_UpdateDICApprovalStatus_SalesReturn — see docs/database.md)
```

Each stage that can be rejected has a dedicated "reject" stored procedure (`sp_RejectInvoiceDASalesConfirmStatus`, `sp_RejectInvoiceDAPaymentCollection`, `sp_RejectInvoiceDASalesReturn` — source now in [`spec/database/procs/`](../spec/database/procs/), not the repo root; see [`docs/database.md`](database.md)) that flips the relevant `tblInvoice` status column back and deletes the corresponding in-progress app-log rows, effectively resetting that stage for resubmission.

**Gap, now closed**: the full column list of `tblOrder`, `tblInvoice`, and the challan tables is
**not** fully mirrored in the C# DAO classes (confirmed: `Invoice.cs` is missing
`DA_SalesConfirmStatus`/`DA_PaymentCollection`/`DA_SalesReturn`, which real SQL scripts read/write
directly) — but this is no longer a documentation gap, since the actual column list is now in
[`spec/database-tables.md`](../spec/database-tables.md) regardless of what the DAO class shows.
Treat any `Library.DAO` class in this codebase as a **possibly partial** view of its table, and
check the schema file directly when a DAO class's shape is in question.

## Warehouse stock-in — SAP-to-DC receiving pipeline

A separate pipeline moves goods *into* the distribution center, parallel to (and feeding the stock
behind) the order-to-cash flow above, but with no role-routed approval chain of its own: an
external SAP-side process (not in this repo) posts shipment data into a separate staging database,
`SAP_API_Data` (see [`docs/database.md`](database.md)); a chain of `sp_SAP_*` stored procedures
(`sp_SAP_StockReceive` orchestrating `sp_SAP_WhStockInMaster`/`Details` →
`sp_SAP_STOMaster`/`Details` → `sp_SAP_StockInTransfer`) copies that data through
`tblWHStockInMaster`/`Detail` → `tblRequisition`/`tblRequsitionChild` → `tblStockInTransfar`, which a
warehouse clerk then confirms on `SInventory_UI/ReceiveProductByChalanByDC.aspx`. The only human
gate here is the clerk keying an observed shortage into `UnRcvQty` at receive time — there's no
`Approval_UI`-style multi-step sign-off.
[`docs/ReceiveQty_RootCause_Analysis.md`](ReceiveQty_RootCause_Analysis.md) traces this whole
pipeline end-to-end and documents two confirmed data-integrity defects found in it: the same
shipment synced into the app twice under two different Chalan-number strings (so it could be
received twice), and a duplicate-insert bug inside `sp_SAP_StockInTransfer` backed only by an unsafe
check-then-insert guard. See that doc for the full trace and root-cause detail rather than
duplicating it here.

## Leave approval — a workflow with a real side effect beyond status

Unlike the other approval queues in the table above, leave approval (`LeaveApproveList.aspx.cs` →
`sp_SaveLeaveAppLog`) has a confirmed **balance-ledger side effect**: final Accept deducts the
requested days from `Employee_YearlyLeaveBalance` and appends a debit row to `tblLeaveOperation`;
rejecting an application that had *already* been Accepted refunds the balance but — per the proc body
read for this pass — does **not** append a corresponding credit row to that ledger, a probable
audit-trail asymmetry. There is also a second, separately-callable proc
(`sp_Approve_EmployeeLeaveApplication`) using a different status convention and a different ledger
table (`Employee_YearlyLeaveTranscations`) whose caller was not identified — possibly a legacy or
admin-override path still live in the database but unreachable from the primary UI. See
[`spec/workflow.md`](../spec/workflow.md) §5 for the full state-machine detail.

## Field-force / doctor-call side

Separately from order-to-cash, the field-force module (`DoctorModule_UI`, `DoctorVisit_UI`, `DWSP`) runs its own cycle: tour plan → doctor visit / daily call report (DCR) → doctor call programme (DCP) → prescription (RX) capture, each with its own approval queue in the table above, and its own reporting family in `Reports_UI` (`DcrDoctoriseMonthlypt`, `DcpDoctoriseMonthlypt`, `CVRDoctoriseMonthlypt`, `RXDoctoriseMonthlypt`). See [`spec/modules.md`](../spec/modules.md) for the module inventory and [`spec/reports.md`](../spec/reports.md) for the report catalog.
