# Database Tables — Full Column Catalog

Auto-generated from live schema (`SalesDisDB_SMC_NEWDB` on DESKTOP-MND72HJ) via `INFORMATION_SCHEMA` + `sys.identity_columns`. 569 base tables, 7402 columns. See [`database-spec.md`](database-spec.md) for views/procs/functions and narrative notes.

### `AspNetUsers`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Id | nvarchar(128) | NOT NULL | PK |
| Email | nvarchar(256) | NULL |  |
| EmailConfirmed | bit | NOT NULL |  |
| PasswordHash | nvarchar(max) | NULL |  |
| SecurityStamp | nvarchar(max) | NULL |  |
| PhoneNumber | nvarchar(max) | NULL |  |
| PhoneNumberConfirmed | bit | NOT NULL |  |
| TwoFactorEnabled | bit | NOT NULL |  |
| LockoutEndDateUtc | datetime | NULL |  |
| LockoutEnabled | bit | NOT NULL |  |
| AccessFailedCount | int | NOT NULL |  |
| UserName | nvarchar(256) | NOT NULL |  |

### `Biz_HQEHQ`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubMarket | nvarchar(max) | NULL |  |
| Code | nvarchar(max) | NULL |  |
| TeName | nvarchar(max) | NULL |  |
| TeCode | nvarchar(max) | NULL |  |
| TypeForMIO | nvarchar(max) | NULL |  |
| TyprofAM | nvarchar(max) | NULL |  |
| TypeofZonal | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Upazila | nvarchar(max) | NULL |  |
| MarketID_2 | int | NULL |  |

### `dainfoAug`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNo | nvarchar(100) | NULL |  |
| DaName | nvarchar(100) | NULL |  |
| DAID | int | NULL |  |
| DACode | nvarchar(100) | NULL |  |
| DAInfoChengeId | int | NOT NULL | PK, IDENTITY |

### `dainfojul`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNo | nvarchar(50) | NULL |  |
| DaName | nvarchar(50) | NULL |  |
| DAID | int | NULL |  |
| DACode | nvarchar(50) | NULL |  |
| DAInfoChengeId | int | NOT NULL | PK, IDENTITY |

### `dainfoOct`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNo | nvarchar(100) | NULL |  |
| DaName | nvarchar(100) | NULL |  |
| DAID | int | NULL |  |
| DACode | nvarchar(50) | NULL |  |
| DAInfoChengeId | int | NOT NULL | PK, IDENTITY |

### `dainfoSep`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNo | nvarchar(100) | NULL |  |
| DaName | nvarchar(100) | NULL |  |
| DAID | int | NULL |  |
| DACode | nvarchar(50) | NULL |  |
| DAInfoChengeId | int | NOT NULL | PK, IDENTITY |

### `DashboardSummary`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DashboardSummaryId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NOT NULL |  |
| PunchInTime | datetime | NULL |  |
| PunchOutTime | datetime | NULL |  |
| WorkingHours | decimal(10,2) | NULL |  |
| MeetingsCount | int | NULL |  |
| ProviderCount | int | NULL |  |
| PendingTaskCount | int | NULL |  |
| TrainingCount | int | NULL |  |
| TourPlanCount | int | NULL |  |
| CreatedOn | datetime | NOT NULL |  |

### `DashboardTileConfig`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FieldKey | nvarchar(50) | NOT NULL | PK |
| FieldName | nvarchar(100) | NOT NULL |  |
| FieldBgColor | nvarchar(20) | NULL |  |
| FieldIcon | nvarchar(100) | NULL |  |
| FieldOrder | int | NOT NULL |  |
| IsActive | bit | NOT NULL |  |

### `DocExcelCode`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DocTorExxcwelInactiveID | int | NOT NULL | PK, IDENTITY |
| DocCodeNo | nvarchar(50) | NULL |  |

### `Employe_LeaveTypeInfos`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveTypeId | int | NOT NULL | PK, IDENTITY |
| LeaveTypeName | nvarchar(500) | NULL |  |
| LeaveDays | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| HolidayCount | bit | NULL |  |
| Note | nvarchar(max) | NULL |  |

### `Employee_GovtHolidays`

| Column | Type | Nullable | Key |
|---|---|---|---|
| HolidayId | int | NOT NULL | PK, IDENTITY |
| FiscalYear | int | NULL |  |
| HolidayDate | datetime | NULL |  |
| DayName | nvarchar(500) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| HolidayToDate | datetime | NULL |  |

### `Employee_LeaveApplications`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveApplicationId | int | NOT NULL | PK, IDENTITY |
| EmployeeId | int | NULL |  |
| LeaveBalanceId | int | NULL |  |
| LeaveFromDate | datetime | NULL |  |
| LeaveToDate | datetime | NULL |  |
| Days | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(max) | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| Reason | nvarchar(max) | NULL |  |
| IsApproved | bit | NULL |  |
| DateOfReturnsToDuty | datetime | NULL |  |
| LeaveAddress | nvarchar(max) | NULL |  |
| EmergencyContactNo | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `Employee_YearlyLeaveBalance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveBalanceId | int | NOT NULL | PK, IDENTITY |
| FiscalYear | nvarchar(500) | NULL |  |
| EmployeeInfoId | int | NULL |  |
| LeaveTypeId | int | NULL |  |
| YearlyLeaveBalance | decimal(18,2) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| YearlyLeaveQty | decimal(18,2) | NULL |  |

### `Employee_YearlyLeaveTranscations`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveTranscationId | int | NOT NULL | PK, IDENTITY |
| TranscationDate | datetime | NULL |  |
| LeaveApplicationId | int | NULL |  |
| LeaveDays | decimal(18,2) | NULL |  |
| LeaveBalanceId | int | NULL |  |

### `EmployeeAllowance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmployeeAllowanceId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| AllowanceId | int | NULL |  |

### `FCBtoGeneral`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NULL |  |

### `GeneraltoFCB`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NULL |  |

### `google_map`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Id | int | NOT NULL | PK, IDENTITY |
| Rating | int | NULL |  |
| Address | nvarchar(50) | NULL |  |
| Lat | float | NULL |  |
| Long | float | NULL |  |
| Zoom | int | NULL |  |

### `Grades`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Student | varchar(50) | NULL |  |
| Subject | varchar(50) | NULL |  |
| Marks | int | NULL |  |

### `InactiveCustomerList`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NULL |  |

### `InactiveProduct`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductCode | nvarchar(max) | NULL |  |

### `Invoice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNO | nvarchar(max) | NOT NULL |  |

### `log_tbl_Zone`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ZoneId | int | NOT NULL |  |
| ZoneCode | nvarchar(max) | NULL |  |
| ZoneName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdatedBy | nvarchar(50) | NULL |  |
| UpdatedDate | datetime | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| LogEntryBy | nvarchar(max) | NULL |  |
| LogEntryDate | datetime | NULL |  |
| DivisionId | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |

### `Month`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Month_Name | nvarchar(max) | NULL |  |

### `OrderUpdate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderNo | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| ZoneCode | nvarchar(max) | NULL |  |

### `OrderUpdate2`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderNo | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| ZoneCode | nvarchar(max) | NULL |  |

### `ProcedureExecutionLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ID | int | NOT NULL | PK, IDENTITY |
| ProcedureName | nvarchar(255) | NULL |  |
| ExecutionStartTime | datetime | NULL |  |

### `Route_Excel_Update`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarketCode | nvarchar(max) | NULL |  |
| RoutePK | int | NULL |  |
| MarketPK | int | NULL |  |

### `RouteExclIssue`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouteExclIssueId | int | NOT NULL | PK, IDENTITY |
| MArketCode | nvarchar(50) | NULL |  |
| SystemCode | int | NULL |  |
| PrvDepoCode | nvarchar(50) | NULL |  |
| PrvRouteBame | nvarchar(50) | NULL |  |
| NewDepoCode | nvarchar(50) | NULL |  |
| NewRouteName | nvarchar(50) | NULL |  |
| DACode | nvarchar(50) | NULL |  |
| DANAme | nvarchar(50) | NULL |  |
| MArketIdnew | int | NULL |  |

### `RouterDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouterDetailsId | int | NOT NULL | PK, IDENTITY |
| RouterMasterId | int | NULL |  |
| TerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `RouterMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouterMasterId | int | NOT NULL | PK, IDENTITY |
| RouterName | nvarchar(max) | NULL |  |
| RouterCode | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `SAP_Defigit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MAterial | nvarchar(max) | NULL |  |
| Plant | nvarchar(max) | NULL |  |

### `Sap_employee`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmpCode | nvarchar(max) | NULL |  |
| SapCode | nvarchar(max) | NULL |  |

### `SAP_MarketSt_Code`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAP_areaCode | nvarchar(max) | NULL |  |
| epharma_area_Code | nvarchar(max) | NULL |  |
| Sap_area_Name | nvarchar(max) | NULL |  |
| Sap_territory_code | nvarchar(max) | NULL |  |
| epharma_territory_code | nvarchar(max) | NULL |  |
| SAP_territory_Name | nvarchar(max) | NULL |  |

### `Sap_Stock13thSepOpening`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Sap_Material | nvarchar(max) | NULL |  |
| Sap_Plant | nvarchar(max) | NULL |  |
| Sap_Batch | nvarchar(max) | NULL |  |
| Sap_Stock | decimal(18,2) | NULL |  |
| Base Unit of Measure | nchar(10) | NULL |  |
| Sap_Stock1 | decimal(18,2) | NULL |  |
| SALES_UNIT | nchar(10) | NULL |  |
| Sl | int | NOT NULL | PK, IDENTITY |

### `SAP_tblSales_Order`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAP_Sales_OrderId | int | NOT NULL | PK, IDENTITY |
| InvoiceNo | nvarchar(max) | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| SalesDocDate | date | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| SalesOrg | nvarchar(max) | NULL |  |
| CustomerPONo | nvarchar(max) | NULL |  |
| DistChnl | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| Territory | nvarchar(max) | NULL |  |
| CustomerRefDt | nvarchar(max) | NULL |  |
| DeliveryDate | nvarchar(max) | NULL |  |
| PaymentTerms | nvarchar(max) | NULL |  |
| OrderType | nvarchar(max) | NULL |  |
| Line | nvarchar(max) | NULL |  |
| Plant | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| Quantity | nvarchar(max) | NULL |  |
| UoM | nvarchar(max) | NULL |  |
| StorageLoc | nvarchar(max) | NULL |  |
| UnitPrice | nvarchar(max) | NULL |  |
| Inco1 | nvarchar(max) | NULL |  |
| Inco2 | nvarchar(max) | NULL |  |
| OrderReason | nvarchar(max) | NULL |  |
| DiscountAmount | nvarchar(max) | NULL |  |
| FOCFlag | nvarchar(max) | NULL |  |
| Outlet | nvarchar(max) | NULL |  |
| Action | nvarchar(max) | NULL |  |
| InvoiceId | int | NULL |  |
| Note | nvarchar(max) | NULL |  |

### `SAP_tblSales_OrderDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAP_Sales_OrderDetailId | int | NOT NULL | PK, IDENTITY |
| InvoiceDetailId | nvarchar(max) | NULL |  |
| Plant | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| Quantity | nvarchar(max) | NULL |  |
| UoM | nvarchar(max) | NULL |  |
| StorageLoc | nvarchar(max) | NULL |  |
| UnitPrice | nvarchar(max) | NULL |  |
| Inco1 | nvarchar(max) | NULL |  |
| Inco2 | nvarchar(max) | NULL |  |
| OrderReason | nvarchar(max) | NULL |  |
| DiscountAmount | nvarchar(max) | NULL |  |
| FOCFlag | nvarchar(max) | NULL |  |
| Outlet | nvarchar(max) | NULL |  |
| Action | nvarchar(max) | NULL |  |
| InvoiceId | int | NULL |  |

### `SAP_tblSales_PGI`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InviceNo | nvarchar(max) | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| DeliveryDate | date | NULL |  |
| Line | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| Quantity | nvarchar(max) | NULL |  |
| Action | nvarchar(max) | NULL |  |
| SAP_Sales_PGIId | int | NOT NULL | PK, IDENTITY |

### `SMC_CustomerMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NULL |  |
| sales_center_code | nvarchar(max) | NULL |  |
| sales_center_name | nvarchar(max) | NULL |  |
| CUSTOMERNAME | nvarchar(max) | NULL |  |
| Marketcode | nchar(10) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| FECode | nvarchar(max) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| DZSMCode | nvarchar(max) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| owner_name | nvarchar(max) | NULL |  |
| mobile | nvarchar(max) | NULL |  |
| division | nvarchar(max) | NULL |  |
| district | nvarchar(max) | NULL |  |
| thana | nvarchar(max) | NULL |  |
| union_name | nvarchar(max) | NULL |  |

### `subDeport`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Customer | nvarchar(max) | NULL |  |
| SubDeport | nvarchar(max) | NULL |  |

### `subDeport1`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Customer | nvarchar(max) | NULL |  |
| SubDeport | nvarchar(max) | NULL |  |

### `Table_1`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductCode | nvarchar(max) | NULL |  |
| TP | numeric(18,3) | NULL |  |
| Vat | numeric(18,3) | NULL |  |

### `Table_CustomerUpload`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(50) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| Address | nvarchar(500) | NULL |  |
| CellNo | nvarchar(50) | NULL |  |
| MarketId | int | NULL |  |
| MarketName | nvarchar(50) | NULL |  |
| Address2 | nvarchar(50) | NULL |  |
| City | nvarchar(50) | NULL |  |
| ConPerson | nvarchar(50) | NULL |  |
| TermsOfPayment | nvarchar(50) | NULL |  |

### `Table_DueInvoice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceId | int | NULL |  |
| InvoiceNo | nvarchar(max) | NULL |  |
| DeliveryInvoNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| MarketId | int | NULL |  |
| UnitCode | nvarchar(max) | NULL |  |
| UnitId | int | NULL |  |
| MiaCode | nvarchar(max) | NULL |  |
| MiaId | int | NULL |  |
| Due | decimal(18,2) | NULL |  |

### `tbl_AppVersion`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AppVersionId | int | NOT NULL | PK, IDENTITY |
| Version | int | NULL |  |
| VersionName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| InActiveDate | datetime | NULL |  |

### `tbl_AreaDistrictRelation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AdrId | int | NOT NULL | PK, IDENTITY |
| AreaId | int | NOT NULL |  |
| DistrictId | int | NOT NULL |  |

### `tbl_BonusCampaignBonusProductDtls`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BonusCampaignBonusProductDtlsId | int | NOT NULL | PK, IDENTITY |
| CampgainMasterId | int | NULL |  |
| BonusProductId | int | NULL |  |

### `tbl_BonusCampaignCustomerDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampaignCustomerDetailId | int | NOT NULL | PK, IDENTITY |
| CampaignMasterId | int | NULL |  |
| CustomerMasterId | int | NULL |  |

### `tbl_BonusCampaignDetailsCustType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BonusCampaignDetailsCustTypeId | int | NOT NULL | PK, IDENTITY |
| CampgainMasterId | int | NULL |  |
| CampgainMasterMapId | int | NULL |  |
| CampaignCode_dtl | nvarchar(50) | NULL |  |
| CustomerTypeId | int | NULL |  |

### `tbl_BonusCampaignMarketDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampaignMarketDetailId | int | NOT NULL | PK, IDENTITY |
| CampaignMasterId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `tbl_BonusCampaignMarketDetailDEL`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DELCampaignMarketDetailId | int | NOT NULL | PK, IDENTITY |
| CampaignMarketDetailId | int | NULL |  |
| CampaignMasterId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `tbl_BonusCampaignNewDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampaignDetailId | int | NOT NULL | PK, IDENTITY |
| CampaignMasterId | int | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| ProductId | int | NULL |  |
| Quantity | decimal(18,2) | NULL |  |
| BonusProductId | int | NULL |  |
| BonusQuantity | decimal(18,2) | NULL |  |
| BonusTypeId | int | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| MinAmount | decimal(18,3) | NULL |  |
| MaxAmount | decimal(18,3) | NULL |  |
| BonusProductCode | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| QuantityDteail | decimal(18,2) | NULL |  |
| IsRatioWiseIncrementPro | bit | NULL |  |

### `tbl_BonusCampaignNewDetailDEL`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DELCampaignDetailId | int | NOT NULL | PK, IDENTITY |
| CampaignDetailId | int | NULL |  |
| CampaignMasterId | int | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| ProductId | int | NULL |  |
| Quantity | decimal(18,2) | NULL |  |
| BonusProductId | int | NULL |  |
| BonusQuantity | decimal(18,2) | NULL |  |
| BonusTypeId | int | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| MinAmount | decimal(18,3) | NULL |  |
| MaxAmount | decimal(18,3) | NULL |  |
| BonusProductCode | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| QuantityDteail | decimal(18,2) | NULL |  |
| IsRatioWiseIncrementPro | bit | NULL |  |

### `tbl_BonusCampaignNewMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampgainMasterId | int | NOT NULL | PK, IDENTITY |
| CampaignCode | nvarchar(50) | NULL |  |
| ProductLineID | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| CampaignDesc | nvarchar(max) | NULL |  |
| FromDate | datetime | NULL |  |
| Todate | datetime | NULL |  |
| CampainTypeId | int | NULL |  |
| IsActive | bit | NULL |  |
| CustomerTypeId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| MaxAmount | decimal(18,2) | NULL |  |
| ProductQty | decimal(18,2) | NULL |  |
| IsTradePolicy | bit | NULL |  |
| BonusProductId | int | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsRatioWiseIncrement | bit | NULL |  |
| CampaignCategoryId | int | NULL |  |
| IsFCFS | bit | NULL |  |
| IsPTforCOD | bit | NULL |  |
| IsPTforOther | bit | NULL |  |
| pkCampaignSetupId | int | NULL |  |
| IsOld | bit | NULL |  |
| BonusProductDtlsId | nvarchar(50) | NULL |  |

### `tbl_BonusCampaignNewMasterDel`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampgainMasterDelId | int | NOT NULL | PK, IDENTITY |
| CampgainMasterId | int | NULL |  |
| CampaignCode | nvarchar(50) | NULL |  |
| ProductLineID | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| CampaignDesc | nvarchar(max) | NULL |  |
| FromDate | datetime | NULL |  |
| Todate | datetime | NULL |  |
| CampainTypeId | int | NULL |  |
| IsActive | bit | NULL |  |
| CustomerTypeId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| MaxAmount | decimal(18,2) | NULL |  |
| ProductQty | decimal(18,2) | NULL |  |
| IsTradePolicy | bit | NULL |  |
| BonusProductId | int | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsRatioWiseIncrement | bit | NULL |  |
| CampaignCategoryId | int | NULL |  |
| IsFCFS | bit | NULL |  |
| IsPTforCOD | bit | NULL |  |
| IsPTforOther | bit | NULL |  |
| pkCampaignSetupId | int | NULL |  |

### `tbl_BonusOnType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BonusTypeId | int | NULL |  |
| TypeName | nvarchar(50) | NULL |  |
| CodeName | nvarchar(50) | NULL |  |
| CampainTypeId | int | NULL |  |

### `tbl_CampaignType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampainTypeId | int | NULL |  |
| TypeName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| Description | nvarchar(50) | NULL |  |
| CodeName | nvarchar(50) | NULL |  |

### `tbl_CodeSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SetupID | int | NOT NULL | PK, IDENTITY |
| SetupName | nvarchar(max) | NULL |  |
| Prefix | nvarchar(50) | NULL |  |
| StartFrom | int | NULL |  |

### `tbl_ContactType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ContactTypeId | int | NOT NULL | PK, IDENTITY |
| ContactType | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_CustomerType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerTypeId | int | NOT NULL |  |
| TypeName | nvarchar(50) | NULL |  |

### `tbl_DcrBrandDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BrandDetailId | int | NOT NULL | PK, IDENTITY |
| BrandId | int | NULL |  |
| DcrId | int | NULL |  |

### `tbl_DcrDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcrDetailID | int | NOT NULL | PK, IDENTITY |
| DcrId | int | NULL |  |
| ProductId | int | NULL |  |
| Type | nvarchar(max) | NULL |  |
| ProductQty | decimal(18,0) | NULL |  |
| GWPromoQtyId | int | NULL |  |
| EmpInfoId | int | NULL |  |

### `tbl_DCRInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcrId | int | NOT NULL | PK, IDENTITY |
| DcrDate | datetime | NULL |  |
| TourTypeId | int | NULL |  |
| ChemberId | int | NULL |  |
| EntryBy | nvarchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsApproved | bit | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| DoctorId | int | NULL |  |
| DocTPDetailsId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| TerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| IsNonEffectiveReason | bit | NULL |  |
| ReasonId | int | NULL |  |
| EntryDate_Apps | datetime | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| Latitude | nvarchar(max) | NULL |  |
| Longitude | nvarchar(max) | NULL |  |
| StreetAddress | nvarchar(max) | NULL |  |
| DoctorProgramypeId | int | NULL |  |
| GroupName | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| SubTerritoryName | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| GroupCode_DCR | nvarchar(max) | NULL |  |
| RegionCode_DCR | nvarchar(max) | NULL |  |
| AreaCode_DCR | nvarchar(max) | NULL |  |
| TerritoryCode_DCR | nvarchar(max) | NULL |  |
| SubTerritoryCode_DCR | nvarchar(max) | NULL |  |
| MarketCode_DCR | nvarchar(max) | NULL |  |
| SmcTypeId_DCR | int | NULL |  |
| SMCType_DCR | nvarchar(max) | NULL |  |
| DoctorType_DCR | nvarchar(max) | NULL |  |
| DoctorTypeID_DCR | int | NULL |  |
| TypeDcr | nvarchar(max) | NULL |  |

### `tbl_DcrVisitedWithDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcrVisitWithId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| DcrId | int | NULL |  |

### `tbl_DcrVisitedWithDetailsDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| DcrVisitWithId | bigint | NOT NULL |  |
| EmpInfoId | bigint | NULL |  |
| DcrId | bigint | NOT NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tbl_District`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DistrictName | nvarchar(max) | NULL |  |
| DivisionId | int | NULL |  |
| DistrictId | int | NOT NULL | PK, IDENTITY |
| DistrictName_BN | nvarchar(max) | NULL |  |
| Lat | nvarchar(max) | NULL |  |
| Long | nvarchar(max) | NULL |  |
| url | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_Division`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DivisionId | int | NOT NULL |  |
| DivisionCode | nvarchar(max) | NULL |  |
| DivisionName | nvarchar(max) | NOT NULL |  |
| DivisionName_BN | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |

### `tbl_DoctorTourPlanDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DocTPDetailsId | int | NOT NULL | PK, IDENTITY |
| SMId | int | NULL |  |
| DoctorId | int | NULL |  |
| ShiftId | int | NULL |  |
| TourTypeId | int | NULL |  |
| TPId | int | NULL |  |
| Comment | nvarchar(max) | NULL |  |
| TourPlanDate | datetime | NULL |  |
| EmpInfoId | int | NULL |  |
| IsApproved | bit | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| DocTPMaster | int | NULL |  |
| IsDcrDone | bit | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| GroupName_DV | nvarchar(max) | NULL |  |
| RegionName_DV | nvarchar(max) | NULL |  |
| AreaName_DV | nvarchar(max) | NULL |  |
| TerritoryName_DV | nvarchar(max) | NULL |  |
| SubTerritoryName_DV | nvarchar(max) | NULL |  |
| MarketName_DV | nvarchar(max) | NULL |  |
| DoctorProgramypeId_DV | int | NULL |  |
| GroupCode_DV | nvarchar(max) | NULL |  |
| RegionCode_DV | nvarchar(max) | NULL |  |
| AreaCode_DV | nvarchar(max) | NULL |  |
| TerritoryCode_DV | nvarchar(max) | NULL |  |
| SubTerritoryCode_DV | nvarchar(max) | NULL |  |
| MarketCode_DV | nvarchar(max) | NULL |  |
| SMCTypeId_DV | int | NULL |  |
| SMCType_DV | nvarchar(max) | NULL |  |
| Type_DV | nvarchar(max) | NULL |  |
| DoctorName_DV | nvarchar(max) | NULL |  |

### `tbl_DoctorTourPlanMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DocTPMaster | int | NOT NULL | PK, IDENTITY |
| MonthValue | int | NULL |  |
| YearValue | int | NULL |  |
| EmpInfoId | int | NULL |  |
| IsFinalSubmit | bit | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| FinalSubmitRemarks | nvarchar(max) | NULL |  |
| ApprovalRemarks | nvarchar(max) | NULL |  |
| DType | nvarchar(max) | NULL |  |

### `tbl_DoctorVisitType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DocVisitTypeId | int | NOT NULL | PK, IDENTITY |
| VisitTypeName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_DWSPDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DWSPDetailId | int | NOT NULL | PK, IDENTITY |
| DWSPMasterId | int | NULL |  |
| FCBAmount | decimal(18,2) | NULL |  |
| GeneralAmount | decimal(18,2) | NULL |  |
| CampaignAmount | decimal(18,2) | NULL |  |
| DWSPDate | datetime | NULL |  |
| EmpInfoId | int | NULL |  |

### `tbl_DWSPMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DWSPMasterId | int | NOT NULL | PK, IDENTITY |
| MonthValue | int | NULL |  |
| YearValue | int | NULL |  |
| EmpInfoId | int | NULL |  |
| IsFinalSubmit | bit | NULL |  |
| FinalSubmitRemarks | nvarchar(max) | NULL |  |
| ApprovalRemarks | nvarchar(max) | NULL |  |
| OtherRemarks | nvarchar(max) | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| TerritoryId | int | NULL |  |

### `tbl_ExceptionRecords`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExceptionId | int | NOT NULL | PK, IDENTITY |
| Module | nvarchar(50) | NULL |  |
| Title | nvarchar(50) | NULL |  |
| Exception | nvarchar(max) | NULL |  |
| ExceptionDate | datetime | NULL |  |

### `tbl_ExpenseClaim`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpenseClaimID | int | NOT NULL | PK, IDENTITY |
| ExpenseTypeId | int | NULL |  |
| ExpenseDate | datetime | NULL |  |
| EmpInfoId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| ImageName | nvarchar(50) | NULL |  |
| ImagePath | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(max) | NULL |  |
| IsFromApp | bit | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tbl_ExpenseClaimDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpenseDetailId | int | NOT NULL | PK, IDENTITY |
| ExpenseClaimID | int | NULL |  |
| ExpenseTypDetailsId | int | NULL |  |
| ValueText | nvarchar(max) | NULL |  |

### `tbl_ExpenseClaimDetailsDel`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DelExpenseDetailId | int | NOT NULL | PK, IDENTITY |
| ExpenseDetailId | int | NULL |  |
| ExpenseClaimID | int | NULL |  |
| ExpenseTypDetailsId | int | NULL |  |
| ValueText | nvarchar(max) | NULL |  |

### `tbl_ExpenseClaimLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpenseClaimLogID | int | NOT NULL | PK, IDENTITY |
| ExpenseTypeId | int | NULL |  |
| ExpenseDate | datetime | NULL |  |
| EmpInfoId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| ImageName | nvarchar(50) | NULL |  |
| ImagePath | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(max) | NULL |  |
| IsFromApp | bit | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| DelBy | nvarchar(50) | NULL |  |
| DelDate | datetime | NULL |  |

### `tbl_ExpenseType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpenseTypeId | int | NOT NULL | PK, IDENTITY |
| TypeName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_ExpenseTypeDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpenseTypDetailsId | int | NOT NULL | PK, IDENTITY |
| ExpenseTypeId | int | NULL |  |
| FieldName | nvarchar(max) | NULL |  |
| IsRequied | bit | NULL |  |

### `tbl_ExpenseTypeMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpenseTypeId | int | NOT NULL | PK, IDENTITY |
| ExpenseTypeName | nvarchar(50) | NULL |  |
| ImageRequired | bit | NULL |  |
| IsActive | bit | NULL |  |
| ActiveInactiveDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsFromApp | bit | NULL |  |
| ExpenseAmount | decimal(18,2) | NULL |  |
| isFixed | bit | NULL |  |
| RoleType_xp | int | NULL |  |
| RoleTypeMult | nvarchar(max) | NULL |  |
| EmpNameMult | nvarchar(max) | NULL |  |

### `tbl_GlobalAccess_User`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GlobalUserName | nvarchar(50) | NULL |  |
| IMEI | nvarchar(max) | NULL |  |
| IMEI_Two | nvarchar(max) | NULL |  |

### `tbl_Group`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GroupId | int | NOT NULL | PK, IDENTITY |
| GroupName | nvarchar(500) | NULL |  |
| NationalId | int | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| GroupCode | nvarchar(max) | NULL |  |
| CodeStr | nvarchar(max) | NULL |  |

### `tbl_ImagePath_Setting`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ImagePathId | int | NOT NULL | PK, IDENTITY |
| ImageType | nvarchar(50) | NULL |  |
| ImagePreName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| ImagePath | nvarchar(max) | NULL |  |
| Remarks | nvarchar(50) | NULL |  |

### `tbl_LeaveTypeInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveTypeId | int | NOT NULL | PK, IDENTITY |
| LeaveTypeName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_MileageClaim`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MileageClaimId | int | NOT NULL | PK, IDENTITY |
| MileageDate | datetime | NULL |  |
| TransportId | int | NULL |  |
| MileageInKM | decimal(18,2) | NULL |  |
| MeterReading | decimal(18,2) | NULL |  |
| AllowedMileageInKM | decimal(18,2) | NULL |  |
| SMId | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| EmpInfoId | int | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdatedBy | int | NULL |  |
| UpdatedDate | datetime | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| TourTypeId | int | NULL |  |
| MileageImage | nvarchar(max) | NULL |  |
| GroupName | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| SubTerritoryName | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| GroupCode_Mil | nvarchar(max) | NULL |  |
| RegionCode_Mil | nvarchar(max) | NULL |  |
| AreaCode_Mil | nvarchar(max) | NULL |  |
| TerritoryCode_Mil | nvarchar(max) | NULL |  |
| SubTerritoryCode_Mil | nvarchar(max) | NULL |  |
| MarketCode_Mil | nvarchar(max) | NULL |  |

### `tbl_MonthlyAllowance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MonthlyAllowanceId | int | NOT NULL | PK, IDENTITY |
| MonthlyAllowanceName | nvarchar(500) | NULL |  |
| MonthlyAllowance | decimal(18,2) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tbl_MonthlyAllowanceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MonthlyAllowanceDetailId | int | NOT NULL | PK, IDENTITY |
| MonthlyAllowanceId | int | NULL |  |
| EmpInfoId | int | NULL |  |
| UserRoleId | int | NULL |  |

### `tbl_National`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NationalId | int | NOT NULL | PK, IDENTITY |
| NationalName | nvarchar(500) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| NationalCode | nvarchar(max) | NULL |  |
| NationalStr | nvarchar(max) | NULL |  |

### `tbl_Notice_Image`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NoticeImageId | int | NOT NULL | PK, IDENTITY |
| NoticeId | int | NOT NULL |  |
| ImagePath | nvarchar(max) | NOT NULL |  |
| ImageName | nvarchar(max) | NULL |  |

### `tbl_Notice_MarketDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NoticeDetailsId | int | NOT NULL | PK, IDENTITY |
| NoticeId | int | NOT NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `tbl_Notice_MarketMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NoticeId | int | NOT NULL | PK, IDENTITY |
| NoticeTitle | nvarchar(max) | NOT NULL |  |
| Announcement | nvarchar(max) | NULL |  |
| FromDate | datetime | NULL |  |
| ToDate | datetime | NULL |  |
| EntryDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| IsReaded | bit | NULL |  |
| CompanyId | int | NULL |  |
| IsPublish | bit | NULL |  |
| UpdateDate | datetime | NULL |  |
| UpdateBy | nvarchar(500) | NULL |  |
| IsPushNotification | bit | NULL |  |

### `tbl_Notice_UserDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NoticeUserId | int | NOT NULL | PK, IDENTITY |
| MasterId | int | NULL |  |
| UserId | int | NULL |  |

