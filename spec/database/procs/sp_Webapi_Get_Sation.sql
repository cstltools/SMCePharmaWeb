-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_Sation]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		

		SELECT StationTypeId ,
               StationTypeName  FROM dbo.tblStationType WHERE IsActive = 1


END

