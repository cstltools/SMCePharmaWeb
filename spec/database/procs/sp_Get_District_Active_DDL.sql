CREATE PROCEDURE [dbo].[sp_Get_District_Active_DDL]
	-- Add the parameters for the stored procedure here
	@id Nvarchar(MAX)
AS
BEGIN

		SELECT  DistrictId ,DistrictName  FROM dbo.tbl_District WHERE IsActive = 1 and DivisionId = @id

END
