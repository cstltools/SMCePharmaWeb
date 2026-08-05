CREATE PROCEDURE [dbo].[sp_Get_TerritoryListOrdPerALL]
	 	 
AS
BEGIN
	
	  SELECT
		 DPT.TerritoryId,	case when DPT.IsActive=0 then DPT.TerritoryCode+ ' : '+ DPT.TerritoryName +' (Inactive)'   else  DPT.TerritoryCode+ ' : '+ DPT.TerritoryName end  TerritoryName
		FROM tblTerritory AS DPT  with (nolock) where  DPT.IsActive=1  order by  DPT.TerritoryCode asc
	 
END