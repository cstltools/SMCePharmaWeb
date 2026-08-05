create PROCEDURE [dbo].[sp_Get_AreaListOrdPerALL]
	 	 
AS
BEGIN
	
	  SELECT
		 DPT.AreaId,	case when DPT.IsActive=0 then DPT.AreaCode+ ' : '+ DPT.AreaName +' (Inactive)'   else  DPT.AreaCode+ ' : '+ DPT.AreaName end  AreaName
		FROM tblArea AS DPT  with (nolock) where  DPT.IsActive=1  order by  DPT.AreaCode asc
	 
END