CREATE PROCEDURE [dbo].[sp_Webapi_Get_MarketByTerritoryId]
	-- Add the parameters for the stored procedure here
@territoryId INT = NULL
AS
BEGIN
		
		SELECT * FROM dbo.tblMarket WHERE TerritoryId = @territoryId AND IsActive = 1
		 

END
