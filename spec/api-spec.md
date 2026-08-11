# API Spec

This is the definitive catalog of every HTTP-callable endpoint in `Solution.Web`. Per `CLAUDE.md`:
this codebase has **no single API gateway or controller layer** — there is no ASP.NET Web API
(`ApiController`), no `WebApiConfig`, and no OpenAPI/Swagger definition anywhere in the repository
(confirmed by grep across the whole tree). Instead the API surface that the companion Flutter
mobile app and jQuery autocomplete widgets call is fragmented across three mechanisms:

1. One shared **`.asmx`/`[ScriptService]`** class (`SInventoryWebService`), mounted at three
   different URLs.
2. Three **`.ashx`** (`IHttpHandler`) files for binary/file upload traffic.
3. **459 inline `[WebMethod]` static methods across 116 `.aspx.cs` files** — ASP.NET's "page
   methods" feature, invoked via `PageName.aspx/MethodName` from jQuery (`$.ajax`-style calls) and
   jQuery UI Autocomplete `source:` callbacks. Scattered across every `*_UI` folder, never
   consolidated.

There is no consistent auth scheme across any of this: everything relies on an ASP.NET Forms
`Session` already being populated by a prior page login; several methods throw
`NullReferenceException` if invoked without one. No API-key/token auth, no rate limiting, no
versioning.

**Verification note (this revision):** this catalog was re-checked by directly reading
`SInventoryWebService.cs` in full alongside all three `.ashx` handlers — every entry below was
confirmed accurate, no discrepancies found. One clarification worth surfacing: `CLAUDE.md` describes
`SInventoryWebService` as what "the Flutter app and jQuery autocomplete widgets call," but every one
of its 21 methods is shaped as a plain-string-array typeahead query with no JSON envelope,
pagination, or versioning — a mobile app consuming this directly would be unusual. The far more
likely mobile-facing data layer is the `sp_Webapi_*`/`sp_SalesAPI_*` stored-procedure family (see
[`integrations.md`](integrations.md) §4), but no REST/controller code exposing that family over HTTP
was found anywhere in this repository — so `CLAUDE.md`'s specific claim about this service remains
unresolved rather than confirmed or refuted.

## 1. `.asmx` service — `SInventoryWebService`

- **Class**: `Solution.Web/App_Code/SInventoryWebService.cs`
- **Mount points** (identical class, three URLs — pick whichever matches the calling page's
  folder): `MasterSetup_UI/SInventoryWebService.asmx`, `SInventory_UI/SInventoryWebService.asmx`,
  `SubDepot_UI/SInventoryWebService.asmx`
- **Protocol**: declared SOAP (`WsiProfiles.BasicProfile1_1`) + `[ScriptService]`; actual usage is
  client-side JS/jQuery UI Autocomplete calls, not SOAP envelopes
- **Auth**: none beyond an active ASP.NET session
- **Data access**: Dapper, connection string `SolutionConnectionStringSSIDB` from `web.config`

| Method | Params | Returns | Session read | Notes |
|---|---|---|---|---|
| `HelloWorld` | — | `string` | none | Health-check stub |
| `GetProductList` | `prefixText` | `string[]` | none | `tblProduct`, Group 1, active only |
| `GetSubDepotInvoiceNo` | `prefixText` | `string[]` | `ComUnitId` | SQL built by string concatenation of `ComUnitId` — injection-shaped |
| `GetProformaInvoiceNo` | `prefixText` | `string[]` | `ComUnitId` | Same concatenation pattern |
| `GetProformaInvoiceNoNew` | `prefixText` | `string[]` | `ComUnitId` | Adds an "N/A" placeholder row via `UNION ALL` |
| `GetPreBatch` | `prefixText` | `string[]` | `ProductId` (read then nulled) | `tblCentralStore` batch lookup |
| `GetAllInvoice` | `prefixText` | `string[]` | `CompIDD` | `tblInvoice`, top 15 |
| `GetProductWithCode` | `prefixText` | `string[]` | none | `tblProduct` |
| `GetCustomer` | `prefixText` | `string[]` | `UserType`, `ComUnitId` | Admin sees all; else scoped to unit |
| `GetCustomer_New` | `prefixText` | `string[]` | none (Admin branch dead-code) | `tblCustMaster`, active, code/name/cell match |
| `GetCustomer_ALL` | `prefixText` | `string[]` | none | Includes inactive rows, labeled `(Inactive)` |
| `GetCustomer_ALL_Active` | `prefixText` | `string[]` | none | Active only, top 25 |
| `GetCustomer_ALL_new` | `prefixText` | `string[]` | none | Near-duplicate of `GetCustomer_ALL_Active` minus the `IsActive` filter |
| `GetCustomer_ALL_ForDIC` | `prefixText` | `string[]` | none | Joined through full market/DC org hierarchy, DIC-scoped |
| `GetCustomer_WithoutGeneral` | `prefixText` | `string[]` | `UserType` | Excludes `ProgramTypeId = 4` for non-admins |
| `GetDoctor_ALL` | `prefixText` | `string[]` | none | `tblDoctorMaster` |
| `GetProduct2` | `prefixText` | `string[]` | none | `Name:Code` format |
| `GetProduct3` | `prefixText` | `string[]` | none | `Code:Name:PackSize` format |
| `GetProductByMenufracturer` | `prefixText`, `contextKey` | `string[]` | none | `contextKey` (AjaxControlToolkit convention) carries manufacturer ID, concatenated into SQL |
| `GetEmpInfo` | `prefixText` | `string[]` | `UserType` | `tblEmpGeneralInfo`, admin vs. unit-scoped |
| `GetProduct` | `prefixText`, `contextKey` | `string[]` | none | Group 1, active only |

Autocomplete methods return `string[]`, each entry pre-formatted for direct display (e.g.
`"CODE : Name"`), not structured JSON objects — the client is expected to split on `:`/`|`
delimiters, and different methods use inconsistent delimiter conventions (`' : '` vs `':'` vs a
trailing `|Id` suffix).

