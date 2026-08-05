create PROCEDURE [dbo].[sp_Get_JoiningDateCountInfo] -- Add the parameters for the stored procedure here
 
AS
BEGIN
	
	SELECT  * FROM   [dbo].tblJoiningDateCountInfo with (nolock)

END