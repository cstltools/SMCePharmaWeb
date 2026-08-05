
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetSubTerritory_ByTerritoryId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
			SELECT SubTerritoryId,SubTerritoryCode+' : '+SubTerritoryName SubTerritoryName FROM dbo.tblSubTerritory with (nolock) WHERE IsActive = 1 AND TerritoryId = @id

END


