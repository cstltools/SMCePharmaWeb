 
CREATE PROCEDURE [dbo].[sp_CS_GetMarket_ByTerritoryId_All]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		SELECT CASE WHEN IsActive=1 THEN   MarketName  ELSE   MarketName+' (Inactive)' END  MarketName,MarketId, * FROM dbo.tblMarket WITH (NOLOCK) WHERE   TerritoryId = @id
END
