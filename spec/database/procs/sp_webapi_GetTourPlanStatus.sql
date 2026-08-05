CREATE PROCEDURE [dbo].[sp_webapi_GetTourPlanStatus]
	-- Add the parameters for the stored procedure here
@empId INT=null,@month INT=null,@year INT=null
AS
BEGIN
			
			SELECT * FROM dbo.tbl_TourPlanMaster WHERE EmpInfoId = @empId AND MonthValue = @month AND YearValue = @year

END
