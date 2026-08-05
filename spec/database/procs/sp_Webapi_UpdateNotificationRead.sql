CREATE PROCEDURE [dbo].[sp_Webapi_UpdateNotificationRead]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
		
		UPDATE dbo.tbl_Notification SET IsRead = 1 WHERE NotificationId= @id

END
