-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_MileageClaim]
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
	 
    
    @UpdatedBy NVARCHAR(50)  ,

	 @GroupId INT=NULL
      ,@RegionId INT=NULL
      ,@AreaId INT=NULL
      ,@TerritoryId INT=NULL
      ,@SubTerritoryId INT=NULL
AS
    BEGIN

      UPDATE [dbo].[tbl_MileageClaim]
   SET [MileageDate] = @MileageDate 
      ,[TransportId] = @TransportId 
      ,[MileageInKM] = @MileageInKM 
      ,[MeterReading] = @MeterReading 
   
     
      ,[Remarks] = @Remarks 
      ,[EmpInfoId] = @EmpInfoId 
      
      
      ,[UpdatedBy] = @UpdatedBy 
      ,[UpdatedDate] = GETDATE(),
         [GroupId] = @GroupId 
      ,[RegionId] = @RegionId 
      ,[AreaId] = @AreaId 
      ,[TerritoryId] = @TerritoryId 
      ,[SubTerritoryId] = @SubTerritoryId 
      ,[MarketId] = @MarketId 
     
      ,[TourTypeId] = @TourTypeId 
      
 WHERE MileageClaimId=@MileageClaimId
    END


