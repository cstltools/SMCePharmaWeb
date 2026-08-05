CREATE PROCEDURE [dbo].[sp_CS_MIOInfo_Rpt]
	-- Add the parameters for the stored procedure here

AS
BEGIN
 
		
		SELECT emp.EmpInfoId ValueId,emp.EmpMasterCode+' : '+  CASE WHEN mas.IsActive=1 THEN   emp.EmpName  ELSE   emp.EmpName+' (Inactive)' END  TextName  FROM dbo.tblMIOInfo mas  with(nolock)
		INNER JOIN dbo.tblEmpGeneralInfo emp ON mas.EmployeeId=emp.EmpInfoId

		where mas.IsActive=1
END
