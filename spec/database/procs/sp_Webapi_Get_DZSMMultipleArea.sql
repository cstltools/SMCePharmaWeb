CREATE PROCEDURE [dbo].[sp_Webapi_Get_DZSMMultipleArea]
	-- Add the parameters for the stored procedure here
	@AreId NVARCHAR(MAX)= NULL
	AS
    BEGIN


	declare    @PersonalEmpId nvarchar(max)
	
	select    RegionId from tblRSMInfo where EmployeeId in (select  EmployeeId from tblRSMInfo where RegionId=@AreId and IsActive=1)  and IsActive=1 order by RSMId asc
	 

	end
	 