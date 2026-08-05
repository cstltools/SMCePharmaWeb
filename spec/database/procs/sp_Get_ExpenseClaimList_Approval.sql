
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ExpenseClaimList_Approval]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT  A.ExpenseClaimID,et.TypeName, CONVERT(NVARCHAR(50),A.ExpenseDate,106)AS ExpenseDate , emp.EmpName, emp.EmpMasterCode, *  
		  FROM dbo.tbl_ExpenseClaim A
		  LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=A.EmpInfoId
		  LEFT JOIN dbo.tbl_ExpenseType et ON et.ExpenseTypeId=A.ExpenseTypeId
		  where A.ApprovalStatus != 'Approved'

		  
		  --SELECT DegId,COUNT(DoctorDegId) AS S FROM tblDoctorDegreeDetail GROUP BY DegId
END


