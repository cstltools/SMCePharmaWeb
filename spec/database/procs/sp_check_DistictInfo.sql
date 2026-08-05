CREATE PROCEDURE [dbo].[sp_check_DistictInfo]
	-- Add the parameters for the stored procedure here
    @id  INT ,
    @Name NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tbl_District WHERE DistrictName = @Name  And DivisionId NOT IN (@id)

END
