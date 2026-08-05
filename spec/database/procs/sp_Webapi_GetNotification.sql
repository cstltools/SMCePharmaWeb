CREATE PROCEDURE [dbo].[sp_Webapi_GetNotification]
	-- Add the parameters for the stored procedure here
@empId INT
AS
BEGIN
	
	SELECT NotificationId ,
           NotificationType ,
           NotificationPrimaryText ,
          NotificationMainText AS  NotificationRestText ,
           EntryBy ,
           EntryDate ,
           IsRead ,
           EmpInfoId,PrimaryId FROM dbo.tbl_Notification ORDER BY IsRead ASC

END
