CREATE PROCEDURE [dbo].[sp_CS_NSMInfo_Rpt]
	-- Add the parameters for the stored procedure here

AS
BEGIN
 
		
		SELECT mas.EmployeeId ValueId,emp.EmpMasterCode+' : '+  CASE WHEN mas.IsActive=1 THEN   emp.EmpName  ELSE   emp.EmpName+' (Inactive)' END  TextName  FROM dbo.tblNSMInfo mas  with(nolock)
		INNER JOIN dbo.tblEmpGeneralInfo emp ON mas.EmployeeId=emp.EmpInfoId


END
