-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Get_DCRInfoListForView]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
 
    DECLARE @Query NVARCHAR(MAX)

 SET @Query = '
SELECT DCR.StreetAddress,  docMas.DoctorAddress, STUFF( (SELECT CONCAT('','', mgd.EmpMasterCode +'' : ''+mgd.EmpName , '''') FROM tbl_DcrVisitedWithDetails mm (NOLOCK) INNER JOIN dbo.tblEmpGeneralInfo mgd ON mgd.EmpInfoId=mm.EmpInfoId WHERE mm.DcrId=DCR.DcrId ORDER BY mm.DcrVisitWithId FOR XML PATH ('''') ),1,1,'''') AS VisitedWith, DCR.Latitude  +'',''+ DCR.Longitude AS POutLoc, case when DCR.ApprovalStatus=''0'' then ''Pending''  when DCR.ApprovalStatus=''1'' then ''Verified''  when DCR.ApprovalStatus=''2'' then ''Approved''  WHEN DCR.ApprovalStatus=''3'' then ''Rejected''  else DCR.ApprovalStatus end ApprovalStatus, tt.VisitTypeName TourTypeName,cham.Name ChamberName,    docMas.DoctorCode +'' : ''+  docMas.DoctorName DoctorName,  usr.RoleName, dgs.DesigName, dtl.EmpMasterCode, dtl.EmpName,  FORMAT(DCR.DcrDate,''dd-MMM-yyyy hh:mm tt'')  DcrDate, * FROM  tbl_DCRInfo  DCR WITH (NOLOCK)
 

left JOIN dbo.tblUser us  WITH (NOLOCK) ON us.UserId = DCR.Entryby
left JOIN dbo.tblEmpGeneralInfo dtl  WITH (NOLOCK)  ON dtl.EmpInfoId = us.EmpInfoId
left JOIN dbo.tbl_UserRoleInfo usr  WITH (NOLOCK) ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs  WITH (NOLOCK) ON dgs.DesignationId = dtl.DesignationId
left JOIN dbo.tblDoctorMaster docMas  WITH (NOLOCK) ON docMas.DoctorId = DCR.DoctorId
 
left JOIN   tblDoctorChemberDetail cham  WITH (NOLOCK)    ON cham.ChemberId = DCR.ChemberId		
left JOIN dbo.tbl_DoctorVisitType tt  WITH (NOLOCK)  ON tt.DocVisitTypeId = DCR.TourTypeId
left JOIN View_Webapi_EmployeeFieldForceInfo on View_Webapi_EmployeeFieldForceInfo.EmpInfoId=dtl.EmpInfoId
where  DCR.DcrId is not null
'+  @param +'  order by DCR.DcrDate desc'
 
END

EXEC (@Query)
