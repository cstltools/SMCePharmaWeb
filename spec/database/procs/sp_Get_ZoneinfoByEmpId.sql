
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ZoneinfoByEmpId]
	-- Add the parameters for the stored procedure here

	@EmpId INT

AS
BEGIN
	
	 

	select distinct rg.GroupId, rg.RegionId,am.AreaId from tblASMInfo am   with (nolock) 
inner join tblArea Ar   with (nolock)  on am.AreaId=Ar.AreaId
inner join tblRegion rg   with (nolock)  on rg.RegionId=Ar.RegionId

 where am.IsActive=1 and EmployeeId=@EmpId
END