## 2. `.ashx` handlers (`IHttpHandler`)

| Handler | HTTP behavior | Session dependency | Auth |
|---|---|---|---|
| `Solution.Web/PictureHandler.ashx` | GET → binary `image/JPEG` from `Session["ImageBytes"]` | Required (`IRequiresSessionState`) | Session only |
| `Solution.Web/SignatureHandler.ashx` | GET → binary `image/JPEG`; guard checks `Session["ImageBytes"] != null` but then reads `Session["SigImageBytes"]` for the actual bytes (pre-existing inconsistency in the source) | Required | Session only |
| `Solution.Web/SInventory_UI/HandlerDocCV.ashx` | POST (multipart file) → JSON `{name, dbfilename}`; saves upload to `~/UploadFile/{guid}Product_{ext}` via `JavaScriptSerializer` | None | **None found** — no auth check, no file-type/size validation (see [`validation-rules.md`](validation-rules.md) §3) |

`HandlerDocCV.ashx` is the only endpoint in this catalog returning structured JSON rather than a
delimited string or binary image.

## 3. Inline `[WebMethod]` page methods (`.aspx.cs`)

These are ASP.NET "page methods": static `[WebMethod]`-annotated methods on a `.aspx.cs`
code-behind class, invoked from client JS as `PageName.aspx/MethodName`. **459 `[WebMethod]`-tagged
members across 116 files** (a handful are commented out / dead and are excluded below). Grouped by
containing `*_UI` module folder. Params/returns are read directly off each method signature;
purpose is inferred from the method name and is intentionally terse given the volume.

### `Dashboard_UI` (1 file, 28 methods)

All in `AdminDashboard.aspx.cs`, all `public static string` (JSON payload strings for dashboard
charts) unless noted, all take date-range/filter strings (`fromdt`, `todt`, `param`, sometimes
`Brand`/`SSMonthNew`/`SSYearNew`) and return chart-ready JSON.

| Method | Params | Purpose |
|---|---|---|
| `Get_DeptoWiseOrder` | `param` | Dept-wise order chart data |
| `Get_DeptoWiseInvoice` | `param` | Dept-wise invoice chart data |
| `Get_TopBarChartOrder` | `param` | Top-bar KPI: order count |
| `Get_TopBarChartDeliveryAmount` | `param` | Top-bar KPI: delivery amount |
| `Get_TopBarChartRejectionAmount` | `param` | Top-bar KPI: rejection amount |
| `Get_TopBarChartDCR` | `param` | Top-bar KPI: DCR count |
| `Get_TopBarChartTotalRX` | `param` | Top-bar KPI: total prescriptions |
| `Get_TopBarChartTotalAttandence` | `param` | Top-bar KPI: attendance |
| `Get_TopBarChartCustomerCoverage` | `param` | Top-bar KPI: customer coverage |
| `Get_TopBarChartTotalLeave` | `param` | Top-bar KPI: leave count |
| `Get_TopBarChartOrderCount` | `param` | Top-bar KPI: order count |
| `Get_TopBarChartTotalInvoice` | `param` | Top-bar KPI: invoice count |
| `GetTotalInfoByCurrentDate` | `int id` | returns `TotalInfoDAO`, today's summary totals |
| `GetBrandWiseOrderReport` | `fromdt, todt, param` | Brand-wise order report chart |
| `GetBrandWiseOrderReportDayWise` | `fromdt, todt, param, Brand` | Day-wise variant, single brand |
| `GetAttandenceMonthlyReport` | `fromdt, todt, param` | Monthly attendance chart |
| `GetGMPRXReportChartDataDayWise` | `fromdt, todt, param` | GMP prescription report, day-wise |
| `GetGMPVisitReportChartDataDayWise` | `fromdt, todt, param` | GMP visit report, day-wise |
| `GetSalesChartData` | `fromdt, todt, param, SSMonthNew, SSYearNew` | Sales chart |
| `GetSalesRetrunChartData` | `fromdt, todt, param` | Sales return chart |
| `GetOrderChartData` | `fromdt, todt, param, SSMonthNew, SSYearNew` | Order chart |
| `GetCustomerReportChartData` | `fromdt, todt, param, SSMonthNew, SSYearNew` | Customer report chart |
| `GetGMPVisitReportChartData` | `fromdt, todt, param` | GMP visit report |
| `GetNONGMPVisitReportChartData` | `fromdt, todt` | Non-GMP visit report |
| `GetGMPRXReportChartData` | `fromdt, todt, param` | GMP RX report |
| `GetNONGMPRXReportChartData` | `fromdt, todt` | Non-GMP RX report |
| `GetExpanseClaimMonthlyChartData` | `fromdt, todt, param` | Monthly expense claim chart |
| `GetExpanseClaimMonthlyChartDataDayWise` | `fromdt, todt, param` | Day-wise variant |

### `DoctorMaster_UI` (16 files, ~30 methods — corrected this revision, was previously miscounted as "12 files")

CRUD + lookup pairs for doctor-related master data (chambers, categories, degrees, designations,
specialities, patient types, prescription types, special days). Pattern is consistently
`Save_X(XDao dto) -> ResultInfo`, `GetXEditData(int id) -> Xdao`, `Get_X() -> string` (list JSON),
`Delete_X(int Id) -> ResultInfo`.