### `tbl_Notification`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NotificationId | int | NOT NULL | PK, IDENTITY |
| NotificationType | nvarchar(50) | NULL |  |
| NotificationPrimaryText | nvarchar(max) | NULL |  |
| NotificationMainText | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| IsRead | bit | NULL |  |
| EmpInfoId | int | NULL |  |
| NotificationGroupId | int | NULL |  |
| PrimaryId | int | NULL |  |

### `tbl_NotificationGroup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NotificationGroupId | int | NULL |  |
| GroupName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_PrescriptionMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PrescriptionId | int | NOT NULL | PK, IDENTITY |
| PrescriptionDate | datetime | NULL |  |
| PrescriptionTypeId | int | NULL |  |
| DoctorId | int | NULL |  |
| ImagePath | nvarchar(max) | NULL |  |
| ImageName | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ChemberId | int | NULL |  |
| TerritoryId | nchar(10) | NULL |  |
| SubTerritoryId | nchar(10) | NULL |  |
| MarketId | nchar(10) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| DoctorProgramypeId | int | NULL |  |
| GroupName | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| SubTerritoryName | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| GroupCode_RX | nvarchar(max) | NULL |  |
| RegionCode_RX | nvarchar(max) | NULL |  |
| AreaCode_RX | nvarchar(max) | NULL |  |
| TerritoryCode_RX | nvarchar(max) | NULL |  |
| SubTerritoryCode_RX | nvarchar(max) | NULL |  |
| MarketCode_RX | nvarchar(max) | NULL |  |
| SmcTypeId_RX | int | NULL |  |
| SMCType_RX | nvarchar(max) | NULL |  |
| DoctorType_RX | nvarchar(max) | NULL |  |
| DoctorTypeId_RX | int | NULL |  |
| EntryDateDate | date | NULL |  |

### `tbl_PrescriptionMasterDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PrescriptionId | int | NOT NULL | IDENTITY |
| PrescriptionDate | datetime | NULL |  |
| PrescriptionTypeId | int | NULL |  |
| DoctorId | int | NULL |  |
| ImagePath | nvarchar(max) | NULL |  |
| ImageName | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ChemberId | int | NULL |  |
| TerritoryId | nchar(10) | NULL |  |
| SubTerritoryId | nchar(10) | NULL |  |
| MarketId | nchar(10) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| DoctorProgramypeId | int | NULL |  |
| GroupName | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| SubTerritoryName | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| GroupCode_RX | nvarchar(max) | NULL |  |
| RegionCode_RX | nvarchar(max) | NULL |  |
| AreaCode_RX | nvarchar(max) | NULL |  |
| TerritoryCode_RX | nvarchar(max) | NULL |  |
| SubTerritoryCode_RX | nvarchar(max) | NULL |  |
| MarketCode_RX | nvarchar(max) | NULL |  |
| SmcTypeId_RX | int | NULL |  |
| SMCType_RX | nvarchar(max) | NULL |  |
| DoctorType_RX | nvarchar(max) | NULL |  |
| DoctorTypeId_RX | int | NULL |  |
| EntryDateDate | date | NULL |  |

### `tbl_PrescriptionProductDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PresDetailId | int | NOT NULL | PK, IDENTITY |
| PrescriptionId | int | NULL |  |
| ProductId | int | NULL |  |

### `tbl_PrescriptionProductDetailDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PresDetailId | int | NOT NULL | IDENTITY |
| PrescriptionId | int | NULL |  |
| ProductId | int | NULL |  |

### `tbl_PrescriptionType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PrescriptionTypeId | int | NOT NULL | PK, IDENTITY |
| PrescriptionType | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveInactiveDate | datetime | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tbl_PrescriptionType_Log`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Log_PrescriptionTypeId | int | NOT NULL | PK, IDENTITY |
| PrescriptionTypeId | int | NULL |  |
| PrescriptionType | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveInactiveDate | datetime | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tbl_ProcedureExecutionStats`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Id | int | NOT NULL | PK, IDENTITY |
| DatabaseName | nvarchar(128) | NULL |  |
| ProcedureName | nvarchar(128) | NULL |  |
| ExecutionCount | bigint | NULL |  |
| LastExecutionTime | datetime | NULL |  |

### `tbl_Sap_AM_DASM`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAPCode | nvarchar(max) | NULL |  |
| EmpCode | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |

### `tbl_SAP_User`

| Column | Type | Nullable | Key |
|---|---|---|---|
| User_Id | int | NOT NULL | IDENTITY |
| UserName | nvarchar(max) | NULL |  |
| Password | nvarchar(max) | NULL |  |

### `tbl_Shift`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ShiftId | int | NOT NULL | PK, IDENTITY |
| ShiftText | nvarchar(max) | NULL |  |
| ShiftInTime | time | NULL |  |
| ShiftOutTime | time | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tbl_SubMarket`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SMId | int | NOT NULL | PK, IDENTITY |
| SMCode | nvarchar(50) | NULL |  |
| SMName | nvarchar(max) | NULL |  |
| MarketId | int | NOT NULL |  |
| IsActive | bit | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdatedBy | nvarchar(50) | NULL |  |
| UpdatedDate | datetime | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `tbl_TadaClaimDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TadaDetailId | int | NOT NULL | PK, IDENTITY |
| TadaID | int | NULL |  |
| TourPlanId | int | NULL |  |
| TaAmt | decimal(18,2) | NULL |  |
| DaAmt | decimal(18,2) | NULL |  |

### `tbl_TadaClaimMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TadaID | int | NOT NULL | PK, IDENTITY |
| TadaDate | datetime | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| EmpInfoId | int | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| DAAmount | decimal(18,2) | NULL |  |
| TourTypeId | int | NULL |  |
| HotelName | nvarchar(max) | NULL |  |
| HotelPhone | nvarchar(max) | NULL |  |
| GroupName | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| SubTerritoryName | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| GroupCode_DA | nvarchar(max) | NULL |  |
| RegionCode_DA | nvarchar(max) | NULL |  |
| AreaCode_DA | nvarchar(max) | NULL |  |
| TerritoryCode_DA | nvarchar(max) | NULL |  |
| SubTerritoryCode_DA | nvarchar(max) | NULL |  |
| MarketCode_DA | nvarchar(max) | NULL |  |

### `tbl_TADAMarketRulesConfig`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TADAMarketRuleConfigId | int | NOT NULL | PK, IDENTITY |
| TourType | int | NULL |  |
| TAAmount | decimal(18,2) | NULL |  |
| DAAmount | decimal(18,2) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsRoleWise | bit | NULL |  |
| IsMarketWise | bit | NULL |  |
| IsBoth | bit | NULL |  |
| UserRoleID | int | NULL |  |
| GroupId | int | NULL |  |
| ZoneId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `tbl_TempAllMonthforWeek`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MonthValue | nvarchar(50) | NULL |  |
| LastDateofTheMonth | nvarchar(50) | NULL |  |

### `tbl_TerritoryThanaRelation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TurId | int | NOT NULL | PK, IDENTITY |
| TerritoryId | int | NULL |  |
| ThanaId | int | NULL |  |

### `tbl_Thana`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ThanaName | nvarchar(max) | NULL |  |
| district_id | int | NULL |  |
| ThanaId | int | NOT NULL | PK, IDENTITY |
| ThanaName_BN | nvarchar(max) | NULL |  |
| ThanaCode | nvarchar(50) | NULL |  |
| url | nvarchar(max) | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| IsActive | bit | NULL |  |

### `tbl_TourPlanInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPlanId | int | NOT NULL | PK, IDENTITY |
| SMId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| ShiftId | int | NULL |  |
| TourTypeId | int | NULL |  |
| TPId | int | NULL |  |
| Comment | nvarchar(max) | NULL |  |
| TourPlanDate | datetime | NULL |  |
| EmpInfoId | int | NULL |  |
| IsMarketWise | bit | NULL |  |
| IsApproved | bit | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| TPMaster | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| GroupName | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| SubTerritoryName | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| GroupCode_TP | nvarchar(max) | NULL |  |
| RegionCode_TP | nvarchar(max) | NULL |  |
| AreaCode_TP | nvarchar(max) | NULL |  |
| TerritoryCode_TP | nvarchar(max) | NULL |  |
| SubTerritoryCode_TP | nvarchar(max) | NULL |  |
| MarketCode_TP | nvarchar(max) | NULL |  |
| SerialNo | int | NULL |  |
| IsMorning | bit | NULL |  |
| IsEvening | bit | NULL |  |
| IsStartTime | bit | NULL |  |
| Starttime | nvarchar(50) | NULL |  |
| IsEndtime | bit | NULL |  |
| Endtime | nvarchar(50) | NULL |  |
| VisitedWithEmpInfoId | int | NULL |  |
| GroupIdEnd | int | NULL |  |
| RegionIdEnd | int | NULL |  |
| AreaIdEnd | int | NULL |  |
| TerritoryIdEnd | int | NULL |  |
| SubTerritoryIdEnd | int | NULL |  |
| MarketIdEnd | int | NULL |  |
| GroupNameEnd | nvarchar(max) | NULL |  |
| RegionNameEnd | nvarchar(max) | NULL |  |
| AreaNameEnd | nvarchar(max) | NULL |  |
| TerritoryNameEnd | nvarchar(max) | NULL |  |
| SubTerritoryNameEnd | nvarchar(max) | NULL |  |
| MarketNameEnd | nvarchar(max) | NULL |  |
| GroupCode_TPEnd | nvarchar(max) | NULL |  |
| RegionCode_TPEnd | nvarchar(max) | NULL |  |
| AreaCode_TPEnd | nvarchar(max) | NULL |  |
| TerritoryCode_TPEnd | nvarchar(max) | NULL |  |
| SubTerritoryCode_TPEnd | nvarchar(max) | NULL |  |
| MarketCode_TPEnd | nvarchar(max) | NULL |  |
| IsMarketVisit | bit | NULL |  |
| IsOtherVisit | bit | NULL |  |
| OtherMarketNameVisited | nvarchar(max) | NULL |  |
| Objective | nvarchar(max) | NULL |  |

### `tbl_TourPlanMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TPMaster | int | NOT NULL | PK, IDENTITY |
| MonthValue | int | NULL |  |
| YearValue | int | NULL |  |
| EmpInfoId | int | NULL |  |
| IsFinalSubmit | bit | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| FinalSubmitRemarks | nvarchar(max) | NULL |  |
| ApprovalRemarks | nvarchar(max) | NULL |  |

### `tbl_TourPlanMaster_Backup_2022_2024`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BackupId | int | NOT NULL | PK, IDENTITY |
| TPMaster | int | NULL |  |
| MonthValue | int | NULL |  |
| YearValue | int | NULL |  |
| EmpInfoId | int | NULL |  |
| IsFinalSubmit | bit | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| FinalSubmitRemarks | nvarchar(max) | NULL |  |
| ApprovalRemarks | nvarchar(max) | NULL |  |

### `tbl_TourPlanPurpose`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TPId | int | NOT NULL | PK, IDENTITY |
| TPName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |
| IsExtraBenifit | bit | NULL |  |
| MIOAmount | decimal(18,2) | NULL |  |
| AMAmount | decimal(18,2) | NULL |  |
| DZSMAmount | decimal(18,2) | NULL |  |
| IsMarketVisit | int | NULL |  |
| IsOtherVisit | int | NULL |  |

### `tbl_TourPlanType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourTypeId | int | NOT NULL | PK, IDENTITY |
| TourTypeName | nvarchar(max) | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tbl_TrainingMarketDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TrainingMarketDetailId | int | NOT NULL | PK, IDENTITY |
| TrainningId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `tbl_Transport`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TransportId | int | NOT NULL | PK, IDENTITY |
| TransportName | nvarchar(50) | NULL |  |
| AllowedMilagePerKM | decimal(18,2) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tbl_UserMarketDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserMarketDetailId | int | NOT NULL | PK, IDENTITY |
| UserId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |

### `tbl_UserRoleInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserRoleID | int | NOT NULL | PK, IDENTITY |
| RoleName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| ActiveInActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| RoleTypeId | int | NULL |  |
| IsApprove | bit | NULL |  |
| IsForward | bit | NULL |  |

### `tbl_UserTracking`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TrackingId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| LatValue | nvarchar(max) | NULL |  |
| LongValue | nvarchar(max) | NULL |  |
| AddressName | nvarchar(max) | NULL |  |
| Time | nvarchar(50) | NULL |  |
| TrackDate | datetime | NULL |  |

### `tbl_UserTrackingOld`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TrackingId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| LatValue | nvarchar(max) | NULL |  |
| LongValue | nvarchar(max) | NULL |  |
| AddressName | nvarchar(max) | NULL |  |
| Time | nvarchar(50) | NULL |  |
| TrackDate | datetime | NULL |  |

### `tbl_ZoneDivisionRelation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ZdrId | int | NOT NULL | PK, IDENTITY |
| ZoneId | int | NOT NULL |  |
| DivisionId | int | NOT NULL |  |

### `tblAction`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ActionId | int | NOT NULL | PK |
| ActionText | nvarchar(50) | NULL |  |
| ActionValue | nvarchar(50) | NULL |  |
| IsShow | bit | NULL |  |

### `tblActionPageWiseStep`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PWASId | int | NOT NULL | PK |
| ManuSL | int | NULL |  |
| ASId | int | NULL |  |

### `tblActionStatus`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ActionId | int | NOT NULL | PK, IDENTITY |
| ActionStatus | nvarchar(500) | NULL |  |
| SoftwareUseId | int | NULL |  |
| WebShow | nvarchar(500) | NULL |  |
| IsActive | bit | NULL |  |

### `tblActionStepDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ASWLId | int | NOT NULL | PK |
| ASId | int | NULL |  |
| ActionId | int | NULL |  |
| ActionCondition | nvarchar(max) | NULL |  |

### `tblActionSteps`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ASId | int | NOT NULL | PK |
| ActionSteps | nvarchar(max) | NULL |  |

### `tblActionUserWiseApproval`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UWAId | int | NOT NULL | PK |
| UserId | int | NULL |  |
| LoginName | nvarchar(50) | NULL |  |
| ManuSL | int | NULL |  |
| ActionId | int | NULL |  |

### `tblAdjustmentType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AdjustmentTypeId | int | NOT NULL | PK, IDENTITY |
| AdjustmentType | nvarchar(50) | NULL |  |

### `tblApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |

### `tblApprovalMapDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ApprovalMapDetailId | int | NOT NULL | PK, IDENTITY |
| ApprovalMapMasterId | int | NULL |  |
| ToRoleId | int | NULL |  |
| Order | int | NULL |  |

### `tblApprovalMapMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ApprovalMapMasterId | int | NOT NULL | PK, IDENTITY |
| MenuId | int | NULL |  |
| MenuName | nvarchar(50) | NULL |  |
| FromRoleId | int | NULL |  |

### `tblApprovalStep`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ApprovalStepsId | int | NOT NULL | PK, IDENTITY |
| Page | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| ApprovalType | nvarchar(50) | NULL |  |
| URL | nvarchar(50) | NULL |  |
| SL | int | NULL |  |

### `tblApprovalStepMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AppMasterId | int | NOT NULL | PK, IDENTITY |
| SL | int | NULL |  |
| Steps | nchar(10) | NULL |  |

### `tblApprovalStepsNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ApprovalStepsId | int | NOT NULL | PK, IDENTITY |
| PageName | nvarchar(50) | NULL |  |
| Url | nvarchar(50) | NULL |  |
| SL | int | NULL |  |
| StepType | nvarchar(50) | NULL |  |
| StepOrder | int | NULL |  |
| RoleName | nvarchar(50) | NULL |  |
| ApprovalStepMasterId | int | NULL |  |

### `tblAppSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AppSetupId | int | NOT NULL | PK, IDENTITY |
| SL | int | NULL |  |
| UserId | int | NULL |  |
| Email | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblAppVersionControl`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Id | int | NOT NULL | PK, IDENTITY |
| AppName | nvarchar(100) | NOT NULL |  |
| LatestVersionCode | int | NOT NULL |  |
| LatestVersionName | nvarchar(50) | NOT NULL |  |
| MinimumRequiredVersionCode | int | NOT NULL |  |
| UpdateUrl | nvarchar(500) | NULL |  |
| ReleaseNotes | nvarchar(max) | NULL |  |
| IsActive | bit | NOT NULL |  |
| CreatedDate | datetime | NOT NULL |  |
| UpdatedDate | datetime | NULL |  |

### `tblArcDBConnect`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SL | int | NOT NULL | PK, IDENTITY |
| FY | nvarchar(max) | NULL |  |
| DataBaseName | nvarchar(max) | NULL |  |

### `tblArea`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AreaCode | nvarchar(500) | NULL |  |
| AreaName | nvarchar(500) | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NOT NULL | PK, IDENTITY |
| New | nvarchar(50) | NULL |  |
| DistrictId | int | NULL |  |
| MiaId | int | NULL |  |
| IsActive | int | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| ActiveInactiveBy | nvarchar(50) | NULL |  |
| CodeStr | nvarchar(500) | NULL |  |
| SAP_Code | nvarchar(500) | NULL |  |
| SAP_Name | nvarchar(500) | NULL |  |

### `tblAreaSubDepotPermission`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AreaSubDepotPermissionId | int | NOT NULL | PK |
| AreaId | int | NOT NULL |  |
| SubDCStoreId | int | NOT NULL |  |
| IsActive | bit | NOT NULL |  |

### `tblAreaWiseTargetSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AreaWTSetupId | int | NOT NULL | PK, IDENTITY |
| Year | nvarchar(50) | NULL |  |
| Month | nvarchar(50) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| TargetAmount | decimal(18,2) | NULL |  |
| AreaId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblASMInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmployeeId | int | NULL |  |
| AreaId | int | NULL |  |
| IsActive | bit | NULL |  |
| ASMId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| ActiveDate | datetime | NULL |  |
| ActiveInActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Vacant | nvarchar(50) | NULL |  |
| IsBaseAM | bit | NULL |  |
| ASMSapCode | nvarchar(50) | NULL |  |

### `tblBankInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BankName | nvarchar(max) | NULL |  |
| BankId | int | NOT NULL | PK, IDENTITY |
| IsBankActive | bit | NULL |  |
| DisplayBankName | nvarchar(max) | NULL |  |

### `tblBankInfoNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BankId | int | NOT NULL | PK, IDENTITY |
| SalesDepot | nvarchar(max) | NULL |  |
| BankAccountName | nvarchar(max) | NULL |  |
| BankAccountNumber | nvarchar(max) | NULL |  |
| AccountType | nvarchar(max) | NULL |  |
| BankName | nvarchar(max) | NULL |  |
| BranchName | nvarchar(max) | NULL |  |
| RoutingNumber | nvarchar(max) | NULL |  |
| Currency | nvarchar(max) | NULL |  |
| Remark | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| ComUnitId | int | NULL |  |
| BankOldId | int | NULL |  |

### `tblBankSAPMapping`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BankAccNo | nvarchar(max) | NULL |  |
| SAP_Map | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |
| Note | nvarchar(max) | NULL |  |

### `tblBiz_DataSent`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderID | nvarchar(max) | NULL |  |
| OrderTime | datetime | NULL |  |
| InvoiceID | nvarchar(max) | NULL |  |
| InvoiceTime | datetime | NULL |  |
| ReferenceID | nvarchar(max) | NULL |  |
| OrderAmount | nvarchar(max) | NULL |  |
| InvoiceAmount | nvarchar(max) | NULL |  |

### `tblBizOrder`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderNo | nvarchar(max) | NULL |  |

### `tblBonusCampaignMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampgainMasterId | int | NOT NULL | PK, IDENTITY |
| CampaignCode | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| CampaignDesc | nvarchar(max) | NULL |  |
| FromDate | datetime | NULL |  |
| Todate | datetime | NULL |  |
| Type | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tblBonusCampgainDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampaignDetailId | int | NOT NULL | PK, IDENTITY |
| CampgainMasterId | int | NULL |  |
| PointProductCode | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusProductCode | nvarchar(50) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| IsActive | bit | NULL |  |
| FromDate | datetime | NULL |  |
| FromTime | time | NULL |  |
| ToDate | datetime | NULL |  |
| ToTime | time | NULL |  |
| IsSame | bit | NULL |  |

### `tblBounsCampPro`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BounsCampProId | int | NOT NULL | PK, IDENTITY |
| ProId | int | NULL |  |

### `tblBranchInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BranchId | int | NOT NULL | PK, IDENTITY |
| BankId | int | NULL |  |
| BranchName | nvarchar(max) | NULL |  |

### `tblBSPDistrict`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DistrictId | int | NOT NULL | PK, IDENTITY |
| DivisionId | int | NOT NULL |  |
| DistrictName | nvarchar(100) | NOT NULL |  |
| IsActive | bit | NOT NULL |  |
| CreatedAt | datetime2 | NOT NULL |  |

### `tblBSPDivision`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DivisionId | int | NOT NULL | PK, IDENTITY |
| DivisionName | nvarchar(100) | NOT NULL |  |
| IsActive | bit | NOT NULL |  |
| CreatedAt | datetime2 | NOT NULL |  |

### `tblBSPUpazila`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UpazilaId | int | NOT NULL | PK, IDENTITY |
| DistrictId | int | NOT NULL |  |
| UpazilaName | nvarchar(100) | NOT NULL |  |
| IsActive | bit | NOT NULL |  |
| CreatedAt | datetime2 | NOT NULL |  |

### `tblCampaignBonusMap`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampaignBonusMapId | int | NOT NULL | PK, IDENTITY |
| CampainTypeId | int | NULL |  |
| BonusTypeId | int | NULL |  |
| IsActive | bit | NULL |  |

### `tblCampaignCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CampaignCategoryId | int | NOT NULL | PK, IDENTITY |
| CampaignCategory | nvarchar(500) | NULL |  |

### `tblCentralStore`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReceiveId | int | NOT NULL | PK, IDENTITY |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| ProductName | nvarchar(max) | NOT NULL |  |
| PackSize | nvarchar(50) | NOT NULL |  |
| BatchNo | nvarchar(max) | NOT NULL |  |
| Quantity | decimal(18,0) | NOT NULL |  |
| MfgDate | datetime | NOT NULL |  |
| ExpDate | datetime | NOT NULL |  |
| ReceiveDate | datetime | NOT NULL |  |
| ChalanNo | nvarchar(max) | NOT NULL |  |
| ChalanDate | datetime | NOT NULL |  |
| StockInQty | decimal(18,0) | NOT NULL |  |
| UnitPrice | decimal(18,2) | NOT NULL |  |
| TotalPrice | decimal(18,2) | NOT NULL |  |
| VATPerUnit | decimal(18,2) | NOT NULL |  |
| TotalVAT | decimal(18,2) | NOT NULL |  |
| TotalAmount | decimal(18,2) | NOT NULL |  |
| StockCondition | nvarchar(50) | NOT NULL |  |
| MigoDetailID | int | NOT NULL |  |
| DeveloperRemarks | nvarchar(500) | NULL |  |
| ProductStockType | nvarchar(50) | NOT NULL |  |
| InternalNoteNo | nvarchar(50) | NULL |  |
| DCStoreFreezeId | int | NULL |  |
| DCStoreId | int | NULL |  |
| WarehouseId | int | NULL |  |
| Remarks | nvarchar(50) | NULL |  |

### `tblCentralStore_OpeninigBalance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CSOpeninigBalanceId | int | NOT NULL | PK, IDENTITY |
| CSOpeninigBalanceDate | datetime | NOT NULL |  |
| ReceiveId | int | NOT NULL |  |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| ProductName | nvarchar(max) | NOT NULL |  |
| PackSize | nvarchar(50) | NOT NULL |  |
| BatchNo | nvarchar(max) | NOT NULL |  |
| Quantity | decimal(18,0) | NOT NULL |  |
| MfgDate | datetime | NOT NULL |  |
| ExpDate | datetime | NOT NULL |  |
| ReceiveDate | datetime | NOT NULL |  |
| ChalanNo | nvarchar(max) | NOT NULL |  |
| ChalanDate | datetime | NOT NULL |  |
| StockInQty | decimal(18,0) | NOT NULL |  |
| UnitPrice | decimal(18,2) | NOT NULL |  |
| TotalPrice | decimal(18,2) | NOT NULL |  |
| VATPerUnit | decimal(18,2) | NOT NULL |  |
| TotalVAT | decimal(18,2) | NOT NULL |  |
| TotalAmount | decimal(18,2) | NOT NULL |  |
| StockCondition | nvarchar(50) | NOT NULL |  |
| MigoDetailID | int | NOT NULL |  |
| DeveloperRemarks | nvarchar(500) | NULL |  |
| ProductStockType | nvarchar(50) | NOT NULL |  |
| InternalNoteNo | nvarchar(50) | NULL |  |

### `tblChalanDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ChalanDetailsId | int | NOT NULL | PK |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BatchNo | nvarchar(50) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| Value | decimal(18,2) | NULL |  |
| Vat | decimal(18,2) | NULL |  |
| ValueWVat | decimal(18,2) | NULL |  |
| ChalanId | int | NOT NULL |  |
| DCStoreId | int | NULL |  |

### `tblChalanInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ChalanId | int | NOT NULL | PK |
| ChalanDate | date | NULL |  |
| ChalanNo | nvarchar(255) | NULL |  |
| TrackNo | nvarchar(max) | NULL |  |
| DriverName | nvarchar(max) | NULL |  |
| FromComUnitCode | nvarchar(max) | NULL |  |
| FromComUnitName | nvarchar(max) | NULL |  |
| FromComUnitAddress | nvarchar(max) | NULL |  |
| ToComUnitCode | nvarchar(max) | NULL |  |
| ToComUnitName | nvarchar(max) | NULL |  |
| ToComUnitAddress | nvarchar(max) | NULL |  |
| TotalValue | decimal(18,2) | NULL |  |
| TotalVat | decimal(18,2) | NULL |  |
| GrandTotal | decimal(18,2) | NULL |  |
| ManufacId | int | NULL |  |
| IsDeliver | nvarchar(50) | NULL |  |
| FromComUnitId | int | NULL |  |
| Note | nvarchar(50) | NULL |  |
| SAP_ChallanSend | bit | NULL |  |
| SAP_ChallanRecevie | bit | NULL |  |
| SAP_Challan_ConfirmationSend | bit | NULL |  |

### `tblChangeCustomerSalesCenter`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SalesCenterCode | nvarchar(max) | NULL |  |
| Name | nvarchar(max) | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |

### `tblChege`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NewId | nvarchar(50) | NULL |  |
| DOJ | datetime | NULL |  |
| PNo | nvarchar(50) | NULL |  |

### `tblCompanyInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CompanyId | int | NOT NULL | PK, IDENTITY |
| CompanyCode | nvarchar(50) | NULL |  |
| CompanyName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| ContactNo | nvarchar(max) | NULL |  |
| FaxNo | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `tblCompanyUnit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ComUnitId | int | NOT NULL | PK |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(50) | NULL |  |
| Address | nvarchar(500) | NULL |  |
| PhoneNo | nvarchar(50) | NULL |  |
| MobileNo | nvarchar(50) | NULL |  |
| FaxNo | nvarchar(50) | NULL |  |
| RegionId | int | NULL |  |
| ShortName | nvarchar(50) | NULL |  |
| CompanyId | int | NULL |  |
| SAP_Code | nvarchar(50) | NULL |  |
| Customer_Code | nvarchar(50) | NULL |  |

### `tblCompanyWiseDeposit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DepositId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| BranchName | nvarchar(max) | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| DepositDate | date | NULL |  |
| IsDelete | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |
| DepositType | nvarchar(50) | NULL |  |
| AccountName | nvarchar(max) | NULL |  |
| CheckNumber | nvarchar(max) | NULL |  |
| CheckDate | datetime | NULL |  |
| BankId | int | NULL |  |
| IsExcelUpload | bit | NULL |  |
| AIT | decimal(18,2) | NULL |  |
| EmployeeId | int | NULL |  |
| EmpMasterCode | nvarchar(max) | NULL |  |
| EmpName | nvarchar(max) | NULL |  |
| TerritoryId | int | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| mioId | int | NULL |  |
| SAP_MIOCode_ | nvarchar(max) | NULL |  |
| DepositCode | nvarchar(max) | NULL |  |

### `tblConsumerCustomer`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ConsumerCustId | int | NOT NULL | PK |
| CustomerName | nvarchar(50) | NULL |  |
| CustomerPhoneNo | nvarchar(50) | NULL |  |
| CustomerAddress | nvarchar(max) | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |

### `tblConvQty`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductCode | nvarchar(max) | NOT NULL |  |
| ConvertionQty | int | NULL |  |

### `tblCostPriceUpdate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductCode | nvarchar(250) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |

### `tblCreditAdjustment`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CrditAdjustmentId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| InvoiceId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| ReturnDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| NTInvoiceId | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `tblCurrentStock`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockId | int | NOT NULL | PK |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| PackSize | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |

### `tblCusDocTran`

| Column | Type | Nullable | Key |
|---|---|---|---|
| cusDocTranId | int | NOT NULL | PK, IDENTITY |
| EntryBy | int | NULL |  |

### `tblCustCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CategoryId | int | NOT NULL | PK |
| CategoryCode | nvarchar(50) | NULL |  |
| CategoryName | nvarchar(50) | NULL |  |

### `tblCusTerritoryChange`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Customercode | nchar(10) | NULL |  |
| TerritoryCode | nchar(10) | NULL |  |
| CustomerID | int | NULL |  |

### `tblCustMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerMasterId | int | NOT NULL | PK, IDENTITY |
| CustomerCode | nvarchar(50) | NULL |  |
| CategoryId | int | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| CellNo | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| Addrees2 | nvarchar(max) | NULL |  |
| City | nvarchar(max) | NULL |  |
| ConPerson | nvarchar(max) | NULL |  |
| ShippingCond | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| TermOfPayment | nvarchar(50) | NULL |  |
| CustomerCodeOld | nvarchar(50) | NULL |  |
| UploadDate | datetime | NULL |  |
| ExcelUpload | bit | NULL |  |
| FixedCustomer | bit | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Type | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| IsActive | bit | NULL |  |
| InActiveDate | nvarchar(max) | NULL |  |
| CustomerStation | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Thana | nvarchar(max) | NULL |  |
| Upazila | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AITGLId | int | NULL |  |
| CustomerTypeId | int | NULL |  |
| DistrictId | int | NULL |  |
| DivisionId | int | NULL |  |
| ThanaId | int | NULL |  |
| StationTypeId | int | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| IsVatApplicable | bit | NULL |  |
| DistributionRouteId | int | NULL |  |
| OwnerName | nvarchar(max) | NULL |  |
| VoterID | nvarchar(max) | NULL |  |
| TradeLicense | nvarchar(max) | NULL |  |
| DrugLicense | nvarchar(max) | NULL |  |
| PharmacyCouncilCertificate | nvarchar(max) | NULL |  |
| BCDS | nvarchar(max) | NULL |  |
| ProgramTypeId | int | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | nvarchar(max) | NULL |  |
| ActionStatus | nvarchar(max) | NULL |  |
| Email | nvarchar(max) | NULL |  |
| Reamrks | nvarchar(max) | NULL |  |
| Latitude | nvarchar(max) | NULL |  |
| Longitude | nvarchar(max) | NULL |  |
| LocationUpdateBy | int | NULL |  |
| LocationUpdateTime | datetime | NULL |  |
| StreetAddress | nvarchar(max) | NULL |  |
| NSMStationTypeId | int | NULL |  |
| DZSMStationTypeId | int | NULL |  |
| ProgramTypeCode | nvarchar(max) | NULL |  |
| COldCode | nvarchar(max) | NULL |  |
| IsMarketUpdate2022 | bit | NULL |  |
| SMCTypeId | int | NULL |  |
| CustomerBsPCode | nvarchar(max) | NULL |  |
| CustomerBsPCodeUpdateBy | int | NULL |  |
| CustomerBsPCodeDate | datetime | NULL |  |
| CustomerBsPCodeInfo | nvarchar(max) | NULL |  |
| CustomerBsPCodeUpdateDate | datetime | NULL |  |
| CustomerBsPTag | nvarchar(20) | NULL |  |
| NormalizedCustomerCode | nvarchar(50) | NULL |  |
| PreProgramIDD | int | NULL |  |

