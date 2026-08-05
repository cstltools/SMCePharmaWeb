
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetSubTerritory_ByTerritoryId_Rpt]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
			SELECT  SubTerritoryId,SubTerritoryCode+' : '+CASE WHEN IsActive=1 THEN   SubTerritoryName  ELSE   SubTerritoryName+' (Inactive)' END  SubTerritoryName  FROM dbo.tblSubTerritory with (nolock) WHERE  TerritoryId = @id

END


