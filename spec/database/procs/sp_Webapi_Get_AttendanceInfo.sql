CREATE PROCEDURE [dbo].[sp_Webapi_Get_AttendanceInfo]
 
 @empId int

 as
 
BEGIN

	select CASE WHEN att1.AttType=1 THEN 'OFF' ELSE 'ON'   END PunchInBtn , CASE WHEN att2.AttType=2 THEN 'OFF'  ELSE 'ON' END PunchOUTBtn FROM tblMarketAttendance_Master_webapi  att1  with (nolock) 

	left join (select AttType, EmpInfoId,AttendanceDate from  tblMarketAttendance_Master_webapi with (nolock)  where  AttType=2 AND  EmpInfoId = @empId  AND CONVERT(DATE,AttendanceDate) = CONVERT(DATE,GETDATE()) ) att2 on att2.EmpInfoId=att1.EmpInfoId AND CONVERT(DATE,att1.AttendanceDate) = CONVERT(DATE,att2.AttendanceDate)

	WHERE att1.EmpInfoId = @empId AND CONVERT(DATE,att1.AttendanceDate) = CONVERT(DATE,GETDATE())  AND   att1.AttType=1 

END