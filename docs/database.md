# Database

## Engine and logical databases

Microsoft SQL Server (2019 in every dev connection string found). Two logical databases are referenced across the codebase:

- **`SSIDB`** (connection-string key `SolutionConnectionStringSSIDB`, resolved by `Library.DAL/InternalCls/ClsCommonInternalDAL.cs`'s `ConnStr(string dataBaseName)` helper — there is no default/no-arg overload; every one of that class's ~23 call sites passes the literal `"SSIDB"` explicitly, including the ones that take a `dataBaseName` parameter from their own caller) — the main application database.
- **`SalesDisDB_SMC_NEWDB`** — defined as the `DataBase.SalesDB` constant in `Library.DAL/DataManager/DataBase.cs` (two other values, `..._InvoiceTest` and `..._TerritoryStucture`, are left commented out as prior test/dev databases in the same file). Most DAL code doesn't reference this constant directly — it resolves connection strings by database-name suffix instead (see below).
- **`SAP_API_Data`** — a third logical database, on the same SQL Server instance as
  `SalesDisDB_SMC_NEWDB`, filled by an external, out-of-repo SAP-side process — this app never
  writes to it directly. It has no connection-string entry of its own; every reference is a
  cross-database qualifier (`SAP_API_Data..tableName`, e.g. `SAP_API_Data..tblSAP_StockMovementMaster`)
  inside a stored procedure that's already connected to `SalesDisDB_SMC_NEWDB`, so it only works
  because both databases live on the same server. Read by the ~77 `sp_SAP*`-prefixed procedures (see
  [`spec/integrations.md`](../spec/integrations.md) §1). Two of its tables —
  `tblSAP_StockMovementMaster` / `tblSAP_StockMovementDetail` — are schema-documented in
  [`docs/ReceiveQty_RootCause_Analysis.md`](ReceiveQty_RootCause_Analysis.md) §6, which also surfaces
  a structural gap worth flagging here: the Master table's only natural key, `challan_code`, has no
  unique constraint, and neither table carries a SAP document number or movement-type code — nothing
  in the schema stops the same shipment from being posted twice under different `challan_code`
  strings. That gap is the confirmed root cause of a real duplicate-stock-receive incident traced
  end-to-end in that doc.

## Schema source — now authoritative via live introspection

**Update: this gap is closed.** There is still no Entity Framework migration history and no
database diagram, but the live schema has now been pulled directly from `SalesDisDB_SMC_NEWDB` and
checked into the repo:

- [`spec/database-tables.md`](../spec/database-tables.md) — every table (570), every column
  (7,405), with type/nullability/key, pulled from `INFORMATION_SCHEMA`/`sys.identity_columns`.
- [`spec/database/`](../spec/database/) — full `CREATE PROCEDURE`/`FUNCTION`/`VIEW` source for all
  1,870 stored procedures, 43 functions, and 58 views, pulled via `OBJECT_DEFINITION()`.
- [`spec/database-spec.md`](../spec/database-spec.md) — the index into both of the above, plus
  hard facts the DAO/grep-based reconstruction couldn't surface: only **3 real foreign-key
  constraints** exist across the entire schema, and the primary-key strategy split (475 tables with
  a PK constraint, 418 with IDENTITY — meaning 95 tables have no PK constraint at all) is now
  precisely counted rather than guessed at.

