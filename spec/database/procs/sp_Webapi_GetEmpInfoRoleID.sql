-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_GetEmpInfoRoleID]
	-- Add the parameters for the stored procedure here
	@empId int
AS
BEGIN



--SELECT case when  u.EmpInfoId is null then LoginName else   EmpName end EmpName, emp.EmpMasterCode, emp.EmpInfoId, u.UserRoleID FROM dbo.tblUser u with (nolock) 
--inner  join tblEmpGeneralInfo emp with (nolock)  on u.EmpInfoId=    emp.EmpInfoId
--inner  join tbl_UserRoleInfo uri with (nolock)  on u.UserRoleID=    uri.UserRoleID
--where u.UserStatus='Active'  and uri.RoleTypeId<>'2' and uri.RoleTypeId<>'3' and uri.RoleTypeId<>'4'
-- AND emp.EmpInfoId<>@empId

 SELECT case when  u.EmpInfoId is null then LoginName else   EmpName end EmpName, emp.EmpMasterCode, emp.EmpInfoId, u.UserRoleID FROM dbo.tblUser u with (nolock) 
inner  join tblEmpGeneralInfo emp with (nolock)  on u.EmpInfoId=    emp.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs on emp.EmpInfoId=fs.EmpInfoId
inner  join tbl_UserRoleInfo uri with (nolock)  on u.UserRoleID=    uri.UserRoleID
where u.UserStatus='Active'  and uri.RoleTypeId<>'2' and uri.RoleTypeId<>'3' and uri.RoleTypeId<>'4'
 AND emp.EmpInfoId<>@empId and (fs.MIOEmpId=@empId  or fs.ASMEMPId=@empId  or fs.RSMEMPId=@empId  or fs.NSMEMPId=@empId)


union all

select distinct ASMName EmpName, ASM EmpMasterCode,ASMEMPId EmpInfoId, u.UserRoleID from View_webapi_FieldForce   vvv
inner join tblUser u on u.EmpInfoId=vvv.ASMEMPId
 where MIOEmpId=@empId

union all

select distinct RSMName EmpName, RSMCode EmpMasterCode,RSMEMPId EmpInfoId, u.UserRoleID from View_webapi_FieldForce   vvv
inner join tblUser u on u.EmpInfoId=vvv.RSMEMPId
 where  MIOEmpId=@empId

union all


select distinct NSMName EmpName, NSMCode EmpMasterCode,NSMEMPId EmpInfoId, u.UserRoleID from View_webapi_FieldForce   vvv
inner join tblUser u on u.EmpInfoId=vvv.NSMEMPId
 where  MIOEmpId=@empId


UNION ALL 

SELECT case when  u.EmpInfoId is null then LoginName else   EmpName end EmpName, emp.EmpMasterCode, emp.EmpInfoId, u.UserRoleID FROM dbo.tblUser u with (nolock) 
inner  join tblEmpGeneralInfo emp with (nolock)  on u.EmpInfoId=    emp.EmpInfoId
where u.UserStatus='Active' AND emp.EmpInfoId=@empId

END

