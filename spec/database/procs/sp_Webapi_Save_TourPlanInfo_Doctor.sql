CREATE PROCEDURE [dbo].[sp_Webapi_Save_TourPlanInfo_Doctor]
	-- Add the parameters for the stored procedure here
  @TourDate DATETIME = NULL ,
  @doctorId INT = NULL,
  @empId INT =null
  
AS
    BEGIN

	DECLARE @tpMasterId int
	IF(NOT EXISTS(SELECT * FROM dbo.tbl_DoctorTourPlanDetail WHERE TourPlanDate = @TourDate  AND DoctorId = @doctorId))
	BEGIN

	IF(NOT EXISTS(SELECT * FROM dbo.tbl_DoctorTourPlanMaster WHERE MonthValue = MONTH(@TourDate) AND YearValue = YEAR(@TourDate) AND EmpInfoId = @empId))
	BEGIN

		
		INSERT INTO dbo.tbl_DoctorTourPlanMaster
		        ( MonthValue ,
		          YearValue ,
		          EmpInfoId 
		        )
		VALUES  ( 
		MONTH(@TourDate),
		YEAR(@TourDate),
		@empId

		        )


			SET @tpMasterId = SCOPE_IDENTITY()

		
	END
	ELSE
	BEGIN

	SET @tpMasterId = (SELECT  TOP 1 DocTPMaster FROM dbo.tbl_DoctorTourPlanMaster WHERE MonthValue = MONTH(@TourDate) AND YearValue = YEAR(@TourDate) AND EmpInfoId = @empId ORDER BY DocTPMaster DESC)
		
	END

	DECLARE @StationTypeId int
 SELECT  @StationTypeId=StationTypeId FROM dbo.tblDoctorMaster WHERE DoctorId=@doctorId

 	DECLARE  @DoctorProgramypeId int,@userId INT, @GroupId INT,@RegionId INT,@AreaId INT, @TerritoryId INT,@SubTerritoryId INT,@marketId INT

	declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max),@SMCTypeId_DV int ,@SMCType_DV nvarchar(max)


 	select @SMCTypeId_DV=tblDoctorMaster.SMCTypeId, @SMCType_DV= st.SmcType,  @DoctorProgramypeId=tblDoctorMaster.ProgramTypeId, @GroupId=gr.GroupId, @RegionId=rg.RegionId, @AreaId=Ar.AreaId,@SubTerritoryId=subTr.SubTerritoryId,@TerritoryId=Tr.TerritoryId, @marketId=tblDoctorMaster.MarketId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=subTr.SubTerritoryName, @MarketName=mr.MarketName,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=subTr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode  from tblDoctorMaster   with (nolock)
		 left join  tblMarket mr on tblDoctorMaster.MarketId=mr.MarketId
		 left join  tblSMCType st on tblDoctorMaster.SMCTypeId=st.SMCTypeId

	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
		 where   DoctorId = @doctorId
	 

INSERT INTO dbo.tbl_DoctorTourPlanDetail
        ( 
          DoctorId ,
          TourPlanDate ,
          EmpInfoId ,
          DocTPMaster, TourTypeId,GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId ,DoctorProgramypeId_DV,[GroupName_DV]
           ,[RegionName_DV]
           ,[AreaName_DV]
           ,[TerritoryName_DV]
           ,[SubTerritoryName_DV]
           ,[MarketName_DV],[GroupCode_DV]
           ,[RegionCode_DV]
           ,[AreaCode_DV]
           ,[TerritoryCode_DV]
           ,[SubTerritoryCode_DV]
           ,[MarketCode_DV], SMCTypeId_DV,SMCType_DV
        )
VALUES  (
		@doctorId,
		@TourDate,
		@empId,
		@tpMasterId ,@StationTypeId,@GroupId,@RegionId,@AreaId,@TerritoryId,@SubTerritoryId, @MarketId, @DoctorProgramypeId,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord, @SMCTypeId_DV, @SMCType_DV


        )


 		DECLARE @Id INT
 set @Id=@tpMasterId
		 


--DECLARE @Role NVARCHAR(MAX)
--SELECT @Role=usR.RoleName, @empId=emp.EmpInfoId
--FROM dbo.tblEmpGeneralInfo  emp
--left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
--left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
-- WHERE us.EmpInfoId=@empId


--DECLARE @ToEmpId1 INT
--DECLARE @GroupId1 INT
--DECLARE @RegionId1 INT
--DECLARE @AreaId1 INT
--DECLARE @TerrId1 INT

--DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
----SELECT * FROM dbo.View_webapi_FieldForce
----LEFT JOIN dbo.tblMIOInfo ON 

--IF(@Role='MIO')
--BEGIN
--    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
--END
--IF(@Role='ASM')
--BEGIN
--SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
--END
--IF(@Role='RSM')
--BEGIN
--    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
--END
--IF(@Role='NSM')
--BEGIN
--    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
--END

--DECLARE @EDate DATETIME=GETDATE()
	
--EXECUTE dbo.sp_webapi_SaveVisitPlanAppLog @VisitPlanApprovalId = 0,                         -- int
--                                 @Date = @EDate,           -- datetime
--                                 @FromEmpId = @empId,                          -- int
--                                 @ToEmpId = 0,                            -- int
--                                 @TableId = @Id,                            -- int
--                                 @Status = N'0',                           -- nvarchar(max)
--                                 @Comments = N'',                         -- nvarchar(max)
--                                 @Type = N'TourPlan',                             -- nvarchar(max)
--                                 @Step = 1,                               -- int
--                                 @GroupId = @GroupId1,                            -- int
--                                 @RegionId = @RegionId1,                           -- int
--                                 @AreaId = @AreaId1,                             -- int
--                                 @TerritoryId = @TerrId1,                        -- int
--                                 @ToGroupId = 0,                          -- int
--                                 @ToRegionId = 0,                         -- int
--                                 @ToAreaId = 0,                           -- int
--                                 @ToTerritoryId = 0,                      -- int
--                                 @EntryByS = @empId,                         -- nvarchar(max)
--                                 @EntryDateS = @EDate,     -- datetime
--                                 @EntryTimeS = @EntryTime,                -- time(7)
--                                 @ApproveByS = NULL,                       -- nvarchar(max)
--                                 @ApproveDateS = NULL,   -- datetime
--                                 @ApproveTimeS = NULL,              -- time(7)
--                                 @EntryByApp = @empId,                       -- nvarchar(max)
--                                 @EntryDateApp = @EDate,   -- datetime
--                                 @EntryTimeApp = @EntryTime,              -- time(7)
--                                 @ApproveByApp = NULL,                     -- nvarchar(max)
--                                 @ApproveDateApp = NULL, -- datetime
--                                 @ApproveTimeApp = NULL,            -- time(7)
--                                 @MenuId = 377                           -- int


--    SELECT  @Id



    End
set	@tpMasterId=0
    End