### `tblCustMaster_Log`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerMasterLogId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CategoryId | int | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| CellNo | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| Addrees2 | nvarchar(max) | NULL |  |
| City | nvarchar(max) | NULL |  |
| ConPerson | nvarchar(max) | NULL |  |
| ShippingCond | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| TermOfPayment | nvarchar(50) | NULL |  |
| CustomerCodeOld | nvarchar(50) | NULL |  |
| UploadDate | datetime | NULL |  |
| ExcelUpload | bit | NULL |  |
| FixedCustomer | bit | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Type | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| IsActive | bit | NULL |  |
| InActiveDate | nvarchar(max) | NULL |  |
| CustomerStation | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Thana | nvarchar(max) | NULL |  |
| Upazila | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AITGLId | int | NULL |  |
| CustomerTypeId | int | NULL |  |
| DistrictId | int | NULL |  |
| DivisionId | int | NULL |  |
| ThanaId | int | NULL |  |
| StationTypeId | int | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| IsVatApplicable | bit | NULL |  |
| DistributionRouteId | int | NULL |  |
| OwnerName | nvarchar(max) | NULL |  |
| VoterID | nvarchar(max) | NULL |  |
| TradeLicense | nvarchar(max) | NULL |  |
| DrugLicense | nvarchar(max) | NULL |  |
| PharmacyCouncilCertificate | nvarchar(max) | NULL |  |
| BCDS | nvarchar(max) | NULL |  |
| ProgramTypeId | int | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | nvarchar(max) | NULL |  |
| ActionStatus | nvarchar(max) | NULL |  |
| Email | nvarchar(max) | NULL |  |
| Reamrks | nvarchar(max) | NULL |  |
| Latitude | nvarchar(max) | NULL |  |
| Longitude | nvarchar(max) | NULL |  |
| LocationUpdateBy | int | NULL |  |
| LocationUpdateTime | datetime | NULL |  |
| StreetAddress | nvarchar(max) | NULL |  |
| NSMStationTypeId | int | NULL |  |
| DZSMStationTypeId | int | NULL |  |
| ProgramTypeCode | nvarchar(max) | NULL |  |
| COldCode | nvarchar(max) | NULL |  |
| LogBy | nvarchar(50) | NULL |  |
| LogDate | datetime | NULL |  |

### `tblCustMaster_TranferLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustMaster_TranferLogId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CategoryId | int | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| CellNo | nvarchar(max) | NULL |  |
| MarketId | int | NULL |  |
| Addrees2 | nvarchar(max) | NULL |  |
| City | nvarchar(max) | NULL |  |
| ConPerson | nvarchar(max) | NULL |  |
| ShippingCond | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| TermOfPayment | nvarchar(50) | NULL |  |
| CustomerCodeOld | nvarchar(50) | NULL |  |
| UploadDate | datetime | NULL |  |
| ExcelUpload | bit | NULL |  |
| FixedCustomer | bit | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Type | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| IsActive | bit | NULL |  |
| InActiveDate | nvarchar(max) | NULL |  |
| CustomerStation | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Thana | nvarchar(max) | NULL |  |
| Upazila | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AITGLId | int | NULL |  |
| CustomerTypeId | int | NULL |  |
| DistrictId | int | NULL |  |
| DivisionId | int | NULL |  |
| ThanaId | int | NULL |  |
| StationTypeId | int | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| IsVatApplicable | bit | NULL |  |
| DistributionRouteId | int | NULL |  |
| OwnerName | nvarchar(max) | NULL |  |
| VoterID | nvarchar(max) | NULL |  |
| TradeLicense | nvarchar(max) | NULL |  |
| DrugLicense | nvarchar(max) | NULL |  |
| PharmacyCouncilCertificate | nvarchar(max) | NULL |  |
| BCDS | nvarchar(max) | NULL |  |
| ProgramTypeId | int | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | nvarchar(max) | NULL |  |
| ActionStatus | nvarchar(max) | NULL |  |
| Email | nvarchar(max) | NULL |  |
| Reamrks | nvarchar(max) | NULL |  |
| TranferBy | int | NULL |  |
| TranferDate | datetime | NULL |  |
| IsApprove | bit | NULL |  |
| MasterId | int | NULL |  |

### `tblCustMasterCamp`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustMasterCampId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CampaignMasterId | int | NULL |  |

### `tblCustMasterCampNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustMasterCampId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CampaignMasterId | int | NULL |  |
| custtypeid | int | NULL |  |
| EntryDate | datetime | NULL |  |
| NormalizedCustomerCode | nvarchar(50) | NULL |  |

### `tblCustMasterTemp_Feb`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerName | nvarchar(max) | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| SecondaryCode | nvarchar(max) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| CellNo | nvarchar(max) | NULL |  |
| CreditLimit | decimal(18,2) | NULL |  |
| Phone | nvarchar(max) | NULL |  |
| OwnerName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Thana | nvarchar(max) | NULL |  |
| UnionName | nvarchar(max) | NULL |  |
| ComUnitCode | nvarchar(max) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| DistributionRoute | nvarchar(max) | NULL |  |
| DistributionRouteCode | nvarchar(max) | NULL |  |
| CustomerStation | nvarchar(max) | NULL |  |
| ProgramType | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| Territory | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| Area | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| Zone | nvarchar(max) | NULL |  |
| ZoneCode | nvarchar(max) | NULL |  |
| NationalName | nvarchar(max) | NULL |  |
| NationalCode | nvarchar(max) | NULL |  |
| Email | nvarchar(max) | NULL |  |
| TempCustomerMasterId | int | NOT NULL | PK, IDENTITY |

### `tblCustMIO`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustCode | nvarchar(max) | NULL |  |
| MCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| MIACode | nvarchar(max) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |

### `tblCustomerApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblCustomerCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCategoryId | int | NOT NULL | PK, IDENTITY |
| CustomerCategory | nvarchar(500) | NULL |  |

### `tblcustomerchanges31`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SCcode | nvarchar(max) | NULL |  |
| customercode | nvarchar(max) | NULL |  |
| marketcode | nvarchar(max) | NULL |  |
| marketname | nvarchar(max) | NULL |  |
| type | nvarchar(max) | NULL |  |

### `tblCustomerCreditLimit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CreditLimitId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NOT NULL |  |
| CustomerMasterId | int | NOT NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| LimitAmount | decimal(18,2) | NOT NULL |  |
| DayLimit | int | NOT NULL |  |
| IsActive | bit | NOT NULL |  |
| EntryBy | nvarchar(50) | NOT NULL |  |
| EntryDate | datetime | NOT NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| StartDate | datetime | NULL |  |
| EndDate | datetime | NULL |  |

### `tblCustomerDepoChange`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Code | nvarchar(50) | NULL |  |
| UnitCode | nvarchar(50) | NULL |  |
| UnitName | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(50) | NULL |  |

### `tblCustomerFixedDiscount`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DiscountId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| CustMasterId | int | NULL |  |
| DiscountParcentage | decimal(18,2) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| ActiveDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NULL |  |
| InactiveBy | nvarchar(50) | NULL |  |

### `tblCustomerInvoiceLimit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Id | int | NOT NULL | PK, IDENTITY |
| CustomerId | int | NOT NULL |  |
| MaximumInvoiceValue | decimal(18,2) | NOT NULL |  |
| Remarks | nvarchar(250) | NULL |  |
| IsActive | bit | NOT NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdatedBy | nvarchar(50) | NULL |  |
| UpdatedDate | datetime | NULL |  |

### `tblCustomerMasterExcelFileDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BRANCH | nvarchar(500) | NULL |  |
| BRANCHDES | nvarchar(500) | NULL |  |
| CustomerCode | nvarchar(500) | NULL |  |
| CUSTOMERNAME | nvarchar(500) | NULL |  |
| ADDRESS1 | nvarchar(500) | NULL |  |
| ADDRESS2 | nvarchar(500) | NULL |  |
| CITY | nvarchar(500) | NULL |  |
| CONTACTPERSON | nvarchar(500) | NULL |  |
| CONTACTNUMBER | nvarchar(500) | NULL |  |
| MIOCode | nvarchar(500) | NULL |  |
| MIOName | nvarchar(500) | NULL |  |
| TerritoryCode | nvarchar(500) | NULL |  |
| FECode | nvarchar(500) | NULL |  |
| FEName | nvarchar(500) | NULL |  |
| DZSMCode | nvarchar(500) | NULL |  |
| DZSMName | nvarchar(500) | NULL |  |
| SHIPPINGCOND | nvarchar(500) | NULL |  |
| SHIPPINGPOINT | nvarchar(500) | NULL |  |
| MarketName | nvarchar(500) | NULL |  |
| TERMOFPAYMENT | nvarchar(500) | NULL |  |
| Type | nchar(10) | NULL |  |
| Verifyed | bit | NULL |  |
| MasterID | int | NULL |  |
| DetailID | int | NOT NULL | IDENTITY |

### `tblCustomerMasterExcelFileMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerMasterExcelFileMasterID | int | NOT NULL | PK |
| CustomerMasterExcelFileCode | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerMasterExcelFileDocumentDate | datetime | NULL |  |
| Transfer | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| VerifyedAll | bit | NULL |  |

### `tblCustomerMasterTagChangeExcelFileDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DetailID | int | NOT NULL | IDENTITY |
| MasterID | int | NULL |  |
| BRANCH | nvarchar(500) | NULL |  |
| BRANCHDES | nvarchar(500) | NULL |  |
| CustomerCode | nvarchar(500) | NULL |  |
| CUSTOMERNAME | nvarchar(500) | NULL |  |
| ADDRESS1 | nvarchar(500) | NULL |  |
| ADDRESS2 | nvarchar(500) | NULL |  |
| CITY | nvarchar(500) | NULL |  |
| CONTACTPERSON | nvarchar(500) | NULL |  |
| CONTACTNUMBER | nvarchar(500) | NULL |  |
| MIOCode | nvarchar(500) | NULL |  |
| MIOName | nvarchar(500) | NULL |  |
| TerritoryCode | nvarchar(500) | NULL |  |
| FECode | nvarchar(500) | NULL |  |
| FEName | nvarchar(500) | NULL |  |
| DZSMCode | nvarchar(500) | NULL |  |
| DZSMName | nvarchar(500) | NULL |  |
| SHIPPINGCOND | nvarchar(500) | NULL |  |
| SHIPPINGPOINT | nvarchar(500) | NULL |  |
| MarketName | nvarchar(500) | NULL |  |
| TERMOFPAYMENT | nvarchar(500) | NULL |  |
| Verifyed | bit | NULL |  |

### `tblCustomerMasterTagChangeExcelFileMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerTagChangeExcelFileMasterID | int | NOT NULL | PK |
| CustomerTagChangeExcelFileCode | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerTagChangeExcelFileDocumentDate | datetime | NULL |  |
| Transfer | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| VerifyedAll | bit | NULL |  |

### `tblCustomerNewCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NOT NULL |  |
| CategoryId | nchar(10) | NULL |  |

### `tblCustomerPay`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayId | int | NOT NULL | PK |
| MarketId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| PaymentDate | datetime | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PayType | nvarchar(50) | NULL |  |
| RefNo | nvarchar(50) | NULL |  |
| RefDate | datetime | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ComUnitId | int | NULL |  |

### `tblCustomerPayDeleteLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayId | int | NOT NULL | PK |
| CustomerMasterId | int | NULL |  |
| PaymentDate | datetime | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PayType | nvarchar(50) | NULL |  |
| RefNo | nvarchar(50) | NULL |  |
| RefDate | datetime | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblCustomerPropUpdateDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPropUpdateDetailId | int | NOT NULL | PK, IDENTITY |
| CustPropMasterId | int | NULL |  |
| CustCode | nvarchar(max) | NULL |  |
| CustomerId | int | NULL |  |
| ProviderType | nvarchar(max) | NULL |  |
| ProviderTypeId | int | NULL |  |
| CustTypeCode | nvarchar(max) | NULL |  |
| CustTypeId | int | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketId | int | NULL |  |
| IsSuccess | bit | NULL |  |
| PharmaPlatformCode | nvarchar(max) | NULL |  |
| PharmaPlatformId | int | NULL |  |

### `tblCustomerPropUpdateMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPropMasterId | int | NOT NULL | PK, IDENTITY |
| TypeId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| ConvertType | nvarchar(50) | NULL |  |
| IsTransfer | bit | NULL |  |

### `tblCustomerReturnDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustReturnDetailId | int | NOT NULL | PK, IDENTITY |
| InvoiceDetailId | int | NULL |  |
| ReturnQty | int | NULL |  |
| ReturnAmount | decimal(18,2) | NULL |  |
| CustReturnId | int | NULL |  |

### `tblCustomerReturnMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustReturnId | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| TotalQty | int | NULL |  |
| TotalAmount | decimal(18,2) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsPosting | bit | NULL |  |

### `tblCustomerType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerTypeId | int | NOT NULL | PK, IDENTITY |
| CustomerType | nvarchar(max) | NULL |  |
| CustTypeCode | nvarchar(max) | NULL |  |
| IsOrderApproval | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| IsDefault | bit | NULL |  |
| CustomerCategoryId | int | NULL |  |

### `tblCustomerTypeExcel`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NULL |  |
| Type | nvarchar(max) | NULL |  |

### `tblCustomeTagChange`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Marketcode | nvarchar(max) | NULL |  |
| Marketname | nvarchar(max) | NULL |  |
| Beancehcode | nvarchar(max) | NULL |  |
| BrasnchName | nvarchar(max) | NULL |  |
| Custcode | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| TeriCode | nvarchar(max) | NULL |  |
| TeriName | nvarchar(max) | NULL |  |
| FEcode | nvarchar(max) | NULL |  |
| FeName | nvarchar(max) | NULL |  |
| DZsmCode | nvarchar(max) | NULL |  |
| DzsmName | nvarchar(max) | NULL |  |

### `tblCustPayDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayDetailId | int | NOT NULL |  |
| InvoiceId | int | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| CustPayId | int | NULL |  |
| SubDeportInvoiceId | int | NULL |  |
| Discount | decimal(18,2) | NULL |  |
| CashAccId | int | NULL |  |
| BankAccId | int | NULL |  |
| AIT | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| TransctionDetailId | int | NULL |  |
| custPaymentDate | date | NULL |  |
| TPAmount | decimal(18,2) | NULL |  |
| VATAmount | decimal(18,2) | NULL |  |
| fristRow | bit | NULL |  |
| SecondRow | bit | NULL |  |
| 42workingRow | bit | NULL |  |
| CollectionBy | nvarchar(500) | NULL |  |
| DANameId | int | NULL |  |
| PreviousDANameId | int | NULL |  |
| TestIDnew | int | NULL |  |
| PreCollDate | nvarchar(500) | NULL |  |
| ReferenceNo | nvarchar(max) | NULL |  |
| IsAttachment | bit | NULL |  |
| EntryFromTag | nvarchar(max) | NULL |  |

### `tblCustPayDetail_DeleteLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayDeleteId | int | NOT NULL | IDENTITY |
| CustPayDetailId | int | NULL |  |
| InvoiceId | int | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| CustPayId | int | NULL |  |
| SubDeportInvoiceId | int | NULL |  |
| Discount | decimal(18,2) | NULL |  |
| CashAccId | int | NULL |  |
| BankAccId | int | NULL |  |
| AIT | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| TransctionDetailId | int | NULL |  |
| custPaymentDate | date | NULL |  |
| TPAmount | decimal(18,2) | NULL |  |
| VATAmount | decimal(18,2) | NULL |  |
| fristRow | bit | NULL |  |
| SecondRow | bit | NULL |  |
| 42workingRow | bit | NULL |  |
| CollectionBy | nvarchar(500) | NULL |  |
| DANameId | int | NULL |  |
| PreviousDANameId | int | NULL |  |
| TestIDnew | int | NULL |  |
| PreCollDate | nvarchar(500) | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| DelBy | nvarchar(500) | NULL |  |
| DelDate | datetime | NULL |  |

### `tblCustPayDetailDeleteLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayDetailId | int | NOT NULL |  |
| InvoiceId | int | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| CustPayId | int | NULL |  |
| RetrunPayBy | nvarchar(50) | NULL |  |
| ReturnPayDate | datetime | NULL |  |

### `tblCustPayDetailForTempcoddoso`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayDetailId | int | NOT NULL |  |
| InvoiceId | int | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| CustPayId | int | NULL |  |
| SubDeportInvoiceId | int | NULL |  |
| Discount | decimal(18,2) | NULL |  |
| CashAccId | int | NULL |  |
| BankAccId | int | NULL |  |
| AIT | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| TransctionDetailId | int | NULL |  |
| custPaymentDate | date | NULL |  |
| TPAmount | decimal(18,2) | NULL |  |
| VATAmount | decimal(18,2) | NULL |  |
| isdone | bit | NULL |  |
| uniq | bit | NULL |  |
| FirstRowz | bit | NULL |  |
| SecondRowz | bit | NULL |  |

### `tblCustPayForLastcursor`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayForLast | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| PmtAmt | decimal(18,2) | NULL |  |
| VatAmt | decimal(18,2) | NULL |  |
| TpAMt | decimal(18,2) | NULL |  |
| TotalDelivery | decimal(18,2) | NULL |  |
| pmtDate | date | NULL |  |
| CustPayDetailId | int | NULL |  |

### `tblCustPayTemp`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayTempId | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| custPaymentDate | date | NULL |  |
| ConfirmAmount | decimal(18,2) | NULL |  |
| TpAmt | decimal(18,2) | NULL |  |
| VAtAmt | decimal(18,2) | NULL |  |

### `tblCustProductLine`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustProLineID | int | NOT NULL | PK, IDENTITY |
| ProductLineID | int | NULL |  |
| CustomerMasterId | int | NULL |  |

### `tblCustProgramTypeChange`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustProgramTypeChangeId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| FromProgramTypeId | int | NULL |  |
| ToProgramTypeId | int | NULL |  |
| FromProgramTypeCode | nvarchar(max) | NULL |  |
| ToProgramTypeCode | nvarchar(max) | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblCustUpdateMarketLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustUpdateMarketLogId | int | NOT NULL | PK, IDENTITY |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| TGroupId | int | NULL |  |
| TRegionId | int | NULL |  |
| TAreaId | int | NULL |  |
| TTerritoryId | int | NULL |  |
| TSubTerritoryId | int | NULL |  |
| TMarketId | int | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |

### `tblCustUpdateProviderLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustUpdateProviderLogId | int | NOT NULL | PK, IDENTITY |
| FromProgramTypeId | int | NULL |  |
| ToProgramTypeId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDAClaimDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DAClaimDetailId | int | NOT NULL | PK, IDENTITY |
| DAClaimId | int | NOT NULL |  |
| MarketId | int | NOT NULL |  |
| MarketName | nvarchar(250) | NULL |  |
| DAClaimAmount | decimal(18,2) | NOT NULL |  |

### `tblDAClaimMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DAClaimId | int | NOT NULL | PK, IDENTITY |
| DaId | int | NOT NULL |  |
| ComUnitId | int | NOT NULL |  |
| RouteId | int | NOT NULL |  |
| FrmDate | date | NOT NULL |  |
| ToDate | date | NOT NULL |  |
| TotalClaimAmount | decimal(18,2) | NOT NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| ApprovalStatus | nvarchar(50) | NOT NULL |  |
| IsFromApp | bit | NOT NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NOT NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| DICApprovalDate | datetime | NULL |  |
| DICApprovalStatus | nvarchar(50) | NOT NULL |  |
| DICApprovalBy | nvarchar(50) | NULL |  |
| DICClaimDate | datetime | NULL |  |
| DICClaimBy | nvarchar(50) | NULL |  |
| DICClaimAmount | decimal(18,2) | NULL |  |

### `tblDAInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DAId | int | NOT NULL | PK, IDENTITY |
| NID | nvarchar(max) | NOT NULL |  |
| Name | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| PhoneNo | nvarchar(max) | NULL |  |
| EmergencyContactNo | nvarchar(max) | NULL |  |
| ReferenceName | nvarchar(max) | NULL |  |
| ReferencePhone | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| DACode | nvarchar(max) | NULL |  |
| ComUnitId | int | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |
| JoiningDate | datetime | NULL |  |

### `tblDATerritoryWise`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DATerritoryWiseID | int | NOT NULL | PK, IDENTITY |
| TerritoryCode | varchar(max) | NULL |  |
| TerritoryName | varchar(max) | NULL |  |
| DACode | varchar(max) | NULL |  |
| DAName | varchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| SA_TPAmount | decimal(18,2) | NULL |  |
| SA_PaidAmount | decimal(18,2) | NULL |  |
| Total_TPAmount | decimal(18,2) | NULL |  |
| Total_PaidAmount | decimal(18,2) | NULL |  |

### `tblDayName`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DayNameValueId | int | NOT NULL | PK, IDENTITY |
| DayNameValue | nvarchar(50) | NULL |  |

### `tblDCPicking`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCPicId | int | NOT NULL | PK |
| DCPicNo | nvarchar(max) | NULL |  |
| DCPicDate | datetime | NULL |  |
| ComUnitId | int | NULL |  |
| AreaId | int | NULL |  |

### `tblDCPickingDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCPicDetailId | int | NOT NULL | PK |
| InvoiceNo | nvarchar(max) | NULL |  |
| DCPicId | int | NULL |  |

### `tblDCRApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCRApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblDCRBrandDetailsDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| BrandDetailId | bigint | NOT NULL |  |
| BrandId | bigint | NULL |  |
| DcrId | bigint | NOT NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tblDCRDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| DcrId | bigint | NOT NULL |  |
| DcrDate | date | NOT NULL |  |
| TourTypeId | int | NULL |  |
| ChemberId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsApproved | bit | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| DoctorId | bigint | NULL |  |
| DocTPDetailsId | bigint | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| TerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| IsNonEffectiveReason | bit | NULL |  |
| ReasonId | int | NULL |  |
| EntryDate_Apps | datetime | NULL |  |
| ApprovalStatus | nvarchar(20) | NULL |  |
| Latitude | nvarchar(50) | NULL |  |
| Longitude | nvarchar(50) | NULL |  |
| StreetAddress | nvarchar(500) | NULL |  |
| DoctorProgramypeId | int | NULL |  |
| GroupName | nvarchar(100) | NULL |  |
| RegionName | nvarchar(100) | NULL |  |
| AreaName | nvarchar(100) | NULL |  |
| TerritoryName | nvarchar(100) | NULL |  |
| SubTerritoryName | nvarchar(100) | NULL |  |
| MarketName | nvarchar(100) | NULL |  |
| GroupCode_DCR | nvarchar(20) | NULL |  |
| RegionCode_DCR | nvarchar(20) | NULL |  |
| AreaCode_DCR | nvarchar(20) | NULL |  |
| TerritoryCode_DCR | nvarchar(20) | NULL |  |
| SubTerritoryCode_DCR | nvarchar(20) | NULL |  |
| MarketCode_DCR | nvarchar(20) | NULL |  |
| SmcTypeId_DCR | int | NULL |  |
| SMCType_DCR | nvarchar(50) | NULL |  |
| DoctorType_DCR | nvarchar(50) | NULL |  |
| DoctorTypeID_DCR | int | NULL |  |
| TypeDcr | nvarchar(20) | NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tblDCRDetailDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| DcrDetailID | bigint | NOT NULL |  |
| DcrId | bigint | NOT NULL |  |
| ProductId | bigint | NULL |  |
| Type | nvarchar(20) | NULL |  |
| ProductQty | int | NULL |  |
| GWPromoQtyId | bigint | NULL |  |
| EmpInfoId | bigint | NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tblDCRRXDoctorWiseReport`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCRRXDoctorWiseReportId | int | NOT NULL | PK, IDENTITY |
| DoctorId | nvarchar(50) | NULL |  |
| DoctorName | nvarchar(50) | NULL |  |
| DoctorCode | nvarchar(50) | NULL |  |
| DegreeName | nvarchar(50) | NULL |  |
| DoctorSpeciality | nvarchar(50) | NULL |  |
| ProgramTypeName | nvarchar(50) | NULL |  |
| DoctorTypeName | nvarchar(50) | NULL |  |
| GroupName | nvarchar(50) | NULL |  |
| GroupCode | nvarchar(50) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| RegionName | nvarchar(50) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| AreaName | nvarchar(50) | NULL |  |
| TerritoryCode | nvarchar(50) | NULL |  |
| TerritoryName | nvarchar(50) | NULL |  |
| SubTerritoryCode | nvarchar(50) | NULL |  |
| SubTerritoryName | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(50) | NULL |  |
| D1 | nvarchar(50) | NULL |  |
| D2 | nvarchar(50) | NULL |  |
| D3 | nvarchar(50) | NULL |  |
| D4 | nvarchar(50) | NULL |  |
| D5 | nvarchar(50) | NULL |  |
| D6 | nvarchar(50) | NULL |  |
| D7 | nvarchar(50) | NULL |  |
| D8 | nvarchar(50) | NULL |  |
| D9 | nvarchar(50) | NULL |  |
| D10 | nvarchar(50) | NULL |  |
| D11 | nvarchar(50) | NULL |  |
| D12 | nvarchar(50) | NULL |  |
| D13 | nvarchar(50) | NULL |  |
| D14 | nvarchar(50) | NULL |  |
| D15 | nvarchar(50) | NULL |  |
| D16 | nvarchar(50) | NULL |  |
| D17 | nvarchar(50) | NULL |  |
| D18 | nvarchar(50) | NULL |  |
| D19 | nvarchar(50) | NULL |  |
| D20 | nvarchar(50) | NULL |  |
| D21 | nvarchar(50) | NULL |  |
| D22 | nvarchar(50) | NULL |  |
| D23 | nvarchar(50) | NULL |  |
| D24 | nvarchar(50) | NULL |  |
| D25 | nvarchar(50) | NULL |  |
| D26 | nvarchar(50) | NULL |  |
| D27 | nvarchar(50) | NULL |  |
| D28 | nvarchar(50) | NULL |  |
| D29 | nchar(10) | NULL |  |
| D30 | nvarchar(50) | NULL |  |
| D31 | nvarchar(50) | NULL |  |
| TotAL | nvarchar(50) | NULL |  |
| Month | nvarchar(50) | NULL |  |
| Year | nvarchar(50) | NULL |  |
| Type | nvarchar(50) | NULL |  |

### `tblDCStore`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCStoreId | int | NOT NULL | PK |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| ChalanDate | datetime | NULL |  |
| ComUnitId | int | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | datetime | NULL |  |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| StockInTransfarId | int | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| ChalanDetailsId | int | NULL |  |
| MfgDate | datetime | NULL |  |
| Note | nvarchar(50) | NULL |  |
| SChalanDetailsId | int | NULL |  |
| IsBatchUpdate | bit | NULL |  |
| TempReceiveId | int | NULL |  |
| AdjustmentStock | decimal(18,0) | NULL |  |

### `tblDCStore_OpeningBalance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCOpeningBalanceId | int | NOT NULL | PK, IDENTITY |
| DCOpeningBalanceDate | datetime | NOT NULL |  |
| DCStoreId | int | NOT NULL |  |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| ChalanDate | datetime | NULL |  |
| ComUnitId | int | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | datetime | NULL |  |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| StockInTransfarId | int | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| ChalanDetailsId | int | NULL |  |
| MfgDate | datetime | NULL |  |
| Note | nvarchar(max) | NULL |  |
| TempReceiveId | int | NULL |  |

### `tbldcstoredddd`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Invoicenoo | nvarchar(50) | NULL |  |

### `tblDCStoreFreeze`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCStoreFreezeId | int | NOT NULL | PK |
| DCStoreId | int | NULL |  |
| InvoiceDetailId | int | NULL |  |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| ChalanDate | datetime | NULL |  |
| ComUnitId | int | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | date | NULL |  |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| StockInTransfarId | int | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| ReceiveId | int | NULL |  |
| StockConditionFreezeID | int | NULL |  |
| ChalanDetailsId | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| ReturnInvoiceDetailId | int | NULL |  |
| IsPosting | int | NULL |  |
| Opening | date | NULL |  |

### `tblDCStoreTransaction`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCStoreTransId | int | NOT NULL | PK, IDENTITY |
| DCStoreId | int | NULL |  |
| Date | datetime | NULL |  |
| Id | int | NULL |  |
| Type | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |

### `tblDcWiseTerritoryDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcWiseTerritoryDetailId | int | NOT NULL | PK, IDENTITY |
| DcWiseTerritoryMasterId | int | NULL |  |
| TerritoryId | int | NULL |  |

### `tblDcWiseTerritoryMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcWiseTerritoryMasterId | int | NOT NULL | PK, IDENTITY |
| DCId | int | NULL |  |
| SubDepotId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDeliveryManInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DeliveryManId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDepartment`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DeptId | int | NOT NULL | PK, IDENTITY |
| DeptCode | nvarchar(50) | NULL |  |
| DeptName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | nvarchar(max) | NULL |  |
| InactiveDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDepositOpeningBalance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Bran | nvarchar(max) | NULL |  |
| CollectionInHand | decimal(18,2) | NULL |  |
| MarketOutstanding | decimal(18,2) | NULL |  |
| TotalReceivable | decimal(18,2) | NULL |  |
| OpeningDate | date | NULL |  |
| ComUnitID | int | NULL |  |
| Name | nvarchar(max) | NULL |  |
| ID | int | NOT NULL | PK, IDENTITY |

### `tblDepotToWHChalanDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SChalanDetailsId | int | NOT NULL | PK |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BatchNo | nvarchar(50) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| Value | decimal(18,2) | NULL |  |
| Vat | decimal(18,2) | NULL |  |
| ValueWVat | decimal(18,2) | NULL |  |
| SChalanId | int | NOT NULL |  |
| DCStoreId | int | NULL |  |
| DCStoreFreezeId | int | NULL |  |
| PurposeId | int | NULL |  |

### `tblDepotToWHChalanInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SChalanId | int | NOT NULL | PK |
| ChalanDate | date | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| TrackNo | nvarchar(max) | NULL |  |
| DriverName | nvarchar(max) | NULL |  |
| FromComUnitCode | nvarchar(max) | NULL |  |
| FromComUnitName | nvarchar(max) | NULL |  |
| FromComUnitAddress | nvarchar(max) | NULL |  |
| WHCode | nvarchar(max) | NULL |  |
| WHName | nvarchar(max) | NULL |  |
| WHAddress | nvarchar(max) | NULL |  |
| TotalValue | decimal(18,2) | NULL |  |
| TotalVat | decimal(18,2) | NULL |  |
| GrandTotal | decimal(18,2) | NULL |  |
| ManufacId | int | NULL |  |
| IsDeliver | nvarchar(50) | NULL |  |
| ComUnitId2 | int | NULL |  |
| IsTransfer | nvarchar(50) | NULL |  |
| IsSoundProduct | bit | NULL |  |

