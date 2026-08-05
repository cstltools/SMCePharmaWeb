-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DistrictByDivisionId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	

	SELECT DistrictId,DistrictName FROM dbo.tbl_District WHERE IsActive = 1 and DivisionId=@id

END

