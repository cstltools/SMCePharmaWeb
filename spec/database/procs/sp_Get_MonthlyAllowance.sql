CREATE PROCEDURE [dbo].[sp_Get_MonthlyAllowance]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   Select ISNULL(emp.EmpMasterCode+' : '+ emp.EmpName,us.UserName) empName,  convert(varchar, A.EntryDate, 0)  EntryDate, * from tbl_MonthlyAllowance A
     LEFT JOIN dbo.tblUser us ON us.UserId=A.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=us.EmpInfoId
		 
END
