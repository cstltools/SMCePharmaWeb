
CREATE PROCEDURE [dbo].[usp_InsertTerritoryData]

 @SL INT OUT,
    @TerritoryCode nvarchar(max), 
    @Value nvarchar(max),
    @MonthName varchar(max),
  
   
    @YearValue varchar(max) ,
    @FinYearValue varchar(max) ,
	@EntryBy varchar(max)

  
AS
BEGIN

declare @EmpId int, @FYId int,  @EmpName nvarchar(max),  @TerritoryId int, @ZoneId_tr int,
    @ZoneCode_tr varchar(max),  
    @EmpCode varchar(max),  
    @AreaId_tr int,
    @AreaIdCode_tr varchar(max)
	 

	select  @EmpCode=EmpMasterCode,  @EmpName= EmpName, @EmpId=mo.EmployeeId,  @TerritoryId=  tr.TerritoryId, @AreaId_tr=AreaId from tblTerritory tr
	inner join tblMIOInfo mo on mo.TerritoryId=tr.TerritoryId 
	inner join tblEmpGeneralInfo eg on mo.EmployeeId=eg.EmpInfoId 
	
	where  tr.IsActive=1  and mo.IsActive=1 and  LTRIM(RTRIM(tr.TerritoryCode))= LTRIM(RTRIM(@TerritoryCode))

	select @AreaIdCode_tr=  AreaCode, @ZoneId_tr= RegionId  from tblArea where AreaId=@AreaId_tr

	
	select @ZoneCode_tr=  RegionCode   from tblRegion where RegionId=@ZoneId_tr


	select    @FYId=FinancialYearId   from tblFinancialYear where FinancialYearDesc=@FinYearValue







    INSERT INTO [dbo].[tblTerritoryDataMigration] 
    ([EmpCode], [TerritoryCode], [EmpName],   [Value], [MonthName], [EmpId], [FYId], [TerritoryId], [YearValue], [ZoneId_tr], [ZoneCode_tr], [AreaId_tr], [AreaIdCode_tr],EntryBy,EntryDate)
    VALUES 
    (@EmpCode, @TerritoryCode, @EmpName,  @Value, @MonthName, @EmpId, @FYId, @TerritoryId, @YearValue, @ZoneId_tr, @ZoneCode_tr, @AreaId_tr, @AreaIdCode_tr,@EntryBy,GETDATE());


	   set @SL =SCOPE_IDENTITY() 
END;