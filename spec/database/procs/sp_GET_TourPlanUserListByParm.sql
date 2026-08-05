Create PROCEDURE [dbo].[sp_GET_TourPlanUserListByParm] 
  @Parm NVARCHAR(Max)=NULL
	as

BEGIN


   declare @query nvarchar(max)=null
	set @query='SELECT Emp.EmpMasterCode, Emp.EmpName, Dg.DesigName FROM tbl_TourPlanMaster A with(nolock) 
	Left Join tblEmpGeneralInfo Emp On A.EmpInfoId = Emp.EmpInfoId
	LEft Join tblDesignation Dg On Emp.DesignationId = Dg.DesignationId
	where TPMaster Is Not NUll   '+@Parm+''
   	exec(@query) 


	--SELECT Emp.EmpMasterCode, Emp.EmpName, Dg.DesigName FROM tbl_TourPlanMaster A with(nolock) 
	--Left Join tblEmpGeneralInfo Emp On A.EmpInfoId = Emp.EmpInfoId
	--LEft Join tblDesignation Dg On Emp.DesignationId = Dg.DesignationId
	--where TPMaster Is Not NUll 

END

