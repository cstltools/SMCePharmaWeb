CREATE PROCEDURE [dbo].[sp_Get_ZoneListOrdPer]
	  
AS
BEGIN
	
	  SELECT
		 DPT.RegionId,	case when DPT.IsActive=0 then DPT.RegionCode+' : '+ DPT.RegionName +' (Inactive)'   else  DPT.RegionCode+' : '+ DPT.RegionName end  RegionName
		FROM tblRegion AS DPT with (nolock)  where DPT.IsActive=1   order by  DPT.RegionCode asc
	 
END