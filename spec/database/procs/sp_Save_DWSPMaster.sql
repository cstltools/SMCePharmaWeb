

CREATE PROCEDURE [dbo].[sp_Save_DWSPMaster]
	-- Add the parameters for the stored procedure here
  @DWSPDate DATETIME = NULL ,
  @FCBAmount decimal(18,2) = NULL,
  @CampaignAmount decimal(18,2) = NULL,
  @GeneralAmount decimal(18,2) = NULL,
  @empId INT =null,
  @TerritoryId INT =null
  
AS
    BEGIN


	declare @iSfSubmit bit =0
	select @iSfSubmit= ISNULL(mas.IsFinalSubmit,0) FROM dbo.tbl_DWSPDetail dtl
	inner join tbl_DWSPMaster mas on dtl.DWSPMasterId=mas.DWSPMasterId
	 WHERE CONVERT(Date,DWSPDate) = CONVERT(Date,@DWSPDate)  AND dtl.EmpInfoId = @empId and  MonthValue = MONTH(@DWSPDate) AND YearValue = YEAR(@DWSPDate) and mas.TerritoryId=@TerritoryId


	 if(@iSfSubmit<>1)
	 begin
	declare @MasId int =0

	 select @MasId= ISNULL(mas.DWSPMasterId,0) FROM dbo.tbl_DWSPDetail dtl
	inner join tbl_DWSPMaster mas on dtl.DWSPMasterId=mas.DWSPMasterId
	 WHERE CONVERT(Date,DWSPDate) = CONVERT(Date,@DWSPDate)  AND dtl.EmpInfoId = @empId and  MonthValue = MONTH(@DWSPDate) AND YearValue = YEAR(@DWSPDate) and mas.TerritoryId=@TerritoryId
	delete FROM dbo.tbl_DWSPDetail WHERE DWSPMasterId=@MasId
	DECLARE @DWSPMasterId int
	IF(NOT EXISTS(select  mas.DWSPMasterId  FROM dbo.tbl_DWSPDetail dtl
	inner join tbl_DWSPMaster mas on dtl.DWSPMasterId=mas.DWSPMasterId
	 WHERE CONVERT(Date,DWSPDate) = CONVERT(Date,@DWSPDate)  AND dtl.EmpInfoId = @empId and  MonthValue = MONTH(@DWSPDate) AND YearValue = YEAR(@DWSPDate) and mas.TerritoryId=@TerritoryId))
	BEGIN

	IF(NOT EXISTS(SELECT * FROM dbo.tbl_DWSPMaster WHERE MonthValue = MONTH(@DWSPDate) AND YearValue = YEAR(@DWSPDate) AND EmpInfoId = @empId and  TerritoryId=@TerritoryId))
	BEGIN

		
		INSERT INTO dbo.tbl_DWSPMaster
		        ( MonthValue ,
		          YearValue ,
		          EmpInfoId ,TerritoryId, ApprovalStatus, IsFinalSubmit, OtherRemarks
		        )
		VALUES  ( 
		MONTH(@DWSPDate),
		YEAR(@DWSPDate),
		@empId,@TerritoryId,'2',1,'Vaccant'

		        )


			SET @DWSPMasterId = SCOPE_IDENTITY()

		
	END
	ELSE
	BEGIN

	SET @DWSPMasterId = (SELECT  TOP 1 DWSPMasterId FROM dbo.tbl_DWSPMaster WHERE MonthValue = MONTH(@DWSPDate) AND YearValue = YEAR(@DWSPDate) AND EmpInfoId = @empId  and  TerritoryId=@TerritoryId ORDER BY DWSPMasterId DESC)
		
	END

	 

INSERT INTO [dbo].[tbl_DWSPDetail]
           ([DWSPMasterId]
           ,[FCBAmount]
           ,[GeneralAmount]
           ,[CampaignAmount]
           ,[DWSPDate]
           ,[EmpInfoId])
     VALUES
           (@DWSPMasterId 
           ,@FCBAmount 
           ,@GeneralAmount 
           ,@CampaignAmount 
           ,@DWSPDate 
           ,@empId)


 		DECLARE @Id INT
 set @Id=@DWSPMasterId
		 
		 end

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
set	@DWSPMasterId=0
    End










