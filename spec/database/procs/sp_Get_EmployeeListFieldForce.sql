CREATE PROCEDURE [dbo].[sp_Get_EmployeeListFieldForce]
    -- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT EmpInfoId,EGI.EmpMasterCode + ' : ' + EGI.EmpName AS EmployeeName FROM tblEmpGeneralInfo AS EGI  with (nolock)
   WHERE EmployeeStatus = 'Active'  
   AND EGI.EmpMasterCode IS NOT NULL
   -- AND EGI.EmpInfoId NOT IN (SELECT DISTINCT EmployeeId FROM tblNSMInfo AS NSM
   --WHERE NSM.IsActive = 1  UNION ALL SELECT DISTINCT EmployeeId FROM tblRSMInfo AS RSM
   --WHERE RSM.IsActive = 1  UNION ALL SELECT DISTINCT EmployeeId FROM tblASMInfo AS ASM
   --WHERE ASM.IsActive = 1  UNION ALL SELECT DISTINCT EmployeeId FROM tblMIOInfo AS MIO
   --WHERE MIO.IsActive = 1 )
   
    

   order by  EGI.EmpMasterCode asc
    

END

