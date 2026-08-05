create View [dbo].[view_EmpList]
as
select Emp.EmpMasterCode, Emp.EmpName, emp.PhoneNo  from tblEmpGeneralInfo emp