### `tblDesignation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DesignationId | int | NOT NULL | PK, IDENTITY |
| DesigName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| InactiveDate | datetime | NULL |  |
| InactiveBy | nvarchar(50) | NULL |  |
| DesigCode | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDeStockOutDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcStockOutDetailsId | int | NOT NULL | PK |
| DcStockOutMasterId | int | NULL |  |
| DcStoreId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| StackOutQty | int | NULL |  |
| PackSize | nvarchar(50) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |

### `tblDeStockOutMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcStockOutMasterId | int | NOT NULL | PK |
| ComUnitId | int | NULL |  |
| InvoiceId | int | NULL |  |
| StockOutDate | datetime | NULL |  |
| Reason | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| Status | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |

### `tblDestroyProduct`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DestroyId | int | NOT NULL | PK, IDENTITY |
| DcFreezeId | int | NULL |  |
| StockOutQty | decimal(18,2) | NULL |  |
| StockOutAmount | decimal(18,2) | NULL |  |
| StockOutBy | int | NULL |  |
| StockOutDate | datetime | NULL |  |
| Reason | nvarchar(max) | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| IsApproved | bit | NULL |  |
| IsPosting | bit | NULL |  |

### `tblDICApprovedDAClaimAmount`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DICApprovedDAClaimAmountId | int | NOT NULL | PK, IDENTITY |
| DaId | int | NOT NULL |  |
| DAAmount | decimal(18,2) | NOT NULL |  |
| ApprovalStatus | nvarchar(50) | NOT NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NOT NULL |  |
| EntryDate | datetime | NOT NULL |  |
| DAClaimId | int | NOT NULL |  |
| MarketId | int | NOT NULL |  |
| ApprovedDate | datetime | NULL |  |

### `tblDirectStockOut`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCStockOutId | int | NOT NULL | PK, IDENTITY |
| StockOutCode | nvarchar(500) | NULL |  |
| DCId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| StockOutDate | datetime | NULL |  |
| DCStoreId | int | NULL |  |
| StockOutQty | decimal(18,2) | NULL |  |
| StockOutValue | decimal(18,2) | NULL |  |
| StockOutReason | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| StockOutType | nvarchar(max) | NULL |  |

### `tblDistributionRoute`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DistributionRouteId | int | NOT NULL | PK, IDENTITY |
| DistributionRouteName | nvarchar(max) | NULL |  |

### `tblDistributionType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DcTypeId | int | NOT NULL | PK, IDENTITY |
| DcTypeName | nvarchar(max) | NULL |  |

### `tblDistrict`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DistrictCode | nvarchar(500) | NULL |  |
| DistrictName | nvarchar(500) | NULL |  |
| DistrictId | int | NOT NULL | PK |
| ComUnitId | int | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblDistrictCoordinator`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DistCoordinatorId | int | NOT NULL | PK, IDENTITY |
| DistCoordinatorCode | nvarchar(50) | NULL |  |
| DivisionId | int | NULL |  |
| DistrictId | int | NULL |  |
| EmpInfoId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblDoctor_CustomerDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustDetailId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| CustomerId | int | NULL |  |

### `tblDoctorApprovalLog_New`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblDoctorBrand`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorBrandId | int | NOT NULL | PK, IDENTITY |
| DoctorBrandName | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tblDoctorBrandDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorId | int | NULL |  |
| BrandId | int | NULL |  |
| DoctorBrandId | int | NOT NULL | PK, IDENTITY |

### `tblDoctorCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CategoryId | int | NOT NULL | PK, IDENTITY |
| CategoryName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorChamber`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ChamberId | int | NOT NULL | PK, IDENTITY |
| ChamberName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorChemberDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorId | int | NULL |  |
| ChamberTypeId | int | NULL |  |
| Name | nvarchar(max) | NULL |  |
| Phone | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| ChemberId | int | NOT NULL | PK, IDENTITY |

### `tblDoctorContactDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ContactId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| ContactType | nvarchar(50) | NULL |  |
| Contact | nvarchar(max) | NULL |  |
| ContactTypeId | int | NULL |  |

### `tblDoctorCustomerDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DocCustomerId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |

### `tblDoctorDegree`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DegreeId | int | NOT NULL | PK, IDENTITY |
| DoctorTypeId | int | NULL |  |
| DegreeName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorDegreeDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorId | int | NULL |  |
| DegId | int | NOT NULL |  |
| DoctorDegId | int | NOT NULL | PK, IDENTITY |

### `tblDoctorDesignation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DesignationName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| DesignationId | int | NOT NULL | IDENTITY |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorInstitutionDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InstDetailId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| InstitutionId | int | NULL |  |

### `tblDoctorMarketDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorMktId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| SubmarketId | int | NULL |  |
| IsTopDoctor | bit | NULL |  |
| IsDCRAllowed | bit | NULL |  |
| MarketId | int | NULL |  |

### `tblDoctorMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorId | int | NOT NULL | PK, IDENTITY |
| DoctorCode | nvarchar(max) | NULL |  |
| DoctorName | nvarchar(max) | NULL |  |
| SecondaryCode | nvarchar(max) | NULL |  |
| DesignationId | int | NULL |  |
| DegreeId | int | NULL |  |
| Gender | nvarchar(max) | NULL |  |
| Speciality | int | NULL |  |
| ProgramType | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |
| InactiveBy | nvarchar(max) | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |
| DivisionId | int | NULL |  |
| DistrictId | int | NULL |  |
| ThanaId | int | NULL |  |
| IsFromApp | bit | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| UPCode | nvarchar(max) | NULL |  |
| DoctorTypeId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| UnionName | nvarchar(max) | NULL |  |
| Reamrks | nvarchar(max) | NULL |  |
| StationTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| DoctorCategoryId | int | NULL |  |
| SpecialDayId | int | NULL |  |
| SpeciaDateStr | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| OldCode | nvarchar(max) | NULL |  |
| IsMarketUpdate2022 | bit | NULL |  |
| SMCTypeId | int | NULL |  |
| DoctorAddress | nvarchar(max) | NULL |  |

### `tblDoctorMaster_Log`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorLogId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| DoctorCode | nvarchar(max) | NULL |  |
| DoctorName | nvarchar(max) | NULL |  |
| SecondaryCode | nvarchar(max) | NULL |  |
| DesignationId | int | NULL |  |
| DegreeId | int | NULL |  |
| Gender | nvarchar(max) | NULL |  |
| Speciality | int | NULL |  |
| ProgramType | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |
| InactiveBy | nvarchar(max) | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |
| DivisionId | int | NULL |  |
| DistrictId | int | NULL |  |
| ThanaId | int | NULL |  |
| IsFromApp | bit | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| UPCode | nvarchar(max) | NULL |  |
| DoctorTypeId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| UnionName | nvarchar(max) | NULL |  |
| Reamrks | nvarchar(max) | NULL |  |
| StationTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| DoctorCategoryId | int | NULL |  |
| SpecialDayId | int | NULL |  |
| SpeciaDateStr | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| OldCode | nvarchar(max) | NULL |  |
| LogBy | nvarchar(50) | NULL |  |
| LogDate | datetime | NULL |  |

### `tblDoctorMaster_TranferLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorTranferLogid | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| DoctorCode | nvarchar(max) | NULL |  |
| DoctorName | nvarchar(max) | NULL |  |
| SecondaryCode | nvarchar(max) | NULL |  |
| DesignationId | int | NULL |  |
| DegreeId | int | NULL |  |
| Gender | nvarchar(max) | NULL |  |
| Speciality | int | NULL |  |
| ProgramType | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |
| InactiveBy | nvarchar(max) | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |
| DivisionId | int | NULL |  |
| DistrictId | int | NULL |  |
| ThanaId | int | NULL |  |
| IsFromApp | bit | NULL |  |
| ApprovalStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| UPCode | nvarchar(max) | NULL |  |
| DoctorTypeId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| UnionName | nvarchar(max) | NULL |  |
| Reamrks | nvarchar(max) | NULL |  |
| StationTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| DoctorCategoryId | int | NULL |  |
| TranferBy | int | NULL |  |
| TranferDate | datetime | NULL |  |
| IsApprove | bit | NULL |  |
| MasterId | int | NULL |  |

### `tblDoctorPatientType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PatientTypeId | int | NOT NULL | PK, IDENTITY |
| PatientType | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorProgramType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProgramTypeId | int | NOT NULL | PK, IDENTITY |
| ProgramType | nvarchar(max) | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| IsActive | bit | NULL |  |

### `tblDoctorProgramTypeDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorTypeDetailId | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| ProgramTypeId | int | NULL |  |

### `tblDoctorPropUpdateDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPropUpdateDetailId | int | NOT NULL | PK, IDENTITY |
| CustPropMasterId | int | NULL |  |
| CustCode | nvarchar(max) | NULL |  |
| CustomerId | int | NULL |  |
| ProviderType | nvarchar(max) | NULL |  |
| ProviderTypeId | int | NULL |  |
| CustTypeCode | nvarchar(max) | NULL |  |
| CustTypeId | int | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketId | int | NULL |  |
| IsSuccess | bit | NULL |  |
| PharmaPlatformCode | nvarchar(max) | NULL |  |
| PharmaPlatformId | int | NULL |  |

### `tblDoctorPropUpdateMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPropMasterId | int | NOT NULL | PK, IDENTITY |
| TypeId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| ConvertType | nvarchar(50) | NULL |  |
| IsTransfer | bit | NULL |  |

### `tblDoctorSpecialDay`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SpecialDayId | int | NOT NULL | PK, IDENTITY |
| SpecialDay | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorSpecialDayDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SpecialDayInt | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| SpecialDayId | int | NULL |  |
| SpecialDate | datetime | NULL |  |

### `tblDoctorSpeciality`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SpecialityId | int | NOT NULL | IDENTITY |
| SpecialityName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |
| Activedate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsDelate | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblDoctorSpecialityDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorSpId | int | NOT NULL | PK, IDENTITY |
| SpecialityId | int | NULL |  |
| DoctorId | int | NULL |  |

### `tblDoctorType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorTypeId | int | NOT NULL | PK, IDENTITY |
| DoctorTypeName | nvarchar(500) | NULL |  |
| IsActive | bit | NULL |  |
| DoctorTypeCode | nvarchar(500) | NULL |  |

### `tblDoctorUpdateMarketLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorUpdateMarketLogId | int | NOT NULL | PK, IDENTITY |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| DoctorId | int | NULL |  |
| TGroupId | int | NULL |  |
| TRegionId | int | NULL |  |
| TAreaId | int | NULL |  |
| TTerritoryId | int | NULL |  |
| TSubTerritoryId | int | NULL |  |
| TMarketId | int | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDoctorUpdateProviderLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DoctorUpdateProviderLogId | int | NOT NULL | PK, IDENTITY |
| FromProgramTypeId | int | NULL |  |
| ToProgramTypeId | int | NULL |  |
| DoctorId | int | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblDocUpdateforInactive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DocCode | nvarchar(max) | NULL |  |
| DocId | int | NULL |  |

### `tblDWSPApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DWSPApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblDWSPApprovalVoidLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DWSPApprovalVoidId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblDZSMProcessDate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DZSMProcessId | int | NOT NULL | PK, IDENTITY |
| DZSMProcessDate | datetime | NULL |  |

### `tblDZSMwiseReportParam`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DZSMwiseReportParamId | int | NOT NULL | PK, IDENTITY |
| RegionId | int | NULL |  |
| AreaCode | nvarchar(500) | NULL |  |
| AreaName | nvarchar(500) | NULL |  |
| TerritoryCode | nvarchar(500) | NULL |  |
| TerritoryName | nvarchar(500) | NULL |  |
| NumberofProformaInvoice | int | NULL |  |
| SumofNetProformaAmount | decimal(18,2) | NULL |  |
| ProTpVat | decimal(18,2) | NULL |  |
| NumberofInvoiceSold | int | NULL |  |
| SumofNetSalesAmount | decimal(18,2) | NULL |  |
| DelTpVat | decimal(18,2) | NULL |  |
| NumberofReturnInvoice | int | NULL |  |
| SumofNetReturnAmount | decimal(18,2) | NULL |  |
| DelReTpVat | decimal(18,2) | NULL |  |
| CustomerCoverPer | decimal(18,2) | NULL |  |
| SumofNetSalesAmountFixed | decimal(18,2) | NULL |  |
| SumofNetSalesAmountCamp | decimal(18,2) | NULL |  |
| FinalSales | decimal(18,2) | NULL |  |
| SumofNetSalesAmountFixed2 | decimal(18,2) | NULL |  |
| SumofNetSalesAmountCamp2 | decimal(18,2) | NULL |  |
| FinalSales2 | decimal(18,2) | NULL |  |
| CustomerCoverPerProforma | decimal(18,2) | NULL |  |
| BlueNetSell | decimal(18,2) | NULL |  |
| GreenNetSell | decimal(18,2) | NULL |  |
| DelBlueNetSell | decimal(18,2) | NULL |  |
| DelGreenNetSell | decimal(18,2) | NULL |  |
| BlueCov | decimal(18,2) | NULL |  |
| greenCov | decimal(18,2) | NULL |  |
| DelBlueCov | decimal(18,2) | NULL |  |
| DelgreenCov | decimal(18,2) | NULL |  |
| MonthValue | int | NULL |  |
| YearValue | int | NULL |  |
| ProcessDate | datetime | NULL |  |

### `tblEmpAppVersion`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmpAppVersionId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| AppVersion | nvarchar(max) | NULL |  |
| AppVersionDate | datetime | NULL |  |

### `tblEmpCodeUpdate_SAP`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmpCode | nvarchar(max) | NULL |  |
| SAPCode | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |

### `tblEmpGeneralInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmpName | nvarchar(max) | NULL |  |
| EmpMasterCode | nvarchar(max) | NULL |  |
| DesignationId | int | NULL |  |
| ShiftId | int | NULL |  |
| EmployeeStatus | nvarchar(max) | NULL |  |
| PhoneNo | nvarchar(max) | NULL |  |
| CellNumber | nvarchar(max) | NULL |  |
| Email | nvarchar(max) | NULL |  |
| JoiningDate | datetime | NULL |  |
| EntryBy | nvarchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| EmpInfoId | int | NOT NULL | PK, IDENTITY |
| ShortName | nvarchar(max) | NULL |  |
| FatherName | nvarchar(max) | NULL |  |
| MotherName | nvarchar(max) | NULL |  |
| Religion | nvarchar(max) | NULL |  |
| Nationality | nvarchar(max) | NULL |  |
| DateOfBirth | date | NULL |  |
| PlaceOfBirth | nvarchar(max) | NULL |  |
| BloodGroup | nvarchar(max) | NULL |  |
| Gender | nvarchar(max) | NULL |  |
| AddressPresent | nvarchar(max) | NULL |  |
| AddressPermanent | nvarchar(max) | NULL |  |
| MedicalInformation | nvarchar(max) | NULL |  |
| EmpImage | image(2147483647) | NULL |  |
| SignatureImage | image(2147483647) | NULL |  |
| MaritalStatus | nvarchar(max) | NULL |  |
| NationalIdNo | nvarchar(max) | NULL |  |
| RefName | nvarchar(max) | NULL |  |
| RefAddress | nvarchar(max) | NULL |  |
| RefCellNo | nvarchar(max) | NULL |  |
| DepartmentId | int | NULL |  |
| Designation | nvarchar(max) | NULL |  |
| DeptName | nvarchar(max) | NULL |  |
| CompanyId | int | NULL |  |
| FirstHoliday | nvarchar(max) | NULL |  |
| SecondHoliDay | nvarchar(max) | NULL |  |
| RefContactNo | nvarchar(max) | NULL |  |
| EmrgContactNo | nvarchar(max) | NULL |  |
| EmrgContactNoRelaton | nvarchar(max) | NULL |  |
| IsApproved | bit | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| JobLeftDate | datetime | NULL |  |
| LastCompanyName | nvarchar(max) | NULL |  |
| LastJobLocation | nvarchar(max) | NULL |  |
| IsProbition | bit | NULL |  |
| IsTempEmployeeCode | bit | NULL |  |
| ProbitionEndDate | datetime | NULL |  |
| SAPEmpCode | nvarchar(max) | NULL |  |

### `tblExeOfficeDocUpDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExeOfficeDocUpDetailsId | int | NOT NULL | PK, IDENTITY |
| ExeOffiDocUpId | int | NULL |  |
| DocumentLink | nvarchar(max) | NULL |  |
| DocumentNote | nvarchar(max) | NULL |  |
| FileName | nvarchar(max) | NULL |  |

### `tblExpanseApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpanseApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |

### `tblExpiryReturn_appLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpiryReturnId | int | NOT NULL | PK, IDENTITY |
| DaId | int | NOT NULL |  |
| ComUnitId | int | NOT NULL |  |
| RouteId | int | NOT NULL |  |
| CustomerCode | nvarchar(50) | NOT NULL |  |
| CustomerName | nvarchar(250) | NULL |  |
| SubmitBy | int | NOT NULL |  |
| SubmitDate | datetime2 | NOT NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| IsFromApp | bit | NOT NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime2 | NULL |  |
| ApprovalStatus | nvarchar(20) | NULL |  |
| ApproveBy | nvarchar(100) | NULL |  |
| ApprovalDate | datetime | NULL |  |

### `tblExpiryReturn_appLogDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ExpiryReturnDetailId | int | NOT NULL | PK, IDENTITY |
| ExpiryReturnId | int | NOT NULL |  |
| ProductId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| ProductName | nvarchar(200) | NULL |  |
| BatchNo | nvarchar(100) | NOT NULL |  |
| ReturnQty | decimal(18,2) | NOT NULL |  |
| ReasonId | int | NOT NULL |  |
| ReasonName | nvarchar(200) | NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |
| DCStoreId | int | NOT NULL |  |

### `tblFake`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FakeId | int | NOT NULL | PK, IDENTITY |
| EmpCode | nvarchar(50) | NULL |  |
| Desig | nvarchar(500) | NULL |  |
| Mobile | nvarchar(500) | NULL |  |
| DOJ | datetime | NULL |  |
| DesigId | int | NULL |  |
| EMPID | int | NULL |  |

### `tblfakeDaInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| fakeDaInfoId | int | NOT NULL | PK, IDENTITY |
| DACode | nvarchar(50) | NULL |  |
| TerritoryCode | nvarchar(50) | NULL |  |
| TerritoryName | nvarchar(50) | NULL |  |
| DaInfoIdNew | int | NULL |  |

### `tblfakeDaInfoIdNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayDetailIdFakeId | int | NOT NULL | PK, IDENTITY |
| CustPayDetailId | int | NULL |  |
| DaInfoIdNew | int | NULL |  |

### `tblFakeLeaveInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FakeLeaveInfoId | int | NOT NULL | PK, IDENTITY |
| EmpCode | nvarchar(50) | NULL |  |
| AccLeave | decimal(18,2) | NULL |  |
| isGone | bit | NULL |  |

### `tblFakemp`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FakeEmpCode | nvarchar(50) | NULL |  |
| EmpID | int | NULL |  |
| UserRoleId | int | NULL |  |

### `tblFakeOrderMarketStrucUpdateById`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FakeIncId | int | NOT NULL | PK, IDENTITY |
| OrderNO | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| ZoneCode | nvarchar(max) | NULL |  |
| TerritoryId | int | NULL |  |
| AreaId | int | NULL |  |
| ZoneId | int | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| ZoneName | nvarchar(max) | NULL |  |

### `tblFakeOtherVisit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FakeConId | int | NOT NULL | PK, IDENTITY |
| ROleType | nvarchar(50) | NULL |  |
| Territory | nvarchar(50) | NULL |  |
| Area | nvarchar(50) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| GroupCode | nvarchar(50) | NULL |  |
| StationType | nvarchar(50) | NULL |  |

### `tblFakeTableForRegion`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FakeTableForRegionId | int | NOT NULL | PK, IDENTITY |
| MarketCode | nvarchar(50) | NULL |  |
| StType | nvarchar(50) | NULL |  |

### `tblFinancialYear`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FinancialYearId | int | NOT NULL | PK, IDENTITY |
| FinancialCode | nvarchar(50) | NULL |  |
| StartDate | datetime | NULL |  |
| EndDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| FinancialYearDesc | nvarchar(max) | NULL |  |

### `tblFiscalYearInfos`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FiscalYearId | int | NOT NULL | PK, IDENTITY |
| FiscalYearDesc | nvarchar(max) | NULL |  |
| YearFromDate | datetime | NULL |  |
| YearTodate | datetime | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| FinancialCode | nvarchar(max) | NULL |  |

### `tblFocDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FocId | int | NOT NULL |  |
| RangeFrom | int | NULL |  |
| RangeTo | int | NULL |  |
| BonusQty | int | NULL |  |
| FocDetailsId | int | NOT NULL | PK, IDENTITY |

### `tblFocMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| FocId | int | NOT NULL | PK |
| FocDescription | nvarchar(500) | NULL |  |
| FocFromDate | datetime | NULL |  |
| FocToDate | datetime | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| CreateDate | datetime | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tblGenericGroup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GenericGroupId | int | NOT NULL | PK, IDENTITY |
| GenericGroupCode | nvarchar(max) | NULL |  |
| GenericGroupName | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblGhorShajai2RestrictProducts`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GhorShajai2RestrictProductsId | int | NOT NULL | PK, IDENTITY |
| ProductID | int | NULL |  |
| ProductName | nvarchar(255) | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| IsActive | bit | NULL |  |

### `tblGhorShajai3RestrictProducts`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GhorShajai3RestrictProductsId | int | NOT NULL | PK, IDENTITY |
| ProductID | int | NULL |  |
| ProductName | nvarchar(255) | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| IsActive | bit | NULL |  |

### `tblGroupInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GroupId | int | NOT NULL | PK, IDENTITY |
| GroupName | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblGroupInformation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GroupId | int | NOT NULL | PK, IDENTITY |
| GroupName | nvarchar(500) | NULL |  |
| GrpShortName | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblGroupWisePromoQty`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GWPromoQtyId | int | NOT NULL | PK, IDENTITY |
| Year | int | NULL |  |
| Month | nvarchar(500) | NULL |  |
| PromoGroupId | int | NULL |  |
| Qty | decimal(18,0) | NULL |  |
| Date | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ProductId | int | NULL |  |
| MIOId | int | NULL |  |
| EmpInfoId | int | NULL |  |
| AllocationCode | nvarchar(500) | NULL |  |
| TerritoryId | int | NULL |  |
| TransactionQTY | decimal(18,0) | NULL |  |

### `tblGroupWisePromoQty_OpeningBalanceProcess`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GroupWisePromoQty_OpeningBalanceId | int | NOT NULL | PK, IDENTITY |
| ProcessDate | date | NULL |  |
| GWPromoQtyId | int | NULL |  |
| Year | int | NULL |  |
| Month | nvarchar(500) | NULL |  |
| PromoGroupId | int | NULL |  |
| Qty | decimal(18,0) | NULL |  |
| Date | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ProductId | int | NULL |  |
| MIOId | int | NULL |  |
| EmpInfoId | int | NULL |  |
| AllocationCode | nvarchar(500) | NULL |  |
| TerritoryId | int | NULL |  |
| TransactionQTY | decimal(18,0) | NULL |  |

### `tblGWPStock`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GWPStockId | int | NOT NULL | PK, IDENTITY |
| ReceiveId | int | NULL |  |
| ProductId | int | NULL |  |
| Qty | int | NULL |  |
| GWPromoQtyId | int | NULL |  |

### `tblIngridents`

| Column | Type | Nullable | Key |
|---|---|---|---|
| IngridentsId | int | NOT NULL | PK |
| IngridentsName | nvarchar(max) | NULL |  |
| IngridentsType | nvarchar(max) | NULL |  |

### `tblInstitutionInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InstitutionId | int | NOT NULL | PK, IDENTITY |
| Institution | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |

### `tblInvoice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceId | int | NOT NULL | PK, IDENTITY |
| InvoiceNo | varchar(50) | NOT NULL |  |
| InvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(max) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(max) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(max) | NULL |  |
| ProductOffer | nvarchar(max) | NULL |  |
| OldTradePolicy | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(max) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| DisCode | nvarchar(max) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(max) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| DeliveryPersonName | nvarchar(max) | NULL |  |
| DeliveryPersonPhNo | nvarchar(max) | NULL |  |
| Types | nvarchar(max) | NULL |  |
| GreenStarBlueStarID | int | NULL |  |
| AdjustAmount | decimal(18,2) | NULL |  |
| IsAdjustInvoice | bit | NULL |  |
| ReceivableAmount | decimal(18,2) | NULL |  |
| IsSalesTransfer | bit | NULL |  |
| TransferInvoiceDate | datetime | NULL |  |
| UpdateDatetime | datetime | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AdjustInvoiceNo_ReturnInvoiceNo | nvarchar(max) | NULL |  |
| DeliveryManId | int | NULL |  |
| AIT | int | NULL |  |
| DiscountOnPayment | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| MIOId | int | NULL |  |
| IsAuto | bit | NULL |  |
| LoadingSummaryStatus | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateBy | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateDate | datetime | NULL |  |
| loadingsummaryFinalStatus | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateBy | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateDatetime | datetime | NULL |  |
| PaymentTpTotal | decimal(18,2) | NULL |  |
| PaymentTpDiscount | decimal(18,2) | NULL |  |
| PaymentTpVat | decimal(18,2) | NULL |  |
| PaymentTpGrandTotal | decimal(18,2) | NULL |  |
| PaymentInvoiceStatus | nvarchar(max) | NULL |  |
| PaymentInvoiceNo | nvarchar(max) | NULL |  |
| PaymentBy | nvarchar(max) | NULL |  |
| PaymentDate | datetime | NULL |  |
| FinalPaymentNo | nvarchar(max) | NULL |  |
| FinalPaymentBy | nvarchar(max) | NULL |  |
| FinalPaymentDate | datetime | NULL |  |
| RejectionSts | nvarchar(max) | NULL |  |
| Inv_DANameId | int | NULL |  |
| SndReturnInvoiceNo | nvarchar(max) | NULL |  |
| SndReturnPaymentBy | nvarchar(max) | NULL |  |
| SndReturnPaymentDate | datetime | NULL |  |
| sndReturnTpTotal | decimal(18,2) | NULL |  |
| sndReturnTpDiscount | decimal(18,2) | NULL |  |
| sndReturnTpVat | decimal(18,2) | NULL |  |
| sndReturnTpGrandTotal | decimal(18,2) | NULL |  |
| sndReturnInvoiceStatus | nvarchar(50) | NULL |  |
| UpdateDateDate | date | NULL |  |
| IS_Date | datetime | NULL |  |
| DA_SalesConfirmStatus | nvarchar(50) | NULL |  |
| DA_PaymentCollection | nvarchar(50) | NULL |  |
| DA_SalesReturn | nvarchar(50) | NULL |  |
| old_Invoicedate | datetime | NULL |  |
| oldUpdatedate | datetime | NULL |  |
| DA_SalesConfirmBy | nvarchar(50) | NULL |  |
| DA_SalesConfirmDate | datetime | NULL |  |
| DA_PaymentCollectionBy | nvarchar(50) | NULL |  |
| DA_PaymentCollectionDate | datetime | NULL |  |
| DA_SalesReturnDate | datetime | NULL |  |
| DA_SalesReturnBy | nvarchar(50) | NULL |  |
| DA_SalesReturnType | nvarchar(50) | NULL |  |

### `tblInvoice_DeleteLogbyTrigger`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceId | int | NOT NULL | PK |
| InvoiceNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(max) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(max) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(max) | NULL |  |
| ProductOffer | nvarchar(max) | NULL |  |
| OldTradePolicy | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(max) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| DisCode | nvarchar(max) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(max) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| DeliveryPersonName | nvarchar(max) | NULL |  |
| DeliveryPersonPhNo | nvarchar(max) | NULL |  |
| Types | nvarchar(max) | NULL |  |
| GreenStarBlueStarID | int | NULL |  |
| AdjustAmount | decimal(18,2) | NULL |  |
| IsAdjustInvoice | bit | NULL |  |
| ReceivableAmount | decimal(18,2) | NULL |  |
| IsSalesTransfer | bit | NULL |  |
| TransferInvoiceDate | datetime | NULL |  |
| UpdateDatetime | datetime | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AdjustInvoiceNo_ReturnInvoiceNo | nvarchar(max) | NULL |  |
| DeliveryManId | int | NULL |  |
| AIT | int | NULL |  |
| DiscountOnPayment | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| MIOId | int | NULL |  |
| IsAuto | bit | NULL |  |
| LoadingSummaryStatus | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateBy | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateDate | datetime | NULL |  |
| loadingsummaryFinalStatus | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateBy | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateDatetime | datetime | NULL |  |
| PaymentTpTotal | decimal(18,2) | NULL |  |
| PaymentTpDiscount | decimal(18,2) | NULL |  |
| PaymentTpVat | decimal(18,2) | NULL |  |
| PaymentTpGrandTotal | decimal(18,2) | NULL |  |
| PaymentInvoiceStatus | nvarchar(max) | NULL |  |
| PaymentInvoiceNo | nvarchar(max) | NULL |  |
| PaymentBy | nvarchar(max) | NULL |  |
| PaymentDate | datetime | NULL |  |
| FinalPaymentNo | nvarchar(max) | NULL |  |
| FinalPaymentBy | nvarchar(max) | NULL |  |
| FinalPaymentDate | datetime | NULL |  |
| RejectionSts | nvarchar(max) | NULL |  |
| Inv_DANameId | int | NULL |  |
| ModifyDate | datetime | NULL |  |

### `tblInvoiceBatch`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BatchId | int | NOT NULL | PK, IDENTITY |
| BatchNo | nvarchar(max) | NULL |  |
| Date | datetime | NULL |  |
| InvoiceId | int | NULL |  |

### `tblInvoiceDeleteLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| IDelLogId | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| InvoiceNo | nvarchar(500) | NULL |  |
| DelInvoiceNo | nvarchar(500) | NULL |  |
| DeleteDateTime | datetime | NULL |  |
| DeleteBy | nvarchar(500) | NULL |  |
| DeliveryDeleteBy | nvarchar(500) | NULL |  |
| DeliveryDeleteDateTime | nvarchar(500) | NULL |  |

### `tblInvoiceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceDetailId | int | NOT NULL | PK, IDENTITY |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalPriceVatAmount | decimal(18,2) | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| InvoiceId | int | NULL |  |
| DCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(max) | NULL |  |
| Campaign | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| AdjustmentAmount | decimal(18,2) | NULL |  |
| PaymentQuantity | decimal(18,0) | NULL |  |
| PaymentBonusQuantity | decimal(18,0) | NULL |  |
| PaymentTotalQuantity | decimal(18,0) | NULL |  |
| PaymentTotalPrice | decimal(18,2) | NULL |  |
| PaymentTotalPriceVatAmount | decimal(18,2) | NULL |  |
| PaymentDiscountPercentage | decimal(18,2) | NULL |  |
| PaymentDiscountAmount | decimal(18,2) | NULL |  |
| PaymentNetAmount | decimal(18,2) | NULL |  |
| PaymentReturnReason | nvarchar(50) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| PaymentTP | decimal(19,2) | NULL |  |

### `tblInvoiceDetail_DeleterRecord`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceDetailDR_Id | int | NOT NULL | PK, IDENTITY |
| InvoiceDetailId | int | NOT NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalPriceVatAmount | decimal(18,2) | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| InvoiceId | int | NULL |  |
| DCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(500) | NULL |  |
| SubDCStoreId | int | NULL |  |

