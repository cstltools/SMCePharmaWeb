CREATE PROCEDURE [dbo].[sp_WebApi_GetVersion] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		

		SELECT TOP 1 * FROM tbl_AppVersion WHERE IsActive =1 ORDER by AppVersionId desc


END