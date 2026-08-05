CREATE PROCEDURE [dbo].[sp_Webapi_Get_AMMultipleArea]
	-- Add the parameters for the stored procedure here
	@AreId NVARCHAR(MAX)= NULL
	AS
    BEGIN


	declare    @PersonalEmpId nvarchar(max)
	select @PersonalEmpId=EmployeeId from tblASMInfo where areaid=@AreId
	select     AreaId from tblASMInfo where EmployeeId in (select  EmployeeId from tblASMInfo where areaid=@AreId AND IsActive=1)  and IsActive=1 order by ASMId asc
	 

	end