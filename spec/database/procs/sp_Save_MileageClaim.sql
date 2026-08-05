-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_MileageClaim]
	-- Add the parameters for the stored procedure here
	@MileageClaimId INT,
    @MileageDate DATETIME,
	@TransportId INT=NULL,
	@MileageInKM DECIMAL,
    @MeterReading DECIMAL,
	@Remarks  NVARCHAR(MAX),
	@EmpInfoId  INT=NULL,
	@MarketId INT=NULL,
	@TourTypeId INT=NULL,
	--@MileageImage  NVARCHAR(MAX),
	@EntryBy  NVARCHAR(MAX),

	 @GroupId INT=NULL
      ,@RegionId INT=NULL
      ,@AreaId INT=NULL
      ,@TerritoryId INT=NULL
      ,@SubTerritoryId INT=NULL





AS
    BEGIN

 
INSERT INTO [dbo].[tbl_MileageClaim]
           ([MileageDate]
           ,[TransportId]
           ,[MileageInKM]
           ,[MeterReading]
        
      
           ,[Remarks]
           ,[EmpInfoId]
           ,[ApprovalStatus]
           ,[EntryBy]
           ,[EntryDate]
       ,[GroupId]
      ,[RegionId]
      ,[AreaId]
      ,[TerritoryId]
      ,[SubTerritoryId]
           ,[MarketId]
           ,[TourTypeId] 
          )
     VALUES
           (@MileageDate 
           ,@TransportId 
           ,@MileageInKM 
           ,@MeterReading 
          
         
           ,@Remarks 
           ,@EmpInfoId 
           ,'0'
           ,@EntryBy 
           ,GETDATE()
          ,@GroupId
      ,@RegionId
      ,@AreaId
      ,@TerritoryId
      ,@SubTerritoryId
            
           ,@MarketId 
           ,@TourTypeId 
            )
SELECT SCOPE_IDENTITY()
 
 
	
 
		
END


