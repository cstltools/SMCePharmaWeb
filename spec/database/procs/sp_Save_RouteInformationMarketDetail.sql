-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_RouteInformationMarketDetail]
	-- Add the parameters for the stored procedure here
	 

@RouteInformationMasterId  INT,
@GroupId  INT,
@RegionId  INT,
@AreaId  INT,
@TerritoryId  INT,
@SubTerritoryId  INT,
@MarketId  INT,
@Distance decimal(18,2)
AS
    BEGIN
	
    INSERT INTO [dbo].[tblRouteInformationMarketDetail]
           (RouteInformationMasterId
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId],Distance)
     VALUES
           (@RouteInformationMasterId 
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId,@Distance )

 

END

