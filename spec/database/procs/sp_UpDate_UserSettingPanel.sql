
create PROCEDURE [dbo].[sp_UpDate_UserSettingPanel]
	-- Add the parameters for the stored procedure here
	 
@UserSettingPanelId INT ,
@FromDate DATETIME NUll,
@Todate DATETIME NUll

AS
BEGIN

UPDATE [dbo].[tblUserSettingPanel]
   SET [FromDate] = @FromDate
      ,[Todate] = @Todate 
 WHERE UserSettingPanelId = @UserSettingPanelId

END

