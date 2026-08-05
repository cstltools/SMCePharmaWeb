
CREATE PROCEDURE [dbo].[sp_GET_UserSettingPanel]
	-- Add the parameters for the stored procedure here
	 


AS
BEGIN

SELECT * FROM tblUserSettingPanel where UserSettingPanelId not in (3)

END

