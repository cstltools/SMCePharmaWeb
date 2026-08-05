CREATE PROCEDURE [dbo].[sp_CS_GetZone_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		--SELECT * FROM dbo.tbl_Zone WHERE IsActive = 1


		SELECT * FROM dbo.tblRegion WHERE IsActive = 1

END
