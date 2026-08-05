

 create PROCEDURE [dbo].[sp_GET_DZSMInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select FORMAT(rsm.ActiveDate,'dd-MMM-yyyy') ActiveDateStr, rg.RegionId,rg.GroupId,  * from tblRSMInfo rsm with (nolock)
	 left join tblRegion rg on rg.RegionId=rsm.RegionId
	  where rsm.RSMId = @id
      
    END


