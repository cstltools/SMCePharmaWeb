create PROCEDURE [dbo].[sp_Get_GroupListOrdPer]
	  
AS
BEGIN
	
	  SELECT
		 DPT.GroupId,	case when DPT.IsActive=0 then DPT.GroupCode+' : '+ DPT.GroupName +' (Inactive)'   else  DPT.GroupCode+' : '+ DPT.GroupName end  GroupName
		FROM tbl_Group AS DPT with (nolock)  where DPT.IsActive=1   order by  DPT.GroupCode asc
	 
END

 