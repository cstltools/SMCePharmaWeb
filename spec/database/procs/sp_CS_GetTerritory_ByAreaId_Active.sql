
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetTerritory_ByAreaId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		SELECT TerritoryId,TerritoryCode+' : '+ TerritoryName TerritoryName FROM dbo.tblTerritory  with (nolock)  WHERE IsActive = 1 AND AreaId = @id
END


