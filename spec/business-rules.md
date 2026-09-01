# Business Rules

Exhaustive catalog of business rules enforced in code (BLL or code-behind), grounded in specific
files and line numbers. This supersedes the earlier "representative sample" version — every
`Library.BLL/**/*.cs` file and every `*_UI/**/*.aspx.cs` code-behind file with validation logic was
scanned. See [`validation-rules.md`](validation-rules.md) for the field-level validation catalog
and [`workflow.md`](workflow.md) for approval-routing rules in more detail.

**Legend:** "blocks" / "enforced" = the code returns/aborts before persistence. "weak enforcement" =
a message is shown but the save proceeds anyway, or the guard can be bypassed. "silent" = the
action is blocked but no message is shown to the user (CSS/focus only).

---

## 0. Verification pass — full re-analysis against live database + source (this revision)

This revision re-verified this document against **direct introspection of the live development
database** (`TOWSIF\MSSQLSERVER2019` / `SalesDisDB_SMC_NEWDB` — the instance the app's active
`web.config` connection string points at) plus a fresh read of every stored-procedure body behind
this codebase's 1,870 procedures, cross-referenced against actual C# call sites, executed as six
parallel module-scoped analyses (SInventory; DoctorModule half A; DoctorModule half B +
DoctorVisit/DoctorMaster/DoctorInfo/Doctor_Monitoring; MasterSetup/Thana/SubDepot; the smaller
transactional modules — DWSP/SAP/PromoAlloc/Transfer/MarketUpload/SettingPanel/UserRole/InternalCls;
and platform/auth/API/all-views/all-functions). Every existing claim in this file that fell inside
one of those six scopes was checked directly against current source, not assumed correct.

**Result: the overwhelming majority of this document's existing claims were confirmed accurate**
(see per-agent [VERIFIED] tables in the source reports) — this file was demonstrably not a "generic"
or stale document before this pass. The additions below are net-new findings and the small number of
genuine conflicts found, organized by the same module numbering as the rest of this file. New rules
use the ID scheme `BR-<MODULE>-NN` and are cross-referenced from `spec/database-spec.md`'s per-module
deep-dive sections, which anchor each rule back to its owning stored procedure.

### 0.1 New rules confirmed by reading stored-procedure bodies directly (not previously documented)

**SInventory:**
- **BR-SI-08 — `sp_UP_LoadingSummary` is the real order-to-cash orchestration hub**, not previously in `workflow.md`'s lifecycle diagram. Branches on `@LoadingSummaryStatus`: `'Rejection'` archives + calls `sp_Delete_ProformaInvoice` (reverses stock); `'Cash'` calls `sp_DeliveryConformationFull` + `sp_PaymentConformationFull` back-to-back (cash sales skip separate DA delivery/payment confirmation steps entirely); any other value just stamps status and still calls the payment-confirm proc. **No shared transaction across this 2-3 proc chain** — a mid-chain failure leaves inconsistent state. Source: `spec/database/procs/sp_UP_LoadingSummary.sql`.
- **BR-SI-02 — `sp_Process_ProformaInvoiceByOrderId`'s hardening is confirmed LIVE, not a staged patch.** Directly queried `OBJECT_DEFINITION()` against the live database on 2026-08-11 — the live procedure body begins with the identical "FIX SCRIPT" changelog header found on disk, confirming the 2026-07-25/2026-08-08 concurrency fixes (row-locked FEFO batch allocation, `BEGIN TRANSACTION`+`TRY/CATCH`+`XACT_ABORT ON`, re-entrancy guard on `tblOrder.IsInvoice`, post-loop consistency cursor) are genuinely deployed and running, not proposed-but-unapplied code sitting in the repo. Same direct verification performed for `sp_Delete_ProformaInvoice` — also confirmed live.
- **BR-SI-17 — `sp_Deletenvoice` is broken and would error if executed**, yet is still called from `InvoiceDAL.cs:1897`/`InvoiceDAL_daaw.cs:1788`. Its live body is literally `delete Invoice` (no `FROM`, no schema-qualified table — no table named exactly `Invoice` exists) with the real logic commented out above it. Whether this call path is ever actually exercised in production could not be confirmed from source alone — flagged as an open question requiring a live exception-log check.
- **BR-SI-18 — market-structure report filters must key off the *deepest selected* level only; `tblOrder`'s hierarchy columns are a point-in-time snapshot** (added 2026-08-19). `tblOrder` stamps `GroupId`/`RegionId`/`AreaId`/`TerritoryId`/`SubTerritoryId`/`MarketId` (plus the parallel `*Code_Ord`/`*Name_Ord` columns) at order-creation time and never back-fills them, while the report cascade dropdowns are built from the current masters (`tblRegion.GroupId` → `tblArea.RegionId` → `tblTerritory.AreaId`). ANDing every level together therefore returns **zero rows** for any node whose ancestors have since been reorganized — confirmed on `NK-142 : Feni-2` (TerritoryId 124), whose 505 orders in FY 2025-26 are all stamped `GroupId=2` (`EW-100`) while the current master places its region under `GroupId=4` (`ER-100`, itself renamed from `SR-100`). Correct behavior: filter on the deepest selected level, resolving Group/Zone/Area to the territories currently under them. Fixed in `SInventory_UI/DeliveryPaymentReport.aspx.cs:247`; **11 sibling report pages still carry the defect** — see [`docs/FullPaymentReport_MarketStructureFilter_Fix.md`](../docs/FullPaymentReport_MarketStructureFilter_Fix.md).
- **BR-SI-11 — `sp_RejectInvoiceDAPaymentCollection` does not actually flip the invoice status it's named for** — the `UPDATE tblInvoice SET DA_PaymentCollection='Rejected'` statement is commented out; the proc only deletes the app-log row. This contradicts `workflow.md`'s existing assumption that all three DA-reject procs (`SalesConfirmStatus`/`PaymentCollection`/`SalesReturn`) share an identical shape — 2 of 3 do, this one doesn't. **[CONFLICT — see §0.2]**.

