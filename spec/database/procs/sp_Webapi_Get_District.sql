-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_District]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT DistrictId,DistrictName, DivisionId FROM dbo.tbl_District WHERE IsActive = 1

END

