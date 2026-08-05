CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorEntry]
	-- Add the parameters for the stored procedure here

	  @MasterId INT=NULL,
    @doctorName NVARCHAR(MAX) = NULL ,
   
    @remarks NVARCHAR(MAX) = NULL ,
    @entryBy INT = NULL ,
    @EntryDate DATETIME = NULL ,
   
    --@contactTypeId INT = NULL ,
    ----@contactInfo NVARCHAR(MAX) = NULL ,
    @subMarketId INT = NULL,
	@designaionId INT =NULL,
	@marketId INT = NULL,
	@TerritoryId  INT = NULL,
	@SubTerritoryId  INT = NULL,
	@DoctorCategoryId  INT = NULL,
	@ProgramTypeId  INT = NULL,
	@UnionName NVARCHAR(MAX) = NULL ,
	@StationTypeId  INT = NULL ,
	@DoctorTypeId  INT = NULL  ,
	--@SpecialDayId  INT = NULL ,
	 
    @SMCTypeId INT = NULL ,
	@DoctorAddress NVARCHAR(MAX) = NULL

AS
    BEGIN




        DECLARE @doctorId INT,@userId int
        DECLARE @DoctorCode NVARCHAR(MAX)

        --SELECT  @DoctorCode = 'DOC-'
        --        + ( CONVERT(NVARCHAR(MAX), ( COUNT(DoctorId) + 10001 )) )
        --FROM    tblDoctorMaster


		SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @entryBy

		--IF(NOT EXISTS (SELECT * FROM dbo.tblDoctorMaster WHERE DoctorName = @DoctorName  ))
	BEGIN



	if(@marketId >0)
	begin
	 DECLARE @RouteInformationMasterId int ,	@StationTypeId_ INT, @GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId_ INT,@SubTerritoryId_ INT, @divId int ,@disId int ,@thanaId int 
		SELECT  @divId=div.DivisionId,@disId=dis.DistrictId,  @thanaId=mr.ThanaId,  @SubTerritoryId_=sr.SubTerritoryId,@TerritoryId_=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId

		left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
		left join tbl_Division div  with (nolock) on dis.DistrictId=div.DivisionId 
		 
		  where  MarketId=@MarketId

	 select @StationTypeId_= ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId

		  

		 


        INSERT  INTO dbo.tblDoctorMaster
                ( DoctorName ,
                  DoctorCode ,
                  Remarks ,
                  IsActive ,
                  EntryBy ,
                  EntryDate ,
                
				  IsFromApp,
				  DesignationId,
				  ApprovalStatus   ,
				    GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId
       ,[UnionName]
      
      ,[StationTypeId]
      ,[ProgramTypeId]
      ,[DoctorCategoryId], DoctorTypeId,DivisionId,DistrictId,ThanaId, SMCTypeId, DoctorAddress
	            )
        VALUES  ( @doctorName ,
                  null ,
                  @remarks ,
                  0,
                  @userId ,
                  GETDATE() ,
                  
				  1,
				  @designaionId,
				  '0'
				 ,  @GroupId,@RegionId,@AreaId,@TerritoryId_,@SubTerritoryId_, @marketId
      ,@UnionName 
      
      ,1 
      ,@ProgramTypeId 
      ,@DoctorCategoryId ,@DoctorTypeId,@divId,@disId,@thanaId,@SMCTypeId,@DoctorAddress
	            )

				 
  select    @doctorId=       SCOPE_IDENTITY()

        IF ( @marketId IS NOT NULL )
            BEGIN
                INSERT  INTO dbo.tblDoctorMarketDetail
                        ( DoctorId, MarketId )
                VALUES  ( @doctorId, @marketId )
            END

			   --IF (@SpeciaDateStr IS  not NULL )
      --      BEGIN
      --          INSERT  INTO dbo.tblDoctorSpecialDayDetail
      --                  ( DoctorId, SpecialDayId,SpecialDate )
      --          VALUES  ( @doctorId, @SpecialDayId,@SpeciaDateStr )
      --      END
		 


--        --IF ( @chamberId IS NOT NULL )
--        --    BEGIN
--        --        INSERT  INTO dbo.tblDoctorChemberDetail
--        --                ( ChamberTypeId ,
--        --                  DoctorId ,
--        --                  Name 
--        --                )
--        --        VALUES  ( @chamberId ,
--        --                  @doctorId ,
--        --                  @chamberAddress
--        --                )
	
--        --    END

        --IF ( @contactTypeId IS NOT NULL )
        --    BEGIN
        --        INSERT  INTO dbo.tblDoctorContactDetail
        --                ( DoctorId ,
        --                  ContactTypeId ,
        --                  Contact 
	       --             )
        --        VALUES  ( @doctorId ,
        --                  @contactTypeId ,
        --                  @contactInfo
	       --             )
        --    END

--			 --IF ( @contactTypeId IS NOT NULL )
--    --        BEGIN
--    --            INSERT  INTO dbo.tblDoctorContactDetail
--    --                    ( DoctorId ,
--    --                      ContactTypeId ,
--    --                      Contact 
--	   --                 )
--    --            VALUES  ( @doctorId ,
--    --                      @contactTypeId ,
--    --                      @contactInfo
--	   --                 )
--    --        END

		
		
--    END
	
DECLARE @Id INT
DECLARE @empId INT
set @Id=@doctorId
		 


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName, @empId=emp.EmpInfoId
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
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

	
EXECUTE dbo.sp_webapi_SaveDoctorAppLog @DoctorApprovalId = 0,                         -- int
                                 @Date = @EntryDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Doctor',                             -- nvarchar(max)
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
                                 @EntryDateS = @EntryDate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @EntryDate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 303                            -- int


    SELECT  @doctorId

	--END
	 END
	 END
	 END
