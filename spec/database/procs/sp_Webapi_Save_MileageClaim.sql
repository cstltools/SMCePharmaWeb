-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_MileageClaim]
	-- Add the parameters for the stored procedure here
@MileageClaimId int,

    @mileagDate DATETIME = NULL ,
    @transportId INT = NULL ,
    @mileageInKM DECIMAL(18, 2) = NULL ,
    @meterReading DECIMAL(18, 2) = NULL ,
    @MarketId INT = NULL ,
    
   
    @remakrs NVARCHAR(MAX) = NULL ,
    @empId INT
AS
    BEGIN

	
	DECLARE @RoleCheck NVARCHAR(MAX)
    SELECT distinct @RoleCheck= uType.RoleType
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @empId;

 Declare @TagActive int=0
	
IF(@RoleCheck='MIO')
BEGIN

  
    SELECT distinct @TagActive= ISNULL(TerritoryId,0)  FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE MIOEmpId=@empId
	 
END
IF(@RoleCheck='AM')
BEGIN
SELECT  distinct @TagActive= ISNULL(AreaId,0) FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE ASMEMPId=@empId
END
IF(@RoleCheck='DZSM')
BEGIN
    SELECT  distinct @TagActive= ISNULL(RegionId,0)  FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE RSMEMPId=@empId
END

if(@TagActive>0)
begin
		
		if(convert(Date,@mileagDate)=convert(Date,getdate()))
	begin
        DECLARE @userId INT ,
            @allowedMileage DECIMAL(18, 2) ,
            @appStatus NVARCHAR(50)
        SELECT  @userId = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId

        SELECT  @allowedMileage = AllowedMilagePerKM
        FROM    dbo.tbl_Transport
        WHERE   TransportId = @transportId
         

	 DECLARE 	@GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId INT,@SubTerritoryId INT
	 	declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)
		select @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=sr.SubTerritoryName, @MarketName=mr.MarketName,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=ar.AreaCode,@TerritoryCode_ord=tr.TerritoryCode ,@SubTerritoryCode_ord=sr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
	 inner join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId

		  where  MarketId=@MarketId

			IF(NOT EXISTS (SELECT * FROM dbo.tbl_MileageClaim WHERE EmpInfoId = @empId AND CONVERT(DATE,MileageDate) = CONVERT(DATE,@mileagDate) ))
	BEGIN

	 declare @TourTypeIdCount int=0
		  select @TourTypeIdCount=ISNULL(count(*),0) from     dbo.tbl_TourPlanInfo A  with (nolock) 
		   
			INNER JOIN dbo.tbl_TourPlanMaster tpM  with (nolock)  ON tpM.TPMaster = A.TPMaster  where A.EmpInfoId=@empId and CONVERT(date,A.TourPlanDate)=CONVERT(date,@mileagDate) and tpM.ApprovalStatus='2' and isnull(a.TourTypeId,0)<>1
			print @TourTypeIdCount

			if(@TourTypeIdCount>0)
			begin
        INSERT  INTO dbo.tbl_MileageClaim
                ( MileageDate ,
                  TransportId ,
                  MileageInKM ,
                  MeterReading ,
                  AllowedMileageInKM ,
                  
                  Remarks ,
                  EmpInfoId ,
                  ApprovalStatus ,
                  EntryBy ,
                  EntryDate,
				  GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId,[GroupName]
           ,[RegionName]
           ,[AreaName]
           ,[TerritoryName]
           ,[SubTerritoryName]
           ,[MarketName],[GroupCode_Mil]
           ,[RegionCode_Mil]
           ,[AreaCode_Mil]
           ,[TerritoryCode_Mil]
           ,[SubTerritoryCode_Mil]
           ,[MarketCode_Mil]
		        )
        VALUES  ( @mileagDate ,
                  @transportId ,
                  @mileageInKM ,
                  @meterReading ,
                  @allowedMileage ,
                 
                  @remakrs ,
                  @empId ,
                  '0' ,
                  @userId ,
                  GETDATE(),@GroupId,@RegionId,@AreaId,@TerritoryId,@SubTerritoryId, @MarketId,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord
                )

SELECT SCOPE_IDENTITY()

DECLARE @Id INT
			SELECT SCOPE_IDENTITY()
			SELECT @Id=SCOPE_IDENTITY()


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
 WHERE emp.EmpInfoId=@empId


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
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
END

---DECLARE @Id INT




EXECUTE dbo.sp_webapi_SaveMileageAppLog @MileageApprovalId = 0,                         -- int
                                 @Date = @mileagDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Mileage',                             -- nvarchar(max)
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
                                 @EntryDateS = @mileagDate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @mileagDate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 372                            -- int




    END
    END

    END
    END
    END


