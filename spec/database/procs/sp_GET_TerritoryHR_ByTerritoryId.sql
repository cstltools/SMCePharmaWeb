

 create PROCEDURE [dbo].[sp_GET_TerritoryHR_ByTerritoryId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select rg.GroupId,rg.RegionId, ar.AreaId  from tblTerritory tr with(nolock)
left join tblArea ar with(nolock)   on tr.AreaId=ar.AreaId
left join tblRegion rg with(nolock)   on rg.RegionId=ar.RegionId




where TerritoryId=@id
      
    END


