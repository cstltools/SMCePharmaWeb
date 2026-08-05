

 CREATE PROCEDURE [dbo].[sp_GET_ASMInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select FORMAT(rsm.ActiveInActiveDate,'dd-MMM-yyyy') ActiveDateStr, rg.RegionId,rg.GroupId, rsm.AreaId, * from tblASMInfo rsm with (nolock)
	 left join tblArea ar on ar.AreaId=rsm.AreaId
	 left join tblRegion rg on rg.RegionId=ar.RegionId
	  where rsm.ASMId = @id
      
    END


