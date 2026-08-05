
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetMarket_BySubTerritoryId_Rpt]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
			SELECT  MarketId,MarketCode+' : '+ CASE WHEN IsActive=1 THEN   MarketName  ELSE   MarketName+' (Inactive)' END MarketName,  * FROM dbo.tblMarket with (nolock) WHERE   SubTerritoryId = @id

END


