CREATE
 PROCEDURE [dbo].[sp_Get_Emp_AttendanceInfoDayRow]
	-- Add the parameters for the stored procedure here

	@param NVARCHAR(max)

AS
BEGIN
  

DECLARE @Query NVARCHAR(MAX)

SET @Query = ' 
  
	SELECT  distinct    CASE WHEN att2.PunchInTime  IS NOT NULL THEN ''inline'' ELSE ''none'' END AttStatus, case when usrRT.RoleTypeId=4   then EFF.GroupName when usrRT.RoleTypeId=3  then  EFF.RegionCode when usrRT.RoleTypeId=2  then  EFF.AreaCode   else EFF.TerritoryCode end TerritoryCode, att1.PInLat  +'',''+ att1.PInLog AS PInLoc,   usr.RoleName, dgs.DesigName,dtl.EmpMasterCode,dtl.EmpName, CONVERT(NVARCHAR(50), att1.AttendanceDate, 107)AS  AttendanceDate, 
                att1.PunchInTime ,
              
                att1.PInLat ,
                att1.PInLog  , att2.PunchInTime  PunchOutTime,
               att2.PInLat  +'',''+ att2.PInLog AS POutLoc, 
                att2.PInLat POutLat,
                att2.PInLog  POutLong
        FROM    dbo.tblMarketAttendance_Master_webapi att1 

		left join (select  AttendanceDate, PunchInTime,PInLat,PInLog, EmpInfoId from  tblMarketAttendance_Master_webapi  where  AttType=2 ) att2 on att2.EmpInfoId=att1.EmpInfoId and  CONVERT(DATE,att1.AttendanceDate)=CONVERT(DATE,att2.AttendanceDate)
		 left JOIN dbo.tblEmpGeneralInfo dtl  with (nolock) ON dtl.EmpInfoId = att1.EmpInfoId 
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = att1.UserRoleID
inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usr.RoleTypeId
left JOIN dbo.tblDesignation dgs  with (nolock) ON dgs.DesignationId = dtl.DesignationId
left JOIN dbo.tbl_Shift sft  with (nolock) ON sft.ShiftId=att1.ShiftId
left JOIN View_Webapi_EmployeeFieldForceInfo  EFF  on EFF.EmpInfoId=att1.EmpInfoId
		 
		 
		WHERE att1.AttType=1  '+  @param  +' 	ORDER BY CONVERT(NVARCHAR(50), att1.AttendanceDate, 107) desc   '
 
END

EXEC (@Query)