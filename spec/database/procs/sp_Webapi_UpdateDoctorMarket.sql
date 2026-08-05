
create PROCEDURE [dbo].[sp_Webapi_UpdateDoctorMarket]
	-- Add the parameters for the stored procedure here
     @empId INT = NULL ,
    
    @TGroupId int = NULL,
    @TZoneId int = NULL,
    @TAreaId int = NULL,
    @TTeritoryId int = NULL,
    @TSTeritoryId  int = NULL,
    
    @TMarketId  int = NULL,
    @DoctorId int = NULL
AS
    BEGIN




		DECLARE @GroupId INT=0, @RegionId int =0, @AreaId int =0 , @TerritoryId int =0, @SubTerritoryId int =0, @MarketId int=0
	SELECT @GroupId=GroupId,@RegionId=RegionId,@AreaId=AreaId,@TerritoryId=TerritoryId, @SubTerritoryId=SubTerritoryId , @MarketId=MarketId  FROM dbo.tblDoctorMaster   WHERE   DoctorId = @DoctorId

		DECLARE @MasterId INT=0
	SELECT @MasterId=UserId FROM dbo.tblUser WHERE EmpInfoId = @empId

INSERT INTO [dbo].[tblDoctorUpdateMarketLog]
           ([GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[TGroupId]
           ,[TRegionId]
           ,[TAreaId]
           ,[TTerritoryId]
           ,[TSubTerritoryId]
           ,[TMarketId]
           ,[UpdateBy]
           ,[UpdateDate],DoctorId)
     VALUES
           (@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId 
           ,@TGroupId 
           ,@TZoneId 
           ,@TAreaId 
           ,@TTeritoryId 
           ,@TSTeritoryId 
           ,@TMarketId 
           ,@MasterId 
           ,GETDATE(),@DoctorId)

        UPDATE  dbo.tblDoctorMaster
        SET  IsMarketUpdate2022=1,  GroupId=@TGroupId, RegionId=@TZoneId, AreaId=@TAreaId,   TerritoryId=@TTeritoryId,    SubTerritoryId=@TSTeritoryId,    MarketId=@TMarketId, UpdateBy=@MasterId, UpdateDate=GETDATE()
        WHERE      DoctorId = @DoctorId
                
					 

    END

