
create PROCEDURE [dbo].[sp_SAP_EmployeeAttDataConfirm] ---SAP Invoice
  
  @AttendanceId int =0
AS
BEGIN 

update tblMarketAttendance_Master_webapi  set isGone=1, isGoneDate=getdate() where AttendanceId=@AttendanceId 

END