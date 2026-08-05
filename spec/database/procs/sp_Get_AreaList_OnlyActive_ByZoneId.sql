
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_AreaList_OnlyActive_ByZoneId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		 
		SELECT * FROM dbo.tbl_Area WHERE IsActive = 1 AND ZoneId = @id

END


