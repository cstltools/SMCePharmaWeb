CREATE FUNCTION dbo.GetEmployeeNameFunc
(
    @EmployeeIds VARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @EmpNames NVARCHAR(MAX);
 

	   SELECT @EmpNames= COALESCE(@EmpNames + ', ', '') + case  when  EmployeeStatus='Active'  then    EmpMasterCode+' : '+ EmpName  else   EmpMasterCode+' : '+ EmpName + ISNULL(' ('+EmployeeStatus+')','')  end  	FROM dbo.tblEmpGeneralInfo  emp  with (nolock)
				left JOIN dbo.tblUser UR  with (nolock) ON UR.EmpInfoId = emp.EmpInfoId
				 WHERE emp.EmpInfoId IN (SELECT * FROM dbo.fnSplit(@EmployeeIds, ','));

				 return @EmpNames
END
