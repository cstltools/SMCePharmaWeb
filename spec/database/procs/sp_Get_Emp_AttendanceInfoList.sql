CREATE
 PROCEDURE [dbo].[sp_Get_Emp_AttendanceInfoList]
	-- Add the parameters for the stored procedure here

	@param NVARCHAR(max)

AS
BEGIN
  

DECLARE @Query NVARCHAR(MAX)

SET @Query = ' 
  
	SELECT  distinct   (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''AttendanceMy'')+CAST(att2.AttendanceIdOutID as nvarchar(max))+''.jpg'' AS  ImageOut,(SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''AttendanceMy'')+CAST(att1.AttendanceId as nvarchar(max))+''.jpg'' AS   ImagePreName, att1.AttAddress InAddress , att2.AttAddress OutAddress, case when att1.ApprovalStatus=''0'' then ''Pending''  when att1.ApprovalStatus=''1'' then ''Verified''    when att1.ApprovalStatus=''2'' then ''Approved''     when att1.ApprovalStatus=''3'' then ''Rejected''     else '''' end ApprovalStatus,  CASE WHEN att2.PunchInTime  IS NOT NULL THEN ''inline'' ELSE ''none'' END AttStatus,  (SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''Attendance'')+CAST(att1.AttendanceId AS NVARCHAR(max))+''.jpg''AS ImagePreName, att2.POutRemarks, sft.ShiftText,  att1.PInLat  +'',''+ att1.PInLog AS PInLoc,   usr.RoleName, dgs.DesigName,dtl.EmpMasterCode,dtl.EmpName, format(  att1.AttendanceDate, ''dd-MMM-yyyy'')AS  AttendanceDate, 
                att1.PunchInTime ,
              
                att1.PInLat ,
                att1.PInLog  , att2.PunchInTime  PunchOutTime,
               att2.PInLat  +'',''+ att2.PInLog AS POutLoc, 
                att2.PInLat POutLat,
                att2.PInLog  POutLong
        FROM    dbo.tblMarketAttendance_Master_webapi att1 

		left join (select  AttendanceId AttendanceIdOutID,AttendanceDate, AttAddress, POutRemarks, PunchInTime,PInLat,PInLog, EmpInfoId from  tblMarketAttendance_Master_webapi  where  AttType=2 ) att2 on att2.EmpInfoId=att1.EmpInfoId and  CONVERT(DATE,att1.AttendanceDate)=CONVERT(DATE,att2.AttendanceDate)
		 left JOIN dbo.tblEmpGeneralInfo dtl  with (nolock) ON dtl.EmpInfoId = att1.EmpInfoId 
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = att1.UserRoleID
left JOIN dbo.tblDesignation dgs  with (nolock) ON dgs.DesignationId = dtl.DesignationId
left JOIN dbo.tbl_Shift sft  with (nolock) ON sft.ShiftId=att1.ShiftId
left JOIN View_Webapi_EmployeeFieldForceInfo on View_Webapi_EmployeeFieldForceInfo.EmpInfoId=att1.EmpInfoId
		 
		 
		WHERE att1.AttType=1 '+  @param  +' 	ORDER BY format(  att1.AttendanceDate, ''dd-MMM-yyyy'') desc   '
 
END

EXEC (@Query)