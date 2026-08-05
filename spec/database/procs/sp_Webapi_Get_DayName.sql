create PROCEDURE [dbo].[sp_Webapi_Get_DayName] -- Add the parameters for the stored procedure here
 
AS
BEGIN
	
	SELECT  * FROM dbo.tblDayName  with (nolock)

END