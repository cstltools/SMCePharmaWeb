# Receive Quantity Root Cause Analysis

**Investigation date:** 2026-08-11
**Investigated by:** Claude Code, at request of project owner
**Scope:** Static code trace + live read-only queries against the dev copies of `SalesDisDB_SMC_NEWDB` and `SAP_API_Data` on `TOWSIF\MSSQLSERVER2019` (confirmed by the user as a safe local dev environment, not production). No INSERT/UPDATE/DELETE was executed anywhere. No application file, stored procedure, or table was modified.

---

## 1. Problem Summary

On `SInventory_UI/ReceiveProductByChalanByDC.aspx`, the `RcvQty` column sometimes does not represent the true quantity that should be received for a Chalan line item. Using Chalan `4500008881` (as given by the user) as the worked example, this investigation found **two distinct, independently-confirmed defects**, both traced to real records in the dev database, not merely theorized:

1. **The same physical SAP shipment was synced into the application twice, under two different Chalan-number strings, 10 days apart.** One copy (`45000088812`, Requisition `ReqId=6304`) has already been fully received into stock. The other copy (`4500008881`, `ReqId=6295` — the one in the user's screenshot) is still sitting fully pending. Receiving it now would receive the same physical goods a second time.
2. **Within that same pending Chalan (`ReqId=6295`), one product/batch line (`ANM01`, batch `004/24`) is listed four times instead of two**, because the pipeline that populates `tblStockInTransfar` inserted duplicate rows for the same `ReqChildId`.

Neither defect is a calculation bug inside `ReceiveProductByChalanByDC.aspx` itself — that page simply displays, per line, `RcvQty = Quantity` (see §15). The bug is entirely upstream, in the SAP → local-table integration pipeline.

## 2. Affected Page

`Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx` + `ReceiveProductByChalanByDC.aspx.cs` (`SInventory_UI_ReceiveProductByChalanByDC`).

## 3. Data Flow

```
SAP (external system, not in this repo)
   │
   ▼  (external SAP-side process writes directly into SAP_API_Data — spec/integrations.md §1)
SAP_API_Data.tblSAP_StockMovementMaster   (one row per SAP goods-movement document; keyed only by challan_code, a free-text string)
   │  M.StockMovementMasterId = D.StockMovementMasterId
   ▼
SAP_API_Data.tblSAP_StockMovementDetail   (one row per product/batch/qty line under a Master)
   │
   │  manual trigger: staff clicks "Receive" on SAP_Integration/SAP_StockReceive.aspx
   │  → SAP_IntrigationPointDAL.SaveStockReceive(challanNo) → EXEC sp_SAP_StockReceive @ChallanNo, @ApproveBy
   ▼
sp_SAP_StockReceive  (orchestrator, live proc, confirmed identical to spec/database/procs copy)
   │  IF is_from_wharehouse = 1 AND is B2B = 0:
   ├─► sp_SAP_WhStockInMaster   @ChallanNo        → INSERT tblWHStockInMaster   (guard: challan_code NOT IN existing ChallanNo values)
   ├─► sp_SAP_WhStockInDetails  @MasterId,@ChallanNo → INSERT tblWHStockInDetail (one row per matching Master×Detail join, NOT de-duplicated/summed)
   ├─► sp_SAP_WHStockInApprove
   ├─► sp_SAP_STOMaster         @WHMasterInId     → INSERT tblRequisition       (creates ReqId; also stamps IssueChalanNo/IssuChalanDate — see §13 caveat)
   ├─► sp_SAP_STODetails        @WHMasterInId,@ReqMasterId → INSERT tblRequsitionChild (ReqQty = tblWHStockInDetail.Qty)
   ├─► sp_SAP_RequisitionMasterUpdate / sp_SAP_RequisitionDetailUpdate
   └─► sp_SAP_StockInTransfer   @WHStockInMasterID,@ReqId → INSERT tblStockInTransfar  (Quantity = tblRequsitionChild.ReqQty, via a CTE join — see §5)
           │
           ▼
   RequisitionDAL.GetStockInTransfarByReqIdDAL(reqId)
     "SELECT * FROM tblStockInTransfar WHERE IsTransfared is null and ReqId=@ReqId"
           │
           ▼
   ReceiveProductByChalanByDC.aspx.cs → LoadGrid(reqId) → rcvGridView.DataBind()
           │
           ▼
   ReceiveProductByChalanByDC.aspx markup, line 134:
     <asp:TextBox ID="rcvQtyTextBox" ... Text=<%# Eval("Quantity") %> ReadOnly="True" .../>
           │
           ▼
        RcvQty textbox  (== tblStockInTransfar.Quantity, verbatim, unless the user later edits UnRcvQty)
```

## 4. Relevant Files

| File | Role |
|---|---|
| `Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx` | GridView markup; `RcvQty` bound to `Eval("Quantity")` (line 134) |
| `Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx.cs` | `Page_Load` → `LoadGrid(reqId)`; `Save()` writes to `tblDCStore`/`tblDCStoreFreeze` and marks `tblStockInTransfar.IsTransfared='OK'` |
| `Library.BLL/SInventory_BLL/RequisitionBLL.cs` | `GetStockInTransfarByReqId`, `GetRequisitionInfoByReqId`, `DCStockIn2` pass-throughs |
| `Library.DAL/SInventory_DAL/RequisitionDAL.cs` | `GetStockInTransfarByReqIdDAL` (`SELECT * FROM tblStockInTransfar WHERE IsTransfared is null AND ReqId=@ReqId`), `GetRequisitionInfoByReqIdDAL` (`SELECT * FROM tblRequisition WHERE ReqId=@ReqId`) |
| `Library.DAL/SAP_IntegrationDAL/SAP_IntrigationPointDAL.cs` | `SaveStockReceive(challanNo)` → `EXEC sp_SAP_StockReceive` — the manual trigger for the whole SAP-sync chain |
| `Solution.Web/SAP_Integration/SAP_StockReceive.aspx(.cs)` | Admin page that calls `SaveStockReceive` |
| `spec/integrations.md` §1 | Pre-existing documentation of the SAP staging/reconciliation pattern (confirms `SAP_API_Data` is filled by an external, out-of-repo SAP-side process) |

No JavaScript, AJAX endpoint, `.asmx`, or client-side logic contributes to `RcvQty`'s initial value — it is a plain server-side data-bind. The only client/postback logic touching `RcvQty` after load is `damageTextBox_TextChanged` / `rcvQtyTextBox_TextChanged` (see §14), which only run if the user edits `UnRcvQty`.

## 5. Relevant Stored Procedures

| Procedure | Verified against live DB? | Parameters | Tables touched | Column feeding `RcvQty` chain |
|---|---|---|---|---|
| `sp_SAP_StockReceive` | Yes, definition pulled from `sys.sql_modules`, byte-identical to `spec/database/procs/sp_SAP_StockReceive.sql` | `@ChallanNo`, `@ApproveBy` | orchestrates all procs below | — |
| `sp_SAP_WhStockInMaster` | Yes | `@ChallanNo` | reads `SAP_API_Data..tblSAP_StockMovementMaster/Detail`, `tblProduct`, `tblUnitPrice`; writes `tblWHStockInMaster` | `SUM(quantity)` → `TotalQuantity` (aggregate only, not row-level) |
| `sp_SAP_WhStockInDetails` | Yes | `@MasterId`, `@ChallanNo` | same SAP source join; writes `tblWHStockInDetail` | `quantity` → `Qty` (**one row per Master×Detail match, no `GROUP BY`/`SUM`**) |
| `sp_SAP_STOMaster` | Yes | `@WHMasterInId` | reads `tblWHStockInMaster` (+ SAP join for plant lookup only); writes `tblRequisition` | — |
| `sp_SAP_STODetails` | Yes | `@WHMasterInId`, `@ReqMasterId` | reads `tblWHStockInDetail`; writes `tblRequsitionChild` | `Qty` → `ReqQty` |
| `sp_SAP_StockInTransfer` | Yes (live `modify_date` 2026-02-16, text identical to spec copy) | `@WHStockInMasterID`, `@ReqId` | reads `tblWHStockInDetail`, `tblCentralStore`, `tblWHStockInMaster`, `tblProduct`, `tblRequsitionChild` (+ dead SAP join, see §7); writes `tblStockInTransfar` | `Qty` → `Quantity` — **this is the exact column `RcvQty` is bound to on the page** |

`RequisitionDAL.GetStockInTransfarByReqIdDAL` is the only query the page itself runs; it is a plain, unfiltered `SELECT * ... WHERE IsTransfared IS NULL AND ReqId=@ReqId` — it performs no aggregation, no join, and cannot itself introduce duplication. Whatever rows exist in `tblStockInTransfar` for that `ReqId` are shown as-is.

## 6. SAP Database Tables

`SAP_API_Data` (confirmed present on the same dev server; 2,376 master rows / 25,399 detail rows at time of investigation):

**`tblSAP_StockMovementMaster`** — PK `StockMovementMasterId` (int, identity-style, surrogate). Columns: `challan_code` (nvarchar, **no unique/index constraint**), `challan_date`, `is_from_wharehouse` (bit), `from_plant_code`, `to_plant_code`, `truck_no`, `driver_name`, `entryDate`, `IsReceived`, `ReceiveDate`, `ReceiveBy`, `isConfirmDone`.

**`tblSAP_StockMovementDetail`** — PK `StockMovementDetailId`. Columns: `StockMovementMasterId` (FK, not enforced by a constraint — no FK constraint was found, only the PK), `product_code`, `batch_no`, `quantity`, `unit_price`, `UOM`, `unit_vat`, `net_amount`, `expiry_date`, `manufacturer_date`, `Original_SAP_Stock`.

**Notable structural facts, confirmed against `sys.indexes`/`sys.columns`:**
- Neither table has **any field that identifies a SAP movement type** (no 101/102-style code, no "goods receipt vs. reversal" flag). Only `is_from_wharehouse`/`from_plant_code`/`to_plant_code` distinguish routing.
- Neither table has a **SAP document number, line-item number, or any other natural key** beyond the free-text `challan_code` string. There is nothing in the schema that could be used to detect "this is the same SAP posting as that other row."
- `challan_code` has **no unique constraint**, so nothing in the database prevents the same Chalan from being posted as multiple `tblSAP_StockMovementMaster` rows.

## 7. Master/Detail Relationship

The join used everywhere in the pipeline is `M.StockMovementMasterId = D.StockMovementMasterId`, which is a correct, standard FK-style join — it does not itself multiply rows (each Detail row belongs to exactly one Master). The actual multiplication risk is **not** in this join; it is in how many Master rows can independently exist for what a human considers "one Chalan" (see §10), and in the *downstream* joins inside `sp_SAP_StockInTransfer` (`tblWHStockInDetail` × `tblCentralStore` × `tblRequsitionChild`, joined only by `ProductCode`+`BatchNo`, not by any row-unique key) — see §14 for the confirmed consequence of that join shape.

Separately, three procedures (`sp_SAP_WhStockInMaster`, `sp_SAP_WhStockInDetails`, `sp_SAP_STOMaster`, `sp_SAP_STODetails`) all carry a `LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM ON UPPER(RTRIM(LTRIM(M.ChallanNo))) = UPPER(RTRIM(LTRIM(SM.challan_code)))` purely to resolve `to_plant_code → tblCompanyUnit.SAP_Code` for a `ComUnitId`/`ComUnitCode`/`ComUnitName` lookup. In `sp_SAP_WhStockInDetails`, `sp_SAP_STODetails`, and `sp_SAP_StockInTransfer`, **the resulting `ComUnitId`/`UT` columns are read into cursor variables but never actually written to any INSERT statement** — this join is dead weight that adds duplication *risk* (if `challan_code` is not unique, this LEFT JOIN fans out) without adding functional value. It was not the row-count driver observed in this investigation, but it is a latent risk factor documented for completeness (see §16, LOW).

## 8. Chalan 4500008881 Investigation

The literal 10-digit string `4500008881` does **not** currently exist in `SAP_API_Data.tblSAP_StockMovementMaster`. Searching by prefix `450000888%` returned:

| StockMovementMasterId | challan_code | Length | challan_date | entryDate |
|---|---|---|---|---|
| 432 | `45000088811` | 11 | 2024-05-15 | 2024-05-15 11:42:49 |
| 449 | `45000088811` | 11 | 2024-05-25 | 2024-05-25 10:13:39 |
| 450 | `45000088812` | 11 | 2024-05-25 | 2024-05-25 21:23:17 |

i.e. the SAME 11-digit `challan_code` (`45000088811`) was posted **twice**, 10 days apart (432, 449), and a **third**, near-identical code (`45000088812`, differing only in the final digit) was posted a few hours after the second (450). The exact 10-digit `4500008881` the user sees in the UI does not exist as a standalone SAP master row today — it only exists as the `ChallanNo` already recorded in the app's own `tblWHStockInMaster`/`tblRequisition` (created 2024-05-19, i.e. *between* Master 432 and Master 449), meaning the SAP-side value this app originally matched against has since been altered or removed at the source, with no audit trail available to reconstruct exactly what it looked like at match time.

Local tables confirm two independently-synced chains for this shipment:

| Table | Row | ChallanNo/IssueChalanNo | Date | Total | Status |
|---|---|---|---|---|---|
| `tblWHStockInMaster` | Id 1231 | `4500008881` | 2024-05-15 (Chalan) / entry 2024-05-19 09:20:20 | TotalQuantity **11852** | Approved, `Remarks='From SAP'`, `EntryBy='Auto Posting'` |
| `tblWHStockInMaster` | Id 1240 | `45000088812` | 2024-05-25 (Chalan) / entry 2024-05-25 22:28:54 | TotalQuantity **11852** (identical) | Approved, same auto-posting signature |
| `tblRequisition` | ReqId **6295** | `4500008881` | entry 2024-05-19 09:20:20 | — | `Submit='OK'`, `ReceiveIssue` = **empty (not yet received)** |
| `tblRequisition` | ReqId **6304** | `45000088812` | entry 2024-05-25 22:28:54 | — | `Submit='OK'`, `ReceiveIssue='OK'`, **ReceiveIssueDate = 2024-05-26** |

No duplicate/reversed/cancelled movement flags exist in the schema to check (`IsReceived`/`isConfirmDone` are simple booleans, not movement-type codes); the duplication is entirely at the `challan_code`/Requisition level.

## 9. Product-wise Reconciliation

For the 8 products in the user's example, `ReqId=6295` (still pending — the Chalan shown in the screenshot) vs. `ReqId=6304` (already fully received):

| ProductCode | Batch | ReqId 6295 Qty (pending) | ReqId 6304 Qty (already received `IsTransfared='OK'`) | Match? |
|---|---|---|---|---|
| ARD03 | 003/24 | 84 | 84 | Identical |
| FGD01 | 056 | 216 | 216 | Identical |
| OAD02 | 083 | 448 | 448 | Identical |
| ANB03 | 003 | 200 | 200 | Identical |
| ANB07 | 152 | 250 | 250 | Identical |
| ANB09 | 061 | 270 | 270 | Identical |
| ANB10 | 101 | 672 | 672 | Identical |
| MNS03 | 257 | 600 | 600 | Identical |

All 8 products/batches from the user's screenshot are **exact product+batch+quantity matches** against goods that were already received into stock 10 days earlier under `ReqId=6304`. This is not a coincidence or a similar-looking shipment — it is the same physical delivery, confirmed line-by-line.

Full `ReqId=6295` set: 23 rows, `SUM(Quantity)=13568`, all 23 rows still pending. `ReqId=6304`: 22 rows, `SUM(Quantity)=14036`, all fully received. (Totals differ from each other and from `tblWHStockInMaster.TotalQuantity=11852` because of the additional duplication described in §10/§14 and because `sp_SAP_WhStockInMaster`'s `SUM` is computed from a different, earlier join than the final `tblStockInTransfar` population — the three numbers are produced by three different queries at three different pipeline stages, not reconciled against one another anywhere in the code.)

## 10. Duplicate Data Analysis

Detail-level query against the 3 related SAP masters (432, 449, 450) shows the corruption directly:

| Product | Batch | Master 432 (05/15, "clean") | Master 449 (05/25 AM, same challan_code as 432) | Master 450 (05/25 PM, new challan_code) |
|---|---|---|---|---|
| ...141010 (ARD03) | 003/24 | 84 | **2520** (30×) | 84 |
| ...141050 (ARD12) | 005/24 | 84 | **2520** (30×) | 84 |
| ...141037 (VTM02) | 001/24 | 420 | **25200** (60×) | 420 |
| ...141018 (ANM01) | 004/24 | 780 **and** 936 (2 rows) | **28080** and **37440** (2 rows, ~36×/40×) | **1248** and 936 (2 rows — a *third*, different split) |
| all other 16 products | various | consistent | consistent | consistent |

This is a genuine SAP-source data-quality defect: the external SAP-side process (not in this repo — see `spec/integrations.md` §1) re-posted the same `challan_code` (`45000088811`) ten days later with several product quantities inflated by inconsistent factors (30×, 36×, 40×, 60×) — the pattern is consistent with a unit-of-measure/pack-size conversion error on a re-export, not a deliberate correction. A few hours after that corrupted re-post, a third master (`45000088812`) appeared with mostly-correct quantities but yet a *third*, different split for the `ANM01`/`004-24` batch (1248/936, matching neither 432's 780/936 nor 449's corrupted values).

**None of the corrupted Master-449 quantities (2520, 25200, 28080, 37440) actually made it into `tblWHStockInMaster`/`tblRequisition`** — because `sp_SAP_WhStockInMaster`'s guard (`challan_code NOT IN (SELECT ChallanNo FROM tblWHStockInMaster ...)`) blocks re-processing the *same exact string* `challan_code` a second time, so Master 449 (same string as Master 432, already consumed) was silently ignored by the app. This guard worked correctly for Master 449 specifically. It did **not** and structurally **cannot** protect against Master 450, because 450's `challan_code` string (`45000088812`) is different from the one already recorded (`4500008881`/`45000088811`) — the guard only ever compares literal strings, with no concept of "this is probably the same shipment as a Chalan I already processed."

## 11. Movement Type Analysis

Not applicable to this schema — confirmed in §6, `tblSAP_StockMovementMaster`/`Detail` carry no movement-type column at all. There is no positive/negative or receipt/reversal distinction anywhere in the SAP staging tables used by this pipeline; filtering is done purely by `challan_code` string equality and `ISNULL(quantity,0) > 0`.

## 12. Batch-wise Analysis

Confirmed **product + batch** level, not product-only or product+batch+Chalan-only: every query in the pipeline (`sp_SAP_WhStockInDetails`, `sp_SAP_STODetails`, `sp_SAP_StockInTransfer`) keeps `batch_no`/`Batch`/`BatchNo` as a distinguishing column throughout, and the UI grid shows one row per `(ProductCode, BatchNo)` combination, not aggregated across batches. The example in §8/§9 (Product A batch 001=100 vs batch 002=200 not merging into 300) does **not** occur here — batches are kept separate correctly. The actual defect is a different kind of duplication: the *same* `(ProductCode, BatchNo, ReqId)` combination appearing more than once as separate grid rows (see §14), and the *same* shipment appearing under two different `ReqId`s (see §8/§9).

## 13. Date Filter Analysis

None of the five stored procedures in the chain (`sp_SAP_WhStockInMaster`, `sp_SAP_WhStockInDetails`, `sp_SAP_STOMaster`, `sp_SAP_STODetails`, `sp_SAP_StockInTransfer`) filter by `challan_date`, posting date, or any date range at all — matching is purely by `challan_code` string. Date fields are carried through as data, not used as filters, so no old/new record was wrongly included or excluded by a date condition.

One separate, secondary finding: on the UI, "Chalan Date" is populated from `tblRequisition.IssuChalanDate`, and the live data shows `IssuChalanDate` for ReqId 6295 = `2024-05-19 09:20:20` — this is the **sync/entry timestamp**, not `tblSAP_StockMovementMaster.challan_date` (which is `2024-05-15` for Master 432) or `tblWHStockInMaster.ChallanDate` (also `2024-05-15`). `sp_SAP_STOMaster`'s SELECT does read the correct `M.ChallanDate` into `@ChallanDate`, but the `INSERT INTO tblRequisition` statement never includes an `IssuChalanDate`/`ChallanDate` column at all (see the live procedure text in §5) — so wherever `tblRequisition.IssuChalanDate` actually gets its value (not from this procedure, based on the column list), it is a separate, unlocated code path storing the entry time instead of the true Chalan date. This does not affect `RcvQty` but does mean the "Chalan Date" shown to the user (19-May-2024 in their example) is mislabeled — the real SAP Chalan Date is 15-May-2024.

## 14. C# Code Trace

`Page_Load` (not `IsPostBack`) → `LoadGrid(reqId)` → `RequisitionBLL.GetStockInTransfarByReqId` → `RequisitionDAL.GetStockInTransfarByReqIdDAL`:
```csharp
string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE IsTransfared is null and ReqId=@ReqId";
```
This is a single, unfiltered, un-aggregated `SELECT *`. `rcvGridView.DataSource = aDataTableForGrid; rcvGridView.DataBind();` binds it directly — **whatever duplicate rows exist in `tblStockInTransfar` are rendered as separate grid rows verbatim.** There is no `RowDataBound` logic, no dedup, no grouping in the code-behind.

`RcvQty` is set exactly once, declaratively, in the markup (`ReceiveProductByChalanByDC.aspx:134`): `Text=<%# Eval("Quantity")%>`. It is **not** recalculated from any independent "actual received" source, SAP confirmation, or prior receive history — it is a straight copy of whatever `Quantity` the row carries. `ReadOnly="True"` prevents direct typing, but `AutoPostBack="True"`/`OnTextChanged="rcvQtyTextBox_TextChanged"` are wired up regardless (dead code path for a readonly control under normal use).

The only thing that changes `RcvQty` after binding is the companion `damageTextBox` (labeled "UnRcvQty" in the UI, defaults to `0`): `damageTextBox_TextChanged` recomputes `rcvQtyTextBox.Text = issueQty - damageQty`. So the intended workflow is "assume full receipt (`RcvQty = Quantity`), let the warehouse clerk key in any shortage into `UnRcvQty`, and the system back-calculates the true `RcvQty`." If the clerk does not notice/enter a shortage — which is exactly what happens when the underlying Chalan itself is a duplicate or contains duplicate rows — the default (wrong) `Quantity` value is submitted as-is.

`if (!IsPostBack)` runs once per fresh page load (with `Session`/`ViewState` carrying the grid across postbacks from `damageTextBox_TextChanged`); no evidence of `Page_Load` running multiple times or of `RcvQty` being overwritten by a second DB call. Postback/ViewState/session logic does **not** contribute to this specific bug — the duplication is already present in the data by the time the page ever runs.

## 15. RcvQty Calculation Logic

```
RcvQty (initial, on bind)  =  tblStockInTransfar.Quantity   (verbatim, no calculation)
RcvQty (after UnRcvQty edit) =  Quantity − UnRcvQty          (client/server round-trip via TextChanged handlers)
```
`tblStockInTransfar.Quantity` traces to `tblRequsitionChild.ReqQty` (via `sp_SAP_StockInTransfer`'s CTE `SELECT ... Qty ... FROM tblWHStockInDetail AS D ... LEFT JOIN tblRequsitionChild AS RD ON PD.ProductCode = RD.ProductCode AND RD.BatchNO = CS.BatchNO ...`), which traces to `tblWHStockInDetail.Qty`, which traces to `SAP_API_Data.tblSAP_StockMovementDetail.quantity` (via `sp_SAP_WhStockInDetails`). There is no `SUM`/aggregation anywhere in this final leg — each `tblSAP_StockMovementDetail` row that survives the `Master⋈Detail⋈Product⋈UnitPrice` join produces its own `tblWHStockInDetail` row, its own `tblRequsitionChild` row, and (subject to the CTE's `ROW_NUMBER() PARTITION BY RD.ReqChildId` collapse) its own `tblStockInTransfar` row.

**Confirmed duplicate rows within `ReqId=6295` itself:**

| StockInTransfarId | ProductCode | Batch | Quantity | ReqChildId (via `tblRequsitionChild`) |
|---|---|---|---|---|
| 52486 | ANM01 | 004/24 | 780 | 82176 |
| 52487 | ANM01 | 004/24 | **780 (duplicate)** | 82176 (same) |
| 52488 | ANM01 | 004/24 | 936 | 82174 |
| 52489 | ANM01 | 004/24 | **936 (duplicate)** | 82174 (same) |

`tblRequsitionChild` itself has only **one** row each for `ReqChildId=82174` (936) and `ReqChildId=82176` (780) — confirmed by direct query. So the duplication was introduced specifically by `sp_SAP_StockInTransfer`'s execution against those two `ReqChildId`s, **not** by `tblRequsitionChild` carrying duplicate source rows. The guard inside that procedure (`WHERE RD.ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM tblStockInTransfar WHERE ReqChildId IS NOT NULL)`) is exactly the kind of "check, then insert" pattern that is safe only if the procedure never runs twice concurrently/overlapping for the same input — there is no application lock, no transaction-scoped guard, and no uniqueness constraint on `tblStockInTransfar (ReqChildId)` backing it up. (This repo already has one other confirmed instance of exactly this class of bug — a duplicate-submission race in `dadtlsDelivaryInvoiceDetailsCreation_DA.aspx.cs`, fixed earlier in this engagement — so this failure mode is a known, recurring pattern in this codebase, not a one-off.) I could not obtain execution logs/SQL Agent history to prove *how many times* or *by what trigger* `sp_SAP_StockInTransfer` actually ran for `@ReqId=6295`; the observed data is consistent with the procedure having executed more than once for the same input without its check-then-insert guard being safe under concurrent/repeated execution.

## 16. Root Cause

Ranked, with confidence level:

| # | Root Cause | Category (from Step 15 list) | Severity | Confidence |
|---|---|---|---|---|
| 1 | The same physical SAP shipment was posted to `SAP_API_Data.tblSAP_StockMovementMaster` under **two different `challan_code` strings** 10 days apart (`45000088811`/matched as `4500008881` on 05/19, and `45000088812` on 05/25). Both were independently processed all the way through to a `tblRequisition`/`tblStockInTransfar` chain. The second (`ReqId=6304`) has already been fully received. The first (`ReqId=6295`, the Chalan in the user's screenshot) is still pending. **Receiving it now double-counts stock already received.** | **#1 SAP source data issue** + **#2 SAP integration duplicate issue** + **#7 Wrong Chalan mapping** (the app's exact-string `challan_code` matching has no way to recognize these as the same shipment) | **CRITICAL** | **CONFIRMED** — product/batch/quantity match verified line-by-line (§9), timestamps and auto-posting signatures verified (§8) |
| 2 | Within the still-pending Chalan (`ReqId=6295`) itself, one product/batch (`ANM01`/`004-24`) is represented by **4 `tblStockInTransfar` rows instead of 2**, tracing to a duplicate insert against the same two `ReqChildId`s by `sp_SAP_StockInTransfer`. Its "already inserted?" guard is a plain `NOT IN` check with no lock/transaction/unique-constraint backing, i.e. unsafe under repeated or overlapping execution. | **#3 Master/Detail-adjacent join issue** (contributing shape) + **#9 Stored procedure issue** (unsafe duplicate-check pattern) | **HIGH** | **CONFIRMED** the duplicate rows exist and their line-level `RcvQty` consequence is real; **POSSIBLE** as to the exact triggering mechanism (repeated manual trigger vs. a genuine concurrency race) — could not be pinned down further without execution/audit logs this investigation did not have access to |
| 3 | The SAP source itself re-posted the same `challan_code` (`45000088811`) with severely inflated quantities for 4 products (30×–60× off) 10 days after the original — a real, external data-quality defect. The app's existing "already-processed `challan_code`" guard happened to block this corrupted re-post from reaching local tables this time, but that protection is incidental (string-equality only) and does not generalize (see root cause #1, where a *different* string bypassed it entirely). | **#1 SAP source data issue** | MEDIUM (did not directly cause the observed RcvQty bug, but is direct evidence the SAP feed is unreliable and the app has no systematic defense) | **CONFIRMED** — exact corrupted values captured in §10 |
| 4 | `RcvQty` itself is *by design* nothing more than a copy of `Quantity`, with correction only via manual `UnRcvQty` entry — there is no independent "actual quantity received/confirmed" signal from SAP or elsewhere that the page cross-checks against. This isn't a "bug" in isolation, but it is why root causes #1–#3 are invisible to the receiving clerk: the page has no way to flag "this Chalan/line looks like a duplicate" — it just shows whatever `Quantity` landed in `tblStockInTransfar`. | **#10 C# business logic issue** (design gap, not a defect in existing logic) | LOW/informational | **CONFIRMED** by direct code read (§4, §15) |
| 5 | Several `LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster` clauses inside `sp_SAP_WhStockInMaster`/`sp_SAP_WhStockInDetails`/`sp_SAP_STOMaster`/`sp_SAP_STODetails` compute `ComUnitId`/`UT` columns that are **never used** in any downstream INSERT — dead logic that adds row-multiplication risk (since `challan_code` is not unique) for no functional benefit. Not observed to be the actual driver of the Chalan-4500008881 case, but a latent risk for other Chalans. | **#3 Master/Detail join issue** (latent) | LOW | **CONFIRMED** dead code exists; **not confirmed** as having caused a real incident yet |

## 17. Evidence

All values below were retrieved via read-only `SELECT` queries against the dev server (`TOWSIF\MSSQLSERVER2019`, databases `SalesDisDB_SMC_NEWDB` and `SAP_API_Data`), confirmed by the user as safe to query.

- `tblSAP_StockMovementMaster`: 3 rows for `challan_code LIKE '450000888%'` matching this shipment — StockMovementMasterId 432, 449, 450 (§8, §10).
- `tblSAP_StockMovementDetail`: 61 detail rows across those 3 masters, itemized in §10, showing the 30×–60× quantity corruption on Master 449 and the differing ANM01 split on Master 450.
- `tblWHStockInMaster`: Id 1231 (`ChallanNo='4500008881'`) and Id 1240 (`ChallanNo='45000088812'`), both `Remarks='From SAP'`, `EntryBy='Auto Posting'`, both `TotalQuantity=11852`.
- `tblRequisition`: ReqId 6295 (`IssueChalanNo='4500008881'`, not yet received) and ReqId 6304 (`IssueChalanNo='45000088812'`, `ReceiveIssue='OK'`, `ReceiveIssueDate=2024-05-26`).
- `tblStockInTransfar`: ReqId 6295 → 23 rows, all `IsTransfared IS NULL` (pending); ReqId 6304 → 22 rows, all `IsTransfared='OK'` (received); the 8 example products match exactly between the two sets (§9); the ANM01/004-24 4-row duplication within ReqId 6295 (§15), cross-checked against `tblRequsitionChild` which holds only 1 row per `ReqChildId` (82174=936, 82176=780).
- Live stored procedure text for all 5 procedures pulled directly from `sys.sql_modules` and confirmed byte-identical to the `spec/database/procs/*.sql` copies (§5), so the `spec/` copies used throughout this analysis are trustworthy, current ground truth.
- `SAP_IntrigationPointDAL.SaveStockReceive` → `sp_SAP_StockReceive` confirmed as the actual manual trigger for the whole chain (§3), and `sp_SAP_StockReceive`'s body confirmed to call the 5 sub-procedures in the order documented in §3/§5.

## 18. Recommended Fix

**Not implemented in this investigation, per your instruction ("Only after I review and approve the root cause will we create the implementation/fix plan").** For your review, in priority order:

1. **For root cause #1 (CRITICAL):** Before receiving any Chalan on `ReceiveProductByChalanByDC.aspx`, cross-check whether an already-received Requisition exists with the same `ComUnitId` + overlapping/identical product+batch+quantity set within a short time window (or, more robustly, ask the SAP side for a stable per-shipment key instead of a mutable `challan_code`). At minimum, block/warn when a Chalan's line items exactly match an already-`ReceiveIssue='OK'` Requisition.
2. **For root cause #2/#5 (HIGH/LOW):** Make `sp_SAP_StockInTransfer`'s duplicate guard actually safe — either a real uniqueness constraint on `tblStockInTransfar(ReqChildId)` (so a second insert fails loudly instead of silently duplicating), or serialize the whole `sp_SAP_StockReceive` chain behind an application lock the way the DA delivery-invoice submit path was already fixed earlier in this engagement. Also remove the dead `SAP_API_Data` LEFT JOINs in §7/§16-row-5 that compute unused columns.
3. **For root cause #3 (MEDIUM):** Add a sanity check when consuming `SAP_API_Data` quantities (e.g., reject/flag postings where a re-synced `challan_code`'s quantity for a product deviates wildly — say >5×—from a prior posting of the same product/batch under the same code) rather than silently trusting whatever the feed sends.
4. **For root cause #4 (LOW):** Consider whether `RcvQty` should default to `Quantity` at all, versus defaulting to blank/requiring explicit confirmation — a design question, not a pure bug fix.

## 19. Risk of Current Logic

- **Silent double stock-in**: any Chalan that has been re-synced under a second `challan_code` string will look completely normal on `ReceiveProductByChalanByDC.aspx` — full quantities, `UnRcvQty=0` — with nothing in the UI hinting that it duplicates already-received stock. A clerk has no way to detect this from the page.
- **Silent within-Chalan over-receipt**: a duplicated line (like ANM01/004-24 here) inflates that one batch's received quantity without any visual distinction from a legitimate two-row batch split — both look like ordinary grid rows.
- **No dedup constraint** anywhere in the chain (`tblSAP_StockMovementMaster.challan_code`, `tblStockInTransfar.ReqChildId`) means every step of this pipeline is currently vulnerable to the same class of failure recurring for other Chalans, not just `4500008881`.
- **Unreliable "Chalan Date"** display (§13) could mislead staff into thinking a duplicate Chalan is a *different, later* legitimate delivery when investigating discrepancies.

## 20. Test Cases Required

1. Sync the same `challan_code` twice unchanged → confirm `sp_SAP_WhStockInMaster`'s existing guard blocks the second (already true today — verify it stays true after any fix).
2. Sync the same shipment under two *different* `challan_code` strings (as happened here) → after a fix, confirm the second is detected/blocked before or during receive.
3. Sync a Chalan whose `SAP_API_Data` detail rows contain a genuine intentional duplicate line (two legitimate partial deliveries of the same batch) vs. an accidental duplicate — confirm the fix does not incorrectly merge legitimate splits.
4. Run `sp_SAP_StockReceive` for the same `@ChallanNo` concurrently (two overlapping executions) → confirm no duplicate `tblStockInTransfar` rows result (regression test for root cause #2).
5. Receive a Chalan normally (single, clean, unique) end-to-end → confirm `RcvQty` still defaults correctly and `UnRcvQty` recalculation still works (regression, unrelated logic must not change).
6. Verify `tblSAP_StockMovementMaster`/`tblSAP_StockMovementDetail` quantity-sanity check (if implemented) does not false-positive on legitimate large shipments.
