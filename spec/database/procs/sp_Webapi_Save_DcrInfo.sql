CREATE PROCEDURE [dbo].[sp_Webapi_Save_DcrInfo]
	-- Add the parameters for the stored procedure here
@doctorId INT ,
@dcrDate NVARCHAR(50),
@visitTypeId INT,
@chamberId INT,
@IsNonEffectiveReason bit=null,
@ReasonId INT,
@sessionUser NVARCHAR(50),
@remarks NVARCHAR(50),
@DocTPDetailsId INT =0,
@EntryDate_Apps NVARCHAR(50)=NULL,

    @Latitude NVARCHAR(MAX) = NULL ,
    @Longitude NVARCHAR(MAX) = NULL ,

	@StreetAddress NVARCHAR(MAX) = NULL,
    @Type  NVARCHAR(MAX) = NULL
AS
BEGIN

--IF @EntryDate_Apps IS NOT NULL
--BEGIN
--    DECLARE @FromDateStrings VARCHAR(20) = CONVERT(VARCHAR, @EntryDate_Apps, 106);
--    SET @FromDateStrings = REPLACE(@FromDateStrings, 'Sept', 'Sep');
--    SET @EntryDate_Apps = CONVERT(DATETIME, @FromDateStrings, 106);
--END

--IF @dcrDate IS NOT NULL
--BEGIN
--    DECLARE @FromDateString VARCHAR(20) = CONVERT(VARCHAR, @dcrDate, 106);
--    SET @FromDateString = REPLACE(@FromDateString, 'Sept', 'Sep');
--    SET @dcrDate = CONVERT(DATETIME, @FromDateString, 106);
--END

DECLARE @Id INT=0

if(@Type='ccrAdapter')
begin
set @Type='CVR'
end

else
begin
set @Type='DCR'
end


set @EntryDate_Apps=getdate()
 set @dcrDate = getdate()
	
	DECLARE  @SmcTypeId INT=null ,@SMCType NVARCHAR(500), @DoctorProgramypeId int,@userId INT, @GroupId INT,@RegionId INT,@AreaId INT, @TerritoryId INT,@SubTerritoryId INT,@marketId INT , @DoctorTypeID_DCR INT=null ,@DoctorType_DCR NVARCHAR(500) 
		SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @sessionUser


			declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)


            if(@Type='DCR')
            begin
            
		select @DoctorTypeID_DCR= isnull(dt.DoctorTypeId,0), @DoctorType_DCR= isnull(dt.DoctorTypeName,'N/A'), @SMCType=smcT.SMCType, @SmcTypeId= ISNULL(tblDoctorMaster.SmcTypeId,NULL), @DoctorProgramypeId=tblDoctorMaster.ProgramTypeId, @GroupId=gr.GroupId, @RegionId=rg.RegionId, @AreaId=Ar.AreaId,@SubTerritoryId=subTr.SubTerritoryId,@TerritoryId=Tr.TerritoryId, @marketId=tblDoctorMaster.MarketId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=subTr.SubTerritoryName, @MarketName=mr.MarketName ,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=subTr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from tblDoctorMaster   with (nolock)
		 left join  tblMarket mr on tblDoctorMaster.MarketId=mr.MarketId

	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
	  left JOIN dbo.tblSMCType smcT   with (nolock) ON smcT.SmcTypeId = tblDoctorMaster.SmcTypeId
	  left join tblDoctorType dt on tblDoctorMaster.DoctorTypeId=dt.DoctorTypeId
		 where   DoctorId = @doctorId
            end
            else
             begin

             
		select @DoctorTypeID_DCR= 0, @DoctorType_DCR=  'N/A' , @SMCType='N/A', @SmcTypeId= 0, @DoctorProgramypeId=0, @GroupId=gr.GroupId, @RegionId=rg.RegionId, @AreaId=Ar.AreaId,@SubTerritoryId=subTr.SubTerritoryId,@TerritoryId=Tr.TerritoryId, @marketId=tblCustMaster.MarketId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=subTr.SubTerritoryName, @MarketName=mr.MarketName ,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=subTr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from tblCustMaster   with (nolock)
		 left join  tblMarket mr on tblCustMaster.MarketId=mr.MarketId

	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
	   
	   
		 where   tblCustMaster.CustomerMasterId = @doctorId
             end



              DECLARE @existingId INT=0;

        SELECT TOP (1) @existingId =isnull( c.DcrId,0)
        FROM dbo.tbl_DCRInfo AS c WITH (UPDLOCK, HOLDLOCK)
        WHERE c.DoctorId = @doctorId
          AND CONVERT(date, c.DcrDate) = CONVERT(date, @dcrDate)
          AND c.TypeDcr = @Type and isnull(c.ApprovalStatus,'')<>'2'

    if(isnull(@existingId,0)=0)

         begin
	 UPDATE dbo.tbl_DoctorTourPlanDetail SET IsDcrDone = 1 WHERE DocTPDetailsId = @DocTPDetailsId


		
		INSERT INTO dbo.tbl_DCRInfo
		        ( DcrDate ,
		          TourTypeId ,
		          ChemberId ,
		          EntryBy ,
		          EntryDate ,
		          Remarks,
				  DoctorId,
				  DocTPDetailsId, IsNonEffectiveReason,ReasonId,EntryDate_Apps,GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId, ApprovalStatus, Latitude, Longitude, StreetAddress,DoctorProgramypeId,[GroupName]
           ,[RegionName]
           ,[AreaName]
           ,[TerritoryName]
           ,[SubTerritoryName]
           ,[MarketName],[GroupCode_DCR]
           ,[RegionCode_DCR]
           ,[AreaCode_DCR]
           ,[TerritoryCode_DCR]
           ,[SubTerritoryCode_DCR]
           ,[MarketCode_DCR],  SmcTypeId_DCR, SMCType_DCR,DoctorType_DCR,DoctorTypeID_DCR,TypeDcr
		        )
		VALUES  ( 
					@dcrDate,
					@visitTypeId,
					@chamberId,
					@userId,
					GETDATE(),
					@remarks,
					@doctorId,
					@DocTPDetailsId,
					@IsNonEffectiveReason,@ReasonId,@EntryDate_Apps,@GroupId,@RegionId,@AreaId,@TerritoryId,@SubTerritoryId, @MarketId, 0,@Latitude,@Longitude,@StreetAddress,@DoctorProgramypeId,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord,  isnull(@SmcTypeId,0), isnull( @SMCType , 'N/A') ,isnull( @DoctorType_DCR , 'N/A'),isnull(@DoctorTypeID_DCR,0),@Type
		        )

				
				SELECT @Id=SCOPE_IDENTITY()

			
DECLARE @empId INT
--set @Id=@doctorId
		 


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName, @empId=emp.EmpInfoId
FROM dbo.tblEmpGeneralInfo  emp  with (nolock) 
left join  tblUser us  with (nolock)  on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR  with (nolock)  on usR.UserRoleID=us.UserRoleID
 
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
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE NSMEMPId=@empId
END

	
EXECUTE dbo.sp_webapi_SaveDCRAppLog @DCRApprovalId = 0,                         -- int
                                 @Date = @EntryDate_Apps,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'DCR',                             -- nvarchar(max)
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
                                 @EntryDateS = @EntryDate_Apps,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @EntryDate_Apps,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 382                            -- int

end
    SELECT  isnull(@Id,0)



			


END
