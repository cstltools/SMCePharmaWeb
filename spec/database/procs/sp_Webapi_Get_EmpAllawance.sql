CREATE

 PROCEDURE [dbo].[sp_Webapi_Get_EmpAllawance]
	-- Add the parameters for the stored procedure here

	@EmpInfoId nvarchar(max) 

AS
BEGIN 
select emp.EmpMasterCode, al.EmpInfoId, ISNULL(mas.MonthlyAllowance,0) MonthlyAllowance, mas.MonthlyAllowanceName from tbl_MonthlyAllowance mas 
inner join tbl_MonthlyAllowanceDetail al on mas.MonthlyAllowanceId=al.MonthlyAllowanceId
inner join tblEmpGeneralInfo emp on al.EmpInfoId=emp.EmpInfoId
WHERE al.EmpInfoId in( select * from fnSplit(@EmpInfoId,',')) and mas.IsActive=1

END