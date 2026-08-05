

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_TerritoryWiseDepotSetupList]
    
	@Parameter NVARCHAR(MAX)


AS
BEGIN


   DECLARE @Query NVARCHAR(MAX)

   SET @Query = '   SELECT gr.GroupCode+''  : ''+ gr.GroupName GroupName, rg.RegionCode+'' : ''+ rg.RegionName  RegionName,ar.AreaCode+'' : ''+ ar.AreaName AreaName,terry.TerritoryCode +'' : ''+terry.TerritoryName TerritoryName,un.ComUnitCode +'' : ''+un.ComUnitName ComUnitName, sD.SubDepotCode+'' : ''+sD.SubDepotName SubDepotName FROM dbo.tblTerritory terry  WITH (nolock)
  INNER JOIN dbo.tblArea ar   WITH (nolock) ON ar.AreaId = terry.AreaId
        INNER JOIN dbo.tblRegion rg   WITH (nolock) ON rg.RegionId = ar.RegionId
        INNER JOIN dbo.tbl_Group gr   WITH (NOLOCK) ON gr.GroupId = rg.GroupId
        LEFT JOIN  tblDcWiseTerritoryDetail DDtl   WITH (nolock) ON DDtl.TerritoryId = terry.TerritoryId
        left JOIN  tblDcWiseTerritoryMaster DMas   WITH (nolock) ON DMas.DcWiseTerritoryMasterId = DDtl.DcWiseTerritoryMasterId


        left JOIN dbo.tblCompanyUnit un   WITH (nolock)  ON un.ComUnitId = DMas.DCId
        LEFT JOIN dbo.tblSubDepot sD   WITH (nolock)  ON sD.SubDepotId = DMas.SubDepotId ' + @Parameter

   EXEC(@Query)

END



