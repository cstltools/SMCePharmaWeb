-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_Customer]
	-- Add the parameters for the stored procedure here
    @name NVARCHAR(MAX) = NULL ,
    @address NVARCHAR(MAX) = NULL ,
    @phone NVARCHAR(MAX) = NULL ,
    @conPerson NVARCHAR(MAX) = NULL ,
    @CustomerBSPCode NVARCHAR(MAX) = NULL ,
    @termOfPayment NVARCHAR(50) = NULL ,
    @isFromApp BIT = NULL ,
    @marketId INT = NULL ,
    @ProgramTypeId INT = NULL ,
    @SMCTypeId INT = NULL ,
     @empId INT = NULL ,
    --@districtId INT = NULL ,
    --@divisionId INT = NULL ,
  
    

	 
	@VoterID  NVARCHAR(MAX) = NULL ,

            @TradeLicense NVARCHAR(MAX) = NULL  ,
			@Reamrks NVARCHAR(MAX) = NULL ,

    @Latitude NVARCHAR(MAX) = NULL ,
    @Longitude NVARCHAR(MAX) = NULL ,

	@StreetAddress NVARCHAR(MAX) = NULL
AS
    BEGIN
	

        DECLARE @userid INT ,
            @customerCode NVARCHAR(50)


        SELECT  @userid = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId

		 
		 if(@marketId >0)
	begin

		  declare @CountData int
SELECT @CountData=ISNULL(COUNT(*),0) FROM dbo.tblCustMaster WHERE  marketId = @marketId and CellNo=@phone and [ActionStatus] <>'3'

print @CountData
 IF(@CountData=0)
 BEGIN 
			 
          DECLARE @CustomerBsPCodeJust VARCHAR(50)=null
          if( @CustomerBsPCode='Select' or @CustomerBsPCode='Pop Up')
          begin
          set @CustomerBsPCodeJust=null         
          set @CustomerBsPCode=null

          end
          else
          begin

          SET @CustomerBsPCodeJust = LTRIM(RTRIM((SUBSTRING(@CustomerBsPCode, 1, CHARINDEX(':', @CustomerBsPCode) - 1))))
          end
           


 

	
	 DECLARE @Unit Nvarchar(max), @ComUnitName Nvarchar(max), @ComUnitCode Nvarchar(max),@NSMStationTypeId int , @DZSMStationTypeId int , @CustomerTypeId int

	 DECLARE @RouteInformationMasterId int ,@DCId int ,	@StationTypeId INT, @GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId INT,@SubTerritoryId INT, @divId int ,@disId int ,@thanaId int 
		select @divId=div.DivisionId,@disId=dis.DistrictId,  @thanaId=mr.ThanaId, @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId
		left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
	left join tbl_Division div  with (nolock) on dis.DivisionId=div.DivisionId 
		  where  MarketId=@marketId

		  select  @StationTypeId= ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId and UserRoleID=1

		   select @NSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId and UserRoleID=2

		   	   select @DZSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId and UserRoleID=3

		  

--		  select @RouteInformationMasterId= masR.RouteInformationMasterId from tblRouteInformationMaster masR
--inner join tblRouteInformationMarketDetail dtl on masR.RouteInformationMasterId=dtl.RouteInformationMasterId
--where dtl.MarketId=@marketId


  select @DCId=  masR.DCId, @ComUnitName=cunit.ComUnitName,@ComUnitCode=cunit.ComUnitCode from tblDcWiseTerritoryMaster masR
inner join tblDcWiseTerritoryDetail dtl on masR.DcWiseTerritoryMasterId=dtl.DcWiseTerritoryMasterId
inner join tblCompanyUnit cunit on masR.DCId=cunit.ComUnitId

where dtl.TerritoryId=@TerritoryId


SELECT TOP 1  @CustomerTypeId=CustomerTypeId FROM  tblCustomerType WHERE IsDefault=1

        INSERT  INTO dbo.tblCustMaster
                ( 
                  CustomerName ,
                  Address ,
                  CellNo ,
                  ConPerson ,  
                  TermOfPayment ,
                  IsActive ,
				  CustomerTypeId,
				  CreateBy,
				  CreateDate,
				  IsVatApplicable,[ActionStatus],[VoterID]
           ,[TradeLicense],Reamrks,OwnerName,GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId,Latitude,Longitude, StreetAddress,ProgramTypeId,StationTypeId,DivisionId,DistrictId,ThanaId,CategoryId,FixedCustomer, NSMStationTypeId, DZSMStationTypeId, SMCTypeId,  CustomerBsPCode, CustomerBsPCodeInfo 
	            )
        VALUES  ( 
                  UPPER(@name) ,
                  UPPER(@address) ,
                  @phone ,
                  UPPER(@conPerson) ,
                  @termOfPayment ,
                  0 ,
				  @CustomerTypeId,
				  @userid,
				  GETDATE(),
				  0,'0' ,UPPER(@VoterID)
           ,UPPER(@TradeLicense) ,@Reamrks,UPPER(@conPerson),@GroupId,@RegionId,@AreaId,@TerritoryId,@SubTerritoryId, @marketId,@Latitude,@Longitude,@StreetAddress,@ProgramTypeId,@StationTypeId,@divId,@disId,@thanaId,1,0,@NSMStationTypeId,@DZSMStationTypeId, @SMCTypeId,@CustomerBsPCodeJust,@CustomerBsPCode
	            )


				DECLARE @Id INT
        SELECT  @Id=SCOPE_IDENTITY()

		


		 


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName
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

declare @entrydate datetime=getdate()
	
EXECUTE dbo.sp_webapi_SaveCustomerAppLog @CustomerApprovalId = 0,                         -- int
                                 @Date = @entrydate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Customer',                             -- nvarchar(max)
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
                                 @EntryDateS = @entrydate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @entrydate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 302                          -- int


    SELECT  @Id

    END

	END
	END

