# Database Spec

This is a reference-table expansion of [`docs/database.md`](../docs/database.md). Read that file
first for the narrative (connection-string drift, data-access plumbing).

**This version is grounded in a live schema introspection** (`INFORMATION_SCHEMA` + `sys.objects` /
`sys.identity_columns` / `sys.foreign_keys` against `SalesDisDB_SMC_NEWDB` on `DESKTOP-MND72HJ`,
the credentials in `Solution.Web/web.config`'s active — uncommented — connection string), not
reconstructed from grep/DAO evidence. Object *names*, *columns*, *types*, *counts*, and full
*definitions* below are authoritative for that database snapshot as of this pull.

**Full source for every procedure, function, and view is now checked into this repo** under
[`spec/database/`](database/) — `procs/<name>.sql` (1866 files), `functions/<name>.sql` (43 files),
`views/<name>.sql` (58 files), one `CREATE PROCEDURE`/`CREATE FUNCTION`/`CREATE VIEW` per file,
pulled via `OBJECT_DEFINITION()`. This supersedes the "bodies not pulled" caveat from the prior
version of this doc — if you need to know what a specific `sp_*` actually does, open its file
directly instead of asking for it to be re-pulled. The handful of procs with hand-maintained working
copies at the repo root (table below) predate this dump and may have drifted from the live version
now in `spec/database/procs/` — treat `spec/database/procs/` as current, the root `.sql` files as
historical working notes.

## Databases on the connected server

| Name | Status |
|---|---|
| `SalesDisDB_SMC_NEWDB` | **Active** — matches `web.config`'s uncommented connection string |
| `SalesDisDB_SMC` | Present, referenced by other commented-out connection strings in `web.config` — likely an older/prod copy |
| `CRMDB`, `CSTL_ACCDB_Unicorn`, `CSTL_ERPDB_Unicorn` | Present on the same server, unrelated to this app (other CSTL products) |
| `master`, `tempdb`, `model`, `msdb` | System databases |

## Object counts (SalesDisDB_SMC_NEWDB)

| Object type | Count |
|---|---|
| Tables | 569 |
| Columns (all tables) | 7,402 |
| Views | 58 |
| Stored procedures | 1,866 |
| Functions (scalar/table/inline-table) | 41 |
| **Enforced foreign keys** | **3** |

## Full object catalogs

- **[`database-tables.md`](database-tables.md)** — every table, every column, with type/nullability/key, generated directly from `INFORMATION_SCHEMA.COLUMNS` + `sys.identity_columns`. This is the authoritative column list; treat any `Library.DAO` class as a possibly-partial view of the table it maps to (confirmed gap below still stands).
- Views, functions, and the full stored-procedure name catalog are below in this file.

## Referential integrity — confirmed, not just suspected

Only **3 foreign keys** exist as actual DB constraints in the entire 569-table schema:

| FK | Child | Parent |
|---|---|---|
| `FK_tblExpiryReturn_appLogDetail_LogId` | `tblExpiryReturn_appLogDetail(ExpiryReturnId)` | `tblExpiryReturn_appLog(ExpiryReturnId)` |
| `FK__tblPettyC__Petty__0ECE1972` | `tblPettyCashDetails(PettyCashmasterId)` | `tblPettyCashMaster(PettyCashmasterId)` |
| `FK_tblSalesReturn_appLogDetail_LogId` | `tblSalesReturn_appLogDetail(SalesReturnAppLogId)` | `tblSalesReturn_appLog(SalesReturnAppLogId)` |

Every other master-detail/lookup relationship in this schema (customer↔invoice, product↔stock,
employee↔territory, etc.) is enforced **only** in application/stored-procedure code, not by the
database. This confirms and hardens the "possibly-partial DAO" and "no cascading delete safety
net" concerns raised elsewhere in the docs — an orphaned child row from a bad delete anywhere in
the app will not be caught by SQL Server.

## Primary-key generation

**Confirmed split**: 473 of 569 tables have a `PRIMARY KEY` constraint; 417 have an `IDENTITY`
column. That leaves roughly 150 tables with **no PK constraint at all**, and ~55 tables with a PK
constraint but no IDENTITY column (i.e. relying on `Library.DAL/InternalCls/ClsPrimaryKeyFind.cs`'s
`SELECT MAX(column)+1` string-built pattern noted in `docs/database.md` and `docs/security.md`).
Exactly which tables fall in which bucket is enumerated in
[`database-tables.md`](database-tables.md) (`Key` column: `PK`, `IDENTITY`, `PK, IDENTITY`, or
blank).

## Views (58)

Full `CREATE VIEW` source for every one of these is in [`spec/database/views/`](database/views/).
Grouped loosely by name below; most are `View_*`/`view_*` (SQL Server is case-insensitive here but
the casing is inconsistent in source — copy names exactly as listed).

**Field-force / market-structure hierarchy**: `View_FieldForceArea`, `View_FieldForceAsm`, `View_FieldForceGroup`, `View_FieldForceMarket`, `View_FieldForceMio`, `View_FieldForceNsm`, `View_FieldForceRegion`, `View_FieldForceRsm`, `View_FieldForceSubTerritory`, `View_FieldForceTerritory`, `View_webapi_FieldForce`, `View_webapi_FieldForce_Test`, `view_EmpList`, `View_ZoneName`, `View_DepotName`, `View_MIOName`.

**Customer / doctor master**: `View_CustomerMaster`, `View_CustomerMasterOld`, `View_CustomerMaster_ActiveInactive`, `View_CustomerForModification`, `View_CustomerName`, `View_CustomerDCP`, `View_DoctorMaster`, `View_DoctorMasterActiveInactive`, `View_OrderCustomerInfo`.

**Stock / inventory**: `View_AllStock`, `View_CentralStoreCurrentStock`, `View_DCStoreCurrentStock`, `View_SampleCurrentStock`, `VIew_SubDepotCurrentStock`, `View_ProDCStock`, `View_TotalCurrentStockofCompanyWithStockInTransfar`, `v_ProductALLInfo`, `View_ProductName`.

**BI / reporting** (heaviest group — mostly feed the `Dashboard_UI`/`Reports_UI` screens and PowerBI-style dashboards): `View_AccountsReceivable_BIReport`, `View_BusinessSummary`, `View_CustomerAging_BIReport`, `View_CVR`, `View_DCP`, `View_DCR`, `View_MIAWiseSalesReport`, `View_OrderInfo_BIReport`, `View_ProductCoverage_BIReport`, `View_ProductWiseSales_BIReport`, `View_ProformaInvoiceReportList`, `View_Return_BIReport`, `View_Sales_BIReport`, `View_SalesCollectionDue_BIReport`, `View_TargetvsAchivement_BIReport`, `View_TargetvsAchivment_2023to2024`, `vw_TargetvsAchievement_BIReport`, `View_EpharmaSales2022April`, `View_EpharmaSales2023`, `View_EpharmaSales2024` (three year-specific snapshot views — a "clone a view per fiscal year" pattern, not parameterized).

**Web API feeds**: `View_Webapi_EmployeeFieldForceInfo`, `View_Webapi_EmployeeFieldForceInfo_Collection`, `View_Webapi_EmployeeFieldForceInfo_Top1`.

**Other**: `DWSPMasterTerritoryDATA`.

Three `_2022`/`2023`/`2024` and `...Old`/`...ActiveInactive` view-name suffixes across this list
signal the same anti-pattern seen in `CampaignSetup*.aspx.cs` in [`business-rules.md`](business-rules.md)
— point-in-time or variant copies kept alive side-by-side rather than parameterized or migrated away
from.

## Functions (41)

Full `CREATE FUNCTION` source for every one of these is in [`spec/database/functions/`](database/functions/).

| Function | Type |
|---|---|
| `CheckMobileNumber` | scalar |
| `DateRange_To_Table` | table |
| `DateRange_To_TableByMonthYear` | table |
| `DateRange_To_TableSL` | table |
| `DelimitedSplit8K` | inline-table |
| `EmployeeSale` | table |
| `F_DateName` | table |
| `F_FIRST_N_WEEKDATES` | table |
| `F_MonthName` | table |
| `F_ProductName` | table |
| `F_ProductNameFromEmpSale` | table |
| `fn_CleanRows` | scalar |
| `fn_GetExistenceStatus` | scalar |
| `fn_GetTerritoryInfo` | table |
| `fn_GetTerritoryInfo_Optimized` | inline-table |
| `fn_GetTotalCountForEmployee` | table |
| `fn_split_string_to_column` | table |
| `fnSplit` | table |
| `GetBookQuantityByDCStore` | inline-table |
| `GetBookQuantityByDCStored` | table |
| `GetBookQuantityByDCStoreId` | scalar |
| `GetCampaignCustomer` | table |
| `GetCampaignCustomerback` | table |
| `GetCampaignCustomerlasst` | table |
| `GetCampaignCustomerlast` | inline-table |
| `GetCampaignCustomermm` | inline-table |
| `GetCampaignCustomernn` | table |
| `GetCampaignEmployee` | table |
| `GetDateWiseSale` | table |
| `GetDayes` | table |
| `GetDCwiseStock` | table |
| `GetEmployeeNameFunc` | scalar |
| `GetmonthlycustomerSaleDate` | inline-table |
| `GetMonthWiseSale` | table |
| `GetMonthYearValuesDateRange` | inline-table |
| `GetRoleTypesFunc` | scalar |
| `GetVat` | inline-table |
| `MainMenu` | scalar |
| `MainMenu2` | scalar |
| `MonthValueToName` | scalar |
| `parseJSON` | table |
| `Remove_SpecialCharacters` | scalar |
| `TimeDifference` | scalar |

`MainMenu2` has full source in this repo (`alter_menu.sql`/`menu_func*.sql`, see `docs/database.md`).
The five `GetCampaignCustomer*` variants (`GetCampaignCustomer`, `GetCampaignCustomerback`,
`GetCampaignCustomerlasst`, `GetCampaignCustomerlast`, `GetCampaignCustomermm`,
`GetCampaignCustomernn` — six, not five) are the same "keep every draft alongside the current
version" pattern as the view-naming and `CampaignSetup*` code duplication already flagged in
`business-rules.md` §3 — treat only the one actually referenced from `Library.DAL`/`.aspx.cs` (not
determined in this pass) as live.

## Stored procedures with full source in this repo

(Unchanged from the prior version of this doc — these ~20 procs have real `.sql` files at the repo
root, distinct from the 1,866-name catalog below which is names-only from the live server.)

| Procedure | File | Operation | Table(s) |
|---|---|---|---|
| `sp_InsertCustomerInvoiceLimit` | `CustomerInvoiceLimit.sql` | INSERT | `tblCustomerInvoiceLimit` |
| `sp_UpdateCustomerInvoiceLimit` | `CustomerInvoiceLimit.sql` | UPDATE | `tblCustomerInvoiceLimit` |
| `sp_DeleteCustomerInvoiceLimit` | `CustomerInvoiceLimit.sql` | DELETE | `tblCustomerInvoiceLimit` |
| `sp_GetCustomerInvoiceLimitById` | `CustomerInvoiceLimit.sql` | SELECT (1 row, joined) | `tblCustomerInvoiceLimit`, `tblCustMaster` |
| `sp_GetCustomerInvoiceLimits` | `CustomerInvoiceLimit.sql` | SELECT (list, joined) | `tblCustomerInvoiceLimit`, `tblCustMaster` |
| `sp_GetCustomerAutoComplete` | `CustomerInvoiceLimit.sql` | SELECT top 20 | `tblCustMaster` |
| `sp_InsertInvoiceNotBinding` | `CustomerInvoiceLimit.sql` | INSERT | `tblInvoiceNotBinding`, `tblCustMaster` |
| `sp_UpdateInvoiceNotBinding` | `CustomerInvoiceLimit.sql` | UPDATE | `tblInvoiceNotBinding` |
| `sp_DeleteInvoiceNotBinding` | `CustomerInvoiceLimit.sql` | DELETE | `tblInvoiceNotBinding` |
| `sp_GetInvoiceNotBindingById` | `CustomerInvoiceLimit.sql` | SELECT (joined) | `tblInvoiceNotBinding`, `tblCustMaster`, `tblCustomerType` |
| `sp_GetInvoiceNotBindingList` | `CustomerInvoiceLimit.sql` | SELECT (joined list) | `tblInvoiceNotBinding`, `tblCustMaster`, `tblCustomerType` |
| `MainMenu2` (function) | `alter_menu.sql`/`menu_func*.sql` | SELECT → HTML string, nested cursors, 4 menu levels | `tblMainMenuNew`, `tblMenuRole`, `tblMenuDistribution` |
| `sp_Get_MarketList` | `sp_Get_MarketList.sql` / `alter_sp_Get_MarketList.sql` | SELECT (dynamic SQL, hierarchy + role pivot) | `tblMarket`, `tblSubTerritory`, `tblTerritory`, `tblArea`, `tblRegion`, `tbl_Group`, `tblUser`, `tblEmpGeneralInfo`, `tbl_Thana`/`District`/`Division`, `tblMarketStationDetail`, `tblStationType` |
| `sp_Rep_DepopsitSlip_BusinessSummary` | `sp1.sql`/`sp1_alt.sql` | SELECT (multi-CTE aggregate) | `tblCompanyUnit`, `tblInvoice(Detail)`, `tblSubInvoiceMaster/Detail`, `tblCustPayDetail`, `tblOrder`, `tblReturnInvoice`, `tblDepositOpeningBalance`, `tblCompanyWiseDeposit` |
| `sp_Rep_DepopsitSlip_BusinessSummaryClosingReport` | `sp2.sql`/`sp2_alt.sql` | SELECT + transactional DELETE/INSERT snapshot | Same read set + write `tblDepositOpeningBalance` |
| `sp_GetMarketwisePickingslipByBatchNo_daaw` | own file | SELECT | `tblInvoice(Detail)`, `tblOrder`, `tblProduct`, `tblRouteInformationMaster`, `tblInvoiceBatch` |
| `sp_GetTopSheetByBatchNo_daaw` | own file | SELECT | `tblInvoice(Detail)`, `tblCustMaster`, `tblOrder`, `tblCustomerType`, `tblRouteInformationMaster/DADetail`, `tblDAInfo`, `tblInvoiceBatch` |
| `sp_RejectInvoiceDAPaymentCollection` | own file | UPDATE + DELETE | `tblInvoice`, `tblPaymentCollection_appLog` |
| `sp_RejectInvoiceDASalesConfirmStatus` | own file | UPDATE + DELETE | `tblInvoice`, `tblSalesConfirmation_appLog(Detail)` |
| `sp_RejectInvoiceDASalesReturn` | own file | DELETE + UPDATE | `tblInvoice`, `tblSalesReturn_appLog(Detail)` |
| `sp_UpdateDICApprovalStatus` | own file | UPDATE | `tblSalesConfirmation_appLog` |
| `sp_UpdateDICApprovalStatus_SalesReturn` | own file | ALTER TABLE (adds 3 cols) + UPDATE | `tblSalesReturn_appLog` |
| `sp_check_da_UserInfo` | `update_sps_check.sql` | SELECT (uniqueness check, edit) | `tblUser` |
| `sp_check_da_UserInfo_Save` | `update_sps_check.sql` | SELECT (uniqueness check, new) | `tblUser` |
| `sp_Save_UserMaster_New` | `update_sps_main.sql` | INSERT, returns `SCOPE_IDENTITY()` | `tblUser` |

## Full stored-procedure name catalog (all 1,866)

Pulled live from `INFORMATION_SCHEMA.ROUTINES` — this is the authoritative list of what exists on
the server, superseding the prior "~120 further names, regenerate by grepping" note. Full source
for every one of these is in [`spec/database/procs/`](database/procs/) (one `.sql` file per
procedure, see note above) — this section is a browsable index into that folder, not a
name-only stub. Grouped by naming-convention prefix, which
approximates — but does not guarantee — operational purpose, since the codebase is not consistent
about it (see `sp_check*` vs `sp_Check*` casing, and `sp_DEL*` vs `sp_Delete*` as two separate
delete conventions).

## Appendix: full stored-procedure catalog (all 1866)

Grouped by name-prefix convention (operational purpose is inferred from naming, not from reading every body). Alphabetical within each group.

<details><summary><strong>Read (sp_Get*/sp_Rpt*)</strong> (696)</summary>


- `sp_GET_ActionStatusList`
- `sp_Get_alesReectionReportList`
- `sp_Get_ALl_District_List`
- `sp_Get_ALl_Division_List`
- `sp_Get_ALl_Thana_List`
- `sp_Get_AllActive_Zone_BI_Report`
- `sp_GET_AllArea`
- `sp_Get_AllCollectionReportListDHB`
- `sp_Get_ALlDIvision`
- `sp_Get_AllDoctorVisitMonitoringApprovalList`
- `sp_Get_AllLeaveRecords`
- `sp_Get_ALlOrderSummaryByChemist`
- `sp_Get_ALlOrderSummaryByChemist_Pivot`
- `sp_Get_ALlOrderSummaryByProduct`
- `sp_Get_Allowance_For_DDL`
- `sp_Get_AllowanceData_ByEmployeeId`
- `sp_Get_AllPaymentReportList`
- `sp_GET_AllRegion`
- `sp_Get_AllSalesConfirmationReport_new`
- `sp_Get_AllSalesReportList`
- `sp_Get_AllSalesReportListDHB`
- `sp_Get_AllSalesReportListParam2`
- `sp_Get_AllSalesReportListParam2Pro`
- `sp_Get_AllSalesReportListParamNew`
- `sp_GET_AllStockProductwise`
- `sp_Get_AMDZSMListByTerritoryId`
- `sp_Get_ApprovalMapData`
- `sp_GET_ApprovalMapLoad`
- `sp_GET_ArchiveDbConnect_ByFinancialYearDesc`
- `sp_GET_ArchiveFinancialYearList`
- `sp_Get_AreaAll_ByEmpID`
- `sp_Get_AreaAll_ByZoneId`
- `sp_Get_AreaData_ByAreaId`
- `sp_Get_AreaList`
- `sp_Get_AreaList_OnlyActive_ByZoneId`
- `sp_Get_AreaListOrdPer`
- `sp_Get_AreaListOrdPerALL`
- `sp_Get_AreaTargetAmount`
- `sp_Get_AreaWiseTargetList`
- `sp_GET_ASMInfo`
- `sp_GET_ASMInfo_ByEmpId`
- `sp_GET_ASMInfo_ById`
- `sp_Get_AttandenceMonthlyDashboard`
- `sp_Get_AttandenceMonthlyDashboard_new`
- `sp_Get_AttendanceInformation`
- `sp_GET_BAnkInfoById_ById`
- `sp_GET_BAnkInfoById_ByIdAcc`
- `sp_GET_BAnkInfoById_ByIdExcel`
- `sp_Get_BankSAPMappingAccounTNo`
- `sp_Get_BonusCampaigndtlList`
- `sp_Get_BonusCampaignNewMasterList`
- `sp_Get_BrandName_All`
- `sp_Get_BrandWiseOrderDashboard`
- `sp_Get_BrandWiseOrderDashboard_new`
- `sp_Get_BrandWiseOrderPaymentDashboard`
- `sp_GET_btnShow`
- `sp_Get_BusinessSummaryReportList`
- `sp_GET_CampaignCategory`
- `sp_GET_CampaignDetail_ById`
- `sp_GET_CampaignDetailCustomer_ById`
- `sp_GET_CampaignDetailMarket_ById`
- `sp_GET_CampaignMaster_ById`
- `sp_GET_CampaignMasterMap_ById`
- `sp_GET_CampaignNameFromOrderDetail`
- `sp_GET_CampaignNameFromOrderDetailByDateRange`
- `sp_GET_CampaignNameFromOrderDetailByMonthYear`
- `sp_GET_CampaignType`
- `sp_Get_CapturedBY_For_DDL`
- `sp_Get_ChamberType_Active`
- `sp_GET_Check_QuotedpriceEntry`
- `sp_GET_checkTodaysAlreadyInviceGenerateByCustId`
- `sp_Get_Chk_EmpCode`
- `sp_Get_Chk_EMPDataExistCheck`
- `sp_Get_Chk_TerritoryCode`
- `sp_GET_CollectionVsSales_BI`
- `sp_GET_CompanyInfo`
- `sp_Get_ContactType_Active`
- `sp_GET_CustMaster_ById`
- `sp_Get_CustMasterInstitution`
- `sp_Get_CustMasterList_Approve`
- `sp_Get_CustMasterList_ApproveTest`
- `sp_Get_Customer_Active`
- `sp_Get_CustomerApp`
- `sp_Get_CustomerAppDataForDuplicate`
- `sp_Get_CustomerCategory`
- `sp_GET_CustomerCategoryWiseCount_BI`
- `sp_Get_CustomerCoverage`
- `sp_GET_CustomerCoverageFCBNOFCB_BI`
- `sp_Get_CustomerCoverageRecordMonthlyDashboard`
- `sp_Get_CustomerCoverageRecordMonthlyDashboard_New`
- `sp_Get_CustomerCoverageRecordPaymentDashboard_New`
- `sp_GET_CustomerInfo`
- `sp_Get_CustomerInfo_ByCode`
- `sp_Get_CustomerInfoForDDL`
- `sp_Get_CustomerTranferApprovalList`
- `sp_GET_CustomerType`
- `sp_GET_CustomerType_ById`
- `sp_GET_CustomerTypeActive`
- `sp_GET_CustomerTypeAll`
- `sp_GET_CustomerTypeAllByDateRange`
- `sp_GET_CustomerTypeAllMonthYear`
- `sp_GET_CustomerWiseNoSales_BI`
- `sp_GET_CustomerWiseSalesAnalysis`
- `sp_GET_CustomerWiseSalesAnalysis_BI`
- `sp_GET_da_BankList`
- `sp_GET_da_ConfirmationList`
- `sp_GET_da_CustomerwiseAgingdashboard`
- `sp_GET_da_DAAmountList`
- `sp_GET_da_DAClaimAmountListReports`
- `sp_GET_da_DAClaimListByDA`
- `sp_GET_da_DATOurPlanMarketListReports`
- `sp_GET_da_DaWiseCustomerList`
- `sp_GET_da_DaWiseDCList`
- `sp_GET_da_DaWiseMarketList`
- `sp_GET_da_DaWiseRouteList`
- `sp_GET_da_DICApprovedDAClaimMarket`
- `sp_GET_da_ExpenseClaimListByDA`
- `sp_GET_da_ExpenseImagePathSetting`
- `sp_GET_da_ExpenseTypeByDA`
- `sp_GET_da_ExpenseTypeDetailsById`
- `sp_GET_da_ExpenseTypeWithDetailsById`
- `sp_GET_da_MarketListDAClaim`
- `sp_GET_da_PaymentCollectionApprovalList`
- `sp_GET_da_PaymentCollectionList`
- `sp_GET_DA_PaymentInvSP`
- `sp_GET_da_PendingforDepositlist`
- `sp_GET_da_ProductList`
- `sp_GET_da_rpt_ConfirmationList`
- `sp_GET_da_rpt_PaymentCollectionList`
- `sp_GET_da_rpt_SalesReturnList`
- `sp_GET_da_SalesConfirmationApprovalList`
- `sp_GET_da_SalesConfirmationDetailsByInvoiceId`
- `sp_GET_da_SalesReturnApprovalList`
- `sp_GET_da_SalesReturnDetailsByInvoiceId`
- `sp_GET_da_SalesReturnList`
- `sp_Get_DAClaimDARouteList`
- `sp_Get_DAClaimDICApprovalListByRoute`
- `sp_Get_DACollectionReport`
- `sp_Get_DAExpenseClaimApprovalList`
- `sp_Get_DAExpenseClaimList`
- `sp_Get_DAExpenseDayWiseSummary`
- `sp_GET_DAInfo`
- `sp_GET_DAInfoById`
- `sp_Get_DAMonthlyDashboard_DayWise`
- `sp_GET_Dashboard_BI`
- `sp_GET_DashboardCardInfo`
- `sp_Get_DashboardDeptoWiseInvoice`
- `sp_Get_DashboardDeptoWiseOrder`
- `sp_Get_DashboardInvoice_DeptoWise`
- `sp_Get_DashboardOrder_DeptoWise`
- `sp_Get_DashboardTopBarChartCustomerCoverage`
- `sp_Get_DashboardTopBarChartDeliveryAmount`
- `sp_Get_DashboardTopBarChartOrder`
- `sp_Get_DashboardTopBarChartOrderCount`
- `sp_Get_DashboardTopBarChartRejectionAmount`
- `sp_Get_DashboardTopBarChartTotalAttandence`
- `sp_Get_DashboardTopBarChartTotalDCR`
- `sp_Get_DashboardTopBarChartTotalInvoiceAmount`
- `sp_Get_DashboardTopBarChartTotalLeave`
- `sp_Get_DashboardTopBarChartTotalRX`
- `sp_Get_DashboardTopBarData`
- `sp_Get_DashboardTopBarData_NSM`
- `sp_Get_DashboardTopBarData_Zone`
- `sp_GET_DatewiseSale`
- `sp_Get_DCPCVPTourPlanApp`
- `sp_Get_DCRApp`
- `sp_Get_DCRInfoList`
- `sp_Get_DCRInfoListForView`
- `sp_Get_DCRReportNew`
- `sp_GET_DCStockInfo`
- `sp_Get_DCStockReportList`
- `sp_Get_DCStockReportListNew`
- `sp_GET_DCWiseArea`
- `sp_Get_DDLDAName`
- `sp_Get_DDLDANameByDCID`
- `sp_Get_Degree_All`
- `sp_Get_Degree_All_Active`
- `sp_Get_Degree_All_ActiveByDoctorTypeId`
- `sp_GET_DelivaryInvoiceNoCheckById`
- `sp_Get_DeliveryReturnReport`
- `sp_GET_DeliveryVsCollection`
- `sp_GET_DelTerritoryByRouteInformationDDL`
- `sp_GET_DepartmentInfo`
- `sp_GET_DepartmentInfo_ById`
- `sp_Get_DepositCodeByDIC`
- `sp_GET_DepotByCompanyId`
- `sp_Get_Designation_All_Active`
- `sp_GET_DesignationForDDL`
- `sp_GET_DesignationInfo`
- `sp_GET_DesignationInfo_ById`
- `sp_GET_DistributionCenter`
- `sp_GET_DistributionRoute`
- `sp_GET_DistributionRouteByDCID`
- `sp_Get_District_Active_DDL`
- `sp_Get_District_All_Active_NoTag`
- `sp_GET_DistrictCoordinator`
- `sp_GET_DistrictCoordinator_ById`
- `sp_GET_DistrictInfo_ById`
- `sp_GET_DistrictList`
- `sp_Get_DistrictList_OnlyActive_ByDivisionId`
- `sp_Get_Division_Active`
- `sp_Get_Division_Active_DDL`
- `sp_GET_DivisionList`
- `sp_Get_Doctor_For_DDL`
- `sp_Get_DoctorAppDataForDuplicate`
- `sp_Get_DoctorBrand_Active`
- `sp_Get_Doctorcategory_ById`
- `sp_Get_DoctorCategoryList`
- `sp_Get_doctorCateList`
- `sp_Get_DoctorChamber_ById`
- `sp_Get_DoctorChamberList`
- `sp_Get_DoctorClaimApp`
- `sp_GET_DoctorContactDetail_ById`
- `sp_Get_DoctorCustomer_Active`
- `sp_Get_DoctorDegree_ById`
- `sp_Get_DoctorDegreeList`
- `sp_Get_DoctorDesignation_ById`
- `sp_Get_DoctorDesignationList`
- `sp_Get_DoctorExpenseClaim_ById`
- `sp_Get_DoctorGMPRecordMonthlyDashboard`
- `sp_Get_DoctorGMPRecordMonthlyDashboard_New`
- `sp_Get_DoctorGMPRecordMonthlyDashboardDayWise`
- `sp_Get_DoctorGMPRecordMonthlyDashboardZoneWise`
- `sp_Get_DoctorGMPxRecordMonthlyDashboard`
- `sp_Get_DoctorGMPxRecordMonthlyDashboard_new`
- `sp_Get_DoctorGMPxRecordMonthlyDashboardDayWise`
- `sp_Get_DoctorGMPxRecordMonthlyDashboardZoneWise`
- `sp_Get_DoctorList`
- `sp_Get_DoctorList_Approval`
- `sp_GET_DoctorMaster_ById`
- `sp_Get_DoctorNGMPRecordMonthlyDashboard`
- `sp_Get_DoctorNGMPxRecordMonthlyDashboard`
- `sp_Get_DoctorPatientList`
- `sp_Get_DoctorPatientType_ById`
- `sp_Get_DoctorPlanDetailsById`
- `sp_Get_DoctorProgramType_Active`
- `sp_GET_DoctorProgramTypeList`
- `sp_Get_DoctorSetupData_ByDoctorId`
- `sp_Get_DoctorSpeacialDay_ById`
- `sp_Get_DoctorSpecailDayList`
- `sp_Get_DoctorSpecialDay_Active`
- `sp_Get_DoctorSpecialDay_All_Active`
- `sp_GET_DoctorSpecialDayDetail_ById`
- `sp_Get_DoctorSpeciality_Active`
- `sp_Get_DoctorSpeciality_ById`
- `sp_Get_DoctorSpecialityList`
- `sp_Get_DoctorTourPlanDateById`
- `sp_Get_DoctorTourPlanMasteList`
- `sp_Get_DoctorTranferApprovalList`
- `sp_Get_DoctorType_Active`
- `sp_GET_DueInvoiceNoCorrection`
- `sp_GET_DZSMInfo_ByEmpId`
- `sp_GET_DZSMInfo_ById`
- `sp_Get_DZSMinfoByEmpId`
- `sp_GET_DZSMProcessDate`
- `sp_GET_DZSMwiseNAtionalReport`
- `sp_GET_DZSMwiseReport`
- `sp_GET_DZSMwiseReportParam`
- `sp_GET_DZSMwiseReportParam_ByProcess`
- `sp_GET_DZSMwiseReportParam_ByProcess_Area`
- `sp_GET_DZSMwiseReportParam_ByProcess_Terri`
- `sp_GET_DZSMwiseReportParam_ByProcess_vv`
- `sp_GET_DZSMwiseReportParam_ByTest`
- `sp_GET_DZSMwiseReportParam_new`
- `sp_GET_DZSMwiseReportParam_new_Day`
- `sp_Get_Emp_AttendanceInfoDayRow`
- `sp_Get_Emp_AttendanceInfoList`
- `sp_Get_Emp_AttendanceInfoListPending`
- `sp_Get_Employee_ShiftInfos_ById`
- `sp_Get_Employee_ShiftInfosList`
- `sp_Get_EmployeeAMditID`
- `sp_Get_EmployeeDZSMditID`
- `sp_Get_EmployeeFieldForceInfo_EmpId`
- `sp_Get_EmployeeFieldForceInfo_EmpIdMArketInfo`
- `sp_GET_EmployeeInfoOrdPermission`
- `sp_Get_EmployeeInformation_ById`
- `sp_Get_EmployeeInformationList`
- `sp_Get_EmployeeInformationList_Prm`
- `sp_Get_EmployeeInformationListActive`
- `sp_Get_EmployeeInformationListRpt`
- `sp_Get_EmployeeInformationListRpt_Final`
- `sp_Get_EmployeeInformationListRpt_new`
- `sp_GET_EmployeeLeaveBalance`
- `sp_Get_EmployeeLeaveIinfo_ById`
- `sp_Get_EmployeeList`
- `sp_Get_EmployeeListFieldForce`
- `sp_Get_EmployeeMIO`
- `sp_Get_EmployeeMIOEditID`
- `sp_Get_EmployeeNSMditID`
- `sp_GET_EmployeeWiseProductSale`
- `sp_Get_EmployyeMonthlyExpense`
- `sp_Get_ExpanseClaimApp`
- `sp_Get_ExpanseClaimMonthlyDashboard`
- `sp_Get_ExpanseClaimMonthlyDashboard_DayWise`
- `sp_Get_ExpenseClaimList`
- `sp_Get_ExpenseClaimList_Approval`
- `sp_Get_ExpenseDetails_ByExpenseId`
- `sp_Get_ExpenseTypeData_ByExpenseTypeId`
- `sp_Get_ExpenseTypeMaster`
- `sp_GET_FinancialInfo`
- `sp_GET_FinancialYear`
- `sp_GET_financialYear_ById`
- `sp_GET_FinancialYearDate`
- `sp_Get_FinanCialyearforDDL`
- `sp_GET_FinancialYearWithId`
- `sp_Get_FirstDate_LastDatebyYearMonth`
- `sp_GET_forPaymentTerritoryByRouteInformationDDL`
- `sp_GET_forsndReturnTerritoryByRouteInformationDDL`
- `sp_GET_GenericGroup`
- `sp_GET_GenericGroup_ById`
- `sp_GET_GenericGroupActiveForDDL`
- `sp_Get_GetDWSPTotalsByEmpId`
- `sp_GET_GetOrderDtlCamCheckId`
- `sp_GET_GetOrderDtlCamCheckIdEze`
- `sp_Get_GoogleList`
- `sp_Get_Group_List`
- `sp_GET_GroupInfo`
- `sp_GET_GroupInfo_ById`
- `sp_GET_GroupList`
- `sp_Get_GroupListOrdPer`
- `sp_Get_GroupWisePromoQtyList`
- `sp_Get_HolidayInfo_ById`
- `sp_Get_Holidaylist`
- `sp_Get_IntransitReportList`
- `sp_Get_IntransitReportList_BI`
- `sp_Get_InvoiceCreationRouteWiseSalesAssistantList`
- `sp_Get_InvoiceCreationRouteWiseSalesAssistantListforSick`
- `sp_GET_InvoiceStatusddlAll`
- `sp_Get_JoiningDateCountInfo`
- `sp_GET_lDcWiseTerritoryDetail_ByAreaId`
- `sp_Get_Leave_AppLog`
- `sp_GET_LeaveApplicationInfoById`
- `sp_Get_LeaveConfigList`
- `sp_GET_LeaveConfigSetupById`
- `sp_Get_Leavelist`
- `sp_Get_LeaveType_New`
- `sp_Get_LoadingReportList`
- `sp_GET_MainMenuByType`
- `sp_GET_MainMenuRole`
- `sp_GET_MainMenuRole2`
- `sp_GET_MainMenuRoleIsApp`
- `sp_GET_MainPermissionByUserRoleandPageUrl`
- `sp_GET_Manufacturer`
- `sp_GET_Manufacturer_ById`
- `sp_GET_ManufacturerActiveForDDL`
- `sp_Get_MarketByTerriTory`
- `sp_Get_MarketByTerriTory_ByRouterMasterId`
- `sp_Get_MarketData_ByMarketid`
- `sp_Get_MarketList`
- `sp_GET_MenuHTML`
- `sp_Get_MIATargetList`
- `sp_Get_MIATargetListNew`
- `sp_Get_MileageAppData`
- `sp_Get_MileageClaim_ById`
- `sp_Get_MileageClaimList`
- `sp_Get_MileageClaimList_new`
- `sp_GET_MIOInfo`
- `sp_GET_MIOInfo_ByEmpId`
- `sp_GET_MIOInfo_ById`
- `sp_Get_MIOListByTerritoryId`
- `sp_Get_MIOWiseReceiveableReport`
- `sp_Get_MoneyReceiptReportAfterPaymentList`
- `sp_Get_MoneyReceiptReportAfterPaymentListforDALedger`
- `sp_Get_MoneyReceiptReportList`
- `sp_Get_MonthlyAllowance`
- `sp_Get_MonthlyAllowance_ById`
- `sp_Get_MonthlyAllowanceById`
- `sp_GET_MonthlyAllowanceList`
- `sp_Get_MonthlyExpenseEmpWiseMaster`
- `sp_Get_MonthlyExpenseEmpWiseMaster_Final`
- `sp_Get_MonthlyExpenseEmpWiseMaster_Mo`
- `sp_Get_MonthlyExpenseEmpWiseMaster_new`
- `sp_Get_MonthlyExpenseEmpWiseMasterff`
- `sp_Get_MonthlyExpenseEmpWiseTotal`
- `sp_Get_MonthlyInventoryReport`
- `sp_Get_MonthlyInventoryReport_Back`
- `sp_Get_MonthlyInventoryReportBatchWise`
- `sp_GET_MonthwiseSale`
- `sp_Get_MSList_Approve`
- `sp_GET_NationalList`
- `sp_Get_NationalTargetAmount`
- `sp_Get_NewReceiveableList`
- `sp_Get_NewReceiveableListforInvoice`
- `sp_Get_NewReceiveableListWeb`
- `sp_Get_Notice_ById`
- `sp_GET_NoticeDetailMarket_ById`
- `sp_Get_Noticedetails_By_NoticeId`
- `sp_Get_NoticeImage_By_NoticeId`
- `sp_Get_NoticeMaster`
- `sp_Get_NoticeMaster_ById`
- `sp_GET_NoticeSeen_ById`
- `sp_GET_NSMHeadInfo`
- `sp_GET_NSMInfo`
- `sp_GET_NSMInfo_ByEMPId`
- `sp_GET_NSMInfo_ById`
- `sp_Get_OfferTypeInfo`
- `sp_Get_Order_Info_WebAPI_NEw`
- `sp_Get_Order_Info_WebAPI_NEw_MIo`
- `sp_Get_Order_Info_WebAPI_NEw_MIo_ByMonthYear`
- `sp_Get_OrderDelTrackingList`
- `sp_Get_OrderDetailsTrackingList`
- `sp_Get_OrderNoforReturn`
- `sp_Get_OrderNoforReturnDistributionRouteId`
- `sp_Get_OrderRecordMonthly`
- `sp_Get_OrderRecordMonthlyDashboard`
- `sp_Get_OrderRecordMonthlyDashboard_Depo`
- `sp_Get_OrderRecordMonthlyDashboard_New`
- `sp_Get_OrderRecordMonthlyDashboardMonthWise`
- `sp_Get_OrderTrackingList`
- `sp_Get_OrderTrackingList_DBH`
- `sp_Get_OrderTrackingList_Latest`
- `sp_GET_packSize`
- `sp_GET_PackSize_ById`
- `sp_GET_PackSizeActiveForDDL`
- `sp_Get_PaymentBrandWiseOrderDashboard`
- `sp_GET_PaymentInvSP`
- `sp_GET_PaymentInvSP_DA`
- `sp_GET_PaymentInvSPNew`
- `sp_GET_PaymentInvSPPaymentAmount`
- `sp_GET_PaymentInvSPSndReturn`
- `sp_GET_PaymentInvSPTPVATAmt`
- `sp_GET_PendingSalesConfirmationReport`
- `sp_Get_Prescription_ByPrescriptionId`
- `sp_Get_PrescriptionApp`
- `sp_Get_PrescriptionDetails_ByPrescriptionId`
- `sp_Get_PrescriptionList`
- `sp_Get_PrescriptionList_ForApproval`
- `sp_Get_PrescriptionType_ById`
- `sp_Get_PrescriptionType_For_DDL`
- `sp_Get_PrescriptionTypeList`
- `sp_Get_Product_Active`
- `sp_Get_Product_All`
- `sp_Get_product_ByCode`
- `sp_Get_Product_For_DDl`
- `sp_Get_Product_ForTargetSetup_DDL`
- `sp_Get_Product_List`
- `sp_GET_ProductAllForDDL`
- `sp_GET_ProductBrand`
- `sp_GET_ProductBrand_ById`
- `sp_GET_ProductBrandActiveForDDL`
- `sp_GET_ProductCategory`
- `sp_GET_ProductCategory_ById`
- `sp_GET_ProductCategoryActiveForDDL`
- `sp_Get_productForDDL`
- `sp_GET_ProductGroup`
- `sp_GET_ProductInfo`
- `sp_GET_ProductInfo_ById`
- `sp_GET_ProductLine`
- `sp_GET_ProductLine_ById`
- `sp_GET_ProductLineList`
- `sp_GET_ProductNameList`
- `sp_GET_ProductQuotedPrice`
- `sp_GET_productQuotedPrice_ById`
- `sp_GET_ProductRelatedValue_ById`
- `sp_GET_ProductType`
- `sp_GET_ProductType_ById`
- `sp_GET_ProductTypeActiveForDDL`
- `sp_Get_ProductWiseOrderDashboard`
- `sp_Get_ProductWiseOrderPaymentDashboard`
- `sp_Get_ProformaInvoiceReportList`
- `sp_Get_ProformaInvoiceReportList_Search`
- `sp_GET_ProgramType_ById`
- `sp_GET_ProgramtypeInfo`
- `sp_GET_ProgramTypeList`
- `sp_GET_ProgramTypeListAll`
- `sp_GET_ProgramTypeListByDateRange`
- `sp_GET_ProgramTypeListByMonthYear`
- `sp_GET_ProgramTypeListParm`
- `sp_GET_ProgramTypeWithoutGeneralList`
- `sp_Get_ProviderDropoutIntrigrationList`
- `sp_Get_QuotedPriceDetailById`
- `sp_Get_QuotedPriceMaster`
- `sp_GET_QuotedPriceMaster_ById`
- `sp_GET_ReferInstitution`
- `sp_GET_ReferInstitution_ById`
- `sp_Get_ReplaceNoteReport`
- `sp_GET_ReturnReasonAnalysis`
- `sp_GET_RoleType`
- `sp_Get_RoleTypeByEmpId`
- `sp_Get_RouteInfoforBacktoReturn`
- `sp_Get_RouteInfoforCustPayment`
- `sp_Get_RouteInfoforCustPaymentSnd`
- `sp_Get_RouteInfoforReturn`
- `sp_Get_RouteInfoforReturn2ndTimes`
- `sp_GET_RouteInformationDADetail_ById`
- `sp_GET_RouteInformationDADetailDDL`
- `sp_GET_RouteInformationMarketDetail_ById`
- `sp_GET_RouteInformationMaster_ById`
- `sp_Get_RouteInformationMasterList`
- `sp_Get_RouterMaster_ByRouterMasterId`
- `sp_GET_RouterMasterInfo`
- `sp_Get_RouteTypeInfo`
- `sp_Get_RPT_PaymentSC_Param`
- `sp_Get_RPT_SC_CustomerFinalPaymentReport`
- `sp_Get_RPT_SC_CustomerFinalPaymentReport_new`
- `sp_GET_RSMInfo`
- `sp_Get_SalesAssistantDAAmountClaimConfigById`
- `sp_Get_SalesAssistantDAAmountClaimConfigList`
- `sp_GET_SalesCampaignNonCampaign_BI`
- `sp_GET_SalesFCBNonFCB_BI`
- `sp_Get_SalesRecordMonthly`
- `sp_Get_SalesRecordMonthly_New`
- `sp_Get_SalesRecordMonthlyDayWsie`
- `sp_Get_SalesRecordMonthlyDayWsie_New`
- `sp_Get_SalesRecordMonthlyDayWsiePayment`
- `sp_Get_SalesRejectionReportList`
- `sp_Get_SalesRejectionReportListLAtest`
- `sp_Get_SalesReturnAppLogDetailQty`
- `sp_Get_SalesReturnRecordMonthly_New`
- `sp_Get_SalesReturnReport`
- `sp_Get_SalesReturnReport_fix`
- `sp_Get_SalesReturnReport_kooo`
- `sp_Get_SampleStockReport`
- `sp_Get_SAP_DICStockReceivePendingData`
- `sp_Get_SAP_EmpInfo`
- `sp_Get_SAP_EmpSApCodebyTerritory`
- `sp_Get_SAP_HideChallanByChallanNo`
- `sp_Get_SAP_IntrigationPointHeader`
- `sp_Get_SAP_ProductInfo`
- `sp_Get_SAP_StockReceivePendingData`
- `sp_Get_SAP_StockReceivePendingDataById`
- `sp_GET_ShippingCarton`
- `sp_GET_ShippingCartonActiveForDDL`
- `sp_GET_ShippingCartonSize_ById`
- `sp_GET_SMCFamilyDoctorLastProcessDate`
- `sp_GET_SMCType_ById`
- `sp_GET_SMCtypeInfo`
- `sp_GET_SMCTypeListByDateRange`
- `sp_GET_SMCTypeListMonthYear`
- `sp_GET_SMCTypeListParm`
- `sp_Get_StationType_Active`
- `sp_GET_StationType_ById`
- `sp_GET_StationTypeInfo`
- `sp_GET_StationTypeList`
- `sp_GET_StationTypeListAll`
- `sp_GET_StockUOMForDDL`
- `sp_GET_SubDepotByComUnitId`
- `sp_Get_SubmarketData_ById`
- `sp_Get_SubmarketList`
- `sp_Get_subTerritoryData_BySubTerritoryId`
- `sp_Get_SubTerritoryList`
- `sp_Get_TADAAppData`
- `sp_Get_TadaClaimList`
- `sp_Get_TadaClaimList_Approval`
- `sp_Get_TadaClaimList_new`
- `sp_Get_TadaClaimMaster_ById`
- `sp_Get_TADAMarketRuleConfig_For_DDL`
- `sp_Get_TADAMarketRulesConfig`
- `sp_Get_TADAMarketRulesConfig_ByID`
- `sp_GET_TargetEdit_ById`
- `sp_GET_TargetvsAchivement_BIReport`
- `sp_Get_TerritorryWiseSalesReportList`
- `sp_Get_TerritoryAll_ByAreaId`
- `sp_Get_TerritoryAll_ByAreaIdIsNotVaccant`
- `sp_Get_TerritoryAll_ByAreaIdIsVaccant`
- `sp_GET_TerriToryByDCId`
- `sp_GET_TerritoryByRouteInformationDDL`
- `sp_Get_TerritoryCodeByRoleTypeEmpId`
- `sp_Get_TerritoryCodeByRoleTypeEmpId_Active`
- `sp_Get_TerritoryData_ByTerritoryId`
- `sp_GET_TerritoryHR_ByTerritoryId`
- `sp_Get_TerritoryList`
- `sp_Get_TerritoryListOrdPerALL`
- `sp_Get_TerritoryTargetList`
- `sp_GET_TerritoryWiseDepotSetupList`
- `sp_Get_TerritoryWiseTargetList`
- `sp_Get_TerritoryWiseTargetSetup`
- `sp_GET_tFiscalYearList`
- `sp_Get_Thana_WithTagInfo`
- `sp_Get_Thana_WithTagInfo_TerritoryEdit`
- `sp_GET_ThanaInfo_ById`
- `sp_GET_ThanaList`
- `sp_Get_ThanaList_OnlyActive_Bydistrict_id`
- `sp_GET_TherapeuticGroup_ById`
- `sp_GET_TherapueticGroup`
- `sp_GET_TherapueticGroupActiveForDDL`
- `sp_Get_TopSellingProduct`
- `sp_GET_ToSheetcode_ById`
- `sp_Get_TotalCountForEmployee`
- `sp_Get_TourPlanApp`
- `sp_Get_TourPlanByTourPlanDate`
- `sp_Get_TourPlanDetailsById`
- `sp_Get_TourPlanMasteList`
- `sp_Get_TourPlanReportList`
- `sp_Get_TourPlanReportList__n`
- `sp_Get_TourPlanReportListNN`
- `sp_Get_TourPlanSummaryReport`
- `sp_Get_TourPlanTypeDDL`
- `sp_GET_TourPlanUserListByParm`
- `sp_Get_TourPlanYear`
- `sp_Get_TourPurpose`
- `sp_Get_TourPurpose_ById`
- `sp_Get_TourPurposeDDL`
- `sp_Get_TourPurposeDDLNew`
- `sp_Get_TourPurposeOtherSetupId`
- `sp_Get_TourSetupEmployeeList`
- `sp_Get_TourType`
- `sp_Get_TourType_ById`
- `sp_GET_TrainingDetailMarket_ById`
- `sp_Get_Trainning_ById`
- `sp_Get_Trainninglist`
- `sp_Get_TransitVSCollection_BI`
- `sp_Get_Transport`
- `sp_Get_Transport_ById`
- `sp_Get_TTargetAChivementReport`
- `sp_Get_TTargetAChivementReport_nnn`
- `sp_GET_UnitPrice_ById`
- `sp_GET_UnitPrice_ByProductId`
- `sp_GET_UnitpriceInfo`
- `sp_GET_UpazilaCoordinator`
- `sp_GET_UpdateCampaignType`
- `sp_GET_UpzilaCoordinator_ById`
- `sp_GET_UserDetailMarket_ById`
- `sp_GET_UserInfoAll`
- `sp_GET_UserList`
- `sp_Get_UserLocationTracking`
- `sp_GET_UserMaster_ByEmpId`
- `sp_GET_UserMaster_ById`
- `sp_GET_UserRoleDropDown`
- `sp_Get_UserRoleInfo`
- `sp_GET_UserRoleInfo_ById`
- `sp_GET_UserRoleInfoRoleType_ById`
- `sp_GET_UserRoleList`
- `sp_Get_UserRoles`
- `sp_Get_UserRolesbyid`
- `sp_GET_UserSettingPanel`
- `sp_Get_UserTypeInfo`
- `sp_GET_VacentArea`
- `sp_GET_VacentGroup`
- `sp_GET_VacentRegion`
- `sp_GET_VacentTerritory`
- `sp_GET_WebAPI_CheckList_GetAssignmentScreenData`
- `sp_Get_WeekNameInfo`
- `sp_GET_WingsSalesReport`
- `sp_GET_WingsSalesReportByCompany`
- `sp_GET_WingsSalesReportByUnit`
- `sp_Get_Zone_All_Active`
- `sp_Get_Zone_All_Active_ByGroup`
- `sp_Get_Zone_All_Active_ZoneTarget`
- `sp_Get_Zone_AllByGroup`
- `sp_Get_Zone_AllByGroupRpt`
- `sp_Get_Zone_ForDSM`
- `sp_Get_ZoneData_ByZoneId`
- `sp_Get_ZoneinfoByEmpId`
- `sp_Get_ZoneList`
- `sp_Get_ZoneListOrdPer`
- `sp_Get_ZoneTargetAmount`
- `sp_Get_ZoneWiseTargetList`
- `sp_GetChamber_ByDoctorId`
- `sp_GetCustomer_Doctor_TransferAppList`
- `sp_GetCustomer_Doctor_TransferList`
- `sp_GetCustomerAutoComplete`
- `sp_GetCustomerInvoiceLimitById`
- `sp_GetCustomerInvoiceLimits`
- `sp_GetCustomerProviderTypeApproveList`
- `sp_GetDatewithinDateRange`
- `sp_GetDCRDoctorWiseRpt`
- `sp_GetDCRRXDoctorWiseRptView`
- `sp_GetDoctorProviderTypeApproveList`
- `sp_GetFinalSales`
- `sp_GetInvoiceNotBindingById`
- `sp_GetInvoiceNotBindingList`
- `sp_GetLatestAppVersion`
- `sp_GetMarketInfoApprovalList`
- `sp_GetMarketwisePickingslipByBatchNo_daaw`
- `sp_GetMissingCustomerCount`
- `sp_GetOrderInvoiceIsZero`
- `sp_GetOrganogramreportList`
- `sp_GetRXDoctorWiseRpt`
- `sp_GetTopSheetByBatchNo_daaw`
- `sp_GetWarningForCustomerPayment`
- `sp_GetWarningForCustomerPayment_new`
- `sp_Rpt_AreawiseDoctorWeek`
- `sp_RPT_BusinessSummaryMISReport`
- `sp_Rpt_BusinessSummaryProductwise`
- `sp_RPT_ChallanStatusByDate`
- `sp_Rpt_DCRInfo_ById`
- `sp_RPT_DoctorInfo_Details`
- `sp_RPT_DoctorInfo_DOCWise`
- `sp_RPT_DoctorInfo_MIOWise`
- `sp_RPT_DoctorInfoReport`
- `sp_Rpt_DoctorwiseDoctorWeek`
- `sp_RPT_MIOWiseBusinessSummary`
- `sp_Rpt_MIOwiseDoctorWeek`
- `sp_RPT_MIS_BusinessSummary`
- `sp_RPT_MIS_BusinessSummary_Acc`
- `sp_RPT_MIS_ProductWiseSalesReport`
- `sp_RPT_MIS_RptMIOWiseReceiveableReport`
- `sp_RPT_MonthlyExpense`
- `sp_RPT_SalesConfirmStatusByDate`
- `sp_RPT_SalesReturnStatusByDate`
- `sp_Rpt_SMCFamilyDoctorReport`
- `sp_Rpt_SMCFamilyDoctorReport_ProcessData`
- `sp_Rpt_ZonewiseDoctorWeek`
- `sp_Rpt_ZonewiseDoctorWeek_New`
- `sp_RPTMonitoringReport`

</details>

<details><summary><strong>Write (sp_Save*/sp_Update*/sp_I_*/sp_UD_*/sp_CS_*)</strong> (336)</summary>


- `sp_CS_ASMInfo_Rpt`
- `sp_CS_CustomerType_All`
- `sp_CS_Department_Active`
- `sp_CS_Designation_Active`
- `sp_CS_FiscalYearInfo_Active`
- `sp_CS_GetArea_ByZoneId_Active`
- `sp_CS_GetArea_ByZoneId_All`
- `sp_CS_GetArea_ByZoneId_ForAMOnly`
- `sp_CS_GetArea_ByZoneId_Rpt`
- `sp_CS_GetDistributionRouteNameByMarketId`
- `sp_CS_GetEmpGeneralInfo_Active`
- `sp_CS_GetEmpGeneralInfo_All`
- `sp_CS_GetEmpGeneralInfo_AllFSS`
- `sp_CS_GetExpenseType_Active`
- `sp_CS_GetMarket_BySubTerritoryId_Active`
- `sp_CS_GetMarket_BySubTerritoryId_All`
- `sp_CS_GetMarket_BySubTerritoryId_Rpt`
- `sp_CS_GetMarket_ByTerritoryId_Active`
- `sp_CS_GetMarket_ByTerritoryId_ActiveNew`
- `sp_CS_GetMarket_ByTerritoryId_All`
- `sp_CS_GetSubMarket_ByMarketId_Active`
- `sp_CS_GetSubTerritory_ByTerritoryId_Active`
- `sp_CS_GetSubTerritory_ByTerritoryId_All`
- `sp_CS_GetSubTerritory_ByTerritoryId_Rpt`
- `sp_CS_GetTerritory_All`
- `sp_CS_GetTerritory_ByAreaId_Active`
- `sp_CS_GetTerritory_ByAreaId_ActiveForDepo`
- `sp_CS_GetTerritory_ByAreaId_All`
- `sp_CS_GetTerritory_ByAreaId_Rpt`
- `sp_CS_GetTerritoryWiseDistributnCenterbyTeritoryId`
- `sp_CS_GetZone_Active`
- `sp_CS_GetZone_ByGroupId_Active`
- `sp_CS_Group_Active`
- `sp_CS_Group_All`
- `sp_CS_Group_Rpt`
- `sp_CS_MIOInfo_BySC`
- `sp_CS_MIOInfo_Rpt`
- `sp_CS_National_Active`
- `sp_CS_NSMInfo_Rpt`
- `sp_CS_RoleType`
- `sp_CS_RoleTypeFSS`
- `sp_CS_RSMInfo_Rpt`
- `sp_CS_Shift_Active`
- `sp_CS_Thana_All`
- `sp_CS_TourPlanType_Active`
- `sp_CS_TourPlanType_All`
- `sp_CS_Transport_Active`
- `sp_CS_Transport_All`
- `sp_CS_UserInfo_Active`
- `sp_I_Customer`
- `sp_I_CustomerGl`
- `sp_I_DCStockOutInfo`
- `sp_I_DepotWiseArea`
- `sp_I_Diposit`
- `sp_I_Diposit_New`
- `sp_I_GWPStock`
- `sp_I_InvoiceAutoGeneration`
- `sp_I_InvoiceMaster`
- `sp_I_OrderMaster`
- `sp_I_PaymentDeleteLog`
- `sp_I_PrettyCashDetails`
- `sp_I_PrettyCashMaster`
- `sp_I_ProductGl`
- `sp_I_SampleProductIssue`
- `sp_I_SupplierGl`
- `sp_Save_ApprovalMapDetail`
- `sp_Save_ApprovalMapMaster`
- `sp_Save_AreaDistictRelation`
- `sp_Save_AreaInfo`
- `sp_Save_AreaWiseTargetSetup`
- `sp_Save_ASMInfo`
- `sp_Save_BDoctorChemberDetail`
- `sp_Save_BonusCampaignCustomerDetail`
- `sp_Save_BonusCampaignMarketDetail`
- `sp_Save_BonusCampaignNewDetail`
- `sp_Save_BonusCampaignNewDetail_Up`
- `sp_Save_BonusCampaignNewMaster`
- `sp_Save_CustomerMaster`
- `sp_Save_CustomerPropUpdateDetail`
- `sp_Save_CustomerPropUpdateMaster`
- `sp_Save_CustomerTypeInfo`
- `sp_Save_CustProductLineDetail`
- `sp_Save_DAInfo`
- `sp_Save_DcWiseTerritoryDetail`
- `sp_Save_DcWiseTerritoryMaster`
- `sp_Save_DepartmentInfo`
- `sp_Save_DesignationInfo`
- `sp_Save_DistictInfo`
- `sp_Save_DistrictCoordinator`
- `sp_Save_DivisionZoneRelation`
- `sp_Save_DoctorBrandDetail`
- `sp_Save_DoctorCategory`
- `sp_Save_DoctorChamber`
- `sp_Save_DoctorChemberDetail`
- `sp_Save_DoctorContactDetail`
- `sp_Save_DoctorContactDetail_New`
- `sp_Save_DoctorCustomer`
- `sp_Save_DoctorDegree`
- `sp_Save_DoctorDegreeDetail`
- `sp_Save_DoctorDesignation`
- `sp_Save_DoctorInistitutionDetail`
- `sp_Save_DoctorMarketDetail`
- `sp_Save_DoctorMaster`
- `sp_Save_DoctorPatientType`
- `sp_Save_DoctorPropUpdateDetail`
- `sp_Save_DoctorPropUpdateMaster`
- `sp_Save_DoctorSpecialDay`
- `sp_Save_DoctorSpecialDayDetail`
- `sp_Save_DoctorSpecialDayDetails`
- `sp_Save_DoctorSpeciality`
- `sp_Save_DoctorSpecialityDetail`
- `sp_Save_DWSPMaster`
- `sp_Save_Employe_LeaveType_Infos`
- `sp_Save_Employee_Holiday`
- `sp_Save_EmployeeAllowanceDetail`
- `sp_Save_EmployeeAllowanceRelation`
- `sp_Save_EmployeeInformation`
- `sp_Save_EmployeeLeaveApplication`
- `sp_Save_ExpenseClaimDetails`
- `sp_Save_ExpenseClaimMaster`
- `sp_Save_ExpenseTypeDetails`
- `sp_Save_ExpenseTypeMaster`
- `sp_Save_FinancialYearInfo`
- `sp_Save_GenericGroup`
- `sp_Save_GroupInfo`
- `sp_Save_GroupWisePromoQty`
- `sp_Save_LeaveConfigDtl`
- `sp_Save_LeaveConfigFroenEmp`
- `sp_Save_LeaveConfigMaster`
- `sp_Save_Manufacturer`
- `sp_Save_MarketData`
- `sp_Save_MarketPropDetail`
- `sp_Save_MarketPropMaster`
- `sp_Save_MarketPropToTable`
- `sp_Save_MarketStationDetail`
- `sp_Save_MenuRole`
- `sp_Save_MileageClaim`
- `sp_Save_MIOInfo`
- `sp_Save_MonthlyAllowance`
- `sp_Save_MonthlyAllowanceDetail`
- `sp_Save_NationaltargetSetup`
- `sp_Save_Notice_MarketDetail`
- `sp_Save_NoticeDetails`
- `sp_Save_NoticeImage`
- `sp_Save_NoticeMaster`
- `sp_Save_NoticeUserRoleDetail`
- `sp_Save_NSMHeadInfo`
- `sp_Save_NSMInfo`
- `sp_Save_OrderPermission`
- `sp_Save_Prescription`
- `sp_Save_PrescriptionDetails`
- `sp_Save_PrescriptionMaster`
- `sp_Save_PrescriptionProductDetail`
- `sp_Save_PrescriptionType`
- `sp_Save_ProductBrand`
- `sp_Save_Productcategory`
- `sp_Save_ProductDCDetails`
- `sp_Save_ProductInfo`
- `sp_Save_ProductLine`
- `sp_Save_ProductType`
- `sp_Save_ProgramTypeInfo`
- `sp_Save_PromoMIOTagDetail`
- `sp_Save_PromoMIOTagMaster`
- `sp_Save_QuotedPrice`
- `sp_Save_QuotedPriceDetail`
- `sp_Save_QuotedPriceMaster`
- `sp_Save_ReferInstitution`
- `sp_Save_RouteInformationDADetail`
- `sp_Save_RouteInformationMarketDetail`
- `sp_Save_RouteInformationMaster`
- `sp_Save_RouteInformationWeekNameDetails`
- `sp_Save_RouteMarketDetail_TerritoryWise`
- `sp_Save_RouterDetails`
- `sp_Save_RouterMaster`
- `sp_Save_RSMInfo`
- `sp_Save_SalesAssistantDAAmountClaimConfig`
- `sp_Save_SalesConfirmResponseData`
- `sp_Save_SalesRetunResponseData`
- `sp_Save_ShiftInfos`
- `sp_Save_ShippingCartonSize`
- `sp_Save_SMCTypeInfo`
- `sp_Save_StationTypeInfo`
- `sp_Save_SubMarketData`
- `sp_Save_SubTerritoryInfo`
- `sp_Save_TadaClaimMaster`
- `sp_Save_TADAMarketRulesConfig`
- `sp_Save_tblMIATargetList`
- `sp_Save_tblMIATargetListNew`
- `sp_Save_TerritoryInfo`
- `sp_Save_TerritoryThanaRelation`
- `sp_Save_TerritoryWiseTargetSetup`
- `sp_Save_ThanaInfo`
- `sp_Save_TherapeuticGroup`
- `sp_Save_TopSheetGenReportCode`
- `sp_Save_TourPurpose`
- `sp_Save_TourSetupEmployee`
- `sp_Save_TourType`
- `sp_Save_TrainingMarketDetail`
- `sp_Save_TrainingUserRoleDetail`
- `sp_Save_Trainning`
- `sp_Save_Transport`
- `sp_Save_UnitPriceInfo`
- `sp_Save_UpazilaCoordinator`
- `sp_Save_UserCompanyUnit`
- `sp_Save_UserMarketDetail`
- `sp_Save_UserMaster`
- `sp_Save_UserMaster_New`
- `sp_Save_UserRoleInfo`
- `sp_Save_UserRoles`
- `sp_Save_ZoneInfo`
- `sp_Save_ZoneWiseTargetSetup`
- `sp_SaveLeaveAppLog`
- `sp_UD_ApiCustomerMaster`
- `sp_UD_ASMInfo`
- `sp_UD_CustomerCreditLimitExtension`
- `sp_UD_CustomerGl`
- `sp_UD_CustomerMaster`
- `sp_UD_CustomerTypeInfo`
- `sp_UD_DcStockOutApproval`
- `sp_UD_DepartmentInfo`
- `sp_UD_DepotWiseArea`
- `sp_UD_DesignationInfo`
- `sp_UD_DistictInfo`
- `sp_UD_DistrictCoordinator`
- `sp_UD_FinancialYearInfo`
- `sp_UD_FixedCustomer`
- `sp_UD_GenericGroup`
- `sp_UD_GroupInfo`
- `sp_UD_Insert_ASMInfo`
- `sp_UD_Insert_MIOInfo`
- `sp_UD_InvoicePayment`
- `sp_UD_Manufacturer`
- `sp_UD_MIOInfo`
- `sp_UD_NSMHeadInfo`
- `sp_UD_NSMInfo`
- `sp_UD_OrderIsSpecialApproval`
- `sp_UD_PackSize`
- `sp_UD_ProductBrand`
- `sp_UD_ProductCategory`
- `sp_UD_ProductInfo`
- `sp_UD_ProductLine`
- `sp_UD_productQuotedPrice`
- `sp_UD_ProgramTypeInfo`
- `sp_UD_ReceiveIdInDc`
- `sp_UD_ReceiveIdInDcOpeningBalance`
- `sp_UD_ReferInstitution`
- `sp_UD_RegularCustomer`
- `sp_UD_ResetPaymentExtra`
- `sp_UD_RouteInformationMaster`
- `sp_UD_RSMInfo`
- `sp_UD_SampleStockIssue`
- `sp_UD_ShippingCarton`
- `sp_UD_SMCTypeInfo`
- `sp_UD_StationTypeInfo`
- `sp_UD_StockBatch`
- `sp_UD_StockBatch_new`
- `sp_UD_SubDcStockOutApproval`
- `sp_UD_tblCustMaster`
- `sp_UD_ThanaInfo`
- `sp_UD_TherapeuticGroup`
- `sp_UD_UnitPriceInfo`
- `sp_UD_UpazilaCoordinator`
- `sp_UD_UserRoleInfo`
- `sp_Update_AreaInfo`
- `sp_Update_ASMActiveStatus`
- `sp_Update_BonusCampaignNewMaster`
- `sp_Update_BonusCampaignpkCampaignSetupId`
- `sp_Update_Customer_Doctor_Transfer`
- `sp_Update_Customer_Doctor_TransferApprove`
- `sp_Update_Customer_Doctor_TransferApproveNew`
- `sp_Update_CustomerInfoForMarketData`
- `sp_Update_CustomerMaster`
- `sp_Update_CustomerProgramType`
- `sp_Update_CustPropUpdate`
- `sp_Update_DAExpenseClaimApprovalStatus`
- `sp_Update_DAInfo`
- `sp_Update_DcWiseTerritoryMaster`
- `sp_Update_DoctorCategory`
- `sp_Update_DoctorChamber`
- `sp_Update_DoctorDegree`
- `sp_Update_DoctorDesignation`
- `sp_Update_DoctorMaster`
- `sp_Update_DoctorPatientType`
- `sp_Update_DoctorPropUpdate`
- `sp_Update_DoctorSpecialDay`
- `sp_Update_DoctorSpeciality`
- `sp_Update_Employee_Holiday`
- `sp_Update_Employee_Leave_info`
- `sp_Update_Employee_ShiftInfos`
- `sp_Update_EmployeeInformation`
- `sp_Update_ExpenseClaim`
- `sp_Update_ExpenseType`
- `sp_Update_ExpenseTypeDetails`
- `sp_Update_InvoiceFinalPayment`
- `sp_Update_MarketData`
- `sp_Update_MarketStructure_Approve`
- `sp_Update_MarketStructure_Transfer`
- `sp_Update_MileageClaim`
- `sp_Update_MIOActiveStatus`
- `sp_Update_MonthlyAllowance`
- `sp_Update_NoticeMaster`
- `sp_Update_OrderDC`
- `sp_Update_Prescription`
- `sp_Update_PrescriptionMaster`
- `sp_Update_PrescriptionType`
- `sp_Update_PromoEmployeeQty`
- `sp_Update_PromoMIOTagMaster`
- `sp_Update_QuotedPriceMaster`
- `sp_Update_RouterMaster`
- `sp_Update_RSMActiveStatus`
- `sp_Update_SubTerritoryData`
- `sp_Update_TadaClaimMaster`
- `sp_Update_TADAMarketRulesConfig`
- `sp_Update_TargetInfo`
- `sp_Update_TerritoryData`
- `sp_Update_TourPurpose`
- `sp_Update_TourSetupEmployee`
- `sp_Update_TourType`
- `sp_Update_Trainning`
- `sp_Update_Transport`
- `sp_Update_UserMaster`
- `sp_Update_UserMaster_new`
- `sp_Update_Zero_PaymentInfo`
- `sp_Update_ZoneInfo`
- `sp_UpdateAndInsertInvoiceDetailSalesReturn`
- `sp_UpdateBacktoReturnPage`
- `sp_UpdateBlueandGreenstarEmpType`
- `sp_UpdateCustomerInvoiceLimit`
- `sp_UpdateDeliveryamout`
- `sp_UpdateDICApprovalStatus`
- `sp_UpdateDICApprovalStatus_SalesReturn`
- `sp_UpdateDiscountForInstrituteBusiness`
- `sp_UpdateInvoiceNotBinding`
- `sp_UpdateNegativeStock`
- `sp_UpdatenullInvoiceStatus`
- `sp_UpdateOpeningBalanceStockQty`

</details>

<details><summary><strong>Web API (sp_Webapi*)</strong> (333)</summary>


- `sp_Webapi_check_Customer`
- `sp_Webapi_Check_DcrProduct`
- `sp_Webapi_check_ExpenseClaim`
- `sp_Webapi_Check_ProductActiveorGift`
- `sp_Webapi_Check_ProductActiveorNot`
- `sp_Webapi_Check_ProductActiveorNotEmpId`
- `sp_Webapi_Check_ProductGiftActiveorNotEmpId`
- `sp_Webapi_CheckFakeMarket`
- `sp_Webapi_CheckGhorShajai2RestrictProducts`
- `sp_Webapi_CheckGhorShajai3RestrictProducts`
- `sp_Webapi_CheckGiftProduct`
- `sp_Webapi_CheckGRestrictProductsByCustYpeID`
- `sp_Webapi_CheckOld_Password`
- `sp_Webapi_CheckWhocanSubmitOrder`
- `sp_Webapi_CHK_PROMOProductQty`
- `sp_webapi_CompanyUnitAllNN`
- `sp_Webapi_Del_TourPlanInfoForEmpDate`
- `sp_Webapi_Delete_Dcr`
- `sp_Webapi_Delete_DoctorTourPlan`
- `sp_Webapi_Delete_ExpenseClaim`
- `sp_Webapi_Delete_LeaveInfo`
- `sp_Webapi_Delete_OrderDetail`
- `sp_Webapi_delete_TourPlanData`
- `sp_Webapi_FinalSubmitSend_Check`
- `sp_Webapi_FinalSubmitSend_DWSP`
- `sp_Webapi_FinalSubmitSend_TourPlan`
- `sp_Webapi_Get_AllApprovalPendingInfo`
- `sp_Webapi_Get_AllLeaveRecords`
- `sp_Webapi_Get_AMMultipleArea`
- `sp_Webapi_Get_AttendanceInfo`
- `sp_Webapi_Get_AttendanceInformation`
- `sp_Webapi_Get_AttendanceInformation2`
- `sp_Webapi_Get_AttendanceInformation3`
- `sp_Webapi_Get_BonusCampaingData`
- `sp_Webapi_Get_BSPDistrict`
- `sp_Webapi_Get_BSPDivisionAll`
- `sp_Webapi_Get_BSPThana`
- `sp_Webapi_GET_CampaignDetail_ById`
- `sp_Webapi_Get_CampaignMasterCheck`
- `sp_Webapi_Get_CampaignMasterInfo`
- `sp_Webapi_Get_CampaignMasterInfoMultiPro`
- `sp_Webapi_Get_CampaignMasterInfoProForProduct`
- `sp_Webapi_Get_CampaignNCOD`
- `sp_Webapi_Get_CampaingData`
- `sp_Webapi_Get_CampaingDetail`
- `sp_Webapi_Get_CampaingDetailParam`
- `sp_Webapi_Get_Chamber_ByDoctorId`
- `sp_Webapi_Get_ChamberName`
- `sp_Webapi_Get_CustomerAll`
- `sp_Webapi_Get_CustomerAllIsMarketUpdate2022`
- `sp_Webapi_Get_CustomerApp`
- `sp_Webapi_Get_CustomerByMarketId`
- `sp_Webapi_Get_CustomerCampaignData`
- `sp_Webapi_Get_CustomerInfos`
- `sp_Webapi_Get_CustomerPendingReject`
- `sp_Webapi_Get_CustomerType`
- `sp_Webapi_Get_DayName`
- `sp_Webapi_Get_DCRApp`
- `sp_Webapi_Get_DCRBrandList`
- `sp_Webapi_Get_DCRInfoListbyDcrId`
- `sp_Webapi_Get_DcrListById`
- `sp_Webapi_Get_DcrProductByType`
- `sp_Webapi_Get_DCRProductList`
- `sp_Webapi_Get_DCRVisitedWithList`
- `sp_Webapi_Get_DICcheck`
- `sp_Webapi_Get_District`
- `sp_Webapi_Get_DistrictByDivisionId`
- `sp_Webapi_Get_DivisionAll`
- `sp_Webapi_Get_DoctorAll`
- `sp_Webapi_Get_DoctorAllIsMarketUpdate2022`
- `sp_Webapi_Get_DoctorBrand`
- `sp_Webapi_Get_DoctorBrandByDoctorId`
- `sp_Webapi_Get_DoctorCategory`
- `sp_Webapi_Get_DoctorChamber`
- `sp_Webapi_Get_DoctorChamberByDocId`
- `sp_Webapi_Get_DoctorChember_AppLog`
- `sp_Webapi_Get_DoctorClaimApp`
- `sp_Webapi_Get_DoctorContact_AppLog`
- `sp_Webapi_Get_DoctorContactType`
- `sp_Webapi_Get_DoctorDegree`
- `sp_Webapi_Get_DoctorDesignation`
- `sp_Webapi_Get_DoctoreVisitTypeForDcr`
- `sp_Webapi_Get_DoctorInstitute`
- `sp_Webapi_Get_DoctorList`
- `sp_Webapi_Get_DoctorMaster_AppLog`
- `sp_Webapi_Get_DoctorPendingReject`
- `sp_Webapi_Get_DoctorPlanByDate`
- `sp_Webapi_Get_DoctorProgramType`
- `sp_Webapi_Get_DoctorSpecialDay`
- `sp_Webapi_Get_DoctorSpecialDay_AppLog`
- `sp_Webapi_Get_DoctorSpeciality`
- `sp_Webapi_Get_DoctorType`
- `sp_Webapi_Get_DoctorVisitPlanMasterData`
- `sp_Webapi_Get_DoctorVisitType`
- `sp_Webapi_Get_DWSPApp`
- `sp_Webapi_Get_DWSPByDate`
- `sp_Webapi_Get_DWSPDetails`
- `sp_Webapi_Get_DZSMMultipleArea`
- `sp_Webapi_Get_EmpAllawance`
- `sp_Webapi_Get_EmpAllawance_Monthly`
- `sp_Webapi_Get_EmpAllawance_MonthYear`
- `sp_Webapi_Get_EmployyeMonthlyExpense`
- `sp_Webapi_Get_EmployyeMonthlyExpenseSum`
- `sp_Webapi_Get_ExpanseClaimApp`
- `sp_Webapi_Get_ExpenseClaimList`
- `sp_Webapi_Get_ExpenseClaimListDetaisl`
- `sp_Webapi_Get_ExpenseClaimMasterDataById`
- `sp_Webapi_Get_ExpenseType`
- `sp_Webapi_Get_ExpenseTypebyRoleEmp`
- `sp_Webapi_Get_ExpenseTypeByRoleType`
- `sp_Webapi_Get_ExpenseTypeDetails`
- `sp_Webapi_Get_ImagePath`
- `sp_Webapi_Get_Leave_AppLog`
- `sp_Webapi_Get_LeaveApproveById`
- `sp_Webapi_Get_LeaveConType`
- `sp_Webapi_Get_LeaveEditData`
- `sp_Webapi_Get_LeaveRecords`
- `sp_Webapi_Get_LeaveType`
- `sp_Webapi_Get_LeaveTypeOld`
- `sp_Webapi_Get_MarketAttendanceMaxID`
- `sp_Webapi_Get_MarketByTerritoryId`
- `sp_Webapi_Get_MenuPermissionRolewise`
- `sp_Webapi_Get_MileageAppData`
- `sp_Webapi_Get_MileageClaimList`
- `sp_Webapi_Get_MileageDetailsByID`
- `sp_WebAPI_Get_MioDashboardTopBarData_New`
- `sp_WebAPI_Get_MioDashboardTopBarData_New_old`
- `sp_WebAPI_Get_MioDashboardTopBarData_OrdAtt`
- `sp_WebAPI_Get_MioDashboardTopBarDataWithoutOrd_Att`
- `sp_Webapi_Get_NonEffectiveReason`
- `sp_Webapi_Get_OnOffButtonForCustomerChange`
- `sp_Webapi_Get_OnOffButtonForCustomerChange_MS`
- `sp_Webapi_Get_OnOffButtonForDocChange`
- `sp_Webapi_Get_OnOffButtonForDocChange_MS`
- `sp_Webapi_Get_OrderApp`
- `sp_Webapi_Get_OrderDetailsById`
- `sp_WebAPI_Get_OrderinfoData_ById`
- `sp_Webapi_Get_PresCripProductbyId`
- `sp_Webapi_Get_PrescriptionApp`
- `sp_Webapi_Get_PrescriptionByPrescriptionIdId`
- `sp_Webapi_Get_PrescriptionDetails_AppLog`
- `sp_Webapi_Get_PrescriptionList`
- `sp_Webapi_Get_ProductGiftInactivePro`
- `sp_Webapi_Get_ProductInactiveName`
- `sp_Webapi_Get_ProductPrice`
- `sp_Webapi_Get_ProductPriceOld`
- `sp_Webapi_Get_ProgramType`
- `sp_Webapi_Get_ProviderType`
- `sp_Webapi_Get_PunchInOutStatus`
- `sp_Webapi_Get_RSM_DZSMByRole`
- `sp_Webapi_Get_RSM_DZSMcheck`
- `sp_webapi_Get_SampleStockReport`
- `sp_webapi_Get_SampleStockReport_new`
- `sp_Webapi_Get_Sation`
- `sp_Webapi_Get_Shift`
- `sp_Webapi_Get_SMCType`
- `sp_webapi_Get_StockReport`
- `sp_Webapi_Get_SubMarketByMarketId`
- `sp_Webapi_GET_TADAAmountByUser`
- `sp_Webapi_Get_TADAAppData`
- `sp_Webapi_Get_TADAClist`
- `sp_WebAPI_Get_TargetAChivementReport`
- `sp_Webapi_Get_TargetVsAcchivementData`
- `sp_Webapi_Get_Thana`
- `sp_Webapi_Get_TodaysTask`
- `sp_Webapi_Get_TodaysTaskforDCPCCP`
- `sp_Webapi_Get_TourPlanApp`
- `sp_Webapi_Get_TourPlanBalance`
- `sp_Webapi_Get_TourPlanBalanceEmp`
- `sp_Webapi_Get_TourPlanBalanceWithEmpInfo`
- `sp_Webapi_Get_TourPlanDataForTadaClaim`
- `sp_Webapi_Get_TourPlanInfo`
- `sp_Webapi_Get_TourPlanInfo_New`
- `sp_Webapi_Get_TourPlanInfo_Vthree`
- `sp_Webapi_Get_TourPlanInfoDetail`
- `sp_Webapi_Get_TourPlanInfoDetail_new`
- `sp_Webapi_Get_TourPlanMasterData`
- `sp_Webapi_Get_TourPlanPurpose`
- `sp_Webapi_Get_TourPlanPurposeForMarketVisit`
- `sp_Webapi_Get_TourPlanPurposeForOtherVisit`
- `sp_Webapi_Get_TourPlanType`
- `sp_Webapi_Get_TourTourPlanDetails`
- `sp_Webapi_Get_TPCustomerDetailList`
- `sp_Webapi_Get_TPMarketDetailList`
- `sp_Webapi_Get_TransportList`
- `sp_Webapi_Get_UserByRoleId`
- `sp_Webapi_Get_Userrole`
- `sp_Webapi_Get_VisitPlanApp`
- `sp_Webapi_Get_VisitTypeForDcr`
- `sp_Webapi_GET_WeekofYear`
- `sp_webapi_GetAllProducts`
- `sp_webapi_GetAllSampleProducts`
- `sp_WebAPI_GetAttendanceData_New`
- `sp_Webapi_GetBounsGiftList`
- `sp_Webapi_GetCampaignCustomer`
- `sp_Webapi_GetCampaignData`
- `sp_Webapi_GetCampaignDetail`
- `sp_Webapi_GetCampaignDetail_IsRatioInc`
- `sp_Webapi_GetCampaignFCFSCampainType`
- `sp_Webapi_GetCampaignTradePolicyPerc`
- `sp_Webapi_GetCampaignType3rd`
- `sp_Webapi_GetCampaignType3rd_WithoutTrade`
- `sp_Webapi_GetCollectionList`
- `sp_webapi_GetCustomerbyMobileNO`
- `sp_webapi_GetCustomerbyUser`
- `sp_webapi_GetCustomerbyUserOld`
- `sp_webapi_GetCustomerList`
- `sp_webapi_GetCustomerListByCusId`
- `sp_Webapi_GetCustWiseOrderReport`
- `sp_Webapi_GetCustWiseOrderReport_L`
- `sp_Webapi_GetCustWiseOrderReportSum`
- `sp_Webapi_GetCustWiseSalesReport`
- `sp_Webapi_GetCustWiseSalesReport_L`
- `sp_Webapi_GetCustWiseSalesReport_New`
- `sp_Webapi_GetCustWiseSalesReportSum`
- `sp_Webapi_GetDashboardSummary`
- `sp_Webapi_GetDashboardTiles`
- `sp_Webapi_GetDCStoreStockList`
- `sp_webapi_GetDoctorVisitDateById`
- `sp_webapi_GetDoctorVisitPlanMasterById`
- `sp_webapi_GetDWSPDateById`
- `sp_webapi_GetDWSPDetailById_new`
- `sp_webapi_GetDWSPMasterById`
- `sp_Webapi_GetEmpInfoRoleID`
- `sp_webapi_GetmarketNotice_ByEmpId`
- `sp_Webapi_GetMorningEveningTime`
- `sp_Webapi_GetNotification`
- `sp_Webapi_GetNotificationCount`
- `sp_Webapi_GetOrder_TrackingList`
- `sp_Webapi_GetOrder_TrackingListSummary`
- `sp_webapi_GetOrderCustMasterById`
- `sp_webapi_GetOrderMasterById`
- `sp_Webapi_GetOtherMarketVisitListTourPlanEditbyId`
- `sp_Webapi_GetProductWiseOrderReport`
- `sp_Webapi_GetProductWiseOrderReport_L`
- `sp_Webapi_GetProductWiseOrderReportSum`
- `sp_Webapi_GetProductWiseSalesReport`
- `sp_Webapi_GetProductWiseSalesReport_L`
- `sp_Webapi_GetProductWiseSalesReportSum`
- `sp_webapi_GetTADAAppDataById`
- `sp_Webapi_GetTeamList`
- `sp_Webapi_GetTerritoryByEmpId`
- `sp_webapi_GetTourPlanDateById`
- `sp_webapi_GetTourPlanDetailById`
- `sp_webapi_GetTourPlanDetailById_new`
- `sp_Webapi_GetTourPlanEditbyId`
- `sp_Webapi_GetTourPlanForWorkedwith`
- `sp_Webapi_GetTourPlanForWorkedwithCopy`
- `sp_webapi_GetTourPlanMasterById`
- `sp_webapi_GetTourPlanStatus`
- `sp_webapi_GetTraning_ByEmpId`
- `sp_webapi_GetvisitPlanDetailById_new`
- `sp_Webapi_LeaveReport`
- `sp_Webapi_LeaveReport_Details`
- `sp_Webapi_LeaveReport_New`
- `sp_Webapi_LeaveReport_Summary`
- `sp_Webapi_NotificationAllsent`
- `sp_Webapi_NotificationPost`
- `sp_Webapi_Save_Customer`
- `sp_Webapi_Save_DcrBrand`
- `sp_Webapi_Save_DcrInfo`
- `sp_Webapi_Save_DcrProduct`
- `sp_Webapi_Save_DcrVisitedWith`
- `sp_Webapi_Save_DCStoreTransaction`
- `sp_Webapi_Save_DoctorBrandDetail`
- `sp_Webapi_Save_DoctorChemberDetail`
- `sp_Webapi_Save_DoctorContactDetail`
- `sp_Webapi_Save_DoctorDegreeDetail`
- `sp_Webapi_Save_DoctorEntry`
- `sp_Webapi_Save_DoctorInstitutionDetail`
- `sp_Webapi_Save_DoctorSpecialDayDetail`
- `sp_Webapi_Save_DoctorSpecialityDetail`
- `sp_Webapi_Save_DoctorTypeDetail`
- `sp_Webapi_Save_DWSPMaster`
- `sp_Webapi_Save_EmpAppVersion`
- `sp_Webapi_Save_ExpenseClaimDetails`
- `sp_Webapi_Save_ExpenseClaimMaster`
- `sp_Webapi_Save_ExpenseClaimMasterissue`
- `sp_Webapi_Save_ExpenseClaimMasterOlddddddd`
- `sp_Webapi_Save_LeaveInfo`
- `sp_Webapi_Save_MileageClaim`
- `sp_Webapi_Save_Prescription`
- `sp_Webapi_Save_PrescriptionDetail`
- `sp_Webapi_Save_SynchronizationInfo`
- `sp_Webapi_Save_TadaClaim`
- `sp_Webapi_Save_TourPlanInfo`
- `sp_Webapi_Save_TourPlanInfo_Doctor`
- `sp_Webapi_Save_TourPlanInfo_Doctor_New`
- `sp_Webapi_Save_TourPlanInfo_new`
- `sp_Webapi_Save_TourPlanInfo_vThree`
- `sp_Webapi_Save_TPCustomerDetail`
- `sp_Webapi_Save_TPMarketDetail`
- `sp_Webapi_Save_UserDeviceToken`
- `sp_Webapi_Save_UserTracking`
- `sp_webapi_SaveAppLog`
- `sp_webapi_SaveCustomerAppLog`
- `sp_webapi_SaveDCRAppLog`
- `sp_webapi_SaveDoctorAppLog`
- `sp_webapi_SaveDWSPLog`
- `sp_webapi_SaveExpanseAppLog`
- `sp_webapi_SaveLeaveAppLog`
- `sp_webapi_SaveMileageAppLog`
- `sp_webapi_SaveOrderAppLog`
- `sp_webapi_SaveOrderCampaign`
- `sp_webapi_SaveOrderDetail`
- `sp_webapi_SaveOrderDetail_Doctor`
- `sp_webapi_SaveOrderDetail_Temp`
- `sp_webapi_SaveOrderMaster`
- `sp_webapi_SaveOrderMaster_Doctor`
- `sp_webapi_SavePrescriptionAppLog`
- `sp_webapi_SavePunchInInfo`
- `sp_webapi_SavePunchoutInfo`
- `sp_webapi_SavePunchTotalInfo`
- `sp_webapi_SaveTADAAppLog`
- `sp_webapi_SaveTourPlanAppLog`
- `sp_webapi_SaveVisitPlanAppLog`
- `sp_Webapi_UD_DoctorEntry`
- `sp_Webapi_UD_LeaveInfo`
- `sp_Webapi_Update_Customer`
- `sp_Webapi_Update_CustomerBSP`
- `sp_Webapi_Update_DoctorFinalSubmit`
- `sp_Webapi_Update_ExpenseClaim`
- `sp_Webapi_Update_LeaveData`
- `sp_Webapi_Update_MileageClaim`
- `sp_Webapi_Update_OrderMaster`
- `sp_Webapi_Update_Password`
- `sp_Webapi_UpdateCustomerMarket`
- `sp_Webapi_UpdateCustomerProvider`
- `sp_Webapi_UpdateDoctorMarket`
- `sp_Webapi_UpdateDoctorProvider`
- `sp_Webapi_UpdateNotice_EmployeeReadByEmpIdMasterId`
- `sp_Webapi_UpdateNotificationRead`
- `sp_Webapi_UpdateTraining_EmployeeReadByEmpIdMasterId`

</details>

<details><summary><strong>Existence/duplicate checks (sp_check*)</strong> (72)</summary>


- `sp_Check_anomalyInvoiceDetails`
- `sp_Check_anomalyInvoiceDetailsdddddddddd`
- `sp_Check_anomalyInvoiceDetailsfffffff`
- `sp_Check_anomalyInvoiceDetailsrecheck`
- `sp_check_AreaInfo`
- `sp_check_ASMInfo`
- `sp_check_Count_MarketStructure`
- `sp_check_CustomerType`
- `sp_check_da_UserInfo`
- `sp_check_da_UserInfo_Save`
- `sp_check_Department`
- `sp_check_Designation`
- `sp_check_DistictInfo`
- `sp_check_DistrictCoordinator`
- `sp_check_DoctorCategory`
- `sp_check_DoctorChamber`
- `sp_check_DoctorDegree`
- `sp_check_DoctorDegreeDetail`
- `sp_check_DoctorDesignation`
- `sp_check_DoctorPatientType`
- `sp_check_DoctorSpecialDay`
- `sp_check_DoctorSpeciality`
- `sp_Check_Duplicate_InvoiceFinalPayment`
- `sp_check_Employee_ShiftInfos`
- `sp_check_EmployeeAllowance`
- `sp_check_EmployeeInfo`
- `sp_check_ExpenseType`
- `sp_check_FinancialYear`
- `sp_check_GenericGroup`
- `sp_check_GroupInfo`
- `sp_check_Holiday`
- `sp_check_LeaveInfo`
- `sp_check_Manufacturer`
- `sp_check_MarketInfo`
- `sp_check_MIOInfo`
- `sp_check_MonthlyAllowance`
- `sp_check_MonthlyTarget`
- `sp_check_NSMHeadInfo`
- `sp_check_NSMInfo`
- `sp_check_PackZise`
- `sp_check_PrescriptionType`
- `sp_check_ProductBrand`
- `sp_check_ProductCategory`
- `sp_check_ProductInfo`
- `sp_check_ProductLine`
- `sp_check_Programtype`
- `sp_check_ReferInstitution`
- `sp_check_RouteInformationMArket`
- `sp_check_RouterMaster`
- `sp_check_RSMInfo`
- `sp_check_ShippingCarton`
- `sp_check_SMCtype`
- `sp_check_StationType`
- `sp_check_SubTerritoryInfo`
- `sp_check_TADAMarketRuleConfiguration`
- `sp_check_TerritoryInfo`
- `sp_check_ThanaInfo`
- `sp_check_TherapeuticGroup`
- `sp_Check_TourSetupEmployeeList`
- `sp_Check_TourSetupEmployeeListRoleType`
- `sp_check_Transport`
- `sp_check_Unitprice`
- `sp_check_UpazilaCoordinator`
- `sp_check_UserInfo`
- `sp_check_UserInfo_Save`
- `sp_check_UserRoleInfo`
- `sp_check_Vali_EmployeeInfoEntry`
- `sp_check_Vali_EmployeeInfoUpdate`
- `sp_check_Vali_MarketStructure`
- `sp_check_Vali_PromoMIOTag`
- `sp_check_ZoneInfo`
- `sp_checkIsDefault_CustomerType`

</details>

<details><summary><strong>Delete (sp_Delete*)</strong> (54)</summary>


- `sp_Delete_ByRoleIDTypeId`
- `sp_Delete_CustomerTypeInfo`
- `sp_Delete_DepartmnetInfo`
- `sp_Delete_DesignationInfo`
- `sp_Delete_DistrictCoordinator`
- `sp_Delete_DoctorCategory`
- `sp_Delete_DoctorChamber`
- `sp_Delete_DoctorDegree`
- `sp_Delete_DoctorDesignation`
- `sp_Delete_DoctorpatientType`
- `sp_Delete_DoctorSpecailDay`
- `sp_Delete_DoctorSpeciality`
- `sp_Delete_Employee_LeaveInfo`
- `sp_Delete_EmployeeInformation`
- `sp_Delete_ExpenseType`
- `sp_Delete_GroupInfo`
- `sp_Delete_MonthlyAllowance`
- `sp_Delete_NoticeMaster`
- `sp_Delete_Prescription`
- `sp_Delete_Prescription_All`
- `sp_Delete_PrescriptionDetailsWhenUpdate`
- `sp_Delete_PrescriptionType`
- `sp_Delete_PreviousmenuByRoleID`
- `sp_Delete_ProductDCDetails`
- `sp_Delete_ProformaInvoice`
- `sp_Delete_ProformaInvoice_SubDeport`
- `sp_Delete_TADAMarketRulesConfig`
- `sp_Delete_TourPurpose`
- `sp_Delete_TourType`
- `sp_Delete_Trainning`
- `sp_Delete_Transport`
- `sp_Delete_UpazilaCoordinator`
- `sp_DeleteArchiveAttendanceData`
- `sp_DeleteArchiveDBAttendanceData`
- `sp_DeleteArchiveDBDCRData`
- `sp_DeleteArchiveDBExpenseData`
- `sp_DeleteArchiveDBInvoiceData`
- `sp_DeleteArchiveDBOrderData`
- `sp_DeleteArchiveDBRxData`
- `sp_DeleteArchiveDBTourPlanData`
- `sp_DeleteArchiveDCRData`
- `sp_DeleteArchiveExpenseData`
- `sp_DeleteArchiveInvoiceData`
- `sp_DeleteArchiveOrderData`
- `sp_DeleteArchiveRxData`
- `sp_DeleteArchiveTourPlanData`
- `sp_DeleteCustomerInvoiceLimit`
- `sp_DeleteDeliveryInvoice`
- `sp_DeleteDeliveryInvoiceSubdepo`
- `sp_DeleteDwpotToWhChalan`
- `sp_DeleteInvoice`
- `sp_DeleteInvoiceNotBinding`
- `sp_Deletenvoice`
- `sp_DeleteOrder`

</details>

<details><summary><strong>Delete (sp_DEL*)</strong> (5)</summary>


- `sp_DEL_DelteCustPay`
- `sp_DEL_DuplicatePayment`
- `sp_DEL_NoticeImage`
- `sp_DEL_SampleStockIssue`
- `sp_DEL_TargetInfo`

</details>

<details><summary><strong>Status/approval transitions (sp_ActiveInactivate*/sp_Approve*)</strong> (26)</summary>


- `sp_ActiveInactive_customerType_ById`
- `sp_ActiveInactive_Department`
- `sp_ActiveInactive_DistrictCoordinator`
- `sp_ActiveInactive_employeeDesignation_ById`
- `sp_ActiveInactive_FinancialYear`
- `sp_ActiveInactive_GroupInfo`
- `sp_ActiveInactive_Holiday`
- `sp_ActiveInactive_Programtype`
- `sp_ActiveInactive_QuotedPrice`
- `sp_ActiveInactive_Stationtype`
- `sp_ActiveInactive_Transport`
- `sp_ActiveInactive_UpazilaCoordinator`
- `sp_Approve_DoctorInformation`
- `sp_Approve_EmployeeLeaveApplication`
- `sp_Approve_ExpenseClaim`
- `sp_Approve_Prescription`
- `sp_Approve_TADAClaim`
- `sp_ApproveAttendanceInformation`
- `sp_ApproveCustomerInformation`
- `sp_Approved_ExpenseReimbursmentFrom`
- `sp_ApproveDoctorTourPlanMaster`
- `sp_ApproveExpenseClaimInformation`
- `sp_ApproveMileageClaimInformation`
- `sp_ApprovePrescriptionInformation`
- `sp_ApproveTourPlanInformation`
- `sp_ApproveVisitPlanInformation`

</details>

<details><summary><strong>SAP Integration (sp_SAP*)</strong> (77)</summary>


- `sp_SAP_API_InsertProduct`
- `sp_SAP_API_usp_InsertUOMWithConversion`
- `sp_SAP_B2BChallanDetailInsert`
- `sp_SAP_B2BChallanMasterInsert`
- `sp_SAP_B2BStockReceiveByDc`
- `sp_SAP_BankDeposit_SAP_Process`
- `sp_SAP_BankDepositPosting`
- `sp_SAP_BankDepositSendtoSAP`
- `sp_SAP_ChallanMasterConfirm`
- `sp_SAP_ChallanSendDetailByChalanId`
- `sp_SAP_ChallanSendMaster`
- `sp_SAP_DeliveryCOnfirmatioinDtls`
- `sp_SAP_DeliveryCOnfirmatioinDtls_New`
- `sp_SAP_DeliveryCOnfirmatioinMaster`
- `sp_SAP_DeliveryCOnfirmatioinMaster_New`
- `sp_SAP_DeliveryConfirmationSales_Process`
- `sp_SAP_DeliveryConfirmationSales_ProcessNew`
- `sp_SAP_DeliveryInfo_prm`
- `sp_SAP_EmployeeAttData`
- `sp_SAP_EmployeeAttDataConfirm`
- `sp_SAP_Expiry_ProcessNew`
- `sp_SAP_ExpiryDtls_New`
- `sp_SAP_ExpiryReturn_New`
- `sp_SAP_InsertOrUpdateAreaAssign`
- `sp_SAP_InsertOrUpdateEmployee`
- `sp_SAP_InsertOrUpdateTerritoryAssign`
- `sp_SAP_InsertOrUpdateZoneAssign`
- `sp_SAP_Invoice_Process`
- `sp_SAP_InvoiceInfo`
- `sp_SAP_InvoiceInfo_prm`
- `sp_SAP_InvoiceItemByInvoiceId`
- `sp_SAP_NationalStockDtls`
- `sp_SAP_NationalStockList`
- `sp_SAP_NationalStockMaster`
- `sp_SAP_PaymentInfo_prm`
- `sp_SAP_RequisitionDetailUpdate`
- `sp_SAP_RequisitionMasterUpdate`
- `sp_SAP_Return_New`
- `sp_SAP_Return_ProcessNew`
- `sp_SAP_Return_ProcessNew2nd_Return`
- `sp_SAP_ReturnDtls_New`
- `sp_SAP_ReturnRecoveryDtls_New`
- `sp_SAP_ReturnRecoveryMaster_New`
- `sp_SAP_Returns_ExpiryDtls`
- `sp_SAP_Returns_ExpiryList`
- `sp_SAP_Returns_ExpiryMaster`
- `sp_SAP_SalesAdditionDtls`
- `sp_SAP_SalesAdditionList`
- `sp_SAP_SalesAdditionMaster`
- `sp_SAP_SalesDtls`
- `sp_SAP_SalesList`
- `sp_SAP_SalesMaster`
- `sp_SAP_SalesReturnDtls`
- `sp_SAP_SalesReturnMaster`
- `sp_SAP_Save_SAPSTODetail`
- `sp_SAP_Save_SAPSTOMaster`
- `sp_SAP_Save_StockMovementDetails`
- `sp_SAP_Save_StockMovementMaster`
- `sp_SAP_Save_StoInfo`
- `sp_SAP_StockInTransfer`
- `sp_SAP_StockInTransferUpdate`
- `sp_SAP_StockReceive`
- `sp_SAP_StockReceiveByDc`
- `sp_SAP_STODetails`
- `sp_SAP_STOList_prm`
- `sp_SAP_STOListAfterSave_prm`
- `sp_SAP_STOListDetails_prm`
- `sp_SAP_STOMaster`
- `sp_SAP_StoNoforChallanConfirm`
- `sp_SAP_StoNoforChallanConfirmDone`
- `sp_SAP_Up_SAP_ChallanConfirmByChalanId`
- `sp_SAP_Up_SAP_ChallanSendByChalanId`
- `sp_SAP_Up_StockReceiveQty`
- `sp_SAP_UpdateEmpTerritory`
- `sp_SAP_WHStockInApprove`
- `sp_SAP_WhStockInDetails`
- `sp_SAP_WhStockInMaster`

</details>

<details><summary><strong>Sales API (sp_SalesAPI*)</strong> (14)</summary>


- `sp_SalesAPI_doLogin`
- `sp_SalesAPI_doLogin_New`
- `sp_SalesAPI_doLoginCheckEMI`
- `sp_SalesAPI_doLoginMatch`
- `sp_SalesAPI_FieldForceArea`
- `sp_SalesAPI_FieldForceAsm`
- `sp_SalesAPI_FieldForceGroup`
- `sp_SalesAPI_FieldForceMarket`
- `sp_SalesAPI_FieldForceMio`
- `sp_SalesAPI_FieldForceNsm`
- `sp_SalesAPI_FieldForceRegion`
- `sp_SalesAPI_FieldForceRsm`
- `sp_SalesAPI_FieldForceSubTerritory`
- `sp_SalesAPI_FieldForceTerritory`

</details>

<details><summary><strong>DA (delivery agent) ops (sp_da*)</strong> (15)</summary>


- `sp_da_CheckUserForceLogout`
- `sp_da_INS_tblDeliveryLogin_appLog`
- `sp_da_INS_tblPaymentCollection_appLog`
- `sp_da_INS_tblSalesConfirmation_appLog`
- `sp_da_INS_tblSalesConfirmation_appLogDetail`
- `sp_da_INS_tblSalesReturn_appLog`
- `sp_da_INS_tblSalesReturn_appLogDetail`
- `sp_da_SalesAPI_doLogin`
- `sp_da_SAVE_DICApprovedDAClaimAmount`
- `sp_da_SAVE_DICApprovedDAClaimAmountLog`
- `sp_da_SAVE_ExpenseClaim_DA`
- `sp_da_SAVE_ExpiryReturnLog`
- `sp_da_SAVE_tblDAClaim`
- `sp_da_UPD_PaymentCollection_BankDeposit`
- `sp_da_UPDATE_ExpenseClaimImage`

</details>

<details><summary><strong>Processing/batch (sp_Process*)</strong> (14)</summary>


- `sp_Process_AutoWeekProcess`
- `sp_Process_DWSPReport`
- `sp_Process_DWSPReport_Territory`
- `sp_Process_DZSMwiseReportParam`
- `sp_Process_DZSMwiseReportParam_Backup`
- `sp_Process_DZSMwiseReportParam_New_Day`
- `sp_Process_EmpInfoInactive`
- `sp_Process_OrderIssubdeportFalse`
- `sp_Process_ProformaInvoiceByOrderId`
- `sp_Process_ProformaInvoiceByOrderId_OldTest`
- `sp_Process_ProformaInvoiceByOrderId_Pulak`
- `sp_Process_ProformaSampleInvoiceByOrderId`
- `sp_Process_SubDepoProformaInvoiceByOrderId`
- `sp_Process_YearlyLeaveBalance`

</details>

<details><summary><strong>Adjustment posting (sp_ADJ*)</strong> (12)</summary>


- `sp_ADJ_CustomerPaymentPosting`
- `sp_ADJ_DeliveryConfirmationFullPosting`
- `sp_ADJ_DeliveryConfirmationPartiallPosting`
- `sp_ADJ_DeliveryInvoiceDeletePosting`
- `sp_ADJ_DeliverySalesReturnPosting`
- `sp_ADJ_FreezeStockPosting`
- `sp_ADJ_FreezeStockReleasePosting`
- `sp_ADJ_ProductDestroyPosting`
- `sp_ADJ_ProformaFullReturnPosting`
- `sp_ADJ_ProformaPosting`
- `sp_ADJ_ProformaReturnPosting`
- `sp_ADJ_VoucherMasterDetailPosting`

</details>

<details><summary><strong>Business summary reports (sp_BusinessSumm*)</strong> (7)</summary>


- `sp_BusinessSummaryMISReport`
- `sp_BusinessSummaryMISReport_All`
- `sp_BusinessSummaryMISReport_All_New`
- `sp_BusinessSummaryMISReport_All_New_New`
- `sp_BusinessSummaryMISReport_Loading`
- `sp_BusinessSummaryMISReport_TT`
- `sp_BusinessSummaryMISReport_Zone`

</details>

<details><summary><strong>Delivery confirmation (sp_DeliveryConf*)</strong> (6)</summary>


- `sp_DeliveryConfirmationFullPosting`
- `sp_DeliveryConfirmationPartiallPosting`
- `sp_DeliveryConformationFull`
- `sp_DeliveryConformationFull_New`
- `sp_DeliveryConformationFull_OldData`
- `sp_DeliveryConformationReject`

</details>

<details><summary><strong>Order-list loaders (sp_LoadOrderLis*)</strong> (5)</summary>


- `sp_LoadOrderListForOrderCreation`
- `sp_LoadOrderListForOrderCreationbyTerri`
- `sp_LoadOrderListForOrderRouteDayWise`
- `sp_LoadOrderListForOrderRouteDayWiseN`
- `sp_LoadOrderListForOrderRouteDayWiseold`

</details>

<details><summary><strong>Dynamic pivot reports (DynamicPivot*)</strong> (24)</summary>


- `DynamicPivotBrandWiseDCR`
- `DynamicPivotBrandWiseRX`
- `DynamicPivotBrandWiseRX_new`
- `DynamicPivotDoctorWiseCVR`
- `DynamicPivotDoctorWiseCVR_New_ForSearch`
- `DynamicPivotDoctorWiseDCP`
- `DynamicPivotDoctorWiseDCPCustomerWise`
- `DynamicPivotDoctorWiseDCR`
- `DynamicPivotDoctorWiseDCR_New`
- `DynamicPivotDoctorWiseDCR_New_ForSearch`
- `DynamicPivotDoctorWiseDoctorVisitPlan`
- `DynamicPivotDoctorWiseRX`
- `DynamicPivotDoctorWiseRX_New`
- `DynamicPivotDWSP`
- `DynamicPivotProductdWiseDCR`
- `DynamicPivotProductdWiseRX`
- `DynamicPivotProductdWiseRX_New`
- `DynamicPivotTableInSql`
- `DynamicPivotUserandProductdWiseRX_New`
- `DynamicPivotUserWiseAttendance`
- `DynamicPivotUserWiseDCP`
- `DynamicPivotUserWiseDCR`
- `DynamicPivotUserWiseRX`
- `DynamicPivotUserWiseRX_New`

</details>

<details><summary><strong>Other / ungrouped</strong> (170)</summary>


- `AppMonitoringViewList`
- `AppMonitoringViewList_new`
- `AutoDeleteZeroPayment`
- `DateRange_To_TableBySL`
- `DynamicDateByDateRange`
- `DynamicDatebyMonthByDateRange`
- `DynamicDatebyMonthYear`
- `DynamicDatebyMonthYearForStuff`
- `DynamicVisitStatusReport`
- `ExecuteAllSqlQueryByStoreProcedure`
- `GetDynamicSalesReportList`
- `GetDynamicVisitStatusReportRX`
- `GetMonthYearValues`
- `InsertProcedureExecutionStats`
- `MakeRESTRequest`
- `sAlesAssistantDAClaimList`
- `sp_AreawiseDailyOpeningClosingStockDepowise`
- `sp_AreawiseDailyOpeningClosingStockNational`
- `sp_Auto_AutoStockUpdate`
- `sp_AutoInvoiceGeneration`
- `sp_BeforesndSalesReturnList`
- `sp_CampaignTypeUpdateFromBizmotion`
- `sp_CampaignUpdate`
- `sp_CampaignUpdateFromPage`
- `sp_CHK_DCWiseArea`
- `sp_Chk_SAP_EmpInfoCondition`
- `sp_CRRR_WrongPayment`
- `sp_CSOpeningBalanceProcess`
- `sp_CustomerLedger`
- `sp_CustomerLedgerNew`
- `sp_CustomerPaymentPosting`
- `sp_CustomerTransfer`
- `sp_CustomerTransferTagChange`
- `sp_Dashboar_ExpireProductList`
- `sp_Dashboar_TopCustomer`
- `sp_Dashboard_DepotSalesAndCollection`
- `sp_Dashboard_NationalProductSales`
- `sp_Dashboard_PriorityProductSales`
- `sp_Dashboard_TopCustomer`
- `sp_DCBinCard`
- `sp_DCStoreOpeningBalanceProcess`
- `sp_DefigitRecovery`
- `sp_Del_B2BDelete`
- `sp_Del_BonusCampaignNewMaster`
- `sp_DeliveryInvoiceCreationList`
- `sp_DeliveryInvoiceCreationList_DA`
- `sp_DeliveryInvoiceCreationList_New`
- `sp_DeliveryInvoiceDeletePosting`
- `sp_DeliveryReturn`
- `sp_DeliverySalesReturnPosting`
- `sp_DICByregionid`
- `sp_DSB_AglingReport`
- `sp_DSB_BusinessSummery`
- `sp_EmpGeneralInfoByEmployeeId`
- `sp_Execute_SingleOrder`
- `sp_ExpenseTypeDtl`
- `sp_FreezeStockPosting`
- `sp_FreezeStockReleasePosting`
- `sp_get_MIOInfoForTarget`
- `sp_HigharchyInfoByEmployeeId`
- `sp_ImportApiData`
- `sp_ImportApiData_Backup_10102019`
- `sp_InsertCustomerInvoiceLimit`
- `sp_InsertCustPayDetail_DeleteLog`
- `sp_InsertInvoiceNotBinding`
- `sp_InvoceLifecycle`
- `sp_InvoiceDelete_IfnoDetails`
- `sp_LoadingSummary`
- `sp_LoadingSummary_da`
- `sp_LoadSalesReturnReportSAP`
- `sp_MinusStockUpdatetoZero`
- `sp_MioUpdateInCustomerInfo`
- `sp_MiowiseMISReport`
- `sp_NonTranscationalInvoiceApproval`
- `sp_NTS_Group_Active`
- `sp_NumberofInvoiceandCust`
- `sp_OPAPI_GETCamaignDetail`
- `sp_OPAPI_GetCampaignMaster`
- `sp_OPAPI_GetQuotedPrice`
- `sp_OPAPI_updateCustomerLocation`
- `sp_opeingBalanceCreate`
- `sp_OrderGenerationFromUploadOrder`
- `sp_OrderGenerationFromUploadOrder_Backup`
- `sp_OrderGenerationFromUploadOrder_SingleOrder`
- `sp_OrderMonitoringPanel_Bizmotion`
- `sp_PartialUpdate`
- `sp_PaymentConformationFull`
- `sp_Pro_DZSMwiseReportParam`
- `sp_processDCRDCPRX`
- `sp_ProductDestroyPosting`
- `sp_ProductWiseBranchwiseBusinessSummaryMISReport`
- `sp_ProductWiseBusinessSummaryMISReport`
- `sp_ProductWiseBusinessSummaryMISReportByParam`
- `sp_Proforma`
- `sp_ProformaFullReturnPosting`
- `sp_ProformaPosting`
- `sp_ProformaReturnPosting`
- `sp_PROMOOpeningBalanceProcess`
- `sp_RecoverOrderInfo`
- `sp_RejectInvoiceDAPaymentCollection`
- `sp_RejectInvoiceDASalesConfirmStatus`
- `sp_RejectInvoiceDASalesReturn`
- `sp_Rep_DepopsitSlip_BusinessSummary`
- `sp_Rep_DepopsitSlip_BusinessSummaryClosingReport`
- `sp_RSMInfoByEmployeeId`
- `sp_Sales`
- `sp_SalesDepositOpeningBalanceProcess`
- `sp_SampleInvoicePosting`
- `sp_SInventory_DynamicMISReport`
- `sp_SInventory_DynamicMISReportTP`
- `sp_SInventory_DynamicMISReportUserWise`
- `sp_SInventory_DynamicMISReportUserWiseTP`
- `sp_SInventory_GetCustomerTypeReport`
- `sp_sp_DefigitRecovery_Details`
- `sp_Stock`
- `sp_StockInMIGOtoCentralStore`
- `sp_SubDCStoreOpeningBalanceProcess`
- `sp_SubdeportAreawiseDailyOpeningClosingStockNational`
- `sp_SubdeportDeliveryConformationFull`
- `sp_SubDeportDeliveryConformationReject`
- `sp_SubdeportProframTypeUpdate`
- `sp_Suport_IsInvoiceCorrectionOnOrder`
- `sp_Test_GenerateC#ModelFromTable`
- `sp_Up_BonusProducttoZero`
- `sp_Up_LeaveConfigMaster`
- `sp_UP_LoadingSummary`
- `sp_UP_LoadingSummaryFinal`
- `sp_Up_ProviderDropoutIntrigrationApprove`
- `sp_UP_UpdateVatandPrice`
- `sp_upd_30daysOrderInactive`
- `sp_UpDate_UserSettingPanel`
- `sp_Upsertdate_EmpInfo`
- `sp_Upsertdate_ProductInfo`
- `sp_ValidateCreditLimit`
- `sp_ValidateTimeOutOfRange`
- `sp_ValuewiseBusinessSummaryReport`
- `sp_VerifyCustomer`
- `sp_VerifyCustomerTagList`
- `sp_View_EmployeeLeaveBalance`
- `sp_WearhouseBinCard`
- `sp_web_SaveExpanseAppLog`
- `sp_web_SaveMileageAppLog`
- `sp_web_SaveTADAAppLog`
- `sp_WebAI_Get_TTargetAChivementReport`
- `sp_WebAPi_Get_PrescriptionType`
- `sp_WebAPi_GetOrderDetails_New`
- `sp_WebApi_GetVersion`
- `sp_WEBAPI_Process_DWSPReport`
- `sp_WEBAPI_Process_DWSPReportAM`
- `sp_WEBAPI_Process_DWSPReportDZSM`
- `sp_WebApi_SaveEPharmaPersonInfo`
- `sp_WebApi_SaveProviderDropoutIntrigration`
- `sp_WHBeenCard`
- `spGetPersonByDivisionDistrict`
- `spGetProviderTypeDeliveryNetAmointIntrigration`
- `spInsertReturnInvoice`
- `spInsertReturnInvoice_new`
- `spInsertTourPurposeOtherSetup`
- `spInsertTourPurposeOtherSetupDtl`
- `spUpdateTourPurposeOtherSetup`
- `UD_CustomerMaster`
- `UD_CustomerMaster2`
- `usp_CheckCampaignEntryDate`
- `usp_CheckCampaignList`
- `usp_CheckCampaignListByCustomerMasterId`
- `usp_GenerateCustomerCode`
- `usp_InsertTerritoryData`
- `usp_InsertUOMWithConversion`
- `usp_UpdateDistributionRoute_Ord`
- `View_Dashboard_BI`

</details>


## Frequently-referenced tables (curated highlights — full list is in `database-tables.md`)

| Category | Tables |
|---|---|
| Transactional core | `tblInvoice`, `tblInvoiceDetail`, `tblSubInvoiceMaster`, `tblSubInvoiceDetail`, `tblOrder`, `tblOrderDetail`, `tblReturnInvoice`, `tblReturnInvoiceDetail`, `tblInvoiceDetailReturn`, `tblInvoiceBatch`, `tblInvoiceNotBinding`, `tblCustomerInvoiceLimit` |
| Master/reference | `tblCustMaster`, `tblCustomerType`, `tblCustCategory`, `tblProduct`, `tblProductDiscount`, `tblProductSQ`, `tblManufacturer`, `tblUnitPrice`, `tblStockUOM`, `tblCompanyUnit`, `tblCompanyInfo`, `tblUser`, `tblEmpGeneralInfo`, `tblUserCompanyUnit`, `tblPaymentType`, `tblProgramType`, `tblDAInfo` |
| Geo/territory | `tblMarket`, `tblSubTerritory`, `tblTerritory`, `tblArea`, `tblRegion`, `tbl_Group`, `tbl_Thana`, `tbl_District`, `tbl_Division`, `tblDistrict`, `tblMarketStationDetail`, `tblStationType`, `tblRouteInformationMaster`, `tblRouteInformationDADetail`, `tblDistributionRoute` |
| Warehouse/stock/DC | `tblDCStore`, `tblDCStoreFreeze`, `tblDCPicking`, `tblCentralStore`, `tblStockInTransfar`, `tblWHStockInDetail`, `tblSubDepot`, `tblSubDepotStore`, `tblSubDepotStockOutMaster`, `tblSubDepotChalanInfo`, `tblDeStockOutMaster`, `tblMIAInfo`, `tblMIOInfo`, `tblMIGODetail`, `tblRequisition`, `tblRequsitionChild` |
| Payments/collections | `tblCustPayDetail`, `tblCustomerPay`, `tblCollection`, `tblCollectionSub`, `tblChalanInfo`, `tblChalanDetail`, `tblDepositOpeningBalance`, `tblCompanyWiseDeposit` |
| Campaign/menu/app-log | `tbl_BonusCampaignNewDetail`, `tblSubFixed`, `tblSubFixedPro`, `tblFixedPro`, `tblMainMenu`, `tblMainMenuNew`, `tblMenuRole`, `tblMenuDistribution`, `tblPaymentCollection_appLog`, `tblSalesConfirmation_appLog(Detail)`, `tblSalesReturn_appLog(Detail)`, `tblArcDBConnect`, `tblUserSessionTracking` |
| ASP.NET Identity (unused/legacy?) | `AspNetUsers` — schema matches the default ASP.NET Identity table (`Id`, `Email`, `PasswordHash`, `SecurityStamp`, lockout fields), but the app's actual auth is Forms Authentication against `tblUser` (see `docs/security.md`) — this table's presence with no observed C# `UserManager`/`Microsoft.AspNet.Identity` usage in `Library.DAL` suggests dead scaffolding from an early/abandoned auth approach, not a live table. Worth a quick grep confirmation before assuming it's inert. |

## DAO-to-table gaps (confirmed, not exhaustive)

`Library.DAO/SInventory_Entities/Invoice.cs` does not include `DA_SalesConfirmStatus`,
`DA_PaymentCollection`, or `DA_SalesReturn`, even though these columns are read/written directly by
`sp_RejectInvoiceDA*.sql` and now confirmed present on the live `tblInvoice` table (see
[`database-tables.md`](database-tables.md#tblinvoice)). Treat every DAO class in this repo as a
**possibly partial** view of its underlying table — column names/types are now easy to diff
directly against `database-tables.md` if a specific DAO class is in question.
