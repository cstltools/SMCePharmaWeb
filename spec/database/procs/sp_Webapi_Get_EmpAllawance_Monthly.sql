create
 PROCEDURE [dbo].[sp_Webapi_Get_EmpAllawance_Monthly]
	-- Add the parameters for the stored procedure here

	@empId nvarchar(max) 

AS
BEGIN 


select  STUFF( (SELECT CONCAT(CHAR(10), mm.MonthlyAllowanceName+' : '+ CAST(ISNULL(mm.MonthlyAllowance,0) as nvarchar(max)) , '') FROM tbl_MonthlyAllowance  mm (NOLOCK) INNER JOIN dbo.tbl_MonthlyAllowanceDetail mgd ON mgd.MonthlyAllowanceId=mm.MonthlyAllowanceId WHERE mgd.EmpInfoId =@empId and IsActive=1   ORDER BY mgd.MonthlyAllowanceDetailId FOR XML PATH ('') ),1,1,'') AS Allowences  



END