### `tblInvoiceDetailReturn`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceDetailReturnId | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| InvoiceDetailId | int | NULL |  |
| PreviousQuantity | int | NULL |  |
| sndReturnQuantity | int | NULL |  |
| sndReturnBonusQuantity | int | NULL |  |
| sndReturnTotalQuantity | int | NULL |  |
| sndReturnTotalPrice | decimal(18,2) | NULL |  |
| sndReturnTotalPriceVatAmount | decimal(18,2) | NULL |  |
| sndReturnDiscountPercentage | decimal(5,2) | NULL |  |
| sndReturnDiscountAmount | decimal(18,2) | NULL |  |
| sndReturnNetAmount | decimal(18,2) | NULL |  |
| sndReturnStatus | nvarchar(50) | NULL |  |
| sndReturnReason | nvarchar(250) | NULL |  |

### `tblInvoiceNotBinding`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNotBindingId | int | NOT NULL | PK, IDENTITY |
| CustomerId | int | NULL |  |
| CustomerCode | varchar(50) | NULL |  |
| ActiveFromDate | date | NOT NULL |  |
| ActiveToDate | date | NULL |  |
| AllowedNoOfInvoice | int | NULL |  |
| AllowedCreditLimit | decimal(18,2) | NULL |  |
| NumberOfDaysInTransit | int | NULL |  |
| Remarks | nvarchar(250) | NULL |  |
| IsActive | bit | NOT NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdatedBy | nvarchar(50) | NULL |  |
| UpdatedDate | datetime | NULL |  |
| ApplyType | varchar(20) | NOT NULL |  |
| CustomerTypeId | int | NULL |  |

### `tblInvoiceStatusddl`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceStatusddl | int | NOT NULL | PK, IDENTITY |
| Value | nvarchar(50) | NULL |  |
| Text | nvarchar(50) | NULL |  |
| IsShowforPartial | bit | NULL |  |
| IsShowforRejection | bit | NULL |  |
| IsforReturn | bit | NULL |  |
| isForSalesConfirm | bit | NULL |  |

### `tblInvoiceTrigger`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceId | int | NOT NULL |  |
| InvoiceNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(max) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(max) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(max) | NULL |  |
| ProductOffer | nvarchar(max) | NULL |  |
| OldTradePolicy | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(max) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| DisCode | nvarchar(max) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(max) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| DeliveryPersonName | nvarchar(max) | NULL |  |
| DeliveryPersonPhNo | nvarchar(max) | NULL |  |
| Types | nvarchar(max) | NULL |  |
| GreenStarBlueStarID | int | NULL |  |
| AdjustAmount | decimal(18,2) | NULL |  |
| IsAdjustInvoice | bit | NULL |  |
| ReceivableAmount | decimal(18,2) | NULL |  |
| IsSalesTransfer | bit | NULL |  |
| TransferInvoiceDate | datetime | NULL |  |
| UpdateDatetime | datetime | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AdjustInvoiceNo_ReturnInvoiceNo | nvarchar(max) | NULL |  |
| DeliveryManId | int | NULL |  |
| AIT | int | NULL |  |
| DiscountOnPayment | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| MIOId | int | NULL |  |
| IsAuto | bit | NULL |  |
| LoadingSummaryStatus | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateBy | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateDate | datetime | NULL |  |
| loadingsummaryFinalStatus | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateBy | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateDatetime | datetime | NULL |  |
| PaymentTpTotal | decimal(18,2) | NULL |  |
| PaymentTpDiscount | decimal(18,2) | NULL |  |
| PaymentTpVat | decimal(18,2) | NULL |  |
| PaymentTpGrandTotal | decimal(18,2) | NULL |  |
| PaymentInvoiceStatus | nvarchar(max) | NULL |  |
| PaymentInvoiceNo | nvarchar(max) | NULL |  |
| PaymentBy | nvarchar(max) | NULL |  |
| PaymentDate | datetime | NULL |  |
| FinalPaymentNo | nvarchar(max) | NULL |  |
| FinalPaymentBy | nvarchar(max) | NULL |  |
| FinalPaymentDate | datetime | NULL |  |
| RejectionSts | nvarchar(max) | NULL |  |
| TriggerDate | datetime | NULL |  |

### `tblJoiningDateCountInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| JoiningDateCountId | int | NOT NULL | PK, IDENTITY |
| JoiningDateCountName | nvarchar(50) | NULL |  |

### `tblLeaveApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |

### `tblLeaveConfig`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveConfigId | int | NOT NULL | PK, IDENTITY |
| LeaveName | nvarchar(max) | NULL |  |
| CountGovtLeave | bit | NULL |  |
| CountEmployeeHoliday | bit | NULL |  |
| EligbleforProbationEmployee | bit | NULL |  |
| LeaveTypeId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| DayNameId | int | NULL |  |
| IsActive | bit | NULL |  |

### `tblLeaveConfigCountDtl`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveConfigCountId | int | NOT NULL | PK, IDENTITY |
| LeaveConfigId | int | NULL |  |
| JoiningDateCountId | int | NULL |  |
| DaysPerMonthly | decimal(18,16) | NULL |  |

### `tblLeaveConfigForeignId`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveConfigForeignId | int | NOT NULL | PK, IDENTITY |
| LeaveConfigId | int | NULL |  |
| EmployeeId | int | NULL |  |

### `tblLeaveConType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveConTypeId | int | NOT NULL | PK, IDENTITY |
| LeaveConType | nvarchar(50) | NULL |  |

### `tblLeaveEncashBlnc`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveEncashId | int | NOT NULL | PK, IDENTITY |
| EmpId | int | NULL |  |
| EmpCode | nvarchar(50) | NULL |  |
| AccumulateLeave | decimal(18,2) | NULL |  |
| YearVal | int | NULL |  |

### `tblLeaveOperation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LeaveOperationId | int | NOT NULL | PK, IDENTITY |
| EmpId | int | NULL |  |
| LeaveTypeId | int | NULL |  |
| DayValue | decimal(18,16) | NULL |  |
| MonthVal | int | NULL |  |
| YearVal | int | NULL |  |

### `tblLoginLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LogId | int | NOT NULL | IDENTITY |
| UserId | int | NULL |  |
| LoginName | nvarchar(500) | NULL |  |
| LoginTime | datetime | NULL |  |

### `tblMainMenu`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SL | int | NULL |  |
| ManuName | nvarchar(max) | NULL |  |
| URL | nvarchar(max) | NULL |  |
| ParantId | nvarchar(50) | NULL |  |
| IsApprovalPage | bit | NULL |  |
| Class | nvarchar(max) | NULL |  |
| Icon | nvarchar(max) | NULL |  |

### `tblMainMenuNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SL | int | NOT NULL |  |
| ManuName | nvarchar(max) | NULL |  |
| URL | nvarchar(max) | NULL |  |
| ParantId | nvarchar(50) | NULL |  |
| IsApprovalPage | bit | NULL |  |
| Class | nvarchar(max) | NULL |  |
| Icon | nvarchar(max) | NULL |  |
| SystemLink | nvarchar(max) | NULL |  |
| TypeId | int | NULL |  |
| Add | bit | NULL |  |
| View | bit | NULL |  |
| Delete | bit | NULL |  |
| Edit | bit | NULL |  |
| IsApp | bit | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `tblManufacturer`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ManufacId | int | NOT NULL | PK |
| ManufacName | nvarchar(max) | NULL |  |
| ManufacAddress | nvarchar(max) | NULL |  |
| ManufacCode | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| ActiveInactiveDate | datetime | NULL |  |

### `tblMar`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarCode | nvarchar(500) | NULL |  |

### `tblMarket`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubTerritoryId | int | NULL |  |
| MarketName | nvarchar(500) | NULL |  |
| MarketCode | nvarchar(500) | NULL |  |
| IsActive | int | NULL |  |
| acInAcDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ActiveInactiveBy | nvarchar(50) | NULL |  |
| ThanaId | int | NULL |  |
| MarketId | int | NOT NULL | PK, IDENTITY |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| IsCursor | bit | NULL |  |

### `tblMarketAttendace_Tracking_webapi`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AttendanceDetailsId | int | NOT NULL | PK, IDENTITY |
| AttendanceId | int | NULL |  |
| LatValue | nvarchar(500) | NULL |  |
| LongValue | nvarchar(500) | NULL |  |

### `tblMarketAttendance_Master_webapi`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AttendanceId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NOT NULL |  |
| PunchInTime | nvarchar(max) | NULL |  |
| PInLat | nvarchar(max) | NULL |  |
| PInLog | nvarchar(max) | NULL |  |
| POutRemarks | nvarchar(max) | NULL |  |
| AttendanceDate | datetime | NULL |  |
| PINCreatedDateTime | datetime | NULL |  |
| POUTCreatedDateTime | datetime | NULL |  |
| ApprovalStatus | nvarchar(max) | NULL |  |
| ShiftId | int | NULL |  |
| UserRoleID | int | NULL |  |
| ApprovedBy | nvarchar(500) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| AttType | int | NULL |  |
| AttAddress | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| GroupName_Att | nvarchar(max) | NULL |  |
| RegionName_Att | nvarchar(max) | NULL |  |
| AreaName_Att | nvarchar(max) | NULL |  |
| TerritoryName_Att | nvarchar(max) | NULL |  |
| SubTerritoryName_Att | nvarchar(max) | NULL |  |
| MarketName_Att | nvarchar(max) | NULL |  |
| GroupCode_Att | nvarchar(max) | NULL |  |
| RegionCode_Att | nvarchar(max) | NULL |  |
| AreaCode_Att | nvarchar(max) | NULL |  |
| TerritoryCode_Att | nvarchar(max) | NULL |  |
| SubTerritoryCode_Att | nvarchar(max) | NULL |  |
| MarketCode_Att | nvarchar(max) | NULL |  |
| isGone | bit | NULL |  |
| isGoneDate | datetime | NULL |  |

### `tblMarketAttendance_Master_webapiDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| AttendanceId | bigint | NOT NULL |  |
| EmpInfoId | bigint | NULL |  |
| PunchInTime | nvarchar(10) | NULL |  |
| PInLat | nvarchar(50) | NULL |  |
| PInLog | nvarchar(500) | NULL |  |
| POutRemarks | nvarchar(500) | NULL |  |
| AttendanceDate | date | NOT NULL |  |
| PINCreatedDateTime | datetime | NULL |  |
| POUTCreatedDateTime | datetime | NULL |  |
| ApprovalStatus | nvarchar(20) | NULL |  |
| ShiftId | int | NULL |  |
| UserRoleID | int | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| AttType | nvarchar(20) | NULL |  |
| AttAddress | nvarchar(500) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| GroupName_Att | nvarchar(100) | NULL |  |
| RegionName_Att | nvarchar(100) | NULL |  |
| AreaName_Att | nvarchar(100) | NULL |  |
| TerritoryName_Att | nvarchar(100) | NULL |  |
| SubTerritoryName_Att | nvarchar(100) | NULL |  |
| MarketName_Att | nvarchar(100) | NULL |  |
| GroupCode_Att | nvarchar(20) | NULL |  |
| RegionCode_Att | nvarchar(20) | NULL |  |
| AreaCode_Att | nvarchar(20) | NULL |  |
| TerritoryCode_Att | nvarchar(20) | NULL |  |
| SubTerritoryCode_Att | nvarchar(20) | NULL |  |
| MarketCode_Att | nvarchar(20) | NULL |  |
| isGone | bit | NULL |  |
| isGoneDate | date | NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tblMarketFake`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OldOrder | nvarchar(max) | NULL |  |

### `tblMarketPropDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarketPropDetailId | int | NOT NULL | PK, IDENTITY |
| MarketPropMasterId | int | NULL |  |
| TerritoryId | int | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| MarketId | int | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| DivisionId | int | NULL |  |
| DivisionName | nvarchar(max) | NULL |  |
| DistrictId | int | NULL |  |
| DistrictName | nvarchar(max) | NULL |  |
| ThanaId | int | NULL |  |
| ThanaName | nvarchar(max) | NULL |  |
| DZSMStationType | nvarchar(max) | NULL |  |
| DZSMStationTypeId | int | NULL |  |
| AMStationType | nvarchar(max) | NULL |  |
| AMStationTypeId | int | NULL |  |
| MIOStationType | nvarchar(max) | NULL |  |
| MIOStationTypeId | int | NULL |  |
| Issuccess | bit | NULL |  |
| RegionalHeadStationType | nvarchar(max) | NULL |  |
| RegionalHeadStationTypeId | int | NULL |  |
| SalesAssistantStationType | nvarchar(max) | NULL |  |
| SalesAssistantStationTypeId | int | NULL |  |

### `tblMarketPropMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarketPropMasterId | int | NOT NULL | PK, IDENTITY |
| TypeId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| ConvertType | nvarchar(50) | NULL |  |
| IsTransfer | bit | NULL |  |

### `tblMarketStationDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarketId | int | NULL |  |
| StationTypeId | int | NULL |  |
| UserRoleID | int | NULL |  |
| MarketStationDetailId | int | NOT NULL | PK, IDENTITY |

### `tblMarketStructureTranfer`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarketStructureTranferId | int | NOT NULL | PK, IDENTITY |
| FGroupId | int | NULL |  |
| FRegionId | int | NULL |  |
| FAreaId | int | NULL |  |
| FTerritoryId | int | NULL |  |
| FSubTerritoryId | int | NULL |  |
| FMarketId | int | NULL |  |
| TGroupId | int | NULL |  |
| TRegionId | int | NULL |  |
| TAreaId | int | NULL |  |
| TTerritoryId | int | NULL |  |
| TSubTerritoryId | int | NULL |  |
| TMarketId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| MarketType | nvarchar(500) | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ApprovalStatus | nvarchar(500) | NULL |  |

### `tblMenuDistribution`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SL | int | NOT NULL | PK |
| UserId | int | NULL |  |
| MenuSL | int | NULL |  |
| Status | bit | NULL |  |

### `tblMenuRole`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MenuRoleId | int | NOT NULL | IDENTITY |
| SL | int | NULL |  |
| RoleId | int | NULL |  |
| Add | bit | NULL |  |
| View | bit | NULL |  |
| Delete | bit | NULL |  |
| Edit | bit | NULL |  |
| Permission | bit | NULL |  |

### `tblMIAInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MiaCode | nvarchar(500) | NULL |  |
| MiaName | nvarchar(500) | NULL |  |
| MiaId | int | NOT NULL | PK |
| ManufacId | int | NULL |  |
| AreaId | int | NULL |  |
| Entrydate | datetime | NULL |  |

### `tblMIATarget`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MiaTargetId | int | NOT NULL | PK, IDENTITY |
| MiaTargetAmount | decimal(18,0) | NULL |  |
| MiaCode | varchar(max) | NULL |  |
| MiaName | varchar(max) | NULL |  |
| Period | varchar(max) | NULL |  |
| Year | varchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblMIATargetProductWise`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MiaTargetId | int | NOT NULL | PK, IDENTITY |
| MiaId | int | NULL |  |
| MiaName | nvarchar(max) | NULL |  |
| TargetQty | int | NULL |  |
| Period | nvarchar(50) | NULL |  |
| Year | nvarchar(50) | NULL |  |
| CompanyId | int | NULL |  |
| ProductId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblMIGODetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MigoDetailID | int | NOT NULL | PK, IDENTITY |
| MigoMasterID | int | NULL |  |
| ShipToParty | nvarchar(max) | NULL |  |
| PONo | nvarchar(max) | NULL |  |
| PODate | datetime | NULL |  |
| ItemNo | nvarchar(max) | NULL |  |
| OrderDocNo | nvarchar(max) | NULL |  |
| OrderDocDate | datetime | NULL |  |
| DeliveryDocNo | nvarchar(max) | NULL |  |
| DeliveryDocDate | datetime | NULL |  |
| LMID | nvarchar(max) | NULL |  |
| LMIDDescription | nvarchar(max) | NULL |  |
| Batch | nvarchar(max) | NULL |  |
| ExpDate | datetime | NULL |  |
| MfgDate | datetime | NULL |  |
| Qty | decimal(18,0) | NULL |  |
| VATChallan | nvarchar(max) | NULL |  |
| BilltoParty | nvarchar(max) | NULL |  |
| InvoiceNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| CaseNoofShipper | nvarchar(max) | NULL |  |
| VAT | decimal(18,2) | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| Total | decimal(18,2) | NULL |  |
| TransportNo | nvarchar(max) | NULL |  |

### `tblMIGOMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MigoMasterID | int | NOT NULL | PK |
| MogoCode | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| MogoDocumentDate | datetime | NULL |  |
| StockUpload | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblMileageApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MileageApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblMIOInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmployeeId | int | NULL |  |
| TerritoryId | int | NULL |  |
| IsActive | bit | NULL |  |
| MIOId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| Vacant | nvarchar(50) | NULL |  |
| ActiveDate | datetime | NULL |  |
| ActiveInActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| SAP_MIOCode | nvarchar(max) | NULL |  |

### `tblMIOUPDATE`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MIOCODE | nvarchar(max) | NULL |  |
| TERRITORYCODE | nvarchar(max) | NULL |  |
| MIONAME | nvarchar(max) | NULL |  |

### `tblMissingOrder`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderCode | nvarchar(max) | NULL |  |
| CusstomerCode | nvarchar(max) | NULL |  |

### `tblMissingOrdertwo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderCode | nvarchar(max) | NULL |  |

### `tblMonthlyAllowances`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MonthlyAllowanceId | int | NOT NULL | PK, IDENTITY |
| RoleName | nvarchar(100) | NOT NULL |  |
| AllowanceName | nvarchar(200) | NOT NULL |  |
| AllowanceAmount | decimal(18,2) | NOT NULL |  |
| IsActive | bit | NOT NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NOT NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblMonthlyTarget`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MTargetId | int | NOT NULL | PK, IDENTITY |
| Year | int | NULL |  |
| Month | int | NULL |  |
| Date | datetime | NULL |  |
| FinYearId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblNational_NSM`

| Column | Type | Nullable | Key |
|---|---|---|---|
| National_NSMName | nvarchar(max) | NULL |  |
| NationalId | int | NULL |  |
| National_NSMId | int | NOT NULL | PK, IDENTITY |
| IsActive | bit | NULL |  |
| CompanyId | int | NULL |  |
| EmployeeId | int | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Vacant | nvarchar(50) | NULL |  |

### `tblNationalTargetSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NatargetSpId | int | NOT NULL | PK, IDENTITY |
| Year | nvarchar(50) | NULL |  |
| Month | nvarchar(50) | NULL |  |
| GroupId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblNewCustomerChk`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CusCode | nvarchar(max) | NULL |  |

### `tblNewCustomerterritory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CODE | nvarchar(max) | NULL |  |
| TERRITORY | nvarchar(max) | NULL |  |
| PROGRAMTYPE | nvarchar(max) | NULL |  |
| OPERATORTYPE | nvarchar(max) | NULL |  |

### `tblNonEffectiveReason`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReasonId | int | NOT NULL | PK, IDENTITY |
| ReasonName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |

### `tblNonTranscationalInvoiceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvReturnDetailID | int | NOT NULL | PK, IDENTITY |
| InvReturnMasterID | int | NULL |  |
| ProductId | int | NULL |  |
| Batch | nvarchar(max) | NULL |  |
| ExpDate | datetime | NULL |  |
| MfgDate | datetime | NULL |  |
| Qty | decimal(18,0) | NULL |  |
| Price | decimal(18,2) | NULL |  |
| VAT | decimal(18,2) | NULL |  |
| TotalAmount | decimal(18,2) | NULL |  |

### `tblNonTranscationalInvoiceMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvReturnMasterID | int | NOT NULL | PK, IDENTITY |
| ReturnCode | nvarchar(50) | NULL |  |
| InvoiceId | int | NULL |  |
| ReturnDate | datetime | NULL |  |
| SalesDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| TotalReturn | decimal(18,2) | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| TotalValue | decimal(18,2) | NULL |  |

### `tblNotice_Employee`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Notice_Emp_Id | int | NOT NULL | PK, IDENTITY |
| EmployeeId | int | NULL |  |
| IsAppCheck | bit | NULL |  |
| MasterId | int | NULL |  |
| Server_SeenDate | datetime | NULL |  |
| Apps_SeenDate | datetime | NULL |  |
| IsPushNotificationEmp | bit | NULL |  |

### `tblNoticeUserRoleDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NoticeUserRoleDetailId | int | NOT NULL | PK, IDENTITY |
| NoticeId | int | NULL |  |
| UserRoleID | int | NULL |  |

### `tblNSMInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| NSMName | nvarchar(max) | NULL |  |
| GroupId | int | NULL |  |
| NSMId | int | NOT NULL | PK, IDENTITY |
| IsActive | bit | NULL |  |
| CompanyId | int | NULL |  |
| EmployeeId | int | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Vacant | nvarchar(50) | NULL |  |

### `tblOpeningBalanceFinancialYearLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| LogId | bigint | NOT NULL | PK, IDENTITY |
| FinancialYear | nvarchar(50) | NOT NULL |  |
| FromDate | date | NOT NULL |  |
| ToDate | date | NOT NULL |  |
| ProcessDate | datetime | NOT NULL |  |
| TotalOrdersProcessed | int | NULL |  |
| TotalAmount | decimal(18,2) | NULL |  |
| Status | nvarchar(20) | NOT NULL |  |
| CreatedBy | nvarchar(100) | NULL |  |
| CreatedDate | datetime | NOT NULL |  |
| Remarks | nvarchar(500) | NULL |  |

### `tblOrder`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderId | int | NOT NULL | PK, IDENTITY |
| OrderCode | nvarchar(max) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(max) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| IsInvoice | bit | NULL |  |
| IsManual | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| IsSpDis | bit | NULL |  |
| CustomerMasterId | int | NULL |  |
| DeliveryPersonId | int | NULL |  |
| IsSpecialApproval | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsDirect | bit | NULL |  |
| IsFromApp | bit | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| OrderType | nvarchar(50) | NULL |  |
| DistributionRouteId | int | NULL |  |
| RsmEmpId | int | NULL |  |
| AsmEmpId | int | NULL |  |
| TPDiscount | decimal(18,2) | NULL |  |
| ServerDateTime | datetime | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| RSMId | int | NULL |  |
| ASMId | int | NULL |  |
| MIOId | int | NULL |  |
| NSMId | int | NULL |  |
| TotalVat | decimal(18,3) | NULL |  |
| TotalDiscount | decimal(18,3) | NULL |  |
| TotalNetPayable | decimal(18,3) | NULL |  |
| CustTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| DeliveryDate | datetime | NULL |  |
| IsSubDepo | bit | NULL |  |
| GroupName_Ord | nvarchar(max) | NULL |  |
| RegionName_Ord | nvarchar(max) | NULL |  |
| AreaName_Ord | nvarchar(max) | NULL |  |
| TerritoryName_Ord | nvarchar(max) | NULL |  |
| SubTerritoryName_Ord | nvarchar(max) | NULL |  |
| MarketName_Ord | nvarchar(max) | NULL |  |
| GroupCode_Ord | nvarchar(max) | NULL |  |
| RegionCode_Ord | nvarchar(max) | NULL |  |
| AreaCode_Ord | nvarchar(max) | NULL |  |
| TerritoryCode_Ord | nvarchar(max) | NULL |  |
| SubTerritoryCode_Ord | nvarchar(max) | NULL |  |
| MarketCode_Ord | nvarchar(max) | NULL |  |
| DistributionRoute_Ord | nvarchar(max) | NULL |  |
| SmcTypeId_Ord | int | NULL |  |
| SMCType_Ord | nvarchar(max) | NULL |  |
| MIOSAPCode_Ord | nvarchar(max) | NULL |  |
| AMSAPCode_Ord | nvarchar(max) | NULL |  |
| DZSMSAPCode_Ord | nvarchar(max) | NULL |  |
| SAPTerritoryCode_Ord | nvarchar(max) | NULL |  |
| IsRejectionInvoice | bit | NULL |  |
| IsPrepareforInvoice | bit | NULL |  |
| ChangedOrderSenderCode | nvarchar(max) | NULL |  |
| PaymentType | nvarchar(max) | NULL |  |
| PaymentDate_ord | datetime | NULL |  |
| DistributionRouteIdOld | int | NULL |  |
| DistributionRouteNAmeOld | nvarchar(max) | NULL |  |
| forRouteProcess | bit | NULL |  |
| OrDRouteTerritoryId | int | NULL |  |
| S_Date | datetime | NULL |  |
| SAforSelectedSick | int | NULL |  |

### `tblOrder_Doctorrequirement`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderId | int | NOT NULL | PK, IDENTITY |
| OrderCode | nvarchar(max) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(max) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| IsInvoice | bit | NULL |  |
| IsManual | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| IsSpDis | bit | NULL |  |
| CustomerMasterId | int | NULL |  |
| DeliveryPersonId | int | NULL |  |
| IsSpecialApproval | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsDirect | bit | NULL |  |
| IsFromApp | bit | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| OrderType | nvarchar(50) | NULL |  |
| DistributionRouteId | int | NULL |  |
| RsmEmpId | int | NULL |  |
| AsmEmpId | int | NULL |  |
| TPDiscount | decimal(18,2) | NULL |  |
| ServerDateTime | datetime | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| RSMId | int | NULL |  |
| ASMId | int | NULL |  |
| MIOId | int | NULL |  |
| NSMId | int | NULL |  |
| DoctorId | int | NULL |  |

### `tblOrderApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblOrderDel`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDELId | int | NOT NULL | PK, IDENTITY |
| OrderId | int | NULL |  |
| OrderCode | nvarchar(max) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(max) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| IsInvoice | bit | NULL |  |
| IsManual | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| IsSpDis | bit | NULL |  |
| CustomerMasterId | int | NULL |  |
| DeliveryPersonId | int | NULL |  |
| IsSpecialApproval | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsDirect | bit | NULL |  |
| IsFromApp | bit | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| OrderType | nvarchar(50) | NULL |  |
| DistributionRouteId | int | NULL |  |
| RsmEmpId | int | NULL |  |
| AsmEmpId | int | NULL |  |
| TPDiscount | decimal(18,2) | NULL |  |
| ServerDateTime | datetime | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| RSMId | int | NULL |  |
| ASMId | int | NULL |  |
| MIOId | int | NULL |  |
| NSMId | int | NULL |  |
| TotalVat | decimal(18,3) | NULL |  |
| TotalDiscount | decimal(18,3) | NULL |  |
| TotalNetPayable | decimal(18,3) | NULL |  |
| CustTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| DeliveryDate | datetime | NULL |  |
| IsSubDepo | bit | NULL |  |
| DelBy | nvarchar(50) | NULL |  |
| DelDate | datetime | NULL |  |

### `tblOrderDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderId | int | NOT NULL | IDENTITY |
| OrderCode | nvarchar(max) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(max) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| IsInvoice | bit | NULL |  |
| IsManual | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| IsSpDis | bit | NULL |  |
| CustomerMasterId | int | NULL |  |
| DeliveryPersonId | int | NULL |  |
| IsSpecialApproval | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsDirect | bit | NULL |  |
| IsFromApp | bit | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| OrderType | nvarchar(50) | NULL |  |
| DistributionRouteId | int | NULL |  |
| RsmEmpId | int | NULL |  |
| AsmEmpId | int | NULL |  |
| TPDiscount | decimal(18,2) | NULL |  |
| ServerDateTime | datetime | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| RSMId | int | NULL |  |
| ASMId | int | NULL |  |
| MIOId | int | NULL |  |
| NSMId | int | NULL |  |
| TotalVat | decimal(18,3) | NULL |  |
| TotalDiscount | decimal(18,3) | NULL |  |
| TotalNetPayable | decimal(18,3) | NULL |  |
| CustTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| DeliveryDate | datetime | NULL |  |
| IsSubDepo | bit | NULL |  |
| GroupName_Ord | nvarchar(max) | NULL |  |
| RegionName_Ord | nvarchar(max) | NULL |  |
| AreaName_Ord | nvarchar(max) | NULL |  |
| TerritoryName_Ord | nvarchar(max) | NULL |  |
| SubTerritoryName_Ord | nvarchar(max) | NULL |  |
| MarketName_Ord | nvarchar(max) | NULL |  |
| GroupCode_Ord | nvarchar(max) | NULL |  |
| RegionCode_Ord | nvarchar(max) | NULL |  |
| AreaCode_Ord | nvarchar(max) | NULL |  |
| TerritoryCode_Ord | nvarchar(max) | NULL |  |
| SubTerritoryCode_Ord | nvarchar(max) | NULL |  |
| MarketCode_Ord | nvarchar(max) | NULL |  |
| DistributionRoute_Ord | nvarchar(max) | NULL |  |
| SmcTypeId_Ord | int | NULL |  |
| SMCType_Ord | nvarchar(max) | NULL |  |
| MIOSAPCode_Ord | nvarchar(max) | NULL |  |
| AMSAPCode_Ord | nvarchar(max) | NULL |  |
| DZSMSAPCode_Ord | nvarchar(max) | NULL |  |
| SAPTerritoryCode_Ord | nvarchar(max) | NULL |  |
| IsRejectionInvoice | bit | NULL |  |
| IsPrepareforInvoice | bit | NULL |  |
| ChangedOrderSenderCode | nvarchar(max) | NULL |  |
| PaymentType | nvarchar(max) | NULL |  |
| PaymentDate_ord | datetime | NULL |  |
| DistributionRouteIdOld | int | NULL |  |
| DistributionRouteNAmeOld | nvarchar(max) | NULL |  |
| forRouteProcess | bit | NULL |  |
| OrDRouteTerritoryId | int | NULL |  |
| S_Date | datetime | NULL |  |

### `tblOrderDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailId | int | NOT NULL | PK, IDENTITY |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| TradePrice | decimal(18,2) | NULL |  |
| TotalTradePrice | decimal(18,2) | NULL |  |
| OrderId | int | NULL |  |
| OrderListDetailId | int | NULL |  |
| Status | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| DiscountPercent | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,3) | NULL |  |
| TotalVatAmount | decimal(18,3) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| IsSpDis | bit | NULL |  |
| CampaignCategory | nvarchar(max) | NULL |  |

### `tblOrderDetail_Doctorrequirement`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailId | int | NOT NULL | IDENTITY |
| OrderId | int | NULL |  |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| Quantity | nvarchar(max) | NULL |  |

### `tblOrderDetailDel`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailDelId | int | NOT NULL | PK, IDENTITY |
| OrderDetailId | int | NULL |  |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| TradePrice | decimal(18,2) | NULL |  |
| TotalTradePrice | decimal(18,2) | NULL |  |
| OrderId | int | NULL |  |
| OrderListDetailId | int | NULL |  |
| Status | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| DiscountPercent | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,3) | NULL |  |
| TotalVatAmount | decimal(18,3) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| IsSpDis | bit | NULL |  |

### `tblOrderDetailDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailId | int | NOT NULL | IDENTITY |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| TradePrice | decimal(18,2) | NULL |  |
| TotalTradePrice | decimal(18,2) | NULL |  |
| OrderId | int | NULL |  |
| OrderListDetailId | int | NULL |  |
| Status | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| DiscountPercent | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,3) | NULL |  |
| TotalVatAmount | decimal(18,3) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| IsSpDis | bit | NULL |  |
| CampaignCategory | nvarchar(max) | NULL |  |

