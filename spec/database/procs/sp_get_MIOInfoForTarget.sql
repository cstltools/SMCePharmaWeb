

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_MIOInfoForTarget]
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN
		 
	SELECT mas.MIOId, emp.CompanyId, emp.EmpName FROM tblMIOInfo mas
	LEFT JOIN dbo.tblEmpGeneralInfo emp ON mas.EmployeeId=emp.EmpInfoId
	 WHERE IsActive=1

END



