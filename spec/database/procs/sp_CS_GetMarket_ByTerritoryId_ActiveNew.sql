create PROCEDURE [dbo].[sp_CS_GetMarket_ByTerritoryId_ActiveNew]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		SELECT MKT.MarketId MarketId, tr.SubTerritoryId SubTerritoryId,terry.TerritoryId TerritoryId,ar.AreaId AreaId,rg.RegionId RegionId,gp.GroupId GroupId  FROM dbo.tblMarket MKT
		 INNER JOIN dbo.tblSubTerritory tr   with (nolock) ON tr.SubTerritoryId = MKT.SubTerritoryId and tr.IsActive=1
        INNER JOIN dbo.tblTerritory terry   with (nolock) ON terry.TerritoryId = tr.TerritoryId and terry.IsActive=1
		  INNER JOIN dbo.tblArea ar   with (nolock) ON ar.AreaId = terry.AreaId and  ar.IsActive=1
        INNER JOIN dbo.tblRegion rg    with (nolock)ON rg.RegionId = ar.RegionId and rg.IsActive=1
        INNER JOIN dbo.tbl_Group gp   with (nolock) ON gp.GroupId = rg.GroupId and gp.IsActive=1
		WHERE MKT.IsActive = 1 AND terry.TerritoryId = @id
END


