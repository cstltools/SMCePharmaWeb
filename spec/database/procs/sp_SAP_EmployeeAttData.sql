CREATE PROCEDURE [dbo].[sp_SAP_EmployeeAttData] ---SAP Invoice
  

AS
BEGIN 
SELECT att1.AttendanceId,
    emp.EmpMasterCode AS employee_id,
    CONVERT(VARCHAR(8), CAST(att1.PunchInTime AS TIME), 108) AS InTime,
    CONVERT(VARCHAR(8), CAST(att2.PunchInTime AS TIME), 108) AS OutTime,
    FORMAT(CONVERT(DATE, att1.AttendanceDate), 'yyyy-MM-dd') AS date_for,
    '0' AS project
FROM tblMarketAttendance_Master_webapi att1 WITH (NOLOCK)

left join (select  AttendanceId AttendanceIdOutID,AttendanceDate, AttAddress, POutRemarks, PunchInTime,PInLat,PInLog, EmpInfoId from  tblMarketAttendance_Master_webapi  where  AttType=2 ) att2 on att2.EmpInfoId=att1.EmpInfoId and  CONVERT(DATE,att1.AttendanceDate)=CONVERT(DATE,att2.AttendanceDate)
INNER JOIN tblEmpGeneralInfo emp WITH (NOLOCK) 
    ON emp.EmpInfoId = att1.EmpInfoId
WHERE  att1.AttType=1 and CONVERT(DATE, att1.AttendanceDate) = CONVERT(DATE, DATEADD(DAY, -1, GETDATE()))   and ISNULL(att1.isGone,0)=0  order by  CONVERT(DATE, att1.AttendanceDate) asc


END