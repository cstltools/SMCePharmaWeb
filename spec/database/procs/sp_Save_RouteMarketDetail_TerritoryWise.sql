CREATE PROCEDURE [dbo].[sp_Save_RouteMarketDetail_TerritoryWise]
	@RouteInformationMasterId  INT,
	@GroupId  INT,
	@RegionId  INT,
	@AreaId  INT,
	@TerritoryId  INT,
	@SubTerritoryId  INT,
	@MarketId  INT,
	@Distance decimal(18,2)=0
AS
BEGIN
    SET NOCOUNT ON;

    -- যদি MarketId আগে থেকেই থাকে, তাহলে সেটা delete করা হচ্ছে
    IF EXISTS (SELECT 1 FROM [dbo].[tblRouteInformationMarketDetail] WHERE MarketId = @MarketId)
    BEGIN
        DELETE FROM [dbo].[tblRouteInformationMarketDetail]
        WHERE MarketId = @MarketId
    END

    -- নতুন record insert করা হচ্ছে
    INSERT INTO [dbo].[tblRouteInformationMarketDetail]
           (RouteInformationMasterId
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,Distance)
     VALUES
           (@RouteInformationMasterId 
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId
           ,@Distance)
END