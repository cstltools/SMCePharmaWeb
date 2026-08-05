 
CREATE PROCEDURE [dbo].[sp_Webapi_Save_Prescription]
	-- Add the parameters for the stored procedure here
@doctorId INT =NULL,
@presTypeId INT = NULL,
@ChemberId INT = NULL,
@presDate NVARCHAR(50)=null,
@sessionUser NVARCHAR(50)=null
AS
BEGIN
	
	 IF @presDate IS NOT NULL
    BEGIN
        DECLARE @FromDateString VARCHAR(20) = CONVERT(VARCHAR, @presDate, 106);
        SET @FromDateString = REPLACE(@FromDateString, 'Sept', 'Sep');
        SET @presDate = CONVERT(DATETIME, @FromDateString);
    END
	DECLARE @userId INT 

	SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @sessionUser


	DECLARE @DoctorTypeId int,  @DoctorType NVARCHAR(max),  @SmcTypeId INT=null ,@SMCType NVARCHAR(500), @DoctorProgramypeId int, @GroupId INT,@RegionId INT,@AreaId INT, @TerritoryId INT,@SubTerritoryId INT,@marketId INT

	declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)

	select @DoctorTypeId=ISNULL(tblDoctorMaster.DoctorTypeId,0), @DoctorType=ISNULL(dtT.DoctorTypeName,'N/A'),  @SMCType=smcT.SMCType, @SmcTypeId= ISNULL(tblDoctorMaster.SmcTypeId,NULL), @DoctorProgramypeId=tblDoctorMaster.ProgramTypeId,  @GroupId=gr.GroupId, @RegionId=rg.RegionId, @AreaId=Ar.AreaId,@SubTerritoryId=subTr.SubTerritoryId,@TerritoryId=Tr.TerritoryId, @marketId=tblDoctorMaster.MarketId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=subTr.SubTerritoryName, @MarketName=mr.MarketName  ,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=subTr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from 
	

	tblDoctorMaster   with (nolock)
  left join  tblMarket mr on tblDoctorMaster.MarketId=mr.MarketId

	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
	 
		 left JOIN dbo.tblSMCType smcT   with (nolock) ON smcT.SmcTypeId = tblDoctorMaster.SmcTypeId

		  left JOIN dbo.tblDoctorType dtT   with (nolock) ON dtT.DoctorTypeId = tblDoctorMaster.DoctorTypeId
		  
		 where   DoctorId = @doctorId
		 
	 
	INSERT INTO dbo.tbl_PrescriptionMaster
	        ( PrescriptionDate ,
	          PrescriptionTypeId ,
	          DoctorId ,
	          EntryBy ,
	          EntryDate,
			  ApprovalStatus,ChemberId,GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId,DoctorProgramypeId,[GroupName]
           ,[RegionName]
           ,[AreaName]
           ,[TerritoryName]
           ,[SubTerritoryName]
           ,[MarketName] ,[GroupCode_RX]
           ,[RegionCode_RX]
           ,[AreaCode_RX]
           ,[TerritoryCode_RX]
           ,[SubTerritoryCode_RX]
           ,[MarketCode_RX],  SmcTypeId_RX, SMCType_RX,DoctorType_RX,DoctorTypeId_RX
	        )
	VALUES  ( 
	@presDate,
	@presTypeId,
	@doctorId,
	@userId,
	GETDATE(),
	'0',@ChemberId,@GroupId,@RegionId,@AreaId,@TerritoryId,@SubTerritoryId, @MarketId,@DoctorProgramypeId ,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName 
		   ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord,  isnull(@SmcTypeId,0),isnull( @SMCType , 'N/A'), @DoctorType ,@DoctorTypeId 
	        )


DECLARE @Id INT
				SELECT @Id=SCOPE_IDENTITY()

			
DECLARE @empId INT
--set @Id=@doctorId
		 


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName, @empId=emp.EmpInfoId
FROM dbo.tblEmpGeneralInfo  emp  WITH (NOLOCK)  
left join  tblUser us  WITH (NOLOCK)   on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR  WITH (NOLOCK)  on usR.UserRoleID=us.UserRoleID
 
 WHERE us.UserId=@userId


DECLARE @ToEmpId1 INT
DECLARE @GroupId1 INT
DECLARE @RegionId1 INT
DECLARE @AreaId1 INT
DECLARE @TerrId1 INT

DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
--SELECT * FROM dbo.View_webapi_FieldForce
--LEFT JOIN dbo.tblMIOInfo ON 

IF(@Role='MIO')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  WITH (NOLOCK)   WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  WITH (NOLOCK)   WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  WITH (NOLOCK)   WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  WITH (NOLOCK)   WHERE NSMEMPId=@empId
END

DECLARE @EDate DATETIME=GETDATE()
	
EXECUTE dbo.sp_webapi_SavePrescriptionAppLog @PrescriptionApprovalId = 0,                         -- int
                                 @Date = @EDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Prescription',                             -- nvarchar(max)
                                 @Step = 1,                               -- int
                                 @GroupId = @GroupId1,                            -- int
                                 @RegionId = @RegionId1,                           -- int
                                 @AreaId = @AreaId1,                             -- int
                                 @TerritoryId = @TerrId1,                        -- int
                                 @ToGroupId = 0,                          -- int
                                 @ToRegionId = 0,                         -- int
                                 @ToAreaId = 0,                           -- int
                                 @ToTerritoryId = 0,                      -- int
                                 @EntryByS = @empId,                         -- nvarchar(max)
                                 @EntryDateS = @EDate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @EDate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 379                           -- int


    SELECT  @Id


END