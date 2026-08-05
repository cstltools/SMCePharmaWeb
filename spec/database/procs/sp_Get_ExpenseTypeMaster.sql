
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ExpenseTypeMaster]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT ISNULL(ExpenseAmount,0) ExpenseAmount, isnull(rt.RoleType,'') RoleTypeName, ISNULL(emp.EmpMasterCode+' : '+ emp.EmpName,us.UserName) empName,  convert(varchar, A.EntryDate, 0)  EntryDate, (SELECT  dbo.GetRoleTypesFunc(A.RoleTypeMult)  ) RoleTypeMult ,  (SELECT  dbo.GetEmployeeNameFunc(A.EmpNameMult)  )  EmpNameMult,*	FROM [dbo].[tbl_ExpenseTypeMaster] A WITH (NOLOCK)
		 	  LEFT JOIN dbo.tblUser us ON us.UserId=A.EntryBy
		 	  LEFT JOIN dbo.tblRoleType rt ON rt.RoleTypeId=A.RoleType_xp
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=us.EmpInfoId


ORDER BY A.EntryDate DESC
 
END