### `tblOrderListDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailId | int | NOT NULL | PK, IDENTITY |
| OrderMasterID | int | NULL |  |
| SalesCentre | nvarchar(max) | NULL |  |
| SalesCentreName | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(500) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| FECode | nvarchar(max) | NULL |  |
| DZSMCode | nvarchar(max) | NULL |  |
| CustomerID | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| OrderQty | decimal(18,0) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| OrderCode | nvarchar(max) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| OrderDetailIdApi | int | NULL |  |
| DiscountPercent | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| TotalVatAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| Address | nvarchar(max) | NULL |  |
| CellNo | nvarchar(max) | NULL |  |
| ConPerson | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| TerritoryName | nvarchar(max) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| FixedCustomer | nvarchar(max) | NULL |  |
| ProgramType | nvarchar(max) | NULL |  |
| CustomerStation | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Thana | nvarchar(max) | NULL |  |
| Upazila | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| IsSpDis | bit | NULL |  |

### `tblOrderListMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderMasterID | int | NOT NULL | PK |
| ManufacId | int | NULL |  |
| DocumentDate | datetime | NULL |  |
| GenerateOrder | bit | NULL |  |
| EntryBy | nvarchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| IsApiData | bit | NULL |  |

### `tblOrderPermission`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderPermissionId | int | NOT NULL | PK, IDENTITY |
| TerritoryId | int | NULL |  |
| PermittedEmpId | int | NULL |  |
| FrmDate | datetime | NULL |  |
| ToDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblPackSize`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PackSizeId | int | NOT NULL | PK, IDENTITY |
| PackSizeName | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| ActiveInactiveDate | datetime | NULL |  |
| PackSizeCode | nvarchar(50) | NULL |  |
| PackSizeSAPCode | nvarchar(50) | NULL |  |

### `tblPaymentCollection_appLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PaymentCollectionAppLogId | int | NOT NULL | PK, IDENTITY |
| DaId | int | NOT NULL |  |
| ComUnitId | int | NOT NULL |  |
| RouteId | int | NOT NULL |  |
| InvoiceId | int | NOT NULL |  |
| PayableAmount | decimal(18,2) | NULL |  |
| ApprovalStatus | nvarchar(50) | NOT NULL |  |
| ApproveDate | datetime2 | NULL |  |
| ApproveBy | int | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |
| BankId | int | NULL |  |
| approvebyDIC | nvarchar(50) | NULL |  |
| ApproveDICDate | datetime | NULL |  |
| DepositEntryDate | datetime | NULL |  |
| isDepositEntryDone | bit | NULL |  |

### `tblPaymentReverseDELInvoice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PaymentReverseDELInvoiceID | int | NOT NULL | PK |
| InvoiceId | int | NULL |  |
| InvoiceNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(50) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| ProductOffer | nvarchar(50) | NULL |  |
| OldTradePolicy | nvarchar(50) | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| DeliveryManId | int | NULL |  |
| BatchId | int | NULL |  |
| IsDirect | bit | NULL |  |
| IsPosting | bit | NULL |  |
| DeleteBy | nvarchar(50) | NULL |  |
| DeleteDate | datetime | NULL |  |

### `tblPaymentTranscationDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayDetailId | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| CustPayId | int | NULL |  |
| IsPrint | bit | NULL |  |
| Discount | decimal(18,2) | NULL |  |
| CashAccId | int | NULL |  |
| IsPosting | bit | NULL |  |
| BankAccId | int | NULL |  |
| IsDetailProcess | bit | NULL |  |
| PaymentRemarks | nvarchar(max) | NULL |  |
| AIT | decimal(18,2) | NULL |  |

### `tblPaymentTranscationMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustPayId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| PaymentDate | datetime | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PayType | nvarchar(50) | NULL |  |
| RefNo | nvarchar(50) | NULL |  |
| RefDate | datetime | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsProcess | bit | NULL |  |
| InvPaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| IsReject | bit | NULL |  |

### `tblPaymentType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PaymentTypeId | int | NOT NULL | PK |
| PaymentTypeName | nvarchar(max) | NULL |  |

### `tblPendingDeliveryInvoice_Detail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PendingDetailsID | int | NOT NULL | PK, IDENTITY |
| PendingID | int | NULL |  |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Order_Quantity | decimal(18,0) | NULL |  |
| Order_TradePrice | decimal(18,2) | NULL |  |
| Order_TotalTradePrice | decimal(18,2) | NULL |  |
| Order_Status | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| Order_DiscountPercent | decimal(18,2) | NULL |  |
| Order_DiscountAmount | decimal(18,2) | NULL |  |
| Order_UnitVatAmount | decimal(18,3) | NULL |  |
| Order_TotalVatAmount | decimal(18,3) | NULL |  |
| Order_NetAmount | decimal(18,2) | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| IsSpDis | bit | NULL |  |
| CampaignCategory | nvarchar(max) | NULL |  |
| Invoice_CostPrice | decimal(18,2) | NULL |  |
| Invoice_UnitPrice | decimal(18,2) | NULL |  |
| Invoice_UnitVatAmount | decimal(18,2) | NULL |  |
| Invoice_Quantity | decimal(18,0) | NULL |  |
| Invoice_BonusQuantity | decimal(18,0) | NULL |  |
| Invoice_TotalQuantity | decimal(18,0) | NULL |  |
| Invoice_TotalPrice | decimal(18,2) | NULL |  |
| Invoice_TotalPriceVatAmount | decimal(18,2) | NULL |  |
| Invoice_DiscountPercentage | decimal(18,2) | NULL |  |
| Invoice_DiscountAmount | decimal(18,2) | NULL |  |
| Invoice_NetAmount | decimal(18,2) | NULL |  |
| InvoiceId | int | NULL |  |
| DCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(max) | NULL |  |
| Campaign | nvarchar(max) | NULL |  |
| AdjustmentAmount | decimal(18,2) | NULL |  |
| PaymentQuantity | decimal(18,0) | NULL |  |
| PaymentBonusQuantity | decimal(18,0) | NULL |  |
| PaymentTotalQuantity | decimal(18,0) | NULL |  |
| PaymentTotalPrice | decimal(18,2) | NULL |  |
| PaymentTotalPriceVatAmount | decimal(18,2) | NULL |  |
| PaymentDiscountPercentage | decimal(18,2) | NULL |  |
| PaymentDiscountAmount | decimal(18,2) | NULL |  |
| PaymentNetAmount | decimal(18,2) | NULL |  |
| PaymentReturnReason | nvarchar(50) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |

### `tblPendingDeliveryInvoice_Master`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PendingDelID | int | NOT NULL | PK, IDENTITY |
| OrderId | int | NULL |  |
| OrderCode | nvarchar(max) | NULL |  |
| OrderSubmissionDate | datetime | NULL |  |
| DepoId | int | NULL |  |
| DepoCode | nvarchar(max) | NULL |  |
| DepoName | nvarchar(max) | NULL |  |
| CustomerMasterId | int | NULL |  |
| CustomerCode | nvarchar(max) | NULL |  |
| CustomerName | nvarchar(max) | NULL |  |
| CustTypeId | int | NULL |  |
| ProgramTypeId | int | NULL |  |
| CustType | nvarchar(max) | NULL |  |
| ProgramType | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| DistributionRouteId | int | NULL |  |
| DistributionRoute_Name | nvarchar(max) | NULL |  |
| NSMId | int | NULL |  |
| RSMId | int | NULL |  |
| ASMId | int | NULL |  |
| MIOId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| Group_Name | nvarchar(max) | NULL |  |
| Region_Name | nvarchar(max) | NULL |  |
| Area_Name | nvarchar(max) | NULL |  |
| Territory_Name | nvarchar(max) | NULL |  |
| SubTerritory_Name | nvarchar(max) | NULL |  |
| Market_Name | nvarchar(max) | NULL |  |

### `tblPersonInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BSPCode | nvarchar(max) | NULL |  |
| Name | nvarchar(max) | NULL |  |
| OwnerName | nvarchar(max) | NULL |  |
| Address | nvarchar(max) | NULL |  |
| Mobile | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Upazila | nvarchar(max) | NULL |  |
| ProviderType | nvarchar(50) | NULL |  |
| PersonId | int | NOT NULL | PK, IDENTITY |
| entrydate | datetime | NULL |  |
| updatedate | datetime | NULL |  |

### `tblPettyCashDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PettyCashDetailsId | int | NOT NULL | PK, IDENTITY |
| PettyCashmasterId | int | NULL |  |
| PerticulerId | int | NULL |  |
| CashReason | nvarchar(max) | NULL |  |
| Amount | decimal(18,2) | NULL |  |

### `tblPettyCashMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PettyCashmasterId | int | NOT NULL | PK, IDENTITY |
| ConpanyId | int | NULL |  |
| PostingDate | datetime | NULL |  |
| CashAccId | int | NULL |  |
| Remark | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActiveStatus | nvarchar(50) | NULL |  |

### `tblPrescriptionApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PrescriptionApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblPrescriptionApprovalLogDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PrescriptionApprovalId | int | NOT NULL | IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblPreviousCustInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UpdateID | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NOT NULL |  |
| CustomerCode | nvarchar(50) | NOT NULL |  |
| CategoryId | int | NOT NULL |  |
| CustomerName | nvarchar(max) | NOT NULL |  |
| Address | nvarchar(max) | NOT NULL |  |
| CellNo | nvarchar(max) | NOT NULL |  |
| MarketId | int | NULL |  |
| Addrees2 | nvarchar(max) | NOT NULL |  |
| City | nvarchar(max) | NOT NULL |  |
| ConPerson | nvarchar(max) | NOT NULL |  |
| ShippingCond | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NOT NULL |  |
| MarketName | nvarchar(max) | NOT NULL |  |
| MIACode | nvarchar(50) | NOT NULL |  |
| MIAName | nvarchar(max) | NOT NULL |  |
| AreaCode | nvarchar(50) | NOT NULL |  |
| DisCode | nvarchar(50) | NOT NULL |  |
| FEName | nvarchar(max) | NOT NULL |  |
| ComUnitCode | nvarchar(50) | NOT NULL |  |
| ComUnitName | nvarchar(max) | NOT NULL |  |
| RegionCode | nvarchar(50) | NOT NULL |  |
| DZSMName | nvarchar(max) | NOT NULL |  |
| TermOfPayment | nvarchar(50) | NULL |  |
| CustomerCodeOld | nvarchar(50) | NULL |  |
| UploadDate | datetime | NULL |  |
| ExcelUpload | bit | NULL |  |
| FixedCustomer | bit | NULL |  |
| CreateBy | nvarchar(50) | NOT NULL |  |
| CreateDate | datetime | NOT NULL |  |

### `tblProCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CategoryId | int | NOT NULL | PK |
| CategoryCode | nvarchar(50) | NULL |  |
| CategoryName | nvarchar(50) | NULL |  |
| CategorySAPCode | nvarchar(50) | NULL |  |

### `tblProcess_SMCFamilyDoctor`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Processid | int | NOT NULL | PK, IDENTITY |
| DoctorId | int | NULL |  |
| AreaId | int | NULL |  |
| RegionId | int | NULL |  |
| TerritoryId | int | NULL |  |
| RegionName | nvarchar(500) | NULL |  |
| AreaName | nvarchar(500) | NULL |  |
| MIOCode | nvarchar(500) | NULL |  |
| MIOName | nvarchar(500) | NULL |  |
| DoctorName | nvarchar(500) | NULL |  |
| DegreeName | nvarchar(500) | NULL |  |
| DoctorSpeciality | nvarchar(500) | NULL |  |
| ProgramTypeName | nvarchar(500) | NULL |  |
| DoctorTypeName | nvarchar(500) | NULL |  |
| 1_DCP | int | NULL |  |
| 1_DCR | int | NULL |  |
| 1_RX | int | NULL |  |
| 2_DCP | int | NULL |  |
| 2_DCR | int | NULL |  |
| 2_RX | int | NULL |  |
| 3_DCP | int | NULL |  |
| 3_DCR | int | NULL |  |
| 3_RX | int | NULL |  |
| 4_DCP | int | NULL |  |
| 4_DCR | int | NULL |  |
| 4_RX | int | NULL |  |
| 5_DCP | int | NULL |  |
| 5_DCR | int | NULL |  |
| 5_RX | int | NULL |  |
| 6_DCP | int | NULL |  |
| 6_DCR | int | NULL |  |
| 6_RX | int | NULL |  |
| 7_DCP | int | NULL |  |
| 7_DCR | int | NULL |  |
| 7_RX | int | NULL |  |
| 8_DCP | int | NULL |  |
| 8_DCR | int | NULL |  |
| 8_RX | int | NULL |  |
| 9_DCP | int | NULL |  |
| 9_DCR | int | NULL |  |
| 9_RX | int | NULL |  |
| 10_DCP | int | NULL |  |
| 10_DCR | int | NULL |  |
| 10_RX | int | NULL |  |
| 11_DCP | int | NULL |  |
| 11_DCR | int | NULL |  |
| 11_RX | int | NULL |  |
| 12_DCP | int | NULL |  |
| 12_DCR | int | NULL |  |
| 12_RX | int | NULL |  |
| 13_DCP | int | NULL |  |
| 13_DCR | int | NULL |  |
| 13_RX | int | NULL |  |
| 14_DCP | int | NULL |  |
| 14_DCR | int | NULL |  |
| 14_RX | int | NULL |  |
| 15_DCP | int | NULL |  |
| 15_DCR | int | NULL |  |
| 15_RX | int | NULL |  |
| 16_DCP | int | NULL |  |
| 16_DCR | int | NULL |  |
| 16_RX | int | NULL |  |
| 17_DCP | int | NULL |  |
| 17_DCR | int | NULL |  |
| 17_RX | int | NULL |  |
| 18_DCP | int | NULL |  |
| 18_DCR | int | NULL |  |
| 18_RX | int | NULL |  |
| 19_DCP | int | NULL |  |
| 19_DCR | int | NULL |  |
| 19_RX | int | NULL |  |
| 20_DCP | int | NULL |  |
| 20_DCR | int | NULL |  |
| 20_RX | int | NULL |  |
| 21_DCP | int | NULL |  |
| 21_DCR | int | NULL |  |
| 21_RX | int | NULL |  |
| 22_DCP | int | NULL |  |
| 22_DCR | int | NULL |  |
| 22_RX | int | NULL |  |
| 23_DCP | int | NULL |  |
| 23_DCR | int | NULL |  |
| 23_RX | int | NULL |  |
| 24_DCP | int | NULL |  |
| 24_DCR | int | NULL |  |
| 24_RX | int | NULL |  |
| 25_DCP | int | NULL |  |
| 25_DCR | int | NULL |  |
| 25_RX | int | NULL |  |
| 26_DCP | int | NULL |  |
| 26_DCR | int | NULL |  |
| 26_RX | int | NULL |  |
| 27_DCP | int | NULL |  |
| 27_DCR | int | NULL |  |
| 27_RX | int | NULL |  |
| 28_DCP | int | NULL |  |
| 28_DCR | int | NULL |  |
| 28_RX | int | NULL |  |
| 29_DCP | int | NULL |  |
| 29_DCR | int | NULL |  |
| 29_RX | int | NULL |  |
| 30_DCP | int | NULL |  |
| 30_DCR | int | NULL |  |
| 30_RX | int | NULL |  |
| 31_DCP | int | NULL |  |
| 31_DCR | int | NULL |  |
| 31_RX | int | NULL |  |
| to_DCP | int | NULL |  |
| to_DCR | int | NULL |  |
| to_RX | int | NULL |  |
| MonthValue | int | NULL |  |
| YearValue | int | NULL |  |
| ProcessDate | datetime | NULL |  |

### `tblProduct`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductId | int | NOT NULL | PK |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| Description | nvarchar(max) | NULL |  |
| ProductBrandId | int | NULL |  |
| PackSizeId | int | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| ProTypeId | int | NULL |  |
| CategoryId | nvarchar(max) | NULL |  |
| ManufacId | int | NULL |  |
| StockUOMId | int | NULL |  |
| CaseId | int | NULL |  |
| GroupId | int | NULL |  |
| CompanyId | int | NULL |  |
| ProductType | nvarchar(max) | NULL |  |
| CategoryId1 | int | NULL |  |
| ShippingCartonSizeId | int | NULL |  |
| GenericGroupId | int | NULL |  |
| TherapueticGroupId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ProductImage | nvarchar(max) | NULL |  |
| ProductGroupId | int | NULL |  |
| IsActive | bit | NULL |  |
| ProductLineID | int | NULL |  |
| SAP_Code | nvarchar(max) | NULL |  |

### `tblProductBrand`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductBrandId | int | NOT NULL | PK, IDENTITY |
| ProductBrandCode | nvarchar(50) | NULL |  |
| ProductBrandName | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| ActiveInActiveDate | datetime | NULL |  |

### `tblProductCase`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CaseId | int | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| CaseQty | decimal(18,0) | NULL |  |
| PcsPerCase | numeric(18,0) | NULL |  |

### `tblProductCategory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductCategoryId | int | NOT NULL | PK, IDENTITY |
| ProductCategoryCode | nvarchar(50) | NULL |  |
| ProductCategory | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblProductDCDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductId | int | NULL |  |
| ComUnitId | int | NULL |  |
| ProductDCId | int | NOT NULL | PK, IDENTITY |

### `tblProductDiscount`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DiscountId | int | NOT NULL | PK |
| ProductCode | nvarchar(max) | NULL |  |
| CustomerMasterId | int | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| Status | nvarchar(50) | NULL |  |
| ActiveDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblProductGroup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GroupId | int | NOT NULL | PK, IDENTITY |
| GroupName | nvarchar(50) | NULL |  |
| GroupSAPCode | nvarchar(50) | NULL |  |

### `tblProductLine`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductLineID | int | NOT NULL | PK, IDENTITY |
| LineName | nvarchar(max) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblProductQuotedPrice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| QuotedPriceId | int | NOT NULL | PK, IDENTITY |
| ProductId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| QuotedPrice | decimal(18,2) | NULL |  |
| Status | nvarchar(50) | NULL |  |
| ActiveDate | datetime | NULL |  |
| InactiveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | int | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| ActiveInActiveBy | int | NULL |  |

### `tblProductSQ`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductBrandId | int | NOT NULL | PK |
| IngridentsId | int | NULL |  |
| ProductSQName | nvarchar(max) | NULL |  |
| MaxValue | int | NULL |  |
| ProductSQSAPCode | nvarchar(max) | NULL |  |

### `tblProductType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductTypeId | int | NOT NULL | PK, IDENTITY |
| ProductTypeCode | nvarchar(50) | NULL |  |
| ProductTypeName | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| ActiveInActiveDate | datetime | NULL |  |

### `tblProductUpload`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| Description | nvarchar(max) | NULL |  |
| Company | nvarchar(50) | NULL |  |
| PackSize | nvarchar(50) | NULL |  |
| ProductBrand | nvarchar(50) | NULL |  |
| ProType | nvarchar(50) | NULL |  |
| Category | nvarchar(50) | NULL |  |
| Manufacturer | nvarchar(50) | NULL |  |
| StockUOM | nvarchar(50) | NULL |  |
| ProductCase | nvarchar(50) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| MRPPrice | decimal(18,2) | NULL |  |
| CompanyId | nchar(10) | NULL |  |
| PackSizeId | nchar(10) | NULL |  |
| BrandId | nchar(10) | NULL |  |
| TypeId | nchar(10) | NULL |  |
| CategoryId | nchar(10) | NULL |  |
| ManufacturerId | nchar(10) | NULL |  |
| UOMId | nchar(10) | NULL |  |
| CaseId | nchar(10) | NULL |  |

### `tblProductWiseSalesTarget`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductSalesTargetId | int | NOT NULL | PK, IDENTITY |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ProductId | int | NULL |  |
| Month | int | NULL |  |
| Year | int | NULL |  |
| Date | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Amount | decimal(18,2) | NULL |  |

### `tblProgramType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProgramTypeId | int | NOT NULL | PK, IDENTITY |
| ProgramTypeName | nvarchar(50) | NULL |  |
| PrgmTypeCode | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| IsCustomer | bit | NULL |  |
| IsDoctor | bit | NULL |  |
| IsDefault | bit | NULL |  |

### `tblProInvoiceReturnTrack`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ID | int | NOT NULL | PK, IDENTITY |
| ReturnTotalQuantity | decimal(18,0) | NULL |  |
| DCStoreId | int | NULL |  |
| ReturnDate | datetime | NULL |  |
| ReturnExecutionDateTime | datetime | NULL |  |
| InvoiceDetailId | int | NULL |  |
| InvoiceId | int | NULL |  |
| SubDCStoreId | int | NULL |  |

### `tblPromoGroup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PromoGroupId | int | NOT NULL | PK, IDENTITY |
| PromoGroupCode | nvarchar(50) | NULL |  |
| PromoGroupName | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblPromoMIOTagDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PromoMIOTagDetailId | int | NOT NULL | PK, IDENTITY |
| MIOTagMasterId | int | NULL |  |
| MIOId | int | NULL |  |
| EmpInfoId | int | NULL |  |

### `tblPromoMIOTagMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MIOTagId | int | NOT NULL | PK, IDENTITY |
| PromoGroupId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblPromoTransaction`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PromoTransId | int | NOT NULL | PK, IDENTITY |
| TransDate | datetime | NULL |  |
| GWPromoQtyId | int | NULL |  |
| TransQty | decimal(18,0) | NULL |  |

### `tblProType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProTypeId | int | NOT NULL | PK |
| ProTypeName | nvarchar(max) | NULL |  |
| ProTypeSAPCode | nvarchar(max) | NULL |  |

### `tblProviderDropoutIntrigration`

| Column | Type | Nullable | Key |
|---|---|---|---|
| providerIDropoutIntrigrationd | bigint | NOT NULL | PK, IDENTITY |
| programName | nvarchar(50) | NULL |  |
| providerCode | nvarchar(50) | NULL |  |
| providerName | nvarchar(200) | NULL |  |
| mobileNo | nvarchar(30) | NULL |  |
| nid | nvarchar(30) | NULL |  |
| email | nvarchar(255) | NULL |  |
| outlet | nvarchar(200) | NULL |  |
| dropoutReason | nvarchar(500) | NULL |  |
| insertedAt | datetime2 | NOT NULL |  |
| IsApprove | bit | NOT NULL |  |
| IsApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime2 | NULL |  |

### `tblPurpose`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PurposeId | int | NOT NULL | PK, IDENTITY |
| Purpose | nvarchar(50) | NULL |  |
| StockConditionId | int | NULL |  |

### `tblQuotedPriceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| QuotedPriceDetailId | int | NOT NULL | PK, IDENTITY |
| QuotedPriceMasterId | int | NULL |  |
| ProductId | int | NULL |  |
| UnitPrice | decimal(18,3) | NULL |  |
| Vat | decimal(18,3) | NULL |  |
| Note | nvarchar(max) | NULL |  |

### `tblQuotedPriceMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| QuotedPriceMasterId | int | NOT NULL | PK, IDENTITY |
| Description | nvarchar(max) | NULL |  |
| Policy | nvarchar(max) | NULL |  |
| IsCustomerWise | bit | NULL |  |
| CustomerMasterId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| ActiveFromDate | datetime | NULL |  |
| ActiveToDate | datetime | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| ActionStatus | nvarchar(max) | NULL |  |

### `tblReferInstitution`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InstitutionId | int | NOT NULL | PK, IDENTITY |
| InstitutionCode | nvarchar(50) | NULL |  |
| InstitutionName | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblRegion`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RegionId | int | NOT NULL | PK, IDENTITY |
| RegionCode | nvarchar(500) | NULL |  |
| RegionName | nvarchar(500) | NULL |  |
| CompanyId | int | NULL |  |
| Region | nvarchar(max) | NULL |  |
| IsActive | int | NULL |  |
| GroupId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateDate | datetime | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| ActiveOrInactiveBy | nvarchar(50) | NULL |  |
| CodeStr | nvarchar(max) | NULL |  |
| SAP_Code | nvarchar(max) | NULL |  |
| SAP_Name | nvarchar(max) | NULL |  |

### `tblRegion_Log`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Log_RegionId | int | NOT NULL | PK, IDENTITY |
| RegionId | int | NOT NULL |  |
| RegionCode | nvarchar(500) | NULL |  |
| RegionName | nvarchar(500) | NULL |  |
| CompanyId | int | NULL |  |
| Region | nvarchar(max) | NULL |  |
| IsActive | int | NULL |  |
| GroupId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateDate | datetime | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| ActiveOrInactiveBy | nvarchar(50) | NULL |  |
| DelDate | datetime | NULL |  |
| DelBy | nvarchar(50) | NULL |  |

### `tblRejectionInvoiceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RejectionInvoiceDetailId | int | NOT NULL | IDENTITY |
| InvoiceDetailId | int | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalPriceVatAmount | decimal(18,2) | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| InvoiceId | int | NULL |  |
| DCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| PaymentQuantity | decimal(18,0) | NULL |  |
| PaymentBonusQuantity | decimal(18,0) | NULL |  |
| PaymentTotalQuantity | decimal(18,0) | NULL |  |
| PaymentTotalPrice | decimal(18,2) | NULL |  |
| PaymentTotalPriceVatAmount | decimal(18,2) | NULL |  |
| PaymentDiscountPercentage | decimal(18,2) | NULL |  |
| PaymentDiscountAmount | decimal(18,2) | NULL |  |
| PaymentNetAmount | decimal(18,2) | NULL |  |
| PaymentReturnReason | nvarchar(50) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NOT NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(max) | NULL |  |
| Campaign | nvarchar(max) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |
| AdjustmentAmount | decimal(18,2) | NULL |  |

### `tblRejectionInvoiceMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RejectionInvoiceMaster | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| InvoiceNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(max) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| PaymentTpTotal | decimal(18,2) | NULL |  |
| PaymentTpDiscount | decimal(18,2) | NULL |  |
| PaymentTpVat | decimal(18,2) | NULL |  |
| PaymentTpGrandTotal | decimal(18,2) | NULL |  |
| PaymentInvoiceStatus | nvarchar(max) | NULL |  |
| PaymentInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(max) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(max) | NULL |  |
| ProductOffer | nvarchar(max) | NULL |  |
| OldTradePolicy | nvarchar(max) | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(max) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| DisCode | nvarchar(max) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(max) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| DeliveryPersonName | nvarchar(max) | NULL |  |
| DeliveryPersonPhNo | nvarchar(max) | NULL |  |
| Types | nvarchar(max) | NULL |  |
| GreenStarBlueStarID | int | NULL |  |
| AdjustAmount | decimal(18,2) | NULL |  |
| IsAdjustInvoice | bit | NULL |  |
| ReceivableAmount | decimal(18,2) | NULL |  |
| IsSalesTransfer | bit | NULL |  |
| TransferInvoiceDate | datetime | NULL |  |
| UpdateDatetime | datetime | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AdjustInvoiceNo_ReturnInvoiceNo | nvarchar(max) | NULL |  |
| DeliveryManId | int | NULL |  |
| AIT | int | NULL |  |
| DiscountOnPayment | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |
| MIOId | int | NULL |  |
| IsAuto | bit | NULL |  |
| LoadingSummaryStatus | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateBy | nvarchar(max) | NULL |  |
| LoadingSummaryUpdateDate | datetime | NULL |  |
| loadingsummaryFinalStatus | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateBy | nvarchar(max) | NULL |  |
| loadingsummaryFinalStatusUpdateDatetime | datetime | NULL |  |
| PaymentBy | nvarchar(max) | NULL |  |
| PaymentDate | datetime | NULL |  |
| RejectionBy | nvarchar(max) | NULL |  |
| RejectionDate | datetime | NULL |  |

### `tblRejectionLoadSum`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RejectionLoadSumId | int | NOT NULL | PK, IDENTITY |
| InvoiceId | int | NULL |  |
| InvoiceNo | nvarchar(500) | NULL |  |
| Lstatus | nvarchar(500) | NULL |  |
| Updateby | nvarchar(500) | NULL |  |

### `tblRequisition`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReqId | int | NOT NULL | PK |
| ReqNo | nvarchar(max) | NULL |  |
| ReqDate | datetime | NULL |  |
| WarehouseId | int | NULL |  |
| WearhouseName | nvarchar(max) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| Submit | nvarchar(50) | NULL |  |
| SubmitDate | datetime | NULL |  |
| IssueChalanNo | nvarchar(max) | NULL |  |
| IssuChalanDate | datetime | NULL |  |
| TruckNo | nvarchar(max) | NULL |  |
| DriverName | nvarchar(max) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalVAT | decimal(18,2) | NULL |  |
| GrandTotalPrice | decimal(18,2) | NULL |  |
| ReceiveIssue | nvarchar(50) | NULL |  |
| ReceiveIssueDate | datetime | NULL |  |
| CreatePicking | nvarchar(max) | NULL |  |
| PickingNo | nvarchar(max) | NULL |  |
| PickingDate | datetime | NULL |  |
| ManufacId | int | NULL |  |
| EntryBy | nvarchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsFromBatch | bit | NULL |  |

### `tblRequsitionChild`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReqChildId | int | NOT NULL | PK |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| ReqQty | decimal(18,0) | NULL |  |
| ReqId | int | NULL |  |
| IssueQty | decimal(18,0) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| PriceAmount | decimal(18,2) | NULL |  |
| VATAmount | decimal(18,2) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| IsIssue | nvarchar(max) | NULL |  |
| CaseQty | decimal(18,0) | NULL |  |
| MusakVATAmount | decimal(18,2) | NULL |  |
| MusakTotalPrice | decimal(18,2) | NULL |  |
| IsPicking | nvarchar(max) | NULL |  |
| BatchNO | nvarchar(max) | NULL |  |

### `tblRestrictProducts`

| Column | Type | Nullable | Key |
|---|---|---|---|
| GhorShajai3RestrictProductsId | int | NOT NULL | PK, IDENTITY |
| ProductID | int | NULL |  |
| CustYpeID | int | NULL |  |
| ProductName | nvarchar(255) | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |

### `tblReturnAmount`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReturnAmountId | int | NOT NULL | PK, IDENTITY |
| CustomerId | int | NULL |  |
| InvoiceId | int | NULL |  |
| ReturnInvoiceId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |

### `tblReturnInvoice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReturnInvoiceId | int | NOT NULL | PK, IDENTITY |
| ReturnInvoiceNo | nvarchar(max) | NULL |  |
| ReturnInvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(50) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| ProductOffer | nvarchar(50) | NULL |  |
| OldTradePolicy | nvarchar(50) | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(50) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(50) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(50) | NULL |  |
| DeliveryPersonName | nvarchar(50) | NULL |  |
| DeliveryPersonPhNo | nvarchar(50) | NULL |  |
| Types | nvarchar(50) | NULL |  |
| InvoiceId | int | NULL |  |
| SubInvoiceId | int | NULL |  |
| IsSalesReturnWithoutOrder | nvarchar(50) | NULL |  |
| InvoiceNo | nvarchar(max) | NULL |  |
| ISSubdeport | bit | NULL |  |
| MIOId_new | int | NULL |  |
| Terri_Id_new | int | NULL |  |
| MioEmpId_new | int | NULL |  |
| Mio_SapCode_New | nvarchar(max) | NULL |  |
| RegionId_Rtn | int | NULL |  |
| AreaId_Rtn | int | NULL |  |
| InvoiceAdjustmentDate | date | NULL |  |

### `tblReturnInvoiceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReturnInvoiceDetailId | int | NOT NULL | PK |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalPriceVatAmount | decimal(18,2) | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| ReturnInvoiceId | int | NULL |  |
| DCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(500) | NULL |  |
| Campaign | nvarchar(500) | NULL |  |
| InvoiceDetailId | int | NULL |  |
| SubInvoiceDetailId | int | NULL |  |

### `tblReturnReason`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ReturndReasonId | int | NOT NULL |  |
| ReaturnReason | nvarchar(max) | NULL |  |

