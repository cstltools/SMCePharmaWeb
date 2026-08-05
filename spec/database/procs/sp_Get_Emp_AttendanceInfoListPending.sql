-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Get_Emp_AttendanceInfoListPending]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT case when mas.AttType=1 then 'IN' else 'OUT'   end as AttType, usr.RoleName, dgs.DesigName,   mas.PInLat  +','+ mas.PInLog AS PInLoc,  mas.POutLat+','+ mas.POutLong AS POnLoc,   CONVERT(varchar(100),CAST(mas.PunchInTime AS TIME),100)PunchInTime, CONVERT(varchar(100),CAST(mas.PunchOutTime AS TIME),100)PunchOutTime, sft.ShiftText,   CONVERT(NVARCHAR(50),mas.AttendanceDate,106)AS AttendanceDate, dtl.EmpMasterCode,dtl.EmpName, CASE WHEN mas.Status =0 THEN 'Pending' ELSE 'Approved' end ApprovalStatus,*     FROM  tblMarketAttendance_Master_webapi mas
 
 left JOIN dbo.tblEmpGeneralInfo dtl ON dtl.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tblUser us ON us.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = dtl.DesignationId
left JOIN dbo.tbl_Shift sft ON sft.ShiftId=mas.ShiftId

 WHERE mas.Status=0
 
END

