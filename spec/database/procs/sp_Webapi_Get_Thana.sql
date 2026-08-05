-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_Thana] -- Add the parameters for the stored procedure here
 
AS
BEGIN
	
	SELECT ThanaId,ThanaName,district_id FROM dbo.tbl_Thana WHERE IsActive = 1 

END

