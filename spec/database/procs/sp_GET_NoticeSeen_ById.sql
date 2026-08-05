

 create PROCEDURE [dbo].[sp_GET_NoticeSeen_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select  emp.EmpName +' ('+emp.EmpMasterCode+') - at '+ FORMAT(dtl.Server_SeenDate,'dd MMM, yyyy hh:mm tt') EmpName from [dbo].tblNotice_Employee dtl with (nolock)
	left join tblEmpGeneralInfo emp  with (nolock) on   dtl.EmployeeId=emp.EmpInfoId
	 
	 where dtl.IsAppCheck=1 and dtl.MasterId= @id
      
    END


