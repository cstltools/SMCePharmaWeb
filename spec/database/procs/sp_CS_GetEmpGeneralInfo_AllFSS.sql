CREATE PROCEDURE [dbo].[sp_CS_GetEmpGeneralInfo_AllFSS]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
				SELECT  case  when  EmployeeStatus='Active'  then    EmpMasterCode+' : '+ EmpName  else   EmpMasterCode+' : '+ EmpName + ISNULL(' ('+EmployeeStatus+')','')  end AS EmpName, emp.EmpInfoId	FROM dbo.tblEmpGeneralInfo  emp  with (nolock)
				left JOIN dbo.tblUser UR  with (nolock) ON UR.EmpInfoId = emp.EmpInfoId
			  left join tbl_UserRoleInfo uRR  with (nolock) on uRR.UserRoleID=UR.UserRoleID
			  left join tblRoleType Rtp  with (nolock) on uRR.RoleTypeId=Rtp.RoleTypeId
				where   Rtp.RoleTypeId in (1,
2,
3,4)   

				order by EmpMasterCode




				--SELECT EmpMasterCode+' : '+ EmpName AS EmpName, *	FROM dbo.tblEmpGeneralInfo   E
				--LEFT JOIN tblDistrictCoordinator DC ON DC.EmpInfoId=  E.EmpInfoId
				--LEFT JOIn tblUpazilaCoordinator UC ON UC.EmpInfoId = E.EmpInfoId
				
			

END
