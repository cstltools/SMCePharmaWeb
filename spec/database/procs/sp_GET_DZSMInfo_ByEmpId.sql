

 CREATE PROCEDURE [dbo].[sp_GET_DZSMInfo_ByEmpId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select rsm.RSMId, FORMAT(rsm.ActiveDate,'dd MMMM, yyyy') ActiveDateStr, rg.RegionId,rg.GroupId,  * from tblRSMInfo rsm with (nolock)
	 left join tblRegion rg on rg.RegionId=rsm.RegionId
	  where rsm.EmployeeId = @id and rsm.IsActive=1
      
    END


