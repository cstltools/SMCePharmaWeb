
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_DZSMinfoByEmpId]
	-- Add the parameters for the stored procedure here

	@EmpId INT

AS
BEGIN
	
	 

	select distinct rg.GroupId, rg.RegionId from tblRSMInfo am   with (nolock) 
 inner join tblRegion rg   with (nolock)  on rg.RegionId=am.RegionId

 where am.IsActive=1 and rg.IsActive=1 and EmployeeId=@EmpId
END