### `tblRoleType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RoleTypeId | int | NOT NULL | PK, IDENTITY |
| RoleType | nvarchar(max) | NULL |  |
| SAP_RoleTypeCode | nvarchar(max) | NULL |  |
| DisplayName | nvarchar(max) | NULL |  |
| Notes | nvarchar(max) | NULL |  |

### `tblRouteInformationDADetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouteInformationDADetailId | int | NOT NULL | PK, IDENTITY |
| RouteInformationMasterId | int | NULL |  |
| DAId | int | NULL |  |

### `tblRouteInformationMarketDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouteInformationMarketDetailId | int | NOT NULL | PK, IDENTITY |
| RouteInformationMasterId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| Distance | decimal(18,2) | NULL |  |

### `tblRouteInformationMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouteInformationMasterId | int | NOT NULL | PK, IDENTITY |
| DCId | int | NULL |  |
| IsSubDepo | bit | NULL |  |
| RouteName | nvarchar(max) | NULL |  |
| TotalDistance | decimal(18,2) | NULL |  |
| TotalDay | decimal(18,2) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| RouteTypeId | int | NULL |  |
| TAAmount | decimal(18,2) | NULL |  |
| DAAmount | decimal(18,2) | NULL |  |
| RtInactive | bit | NULL |  |

### `tblRouteInformationWeekNameDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouteInformationWeekNameDtlId | int | NOT NULL | PK, IDENTITY |
| RouteInformationMasterId | int | NULL |  |
| WeekNameId | int | NULL |  |

### `tblRouteTypeInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RouteTypeId | int | NOT NULL | PK, IDENTITY |
| RouteTypeName | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |

### `tblRSMInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RSMId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| RegionId | int | NULL |  |
| EmployeeId | int | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| Vacant | nvarchar(50) | NULL |  |
| IsBase | bit | NULL |  |
| DZSMSapCode | nvarchar(50) | NULL |  |

### `tblSalesAssistantDAAmountClaimConfig`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SalesAssistantDAAmountClaimConfigId | int | NOT NULL | PK, IDENTITY |
| RoleName | nvarchar(100) | NOT NULL |  |
| TourTypeId | int | NOT NULL |  |
| DAAmount | decimal(18,2) | NOT NULL |  |
| IsActive | bit | NOT NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NOT NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblSalesConfirmation_appLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SalesConfirmationAppLogId | int | NOT NULL | PK, IDENTITY |
| DaId | int | NOT NULL |  |
| ComUnitId | int | NOT NULL |  |
| RouteId | int | NOT NULL |  |
| InvoiceId | int | NOT NULL |  |
| ApprovalStatus | nvarchar(50) | NOT NULL |  |
| ApproveDate | datetime2 | NULL |  |
| ApproveBy | nvarchar(100) | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |
| DICApprovalStatus | nvarchar(50) | NULL |  |
| DICApproveDate | datetime2 | NULL |  |
| DICApproveBy | nvarchar(100) | NULL |  |

### `tblSalesConfirmation_appLogDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SalesConfirmationAppLogDetailId | int | NOT NULL | PK, IDENTITY |
| SalesConfirmationAppLogId | int | NOT NULL |  |
| InvoiceDetailId | int | NOT NULL |  |
| OrderDetailsId | int | NOT NULL |  |
| DCStoreId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| ProductName | nvarchar(200) | NULL |  |
| StockQty | decimal(18,2) | NOT NULL |  |
| OrderedQty | decimal(18,2) | NOT NULL |  |
| DeliveredQty | decimal(18,2) | NOT NULL |  |
| UnitPrice | decimal(18,4) | NOT NULL |  |
| UnitVat | decimal(18,4) | NOT NULL |  |
| DiscountAmount | decimal(18,4) | NOT NULL |  |
| NetPrice | decimal(18,4) | NOT NULL |  |
| TotalQty | decimal(18,2) | NOT NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |
| InvoiceId | int | NOT NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| DeliveryReason | nvarchar(200) | NULL |  |

### `tblSalesConfirmResponseData`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ResponseId | int | NOT NULL | PK, IDENTITY |
| Code | nvarchar(50) | NULL |  |
| SalesDocDate | date | NULL |  |
| IdocNo | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblSalesReturn_appLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SalesReturnAppLogId | int | NOT NULL | PK, IDENTITY |
| DaId | int | NOT NULL |  |
| ComUnitId | int | NOT NULL |  |
| RouteId | int | NOT NULL |  |
| InvoiceId | int | NOT NULL |  |
| ApprovalStatus | nvarchar(50) | NOT NULL |  |
| ApproveDate | datetime2 | NULL |  |
| ApproveBy | int | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |
| ReturnType | nvarchar(20) | NOT NULL |  |
| DICApprovalStatus | nvarchar(50) | NULL |  |
| DICApproveDate | datetime2 | NULL |  |
| DICApproveBy | nvarchar(100) | NULL |  |

### `tblSalesReturn_appLogDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SalesReturnAppLogDetailId | int | NOT NULL | PK, IDENTITY |
| SalesReturnAppLogId | int | NOT NULL |  |
| InvoiceId | int | NOT NULL |  |
| InvoiceDetailId | int | NOT NULL |  |
| OrderDetailsId | int | NOT NULL |  |
| DCStoreId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NOT NULL |  |
| ProductName | nvarchar(200) | NULL |  |
| StockQty | decimal(18,2) | NOT NULL |  |
| OrderedQty | decimal(18,2) | NOT NULL |  |
| ReturnQty | decimal(18,2) | NOT NULL |  |
| UnitPrice | decimal(18,4) | NOT NULL |  |
| UnitVat | decimal(18,4) | NOT NULL |  |
| DiscountAmount | decimal(18,4) | NOT NULL |  |
| NetPrice | decimal(18,4) | NOT NULL |  |
| TotalQty | decimal(18,2) | NOT NULL |  |
| ReturnStatus | nvarchar(50) | NULL |  |
| ReasonCode | nvarchar(50) | NULL |  |
| ReasonLabel | nvarchar(200) | NULL |  |
| CreatedOn | datetime2 | NOT NULL |  |

### `tblSalesReturnDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailId | int | NOT NULL | PK, IDENTITY |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| TradePrice | decimal(18,2) | NULL |  |
| TotalTradePrice | decimal(18,2) | NULL |  |
| OrderId | int | NULL |  |
| OrderListDetailId | int | NULL |  |
| Status | nvarchar(max) | NULL |  |

### `tblSalesReturnResponseData`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ResponseId | int | NOT NULL | PK, IDENTITY |
| Code | nvarchar(50) | NULL |  |
| SalesDocDate | date | NULL |  |
| IdocNo | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblSalesTransfer`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceNo | nvarchar(max) | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| Custome | nvarchar(max) | NULL |  |

### `tblSampleInvoice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SampleInvoiceId | int | NOT NULL | PK |
| SampleInvoiceNo | nvarchar(max) | NULL |  |
| SampleInvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliverySampleInvoiceStatus | nvarchar(50) | NULL |  |
| DelivarySampleInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| ProductOffer | nvarchar(50) | NULL |  |
| OldTradePolicy | nvarchar(50) | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(50) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(50) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(50) | NULL |  |
| DeliveryPersonName | nvarchar(50) | NULL |  |
| DeliveryPersonPhNo | nvarchar(50) | NULL |  |
| Types | nvarchar(50) | NULL |  |
| GreenStarBlueStarID | int | NULL |  |
| AdjustAmount | decimal(18,2) | NULL |  |
| IsAdjustSampleInvoice | bit | NULL |  |
| ReceivableAmount | decimal(18,2) | NULL |  |
| IsSalesTransfer | bit | NULL |  |
| TransferSampleInvoiceDate | datetime | NULL |  |
| UpdateDatetime | datetime | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| AdjustSampleInvoiceNo_ReturnSampleInvoiceNo | nvarchar(max) | NULL |  |
| DeliveryManId | int | NULL |  |
| AIT | decimal(18,2) | NULL |  |
| DiscountOnPayment | decimal(18,2) | NULL |  |
| IsPosting | bit | NULL |  |

### `tblSampleInvoiceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SampleInvoiceDetailId | int | NOT NULL | PK |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalPriceVatAmount | decimal(18,2) | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| SampleInvoiceId | int | NULL |  |
| DCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(500) | NULL |  |
| Campaign | nvarchar(500) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |

### `tblSampleIssue`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderId | int | NOT NULL | PK, IDENTITY |
| OrderCode | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(500) | NULL |  |
| MIOCode | nvarchar(50) | NULL |  |
| MIOName | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CustomerName | nvarchar(500) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| IsInvoice | bit | NULL |  |
| IsManual | nvarchar(50) | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| RSMId | int | NULL |  |
| ASMId | int | NULL |  |
| MIOId | int | NULL |  |
| DeliveryPersonId | int | NULL |  |
| IsSpecialApproval | bit | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsDirect | bit | NULL |  |
| IsPosting | bit | NULL |  |

### `tblSampleIssueDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderDetailId | int | NOT NULL | PK, IDENTITY |
| ProductId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| TradePrice | decimal(18,2) | NULL |  |
| TotalTradePrice | decimal(18,2) | NULL |  |
| OrderId | int | NULL |  |
| OrderListDetailId | int | NULL |  |
| Status | nvarchar(max) | NULL |  |

### `tblSampleIssueTranscation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CrditAdjustmentId | int | NOT NULL | PK, IDENTITY |
| ComUnitId | int | NULL |  |
| CustomerMasterId | int | NULL |  |
| IssueId | int | NULL |  |
| IssueDetailId | int | NULL |  |
| DCStoreId | int | NULL |  |
| Quantity | decimal(18,2) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `tblSampleStockForDcDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SampleStockForDcDetailsId | nchar(10) | NULL |  |
| SampleStockForDcMasterId | nchar(10) | NULL |  |
| DCStoreId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| BatchNo | nvarchar(50) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| SampleStock | int | NULL |  |

### `tblSampleStockForDcMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SampleStockForDcMasterId | int | NULL |  |
| SampleStockForDcMasterCode | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| Action | nvarchar(50) | NULL |  |
| Date | datetime | NULL |  |
| Status | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblSampleStockForWareHouseDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SampleStockForWHDetailsId | int | NULL |  |
| SampleStockForWHMasterId | int | NULL |  |
| ReceiveId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| BatchNo | nvarchar(50) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| SampleStock | int | NULL |  |

### `tblSampleStockForWareHouseMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SampleStockForWHMasterId | int | NOT NULL | PK |
| SampleStockForWareHouseMstCode | nvarchar(50) | NULL |  |
| WareHouseId | int | NULL |  |
| Action | nvarchar(50) | NULL |  |
| Date | datetime | NULL |  |
| Status | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblSAP_Area_Assign`

| Column | Type | Nullable | Key |
|---|---|---|---|
| area_assign_id | int | NOT NULL | PK, IDENTITY |
| employee_id | int | NULL |  |
| from_area_code | nvarchar(max) | NULL |  |
| to_area_code | nvarchar(max) | NULL |  |
| transfer_effective_date | date | NULL |  |
| action | nvarchar(max) | NULL |  |

### `tblSAP_Employee`

| Column | Type | Nullable | Key |
|---|---|---|---|
| employee_id | int | NOT NULL | PK, IDENTITY |
| employee_code | nvarchar(max) | NULL |  |
| name | nvarchar(max) | NULL |  |
| role | nvarchar(max) | NULL |  |
| joining_date | date | NULL |  |
| mobile_no | nvarchar(max) | NULL |  |
| is_active | bit | NULL |  |
| action | nvarchar(max) | NULL |  |

### `tblSAP_MIOCode`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MIOCode | nvarchar(max) | NULL |  |
| SAP_Code | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |

### `tblSAP_PromoMaterial`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAP_Code | nvarchar(max) | NULL |  |
| GiftProductCode_SMC | nvarchar(max) | NULL |  |
| P_name | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |

### `tblSAP_StockMovementDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockMovementDetailId | int | NOT NULL | PK, IDENTITY |
| StockMovementMasterId | int | NULL |  |
| product_code | nvarchar(max) | NULL |  |
| batch_no | nvarchar(max) | NULL |  |
| quantity | decimal(18,2) | NULL |  |
| unit_price | decimal(18,2) | NULL |  |
| UOM | nvarchar(max) | NULL |  |
| unit_vat | decimal(18,2) | NULL |  |
| net_amount | decimal(18,2) | NULL |  |
| expiry_date | datetime | NULL |  |
| manufacturer_date | datetime | NULL |  |

### `tblSAP_StockMovementMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockMovementMasterId | int | NOT NULL | PK, IDENTITY |
| challan_code | nvarchar(max) | NULL |  |
| challan_date | datetime | NULL |  |
| is_from_wharehouse | bit | NULL |  |
| from_plant_code | nvarchar(max) | NULL |  |
| to_plant_code | nvarchar(max) | NULL |  |
| truck_no | nvarchar(max) | NULL |  |
| driver_name | nvarchar(max) | NULL |  |
| entryDate | datetime | NULL |  |

### `tblSAP_StoInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SapStoInfoId | int | NOT NULL | PK, IDENTITY |
| OutboundDeliveryID | nvarchar(max) | NULL |  |
| OBDDate | date | NULL |  |
| OBDTime | nvarchar(max) | NULL |  |
| PO_NUMBER | nvarchar(max) | NULL |  |
| ItemLineNo | nvarchar(max) | NULL |  |
| ItemCode | nvarchar(max) | NULL |  |
| Batch | nvarchar(max) | NULL |  |
| ExpDate | date | NULL |  |
| Unit | nvarchar(max) | NULL |  |
| Quantity | nvarchar(max) | NULL |  |
| IssuingOffice | nvarchar(max) | NULL |  |
| ReceivingPlant | nvarchar(max) | NULL |  |
| PO_ITEM | nvarchar(max) | NULL |  |
| StorageLoc | nvarchar(max) | NULL |  |

### `tblSAP_Territory_Assign`

| Column | Type | Nullable | Key |
|---|---|---|---|
| territory_assign_id | int | NOT NULL | PK, IDENTITY |
| employee_id | int | NULL |  |
| from_territory_code | nvarchar(max) | NULL |  |
| to_territory_code | nvarchar(max) | NULL |  |
| transfer_effective_date | date | NULL |  |
| action | nvarchar(max) | NULL |  |

### `tblSAP_Zone_Assign`

| Column | Type | Nullable | Key |
|---|---|---|---|
| zone_assign_id | int | NOT NULL | PK, IDENTITY |
| employee_id | int | NULL |  |
| from_zone_code | nvarchar(max) | NULL |  |
| to_zone_code | nvarchar(max) | NULL |  |
| transfer_effective_date | date | NULL |  |
| action | nvarchar(max) | NULL |  |

### `tblSAPCode`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAPCodeId | int | NOT NULL | PK, IDENTITY |
| SAPCode | nvarchar(500) | NULL |  |
| ePharmaSystemCode | nvarchar(500) | NULL |  |
| Type | nvarchar(500) | NULL |  |

### `tblSAPSTODetail_SAP`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAPSTODetailId | int | NOT NULL | PK, IDENTITY |
| SAPSTOMasterId | int | NULL |  |
| ObdItemNo | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| Batch | nvarchar(max) | NULL |  |
| ExpDate | datetime | NULL |  |
| UoM | nvarchar(max) | NULL |  |
| Quantity | nvarchar(max) | NULL |  |
| PoItem | nvarchar(max) | NULL |  |
| StorageLoc | nvarchar(max) | NULL |  |
| MfgDate | datetime | NULL |  |

### `tblSAPSTOMaster_SAP`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SAPSTOMasterId | int | NOT NULL | PK, IDENTITY |
| ObdDeliveryID | nvarchar(max) | NULL |  |
| OBDDate | datetime | NULL |  |
| OBDTime | nvarchar(max) | NULL |  |
| IssueingOffice | nvarchar(max) | NULL |  |
| ReceivingPlant | nvarchar(max) | NULL |  |
| PoNumber | nvarchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblShippingCartonSize`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ShippingCartonSizeId | int | NOT NULL | PK, IDENTITY |
| ShippingCartonSizeName | nvarchar(max) | NULL |  |
| ShippingCartonCode | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| ActiveInactiveDate | datetime | NULL |  |

### `tblSlaveInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SlaveId | int | NOT NULL | PK, IDENTITY |
| CompanyId | int | NULL |  |
| MaxAmmount | decimal(18,2) | NULL |  |
| MinAmmount | decimal(18,2) | NULL |  |
| DisParcentage | int | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| InActiveBy | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblsmc2019CustomerUpdate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| CustomerCode | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| MIOCODE | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| FECOde | nvarchar(max) | NULL |  |
| FENAme | nvarchar(max) | NULL |  |
| DzsmCode | nvarchar(max) | NULL |  |
| DzsmName | nvarchar(max) | NULL |  |
| MArketCode | nvarchar(max) | NULL |  |
| MArketName | nvarchar(max) | NULL |  |
| ProgramType | nvarchar(max) | NULL |  |

### `tblSMCType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SMCTypeId | int | NOT NULL | PK, IDENTITY |
| SMCType | nvarchar(max) | NULL |  |
| forCustomer | bit | NULL |  |
| forDotor | bit | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsDefault | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| SMCTypeCode | nvarchar(max) | NULL |  |

### `tblStationType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StationTypeId | int | NOT NULL | PK, IDENTITY |
| StationTypeName | nvarchar(50) | NULL |  |
| StationCode | nvarchar(50) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |
| StartTime | time | NULL |  |
| EndTime | time | NULL |  |

### `tblStockAdjust`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Comid | int | NULL |  |
| Stock | int | NULL |  |
| PCode | nvarchar(max) | NULL |  |

### `tblStockBatchUpdateTracking`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BatchUpdateId | int | NOT NULL | PK, IDENTITY |
| DcStoreId | int | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| MFGDate | datetime | NULL |  |
| EXPDate | datetime | NULL |  |
| UpdateBy | nvarchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblStockClosingStockCompare`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ProductCode | nvarchar(max) | NULL |  |
| Barisal | decimal(18,0) | NULL |  |

### `tblStockCondition`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockConId | int | NOT NULL | PK |
| StockCondition | nvarchar(50) | NULL |  |

### `tblStockConditionFreeze`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockConditionFreezeID | int | NOT NULL | PK |
| ReceiveId | int | NULL |  |
| DCStoreId | int | NULL |  |
| ManufacId | int | NULL |  |
| FreezeQty | decimal(18,0) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblStockConditionPermission`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockCondintionID | int | NOT NULL | PK, IDENTITY |
| UserId | int | NULL |  |
| CompanyUnitId | int | NULL |  |
| StockConId | int | NULL |  |
| Permission | bit | NULL |  |

### `tblStockInTransfar`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockInTransfarId | int | NOT NULL | PK |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(50) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| PickingQty | decimal(18,0) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| PriceAmount | decimal(18,2) | NULL |  |
| VATAmount | decimal(18,2) | NULL |  |
| TotalPriceAmount | decimal(18,2) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| IsTransfared | nvarchar(50) | NULL |  |
| IsIssue | nvarchar(50) | NULL |  |
| ReceiveId | int | NULL |  |
| MfgDate | datetime | NULL |  |
| CompanyId | int | NULL |  |

### `tblStockUOM`

| Column | Type | Nullable | Key |
|---|---|---|---|
| StockUOMId | int | NOT NULL | PK |
| StockUOMName | nvarchar(max) | NULL |  |
| UOMSAPCode | nvarchar(max) | NULL |  |

### `tblSubDCStore_OpeningBalance`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCOpeningBalanceId | int | NOT NULL | PK, IDENTITY |
| DCOpeningBalanceDate | datetime | NOT NULL |  |
| SubDepotId | int | NOT NULL |  |
| DCStoreId | int | NOT NULL |  |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| ChalanDate | datetime | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | datetime | NULL |  |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| StockInTransfarId | int | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| SChalanDetailsId | int | NULL |  |
| MfgDate | datetime | NULL |  |
| Note | nvarchar(max) | NULL |  |
| comID | int | NULL |  |

### `tblSubDepot`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubDepotId | int | NOT NULL | PK, IDENTITY |
| ComUnitId | int | NOT NULL |  |
| SubDepotCode | nvarchar(50) | NULL |  |
| SubDepotName | nvarchar(50) | NULL |  |
| Address | nvarchar(500) | NULL |  |
| PhoneNo | nvarchar(50) | NULL |  |
| MobileNo | nvarchar(50) | NULL |  |
| FaxNo | nvarchar(50) | NULL |  |
| ShortName | nvarchar(50) | NULL |  |

### `tblSubDepotChalanDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SChalanDetailsId | int | NOT NULL | PK |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BatchNo | nvarchar(50) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| Value | decimal(18,2) | NULL |  |
| Vat | decimal(18,2) | NULL |  |
| ValueWVat | decimal(18,2) | NULL |  |
| SChalanId | int | NOT NULL |  |
| DCStoreId | int | NULL |  |

### `tblSubDepotChalanInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SChalanId | int | NOT NULL | PK |
| ChalanDate | date | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| TrackNo | nvarchar(max) | NULL |  |
| DriverName | nvarchar(max) | NULL |  |
| FromComUnitCode | nvarchar(max) | NULL |  |
| FromComUnitName | nvarchar(max) | NULL |  |
| FromComUnitAddress | nvarchar(max) | NULL |  |
| SubDepotCode | nvarchar(max) | NULL |  |
| SubDepotName | nvarchar(max) | NULL |  |
| SubDepotAddress | nvarchar(max) | NULL |  |
| TotalValue | decimal(18,2) | NULL |  |
| TotalVat | decimal(18,2) | NULL |  |
| GrandTotal | decimal(18,2) | NULL |  |
| ManufacId | int | NULL |  |
| IsDeliver | nvarchar(50) | NULL |  |
| ComUnitId2 | int | NULL |  |

### `tblSubDepotChalanRetuenDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SChalanDetailsId | int | NOT NULL | PK |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BatchNo | nvarchar(50) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| Value | decimal(18,2) | NULL |  |
| Vat | decimal(18,2) | NULL |  |
| ValueWVat | decimal(18,2) | NULL |  |
| SChalanId | int | NOT NULL |  |
| DCStoreId | int | NULL |  |

### `tblSubDepotChalanReturnInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SChalanId | int | NOT NULL | PK |
| ChalanDate | date | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| TrackNo | nvarchar(max) | NULL |  |
| DriverName | nvarchar(max) | NULL |  |
| FromComUnitCode | nvarchar(max) | NULL |  |
| FromComUnitName | nvarchar(max) | NULL |  |
| FromComUnitAddress | nvarchar(max) | NULL |  |
| SubDepotCode | nvarchar(max) | NULL |  |
| SubDepotName | nvarchar(max) | NULL |  |
| SubDepotAddress | nvarchar(max) | NULL |  |
| TotalValue | decimal(18,2) | NULL |  |
| TotalVat | decimal(18,2) | NULL |  |
| GrandTotal | decimal(18,2) | NULL |  |
| ManufacId | int | NULL |  |
| IsDeliver | nvarchar(50) | NULL |  |
| ComUnitId2 | int | NULL |  |

### `tblSubDepotStockOutDetails`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubDcStockOutDetailsId | int | NOT NULL | PK |
| SubDcStockOutMasterId | int | NULL |  |
| SubDCStoreId | int | NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(50) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| StockOutQty | int | NULL |  |

### `tblSubDepotStockOutMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubDcStockOutMasterId | int | NOT NULL | PK |
| SubDcStockOutMasterCode | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| InvoiceId | int | NULL |  |
| StockOutDate | datetime | NULL |  |
| Reason | nvarchar(max) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| Status | nvarchar(50) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |

### `tblSubDepotStore`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubDCStoreId | int | NOT NULL | PK |
| SubDepotId | int | NOT NULL |  |
| DCStoreId | int | NULL |  |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| ChalanDate | datetime | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | datetime | NULL |  |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| StockInTransfarId | int | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| SChalanDetailsId | int | NULL |  |
| MfgDate | datetime | NULL |  |

### `tblSubDepotStoreFreeze`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SDStoreFreezeId | int | NOT NULL | PK |
| SubDCStoreId | int | NULL |  |
| InvoiceDetailId | int | NULL |  |
| StorageLocation | nvarchar(max) | NULL |  |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ChalanNo | nvarchar(max) | NULL |  |
| ChalanDate | datetime | NULL |  |
| SubDepotId | int | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | datetime | NULL |  |
| ReqId | int | NULL |  |
| ReqChildId | int | NULL |  |
| StockInTransfarId | int | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| ReceiveId | int | NULL |  |
| StockConditionFreezeID | int | NULL |  |
| SChalanDetailsId | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |
| ReturnInvoiceDetailId | int | NULL |  |

### `tblSubDepotStoreTransaction`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DCStoreTransId | int | NOT NULL | PK, IDENTITY |
| DCStoreId | int | NULL |  |
| Date | datetime | NULL |  |
| Id | int | NULL |  |
| Type | nvarchar(50) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |

### `tblSubInvoiceDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceDetailId | int | NOT NULL | PK |
| ProductCode | nvarchar(max) | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| ReceiveDate | datetime | NULL |  |
| ExpDate | datetime | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| UnitVatAmount | decimal(18,2) | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| BonusQuantity | decimal(18,0) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| TotalPrice | decimal(18,2) | NULL |  |
| TotalPriceVatAmount | decimal(18,2) | NULL |  |
| DiscountPercentage | decimal(18,2) | NULL |  |
| DiscountAmount | decimal(18,2) | NULL |  |
| NetAmount | decimal(18,2) | NULL |  |
| InvoiceId | int | NULL |  |
| SubDCStoreId | int | NULL |  |
| DeliveryQuantity | decimal(18,0) | NULL |  |
| DeliveryBonusQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalQuantity | decimal(18,0) | NULL |  |
| DeliveryTotalPrice | decimal(18,2) | NULL |  |
| DeliveryTotalPriceVatAmount | decimal(18,2) | NULL |  |
| DeliveryDiscountPercentage | decimal(18,2) | NULL |  |
| DeliveryDiscountAmount | decimal(18,2) | NULL |  |
| DeliveryNetAmount | decimal(18,2) | NULL |  |
| DeliveryStatus | nvarchar(50) | NULL |  |
| OrderDetailsId | int | NULL |  |
| SpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| ReturnReason | nvarchar(500) | NULL |  |
| Campaign | nvarchar(500) | NULL |  |
| ISGiftProduct | bit | NULL |  |
| CampaignType | nvarchar(max) | NULL |  |
| IsCampaignProduct | bit | NULL |  |

### `tblSubInvoiceMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| InvoiceId | int | NOT NULL | PK |
| InvoiceNo | nvarchar(max) | NULL |  |
| InvoiceDate | datetime | NULL |  |
| OrderId | int | NULL |  |
| OrderNo | nvarchar(max) | NULL |  |
| OrderDate | datetime | NULL |  |
| CustomerMasterId | int | NULL |  |
| ComUnitId | int | NULL |  |
| MiaId | int | NULL |  |
| PaymentTypeId | int | NULL |  |
| TpTotal | decimal(18,2) | NULL |  |
| TpDiscount | decimal(18,2) | NULL |  |
| TpVat | decimal(18,2) | NULL |  |
| TpGrandTotal | decimal(18,2) | NULL |  |
| UserId | int | NULL |  |
| DeliveryTpTotal | decimal(18,2) | NULL |  |
| DeliveryTpDiscount | decimal(18,2) | NULL |  |
| DeliveryTpVat | decimal(18,2) | NULL |  |
| DeliveryTpGrandTotal | decimal(18,2) | NULL |  |
| DeliveryInvoiceStatus | nvarchar(50) | NULL |  |
| DelivaryInvoiceNo | nvarchar(max) | NULL |  |
| CreateBy | nvarchar(50) | NULL |  |
| CreateDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| TotalSpecialAmount | decimal(18,2) | NULL |  |
| DelivarySpecialAmount | decimal(18,2) | NULL |  |
| PaymentAmount | decimal(18,2) | NULL |  |
| PaymentStatus | nvarchar(50) | NULL |  |
| ProductOffer | nvarchar(50) | NULL |  |
| OldTradePolicy | nvarchar(50) | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| FixedCustomer | bit | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(50) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(50) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(50) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(50) | NULL |  |
| DeliveryPersonName | nvarchar(50) | NULL |  |
| DeliveryPersonPhNo | nvarchar(50) | NULL |  |
| SubDepotId | int | NULL |  |
| UpdateDatetime | datetime | NULL |  |
| CampaignName | nvarchar(max) | NULL |  |
| OrderSenderType | nvarchar(max) | NULL |  |
| OrderSenderCode | nvarchar(max) | NULL |  |
| OrderSenderName | nvarchar(max) | NULL |  |
| CustomerType | nvarchar(max) | NULL |  |
| ProgramType | nvarchar(max) | NULL |  |

### `tblSubInvoiceMasterBatch`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BatchId | int | NOT NULL | PK, IDENTITY |
| BatchNo | nvarchar(max) | NULL |  |
| Date | datetime | NULL |  |
| InvoiceId | int | NULL |  |

### `tblSubmitButton`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SubmitButtonId | int | NOT NULL | PK, IDENTITY |
| LinkText | nvarchar(50) | NULL |  |
| btnVisible | bit | NULL |  |

### `tblSubTerritory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TerritoryId | int | NOT NULL |  |
| SubTerritoryName | nvarchar(500) | NULL |  |
| SubTerritoryCode | nvarchar(500) | NULL |  |
| IsActive | bit | NULL |  |
| SubTerritoryId | int | NOT NULL | PK, IDENTITY |
| SubTerritoryShortName | nvarchar(50) | NULL |  |
| Description | nvarchar(500) | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| ActiveInactiveBy | int | NULL |  |

### `tblSupplierInformation`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SupplierId | int | NOT NULL | PK, IDENTITY |
| SupplierCode | nvarchar(50) | NULL |  |
| SupplierName | nvarchar(max) | NULL |  |
| SupplierAddress | nvarchar(max) | NULL |  |
| ContactNo | nvarchar(50) | NULL |  |
| Entryby | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| Updateby | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblSynchronizationInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SynchronizationInfoId | int | NOT NULL | PK, IDENTITY |
| EmpInfoId | int | NULL |  |
| SynchronizationDate | datetime | NULL |  |

### `tblTADAApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TADAApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |

### `tbltagfakemarkId`

| Column | Type | Nullable | Key |
|---|---|---|---|
| tagfakemarkId | int | NOT NULL | PK, IDENTITY |
| subId | int | NULL |  |
| SubCode | nvarchar(50) | NULL |  |
| MaktCode | nvarchar(50) | NULL |  |
| IsDone | bit | NULL |  |

### `tblTargeExcelUpload`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TargeExcelUploadId | int | NOT NULL | IDENTITY |

### `TblTargeExcelUploadNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Territory | nvarchar(100) | NULL |  |
| EmployeeName | nvarchar(200) | NULL |  |
| Designation | nvarchar(100) | NULL |  |
| BaseHQ | nvarchar(100) | NULL |  |
| TargetMonth | int | NULL |  |
| TargetYear | int | NULL |  |
| AmountValue | decimal(18,2) | NULL |  |
| Id | int | NOT NULL | PK, IDENTITY |

### `tblTemp`

| Column | Type | Nullable | Key |
|---|---|---|---|
| id | int | NOT NULL | PK, IDENTITY |
| RegionCode | nvarchar(max) | NULL |  |
| RegionName | nvarchar(max) | NULL |  |
| SalesCenterCode | nvarchar(max) | NULL |  |
| SalesCenterName | nvarchar(max) | NULL |  |
| DistrictCode | nvarchar(max) | NULL |  |
| DistrictName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(max) | NULL |  |
| AreaName | nvarchar(max) | NULL |  |
| MioCode | nvarchar(max) | NULL |  |
| MioName | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(max) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |

