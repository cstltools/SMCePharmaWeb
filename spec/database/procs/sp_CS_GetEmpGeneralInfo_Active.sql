CREATE PROCEDURE [dbo].[sp_CS_GetEmpGeneralInfo_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT   EmpMasterCode+' : '+ EmpName AS EmpName, EmpInfoId	FROM dbo.tblEmpGeneralInfo   with (nolock) where EmployeeStatus='Active'




				--SELECT EmpMasterCode+' : '+ EmpName AS EmpName, *	FROM dbo.tblEmpGeneralInfo   E
				--LEFT JOIN tblDistrictCoordinator DC ON DC.EmpInfoId=  E.EmpInfoId
				--LEFT JOIn tblUpazilaCoordinator UC ON UC.EmpInfoId = E.EmpInfoId
				
			

END
