
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_EmployeeMIO]
	-- Add the parameters for the stored procedure here
 
AS
BEGIN
   
   SELECT DISTINCT NSM.EmployeeId EmpInfoId,emp.EmpMasterCode + ' : ' + emp.EmpName +ISNULL( case when  NSM.IsActive=0 then ' [Inactive]' else '' end  ,'') AS EmployeeName FROM tblMIOInfo AS NSM with (nolock)
	INNER JOIN tblEmpGeneralInfo emp with (nolock) ON NSM.EmployeeId=emp.EmpInfoId 

	 

   
    

END


