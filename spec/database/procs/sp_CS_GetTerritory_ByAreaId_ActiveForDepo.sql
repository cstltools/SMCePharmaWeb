
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetTerritory_ByAreaId_ActiveForDepo]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		SELECT tr.TerritoryId, '('+tr.TerritoryCode+') '+ CASE WHEN mas.DCId IS NOT  NULL THEN  TerritoryName + ' : '+cu.ComUnitName ELSE TerritoryName END TerritoryName  FROM dbo.tblTerritory  tr with (nolock)
		LEFT JOIN dbo.tblDcWiseTerritoryDetail dtl  with (nolock) ON dtl.TerritoryId = tr.TerritoryId
		LEFT JOIN dbo.tblDcWiseTerritoryMaster mas  with (nolock) ON mas.DcWiseTerritoryMasterId = dtl.DcWiseTerritoryMasterId
		LEFT JOIN dbo.tblCompanyUnit cu  with (nolock) ON mas.DCId = cu.ComUnitId
		  WHERE IsActive = 1 AND tr.AreaId = @id
END


