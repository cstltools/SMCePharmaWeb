

 create PROCEDURE [dbo].[sp_GET_MIOInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select FORMAT(rsm.ActiveInActiveDate,'dd-MMM-yyyy') ActiveDateStr, rg.RegionId,rg.GroupId, ar.AreaId,  rsm.TerritoryId,* from tblMIOInfo rsm with (nolock)
	 left join tblTerritory tr on tr.TerritoryId=rsm.TerritoryId
	 left join tblArea ar on ar.AreaId=tr.AreaId
	 left join tblRegion rg on rg.RegionId=ar.RegionId
	  where rsm.MIOId = @id
      
    END


