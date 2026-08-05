create PROCEDURE [dbo].[sp_Webapi_Get_MarketAttendanceMaxID]
 
AS
BEGIN

	select MAX(AttendanceId) AttendanceId from tblMarketAttendance_Master_webapi

END