The three older partial sources below are kept for narrative/historical context (they explain
*why* a given table/proc came to exist, which the schema alone doesn't), but for "does this column
exist" or "what does this proc actually do," go to `spec/database-tables.md`/`spec/database/`
first:

1. ~20 root-level `.sql` files that used to each be a working copy of one or a few stored procedures (occasionally with an embedded `CREATE`/`ALTER TABLE` for the specific feature being patched) — **deleted in commit `ddd28c0`** ("clean up scratch scripts") and no longer present in the tree. Every procedure they used to document still exists; its source now lives in `spec/database/procs/<name>.sql` (or `spec/database/functions/` for `MainMenu2`) instead. The table below is kept for the narrative/purpose context those working copies used to carry, with file references updated to point at the surviving `spec/` copies.
2. `Library.DAO` entity/DTO classes — a **partial** mirror of real tables; several SQL scripts reference columns (e.g. `tblInvoice.DA_SalesConfirmStatus`) that don't appear in the corresponding C# DTO (`Invoice.cs`), so the DAO classes should not be treated as the full column list — this is now directly verifiable against `spec/database-tables.md` rather than inferred.
3. Inline SQL strings scattered across `Library.DAL`.

## Connection configuration — three sources, already out of sync

See [`docs/security.md`](security.md) §1 for the full drift detail. In short:

| Source | Used by |
|---|---|
| `Solution.Web/web.config` → `connectionStrings/SolutionConnectionStringSSIDB` | `ConfigurationManager`-based Dapper code (e.g. `SInventoryWebService.cs`, `ArchiveDbConnectRepository.cs`, `UserSessionTrackingManager.cs`) |
| `Library.DAL/DataManager/SqlUserAccess.cs` (`DataSource`/`UserName`/`PassWord` static fields) | The legacy `DataAccessManager*` classes |
| `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs` | An older, simpler duplicate of the same idea |

`SqlUserAccess.cs` also defines `AppName`/`BASE_URL` for a separate REST API host — unrelated to the database, see [`docs/api.md`](api.md).

A fourth source — root-level `*.ps1` scripts, each embedding its own literal connection string — used to exist but was deleted in commit `ddd28c0` ("clean up scratch scripts"); none remain in the tree (the surviving `deploy/scripts/*.ps1` files are Web Deploy/IIS automation, not per-developer DB pointers, and don't embed a connection string of their own).

## Data access plumbing

`Library.DAL/DataManager/` contains **four** near-duplicate connection/command helper classes — `DataAccessManager`, `DataAccessManagerAsync`, `DataAccessManagerOld`, `DataAccessManager_daaw` — plus `SqlUserAccess.cs` and `DB_Authentication.cs` above, and `EncryptDecrypt.cs` (unused, see [`security.md`](security.md)). Which one a given DAL class uses appears to depend on when that class was written rather than a deliberate per-case choice; `DataAccessManager`'s connection-string builder is the only one observed setting `Encrypt=True;TrustServerCertificate=True`.

**⚠️ Temporary diagnostic change, not yet resolved (as of 2026-08-06):** `DataAccessManager.cs`'s
`SqlConnectionOpen(string database)` (~line 119) originally caught `SqlException` and returned
`false` silently (with a `//throw;` left commented out) — every caller of `SqlConnectionOpen`
(e.g. `PanalClsDAL.Login`) ignores that `bool` return value and immediately calls a `Get*`/`Save*`
method on the same `DataAccessManager`, which then throws a **misleading**
`InvalidOperationException("Connection is not open.")` instead of the real underlying
`SqlException` — this masked a live login failure (`Login.aspx.cs`) that reproduced consistently
(three consecutive `POST /Login.aspx` → HTTP 500 in one test session) even though the same
connection string opened successfully outside the app (via `sqlcmd` and a standalone
`SqlConnection.Open()` test). The `//throw;` was uncommented to surface the real exception for
debugging, and that change is **still active in the codebase** — it was not reverted before this
note was written, and the actual root SqlException from inside IIS Express had not yet been
captured. Before treating this as a permanent fix: (a) capture the real exception message next
time this reproduces, (b) decide deliberately whether `SqlConnectionOpen` should throw or whether
callers should instead start checking its `bool` return (the swallow-and-ignore pattern is used
elsewhere in this class too, e.g. `SaveData`/`UpdateData`/`DeleteData` do check `EnsureOpen`
failures via their own `catch (SqlException) { throw; }`, so `SqlConnectionOpen` alone was the
outlier). Do not assume this is resolved without checking `Library.DAL/DataManager/DataAccessManager.cs` directly.

`Library.DAL/InternalCls/`:
- `ClsPrimaryKeyFind.cs` — computes the next primary-key value for a table, either by `SELECT MAX(column)+1` (built via string concatenation of the table/column name — see [`security.md`](security.md)) or `IDENT_CURRENT('table')` for identity columns. Confirms **not all tables use IDENTITY columns**; some rely on application-computed max+1, which is a concurrency consideration for any write path using it.
- `ClsCommonInternalDAL.cs` — the lowest-level Dapper/ADO.NET wrapper: opens a `SqlConnection` from a named connection string and exposes generic run-SQL-text or run-named-stored-procedure helpers (including a legacy catch-all proc, `ExecuteAllSqlQueryByStoreProcedure`, for ad-hoc query strings), covering SELECT/INSERT/UPDATE/DELETE, identity-return inserts, DataTable/DataReader loading, and DropDownList binding.

## Stored procedures actually called from C# (representative, not exhaustive)

Grouped by dominant `Library.DAL` folder — call counts in parens indicate how many distinct call sites reference that procedure name (not executions):

- **SInventory_DAL** (invoicing/inventory, heaviest usage): `sp_Process_DWSPReport` (39), `sp_DeliveryInvoiceCreationList` (33), `sp_I_InvoiceMaster` (12), `sp_DeliveryConformationFull`/`Reject` (8/6), `sp_Deletenvoice` (6), `sp_Update_InvoiceFinalPayment` (5), `sp_UD_InvoiceDetail` (5), `sp_Process_ProformaInvoiceByOrderId` (5), `sp_Get_NewReceiveableList` (5), `sp_Get_MoneyReceiptReportList`/`AfterPaymentList` (5/5), `sp_GET_PaymentInvSP*` (5 each), `sp_UP_LoadingSummary*` (4 each).
- **DoctorModule_DAL** (territory/market/expense/prescription admin — a mixed-purpose folder despite the name): `sp_check_Vali_MarketStructure` (20), `sp_Update_TerritoryData` (16), `sp_Save_TerritoryThanaRelation` (12), `sp_Update_ExpenseType`/`sp_Save_ExpenseTypeDetails` (11 each), `sp_Update_MarketData`/`sp_Update_ExpenseClaim`/`sp_Save_ExpenseClaimMaster`/`sp_Save_ExpenseClaimDetails` (10 each), plus a repeated Save/Update/Get/Delete CRUD family for doctor master data (speciality, special-day, patient-type, designation, degree, chamber, category — 4-7 call sites each).
- **MasterSetup_DAL**: `sp_Webapi_Get_DoctorClaimApp` (14+3), `sp_Webapi_Get_AttendanceInformation` (13+3), `sp_Save_BonusCampaignNewDetail*`/`sp_Get_BonusCampaigndtlList` (6 each), `sp_Get_EmployeeInformationListRpt_Final` (6), `sp_Get_MarketList` (6), `sp_Save_RSMInfo` (7).
- **Transfer_DAL**: `sp_Update_MarketStructure_Transfer` (5).
- **SubDepot_DAL**: `sp_SubdeportDeliveryConformationFull`/`Reject` (5/5), `sp_Process_SubDepoProformaInvoiceByOrderId` (5).
- **UserRoleDAL**: `sp_Get_UserRoleInfo` (7), `sp_GET_ApprovalMapLoad`, `sp_Save_ApprovalMapMaster`/`Detail` (approval routing, see [`business-flow.md`](business-flow.md)).
- **SAP_IntegrationDAL / Thana_DAL / ChartDAL / DWSP_DAL**: dashboard aggregation procs (`sp_Get_*Dashboard_new`) and SAP staging-sync procs (`sp_Chk_SAP_EmpInfoCondition`, `sp_Upsertdate_ProductInfo`, `sp_Upsertdate_EmpInfo`, `sp_SAP_StockReceive`, `sp_SAP_Up_StockReceiveQty` — see [`spec/integrations.md`](../spec/integrations.md)) and Thana/District/Division geography CRUD. For a fully-verified, end-to-end trace of one such chain — `sp_SAP_StockReceive` orchestrating `sp_SAP_WhStockInMaster`/`sp_SAP_WhStockInDetails` → `sp_SAP_STOMaster`/`sp_SAP_STODetails` → `sp_SAP_StockInTransfer`, from the `SAP_API_Data` staging tables through to `SInventory_UI/ReceiveProductByChalanByDC.aspx` — see [`docs/ReceiveQty_RootCause_Analysis.md`](ReceiveQty_RootCause_Analysis.md) §3/§5.

## Stored procedures previously tracked via root `.sql` working copies, now sourced from `spec/database/`

The root-level `.sql` files this table used to cite (`CustomerInvoiceLimit.sql`, `alter_menu.sql`,
`sp1.sql`/`sp2.sql`, `update_sps_*.sql`, etc.) were all deleted from the tree in commit `ddd28c0`
("clean up scratch scripts"). Every procedure below still exists in the live database — the `File`
column now points at its full source under [`spec/database/`](../spec/database/) instead:

| Procedure | File | Purpose | Main table(s) |
|---|---|---|---|
| `sp_InsertCustomerInvoiceLimit` / `sp_UpdateCustomerInvoiceLimit` / `sp_DeleteCustomerInvoiceLimit` / `sp_GetCustomerInvoiceLimitById` / `sp_GetCustomerInvoiceLimits` | `spec/database/procs/` (one file per procedure) | Per-customer max-invoice-value config CRUD | `tblCustomerInvoiceLimit`, `tblCustMaster` |
| `sp_GetCustomerAutoComplete` | `spec/database/procs/sp_GetCustomerAutoComplete.sql` | Top-20 customer autocomplete | `tblCustMaster` |
| `sp_InsertInvoiceNotBinding` / `sp_UpdateInvoiceNotBinding` / `sp_DeleteInvoiceNotBinding` / `sp_GetInvoiceNotBindingById` / `sp_GetInvoiceNotBindingList` | `spec/database/procs/` (one file per procedure) | Invoice-limit exception rules (by customer or customer type) | `tblInvoiceNotBinding`, `tblCustMaster`, `tblCustomerType` |
| `MainMenu2` (a function, not a procedure) | `spec/database/functions/MainMenu2.sql` | Builds the nested `<ul>` HTML menu string via nested cursors over 4 menu levels, filtered by role | `tblMainMenuNew`, `tblMenuRole`, `tblMenuDistribution` |
| `sp_Get_MarketList` | `spec/database/procs/sp_Get_MarketList.sql` | Dynamic-SQL SELECT of the full market hierarchy with station-type role pivots | `tblMarket`, `tblSubTerritory`, `tblTerritory`, `tblArea`, `tblRegion`, `tbl_Group`, `tblUser`, `tblEmpGeneralInfo`, `tbl_Thana`/`District`/`Division`, `tblMarketStationDetail`, `tblStationType` |
| `sp_Rep_DepopsitSlip_BusinessSummary` | `spec/database/procs/sp_Rep_DepopsitSlip_BusinessSummary.sql` | Multi-CTE per-company-unit cash-in-hand / outstanding / sales-return-collection totals for a deposit-slip report | `tblCompanyUnit`, `tblInvoice(Detail)`, `tblSubInvoiceMaster/Detail`, `tblCustPayDetail`, `tblOrder`, `tblReturnInvoice`, `tblDepositOpeningBalance`, `tblCompanyWiseDeposit` |
| `sp_Rep_DepopsitSlip_BusinessSummaryClosingReport` | `spec/database/procs/sp_Rep_DepopsitSlip_BusinessSummaryClosingReport.sql` | Same summary, wrapped in a transaction that snapshots a closing balance into `tblDepositOpeningBalance` | Same read set + write to `tblDepositOpeningBalance` |
| `sp_GetMarketwisePickingslipByBatchNo_daaw` | `spec/database/procs/sp_GetMarketwisePickingslipByBatchNo_daaw.sql` | Route/product/batch quantities for a picking slip | `tblInvoice(Detail)`, `tblOrder`, `tblProduct`, `tblRouteInformationMaster`, `tblInvoiceBatch` |
| `sp_GetTopSheetByBatchNo_daaw` | `spec/database/procs/sp_GetTopSheetByBatchNo_daaw.sql` | Customer/DA/route "top sheet" rows for a batch | `tblInvoice(Detail)`, `tblCustMaster`, `tblOrder`, `tblCustomerType`, `tblRouteInformationMaster/DADetail`, `tblDAInfo`, `tblInvoiceBatch` |
| `sp_RejectInvoiceDAPaymentCollection` | `spec/database/procs/sp_RejectInvoiceDAPaymentCollection.sql` | Revert an invoice's DA payment-collection status, delete its app-log row | `tblInvoice`, `tblPaymentCollection_appLog` |
| `sp_RejectInvoiceDASalesConfirmStatus` | `spec/database/procs/sp_RejectInvoiceDASalesConfirmStatus.sql` | Revert an invoice's DA sales-confirm status, delete its app-log rows | `tblInvoice`, `tblSalesConfirmation_appLog(Detail)` |
| `sp_RejectInvoiceDASalesReturn` | `spec/database/procs/sp_RejectInvoiceDASalesReturn.sql` | Revert DA sales-return status, delete app-log rows | `tblInvoice`, `tblSalesReturn_appLog(Detail)` |
| `sp_UpdateDICApprovalStatus` / `sp_UpdateDICApprovalStatus_SalesReturn` | `spec/database/procs/` (one file per procedure) | DIC-level re-approval on top of DA confirmation/return | `tblSalesConfirmation_appLog`, `tblSalesReturn_appLog` |
| `sp_check_da_UserInfo` / `sp_check_da_UserInfo_Save` | `spec/database/procs/` (one file per procedure) | Uniqueness checks on LoginName/EmpInfoId/DaInfoId for user edit vs. new-user save | `tblUser` |
| `sp_Save_UserMaster_New` | `spec/database/procs/sp_Save_UserMaster_New.sql` | Insert a new app user with generated `UserCode` | `tblUser` |

## Frequently-referenced tables (deduplicated, from grep across `Library.DAL` + the now-deleted root SQL working copies)

- **Transactional core**: `tblInvoice`, `tblInvoiceDetail`, `tblSubInvoiceMaster`, `tblSubInvoiceDetail`, `tblOrder`, `tblOrderDetail`, `tblReturnInvoice`, `tblReturnInvoiceDetail`, `tblInvoiceDetailReturn`, `tblInvoiceBatch`, `tblInvoiceNotBinding`, `tblCustomerInvoiceLimit`.
- **Master/reference data**: `tblCustMaster`, `tblCustomerType`, `tblCustCategory`, `tblProduct`, `tblProductDiscount`, `tblProductSQ`, `tblManufacturer`, `tblUnitPrice`, `tblStockUOM`, `tblCompanyUnit`, `tblCompanyInfo`, `tblUser`, `tblEmpGeneralInfo`, `tblUserCompanyUnit`, `tblPaymentType`, `tblProgramType`, `tblDAInfo`.
- **Geo/territory hierarchy**: `tblMarket`, `tblSubTerritory`, `tblTerritory`, `tblArea`, `tblRegion`, `tbl_Group`, `tbl_Thana`, `tbl_District`, `tbl_Division`, `tblDistrict`, `tblMarketStationDetail`, `tblStationType`, `tblRouteInformationMaster`, `tblRouteInformationDADetail`, `tblDistributionRoute`.
- **Warehouse/stock/DC**: `tblDCStore`, `tblDCStoreFreeze`, `tblDCPicking`, `tblCentralStore`, `tblStockInTransfar`, `tblWHStockInDetail`, `tblSubDepot`, `tblSubDepotStore`, `tblSubDepotStockOutMaster`, `tblSubDepotChalanInfo`, `tblDeStockOutMaster`, `tblMIAInfo`, `tblMIOInfo`, `tblMIGODetail`, `tblRequisition`, `tblRequsitionChild`.
- **Payments/collections**: `tblCustPayDetail`, `tblCustomerPay`, `tblCollection`, `tblCollectionSub`, `tblChalanInfo`, `tblChalanDetail`, `tblDepositOpeningBalance`, `tblCompanyWiseDeposit`.
- **Campaign/menu/app-log**: `tbl_BonusCampaignNewDetail`, `tblSubFixed`, `tblSubFixedPro`, `tblFixedPro`, `tblMainMenu`, `tblMainMenuNew`, `tblMenuRole`, `tblMenuDistribution`, `tblPaymentCollection_appLog`, `tblSalesConfirmation_appLog(Detail)`, `tblSalesReturn_appLog(Detail)`.

Full column-level detail for every one of these — and every other table in the 570-table schema — is in [`spec/database-tables.md`](../spec/database-tables.md), no longer "Not Found."
