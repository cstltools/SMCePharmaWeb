create PROCEDURE [dbo].[sp_Get_AreaAll_ByEmpID]
	-- Add the parameters for the stored procedure here
	@id NVARCHAR(MAX),
	@EmpId NVARCHAR(MAX)
AS
BEGIN
		
		SELECT   ar.AreaId, ar.AreaName ,'' AS Amount FROM dbo.tblArea ar WITH (NOLOCK)
		inner join tblASMInfo am on ar.AreaId=am.AreaId
		  where ar.IsActive=1 and am.IsActive=1 And RegionId= @id and   am.EmployeeId=@EmpId
END