**Doctor/Field-Force (both halves combined):**
- **Two-to-three parallel, independently-live approval mechanisms exist for Tour Plan / Visit Plan / Prescription / Attendance / Doctor / TADA**, layered on top of the chain-based routing engine documented in `workflow.md` §1. A "legacy bulk approve" proc family (`sp_Approve_DoctorInformation`, `sp_Approve_TADAClaim`, `sp_ApproveTourPlanInformation`, `sp_ApproveVisitPlanInformation`, `sp_ApproveExpenseClaimInformation`, `sp_ApproveMileageClaimInformation`, `sp_ApprovePrescriptionInformation`, `sp_ApproveAttendanceInformation`) does a single bulk `UPDATE ... WHERE Id IN (fnSplit(@Ids,','))`. A live/dead-from-UI audit of all 8 found: **Tour Plan, Visit Plan, Prescription, and Attendance approval are LIVE via this path** (`TourPlannedApprovalList.aspx.cs:98`, `VisitPlannedApprovalList.aspx.cs:101`, `Setup.aspx.cs:72-75`, `AttendanceListApproval.aspx.cs:474`), while **Expense Claim, Mileage Claim, Doctor, and TADA's calls to this path are commented out in the UI** (dead from the UI, though the procs themselves remain callable). Separately, `tbl_DoctorTourPlanMaster` (doctor-visit tour plans) and `tbl_TourPlanMaster` (general/market tour plans) are **two distinct master tables** with two distinct approval mechanics, easily conflated because both display the identical `0=Pending,1=Verified,2=Approved,3=Rejected` status vocabulary. Recommend `workflow.md` explicitly disambiguate these as separate features. Also newly found: `TourPlannedApprovalList.aspx` and `VisitPlannedApprovalList.aspx` are live, reachable, DAL/proc-backed pages **absent from `spec/modules.md`'s page inventory** (only the chain-based `Approval_UI/TourPlanApproval.aspx` is listed there).
- **BR-DRB-10 (CRITICAL, actionable) — confirmed, traced SQL-injection + authorization-bypass path.** `Solution.Web/DoctorVisit_UI/DoctorVisitReport.aspx.cs:21-38` exposes `[WebMethod] GetDoctorVisitList(string param)` / `GetDynamicPivotDoctorWiseDoctorVisitPlan(string param)` — public AJAX endpoints that forward a client-supplied `param` string, **completely unvalidated**, into `DoctorVisitDAL` methods that pass it as the sole filter fragment into stored procedures executing `EXEC(@Query)`/`sp_executesql` dynamically. A parallel, even more severe instance: `Solution.Web/DoctorModule_UI/AttendanceInfoList.aspx.cs:52-59`'s `[WebMethod] Emp_AttendanceInfoList(string param)` skips the page's own safe `param()` builder (which normally injects the caller's MIO/AM/DZSM/NSM row-level hierarchy scope) entirely — an authenticated user of **any role** can call this endpoint directly with a hand-built string to (a) see any employee's attendance regardless of their own hierarchy position, bypassing the module's core row-level-security mechanism, and (b) inject arbitrary SQL, since the underlying procs (`sp_Get_Emp_AttendanceInfoList`/`DayRow`) concatenate the parameter directly into `EXEC(@Query)` with zero server-side reconstruction or sanitization. This is the single most concrete, exploitable finding across the entire re-analysis. Roughly 20 more procs in this cluster share the "concatenate `@param` into dynamic SQL" *shape*, but were confirmed to only receive constrained dropdown values at their current call sites — the architecture is unsafe throughout, but only the two endpoints above were confirmed to accept genuinely free-text/unvalidated input today.
- **Whole-file duplication risk**: `Setup2DAL.cs`/`SetupDAL.cs`/`SetupDAL_daaw.cs` (and `CommonDataLoad.cs`/`_daaw.cs`, `SeedDataDAL.cs`/`_daaw.cs`) are byte-identical copies differing only in which `DataAccessManager` variant they use. A bug found in one copy (e.g. BR-DRB-08 below) should be assumed present, **unverified**, in its sibling(s) — nothing enforces the copies stay in sync.
- **BR-DRB-08 — two independently-confirmed "reports success regardless of actual outcome" bugs** in `Setup2DAL.cs:3713-3950` (`Save_Prescription`/`Save_ExpenseClaim`, also present at the same line numbers in the duplicate `SetupDAL.cs`, unverified in `SetupDAL_daaw.cs`): editing an existing prescription always reports success to the caller regardless of whether the underlying UPDATE actually affected a row (the real result is captured then unconditionally overwritten to `true` two lines later); an expense claim's image-evidence write is wrapped in an empty `catch {}` — a failed write (bad path, disk full, invalid base64) is completely silent, with the claim record itself still saved successfully and no image ever persisted.
- **BR-DRB-09 — the same "hardcoded `isSuccess = true` in a `finally` block regardless of the real delete result" bug independently confirmed in 3 more Doctor-module DAL classes**: `DoctorChamberDal.DeleteDoctorchamber`, `NoticeDal.Delete_NoticeMaster`, `PrescriptionTypeDal.Delete_PrescriptionType` — consistent with the same pattern already flagged for other modules elsewhere in this document (see cross-reference note below), now confirmed as a recurring, not isolated, convention.
- **BR-DRB-03 — a market-deactivation "in-use" guard has a dead branch**: `sp_check_Vali_MarketStructure`'s `@PageName='ExpenseType'` case tests `WHERE dtl.ExpenseTypDetailsId=0` — a literal zero, never the actual `@MasterId` being checked — so this specific branch can never detect a real in-use conflict. The proc otherwise correctly blocks deactivating a Market while any active doctor is tagged to it, and blocks deactivating any hierarchy level with an in-range active campaign/notice/training.
- **BR-DRB-04 — `sp_Save_UserMarketDetail` accumulates rather than replaces** a user's derived market-scope table (`tblUserMarketExecss`) on every re-save, because the `DELETE` that would make the operation idempotent is commented out — editing (not first-saving) a user's market assignment appends duplicate/stale rows rather than replacing them.
- **BR-DRB-05 — reactivating a market unconditionally cascades geography/station-type fields onto every tagged customer**, with no active-status filter and no audit trail (`sp_Update_CustomerInfoForMarketData`, called from `Setup2DAL.SaveMarket`).
- **BR-DRB-06 — `sp_opeingBalanceCreate`'s NULL-date defaulting is broken**: the intended `SET @FromDate='19000101'`/`SET @ToDate='99991231'` defaults are commented out, leaving dangling `IF` statements that never actually default the dates — if either parameter is passed `NULL` (a plausible mistake, since both are optional), the proc silently processes zero rows and still reports success, rather than defaulting to "all dates" as the surrounding comments intend. This is otherwise the single best-hardened proc found in the whole Doctor-module cluster (proper `BEGIN TRAN`/`TRY`/`CATCH`/`XACT_ABORT`, `NOT EXISTS` dedup guards, clean rollback via `THROW`).
- **BR-DRB-07 / BR-DR-* — a new, independent instance of the codebase's hardcoded-employee-ID pattern**: `sp_HigharchyInfoByEmployeeId` short-circuits its normal join for `@EmployeeId=683` at the NSM role level. This is a different ID and a different context (org-chart/dashboard scoping, not approval bypass) from the `EmpInfoId="496"`/role-`"5"` bypass already documented elsewhere in this file — reinforcing that individually-privileged literals baked directly into procs/code are a systemic pattern here, not a one-off.
- **BR-DR-03/BR-DRB — Two more Doctor-module-cluster bugs of the same family**: `sp_Get_DoctorList` is called from `SetupDAL.cs:189` with **zero parameters** against a proc whose sole `@Parm` parameter has no default — likely either dead/unreachable code or relies on undocumented framework behavior; the correctly-parameterized live path is `MasterSetup_DAL/DoctorDAL.cs:412-420`. `sp_Save_TadaClaimMaster` hardcodes new TADA claims into `ApprovalStatus='2'` (Accepted) at creation time — apparently bypassing, or operating independently of, the chain-based `DAApprovalList` workflow `workflow.md` documents for the same claim type; the relationship between the two was not resolved in this pass.

**MasterSetup / Thana / SubDepot:**
- **BR-MS-03 — `sp_Update_CustomerMaster` derives a customer's geography from the selected Market twice, and the second (actually-applied) derivation uses a mismatched join key**: the first, correct derivation (`District.DivisionId = Division.DivisionId`) is computed but discarded; the second block immediately before the final `UPDATE` instead joins `District.DistrictId = Division.DivisionId` — comparing values from two different ID spaces. Since the second block's result is what's actually written, **`tblCustMaster.DivisionId` is very likely wrong/NULL on every edited customer** unless a District row happens to share a numeric ID with a Division row. Static-analysis finding only, not confirmed by executing the proc against live data.
- **BR-MS-04 — `sp_ApproveCustomerInformation` will likely raise a SQL error if actually invoked**, because it tries `CAST(CustomerCode AS INT)` against codes that `sp_Save_CustomerMaster` generates with a literal `'C'` prefix (e.g. `C1042`). Whether this code path is genuinely dead (real approvals go through the `sp_webapi_SaveCustomerAppLog` chain instead, per `workflow.md`) or actually errors when hit is an open question this pass could not resolve without a DB trace or reading `CustomerApproveList.aspx.cs`.
- **BR-MS-05 — the Doctor leg of the Customer/Doctor territory-transfer approval is dead code**: `sp_Update_Customer_Doctor_TransferApprove`'s entire `else` (Doctor) branch — the part that would actually apply the market/territory change to `tblDoctorMaster` on approval — is commented out. A doctor-transfer request is logged but approving it has no effect; the identical Customer-side branch works correctly.
- **BR-MS-01 — confirmed, extended**: the insert-side duplicate-name check gap already documented for other master-data entities also applies to **Customer Master itself and Delivery Agent (DA)** — neither `sp_Save_CustomerMaster` nor `sp_Save_DAInfo` has a duplicate-check procedure at all, in either direction.
- **Confirmed critical, pervasive SQL injection across the entire `SubDepot_DAL` folder** (not just one file): `Sub_InvoiceDAL.cs` (~515 raw-SQL concatenation sites), `SubDepoAdjustDAL.cs`, `SubDepotChalanDAL.cs`, `SubDepotChalanReturnDAL.cs`, `SubDepotDAL.cs` (~96-94 sites each) — every INSERT/UPDATE/SELECT in this module is built by string-concatenating C# field values with **no parameterization and no quote-escaping anywhere**, covering both SubDepot master data and its invoicing/stock-transfer/adjustment-voucher transactions. This is architecturally distinct from (and more severe than) the rest of the codebase's dynamic-SQL pattern, which at least routes through a generic `EXEC(@Query)` dispatcher proc — SubDepot_DAL doesn't even use that; it builds ad-hoc SQL text directly against `ClsCommonInternalDAL`.

**Transactional modules (DWSP/SAP/PromoAlloc/Transfer/UserRole/InternalCls):**
- **`Library.DAL/InternalCls/ClsCommonInternalDAL.cs` — confirmed architecture: a shared, generic dynamic-SQL dispatcher, not a stored-procedure boundary.** Its `DataContainerDataTable`/`SaveDataByInsertCommand`/`UpdateDataByUpdateCommand`/`DeleteDataByDeleteCommand` methods route a caller-built SQL string through Dapper as a `CommandType.StoredProcedure` call to `ExecuteAllSqlQueryByStoreProcedure` — whose entire live body is `EXEC (@Query)`. This confirms, with the proc source directly read, that every "raw string concatenation" finding anywhere in this codebase funnels through one real dynamic-SQL execution point. **Exploitable, not just theoretical**: `PromoGroupDAL.SavePromoGroup`/`UpdatePromoGroup` concatenates a free-text promo-group name from `PromoGroup.aspx` directly into an INSERT/UPDATE string routed through this dispatcher; `GroupWisePromoQtyDAL` and `PromoMITagDAL` do the same for several fields. Notably, `PromoMITagDAL.SaveMIOTagMaster` (parameterized, safe) sits a few lines above `SaveMIOTagDetail` (concatenated, unsafe) **in the same class** — proof this is an inconsistent coding habit, not a uniform legacy pattern being phased out.
- **The SAP integration's `MakeRESTRequest` stored procedure makes a real, live outbound HTTPS call**, not a dead/no-op as could be inferred from the C# side alone (`SAP_IntrigationPointDAL.MakeRESTRequestWithUpdateChallan` merely calls this proc, no `HttpClient` in C#). The proc itself uses `sp_OACreate`/`sp_OAMethod` (SQL Server OLE Automation) to POST to `https://smcsap.smc-bd.org:42223/RESTAdapter/eph_sto` with **hardcoded plaintext credentials embedded directly in the SQL** (`smc_epharma` / `Eph@rma2023#`) — the same credential pair already flagged elsewhere in this codebase as present in a *dead* C# path (`BankDepositSAP.aspx.cs`, different endpoint `eph_mio`); this instance is live, called from `Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx.cs:148` and `TransferReceiveProductByChalanByDC.aspx.cs:118` (both wrapped in an empty `catch{}` that swallows any failure). No `TRY/CATCH` exists inside the proc itself either — if OLE Automation is disabled on the SQL Server instance, the HTTP call fails completely silently while the calling code still marks the operation successful.
- **`DataAccessManager.ExecuteNonQueryVoid` never checks rows-affected** — every `SaveData`/`UpdateData`/`DeleteData` call system-wide reports success purely on "no exception thrown." Combined with a confirmed dead branch in `sp_Update_MarketStructure_Transfer` (which has `IF` branches for Market/Sub-Territory/Territory but **none for Area or Zone**, despite `Area_Transfer.aspx`/`Zone_Transfer.aspx` calling it with exactly those `@Type` values), this produces a live, user-facing bug: **the Area Transfer and Zone Transfer screens report success while persisting nothing.**
- **Permission and approval-routing tables are updated via non-atomic delete-then-reinsert**, with no transaction wrapping either sequence: `MenuDAL.SaveMenus` (delete all `tblMenuRole` rows for a role, then loop-reinsert) and `sp_Save_ApprovalMapMaster` (wipe all `tblApprovalMapDetail` children, expect the caller to reinsert every step). A mid-loop exception after the delete has already committed leaves a role under-permissioned or an approval chain incomplete, with no rollback.
- **`GroupWisePromoQtyEntry.aspx.cs`'s central-warehouse stock-cap validation has a loop-exit bug**: the accumulation loop `break`s immediately after processing the *first* checked employee row, so the "assigned stock exceeds available stock" check never actually sums more than one row even when multiple employees are allocated — it is possible to over-allocate promotional stock across employees without the intended guard catching it.

**Platform / Auth / Menu / API:**
- **Menu/permission model is a three-generation, partially-overlapping system**, not a single mechanism: a legacy per-`UserId` system (`tblMainMenu`/`tblMenuDistribution`, built by a C# loop in `PanalClsDAL`), a parallel SQL-function version of the same legacy system (`dbo.MainMenu(@UserId)`, no confirmed live caller), and the current per-`RoleId` system with Add/View/Edit/Delete flags (`tblMainMenuNew`/`tblMenuRole`, built by `dbo.MainMenu2(@UserId,@UserRoleID)`). **All three independently hardcode the same superadmin bypass** (`UserId==1` in the C# master page and in both SQL functions). The granular Add/View/Edit/Delete flags in `tblMenuRole` are largely decorative — `MainMenu2` only checks whether a `(SL, RoleId)` row exists, never the flag values themselves; only one page in the whole codebase (`UserRecords.aspx.cs`) was confirmed to actually read and apply those flags to control button/column visibility. `MainMenu2` additionally has an internal inconsistency: its two upper nesting levels correctly read the new `tblMenuRole` table, but its deepest level falls back to the stale `tblMenuDistribution` table instead.
- **Confirmed: per-page authorization beyond "a session exists" is opt-in and applied to only a minority of the codebase's ~700 pages.** The `UserPersmissionValidation()` pattern (looks up `sp_GET_MainPermissionByUserRoleandPageUrl` for the current page URL + role, redirects to Dashboard if no row found or on any exception) is genuinely present and correctly wired on the pages already documented in this file, but role `"2"` (Admin) bypasses it unconditionally, and most pages across the system simply never call it — meaning they are reachable by any authenticated user of any role via direct URL navigation, with menu-hiding as the only practical (non-enforced) deterrent.
- **`SInventoryWebService.cs` (the `.asmx` endpoint mounted identically under three different UI folders) has no authorization beyond an existing session**, and 8 of its 20 autocomplete methods build SQL by string concatenation of session-derived values (`ComUnitId`, `ProductId`, `UserType`) rather than parameters — session values aren't directly attacker-supplied today, but this remains a defense-in-depth gap.
- **`HandlerDocCV.ashx` (file-upload handler) has no authentication check at all** — any unauthenticated request can POST a file into `~/UploadFile/`. Server-generated filenames prevent path traversal, but there is no content-type whitelist and no size cap.
- **Unresolved architectural question, not a confirmed finding**: `CLAUDE.md` states `SInventoryWebService.cs` is what the companion Flutter mobile app calls; this pass's direct read of the class (20 methods, all shaped as jQuery-autocomplete typeahead queries — plain string arrays, no JSON envelope, no pagination/versioning) plus a cross-reference of the `sp_Webapi_*`/`sp_SalesAPI_FieldForce*` stored-procedure family (333+ procs, fed in part by a dedicated `View_FieldForce*`/`View_Webapi_*` view family this pass fully documented) makes it far more likely those procs are the mobile app's actual backing layer — but **no REST/API-controller code exposing that proc family over HTTP was found anywhere in this repository**, so the mobile app's real integration point remains genuinely unlocated, not just undocumented.
- **58 database views and 43 functions were read and documented in full** (see `spec/database-spec.md` for the complete catalog). Notable findings: `View_BusinessSummary` has a hardcoded `BETWEEN '5/1/2018' AND '5/30/2018'` literal baked into its definition — effectively frozen/dead since 2018; 3 near-duplicate `GetBookQuantityByDCStore*` function variants and 6 near-duplicate `GetCampaignCustomer*` variants coexist with mostly zero confirmed callers (one, `GetCampaignCustomer`, is the live version with 9 confirmed callers); `fn_GetTerritoryInfo_Optimized` silently drops a fallback branch present in the original `fn_GetTerritoryInfo` it appears intended to replace, and neither has a confirmed caller.

### 0.2 Conflicts with pre-existing content in this document

| Existing claim | Verdict |
|---|---|
| Implicit assumption in `workflow.md` §4.3 that all three DA-reject procedures (`sp_RejectInvoiceDASalesConfirmStatus`/`PaymentCollection`/`SalesReturn`) share an identical shape | **[CONFLICT]** — `sp_RejectInvoiceDAPaymentCollection`'s actual status-flip statement is commented out; only 2 of 3 siblings match. See BR-SI-11 above. |
| `spec/integrations.md`'s prior characterization of `MakeRESTRequestWithUpdateChallan()`/`MakeRESTRequest` as "just a stored-procedure call, no actual outbound HTTP call" | **[CONFLICT / INCOMPLETE]** — true narrowly at the C# level, but the stored procedure itself performs a genuine live HTTPS POST via OLE Automation with hardcoded credentials; see the SAP finding above and the updated `spec/integrations.md`. |
| `CLAUDE.md`'s statement that the Flutter mobile app talks to the `.asmx`/`.ashx` endpoints in this repo | **[UNRESOLVED, not simply wrong]** — see the platform/auth finding above; the more probable mobile-facing proc family's HTTP exposure could not be located in this repository at all. |

All other claims checked by the six parallel analyses against this document, `workflow.md`, `validation-rules.md`, and `modules.md` were confirmed **[VERIFIED]** — see each analysis's own verification table (preserved in this project's session history) for the full line-by-line record. No claim was found to be simply fabricated or unrelated to the actual codebase.

---

## 0.2 Confirmed and fixed: `DataAccessManager_daaw.GetDataSet` silently dropped every second result set (2026-08-20)

Found while driving the new Order Payment Approval screens in a real browser, not by static reading
— the page reported "not authorized" when the underlying procedure had in fact returned data.

`Library.DAL/DataManager/DataAccessManager_daaw.cs`'s multi-result-set reader was:

```csharp
do {
    var dt = new DataTable();
    dt.Load(reader);
    ds.Tables.Add(dt);
} while (!reader.IsClosed && reader.NextResult());
```

`DataTable.Load(IDataReader)` consumes one result set **and advances the reader to the next one by
itself**. The extra `NextResult()` therefore skipped one set per iteration: a procedure returning 3
result sets yielded tables `[1st, 3rd]`, and one returning 2 yielded only the 1st. Reproduced
directly against the live database before changing anything.

**Pre-existing impact beyond the new feature:** `GetDataSet` has only three callers.
`Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:244` reads `dataSet.Tables[1]` for the claim
**details** — that table was never populated, so the details have always come back empty on that
page. `DAExpenseClaimApprovalList.aspx.cs` reads only `Tables[0]` and was unaffected.

Fixed at the shared method (one guard for all callers, rather than a workaround per caller), which
repairs the DA Expense Claim details as a side effect:

```csharp
while (!reader.IsClosed) {
    var dt = new DataTable();
    dt.Load(reader);
    if (dt.Columns.Count == 0) break;   // reader exhausted
    ds.Tables.Add(dt);
}
```

The `dt.Columns.Count == 0` break is load-bearing: `DataTable.Load` does not necessarily close the
reader after the final result set, so `!reader.IsClosed` alone would spin.

---

## 1. SInventory module (SInventory_UI, SInventory_BLL — largest module, 419 files)

### Warehouse Stock In
- `Solution.Web/SInventory_UI/WarehouseStockIn.aspx.cs:486` — Manufacturer required: `"Please Select Manufacturer !!!"`
- `Solution.Web/SInventory_UI/WarehouseStockIn.aspx.cs:493` — Supplier required: `"Please Select Supplier !!!"`
- `Solution.Web/SInventory_UI/WarehouseStockInEdit.aspx.cs:396` — Manufacturer required on edit.

### Warehouse Stock In Approval
- `Solution.Web/SInventory_UI/WarehouseStockInApproval.aspx.cs:132` — At least one row selected: `"Please select at least one row!!!"`
- `Solution.Web/SInventory_UI/WarehouseStockInApproval.aspx.cs:145` — Operation must be selected: `"Please select an operation!!"`
- `Solution.Web/SInventory_UI/WarehouseStockInApproval.aspx.cs:72,188,217` — `Session["UserId"]`/`Session["LoginName"]` stamp the approving user.

### Warehouse Stock Out
- `Solution.Web/SInventory_UI/WarehouseStockOut.aspx.cs:846-849` — Out qty ≤ current stock qty, enforced by resetting field to `"0"`: `"Cannot be greater than Current Stock Qty !!"`
- `Solution.Web/SInventory_UI/WarehouseStockOut.aspx.cs:460` — Manufacturer required.

### Warehouse Stock Freeze / Release (Condition & Damage Stock)
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:84` — Stock condition required.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:90,254` — Return qty required.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:255-258` — Return qty ≤ current stock, enforced (textbox reset).
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:264` — Return qty > 0.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:273` — Return qty must be numeric.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:314` — Warehouse required.
- `Solution.Web/SInventory_UI/WhFreezeStockRelease.aspx.cs:145,238,245,254,294` — Mirrored release-flow rules.
- **Weak/disabled enforcement**: `Library.BLL/SInventory_BLL/StockConditionFreezeBLL.cs:41-52` (`SaveforWH`) and `:60-72` (`SaveforDC`) — the duplicate-existence check and its `"Company Name already exist"` branch are commented out; save is unconditional.

### Stock Transfer (Requisition / DC-to-DC / Depot-to-Warehouse)
- `Solution.Web/SInventory_UI/StockTransferOrder.aspx.cs:452,459,466` — Manufacturer / Warehouse / Distribution Center required.
- `Solution.Web/SInventory_UI/StockTransferOrder.aspx.cs:820` — At least one product required.
- `Solution.Web/SInventory_UI/DepoToWHTransfer.aspx.cs:175,631` — Product & sales center required.
- `Solution.Web/SInventory_UI/DepoToWHTransfer.aspx.cs:369,374,379` — Manufacturer/from-unit/to-unit required.
- `Solution.Web/SInventory_UI/NewStockTransferDcToDc.aspx.cs:139,144,149` — Same manufacturer/from-unit/to-unit checks.
- `Solution.Web/SInventory_UI/OrderRequisitionCreation.aspx.cs:447,454,461,473,485,497` — Manufacturer/Warehouse/DC + per-line Req Qty/product required.
- `Solution.Web/SInventory_UI/IssueRequisitionProducts.aspx.cs:27` — Duplicate-challan guard: `"Challan Already Generated !!"`

### Stock Out Approval (DC / Sub-Depot)
- `Solution.Web/SInventory_UI/DcStockOutApproval.aspx.cs:129,143` — Row/operation selection required.
- `Solution.Web/SInventory_UI/DcStockOutApproval.aspx.cs:71,189,215` — `Session["UserId"]`/`Session["LoginName"]` gate approver.
- `Solution.Web/SInventory_UI/SubDepotStockOutApproval.aspx.cs:145,159,205,230,68` — Identical pattern.

### Sample / Warehouse Sample Stock Conversion
- `Solution.Web/SInventory_UI/SampleTypeConvertion.aspx.cs:181-189` — Stock-out qty ≤ main stock qty, enforced (clears input): `"Stock Out Qty. can't be more then Stock Quantity"`
- `Solution.Web/SInventory_UI/SampleTypeConvertion.aspx.cs:264-286` — Sales center/action/date/product required; ≥1 product line.
- `Solution.Web/SInventory_UI/SampleStockforWarehouse.aspx.cs:183-187` — Same stock-out ≤ stock guard.
- `Solution.Web/SInventory_UI/SampleStockforWarehouse.aspx.cs:260-282` — DC/action/date/product required.

### Invoice Creation (by Order)
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:221,226,232,251` — Order Number/Date, Payment Type, DA Name required.
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:237` — `"Invalid Receivable Amount!!"`
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:1193` — Duplicate order guard: `"Order Information already Exists !!"`
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:2247,2270` — Duplicate product row: `"Product Already Inserted!!!"`
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:2482` — `InvalidOperationException` hard invariant for unique InvoiceId/InvoiceDetailId sequencing.
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:134-178` (`AdjustmentAmount`) — **Fixed 2026-08-15**: the customer's available-credit adjustment (`crAmountTextBox`) is now allocated sequentially in grid row order, each row absorbing `Math.Min(that row's own pre-adjustment Net Amount, remaining adjustment)` — a row's `NetAmount` can never go negative, and any adjustment left over after the last row simply goes unapplied. Previously the full adjustment amount was divided evenly across every row (`amount / rowCount`) regardless of each row's own value, which could drive a smaller row's `NetAmount` negative.
- `Solution.Web/SInventory_UI/InvoiceGenerationRestricted.aspx.cs:436-439` — **Invoice value approval-limit gate**: `grandTotal > 50000 && !chbOverrideLimit.Checked` blocks save unless an override checkbox is checked: `"Invoice value exceeds BDT 50,000. Authorized override required."` (This is a UI-level parallel to the DB-level `CustomerInvoiceLimitService` gate in §3 — the two are not obviously wired together; verify before assuming a single source of truth for invoice limits.)
- `Solution.Web/SInventory_UI/InvoiceGenerationRestricted.aspx.cs:339` — Duplicate product row guard.
- `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx.cs` (manual order → invoice, via
  `OrderInfoBLL_daaw.GenerateInvoiceByOrderId` → `sp_Process_ProformaInvoiceByOrderId`) — **Fixed
  2026-08-08**: insufficient stock for a selected order (either mid-allocation, or a product with no
  stock row at all in the depot) used to still commit a partial/empty invoice and always show
  "Invoice Generated Successfully!". The proc now reports real success/failure per order via a
  `@Success` OUTPUT parameter (see `spec/workflow.md` §4.2), and the page now shows a distinct
  message when some/all selected orders fail the stock check vs. all succeeding.

### Payment Partial / Partial Dues
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:47,52,69,82` — Order Number/Date, valid data, Reason required.
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:2083` — Qty ≤ Total Quantity: `"Cannot be greater then Total Quantity"`
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:2116` — Qty ≤ Sales Confirmation Quantity.
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:969-978` — Pre-flight duplicate-invoice check, **plus** a row-locked, transactional re-check inside the DB transaction to defeat race conditions (rolls back + `"Already Exist!"` on concurrent submit) — the one properly hardened duplicate guard found in this pass.

### Customer Payment
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:201,215,226,254,259` — Invoice, Pay Amount, Collection By, Payment Type, DA Name required.
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:269-435` (`saveButton_Click`) — **Hardened (previously weak, fixed 2026-08-06)**: each selected invoice row now saves as its own independent unit with its own `save`/detail-list state (previously a single `bool save` and a single, ever-growing `List<CustPaymentDetail>` were shared/reused across every selected row in the loop, so (a) the post-loop `if(save)` reflected only the **last** row's outcome — a real save on row 1 could be masked by a duplicate-skip on row 2 and reported as total failure, or vice versa — and (b) every `SaveCustPayment` call re-sent all prior rows' details, redundantly. Now tracked via `anySaved`/`anyFailed`, and the failure message distinguishes "all failed" from "some skipped as already-paid-today".
  - `Library.BLL/SInventory_BLL/CustPaymentBLL.cs:27-131` / `Library.DAL/SInventory_DAL/CustPaymentDAL.cs` (`SaveCustPayment`, `SaveCustDetail`) — previously always `return true` regardless of whether the underlying insert actually happened (DAL bool result was discarded); now propagates the real per-row result. `CustPayId`/`CustPayDetailId` generation was also moved off the unlocked `ClsPrimaryKeyFind` `MAX()+1` pattern into a `WITH (UPDLOCK, HOLDLOCK)`-guarded transaction inside `CustPaymentDAL.cs` itself (see §8/data-model note on `ClsPrimaryKeyFind` in `SKILL.md`), closing a concurrent-save collision risk — this is now, alongside `PaymentPartial.aspx.cs`, a second reference implementation for hardening a save path in this codebase.
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:467-526` (`PayAmountChange`) — **Fixed (2026-08-06)**: the TP/VAT split for a partial payment (previously) fell through to `TPAmount=0, VATAmount=0` whenever the invoice's remaining VAT due was `<= 0` (VAT already fully covered or overpaid) instead of routing the full amount to TP — silently saving a wrong TP/VAT split. Also, when `sp_GET_PaymentInvSPTPVATAmt` returned zero rows for the current invoice/amount, the TP/VAT hidden fields were left holding a stale value from a previous edit or the initial grid bind instead of being reset; both now handled explicitly.
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:545` — `(mainamount+prevamount) > delamount` blocked (textbox reset to `"0"`): `"Cannot Be Greater then Invoice Quantity "`
- **Weak/disabled enforcement (separate, untouched class)**: `Library.BLL/SInventory_BLL/dadtlsCustPaymentBLL.cs:88-102` (`SaveCustPayment`) — a parallel/duplicate implementation used by other pages, **not** `CustomerPayment.aspx.cs`'s own `CustPaymentBLL.cs` above — duplicate-existence check is an empty block; method always `return true` with no error surfaced. Duplicate payments can silently fail to save with no user feedback. Not part of the 2026-08-06 fix; still open — contrast with the DA delivery-invoice duplicate-submit race in the same module, fixed 2026-08-11 (§1 above, "DA Delivery Invoice Submission").
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:282-297` (`saveButton_Click`, row-control
  lookup) — **Fixed 2026-08-09**: row controls (`chkSelect`, `chkAdjust`, `payAmountTextBox`,
  hidden fields, `ddlCollectionBy`, etc.) were looked up via a hardcoded `.Cells[0]`/`.Cells[7]`
  index into `orderGridView.Rows[i]`, which breaks silently (wrong cell → `FindControl` returns
  `null` → `NullReferenceException` or wrong control) if the grid's column layout ever changes. Now
  looked up directly on the row (`Rows[i].FindControl(...)`, no cell index), with a null-check that
  skips the row instead of throwing if a control genuinely isn't found.

