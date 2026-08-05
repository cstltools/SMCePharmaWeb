CREATE PROCEDURE [dbo].[sp_Webapi_GetNotificationCount]
	-- Add the parameters for the stored procedure here
@empId int
AS
BEGIN
		

		SELECT COUNT(*) AS NotificationCount FROM dbo.tbl_Notification (NOLOCK) WHERE IsRead = 0 
		
		AND EmpInfoId = @empId




END
