# Database Specification — Stored Procedures, Views, Functions (Live-Schema Verified)

> Regenerated from direct introspection of the live development SQL Server instance (`TOWSIF\MSSQLSERVER2019` / `SalesDisDB_SMC_NEWDB`) plus structural parsing of every file under `spec/database/{procs,views,functions}/` (1,870 procedure files, 58 view files, 43 function files — verified byte-for-byte object-count match against the live database; only 2 trivial filename-vs-live-object drifts found, noted in the Inconsistencies section below), cross-referenced against a whole-word scan of all C# (`Solution.Web`, `Library.DAL`, `Library.BLL`, `Library.DAO`, `Library.CrystalReports`) source for callers. This supersedes the prior version of this file.

**Methodology and coverage**: every object below has its *mechanical* facts (parameters, tables touched, CRUD operation flags, error-handling/transaction/dynamic-SQL/cursor presence, caller list) verified against the actual SQL text — this is complete for all 1,971 objects, not a sample. *Business-logic narrative* (what a procedure is actually for, in prose) is only practical to hand-write for a bounded subset at this scale (1,870 procedures); it is provided for procedures with a confirmed C# caller, grouped by the module that calls them, in the **Module deep-dives** section — this is the subset practically reachable through the application today. The remaining orphaned procedures (**810 of 1,870, 43%** — no caller found by name anywhere in the analyzed C# source) are listed by name only in the Orphan Inventory; some of these may be called by the external Flutter mobile app (which talks to `.asmx`/`.ashx` endpoints not fully traced to every downstream proc call in this pass) or by ad-hoc/manual execution rather than application code — treat "orphan" as "no static caller found", not a confirmed-safe-to-delete list. **Confirmed concrete case of a false-positive "orphan"**: `sp_SAP_WhStockInMaster`, `sp_SAP_WhStockInDetails`, `sp_SAP_STOMaster`, `sp_SAP_STODetails`, and `sp_SAP_StockInTransfer` all show up in the Orphan Inventory below (no *C#* caller), but `docs/ReceiveQty_RootCause_Analysis.md` traced them as live, frequently-executed procedures called only from *inside* `sp_SAP_StockReceive` (itself called from `SAP_IntrigationPointDAL.SaveStockReceive`) — this scan does not follow proc-to-proc `EXEC` chains, so "orphan" specifically undercounts procedures reachable only via another procedure, a distinct category from truly-uncalled code.

## Summary statistics

- **1870 stored procedures** (1060 with a confirmed C# caller, 810 orphaned)
- **58 views** (11 called directly from C#, 25 referenced from inside another proc/view, 27 with no reference found anywhere)
- **43 functions** (3 called directly from C#, 18 referenced from inside another proc/view, 22 with no reference found anywhere)
- **27 of 1870 procedures (1%) use TRY/CATCH error handling**
- **25 of 1870 procedures (1%) use an explicit transaction** (`BEGIN TRAN`)
- **299 of 1870 procedures (15%) build/execute dynamic SQL** (`EXEC(@...)`/`sp_executesql`) — see `spec/business-rules.md` and security notes
- **135 procedures use a CURSOR** (re-verified by direct `grep` for `DECLARE ... CURSOR`/`CURSOR FOR`/`CURSOR FAST_FORWARD` across every file in `spec/database/procs/`; the previous "17" figure undercounted by 8x — most of the missed cursor-using procedures are orphaned `sp_ADJ_*`/`sp_*Posting`/`sp_DeleteArchive*` procs that are listed name-only in the Orphan Inventory below, which doesn't carry per-procedure TC/TX/DYN/CUR flags, so they weren't reflected in whatever partial count produced "17")
- Only **3 foreign keys** and **0 triggers** exist across the entire 570-table schema (see `spec/database-tables.md`) — referential integrity is almost entirely unenforced at the database level; whatever integrity exists is enforced (or not) inside these procedures.
- All of the above counts are for `SalesDisDB_SMC_NEWDB` only. A **second, separate database, `SAP_API_Data`**, is cross-database queried (`SAP_API_Data..tableName` syntax) by at least 16 procedures in this inventory (the `sp_SAP_*`/`sp_Get_SAP_*` stock-receive family plus `MakeRESTRequest`) — see the dedicated `SAP_API_Data` section at the end of `spec/database-tables.md` and `spec/integrations.md` §1. It was not introspected as part of this file's live-schema pass.

## Inconsistencies found between checked-in SQL files and the live database

- `usp_process_Update_DistributionRoute` exists live but has no corresponding file under `spec/database/procs/` — either deleted from disk after being deployed, or deployed directly via SSMS without being saved to the repo.
- `spec/database/procs/sp_Process_ProformaInvoiceByOrderId_backup_20260808_pre_stockfix.sql` exists on disk but is **not a live database object** — a manually-saved backup copy of `sp_Process_ProformaInvoiceByOrderId` taken before an edit, left in the folder. Not a real procedure; excluded from the inventory below.
- All 58 views and 43 functions match exactly between disk and live database — no drift.

---

## Stored procedure inventory, by dominant calling module

"Dominant calling module" = the `Library.DAL`/`Library.BLL`/`Solution.Web` subfolder that references this procedure name the most times, among procedures with at least one confirmed caller. Ops legend: **S**=SELECT, **I**=INSERT, **U**=UPDATE, **D**=DELETE, **M**=MERGE. TC=has TRY/CATCH, TX=has explicit transaction, DYN=builds dynamic SQL, CUR=uses a cursor.

### DoctorModule_DAL (488 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `AppMonitoringViewList` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpAppVersion, tblEmpGeneralInfo, tblSynchronizationInfo, tbl_UserRoleInfo, tbluser | `spec/database/procs/AppMonitoringViewList.sql` |
| `AppMonitoringViewList_new` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tbl_UserRoleInfo, tbluser | `spec/database/procs/AppMonitoringViewList_new.sql` |
| `sp_ActiveInactive_Department` | @DeptId INT, @InactiveBy INT | SU |  |  |  |  | tblDepartment | `spec/database/procs/sp_ActiveInactive_Department.sql` |
| `sp_ActiveInactive_employeeDesignation_ById` | @DesignationId INT, @InactiveBy INT | SU |  |  |  |  | tblDesignation | `spec/database/procs/sp_ActiveInactive_employeeDesignation_ById.sql` |
| `sp_ActiveInactive_FinancialYear` | @Id INT, @InactiveBy INT | SU |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_ActiveInactive_FinancialYear.sql` |
| `sp_ActiveInactive_GroupInfo` | @Id INT, @InactiveBy INT | SU |  |  |  |  | tbl_Group | `spec/database/procs/sp_ActiveInactive_GroupInfo.sql` |
| `sp_ActiveInactive_Holiday` | @HolidayId INT, @InactiveBy INT | SU |  |  |  |  | Employee_GovtHolidays | `spec/database/procs/sp_ActiveInactive_Holiday.sql` |
| `sp_ActiveInactive_Transport` | @LeaveTypeId INT, @InactiveBy INT | SU |  |  |  |  | Employe_LeaveTypeInfos | `spec/database/procs/sp_ActiveInactive_Transport.sql` |
| `sp_Approve_DoctorInformation` | @DoctorId NVARCHAR, @ApprovedBy NVARCHAR | SU |  |  |  |  | fnSplit, tblDoctorMaster | `spec/database/procs/sp_Approve_DoctorInformation.sql` |
| `sp_Approve_TADAClaim` | @TadaID NVARCHAR, @ApprovedBy NVARCHAR | SU |  |  |  |  | fnSplit, tbl_TadaClaimMaster | `spec/database/procs/sp_Approve_TADAClaim.sql` |
| `sp_ApproveAttendanceInformation` | @AttendanceId NVARCHAR, @ApprovedBy NVARCHAR, @Status BIT | SU |  |  |  |  | fnSplit, tblMarketAttendance_Master_webapi | `spec/database/procs/sp_ApproveAttendanceInformation.sql` |
| `sp_ApproveExpenseClaimInformation` | @TPMaster NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | fnSplit, tbl_ExpenseClaim | `spec/database/procs/sp_ApproveExpenseClaimInformation.sql` |
| `sp_ApproveMileageClaimInformation` | @TPMaster NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | fnSplit, tbl_MileageClaim | `spec/database/procs/sp_ApproveMileageClaimInformation.sql` |
| `sp_ApprovePrescriptionInformation` | @TPMaster NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | fnSplit, tbl_PrescriptionMaster | `spec/database/procs/sp_ApprovePrescriptionInformation.sql` |
| `sp_ApproveTourPlanInformation` | @TPMaster NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | fnSplit, tbl_TourPlanMaster | `spec/database/procs/sp_ApproveTourPlanInformation.sql` |
| `sp_ApproveVisitPlanInformation` | @TPMaster NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | fnSplit, tbl_DoctorTourPlanMaster | `spec/database/procs/sp_ApproveVisitPlanInformation.sql` |
| `sp_Check_anomalyInvoiceDetails` | @InvoiceId int, @orderId int | S |  |  |  |  | tblInvoice, tblInvoiceDetail, tblOrderDetail | `spec/database/procs/sp_Check_anomalyInvoiceDetails.sql` |
| `sp_check_AreaInfo` | @id INT, @zoneId int, @Name NVARCHAR | S |  |  |  |  | tblArea | `spec/database/procs/sp_check_AreaInfo.sql` |
| `sp_check_ASMInfo` | @AreaId INT, @ASMId INT | S |  |  |  |  | tblASMInfo | `spec/database/procs/sp_check_ASMInfo.sql` |
| `sp_check_Count_MarketStructure` | @MasterId INT, @PageName NVARCHAR | S |  |  |  |  | tblCustMaster, tblDoctorMaster, tblOrder, tblRouteInformationMarketDetail | `spec/database/procs/sp_check_Count_MarketStructure.sql` |
| `sp_check_da_UserInfo` | @UserId INT, @LoginName NVARCHAR, @EmpInfoId INT, @DaInfoId INT | S |  |  |  |  | tblUser | `spec/database/procs/sp_check_da_UserInfo.sql` |
| `sp_check_da_UserInfo_Save` | @UserId INT, @LoginName NVARCHAR, @EmpInfoId INT, @DaInfoId INT | S |  |  |  |  | tblUser | `spec/database/procs/sp_check_da_UserInfo_Save.sql` |
| `sp_check_Department` | @id INT, @DepartmentName NVARCHAR | S |  |  |  |  | tblDepartment | `spec/database/procs/sp_check_Department.sql` |
| `sp_check_Designation` | @id INT, @DesigName NVARCHAR | S |  |  |  |  | tblDesignation | `spec/database/procs/sp_check_Designation.sql` |
| `sp_check_DoctorCategory` | @CategoryId INT, @CategoryName NVARCHAR | S |  |  |  |  | tblDoctorCategory | `spec/database/procs/sp_check_DoctorCategory.sql` |
| `sp_check_DoctorChamber` | @ChamberId INT, @ChamberName NVARCHAR | S |  |  |  |  | tblDoctorChamber | `spec/database/procs/sp_check_DoctorChamber.sql` |
| `sp_check_DoctorDegree` | @DegreeId INT, @DoctorTypeId int, @DegreeName NVARCHAR | S |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_check_DoctorDegree.sql` |
| `sp_check_DoctorDesignation` | @DesignationId INT, @DesignationName NVARCHAR | S |  |  |  |  | tblDoctorDesignation | `spec/database/procs/sp_check_DoctorDesignation.sql` |
| `sp_check_DoctorPatientType` | @PatientTypeId INT, @PatientType NVARCHAR | S |  |  |  |  | tblDoctorPatientType | `spec/database/procs/sp_check_DoctorPatientType.sql` |
| `sp_check_DoctorSpecialDay` | @SpecialDayId INT, @SpecialDay NVARCHAR | S |  |  |  |  | tblDoctorSpecialDay | `spec/database/procs/sp_check_DoctorSpecialDay.sql` |
| `sp_check_DoctorSpeciality` | @SpecialityId INT, @SpecialityName NVARCHAR | S |  |  |  |  | tblDoctorSpeciality | `spec/database/procs/sp_check_DoctorSpeciality.sql` |
| `sp_check_Employee_ShiftInfos` | @ShiftId INT, @ShiftText NVARCHAR | S |  |  |  |  | tbl_Shift | `spec/database/procs/sp_check_Employee_ShiftInfos.sql` |
| `sp_check_EmployeeAllowance` | @id INT, @Name NVARCHAR | S |  |  |  |  | tbl_MonthlyAllowance | `spec/database/procs/sp_check_EmployeeAllowance.sql` |
| `sp_check_ExpenseType` | @ExpenseTypeId INT, @ExpenseTypeName NVARCHAR | S |  |  |  |  | tbl_ExpenseTypeMaster | `spec/database/procs/sp_check_ExpenseType.sql` |
| `sp_check_FinancialYear` | @id INT, @FiscalYearDesc NVARCHAR | S |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_check_FinancialYear.sql` |
| `sp_check_GenericGroup` | @id INT, @GenericGroupName NVARCHAR | S |  |  |  |  | tblGenericGroup | `spec/database/procs/sp_check_GenericGroup.sql` |
| `sp_check_GroupInfo` | @id INT, @Name NVARCHAR | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_check_GroupInfo.sql` |
| `sp_check_Holiday` | @id INT, @Name NVARCHAR | S |  |  |  |  | Employee_GovtHolidays | `spec/database/procs/sp_check_Holiday.sql` |
| `sp_check_LeaveInfo` | @id INT, @Name NVARCHAR | S |  |  |  |  | Employe_LeaveTypeInfos | `spec/database/procs/sp_check_LeaveInfo.sql` |
| `sp_check_MarketInfo` | @id INT, @SubTerritoryId int, @Name NVARCHAR | S |  |  |  |  | tblMarket | `spec/database/procs/sp_check_MarketInfo.sql` |
| `sp_check_MIOInfo` | @TerritoryId INT, @MIOId INT | S |  |  |  |  | tblMIOInfo | `spec/database/procs/sp_check_MIOInfo.sql` |
| `sp_check_NSMHeadInfo` | @GroupId INT, @NSMId INT | S |  |  |  |  | tblNational_NSM | `spec/database/procs/sp_check_NSMHeadInfo.sql` |
| `sp_check_NSMInfo` | @GroupId INT, @NSMId INT | S |  |  |  |  | tblNSMInfo | `spec/database/procs/sp_check_NSMInfo.sql` |
| `sp_check_ProductLine` | @id INT, @LineName NVARCHAR | S |  |  |  |  | tblProductLine | `spec/database/procs/sp_check_ProductLine.sql` |
| `sp_check_RouterMaster` | @id INT, @RouterName NVARCHAR | S |  |  |  |  | RouterMaster | `spec/database/procs/sp_check_RouterMaster.sql` |
| `sp_check_RSMInfo` | @RegionId INT, @RSMId INT | S |  |  |  |  | tblRSMInfo | `spec/database/procs/sp_check_RSMInfo.sql` |
| `sp_check_SubTerritoryInfo` | @id INT, @TerritoryId INT, @Name NVARCHAR | S |  |  |  |  | tblSubTerritory | `spec/database/procs/sp_check_SubTerritoryInfo.sql` |
| `sp_check_TADAMarketRuleConfiguration` | @id INT, @TourType INT, @UserRoleID INT, @MarketId INT (+2 more) | S |  |  |  |  | tbl_TADAMarketRulesConfig | `spec/database/procs/sp_check_TADAMarketRuleConfiguration.sql` |
| `sp_check_TerritoryInfo` | @id INT, @areaId int, @Name NVARCHAR | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_check_TerritoryInfo.sql` |
| `sp_check_TherapeuticGroup` | @id INT, @TherapeuticGroupName NVARCHAR | S |  |  |  |  | tblTherapeuticGroup | `spec/database/procs/sp_check_TherapeuticGroup.sql` |
| `sp_check_Transport` | @TransportId INT, @TransportName NVARCHAR | S |  |  |  |  | tbl_Transport | `spec/database/procs/sp_check_Transport.sql` |
| `sp_check_UserInfo_Save` | @UserId INT, @LoginName nvarchar, @EmpInfoId int | S |  |  |  |  | tblUser | `spec/database/procs/sp_check_UserInfo_Save.sql` |
| `sp_check_UserRoleInfo` | @UserRoleID INT, @RoleName nvarchar | S |  |  |  |  | tbl_UserRoleInfo | `spec/database/procs/sp_check_UserRoleInfo.sql` |
| `sp_check_Vali_EmployeeInfoEntry` | @MasterId NVARCHAR, @PageName NVARCHAR | S |  |  |  |  | tblASMInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblUser | `spec/database/procs/sp_check_Vali_EmployeeInfoEntry.sql` |
| `sp_check_Vali_EmployeeInfoUpdate` | @EmpMasterCode nvarchar, @EmpId INT | S |  |  |  |  | tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_check_Vali_EmployeeInfoUpdate.sql` |
| `sp_check_Vali_MarketStructure` | @MasterId INT, @PageName NVARCHAR | S |  |  |  |  | EmployeeAllowance, tblASMInfo, tblArea, tblCustMaster, tblDcWiseTerritoryDetail, tblDoctorMaster (+19 more) | `spec/database/procs/sp_check_Vali_MarketStructure.sql` |
| `sp_check_Vali_PromoMIOTag` | @PromoGroupId INT, @EmpInfoId INT, @PageName NVARCHAR | S |  |  |  |  | tblPromoMIOTagDetail, tblPromoMIOTagMaster | `spec/database/procs/sp_check_Vali_PromoMIOTag.sql` |
| `sp_check_ZoneInfo` | @id INT, @GroupId INT, @Name NVARCHAR | S |  |  |  |  | tblRegion | `spec/database/procs/sp_check_ZoneInfo.sql` |
| `sp_CHK_DCWiseArea` | @DepotId INT | S |  |  |  |  | tblDcWiseAreaInfo | `spec/database/procs/sp_CHK_DCWiseArea.sql` |
| `sp_CS_ASMInfo_Rpt` | (none) | S |  |  |  |  | tblASMInfo, tblEmpGeneralInfo | `spec/database/procs/sp_CS_ASMInfo_Rpt.sql` |
| `sp_CS_CustomerType_All` | (none) | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_CS_CustomerType_All.sql` |
| `sp_CS_Department_Active` | (none) | S |  |  |  |  | tblDepartment | `spec/database/procs/sp_CS_Department_Active.sql` |
| `sp_CS_Designation_Active` | (none) | S |  |  |  |  | tblDesignation | `spec/database/procs/sp_CS_Designation_Active.sql` |
| `sp_CS_FiscalYearInfo_Active` | (none) | S |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_CS_FiscalYearInfo_Active.sql` |
| `sp_CS_GetArea_ByZoneId_Active` | @id int | S |  |  |  |  | tblArea | `spec/database/procs/sp_CS_GetArea_ByZoneId_Active.sql` |
| `sp_CS_GetArea_ByZoneId_All` | @id int | S |  |  |  |  | tblArea | `spec/database/procs/sp_CS_GetArea_ByZoneId_All.sql` |
| `sp_CS_GetArea_ByZoneId_ForAMOnly` | @id nvarchar | S |  |  |  |  | fnSplit, tblArea | `spec/database/procs/sp_CS_GetArea_ByZoneId_ForAMOnly.sql` |
| `sp_CS_GetArea_ByZoneId_Rpt` | @id int | S |  |  |  |  | tblArea | `spec/database/procs/sp_CS_GetArea_ByZoneId_Rpt.sql` |
| `sp_CS_GetDistributionRouteNameByMarketId` | @id int | S |  |  |  |  | tblRouteInformationMarketDetail, tblRouteInformationMaster | `spec/database/procs/sp_CS_GetDistributionRouteNameByMarketId.sql` |
| `sp_CS_GetEmpGeneralInfo_Active` | (none) | S |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_CS_GetEmpGeneralInfo_Active.sql` |
| `sp_CS_GetEmpGeneralInfo_All` | (none) | S |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_CS_GetEmpGeneralInfo_All.sql` |
| `sp_CS_GetEmpGeneralInfo_AllFSS` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblRoleType, tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_CS_GetEmpGeneralInfo_AllFSS.sql` |
| `sp_CS_GetExpenseType_Active` | (none) | S |  |  |  |  | tbl_ExpenseTypeMaster | `spec/database/procs/sp_CS_GetExpenseType_Active.sql` |
| `sp_CS_GetMarket_BySubTerritoryId_Active` | @id int | S |  |  |  |  | tblMarket | `spec/database/procs/sp_CS_GetMarket_BySubTerritoryId_Active.sql` |
| `sp_CS_GetMarket_BySubTerritoryId_All` | @id int | S |  |  |  |  | tblMarket | `spec/database/procs/sp_CS_GetMarket_BySubTerritoryId_All.sql` |
| `sp_CS_GetMarket_BySubTerritoryId_Rpt` | @id int | S |  |  |  |  | tblMarket | `spec/database/procs/sp_CS_GetMarket_BySubTerritoryId_Rpt.sql` |
| `sp_CS_GetMarket_ByTerritoryId_All` | @id int | S |  |  |  |  | tblMarket | `spec/database/procs/sp_CS_GetMarket_ByTerritoryId_All.sql` |
| `sp_CS_GetSubTerritory_ByTerritoryId_Active` | @id int | S |  |  |  |  | tblSubTerritory | `spec/database/procs/sp_CS_GetSubTerritory_ByTerritoryId_Active.sql` |
| `sp_CS_GetSubTerritory_ByTerritoryId_All` | @id int | S |  |  |  |  | tblSubTerritory | `spec/database/procs/sp_CS_GetSubTerritory_ByTerritoryId_All.sql` |
| `sp_CS_GetSubTerritory_ByTerritoryId_Rpt` | @id int | S |  |  |  |  | tblSubTerritory | `spec/database/procs/sp_CS_GetSubTerritory_ByTerritoryId_Rpt.sql` |
| `sp_CS_GetTerritory_All` | (none) | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_CS_GetTerritory_All.sql` |
| `sp_CS_GetTerritory_ByAreaId_Active` | @id int | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_CS_GetTerritory_ByAreaId_Active.sql` |
| `sp_CS_GetTerritory_ByAreaId_ActiveForDepo` | @id int | S |  |  |  |  | tblCompanyUnit, tblDcWiseTerritoryDetail, tblDcWiseTerritoryMaster, tblTerritory | `spec/database/procs/sp_CS_GetTerritory_ByAreaId_ActiveForDepo.sql` |
| `sp_CS_GetTerritory_ByAreaId_All` | @id int | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_CS_GetTerritory_ByAreaId_All.sql` |
| `sp_CS_GetTerritory_ByAreaId_Rpt` | @id int | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_CS_GetTerritory_ByAreaId_Rpt.sql` |
| `sp_CS_GetTerritoryWiseDistributnCenterbyTeritoryId` | @id int | S |  |  |  |  | tblDcWiseTerritoryDetail, tblDcWiseTerritoryMaster | `spec/database/procs/sp_CS_GetTerritoryWiseDistributnCenterbyTeritoryId.sql` |
| `sp_CS_GetZone_Active` | (none) | S |  |  |  |  | tblRegion | `spec/database/procs/sp_CS_GetZone_Active.sql` |
| `sp_CS_GetZone_ByGroupId_Active` | @id int | S |  |  |  |  | tbl_Zone | `spec/database/procs/sp_CS_GetZone_ByGroupId_Active.sql` |
| `sp_CS_Group_Active` | (none) | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_CS_Group_Active.sql` |
| `sp_CS_Group_All` | (none) | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_CS_Group_All.sql` |
| `sp_CS_Group_Rpt` | (none) | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_CS_Group_Rpt.sql` |
| `sp_CS_MIOInfo_BySC` | @DCId int | S |  |  |  |  | tblEmpGeneralInfo, tblMIOInfo, tblRouteInformationMarketDetail, tblRouteInformationMaster, tblTerritory | `spec/database/procs/sp_CS_MIOInfo_BySC.sql` |
| `sp_CS_MIOInfo_Rpt` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblMIOInfo | `spec/database/procs/sp_CS_MIOInfo_Rpt.sql` |
| `sp_CS_National_Active` | (none) | S |  |  |  |  | tbl_National | `spec/database/procs/sp_CS_National_Active.sql` |
| `sp_CS_NSMInfo_Rpt` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblNSMInfo | `spec/database/procs/sp_CS_NSMInfo_Rpt.sql` |
| `sp_CS_RoleType` | (none) | S |  |  |  |  | tblRoleType | `spec/database/procs/sp_CS_RoleType.sql` |
| `sp_CS_RoleTypeFSS` | (none) | S |  |  |  |  | tblRoleType | `spec/database/procs/sp_CS_RoleTypeFSS.sql` |
| `sp_CS_RSMInfo_Rpt` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblRSMInfo | `spec/database/procs/sp_CS_RSMInfo_Rpt.sql` |
| `sp_CS_Shift_Active` | (none) | S |  |  |  |  | tbl_Shift | `spec/database/procs/sp_CS_Shift_Active.sql` |
| `sp_CS_Thana_All` | (none) | S |  |  |  |  | tbl_Thana | `spec/database/procs/sp_CS_Thana_All.sql` |
| `sp_CS_TourPlanType_Active` | (none) | S |  |  |  |  | tbl_TourPlanType | `spec/database/procs/sp_CS_TourPlanType_Active.sql` |
| `sp_CS_TourPlanType_All` | (none) | S |  |  |  |  | tbl_TourPlanType | `spec/database/procs/sp_CS_TourPlanType_All.sql` |
| `sp_CS_Transport_Active` | (none) | S |  |  |  |  | tbl_Transport | `spec/database/procs/sp_CS_Transport_Active.sql` |
| `sp_CS_Transport_All` | (none) | S |  |  |  |  | tbl_Transport | `spec/database/procs/sp_CS_Transport_All.sql` |
| `sp_CS_UserInfo_Active` | (none) | S |  |  |  |  | tblUser | `spec/database/procs/sp_CS_UserInfo_Active.sql` |
| `sp_Delete_DesignationInfo` | @DesignationId INT | D |  |  |  |  | tblDesignation | `spec/database/procs/sp_Delete_DesignationInfo.sql` |
| `sp_Delete_DoctorCategory` | @CategoryId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorCategory | `spec/database/procs/sp_Delete_DoctorCategory.sql` |
| `sp_Delete_DoctorDegree` | @DegreeId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Delete_DoctorDegree.sql` |
| `sp_Delete_DoctorDesignation` | @DesignationId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorDesignation | `spec/database/procs/sp_Delete_DoctorDesignation.sql` |
| `sp_Delete_DoctorpatientType` | @PatientTypeId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorPatientType | `spec/database/procs/sp_Delete_DoctorpatientType.sql` |
| `sp_Delete_DoctorSpecailDay` | @SpecialDayId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorSpecialDay | `spec/database/procs/sp_Delete_DoctorSpecailDay.sql` |
| `sp_Delete_DoctorSpeciality` | @SpecialityId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorSpeciality | `spec/database/procs/sp_Delete_DoctorSpeciality.sql` |
| `sp_Delete_Employee_LeaveInfo` | @LeaveTypeId INT | D |  |  |  |  | Employe_LeaveTypeInfos | `spec/database/procs/sp_Delete_Employee_LeaveInfo.sql` |
| `sp_Delete_ExpenseType` | @ExpenseTypeId INT | D |  |  |  |  | tbl_ExpenseTypeDetails, tbl_ExpenseTypeMaster | `spec/database/procs/sp_Delete_ExpenseType.sql` |
| `sp_Delete_GroupInfo` | @Id INT | D |  |  |  |  | tbl_Group | `spec/database/procs/sp_Delete_GroupInfo.sql` |
| `sp_Delete_MonthlyAllowance` | @MonthlyAllowanceId INT | D |  |  |  |  | tbl_MonthlyAllowance | `spec/database/procs/sp_Delete_MonthlyAllowance.sql` |
| `sp_Delete_Prescription_All` | @PrescriptionTypeId INT | D |  |  |  |  | tbl_PrescriptionMaster, tbl_PrescriptionProductDetail | `spec/database/procs/sp_Delete_Prescription_All.sql` |
| `sp_Delete_PrescriptionDetailsWhenUpdate` | @PrescriptionTypeId INT | D |  |  |  |  | tbl_PrescriptionProductDetail | `spec/database/procs/sp_Delete_PrescriptionDetailsWhenUpdate.sql` |
| `sp_Delete_PrescriptionType` | @PrescriptionTypeId INT | D |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_Delete_PrescriptionType.sql` |
| `sp_Delete_TADAMarketRulesConfig` | @TADAMarketRuleConfigId INT | D |  |  |  |  | tbl_TADAMarketRulesConfig | `spec/database/procs/sp_Delete_TADAMarketRulesConfig.sql` |
| `sp_Delete_TourPurpose` | @TourPurposeId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblTourPurpose | `spec/database/procs/sp_Delete_TourPurpose.sql` |
| `sp_Delete_TourType` | @TourTypeId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblTourType | `spec/database/procs/sp_Delete_TourType.sql` |
| `sp_Delete_Trainning` | @TrainningId INT | D |  |  |  |  | tblTrainning | `spec/database/procs/sp_Delete_Trainning.sql` |
| `sp_Delete_Transport` | @TransportId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tbl_Transport | `spec/database/procs/sp_Delete_Transport.sql` |
| `sp_DeleteArchiveAttendanceData` | @FromDate DATE, @ToDate DATE | SID | Y | Y |  |  | SalesDisDB_SMC_NEWDB_Dynamic, tblMarketAttendance_Master_webapiDeleteArchive | `spec/database/procs/sp_DeleteArchiveAttendanceData.sql` |
| `sp_DeleteArchiveDBAttendanceData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBAttendanceData.sql` |
| `sp_DeleteArchiveDBDCRData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBDCRData.sql` |
| `sp_DeleteArchiveDBExpenseData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBExpenseData.sql` |
| `sp_DeleteArchiveDBInvoiceData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBInvoiceData.sql` |
| `sp_DeleteArchiveDBOrderData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBOrderData.sql` |
| `sp_DeleteArchiveDBRxData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBRxData.sql` |
| `sp_DeleteArchiveDBTourPlanData` | @DatabaseName NVARCHAR, @FromDate DATE, @ToDate DATE | D | Y | Y | Y |  | sp_executesql | `spec/database/procs/sp_DeleteArchiveDBTourPlanData.sql` |
| `sp_DeleteArchiveDCRData` | @FromDate DATE, @ToDate DATE | SID | Y | Y |  |  | SalesDisDB_SMC_NEWDB_Dynamic, tblDCRBrandDetailsDeleteArchive, tblDCRDeleteArchive, tblDCRDetailDeleteArchive, tbl_DCRInfo, tbl_DcrBrandDetails (+3 more) | `spec/database/procs/sp_DeleteArchiveDCRData.sql` |
| `sp_DeleteArchiveExpenseData` | @FromDate DATETIME, @ToDate DATETIME | SID |  |  | Y |  | SalesDisDB_SMC_NEWDB_Dynamic, sp_executesql, sys, tbl_ExpenseClaim, tbl_ExpenseClaimDeleteArchive, tbl_ExpenseClaimDetails (+1 more) | `spec/database/procs/sp_DeleteArchiveExpenseData.sql` |
| `sp_DeleteArchiveInvoiceData` | @FromDate DATETIME, @ToDate DATETIME | SID |  |  | Y |  | SalesDisDB_SMC_NEWDB_Dynamic, sp_executesql, sys, tblInvoice, tblInvoiceDeleteArchive, tblInvoiceDetail (+1 more) | `spec/database/procs/sp_DeleteArchiveInvoiceData.sql` |
| `sp_DeleteArchiveOrderData` | @FromDate DATETIME, @ToDate DATETIME | SID |  |  | Y |  | SalesDisDB_SMC_NEWDB_Dynamic, sp_executesql, sys, tblOrder, tblOrderDeleteArchive, tblOrderDetail (+1 more) | `spec/database/procs/sp_DeleteArchiveOrderData.sql` |
| `sp_DeleteArchiveRxData` | @FromDate DATETIME, @ToDate DATETIME | SID | Y | Y | Y |  | SalesDisDB_SMC_NEWDB_Dynamic, sp_executesql, sys, tblPrescriptionApprovalLog, tblPrescriptionApprovalLogDeleteArchive, tbl_PrescriptionMaster (+3 more) | `spec/database/procs/sp_DeleteArchiveRxData.sql` |
| `sp_DeleteArchiveTourPlanData` | @FromDate DATE, @ToDate DATE | SID | Y | Y |  |  | SalesDisDB_SMC_NEWDB_Dynamic, tblTourPlanInfoDeleteArchive, tblTourPlanMasterDeleteArchive, tbl_TourPlanInfo, tbl_TourPlanMaster | `spec/database/procs/sp_DeleteArchiveTourPlanData.sql` |
| `sp_EmpGeneralInfoByEmployeeId` | @EmployeeId INT | S |  |  |  |  | tblEmpGeneralInfo, tblRoleType, tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_EmpGeneralInfoByEmployeeId.sql` |
| `sp_ExpenseTypeDtl` | @ExpenseTypeId INT | D |  |  |  |  | tbl_ExpenseTypeDetails | `spec/database/procs/sp_ExpenseTypeDtl.sql` |
| `sp_GET_ActionStatusList` | (none) | S |  |  |  |  | tblActionStatus | `spec/database/procs/sp_GET_ActionStatusList.sql` |
| `sp_Get_ALlDIvision` | (none) | S |  |  |  |  | tbl_Division | `spec/database/procs/sp_Get_ALlDIvision.sql` |
| `sp_Get_Allowance_For_DDL` | (none) | S |  |  |  |  | tbl_AllowanceName | `spec/database/procs/sp_Get_Allowance_For_DDL.sql` |
| `sp_GET_ArchiveDbConnect_ByFinancialYearDesc` | @FinancialYearDesc NVARCHAR | S |  |  |  |  | tblArcDBConnect | `spec/database/procs/sp_GET_ArchiveDbConnect_ByFinancialYearDesc.sql` |
| `sp_GET_ArchiveFinancialYearList` | (none) | S |  |  |  |  | SalesDisDB_SMC_NEWDB, tblFinancialYear | `spec/database/procs/sp_GET_ArchiveFinancialYearList.sql` |
| `sp_Get_AreaData_ByAreaId` | @id int | S |  |  |  |  | tblArea, tblRegion, tbl_AreaDistrictRelation, tbl_Group | `spec/database/procs/sp_Get_AreaData_ByAreaId.sql` |
| `sp_Get_AreaList` | @RegionId int | S |  |  |  |  | tblArea, tblEmpGeneralInfo, tblRegion, tblTerritory, tblUser, tbl_AreaDistrictRelation (+2 more) | `spec/database/procs/sp_Get_AreaList.sql` |
| `sp_Get_AreaList_OnlyActive_ByZoneId` | @id int | S |  |  |  |  | tbl_Area | `spec/database/procs/sp_Get_AreaList_OnlyActive_ByZoneId.sql` |
| `sp_Get_AreaListOrdPer` | @RegionId int | S |  |  |  |  | tblArea | `spec/database/procs/sp_Get_AreaListOrdPer.sql` |
| `sp_Get_AreaListOrdPerALL` | (none) | S |  |  |  |  | tblArea | `spec/database/procs/sp_Get_AreaListOrdPerALL.sql` |
| `sp_GET_ASMInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblASMInfo, tblArea, tblEmpGeneralInfo, tblOrder, tblRegion | `spec/database/procs/sp_GET_ASMInfo.sql` |
| `sp_GET_ASMInfo_ByEmpId` | @id NVARCHAR | S |  |  |  |  | tblASMInfo, tblArea, tblRegion | `spec/database/procs/sp_GET_ASMInfo_ByEmpId.sql` |
| `sp_GET_ASMInfo_ById` | @id NVARCHAR | S |  |  |  |  | tblASMInfo, tblArea, tblRegion | `spec/database/procs/sp_GET_ASMInfo_ById.sql` |
| `sp_GET_BAnkInfoById_ById` | @id NVARCHAR | S |  |  |  |  | tblBankInfoNew | `spec/database/procs/sp_GET_BAnkInfoById_ById.sql` |
| `sp_GET_BAnkInfoById_ByIdAcc` | @AccNo NVARCHAR, @CompanyId NVARCHAR | S |  |  |  |  | tblBankInfoNew | `spec/database/procs/sp_GET_BAnkInfoById_ByIdAcc.sql` |
| `sp_Get_BrandName_All` | (none) | S |  |  |  |  | tblProductSQ | `spec/database/procs/sp_Get_BrandName_All.sql` |
| `sp_GET_btnShow` | @PageName nvarchar | S |  |  |  |  | tblSubmitButton | `spec/database/procs/sp_GET_btnShow.sql` |
| `sp_GET_CampaignCategory` | (none) | S |  |  |  |  | tblCampaignCategory | `spec/database/procs/sp_GET_CampaignCategory.sql` |
| `sp_GET_CampaignNameFromOrderDetail` | (none) | S |  |  |  |  | tblOrderDetail | `spec/database/procs/sp_GET_CampaignNameFromOrderDetail.sql` |
| `sp_GET_CampaignType` | (none) | S |  |  |  |  | tbl_CampaignType | `spec/database/procs/sp_GET_CampaignType.sql` |
| `sp_Get_CapturedBY_For_DDL` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_Get_CapturedBY_For_DDL.sql` |
| `sp_Get_ChamberType_Active` | (none) | S |  |  |  |  | tblDoctorChamber | `spec/database/procs/sp_Get_ChamberType_Active.sql` |
| `sp_GET_CompanyInfo` | (none) | S |  |  |  |  | tblCompanyInfo | `spec/database/procs/sp_GET_CompanyInfo.sql` |
| `sp_Get_ContactType_Active` | (none) | S |  |  |  |  | tbl_ContactType | `spec/database/procs/sp_Get_ContactType_Active.sql` |
| `sp_Get_CustMasterInstitution` | (none) | S |  |  |  |  | tblCustMaster | `spec/database/procs/sp_Get_CustMasterInstitution.sql` |
| `sp_Get_CustomerCategory` | (none) | S |  |  |  |  | tblCustomerCategory | `spec/database/procs/sp_Get_CustomerCategory.sql` |
| `sp_GET_CustomerType` | (none) | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_GET_CustomerType.sql` |
| `sp_GET_CustomerTypeActive` | (none) | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_GET_CustomerTypeActive.sql` |
| `sp_GET_CustomerTypeAll` | (none) | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_GET_CustomerTypeAll.sql` |
| `sp_GET_DCWiseArea` | @DepotId INT | S |  |  |  |  | tblArea, tblDcWiseAreaInfo | `spec/database/procs/sp_GET_DCWiseArea.sql` |
| `sp_Get_Degree_All` | (none) | S |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Get_Degree_All.sql` |
| `sp_Get_Degree_All_Active` | (none) | S |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Get_Degree_All_Active.sql` |
| `sp_Get_Degree_All_ActiveByDoctorTypeId` | @id int | S |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Get_Degree_All_ActiveByDoctorTypeId.sql` |
| `sp_GET_DepartmentInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblDepartment, tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_GET_DepartmentInfo.sql` |
| `sp_GET_DepartmentInfo_ById` | @id NVARCHAR | S |  |  |  |  | tblDepartment | `spec/database/procs/sp_GET_DepartmentInfo_ById.sql` |
| `sp_GET_DepotByCompanyId` | @CompanyId INT | S |  |  |  |  | tblCompanyUnit | `spec/database/procs/sp_GET_DepotByCompanyId.sql` |
| `sp_Get_Designation_All_Active` | (none) | S |  |  |  |  | tblDoctorDesignation | `spec/database/procs/sp_Get_Designation_All_Active.sql` |
| `sp_GET_DesignationInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblDesignation, tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_GET_DesignationInfo.sql` |
| `sp_GET_DesignationInfo_ById` | @id NVARCHAR | S |  |  |  |  | tblDesignation | `spec/database/procs/sp_GET_DesignationInfo_ById.sql` |
| `sp_GET_DistributionCenter` | (none) | S |  |  |  |  | tblCompanyUnit | `spec/database/procs/sp_GET_DistributionCenter.sql` |
| `sp_GET_DistributionRoute` | (none) | S |  |  |  |  | tblOrder | `spec/database/procs/sp_GET_DistributionRoute.sql` |
| `sp_GET_DistributionRouteByDCID` | @id int | S |  |  |  |  | tblOrder | `spec/database/procs/sp_GET_DistributionRouteByDCID.sql` |
| `sp_Get_District_All_Active_NoTag` | (none) | S |  |  |  |  | tbl_District | `spec/database/procs/sp_Get_District_All_Active_NoTag.sql` |
| `sp_GET_DistrictList` | @Id int | S |  |  |  |  | tbl_District | `spec/database/procs/sp_GET_DistrictList.sql` |
| `sp_Get_DistrictList_OnlyActive_ByDivisionId` | @id int | S |  |  |  |  | tbl_District | `spec/database/procs/sp_Get_DistrictList_OnlyActive_ByDivisionId.sql` |
| `sp_Get_Division_Active` | (none) | S |  |  |  |  | tbl_Division | `spec/database/procs/sp_Get_Division_Active.sql` |
| `sp_GET_DivisionList` | (none) | S |  |  |  |  | tbl_Division | `spec/database/procs/sp_GET_DivisionList.sql` |
| `sp_Get_Doctor_For_DDL` | (none) | S |  |  |  |  | tblDoctorMaster | `spec/database/procs/sp_Get_Doctor_For_DDL.sql` |
| `sp_Get_DoctorBrand_Active` | (none) | S |  |  |  |  | tblProductSQ | `spec/database/procs/sp_Get_DoctorBrand_Active.sql` |
| `sp_Get_Doctorcategory_ById` | @id INT | S |  |  |  |  | tblDoctorCategory | `spec/database/procs/sp_Get_Doctorcategory_ById.sql` |
| `sp_Get_DoctorCategoryList` | (none) | S |  |  |  |  | tblDoctorCategory, tblUser | `spec/database/procs/sp_Get_DoctorCategoryList.sql` |
| `sp_Get_doctorCateList` | (none) | S |  |  |  |  | tblDoctorCategory | `spec/database/procs/sp_Get_doctorCateList.sql` |
| `sp_Get_DoctorChamber_ById` | @id INT | S |  |  |  |  | tblDoctorChamber | `spec/database/procs/sp_Get_DoctorChamber_ById.sql` |
| `sp_Get_DoctorChamberList` | (none) | S |  |  |  |  | tblDoctorChamber, tblDoctorChemberDetail, tblUser | `spec/database/procs/sp_Get_DoctorChamberList.sql` |
| `sp_Get_DoctorCustomer_Active` | (none) | S |  |  |  |  | SalesRollDB_ZAS | `spec/database/procs/sp_Get_DoctorCustomer_Active.sql` |
| `sp_Get_DoctorDegree_ById` | @id INT | S |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Get_DoctorDegree_ById.sql` |
| `sp_Get_DoctorDegreeList` | (none) | S |  |  |  |  | tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorType, tblUser | `spec/database/procs/sp_Get_DoctorDegreeList.sql` |
| `sp_Get_DoctorDesignation_ById` | @id INT | S |  |  |  |  | tblDoctorDesignation | `spec/database/procs/sp_Get_DoctorDesignation_ById.sql` |
| `sp_Get_DoctorDesignationList` | (none) | S |  |  |  |  | tblDoctorDesignation, tblDoctorMaster, tblUser | `spec/database/procs/sp_Get_DoctorDesignationList.sql` |
| `sp_Get_DoctorExpenseClaim_ById` | @id INT | S |  |  |  |  | tbl_ExpenseClaim, tbl_ExpenseClaimDetails, tbl_ExpenseTypeDetails, tbl_ImagePath_Setting | `spec/database/procs/sp_Get_DoctorExpenseClaim_ById.sql` |
| `sp_Get_DoctorList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblArea, tblCompanyUnit, tblDoctorChamber, tblDoctorChemberDetail, tblDoctorContactDetail (+21 more) | `spec/database/procs/sp_Get_DoctorList.sql` |
| `sp_Get_DoctorList_Approval` | (none) | S |  |  |  |  | tblDesignation, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorProgramType, tblDoctorProgramTypeDetail (+3 more) | `spec/database/procs/sp_Get_DoctorList_Approval.sql` |
| `sp_Get_DoctorPatientList` | (none) | S |  |  |  |  | tblDoctorPatientType | `spec/database/procs/sp_Get_DoctorPatientList.sql` |
| `sp_Get_DoctorPatientType_ById` | @id INT | S |  |  |  |  | tblDoctorPatientType | `spec/database/procs/sp_Get_DoctorPatientType_ById.sql` |
| `sp_Get_DoctorProgramType_Active` | (none) | S |  |  |  |  | tblDoctorProgramType | `spec/database/procs/sp_Get_DoctorProgramType_Active.sql` |
| `sp_GET_DoctorProgramTypeList` | (none) | S |  |  |  |  | tblDoctorProgramType | `spec/database/procs/sp_GET_DoctorProgramTypeList.sql` |
| `sp_Get_DoctorSetupData_ByDoctorId` | @id INT | S |  |  |  |  | tblDoctorMaster | `spec/database/procs/sp_Get_DoctorSetupData_ByDoctorId.sql` |
| `sp_Get_DoctorSpeacialDay_ById` | @id INT | S |  |  |  |  | tblDoctorSpecialDay | `spec/database/procs/sp_Get_DoctorSpeacialDay_ById.sql` |
| `sp_Get_DoctorSpecailDayList` | (none) | S |  |  |  |  | tblDoctorSpecialDay, tblUser | `spec/database/procs/sp_Get_DoctorSpecailDayList.sql` |
| `sp_Get_DoctorSpecialDay_All_Active` | (none) | S |  |  |  |  | tblDoctorSpecialDay | `spec/database/procs/sp_Get_DoctorSpecialDay_All_Active.sql` |
| `sp_Get_DoctorSpeciality_Active` | (none) | S |  |  |  |  | tblDoctorSpeciality | `spec/database/procs/sp_Get_DoctorSpeciality_Active.sql` |
| `sp_Get_DoctorSpeciality_ById` | @id INT | S |  |  |  |  | tblDoctorSpeciality | `spec/database/procs/sp_Get_DoctorSpeciality_ById.sql` |
| `sp_Get_DoctorSpecialityList` | (none) | S |  |  |  |  | tblDoctorSpeciality, tblDoctorSpecialityDetail, tblUser | `spec/database/procs/sp_Get_DoctorSpecialityList.sql` |
| `sp_Get_DoctorType_Active` | (none) | S |  |  |  |  | tblDoctorType | `spec/database/procs/sp_Get_DoctorType_Active.sql` |
| `sp_GET_DZSMInfo_ByEmpId` | @id NVARCHAR | S |  |  |  |  | tblRSMInfo, tblRegion | `spec/database/procs/sp_GET_DZSMInfo_ByEmpId.sql` |
| `sp_GET_DZSMInfo_ById` | @id NVARCHAR | S |  |  |  |  | tblRSMInfo, tblRegion | `spec/database/procs/sp_GET_DZSMInfo_ById.sql` |
| `sp_Get_Emp_AttendanceInfoDayRow` | @param NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDesignation, tblEmpGeneralInfo, tblMarketAttendance_Master_webapi, tblRoleType, tbl_Shift (+1 more) | `spec/database/procs/sp_Get_Emp_AttendanceInfoDayRow.sql` |
| `sp_Get_Emp_AttendanceInfoList` | @param NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDesignation, tblEmpGeneralInfo, tblMarketAttendance_Master_webapi, tbl_ImagePath_Setting, tbl_Shift (+1 more) | `spec/database/procs/sp_Get_Emp_AttendanceInfoList.sql` |
| `sp_Get_Emp_AttendanceInfoListPending` | (none) | S |  |  |  |  | tblDesignation, tblEmpGeneralInfo, tblMarketAttendance_Master_webapi, tblUser, tbl_Shift, tbl_UserRoleInfo | `spec/database/procs/sp_Get_Emp_AttendanceInfoListPending.sql` |
| `sp_Get_Employee_ShiftInfos_ById` | @id INT | S |  |  |  |  | tbl_Shift | `spec/database/procs/sp_Get_Employee_ShiftInfos_ById.sql` |
| `sp_Get_Employee_ShiftInfosList` | (none) | S |  |  |  |  | tbl_Shift | `spec/database/procs/sp_Get_Employee_ShiftInfosList.sql` |
| `sp_Get_EmployeeAMditID` | @Id int | S |  |  |  |  | tblASMInfo, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo | `spec/database/procs/sp_Get_EmployeeAMditID.sql` |
| `sp_Get_EmployeeDZSMditID` | @Id int | S |  |  |  |  | tblASMInfo, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo | `spec/database/procs/sp_Get_EmployeeDZSMditID.sql` |
| `sp_Get_EmployeeFieldForceInfo_EmpId` | @id int | S |  |  |  |  | View_Webapi_EmployeeFieldForceInfo | `spec/database/procs/sp_Get_EmployeeFieldForceInfo_EmpId.sql` |
| `sp_Get_EmployeeFieldForceInfo_EmpIdMArketInfo` | @id int, @RoleTypeName nvarchar | S |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, View_webapi_FieldForce | `spec/database/procs/sp_Get_EmployeeFieldForceInfo_EmpIdMArketInfo.sql` |
| `sp_Get_EmployeeLeaveIinfo_ById` | @id INT | S |  |  |  |  | Employe_LeaveTypeInfos, Employee_YearlyLeaveBalance, tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_Get_EmployeeLeaveIinfo_ById.sql` |
| `sp_Get_EmployeeList` | (none) | S |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_Get_EmployeeList.sql` |
| `sp_Get_EmployeeListFieldForce` | (none) | S |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_Get_EmployeeListFieldForce.sql` |
| `sp_Get_EmployeeMIO` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblMIOInfo | `spec/database/procs/sp_Get_EmployeeMIO.sql` |
| `sp_Get_EmployeeMIOEditID` | @Id int | S |  |  |  |  | tblASMInfo, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo | `spec/database/procs/sp_Get_EmployeeMIOEditID.sql` |
| `sp_Get_EmployeeNSMditID` | @Id int | S |  |  |  |  | tblASMInfo, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo | `spec/database/procs/sp_Get_EmployeeNSMditID.sql` |
| `sp_Get_ExpenseClaimList` | @param NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDesignation, tblEmpGeneralInfo, tblExpanseApprovalLog, tblUser, tbl_ExpenseClaim (+3 more) | `spec/database/procs/sp_Get_ExpenseClaimList.sql` |
| `sp_Get_ExpenseDetails_ByExpenseId` | @id INT | S |  |  |  |  | tbl_ExpenseTypeDetails | `spec/database/procs/sp_Get_ExpenseDetails_ByExpenseId.sql` |
| `sp_Get_ExpenseTypeData_ByExpenseTypeId` | @id INT | S |  |  |  |  | tbl_ExpenseTypeDetails, tbl_ExpenseTypeMaster | `spec/database/procs/sp_Get_ExpenseTypeData_ByExpenseTypeId.sql` |
| `sp_Get_ExpenseTypeMaster` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblRoleType, tblUser, tbl_ExpenseTypeMaster | `spec/database/procs/sp_Get_ExpenseTypeMaster.sql` |
| `sp_GET_FinancialInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblFiscalYearInfos, tblUser | `spec/database/procs/sp_GET_FinancialInfo.sql` |
| `sp_GET_financialYear_ById` | @id NVARCHAR | S |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_GET_financialYear_ById.sql` |
| `sp_Get_FinanCialyearforDDL` | (none) | S |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_Get_FinanCialyearforDDL.sql` |
| `sp_GET_GenericGroup` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblGenericGroup, tblUser | `spec/database/procs/sp_GET_GenericGroup.sql` |
| `sp_GET_GenericGroup_ById` | @id NVARCHAR | S |  |  |  |  | tblGenericGroup | `spec/database/procs/sp_GET_GenericGroup_ById.sql` |
| `sp_GET_GroupInfo` | (none) | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_GET_GroupInfo.sql` |
| `sp_GET_GroupInfo_ById` | @id NVARCHAR | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_GET_GroupInfo_ById.sql` |
| `sp_GET_GroupList` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblRegion, tblUser, tbl_Group | `spec/database/procs/sp_GET_GroupList.sql` |
| `sp_Get_GroupListOrdPer` | (none) | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_Get_GroupListOrdPer.sql` |
| `sp_Get_HolidayInfo_ById` | @id INT | S |  |  |  |  | Employee_GovtHolidays | `spec/database/procs/sp_Get_HolidayInfo_ById.sql` |
| `sp_Get_Holidaylist` | (none) | S |  |  |  |  | Employee_GovtHolidays, tblEmpGeneralInfo, tblFiscalYearInfos, tblUser | `spec/database/procs/sp_Get_Holidaylist.sql` |
| `sp_GET_InvoiceStatusddlAll` | @isForSalesConfirm bit, @IsShowforPartial bit, @IsShowforRejection bit, @IsforReturn bit | S |  |  |  |  | tblInvoiceStatusddl | `spec/database/procs/sp_GET_InvoiceStatusddlAll.sql` |
| `sp_Get_JoiningDateCountInfo` | (none) | S |  |  |  |  | tblJoiningDateCountInfo | `spec/database/procs/sp_Get_JoiningDateCountInfo.sql` |
| `sp_Get_LeaveConfigList` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblLeaveConfig, tblUser | `spec/database/procs/sp_Get_LeaveConfigList.sql` |
| `sp_Get_Leavelist` | (none) | S |  |  |  |  | Employe_LeaveTypeInfos, Employee_YearlyLeaveBalance, tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_Get_Leavelist.sql` |
| `sp_Get_LeaveType_New` | (none) | S |  |  |  |  | Employee_YearlyLeaveBalance, Employee_YearlyLeaveTranscations, tblLeaveConType | `spec/database/procs/sp_Get_LeaveType_New.sql` |
| `sp_GET_MainPermissionByUserRoleandPageUrl` | @RoleId INT, @PageName nvarchar | S |  |  |  |  | tblMainMenuNew, tblMenuRole | `spec/database/procs/sp_GET_MainPermissionByUserRoleandPageUrl.sql` |
| `sp_Get_MarketByTerriTory` | (none) | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblTerritory, tbl_Group | `spec/database/procs/sp_Get_MarketByTerriTory.sql` |
| `sp_Get_MarketByTerriTory_ByRouterMasterId` | @id INT | S |  |  |  |  | RouterDetails, tblArea, tblMarket, tblRegion, tblTerritory, tbl_Group | `spec/database/procs/sp_Get_MarketByTerriTory_ByRouterMasterId.sql` |
| `sp_Get_MarketData_ByMarketid` | @id INT | S |  |  |  |  | tblArea, tblMarket, tblMarketStationDetail, tblRegion, tblRoleType, tblStationType (+6 more) | `spec/database/procs/sp_Get_MarketData_ByMarketid.sql` |
| `sp_Get_MarketList` | @Parameter NVARCHAR | S |  |  | Y |  | tblArea, tblEmpGeneralInfo, tblMarket, tblMarketStationDetail, tblRegion, tblRouteInformationMarketDetail (+9 more) | `spec/database/procs/sp_Get_MarketList.sql` |
| `sp_Get_MileageClaim_ById` | @id INT | S |  |  |  |  | tbl_ImagePath_Setting, tbl_MileageClaim | `spec/database/procs/sp_Get_MileageClaim_ById.sql` |
| `sp_Get_MileageClaimList` | @param NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblEmpGeneralInfo, tblMileageApprovalLog, tblUser, tbl_ImagePath_Setting, tbl_MileageClaim (+2 more) | `spec/database/procs/sp_Get_MileageClaimList.sql` |
| `sp_GET_MIOInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblArea, tblEmpGeneralInfo, tblMIOInfo, tblOrder, tblRegion, tblTerritory | `spec/database/procs/sp_GET_MIOInfo.sql` |
| `sp_GET_MIOInfo_ByEmpId` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMIOInfo, tblRegion, tblTerritory | `spec/database/procs/sp_GET_MIOInfo_ByEmpId.sql` |
| `sp_GET_MIOInfo_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMIOInfo, tblRegion, tblTerritory | `spec/database/procs/sp_GET_MIOInfo_ById.sql` |
| `sp_Get_MonthlyAllowance` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblUser, tbl_MonthlyAllowance | `spec/database/procs/sp_Get_MonthlyAllowance.sql` |
| `sp_Get_MonthlyAllowance_ById` | @id INT | S |  |  |  |  | tbl_MonthlyAllowance, tbl_MonthlyAllowanceDetail | `spec/database/procs/sp_Get_MonthlyAllowance_ById.sql` |
| `sp_GET_MonthlyAllowanceList` | @RoleName NVARCHAR | S |  |  |  |  | tblMonthlyAllowances | `spec/database/procs/sp_GET_MonthlyAllowanceList.sql` |
| `sp_GET_NationalList` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblUser, tbl_National | `spec/database/procs/sp_GET_NationalList.sql` |
| `sp_Get_Notice_ById` | @id INT | S |  |  |  |  | tblNoticeUserRoleDetail, tbl_ImagePath_Setting, tbl_Notice_MarketMaster | `spec/database/procs/sp_Get_Notice_ById.sql` |
| `sp_GET_NoticeDetailMarket_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblSubTerritory, tblTerritory, tbl_Group (+1 more) | `spec/database/procs/sp_GET_NoticeDetailMarket_ById.sql` |
| `sp_GET_NoticeSeen_ById` | @id NVARCHAR | S |  |  |  |  | tblEmpGeneralInfo, tblNotice_Employee | `spec/database/procs/sp_GET_NoticeSeen_ById.sql` |
| `sp_GET_NSMHeadInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblNational_NSM, tbl_National | `spec/database/procs/sp_GET_NSMHeadInfo.sql` |
| `sp_GET_NSMInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblNSMInfo, tblOrder, tbl_Group | `spec/database/procs/sp_GET_NSMInfo.sql` |
| `sp_GET_NSMInfo_ByEMPId` | @id NVARCHAR | S |  |  |  |  | tblNSMInfo | `spec/database/procs/sp_GET_NSMInfo_ByEMPId.sql` |
| `sp_GET_NSMInfo_ById` | @id NVARCHAR | S |  |  |  |  | tblNSMInfo | `spec/database/procs/sp_GET_NSMInfo_ById.sql` |
| `sp_Get_OfferTypeInfo` | @id INT | S |  |  |  |  | tblCampaignBonusMap, tbl_BonusOnType | `spec/database/procs/sp_Get_OfferTypeInfo.sql` |
| `sp_Get_OrderNoforReturn` | @id INT | S |  |  |  |  | tblInvoice | `spec/database/procs/sp_Get_OrderNoforReturn.sql` |
| `sp_Get_OrderNoforReturnDistributionRouteId` | @ComId INT, @rootId INT | S |  |  |  |  | tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/procs/sp_Get_OrderNoforReturnDistributionRouteId.sql` |
| `sp_Get_Prescription_ByPrescriptionId` | @id INT | S |  |  |  |  | tbl_ImagePath_Setting, tbl_PrescriptionMaster | `spec/database/procs/sp_Get_Prescription_ByPrescriptionId.sql` |
| `sp_Get_PrescriptionDetails_ByPrescriptionId` | @id INT | S |  |  |  |  | tblProduct, tbl_PrescriptionProductDetail | `spec/database/procs/sp_Get_PrescriptionDetails_ByPrescriptionId.sql` |
| `sp_Get_PrescriptionList` | @param NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDoctorMaster, tblEmpGeneralInfo, tblUser, tbl_ImagePath_Setting, tbl_PrescriptionMaster (+2 more) | `spec/database/procs/sp_Get_PrescriptionList.sql` |
| `sp_Get_PrescriptionType_ById` | @id INT | S |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_Get_PrescriptionType_ById.sql` |
| `sp_Get_PrescriptionType_For_DDL` | (none) | S |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_Get_PrescriptionType_For_DDL.sql` |
| `sp_Get_PrescriptionTypeList` | (none) | S |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_Get_PrescriptionTypeList.sql` |
| `sp_Get_Product_For_DDl` | @Parameter NVARCHAR | S |  |  |  |  | tblCustMaster | `spec/database/procs/sp_Get_Product_For_DDl.sql` |
| `sp_Get_Product_List` | (none) | S |  |  |  |  | tblProduct | `spec/database/procs/sp_Get_Product_List.sql` |
| `sp_GET_ProductLine` | (none) | S |  |  |  |  | tblProductLine | `spec/database/procs/sp_GET_ProductLine.sql` |
| `sp_GET_ProductLine_ById` | @id NVARCHAR | S |  |  |  |  | tblProductLine | `spec/database/procs/sp_GET_ProductLine_ById.sql` |
| `sp_GET_ProductLineList` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblProductLine, tblUser | `spec/database/procs/sp_GET_ProductLineList.sql` |
| `sp_GET_ProductNameList` | (none) | S |  |  |  |  | tblProduct | `spec/database/procs/sp_GET_ProductNameList.sql` |
| `sp_GET_ProgramTypeList` | (none) | S |  |  |  |  | tblProgramType | `spec/database/procs/sp_GET_ProgramTypeList.sql` |
| `sp_GET_ProgramTypeListAll` | (none) | S |  |  |  |  | tblProgramType | `spec/database/procs/sp_GET_ProgramTypeListAll.sql` |
| `sp_GET_ProgramTypeListParm` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblProgramType | `spec/database/procs/sp_GET_ProgramTypeListParm.sql` |
| `sp_GET_ProgramTypeWithoutGeneralList` | (none) | S |  |  |  |  | tblProgramType | `spec/database/procs/sp_GET_ProgramTypeWithoutGeneralList.sql` |
| `sp_GET_RoleType` | (none) | S |  |  |  |  | tblRoleType | `spec/database/procs/sp_GET_RoleType.sql` |
| `sp_Get_RouteInfoforBacktoReturn` | @id INT | S |  |  |  |  | tblInvoice, tblOrder, tblRouteInformationMaster | `spec/database/procs/sp_Get_RouteInfoforBacktoReturn.sql` |
| `sp_Get_RouteInfoforCustPayment` | @id INT | S |  |  |  |  | tblInvoice, tblOrder | `spec/database/procs/sp_Get_RouteInfoforCustPayment.sql` |
| `sp_Get_RouteInfoforCustPaymentSnd` | @id INT | S |  |  |  |  | tblInvoice, tblOrder | `spec/database/procs/sp_Get_RouteInfoforCustPaymentSnd.sql` |
| `sp_Get_RouteInfoforReturn` | @id INT | S |  |  |  |  | tblInvoice, tblOrder | `spec/database/procs/sp_Get_RouteInfoforReturn.sql` |
| `sp_Get_RouteInfoforReturn2ndTimes` | @id INT | S |  |  |  |  | tblInvoice, tblOrder | `spec/database/procs/sp_Get_RouteInfoforReturn2ndTimes.sql` |
| `sp_Get_RouterMaster_ByRouterMasterId` | @id INT | S |  |  |  |  | RouterMaster | `spec/database/procs/sp_Get_RouterMaster_ByRouterMasterId.sql` |
| `sp_GET_RouterMasterInfo` | @Parameter NVARCHAR | S |  |  | Y |  | RouterMaster, tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_GET_RouterMasterInfo.sql` |
| `sp_GET_RSMInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblOrder, tblRSMInfo, tblRegion | `spec/database/procs/sp_GET_RSMInfo.sql` |
| `sp_GET_SMCTypeListParm` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblSMCType | `spec/database/procs/sp_GET_SMCTypeListParm.sql` |
| `sp_Get_StationType_Active` | (none) | S |  |  |  |  | tblStationType | `spec/database/procs/sp_Get_StationType_Active.sql` |
| `sp_GET_StationTypeList` | (none) | S |  |  |  |  | tblStationType | `spec/database/procs/sp_GET_StationTypeList.sql` |
| `sp_GET_StationTypeListAll` | (none) | S |  |  |  |  | tblStationType | `spec/database/procs/sp_GET_StationTypeListAll.sql` |
| `sp_GET_SubDepotByComUnitId` | @ComUnitId INT | S |  |  |  |  | tblSubDepot | `spec/database/procs/sp_GET_SubDepotByComUnitId.sql` |
| `sp_Get_SubmarketData_ById` | @id int | S |  |  |  |  | tbl_Area, tbl_Market, tbl_SubMarket, tbl_Territory, tbl_Zone | `spec/database/procs/sp_Get_SubmarketData_ById.sql` |
| `sp_Get_SubmarketList` | (none) | S |  |  |  |  | tbl_Area, tbl_Market, tbl_SubMarket, tbl_Territory, tbl_Zone | `spec/database/procs/sp_Get_SubmarketList.sql` |
| `sp_Get_subTerritoryData_BySubTerritoryId` | @id INT | S |  |  |  |  | tblArea, tblRegion, tblSubTerritory, tblTerritory, tbl_Group | `spec/database/procs/sp_Get_subTerritoryData_BySubTerritoryId.sql` |
| `sp_Get_SubTerritoryList` | @Parameter NVARCHAR | S |  |  | Y |  | tblArea, tblEmpGeneralInfo, tblMarket, tblRegion, tblSubTerritory, tblTerritory (+2 more) | `spec/database/procs/sp_Get_SubTerritoryList.sql` |
| `sp_Get_TadaClaimList` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblEmpGeneralInfo, tblMarket, tblStationType, tblTADAApprovalLog, tblUser (+2 more) | `spec/database/procs/sp_Get_TadaClaimList.sql` |
| `sp_Get_TadaClaimList_Approval` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblMarket, tbl_TadaClaimDetails, tbl_TadaClaimMaster, tbl_TourPlanInfo | `spec/database/procs/sp_Get_TadaClaimList_Approval.sql` |
| `sp_Get_TadaClaimList_new` | @param nvarchar | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sp_executesql, tblEmpGeneralInfo, tblMarket, tblStationType, tblTADAApprovalLog (+4 more) | `spec/database/procs/sp_Get_TadaClaimList_new.sql` |
| `sp_Get_TadaClaimMaster_ById` | @id INT | S |  |  |  |  | tbl_TadaClaimMaster | `spec/database/procs/sp_Get_TadaClaimMaster_ById.sql` |
| `sp_Get_TADAMarketRuleConfig_For_DDL` | (none) | S |  |  |  |  | tblStationType | `spec/database/procs/sp_Get_TADAMarketRuleConfig_For_DDL.sql` |
| `sp_Get_TADAMarketRulesConfig` | (none) | S |  |  |  |  | tblRoleType, tblStationType, tbl_TADAMarketRulesConfig | `spec/database/procs/sp_Get_TADAMarketRulesConfig.sql` |
| `sp_Get_TADAMarketRulesConfig_ByID` | @TADAMarketRuleConfigId INT | S |  |  |  |  | tbl_TADAMarketRulesConfig | `spec/database/procs/sp_Get_TADAMarketRulesConfig_ByID.sql` |
| `sp_GET_TerriToryByDCId` | @DCid NVARCHAR | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblRouteInformationMarketDetail, tblRouteInformationMaster, tblSubTerritory (+2 more) | `spec/database/procs/sp_GET_TerriToryByDCId.sql` |
| `sp_Get_TerritoryData_ByTerritoryId` | @id INT | S |  |  |  |  | tblArea, tblRegion, tblTerritory, tbl_Group, tbl_TerritoryThanaRelation | `spec/database/procs/sp_Get_TerritoryData_ByTerritoryId.sql` |
| `sp_Get_TerritoryList` | @RegionId int, @areaId int | S |  |  |  |  | tblArea, tblEmpGeneralInfo, tblMarket, tblRegion, tblTerritory, tblUser (+3 more) | `spec/database/procs/sp_Get_TerritoryList.sql` |
| `sp_Get_TerritoryListOrdPerALL` | (none) | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_Get_TerritoryListOrdPerALL.sql` |
| `sp_GET_tFiscalYearList` | (none) | S |  |  |  |  | tblFinancialYear | `spec/database/procs/sp_GET_tFiscalYearList.sql` |
| `sp_Get_Thana_WithTagInfo` | (none) | S |  |  |  |  | tbl_Thana | `spec/database/procs/sp_Get_Thana_WithTagInfo.sql` |
| `sp_Get_Thana_WithTagInfo_TerritoryEdit` | @id int | S |  |  |  |  | tblTerritory, tbl_TerritoryThanaRelation, tbl_Thana | `spec/database/procs/sp_Get_Thana_WithTagInfo_TerritoryEdit.sql` |
| `sp_GET_ThanaList` | @id int | S |  |  |  |  | tbl_Thana | `spec/database/procs/sp_GET_ThanaList.sql` |
| `sp_Get_ThanaList_OnlyActive_Bydistrict_id` | @id int | S |  |  |  |  | tbl_Thana | `spec/database/procs/sp_Get_ThanaList_OnlyActive_Bydistrict_id.sql` |
| `sp_GET_TherapeuticGroup_ById` | @id NVARCHAR | S |  |  |  |  | tblTherapeuticGroup | `spec/database/procs/sp_GET_TherapeuticGroup_ById.sql` |
| `sp_GET_TherapueticGroup` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblTherapeuticGroup, tblUser | `spec/database/procs/sp_GET_TherapueticGroup.sql` |
| `sp_GET_ToSheetcode_ById` | @id NVARCHAR | S |  |  |  |  | tblTopSheetGenReport | `spec/database/procs/sp_GET_ToSheetcode_ById.sql` |
| `sp_Get_TourPlanByTourPlanDate` | @tadaDate DATETIME, @empId INT | SU |  |  |  |  | tblUser, tbl_TADAMarketRulesConfig, tbl_TourPlanInfo, tbl_UserRoleInfo | `spec/database/procs/sp_Get_TourPlanByTourPlanDate.sql` |
| `sp_Get_TourPlanDetailsById` | @id INT | S |  |  |  |  | tblDesignation, tblEmpGeneralInfo, tblMarket, tblStationType, tblTPMarketDetail, tbl_TourPlanInfo (+2 more) | `spec/database/procs/sp_Get_TourPlanDetailsById.sql` |
| `sp_Get_TourPlanMasteList` | @param NVARCHAR | S |  |  | Y |  | tblDesignation, tblEmpGeneralInfo, tblUser, tbl_TourPlanMaster, tbl_UserRoleInfo | `spec/database/procs/sp_Get_TourPlanMasteList.sql` |
| `sp_Get_TourPlanTypeDDL` | (none) | S |  |  |  |  | tblStationType | `spec/database/procs/sp_Get_TourPlanTypeDDL.sql` |
| `sp_GET_TourPlanUserListByParm` | @Parm NVARCHAR | S |  |  | Y |  | tblDesignation, tblEmpGeneralInfo, tbl_TourPlanMaster | `spec/database/procs/sp_GET_TourPlanUserListByParm.sql` |
| `sp_Get_TourPlanYear` | (none) | S |  |  |  |  | tbl_TourPlanMaster | `spec/database/procs/sp_Get_TourPlanYear.sql` |
| `sp_Get_TourPurpose_ById` | @id INT | S |  |  |  |  | tbl_TourPlanPurpose | `spec/database/procs/sp_Get_TourPurpose_ById.sql` |
| `sp_Get_TourPurposeDDL` | (none) | S |  |  |  |  | tbl_TourPlanPurpose | `spec/database/procs/sp_Get_TourPurposeDDL.sql` |
| `sp_Get_TourPurposeDDLNew` | (none) | S |  |  |  |  | tblTourPurposeOtherSetup, tbl_TourPlanPurpose | `spec/database/procs/sp_Get_TourPurposeDDLNew.sql` |
| `sp_Get_TourPurposeOtherSetupId` | @id INT | S |  |  |  |  | tblArea, tblRegion, tblStationType, tblTerritory, tblTourPurposeOtherSetup, tblTourPurposeOtherSetupDtl (+1 more) | `spec/database/procs/sp_Get_TourPurposeOtherSetupId.sql` |
| `sp_Get_TourType` | (none) | S |  |  |  |  | tbl_TourPlanType | `spec/database/procs/sp_Get_TourType.sql` |
| `sp_Get_TourType_ById` | @id INT | S |  |  |  |  | tbl_TourPlanType | `spec/database/procs/sp_Get_TourType_ById.sql` |
| `sp_GET_TrainingDetailMarket_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblSubTerritory, tblTerritory, tbl_Group (+1 more) | `spec/database/procs/sp_GET_TrainingDetailMarket_ById.sql` |
| `sp_Get_Trainning_ById` | @id INT | S |  |  |  |  | tblTrainingUserRoleDetail, tblTrainning | `spec/database/procs/sp_Get_Trainning_ById.sql` |
| `sp_Get_Trainninglist` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblTrainning, tblUser | `spec/database/procs/sp_Get_Trainninglist.sql` |
| `sp_Get_Transport` | (none) | S |  |  |  |  | tblEmpGeneralInfo, tblUser, tbl_Transport | `spec/database/procs/sp_Get_Transport.sql` |
| `sp_Get_Transport_ById` | @id INT | S |  |  |  |  | tbl_Transport | `spec/database/procs/sp_Get_Transport_ById.sql` |
| `sp_Get_TTargetAChivementReport` | @_Month nvarchar, @_Year nvarchar, @FromDate nvarchar, @ToDate nvarchar (+3 more) | S |  |  |  |  | GetMonthYearValuesDateRange, tblArea, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail (+3 more) | `spec/database/procs/sp_Get_TTargetAChivementReport.sql` |
| `sp_Get_TTargetAChivementReport_nnn` | @FromDate nvarchar, @ToDate nvarchar, @Type nvarchar, @ZoneId nvarchar (+2 more) | S |  |  |  |  | GetMonthYearValuesDateRange, tblArea, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail (+3 more) | `spec/database/procs/sp_Get_TTargetAChivementReport_nnn.sql` |
| `sp_GET_UserDetailMarket_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblSubTerritory, tblTerritory, tbl_Group (+1 more) | `spec/database/procs/sp_GET_UserDetailMarket_ById.sql` |
| `sp_Get_UserLocationTracking` | @empid INT, @trackDate DATETIME | S |  |  |  |  | tbl_UserTracking | `spec/database/procs/sp_Get_UserLocationTracking.sql` |
| `sp_GET_UserMaster_ByEmpId` | @id NVARCHAR | S |  |  |  |  | tblUser, tblUserCompanyUnit | `spec/database/procs/sp_GET_UserMaster_ByEmpId.sql` |
| `sp_GET_UserMaster_ById` | @id NVARCHAR | S |  |  |  |  | tblUser, tblUserCompanyUnit | `spec/database/procs/sp_GET_UserMaster_ById.sql` |
| `sp_Get_UserRoleInfo` | (none) | S |  |  |  |  | tbl_UserRoleInfo | `spec/database/procs/sp_Get_UserRoleInfo.sql` |
| `sp_GET_UserRoleInfo_ById` | @id NVARCHAR | S |  |  |  |  | tbl_UserRoleInfo | `spec/database/procs/sp_GET_UserRoleInfo_ById.sql` |
| `sp_GET_UserRoleInfoRoleType_ById` | @id NVARCHAR | S |  |  |  |  | tblRoleType, tbl_UserRoleInfo | `spec/database/procs/sp_GET_UserRoleInfoRoleType_ById.sql` |
| `sp_GET_UserRoleList` | @Parameter NVARCHAR | S |  |  | Y |  | tblRoleType, tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_GET_UserRoleList.sql` |
| `sp_Get_UserTypeInfo` | (none) | S |  |  |  |  | tblUserType | `spec/database/procs/sp_Get_UserTypeInfo.sql` |
| `sp_GET_VacentArea` | @RegionId INT | S |  |  |  |  | tblASMInfo, tblArea, tblRegion | `spec/database/procs/sp_GET_VacentArea.sql` |
| `sp_GET_VacentGroup` | (none) | S |  |  |  |  | tblNSMInfo, tbl_Group | `spec/database/procs/sp_GET_VacentGroup.sql` |
| `sp_GET_VacentRegion` | @GroupId INT | S |  |  |  |  | tblRSMInfo, tblRegion | `spec/database/procs/sp_GET_VacentRegion.sql` |
| `sp_GET_VacentTerritory` | @AreaId INT | S |  |  |  |  | tblArea, tblMIOInfo, tblMioInfo, tblRegion, tblTerritory | `spec/database/procs/sp_GET_VacentTerritory.sql` |
| `sp_Get_Zone_All_Active` | @GroupId INT | S |  |  |  |  | tblRegion | `spec/database/procs/sp_Get_Zone_All_Active.sql` |
| `sp_Get_Zone_AllByGroup` | @GroupId INT | S |  |  |  |  | tblRegion | `spec/database/procs/sp_Get_Zone_AllByGroup.sql` |
| `sp_Get_Zone_AllByGroupRpt` | @GroupId INT | S |  |  |  |  | tblRegion | `spec/database/procs/sp_Get_Zone_AllByGroupRpt.sql` |
| `sp_Get_Zone_ForDSM` | @GroupId nvarchar | S |  |  |  |  | fnSplit, tblRegion | `spec/database/procs/sp_Get_Zone_ForDSM.sql` |
| `sp_Get_ZoneData_ByZoneId` | @id int | S |  |  |  |  | tblRegion, tbl_ZoneDivisionRelation | `spec/database/procs/sp_Get_ZoneData_ByZoneId.sql` |
| `sp_Get_ZoneList` | (none) | S |  |  |  |  | tblArea, tblEmpGeneralInfo, tblRegion, tblUser, tbl_Division, tbl_Group (+1 more) | `spec/database/procs/sp_Get_ZoneList.sql` |
| `sp_Get_ZoneListOrdPer` | (none) | S |  |  |  |  | tblRegion | `spec/database/procs/sp_Get_ZoneListOrdPer.sql` |
| `sp_GetChamber_ByDoctorId` | @DoctorId INT | S |  |  |  |  | tblDoctorChemberDetail | `spec/database/procs/sp_GetChamber_ByDoctorId.sql` |
| `sp_GetOrderInvoiceIsZero` | (none) | S |  |  |  |  | tblorder | `spec/database/procs/sp_GetOrderInvoiceIsZero.sql` |
| `sp_HigharchyInfoByEmployeeId` | @EmployeeId INT, @RoleId INT | S |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblArea, tblRegion, tblTerritory, tbl_Group | `spec/database/procs/sp_HigharchyInfoByEmployeeId.sql` |
| `sp_I_DepotWiseArea` | @DepotId INT, @AreaId INT, @EntryBy INT | SI |  |  |  |  | tblDcWiseAreaInfo | `spec/database/procs/sp_I_DepotWiseArea.sql` |
| `sp_opeingBalanceCreate` | @FinancialYear NVARCHAR, @FromDate DATE, @ToDate DATE | SI | Y | Y |  |  | tblInvoice, tblInvoiceDetail, tblOpeningBalanceFinancialYearLog, tblOrder, tblOrderDetail, tblPendingDeliveryInvoice_Detail (+1 more) | `spec/database/procs/sp_opeingBalanceCreate.sql` |
| `sp_RSMInfoByEmployeeId` | @EmployeeId INT | S |  |  |  |  | tblRSMInfo, tblRegion | `spec/database/procs/sp_RSMInfoByEmployeeId.sql` |
| `sp_Save_AreaDistictRelation` | @areaId INT, @districtId int | I |  |  |  |  | tbl_AreaDistrictRelation | `spec/database/procs/sp_Save_AreaDistictRelation.sql` |
| `sp_Save_AreaInfo` | @id INT, @zoneId INT, @areaName NVARCHAR, @CodeStr NVARCHAR (+4 more) | SI |  |  |  |  | tblArea | `spec/database/procs/sp_Save_AreaInfo.sql` |
| `sp_Save_ASMInfo` | @ASMId INT, @CompanyId INT, @AreaId INT, @EmployeeId INT (+3 more) | SI |  |  |  |  | tblASMInfo | `spec/database/procs/sp_Save_ASMInfo.sql` |
| `sp_Save_DepartmentInfo` | @id INT, @DepartmentName NVARCHAR, @EntryBy INT, @IsActive BIT | SI |  |  |  |  | tblDepartment | `spec/database/procs/sp_Save_DepartmentInfo.sql` |
| `sp_Save_DesignationInfo` | @id INT, @DesigName NVARCHAR, @EntryBy INT, @IsActive BIT | SI |  |  |  |  | tblDesignation | `spec/database/procs/sp_Save_DesignationInfo.sql` |
| `sp_Save_DivisionZoneRelation` | @zoneId INT, @divisionId INT | I |  |  |  |  | tbl_ZoneDivisionRelation | `spec/database/procs/sp_Save_DivisionZoneRelation.sql` |
| `sp_Save_DoctorCategory` | @CategoryId INT, @CategoryName NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tblDoctorCategory | `spec/database/procs/sp_Save_DoctorCategory.sql` |
| `sp_Save_DoctorChamber` | @ChamberId INT, @ChamberName NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tblDoctorChamber | `spec/database/procs/sp_Save_DoctorChamber.sql` |
| `sp_Save_DoctorDegree` | @DegreeId INT, @DoctorTypeId int, @DegreeName NVARCHAR, @IsActive BIT (+2 more) | SI |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Save_DoctorDegree.sql` |
| `sp_Save_DoctorDesignation` | @DesignationId INT, @DesignationName NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tblDoctorDesignation | `spec/database/procs/sp_Save_DoctorDesignation.sql` |
| `sp_Save_DoctorPatientType` | @PatientTypeId INT, @PatientType NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tblDoctorPatientType | `spec/database/procs/sp_Save_DoctorPatientType.sql` |
| `sp_Save_DoctorSpecialDay` | @SpecialDayId INT, @SpecialDay NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tblDoctorSpecialDay | `spec/database/procs/sp_Save_DoctorSpecialDay.sql` |
| `sp_Save_DoctorSpeciality` | @SpecialityId INT, @SpecialityName NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tblDoctorSpeciality | `spec/database/procs/sp_Save_DoctorSpeciality.sql` |
| `sp_Save_Employe_LeaveType_Infos` | @LeaveTypeId INT, @LeaveTypeName NVARCHAR, @LeaveDays INT, @IsActive BIT (+1 more) | SI |  |  |  |  | Employe_LeaveTypeInfos | `spec/database/procs/sp_Save_Employe_LeaveType_Infos.sql` |
| `sp_Save_Employee_Holiday` | @HolidayId INT, @FiscalYear INT, @HolidayDate DATETIME, @HolidayToDate DATETIME (+3 more) | SI |  |  |  |  | Employee_GovtHolidays | `spec/database/procs/sp_Save_Employee_Holiday.sql` |
| `sp_Save_ExpenseClaimDetails` | @ExpenseClaimID INT, @ExpenseTypDetailsId INT, @ValueText NVARCHAR | I |  |  |  |  | tbl_ExpenseClaimDetails | `spec/database/procs/sp_Save_ExpenseClaimDetails.sql` |
| `sp_Save_ExpenseClaimMaster` | @ExpenseClaimID INT, @ExpenseTypeId INT, @ExpenseDate DATETIME, @EmpInfoId INT (+3 more) | SI |  |  |  |  | tbl_ExpenseClaim | `spec/database/procs/sp_Save_ExpenseClaimMaster.sql` |
| `sp_Save_ExpenseTypeDetails` | @ExpenseTypDetailsId INT, @ExpenseTypeId INT, @FieldName NVARCHAR, @IsRequied BIT | SI |  |  |  |  | tbl_ExpenseTypeDetails | `spec/database/procs/sp_Save_ExpenseTypeDetails.sql` |
| `sp_Save_ExpenseTypeMaster` | @ExpenseTypeId INT, @RoleType_xp INT, @ExpenseTypeName NVARCHAR, @RoleTypeMult NVARCHAR (+6 more) | SI |  |  |  |  | tbl_ExpenseTypeMaster | `spec/database/procs/sp_Save_ExpenseTypeMaster.sql` |
| `sp_Save_FinancialYearInfo` | @id INT, @YearFromDate datetime, @YearTodate datetime, @EntryBy INT (+1 more) | SI |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_Save_FinancialYearInfo.sql` |
| `sp_Save_GenericGroup` | @id INT, @GenericGroupName NVARCHAR, @EntryBy INT, @IsActive BIT (+2 more) | SI |  |  |  |  | tblGenericGroup | `spec/database/procs/sp_Save_GenericGroup.sql` |
| `sp_Save_GroupInfo` | @id INT, @NationalId INT, @GroupName NVARCHAR, @CodeStr NVARCHAR (+2 more) | SI |  |  |  |  | tbl_Group | `spec/database/procs/sp_Save_GroupInfo.sql` |
| `sp_Save_MarketData` | @id INT, @SubTerritoryId INT, @Name NVARCHAR, @createdBy NVARCHAR (+4 more) | SI |  |  |  |  | tblMarket | `spec/database/procs/sp_Save_MarketData.sql` |
| `sp_Save_MarketStationDetail` | @MarketId INT, @StationTypeId INT, @UserRoleID INT | I |  |  |  |  | tblMarketStationDetail | `spec/database/procs/sp_Save_MarketStationDetail.sql` |
| `sp_Save_MileageClaim` | @MileageClaimId INT, @MileageDate DATETIME, @TransportId INT, @MileageInKM DECIMAL (+11 more) | SI |  |  |  |  | tbl_MileageClaim | `spec/database/procs/sp_Save_MileageClaim.sql` |
| `sp_Save_MIOInfo` | @MIOId INT, @CompanyId INT, @TerritoryId INT, @EmployeeId INT (+3 more) | SI |  |  |  |  | tblMIOInfo | `spec/database/procs/sp_Save_MIOInfo.sql` |
| `sp_Save_MonthlyAllowance` | @MonthlyAllowanceId INT, @RoleName NVARCHAR, @AllowanceName NVARCHAR, @AllowanceAmount DECIMAL (+2 more) | SIU |  |  |  |  | tblMonthlyAllowances | `spec/database/procs/sp_Save_MonthlyAllowance.sql` |
| `sp_Save_MonthlyAllowanceDetail` | @MonthlyAllowanceId INT, @EmpInfoId int, @UserRoleId int | I |  |  |  |  | tbl_MonthlyAllowanceDetail | `spec/database/procs/sp_Save_MonthlyAllowanceDetail.sql` |
| `sp_Save_NSMHeadInfo` | @NSMId INT, @CompanyId INT, @GroupId INT, @EmployeeId INT (+3 more) | SI |  |  |  |  | tblNational_NSM | `spec/database/procs/sp_Save_NSMHeadInfo.sql` |
| `sp_Save_NSMInfo` | @NSMId INT, @CompanyId INT, @GroupId INT, @EmployeeId INT (+3 more) | SI |  |  |  |  | tblNSMInfo | `spec/database/procs/sp_Save_NSMInfo.sql` |
| `sp_Save_OrderPermission` | @TerritoryId INT, @PermittedEmpId INT, @FrmDate datetime, @ToDate datetime (+1 more) | SID |  |  |  |  | tblOrderPermission | `spec/database/procs/sp_Save_OrderPermission.sql` |
| `sp_Save_PrescriptionMaster` | @PrescriptionId INT OUT, @PrescriptionDate DATETIME, @PrescriptionTypeId INT, @DoctorId INT (+4 more) | SI |  |  |  |  | tbl_PrescriptionMaster | `spec/database/procs/sp_Save_PrescriptionMaster.sql` |
| `sp_Save_PrescriptionProductDetail` | @PrescriptionId INT, @ProductId INT | SI |  |  |  |  | tbl_PrescriptionProductDetail | `spec/database/procs/sp_Save_PrescriptionProductDetail.sql` |
| `sp_Save_PrescriptionType` | @PrescriptionTypeId INT, @PrescriptionType NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_Save_PrescriptionType.sql` |
| `sp_Save_ProductLine` | @id INT, @LineName NVARCHAR, @EntryBy INT, @IsActive BIT (+2 more) | SI |  |  |  |  | tblProductLine | `spec/database/procs/sp_Save_ProductLine.sql` |
| `sp_Save_RouterDetails` | @id INT, @RouterMasterId INT, @TerritoryId INT, @MarketId INT | SI |  |  |  |  | RouterDetails | `spec/database/procs/sp_Save_RouterDetails.sql` |
| `sp_Save_RouterMaster` | @id INT, @RouterName NVARCHAR, @EntryBy INT | SI |  |  |  |  | RouterMaster | `spec/database/procs/sp_Save_RouterMaster.sql` |
| `sp_Save_RSMInfo` | @RSMId INT, @CompanyId INT, @RegionId INT, @EmployeeId INT (+3 more) | SI |  |  |  |  | tblRSMInfo | `spec/database/procs/sp_Save_RSMInfo.sql` |
| `sp_Save_ShiftInfos` | @ShiftId INT, @ShiftText NVARCHAR, @ShiftInTime TIME, @ShiftOutTime TIME (+3 more) | SI |  |  |  |  | tbl_Shift | `spec/database/procs/sp_Save_ShiftInfos.sql` |
| `sp_Save_SubMarketData` | @id INT, @marketId INT, @Name NVARCHAR, @createdBy NVARCHAR (+3 more) | SI |  |  |  |  | tbl_CodeSetup, tbl_SubMarket | `spec/database/procs/sp_Save_SubMarketData.sql` |
| `sp_Save_SubTerritoryInfo` | @id INT, @TerritoryId INT, @Name NVARCHAR, @createdBy NVARCHAR (+2 more) | SI |  |  |  |  | tblSubTerritory | `spec/database/procs/sp_Save_SubTerritoryInfo.sql` |
| `sp_Save_TadaClaimMaster` | @TadaID INT, @TadaDate datetime, @Remarks NVARCHAR, @TourTypeId int (+11 more) | SI |  |  |  |  | tblArea, tblRegion, tblSubTerritory, tblTerritory, tbl_Group, tbl_TadaClaimMaster (+1 more) | `spec/database/procs/sp_Save_TadaClaimMaster.sql` |
| `sp_Save_TADAMarketRulesConfig` | @TADAMarketRuleConfigId INT, @TourType INT, @TAAmount decimal, @DAAmount decimal (+11 more) | SI |  |  |  |  | tbl_TADAMarketRulesConfig | `spec/database/procs/sp_Save_TADAMarketRulesConfig.sql` |
| `sp_Save_TerritoryInfo` | @id INT, @areaId INT, @Name NVARCHAR, @CodeStr NVARCHAR (+4 more) | SI |  |  |  |  | tblTerritory | `spec/database/procs/sp_Save_TerritoryInfo.sql` |
| `sp_Save_TerritoryThanaRelation` | @territroId INT, @thanaId int | I |  |  |  |  | tbl_TerritoryThanaRelation | `spec/database/procs/sp_Save_TerritoryThanaRelation.sql` |
| `sp_Save_TherapeuticGroup` | @id INT, @TherapeuticGroupName NVARCHAR, @EntryBy INT, @IsActive BIT (+2 more) | SI |  |  |  |  | tblTherapeuticGroup | `spec/database/procs/sp_Save_TherapeuticGroup.sql` |
| `sp_Save_TopSheetGenReportCode` | @EntryBy int, @DeliveryMan NVARCHAR | SI |  |  |  |  | tblTopSheetGenReport | `spec/database/procs/sp_Save_TopSheetGenReportCode.sql` |
| `sp_Save_TourPurpose` | @TPId INT, @TPName NVARCHAR, @IsActive BIT, @IsOtherVisit int (+6 more) | SI |  |  |  |  | tbl_TourPlanPurpose | `spec/database/procs/sp_Save_TourPurpose.sql` |
| `sp_Save_TourType` | @TourTypeId INT, @TourTypeName NVARCHAR, @IsActive BIT, @Activedate DATETIME (+1 more) | SI |  |  |  |  | tbl_TourPlanType | `spec/database/procs/sp_Save_TourType.sql` |
| `sp_Save_TrainingMarketDetail` | @TrainningId INT, @GroupId INT, @RegionId INT, @AreaId INT (+3 more) | SID |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblTraining_Employee, tbl_TrainingMarketDetail | `spec/database/procs/sp_Save_TrainingMarketDetail.sql` |
| `sp_Save_TrainingUserRoleDetail` | @UserRoleID INT, @TrainningId INT | SID |  |  |  |  | tblTrainingUserRoleDetail, tblTraining_Employee, tblUser | `spec/database/procs/sp_Save_TrainingUserRoleDetail.sql` |
| `sp_Save_Trainning` | @TrainningId INT, @Title Nvarchar, @Description Nvarchar, @TrainningMeterial Nvarchar (+4 more) | SI |  |  |  |  | tblTrainning | `spec/database/procs/sp_Save_Trainning.sql` |
| `sp_Save_Transport` | @TransportId INT, @TransportName NVARCHAR, @AllowedMilagePerKM decimal, @IsActive BIT (+1 more) | SI |  |  |  |  | tbl_Transport | `spec/database/procs/sp_Save_Transport.sql` |
| `sp_Save_UserCompanyUnit` | @UserId INT, @ComUnitId INT | I |  |  |  |  | tblUserCompanyUnit | `spec/database/procs/sp_Save_UserCompanyUnit.sql` |
| `sp_Save_UserMarketDetail` | @UserId INT, @GroupId INT, @RegionId INT, @AreaId INT (+3 more) | SI |  |  | Y |  | View_webapi_FieldForce, sys, tblUserMarketExecss, tbl_UserMarketDetail | `spec/database/procs/sp_Save_UserMarketDetail.sql` |
| `sp_Save_UserMaster_New` | @UserId INT, @UserName nvarchar, @UserType nvarchar, @LoginName nvarchar (+13 more) | SI |  |  |  |  | tblUser | `spec/database/procs/sp_Save_UserMaster_New.sql` |
| `sp_Save_UserRoleInfo` | @UserRoleID INT, @RoleName NVARCHAR, @entryBy INT, @RoleTypeId INT (+2 more) | SI |  |  |  |  | tbl_UserRoleInfo | `spec/database/procs/sp_Save_UserRoleInfo.sql` |
| `sp_Save_ZoneInfo` | @zoneId INT, @zoneName NVARCHAR, @CodeStr NVARCHAR, @createdBy NVARCHAR (+4 more) | SI |  |  |  |  | tblRegion | `spec/database/procs/sp_Save_ZoneInfo.sql` |
| `sp_UD_ASMInfo` | @ASMId INT, @CompanyId INT, @AreaId INT, @EmployeeId INT (+3 more) | U |  |  |  |  | tblASMInfo | `spec/database/procs/sp_UD_ASMInfo.sql` |
| `sp_UD_DepartmentInfo` | @id INT, @DepartmentName NVARCHAR, @UpdateBy INT, @IsActive BIT | U |  |  |  |  | tblDepartment | `spec/database/procs/sp_UD_DepartmentInfo.sql` |
| `sp_UD_DepotWiseArea` | @DepotWiseAreaId INT, @UpdateBy INT | U |  |  |  |  | tblDcWiseAreaInfo | `spec/database/procs/sp_UD_DepotWiseArea.sql` |
| `sp_UD_DesignationInfo` | @id INT, @DesigName NVARCHAR, @UpdateBy INT, @IsActive BIT | U |  |  |  |  | tblDesignation | `spec/database/procs/sp_UD_DesignationInfo.sql` |
| `sp_UD_FinancialYearInfo` | @id INT, @YearFromDate datetime, @YearTodate datetime, @UpdateBy INT (+1 more) | SU |  |  |  |  | tblFiscalYearInfos | `spec/database/procs/sp_UD_FinancialYearInfo.sql` |
| `sp_UD_GenericGroup` | @id INT, @GenericGroupName NVARCHAR, @UpdateBy INT, @IsActive BIT (+2 more) | U |  |  |  |  | tblGenericGroup | `spec/database/procs/sp_UD_GenericGroup.sql` |
| `sp_UD_GroupInfo` | @id INT, @GroupName NVARCHAR, @NationalId INT, @CodeStr NVARCHAR (+2 more) | U |  |  |  |  | tbl_Group | `spec/database/procs/sp_UD_GroupInfo.sql` |
| `sp_UD_Insert_ASMInfo` | @ASMId INT, @CompanyId INT, @AreaId INT, @EmployeeId INT (+3 more) | IU |  |  |  |  | tblASMInfo | `spec/database/procs/sp_UD_Insert_ASMInfo.sql` |
| `sp_UD_Insert_MIOInfo` | @MIOId INT, @CompanyId INT, @TerritoryId INT, @EmployeeId INT (+3 more) | IU |  |  |  |  | tblMIOInfo | `spec/database/procs/sp_UD_Insert_MIOInfo.sql` |
| `sp_UD_MIOInfo` | @MIOId INT, @CompanyId INT, @TerritoryId INT, @EmployeeId INT (+3 more) | U |  |  |  |  | tblMIOInfo | `spec/database/procs/sp_UD_MIOInfo.sql` |
| `sp_UD_NSMHeadInfo` | @NSMId INT, @CompanyId INT, @GroupId INT, @EmployeeId INT (+3 more) | U |  |  |  |  | tblNational_NSM | `spec/database/procs/sp_UD_NSMHeadInfo.sql` |
| `sp_UD_NSMInfo` | @NSMId INT, @CompanyId INT, @GroupId INT, @EmployeeId INT (+3 more) | U |  |  |  |  | tblNSMInfo | `spec/database/procs/sp_UD_NSMInfo.sql` |
| `sp_UD_ProductLine` | @id INT, @LineName NVARCHAR, @UpdateBy INT, @IsActive BIT (+2 more) | U |  |  |  |  | tblProductLine | `spec/database/procs/sp_UD_ProductLine.sql` |
| `sp_UD_RSMInfo` | @RSMId INT, @CompanyId INT, @RegionId INT, @EmployeeId INT (+3 more) | U |  |  |  |  | tblRSMInfo | `spec/database/procs/sp_UD_RSMInfo.sql` |
| `sp_UD_TherapeuticGroup` | @id INT, @TherapeuticGroupName NVARCHAR, @UpdateBy INT, @IsActive BIT (+2 more) | U |  |  |  |  | tblTherapeuticGroup | `spec/database/procs/sp_UD_TherapeuticGroup.sql` |
| `sp_UD_UserRoleInfo` | @UserRoleID INT, @RoleName NVARCHAR, @entryBy INT, @RoleTypeId INT (+2 more) | U |  |  |  |  | tbl_UserRoleInfo | `spec/database/procs/sp_UD_UserRoleInfo.sql` |
| `sp_Update_AreaInfo` | @id INT, @zoneId INT, @areaName NVARCHAR, @createdBy NVARCHAR (+4 more) | SUD |  |  |  |  | tblArea, tbl_AreaDistrictRelation | `spec/database/procs/sp_Update_AreaInfo.sql` |
| `sp_Update_ASMActiveStatus` | @ASMId INT, @InactiveBy INT | U |  |  |  |  | tblASMInfo | `spec/database/procs/sp_Update_ASMActiveStatus.sql` |
| `sp_Update_CustomerInfoForMarketData` | @MasterId INT | SU |  |  |  |  | tblArea, tblCustMaster, tblMarketStationDetail, tblRegion, tblSubTerritory, tblTerritory (+4 more) | `spec/database/procs/sp_Update_CustomerInfoForMarketData.sql` |
| `sp_Update_DoctorCategory` | @CategoryId INT, @CategoryName NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblDoctorCategory | `spec/database/procs/sp_Update_DoctorCategory.sql` |
| `sp_Update_DoctorChamber` | @ChamberId INT, @ChamberName NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblDoctorChamber | `spec/database/procs/sp_Update_DoctorChamber.sql` |
| `sp_Update_DoctorDegree` | @DegreeId INT, @DegreeName NVARCHAR, @DoctorTypeId int, @UpdateBy NVARCHAR (+3 more) | U |  |  |  |  | tblDoctorDegree | `spec/database/procs/sp_Update_DoctorDegree.sql` |
| `sp_Update_DoctorDesignation` | @DesignationId INT, @DesignationName NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblDoctorDesignation | `spec/database/procs/sp_Update_DoctorDesignation.sql` |
| `sp_Update_DoctorPatientType` | @PatientTypeId INT, @PatientType NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblDoctorPatientType | `spec/database/procs/sp_Update_DoctorPatientType.sql` |
| `sp_Update_DoctorSpecialDay` | @SpecialDayId INT, @SpecialDay NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblDoctorSpecialDay | `spec/database/procs/sp_Update_DoctorSpecialDay.sql` |
| `sp_Update_DoctorSpeciality` | @SpecialityId INT, @SpecialityName NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblDoctorSpeciality | `spec/database/procs/sp_Update_DoctorSpeciality.sql` |
| `sp_Update_Employee_Holiday` | @HolidayId INT, @FiscalYear INT, @HolidayDate DATETIME, @HolidayToDate DATETIME (+3 more) | U |  |  |  |  | Employee_GovtHolidays | `spec/database/procs/sp_Update_Employee_Holiday.sql` |
| `sp_Update_Employee_Leave_info` | @LeaveTypeId INT, @LeaveTypeName NVARCHAR, @LeaveDays INT, @IsActive BIT (+1 more) | U |  |  |  |  | Employe_LeaveTypeInfos | `spec/database/procs/sp_Update_Employee_Leave_info.sql` |
| `sp_Update_Employee_ShiftInfos` | @ShiftId INT, @ShiftText NVARCHAR, @ShiftInTime TIME, @ShiftOutTime TIME (+3 more) | U |  |  |  |  | tbl_Shift | `spec/database/procs/sp_Update_Employee_ShiftInfos.sql` |
| `sp_Update_ExpenseClaim` | @ExpenseClaimID INT, @ExpenseTypeId INT, @ExpenseDate DATETIME, @EmpInfoId INT (+3 more) | SIUD |  |  |  |  | tbl_ExpenseClaim, tbl_ExpenseClaimDetails, tbl_ExpenseClaimLog | `spec/database/procs/sp_Update_ExpenseClaim.sql` |
| `sp_Update_ExpenseType` | @ExpenseTypeId INT, @ExpenseTypeName NVARCHAR, @ExpenseAmount decimal, @ImageRequired NVARCHAR (+6 more) | UD |  |  |  |  | tbl_ExpenseTypeDetails, tbl_ExpenseTypeMaster | `spec/database/procs/sp_Update_ExpenseType.sql` |
| `sp_Update_ExpenseTypeDetails` | @ExpenseTypDetailsId INT, @ExpenseTypeId INT, @FieldName NVARCHAR, @IsRequied BIT | U |  |  |  |  | tbl_ExpenseTypeDetails | `spec/database/procs/sp_Update_ExpenseTypeDetails.sql` |
| `sp_Update_MarketData` | @id INT, @SubTerritoryId INT, @Name NVARCHAR, @createdBy NVARCHAR (+4 more) | UD |  |  |  |  | tblMarket, tblMarketStationDetail | `spec/database/procs/sp_Update_MarketData.sql` |
| `sp_Update_MileageClaim` | @MileageClaimId INT, @MileageDate DATETIME, @TransportId INT, @MileageInKM DECIMAL (+11 more) | U |  |  |  |  | tbl_MileageClaim | `spec/database/procs/sp_Update_MileageClaim.sql` |
| `sp_Update_MIOActiveStatus` | @MIOId INT, @InactiveBy INT | U |  |  |  |  | tblMIOInfo | `spec/database/procs/sp_Update_MIOActiveStatus.sql` |
| `sp_Update_MonthlyAllowance` | @MonthlyAllowanceId INT, @MonthlyAllowanceName NVARCHAR, @MonthlyAllowance Decimal, @UpdateBy NVARCHAR (+2 more) | UD |  |  |  |  | tbl_MonthlyAllowance, tbl_MonthlyAllowanceDetail | `spec/database/procs/sp_Update_MonthlyAllowance.sql` |
| `sp_Update_PrescriptionMaster` | @PrescriptionId INT, @PrescriptionDate DATETIME, @PrescriptionTypeId INT, @DoctorId INT (+4 more) | UD |  |  |  |  | tbl_PrescriptionMaster, tbl_PrescriptionProductDetail | `spec/database/procs/sp_Update_PrescriptionMaster.sql` |
| `sp_Update_PrescriptionType` | @PrescriptionTypeId INT, @PrescriptionType NVARCHAR, @UpdateBy NVARCHAR, @remarks NVARCHAR (+2 more) | U |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_Update_PrescriptionType.sql` |
| `sp_Update_RouterMaster` | @id INT, @RouterName NVARCHAR, @UpdateBy INT | UD |  |  |  |  | RouterDetails, RouterMaster | `spec/database/procs/sp_Update_RouterMaster.sql` |
| `sp_Update_RSMActiveStatus` | @RSMId INT, @InactiveBy INT | U |  |  |  |  | tblRSMInfo | `spec/database/procs/sp_Update_RSMActiveStatus.sql` |
| `sp_Update_SubTerritoryData` | @id INT, @TerritoryId INT, @Name NVARCHAR, @createdBy NVARCHAR (+3 more) | U |  |  |  |  | tblSubTerritory | `spec/database/procs/sp_Update_SubTerritoryData.sql` |
| `sp_Update_TadaClaimMaster` | @TadaID INT, @TadaDate datetime, @Remarks NVARCHAR, @TourTypeId int (+11 more) | U |  |  |  |  | tbl_TadaClaimMaster | `spec/database/procs/sp_Update_TadaClaimMaster.sql` |
| `sp_Update_TADAMarketRulesConfig` | @TADAMarketRuleConfigId INT, @TourType INT, @TAAmount decimal, @DAAmount decimal (+11 more) | U |  |  |  |  | tbl_TADAMarketRulesConfig | `spec/database/procs/sp_Update_TADAMarketRulesConfig.sql` |
| `sp_Update_TerritoryData` | @id INT, @areaId INT, @CodeStr NVARCHAR, @Name NVARCHAR (+4 more) | UD |  |  |  |  | tblTerritory, tbl_TerritoryThanaRelation | `spec/database/procs/sp_Update_TerritoryData.sql` |
| `sp_Update_TourPurpose` | @TPId INT, @TPName NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+6 more) | U |  |  |  |  | tbl_TourPlanPurpose | `spec/database/procs/sp_Update_TourPurpose.sql` |
| `sp_Update_TourType` | @TourTypeId INT, @TourTypeName NVARCHAR, @UpdateBy NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tbl_TourPlanType | `spec/database/procs/sp_Update_TourType.sql` |
| `sp_Update_Trainning` | @TrainningId INT, @Title Nvarchar, @Description Nvarchar, @TrainningMeterial Nvarchar (+4 more) | UD |  |  |  |  | tblTrainingUserRoleDetail, tblTrainning, tbl_TrainingMarketDetail | `spec/database/procs/sp_Update_Trainning.sql` |
| `sp_Update_Transport` | @TransportId INT, @TransportName NVARCHAR, @AllowedMilagePerKM Decimal, @UpdateBy NVARCHAR (+1 more) | U |  |  |  |  | tbl_Transport | `spec/database/procs/sp_Update_Transport.sql` |
| `sp_Update_UserMaster_new` | @UserId INT, @UserName nvarchar, @UserType nvarchar, @LoginName nvarchar (+13 more) | UD |  |  |  |  | tblUser, tblUserCompanyUnit, tbl_UserMarketDetail | `spec/database/procs/sp_Update_UserMaster_new.sql` |
| `sp_Update_ZoneInfo` | @zoneId INT, @zoneName NVARCHAR, @createdBy NVARCHAR, @CodeStr NVARCHAR (+4 more) | SIUD |  |  |  |  | tblRegion, tblRegion_Log, tbl_Division, tbl_ZoneDivisionRelation | `spec/database/procs/sp_Update_ZoneInfo.sql` |
| `sp_Webapi_Get_DayName` | (none) | S |  |  |  |  | tblDayName | `spec/database/procs/sp_Webapi_Get_DayName.sql` |
| `sp_Webapi_Get_ImagePath` | @type NVARCHAR | S |  |  |  |  | tbl_ImagePath_Setting | `spec/database/procs/sp_Webapi_Get_ImagePath.sql` |
| `sp_Webapi_Get_LeaveConType` | (none) | S |  |  |  |  | tblLeaveConType | `spec/database/procs/sp_Webapi_Get_LeaveConType.sql` |
| `sp_Webapi_Get_TourPlanBalance` | @EmpInfoId INT, @Month INT, @year INT | S |  |  |  |  | tblStationType, tblTourSetupEmployee, tbl_TourPlanInfo | `spec/database/procs/sp_Webapi_Get_TourPlanBalance.sql` |
| `sp_WebApi_GetVersion` | (none) | S |  |  |  |  | tbl_AppVersion | `spec/database/procs/sp_WebApi_GetVersion.sql` |
| `spInsertTourPurposeOtherSetup` | @TourPurposeOtherSetupId int OUT, @VisitTypeId INT, @TourPurposeId INT, @EntryBy NVARCHAR (+1 more) | SID | Y | Y |  |  | tblTourPurposeOtherSetup, tblTourPurposeOtherSetupDtl | `spec/database/procs/spInsertTourPurposeOtherSetup.sql` |
| `spInsertTourPurposeOtherSetupDtl` | @TourPurposeOtherSetupId INT, @RoleName NVARCHAR, @TerritoryId INT, @AreaId INT (+3 more) | I |  |  |  |  | tblTourPurposeOtherSetupDtl | `spec/database/procs/spInsertTourPurposeOtherSetupDtl.sql` |

### MasterSetup_DAL (284 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `DynamicDateByDateRange` | @frmDate NVARCHAR, @toDate NVARCHAR | S |  |  |  |  | DateRange_To_TableSL | `spec/database/procs/DynamicDateByDateRange.sql` |
| `DynamicDatebyMonthByDateRange` | @frmDate NVARCHAR, @toDate NVARCHAR | S |  |  |  |  | DateRange_To_TableSL | `spec/database/procs/DynamicDatebyMonthByDateRange.sql` |
| `DynamicDatebyMonthYear` | @Month NVARCHAR, @Year NVARCHAR | S |  |  |  |  | sys | `spec/database/procs/DynamicDatebyMonthYear.sql` |
| `DynamicDatebyMonthYearForStuff` | @Month NVARCHAR, @Year NVARCHAR | S |  |  |  |  | sys | `spec/database/procs/DynamicDatebyMonthYearForStuff.sql` |
| `DynamicPivotBrandWiseDCR` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | tblProduct, tblProductSQ, tbl_DCRInfo, tbl_DcrDetails | `spec/database/procs/DynamicPivotBrandWiseDCR.sql` |
| `DynamicPivotBrandWiseRX_new` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+7 more) | S |  |  | Y |  | tblProduct, tblProductSQ, tblProgramType, tbl_PrescriptionMaster, tbl_PrescriptionProductDetail | `spec/database/procs/DynamicPivotBrandWiseRX_new.sql` |
| `DynamicPivotDoctorWiseCVR_New_ForSearch` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | View_CVR | `spec/database/procs/DynamicPivotDoctorWiseCVR_New_ForSearch.sql` |
| `DynamicPivotDoctorWiseDCP` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | View_DCP, View_DCR | `spec/database/procs/DynamicPivotDoctorWiseDCP.sql` |
| `DynamicPivotDoctorWiseDCPCustomerWise` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | View_CustomerDCP | `spec/database/procs/DynamicPivotDoctorWiseDCPCustomerWise.sql` |
| `DynamicPivotDoctorWiseDCR` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR | S |  |  | Y |  | tblArea, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail (+8 more) | `spec/database/procs/DynamicPivotDoctorWiseDCR.sql` |
| `DynamicPivotDoctorWiseDCR_New_ForSearch` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | View_DCR | `spec/database/procs/DynamicPivotDoctorWiseDCR_New_ForSearch.sql` |
| `DynamicPivotDoctorWiseRX_New` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+7 more) | S |  |  | Y |  | tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail, tblProgramType (+1 more) | `spec/database/procs/DynamicPivotDoctorWiseRX_New.sql` |
| `DynamicPivotDWSP` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDesignation, tblEmpGeneralInfo, tblTerritoryWiseTargetSetup, tblUser, tbl_DWSPDetail (+2 more) | `spec/database/procs/DynamicPivotDWSP.sql` |
| `DynamicPivotProductdWiseDCR` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | tblProduct, tbl_DCRInfo, tbl_DcrDetails | `spec/database/procs/DynamicPivotProductdWiseDCR.sql` |
| `DynamicPivotProductdWiseRX_New` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+7 more) | S |  |  | Y |  | tblProduct, tblProgramType, tbl_PrescriptionMaster, tbl_PrescriptionProductDetail | `spec/database/procs/DynamicPivotProductdWiseRX_New.sql` |
| `DynamicPivotUserandProductdWiseRX_New` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+8 more) | S |  |  | Y |  | tblEmpGeneralInfo, tblProduct, tblProgramType, tblRoleType, tblUser, tbl_PrescriptionMaster (+2 more) | `spec/database/procs/DynamicPivotUserandProductdWiseRX_New.sql` |
| `DynamicPivotUserWiseDCP` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | tblEmpGeneralInfo, tblRoleType, tblUser, tbl_DoctorTourPlanDetail, tbl_DoctorTourPlanMaster, tbl_UserRoleInfo | `spec/database/procs/DynamicPivotUserWiseDCP.sql` |
| `DynamicPivotUserWiseDCR` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+6 more) | S |  |  | Y |  | tblEmpGeneralInfo, tblRoleType, tblUser, tbl_DCRInfo, tbl_UserRoleInfo | `spec/database/procs/DynamicPivotUserWiseDCR.sql` |
| `DynamicPivotUserWiseRX_New` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+7 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblEmpGeneralInfo, tblProgramType, tblRoleType, tblUser, tbl_PrescriptionMaster (+1 more) | `spec/database/procs/DynamicPivotUserWiseRX_New.sql` |
| `DynamicVisitStatusReport` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+9 more) | S |  |  | Y |  | tblDoctorMaster, tblDoctorType, tblEmpGeneralInfo, tblProduct, tblProgramType, tblRoleType (+4 more) | `spec/database/procs/DynamicVisitStatusReport.sql` |
| `GetDynamicSalesReportList` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+3 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCustPayDetail, tblCustomerType, tblDoctorMaster, tblInvoice (+10 more) | `spec/database/procs/GetDynamicSalesReportList.sql` |
| `GetDynamicVisitStatusReportRX` | @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR, @Month NVARCHAR, @Year NVARCHAR (+10 more) | S |  |  | Y |  | tblDoctorMaster, tblEmpGeneralInfo, tblProduct, tblProgramType, tblRoleType, tblUser (+3 more) | `spec/database/procs/GetDynamicVisitStatusReportRX.sql` |
| `sp_ActiveInactive_customerType_ById` | @CustomerTypeId INT, @InactiveBy INT | SU |  |  |  |  | tblCustomerType | `spec/database/procs/sp_ActiveInactive_customerType_ById.sql` |
| `sp_ActiveInactive_Programtype` | @DeptId INT, @InactiveBy INT | SU |  |  |  |  | tblProgramType | `spec/database/procs/sp_ActiveInactive_Programtype.sql` |
| `sp_ActiveInactive_Stationtype` | @DeptId INT, @InactiveBy INT | SU |  |  |  |  | tblStationType | `spec/database/procs/sp_ActiveInactive_Stationtype.sql` |
| `sp_ApproveCustomerInformation` | @CustomerMasterId NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | tblCustMaster | `spec/database/procs/sp_ApproveCustomerInformation.sql` |
| `sp_CampaignUpdateFromPage` | (none) | SI |  |  |  |  | GetCampaignCustomer, tblCustMasterCampNew | `spec/database/procs/sp_CampaignUpdateFromPage.sql` |
| `sp_check_CustomerType` | @id INT, @CustomerType NVARCHAR | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_check_CustomerType.sql` |
| `sp_check_EmployeeInfo` | @id INT, @Name NVARCHAR | S |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_check_EmployeeInfo.sql` |
| `sp_check_Programtype` | @id INT, @ProgramTypeName NVARCHAR | S |  |  |  |  | tblProgramType | `spec/database/procs/sp_check_Programtype.sql` |
| `sp_check_RouteInformationMArket` | @id NVARCHAR, @Name NVARCHAR, @Status NVARCHAR | S |  |  |  |  | fnSplit, tblRouteInformationMarketDetail | `spec/database/procs/sp_check_RouteInformationMArket.sql` |
| `sp_check_SMCtype` | @id INT, @ProgramTypeName NVARCHAR | S |  |  |  |  | tblSMCType | `spec/database/procs/sp_check_SMCtype.sql` |
| `sp_check_StationType` | @id INT, @StationTypeName NVARCHAR | S |  |  |  |  | tblStationType | `spec/database/procs/sp_check_StationType.sql` |
| `sp_Check_TourSetupEmployeeList` | @EmpInfoId int | S |  |  |  |  | tblTourSetupEmployee | `spec/database/procs/sp_Check_TourSetupEmployeeList.sql` |
| `sp_Check_TourSetupEmployeeListRoleType` | @RoleTypeId int | S |  |  |  |  | tblTourSetupEmployee | `spec/database/procs/sp_Check_TourSetupEmployeeListRoleType.sql` |
| `sp_checkIsDefault_CustomerType` | @id INT | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_checkIsDefault_CustomerType.sql` |
| `sp_CS_GetMarket_ByTerritoryId_ActiveNew` | @id int | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblSubTerritory, tblTerritory, tbl_Group | `spec/database/procs/sp_CS_GetMarket_ByTerritoryId_ActiveNew.sql` |
| `sp_Del_BonusCampaignNewMaster` | @CampgainMasterId INT | SID |  |  |  | Y | campaign_cursor, tbl_BonusCampaignCustomerDetail, tbl_BonusCampaignDetailsCustType, tbl_BonusCampaignMarketDetail, tbl_BonusCampaignNewDetail, tbl_BonusCampaignNewDetailDEL (+2 more) | `spec/database/procs/sp_Del_BonusCampaignNewMaster.sql` |
| `sp_DEL_NoticeImage` | @NoticeId INT | D |  |  |  |  | tbl_Notice_Image | `spec/database/procs/sp_DEL_NoticeImage.sql` |
| `sp_DEL_TargetInfo` | @SL INT | D |  |  |  |  | tblTerritoryDataMigration | `spec/database/procs/sp_DEL_TargetInfo.sql` |
| `sp_Delete_CustTaggDoc` | @CustomerMasterId INT | D |  |  |  |  | tblCustTaggDoc | `spec/database/procs/sp_Delete_CustTaggDoc.sql` |
| `sp_Delete_DepartmnetInfo` | @DeptId INT | D |  |  |  |  | tblDepartment | `spec/database/procs/sp_Delete_DepartmnetInfo.sql` |
| `sp_Delete_EmployeeInformation` | @EmpInfoId INT | D |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_Delete_EmployeeInformation.sql` |
| `sp_Delete_NoticeMaster` | @NoticeId INT | D |  |  |  |  | tbl_Notice_MarketDetails, tbl_Notice_MarketMaster | `spec/database/procs/sp_Delete_NoticeMaster.sql` |
| `sp_Delete_ProductDCDetails` | @ProductId INT | D |  |  |  |  | tblProductDCDetails | `spec/database/procs/sp_Delete_ProductDCDetails.sql` |
| `sp_DeleteCustomerInvoiceLimit` | @Id INT | D |  |  |  |  | tblCustomerInvoiceLimit | `spec/database/procs/sp_DeleteCustomerInvoiceLimit.sql` |
| `sp_DeleteInvoiceNotBinding` | @InvoiceNotBindingId INT | D |  |  |  |  | tblInvoiceNotBinding | `spec/database/procs/sp_DeleteInvoiceNotBinding.sql` |
| `sp_Get_alesReectionReportList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblEmpGeneralInfo, tblInvoice, tblOrder (+3 more) | `spec/database/procs/sp_Get_alesReectionReportList.sql` |
| `sp_Get_AllCollectionReportListDHB` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomertype, tblEmpGeneralInfo (+5 more) | `spec/database/procs/sp_Get_AllCollectionReportListDHB.sql` |
| `sp_Get_AllLeaveRecords` | @Parameter NVARCHAR | S |  |  | Y |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, Employee_YearlyLeaveTranscations, tblEmpGeneralInfo, tblLeaveConType, tblUser (+2 more) | `spec/database/procs/sp_Get_AllLeaveRecords.sql` |
| `sp_Get_ALlOrderSummaryByChemist` | @Parm NVARCHAR | S |  |  | Y |  | View_CustomerMaster_ActiveInactive, View_Webapi_EmployeeFieldForceInfo, tblOrder, tbluser | `spec/database/procs/sp_Get_ALlOrderSummaryByChemist.sql` |
| `sp_Get_ALlOrderSummaryByChemist_Pivot` | @Parm NVARCHAR, @ColumnToPivot NVARCHAR, @ListToPivot NVARCHAR | S |  |  | Y |  | View_CustomerMaster_ActiveInactive, View_Webapi_EmployeeFieldForceInfo, tblOrder, tbluser | `spec/database/procs/sp_Get_ALlOrderSummaryByChemist_Pivot.sql` |
| `sp_Get_ALlOrderSummaryByProduct` | @Parm NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblOrder, tblOrderDetail, tblProduct, tbluser | `spec/database/procs/sp_Get_ALlOrderSummaryByProduct.sql` |
| `sp_Get_AllPaymentReportList` | @Parm nvarchar | S |  |  | Y |  | View_CustomerMaster, sp_executesql, tblCompanyUnit, tblCustPayDetail, tblCustomerPay, tblInvoice (+2 more) | `spec/database/procs/sp_Get_AllPaymentReportList.sql` |
| `sp_Get_AllSalesConfirmationReport_new` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustomertype, tblDCStore, tblEmpGeneralInfo (+12 more) | `spec/database/procs/sp_Get_AllSalesConfirmationReport_new.sql` |
| `sp_Get_AllSalesReportList` | @Parm nvarchar | S |  |  | Y |  | SalesDisDB_SMC, sp_executesql, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype (+15 more) | `spec/database/procs/sp_Get_AllSalesReportList.sql` |
| `sp_Get_AllSalesReportListDHB` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCustMaster, tblInvoice, tblOrder | `spec/database/procs/sp_Get_AllSalesReportListDHB.sql` |
| `sp_Get_AllSalesReportListParam2` | @NewParm nvarchar, @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustPayDetail, tblCustomertype, tblEmpGeneralInfo, tblInvoice (+7 more) | `spec/database/procs/sp_Get_AllSalesReportListParam2.sql` |
| `sp_Get_AllSalesReportListParamNew` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | SAP_API_Data, sp_executesql, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype (+13 more) | `spec/database/procs/sp_Get_AllSalesReportListParamNew.sql` |
| `sp_Get_AMDZSMListByTerritoryId` | @TerritoryId int | S |  |  |  |  | tblASMInfo, tblArea, tblEmpGeneralInfo, tblRSMInfo, tblRegion, tblTerritory | `spec/database/procs/sp_Get_AMDZSMListByTerritoryId.sql` |
| `sp_Get_AttendanceInformation` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @AttType INT (+3 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblApprovalLog, tblDesignation, tblEmpGeneralInfo, tblMarketAttendance_Master_webapi (+4 more) | `spec/database/procs/sp_Get_AttendanceInformation.sql` |
| `sp_Get_BonusCampaigndtlList` | @CampgainMasterId nvarchar | S |  |  |  |  | tbl_BonusCampaignNewDetail | `spec/database/procs/sp_Get_BonusCampaigndtlList.sql` |
| `sp_Get_BonusCampaignNewMasterList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblCustomerType, tbl_BonusCampaignDetailsCustType, tbl_BonusCampaignNewMaster, tbl_CampaignType | `spec/database/procs/sp_Get_BonusCampaignNewMasterList.sql` |
| `sp_Get_BusinessSummaryReportList` | @fromdate datetime, @todate datetime | S |  |  |  |  | tblCompanyUnit, tblCustMaster, tblInvoice, tblInvoiceDetail, tblOrder, tblSubInvoiceDetail (+1 more) | `spec/database/procs/sp_Get_BusinessSummaryReportList.sql` |
| `sp_GET_CampaignDetail_ById` | @id NVARCHAR | S |  |  |  |  | tblProduct, tbl_BonusCampaignNewDetail, tbl_BonusOnType | `spec/database/procs/sp_GET_CampaignDetail_ById.sql` |
| `sp_GET_CampaignDetailCustomer_ById` | @id NVARCHAR | S |  |  |  |  | tblCustMaster, tbl_BonusCampaignCustomerDetail | `spec/database/procs/sp_GET_CampaignDetailCustomer_ById.sql` |
| `sp_GET_CampaignDetailMarket_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblSubTerritory, tblTerritory, tbl_BonusCampaignMarketDetail (+1 more) | `spec/database/procs/sp_GET_CampaignDetailMarket_ById.sql` |
| `sp_GET_CampaignMaster_ById` | @id NVARCHAR | S |  |  |  |  | tbl_BonusCampaignDetailsCustType, tbl_BonusCampaignNewMaster | `spec/database/procs/sp_GET_CampaignMaster_ById.sql` |
| `sp_GET_CampaignMasterMap_ById` | @id NVARCHAR | S |  |  |  |  | tbl_BonusCampaignDetailsCustType | `spec/database/procs/sp_GET_CampaignMasterMap_ById.sql` |
| `sp_GET_checkTodaysAlreadyInviceGenerateByCustId` | @id NVARCHAR | S |  |  |  |  | tblInvoice | `spec/database/procs/sp_GET_checkTodaysAlreadyInviceGenerateByCustId.sql` |
| `sp_GET_CustMaster_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblCustMaster, tblCustProductLine, tblMarket, tblRegion, tblSubTerritory (+5 more) | `spec/database/procs/sp_GET_CustMaster_ById.sql` |
| `sp_Get_CustMasterList_Approve` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblArea, tblCompanyUnit, tblCustMaster, tblCustomerType, tblEmpGeneralInfo (+15 more) | `spec/database/procs/sp_Get_CustMasterList_Approve.sql` |
| `sp_Get_Customer_Active` | (none) | S |  |  |  |  | tblCustMaster | `spec/database/procs/sp_Get_Customer_Active.sql` |
| `sp_Get_CustomerApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+3 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblCustMaster, tblCustomerApprovalLog, tblCustomerType, tblDistributionRoute (+10 more) | `spec/database/procs/sp_Get_CustomerApp.sql` |
| `sp_GET_CustomerInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblCustomerCategory, tblCustomerType, tblEmpGeneralInfo, tblUser | `spec/database/procs/sp_GET_CustomerInfo.sql` |
| `sp_Get_CustomerTranferApprovalList` | @Parm nvarchar | S |  |  |  |  | tblArea, tblCustMaster_TranferLog, tblCustomerType, tblMarket, tblProgramType, tblRegion (+5 more) | `spec/database/procs/sp_Get_CustomerTranferApprovalList.sql` |
| `sp_GET_CustomerType_ById` | @id NVARCHAR | S |  |  |  |  | tblCustomerType | `spec/database/procs/sp_GET_CustomerType_ById.sql` |
| `sp_GET_CustTaggedDoctorList` | @CustomerMasterId INT | S |  |  |  |  | tblCustTaggDoc | `spec/database/procs/sp_GET_CustTaggedDoctorList.sql` |
| `sp_Get_DACollectionReport` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblDAInfo, tblInvoice (+6 more) | `spec/database/procs/sp_Get_DACollectionReport.sql` |
| `sp_GET_DAInfo` | @Parameter int | S |  |  |  |  | tblCompanyUnit, tblDAInfo, tblUser, tblUserCompanyUnit | `spec/database/procs/sp_GET_DAInfo.sql` |
| `sp_GET_DAInfoById` | @Parameter NVARCHAR | S |  |  |  |  | tblDAInfo | `spec/database/procs/sp_GET_DAInfoById.sql` |
| `sp_Get_DCPCVPTourPlanApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+4 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDesignation, tblEmpGeneralInfo, tblRoleType, tblUser (+3 more) | `spec/database/procs/sp_Get_DCPCVPTourPlanApp.sql` |
| `sp_Get_DCRApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+6 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDCRApprovalLog, tblDesignation, tblDoctorChemberDetail, tblDoctorMaster (+6 more) | `spec/database/procs/sp_Get_DCRApp.sql` |
| `sp_Get_DCStockReportListNew` | @comunit int | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblChalanDetail, tblChalanInfo, tblCompanyUnit, tblDCStore (+19 more) | `spec/database/procs/sp_Get_DCStockReportListNew.sql` |
| `sp_Get_DDLDAName` | (none) | S |  |  |  |  | tblDAInfo | `spec/database/procs/sp_Get_DDLDAName.sql` |
| `sp_Get_DDLDANameByDCID` | @depoId INT | S |  |  |  |  | tblDAInfo | `spec/database/procs/sp_Get_DDLDANameByDCID.sql` |
| `sp_GET_DelivaryInvoiceNoCheckById` | @id NVARCHAR, @InvStatus NVARCHAR | S |  |  |  |  | tblInvoice | `spec/database/procs/sp_GET_DelivaryInvoiceNoCheckById.sql` |
| `sp_Get_DeliveryReturnReport` | @Parm nvarchar | S |  |  | Y |  | SalesDisDB_SMC, sp_executesql, tblCompanyUnit, tblCustMaster, tblCustomerType, tblDCStore (+5 more) | `spec/database/procs/sp_Get_DeliveryReturnReport.sql` |
| `sp_GET_DelTerritoryByRouteInformationDDL` | @id NVARCHAR, @IvDate NVARCHAR | S |  |  |  |  | tblInvoice, tblOrder, tblTerritory | `spec/database/procs/sp_GET_DelTerritoryByRouteInformationDDL.sql` |
| `sp_Get_DoctorClaimApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+4 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDoctorApprovalLog_New, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorDesignation (+11 more) | `spec/database/procs/sp_Get_DoctorClaimApp.sql` |
| `sp_GET_DoctorContactDetail_ById` | @id NVARCHAR | S |  |  |  |  | tblDoctorContactDetail, tbl_ContactType | `spec/database/procs/sp_GET_DoctorContactDetail_ById.sql` |
| `sp_GET_DoctorList_ForCustTagging` | (none) | S |  |  |  |  | tblDoctorMaster | `spec/database/procs/sp_GET_DoctorList_ForCustTagging.sql` |
| `sp_GET_DoctorMaster_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblDoctorBrandDetail, tblDoctorChamber, tblDoctorChemberDetail, tblDoctorDegreeDetail, tblDoctorMaster (+7 more) | `spec/database/procs/sp_GET_DoctorMaster_ById.sql` |
| `sp_GET_DoctorSpecialDayDetail_ById` | @id NVARCHAR | S |  |  |  |  | tblDoctorSpecialDay, tblDoctorSpecialDayDetail | `spec/database/procs/sp_GET_DoctorSpecialDayDetail_ById.sql` |
| `sp_Get_DoctorTranferApprovalList` | @Parm nvarchar | S |  |  |  |  | tblArea, tblDoctorContactDetail, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorDesignation, tblDoctorMaster_TranferLog (+12 more) | `spec/database/procs/sp_Get_DoctorTranferApprovalList.sql` |
| `sp_GET_EmployeeInfoOrdPermission` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblOrderPermission, tblRoleType (+3 more) | `spec/database/procs/sp_GET_EmployeeInfoOrdPermission.sql` |
| `sp_Get_EmployeeInformation_ById` | @id INT | S |  |  |  |  | EmployeeAllowance, tblEmpGeneralInfo | `spec/database/procs/sp_Get_EmployeeInformation_ById.sql` |
| `sp_Get_EmployeeInformationList_Prm` | @Parm NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDesignation, tblEmpGeneralInfo, tblRoleType, tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_Get_EmployeeInformationList_Prm.sql` |
| `sp_Get_EmployeeInformationListActive` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblEmpGeneralInfo, tblRoleType, tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_Get_EmployeeInformationListActive.sql` |
| `sp_Get_EmployeeInformationListRpt_Final` | @Parm nvarchar, @Month nvarchar | S |  |  | Y |  | sp_executesql, tblEmpGeneralInfo, tblRoleType, tblUser, tbl_ExpenseClaim, tbl_MileageClaim (+4 more) | `spec/database/procs/sp_Get_EmployeeInformationListRpt_Final.sql` |
| `sp_GET_EmployeeLeaveBalance` | @Parameter NVARCHAR | S |  |  | Y |  | Employee_YearlyLeaveBalance, Employee_YearlyLeaveTranscations, tblEmpGeneralInfo, tblLeaveConType | `spec/database/procs/sp_GET_EmployeeLeaveBalance.sql` |
| `sp_Get_EmployyeMonthlyExpense` | @EmpId NVARCHAR, @frmDate NVARCHAR, @ToDate NVARCHAR | S |  |  |  |  | tblEmpGeneralInfo, tblStationType, tbl_ExpenseClaim, tbl_MileageClaim, tbl_TadaClaimMaster | `spec/database/procs/sp_Get_EmployyeMonthlyExpense.sql` |
| `sp_Get_ExpanseClaimApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt NVARCHAR (+2 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDesignation, tblEmpGeneralInfo, tblExpanseApprovalLog, tblRoleType (+5 more) | `spec/database/procs/sp_Get_ExpanseClaimApp.sql` |
| `sp_GET_forPaymentTerritoryByRouteInformationDDL` | @id NVARCHAR | S |  |  |  |  | tblInvoice, tblOrder, tblTerritory | `spec/database/procs/sp_GET_forPaymentTerritoryByRouteInformationDDL.sql` |
| `sp_GET_forsndReturnTerritoryByRouteInformationDDL` | @id NVARCHAR | S |  |  |  |  | tblInvoice, tblOrder, tblTerritory | `spec/database/procs/sp_GET_forsndReturnTerritoryByRouteInformationDDL.sql` |
| `sp_GET_GetOrderDtlCamCheckId` | @id NVARCHAR | S |  |  |  |  | tblOrderDetail | `spec/database/procs/sp_GET_GetOrderDtlCamCheckId.sql` |
| `sp_GET_GetOrderDtlCamCheckIdEze` | @id NVARCHAR | S |  |  |  |  | tblOrderDetail | `spec/database/procs/sp_GET_GetOrderDtlCamCheckIdEze.sql` |
| `sp_GET_lDcWiseTerritoryDetail_ByAreaId` | @DCId NVARCHAR, @SubDepotId NVARCHAR | S |  |  |  |  | tblDcWiseTerritoryDetail, tblDcWiseTerritoryMaster | `spec/database/procs/sp_GET_lDcWiseTerritoryDetail_ByAreaId.sql` |
| `sp_Get_Leave_AppLog` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+2 more) | S |  |  | Y |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, View_Webapi_EmployeeFieldForceInfo, sys, tblEmpGeneralInfo, tblLeaveApprovalLog (+5 more) | `spec/database/procs/sp_Get_Leave_AppLog.sql` |
| `sp_GET_LeaveApplicationInfoById` | @Parameter NVARCHAR | S |  |  | Y |  | Employe_LeaveTypeInfos, Employee_LeaveApplications, Employee_YearlyLeaveBalance, tblEmpGeneralInfo | `spec/database/procs/sp_GET_LeaveApplicationInfoById.sql` |
| `sp_GET_LeaveConfigSetupById` | @id NVARCHAR | S |  |  |  |  | tblLeaveConfig, tblLeaveConfigCountDtl, tblLeaveConfigForeignId | `spec/database/procs/sp_GET_LeaveConfigSetupById.sql` |
| `sp_Get_LoadingReportList` | @Parm nvarchar, @dtRange nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustomerType, tblEmpGeneralInfo, tblInvoice (+3 more) | `spec/database/procs/sp_Get_LoadingReportList.sql` |
| `sp_Get_MileageAppData` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt NVARCHAR (+2 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblEmpGeneralInfo, tblMarket, tblMileageApprovalLog, tblRoleType (+5 more) | `spec/database/procs/sp_Get_MileageAppData.sql` |
| `sp_Get_MIOWiseReceiveableReport` | @Parm nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblCompanyUnit, tblCustMaster, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/procs/sp_Get_MIOWiseReceiveableReport.sql` |
| `sp_Get_MonthlyExpenseEmpWiseMaster` | @Month nvarchar, @Year nvarchar, @EmpId nvarchar | S |  |  |  |  | View_Webapi_EmployeeFieldForceInfo_Top1, fnSplit, sys, tblASMInfo, tblArea, tblDesignation (+12 more) | `spec/database/procs/sp_Get_MonthlyExpenseEmpWiseMaster.sql` |
| `sp_Get_MonthlyExpenseEmpWiseMaster_Final` | @Month nvarchar, @Year nvarchar, @EmpId nvarchar | SI |  |  |  |  | DateRange_To_TableByMonthYear, tblASMInfo, tblArea, tblDesignation, tblEmpGeneralInfo, tblMIOInfo (+12 more) | `spec/database/procs/sp_Get_MonthlyExpenseEmpWiseMaster_Final.sql` |
| `sp_Get_MonthlyExpenseEmpWiseTotal` | @Month nvarchar, @Year nvarchar, @EmpId nvarchar | S |  |  |  |  | fnSplit, tblEmpGeneralInfo, tbl_ExpenseClaim, tbl_MileageClaim, tbl_MonthlyAllowance, tbl_MonthlyAllowanceDetail (+1 more) | `spec/database/procs/sp_Get_MonthlyExpenseEmpWiseTotal.sql` |
| `sp_Get_Noticedetails_By_NoticeId` | @id INT | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblTerritory, tbl_Group, tbl_Notice_MarketDetails | `spec/database/procs/sp_Get_Noticedetails_By_NoticeId.sql` |
| `sp_Get_NoticeImage_By_NoticeId` | @id INT | S |  |  |  |  | tbl_Notice_Image | `spec/database/procs/sp_Get_NoticeImage_By_NoticeId.sql` |
| `sp_Get_NoticeMaster` | (none) | S |  |  |  |  | tbl_Notice_MarketMaster | `spec/database/procs/sp_Get_NoticeMaster.sql` |
| `sp_Get_NoticeMaster_ById` | @id INT | S |  |  |  |  | tbl_Notice_MarketMaster | `spec/database/procs/sp_Get_NoticeMaster_ById.sql` |
| `sp_Get_OrderDelTrackingList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblArea, tblEmpGeneralInfo, tblOrderDel, tblRegion, tblRouteInformationMaster (+5 more) | `spec/database/procs/sp_Get_OrderDelTrackingList.sql` |
| `sp_Get_OrderDetailsTrackingList` | @Parm nvarchar | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sp_executesql, tblArea, tblEmpGeneralInfo, tblOrder, tblOrderDetail (+7 more) | `spec/database/procs/sp_Get_OrderDetailsTrackingList.sql` |
| `sp_Get_OrderTrackingList_DBH` | @Parm nvarchar | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sp_executesql, tblEmpGeneralInfo, tblOrder, tblRouteInformationMaster, tbluser | `spec/database/procs/sp_Get_OrderTrackingList_DBH.sql` |
| `sp_Get_OrderTrackingList_Latest` | @Parm nvarchar | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sp_executesql, tblEmpGeneralInfo, tblOrder, tblRouteInformationMaster, tbluser | `spec/database/procs/sp_Get_OrderTrackingList_Latest.sql` |
| `sp_Get_PrescriptionApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+6 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDoctorMaster, tblEmpGeneralInfo, tblPrescriptionApprovalLog, tblRoleType (+5 more) | `spec/database/procs/sp_Get_PrescriptionApp.sql` |
| `sp_Get_Product_Active` | (none) | S |  |  |  |  | tblProduct, tblUnitPrice | `spec/database/procs/sp_Get_Product_Active.sql` |
| `sp_Get_Product_All` | (none) | S |  |  |  |  | tblProduct, tblUnitPrice | `spec/database/procs/sp_Get_Product_All.sql` |
| `sp_Get_Product_ForTargetSetup_DDL` | (none) | S |  |  |  |  | tblProduct | `spec/database/procs/sp_Get_Product_ForTargetSetup_DDL.sql` |
| `sp_Get_ProformaInvoiceReportList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustomerType, tblDCStore, tblEmpGeneralInfo, tblInvoice (+5 more) | `spec/database/procs/sp_Get_ProformaInvoiceReportList.sql` |
| `sp_GET_ProgramType_ById` | @id NVARCHAR | S |  |  |  |  | tblProgramType | `spec/database/procs/sp_GET_ProgramType_ById.sql` |
| `sp_GET_ProgramtypeInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblProgramType, tblUser | `spec/database/procs/sp_GET_ProgramtypeInfo.sql` |
| `sp_Get_QuotedPriceDetailById` | @id NVARCHAR | S |  |  |  |  | tblQuotedPriceDetail | `spec/database/procs/sp_Get_QuotedPriceDetailById.sql` |
| `sp_Get_QuotedPriceMaster` | (none) | S |  |  |  |  | tblCustMaster, tblQuotedPriceMaster | `spec/database/procs/sp_Get_QuotedPriceMaster.sql` |
| `sp_GET_QuotedPriceMaster_ById` | @id NVARCHAR | S |  |  |  |  | tblCustMaster, tblQuotedPriceMaster | `spec/database/procs/sp_GET_QuotedPriceMaster_ById.sql` |
| `sp_Get_ReplaceNoteReport` | @Parm nvarchar | S |  |  | Y |  | market, sp_executesql, tblCompanyUnit, tblCustMaster, tblDCStore, tblPackSize (+3 more) | `spec/database/procs/sp_Get_ReplaceNoteReport.sql` |
| `sp_GET_RouteInformationDADetail_ById` | @id NVARCHAR | S |  |  |  |  | tblDAInfo, tblRouteInformationDADetail | `spec/database/procs/sp_GET_RouteInformationDADetail_ById.sql` |
| `sp_GET_RouteInformationDADetailDDL` | @id NVARCHAR | S |  |  |  |  | tblDAInfo, tblRouteInformationDADetail | `spec/database/procs/sp_GET_RouteInformationDADetailDDL.sql` |
| `sp_GET_RouteInformationMarketDetail_ById` | @id NVARCHAR | S |  |  |  |  | tblArea, tblMarket, tblRegion, tblRouteInformationMarketDetail, tblSubTerritory, tblTerritory (+1 more) | `spec/database/procs/sp_GET_RouteInformationMarketDetail_ById.sql` |
| `sp_GET_RouteInformationMaster_ById` | @id NVARCHAR | S |  |  |  |  | tblRouteInformationMaster, tblRouteInformationWeekNameDetails | `spec/database/procs/sp_GET_RouteInformationMaster_ById.sql` |
| `sp_Get_RouteInformationMasterList` | @Parameter NVARCHAR | S |  |  | Y |  | tblCompanyUnit, tblDAInfo, tblEmpGeneralInfo, tblRouteInformationDADetail, tblRouteInformationMarketDetail, tblRouteInformationMaster (+1 more) | `spec/database/procs/sp_Get_RouteInformationMasterList.sql` |
| `sp_Get_RouteTypeInfo` | (none) | S |  |  |  |  | tblRouteTypeInfo | `spec/database/procs/sp_Get_RouteTypeInfo.sql` |
| `sp_Get_RPT_PaymentSC_Param` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustomertype, tblDCStore, tblEmpGeneralInfo (+9 more) | `spec/database/procs/sp_Get_RPT_PaymentSC_Param.sql` |
| `sp_Get_RPT_SC_CustomerFinalPaymentReport` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomertype, tblEmpGeneralInfo (+4 more) | `spec/database/procs/sp_Get_RPT_SC_CustomerFinalPaymentReport.sql` |
| `sp_Get_RPT_SC_CustomerFinalPaymentReport_new` | @Parm nvarchar, @Parm2 nvarchar, @oldParam nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomertype, tblDAInfo (+11 more) | `spec/database/procs/sp_Get_RPT_SC_CustomerFinalPaymentReport_new.sql` |
| `sp_Get_SalesRejectionReportListLAtest` | @Parm nvarchar, @Parm2 nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustomerType, tblDCStore, tblEmpGeneralInfo (+9 more) | `spec/database/procs/sp_Get_SalesRejectionReportListLAtest.sql` |
| `sp_Get_SalesReturnReport` | @Parm NVARCHAR, @Parm2 NVARCHAR | S |  |  | Y |  | sp_executesql, tblArea, tblCompanyUnit, tblCustMaster, tblCustomerType, tblDCStore (+11 more) | `spec/database/procs/sp_Get_SalesReturnReport.sql` |
| `sp_Get_SampleStockReport` | @EmpId NVARCHAR, @Month NVARCHAR, @Year NVARCHAR | S |  |  |  |  | tblEmpGeneralInfo, tblGroupWisePromoQty, tblGroupWisePromoQty_OpeningBalanceProcess, tblProduct, tbl_DCRInfo, tbl_DcrDetails | `spec/database/procs/sp_Get_SampleStockReport.sql` |
| `sp_GET_SMCType_ById` | @id NVARCHAR | S |  |  |  |  | tblSMCType | `spec/database/procs/sp_GET_SMCType_ById.sql` |
| `sp_GET_SMCtypeInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblSMCType, tblUser | `spec/database/procs/sp_GET_SMCtypeInfo.sql` |
| `sp_GET_StationType_ById` | @id NVARCHAR | S |  |  |  |  | tblStationType | `spec/database/procs/sp_GET_StationType_ById.sql` |
| `sp_GET_StationTypeInfo` | @Parameter NVARCHAR | S |  |  | Y |  | tblEmpGeneralInfo, tblStationType, tblUser | `spec/database/procs/sp_GET_StationTypeInfo.sql` |
| `sp_Get_TADAAppData` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt NVARCHAR (+2 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblEmpGeneralInfo, tblRoleType, tblStationType, tblTADAApprovalLog (+3 more) | `spec/database/procs/sp_Get_TADAAppData.sql` |
| `sp_GET_TargetEdit_ById` | @id NVARCHAR | S |  |  |  |  | tblTerritoryDataMigration | `spec/database/procs/sp_GET_TargetEdit_ById.sql` |
| `sp_Get_TerritorryWiseSalesReportList` | @Parm nvarchar | S |  |  | Y |  | tblEmpGeneralInfo, tblInvoice, tblInvoiceDetail, tblMIOInfo, tblOrder | `spec/database/procs/sp_Get_TerritorryWiseSalesReportList.sql` |
| `sp_GET_TerritoryByRouteInformationDDL` | @id NVARCHAR | S |  |  |  |  | tblOrder, tblTerritory | `spec/database/procs/sp_GET_TerritoryByRouteInformationDDL.sql` |
| `sp_Get_TerritoryCodeByRoleTypeEmpId` | @RoleType nvarchar, @EmpId nvarchar | S |  |  |  |  | tblASMInfo, tblArea, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion (+2 more) | `spec/database/procs/sp_Get_TerritoryCodeByRoleTypeEmpId.sql` |
| `sp_Get_TerritoryCodeByRoleTypeEmpId_Active` | @RoleType nvarchar, @EmpId nvarchar | S |  |  |  |  | tblASMInfo, tblArea, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion (+2 more) | `spec/database/procs/sp_Get_TerritoryCodeByRoleTypeEmpId_Active.sql` |
| `sp_Get_TerritoryTargetList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblDesignation, tblEmpGeneralInfo, tblTerritory, tblTerritoryDataMigration | `spec/database/procs/sp_Get_TerritoryTargetList.sql` |
| `sp_GET_TerritoryWiseDepotSetupList` | @Parameter NVARCHAR | S |  |  | Y |  | tblArea, tblCompanyUnit, tblDcWiseTerritoryDetail, tblDcWiseTerritoryMaster, tblRegion, tblSubDepot (+2 more) | `spec/database/procs/sp_GET_TerritoryWiseDepotSetupList.sql` |
| `sp_Get_TourPlanApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+4 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDesignation, tblEmpGeneralInfo, tblRoleType, tblTourPlanApprovalLog (+3 more) | `spec/database/procs/sp_Get_TourPlanApp.sql` |
| `sp_Get_TourPlanReportList` | @param NVARCHAR | S |  |  | Y |  | tblDesignation, tblEmpGeneralInfo, tblMarket, tblTPMarketDetail, tblUser, tbl_TourPlanInfo (+3 more) | `spec/database/procs/sp_Get_TourPlanReportList.sql` |
| `sp_Get_TourPlanReportList__n` | @EmpInfoId int, @Month int, @Year int | S |  |  |  |  | tblDesignation, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblRoleType, tblStationType (+7 more) | `spec/database/procs/sp_Get_TourPlanReportList__n.sql` |
| `sp_Get_TourPlanSummaryReport` | @EmpInfoId int, @UserRoleId int, @Month int, @Year int | S |  |  |  |  | DateRange, WorkingDays, master, tblEmpGeneralInfo, tblRoleType, tblStationType (+3 more) | `spec/database/procs/sp_Get_TourPlanSummaryReport.sql` |
| `sp_Get_TourSetupEmployeeList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblEmpGeneralInfo, tblRoleType, tblStationType, tblTourSetupEmployee | `spec/database/procs/sp_Get_TourSetupEmployeeList.sql` |
| `sp_Get_WeekNameInfo` | (none) | S |  |  |  |  | tblWeekNameInfo | `spec/database/procs/sp_Get_WeekNameInfo.sql` |
| `sp_GetCustomer_Doctor_TransferAppList` | @Parm nvarchar, @Type nvarchar | S |  |  |  |  | tblCustMaster_TranferLog, tblDoctorMaster_TranferLog, tblEmpGeneralInfo, tblMarket, tbluser | `spec/database/procs/sp_GetCustomer_Doctor_TransferAppList.sql` |
| `sp_GetCustomerAutoComplete` | @Keyword NVARCHAR | S |  |  |  |  | tblCustMaster | `spec/database/procs/sp_GetCustomerAutoComplete.sql` |
| `sp_GetCustomerInvoiceLimitById` | @Id INT | S |  |  |  |  | tblCustMaster, tblCustomerInvoiceLimit | `spec/database/procs/sp_GetCustomerInvoiceLimitById.sql` |
| `sp_GetCustomerInvoiceLimits` | (none) | S |  |  |  |  | tblCustMaster, tblCustomerInvoiceLimit | `spec/database/procs/sp_GetCustomerInvoiceLimits.sql` |
| `sp_GetCustomerProviderTypeApproveList` | @Parm nvarchar | S |  |  |  |  | tblCustomerPropUpdateMaster, tblEmpGeneralInfo, tbluser | `spec/database/procs/sp_GetCustomerProviderTypeApproveList.sql` |
| `sp_GetDCRRXDoctorWiseRptView` | @Month nvarchar, @Year nvarchar, @Type nvarchar | S |  |  |  |  | tblDCRRXDoctorWiseReport | `spec/database/procs/sp_GetDCRRXDoctorWiseRptView.sql` |
| `sp_GetDoctorProviderTypeApproveList` | @Parm nvarchar | S |  |  |  |  | tblDoctorPropUpdateMaster, tblEmpGeneralInfo, tbluser | `spec/database/procs/sp_GetDoctorProviderTypeApproveList.sql` |
| `sp_GetInvoiceNotBindingById` | @InvoiceNotBindingId INT | S |  |  |  |  | tblCustMaster, tblInvoiceNotBinding | `spec/database/procs/sp_GetInvoiceNotBindingById.sql` |
| `sp_GetInvoiceNotBindingList` | (none) | S |  |  |  |  | tblCustMaster, tblCustomerType, tblInvoiceNotBinding | `spec/database/procs/sp_GetInvoiceNotBindingList.sql` |
| `sp_GetMarketInfoApprovalList` | @Parm nvarchar | S |  |  |  |  | tblEmpGeneralInfo, tblMarketPropMaster, tbluser | `spec/database/procs/sp_GetMarketInfoApprovalList.sql` |
| `sp_GetOrganogramreportList` | @Parm nvarchar | S |  |  |  |  | View_webapi_FieldForce, tblCustMaster, tblDoctorMaster, tblRouteInformationMarketDetail | `spec/database/procs/sp_GetOrganogramreportList.sql` |
| `sp_GetRXDoctorWiseRpt` | @Month nvarchar, @MonthValue int, @Year nvarchar, @ApprovalStatus nvarchar | SI |  |  |  |  | tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail, tblDoctorType (+2 more) | `spec/database/procs/sp_GetRXDoctorWiseRpt.sql` |
| `sp_InsertCustomerInvoiceLimit` | @CustomerId INT, @MaximumInvoiceValue DECIMAL, @Remarks NVARCHAR, @IsActive BIT (+1 more) | SI |  |  |  |  | tblCustomerInvoiceLimit | `spec/database/procs/sp_InsertCustomerInvoiceLimit.sql` |
| `sp_InsertInvoiceNotBinding` | @ApplyType VARCHAR, @CustomerId INT, @CustomerCode VARCHAR, @CustomerTypeId INT (+8 more) | SI |  |  |  |  | tblCustMaster, tblInvoiceNotBinding | `spec/database/procs/sp_InsertInvoiceNotBinding.sql` |
| `sp_Process_DWSPReport_Territory` | @Month nvarchar, @MonthValue int, @Year nvarchar, @ApprovalStatus nvarchar (+3 more) | SI |  |  |  |  | tblASMInfo, tblArea, tblDesignation, tblEmpGeneralInfo, tblMIOInfo, tblRegion (+5 more) | `spec/database/procs/sp_Process_DWSPReport_Territory.sql` |
| `sp_Process_YearlyLeaveBalance` | @ProcessBy INT | SI |  |  |  |  | Employee_YearlyLeaveBalance, Employee_YearlyLeaveTranscations, tblEmpGeneralInfo, tblLeaveConfig, tblLeaveConfigCountDtl | `spec/database/procs/sp_Process_YearlyLeaveBalance.sql` |
| `sp_RPT_ChallanStatusByDate` | @Month INT, @Year INT | S |  |  |  |  | tblChalanDetail, tblChalanInfo | `spec/database/procs/sp_RPT_ChallanStatusByDate.sql` |
| `sp_RPT_MonthlyExpense` | @Parm nvarchar, @Month nvarchar, @Year nvarchar | S |  |  | Y |  | sp_executesql, tblEmpGeneralInfo, tblRoleType, tblUser, tbl_ExpenseClaim, tbl_MileageClaim (+4 more) | `spec/database/procs/sp_RPT_MonthlyExpense.sql` |
| `sp_RPT_SalesConfirmStatusByDate` | @Month INT, @Year INT | S |  |  |  |  | SAP_API_Data | `spec/database/procs/sp_RPT_SalesConfirmStatusByDate.sql` |
| `sp_RPT_SalesReturnStatusByDate` | @Month INT, @Year INT | S |  |  |  |  | SAP_API_Data | `spec/database/procs/sp_RPT_SalesReturnStatusByDate.sql` |
| `sp_SAP_BankDeposit_SAP_Process` | @frmdate DATE, @todate DATE, @msgRes NVARCHAR OUT | SID | Y |  |  |  | SAP_API_Data, src, tblBankSAPMapping, tblCompanyUnit, tblCompanyWiseDeposit | `spec/database/procs/sp_SAP_BankDeposit_SAP_Process.sql` |
| `sp_SAP_BankDepositSendtoSAP` | @Ids NVARCHAR, @msgRes NVARCHAR OUT | SU | Y |  |  |  | SAP_API_Data, fnSplit | `spec/database/procs/sp_SAP_BankDepositSendtoSAP.sql` |
| `sp_Save_BDoctorChemberDetail` | @ChamberTypeId INT, @DoctorId INT, @Name nvarchar, @Phone nvarchar (+1 more) | SI |  |  |  |  | tblDoctorChemberDetail | `spec/database/procs/sp_Save_BDoctorChemberDetail.sql` |
| `sp_Save_BonusCampaignCustomerDetail` | @CampaignMasterId INT, @CustomerMasterId INT | I |  |  |  |  | tbl_BonusCampaignCustomerDetail | `spec/database/procs/sp_Save_BonusCampaignCustomerDetail.sql` |
| `sp_Save_BonusCampaignMarketDetail` | @CampaignMasterId INT, @GroupId INT, @RegionId INT, @AreaId INT (+3 more) | I |  |  |  |  | tbl_BonusCampaignMarketDetail | `spec/database/procs/sp_Save_BonusCampaignMarketDetail.sql` |
| `sp_Save_BonusCampaignNewDetail` | @CampaignMasterId INT, @DiscountPercentage decimal, @ProductId int, @Quantity decimal (+6 more) | I |  |  |  |  | tbl_BonusCampaignNewDetail | `spec/database/procs/sp_Save_BonusCampaignNewDetail.sql` |
| `sp_Save_BonusCampaignNewDetail_Up` | @CampaignMasterId INT, @CampaignDetailId INT, @DiscountPercentage decimal, @ProductId int (+7 more) | SIU |  |  |  |  | tblOrderDetail, tbl_BonusCampaignNewDetail | `spec/database/procs/sp_Save_BonusCampaignNewDetail_Up.sql` |
| `sp_Save_BonusCampaignNewMaster` | @CampgainMasterId INT, @CampaignName nvarchar, @FromDate datetime, @ToDate datetime (+15 more) | SI |  |  |  |  | tbl_BonusCampaignNewMaster | `spec/database/procs/sp_Save_BonusCampaignNewMaster.sql` |
| `sp_Save_CustomerMaster` | @CustomerMasterId int, @CustomerName nvarchar, @Address nvarchar, @CellNo nvarchar (+28 more) | SI |  |  |  |  | tblArea, tblCompanyUnit, tblCustMaster, tblMarketStationDetail, tblRegion, tblSubTerritory (+5 more) | `spec/database/procs/sp_Save_CustomerMaster.sql` |
| `sp_Save_CustomerPropUpdateDetail` | @CustPropUpdateDetailId INT, @CustPropMasterId INT, @CustCode NVARCHAR, @ProviderType NVARCHAR (+3 more) | SI |  |  |  |  | tblCustMaster, tblCustomerPropUpdateDetail, tblCustomerType, tblMarket, tblProgramType, tblSMCType | `spec/database/procs/sp_Save_CustomerPropUpdateDetail.sql` |
| `sp_Save_CustomerPropUpdateMaster` | @CustPropMasterId INT, @TypeId INT, @EntryBy NVARCHAR, @ConvertType NVARCHAR | SI |  |  |  |  | tblCustomerPropUpdateMaster | `spec/database/procs/sp_Save_CustomerPropUpdateMaster.sql` |
| `sp_Save_CustomerTypeInfo` | @id INT, @CustomerType NVARCHAR, @EntryBy INT, @CustomerCategoryId INT (+3 more) | SI |  |  |  |  | tblCustomerType | `spec/database/procs/sp_Save_CustomerTypeInfo.sql` |
| `sp_Save_CustProductLineDetail` | @ProductLineID INT, @CustomerMasterId INT | I |  |  |  |  | tblCustProductLine | `spec/database/procs/sp_Save_CustProductLineDetail.sql` |
| `sp_Save_CustTaggDoc` | @CustomerMasterId INT, @DoctorId INT | I |  |  |  |  | tblCustTaggDoc | `spec/database/procs/sp_Save_CustTaggDoc.sql` |
| `sp_Save_DAInfo` | @NID NVARCHAR, @Name NVARCHAR, @Address NVARCHAR, @PhoneNo NVARCHAR (+11 more) | SI |  |  |  |  | tblDAInfo | `spec/database/procs/sp_Save_DAInfo.sql` |
| `sp_Save_DcWiseTerritoryDetail` | @DcWiseTerritoryMasterId INT, @TerritoryId int | SI |  |  |  |  | tblDcWiseTerritoryDetail | `spec/database/procs/sp_Save_DcWiseTerritoryDetail.sql` |
| `sp_Save_DcWiseTerritoryMaster` | @DcWiseTerritoryMasterId INT, @DCId INT, @GroupId INT, @RegionId INT (+3 more) | SI |  |  |  |  | tblDcWiseTerritoryMaster | `spec/database/procs/sp_Save_DcWiseTerritoryMaster.sql` |
| `sp_Save_DoctorBrandDetail` | @DoctorId INT, @BrandId int | I |  |  |  |  | tblDoctorBrandDetail | `spec/database/procs/sp_Save_DoctorBrandDetail.sql` |
| `sp_Save_DoctorContactDetail_New` | @DoctorId INT, @ContactTypeId INT, @ContactType NVARCHAR, @Contact NVARCHAR | I |  |  |  |  | tblDoctorContactDetail | `spec/database/procs/sp_Save_DoctorContactDetail_New.sql` |
| `sp_Save_DoctorDegreeDetail` | @DoctorId INT, @DegId INT | I |  |  |  |  | tblDoctorDegreeDetail | `spec/database/procs/sp_Save_DoctorDegreeDetail.sql` |
| `sp_Save_DoctorMaster` | @DoctorId int, @SecondaryCode nvarchar, @DesignationId int, @Gender nvarchar (+17 more) | SI |  |  |  |  | tblDoctorMaster | `spec/database/procs/sp_Save_DoctorMaster.sql` |
| `sp_Save_DoctorPropUpdateDetail` | @CustPropUpdateDetailId INT, @CustPropMasterId INT, @CustCode NVARCHAR, @ProviderType NVARCHAR (+3 more) | SI |  |  |  |  | tblDoctorMaster, tblDoctorPropUpdateDetail, tblDoctorType, tblMarket, tblProgramType, tblSMCType | `spec/database/procs/sp_Save_DoctorPropUpdateDetail.sql` |
| `sp_Save_DoctorPropUpdateMaster` | @CustPropMasterId INT, @TypeId INT, @EntryBy NVARCHAR, @ConvertType NVARCHAR | SI |  |  |  |  | tblDoctorPropUpdateMaster | `spec/database/procs/sp_Save_DoctorPropUpdateMaster.sql` |
| `sp_Save_DoctorSpecialDayDetails` | @DoctorId INT, @SpecialDayId INT, @SpecialDate datetime | I |  |  |  |  | tblDoctorSpecialDayDetail | `spec/database/procs/sp_Save_DoctorSpecialDayDetails.sql` |
| `sp_Save_DoctorSpecialityDetail` | @DoctorId INT, @SpecialityId NVARCHAR | I |  |  |  |  | tblDoctorSpecialityDetail | `spec/database/procs/sp_Save_DoctorSpecialityDetail.sql` |
| `sp_Save_EmployeeAllowanceDetail` | @EmpInfoId INT, @AllowanceId INT | I |  |  |  |  | EmployeeAllowance | `spec/database/procs/sp_Save_EmployeeAllowanceDetail.sql` |
| `sp_Save_EmployeeInformation` | @EmpInfoId int, @CompanyId int, @EmpName nvarchar, @EmpMasterCode nvarchar (+31 more) | SI |  |  |  |  | tblEmpGeneralInfo | `spec/database/procs/sp_Save_EmployeeInformation.sql` |
| `sp_Save_LeaveConfigDtl` | @LeaveConfigId int, @LeaveName nvarchar, @JoiningDateCountId int, @DaysPerMonthly decimal | I |  |  |  |  | tblLeaveConfigCountDtl | `spec/database/procs/sp_Save_LeaveConfigDtl.sql` |
| `sp_Save_LeaveConfigFroenEmp` | @LeaveConfigId int, @EmployeeId int | I |  |  |  |  | tblLeaveConfigForeignId | `spec/database/procs/sp_Save_LeaveConfigFroenEmp.sql` |
| `sp_Save_LeaveConfigMaster` | @LeaveConfigId int OUT, @LeaveName nvarchar, @CountGovtLeave BIT, @CountEmployeeHoliday BIT (+5 more) | SI |  |  |  |  | tblLeaveConfig | `spec/database/procs/sp_Save_LeaveConfigMaster.sql` |
| `sp_Save_NoticeImage` | @id INT, @ImagePath NVARCHAR | SI |  |  |  |  | tbl_ImagePath_Setting | `spec/database/procs/sp_Save_NoticeImage.sql` |
| `sp_Save_ProductDCDetails` | @ProductId INT, @ComUnitId INT | I |  |  |  |  | tblProductDCDetails | `spec/database/procs/sp_Save_ProductDCDetails.sql` |
| `sp_Save_ProgramTypeInfo` | @id INT, @ProgramTypeName NVARCHAR, @EntryBy INT, @IsActive BIT (+3 more) | SI |  |  |  |  | tblProgramType | `spec/database/procs/sp_Save_ProgramTypeInfo.sql` |
| `sp_Save_QuotedPriceDetail` | @QuotedPriceMasterId INT, @ProductId int, @UnitPrice decimal, @Vat decimal | I |  |  |  |  | tblQuotedPriceDetail | `spec/database/procs/sp_Save_QuotedPriceDetail.sql` |
| `sp_Save_QuotedPriceMaster` | @QuotedPriceMasterId int, @Description NVARCHAR, @Policy NVARCHAR, @IsCustomerWise bit (+12 more) | SI |  |  |  |  | tblQuotedPriceMaster | `spec/database/procs/sp_Save_QuotedPriceMaster.sql` |
| `sp_Save_RouteInformationDADetail` | @RouteInformationMasterId INT, @DAId INT | I |  |  |  |  | tblRouteInformationDADetail | `spec/database/procs/sp_Save_RouteInformationDADetail.sql` |
| `sp_Save_RouteInformationMarketDetail` | @RouteInformationMasterId INT, @GroupId INT, @RegionId INT, @AreaId INT (+4 more) | I |  |  |  |  | tblRouteInformationMarketDetail | `spec/database/procs/sp_Save_RouteInformationMarketDetail.sql` |
| `sp_Save_RouteInformationMaster` | @RouteInformationMasterId INT, @DCId INT, @IsSubDepo bit, @RouteName nvarchar (+6 more) | SI |  |  |  |  | tblRouteInformationMaster | `spec/database/procs/sp_Save_RouteInformationMaster.sql` |
| `sp_Save_RouteInformationWeekNameDetails` | @RouteInformationMasterId INT, @WeekNameId int | I |  |  |  |  | tblRouteInformationWeekNameDetails | `spec/database/procs/sp_Save_RouteInformationWeekNameDetails.sql` |
| `sp_Save_RouteMarketDetail_TerritoryWise` | @RouteInformationMasterId INT, @GroupId INT, @RegionId INT, @AreaId INT (+4 more) | SID |  |  |  |  | tblRouteInformationMarketDetail | `spec/database/procs/sp_Save_RouteMarketDetail_TerritoryWise.sql` |
| `sp_Save_SMCTypeInfo` | @id INT, @SMCType NVARCHAR, @EntryBy INT, @IsActive BIT (+3 more) | SI |  |  |  |  | tblSMCType | `spec/database/procs/sp_Save_SMCTypeInfo.sql` |
| `sp_Save_StationTypeInfo` | @id INT, @StationTypeName NVARCHAR, @EntryBy INT, @IsActive BIT (+2 more) | SI |  |  |  |  | tblStationType | `spec/database/procs/sp_Save_StationTypeInfo.sql` |
| `sp_Save_TourSetupEmployee` | @IsRoleWise bit, @IsEmployeeWise bit, @EmpInfoId INT, @StationTypeId INT (+4 more) | SI |  |  |  |  | tblEmpGeneralInfo, tblTourSetupEmployee, tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_Save_TourSetupEmployee.sql` |
| `sp_SaveLeaveAppLog` | @LeaveApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster (+5 more) | `spec/database/procs/sp_SaveLeaveAppLog.sql` |
| `sp_UD_CustomerTypeInfo` | @id INT, @CustomerType NVARCHAR, @UpdateBy INT, @IsActive BIT (+3 more) | U |  |  |  |  | tblCustomerType | `spec/database/procs/sp_UD_CustomerTypeInfo.sql` |
| `sp_UD_ProgramTypeInfo` | @id INT, @ProgramTypeName NVARCHAR, @UpdateBy INT, @IsActive BIT (+3 more) | U |  |  |  |  | tblProgramType | `spec/database/procs/sp_UD_ProgramTypeInfo.sql` |
| `sp_UD_RouteInformationMaster` | @RouteInformationMasterId INT, @DCId INT, @RouteName nvarchar, @IsSubDepo bit (+6 more) | UD |  |  |  |  | tblRouteInformationDADetail, tblRouteInformationMarketDetail, tblRouteInformationMaster, tblRouteInformationWeekNameDetails | `spec/database/procs/sp_UD_RouteInformationMaster.sql` |
| `sp_UD_SMCTypeInfo` | @id INT, @SMCType NVARCHAR, @UpdateBy INT, @IsActive BIT (+3 more) | U |  |  |  |  | tblSMCType | `spec/database/procs/sp_UD_SMCTypeInfo.sql` |
| `sp_UD_StationTypeInfo` | @id INT, @StationTypeName NVARCHAR, @UpdateBy INT, @IsActive BIT (+2 more) | U |  |  |  |  | tblStationType | `spec/database/procs/sp_UD_StationTypeInfo.sql` |
| `sp_Up_LeaveConfigMaster` | @LeaveConfigId int OUT, @LeaveName nvarchar, @CountGovtLeave BIT, @CountEmployeeHoliday BIT (+5 more) | UD |  |  |  |  | tblLeaveConfig, tblLeaveConfigCountDtl, tblLeaveConfigForeignId | `spec/database/procs/sp_Up_LeaveConfigMaster.sql` |
| `sp_Update_BonusCampaignNewMaster` | @CampgainMasterId INT, @CampaignName nvarchar, @FromDate datetime, @ToDate datetime (+16 more) | UD |  |  |  |  | tbl_BonusCampaignCustomerDetail, tbl_BonusCampaignMarketDetail, tbl_BonusCampaignNewDetail, tbl_BonusCampaignNewMaster | `spec/database/procs/sp_Update_BonusCampaignNewMaster.sql` |
| `sp_Update_BonusCampaignpkCampaignSetupId` | @CampaignMasterId INT, @CampgainMasterMapId INT, @CustomerTypeId int | SI |  |  |  |  | tbl_BonusCampaignDetailsCustType, tbl_BonusCampaignNewMaster | `spec/database/procs/sp_Update_BonusCampaignpkCampaignSetupId.sql` |
| `sp_Update_Customer_Doctor_Transfer` | @MasterId NVARCHAR, @MarketId NVARCHAR, @ApprovedBy NVARCHAR, @Type NVARCHAR (+2 more) | SI |  |  |  |  | fnSplit, tblCusDocTran, tblCustMaster, tblCustMaster_TranferLog, tblDoctorMaster, tblDoctorMaster_TranferLog | `spec/database/procs/sp_Update_Customer_Doctor_Transfer.sql` |
| `sp_Update_Customer_Doctor_TransferApprove` | @MasterId NVARCHAR, @MarketId NVARCHAR, @ApprovedBy NVARCHAR, @Type NVARCHAR (+2 more) | SU |  |  |  |  | tblCustMaster, tblCustMaster_TranferLog, tblDoctorMaster_TranferLog | `spec/database/procs/sp_Update_Customer_Doctor_TransferApprove.sql` |
| `sp_Update_Customer_Doctor_TransferApproveNew` | @MasterId NVARCHAR, @ApprovedBy NVARCHAR, @Type NVARCHAR | SU |  |  |  |  | tblCustMaster, tblCustMaster_TranferLog, tblDoctorMaster, tblDoctorMaster_TranferLog | `spec/database/procs/sp_Update_Customer_Doctor_TransferApproveNew.sql` |
| `sp_Update_CustomerMaster` | @CustomerMasterId int, @CustomerName nvarchar, @Address nvarchar, @CellNo nvarchar (+28 more) | SIUD |  |  |  |  | tblArea, tblCustMaster, tblCustMaster_Log, tblCustProductLine, tblMarketStationDetail, tblRegion (+6 more) | `spec/database/procs/sp_Update_CustomerMaster.sql` |
| `sp_Update_CustomerProgramType` | @CustomerMasterId int, @ProgramTypeId int, @ProgramTypeCode nvarchar, @UpdateBy INT (+1 more) | SIU |  |  |  |  | tblCustMaster, tblCustProgramTypeChange | `spec/database/procs/sp_Update_CustomerProgramType.sql` |
| `sp_Update_CustPropUpdate` | @CustPropMasterId INT, @UpdateBy int | SU |  |  |  |  | tblCustMaster, tblCustomerPropUpdateDetail, tblCustomerPropUpdateMaster | `spec/database/procs/sp_Update_CustPropUpdate.sql` |
| `sp_Update_DAInfo` | @DAId INT, @NID NVARCHAR, @Name NVARCHAR, @Address NVARCHAR (+12 more) | U |  |  |  |  | tblDAInfo | `spec/database/procs/sp_Update_DAInfo.sql` |
| `sp_Update_DcWiseTerritoryMaster` | @DcWiseTerritoryMasterId INT, @DCId INT, @GroupId INT, @RegionId INT (+3 more) | U |  |  |  |  | tblDcWiseTerritoryMaster | `spec/database/procs/sp_Update_DcWiseTerritoryMaster.sql` |
| `sp_Update_DoctorMaster` | @DoctorId int, @SecondaryCode nvarchar, @DesignationId int, @Gender nvarchar (+17 more) | SIUD |  |  |  |  | tblDoctorBrandDetail, tblDoctorChemberDetail, tblDoctorContactDetail, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorMaster_Log (+4 more) | `spec/database/procs/sp_Update_DoctorMaster.sql` |
| `sp_Update_DoctorPropUpdate` | @CustPropMasterId INT, @UpdateBy int | SU |  |  |  |  | tblDoctorMaster, tblDoctorPropUpdateDetail, tblDoctorPropUpdateMaster | `spec/database/procs/sp_Update_DoctorPropUpdate.sql` |
| `sp_Update_EmployeeInformation` | @EmpInfoId int, @CompanyId int, @EmpName nvarchar, @EmpMasterCode nvarchar (+31 more) | SU |  |  |  |  | tblASMInfo, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRoleType (+2 more) | `spec/database/procs/sp_Update_EmployeeInformation.sql` |
| `sp_Update_OrderDC` | @DCID NVARCHAR, @RouteNameId NVARCHAR, @ApprovedBy NVARCHAR, @OrdId NVARCHAR | SU |  |  |  |  | fnSplit, tblCompanyUnit, tblOrder | `spec/database/procs/sp_Update_OrderDC.sql` |
| `sp_Update_QuotedPriceMaster` | @QuotedPriceMasterId int, @Description NVARCHAR, @Policy NVARCHAR, @IsCustomerWise bit (+12 more) | UD |  |  |  |  | tblQuotedPriceDetail, tblQuotedPriceMaster | `spec/database/procs/sp_Update_QuotedPriceMaster.sql` |
| `sp_Update_TargetInfo` | @SL INT, @UpdateBy nvarchar, @Value DECIMAL, @FYId int (+3 more) | U |  |  |  |  | tblTerritoryDataMigration | `spec/database/procs/sp_Update_TargetInfo.sql` |
| `sp_Update_TourSetupEmployee` | @TourSetupEmployeeId int, @CountNo int, @UpdateBy INT, @UpdateDate DATETIME | U |  |  |  |  | tblTourSetupEmployee | `spec/database/procs/sp_Update_TourSetupEmployee.sql` |
| `sp_UpdateCustomerInvoiceLimit` | @Id INT, @MaximumInvoiceValue DECIMAL, @Remarks NVARCHAR, @IsActive BIT (+1 more) | U |  |  |  |  | tblCustomerInvoiceLimit | `spec/database/procs/sp_UpdateCustomerInvoiceLimit.sql` |
| `sp_UpdateInvoiceNotBinding` | @InvoiceNotBindingId INT, @ActiveFromDate DATE, @ActiveToDate DATE, @AllowedNoOfInvoice INT (+5 more) | U |  |  |  |  | tblInvoiceNotBinding | `spec/database/procs/sp_UpdateInvoiceNotBinding.sql` |
| `sp_web_SaveExpanseAppLog` | @ExpanseApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblEmpGeneralInfo, tblExpanseApprovalLog (+3 more) | `spec/database/procs/sp_web_SaveExpanseAppLog.sql` |
| `sp_web_SaveMileageAppLog` | @MileageApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblEmpGeneralInfo, tblMileageApprovalLog (+3 more) | `spec/database/procs/sp_web_SaveMileageAppLog.sql` |
| `sp_web_SaveTADAAppLog` | @TADAApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblEmpGeneralInfo, tblTADAApprovalLog (+3 more) | `spec/database/procs/sp_web_SaveTADAAppLog.sql` |
| `sp_Webapi_Get_AttendanceInformation` | @param NVARCHAR, @Role NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblApprovalLog, tblEmpGeneralInfo, tblMarketAttendance_Master_webapi, tbl_ImagePath_Setting | `spec/database/procs/sp_Webapi_Get_AttendanceInformation.sql` |
| `sp_Webapi_Get_CustomerApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+6 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblCustMaster, tblCustomerApprovalLog, tblCustomerType, tblDistributionRoute (+9 more) | `spec/database/procs/sp_Webapi_Get_CustomerApp.sql` |
| `sp_Webapi_Get_DoctorClaimApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+5 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblDoctorApprovalLog_New, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorDesignation (+9 more) | `spec/database/procs/sp_Webapi_Get_DoctorClaimApp.sql` |
| `sp_Webapi_Get_EmpAllawance` | @EmpInfoId nvarchar | S |  |  |  |  | fnSplit, tblEmpGeneralInfo, tbl_MonthlyAllowance, tbl_MonthlyAllowanceDetail | `spec/database/procs/sp_Webapi_Get_EmpAllawance.sql` |
| `sp_Webapi_Get_EmpAllawance_MonthYear` | @EmpInfoId nvarchar, @Month nvarchar, @Year nvarchar | S |  |  |  |  | fnSplit, tblEmpGeneralInfo, tbl_MonthlyAllowance, tbl_MonthlyAllowanceDetail | `spec/database/procs/sp_Webapi_Get_EmpAllawance_MonthYear.sql` |
| `sp_Webapi_Get_Leave_AppLog` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+2 more) | S |  |  | Y |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, View_Webapi_EmployeeFieldForceInfo, sys, tblEmpGeneralInfo, tblLeaveApprovalLog (+5 more) | `spec/database/procs/sp_Webapi_Get_Leave_AppLog.sql` |
| `sp_Webapi_Get_LeaveApproveById` | @id INT | S |  |  |  |  | Employee_LeaveApplications, tblAction | `spec/database/procs/sp_Webapi_Get_LeaveApproveById.sql` |
| `sp_Webapi_Get_OrderApp` | @param NVARCHAR, @Role NVARCHAR, @AppStatus NVARCHAR, @FromDt DATETIME (+8 more) | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, sys, tblEmpGeneralInfo, tblMarket, tblOrder, tblOrderApprovalLog (+1 more) | `spec/database/procs/sp_Webapi_Get_OrderApp.sql` |
| `sp_Webapi_Get_TourPlanBalanceEmp` | @EmpInfoId nvarchar, @Month nvarchar, @year nvarchar | S |  |  |  |  | fnSplit, tblEmpGeneralInfo, tblStationType, tbl_TadaClaimMaster | `spec/database/procs/sp_Webapi_Get_TourPlanBalanceEmp.sql` |
| `sp_Webapi_Get_TourPlanBalanceWithEmpInfo` | @EmpInfoId INT, @Month INT, @year INT | S |  |  |  |  | tblStationType, tbl_TourPlanInfo | `spec/database/procs/sp_Webapi_Get_TourPlanBalanceWithEmpInfo.sql` |
| `sp_Webapi_LeaveReport_Details` | @Parm nvarchar, @Parm2 nvarchar, @Year nvarchar | S |  |  | Y |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, sp_executesql, tblEmpGeneralInfo, tblLeaveConType, tblLeaveEncashBlnc (+2 more) | `spec/database/procs/sp_Webapi_LeaveReport_Details.sql` |
| `sp_Webapi_LeaveReport_New` | @Parm nvarchar | S |  |  | Y |  | Employe_LeaveTypeInfos, Employee_YearlyLeaveBalance, sp_executesql, tblEmpGeneralInfo | `spec/database/procs/sp_Webapi_LeaveReport_New.sql` |
| `sp_Webapi_LeaveReport_Summary` | @Parm nvarchar, @Parm2 nvarchar, @Year nvarchar | S |  |  | Y |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, sp_executesql, tblASMInfo, tblArea, tblDesignation (+9 more) | `spec/database/procs/sp_Webapi_LeaveReport_Summary.sql` |
| `sp_Webapi_Save_LeaveInfo` | @leaveAppId INT, @typeId INT, @startDate DATETIME, @endDate DATETIME (+6 more) | SI |  |  |  |  | Employee_GovtHolidays, Employee_LeaveApplications, Employee_YearlyLeaveBalance, View_webapi_FieldForce, sp_webapi_SaveLeaveAppLog, tblAction (+5 more) | `spec/database/procs/sp_Webapi_Save_LeaveInfo.sql` |
| `sp_webapi_SaveAppLog` | @ApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalLog, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblEmpGeneralInfo (+3 more) | `spec/database/procs/sp_webapi_SaveAppLog.sql` |
| `sp_webapi_SaveCustomerAppLog` | @CustomerApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, sp_Webapi_NotificationPost, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblCustMaster (+4 more) | `spec/database/procs/sp_webapi_SaveCustomerAppLog.sql` |
| `sp_webapi_SaveDCRAppLog` | @DCRApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblDCRApprovalLog, tblGroupWisePromoQty (+5 more) | `spec/database/procs/sp_webapi_SaveDCRAppLog.sql` |
| `sp_webapi_SaveDoctorAppLog` | @DoctorApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, sp_Webapi_NotificationPost, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblDoctorApprovalLog_New (+4 more) | `spec/database/procs/sp_webapi_SaveDoctorAppLog.sql` |
| `sp_webapi_SaveLeaveAppLog` | @LeaveApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | Employee_LeaveApplications, Employee_YearlyLeaveBalance, View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster (+5 more) | `spec/database/procs/sp_webapi_SaveLeaveAppLog.sql` |
| `sp_webapi_SaveOrderAppLog` | @OrderApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblOrder, tblOrderApprovalLog (+2 more) | `spec/database/procs/sp_webapi_SaveOrderAppLog.sql` |
| `sp_webapi_SavePrescriptionAppLog` | @PrescriptionApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIU |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblPrescriptionApprovalLog, tblUser (+2 more) | `spec/database/procs/sp_webapi_SavePrescriptionAppLog.sql` |
| `sp_webapi_SaveTourPlanAppLog` | @TourPlanApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIUD |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblEmpGeneralInfo, tblTourPlanApprovalLog (+4 more) | `spec/database/procs/sp_webapi_SaveTourPlanAppLog.sql` |
| `sp_webapi_SaveVisitPlanAppLog` | @VisitPlanApprovalId INT, @Date DATETIME, @FromEmpId INT, @ToEmpId INT (+26 more) | SIUD |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblApprovalMapDetail, tblApprovalMapMaster, tblApprovalStepMaster, tblEmpGeneralInfo, tblUser (+4 more) | `spec/database/procs/sp_webapi_SaveVisitPlanAppLog.sql` |
| `sp_Webapi_Update_LeaveData` | @id INT, @approvalType NVARCHAR, @empId INT | SIU |  |  |  |  | Employee_LeaveApplications, Employee_YearlyLeaveTranscations | `spec/database/procs/sp_Webapi_Update_LeaveData.sql` |
| `spInsertReturnInvoice_new` | @ReturnInvoiceId INT, @InvoiceDate datetime, @OrderId int, @OrderNo nvarchar (+32 more) | SI |  |  |  |  | tblArea, tblRegion, tblReturnInvoice, tblTerritory | `spec/database/procs/spInsertReturnInvoice_new.sql` |
| `usp_CheckCampaignEntryDate` | (none) | S |  |  |  |  | tblCustMasterCampNew, tbl_BonusCampaignNewMaster | `spec/database/procs/usp_CheckCampaignEntryDate.sql` |

### SInventory_DAL (124 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_AreawiseDailyOpeningClosingStockDepowise` | @fromDate datetime, @toDate DATETIME, @CiD int | S |  |  |  |  | SalesDisDB_SMC, tblChalanDetail, tblChalanInfo, tblCompanyUnit, tblDCStore, tblDCStoreFreeze (+12 more) | `spec/database/procs/sp_AreawiseDailyOpeningClosingStockDepowise.sql` |
| `sp_AreawiseDailyOpeningClosingStockNational` | @fromDate datetime, @toDate DATETIME | S |  |  |  |  | SalesDisDB_SMC, tblChalanDetail, tblChalanInfo, tblCompanyUnit, tblDCStore, tblDCStoreFreeze (+12 more) | `spec/database/procs/sp_AreawiseDailyOpeningClosingStockNational.sql` |
| `sp_AutoInvoiceGeneration` | @OrderCodeInPut NVARCHAR, @UserId INT | SIU |  |  |  | Y | MY_Order, MY_data, View_CustomerMaster, tblDCStore, tblInvoice, tblInvoiceDetail (+2 more) | `spec/database/procs/sp_AutoInvoiceGeneration.sql` |
| `sp_BeforesndSalesReturnList` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblMarket, tblOrder | `spec/database/procs/sp_BeforesndSalesReturnList.sql` |
| `sp_BusinessSummaryMISReport` | @fromdate datetime, @todate datetime | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+17 more) | `spec/database/procs/sp_BusinessSummaryMISReport.sql` |
| `sp_BusinessSummaryMISReport_All_New` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+1 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+17 more) | `spec/database/procs/sp_BusinessSummaryMISReport_All_New.sql` |
| `sp_BusinessSummaryMISReport_All_New_New` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+17 more) | `spec/database/procs/sp_BusinessSummaryMISReport_All_New_New.sql` |
| `sp_BusinessSummaryMISReport_Loading` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+1 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+19 more) | `spec/database/procs/sp_BusinessSummaryMISReport_Loading.sql` |
| `sp_BusinessSummaryMISReport_TT` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+17 more) | `spec/database/procs/sp_BusinessSummaryMISReport_TT.sql` |
| `sp_Check_Duplicate_InvoiceFinalPayment` | @InvoiceId INT, @PaymentAmount decimal | S |  |  |  |  | tblCustPayDetail | `spec/database/procs/sp_Check_Duplicate_InvoiceFinalPayment.sql` |
| `sp_CustomerLedger` | @Cust nvarchar, @fromdate datetime, @todate datetime | S |  |  |  |  | SalesDisDB_SMC, tblCustMaster, tblCustomerType, tblInvoice, tblInvoiceDetail, tblMarket (+1 more) | `spec/database/procs/sp_CustomerLedger.sql` |
| `sp_CustomerLedgerNew` | @Cust nvarchar, @fromdate datetime, @todate datetime | S |  |  |  |  | tblCustMaster, tblCustPayDetail, tblCustomerType, tblInvoice, tblInvoiceDetail, tblInvoiceDetailReturn (+2 more) | `spec/database/procs/sp_CustomerLedgerNew.sql` |
| `sp_CustomerTransfer` | @CustomerMasterExcelFileMasterID INT | SIU |  |  |  |  | tblCustMaster, tblCustomerMasterExcelFileDetail, tblCustomerMasterExcelFileMaster | `spec/database/procs/sp_CustomerTransfer.sql` |
| `sp_CustomerTransferTagChange` | @CustomerTagChangeExcelFileMasterID INT | SU |  |  |  |  | tblCustMaster, tblCustomerMasterTagChangeExcelFileDetail, tblCustomerMasterTagChangeExcelFileMaster | `spec/database/procs/sp_CustomerTransferTagChange.sql` |
| `sp_Del_B2BDelete` | @chalanId nvarchar | SUD |  |  |  |  | tblChalanDetail, tblDCStore | `spec/database/procs/sp_Del_B2BDelete.sql` |
| `sp_Delete_ProformaInvoice` | @InvoiceCode NVARCHAR, @User NVARCHAR | SIUD | Y | Y |  |  | tblDCStore, tblInvoice, tblInvoiceDeleteLog, tblInvoiceDetail, tblInvoiceDetail_DeleterRecord, tblOrder (+3 more) | `spec/database/procs/sp_Delete_ProformaInvoice.sql` |
| `sp_Delete_ProformaInvoice_SubDeport` | @InvoiceCode NVARCHAR, @User NVARCHAR | SIUD |  |  |  |  | tblInvoiceDeleteLog, tblInvoiceDetail_DeleterRecord, tblOrder, tblOrderDetail, tblProInvoiceReturnTrack, tblSubDepotStore (+2 more) | `spec/database/procs/sp_Delete_ProformaInvoice_SubDeport.sql` |
| `sp_DeleteDeliveryInvoice` | @DelivaryInvoiceNo nvarchar, @User NVARCHAR | SIUD |  |  |  |  | tblDCStore, tblInvoice, tblInvoiceDeleteLog, tblInvoiceDetail | `spec/database/procs/sp_DeleteDeliveryInvoice.sql` |
| `sp_DeleteDeliveryInvoiceSubdepo` | @DelivaryInvoiceNo nvarchar, @User NVARCHAR | SIUD |  |  |  |  | tblInvoiceDeleteLog, tblSubDepotStore, tblSubInvoiceDetail, tblSubInvoiceMaster | `spec/database/procs/sp_DeleteDeliveryInvoiceSubdepo.sql` |
| `sp_DeleteDwpotToWhChalan` | @masterId INT | D |  |  |  |  | tblDepotToWHChalanDetail, tblDepotToWHChalanInfo | `spec/database/procs/sp_DeleteDwpotToWhChalan.sql` |
| `sp_Deletenvoice` | @OrderID int | D |  |  |  |  |  | `spec/database/procs/sp_Deletenvoice.sql` |
| `sp_DeleteOrder` | @OrdID INT, @LoginName NVARCHAR | SID |  |  |  |  | tblInvoice, tblOrder, tblOrderDel, tblOrderDetail, tblOrderDetailDel | `spec/database/procs/sp_DeleteOrder.sql` |
| `sp_DeliveryConformationFull` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @UpdateDate DATETIME | SU |  |  |  | Y | MY_data, tblInvoice, tblInvoiceDetail | `spec/database/procs/sp_DeliveryConformationFull.sql` |
| `sp_DeliveryConformationFull_New` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @UpdateDate DATETIME | SU |  |  |  | Y | MY_data, tblInvoice, tblInvoiceDetail | `spec/database/procs/sp_DeliveryConformationFull_New.sql` |
| `sp_DeliveryConformationFull_OldData` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @UpdateDate DATETIME | SU |  |  |  | Y | MY_data, SalesDisDB_SMC | `spec/database/procs/sp_DeliveryConformationFull_OldData.sql` |
| `sp_DeliveryConformationReject` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @ReturnReason NVARCHAR, @UpdateDate DATETIME | SIU |  |  |  | Y | MY_data, SalesDisDB_SMC_NEWDB, tblDCStore, tblDCStoreFreeze, tblInvoice, tblInvoiceDetail | `spec/database/procs/sp_DeliveryConformationReject.sql` |
| `sp_DeliveryInvoiceCreationList` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblMarket, tblOrder | `spec/database/procs/sp_DeliveryInvoiceCreationList.sql` |
| `sp_DeliveryInvoiceCreationList_DA` | @param nvarchar | SU |  |  | Y |  | sp_executesql, tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblMarket, tblOrder (+2 more) | `spec/database/procs/sp_DeliveryInvoiceCreationList_DA.sql` |
| `sp_DeliveryInvoiceCreationList_New` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblMarket, tblOrder | `spec/database/procs/sp_DeliveryInvoiceCreationList_New.sql` |
| `sp_DICByregionid` | @EmployeeId INT, @RoleId INT | S |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblRegion, tblRouteInformationMarketDetail, tblRouteInformationMaster, tbl_Group | `spec/database/procs/sp_DICByregionid.sql` |
| `sp_GET_AllStockProductwise` | (none) | S |  |  | Y |  | F_ProductName, GetDCwiseStock, sp_executesql | `spec/database/procs/sp_GET_AllStockProductwise.sql` |
| `sp_GET_DA_PaymentInvSP` | @param NVARCHAR | S |  |  | Y |  | View_CustomerMaster, sp_executesql, tblBankInfo, tblCustPayDetail, tblDAInfo, tblInvoice (+3 more) | `spec/database/procs/sp_GET_DA_PaymentInvSP.sql` |
| `sp_GET_DatewiseSale` | @FromDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | F_DateName, GetDateWiseSale, GetDayes, sp_executesql | `spec/database/procs/sp_GET_DatewiseSale.sql` |
| `sp_GET_DZSMwiseNAtionalReport` | @FromDate nvarchar, @ToDate nvarchar | S |  |  |  |  | tblArea, tblCustMaster, tblInvoice, tblInvoiceDetail, tblSubInvoiceDetail, tblSubInvoiceMaster | `spec/database/procs/sp_GET_DZSMwiseNAtionalReport.sql` |
| `sp_GET_DZSMwiseReport` | @FromDate nvarchar, @ToDate nvarchar, @Dzsm nvarchar | S |  |  |  |  | tblArea, tblCustMaster, tblInvoice, tblInvoiceDetail, tblSubInvoiceDetail, tblSubInvoiceMaster | `spec/database/procs/sp_GET_DZSMwiseReport.sql` |
| `sp_GET_DZSMwiseReportParam_ByProcess` | @FromDate nvarchar, @ToDate nvarchar, @parm nvarchar | S |  |  |  |  | SalesDisDB_SMC, SalesDisDB_SMC_TrSalesRepor, tblCustMaster, tblInvoice | `spec/database/procs/sp_GET_DZSMwiseReportParam_ByProcess.sql` |
| `sp_GET_DZSMwiseReportParam_ByProcess_Area` | @FromDate nvarchar, @ToDate nvarchar, @ZoneSelect nvarchar, @AreaSelect nvarchar (+1 more) | S |  |  |  |  | SalesDisDB_SMC, SalesDisDB_SMC_NEWDB, SalesDisDB_SMC_TrSalesRepor, tblCustMaster, tblCustPayDetail, tblInvoice | `spec/database/procs/sp_GET_DZSMwiseReportParam_ByProcess_Area.sql` |
| `sp_GET_DZSMwiseReportParam_ByProcess_Terri` | @FromDate nvarchar, @ToDate nvarchar, @ZoneSelect nvarchar, @AreaSelect nvarchar (+1 more) | S |  |  |  |  | SalesDisDB_SMC, SalesDisDB_SMC_NEWDB, SalesDisDB_SMC_TrSalesRepor, tblCustMaster, tblCustPayDetail, tblInvoice | `spec/database/procs/sp_GET_DZSMwiseReportParam_ByProcess_Terri.sql` |
| `sp_GET_DZSMwiseReportParam_ByProcess_vv` | @FromDate nvarchar, @ToDate nvarchar, @ZoneSelect nvarchar, @AreaSelect nvarchar (+1 more) | S |  |  |  |  | SalesDisDB_SMC, SalesDisDB_SMC_NEWDB, SalesDisDB_SMC_TrSalesRepor, tblCustMaster, tblCustPayDetail, tblCustomerType (+1 more) | `spec/database/procs/sp_GET_DZSMwiseReportParam_ByProcess_vv.sql` |
| `sp_GET_DZSMwiseReportParam_ByTest` | @FromDate nvarchar, @ToDate nvarchar, @parm nvarchar | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCustMaster, tblInvoice, tblInvoiceDetail, tblOrderDetail (+4 more) | `spec/database/procs/sp_GET_DZSMwiseReportParam_ByTest.sql` |
| `sp_GET_DZSMwiseReportParam_new_Day` | @FromDate nvarchar, @ToDate nvarchar, @parm nvarchar | S |  |  | Y |  | tblDZSMwiseReportParam | `spec/database/procs/sp_GET_DZSMwiseReportParam_new_Day.sql` |
| `sp_GET_EmployeeWiseProductSale` | (none) | S |  |  | Y |  | EmployeeSale, F_ProductNameFromEmpSale, sp_executesql | `spec/database/procs/sp_GET_EmployeeWiseProductSale.sql` |
| `sp_Get_IntransitReportList` | @districtId nvarchar, @fromDate datetime, @toDate datetime | S |  |  | Y |  | SalesDisDB_SMC, sp_executesql, tblCompanyUnit, tblCustMaster, tblCustomerType, tblEmpGeneralInfo (+8 more) | `spec/database/procs/sp_Get_IntransitReportList.sql` |
| `sp_Get_InvoiceCreationRouteWiseSalesAssistantList` | @InputDate DATE, @DCId INT | S |  |  |  |  | tblDAInfo, tblRouteInformationDADetail, tblRouteInformationMarketDetail, tblRouteInformationMaster, tblRouteInformationWeekNameDetails, tblWeekNameInfo | `spec/database/procs/sp_Get_InvoiceCreationRouteWiseSalesAssistantList.sql` |
| `sp_Get_InvoiceCreationRouteWiseSalesAssistantListforSick` | @DCId INT | S |  |  |  |  | tblDAInfo, tblRouteInformationDADetail, tblRouteInformationMarketDetail, tblRouteInformationMaster | `spec/database/procs/sp_Get_InvoiceCreationRouteWiseSalesAssistantListforSick.sql` |
| `sp_Get_MoneyReceiptReportAfterPaymentList` | @Parm nvarchar | S |  |  | Y |  | sp_Update_Zero_PaymentInfo, sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblDAInfo (+2 more) | `spec/database/procs/sp_Get_MoneyReceiptReportAfterPaymentList.sql` |
| `sp_Get_MoneyReceiptReportAfterPaymentListforDALedger` | @Parm nvarchar | S |  |  | Y |  | DA, sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblDAInfo (+2 more) | `spec/database/procs/sp_Get_MoneyReceiptReportAfterPaymentListforDALedger.sql` |
| `sp_Get_MoneyReceiptReportList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/procs/sp_Get_MoneyReceiptReportList.sql` |
| `sp_Get_MonthlyInventoryReport` | @fromDate datetime, @toDate DATETIME, @CiD nvarchar, @ProTypId nvarchar | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblChalanDetail, tblChalanInfo, tblCompanyUnit, tblDCStore (+20 more) | `spec/database/procs/sp_Get_MonthlyInventoryReport.sql` |
| `sp_Get_MonthlyInventoryReportBatchWise` | @fromDate DATETIME, @toDate DATETIME, @CiD NVARCHAR | S |  |  |  |  | SalesDisDB_SMC, tblChalanDetail, tblChalanInfo, tblCompanyUnit, tblDCStore, tblDCStoreFreeze (+13 more) | `spec/database/procs/sp_Get_MonthlyInventoryReportBatchWise.sql` |
| `sp_GET_MonthwiseSale` | @FromDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | F_MonthName, GetMonthWiseSale, master, sp_executesql | `spec/database/procs/sp_GET_MonthwiseSale.sql` |
| `sp_Get_NewReceiveableList` | @districtId nvarchar, @fromDate nvarchar, @toDate nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType, tblEmpGeneralInfo (+8 more) | `spec/database/procs/sp_Get_NewReceiveableList.sql` |
| `sp_Get_NewReceiveableListforInvoice` | @districtId nvarchar, @fromDate nvarchar, @toDate nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType, tblEmpGeneralInfo (+7 more) | `spec/database/procs/sp_Get_NewReceiveableListforInvoice.sql` |
| `sp_Get_NewReceiveableListWeb` | @districtId nvarchar, @fromDate nvarchar, @toDate nvarchar | S |  |  |  |  | tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType, tblEmpGeneralInfo, tblInvoice (+7 more) | `spec/database/procs/sp_Get_NewReceiveableListWeb.sql` |
| `sp_GET_PaymentInvSP` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblOrder, tblReturnInvoice | `spec/database/procs/sp_GET_PaymentInvSP.sql` |
| `sp_GET_PaymentInvSPPaymentAmount` | @param nvarchar, @PaymentAmount nvarchar, @CollectionBy nvarchar | S |  |  | Y |  | sp_executesql, tblCustMaster, tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblOrder (+1 more) | `spec/database/procs/sp_GET_PaymentInvSPPaymentAmount.sql` |
| `sp_GET_PaymentInvSPSndReturn` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblInvoiceDetailReturn, tblOrder (+1 more) | `spec/database/procs/sp_GET_PaymentInvSPSndReturn.sql` |
| `sp_GET_PaymentInvSPTPVATAmt` | @InvoiceId int, @PayAmount decimal | S |  |  |  |  | tblCustMaster, tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblOrder, tblReturnInvoice | `spec/database/procs/sp_GET_PaymentInvSPTPVATAmt.sql` |
| `sp_GET_PendingSalesConfirmationReport` | @districtId nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblEmpGeneralInfo, tblInvoice, tblInvoiceDetail, tblMarket (+1 more) | `spec/database/procs/sp_GET_PendingSalesConfirmationReport.sql` |
| `sp_GetFinalSales` | @fromdate datetime, @todate datetime | S |  |  |  |  | tblCompanyUnit, tblCustMaster, tblDCStore, tblInvoice, tblInvoiceDetail, tblOrder (+2 more) | `spec/database/procs/sp_GetFinalSales.sql` |
| `sp_GetMarketwisePickingslipByBatchNo_daaw` | @BatchNo VARCHAR | S |  |  |  |  | tblCustMaster, tblInvoice, tblInvoiceBatch, tblInvoiceDetail, tblOrder, tblProduct (+1 more) | `spec/database/procs/sp_GetMarketwisePickingslipByBatchNo_daaw.sql` |
| `sp_GetTopSheetByBatchNo_daaw` | @BatchNo VARCHAR | S |  |  |  |  | tblCustMaster, tblCustomerType, tblDAInfo, tblInvoice, tblInvoiceBatch, tblInvoiceDetail (+4 more) | `spec/database/procs/sp_GetTopSheetByBatchNo_daaw.sql` |
| `sp_GetWarningForCustomerPayment_new` | @CustID nvarchar, @CustCode nvarchar | S |  |  |  |  | tblInvoice | `spec/database/procs/sp_GetWarningForCustomerPayment_new.sql` |
| `sp_I_Customer` | @DetailID INT OUT, @Migo int, @BRANCH NVARCHAR, @BRANCHDES NVARCHAR (+19 more) | I |  |  |  |  | tblCustomerMasterExcelFileDetail | `spec/database/procs/sp_I_Customer.sql` |
| `sp_I_Diposit_New` | @DepositId INT OUT, @CompanyId int, @BranchName NVARCHAR, @Amount decimal (+14 more) | SI |  |  |  |  | tblCompanyUnit, tblCompanyWiseDeposit, tblEmpGeneralInfo, tblMIOInfo, tblTerritory | `spec/database/procs/sp_I_Diposit_New.sql` |
| `sp_I_InvoiceMaster` | @InvoiceId int OUT, @InvoiceDate DATETIME, @OrderNo NVARCHAR, @OrderDate DATETIME (+16 more) | SI |  |  |  |  | tblInvoice | `spec/database/procs/sp_I_InvoiceMaster.sql` |
| `sp_InsertCustPayDetail_DeleteLog` | @Remarks NVARCHAR, @CustPayDetailId INT, @LoginName NVARCHAR | SIUD |  |  |  |  | tblCustPayDetail, tblCustPayDetail_DeleteLog, tblInvoice | `spec/database/procs/sp_InsertCustPayDetail_DeleteLog.sql` |
| `sp_InvoceLifecycle` | @fromDate DATETIME, @toDate DATETIME | S |  |  |  |  | tblCompanyUnit, tblInvoice, tblSubInvoiceMaster | `spec/database/procs/sp_InvoceLifecycle.sql` |
| `sp_LoadingSummary` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/procs/sp_LoadingSummary.sql` |
| `sp_LoadingSummary_da` | @param nvarchar | S |  |  | Y |  | sp_executesql, tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblOrder, tblSalesConfirmation_appLog | `spec/database/procs/sp_LoadingSummary_da.sql` |
| `sp_LoadOrderListForOrderCreation` | @manufacId int, @comunitId int | S |  |  |  |  | tblCustPayDetail, tblCustomerType, tblInvoice, tblInvoiceDetail, tblMarket, tblOrder | `spec/database/procs/sp_LoadOrderListForOrderCreation.sql` |
| `sp_LoadOrderListForOrderCreationbyTerri` | @manufacId int, @comunitId int, @TerritoryId int | S |  |  |  |  | tblCustPayDetail, tblCustomerType, tblInvoice, tblInvoiceDetail, tblInvoiceDetailReturn, tblInvoiceNotBinding (+2 more) | `spec/database/procs/sp_LoadOrderListForOrderCreationbyTerri.sql` |
| `sp_LoadOrderListForOrderRouteDayWise` | @comunitId int, @routeId int, @RouteDate date | S |  |  |  |  | tblCustPayDetail, tblCustomerType, tblInvoice, tblInvoiceDetail, tblInvoiceDetailReturn, tblInvoiceNotBinding (+2 more) | `spec/database/procs/sp_LoadOrderListForOrderRouteDayWise.sql` |
| `sp_LoadSalesReturnReportSAP` | @fromdate datetime, @todate datetime | S |  |  |  |  | SAP_API_Data, tblCompanyUnit | `spec/database/procs/sp_LoadSalesReturnReportSAP.sql` |
| `sp_MioUpdateInCustomerInfo` | @ter NVARCHAR, @mio NVARCHAR, @name NVARCHAR | SU |  |  |  |  | tblCustMaster | `spec/database/procs/sp_MioUpdateInCustomerInfo.sql` |
| `sp_MiowiseMISReport` | @unitid INT, @fromdate datetime, @todate datetime | S |  |  |  |  | tblInvoice, tblInvoiceDetail, tblMIAInfo, tblSubInvoiceDetail, tblSubInvoiceMaster | `spec/database/procs/sp_MiowiseMISReport.sql` |
| `sp_NumberofInvoiceandCust` | @fromdate datetime, @todate datetime | S |  |  |  |  | tblInvoice, tblOrder, tbl_DCRInfo, tbl_PrescriptionMaster | `spec/database/procs/sp_NumberofInvoiceandCust.sql` |
| `sp_OrderGenerationFromUploadOrder` | @OrderMasterID_In INT, @IsApiData BIT | SIUD |  |  |  |  | SalesDisDB_SMC, SystemTest, View_CustomerMaster, tblCompanyUnit, tblCustMaster, tblOrder (+4 more) | `spec/database/procs/sp_OrderGenerationFromUploadOrder.sql` |
| `sp_OrderGenerationFromUploadOrder_SingleOrder` | @OrderMasterID_In INT, @OrderCode NVARCHAR, @IsApiData BIT | SIUD |  |  |  |  | SalesDisDB_SMC, SystemTest, tblCompanyUnit, tblCustMaster, tblOrder, tblOrderDetail (+3 more) | `spec/database/procs/sp_OrderGenerationFromUploadOrder_SingleOrder.sql` |
| `sp_OrderMonitoringPanel_Bizmotion` | @fromdate datetime, @todate datetime | S |  |  |  |  | tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDel, tblOrderDetail (+1 more) | `spec/database/procs/sp_OrderMonitoringPanel_Bizmotion.sql` |
| `sp_PaymentConformationFull` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @UpdateDate DATETIME | SU |  |  |  | Y | MY_data, tblInvoice, tblInvoiceDetail | `spec/database/procs/sp_PaymentConformationFull.sql` |
| `sp_Pro_DZSMwiseReportParam` | (none) | SIUD |  |  |  |  | SalesDisDB_SMC_NEWDB, SalesDisDB_SMC_TrSalesRepor, tblDZSMProcessDate, tblOrder, tbl_DCRInfo, tbl_PrescriptionMaster | `spec/database/procs/sp_Pro_DZSMwiseReportParam.sql` |
| `sp_Process_DWSPReport` | @Month nvarchar, @MonthValue int, @Year nvarchar, @ApprovalStatus nvarchar (+3 more) | SI |  |  |  |  | tblArea, tblDesignation, tblEmpGeneralInfo, tblMIOInfo, tblRegion, tblTerritory (+5 more) | `spec/database/procs/sp_Process_DWSPReport.sql` |
| `sp_Process_ProformaInvoiceByOrderId` | @OrderId INT, @UserId INT, @DANameId INT, @BatchNo1 NVARCHAR (+2 more) | SIU | Y | Y |  |  | tblCompanyUnit, tblCustomerType, tblDCStore, tblDCStoreTransaction, tblInvoice, tblInvoiceBatch (+8 more) | `spec/database/procs/sp_Process_ProformaInvoiceByOrderId.sql` |
| `sp_Process_SubDepoProformaInvoiceByOrderId` | @OrderId INT, @UserId INT, @BatchNo1 NVARCHAR | SIU |  |  |  |  | tblCompanyUnit, tblCustomerType, tblMarket, tblOrder, tblOrderDetail, tblProduct (+8 more) | `spec/database/procs/sp_Process_SubDepoProformaInvoiceByOrderId.sql` |
| `sp_ProductWiseBranchwiseBusinessSummaryMISReport` | @Branch nvarchar, @fromdate datetime, @todate datetime | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomerType, tblCustomertype (+18 more) | `spec/database/procs/sp_ProductWiseBranchwiseBusinessSummaryMISReport.sql` |
| `sp_ProductWiseBusinessSummaryMISReport` | @fromdate datetime, @todate datetime | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomerType, tblCustomertype (+18 more) | `spec/database/procs/sp_ProductWiseBusinessSummaryMISReport.sql` |
| `sp_ProductWiseBusinessSummaryMISReportByParam` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomerType, tblCustomertype (+18 more) | `spec/database/procs/sp_ProductWiseBusinessSummaryMISReportByParam.sql` |
| `sp_RejectInvoiceDAPaymentCollection` | @InvoiceId INT, @PaymentCollectionAppLogId INT | D |  |  |  |  | tblPaymentCollection_appLog | `spec/database/procs/sp_RejectInvoiceDAPaymentCollection.sql` |
| `sp_RejectInvoiceDASalesConfirmStatus` | @InvoiceId INT | UD |  |  |  |  | tblInvoice, tblSalesConfirmation_appLog, tblSalesConfirmation_appLogDetail | `spec/database/procs/sp_RejectInvoiceDASalesConfirmStatus.sql` |
| `sp_RejectInvoiceDASalesReturn` | @InvoiceId INT, @SalesReturnAppLogId INT | SUD |  |  |  |  | tblInvoice, tblSalesReturn_appLog, tblSalesReturn_appLogDetail | `spec/database/procs/sp_RejectInvoiceDASalesReturn.sql` |
| `sp_Rep_DepopsitSlip_BusinessSummary` | @fromdate datetime, @todate datetime, @ComUnitId varchar | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCompanyWiseDeposit, tblCustMaster, tblCustPayDetail (+25 more) | `spec/database/procs/sp_Rep_DepopsitSlip_BusinessSummary.sql` |
| `sp_Rep_DepopsitSlip_BusinessSummaryClosingReport` | @fromdate datetime, @todate datetime, @ComUnitId varchar | SID | Y | Y |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCompanyWiseDeposit, tblCustMaster, tblCustPayDetail (+25 more) | `spec/database/procs/sp_Rep_DepopsitSlip_BusinessSummaryClosingReport.sql` |
| `sp_RPT_BusinessSummaryMISReport` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+17 more) | `spec/database/procs/sp_RPT_BusinessSummaryMISReport.sql` |
| `sp_Rpt_BusinessSummaryProductwise` | @fromdate datetime, @todate datetime | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+16 more) | `spec/database/procs/sp_Rpt_BusinessSummaryProductwise.sql` |
| `sp_RPT_MIOWiseBusinessSummary` | @fromdate datetime, @todate datetime, @Depid nvarchar | S |  |  |  |  | tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo, tblInvoice (+14 more) | `spec/database/procs/sp_RPT_MIOWiseBusinessSummary.sql` |
| `sp_RPT_MIS_BusinessSummary` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType (+17 more) | `spec/database/procs/sp_RPT_MIS_BusinessSummary.sql` |
| `sp_RPT_MIS_BusinessSummary_Acc` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType (+13 more) | `spec/database/procs/sp_RPT_MIS_BusinessSummary_Acc.sql` |
| `sp_RPT_MIS_ProductWiseSalesReport` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType, tblDCStore (+7 more) | `spec/database/procs/sp_RPT_MIS_ProductWiseSalesReport.sql` |
| `sp_RPT_MIS_RptMIOWiseReceiveableReport` | @fromdate datetime, @todate datetime, @Type nvarchar, @Area nvarchar (+2 more) | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomerType (+14 more) | `spec/database/procs/sp_RPT_MIS_RptMIOWiseReceiveableReport.sql` |
| `sp_RPTMonitoringReport` | @fromdate datetime, @todate datetime, @Type nvarchar | S |  |  |  |  | SalesDisDB_SMC, tblArea, tblCompanyUnit, tblCustMaster, tblCustomertype, tblEmpGeneralInfo (+17 more) | `spec/database/procs/sp_RPTMonitoringReport.sql` |
| `sp_SAP_BankDepositPosting` | @frmDate nvarchar, @toDate nvarchar | S |  |  |  |  | SAP_API_Data | `spec/database/procs/sp_SAP_BankDepositPosting.sql` |
| `sp_StockInMIGOtoCentralStore` | @MigoMasterID_In INT | SIU |  |  |  |  | tblCentralStore, tblMIGODetail, tblMIGOMaster, tblProduct | `spec/database/procs/sp_StockInMIGOtoCentralStore.sql` |
| `sp_SubdeportAreawiseDailyOpeningClosingStockNational` | @fromDate datetime, @toDate DATETIME | S |  |  |  |  | tblCompanyUnit, tblProduct, tblSubDCStore_OpeningBalance, tblSubDepotChalanDetail, tblSubDepotChalanInfo, tblSubDepotChalanRetuenDetail (+5 more) | `spec/database/procs/sp_SubdeportAreawiseDailyOpeningClosingStockNational.sql` |
| `sp_SubdeportDeliveryConformationFull` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @UpdateDate DATETIME | SU |  |  |  | Y | MY_data, tblSubInvoiceDetail, tblSubInvoiceMaster | `spec/database/procs/sp_SubdeportDeliveryConformationFull.sql` |
| `sp_SubDeportDeliveryConformationReject` | @InvoiceNo NVARCHAR, @UpdateBy NVARCHAR, @ReturnReason NVARCHAR, @UpdateDate DATETIME | SIU |  |  |  | Y | MY_data, tblSubDepotStore, tblSubDepotStoreFreeze, tblSubInvoiceDetail, tblSubInvoiceMaster | `spec/database/procs/sp_SubDeportDeliveryConformationReject.sql` |
| `sp_UD_ApiCustomerMaster` | @ApiCustomerId INT, @CustomerName NVARCHAR, @Address NVARCHAR, @CellNo NVARCHAR (+16 more) | U |  |  |  |  | tbltempCustMaster | `spec/database/procs/sp_UD_ApiCustomerMaster.sql` |
| `sp_UD_DcStockOutApproval` | @DcStockOutMasterId INT, @Status NVARCHAR, @ApprovedBy NVARCHAR, @ApprovedDate DateTime | SU |  |  |  |  | tblDCStore, tblDeStockOutDetails, tblDeStockOutMaster | `spec/database/procs/sp_UD_DcStockOutApproval.sql` |
| `sp_UD_FixedCustomer` | @code NVARCHAR | SU |  |  |  |  | FixedC, tblCustMaster | `spec/database/procs/sp_UD_FixedCustomer.sql` |
| `sp_UD_RegularCustomer` | @code NVARCHAR | SU |  |  |  |  | FixedC, tblCustMaster | `spec/database/procs/sp_UD_RegularCustomer.sql` |
| `sp_UD_StockBatch_new` | @dcStoreId INT, @batch NVARCHAR, @mfgdate datetime, @expDate datetime (+2 more) | SIU |  |  |  |  | tblDCStore, tblStockBatchUpdateTracking | `spec/database/procs/sp_UD_StockBatch_new.sql` |
| `sp_UP_LoadingSummary` | @InvoiceId NVARCHAR, @UpdateBy NVARCHAR, @LoadingSummaryStatus NVARCHAR | SIU |  |  |  |  | sp_Delete_ProformaInvoice, sp_DeliveryConformationFull, sp_PaymentConformationFull, tblInvoice, tblInvoiceDetail, tblOrder (+3 more) | `spec/database/procs/sp_UP_LoadingSummary.sql` |
| `sp_UP_LoadingSummaryFinal` | @InvoiceId NVARCHAR, @UpdateBy NVARCHAR, @LoadingSummaryStatus NVARCHAR | U |  |  |  |  | tblInvoice | `spec/database/procs/sp_UP_LoadingSummaryFinal.sql` |
| `sp_Update_InvoiceFinalPayment` | @InvoiceId INT, @PaymentAmount DECIMAL, @ptStatus NVARCHAR, @FinalPaymentBy NVARCHAR (+1 more) | SU |  |  |  |  | tblCustPayDetail, tblInvoice, tblPaymentCollection_appLog | `spec/database/procs/sp_Update_InvoiceFinalPayment.sql` |
| `sp_UpdateAndInsertInvoiceDetailSalesReturn` | @InvoiceDetailReturnId INT OUT, @InvoiceId INT, @InvoiceDetailId INT, @Quantity INT (+10 more) | SI |  |  |  |  | tblInvoiceDetailReturn | `spec/database/procs/sp_UpdateAndInsertInvoiceDetailSalesReturn.sql` |
| `sp_UpdateBacktoReturnPage` | @OrdID INT, @LoginName NVARCHAR | SU |  |  |  |  | tblInvoice | `spec/database/procs/sp_UpdateBacktoReturnPage.sql` |
| `sp_UpdateDICApprovalStatus` | @SalesConfirmationAppLogId VARCHAR, @DICApprovalStatus VARCHAR, @DICApproveDate DATETIME, @DICApproveBy VARCHAR | U |  |  |  |  | tblSalesConfirmation_appLog | `spec/database/procs/sp_UpdateDICApprovalStatus.sql` |
| `sp_UpdateDICApprovalStatus_SalesReturn` | @SalesReturnAppLogId VARCHAR, @DICApprovalStatus VARCHAR, @DICApproveDate DATETIME, @DICApproveBy VARCHAR | U |  |  |  |  | tblSalesReturn_appLog | `spec/database/procs/sp_UpdateDICApprovalStatus_SalesReturn.sql` |
| `sp_VerifyCustomer` | @MasterID INT | SU |  |  |  |  | tblArea, tblCompanyUnit, tblCustMaster, tblCustomerMasterExcelFileDetail, tblCustomerMasterExcelFileMaster, tblDistrict (+3 more) | `spec/database/procs/sp_VerifyCustomer.sql` |
| `sp_VerifyCustomerTagList` | @MasterID INT | SU |  |  |  |  | tblArea, tblCompanyUnit, tblCustMaster, tblCustomerMasterTagChangeExcelFileDetail, tblCustomerMasterTagChangeExcelFileMaster, tblDistrict (+3 more) | `spec/database/procs/sp_VerifyCustomerTagList.sql` |
| `sp_WHBeenCard` | @fromDate datetime, @toDate DATETIME | S |  |  |  |  | tblCentralStore, tblCentralStore_OpeninigBalance, tblInvoice, tblInvoiceDetail, tblProduct, tblRequisition (+10 more) | `spec/database/procs/sp_WHBeenCard.sql` |
| `UD_CustomerMaster` | @CustomerMasterId INT, @CustomerCode NVARCHAR, @CategoryId INT, @CustomerName NVARCHAR (+22 more) | SIU |  |  |  |  | tblCompanyUnit, tblCustMaster, tblOrder, tblPreviousCustInfo | `spec/database/procs/UD_CustomerMaster.sql` |
| `UD_CustomerMaster2` | @CustomerMasterId INT, @CustomerCode NVARCHAR, @CategoryId INT, @CustomerName NVARCHAR (+18 more) | SIU |  |  |  |  | tblCompanyUnit, tblCustMaster, tblOrder, tblPreviousCustInfo | `spec/database/procs/UD_CustomerMaster2.sql` |
| `usp_InsertTerritoryData` | @SL INT OUT, @TerritoryCode nvarchar, @Value nvarchar, @MonthName varchar (+3 more) | SI |  |  |  |  | tblArea, tblEmpGeneralInfo, tblFinancialYear, tblMIOInfo, tblRegion, tblTerritory (+1 more) | `spec/database/procs/usp_InsertTerritoryData.sql` |

### ChartDAL (43 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Get_AttandenceMonthlyDashboard_new` | @Month nvarchar, @Year nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tblMarketAttendance_Master_webapi | `spec/database/procs/sp_Get_AttandenceMonthlyDashboard_new.sql` |
| `sp_Get_BrandWiseOrderDashboard` | @FrmDate nvarchar, @ToDate nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblProductSQ | `spec/database/procs/sp_Get_BrandWiseOrderDashboard.sql` |
| `sp_Get_BrandWiseOrderDashboard_new` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sp_executesql, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblProductSQ | `spec/database/procs/sp_Get_BrandWiseOrderDashboard_new.sql` |
| `sp_Get_BrandWiseOrderPaymentDashboard` | @FrmDate nvarchar, @ToDate nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblProductSQ | `spec/database/procs/sp_Get_BrandWiseOrderPaymentDashboard.sql` |
| `sp_Get_CustomerCoverageRecordMonthlyDashboard_New` | @Month INT, @Year INT, @param nvarchar | S |  |  | Y |  | sys, tblInvoice, tblOrder, tblRegion | `spec/database/procs/sp_Get_CustomerCoverageRecordMonthlyDashboard_New.sql` |
| `sp_Get_CustomerCoverageRecordPaymentDashboard_New` | @Month INT, @Year INT, @param nvarchar | S |  |  | Y |  | sys, tblInvoice, tblOrder, tblRegion | `spec/database/procs/sp_Get_CustomerCoverageRecordPaymentDashboard_New.sql` |
| `sp_Get_DAMonthlyDashboard_DayWise` | @Month nvarchar, @Year nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tbl_TadaClaimMaster | `spec/database/procs/sp_Get_DAMonthlyDashboard_DayWise.sql` |
| `sp_Get_DashboardDeptoWiseInvoice` | (none) | S |  |  |  |  | tblInvoice, tblInvoiceDetail, tblOrder, tblRegion | `spec/database/procs/sp_Get_DashboardDeptoWiseInvoice.sql` |
| `sp_Get_DashboardDeptoWiseOrder` | (none) | S |  |  |  |  | tblOrder, tblRegion | `spec/database/procs/sp_Get_DashboardDeptoWiseOrder.sql` |
| `sp_Get_DashboardInvoice_DeptoWise` | (none) | S |  |  |  |  | tblCompanyUnit, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/procs/sp_Get_DashboardInvoice_DeptoWise.sql` |
| `sp_Get_DashboardOrder_DeptoWise` | (none) | S |  |  |  |  | tblCompanyUnit, tblOrder | `spec/database/procs/sp_Get_DashboardOrder_DeptoWise.sql` |
| `sp_Get_DashboardTopBarChartCustomerCoverage` | (none) | S |  |  |  |  | C, N, T, tblOrder | `spec/database/procs/sp_Get_DashboardTopBarChartCustomerCoverage.sql` |
| `sp_Get_DashboardTopBarChartDeliveryAmount` | (none) | S |  |  |  |  | C, N, T, tblCustPayDetail | `spec/database/procs/sp_Get_DashboardTopBarChartDeliveryAmount.sql` |
| `sp_Get_DashboardTopBarChartOrder` | (none) | S |  |  |  |  | tblOrder | `spec/database/procs/sp_Get_DashboardTopBarChartOrder.sql` |
| `sp_Get_DashboardTopBarChartOrderCount` | (none) | S |  |  |  |  | C, T, tblOrder | `spec/database/procs/sp_Get_DashboardTopBarChartOrderCount.sql` |
| `sp_Get_DashboardTopBarChartRejectionAmount` | (none) | S |  |  |  |  | N, P, R, T, tblInvoice, tblInvoiceDetail (+3 more) | `spec/database/procs/sp_Get_DashboardTopBarChartRejectionAmount.sql` |
| `sp_Get_DashboardTopBarChartTotalAttandence` | (none) | S |  |  |  |  | C, N, T, tblMarketAttendance_Master_webapi | `spec/database/procs/sp_Get_DashboardTopBarChartTotalAttandence.sql` |
| `sp_Get_DashboardTopBarChartTotalDCR` | (none) | S |  |  |  |  | C, N, T, tblDoctorMaster, tbl_DCRInfo | `spec/database/procs/sp_Get_DashboardTopBarChartTotalDCR.sql` |
| `sp_Get_DashboardTopBarChartTotalInvoiceAmount` | (none) | S |  |  |  |  | C, N, T, tblInvoice, tblInvoiceDetail | `spec/database/procs/sp_Get_DashboardTopBarChartTotalInvoiceAmount.sql` |
| `sp_Get_DashboardTopBarChartTotalLeave` | (none) | S |  |  |  |  | C, Employee_LeaveApplications, N, T | `spec/database/procs/sp_Get_DashboardTopBarChartTotalLeave.sql` |
| `sp_Get_DashboardTopBarChartTotalRX` | (none) | S |  |  |  |  | C, N, T, tbl_PrescriptionMaster | `spec/database/procs/sp_Get_DashboardTopBarChartTotalRX.sql` |
| `sp_Get_DashboardTopBarData` | (none) | S |  |  |  |  | Employee_LeaveApplications, tblCustPayDetail, tblDoctorMaster, tblInvoice, tblInvoiceDetail, tblMarketAttendance_Master_webapi (+6 more) | `spec/database/procs/sp_Get_DashboardTopBarData.sql` |
| `sp_Get_DashboardTopBarData_NSM` | @GroupId nvarchar | S |  |  |  |  | tblCustPayDetail, tblInvoice, tblOrder, tblRejectionInvoiceDetail, tblRejectionInvoiceMaster | `spec/database/procs/sp_Get_DashboardTopBarData_NSM.sql` |
| `sp_Get_DashboardTopBarData_Zone` | @ZoneId nvarchar | S |  |  |  |  | tblCustPayDetail, tblInvoice, tblOrder, tblRejectionInvoiceDetail, tblRejectionInvoiceMaster | `spec/database/procs/sp_Get_DashboardTopBarData_Zone.sql` |
| `sp_Get_DoctorGMPRecordMonthlyDashboard_New` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblDoctorMaster, tblDoctorType, tbl_DCRInfo | `spec/database/procs/sp_Get_DoctorGMPRecordMonthlyDashboard_New.sql` |
| `sp_Get_DoctorGMPRecordMonthlyDashboardDayWise` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblDoctorMaster, tbl_DCRInfo | `spec/database/procs/sp_Get_DoctorGMPRecordMonthlyDashboardDayWise.sql` |
| `sp_Get_DoctorGMPRecordMonthlyDashboardZoneWise` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblDoctorMaster, tblRegion, tbl_DCRInfo | `spec/database/procs/sp_Get_DoctorGMPRecordMonthlyDashboardZoneWise.sql` |
| `sp_Get_DoctorGMPxRecordMonthlyDashboard_new` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblDoctorMaster, tblDoctorType, tbl_PrescriptionMaster | `spec/database/procs/sp_Get_DoctorGMPxRecordMonthlyDashboard_new.sql` |
| `sp_Get_DoctorGMPxRecordMonthlyDashboardDayWise` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblDoctorMaster, tbl_PrescriptionMaster | `spec/database/procs/sp_Get_DoctorGMPxRecordMonthlyDashboardDayWise.sql` |
| `sp_Get_DoctorGMPxRecordMonthlyDashboardZoneWise` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sys, tblDoctorMaster, tblRegion, tbl_PrescriptionMaster | `spec/database/procs/sp_Get_DoctorGMPxRecordMonthlyDashboardZoneWise.sql` |
| `sp_Get_DoctorNGMPRecordMonthlyDashboard` | @Month INT, @Year INT | S |  |  |  |  | tblCompanyUnit, tblDcWiseTerritoryDetail, tblDcWiseTerritoryMaster, tblDoctorMaster, tbl_DCRInfo | `spec/database/procs/sp_Get_DoctorNGMPRecordMonthlyDashboard.sql` |
| `sp_Get_DoctorNGMPxRecordMonthlyDashboard` | @Month INT, @Year INT | S |  |  |  |  | tblCompanyUnit, tblDcWiseTerritoryDetail, tblDcWiseTerritoryMaster, tblDoctorMaster, tbl_PrescriptionMaster | `spec/database/procs/sp_Get_DoctorNGMPxRecordMonthlyDashboard.sql` |
| `sp_Get_ExpanseClaimMonthlyDashboard` | @Month nvarchar, @Year nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tbl_ExpenseClaim, tbl_ExpenseTypeMaster | `spec/database/procs/sp_Get_ExpanseClaimMonthlyDashboard.sql` |
| `sp_Get_ExpanseClaimMonthlyDashboard_DayWise` | @Month nvarchar, @Year nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tbl_ExpenseClaim | `spec/database/procs/sp_Get_ExpanseClaimMonthlyDashboard_DayWise.sql` |
| `sp_Get_OrderRecordMonthly` | @Month INT, @Year INT | S |  |  |  |  | tblInvoice, tblInvoiceDetail | `spec/database/procs/sp_Get_OrderRecordMonthly.sql` |
| `sp_Get_OrderRecordMonthlyDashboard_Depo` | @Month INT, @Year INT, @param nvarchar | S |  |  | Y |  | sys, tblCompanyUnit, tblOrder | `spec/database/procs/sp_Get_OrderRecordMonthlyDashboard_Depo.sql` |
| `sp_Get_OrderRecordMonthlyDashboard_New` | @Month INT, @Year INT, @param nvarchar | S |  |  | Y |  | sys, tblOrder, tblRegion | `spec/database/procs/sp_Get_OrderRecordMonthlyDashboard_New.sql` |
| `sp_Get_PaymentBrandWiseOrderDashboard` | @param nvarchar, @FrmDate nvarchar, @ToDate nvarchar | S |  |  | Y |  | sp_executesql, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblProductSQ | `spec/database/procs/sp_Get_PaymentBrandWiseOrderDashboard.sql` |
| `sp_Get_ProductWiseOrderDashboard` | @FrmDate nvarchar, @ToDate nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblProductSQ | `spec/database/procs/sp_Get_ProductWiseOrderDashboard.sql` |
| `sp_Get_ProductWiseOrderPaymentDashboard` | @FrmDate nvarchar, @ToDate nvarchar, @param nvarchar | S |  |  | Y |  | sp_executesql, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblProductSQ | `spec/database/procs/sp_Get_ProductWiseOrderPaymentDashboard.sql` |
| `sp_Get_SalesRecordMonthlyDayWsie_New` | @Month INT, @Year INT, @param nvarchar, @CustomerTypeId INT | S |  |  | Y |  | sys, tblInvoice, tblInvoiceDetail, tblOrder, tblRegion | `spec/database/procs/sp_Get_SalesRecordMonthlyDayWsie_New.sql` |
| `sp_Get_SalesRecordMonthlyDayWsiePayment` | @Month INT, @Year INT, @CustomerTypeId INT, @param nvarchar | S |  |  | Y |  | sys, tblInvoice, tblInvoiceDetail, tblOrder, tblRegion | `spec/database/procs/sp_Get_SalesRecordMonthlyDayWsiePayment.sql` |
| `sp_Get_SalesReturnRecordMonthly_New` | @Month INT, @Year INT, @param nvarchar | S |  |  | Y |  | sys, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail, tblSubInvoiceDetail (+2 more) | `spec/database/procs/sp_Get_SalesReturnRecordMonthly_New.sql` |

### DWSP_DAL (26 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Get_AreaAll_ByEmpID` | @id NVARCHAR, @EmpId NVARCHAR | S |  |  |  |  | tblASMInfo, tblArea | `spec/database/procs/sp_Get_AreaAll_ByEmpID.sql` |
| `sp_Get_AreaAll_ByZoneId` | @id NVARCHAR | S |  |  |  |  | tblArea | `spec/database/procs/sp_Get_AreaAll_ByZoneId.sql` |
| `sp_Get_AreaTargetAmount` | @RegionId INT, @month nvarchar, @Year INT | S |  |  |  |  | tblAreaWiseTargetSetup | `spec/database/procs/sp_Get_AreaTargetAmount.sql` |
| `sp_Get_AreaWiseTargetList` | @Parameter nvarchar | S |  |  | Y |  | tblArea, tblAreaWiseTargetSetup, tblRegion, tbl_Group | `spec/database/procs/sp_Get_AreaWiseTargetList.sql` |
| `sp_Get_DZSMinfoByEmpId` | @EmpId INT | S |  |  |  |  | tblRSMInfo, tblRegion | `spec/database/procs/sp_Get_DZSMinfoByEmpId.sql` |
| `sp_Get_FirstDate_LastDatebyYearMonth` | @StartDate DATETIME, @EndDate DATETIME | S |  |  |  |  | master | `spec/database/procs/sp_Get_FirstDate_LastDatebyYearMonth.sql` |
| `sp_Get_Group_List` | @Parameter NVARCHAR | S |  |  | Y |  | tblNationalTargetSetup, tbl_Group | `spec/database/procs/sp_Get_Group_List.sql` |
| `sp_Get_NationalTargetAmount` | @GroupId INT, @month nvarchar, @Year INT | S |  |  |  |  | tblNationalTargetSetup | `spec/database/procs/sp_Get_NationalTargetAmount.sql` |
| `sp_Get_RoleTypeByEmpId` | @EmpId INT | S |  |  |  |  | tblUser, tbl_UserRoleInfo | `spec/database/procs/sp_Get_RoleTypeByEmpId.sql` |
| `sp_Get_TerritoryAll_ByAreaId` | @id NVARCHAR | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_Get_TerritoryAll_ByAreaId.sql` |
| `sp_Get_TerritoryAll_ByAreaIdIsNotVaccant` | @id NVARCHAR | S |  |  |  |  | tblMIOInfo, tblTerritory | `spec/database/procs/sp_Get_TerritoryAll_ByAreaIdIsNotVaccant.sql` |
| `sp_Get_TerritoryAll_ByAreaIdIsVaccant` | @id NVARCHAR | S |  |  |  |  | tblMIOInfo, tblTerritory | `spec/database/procs/sp_Get_TerritoryAll_ByAreaIdIsVaccant.sql` |
| `sp_Get_TerritoryWiseTargetList` | @Parameter nvarchar | S |  |  | Y |  | tblTerritory, tblTerritoryWiseTargetSetup | `spec/database/procs/sp_Get_TerritoryWiseTargetList.sql` |
| `sp_Get_TerritoryWiseTargetSetup` | @RegionId INT, @month nvarchar, @Year INT | S |  |  |  |  | tblTerritoryWiseTargetSetup | `spec/database/procs/sp_Get_TerritoryWiseTargetSetup.sql` |
| `sp_Get_Zone_All_Active_ByGroup` | @GroupId INT | S |  |  |  |  | tblRegion | `spec/database/procs/sp_Get_Zone_All_Active_ByGroup.sql` |
| `sp_Get_Zone_All_Active_ZoneTarget` | @GroupId INT | S |  |  |  |  | tblRegion | `spec/database/procs/sp_Get_Zone_All_Active_ZoneTarget.sql` |
| `sp_Get_ZoneinfoByEmpId` | @EmpId INT | S |  |  |  |  | tblASMInfo, tblArea, tblRegion | `spec/database/procs/sp_Get_ZoneinfoByEmpId.sql` |
| `sp_Get_ZoneTargetAmount` | @RegionId INT, @month nvarchar, @Year INT | S |  |  |  |  | tblZoneWiseTargetSetup | `spec/database/procs/sp_Get_ZoneTargetAmount.sql` |
| `sp_Get_ZoneWiseTargetList` | @Parameter nvarchar | S |  |  | Y |  | tblRegion, tblZoneWiseTargetSetup, tbl_Group | `spec/database/procs/sp_Get_ZoneWiseTargetList.sql` |
| `sp_GetDatewithinDateRange` | @fDate DATETIME, @tDate DATETIME | S |  |  |  |  | dates | `spec/database/procs/sp_GetDatewithinDateRange.sql` |
| `sp_NTS_Group_Active` | (none) | S |  |  |  |  | tbl_Group | `spec/database/procs/sp_NTS_Group_Active.sql` |
| `sp_Save_AreaWiseTargetSetup` | @AreaWTSetupId INT, @Year INT, @Month nvarchar, @GroupId INT (+5 more) | SIU |  |  |  |  | tblAreaWiseTargetSetup | `spec/database/procs/sp_Save_AreaWiseTargetSetup.sql` |
| `sp_Save_DWSPMaster` | @DWSPDate DATETIME, @FCBAmount decimal, @CampaignAmount decimal, @GeneralAmount decimal (+2 more) | SID |  |  |  |  | tbl_DWSPDetail, tbl_DWSPMaster | `spec/database/procs/sp_Save_DWSPMaster.sql` |
| `sp_Save_NationaltargetSetup` | @NatargetSpId INT, @Year NVARCHAR, @Month NVARCHAR, @GroupId INT (+2 more) | SI |  |  |  |  | tblNationalTargetSetup | `spec/database/procs/sp_Save_NationaltargetSetup.sql` |
| `sp_Save_TerritoryWiseTargetSetup` | @TerritoryWTSetupId INT, @Year INT, @Month nvarchar, @GroupId INT (+6 more) | SIU |  |  |  |  | tblTerritoryWiseTargetSetup | `spec/database/procs/sp_Save_TerritoryWiseTargetSetup.sql` |
| `sp_Save_ZoneWiseTargetSetup` | @ZoneWTSetupId INT, @Year INT, @Month nvarchar, @GroupId INT (+4 more) | SIU |  |  |  |  | tblZoneWiseTargetSetup | `spec/database/procs/sp_Save_ZoneWiseTargetSetup.sql` |

### SAP_IntegrationDAL (22 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `MakeRESTRequest` | @StoNo varchar, @RcvBy int | U |  |  |  |  | SAP_API_Data, sp_OACreate, sp_OADestroy, sp_OAMethod | `spec/database/procs/MakeRESTRequest.sql` |
| `sp_Chk_SAP_EmpInfoCondition` | @femployee_id nvarchar, @employee_code nvarchar, @RoleType nvarchar, @ActionStatus nvarchar | SU |  |  |  |  | SAP_API_Data, tblASMInfo, tblArea, tblMIOInfo, tblRSMInfo, tblRegion (+1 more) | `spec/database/procs/sp_Chk_SAP_EmpInfoCondition.sql` |
| `sp_GET_BAnkInfoById_ByIdExcel` | @BankAccNo NVARCHAR, @ComUnitId NVARCHAR | S |  |  |  |  | tblBankInfoNew | `spec/database/procs/sp_GET_BAnkInfoById_ByIdExcel.sql` |
| `sp_Get_BankSAPMappingAccounTNo` | @BankAccNo nvarchar | S |  |  |  |  | tblBankSAPMapping | `spec/database/procs/sp_Get_BankSAPMappingAccounTNo.sql` |
| `sp_Get_Chk_EmpCode` | @EmpCode nvarchar | S |  |  |  |  | tblEmpGeneralInfo, tblMIOInfo, tblTerritory | `spec/database/procs/sp_Get_Chk_EmpCode.sql` |
| `sp_Get_Chk_EMPDataExistCheck` | @EmpCode nvarchar, @MonthValue nvarchar, @YearValue nvarchar | S |  |  |  |  | tblTerritoryDataMigration | `spec/database/procs/sp_Get_Chk_EMPDataExistCheck.sql` |
| `sp_Get_Chk_TerritoryCode` | @TerritoryCode nvarchar | S |  |  |  |  | tblTerritory | `spec/database/procs/sp_Get_Chk_TerritoryCode.sql` |
| `sp_Get_DepositCodeByDIC` | @Parm INT | S |  |  |  |  | tblCompanyUnit, tblCompanyWiseDeposit | `spec/database/procs/sp_Get_DepositCodeByDIC.sql` |
| `sp_Get_ProviderDropoutIntrigrationList` | (none) | S |  |  |  |  | tblProviderDropoutIntrigration | `spec/database/procs/sp_Get_ProviderDropoutIntrigrationList.sql` |
| `sp_Get_SAP_DICStockReceivePendingData` | @Parm int | S |  |  |  |  | SAP_API_Data, WH, tblCompanyUnit, tblProduct | `spec/database/procs/sp_Get_SAP_DICStockReceivePendingData.sql` |
| `sp_Get_SAP_EmpInfo` | @Parm nvarchar, @Parm2 nvarchar | S |  |  |  |  | SAP_API_Data, tblArea, tblRegion, tblRoleType, tblTerritory | `spec/database/procs/sp_Get_SAP_EmpInfo.sql` |
| `sp_Get_SAP_EmpSApCodebyTerritory` | @TerritoryCode nvarchar | S |  |  |  |  | tblEmpGeneralInfo, tblMIOInfo, tblTerritory | `spec/database/procs/sp_Get_SAP_EmpSApCodebyTerritory.sql` |
| `sp_Get_SAP_HideChallanByChallanNo` | @ChallanNo nvarchar | S |  |  |  |  | SAP_API_Data, tblChalanInfo, tblRequisition, tblStockInTransfar | `spec/database/procs/sp_Get_SAP_HideChallanByChallanNo.sql` |
| `sp_Get_SAP_IntrigationPointHeader` | @Parm nvarchar, @Parm2 nvarchar | S |  |  |  |  |  | `spec/database/procs/sp_Get_SAP_IntrigationPointHeader.sql` |
| `sp_Get_SAP_ProductInfo` | @Parm nvarchar, @Parm2 nvarchar | S |  |  |  |  | SAP_API_Data, tblPackSize, tblProCategory, tblProductGroup, tblStockUOM | `spec/database/procs/sp_Get_SAP_ProductInfo.sql` |
| `sp_Get_SAP_StockReceivePendingData` | @Parm nvarchar | S |  |  |  |  | SAP_API_Data, WH, tblCompanyUnit, tblProduct | `spec/database/procs/sp_Get_SAP_StockReceivePendingData.sql` |
| `sp_Get_SAP_StockReceivePendingDataById` | @StockMovementMasterId INT | S |  |  |  |  | SAP_API_Data, WH, tblCompanyUnit, tblConvQty, tblDCStore, tblProduct (+1 more) | `spec/database/procs/sp_Get_SAP_StockReceivePendingDataById.sql` |
| `sp_SAP_StockReceive` | @ChallanNo NVARCHAR, @ApproveBy INT | S |  |  |  |  | SAP_API_Data, sp_SAP_B2BChallanDetailInsert, sp_SAP_RequisitionDetailUpdate, sp_SAP_RequisitionMasterUpdate, sp_SAP_STODetails, sp_SAP_StockInTransfer (+2 more) | `spec/database/procs/sp_SAP_StockReceive.sql` |
| `sp_SAP_Up_StockReceiveQty` | @StockMovementDetailId int, @quantity INT | U |  |  |  |  | SAP_API_Data | `spec/database/procs/sp_SAP_Up_StockReceiveQty.sql` |
| `sp_Up_ProviderDropoutIntrigrationApprove` | @providerIDropoutIntrigrationd BIGINT, @ApproveBy NVARCHAR | SU |  |  |  |  | tblCustMaster, tblProviderDropoutIntrigration | `spec/database/procs/sp_Up_ProviderDropoutIntrigrationApprove.sql` |
| `sp_Upsertdate_EmpInfo` | @employee_id INT, @employee_code nvarchar, @RoleType nvarchar, @UpdateBy int (+1 more) | SIU |  |  |  |  | SAP_API_Data, tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblRSMInfo (+3 more) | `spec/database/procs/sp_Upsertdate_EmpInfo.sql` |
| `sp_Upsertdate_ProductInfo` | @product_id nvarchar, @product_code nvarchar, @status nvarchar, @UpdateBy nvarchar | SIU |  |  |  |  | SAP_API_Data, tblPackSize, tblProCategory, tblProduct, tblProductDCDetails, tblProductGroup (+1 more) | `spec/database/procs/sp_Upsertdate_ProductInfo.sql` |

### DoctorVisit_DAL (13 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `DynamicPivotDoctorWiseDoctorVisitPlan` | @param NVARCHAR | S |  |  | Y |  | tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail, tblDoctorType (+3 more) | `spec/database/procs/DynamicPivotDoctorWiseDoctorVisitPlan.sql` |
| `sp_ApproveDoctorTourPlanMaster` | @TPMaster NVARCHAR, @ApprovedBy NVARCHAR, @Status NVARCHAR | SU |  |  |  |  | fnSplit, tbl_DoctorTourPlanMaster | `spec/database/procs/sp_ApproveDoctorTourPlanMaster.sql` |
| `sp_Get_DCRInfoList` | @param NVARCHAR | S |  |  | Y |  | tblDesignation, tblDoctorChemberDetail, tblDoctorMaster, tblEmpGeneralInfo, tblMarket, tblTerritory (+6 more) | `spec/database/procs/sp_Get_DCRInfoList.sql` |
| `sp_Get_DCRInfoListForView` | @param NVARCHAR | S |  |  | Y |  | View_Webapi_EmployeeFieldForceInfo, tblDesignation, tblDoctorChemberDetail, tblDoctorMaster, tblEmpGeneralInfo, tblUser (+4 more) | `spec/database/procs/sp_Get_DCRInfoListForView.sql` |
| `sp_Get_DoctorPlanDetailsById` | @id INT | S |  |  |  |  | tblDesignation, tblEmpGeneralInfo, tbl_DoctorTourPlanDetail, tbl_DoctorTourPlanMaster | `spec/database/procs/sp_Get_DoctorPlanDetailsById.sql` |
| `sp_Get_DoctorTourPlanMasteList` | @param NVARCHAR | S |  |  | Y |  | tblDesignation, tblEmpGeneralInfo, tblUser, tbl_DoctorTourPlanMaster, tbl_UserRoleInfo | `spec/database/procs/sp_Get_DoctorTourPlanMasteList.sql` |
| `sp_Get_TourPurpose` | (none) | S |  |  |  |  | tbl_TourPlanPurpose | `spec/database/procs/sp_Get_TourPurpose.sql` |
| `sp_Rpt_DCRInfo_ById` | @id INT | S |  |  |  |  | tblDesignation, tblDoctorChemberDetail, tblDoctorMaster, tblEmpGeneralInfo, tblProduct, tblUser (+5 more) | `spec/database/procs/sp_Rpt_DCRInfo_ById.sql` |
| `sp_Save_Notice_MarketDetail` | @NoticeId INT, @GroupId INT, @RegionId INT, @AreaId INT (+3 more) | SI |  |  |  |  | View_Webapi_EmployeeFieldForceInfo, tblNotice_Employee, tbl_Notice_MarketDetails | `spec/database/procs/sp_Save_Notice_MarketDetail.sql` |
| `sp_Save_NoticeDetails` | @NoticeDetailsId INT, @NoticeId INT, @RegionId INT, @AreaId INT (+3 more) | SI |  |  |  |  | tbl_Notice_MarketDetails | `spec/database/procs/sp_Save_NoticeDetails.sql` |
| `sp_Save_NoticeMaster` | @NoticeId INT, @NoticeTitle nvarchar, @Announcement nvarchar, @FromDate datetime (+2 more) | SI |  |  |  |  | tbl_Notice_MarketMaster | `spec/database/procs/sp_Save_NoticeMaster.sql` |
| `sp_Save_NoticeUserRoleDetail` | @UserRoleID INT, @NoticeId INT | SI |  |  |  |  | tblNoticeUserRoleDetail, tblNotice_Employee, tblUser | `spec/database/procs/sp_Save_NoticeUserRoleDetail.sql` |
| `sp_Update_NoticeMaster` | @NoticeId INT, @NoticeTitle NVARCHAR, @Announcement NVARCHAR, @FromDate DATETIME (+2 more) | UD |  |  |  |  | tblNoticeUserRoleDetail, tblNotice_Employee, tbl_Notice_MarketDetails, tbl_Notice_MarketMaster | `spec/database/procs/sp_Update_NoticeMaster.sql` |

### Thana_DAL (13 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_check_DistictInfo` | @id INT, @Name NVARCHAR | S |  |  |  |  | tbl_District | `spec/database/procs/sp_check_DistictInfo.sql` |
| `sp_check_ThanaInfo` | @id INT, @Name NVARCHAR | S |  |  |  |  | tbl_Thana | `spec/database/procs/sp_check_ThanaInfo.sql` |
| `sp_Get_ALl_District_List` | (none) | S |  |  |  |  | tbl_District, tbl_Division | `spec/database/procs/sp_Get_ALl_District_List.sql` |
| `sp_Get_ALl_Division_List` | (none) | S |  |  |  |  | tbl_Division | `spec/database/procs/sp_Get_ALl_Division_List.sql` |
| `sp_Get_ALl_Thana_List` | (none) | S |  |  |  |  | tbl_District, tbl_Division, tbl_Thana | `spec/database/procs/sp_Get_ALl_Thana_List.sql` |
| `sp_Get_District_Active_DDL` | @id Nvarchar | S |  |  |  |  | tbl_District | `spec/database/procs/sp_Get_District_Active_DDL.sql` |
| `sp_GET_DistrictInfo_ById` | @id NVARCHAR | S |  |  |  |  | tbl_District, tbl_Division | `spec/database/procs/sp_GET_DistrictInfo_ById.sql` |
| `sp_Get_Division_Active_DDL` | (none) | S |  |  |  |  | tbl_Division | `spec/database/procs/sp_Get_Division_Active_DDL.sql` |
| `sp_GET_ThanaInfo_ById` | @id NVARCHAR | S |  |  |  |  | tbl_District, tbl_Division, tbl_Thana | `spec/database/procs/sp_GET_ThanaInfo_ById.sql` |
| `sp_Save_DistictInfo` | @id int, @district_id INT, @ThanaName NVARCHAR, @CreatedBy INT | SI |  |  |  |  | tbl_District | `spec/database/procs/sp_Save_DistictInfo.sql` |
| `sp_Save_ThanaInfo` | @id int, @district_id INT, @ThanaName NVARCHAR, @CreatedBy INT | SI |  |  |  |  | tbl_Thana | `spec/database/procs/sp_Save_ThanaInfo.sql` |
| `sp_UD_DistictInfo` | @id int, @district_id INT, @ThanaName NVARCHAR, @UpdateBy INT | U |  |  |  |  | tbl_District | `spec/database/procs/sp_UD_DistictInfo.sql` |
| `sp_UD_ThanaInfo` | @id int, @district_id INT, @ThanaName NVARCHAR, @UpdateBy INT | U |  |  |  |  | tbl_Thana | `spec/database/procs/sp_UD_ThanaInfo.sql` |

### UserRoleDAL (10 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Delete_ByRoleIDTypeId` | @RoleId INT, @TypeId INT | D |  |  |  |  | tblMenuRole | `spec/database/procs/sp_Delete_ByRoleIDTypeId.sql` |
| `sp_Delete_PreviousmenuByRoleID` | @id INT | D |  |  |  |  | tblMenuRole | `spec/database/procs/sp_Delete_PreviousmenuByRoleID.sql` |
| `sp_GET_ApprovalMapLoad` | @FromRoleId NVARCHAR, @MenuId NVARCHAR | S |  |  |  |  | tblApprovalMapDetail, tblApprovalMapMaster, tblRoleType | `spec/database/procs/sp_GET_ApprovalMapLoad.sql` |
| `sp_GET_MainMenuByType` | @TypeId INT | S |  |  |  |  | tblMainMenuNew | `spec/database/procs/sp_GET_MainMenuByType.sql` |
| `sp_GET_MainMenuRole2` | @RoleId INT, @TypeId int | SD |  |  |  |  | tblMainMenuNew, tblMenuRole | `spec/database/procs/sp_GET_MainMenuRole2.sql` |
| `sp_GET_MainMenuRoleIsApp` | @RoleId INT, @TypeId bit | SD |  |  |  |  | tblMainMenuNew, tblMenuRole | `spec/database/procs/sp_GET_MainMenuRoleIsApp.sql` |
| `sp_GET_UserRoleDropDown` | (none) | S |  |  |  |  | tbl_UserRoleInfo | `spec/database/procs/sp_GET_UserRoleDropDown.sql` |
| `sp_Save_ApprovalMapDetail` | @ApprovalMapMasterId INT, @ToRoleId INT, @Order INT | SI |  |  |  |  | tblApprovalMapDetail | `spec/database/procs/sp_Save_ApprovalMapDetail.sql` |
| `sp_Save_ApprovalMapMaster` | @MenuId INT, @MenuName NVARCHAR, @FromRoleId INT | SID |  |  |  |  | tblApprovalMapDetail, tblApprovalMapMaster | `spec/database/procs/sp_Save_ApprovalMapMaster.sql` |
| `sp_Save_MenuRole` | @SL INT, @RoleId INT, @Add BIT, @View BIT (+3 more) | SID |  |  |  |  | tblMenuRole | `spec/database/procs/sp_Save_MenuRole.sql` |

### SInventory_UI (9 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Get_DAClaimDARouteList` | @ComUnitId INT, @ApprovalStatus NVARCHAR | S |  |  |  |  | tblDAClaimMaster, tblRouteInformationMaster | `spec/database/procs/sp_Get_DAClaimDARouteList.sql` |
| `sp_Get_DAClaimDICApprovalListByRoute` | @ComUnitId INT, @RouteId INT | S |  |  |  |  | tblCompanyUnit, tblDAClaimDetails, tblDAClaimMaster, tblDAInfo | `spec/database/procs/sp_Get_DAClaimDICApprovalListByRoute.sql` |
| `sp_Get_DAExpenseClaimList` | @ComUnitId INT, @RouteId INT, @daid INT, @FromDate DATE (+1 more) | S |  |  | Y |  | sys, tblRouteInformationDADetail, tblRouteInformationMaster, tbl_ExpenseClaim, tbl_ExpenseClaimDetails, tbl_ExpenseTypeDetails (+1 more) | `spec/database/procs/sp_Get_DAExpenseClaimList.sql` |
| `sp_Get_DAExpenseDayWiseSummary` | @Mode VARCHAR, @ComUnitId INT, @Month INT, @Year INT (+4 more) | S |  |  |  |  | AllowanceAgg, AllowanceBase, DAAgg, DaBase, DailyCombined, DailyDA (+11 more) | `spec/database/procs/sp_Get_DAExpenseDayWiseSummary.sql` |
| `sp_Get_MonthlyAllowanceById` | @MonthlyAllowanceId INT | S |  |  |  |  | tblMonthlyAllowances | `spec/database/procs/sp_Get_MonthlyAllowanceById.sql` |
| `sp_Get_SalesAssistantDAAmountClaimConfigById` | @SalesAssistantDAAmountClaimConfigId INT | S |  |  |  |  | tblSalesAssistantDAAmountClaimConfig | `spec/database/procs/sp_Get_SalesAssistantDAAmountClaimConfigById.sql` |
| `sp_Get_SalesAssistantDAAmountClaimConfigList` | @RoleName NVARCHAR | SI |  |  | Y |  | sp_executesql, tblSalesAssistantDAAmountClaimConfig, tblTourPlanType, tblTourType, tbl_TourPlanType | `spec/database/procs/sp_Get_SalesAssistantDAAmountClaimConfigList.sql` |
| `sp_Save_SalesAssistantDAAmountClaimConfig` | @SalesAssistantDAAmountClaimConfigId INT, @RoleName NVARCHAR, @TourTypeId INT, @DAAmount DECIMAL (+2 more) | SIU |  |  |  |  | tblSalesAssistantDAAmountClaimConfig | `spec/database/procs/sp_Save_SalesAssistantDAAmountClaimConfig.sql` |
| `sp_Update_DAExpenseClaimApprovalStatus` | @ExpenseClaimID INT, @ApprovalStatus NVARCHAR, @ApprovedBy INT, @UpdateBy NVARCHAR | SU |  |  |  |  | tbl_ExpenseClaim | `spec/database/procs/sp_Update_DAExpenseClaimApprovalStatus.sql` |

### DoctorInfo_DAL (8 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_GET_DZSMProcessDate` | @id NVARCHAR | S |  |  |  |  | tblDZSMProcessDate | `spec/database/procs/sp_GET_DZSMProcessDate.sql` |
| `sp_GET_SMCFamilyDoctorLastProcessDate` | @id NVARCHAR | S |  |  |  |  | tblProcess_SMCFamilyDoctor | `spec/database/procs/sp_GET_SMCFamilyDoctorLastProcessDate.sql` |
| `sp_Rpt_AreawiseDoctorWeek` | @frmDate nvarchar, @toDate nvarchar, @Zone nvarchar, @Area nvarchar (+1 more) | SI |  |  |  |  | tblArea, tblDoctorMaster, tblMarket, tblRegion, tblSubTerritory, tblTerritory (+5 more) | `spec/database/procs/sp_Rpt_AreawiseDoctorWeek.sql` |
| `sp_RPT_DoctorInfoReport` | @frmDate nvarchar, @toDate nvarchar, @Parameter nvarchar | S |  |  |  |  | tblArea, tblDoctorMaster, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblRegion (+4 more) | `spec/database/procs/sp_RPT_DoctorInfoReport.sql` |
| `sp_Rpt_DoctorwiseDoctorWeek` | @frmDate nvarchar, @toDate nvarchar, @Parameter nvarchar, @Zone nvarchar (+2 more) | SI |  |  |  |  | tblArea, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail (+13 more) | `spec/database/procs/sp_Rpt_DoctorwiseDoctorWeek.sql` |
| `sp_Rpt_MIOwiseDoctorWeek` | @frmDate nvarchar, @toDate nvarchar, @Zone nvarchar, @Area nvarchar (+2 more) | SI |  |  |  |  | tblArea, tblDoctorMaster, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblRegion (+7 more) | `spec/database/procs/sp_Rpt_MIOwiseDoctorWeek.sql` |
| `sp_Rpt_SMCFamilyDoctorReport_ProcessData` | @frmDate nvarchar, @toDate nvarchar, @Parameter nvarchar, @Zone nvarchar (+2 more) | S |  |  |  |  | tblProcess_SMCFamilyDoctor | `spec/database/procs/sp_Rpt_SMCFamilyDoctorReport_ProcessData.sql` |
| `sp_Rpt_ZonewiseDoctorWeek` | @frmDate nvarchar, @toDate nvarchar, @Zone nvarchar, @Parameter nvarchar | SI |  |  |  |  | tblArea, tblDoctorMaster, tblMarket, tblRegion, tblSubTerritory, tblTerritory (+5 more) | `spec/database/procs/sp_Rpt_ZonewiseDoctorWeek.sql` |

### PromoAllocDAL (6 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Get_GroupWisePromoQtyList` | @Parm nvarchar | S |  |  | Y |  | sp_executesql, tblEmpGeneralInfo, tblGroupWisePromoQty, tblMIOInfo, tblProduct, tblPromoGroup (+1 more) | `spec/database/procs/sp_Get_GroupWisePromoQtyList.sql` |
| `sp_Save_GroupWisePromoQty` | @Year INT, @Month nvarchar, @PromoGroupId INT, @Qty decimal (+5 more) | SI |  |  |  |  | tblGroupWisePromoQty | `spec/database/procs/sp_Save_GroupWisePromoQty.sql` |
| `sp_Save_PromoMIOTagDetail` | @MIOTagId INT, @MIOId INT, @EmpInfoId INT | I |  |  |  |  | tblPromoMIOTagDetail | `spec/database/procs/sp_Save_PromoMIOTagDetail.sql` |
| `sp_Save_PromoMIOTagMaster` | @MIOTagId INT, @PromoGroupId INT, @EntryBy nvarchar | SI |  |  |  |  | tblPromoMIOTagMaster | `spec/database/procs/sp_Save_PromoMIOTagMaster.sql` |
| `sp_Update_PromoEmployeeQty` | @TourSetupEmployeeId int, @CountNo int, @UpdateBy INT, @UpdateDate DATETIME | U |  |  |  |  | tblGroupWisePromoQty | `spec/database/procs/sp_Update_PromoEmployeeQty.sql` |
| `sp_Update_PromoMIOTagMaster` | @MIOTagId INT, @PromoGroupId INT, @EntryBy nvarchar | UD |  |  |  |  | tblPromoMIOTagDetail, tblPromoMIOTagMaster | `spec/database/procs/sp_Update_PromoMIOTagMaster.sql` |

### Transfer_DAL (3 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Get_MSList_Approve` | @Parm nvarchar | S |  |  |  |  | tblArea, tblMarket, tblMarketStructureTranfer, tblSubTerritory, tblTerritory | `spec/database/procs/sp_Get_MSList_Approve.sql` |
| `sp_Update_MarketStructure_Approve` | @MasterId NVARCHAR, @ApprovedBy NVARCHAR, @Type NVARCHAR | SU |  |  |  |  | tblMarket, tblMarketStructureTranfer, tblSubTerritory, tblTerritory | `spec/database/procs/sp_Update_MarketStructure_Approve.sql` |
| `sp_Update_MarketStructure_Transfer` | @Type NVARCHAR, @FGroupId int, @FRegionId int, @FAreaId int (+9 more) | I |  |  |  |  | tblMarketStructureTranfer | `spec/database/procs/sp_Update_MarketStructure_Transfer.sql` |

### MarketUpload_DAL (3 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Save_MarketPropDetail` | @MarketPropMasterId INT, @TerritoryCode NVARCHAR, @MarketCode NVARCHAR, @MarketName NVARCHAR (+8 more) | SI |  |  |  |  | tblMarket, tblMarketPropDetail, tblStationType, tblTerritory, tbl_District, tbl_Division (+1 more) | `spec/database/procs/sp_Save_MarketPropDetail.sql` |
| `sp_Save_MarketPropMaster` | @MarketPropMasterId INT, @TypeId INT, @EntryBy NVARCHAR, @EntryDate DATETIME (+1 more) | SI |  |  |  |  | tblMarketPropMaster | `spec/database/procs/sp_Save_MarketPropMaster.sql` |
| `sp_Save_MarketPropToTable` | @MarketPropMasterId INT, @EntryBy NVARCHAR, @EntryDate DATETIME | SIUD |  |  |  |  | tblMarket, tblMarketPropDetail, tblMarketPropMaster, tblMarketStationDetail, tblSubTerritory, tblTerritory | `spec/database/procs/sp_Save_MarketPropToTable.sql` |

### DoctorMaster_DAL (2 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_check_PrescriptionType` | @PrescriptionTypeId INT, @PrescriptionType NVARCHAR | S |  |  |  |  | tbl_PrescriptionType | `spec/database/procs/sp_check_PrescriptionType.sql` |
| `sp_Delete_DoctorChamber` | @ChamberId INT, @DeleteBy NVARCHAR | U |  |  |  |  | tblDoctorChamber | `spec/database/procs/sp_Delete_DoctorChamber.sql` |

### SettingPanel_DAL (2 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_GET_UserSettingPanel` | (none) | S |  |  |  |  | tblUserSettingPanel | `spec/database/procs/sp_GET_UserSettingPanel.sql` |
| `sp_UpDate_UserSettingPanel` | @UserSettingPanelId INT, @FromDate DATETIME, @Todate DATETIME | U |  |  |  |  | tblUserSettingPanel | `spec/database/procs/sp_UpDate_UserSettingPanel.sql` |

### InternalCls (1 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `ExecuteAllSqlQueryByStoreProcedure` | @Query NVARCHAR | - |  |  | Y |  |  | `spec/database/procs/ExecuteAllSqlQueryByStoreProcedure.sql` |

### DoctorModule_UI (1 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sAlesAssistantDAClaimList` | @ComUnitId INT, @FromDate DATE, @ToDate DATE | S |  |  |  |  | tblDAInfo, tblDICApprovedDAClaimAmount, tblMarket | `spec/database/procs/sAlesAssistantDAClaimList.sql` |

### Doctor_Monitoring_DAL (1 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_Get_AllDoctorVisitMonitoringApprovalList` | @param NVARCHAR, @frmDate date, @toDate date, @GroupId nvarchar (+3 more) | S |  |  |  |  | tblArea, tblCustMaster, tblCustPayDetail, tblEmpGeneralInfo, tblInvoice, tblInvoiceDetail (+15 more) | `spec/database/procs/sp_Get_AllDoctorVisitMonitoringApprovalList.sql` |

### SubDepot_DAL (1 procedures)

| Procedure | Parameters | Ops | TC | TX | DYN | CUR | Tables referenced | Source |
|---|---|---|---|---|---|---|---|---|
| `sp_UD_SubDcStockOutApproval` | @SubDcStockOutMasterId INT, @Status NVARCHAR, @ApprovedBy NVARCHAR, @ApprovedDate DateTime | SU |  |  |  |  | tblSubDepotStockOutDetails, tblSubDepotStockOutMaster, tblSubDepotStore | `spec/database/procs/sp_UD_SubDcStockOutApproval.sql` |

## Orphan inventory — procedures with no C# caller found (810 procedures)

Listed name-only (mechanical facts are in the source `.sql` file cited). These are candidates for the Flutter mobile app's exclusive use, ad-hoc/manual/reporting use, genuine dead code, **or a procedure called only from inside another procedure** (this scan does not follow `EXEC otherProc` chains — see the confirmed SAP example noted above) — not distinguishable from static analysis alone. Grouped by naming-prefix heuristic where recognizable.

`AutoDeleteZeroPayment`, `DateRange_To_TableBySL`, `DynamicPivotBrandWiseRX`, `DynamicPivotDoctorWiseCVR`, `DynamicPivotDoctorWiseDCR_New`, `DynamicPivotDoctorWiseRX`, `DynamicPivotProductdWiseRX`, `DynamicPivotTableInSql`, `DynamicPivotUserWiseAttendance`, `DynamicPivotUserWiseRX`, `GetMonthYearValues`, `InsertProcedureExecutionStats`, `sp_ActiveInactive_DistrictCoordinator`, `sp_ActiveInactive_QuotedPrice`, `sp_ActiveInactive_UpazilaCoordinator`, `sp_ADJ_CustomerPaymentPosting`, `sp_ADJ_DeliveryConfirmationFullPosting`, `sp_ADJ_DeliveryConfirmationPartiallPosting`, `sp_ADJ_DeliveryInvoiceDeletePosting`, `sp_ADJ_DeliverySalesReturnPosting`, `sp_ADJ_FreezeStockPosting`, `sp_ADJ_FreezeStockReleasePosting`, `sp_ADJ_ProductDestroyPosting`, `sp_ADJ_ProformaFullReturnPosting`, `sp_ADJ_ProformaPosting`, `sp_ADJ_ProformaReturnPosting`, `sp_ADJ_VoucherMasterDetailPosting`, `sp_Approve_EmployeeLeaveApplication`, `sp_Approve_ExpenseClaim`, `sp_Approve_Prescription`, `sp_Approved_ExpenseReimbursmentFrom`, `sp_Auto_AutoStockUpdate`, `sp_BusinessSummaryMISReport_All`, `sp_BusinessSummaryMISReport_Zone`, `sp_CampaignTypeUpdateFromBizmotion`, `sp_CampaignUpdate`, `sp_Check_anomalyInvoiceDetailsdddddddddd`, `sp_Check_anomalyInvoiceDetailsfffffff`, `sp_Check_anomalyInvoiceDetailsrecheck`, `sp_check_DistrictCoordinator`, `sp_check_DoctorDegreeDetail`, `sp_check_Manufacturer`, `sp_check_MonthlyAllowance`, `sp_check_MonthlyTarget`, `sp_check_PackZise`, `sp_check_ProductBrand`, `sp_check_ProductCategory`, `sp_check_ProductInfo`, `sp_check_ReferInstitution`, `sp_check_ShippingCarton`, `sp_check_Unitprice`, `sp_check_UpazilaCoordinator`, `sp_check_UserInfo`, `sp_CRRR_WrongPayment`, `sp_CS_GetMarket_ByTerritoryId_Active`, `sp_CS_GetSubMarket_ByMarketId_Active`, `sp_CSOpeningBalanceProcess`, `sp_CustomerPaymentPosting`, `sp_da_CheckUserForceLogout`, `sp_da_INS_tblDeliveryLogin_appLog`, `sp_da_INS_tblPaymentCollection_appLog`, `sp_da_INS_tblSalesConfirmation_appLog`, `sp_da_INS_tblSalesConfirmation_appLogDetail`, `sp_da_INS_tblSalesReturn_appLog`, `sp_da_INS_tblSalesReturn_appLogDetail`, `sp_da_SalesAPI_doLogin`, `sp_da_SAVE_DICApprovedDAClaimAmount`, `sp_da_SAVE_DICApprovedDAClaimAmountLog`, `sp_da_SAVE_ExpenseClaim_DA`, `sp_da_SAVE_ExpiryReturnLog`, `sp_da_SAVE_tblDAClaim`, `sp_da_UPD_PaymentCollection_BankDeposit`, `sp_da_UPDATE_ExpenseClaimImage`, `sp_Dashboar_ExpireProductList`, `sp_Dashboar_TopCustomer`, `sp_Dashboard_DepotSalesAndCollection`, `sp_Dashboard_NationalProductSales`, `sp_Dashboard_PriorityProductSales`, `sp_Dashboard_TopCustomer`, `sp_DCBinCard`, `sp_DCStoreOpeningBalanceProcess`, `sp_DefigitRecovery`, `sp_DEL_DelteCustPay`, `sp_DEL_DuplicatePayment`, `sp_DEL_SampleStockIssue`, `sp_Delete_CustomerTypeInfo`, `sp_Delete_DistrictCoordinator`, `sp_Delete_Prescription`, `sp_Delete_UpazilaCoordinator`, `sp_DeleteInvoice`, `sp_DeliveryConfirmationFullPosting`, `sp_DeliveryConfirmationPartiallPosting`, `sp_DeliveryInvoiceDeletePosting`, `sp_DeliveryReturn`, `sp_DeliverySalesReturnPosting`, `sp_DSB_AglingReport`, `sp_DSB_BusinessSummery`, `sp_Execute_SingleOrder`, `sp_FreezeStockPosting`, `sp_FreezeStockReleasePosting`, `sp_Get_AllActive_Zone_BI_Report`, `sp_GET_AllArea`, `sp_Get_AllowanceData_ByEmployeeId`, `sp_GET_AllRegion`, `sp_Get_AllSalesReportListParam2Pro`, `sp_Get_ApprovalMapData`, `sp_Get_AttandenceMonthlyDashboard`, `sp_GET_CampaignNameFromOrderDetailByDateRange`, `sp_GET_CampaignNameFromOrderDetailByMonthYear`, `sp_GET_Check_QuotedpriceEntry`, `sp_GET_CollectionVsSales_BI`, `sp_Get_CustMasterList_ApproveTest`, `sp_Get_CustomerAppDataForDuplicate`, `sp_GET_CustomerCategoryWiseCount_BI`, `sp_Get_CustomerCoverage`, `sp_GET_CustomerCoverageFCBNOFCB_BI`, `sp_Get_CustomerCoverageRecordMonthlyDashboard`, `sp_Get_CustomerInfo_ByCode`, `sp_Get_CustomerInfoForDDL`, `sp_GET_CustomerTypeAllByDateRange`, `sp_GET_CustomerTypeAllMonthYear`, `sp_GET_CustomerWiseNoSales_BI`, `sp_GET_CustomerWiseSalesAnalysis`, `sp_GET_CustomerWiseSalesAnalysis_BI`, `sp_GET_da_BankList`, `sp_GET_da_ConfirmationList`, `sp_GET_da_CustomerwiseAgingdashboard`, `sp_GET_da_DAAmountList`, `sp_GET_da_DAClaimAmountListReports`, `sp_GET_da_DAClaimListByDA`, `sp_GET_da_DATOurPlanMarketListReports`, `sp_GET_da_DaWiseCustomerList`, `sp_GET_da_DaWiseDCList`, `sp_GET_da_DaWiseMarketList`, `sp_GET_da_DaWiseRouteList`, `sp_GET_da_DICApprovedDAClaimMarket`, `sp_GET_da_ExpenseClaimListByDA`, `sp_GET_da_ExpenseImagePathSetting`, `sp_GET_da_ExpenseTypeByDA`, `sp_GET_da_ExpenseTypeDetailsById`, `sp_GET_da_ExpenseTypeWithDetailsById`, `sp_GET_da_MarketListDAClaim`, `sp_GET_da_PaymentCollectionApprovalList`, `sp_GET_da_PaymentCollectionList`, `sp_GET_da_PendingforDepositlist`, `sp_GET_da_ProductList`, `sp_GET_da_rpt_ConfirmationList`, `sp_GET_da_rpt_PaymentCollectionList`, `sp_GET_da_rpt_SalesReturnList`, `sp_GET_da_SalesConfirmationApprovalList`, `sp_GET_da_SalesConfirmationDetailsByInvoiceId`, `sp_GET_da_SalesReturnApprovalList`, `sp_GET_da_SalesReturnDetailsByInvoiceId`, `sp_GET_da_SalesReturnList`, `sp_Get_DAExpenseClaimApprovalList`, `sp_GET_Dashboard_BI`, `sp_GET_DashboardCardInfo`, `sp_Get_DCRReportNew`, `sp_GET_DCStockInfo`, `sp_Get_DCStockReportList`, `sp_GET_DeliveryVsCollection`, `sp_GET_DesignationForDDL`, `sp_GET_DistrictCoordinator`, `sp_GET_DistrictCoordinator_ById`, `sp_Get_DoctorAppDataForDuplicate`, `sp_Get_DoctorGMPRecordMonthlyDashboard`, `sp_Get_DoctorGMPxRecordMonthlyDashboard`, `sp_Get_DoctorSpecialDay_Active`, `sp_Get_DoctorTourPlanDateById`, `sp_GET_DueInvoiceNoCorrection`, `sp_GET_DZSMwiseReportParam`, `sp_GET_DZSMwiseReportParam_new`, `sp_Get_EmployeeInformationList`, `sp_Get_EmployeeInformationListRpt`, `sp_Get_EmployeeInformationListRpt_new`, `sp_Get_ExpenseClaimList_Approval`, `sp_GET_FinancialYear`, `sp_GET_FinancialYearDate`, `sp_GET_FinancialYearWithId`, `sp_GET_GenericGroupActiveForDDL`, `sp_Get_GetDWSPTotalsByEmpId`, `sp_Get_GoogleList`, `sp_Get_IntransitReportList_BI`, `sp_GET_MainMenuRole`, `sp_GET_Manufacturer`, `sp_GET_Manufacturer_ById`, `sp_GET_ManufacturerActiveForDDL`, `sp_GET_MenuHTML`, `sp_Get_MIATargetList`, `sp_Get_MIATargetListNew`, `sp_Get_MileageClaimList_new`, `sp_get_MIOInfoForTarget`, `sp_Get_MIOListByTerritoryId`, `sp_Get_MonthlyExpenseEmpWiseMaster_Mo`, `sp_Get_MonthlyExpenseEmpWiseMaster_new`, `sp_Get_MonthlyExpenseEmpWiseMasterff`, `sp_Get_MonthlyInventoryReport_Back`, `sp_Get_Order_Info_WebAPI_NEw`, `sp_Get_Order_Info_WebAPI_NEw_MIo`, `sp_Get_Order_Info_WebAPI_NEw_MIo_ByMonthYear`, `sp_Get_OrderRecordMonthlyDashboard`, `sp_Get_OrderRecordMonthlyDashboardMonthWise`, `sp_Get_OrderTrackingList`, `sp_GET_packSize`, `sp_GET_PackSize_ById`, `sp_GET_PackSizeActiveForDDL`, `sp_GET_PaymentInvSP_DA`, `sp_GET_PaymentInvSPNew`, `sp_Get_PrescriptionList_ForApproval`, `sp_Get_product_ByCode`, `sp_GET_ProductAllForDDL`, `sp_GET_ProductBrand`, `sp_GET_ProductBrand_ById`, `sp_GET_ProductBrandActiveForDDL`, `sp_GET_ProductCategory`, `sp_GET_ProductCategory_ById`, `sp_GET_ProductCategoryActiveForDDL`, `sp_Get_productForDDL`, `sp_GET_ProductGroup`, `sp_GET_ProductInfo`, `sp_GET_ProductInfo_ById`, `sp_GET_ProductQuotedPrice`, `sp_GET_productQuotedPrice_ById`, `sp_GET_ProductRelatedValue_ById`, `sp_GET_ProductType`, `sp_GET_ProductType_ById`, `sp_GET_ProductTypeActiveForDDL`, `sp_Get_ProformaInvoiceReportList_Search`, `sp_GET_ProgramTypeListByDateRange`, `sp_GET_ProgramTypeListByMonthYear`, `sp_GET_ReferInstitution`, `sp_GET_ReferInstitution_ById`, `sp_GET_ReturnReasonAnalysis`, `sp_GET_SalesCampaignNonCampaign_BI`, `sp_GET_SalesFCBNonFCB_BI`, `sp_Get_SalesRecordMonthly`, `sp_Get_SalesRecordMonthly_New`, `sp_Get_SalesRecordMonthlyDayWsie`, `sp_Get_SalesRejectionReportList`, `sp_Get_SalesReturnAppLogDetailQty`, `sp_Get_SalesReturnReport_fix`, `sp_Get_SalesReturnReport_kooo`, `sp_GET_ShippingCarton`, `sp_GET_ShippingCartonActiveForDDL`, `sp_GET_ShippingCartonSize_ById`, `sp_GET_SMCTypeListByDateRange`, `sp_GET_SMCTypeListMonthYear`, `sp_GET_StockUOMForDDL`, `sp_GET_TargetvsAchivement_BIReport`, `sp_GET_TerritoryHR_ByTerritoryId`, `sp_GET_TherapueticGroupActiveForDDL`, `sp_Get_TopSellingProduct`, `sp_Get_TotalCountForEmployee`, `sp_Get_TourPlanReportListNN`, `sp_Get_TransitVSCollection_BI`, `sp_GET_UnitPrice_ById`, `sp_GET_UnitPrice_ByProductId`, `sp_GET_UnitpriceInfo`, `sp_GET_UpazilaCoordinator`, `sp_GET_UpdateCampaignType`, `sp_GET_UpzilaCoordinator_ById`, `sp_GET_UserInfoAll`, `sp_GET_UserList`, `sp_Get_UserRoles`, `sp_Get_UserRolesbyid`, `sp_GET_WebAPI_CheckList_GetAssignmentScreenData`, `sp_GET_WingsSalesReport`, `sp_GET_WingsSalesReportByCompany`, `sp_GET_WingsSalesReportByUnit`, `sp_GetCustomer_Doctor_TransferList`, `sp_GetDCRDoctorWiseRpt`, `sp_GetLatestAppVersion`, `sp_GetMissingCustomerCount`, `sp_GetWarningForCustomerPayment`, `sp_I_CustomerGl`, `sp_I_DCStockOutInfo`, `sp_I_Diposit`, `sp_I_GWPStock`, `sp_I_InvoiceAutoGeneration`, `sp_I_OrderMaster`, `sp_I_PaymentDeleteLog`, `sp_I_PrettyCashDetails`, `sp_I_PrettyCashMaster`, `sp_I_ProductGl`, `sp_I_SampleProductIssue`, `sp_I_SupplierGl`, `sp_ImportApiData`, `sp_ImportApiData_Backup_10102019`, `sp_InvoiceDelete_IfnoDetails`, `sp_LoadOrderListForOrderRouteDayWiseN`, `sp_LoadOrderListForOrderRouteDayWiseold`, `sp_MinusStockUpdatetoZero`, `sp_NonTranscationalInvoiceApproval`, `sp_OPAPI_GETCamaignDetail`, `sp_OPAPI_GetCampaignMaster`, `sp_OPAPI_GetQuotedPrice`, `sp_OPAPI_updateCustomerLocation`, `sp_OrderGenerationFromUploadOrder_Backup`, `sp_PartialUpdate`, `sp_Process_AutoWeekProcess`, `sp_Process_DZSMwiseReportParam`, `sp_Process_DZSMwiseReportParam_Backup`, `sp_Process_DZSMwiseReportParam_New_Day`, `sp_Process_EmpInfoInactive`, `sp_Process_OrderIssubdeportFalse`, `sp_Process_ProformaInvoiceByOrderId_OldTest`, `sp_Process_ProformaInvoiceByOrderId_Pulak`, `sp_Process_ProformaSampleInvoiceByOrderId`, `sp_processDCRDCPRX`, `sp_ProductDestroyPosting`, `sp_Proforma`, `sp_ProformaFullReturnPosting`, `sp_ProformaPosting`, `sp_ProformaReturnPosting`, `sp_PROMOOpeningBalanceProcess`, `sp_RecoverOrderInfo`, `sp_RPT_DoctorInfo_Details`, `sp_RPT_DoctorInfo_DOCWise`, `sp_RPT_DoctorInfo_MIOWise`, `sp_Rpt_SMCFamilyDoctorReport`, `sp_Rpt_ZonewiseDoctorWeek_New`, `sp_Sales`, `sp_SalesAPI_doLogin`, `sp_SalesAPI_doLogin_New`, `sp_SalesAPI_doLoginCheckEMI`, `sp_SalesAPI_doLoginMatch`, `sp_SalesAPI_FieldForceArea`, `sp_SalesAPI_FieldForceAsm`, `sp_SalesAPI_FieldForceGroup`, `sp_SalesAPI_FieldForceMarket`, `sp_SalesAPI_FieldForceMio`, `sp_SalesAPI_FieldForceNsm`, `sp_SalesAPI_FieldForceRegion`, `sp_SalesAPI_FieldForceRsm`, `sp_SalesAPI_FieldForceSubTerritory`, `sp_SalesAPI_FieldForceTerritory`, `sp_SalesDepositOpeningBalanceProcess`, `sp_SampleInvoicePosting`, `sp_SAP_API_InsertProduct`, `sp_SAP_API_usp_InsertUOMWithConversion`, `sp_SAP_B2BChallanDetailInsert`, `sp_SAP_B2BChallanMasterInsert`, `sp_SAP_B2BStockReceiveByDc`, `sp_SAP_ChallanMasterConfirm`, `sp_SAP_ChallanSendDetailByChalanId`, `sp_SAP_ChallanSendMaster`, `sp_SAP_DeliveryCOnfirmatioinDtls`, `sp_SAP_DeliveryCOnfirmatioinDtls_New`, `sp_SAP_DeliveryCOnfirmatioinMaster`, `sp_SAP_DeliveryCOnfirmatioinMaster_New`, `sp_SAP_DeliveryConfirmationSales_Process`, `sp_SAP_DeliveryConfirmationSales_ProcessNew`, `sp_SAP_DeliveryInfo_prm`, `sp_SAP_EmployeeAttData`, `sp_SAP_EmployeeAttDataConfirm`, `sp_SAP_Expiry_ProcessNew`, `sp_SAP_ExpiryDtls_New`, `sp_SAP_ExpiryReturn_New`, `sp_SAP_InsertOrUpdateAreaAssign`, `sp_SAP_InsertOrUpdateEmployee`, `sp_SAP_InsertOrUpdateTerritoryAssign`, `sp_SAP_InsertOrUpdateZoneAssign`, `sp_SAP_Invoice_Process`, `sp_SAP_InvoiceInfo`, `sp_SAP_InvoiceInfo_prm`, `sp_SAP_InvoiceItemByInvoiceId`, `sp_SAP_NationalStockDtls`, `sp_SAP_NationalStockList`, `sp_SAP_NationalStockMaster`, `sp_SAP_PaymentInfo_prm`, `sp_SAP_RequisitionDetailUpdate`, `sp_SAP_RequisitionMasterUpdate`, `sp_SAP_Return_New`, `sp_SAP_Return_ProcessNew`, `sp_SAP_Return_ProcessNew2nd_Return`, `sp_SAP_ReturnDtls_New`, `sp_SAP_ReturnRecoveryDtls_New`, `sp_SAP_ReturnRecoveryMaster_New`, `sp_SAP_Returns_ExpiryDtls`, `sp_SAP_Returns_ExpiryList`, `sp_SAP_Returns_ExpiryMaster`, `sp_SAP_SalesAdditionDtls`, `sp_SAP_SalesAdditionList`, `sp_SAP_SalesAdditionMaster`, `sp_SAP_SalesDtls`, `sp_SAP_SalesList`, `sp_SAP_SalesMaster`, `sp_SAP_SalesReturnDtls`, `sp_SAP_SalesReturnMaster`, `sp_SAP_Save_SAPSTODetail`, `sp_SAP_Save_SAPSTOMaster`, `sp_SAP_Save_StockMovementDetails`, `sp_SAP_Save_StockMovementMaster`, `sp_SAP_Save_StoInfo`, `sp_SAP_StockInTransfer`, `sp_SAP_StockInTransferUpdate`, `sp_SAP_StockReceiveByDc`, `sp_SAP_STODetails`, `sp_SAP_STOList_prm`, `sp_SAP_STOListAfterSave_prm`, `sp_SAP_STOListDetails_prm`, `sp_SAP_STOMaster`, `sp_SAP_StoNoforChallanConfirm`, `sp_SAP_StoNoforChallanConfirmDone`, `sp_SAP_Up_SAP_ChallanConfirmByChalanId`, `sp_SAP_Up_SAP_ChallanSendByChalanId`, `sp_SAP_UpdateEmpTerritory`, `sp_SAP_WHStockInApprove`, `sp_SAP_WhStockInDetails`, `sp_SAP_WhStockInMaster`, `sp_Save_DistrictCoordinator`, `sp_Save_DoctorChemberDetail`, `sp_Save_DoctorContactDetail`, `sp_Save_DoctorCustomer`, `sp_Save_DoctorInistitutionDetail`, `sp_Save_DoctorMarketDetail`, `sp_Save_DoctorSpecialDayDetail`, `sp_Save_EmployeeAllowanceRelation`, `sp_Save_EmployeeLeaveApplication`, `sp_Save_Manufacturer`, `sp_Save_Prescription`, `sp_Save_PrescriptionDetails`, `sp_Save_ProductBrand`, `sp_Save_Productcategory`, `sp_Save_ProductInfo`, `sp_Save_ProductType`, `sp_Save_QuotedPrice`, `sp_Save_ReferInstitution`, `sp_Save_SalesConfirmResponseData`, `sp_Save_SalesRetunResponseData`, `sp_Save_ShippingCartonSize`, `sp_Save_tblMIATargetList`, `sp_Save_tblMIATargetListNew`, `sp_Save_UnitPriceInfo`, `sp_Save_UpazilaCoordinator`, `sp_Save_UserMaster`, `sp_Save_UserRoles`, `sp_SInventory_DynamicMISReport`, `sp_SInventory_DynamicMISReportTP`, `sp_SInventory_DynamicMISReportUserWise`, `sp_SInventory_DynamicMISReportUserWiseTP`, `sp_SInventory_GetCustomerTypeReport`, `sp_sp_DefigitRecovery_Details`, `sp_Stock`, `sp_SubDCStoreOpeningBalanceProcess`, `sp_SubdeportProframTypeUpdate`, `sp_Suport_IsInvoiceCorrectionOnOrder`, `sp_Test_GenerateC#ModelFromTable`, `sp_UD_CustomerCreditLimitExtension`, `sp_UD_CustomerGl`, `sp_UD_CustomerMaster`, `sp_UD_DistrictCoordinator`, `sp_UD_InvoicePayment`, `sp_UD_Manufacturer`, `sp_UD_OrderIsSpecialApproval`, `sp_UD_PackSize`, `sp_UD_ProductBrand`, `sp_UD_ProductCategory`, `sp_UD_ProductInfo`, `sp_UD_productQuotedPrice`, `sp_UD_ReceiveIdInDc`, `sp_UD_ReceiveIdInDcOpeningBalance`, `sp_UD_ReferInstitution`, `sp_UD_ResetPaymentExtra`, `sp_UD_SampleStockIssue`, `sp_UD_ShippingCarton`, `sp_UD_StockBatch`, `sp_UD_tblCustMaster`, `sp_UD_UnitPriceInfo`, `sp_UD_UpazilaCoordinator`, `sp_Up_BonusProducttoZero`, `sp_UP_UpdateVatandPrice`, `sp_upd_30daysOrderInactive`, `sp_Update_Prescription`, `sp_Update_UserMaster`, `sp_Update_Zero_PaymentInfo`, `sp_UpdateBlueandGreenstarEmpType`, `sp_UpdateDeliveryamout`, `sp_UpdateDiscountForInstrituteBusiness`, `sp_UpdateNegativeStock`, `sp_UpdatenullInvoiceStatus`, `sp_UpdateOpeningBalanceStockQty`, `sp_ValidateCreditLimit`, `sp_ValidateTimeOutOfRange`, `sp_ValuewiseBusinessSummaryReport`, `sp_View_EmployeeLeaveBalance`, `sp_WearhouseBinCard`, `sp_WebAI_Get_TTargetAChivementReport`, `sp_Webapi_check_Customer`, `sp_Webapi_Check_DcrProduct`, `sp_Webapi_check_ExpenseClaim`, `sp_Webapi_Check_ProductActiveorGift`, `sp_Webapi_Check_ProductActiveorNot`, `sp_Webapi_Check_ProductActiveorNotEmpId`, `sp_Webapi_Check_ProductGiftActiveorNotEmpId`, `sp_Webapi_CheckFakeMarket`, `sp_Webapi_CheckGhorShajai2RestrictProducts`, `sp_Webapi_CheckGhorShajai3RestrictProducts`, `sp_Webapi_CheckGiftProduct`, `sp_Webapi_CheckGRestrictProductsByCustYpeID`, `sp_Webapi_CheckOld_Password`, `sp_Webapi_CheckWhocanSubmitOrder`, `sp_Webapi_CHK_PROMOProductQty`, `sp_webapi_CompanyUnitAllNN`, `sp_Webapi_Del_TourPlanInfoForEmpDate`, `sp_Webapi_Delete_Dcr`, `sp_Webapi_Delete_DoctorTourPlan`, `sp_Webapi_Delete_ExpenseClaim`, `sp_Webapi_Delete_LeaveInfo`, `sp_Webapi_Delete_OrderDetail`, `sp_Webapi_delete_TourPlanData`, `sp_Webapi_FinalSubmitSend_Check`, `sp_Webapi_FinalSubmitSend_DWSP`, `sp_Webapi_FinalSubmitSend_TourPlan`, `sp_Webapi_Get_AllApprovalPendingInfo`, `sp_Webapi_Get_AllLeaveRecords`, `sp_Webapi_Get_AMMultipleArea`, `sp_Webapi_Get_AttendanceInfo`, `sp_Webapi_Get_AttendanceInformation2`, `sp_Webapi_Get_AttendanceInformation3`, `sp_Webapi_Get_BonusCampaingData`, `sp_Webapi_Get_BSPDistrict`, `sp_Webapi_Get_BSPDivisionAll`, `sp_Webapi_Get_BSPThana`, `sp_Webapi_GET_CampaignDetail_ById`, `sp_Webapi_Get_CampaignMasterCheck`, `sp_Webapi_Get_CampaignMasterInfo`, `sp_Webapi_Get_CampaignMasterInfoMultiPro`, `sp_Webapi_Get_CampaignMasterInfoProForProduct`, `sp_Webapi_Get_CampaignNCOD`, `sp_Webapi_Get_CampaingData`, `sp_Webapi_Get_CampaingDetail`, `sp_Webapi_Get_CampaingDetailParam`, `sp_Webapi_Get_Chamber_ByDoctorId`, `sp_Webapi_Get_ChamberName`, `sp_Webapi_Get_CustomerAll`, `sp_Webapi_Get_CustomerAllIsMarketUpdate2022`, `sp_Webapi_Get_CustomerByMarketId`, `sp_Webapi_Get_CustomerCampaignData`, `sp_Webapi_Get_CustomerInfos`, `sp_Webapi_Get_CustomerPendingReject`, `sp_Webapi_Get_CustomerType`, `sp_Webapi_Get_DCRApp`, `sp_Webapi_Get_DCRBrandList`, `sp_Webapi_Get_DCRInfoListbyDcrId`, `sp_Webapi_Get_DcrListById`, `sp_Webapi_Get_DcrProductByType`, `sp_Webapi_Get_DCRProductList`, `sp_Webapi_Get_DCRVisitedWithList`, `sp_Webapi_Get_DICcheck`, `sp_Webapi_Get_District`, `sp_Webapi_Get_DistrictByDivisionId`, `sp_Webapi_Get_DivisionAll`, `sp_Webapi_Get_DoctorAll`, `sp_Webapi_Get_DoctorAllIsMarketUpdate2022`, `sp_Webapi_Get_DoctorBrand`, `sp_Webapi_Get_DoctorBrandByDoctorId`, `sp_Webapi_Get_DoctorCategory`, `sp_Webapi_Get_DoctorChamber`, `sp_Webapi_Get_DoctorChamberByDocId`, `sp_Webapi_Get_DoctorChember_AppLog`, `sp_Webapi_Get_DoctorContact_AppLog`, `sp_Webapi_Get_DoctorContactType`, `sp_Webapi_Get_DoctorDegree`, `sp_Webapi_Get_DoctorDesignation`, `sp_Webapi_Get_DoctoreVisitTypeForDcr`, `sp_Webapi_Get_DoctorInstitute`, `sp_Webapi_Get_DoctorList`, `sp_Webapi_Get_DoctorMaster_AppLog`, `sp_Webapi_Get_DoctorPendingReject`, `sp_Webapi_Get_DoctorPlanByDate`, `sp_Webapi_Get_DoctorProgramType`, `sp_Webapi_Get_DoctorSpecialDay`, `sp_Webapi_Get_DoctorSpecialDay_AppLog`, `sp_Webapi_Get_DoctorSpeciality`, `sp_Webapi_Get_DoctorType`, `sp_Webapi_Get_DoctorVisitPlanMasterData`, `sp_Webapi_Get_DoctorVisitType`, `sp_Webapi_Get_DWSPApp`, `sp_Webapi_Get_DWSPByDate`, `sp_Webapi_Get_DWSPDetails`, `sp_Webapi_Get_DZSMMultipleArea`, `sp_Webapi_Get_EmpAllawance_Monthly`, `sp_Webapi_Get_EmployyeMonthlyExpense`, `sp_Webapi_Get_EmployyeMonthlyExpenseSum`, `sp_Webapi_Get_ExpanseClaimApp`, `sp_Webapi_Get_ExpenseClaimList`, `sp_Webapi_Get_ExpenseClaimListDetaisl`, `sp_Webapi_Get_ExpenseClaimMasterDataById`, `sp_Webapi_Get_ExpenseType`, `sp_Webapi_Get_ExpenseTypebyRoleEmp`, `sp_Webapi_Get_ExpenseTypeByRoleType`, `sp_Webapi_Get_ExpenseTypeDetails`, `sp_Webapi_Get_LeaveEditData`, `sp_Webapi_Get_LeaveRecords`, `sp_Webapi_Get_LeaveType`, `sp_Webapi_Get_LeaveTypeOld`, `sp_Webapi_Get_MarketAttendanceMaxID`, `sp_Webapi_Get_MarketByTerritoryId`, `sp_Webapi_Get_MenuPermissionRolewise`, `sp_Webapi_Get_MileageAppData`, `sp_Webapi_Get_MileageClaimList`, `sp_Webapi_Get_MileageDetailsByID`, `sp_WebAPI_Get_MioDashboardTopBarData_New`, `sp_WebAPI_Get_MioDashboardTopBarData_New_old`, `sp_WebAPI_Get_MioDashboardTopBarData_OrdAtt`, `sp_WebAPI_Get_MioDashboardTopBarDataWithoutOrd_Att`, `sp_Webapi_Get_NonEffectiveReason`, `sp_Webapi_Get_OnOffButtonForCustomerChange`, `sp_Webapi_Get_OnOffButtonForCustomerChange_MS`, `sp_Webapi_Get_OnOffButtonForDocChange`, `sp_Webapi_Get_OnOffButtonForDocChange_MS`, `sp_Webapi_Get_OrderDetailsById`, `sp_WebAPI_Get_OrderinfoData_ById`, `sp_Webapi_Get_PresCripProductbyId`, `sp_Webapi_Get_PrescriptionApp`, `sp_Webapi_Get_PrescriptionByPrescriptionIdId`, `sp_Webapi_Get_PrescriptionDetails_AppLog`, `sp_Webapi_Get_PrescriptionList`, `sp_WebAPi_Get_PrescriptionType`, `sp_Webapi_Get_ProductGiftInactivePro`, `sp_Webapi_Get_ProductInactiveName`, `sp_Webapi_Get_ProductPrice`, `sp_Webapi_Get_ProductPriceOld`, `sp_Webapi_Get_ProgramType`, `sp_Webapi_Get_ProviderType`, `sp_Webapi_Get_PunchInOutStatus`, `sp_Webapi_Get_RSM_DZSMByRole`, `sp_Webapi_Get_RSM_DZSMcheck`, `sp_webapi_Get_SampleStockReport`, `sp_webapi_Get_SampleStockReport_new`, `sp_Webapi_Get_Sation`, `sp_Webapi_Get_Shift`, `sp_Webapi_Get_SMCType`, `sp_webapi_Get_StockReport`, `sp_Webapi_Get_SubMarketByMarketId`, `sp_Webapi_GET_TADAAmountByUser`, `sp_Webapi_Get_TADAAppData`, `sp_Webapi_Get_TADAClist`, `sp_WebAPI_Get_TargetAChivementReport`, `sp_Webapi_Get_TargetVsAcchivementData`, `sp_Webapi_Get_Thana`, `sp_Webapi_Get_TodaysTask`, `sp_Webapi_Get_TodaysTaskforDCPCCP`, `sp_Webapi_Get_TourPlanApp`, `sp_Webapi_Get_TourPlanDataForTadaClaim`, `sp_Webapi_Get_TourPlanInfo`, `sp_Webapi_Get_TourPlanInfo_New`, `sp_Webapi_Get_TourPlanInfo_Vthree`, `sp_Webapi_Get_TourPlanInfoDetail`, `sp_Webapi_Get_TourPlanInfoDetail_new`, `sp_Webapi_Get_TourPlanMasterData`, `sp_Webapi_Get_TourPlanPurpose`, `sp_Webapi_Get_TourPlanPurposeForMarketVisit`, `sp_Webapi_Get_TourPlanPurposeForOtherVisit`, `sp_Webapi_Get_TourPlanType`, `sp_Webapi_Get_TourTourPlanDetails`, `sp_Webapi_Get_TPCustomerDetailList`, `sp_Webapi_Get_TPMarketDetailList`, `sp_Webapi_Get_TransportList`, `sp_Webapi_Get_UserByRoleId`, `sp_Webapi_Get_Userrole`, `sp_Webapi_Get_VisitPlanApp`, `sp_Webapi_Get_VisitTypeForDcr`, `sp_Webapi_GET_WeekofYear`, `sp_webapi_GetAllProducts`, `sp_webapi_GetAllSampleProducts`, `sp_WebAPI_GetAttendanceData_New`, `sp_Webapi_GetBounsGiftList`, `sp_Webapi_GetCampaignCustomer`, `sp_Webapi_GetCampaignData`, `sp_Webapi_GetCampaignDetail`, `sp_Webapi_GetCampaignDetail_IsRatioInc`, `sp_Webapi_GetCampaignFCFSCampainType`, `sp_Webapi_GetCampaignTradePolicyPerc`, `sp_Webapi_GetCampaignType3rd`, `sp_Webapi_GetCampaignType3rd_WithoutTrade`, `sp_Webapi_GetCollectionList`, `sp_webapi_GetCustomerbyMobileNO`, `sp_webapi_GetCustomerbyUser`, `sp_webapi_GetCustomerbyUserOld`, `sp_webapi_GetCustomerList`, `sp_webapi_GetCustomerListByCusId`, `sp_Webapi_GetCustWiseOrderReport`, `sp_Webapi_GetCustWiseOrderReport_L`, `sp_Webapi_GetCustWiseOrderReportSum`, `sp_Webapi_GetCustWiseSalesReport`, `sp_Webapi_GetCustWiseSalesReport_L`, `sp_Webapi_GetCustWiseSalesReport_New`, `sp_Webapi_GetCustWiseSalesReportSum`, `sp_Webapi_GetDashboardSummary`, `sp_Webapi_GetDashboardTiles`, `sp_Webapi_GetDCStoreStockList`, `sp_webapi_GetDoctorVisitDateById`, `sp_webapi_GetDoctorVisitPlanMasterById`, `sp_webapi_GetDWSPDateById`, `sp_webapi_GetDWSPDetailById_new`, `sp_webapi_GetDWSPMasterById`, `sp_Webapi_GetEmpInfoRoleID`, `sp_webapi_GetmarketNotice_ByEmpId`, `sp_Webapi_GetMorningEveningTime`, `sp_Webapi_GetNotification`, `sp_Webapi_GetNotificationCount`, `sp_Webapi_GetOrder_TrackingList`, `sp_Webapi_GetOrder_TrackingListSummary`, `sp_webapi_GetOrderCustMasterById`, `sp_WebAPi_GetOrderDetails_New`, `sp_webapi_GetOrderMasterById`, `sp_Webapi_GetOtherMarketVisitListTourPlanEditbyId`, `sp_Webapi_GetProductWiseOrderReport`, `sp_Webapi_GetProductWiseOrderReport_L`, `sp_Webapi_GetProductWiseOrderReportSum`, `sp_Webapi_GetProductWiseSalesReport`, `sp_Webapi_GetProductWiseSalesReport_L`, `sp_Webapi_GetProductWiseSalesReportSum`, `sp_webapi_GetTADAAppDataById`, `sp_Webapi_GetTeamList`, `sp_Webapi_GetTerritoryByEmpId`, `sp_webapi_GetTourPlanDateById`, `sp_webapi_GetTourPlanDetailById`, `sp_webapi_GetTourPlanDetailById_new`, `sp_Webapi_GetTourPlanEditbyId`, `sp_Webapi_GetTourPlanForWorkedwith`, `sp_Webapi_GetTourPlanForWorkedwithCopy`, `sp_webapi_GetTourPlanMasterById`, `sp_webapi_GetTourPlanStatus`, `sp_webapi_GetTraning_ByEmpId`, `sp_webapi_GetvisitPlanDetailById_new`, `sp_Webapi_LeaveReport`, `sp_Webapi_NotificationAllsent`, `sp_Webapi_NotificationPost`, `sp_WEBAPI_Process_DWSPReport`, `sp_WEBAPI_Process_DWSPReportAM`, `sp_WEBAPI_Process_DWSPReportDZSM`, `sp_Webapi_Save_Customer`, `sp_Webapi_Save_DcrBrand`, `sp_Webapi_Save_DcrInfo`, `sp_Webapi_Save_DcrProduct`, `sp_Webapi_Save_DcrVisitedWith`, `sp_Webapi_Save_DCStoreTransaction`, `sp_Webapi_Save_DoctorBrandDetail`, `sp_Webapi_Save_DoctorChemberDetail`, `sp_Webapi_Save_DoctorContactDetail`, `sp_Webapi_Save_DoctorDegreeDetail`, `sp_Webapi_Save_DoctorEntry`, `sp_Webapi_Save_DoctorInstitutionDetail`, `sp_Webapi_Save_DoctorSpecialDayDetail`, `sp_Webapi_Save_DoctorSpecialityDetail`, `sp_Webapi_Save_DoctorTypeDetail`, `sp_Webapi_Save_DWSPMaster`, `sp_Webapi_Save_EmpAppVersion`, `sp_Webapi_Save_ExpenseClaimDetails`, `sp_Webapi_Save_ExpenseClaimMaster`, `sp_Webapi_Save_ExpenseClaimMasterissue`, `sp_Webapi_Save_ExpenseClaimMasterOlddddddd`, `sp_Webapi_Save_MileageClaim`, `sp_Webapi_Save_Prescription`, `sp_Webapi_Save_PrescriptionDetail`, `sp_Webapi_Save_SynchronizationInfo`, `sp_Webapi_Save_TadaClaim`, `sp_Webapi_Save_TourPlanInfo`, `sp_Webapi_Save_TourPlanInfo_Doctor`, `sp_Webapi_Save_TourPlanInfo_Doctor_New`, `sp_Webapi_Save_TourPlanInfo_new`, `sp_Webapi_Save_TourPlanInfo_vThree`, `sp_Webapi_Save_TPCustomerDetail`, `sp_Webapi_Save_TPMarketDetail`, `sp_Webapi_Save_UserDeviceToken`, `sp_Webapi_Save_UserTracking`, `sp_webapi_SaveDWSPLog`, `sp_WebApi_SaveEPharmaPersonInfo`, `sp_webapi_SaveExpanseAppLog`, `sp_webapi_SaveMileageAppLog`, `sp_webapi_SaveOrderCampaign`, `sp_webapi_SaveOrderDetail`, `sp_webapi_SaveOrderDetail_Doctor`, `sp_webapi_SaveOrderDetail_Temp`, `sp_webapi_SaveOrderMaster`, `sp_webapi_SaveOrderMaster_Doctor`, `sp_WebApi_SaveProviderDropoutIntrigration`, `sp_webapi_SavePunchInInfo`, `sp_webapi_SavePunchoutInfo`, `sp_webapi_SavePunchTotalInfo`, `sp_webapi_SaveTADAAppLog`, `sp_Webapi_UD_DoctorEntry`, `sp_Webapi_UD_LeaveInfo`, `sp_Webapi_Update_Customer`, `sp_Webapi_Update_CustomerBSP`, `sp_Webapi_Update_DoctorFinalSubmit`, `sp_Webapi_Update_ExpenseClaim`, `sp_Webapi_Update_MileageClaim`, `sp_Webapi_Update_OrderMaster`, `sp_Webapi_Update_Password`, `sp_Webapi_UpdateCustomerMarket`, `sp_Webapi_UpdateCustomerProvider`, `sp_Webapi_UpdateDoctorMarket`, `sp_Webapi_UpdateDoctorProvider`, `sp_Webapi_UpdateNotice_EmployeeReadByEmpIdMasterId`, `sp_Webapi_UpdateNotificationRead`, `sp_Webapi_UpdateTraining_EmployeeReadByEmpIdMasterId`, `spGetPersonByDivisionDistrict`, `spGetProviderTypeDeliveryNetAmointIntrigration`, `spInsertReturnInvoice`, `spUpdateTourPurposeOtherSetup`, `usp_CheckCampaignList`, `usp_CheckCampaignListByCustomerMasterId`, `usp_GenerateCustomerCode`, `usp_InsertUOMWithConversion`, `usp_UpdateDistributionRoute_Ord`, `View_Dashboard_BI`

## View inventory (58)

| View | Referenced in C#? | Referenced in another proc/view? | Tables/views joined | Source |
|---|---|---|---|---|
| `DWSPMasterTerritoryDATA` | No | No | tblASMInfo, tblArea, tblDesignation, tblEmpGeneralInfo, tblMIOInfo, tblRegion, tblTerritory, tblUser | `spec/database/views/DWSPMasterTerritoryDATA.sql` |
| `v_ProductALLInfo` | No | No | tblCompanyUnit, tblGenericGroup, tblManufacturer, tblPackSize, tblProCategory, tblProType, tblProduct, tblProductCase | `spec/database/views/v_ProductALLInfo.sql` |
| `View_AccountsReceivable_BIReport` | No | No | tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/views/View_AccountsReceivable_BIReport.sql` |
| `View_AllStock` | No | Yes | View_CentralStoreCurrentStock, View_DCStoreCurrentStock, tblStockInTransfar | `spec/database/views/View_AllStock.sql` |
| `View_BusinessSummary` | No | No | tblCompanyUnit, tblInvoice, tblInvoiceDetail | `spec/database/views/View_BusinessSummary.sql` |
| `View_CentralStoreCurrentStock` | Yes | Yes | tblCentralStore, tblProduct | `spec/database/views/View_CentralStoreCurrentStock.sql` |
| `View_CustomerAging_BIReport` | No | No | tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/views/View_CustomerAging_BIReport.sql` |
| `View_CustomerDCP` | No | Yes | tblCustMaster, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorSpeciality, tblDoctorSpecialityDetail, tbl_DoctorTourPlanDetail, tbl_DoctorTourPlanMaster | `spec/database/views/View_CustomerDCP.sql` |
| `View_CustomerForModification` | Yes | No | tblArea, tblCompanyUnit, tblCustCategory, tblCustMaster, tblDistrict, tblMIAInfo, tblMarket, tblRegion | `spec/database/views/View_CustomerForModification.sql` |
| `View_CustomerMaster` | Yes | Yes | tblASMInfo, tblArea, tblCustMaster, tblCustomerType, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo | `spec/database/views/View_CustomerMaster.sql` |
| `View_CustomerMaster_ActiveInactive` | No | Yes | tblASMInfo, tblArea, tblCustMaster, tblCustomerType, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo | `spec/database/views/View_CustomerMaster_ActiveInactive.sql` |
| `View_CustomerMasterOld` | No | No | tblArea, tblCompanyUnit, tblCustCategory, tblCustMaster, tblDistrict, tblMIAInfo, tblMarket, tblRegion | `spec/database/views/View_CustomerMasterOld.sql` |
| `View_CustomerName` | No | No | tblCustMaster | `spec/database/views/View_CustomerName.sql` |
| `View_CVR` | No | Yes | tblCustMaster, tblCustomerType, tblProgramType, tbl_DCRInfo | `spec/database/views/View_CVR.sql` |
| `View_DCP` | No | Yes | tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail, tblDoctorType, tblProgramType, tbl_DoctorTourPlanDetail | `spec/database/views/View_DCP.sql` |
| `View_DCR` | No | Yes | tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail, tblDoctorType, tblProgramType, tbl_DCRInfo | `spec/database/views/View_DCR.sql` |
| `View_DCStoreCurrentStock` | Yes | Yes | tblDCStore, tblProduct | `spec/database/views/View_DCStoreCurrentStock.sql` |
| `View_DepotName` | No | No | tblCompanyUnit | `spec/database/views/View_DepotName.sql` |
| `View_DoctorMaster` | No | Yes | tblASMInfo, tblArea, tblDoctorChemberDetail, tblDoctorContactDetail, tblDoctorMaster, tblDoctorType, tblEmpGeneralInfo, tblMIOInfo | `spec/database/views/View_DoctorMaster.sql` |
| `View_DoctorMasterActiveInactive` | No | No | tblArea, tblDoctorChemberDetail, tblDoctorContactDetail, tblDoctorDegree, tblDoctorDegreeDetail, tblDoctorMaster, tblDoctorSpeciality, tblDoctorSpecialityDetail | `spec/database/views/View_DoctorMasterActiveInactive.sql` |
| `view_EmpList` | No | No | tblEmpGeneralInfo | `spec/database/views/view_EmpList.sql` |
| `View_EpharmaSales2022April` | No | No | tblCompanyUnit, tblCustMaster, tblCustomerType, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblStockUOM | `spec/database/views/View_EpharmaSales2022April.sql` |
| `View_EpharmaSales2023` | No | No | tblCompanyUnit, tblCustMaster, tblCustomerType, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblStockUOM | `spec/database/views/View_EpharmaSales2023.sql` |
| `View_EpharmaSales2024` | No | No | tblCompanyUnit, tblCustMaster, tblCustomerType, tblInvoice, tblInvoiceDetail, tblOrder, tblProduct, tblStockUOM | `spec/database/views/View_EpharmaSales2024.sql` |
| `View_FieldForceArea` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion, tblTerritory | `spec/database/views/View_FieldForceArea.sql` |
| `View_FieldForceAsm` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceAsm.sql` |
| `View_FieldForceGroup` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceGroup.sql` |
| `View_FieldForceMarket` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceMarket.sql` |
| `View_FieldForceMio` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceMio.sql` |
| `View_FieldForceNsm` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceNsm.sql` |
| `View_FieldForceRegion` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceRegion.sql` |
| `View_FieldForceRsm` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_FieldForceRsm.sql` |
| `View_FieldForceSubTerritory` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion, tblSubTerritory | `spec/database/views/View_FieldForceSubTerritory.sql` |
| `View_FieldForceTerritory` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion, tblTerritory | `spec/database/views/View_FieldForceTerritory.sql` |
| `View_MIAWiseSalesReport` | Yes | No | tblInvoice, tblInvoiceDetail | `spec/database/views/View_MIAWiseSalesReport.sql` |
| `View_MIOName` | No | No | tblEmpGeneralInfo, tblMIOInfo | `spec/database/views/View_MIOName.sql` |
| `View_OrderCustomerInfo` | Yes | No | tblArea, tblCompanyUnit, tblCustMaster, tblCustomerType, tblEmpGeneralInfo, tblMarket, tblOrder, tblProgramType | `spec/database/views/View_OrderCustomerInfo.sql` |
| `View_OrderInfo_BIReport` | No | No | tblOrder, tblOrderDetail | `spec/database/views/View_OrderInfo_BIReport.sql` |
| `View_ProDCStock` | Yes | No | tblCompanyUnit, tblDCStore | `spec/database/views/View_ProDCStock.sql` |
| `View_ProductCoverage_BIReport` | No | No | tblCompanyUnit, tblCustMaster, tblCustPayDetail, tblCustomertype, tblDCStore, tblInvoice, tblInvoiceDetail, tblMarket | `spec/database/views/View_ProductCoverage_BIReport.sql` |
| `View_ProductName` | No | No | tblProduct | `spec/database/views/View_ProductName.sql` |
| `View_ProductWiseSales_BIReport` | No | No | tblInvoice, tblInvoiceDetail, tblOrder, tblProduct | `spec/database/views/View_ProductWiseSales_BIReport.sql` |
| `View_ProformaInvoiceReportList` | No | Yes | tblCompanyUnit, tblCustomerType, tblDCStore, tblEmpGeneralInfo, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail | `spec/database/views/View_ProformaInvoiceReportList.sql` |
| `View_Return_BIReport` | No | No | tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/views/View_Return_BIReport.sql` |
| `View_Sales_BIReport` | No | No | tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail, tblProgramType | `spec/database/views/View_Sales_BIReport.sql` |
| `View_SalesCollectionDue_BIReport` | No | No | tblCustPayDetail, tblInvoice, tblInvoiceDetail, tblOrder | `spec/database/views/View_SalesCollectionDue_BIReport.sql` |
| `View_SampleCurrentStock` | No | Yes | tblGroupWisePromoQty, tblProduct | `spec/database/views/View_SampleCurrentStock.sql` |
| `VIew_SubDepotCurrentStock` | Yes | No | tblProduct, tblSubDepotStore | `spec/database/views/VIew_SubDepotCurrentStock.sql` |
| `View_TargetvsAchivement_BIReport` | No | No | tblArea, tblInvoice, tblInvoiceDetail, tblOrder, tblRegion, tblTerritory, tblTerritoryDataMigration, tbl_Group | `spec/database/views/View_TargetvsAchivement_BIReport.sql` |
| `View_TargetvsAchivment_2023to2024` | No | No | GetMonthYearValuesDateRange, tblArea, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail, tblRegion, tblTerritory | `spec/database/views/View_TargetvsAchivment_2023to2024.sql` |
| `View_TotalCurrentStockofCompanyWithStockInTransfar` | Yes | No | View_AllStock | `spec/database/views/View_TotalCurrentStockofCompanyWithStockInTransfar.sql` |
| `View_Webapi_EmployeeFieldForceInfo` | Yes | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion, tblTerritory | `spec/database/views/View_Webapi_EmployeeFieldForceInfo.sql` |
| `View_Webapi_EmployeeFieldForceInfo_Collection` | No | No | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion, tblTerritory | `spec/database/views/View_Webapi_EmployeeFieldForceInfo_Collection.sql` |
| `View_Webapi_EmployeeFieldForceInfo_Top1` | Yes | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblNSMInfo, tblRSMInfo, tblRegion, tblTerritory | `spec/database/views/View_Webapi_EmployeeFieldForceInfo_Top1.sql` |
| `View_webapi_FieldForce` | No | Yes | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_webapi_FieldForce.sql` |
| `View_webapi_FieldForce_Test` | No | No | tblASMInfo, tblArea, tblEmpGeneralInfo, tblMIOInfo, tblMarket, tblNSMInfo, tblRSMInfo, tblRegion | `spec/database/views/View_webapi_FieldForce_Test.sql` |
| `View_ZoneName` | No | No | tblRegion | `spec/database/views/View_ZoneName.sql` |
| `vw_TargetvsAchievement_BIReport` | No | No | tblArea, tblInvoice, tblInvoiceDetail, tblOrder, tblOrderDetail, tblRegion, tblTerritoryDataMigration | `spec/database/views/vw_TargetvsAchievement_BIReport.sql` |

## Function inventory (43: 11 scalar, 32 table-valued)

| Function | Referenced in C#? | Referenced in another proc/view? | Params | Source |
|---|---|---|---|---|
| `CheckMobileNumber` | No | No | @MobileNumber VARCHAR | `spec/database/functions/CheckMobileNumber.sql` |
| `DateRange_To_Table` | No | Yes | @minDate_Str NVARCHAR, @maxDate_Str NVARCHAR, @Result TABLE | `spec/database/functions/DateRange_To_Table.sql` |
| `DateRange_To_TableByMonthYear` | No | Yes | @MonthVal nvarchar, @YearVal nvarchar, @Result TABLE | `spec/database/functions/DateRange_To_TableByMonthYear.sql` |
| `DateRange_To_TableSL` | No | Yes | @minDate_Str NVARCHAR, @maxDate_Str NVARCHAR, @Result TABLE | `spec/database/functions/DateRange_To_TableSL.sql` |
| `DelimitedSplit8K` | No | No | @pString VARCHAR, @pDelimiter CHAR | `spec/database/functions/DelimitedSplit8K.sql` |
| `EmployeeSale` | No | Yes | @MasterTable TABLE | `spec/database/functions/EmployeeSale.sql` |
| `F_DateName` | No | Yes | @FromDate NVARCHAR, @ToDate NVARCHAR, @MasterTable TABLE | `spec/database/functions/F_DateName.sql` |
| `F_FIRST_N_WEEKDATES` | No | No | @A_DATE DATETIME2, @N TINYINT, @T TABLE | `spec/database/functions/F_FIRST_N_WEEKDATES.sql` |
| `F_MonthName` | No | Yes | @FromDate NVARCHAR, @ToDate NVARCHAR, @MasterTable TABLE | `spec/database/functions/F_MonthName.sql` |
| `F_ProductName` | No | Yes | @MasterTable TABLE | `spec/database/functions/F_ProductName.sql` |
| `F_ProductNameFromEmpSale` | No | Yes | @MasterTable TABLE | `spec/database/functions/F_ProductNameFromEmpSale.sql` |
| `fn_CleanRows` | No | No | @RowName NVARCHAR | `spec/database/functions/fn_CleanRows.sql` |
| `fn_GetExistenceStatus` | No | No | @CellNo NVARCHAR | `spec/database/functions/fn_GetExistenceStatus.sql` |
| `fn_GetTerritoryInfo` | No | No | @RoleType NVARCHAR, @EmpId INT, @TerritoryInfo TABLE | `spec/database/functions/fn_GetTerritoryInfo.sql` |
| `fn_GetTerritoryInfo_Optimized` | No | No | @RoleType NVARCHAR, @EmpId INT | `spec/database/functions/fn_GetTerritoryInfo_Optimized.sql` |
| `fn_GetTotalCountForEmployee` | No | No | @currentDate DATETIME, @EmpId INT, @resultTable TABLE | `spec/database/functions/fn_GetTotalCountForEmployee.sql` |
| `fn_split_string_to_column` | No | Yes | @string NVARCHAR, @delimiter CHAR, @out_put TABLE | `spec/database/functions/fn_split_string_to_column.sql` |
| `fnSplit` | No | Yes | @sInputList VARCHAR, @sDelimiter VARCHAR, @List TABLE | `spec/database/functions/fnSplit.sql` |
| `GetBookQuantityByDCStore` | No | No | @DCStoreId INT | `spec/database/functions/GetBookQuantityByDCStore.sql` |
| `GetBookQuantityByDCStored` | No | No | @DCStoreId INT, @ResultTable TABLE | `spec/database/functions/GetBookQuantityByDCStored.sql` |
| `GetBookQuantityByDCStoreId` | No | No | @DCStoreId INT | `spec/database/functions/GetBookQuantityByDCStoreId.sql` |
| `GetCampaignCustomer` | No | Yes | @CutstomerType INT, @MasterTable TABLE | `spec/database/functions/GetCampaignCustomer.sql` |
| `GetCampaignCustomerback` | No | No | @CutstomerType INT, @MasterTable TABLE | `spec/database/functions/GetCampaignCustomerback.sql` |
| `GetCampaignCustomerlasst` | No | No | @CutstomerType INT, @MasterTable TABLE | `spec/database/functions/GetCampaignCustomerlasst.sql` |
| `GetCampaignCustomerlast` | No | No | @CutstomerType INT | `spec/database/functions/GetCampaignCustomerlast.sql` |
| `GetCampaignCustomermm` | No | No | @CutstomerType INT | `spec/database/functions/GetCampaignCustomermm.sql` |
| `GetCampaignCustomernn` | No | No | @CutstomerType INT, @MasterTable TABLE | `spec/database/functions/GetCampaignCustomernn.sql` |
| `GetCampaignEmployee` | No | Yes | @MasterTable TABLE | `spec/database/functions/GetCampaignEmployee.sql` |
| `GetDateWiseSale` | No | Yes | @FromDate NVARCHAR, @ToDate NVARCHAR, @MasterTable TABLE | `spec/database/functions/GetDateWiseSale.sql` |
| `GetDayes` | No | Yes | @MasterTable TABLE | `spec/database/functions/GetDayes.sql` |
| `GetDCwiseStock` | No | Yes | @MasterTable TABLE | `spec/database/functions/GetDCwiseStock.sql` |
| `GetEmployeeNameFunc` | No | No | @EmployeeIds VARCHAR | `spec/database/functions/GetEmployeeNameFunc.sql` |
| `GetmonthlycustomerSaleDate` | Yes | No | @FromDate DATETIME, @ToDate DATETIME | `spec/database/functions/GetmonthlycustomerSaleDate.sql` |
| `GetMonthWiseSale` | No | Yes | @FromDate NVARCHAR, @ToDate NVARCHAR, @MasterTable TABLE | `spec/database/functions/GetMonthWiseSale.sql` |
| `GetMonthYearValuesDateRange` | No | Yes | @From_Date DATE, @To_Date DATE | `spec/database/functions/GetMonthYearValuesDateRange.sql` |
| `GetRoleTypesFunc` | No | No | @RoleTypeIds VARCHAR | `spec/database/functions/GetRoleTypesFunc.sql` |
| `GetVat` | No | No | @FromDate DATETIME, @ToDate DATETIME, @IssueChalanNo NVARCHAR | `spec/database/functions/GetVat.sql` |
| `MainMenu` | Yes | No | @UserId INT | `spec/database/functions/MainMenu.sql` |
| `MainMenu2` | Yes | No | @UserId INT, @UserRoleID INT | `spec/database/functions/MainMenu2.sql` |
| `MonthValueToName` | No | No | @MonthValue INT | `spec/database/functions/MonthValueToName.sql` |
| `parseJSON` | No | Yes | @JSON NVARCHAR, @hierarchy TABLE | `spec/database/functions/parseJSON.sql` |
| `Remove_SpecialCharacters` | No | No | @str VARCHAR | `spec/database/functions/Remove_SpecialCharacters.sql` |
| `TimeDifference` | No | No | @FromTime TIME, @ToTime TIME | `spec/database/functions/TimeDifference.sql` |

## Module deep-dives (business logic narrative)

> Populated from six parallel source-code + stored-procedure-body analyses (one per module cluster below), each verified against the live database and cross-referenced against real C# call sites. Full rule-by-rule detail with file:line citations lives in `spec/business-rules.md` §0.1 and `spec/workflow.md`; this section anchors each module's headline findings back to the specific procedures in the mechanical inventory above.

### SInventory (176 procs, `SInventory_DAL`/`ChartDAL`/`SInventory_UI`)

Core order→proforma→invoice→delivery→payment→collection lifecycle. Key procs and their real behavior (full detail: `spec/business-rules.md` §1 and §0.1, `spec/workflow.md` §4):
- `sp_Process_ProformaInvoiceByOrderId` / `sp_AutoInvoiceGeneration` — order-to-invoice conversion; FEFO batch stock allocation; the former is properly transactional with a re-entrancy guard (confirmed **live**, not a staged patch, via direct `OBJECT_DEFINITION()` query against the database), the latter is cursor-based with no transaction at all.
- `sp_UP_LoadingSummary` — the actual orchestration hub chaining delete-proforma/delivery-confirm/payment-confirm procs with no shared transaction; not previously documented anywhere in this spec set before this pass.
- `sp_Delete_ProformaInvoice`/`_SubDeport` — reverses stock on proforma deletion; also confirmed live.
- `sp_RejectInvoiceDA{SalesConfirmStatus,PaymentCollection,SalesReturn}` — three DA-side reject procs that look identical by name but aren't: the Payment one silently fails to update its status column (see `workflow.md` §4.3).
- `sp_Deletenvoice` — dead/broken body (`delete Invoice`, no `FROM`), still called from live C# — open question whether ever actually exercised.
- Security: 105 of 114 `SInventory_DAL` C# files build raw inline SQL via string literals executed through `ClsCommonInternalDAL.DataContainerDataTable`, bypassing stored procs entirely; 47 of 176 procs in this module build dynamic SQL from a `@param` fragment that 44 `SInventory_UI` pages construct via string concatenation of dropdown/hidden-field postback values.

### DoctorModule (513 procs combined: `DoctorModule_DAL` + `DoctorVisit_DAL`/`DoctorMaster_DAL`/`DoctorInfo_DAL`/`Doctor_Monitoring_DAL`)

Field-force org hierarchy, tour/visit planning, DCR, prescriptions, leave/attendance/expense claims. Full detail: `spec/business-rules.md` §2 and §0.1, `spec/workflow.md` §2a.
- Two-to-three parallel approval mechanisms coexist for Tour Plan/Visit Plan/Prescription/Attendance (chain-based routing engine vs. a legacy bulk `sp_Approve*` proc family) — see `workflow.md` §2a for the live/dead audit of each.
- `sp_check_Vali_MarketStructure`, `sp_Save_UserMarketDetail`, `sp_Update_CustomerInfoForMarketData`, `sp_opeingBalanceCreate` — each carries a confirmed logic bug (dead branch, missing idempotency delete, unfiltered cascade, broken NULL-date defaulting, respectively) — see `business-rules.md` §0.1 for detail on each.
- `Setup2DAL.cs`/`SetupDAL.cs`/`SetupDAL_daaw.cs` are whole-file duplicates differing only by connection manager — a bug fixed in one is not automatically fixed in its siblings.
- Security (most actionable finding of the whole re-analysis): `DoctorVisitReport.aspx.cs` and `AttendanceInfoList.aspx.cs` expose `[WebMethod]`s that forward a client-supplied filter string, unvalidated, into procs executing `EXEC(@Query)`/`sp_executesql` — the Attendance one additionally skips the page's own row-level hierarchy-scoping logic entirely, letting any authenticated user view any employee's attendance regardless of role.

### MasterSetup / Thana / SubDepot (298 procs: `MasterSetup_DAL`/`Thana_DAL`/`SubDepot_DAL`)

Customer/product/geography/org master data plus sub-depot transactional operations. Full detail: `spec/business-rules.md` §3 and §0.1.
- Duplicate-name checks are applied on UPDATE but not INSERT across at least 8 entities (District/Thana/CustomerType/StationType/ProgramType/SMCType/Customer Master/DA) — a systemic, not isolated, gap.
- `sp_Update_CustomerMaster` derives a customer's `DivisionId` from a mis-keyed join in its second (actually-applied) geography-derivation block — likely produces wrong/NULL values on every customer edit.
- `sp_ApproveCustomerInformation` will likely error at runtime (`CAST` against a prefixed customer code); the Doctor leg of `sp_Update_Customer_Doctor_TransferApprove` is confirmed dead code (entire mutation branch commented out).
- **`SubDepot_DAL` is confirmed to use zero stored procedures across ~800 concatenation sites in 5 files** — the most severe SQL-injection surface found anywhere in this codebase, architecturally distinct from (and worse than) the rest of the system's `EXEC(@Query)`-dispatcher pattern because it doesn't even route through that dispatcher — it builds and executes ad-hoc SQL text directly.

### Transactional modules (73 procs: DWSP/SAP/PromoAlloc/Transfer/MarketUpload/SettingPanel/UserRole/InternalCls)

Full detail: `spec/business-rules.md` §0.1, `spec/workflow.md` §5a, `spec/integrations.md` §1/§1a-revised.
- `Library.DAL/InternalCls/ClsCommonInternalDAL.cs` is confirmed to be a generic dynamic-SQL dispatcher: its "stored procedure" call target, `ExecuteAllSqlQueryByStoreProcedure`, has a live body of exactly `EXEC (@Query)`. This is the mechanism behind the majority of this codebase's raw-SQL-concatenation findings across every module, not a one-off.
- `MakeRESTRequest` — genuinely live outbound HTTPS call to SAP via SQL Server OLE Automation, hardcoded plaintext credentials in the proc body, called from live (non-commented) C# with the failure path silently swallowed at both layers.
- `sp_Update_MarketStructure_Transfer` — confirmed missing `Area`/`Zone` branches, causing 2 of 6 `TransferUI` screens to report success while persisting nothing (compounded by `DataAccessManager.ExecuteNonQueryVoid` never checking rows-affected).
- Permission/approval-routing tables (`tblMenuRole`, `tblApprovalMapMaster`/`Detail`) are updated via non-atomic delete-then-reinsert with no transaction wrapping.

### Platform/Auth (menu/permission/login) + all 58 views + all 43 functions

Full detail: `spec/business-rules.md` §0.1, `spec/api-spec.md`, `spec/integrations.md` §3-4. Every one of the 58 views and 43 functions in the mechanical inventory above was individually read for this pass; headline findings not visible from the mechanical tables alone: three overlapping, independently-superadmin-bypassed menu/permission generations coexist (`tblMainMenu`/`tblMenuDistribution` legacy, a SQL-function mirror of the same, and the current `tblMainMenuNew`/`tblMenuRole` system, the last of which itself has an internal inconsistency — its deepest sub-menu level reads the stale legacy assignment table); per-page authorization beyond "a session exists" is opt-in and applied to only a minority of the ~700 pages in the application; `View_BusinessSummary` is frozen to a hardcoded May-2018 date range; several near-duplicate view/function families exist (campaign-eligibility has 6 variants, only 1 — `GetCampaignCustomer`, 9 confirmed callers — is live; the others range from abandoned simplifications to unshipped improvements with zero callers).

_(populated in a later pass — see `spec/business-rules.md`, `spec/workflow.md`, `spec/modules.md` for the narrative content; this file's job is the complete mechanical inventory above)_
