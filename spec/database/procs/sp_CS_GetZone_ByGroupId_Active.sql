
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetZone_ByGroupId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		
		SELECT * FROM dbo.tbl_Zone WHERE IsActive = 1 AND GroupId= @id
END