### `tblTemp2`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BRANCH | nvarchar(max) | NULL |  |
| BRANCH DES. | nvarchar(max) | NULL |  |
| Customer ID | nvarchar(max) | NULL |  |
| CUSTOMER NAME | nvarchar(max) | NULL |  |
| MIO-Code | nvarchar(max) | NULL |  |
| Changed MIO Code | nvarchar(max) | NULL |  |
| MIO Name | nvarchar(max) | NULL |  |
| Changed MIO Name | nvarchar(max) | NULL |  |
| Territory Code | nvarchar(max) | NULL |  |
| Changed TR Code | nvarchar(max) | NULL |  |

### `tblTemp3`

| Column | Type | Nullable | Key |
|---|---|---|---|
| BRANCH | nvarchar(max) | NULL |  |
| BRANCH DES. | nvarchar(max) | NULL |  |
| Customer ID | nvarchar(max) | NULL |  |
| CUSTOMER NAME | nvarchar(max) | NULL |  |
| MIO-Code | nvarchar(max) | NULL |  |
| Changed MIO Code | nvarchar(max) | NULL |  |
| MIO Name | nvarchar(max) | NULL |  |
| Changed MIO Name | nvarchar(max) | NULL |  |
| Territory Code | nvarchar(max) | NULL |  |
| Changed TR Code | nvarchar(max) | NULL |  |

### `tblTempCodeName`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Code | nvarchar(max) | NULL |  |

### `tbltempCustMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| tempCustomerMasterId | int | NOT NULL | PK, IDENTITY |
| CustomerCode | nvarchar(50) | NOT NULL |  |
| CustomerName | nvarchar(max) | NOT NULL |  |
| Address | nvarchar(max) | NULL |  |
| CellNo | nvarchar(max) | NULL |  |
| Addrees2 | nvarchar(max) | NULL |  |
| City | nvarchar(max) | NULL |  |
| ConPerson | nvarchar(max) | NULL |  |
| MarketCode | nvarchar(50) | NULL |  |
| MarketName | nvarchar(max) | NULL |  |
| MIACode | nvarchar(50) | NULL |  |
| MIAName | nvarchar(max) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| DisCode | nvarchar(50) | NULL |  |
| FEName | nvarchar(max) | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(max) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| DZSMName | nvarchar(max) | NULL |  |
| TermOfPayment | nvarchar(50) | NULL |  |
| FixedCustomer | bit | NULL |  |
| AddtoMainCustomer | bit | NULL |  |
| importDate | datetime | NULL |  |
| BizCusApiDetailsId | int | NULL |  |

### `tblTempCustomer`

| Column | Type | Nullable | Key |
|---|---|---|---|
| id | int | NOT NULL | PK |
| CusId | nvarchar(50) | NULL |  |
| CustomerName | nvarchar(500) | NULL |  |

### `tblTempSalesReturnOrder`

| Column | Type | Nullable | Key |
|---|---|---|---|
| OrderId | int | NOT NULL | PK, IDENTITY |
| OrderCode | nvarchar(50) | NULL |  |
| ComUnitId | int | NULL |  |
| ComUnitCode | nvarchar(50) | NULL |  |
| ComUnitName | nvarchar(50) | NULL |  |
| MIOCode | nvarchar(50) | NULL |  |
| MIOName | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| CustomerCode | nvarchar(50) | NULL |  |
| CustomerName | nvarchar(50) | NULL |  |
| GrossValue | decimal(18,2) | NULL |  |
| SubmissionDate | datetime | NULL |  |
| IsInvoice | bit | NULL |  |
| IsManual | nvarchar(50) | NULL |  |
| TerritoryCode | nvarchar(50) | NULL |  |

### `tblTerritoeyWisePersonUpdate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TerritoryCode | nvarchar(max) | NULL |  |
| MIOCode | nvarchar(max) | NULL |  |
| MIOName | nvarchar(max) | NULL |  |
| DZsmCode | nvarchar(max) | NULL |  |
| DzsmName | nvarchar(max) | NULL |  |
| FeCode | nvarchar(max) | NULL |  |
| FeName | nvarchar(max) | NULL |  |

### `tblTerritory`

| Column | Type | Nullable | Key |
|---|---|---|---|
| AreaId | int | NULL |  |
| TerritoryName | nvarchar(500) | NULL |  |
| TerritoryCode | nvarchar(500) | NULL |  |
| TerShortName | nvarchar(50) | NULL |  |
| Description | nvarchar(500) | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| IsActive | bit | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| AcOrInAcDate | datetime | NULL |  |
| ActiveInactiveBy | int | NULL |  |
| CodeStr | nvarchar(500) | NULL |  |
| TerritoryId | int | NOT NULL | PK, IDENTITY |
| SAP_Code | nvarchar(500) | NULL |  |
| SAP_Name | nvarchar(500) | NULL |  |

### `tblTerritoryDataMigration`

| Column | Type | Nullable | Key |
|---|---|---|---|
| EmpCode | nvarchar(max) | NULL |  |
| TerritoryCode | nvarchar(max) | NULL |  |
| EmpName | nvarchar(max) | NULL |  |
| Designation | nvarchar(max) | NULL |  |
| BaseHQ | nvarchar(max) | NULL |  |
| Value | nvarchar(max) | NULL |  |
| MonthName | varchar(max) | NULL |  |
| EmpId | int | NULL |  |
| FYId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |
| YearValue | varchar(max) | NULL |  |
| ZoneId_tr | int | NULL |  |
| ZoneCode_tr | varchar(max) | NULL |  |
| AreaId_tr | int | NULL |  |
| AreaIdCode_tr | varchar(max) | NULL |  |
| EntryBy | varchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | varchar(max) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblTerritoryWiseTargetSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TerritoryWTSetupId | int | NOT NULL | PK, IDENTITY |
| Year | nvarchar(50) | NULL |  |
| Month | nvarchar(50) | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| TargetAmount | decimal(18,2) | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblThanaDataUpdate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| MarketCode | nvarchar(max) | NULL |  |
| Division | nvarchar(max) | NULL |  |
| District | nvarchar(max) | NULL |  |
| Thana | nvarchar(max) | NULL |  |
| SL | int | NOT NULL | PK, IDENTITY |
| thanaID | int | NULL |  |

### `tblTherapeuticGroup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TherapeuticGroupId | int | NOT NULL | PK, IDENTITY |
| TherapeuticGroupCode | nvarchar(50) | NULL |  |
| TherapeuticGroupName | nvarchar(50) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblTopSheetGenReport`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TopSheetGenReportId | int | NOT NULL | PK, IDENTITY |
| TopSheetGenCode | nvarchar(500) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| DeliveryMan | nvarchar(500) | NULL |  |

### `tblTourPlanApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPlanApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblTourPlanApprovalVoidLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPlanApprovalVoidId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblTourPlanInfoDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| TourPlanId | bigint | NOT NULL |  |
| SMId | bigint | NULL |  |
| CustomerMasterId | bigint | NULL |  |
| ShiftId | int | NULL |  |
| TourTypeId | int | NULL |  |
| TPId | bigint | NOT NULL |  |
| Comment | nvarchar(1000) | NULL |  |
| TourPlanDate | date | NOT NULL |  |
| EmpInfoId | bigint | NULL |  |
| IsMarketWise | bit | NULL |  |
| IsApproved | bit | NULL |  |
| CreatedBy | nvarchar(50) | NULL |  |
| CreatedDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| TPMaster | bigint | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| GroupName | nvarchar(100) | NULL |  |
| RegionName | nvarchar(100) | NULL |  |
| AreaName | nvarchar(100) | NULL |  |
| TerritoryName | nvarchar(100) | NULL |  |
| SubTerritoryName | nvarchar(100) | NULL |  |
| MarketName | nvarchar(100) | NULL |  |
| GroupCode_TP | nvarchar(20) | NULL |  |
| RegionCode_TP | nvarchar(20) | NULL |  |
| AreaCode_TP | nvarchar(20) | NULL |  |
| TerritoryCode_TP | nvarchar(20) | NULL |  |
| SubTerritoryCode_TP | nvarchar(20) | NULL |  |
| MarketCode_TP | nvarchar(20) | NULL |  |
| SerialNo | int | NULL |  |
| IsMorning | bit | NULL |  |
| IsEvening | bit | NULL |  |
| IsStartTime | bit | NULL |  |
| Starttime | nvarchar(10) | NULL |  |
| IsEndtime | bit | NULL |  |
| Endtime | nvarchar(10) | NULL |  |
| VisitedWithEmpInfoId | bigint | NULL |  |
| GroupIdEnd | int | NULL |  |
| RegionIdEnd | int | NULL |  |
| AreaIdEnd | int | NULL |  |
| TerritoryIdEnd | int | NULL |  |
| SubTerritoryIdEnd | int | NULL |  |
| MarketIdEnd | int | NULL |  |
| GroupNameEnd | nvarchar(100) | NULL |  |
| RegionNameEnd | nvarchar(100) | NULL |  |
| AreaNameEnd | nvarchar(100) | NULL |  |
| TerritoryNameEnd | nvarchar(100) | NULL |  |
| SubTerritoryNameEnd | nvarchar(100) | NULL |  |
| MarketNameEnd | nvarchar(100) | NULL |  |
| GroupCode_TPEnd | nvarchar(20) | NULL |  |
| RegionCode_TPEnd | nvarchar(20) | NULL |  |
| AreaCode_TPEND | nvarchar(20) | NULL |  |
| TerritoryCode_TPEND | nvarchar(20) | NULL |  |
| SubTerritoryCode_TPEND | nvarchar(20) | NULL |  |
| MarketCode_TPEND | nvarchar(20) | NULL |  |
| IsMarketVisit | bit | NULL |  |
| IsOtherVisit | bit | NULL |  |
| OtherMarketNameVisited | nvarchar(200) | NULL |  |
| Objective | nvarchar(1000) | NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tblTourPlanMasterDeleteArchive`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ArchiveId | bigint | NOT NULL | PK, IDENTITY |
| TPMaster | bigint | NOT NULL |  |
| MonthValue | int | NOT NULL |  |
| YearValue | int | NOT NULL |  |
| EmpInfoId | bigint | NULL |  |
| IsFinalSubmit | bit | NULL |  |
| ApprovalStatus | nvarchar(20) | NULL |  |
| ApprovedBy | nvarchar(50) | NULL |  |
| ApprovedDate | datetime | NULL |  |
| FinalSubmitRemarks | nvarchar(500) | NULL |  |
| ApprovalRemarks | nvarchar(500) | NULL |  |
| ArchiveDate | datetime | NOT NULL |  |

### `tblTourPlanShiftInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPlanShiftInfoId | int | NOT NULL | PK, IDENTITY |
| StartTime | time | NULL |  |
| EndTime | time | NULL |  |
| ShiftInfo | nvarchar(50) | NULL |  |
| S_StartTime | nvarchar(50) | NULL |  |
| S_EndTime | nvarchar(50) | NULL |  |

### `tblTourPurposeOtherSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPurposeOtherSetupId | int | NOT NULL | PK, IDENTITY |
| VisitTypeId | int | NULL |  |
| TourPurposeId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |

### `tblTourPurposeOtherSetupDtl`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPurposeOtherSetupDtlId | int | NOT NULL | PK, IDENTITY |
| TourPurposeOtherSetupId | int | NULL |  |
| RoleName | nvarchar(50) | NULL |  |
| TerritoryId | int | NULL |  |
| AreaId | int | NULL |  |
| RegionId | int | NULL |  |
| GroupId | int | NULL |  |
| TourTypeId | int | NULL |  |

### `tblTourSetupEmployee`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourSetupEmployeeId | int | NOT NULL | PK, IDENTITY |
| IsRoleWise | bit | NULL |  |
| IsEmployeeWise | bit | NULL |  |
| EmpInfoId | int | NULL |  |
| StationTypeId | int | NULL |  |
| CountNo | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| RoleTypeId | int | NULL |  |

### `tblTPCustomerDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TPCustomerDetailId | int | NOT NULL | PK, IDENTITY |
| CustomerMasterId | int | NULL |  |
| TourPlanId | int | NULL |  |

### `tblTPMarketDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TPMarketDetailId | int | NOT NULL | PK, IDENTITY |
| MarketId | int | NULL |  |
| TourPlanId | int | NULL |  |

### `tblTradePolicy`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TradePolicyId | int | NOT NULL | PK |
| ManufacId | int | NULL |  |
| MinAmount | decimal(18,2) | NULL |  |
| MaxAmount | decimal(18,2) | NULL |  |
| DiscountPerc | decimal(18,2) | NULL |  |

### `tblTradePolicyNew`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TradePolicyId | int | NOT NULL | PK |
| ManufacId | int | NULL |  |
| MinAmount | decimal(18,2) | NULL |  |
| MaxAmount | decimal(18,2) | NULL |  |
| DiscountPerc | decimal(18,2) | NULL |  |
| PaymentType | nvarchar(max) | NULL |  |

### `tblTradePolicyNew2`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TradePolicyId | int | NOT NULL | PK |
| ManufacId | int | NULL |  |
| MinAmount | decimal(18,2) | NULL |  |
| MaxAmount | decimal(18,2) | NULL |  |
| DiscountPerc | decimal(18,2) | NULL |  |
| PaymentType | nvarchar(max) | NULL |  |
| CustomerType | int | NULL |  |

### `tblTraining_Employee`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Training_Emp_Id | int | NOT NULL | PK, IDENTITY |
| EmployeeId | int | NULL |  |
| IsAppCheck | bit | NULL |  |
| MasterId | int | NULL |  |
| Server_SeenDate | datetime | NULL |  |
| Apps_SeenDate | datetime | NULL |  |

### `tblTrainingUserRoleDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TrainingUserRoleDetailId | int | NOT NULL | PK, IDENTITY |
| TrainningId | int | NULL |  |
| UserRoleID | int | NULL |  |

### `tblTrainning`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TrainningId | int | NOT NULL | PK, IDENTITY |
| Title | nvarchar(max) | NULL |  |
| Description | nvarchar(max) | NULL |  |
| TrainningMeterial | nvarchar(max) | NULL |  |
| FromDate | datetime | NULL |  |
| ToDate | datetime | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsActive | bit | NULL |  |

### `tblUnitPrice`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UnitPriceId | int | NOT NULL | PK |
| ProductId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| PackSize | nvarchar(500) | NULL |  |
| CostPrice | decimal(18,3) | NULL |  |
| UnitPrice | decimal(18,3) | NULL |  |
| VATPercentage | decimal(18,3) | NULL |  |
| VATAmountPerUnit | decimal(18,3) | NULL |  |
| MusakVATPercentage | decimal(18,3) | NULL |  |
| MusakVATAmountPerUnit | decimal(18,3) | NULL |  |
| TPVat | decimal(18,3) | NULL |  |
| MusakVat | decimal(18,3) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| MRPPrice | decimal(18,3) | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |

### `tblUnitPrice_Old`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UnitPriceId | int | NOT NULL | PK |
| ProductId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| PackSize | nvarchar(500) | NULL |  |
| CostPrice | decimal(18,3) | NULL |  |
| UnitPrice | decimal(18,3) | NULL |  |
| VATPercentage | decimal(18,3) | NULL |  |
| VATAmountPerUnit | decimal(18,3) | NULL |  |
| MusakVATPercentage | decimal(18,3) | NULL |  |
| MusakVATAmountPerUnit | decimal(18,3) | NULL |  |
| TPVat | decimal(18,3) | NULL |  |
| MusakVat | decimal(18,3) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NULL |  |
| CompanyId | int | NULL |  |
| MRPPrice | decimal(18,3) | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |

### `tblUnitPriceUpdate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UnitPriceUpdateId | int | NOT NULL |  |
| UnitPriceId | int | NOT NULL |  |
| ProductId | int | NOT NULL |  |
| ProductCode | nvarchar(50) | NULL |  |
| ProductName | nvarchar(50) | NULL |  |
| PackSize | nvarchar(50) | NULL |  |
| CostPrice | decimal(18,2) | NULL |  |
| UnitPrice | decimal(18,2) | NULL |  |
| VATPercentage | decimal(18,2) | NULL |  |
| VATAmountPerUnit | decimal(18,2) | NULL |  |
| MusakVATPercentage | decimal(18,2) | NULL |  |
| MusakVATAmountPerUnit | decimal(18,2) | NULL |  |
| TPVat | decimal(18,2) | NULL |  |
| MusakVat | decimal(18,2) | NULL |  |
| IsActive | bit | NULL |  |
| ActiveDate | datetime | NULL |  |
| InActiveDate | datetime | NULL |  |

### `tblUpazilaCoordinator`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UpCoordinatorId | int | NOT NULL | PK, IDENTITY |
| UpCoordinatorCode | nvarchar(50) | NULL |  |
| DivisionId | int | NULL |  |
| DistrictId | int | NULL |  |
| ThanaId | int | NULL |  |
| EmpInfoId | int | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| IsActive | bit | NULL |  |
| InactiveBy | int | NULL |  |
| InactiveDate | datetime | NULL |  |

### `tblUser`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserId | int | NOT NULL | PK, IDENTITY |
| UserName | nvarchar(max) | NULL |  |
| UserType | nvarchar(max) | NULL |  |
| UserCode | nvarchar(max) | NULL |  |
| LoginName | nvarchar(max) | NULL |  |
| Password | nvarchar(max) | NULL |  |
| UserStatus | nvarchar(max) | NULL |  |
| Email | nvarchar(max) | NULL |  |
| ContactNo | nvarchar(max) | NULL |  |
| CentralWareHouse | bit | NULL |  |
| EmpInfoId | int | NULL |  |
| IsAppsUser | bit | NULL |  |
| IMEI_One | nvarchar(max) | NULL |  |
| IMEI_Two | nvarchar(max) | NULL |  |
| UserRoleID | int | NULL |  |
| IsExpProduct | bit | NULL |  |
| ActiveInActiveDate | datetime | NULL |  |
| UserTypeId | int | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| IsMainDashboard | bit | NULL |  |
| IsDepotDashboard | bit | NULL |  |
| DeviceInfo_1 | nvarchar(max) | NULL |  |
| DeviceInfo_2 | nvarchar(max) | NULL |  |
| OS_1 | nvarchar(max) | NULL |  |
| OS_2 | nvarchar(max) | NULL |  |
| OS_Version_1 | nvarchar(max) | NULL |  |
| OS_Version_2 | nvarchar(max) | NULL |  |
| LastAccessTime_1 | datetime | NULL |  |
| LastAccessTime_2 | datetime | NULL |  |
| AppVer_1 | nvarchar(max) | NULL |  |
| AppVer_2 | nvarchar(max) | NULL |  |
| daInfoId | int | NULL |  |
| IsPasswordChange | bit | NULL |  |
| IsForceLogout | bit | NOT NULL |  |

### `tblUserArchivePermission`

| Column | Type | Nullable | Key |
|---|---|---|---|
| SL | int | NOT NULL | PK, IDENTITY |
| UserId | int | NULL |  |
| FinancialYearId | int | NULL |  |
| DataBaseName | nvarchar(255) | NULL |  |
| EntryBy | nvarchar(100) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(100) | NULL |  |
| UpdateDate | datetime | NULL |  |

### `tblUserCompanyUnit`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserId | int | NULL |  |
| CompanyUnitId | int | NULL |  |
| CWHPermission | bit | NULL |  |
| NationalReportPermission | bit | NULL |  |
| UserComId | int | NOT NULL | PK, IDENTITY |

### `tblUserDeviceToken`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserDeviceTokenId | int | NOT NULL | PK, IDENTITY |
| UserId | int | NULL |  |
| EmpInfoId | int | NULL |  |
| DeviceToken | nvarchar(max) | NULL |  |
| EntryDate | datetime | NULL |  |
| Device | nvarchar(max) | NULL |  |

### `tblUserMarketExecss`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserMarketExcessId | int | NOT NULL | PK, IDENTITY |
| UserId | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| SubTerritoryId | int | NULL |  |
| MarketId | int | NULL |  |
| UserMarketDetailId | int | NULL |  |

### `tblUserMenuPermissionApp`

| Column | Type | Nullable | Key |
|---|---|---|---|
| RolePermissionId | int | NOT NULL | PK, IDENTITY |
| MenuId | int | NULL |  |
| MenuName | nvarchar(50) | NULL |  |
| RoleTypeId | int | NULL |  |

### `tblUserSessionTracking`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TrackingId | int | NOT NULL | PK, IDENTITY |
| UserId | int | NOT NULL |  |
| LoginDateTime | datetime | NOT NULL |  |
| LogoutDateTime | datetime | NULL |  |
| IPAddress | nvarchar(50) | NULL |  |
| Country | nvarchar(100) | NULL |  |
| RegionState | nvarchar(100) | NULL |  |
| City | nvarchar(100) | NULL |  |
| BrowserName | nvarchar(100) | NULL |  |
| OSName | nvarchar(100) | NULL |  |
| DeviceType | nvarchar(50) | NULL |  |
| SessionId | nvarchar(100) | NOT NULL |  |
| LastActivityTime | datetime | NULL |  |
| IsActiveSession | bit | NOT NULL |  |

### `tblUserSettingPanel`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserSettingPanelId | int | NOT NULL | PK, IDENTITY |
| FromDate | datetime | NULL |  |
| Todate | datetime | NULL |  |
| Criteria | nvarchar(max) | NULL |  |
| CriteriaRemarks | nvarchar(max) | NULL |  |

### `tblUserType`

| Column | Type | Nullable | Key |
|---|---|---|---|
| UserTypeId | int | NOT NULL | PK |
| UserType | nvarchar(max) | NULL |  |
| IsActive | bit | NULL |  |

### `tblVarifyCoustomer`

| Column | Type | Nullable | Key |
|---|---|---|---|
| DpoCode | nvarchar(max) | NULL |  |
| VCustomerCode | nvarchar(max) | NOT NULL |  |

### `tblVisitPlanApprovalLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| VisitPlanApprovalId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblVisitPlanApprovalVoidLog`

| Column | Type | Nullable | Key |
|---|---|---|---|
| VisitPlanApprovalVoidId | int | NOT NULL | PK, IDENTITY |
| Date | datetime | NULL |  |
| FromEmpId | int | NULL |  |
| ToEmpId | int | NULL |  |
| TableId | int | NULL |  |
| Status | nvarchar(50) | NULL |  |
| Comments | nvarchar(50) | NULL |  |
| Type | nvarchar(max) | NULL |  |
| Step | int | NULL |  |
| GroupId | int | NULL |  |
| RegionId | int | NULL |  |
| AreaId | int | NULL |  |
| TerritoryId | int | NULL |  |
| ToGroupId | int | NULL |  |
| ToRegionId | int | NULL |  |
| ToAreaId | int | NULL |  |
| ToTerritoryId | int | NULL |  |
| EntryByS | int | NULL |  |
| EntryDateS | datetime | NULL |  |
| EntryTimeS | time | NULL |  |
| ApproveByS | int | NULL |  |
| ApproveDateS | datetime | NULL |  |
| ApproveTimeS | time | NULL |  |
| EntryByApp | int | NULL |  |
| EntryDateApp | datetime | NULL |  |
| EntryTimeApp | time | NULL |  |
| ApproveByApp | int | NULL |  |
| ApproveDateApp | datetime | NULL |  |
| ApproveTimeApp | time | NULL |  |
| RoleTypeId | int | NULL |  |
| ToRoleTypeId | int | NULL |  |
| MenuId | int | NULL |  |

### `tblW_Order`

| Column | Type | Nullable | Key |
|---|---|---|---|
| W_OrderNo | nvarchar(max) | NULL |  |

### `tblWearhouse`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WearhouseId | int | NOT NULL |  |
| WearhouseCode | nvarchar(50) | NULL |  |
| WearhouseName | nvarchar(50) | NULL |  |
| Address | nvarchar(50) | NULL |  |
| PhoneNo | nvarchar(50) | NULL |  |
| MobileNo | nvarchar(50) | NULL |  |
| FaxNo | nvarchar(50) | NULL |  |
| CompanyId | int | NULL |  |
| CompanyName | nvarchar(50) | NULL |  |

### `tblWeekNameInfo`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WeekNameId | int | NOT NULL | PK, IDENTITY |
| WeekName | nvarchar(max) | NULL |  |

### `tblWeekSetting`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WeekSettingId | int | NOT NULL | PK, IDENTITY |
| FiscalYearId | int | NULL |  |
| WeekName | nvarchar(max) | NULL |  |
| Quaters | nvarchar(50) | NULL |  |
| FromDate | datetime | NULL |  |
| Todate | datetime | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | int | NULL |  |
| ApproveDate | datetime | NULL |  |
| WeekSettingCode | nvarchar(max) | NULL |  |

### `tblWHAdjustmentDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WHStockAdjDetailId | int | NOT NULL | PK, IDENTITY |
| WHStockAdjId | int | NULL |  |
| Quantity | decimal(18,0) | NULL |  |
| ReceiveId | int | NULL |  |

### `tblWHStockAdjustment`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WHStockAdjId | int | NOT NULL | PK, IDENTITY |
| TransactionNo | nvarchar(50) | NULL |  |
| TransactionDate | datetime | NULL |  |
| AdjustmentType | int | NULL |  |
| StockEffect | nvarchar(50) | NULL |  |
| FromStore | int | NULL |  |
| Remarks | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NULL |  |
| ActionStatus | nvarchar(50) | NULL |  |
| toStore | int | NULL |  |

### `tblWhStockConditionFreeze`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WhStockConditionFreezeID | int | NOT NULL | PK |
| ReceiveId | int | NULL |  |
| ManufacId | int | NULL |  |
| FreezeQty | decimal(18,0) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblWHStockInDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WHStockInDetailID | int | NOT NULL | PK, IDENTITY |
| WHStockInMasterID | int | NULL |  |
| ProductId | int | NULL |  |
| Batch | nvarchar(max) | NULL |  |
| ExpDate | datetime | NULL |  |
| MfgDate | datetime | NULL |  |
| Qty | decimal(18,0) | NULL |  |
| Price | decimal(18,2) | NULL |  |
| VAT | decimal(18,2) | NULL |  |
| TotalAmount | decimal(18,2) | NULL |  |

### `tblWHStockInMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WHStockInMasterID | int | NOT NULL | PK |
| WHStockInCode | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| WHStockInDate | datetime | NULL |  |
| TotalQuantity | int | NULL |  |
| TotalVat | decimal(18,2) | NULL |  |
| TotalValue | decimal(18,2) | NULL |  |
| ChallanNo | nvarchar(50) | NULL |  |
| ChallanDate | datetime | NULL |  |
| ReferenceNo | nchar(50) | NULL |  |
| ReferenceDate | nvarchar(500) | NULL |  |
| Remarks | nvarchar(500) | NULL |  |
| Status | nvarchar(50) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | nvarchar(50) | NULL |  |
| UpdateDate | datetime | NULL |  |
| ApproveBy | nvarchar(50) | NULL |  |
| ApproveDate | datetime | NULL |  |
| SupplierId | int | NULL |  |

### `tblWHStockOutDetail`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WHStockOutDetailID | int | NOT NULL | PK, IDENTITY |
| WHStockOutMasterID | int | NULL |  |
| ProductId | int | NULL |  |
| Qty | decimal(18,0) | NULL |  |
| WHStockInDetailID | int | NULL |  |
| ReceiveId | int | NULL |  |

### `tblWHStockOutMaster`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WHStockOutMasterID | int | NOT NULL | PK |
| WHStockOutCode | nvarchar(50) | NULL |  |
| ManufacId | int | NULL |  |
| WHStockOutDate | datetime | NULL |  |
| WHStockInMasterID | int | NULL |  |
| Reason | nvarchar(500) | NULL |  |
| EntryBy | nvarchar(50) | NULL |  |
| EntryDate | datetime | NULL |  |

### `tblWhStoreFreeze`

| Column | Type | Nullable | Key |
|---|---|---|---|
| WhStoreFreezeId | int | NOT NULL | PK, IDENTITY |
| ReceiveId | int | NULL |  |
| ProductId | int | NULL |  |
| ProductName | nvarchar(max) | NULL |  |
| PackSize | nvarchar(max) | NULL |  |
| BatchNo | nvarchar(max) | NULL |  |
| TotalQuantity | decimal(18,0) | NULL |  |
| ExpDate | datetime | NULL |  |
| ReceiveDate | datetime | NULL |  |
| StockQty | decimal(18,0) | NULL |  |
| DamageQty | decimal(18,0) | NULL |  |
| StockRcvDate | datetime | NULL |  |
| StockCondition | nvarchar(50) | NULL |  |
| WhStockConditionFreezeID | int | NULL |  |
| Remarks | nvarchar(max) | NULL |  |

### `tblZoneWiseTargetSetup`

| Column | Type | Nullable | Key |
|---|---|---|---|
| ZoneWTSetupId | int | NOT NULL | PK, IDENTITY |
| Year | nvarchar(50) | NULL |  |
| Month | nvarchar(50) | NULL |  |
| GroupId | int | NULL |  |
| TargetAmount | decimal(18,2) | NULL |  |
| RegionId | int | NULL |  |
| Amount | decimal(18,2) | NULL |  |
| EntryBy | int | NULL |  |
| EntryDate | datetime | NULL |  |
| UpdateBy | int | NULL |  |
| UpdateDate | datetime | NULL |  |

### `testOtherVisitConfiguration`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourPurpose | nvarchar(50) | NOT NULL |  |
| RoleName | nvarchar(50) | NOT NULL |  |
| TerritoryCode | nvarchar(50) | NOT NULL |  |
| AreaCode | nvarchar(50) | NOT NULL |  |
| RegionCode | nvarchar(50) | NOT NULL |  |
| StationType | nvarchar(50) | NOT NULL |  |

### `tlFakeEmp`

| Column | Type | Nullable | Key |
|---|---|---|---|
| PreviousID | nvarchar(50) | NULL |  |
| ChangeID | nvarchar(50) | NULL |  |
| EmpName | nvarchar(50) | NULL |  |
| Designation | nvarchar(50) | NULL |  |
| EmpId | int | NULL |  |
| DesignationId | int | NULL |  |

### `TourDetailsFake`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TourDetailsFakeID | int | NOT NULL | PK, IDENTITY |
| TourPurpose | nvarchar(500) | NULL |  |
| RoleName | nvarchar(255) | NULL |  |
| TerritoryCode | nvarchar(50) | NULL |  |
| AreaCode | nvarchar(50) | NULL |  |
| RegionCode | nvarchar(50) | NULL |  |
| StationType | nvarchar(50) | NULL |  |
| TourPurposeId | int | NULL |  |
| RoleNameId | int | NULL |  |
| TerritoryCodeId | int | NULL |  |
| AreaCodeId | int | NULL |  |
| RegionCodeId | int | NULL |  |
| StationTypeId | int | NULL |  |

### `tttttttt`

| Column | Type | Nullable | Key |
|---|---|---|---|
| customerCode | nvarchar(50) | NULL |  |

### `USER_AutoCreate`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Name | nvarchar(max) | NULL |  |
| UserCode | nvarchar(max) | NULL |  |
| Pass | nvarchar(max) | NULL |  |
| EmpID | nvarchar(max) | NULL |  |

### `Year`

| Column | Type | Nullable | Key |
|---|---|---|---|
| Year | nvarchar(max) | NULL |  |

### `yourtable`

| Column | Type | Nullable | Key |
|---|---|---|---|
| TEST_NAME | varchar(5) | NULL |  |
| SBNO | int | NULL |  |
| VAL | varchar(5) | NULL |  |
