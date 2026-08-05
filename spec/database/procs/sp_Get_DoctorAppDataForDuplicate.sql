
create PROCEDURE [dbo].[sp_Get_DoctorAppDataForDuplicate]
	-- Add the parameters for the stored procedure here

	@DoctorId INT

AS
BEGIN
SELECT top 1 case when DM.ApprovalStatus='0' then 'Pending'  when DM.ApprovalStatus='1' then 'Verified' when DM.ApprovalStatus='2' then 'Approved' when DM.ApprovalStatus='3' then 'Rejected'  else DM.ApprovalStatus end ApprovalStatusWeb,  mr.MarketName, CONVERT(NVARCHAR(50),DM.EntryDate,106)AS EntryDate,  dgs.DesignationName DesigName,     DM.DoctorName,    STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeName,  STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm (NOLOCK) INNER JOIN dbo.tblDoctorSpecialityDetail mgd ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') as DoctorSpeciality ,  STUFF( (SELECT CONCAT(',', mm.ProgramType , '') FROM tblDoctorProgramType mm with (NOLOCK) INNER JOIN dbo.tblDoctorProgramTypeDetail mgd ON mgd.ProgramTypeId=mm.ProgramTypeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd. DoctorTypeDetailId FOR XML PATH ('') ),1,1,'') as ProgramType,  tblEmpGeneralInfo.EmpInfoId,DM.DoctorId,
       DoctorName ,
                  DoctorCode ,
                  Remarks ,
          FORMAT(DM.EntryDate,'dd MMM yyyy') EntryDate,
       
       DM.ApprovalStatus,
       
       
       tblDoctorApprovalLog_New.DoctorApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblDoctorApprovalLog_New.TableId,
       tblDoctorApprovalLog_New.Status,
       Comments,
       Type,
       Step,
       tblDoctorApprovalLog_New.GroupId,
       tblDoctorApprovalLog_New.RegionId,
       tblDoctorApprovalLog_New.AreaId,
       tblDoctorApprovalLog_New.TerritoryId,
       
       tblDoctorApprovalLog_New.RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 AreaName,
                                 RegionCode,
                                 RegionName,
                                 GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep 
								 ,tblRoleType.RoleType AS WaitingRole,'' AS WatingEmployee
	   
	   
	   FROM dbo.tblDoctorMaster DM
	     
LEFT JOIN dbo.tblDoctorApprovalLog_New ON dbo.tblDoctorApprovalLog_New.TableId=DM.DoctorId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDoctorApprovalLog_New  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDoctorApprovalLog_New.TableId
left join tblUser on tblUser.UserId=DM.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId

 Left Join dbo.tblDoctorDesignation dgs  with (NOLOCK)  ON dgs.DesignationId= DM.DesignationId
   Left Join dbo.tblDoctorProgramType pt  with (NOLOCK)  ON pt.ProgramTypeId= DM.ProgramType
    left join  tblMarket mr on DM.MarketId=mr.MarketId

	 left join (select TableId,RoleTypeId from tblDoctorApprovalLog_New  with (nolock) where Step=1) as tblrole on DM.DoctorId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE  

   DM.DoctorId=@DoctorId

order by tblDoctorApprovalLog_New.DoctorApprovalId desc
end