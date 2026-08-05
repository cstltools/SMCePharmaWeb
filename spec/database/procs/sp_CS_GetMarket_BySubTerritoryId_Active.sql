
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetMarket_BySubTerritoryId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
			SELECT MarketId,MarketCode+' : '+MarketName MarketName  FROM dbo.tblMarket with (nolock) WHERE IsActive = 1 AND SubTerritoryId = @id

END


