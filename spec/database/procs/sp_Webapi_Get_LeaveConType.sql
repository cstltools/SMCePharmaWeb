create PROCEDURE [dbo].[sp_Webapi_Get_LeaveConType] -- Add the parameters for the stored procedure here
 
AS
BEGIN
	
	SELECT  * FROM   [dbo].[tblLeaveConType] with (nolock)

END