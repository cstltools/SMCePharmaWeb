CREATE PROCEDURE [dbo].[sp_CS_GetMarket_ByTerritoryId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		SELECT * FROM dbo.tblMarket WHERE IsActive = 1 AND TerritoryId = @id
END


