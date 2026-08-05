CREATE PROCEDURE [dbo].[sp_CS_GetEmpGeneralInfo_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
				SELECT  case  when  EmployeeStatus='Active'  then    EmpMasterCode+' : '+ EmpName  else   EmpMasterCode+' : '+ EmpName + ISNULL(' ('+EmployeeStatus+')','')  end AS EmpName, EmpInfoId	FROM dbo.tblEmpGeneralInfo   with (nolock) --where EmployeeStatus='Active'

				order by EmpMasterCode




				--SELECT EmpMasterCode+' : '+ EmpName AS EmpName, *	FROM dbo.tblEmpGeneralInfo   E
				--LEFT JOIN tblDistrictCoordinator DC ON DC.EmpInfoId=  E.EmpInfoId
				--LEFT JOIn tblUpazilaCoordinator UC ON UC.EmpInfoId = E.EmpInfoId
				
			

END
