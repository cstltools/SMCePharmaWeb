
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_TadaClaimMaster]
	-- Add the parameters for the stored procedure here
    @TadaID INT = 0 ,
    @TadaDate datetime ,
    @Remarks NVARCHAR(MAX) ,
    @TourTypeId int ,
    @EmpInfoId int ,
    @GroupId int ,
    @RegionId int ,
    @AreaId int ,
    @TerritoryId int ,
    @SubTerritoryId int ,
    @MarketId int ,
    @HotelName NVARCHAR(MAX) ,
    @HotelPhone NVARCHAR(MAX) ,
	@DAAmount Decimal(18,2),
    @UpdateBy NVARCHAR(50)

AS
    BEGIN
 UPDATE [dbo].[tbl_TadaClaimMaster]
   SET [TadaDate] = @TadaDate 
      ,[Remarks] = @Remarks 
      
      ,[UpdateBy] = @UpdateBy 
      ,[UpdateDate] = getdate()
      ,[ApprovalStatus] ='2'
      ,[EmpInfoId] = @EmpInfoId 
      ,[ApprovedBy] = @UpdateBy 
      ,[ApprovedDate] =getdate() 
      ,[GroupId] = @GroupId 
      ,[RegionId] = @RegionId 
      ,[AreaId] = @AreaId 
      ,[TerritoryId] = @TerritoryId 
      ,[SubTerritoryId] = @SubTerritoryId 
      ,[MarketId] = @MarketId 
      ,[DAAmount] = @DAAmount 
      ,[TourTypeId] = @TourTypeId 
      ,[HotelName] = @HotelName 
      ,[HotelPhone] = @HotelPhone 
 WHERE  TadaID=@TadaID   

    END

