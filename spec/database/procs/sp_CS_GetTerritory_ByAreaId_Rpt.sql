
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetTerritory_ByAreaId_Rpt]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		SELECT  TerritoryId,TerritoryCode+' : '+  CASE WHEN IsActive=1 THEN   TerritoryName  ELSE   TerritoryName+' (Inactive)' END  TerritoryName  FROM dbo.tblTerritory WITH (NOLOCK) WHERE  AreaId = @id
END


