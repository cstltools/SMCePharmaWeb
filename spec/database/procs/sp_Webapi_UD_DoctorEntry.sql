
CREATE PROCEDURE [dbo].[sp_Webapi_UD_DoctorEntry]
	-- Add the parameters for the stored procedure here
   @MasterId INT=NULL,
   @doctorName NVARCHAR(MAX) = NULL ,
   
    @remarks NVARCHAR(MAX) = NULL ,
    @entryBy INT = NULL ,
    @EntryDate DATETIME = NULL ,
   
    @contactTypeId INT = NULL ,
    @contactInfo NVARCHAR(MAX) = NULL ,
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
    @SMCTypeId INT = NULL ,
	@DoctorAddress NVARCHAR(MAX) = NULL
	--@SpecialDayId  INT = NULL ,
	--@SpeciaDateStr date = NULL 
AS
    BEGIN



	 DECLARE @userId int
		SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @entryBy
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

		  

		 

	UPDATE tblDoctorMaster
	SET DoctorName=@DoctorName ,
               
                  Remarks =@remarks,
                
                  UpdateBy=@userId ,
                  UpdateDate=GETDATE() ,
                
				 
				  DesignationId=@designaionId,
				 
				    GroupId=@GroupId,RegionId=@RegionId,AreaId=@AreaId,TerritoryId=@TerritoryId,SubTerritoryId=@SubTerritoryId, MarketId=@MarketId
       ,[UnionName]=@UnionName
      
      ,[StationTypeId]=@StationTypeId
      ,[ProgramTypeId]=@ProgramTypeId
      ,[DoctorCategoryId]=@DoctorCategoryId, DoctorTypeId=@DoctorTypeId,DivisionId=@divId,DistrictId=@disId,ThanaId=@thanaId, SMCTypeId=@SMCTypeId,DoctorAddress=@DoctorAddress
      
     
	WHERE DoctorId = @MasterId



	DELETE FROM tblDoctorMarketDetail WHERE DoctorId=@MasterId
	DELETE FROM tblDoctorSpecialDayDetail WHERE DoctorId=@MasterId

	DELETE FROM tblDoctorContactDetail WHERE DoctorId=@MasterId
	DELETE FROM dbo.tblDoctorDegreeDetail WHERE DoctorId=@MasterId
	DELETE FROM dbo.tblDoctorBrandDetail WHERE DoctorId=@MasterId
	DELETE FROM dbo.tblDoctorSpecialityDetail WHERE DoctorId=@MasterId
	DELETE FROM dbo.tblDoctorInstitutionDetail WHERE DoctorId=@MasterId
	DELETE FROM dbo.tblDoctorProgramTypeDetail WHERE DoctorId=@MasterId
	DELETE FROM dbo.tblDoctorChemberDetail WHERE DoctorId=@MasterId







	 IF ( @marketId IS NOT NULL )
            BEGIN
                INSERT  INTO dbo.tblDoctorMarketDetail
                        ( DoctorId, MarketId )
                VALUES  ( @MasterId, @marketId )
            END

			   --IF (@SpeciaDateStr IS  not NULL )
      --      BEGIN
      --          INSERT  INTO dbo.tblDoctorSpecialDayDetail
      --                  ( DoctorId, SpecialDayId,SpecialDate )
      --          VALUES  ( @MasterId, @SpecialDayId,@SpeciaDateStr )
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
        --        VALUES  ( @MasterId ,
        --                  @contactTypeId ,
        --                  @contactInfo
	       --             )
        --    END


 END
