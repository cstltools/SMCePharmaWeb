CREATE PROCEDURE [dbo].[sp_CS_UserInfo_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT	UserCode+' : '	+	UserName UserName,	 *  FROM dbo.tblUser WHERE UserStatus ='Active'
END
