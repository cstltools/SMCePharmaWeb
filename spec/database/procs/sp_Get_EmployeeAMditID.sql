



CREATE PROCEDURE [dbo].[sp_Get_EmployeeAMditID]
    -- Add the parameters for the stored procedure here
    @Id int
AS
BEGIN

select DISTINCT * from (
   
   SELECT EmpInfoId,EGI.EmpMasterCode + ' : ' + EGI.EmpName AS EmployeeName FROM tblEmpGeneralInfo AS EGI  with (nolock)
   WHERE EmployeeStatus = 'Active'  
   AND EGI.EmpMasterCode IS NOT NULL
    AND EGI.EmpInfoId NOT IN (SELECT DISTINCT EmployeeId FROM tblNSMInfo AS NSM
   WHERE NSM.IsActive = 1  UNION ALL SELECT DISTINCT EmployeeId FROM tblRSMInfo AS RSM
   WHERE RSM.IsActive = 1
   -- UNION ALL SELECT DISTINCT EmployeeId FROM tblASMInfo AS ASM  WHERE ASM.IsActive = 1
     UNION ALL SELECT DISTINCT EmployeeId FROM tblMIOInfo AS MIO
   WHERE MIO.IsActive = 1 )
   
    UNION ALL SELECT DISTINCT NSM.EmployeeId EmpInfoId,emp.EmpMasterCode + ' : ' + emp.EmpName AS EmployeeName FROM tblASMInfo AS NSM
    INNER JOIN tblEmpGeneralInfo emp ON NSM.EmployeeId=emp.EmpInfoId

    WHERE NSM.ASMId=@Id) tbl

   
    

END