### Customer Payment (DA Collection)
- `Solution.Web/SInventory_UI/CustomerPayment_DA.aspx.cs:839-863` (`GenerateParam`) — **Fixed
  (2026-08-16)**: the Route dropdown (`rootDropDownList`) filter was commented out in the
  WHERE-clause builder used by `LoadGridView()`'s search (`ord.DistributionRouteId=...`), so
  selecting a Route on the page had no effect on the invoice grid — only Sales Center, Territory,
  and DA Name were actually applied, even though selecting a Route still repopulated the
  Territory/DA Name dropdowns via `rootDropDownList_SelectedIndexChanged`. Re-enabled. Note the
  sibling `Parm()` method (`:730-754`, used for the post-save money-receipt print) already included
  the same `DistributionRouteId` filter and was unaffected — only the search-grid path was broken.

### DA Delivery Invoice Submission (Delivery Confirmation)
- `Solution.Web/SInventory_UI/dadtlsDelivaryInvoiceDetailsCreation_DA.aspx.cs:1211-1327`
  (`saveButton_Click`) — **Concurrency race fixed (2026-08-11)**: this is the DA (delivery
  associate) delivery-invoice submit flow — invoice master + invoice detail + DC stock
  deduction + DIC approval-status update, all inside one transaction. The duplicate-submission
  recheck (`GetDelivaryInvoiceNoCheckById` against `tblInvoice.DelivaryInvoiceNo`, re-run inside
  the transaction) is guarded by a SQL Server application lock
  (`sp_getapplock`/`sp_releaseapplock`, resource `DaDeliveryInvoiceSubmit_Global`,
  `AcquireDaDeliveryInvoiceSubmitLock`/`ReleaseDaDeliveryInvoiceSubmitLock` at `:1172-1209`).
  **Confirmed root cause**: the lock used to be released right after the recheck passed, before
  `transaction.Commit()` — a concurrent submit for the same invoice could acquire the lock during
  that window, run its own recheck against the not-yet-committed (still invisible) first
  transaction, pass it, and re-apply the same additive `StockQty = StockQty + qty` stock-return a
  second time. The fix widens the lock's scope to span the entire commit: it is now released only
  **after** `transaction.Commit()` succeeds (`:1285`, success path) or after `transaction.Rollback()`
  completes (`:1256-1264` duplicate-found path; `:1294-1304` exception path) — never before. This
  is now, alongside `PaymentPartial.aspx.cs:969-978` and `CustomerPayment.aspx.cs`'s
  `CustPaymentDAL.cs` (§ above), a third reference implementation for hardening a save path in
  this codebase, and is the pattern to copy for any other "check-then-write" duplicate guard found
  elsewhere in this document — contrast with the still-open, **unfixed** weak-enforcement
  duplicate/race gaps documented for `SubDeportStockFreez.aspx.cs` (§4 below, `:271-274` etc. —
  the guard is a sibling `if`, not a lock) and `dadtlsCustPaymentBLL.cs:88-102` (§ above — the
  duplicate check is an empty block entirely). The same class of unsafe "check, then insert" bug
  (no lock, no unique constraint) was independently found, but **not fixed**, in the
  SAP stock-receive pipeline's `sp_SAP_StockInTransfer` — see the new SInventory finding below.

