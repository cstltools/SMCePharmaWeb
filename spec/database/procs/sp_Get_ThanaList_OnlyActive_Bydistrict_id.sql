
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ThanaList_OnlyActive_Bydistrict_id]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		 
		SELECT * FROM dbo.tbl_Thana WHERE IsActive = 1 AND district_id =@id

END