| File | Method | Params | Purpose |
|---|---|---|---|
| `ChamberType.aspx.cs` | `Save_DoctorChamber` | `DoctorChamber` | save chamber type |
| `ChamberType.aspx.cs` | `GetDoctorDegreeEditDataa` | `int id` | edit-data lookup |
| `ChamberTypeView.aspx.cs` | `Get_Doctor_Chamber` | — | list |
| `ChamberTypeView.aspx.cs` | `Delete_Doctorchamber` | `int Id` | delete |
| `DoctorCategory.aspx.cs` | `Save_DoctorCategory` | `DoctorCategory` | save category |
| `DoctorCategory.aspx.cs` | `GetDoctorCategoryEditData` | `int id` | edit-data lookup |
| `DoctorCategoryView.aspx.cs` | `Get_DoctorCategory` | — | list |
| `DoctorDegreeEntry.aspx.cs` | `showMessageBox` | `string message` | non-static helper, not a real AJAX endpoint despite `[WebMethod]` |
| `DoctorDegreeEntry.aspx.cs` | `Save_DoctorDegree` | `DoctorDegreeDao` | save degree |
| `DoctorDegreeEntry.aspx.cs` | `GetDoctorDegreeEditData` | `string id` | returns `DoctorDegreeDao[]` |
| `DoctorDegreeView.aspx.cs` | `GetEmpData` | — | list |
| `DoctorDesignation.aspx.cs` | `Save_DoctorDesignation` | `DoctorDesignation` | save designation |
| `DoctorDesignation.aspx.cs` | `GetDoctorDesignationEditData` | `int id` | edit-data lookup |
| `DoctorDesignationView.aspx.cs` | `Get_DoctorDesignation` | — | list |
| `DoctorDesignationView.aspx.cs` | `Delete_DoctorDesignation` | `int Id` | delete |
| `DoctorSpeciality.aspx.cs` | `Save_DoctorSpeaciality` | `DoctorSpeciality` | save speciality |
| `DoctorSpeciality.aspx.cs` | `Get_DoctorSpecialityForEdit` | `int id` | edit-data lookup |
| `DoctorSpecialityView.aspx.cs` | `Get_DoctorSpeciality` | — | list |
| `DoctorSpecialityView.aspx.cs` | `Delete_DoctorSpeciality` | `int Id` | delete |
| `PatientType.aspx.cs` | `Save_PatientTypeDay` | `PatientTypeDao` | save patient type |
| `PatientType.aspx.cs` | `GetDoctorSpecialDayForEdit` | `int id` | edit-data lookup |
| `PatientTypeView.aspx.cs` | `Get_DoctorSpecialDay` | — | list |
| `PatientTypeView.aspx.cs` | `Delete_DoctorSpecialDay` | `int Id` | delete |
| `PrescriptionType.aspx.cs` | `Save_PrescriptionType` | `PrescriptionType` | save prescription type |
| `PrescriptionType.aspx.cs` | `GetDoctorSpecialDayForEdit` | `int id` | edit-data lookup (name reused, unrelated to `PatientType`'s) |
| `PrescriptionTypeView.aspx.cs` | `Get_PrescriptionTypeList` | — | list |
| `SpecialDaySetup.aspx.cs` | `Save_DoctorSpeacialDay` | `DoctorSpecailDay` | save special day |
| `SpecialDaySetup.aspx.cs` | `GetDoctorSpecialDayForEdit` | `int id` | edit-data lookup |
| `SpecialDayView.aspx.cs` | `Get_DoctorSpecialDay` | — | list |
| `SpecialDayView.aspx.cs` | `Delete_DoctorSpecialDay` | `int Id` | delete |

### `DoctorModule_UI` (53 files — the largest module by far)

Covers field-force org structure, HR (leave/attendance/expense/mileage), tour planning,
prescriptions, and shared dropdown data.

**`CommonDataLoad.aspx.cs`** — pure lookup-list provider consumed by many other pages' dropdowns
(near-identical copy also exists at `Target_UI/CommonDataLoad.aspx.cs`, see below). All
`public static string`, all return JSON list data from `_dataLoad` (a shared DAL helper), most take
no params or a single filter `int id`:

`GetDesignation_Active`, `GetDoctorSpeciality_Active`, `GetDoctorBrand_Active`,
`GetInstitute_Active`, `GetZone_byGroupId_Active(id)`, `GetChamber_ByDoctorId(id)`,
`GetZone_byGroupId_All(id)`, `GetNSMEmployee_All(id)`, `GetDZSMEmployee_All(id)`,
`GetAMEmployee_All(id)`, `GetMIOEmployee_All(id)`, `GetCompanyInfoAll`,
`GetExpenseField_ByExpenseType(id)`, `GetArea_ByZoneId_Active(id)`, `GetArea_ByZoneId_All(id)`,
`GetContactType`, `GetSpecialDay_Active`, `GetStationType_Active`, `GetChamberType_Active`,
`GetDivision_Active`, `GetDistrict_ByDivision_Active(id)`, `GetThana_ByDistrict_Active(id)`,
`GetDoctorType_Active`, `GetDoctorCustomer_Active`, `GetProgramType_Active`, `GetDegree_Active`,
`GetZone_Active`, `GetGroupInfo_Active`, `GetNational_Active`, `GetRoleTypeInfo`,
`GetGroupInfo_All`, `GetCustomerType_All`, `GetThanaInfo_All`, `GetFiscalYearInfo_Active`,
`GetZone_ActiveById(id)`, `GetTerritory_ByAreaId_Active(id)`, `GetSubTerritory_ByTerritoryId_Active(id)`,
`GetSubTerritory_ByTerritoryId_All(id)`, `GetTerritory_ByAreaId_All(id)`,
`GetMarket_ByTerritoryId_Active(id)`, `GetMarket_ByTerritoryId_All(id)`,
`GetMarket_BySubTerritoryId_Active(id)`, `GetMarket_BySubTerritoryId_All(id)`,
`GetEmployeeList_All`, `GetEmployeeList_Active`, `GetDepartment_Active`,
`GetDesignation_Active_Emp`, `GetShift_Active`, `CompanyList_Active`, `GetTourTypeList_Active`,
`GetTourTypeList_All`, `GetTransportList_Active`, `GetTransportList_All`, `GetUserList_Active`,
`GetExpenseType` — each is `(GroupOrParent Id) -> filtered lookup list`, `_Active` suffix = active
rows only, `_All` suffix = includes inactive.

**Org/HR setup pages** (`Save_X` / `GetXEditData` / list / delete|activate pattern):

| File | Method | Params | Purpose |
|---|---|---|---|
| `Department.aspx.cs` | `Save_DepartmentInfo` | `Department` | save department |
| `Department.aspx.cs` | `GetDepartmentEditData` | `int id` | edit-data lookup |
| `DepartmentView.aspx.cs` | `GetDepartmentList` | — | list |
| `DepartmentView.aspx.cs` | `ActiveInactive_departmentInfo` | `int Id` | toggle active |
| `DepartmentView.aspx.cs` | `Delete_EmployeeDepartment` | `int Id` | delete |
| `DepotWiseAreaSetup.aspx.cs` | `LoadCompany` | — | company dropdown |
| `DepotWiseAreaSetup.aspx.cs` | `LoadDepotlist` | `int comapnyId` | depot dropdown by company |
| `DepotWiseAreaSetup.aspx.cs` | `LoadAreaByDepotId` | `int depotId` | area dropdown by depot |
| `Designation.aspx.cs` | `Save_DesignationInfo` | `Designation` | save designation |
| `Designation.aspx.cs` | `GetDesignationEditData` | `int id` | edit-data lookup |
| `DesignationView.aspx.cs` | `GetDesignationList` | — | list |
| `DesignationView.aspx.cs` | `ActiveInactive_DesignationInfo` | `int Id` | toggle active |
| `FinancialYearEntry.aspx.cs` | `Save_FinancialYearInfo` | `FinancialYear` | save FY |
| `FinancialYearEntry.aspx.cs` | `GetFinancialYeaEditData` | `int id` | edit-data lookup |
| `FinancialYearView.aspx.cs` | `ActiveInactive_FinancialYearInfo` | `int Id` | toggle active |
| `FinancialYearView.aspx.cs` | `GetFinancialYearList` | — | list |
| `GenericGroupEntry.aspx.cs` | `Save_GenericGroup` | `GenericGroup` | save |
| `GenericGroupEntry.aspx.cs` | `GetGenericGroupEditData` | `int id` | edit-data lookup |
| `GenericGroupView.aspx.cs` | `GetGenericGroupList` | — | list |
| `GroupSetupEntry.aspx.cs` | `GetGroupSetupEditData` | `int id` | edit-data lookup |
| `GroupSetupEntry.aspx.cs` | `Save_groupSetupInfo` | `GroupSetup` | save |
| `GroupSetupView.aspx.cs` | `GetGroupSetupList` | — | list |
| `GroupSetupView.aspx.cs` | `ActiveInactive_GroupSetupInfo` | `int Id` | toggle active |
| `NationalSetup.aspx.cs` | `GetGroupSetupEditData` | `int id` | edit-data lookup |
| `NationalSetup.aspx.cs` | `Save_groupSetupInfo` | `GroupSetup` | save |
| `NationalSetupView.aspx.cs` | `GetNationalSetupList` | — | list |
| `NationalSetupView.aspx.cs` | `ActiveInactive_GroupSetupInfo` | `int Id` | toggle active |
| `ShiftInfoEntry.aspx.cs` | `Save_ShiftInfo` | `Employee_ShiftInfosDAO` | save shift |
| `ShiftInfoEntry.aspx.cs` | `GetShiftInfoEditData` | `int id` | edit-data lookup |
| `ShiftInfoList.aspx.cs` | `GetShiftList` | — | list |
| `Transport.aspx.cs` | `Save_Transport` | `Transport` | save |
| `Transport.aspx.cs` | `GetTransportEditData` | `int id` | edit-data lookup |

**Field-force hierarchy — `FieldForce.aspx.cs`** (one large file covering RSM/ASM/MIO/NSM
region-manager setup):

| Method | Params | Purpose |
|---|---|---|
| `LoadVacentGroup` | — | groups with vacant slots |
| `LoadVacentRegion` | `int groupId` | regions with vacant slots by group |
| `LoadVacentArea` | `int zoneId` | vacant areas by zone |
| `LoadVacentTerritory` | `int areaId` | vacant territories by area |
| `Save_RSMInfo` | `RSMInfo` | save RSM |
| `GetRSMList` | — | RSM list |
| `RsmInactiveById` | `int rsmId` | deactivate RSM |
| `AsmRecords` | — | ASM list |
| `Save_ASMInfo` / `InsertUpdate_ASMInfo` | `ASMInfo` | save/upsert ASM |
| `AsmInactiveById` | `int asmId` | deactivate ASM |
| `AsmSetup` | — | ASM setup data |
| `MioRecords` / `MioSetup` | — | MIO list / setup data |
| `Save_MIOInfo` / `Insert_Update_MIOInfo` | `MIOInfo` | save/upsert MIO |
| `MioInactiveById` | `int mioId` | deactivate MIO |
| `GetMIOList` | — | MIO list |
| `Save_UserRoleInfo` | `UserRoleDao` | save role |
| `Save_NSMInfo` / `Save_NSMHeadInfo` | `NSMInfo` | save NSM / NSM head |
| `GetUserRoleList`, `GetUserInfoList`, `GetNSMList`, `GetNSMHeadList`, `GetASMList` | — | list endpoints |
| `GetNSMSetupEditData`, `GetNSMSetupEditDataByEmpId`, `GeDZSMSetupEditData`, `GeDZSMSetupEditDataByEMPID`, `GeAMSetupEditData`, `GeMIOtupEditData`, `GeMIOMasterDataByEmpID`, `GAMMasterDataByEmpID`, `GetUserRoleEditData` | `int id` | edit-data lookups by role |

**HR: leave, attendance, expense, mileage:**

| File | Method | Params | Purpose |
|---|---|---|---|
| `AttendanceInfoList.aspx.cs` | `Emp_AttendanceInfoList` | `string param` | attendance list (filter JSON) |
| `AttendanceInfoReport.aspx.cs` | `Emp_AttendanceInfoList` | `string param` | attendance report (same name, different page) |
| `AttendanceListApproval.aspx.cs` | `Get_AttendanceList_Approval` | — | pending-approval list |
| `AttendanceListApproval.aspx.cs` | `Approve_AttendanceList` | `string MyArry, bool? rbValue` | bulk approve/reject |
| `ExpenseClaim.aspx.cs` | `GetAreaList_Active_ByZoneId` | `int id` | dropdown |
| `ExpenseClaim.aspx.cs` | `GetThana_WitTagDetails` / `_forEditPage(id)` | — / `int id` | thana dropdown |
| `ExpenseClaim.aspx.cs` | `Save_ExpenseClaim` | `ExpenseClaimMasterDAO` | save claim |
| `ExpenseClaim.aspx.cs` | `GetExpenseField_ByExpenseType` | `int id` | dynamic field list |
| `ExpenseClaim.aspx.cs` | `GetExpenseClaimEditData` | `int id` | returns `List<ExpenseClaimDAOTT>` |
| `ExpenseClaim.aspx.cs` | `GetExpenseType`, `GetEmployeeList_Active` | — | dropdowns |
| `ExpenseClaimView.aspx.cs` | `GetExpenseClaimList` | `string param` | list |
| `ExpenseClaimView.aspx.cs` | `Get_UserRoleInfo` | — | role dropdown |
| `ExpenseTypeView.aspx.cs` | `GetExpensemasterList` | — | list |
| `ExpenseTypeView.aspx.cs` | `Delete_ExpenseType` | `int Id` | delete |
| `Holiday.aspx.cs` | `GetHoliEditData` | `int id` | edit-data lookup |
| `Holiday.aspx.cs` | `Save_Holiday` | `Holiday` | save |
| `Holiday.aspx.cs` | `GetFinanCialyear` | — | FY dropdown |
| `HolidayView.aspx.cs` | `ActiveInactive_EmployeeLeave` | `int Id` | toggle (name is misleading — this is holiday view) |
| `HolidayView.aspx.cs` | `GetHolidayList` | — | list |
| `Leave.aspx.cs` | `GetEmployeeEditData` | `int id` | edit-data lookup |
| `Leave.aspx.cs` | `Save_Leaveinfo` | `EmployeeLeave` | save |
| `LeaveConfig.aspx.cs` | `GetEmployeeEditData` | `int id` | edit-data lookup |
| `LeaveConfig.aspx.cs` | `Save_Leaveinfo` | `EmployeeLeave` | save leave config |
| `LeaveConfigList.aspx.cs` | `GetLeaveConfigList` | — | list |
| `LeaveConfigList.aspx.cs` | `ActiveInactive_EmployeeLeave` / `Delete_EmployeeLeave` | `int Id` | toggle / delete |
| `LeaveView.aspx.cs` | `GetLeaveList` | — | list |
| `LeaveView.aspx.cs` | `ActiveInactive_EmployeeLeave` / `Delete_EmployeeLeave` | `int Id` | toggle / delete |
| `MileageClaim.aspx.cs` | `GetThana_WitTagDetails_forEditPage` | `int id` | dropdown |
| `MileageClaim.aspx.cs` | `GetMileageClaimEditData` | `int id` | edit-data lookup |
| `MileageClaim.aspx.cs` | `Save_MileageClaim` | `MileageClaimDAO` | save |
| `MileageClaimView.aspx.cs` | `GetMileageClaimList` | `string param` | list |

**Prescriptions / tour plans / product line / market org:**

| File | Method | Params | Purpose |
|---|---|---|---|
| `MarketRecords.aspx.cs` | `GetMarketList` | — | list |
| `Prescription.aspx.cs` | `GetPrescriptionEditData` | `int id` | edit-data lookup |
| `Prescription.aspx.cs` | `GetPrescriptionDetailsListForEdit` | `int id` | detail rows |
| `Prescription.aspx.cs` | `Save_Prescription` | `PrescriptionMasterDAO` | save |
| `PrescriptionType.aspx.cs` | `GetPrescriptionTypeForEdit` | `int id` | edit-data lookup |
| `PrescriptionType.aspx.cs` | `Save_PrescriptionType` | `PrescriptionType` | save (duplicate concept vs. `DoctorMaster_UI`'s page) |
| `PrescriptionTypeView.aspx.cs` | `GetPrescriptiontTypeList` | — | returns `PrescriptionTypeDao[]` |
| `PrescriptionView.aspx.cs` | `Get_PrescriptionList` | `string param` | list |
| `ProductLineEntry.aspx.cs` | `Save_TherapueticGroup` | `TherapeuticGroup` | save |
| `ProductLineEntry.aspx.cs` | `GetTherapueticGroupEditData` | `int id` | edit-data lookup |
| `ProductLineView.aspx.cs` | `GetTherapueticGroupList` | — | list |
| `RouterSetupEntry.aspx.cs` | `Save_RouterSetup` | `RouterMaster` | save route |
| `RouterSetupEntry.aspx.cs` | `GetmarketByTerryTori`, `GetmarketByTerryTori_ById(id)` | — / `int Id` | market dropdown |
| `RouterSetupEntry.aspx.cs` | `GetRouterMasterList`, `GetRouterEditData(id)` | — / `int id` | list / edit-data |
| `RouterSetupView.aspx.cs` | `GetRouterMasterList` | — | list |
| `SeedData.aspx.cs` | `GetDivisionList`, `GetDivisionList_NotInAnyTagWithZone`, `GetZoneList_Active`, `GetBrandNameALL`, `GetDistrictList_Active`, `GetThana_All`, `GetEmployeeList`, `GetEmployee_AllFieldForceEmployeeList`, `GetThana_WitTagDetails`, `GetGroupList`, `GetChemistTypeList`, `GetCampaignTypeList` | — | flat lookup/seed-data providers |
| `SeedData.aspx.cs` | `GetOfferTypeInfo` | `int id` | offer-type lookup |
| `TharapeuticGroupEntry.aspx.cs` | `Save_TherapueticGroup`, `GetTherapueticGroupEditData(id)` | | save/edit therapeutic group |
| `TharapeuticGroupEntry.aspx.cs` | `Save_ProductLine`, `GetProductLineEditData(id)` | | save/edit product line |
| `TharapeuticGroupView.aspx.cs` | `GetTherapueticGroupList`, `GetProductLineList` | — | lists |
| `TourPlanDetailsView.aspx.cs` | `GetTourPlanDetailsViewDatabyID` | `int id` | detail lookup |
| `TourPlanDetailsView.aspx.cs` | `Get_TourPlanBalance` | `int empId, int Month, int year` | leave/tour balance |
| `TourPlannedReport.aspx.cs` | `GetTourPlanList` | `string param` | report list |
| `TourPlannedReport.aspx.cs` | `GetYear_Active` | — | year dropdown |
| `TourPlannedUserList.aspx.cs` | `GetTourPlanList`, `GetTourPlanReport` | `string param` | list / report |
| `TourPlannedUserList.aspx.cs` | `GetYear_Active` | — | year dropdown |
| `TourPurposeRecords.aspx.cs` | `GetTourPurposeList` | — | list |
| `TourPurposeRecords.aspx.cs` | `Delete_TourPurpose` | `int Id` | delete |
| `TourPurposeSetup.aspx.cs` / `TourPurposeSetupNew.aspx.cs` | `Save_TourPurpose`, `GetTourPurposeEditData(id)` | | save/edit (two parallel pages, same contract) |
| `TourTypeRecords.aspx.cs` | `GetTourTypeList`, `Delete_TourType(id)` | | list / delete |
| `TourTypeSetup.aspx.cs` | `GetTourTypeEditData(id)`, `Save_TourType` | | edit / save |

**`Setup.aspx.cs`** (one very large catch-all setup page — territory/zone/area org tree, TADA
rules, approvals, transport, training):

| Method | Params | Purpose |
|---|---|---|
| `Approve_PrescriptionList` | `string MyArry, string rbValue` | bulk approve/reject prescriptions |
| `TourPlanApproveList` | `string param` | pending tour-plan list |
| `Approve_TourPlanList` | `string MyArry, string rbValue` | bulk approve (non-static — likely dead as an AJAX endpoint) |
| `GetZoneList`, `SaveZone`, `GetZoneEditData(id)` | | zone CRUD |
| `SaveArea`, `GetAreaEditData(id)`, `GetAreaList(RegionId)` | | area CRUD |
| `SaveTerritory`, `SaveSubTerritory`, `GetTerritoryList(RegionId, areaId)`, `GetSubTerritoryList`, `GetTerrritoryEditData(id)`, `GetSubTerrritoryEditData(id)` | | territory/sub-territory CRUD |
| `GetThana_WitTagDetails_forEditPage(id)`, `GetMarketEditData(id)` | | lookups |
| `Get_CapturedBy_For_ddl`, `Get_Doctor_For_ddl`, `Get_ProductList_List_New`, `Get_PrescriptionType_For_ddl`, `Get_ProductList_For_ddl`, `Get_ApprovalStatus_ddl`, `Get_AllowanceName_For_ddl`, `Get_TADAMarketRuleConfiguration_For_ddl`, `Get_UserRoleInfo`, `GetCustomerCategory`, `GetEmployeeList_Active_Neww`, `GetEmployeeDesignation`, `Get_UserTypeInfo`, `Get_StationTypeInfo` | — | dropdown providers |
| `Delete_Prescription` | `int Id` | delete |
| `Get_PrescriptionList` | `string param` | list |
| `Get_TADAList` | `string param` | list |
| `GetTransportList` | — | list |
| `Delete_MonthlyAllowance`, `GetMonthlyAllowanceList` | | allowance CRUD |
| `Save_TADAMarketRuleConfiguration`, `GetTADAMarketRuleConfigurationDataById(id)`, `GetTADAMarketRuleConfigurationList` | | TADA rule CRUD |
| `GetTrainningList`, `Delete_Trainning(id)`, `GetTrainningEditData(id)` | | training CRUD |

### `DoctorVisit_UI` (6 methods, 6 files)

| File | Method | Params | Purpose |
|---|---|---|---|
| `DCRList.aspx.cs` | `GetDCRList` | `string param` | daily call report list |
| `DCRReport.aspx.cs` | `GetDCRReportDataById` | `int id` | DCR detail |
| `DoctorDailyVisit.aspx.cs` | `GetDoctorDailyVisitList` | `string param` | list |
| `DoctorPlanDetailsView.aspx.cs` | `GetDoctorPlanDetailsViewDatabyID` | `int id` | detail |
| `DoctorVisit.aspx.cs` | `GetDoctorVisitList` | `string param` | list |
| `DoctorVisitReport.aspx.cs` | `GetDoctorVisitList` | `string param` | list |
| `DoctorVisitReport.aspx.cs` | `GetDynamicPivotDoctorWiseDoctorVisitPlan` | `string param` | pivoted report |

### `eProgram_UI` (1 file, 2 methods)

`ProviderDropoutRequestList.aspx.cs` — both use `[ScriptMethod(ResponseFormat = ResponseFormat.Json)]`
in addition to `[WebMethod]`:

| Method | Params | Purpose |
|---|---|---|
| `GetProviderDropoutIntrigrationList` | — | returns `ProviderDropoutResponse` — pending dropout requests |
| `ApproveProviderDropoutIntrigration` | `long providerIDropoutIntrigrationd` | `[WebMethod(EnableSession = true)]`, returns `ActionResponse` — approve a dropout request |

### `LeaveProcess_UI` (2 files, 5 methods)

| File | Method | Params | Purpose |
|---|---|---|---|
| `LeaveApplicationCode.aspx.cs` | `SaveLeaveApplication` | `LeaveApplication` | create |
| `LeaveApplicationCode.aspx.cs` | `UpdateLeaveApplication` | `LeaveApplication` | update |
| `LeaveApplicationCode.aspx.cs` | `LeaveApplicationApprove` | `int leaveApplicationId, string ApprovalStatus` | approve/reject |
| `LeaveApplicationCode.aspx.cs` | `GetEmployeeLeaveBalance` | `string employeeCode` | balance lookup |
| `LeaveApplicationCode.aspx.cs` | `GetApplicationInfoById` | `int leaveApplicationId` | detail lookup |
| `YearlyLeaveProcess.aspx.cs` | `SaveYearlyleave` | — | triggers yearly leave-balance rollover |

### `MasterSetup_UI` (7 files)

| File | Method | Params | Purpose |
|---|---|---|---|
| `CustomerInvoiceLimit.aspx.cs` | `Save`, `Update`, `Delete(id)`, `GetById(id)`, `GetList` | `CustomerInvoiceLimitModel` | limit CRUD (newer `Service`/`ViewModel` style, per CLAUDE.md's reference example) |
| `CustomerInvoiceLimit.aspx.cs` | `GetCustomerAutoComplete` | `string keyword` | returns `List<CustomerAutoCompleteViewModel>` — typed autocomplete (unlike the raw `string[]` ones in `SInventoryWebService`) |
| `CustomerInvoiceLimit.aspx.cs` | `GetCustomerTypeListActive` | — | returns `List<CustomerTypeViewModel>` |
| `CustomerInvoiceLimit.aspx.cs` | `SaveInvoiceNotBinding`, `UpdateInvoiceNotBinding`, `DeleteInvoiceNotBinding(id)`, `GetInvoiceNotBindingById(id)`, `GetInvoiceNotBindingList` | `InvoiceNotBindingModel` | related "not-binding" rule CRUD |
| `CustomerTypeSetup.aspx.cs` | `Save_DepartmentInfo`, `GetDepartmentList`, `ActiveInactive_departmentInfo(id)`, `GetDepartmentEditData(id)`, `Delete_EmployeeDepartment(id)` | `CustomerType` | customer-type CRUD (method names copy-pasted from `Department`, unrelated domain) |
| `EmployeeRecords.aspx.cs` | `GetEmployeeInformationList` | `string param` | employee list |
| `ProgramTypeView.aspx.cs` | `Save_DepartmentInfo`, `GetDepartmentList`, `GetDepartmentEditData(id)` | `ProgramType` | program-type CRUD, returns `SalesSolution.Web.Models.ResultInfo` |
| `ProgramTypeView.aspx.cs` | `Save_SMCTypeInfo`, `GetSMCTypeList`, `GetSMCTypeEditData(id)` | `SMCTypeDAO` | SMC-type CRUD (same file) |
| `SMCTypeView.aspx.cs` | `Save_DepartmentInfo`, `GetDepartmentList`, `GetDepartmentEditData(id)` | `ProgramType` | near-duplicate of `ProgramTypeView`'s program-type CRUD |
| `StationTypeEntry.aspx.cs` | `Save_DepartmentInfo`, `GetDepartmentEditData(id)` | `StationType` | station-type CRUD |
| `StationTypeView.aspx.cs` | `GetDepartmentList` | — | list |

### `NoticeBoard_UI` (1 file, 4 methods)

`NoticeBoard.aspx.cs`: `GetNoticeMasterList`, `Delete_NoticeMaster(int Id)`,
`GetNoticeMasterEditData(int id)`, `GetNotticeDetailsEditForEdit(int id)` — notice board CRUD.

### `PromoAlloc` (5 files)

| File | Method | Params | Purpose |
|---|---|---|---|
| `GroupWisePromoQtyEntry.aspx.cs` | `LoadStockQty` | `string id` | stock qty lookup |
| `GroupWisePromoQtyEntry.aspx.cs` | `SaveGroupWiseQty` | `GroupWisePromoQtyDAO` | save promo qty |
| `GroupWisePromoQtyEntry.aspx.cs` | `LoadGroupWiseQtyById` | `string id` | edit-data lookup |
| `GroupWisePromoQtyList.aspx.cs` | `LoadGroupWiseQty` | — | list |
| `PromoGroup.aspx.cs` | `SaveGroup` | `GroupDAO` | save promo group |
| `PromoGroup.aspx.cs` | `LoadPromoGroupById` | `string id` | edit-data lookup |
| `PromoGroupList.aspx.cs` | `LoadPromoGroup` | — | list |
| `PromoMIOTag.aspx.cs` | `LoadGroup`, `LoadProduct` | — | dropdowns |
| `PromoMIOTag.aspx.cs` | `LoadMIO` | `string id` | MIO dropdown by group |
| `PromoMIOTag.aspx.cs` | `SaveMIOTag` | `PromoMIOTagMaster` | save MIO tag assignment |

### `Reports_UI` (11 files, 1 method each)

All 11 report pages expose the identical signature `public static string GetMileageClaimList(string
param)` — despite the name (copy-pasted from a mileage-claim report and never renamed), each file's
implementation queries a different report's underlying data (mileage/CVR-doctor-wise,
DCP-doctor-wise, DCR-doctor-wise, doctor-info, DWSP monthly, monthly expense (single/multiple),
order permission, RX-doctor-wise, tour-plan report, tour-plan summary). Files: `CVRDoctoriseMonthlypt.aspx.cs`,
`DcpDoctoriseMonthlypt.aspx.cs`, `DcrDoctoriseMonthlypt.aspx.cs`, `DoctorInfoReport.aspx.cs`,
`DWSPMonthlyRpt.aspx.cs`, `EmpMonthlyExpenseRpt.aspx.cs`, `EmpMonthlyExpenseRptMultiple.aspx.cs`,
`OrderPermission.aspx.cs`, `RXDoctoriseMonthlypt.aspx.cs`, `TourPlanReportNew.aspx.cs`,
`TourPlanSummaryReport.aspx.cs`.

### `Target_UI` (5 files)

`Target_UI/CommonDataLoad.aspx.cs` is a near-duplicate of `DoctorModule_UI/CommonDataLoad.aspx.cs`
(same ~48 lookup methods, copy-pasted rather than shared).

| File | Method | Params | Purpose |
|---|---|---|---|
| `MonthlyTarget.aspx.cs` | `SaveTarget` | `TargetDAO` | save monthly target |
| `MonthlyTarget.aspx.cs` | `LoadMonthlyTargetById` | `string id` | edit-data lookup |
| `MonthlyTargetView.aspx.cs` | `LoadMonthlyTarget` | — | list |
| `ProductWiseTarget.aspx.cs` | `SaveTarget` | `ProductWiseTargetDAO` | save product-wise target |
| `ProductWiseTarget.aspx.cs` | `LoadMonthlyTargetById` | `string id` | edit-data lookup |
| `ProductWiseTarget.aspx.cs` | `LoadProduct` | — | product dropdown |
| `ProductWiseTargetList.aspx.cs` | `LoadMonthlyTarget` | — | list |

### `Thana_UI` (5 files)

Geographic hierarchy (Division → District → Thana) CRUD, duplicated near-identically across three
files (`District_Entry.aspx.cs`, `ThanaEntry.aspx.cs` each implement their own copy):

| File | Method | Params | Purpose |
|---|---|---|---|
| `District_Entry.aspx.cs` | `Save_ThanaInfo` | `ThanaDao` | save |
| `District_Entry.aspx.cs` | `Get_Division_All_DDL`, `Get_District_All_DDL(id)`, `Get_Thana_By_Id(id)` | | dropdowns |
| `District_View.aspx.cs` | `GET_District_All_List` | — | list (verify it's actually `[WebMethod]`-static before wiring a client to it) |
| `Division_View.aspx.cs` | `GET_Division_All_List` | — | list |
| `ThanaEntry.aspx.cs` | `Save_ThanaInfo`, `Save_DistictInfo` | `ThanaDao` | save thana / district |
| `ThanaEntry.aspx.cs` | `Get_Division_All_DDL`, `Get_District_All_DDL(id)`, `Get_Thana_By_Id(id)`, `Get_District_By_Id(id)` | | dropdowns |
| `Thana_View.aspx.cs` | `Get_Thana_All_List` | — | list |

### `UserPermission` (2 files)

| File | Method | Params | Purpose |
|---|---|---|---|
| `ApprovalStepMap.aspx.cs` | `SaveMenu` | `ApprovalMapMaster` | save approval-step map |
| `ApprovalStepMap.aspx.cs` | `GetUserRole`, `GetMenu` | — | returns `dynamic` — role/menu dropdowns |
| `ApprovalStepMap.aspx.cs` | `LoadApprovalMap` | `string roleId, string typeId` | load existing map |
| `UserPermission.aspx.cs` | `SaveMenu` | `MenuRoleMasterDAO arole, string roleSelectid, string typeSelectId` | save menu permissions for a role |
| `UserPermission.aspx.cs` | `GetUserRole` | — | returns `dynamic` |
| `UserPermission.aspx.cs` | `LoadMenu`, `LoadMenuIsApp` | `string roleId, string typeId` | load web vs. app menu permission state |

### `UserTracking` (1 file, 1 method)

`UserTrackingList.aspx.cs`: `GetUserLocationTrackig(int empId, DateTime trackDate)` — reads
`dbo.tblUserSessionTracking` (populated by `UserSessionTrackingManager`, see §5 below).

## 4. External endpoint (declared but unused)

`Library.DAL/DataManager/SqlUserAccess.cs` declares:

```csharp
public static string AppName = "CSTL-Development";
public static string BASE_URL = "http://45.64.134.85:570";
```

`grep -rln "BASE_URL"` across the entire repository returns **only this one file** — nothing reads
`SqlUserAccess.BASE_URL` anywhere. Despite `CLAUDE.md`'s description of this as a REST host used by
older DAL code, there are currently no active call sites; treat it as dead/unused configuration
until proven otherwise, not as a live integration point. (There is a *different*, real,
hardcoded-credential SAP REST call — see [`integrations.md`](integrations.md) §1a — don't confuse
the two.)

## 5. Outbound calls (this app calling out)

| Call | From | Purpose |
|---|---|---|
| `GET https://ipapi.co/{ip}/json/` | `Solution.Web/App_Code/UserSessionTrackingManager.cs` | IP geolocation on every login, written to `tblUserSessionTracking` |
| `EXEC msdb.dbo.sp_start_job` | `Solution.Web/App_Code/ArchiveDbConnectRepository.cs` | Triggers a SQL Agent backup job from the web app |

Full integration-level detail (SAP, SMTP, etc.) is in [`integrations.md`](integrations.md) — this
section only covers calls made *from within* the API-surface files cataloged above.

## What's absent

No `ApiController`, no `WebApiConfig`, no OpenAPI/Swagger definition (`grep`-confirmed empty), no
API versioning scheme, no rate limiting, no API-key/token auth mechanism, no consolidated request
DTO/response envelope convention — every module invented its own return shape (`string[]`,
delimited `string` JSON blobs, `ResultInfo`, typed `List<...ViewModel>`, or raw `dynamic`) — **Not
Found** anywhere in this repository.