### Stock Receive by Chalan (SAP → Requisition sync) — three confirmed findings (2026-08-11), fixes scripted but not applied
Investigated and written up in full at
[`docs/ReceiveQty_RootCause_Analysis.md`](../docs/ReceiveQty_RootCause_Analysis.md); **not fixed**
in that pass (investigation only, by explicit instruction) — flagged here as open findings, not
resolved ones. Affected page:
`Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx(.cs)` (Stock Receive against a
Chalan/DC), fed by the SAP-integration pipeline (`SAP_Integration/SAP_StockReceive.aspx` →
`SAP_IntrigationPointDAL.SaveStockReceive` → `sp_SAP_StockReceive`, which orchestrates
`sp_SAP_WhStockInMaster` → `sp_SAP_WhStockInDetails` → `sp_SAP_STOMaster` → `sp_SAP_STODetails` →
`sp_SAP_StockInTransfer`).
- **No duplicate-shipment detection anywhere in the app (CRITICAL, weak/absent enforcement)**: the
  same physical SAP shipment can be synced into `SAP_API_Data.tblSAP_StockMovementMaster` twice
  under two different `challan_code` strings (confirmed live example: `45000088811`/matched in-app
  as `4500008881`, and `45000088812` — same 8 products, same batches, same quantities, posted 10
  days apart). `sp_SAP_WhStockInMaster`'s only guard is a literal-string `challan_code NOT IN
  (...)` check — it blocks re-processing the *identical* string a second time but has no concept
  of "this is probably the same shipment as a Chalan already processed under a different string."
  Each independently-matched shipment becomes its own fully-valid-looking `tblRequisition` row, so
  a clerk can receive the same goods twice on `ReceiveProductByChalanByDC.aspx` with no warning —
  full quantities, `UnRcvQty=0`, nothing in the UI hints at the duplication. See
  `docs/ReceiveQty_RootCause_Analysis.md` §8-10, §16 (root cause #1, CONFIRMED), §19.
- **`sp_SAP_StockInTransfer`'s duplicate-insert guard is an unsafe check-then-insert (HIGH, weak
  enforcement)**: its guard (`WHERE RD.ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM
  tblStockInTransfar WHERE ReqChildId IS NOT NULL)`) has no application lock, no
  transaction-scoped guard, and no uniqueness constraint on `tblStockInTransfar(ReqChildId)`
  backing it up — safe only if the proc never runs twice concurrently/overlapping for the same
  input. Confirmed live consequence: within Requisition `ReqId=6295`, product/batch `ANM01`/`004-24`
  has 4 `tblStockInTransfar` rows instead of 2 (`StockInTransfarId` 52486-52489, two exact-duplicate
  pairs), even though the upstream `tblRequsitionChild` table has only one legitimate row per
  `ReqChildId`. This is the same class of check-then-insert-without-a-lock bug that caused the
  DA delivery-invoice double-stock-return race above (now fixed there) — an unfixed sibling
  instance of the same pattern. See `docs/ReceiveQty_RootCause_Analysis.md` §14-16 (root cause #2,
  CONFIRMED as to the duplicate rows/consequence; the exact triggering mechanism is unconfirmed —
  no execution/audit logs were available).
- **`sp_SAP_StockInTransfer`'s `ProductCode`+`BatchNo` join mis-assigns quantities (HIGH, CONFIRMED
  — "Problem 3")**: the CTE that pairs `tblWHStockInDetail` rows with `tblRequsitionChild` rows
  joined on `ProductCode` + `BatchNo` only. When one SAP challan carries **more than one detail line
  for the same product+batch**, that join is a cross product and the `ROW_NUMBER()` tie-break picks
  an arbitrary partner, so a `ReqChildId` can be stamped with a sibling line's quantity — either
  swapped between the two lines (net zero, per-batch wrong) or the same value duplicated onto both
  (net over-receipt into `tblDCStore`). Confirmed live: challan `4500039476`, product `MNS07` batch
  `004/26` — SAP posted `2400 + 1680 = 4080`, `tblDCStore` received `2400 + 2400 = 4800`, i.e. 720
  units of phantom stock at Kushtia DC. `tblRequsitionChild.ReqQty` is **not** affected
  (`sp_SAP_STODetails` writes it 1:1 from a cursor over `tblWHStockInDetail`, one row at a time), so
  it is the trustworthy value to detect and repair from. See
  [`docs/ReceiveQty_Permanent_Fix_Plan.md`](../docs/ReceiveQty_Permanent_Fix_Plan.md) §3, §8.
- **Fix artefacts (written, reviewed, NOT applied to any database by any build step)** — three
  scripts at the repo root, in the order they are meant to be run:
  - `deploy_receiveqty_fix_minimal.sql` — Problem 3 only. Adds nullable
    `tblRequsitionChild.WHStockInDetailID` (the real 1:1 key), has `sp_SAP_STODetails` populate it,
    and has `sp_SAP_StockInTransfer` prefer it in the join with a fallback to the legacy
    `ProductCode`+`BatchNo` match for pre-fix rows — so nothing already in flight changes behaviour.
    The column is deliberately **not back-filled**: for already-ambiguous historical rows the correct
    pairing cannot be reconstructed after the fact (Fix Plan §10).
  - `deploy_receiveqty_fix.sql` — the full set: the above plus Problem 1's per-`@ReqId`
    `sp_getapplock`/`BEGIN TRAN` hardening of `sp_SAP_StockInTransfer`, and Problem 2's
    duplicate-shipment fingerprint check in `sp_SAP_WhStockInMaster` (logged to a new
    `tblSAP_SuspectedDuplicateShipment` table). The Problem 2 check **blocks** challans it suspects
    are re-posts, which can hold up a legitimate delivery — a real behaviour change that needs ops
    sign-off, which is why the minimal script exists as the low-risk alternative.
  - `fix_stockintransfar_qty_mismatch.sql` — repairs rows already written wrong (the deploy scripts
    only stop *new* corruption). Report-only by default (`@Apply = 0`); the write path additionally
    demands one specific `@ChallanNo`. Detection rule is `tblStockInTransfar.Quantity <>
    tblRequsitionChild.ReqQty` **scoped to `tblRequisition.EntryBy = 'Auto Posting'`** — for manual
    `CLN-*` requisitions `ReqQty` is the quantity *requested* and `Quantity` the quantity *issued*, so
    a difference there is normal business data, not this bug. On the dev copy the unscoped rule
    matched 4,864 rows across 1,635 requisitions but the SAP-posted subset was only 82 rows / 31
    requisitions — do not widen that filter.

- See also `spec/workflow.md` §3.4 for the full request→sync→receive sequencing this feeds into.

### Customer Master Entry / Edit
- `Solution.Web/SInventory_UI/CustMasterEntry.aspx.cs:102-194` — Long required-field chain (Name, Address, Mobile, Representative, Region, DC, FE, Area, MIO, Market, Category, Code, Address2, Contact No, City, Contact Person, etc).
- `Solution.Web/SInventory_UI/CustMasterEdit.aspx.cs:55-146` — Same chain for edit, but **Payment Type/Region checks are commented out** (`:76,81`) — weaker than the Entry form.

### Sales Return
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:193,199,213,220` — Order Number/Date, Customer, MIO Name required.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:243,254` — Expiry Date and Batch No required per line.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:675,710` — Qty selection required.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:1200` — Mandatory-field check.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:2273,2280` — Stock-existence and duplicate-product-row checks.
- **Dead validation**: `SalesReturn.aspx.cs:1195` — the duplicate-order guard (present in InvoiceCreation) is commented out here, so Sales Return has no equivalent duplicate-order protection.

### DA Expense Claim
- `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:191,212,226` — Sales Center, valid From/To dates required.
- `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:236` — `"From Date cannot be greater than To Date!"`
- `Solution.Web/SInventory_UI/DAExpenseClaimApprovalList.aspx.cs:68,75` — Row/ID validity.
- `Solution.Web/SInventory_UI/DAExpenseClaimApprovalList.aspx.cs:88` — Approval-state race guard: `"This DA expense claim was not updated. It may already be approved or disapproved."`

### DA Claim (DIC Approval)
- `Solution.Web/SInventory_UI/DAClaim_DICApprovalList.aspx.cs:89,96` — Invalid row/claim ID checks.
- `Solution.Web/SInventory_UI/DAClaim_DICApprovalList.aspx.cs:109` — Same approval-state race guard.
- `Solution.Web/SInventory_UI/DAClaim_DICApprovalList.aspx.cs:152,163` — Sales Center/Entry Date required.

### Stock Batch Update
- `Solution.Web/SInventory_UI/StockBatchUpdate.aspx.cs:130,136,142,150` — Batch No/MFG/EXP required per row; ≥1 row checked.

### Deposit Slip / Report
- `Solution.Web/SInventory_UI/DepositSlipReport.aspx.cs:72,77,346,372` — Date-format and date-range required before report.

