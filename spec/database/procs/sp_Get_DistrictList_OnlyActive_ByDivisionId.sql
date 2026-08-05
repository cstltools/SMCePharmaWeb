
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DistrictList_OnlyActive_ByDivisionId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		 
		SELECT DistrictId, DistrictName FROM dbo.tbl_District WHERE IsActive = 1 AND DivisionId = @id

END


