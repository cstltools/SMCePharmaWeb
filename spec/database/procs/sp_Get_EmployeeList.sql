
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_EmployeeList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT EmpInfoId,EGI.EmpMasterCode + ' : ' + EGI.EmpName AS EmployeeName FROM tblEmpGeneralInfo AS EGI  with (nolock)
   WHERE EmployeeStatus = 'Active'  order by  EGI.EmpMasterCode asc
   --AND EGI.EmpMasterCode IS NOT NULL 
   -- AND EGI.EmpInfoId NOT IN (SELECT DISTINCT EmployeeId FROM tblNSMInfo AS NSM
   --WHERE NSM.IsActive = 1 AND NSM.EmployeeId != 1) 
   --AND EGI.EmpInfoId NOT IN (SELECT DISTINCT EmployeeId FROM tblRSMInfo AS RSM
   --WHERE RSM.IsActive = 1 AND RSM.EmployeeId != 1) 
   --AND EGI.EmpInfoId NOT IN (SELECT DISTINCT EmployeeId FROM tblASMInfo AS ASM
   --WHERE ASM.IsActive = 1 AND ASM.EmployeeId != 1)
   --AND EGI.EmpInfoId NOT IN (SELECT DISTINCT EmployeeId FROM tblMIOInfo AS MIO
   --WHERE MIO.IsActive = 1 AND MIO.EmployeeId != 1) 
    

END