### Master Data Duplicate-Name Checks (`Has<Field>Name` pattern — repeated across SInventory_BLL)
Each blocks save on name collision (`if (dal.HasXName(name)) return "X already exist"`):
- `Library.BLL/SInventory_BLL/AreaBLL.cs:31` — `"Area Name already exist"`
- `Library.BLL/SInventory_BLL/CustomerCategoryBLL.cs:30` — `"CustomerCategory Name already exist"`
- `Library.BLL/SInventory_BLL/DepartmentBLL.cs:30` — `"Department Name already exist"`
- `Library.BLL/SInventory_BLL/DistrictBLL.cs:31` — `"DistrictInfo Name already exist"`
- `Library.BLL/SInventory_BLL/ManufacturerBLL.cs:31` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/MarketInfoBLL.cs:31` — `"Company Name already exist"`
- `Library.BLL/SInventory_BLL/MIAInformationBLL.cs:30` — `"Employee Name already exist"`
- `Library.BLL/SInventory_BLL/PackSizeBLL.cs:32` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/ProductCategoriesBLL.cs:33` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/ProductSQBLL.cs:33` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/ProTypeBLL.cs:31` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/RegionInfoBLL.cs:31` — `"Region Name already exist"`
- `Library.BLL/SInventory_BLL/ZoneInfoBLL.cs:33` — `"Zone Name is already exist"`

**Weak/disabled siblings of the above pattern:**
- `Library.BLL/SInventory_BLL/ExcelUpForOrderListBLL.cs:43` — duplicate-company check commented out; no dedup on Excel order import.
- `Library.BLL/SInventory_BLL/UserBLL.cs:46,51,56` — email/login-name/user-name uniqueness checks all commented out; no duplicate-account protection at BLL layer.
- `Library.BLL/SInventory_BLL/StockConditionFreezeBLL.cs:41-52,60-72` — see Warehouse Stock Freeze above.

---

## 2. DoctorModule_UI / DoctorMaster_UI / DoctorVisit_UI (128 files)

`DoctorMaster_UI` and `DoctorVisit_UI` code-behinds are thin pass-throughs to `Library.DAL.*` with
no inline validation — the duplicate/limit rules for those two areas are cataloged in §8 (DAL
layer). All substantive code-behind-level rules below are in `DoctorModule_UI`.

### Doctor Master / CRUD (DoctorMaster_UI)
- All Save/Delete methods are one-line DAL delegations stamped with `Session["UserId"]`, e.g. `Solution.Web/DoctorMaster_UI/DoctorCategory.aspx.cs:32`, `ChamberType.aspx.cs:31`, `DoctorDesignation.aspx.cs:33`, `DoctorSpeciality.aspx.cs:34`, `PatientType.aspx.cs:33`, `PrescriptionType.aspx.cs:34`, `SpecialDaySetup.aspx.cs:30`.
- **Disabled**: `DoctorCategoryView.aspx.cs:39` and `PrescriptionTypeView.aspx.cs:44` — delete calls are commented out; Delete is a no-op on these two screens.

### Market Structure Setup
- `Solution.Web/DoctorModule_UI/MarketSetup.aspx.cs:203-208` — ≥1 station-type user role required: `"please Add to List User Role Wise Station Type!"`
- `MarketSetup.aspx.cs:237-241,243-248,251-256` — Exactly one MIO, one AM, one DZSM required.
- `MarketSetup.aspx.cs:322,329-331` — Duplicate market: `"Already Exist!"`
- `MarketSetup.aspx.cs:336-338` — Deactivation blocked while referenced: `"Data cannot be deactivated!"`
- **Misleading message**: `MarketSetup.aspx.cs:342-345` — any unclassified save failure also shows `"Already Exist!"`.

### Tour Purpose / Tour Plan Setup
- `Solution.Web/DoctorModule_UI/TourPurposeOtherSetup.aspx.cs:161-165,167-171` — Role/Station type required (**silent** — focus only, no message).
- `TourPurposeOtherSetup.aspx.cs:173-185` — ≥1 of Territory/Area/Region/Group required: `"Please select at least one of Territory, Area, Region or Group"`
- `TourPurposeOtherSetup.aspx.cs:187-201` — Duplicate row in grid blocked: `"Already Exist in Table!"`
- `TourPurposeOtherSetup.aspx.cs:683-689` — Tour purpose required (**silent**).
- `TourPurposeOtherSetup.aspx.cs:695-700` — ≥1 market-structure row required.
- `TourPurposeOtherSetup.aspx.cs:641-651` — Row deletion blocked if child data exists: `"Can not be deleted!"`
- `TourPurposeOtherSetup.aspx.cs:785,792-794` — Duplicate on server save; `:797-800` deactivation-while-referenced block; `:802-805` misleading generic-failure `"Already Exist!"`.

### Tour Plan / Visit Plan Approval
- `Solution.Web/DoctorModule_UI/TourPlannedApprovalList.aspx.cs:69-74` — Approval action required: `"please fill out this field"`
- **Weak enforcement (bulk-result bug)**: `TourPlannedApprovalList.aspx.cs:88-117` and `VisitPlannedApprovalList.aspx.cs:74-118` — when multiple rows are selected, the result variable is reassigned every loop iteration, so only the **last** row's outcome determines the success/fail message shown; earlier rows' failures are silently swallowed.

### TADA / DA Claim
- `Solution.Web/SInventory_UI` *(cross-ref)* / `Solution.Web/DoctorModule_UI/TADAClaimEdit.aspx.cs:323-385` — Employee, TADA date, DA Amount, Tour type, Tour purpose, Market (unless purpose contains `"(Other Visit)"`) all required — **all silent** (tooltip/CSS only, no alert).
- `TADAClaimEdit.aspx.cs:428-442` — Save success/failure messages.
- `TADAClaimEdit.aspx.cs:455-463,748-755` — Tour-plan-must-exist-for-date check (via caught exception): `"Tour plan not Exists!"`

### Monthly Allowance
- `Solution.Web/DoctorModule_UI/MonthlyAllowance.aspx.cs:208-232` — Name/Value/Role required (silent).
- `MonthlyAllowance.aspx.cs:235-257` — ≥1 grid row selected: `"Please Select at least one row !"`
- `MonthlyAllowance.aspx.cs:306,313-315` — Deactivate-while-referenced block; `:319-321` duplicate; `:329` generic `"Operation Faild!"`.

### Expense Type / Expense Claim
- **No feedback at all**: `Solution.Web/DoctorModule_UI/ExpenseType.aspx.cs:263-275` — duplicate field name silently not added to the in-memory grid, zero user feedback.
- `ExpenseType.aspx.cs:648-651` — Row deletion blocked if in-use: `"Can not be deleted!"`
- `ExpenseType.aspx.cs:555,562-566` — Duplicate expense type; `:568-572` deactivate-while-referenced block.

### Sub-Territory Setup
- `Solution.Web/DoctorModule_UI/SubTerritorySetup.aspx.cs:172-206` — Area/Territory/Name/Activation date required (silent).
- `SubTerritorySetup.aspx.cs:124,131-133` — Duplicate; `:136-140` deactivate-while-referenced; `:142-146` misleading generic `"Already Exist!"`.

### Training Setup
- `Solution.Web/DoctorModule_UI/Trainning.aspx.cs:127-149` — Title/From-date/To-date required (silent).
- `Trainning.aspx.cs:152-157` — Market structure or user role required: `"please Add to List Market Structure or User Role!!"`
- `Trainning.aspx.cs:230,238` — Duplicate training entry. **No From/To date-order check found** — potential gap.

### Leave Config
- `Solution.Web/DoctorModule_UI/LeaveConfig.aspx.cs:554,563` — Duplicate leave config: `"Already Exist!"`
- `Solution.Web/DoctorModule_UI/Leave.aspx.cs:31` — pure DAL delegation, no inline day-quota/date-overlap check.

### Financial Year Archive / Delete (Data Management)
- `Solution.Web/DoctorModule_UI/FinancialYearDeleteTableEntry.aspx.cs:93-129` — Opening-balance-exists gate toggles Opening vs Delete button availability.
- `:155-175` — Process type, Financial Year, and valid FY date range required for Opening.
- `:200-214` — Delete/Archive mode, Financial Year, table (+ database if archive) required for Delete.
- `:238-249` — **Only whitelisted tables** (Order, Invoice, RX, DCR, TourPlan, Attendance, Expense) are actually deletable: `"Delete logic is configured only for Order, Invoice, RX, DCR, TourPlan, Attendance and Expense."`
- **Dormant guard**: `:228-232` — archive-database-availability check fully commented out.
- **Dropdown/logic mismatch**: `LoadDeleteTableList()` (`:70-86`) offers "Leave" and "Mileage Claim" as deletable, but `TryExecuteDeleteTableProcess` (`:318-450`) has no matching branch — selecting these silently falls into the generic failure message.

### User Setup
- `Solution.Web/DoctorModule_UI/UserSetup.aspx.cs:326-417` — User type, Employee (types 1/3), DA (types 6/7), Username, Login name, Password, User role, Activation date required (silent).
- **Disabled**: `:392-409` — IMEI-required-when-Mobile-Access rule fully commented out.
- `:530,547` — Duplicate user: `"Already Exist!"`

### Approval/Access-Control Gating (cross-cutting, DoctorModule_UI)
- Recurring `UserPersmissionValidation()` pattern: `if (Session["UserRoleID"].ToString() != "2")` looks up a permission row for the current page path; missing row → `Response.Redirect("../Dashboard_UI/DashboardOne.aspx")`. Role `"2"` (Admin) bypasses entirely. Seen in `AttendanceListApproval.aspx.cs:294-326`, `AppMonitoringList.aspx.cs:61-92`, `UserRecords.aspx.cs:45-70`, `TourPlannedApprovalList.aspx.cs`.
- **Weak enforcement**: in `AttendanceListApproval.aspx.cs:305-315`, `AppMonitoringList.aspx.cs`, `TourPlannedApprovalList.aspx.cs` — when a permission row *is* found, the code applying granted `RAdd`/`REdit` flags to button/column visibility is commented out, so any user who passes the page gate still sees full Add/Edit controls regardless of granted rights. Only `UserRecords.aspx.cs:56-65` still applies this correctly — inconsistent across pages.
- `AttendanceListApproval.aspx.cs:328-447` — approval step-advance logic (`Step = InStep+1`, `Status` = Accepted/Verified/Rejected based on `ToRoleTypeId=="5"`), failure shown as misleading `"Already Exist!"` (`:393,441`).

### Field-Force / Reference Setup (RSM/ASM/MIO/NSM, Router, Shift, Holiday, Group, Generic Group, Therapeutic Group, Department, Tour Type/Purpose, Product Line)
- No inline validation — single-line DAL delegations stamped with `Session["UserId"]`. Any duplicate/limit rules live entirely in `Library.DAL.DoctorModule_DAL`.

### Doctor Visit Planning (DoctorVisit_UI)
- `DoctorVisit.aspx.cs`, `DoctorPlanDetailsView.aspx.cs` — pure `[WebMethod]` DAL delegation, no inline visit-target/call-limit rules found in code-behind.
- `DoctorVisitApprovalList.aspx.cs` — empty `Page_Load`, fully client/JS-driven.

---

## 3. MasterSetup_UI / MasterSetup_BLL / Target_UI / Thana_UI

### Customer Invoice / Order Limit Setup (`Library.BLL/MasterSetup_BLL/CustomerInvoiceLimitService.cs`)
All checks below correctly `return` before persistence — no weak enforcement in this file.

| Rule | Location | Message |
|---|---|---|
| Customer required | `:14-17` | "Customer is required." |
| Max invoice value ≥ 1 | `:18-21` | "Maximum Invoice Value must be greater than 0." |
| Duplicate customer in Order Limit Setup | `:23-27` | "This customer already exists in Order Limit Setup." |
| Update requires valid id | `:34-37` | "Invalid record." |
| Delete requires valid id | `:48-51` | "Invalid record." |
| **Invoice-limit gate** (`ValidateInvoiceLimit`) | `:78-98` | active limit for `CustomerId`, default **50,000** if none active; `invoiceAmount > limit` → "Invoice amount exceeds the customer's maximum allowed invoice value." |
| ApplyType defaults to `"Customer"` if blank | `:101-106` | — |
| Customer Type required (ApplyType=CustomerType) | `:110-116` | "Customer Type is required." |
| Customer required (ApplyType≠CustomerType) | `:117-120` | "Customer is required." |
| Active From Date required | `:122-125,156-159` | "Active From Date is required." |
| Duplicate Invoice-Not-Binding entry | `:127-140` | per-ApplyType duplicate message |

Note: `InvoiceGenerationRestricted.aspx.cs:436-439` (§1) implements a *separate* UI-level 50,000 gate
with an override checkbox — not obviously the same code path as this service; treat as two rules
until traced to a single call site.

### Customer Master Data
- `Solution.Web/MasterSetup_UI/CustomerEntry.aspx.cs:318` — Non-Admin role gate disables most fields.
- **Hard-coded backdoor**: `CustomerEntry.aspx.cs:349` and `CustomerView.aspx.cs:320` — `Session["LoginName"] == "53323"` re-enables all fields regardless of role; `CustomerEntry.aspx.cs:71` has a second hard-coded login `"51419"`.
- `CustomerEntry.aspx.cs:766-778` — Mobile number must be 11 digits: `"Mobile NO must be 11 digits!"`
- **Disabled**: `CustomerEntry.aspx.cs:752-764` — NID length check commented out.
- **Active requires approval (added 2026-09-01)**: `CustomerEntry.aspx.cs:766-778` — an existing
  customer cannot be saved with `chkIsActive` checked while its `CustomerCode` is still blank.
  A blank `CustomerCode` is the marker for "not yet approved" (the code is assigned at approval),
  so the save is blocked with `"Customer need to approve!"`. Checked via
  `CustomerInfoDAL.GetCustomerSetupById`; only applies on edit (`id_mastetID` non-empty).
- `CustomerView.aspx.cs:299-320` — Permission gate (role≠2 without permission row → redirect to Dashboard), same backdoor login override.
- **Doctor tagging (added 2026-08-09)**: `CustomerEntry.aspx`'s `ddlDoctorTag` multi-select lets a
  customer be tagged to zero or more doctors, following the same pattern as the page's existing
  `ddlProLine` (product line) multi-select. Dropdown source is active+approved+coded doctors only
  (`IsActive=1 AND DoctorCode IS NOT NULL AND ApprovalStatus='2'`, `sp_GET_DoctorList_ForCustTagging`).
  `CustomerInfoDAL.SaveInfo` syncs the mapping table `tblCustTaggDoc` by delete-then-reinsert on
  every save (not a diff/merge) — see `spec/database-tables.md` `tblCustTaggDoc` and
  `spec/requirements.md` for the source requirement. Verified end-to-end against a running
  instance (IIS Express): create with multiple doctors, edit-reload pre-selection, and
  remove-then-resave correctly drops the removed mapping.
- **Doctor tagging gated to MDC customer type (added 2026-08-11)**: `ddlDoctorTag` now only loads
  and is enabled when the selected `ddlChemisType` (Customer Type) matches MDC —
  `CustomerEntry.aspx.cs:913` `ToggleDoctorTagByCustomerType()`, wired to `ddlChemisType`'s new
  `AutoPostBack`/`SelectedIndexChanged` (`:930`), to the initial page load (`:59`), and to
  edit-mode record load (`:120`). MDC is matched by a case-insensitive prefix check on
  `ddlChemisType`'s selected text (`StartsWith("MDC")`), not full-text equality — `tblCustomerType`
  has no dedicated MDC flag/code, and the display name's fiscal-year suffix (e.g.
  `"MDC (FY 26-27)"`) changes annually. Selecting a non-MDC type clears any selected doctors and
  disables the control; the doctor-list query (`GetDoctorListForTagging`) and the tagged-doctor
  preselect query (`GetTaggedDoctorList`) are both skipped entirely when not MDC — no unnecessary
  DB calls. See `spec/requirements.md` for the source requirement. Verified end-to-end against a
  running instance: toggling Customer Type in add mode enables/loads then disables/clears the
  Doctor field; editing an existing MDC customer, tagging a doctor, and saving persists the row in
  `tblCustTaggDoc`; switching that same customer to a non-MDC type and saving deletes the mapping.
- **Tagged doctor code/name surfaced in Customer List (added 2026-08-17)**: `sp_Get_CustMasterList_Approve`
  now returns `DoctorCode`/`DoctorName` columns, sourced from a pre-aggregated `LEFT JOIN` subquery
  over `tblCustTaggDoc`/`tblDoctorMaster` that `STRING_AGG`s multiple tagged doctors per customer
  into one row — a correlated `OUTER APPLY` was measured 10-40x slower on this table shape (14.6s vs
  106s on a 4.3k-row filtered search) so the pre-aggregated join is deliberate, not incidental.
  `CustomerView.aspx`'s grid/Excel export adds matching `DoctorCode`/`DoctorName` bound columns
  (`:384-385`). Unrelated to this: `CustomerEntry.aspx`'s `ddlDoctorTag` label was reworded from
  "Doctor:" to "Adjacent My Doctor Code:" for clarity — same control, no code-behind change.
- `CustomerListPending.aspx.cs:96-98`, `CustomerView.aspx.cs:159-161`, `CustomerChangeProgramType.aspx.cs:129-131` — DIC role auto-locks Distribution Center dropdown to `Session["DICCompanyUnitId"]`.
- `CustomerChangeProgramType.aspx.cs:263-304` — Program Type required: `"Please Select Program Type!"`; `:295` generic failure mislabeled `"Already Exist!"`.
- `Customer_Doctor_Transfer.aspx.cs:80-85,114-119` — Grid non-empty: `"Table can not be Empty!"`
- `Customer_Doctor_Transfer.aspx.cs:105-109,139-143` — ≥1 employee/doctor selected.
- `Customer_Doctor_Transfer.aspx.cs:148-154,277` — Market required.
- `OrderDCChange.aspx.cs:377-382,402-406` — Grid non-empty, ≥1 row selected.

### Doctor Master Data (MasterSetup_UI copies)
- `DoctorEntry.aspx.cs:228` — Non-Admin field-lock gate (no backdoor override here, unlike CustomerEntry).
- `DoctorEntry.aspx.cs:599` — Mobile 11-digit check.
- `DoctorView.aspx.cs:146-157` — Permission-gated redirect.

### Delivery Agent (DA) Setup
- `DASetup.aspx.cs:181-283` — Name/Depot/Phone/Emergency Contact/Active Date required.
- `DASetup.aspx.cs:200-211` — NID must be 17 digits.
- `DASetup.aspx.cs:226-274` — Phone/Emergency/Reference Contact must be 11 digits each.
- `DASetup.aspx.cs:322-330,362-369` — Duplicate save failure → `"Already Exist!"` (DAL-level dedup, correctly blocks).

### Route / Territory Setup
- `RouteInformationEntry.aspx.cs:613-697` — Depot, Route Name, DA list, Market list, Total Distance/Day, Route Type, TA/DA Amount, Route Day all required.
- `RouteInformationEntry.aspx.cs:704-733` — Duplicate market in list blocked: `"This Market is already exist in list!"`
- `TerritoryWiseDepotSetup.aspx.cs:191-227` — Area/Depot/Route required, ≥1 Territory selected.
- **Weak (silent abort)**: `TerritoryWiseDepotSetup.aspx.cs:252-253` — `if (routeId == 0) return;` aborts save with zero feedback.

### Employee Setup (EmployeeSetup / EmployeeSetupEdit / EmployeeSetupForNewJoiner — identical pattern x3)
- NID must be 17 digits; Employee/Reference/Emergency Contact No must be 11 digits each.
- **Duplicate Employee Code check**: `EmployeeSetup.aspx.cs:716-732` — `"Employee Code Already Exist in User!"`
- Login Name/Password/User Role required before account creation: `:735-755`.
- `EmployeeRecords.aspx.cs:38-58` — Permission gate, redirect to Dashboard if missing.

### Campaign Setup (6 near-duplicate variants: CampaignSetup, CampaignSetup_Mult, CampaignSetup_final, CampaignSetup_new, CampaignSetupPT, OLdCampaignSetup)
- Campaign Name/Chemist Type/Campaign Type/Product Line/From Date/To Date required in every variant.
- Campaign-type-conditional required fields (Product/Qty for type "1", Product/Amount/MaxAmount for "2", Amount for "3").
- Product Offer list and Market Structure/Customer list must be non-empty: `"please Add to List Product Offer"`, `"please Add to List Market Structure or Customer!"`
- **Duplicate customer-in-list check (`AddCustomerVali`)**, repeated in all 6 files: `"The customer already exists in the list!"`
- Autocomplete free-text format validation (`"Name | Id"` pipe format required): `"Input Correct Data !"`
- **Weak/disabled**: email-failure handling commented out in all 6 variants — if the notification email fails, no error is surfaced and the save is not rolled back.

### Quoted Price Setup
- `QuotedPriceSetup.aspx.cs:198-215` — Description/Policy/From/To Date required.
- `QuotedPriceSetup.aspx.cs:163-186` — Customer autocomplete format validation, **weak**: only clears the field/shows a message, doesn't itself block the Save button — the real gate depends on `hfCustomerId.Value` being empty at save time.
- `QuotedPriceSetup.aspx.cs:302` — ≥1 row selected for batch action.

### Order Tracking (view/list)
- DIC role dropdown auto-lock repeated across `OrderTrackingList.aspx.cs:133-135`, `OrderTrackingListDBH.aspx.cs:132-134`, `OrderTrackingSummary.aspx.cs:140-142`.
- `RouteInformationList.aspx.cs:45-52` — role `"5"` restricts route list to `Session["DICUnitId"]`.

### Target Setup (Target_UI)
- `MonthlyTarget.aspx.cs:33-46` — **Weak/inverted gate**: update only proceeds if no conflicting year/month record exists; if one does, the method silently no-ops with no "already exists" message.
- `ProductWiseTarget.aspx.cs:32-39` — Pure insert/update branch on ID, no duplicate/date checks.

### Thana / District / Division Setup (Thana_UI)
- All 5 files are thin `[WebMethod]` wrappers; no validation in this layer. Duplicate-name/required-field logic (if any) lives in `Library.DAL.ThanaDal` — out of scope for this pass.
- `District_Entry.aspx.cs:26`, `ThanaEntry.aspx.cs:26,36` — `Session["UserId"]` passed through with no null-check.

### DWSP (Target Setup UI, separate from Target_UI) — quota enforcement
Recurring "row-sum vs master target" rule across `AMDayWiseDWSPSetup.aspx.cs:525`, `AreaWiseTargetSetup.aspx.cs:476-521`, `AreaWiseTargetSetupView.aspx.cs:425,629`, `TerritoryTargetSetupView.aspx.cs:313,546`, `TerritoryWiseTargetSetup.aspx.cs:392`, `TerritoryWiseTargetSetupApps.aspx.cs:531`, `ZoneWiseTargetSetup.aspx.cs:371`, `ZoneWiseTargetSetupView.aspx.cs:284,446`:
- Condition: running per-row total compared against master `amount.Text` on every row edit; if it exceeds, row input is cleared: `"Amount must be equal with target amount"` — **misleading name**: this is actually an "exceed" cap, not an equality check — a total *less than* target passes silently and is never forced to match before save.
- Companion required-field guard on master target amount (`"Please Select Target Amount"`) is itself weak — shown but doesn't disable the row inputs.
- Role-based zone/employee scoping (`Session["RoleTypeId"]`) restricts selectable zone/territory dropdown options per role — data-scoping, not a hard block.
- **Weak (silent)**: `NationalTargetSetup.aspx.cs:181`, `NationalTargetSetupView.aspx.cs:144`, `ZoneWiseTargetSetupView.aspx.cs:476` — save silently no-ops if `Session["UserId"]` is null, no error shown.

---

## 4. SubDepot module (SubDepot_UI, SubDepot_BLL, 25 files)

### Stock Freeze / Stock Return (`SubDeportStockFreez.aspx.cs`)
- **Weak enforcement, confirmed 4x in one file** (`:271-274`, `:314-317`, `:390-394`, `:437-441`) — `"Return Quantity must be Less then Stock Qty"` is shown but the block is a sibling `if`, not an `else`/`return`; the actual save proceeds via a separate, non-exclusive `if (bigStore >= ReturnQty)` block with no shared flag or early exit. Currently self-correcting only because the two conditions happen to be complementary. Still open, unlike the structurally similar duplicate-submit race in `dadtlsDelivaryInvoiceDetailsCreation_DA.aspx.cs`'s `saveButton_Click` (§1 above), which was fixed 2026-08-11 by moving the app-lock release to after commit/rollback.
- **Hard-coded privileged-user bypass**: `Session["LoginName"] == "21900"` (`:310,432`) duplicates the entire return-processing logic and skips the `"Restricted"` stock-condition gate applied to all other users.
- Return Qty required in all four code paths: `"Insert Return Quantity !!"`

### Stock Transfer — DC ↔ Sub-Depot (`StockOutSubDepot.aspx.cs`, `StockTransferDcToSubDepot.aspx.cs`, `StockTransferSubDepottoDc.aspx.cs`)
- Chalan No/Date, Manufacturer, From/To Company Unit, ≥1 product line required (all three files, near-identical required-field sets): `"Please Insert chalanNo!!"`, `"Please Insert chalanDate!!"`, `"Please Select Manufacturer!!"`, `"Please Select fromComUnit!!"`, `"Please Select toComUnit!!"`, `"Please Add Product!!"`.
- Transfer Qty ≤ available Stock Qty, enforced (textbox cleared): `"Stock Out Qty. cantbe more then Stock Quantity"` / `"Transfer Qty. cantbe more then Stock Quantity"`.
- **Validation-bypass (stronger than weak enforcement)**: `StockOutSubDepot.aspx.cs:117-143` — the live save handler calls `SaveDataForSubDepoAdjust(...)` directly; the full `Validation()` method exists but is only invoked from a dead/commented-out legacy code block (`:144-228`) — **no validation runs on the live save path at all**. Contrast with `StockTransferDcToSubDepot.aspx.cs:325`, which correctly gates its save on `Validation()`.

### Stock Adjustment Voucher (`SubDepotStockAdjustmentVoucher.aspx.cs`)
- Distribution Center, Proforma Invoice Number, Stock Out Date, Reason, Product, ≥1 product row required — `Validation()` correctly gates the save here (`:283-325`).
- `SubDepotStockAdjustmentVoucherView.aspx.cs:47-50` — **Status/approval gate, properly enforced**: a voucher in `"Approved"` status cannot be deleted: `"Can not Delete Data!!!...."`

### Stock Out Approval (`SubDepotStockOutApproval.aspx.cs`)
- `:49-75` — Session-based menu authorization gate: page only loads data if `Session["UserId"]` is assigned to the resolved menu ID.
- `:132-168` — Operation must be selected: `"Please select an operation!!"`; `:145-162` ≥1 row checked: `"Please select at least one row!!!"`
- `:173-220` — Any non-`"Reject"` radio selection sets Status=`"Approved"`; `"Reject"` sets the selected reject-reason text as Status.

### Sub-Depot Customer Payment (`SubDeportCustomerPayment.aspx.cs`)
- Invoice selection, per-row Pay Amount, header Payment Amount, Payment Type, Payment Date required.
- `:186-201` — **Sum of per-row Pay Amounts must exactly equal header Payment Amount**: `"Total Invoice Payment Amount Must Be Equel To Payment Amount"`
- `:296-320` — Per-row Pay Amount (+ previously paid) ≤ invoice amount, enforced (textbox reset to `"0"`): `"Cannot Be Greater then Invoice Quantity "`

### Sub-Depot Invoice Creation
- `SubDepotInvoiceCreation.aspx.cs:55-84,194-204` — **Empty catch blocks** silently swallow invoice-generation and footer-total errors; no user feedback on failure.

### Delivery Invoice List (`DelivaryInvoiceList.aspx.cs`)
- `:93-118` — Status dropdown drives Full/Partial/Reject branching. **Fragile**: the reject branch is an unconditional `else` (no explicit `== "Reject"` check), so any future dropdown value that isn't exactly `"Partial"` or `"Full"` silently falls into Reject.

### Reports / Picking / Master Info
- `SubDepotProformaList.aspx.cs:77-99`, `TopSheetGenerate.aspx.cs:90,98`, `DelivaryTopSheetGenerate.aspx.cs:99,107,171` — All filter parameters required before report generation: `"Please Select all Parameters"`.
- `SCPickingGenerate.aspx.cs:108-125` — ≥1 invoice checked before generating picking report.
- `SubdepotInfoEntry.aspx.cs:73-102` — Sales Center Name, Address, Code, Mobile No, Distribution Center required.
- `SubdepotInfoEntry.aspx.cs:186-243` — Sub-Depot code prefix assigned via a hard-coded per-company-ID `if` ladder (e.g. `"BAR"`, `"BOG"`, `"CHA"`) rather than data-driven config.
- `SubDeportStockReport.aspx.cs:16-31`, `StockReceiveBySubDepot.aspx.cs:16-31` — Session-based login redirect gate; **unguarded `.ToString()`** on `Session["UserType"]` before the null/empty check (NRE risk on expired session).

### Inactive files
- `DelivaryInvoiceCreationForCustomerAuto.aspx.cs.exclude` and `ProformaInvoiceCreation.aspx.cs.exclude` are excluded from the build (`.exclude` suffix) — any rules inside are dormant, not enforced in production.

### Library.BLL/SubDepot_BLL
- All 6 files are pure DAO-calling wrappers with no inline validation. `Sub_InvoiceBLL.cs:736-738` (`LoadOrderExistsBll`) forwards existence-check row counts to callers with no enforcement of its own.

---

## 5. Approval_UI — approval routing (see also [`workflow.md`](workflow.md))

### Access control (repeated pattern across all list pages)
- `Solution.Web/Approval_UI/CustomerApproveList.aspx.cs:75-105` (`UserPersmissionValidation`), mirrored in `DAApprovalList.aspx.cs:246-278`, `DCPCVPApproval.aspx.cs:79-109`, `DoctorApprovalList.aspx.cs`, `ExpenseApprovalList.aspx.cs`, `LeaveApproveList.aspx.cs`, `MillageApprovalList.aspx.cs`, `OrderApproveList.aspx.cs`, `RXApprovalList.aspx.cs`: role≠`"2"` and no permission row → silent redirect to Dashboard.
- **Weak**: the inner per-role field-restriction block after a positive permission check is always empty/dead code — any user with page access gets full button visibility regardless of finer role rules.
- **Fragile**: `Session["RoleTypeName"]`/`["EmpInfoId"]`/`["RoleTypeId"]` read with no null-check on every page load; the whole `Page_Load` try/catch swallows resulting exceptions and silently redirects (expired-session users get no error message), e.g. `CustomerApproveList.aspx.cs:69-72`.

### Multi-step approval-routing gate (role-sequence enforcement)
Implemented identically in `CustomerApproveList.aspx.cs:423-453`, `DAApprovalList.aspx.cs:390-437`, `DCPCVPApproval.aspx.cs:417-448`, `DCRApprovalList.aspx.cs:339-369`, `DoctorApprovalList.aspx.cs:279+`, `ExpenseApprovalList.aspx.cs:445+`, `LeaveApproveList.aspx.cs:417+`, `MillageApprovalList.aspx.cs:393+`, `OrderApproveList.aspx.cs:293+`, `RXApprovalList.aspx.cs:411+`:
- Role IDs `"5"`, `"4"`, `"14"` see all rows as actionable. Otherwise, a row is only actionable if `hfToRoleTypeId` (the pending step's assigned role) matches the current user's role; else the row shows `"Waiting for Another Approver"` instead of action buttons.
- Approve/Reject: `Step = InStep + 1`, `Status = "Accepted"`/`"Rejected"`. **Bug**: `CustomerApproveList.aspx.cs:163-176,220-236` shows the **success** message even when `Res.isSuccess == false` (the correct `"Already Exist!"` failure branch is commented out). Other modules (`DAApprovalList.aspx.cs:188-192`, `DCPCVPApproval.aspx.cs:252-256`, `DCRApprovalList.aspx.cs:171-175`) handle this correctly.

### Multi-tier status escalation — hard-coded super-approver
`DAApprovalList.aspx.cs:138-151`, `ExpenseApprovalList.aspx.cs:191-201`, `LeaveApproveList.aspx.cs:195-205`, `MillageApprovalList.aspx.cs:175-185`, `OrderApproveList.aspx.cs:114-120`, `RXApprovalList.aspx.cs:169-175`:
```
if (ToRoleTypeId == "5") ApprovalStatus = "Accepted";
else if (EmpInfoId == "496") ApprovalStatus = "Accepted";
else ApprovalStatus = "Verified";
```
Role `5` **or** the specific hard-coded employee ID **`496`** gets final "Accepted" status directly, bypassing the normal "Verified" intermediate step required of every other approver. This magic-number bypass appears in 5+ files (also affects row-visibility logic, e.g. `DAApprovalList.aspx.cs:394`, `ExpenseApprovalList.aspx.cs:449`).

### Order Payment Approval (added 2026-08-20) — deliberately does *not* follow the patterns above
`Solution.Web/Approval_UI/OrderPaymentApprovalList.aspx.cs` + `sp_OrderPaymentApproval_*`. Full
rules in `requirements.md`; workflow in [`workflow.md`](workflow.md) §4a. Contrasts with the rest of
this section on every point that made the others weak:

- **No hard-coded super-approver.** There is no employee-id or role-id literal that skips a level.
  Role `5` (Admin) gets read-only oversight — `CanAct` is false for it — not the ability to act.
- **Identity is not a parameter.** Every procedure takes `@ActionUserId` and resolves `EmpInfoId` +
  `RoleTypeId` from `tblUser` → `tbl_UserRoleInfo` itself, so the "role-shaped parameter" class of
  bypass documented elsewhere in this file does not apply.
- **Two-part authorization**: the caller's role type must own the current status *and* the caller
  must be the employee this specific request was routed to (from the snapshotted chain).
- **Button visibility is not authorization.** `sp_OrderPaymentApproval_Act` re-verifies role, level,
  state transition and the payment schedule on every call regardless of what the page rendered.
- **Rejection reason is mandatory** (both the service and the procedure refuse a blank one) — unlike
  the older approval screens, which accept an empty comment.
- **Concurrency is handled**: `UPDATE … WHERE ApprovalStatus = @expected` + `@@ROWCOUNT` guard, so
  two approvers racing get "changed by another user" rather than a double approval.
- **Audit is append-only** via `trg_tblOrderPaymentApprovalHistory_NoChange`.

BR-OPA rules enforced in the procedure layer: request only for a genuinely credit-blocked order;
one live request per order (filtered unique index, race-safe); complete AM/DZSM/NSM chain required;
strict 0→2→4→5 transitions; closed requests immutable; already-invoiced orders excluded; NSM
approval locks the schedule; only the AM step authors the plan; Total Due snapshotted at request
time.

Corresponding change on the invoice side: `InvoiceCreationByOrder_daaw.aspx.cs` now re-checks
`sp_OrderPaymentApproval_CanCreateInvoice` server-side in `gotoinvoiceButton_Click` **and** in
`DataValidation()` — the latter matters most, because bulk invoice generation runs off
ViewState-held selections where a disabled button is not a control. `InvoiceCreationForCustomerByOrder.aspx`
re-checks it too, since it is reachable directly.

### Customer/Doctor transfer approval
- `DoctorCustomerTransferApproval.aspx.cs:168-201` — order-pending customers cannot be transferred: checkbox is programmatically unchecked, `"Order Pending!"`.
- `DoctorCustomerTransferApproval.aspx.cs:282-318` — operation selection required (`"Please select an operation!!"`), ≥1 row checked (silent).

---

## 6. Dashboard_UI, DWSP misc, eProgram_UI, LeaveProcess_UI, Money_Receipt_UI, NoticeBoard_UI, Reports_UI, SettingPanel_UI, UserProfile_UI

### Dashboard_UI
- `AdminDashboard.aspx.cs:37,48` — role≠`"2"` gate (same shape as Approval_UI pattern).
- `DoctorVisitMonitoring.aspx.cs:226-228` — unrecognized `type` param → `"Invalid type."` (defensive input guard, AJAX-style, not a UI block).

### eProgram_UI
- `ProviderDropoutRequestList.aspx:72` — client-side `"Invalid row id."` guard (markup JS, module's only validation; code-behind is otherwise a stub).

### LeaveProcess_UI
- `LeaveApplicationEntry.aspx.cs` is an **empty stub** — all leave-entry validation is client-side markup only (`"Please fill out of this field!"` tooltips, `:255-289`).
- `LeaveApplicationCode.aspx.cs:23-57` — `[WebMethod]`s (`SaveLeaveApplication`, `UpdateLeaveApplication`, `LeaveApplicationApprove`, `GetEmployeeLeaveBalance`) are thin DAL passthroughs with **no server-side validation** — all day-quota/date-range/approval-status enforcement (if any) lives in the DAL, not observed in this pass.
- `YearlyLeaveProcess.aspx.cs:24` — `Session["UserId"]` converted with no null-guard (throws if unauthenticated).
- `YearlyLeaveProcess.aspx:123,132` — mandatory-field messages commented out in markup (**disabled**).

### Money_Receipt_UI
- `BatchWiseCollectionReport.aspx.cs:42-94` — Delivery Man, Batch Creation Date, BatchNo required in sequence; invalid Customer Code lookup clears the field: `"Invalid Customer Info !!"`. All correctly enforced.

### NoticeBoard_UI
- `NoticeSetup.aspx` (markup) — Title, Announcement required; Details list and Image must be non-empty (`"Please!! Add Details list"`, `"Please!! Select Image"`); generic save-failure fallback.
- `SettingPanel_UI/ArchiveDbConnect.aspx:19` — documented (not code-enforced) idempotency: duplicate FY+DB name skips insert but still triggers the job.

### Reports_UI
- `OrderPermission.aspx.cs:191-216` — ≥1 employee checkbox selected: `"Please Select at least one employee!"`
- `CVRDoctoriseMonthlypt.aspx.cs:575,585` — Area/Zone required before report: `"Please Select Area!"` / `"Please Select Zone!"`
- All monthly-report pages read `Session["RoleTypeName"/"EmpInfoId"/"RoleTypeId"]` unguarded — same fragile pattern as Approval_UI.

### SettingPanel_UI
- `UserSettingPanelSetup.aspx.cs:74-96` — ≥1 row checked: `"Please Select Minimum One"`

### UserProfile_UI — password rules
`ChangePassword.aspx.cs`:
- `:111-118` — New password required.
- `:119-126` — Strength regex `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$` (12–20 chars, upper/lower/digit/special): `"Password is not strong enough"`
- `:127-134,158-169` — New password ≠ current password. **Security concern**: the comparison is a **direct plaintext string comparison** against the stored password (`GetUserCurrentPasswordDAL`), consistent with the plaintext-login finding in [`docs/security.md`](../docs/security.md).
- `:137-154` — Confirm-password required and must match; **mislabeled message**: mismatch shows tooltip `"please fill out this field"` instead of a mismatch-specific message.
- `:88-98` — `"Password update failed!"` / `"Password updated successfully!"`, sets `Session["IsPasswordChange"]`.

### Library.BLL (root) / Panal_BLL
- No root-level `.cs` files in `Library.BLL` (all classes live in subfolders).
- `Library.BLL/Panal_BLL/PanalBLL.cs` — pure menu/login/permission plumbing; `SaveMenuBll` (`:39-62`) has an implicit duplicate-prevention pattern (`CheckMenuSl` existence-check-then-insert) but no user-facing validation.

---

## 7. Order-to-cash stage rules (cross-module, from prior pass — not re-verified in this scan)

- An order converts to an invoice (`tblOrder.IsInvoice` flag — confirmed against the live schema; an earlier pass of this document incorrectly named this `OrderInfoMaster.IsInvoice`, a table that doesn't exist); the exact gating condition (e.g. "only after order approval") is implied by approval-workflow ordering but was not traced to a single method.
- DA sales confirmation, payment collection, and sales return each have their own status column on `tblInvoice` (`DA_SalesConfirmStatus`, `DA_PaymentCollection`, `DA_SalesReturn`), independently rejectable via dedicated `sp_RejectInvoiceDA*.sql` procedures. A DIC re-approval layer (`sp_UpdateDICApprovalStatus[_SalesReturn].sql`) sits on top of the DA's own actions for those two stages.

---

## 8. DAL layer (Doctor/Thana modules) — closes the gap flagged in §2

`DoctorMaster_UI`, `DoctorVisit_UI`, `Thana_UI`, and most Field-Force reference-data screens in
`DoctorModule_UI` have thin code-behind with no inline validation (§2) — their rules live in
`Library.DAL/DoctorModule_DAL`, `DoctorMaster_DAL`, `DoctorVisit_DAL`, `Thana_DAL` (37 files, all
scanned). This is stored-procedure-calling ADO.NET throughout, so most "business logic" is a thin
C# wrapper around a `sp_check_*`/`sp_Save_*` call — real duplicate/limit logic mostly lives in the
stored procedures themselves, which are **not in this repo** for the vast majority of these procs.

### Recurring pattern (repeated near-identically across ~20 classes)
1. On edit (`Id > 0`): call `sp_check_<Entity>`; if it returns rows, set `isDuplicateCheck = true` and skip the update.
2. On deactivate (`IsActive == false`) within an edit: additionally call `sp_check_Vali_MarketStructure` with `@MasterId`/`@PageName="<Entity>"`; rows returned → `isValiCheck = true`, blocks deactivation ("in-use, can't deactivate").
3. On insert (`Id == 0`): call `sp_Save_*`; success inferred from `pk > 0` — C# has no visibility into *why* a proc returned 0 (could be duplicate, could be an unrelated failure).
4. Exceptions caught, connection closed, rethrown (or swallowed into a bare `throw;` in "get" methods).

### Confirmed rules with the duplicate-check proc + market-structure gate
- `Library.DAL/DoctorModule_DAL/DesignationDal.cs:17,36,45` — `sp_check_Designation` + gate `PageName="Designation"`.
- `Library.DAL/DoctorModule_DAL/DepartmentDal.cs:18,36,44` — `sp_check_Department` + gate `PageName="Dept"`.
- `Library.DAL/DoctorModule_DAL/GroupSetupDal.cs:62,85,94` — `sp_check_GroupInfo` + gate `PageName="Group"`.
- `Library.DAL/DoctorModule_DAL/ZoneSetupDAL.cs:97,126,134` — `sp_check_ZoneInfo` + gate `PageName="Zone"`.
- `Library.DAL/DoctorModule_DAL/Setup2DAL.cs:211` (Area), `:613` (Territory), `:722` (SubTerritory), `:1198` (Market) — each with matching `sp_check_*` + `PageName` gate.
- `Library.DAL/DoctorModule_DAL/SetupDAL_daaw.cs:4281,4319` — `sp_check_ExpenseType` + gate `PageName="ExpenseTypeName"`.

### Duplicate check only, no market-structure gate
- `HolidayDal.cs:45,67` (`sp_check_Holiday`), `LeaveDal.cs:18,37` (`sp_check_LeaveInfo`), `RouterSetup.cs:16,33` (`sp_check_RouterMaster`), `RSMSetupDal.cs` (ASM/UserRole/NSM/NSMHead/RSM/MIO — lines 48/122, 201, 374, 450, 1060, 1133/1207, each with its own `sp_check_*Info`), `AttendanceDAL.cs:18,47` (`sp_check_Employee_ShiftInfos`), `Setup2DAL.cs:1508` (`sp_check_DoctorDegree`) — and, identically, all nine `DoctorMaster_DAL` classes: `DoctorCategoryDal.cs:17,36`, `DoctorChamberDal.cs:19,38`, `DoctorDegreeDal.cs:28,53`, `DoctorDesignationDal.cs:47,66`, `DoctorSpecailDayDal.cs:19,37`, `DoctorSpecialityDal.cs:17,35`, `PatientTypeDal.cs:19,39`, `PrescriptionTypeDal.cs:65,85`.
- `RSMSetupDal.cs` — deactivation (`Inactive_ASMInfoById:928`, `Inactive_RSMInfoById:993`, `Inactive_MIOInfoById:1282`) calls `sp_Update_*ActiveStatus` directly with **no duplicate/in-use check at all** — inconsistent with the Setup2DAL/DoctorModule_DAL masters that gate deactivation.

### No duplicate-check proc at all (gap vs. sibling masters)
- `Library.DAL/DoctorModule_DAL/TourTypeDal.cs:159` (`SaveTourType`), `:414` (`SaveTourPurpose`) — straight update/insert, no `sp_check_*` call.
- `Library.DAL/DoctorVisit_DAL/DoctorVisitDAL.cs:193,382` — same gap, mirrored (`SaveTourType`/`SaveTourPurpose`).
- `Library.DAL/DoctorVisit_DAL/NoticeDal.cs:22` (`SaveNotice`) — no duplicate check; fans out unguarded per-row inserts to `sp_Save_Notice_MarketDetail`/`sp_Save_NoticeUserRoleDetail`.
- `Library.DAL/DoctorModule_DAL/Setup2DAL.cs:3713,3842` (`Save_Prescription`/`Save_ExpenseClaim`, duplicated in `SetupDAL.cs:4761,4876`) — no duplicate-check proc.
- `Library.DAL/DoctorModule_DAL/SeedDataDAL.cs:180` (`Save_TopSheetGenReportCodeInfo`) — plain insert-and-check-pk>0.

### Confirmed bugs
- **`Library.DAL/Thana_DAL/ThanaDal.cs:52`** — `SaveThanaInfo`'s duplicate-check call passes `thana.district_id` as the `@id` parameter to `sp_check_ThanaInfo` instead of `thana.ThanaId` — the duplicate check is keyed on the wrong column. `Save_DistictInfo:112` has the identical copy-paste bug against `sp_check_DistictInfo`. Neither method has a market-structure in-use gate either.
- **`Library.DAL/DoctorModule_DAL/ZoneSetupDAL.cs:216-231`** — `UpdateActiveStatus` builds parameters but the actual `UpdateData` proc call is commented out (`:231`); the method is a no-op that returns a default `ResultInfo` (`isSuccess` stays `false`) despite appearing to perform an update. `UpdateZoneInfo:251` is an unimplemented stub (`throw new NotImplementedException()`).
- **`Library.DAL/DoctorModule_DAL/GenericGroupDal.cs:68,82`** — sets `isValiCheck = true` on both the duplicate-hit branch and the insert-failure branch, where sibling classes use `isDuplicateCheck` — inconsistent flag usage; if the UI branches on flag type (as several `.aspx.cs` files in §2/§3 do), this class's failures may surface the wrong message.
- **`Library.DAL/DoctorModule_DAL/TherapueticGroupDal.cs:56-57,119-120`** — insert-success branch also sets `isValiCheck = true` alongside `isSuccess = true` — looks like copy-paste from the duplicate branch, likely unintentional.
- **`Library.DAL/DoctorModule_DAL/UserInfoDAL.cs:374-381,407-415`** — `SaveUserInfo` branches its duplicate-check proc on `UserTypeId == 6 || 7` (DA/DA-assistant) vs. all other types, using raw magic numbers `6`/`7` rather than named constants — same "type code as magic number" pattern as the `EmpInfoId=="496"` finding in §5.

### Notable side effects / risk flags (not "rules" but affect data integrity)
- `Setup2DAL.cs:1295` — `SaveMarket`, on reactivation, cascades the market's active state onto related customer records via `sp_Update_CustomerInfoForMarketData` — a cross-entity side effect triggered from what looks like a simple master-data save.
- `Setup2DAL.cs:1650-1653` and `Library.DAL/DoctorVisit_DAL/NoticeDal.cs:95-115,140-162` — image file writes (`File.WriteAllBytes`) with no path-traversal sanitization of the filename/id used to build the path; `Setup2DAL` swallows write failures in an empty `catch`, `NoticeDal` doesn't even catch them (raw exception propagates from an otherwise-successful save).
- `Library.DAL/DoctorModule_DAL/DepotWiseAreaSetupDal.cs:16-110` — client-side diffing of a many-to-many depot/area mapping via a linear `AllocatedOrNot` scan per incoming row (O(n·m)), not a stored-proc-side set operation — no dedup/limit guard beyond the scan itself.
- `Library.DAL/DoctorModule_DAL/UserInfoDAL.cs:98,169` — `IsOpeningBalanceExistsForFinancialYear` and `IsArchiveDatabaseAvailable` are genuine C#-level boolean gates (inline `COUNT(1)` SQL, not stored procs) backing the Financial-Year-Delete screen's rules in §2; `IsArchiveDatabaseAvailable` connects to the `"master"` database by literal string.
- `Library.DAL/DoctorModule_DAL/FinancialYearDeleteTableDAL.cs:141` — `ResolveDatabaseName` silently defaults a blank database name to `DataBase.SalesDB` on a **destructive delete** operation, with no confirmation that the caller intended the default.
- `Library.DAL/DoctorModule_DAL/HolidayDal.cs:40` and `SeedDataDAL.cs:242` — bypass the stored-proc convention entirely with inline ad-hoc SQL (`GetFinanCialyear`, `GetActiveDAList`).
- `Library.DAL/DoctorMaster_DAL/DoctorDegreeDal.cs:56,70` — reads `HttpContext.Current.Session["UserId"]` directly instead of taking it as a parameter like every sibling class in the folder — will `NullReferenceException` if ever called outside a live web request (e.g. a background job).
- `Library.DAL/DoctorMaster_DAL/DoctorInformationDal.cs` — despite the name, contains no doctor-master save/duplicate logic (3 lookup getters only) — actual doctor save logic lives in `Setup2DAL`/`SetupDAL` instead, a code-organization mismatch worth knowing about if searching for "where is Doctor Master saved."

### Not found in repo
Bodies of every `sp_check_*`, `sp_check_Vali_MarketStructure`, `sp_Save_*`, and `sp_Update_*`
procedure referenced above — all logic beyond the row-count/`pk>0` checks documented here lives in
SQL Server and could not be traced from this repo.

---

## What's explicitly not enforced

- **No page-level authorization beyond "is logged in," inconsistently applied even where menu permissions exist.** Menu visibility (per-user grants in `tblMainMenu`) is not a hard page-access check — see the repeated `UserPersmissionValidation`/permission-redirect pattern above, which exists on some pages but is dead/commented-out on others (e.g. Approval_UI's per-role field restriction, DoctorModule_UI's `RAdd`/`REdit` visibility). See [`docs/security.md`](../docs/security.md) and [`validation-rules.md`](validation-rules.md) §Authorization.
- **No password complexity rule for login** — only `ChangePassword.aspx.cs` enforces a strength regex; initial/admin-set passwords and the login comparison itself are plaintext with no visible complexity gate.
- **Several hard-coded user/employee bypasses embedded directly in code** (not config-driven): login name `"53323"` and `"51419"` (CustomerEntry/CustomerView field-lock bypass), login name `"21900"` (SubDeportStockFreez restricted-stock bypass), employee ID `"496"` (Approval_UI final-approval-status bypass). These are undocumented business rules that only exist as magic strings in `.aspx.cs` files.

## Rules defined only in the database (out of scope for this repo)

- Login credential verification happens via a direct plaintext SQL comparison, not a stored procedure — see [`docs/security.md`](../docs/security.md).
- Many "already exists"/limit-style checks likely also exist inside stored procedures whose T-SQL bodies are not fully checked into this repo (only a small number of `.sql`/`.txt` working copies exist at the repo root; the rest live only in the production database). Any rule not traceable to a `.sql` or `.cs` file in this repo is **Not Found**, not assumed absent — see §8 for the full list of `sp_check_*`/`sp_Save_*`/`sp_Update_*` procedures whose bodies are Not Found despite their C#-side callers being fully traced.
