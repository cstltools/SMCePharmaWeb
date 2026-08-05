CREATE PROCEDURE [dbo].[sp_check_ThanaInfo]
	-- Add the parameters for the stored procedure here
    @id  INT ,
    @Name NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tbl_Thana WHERE ThanaName = @Name  And district_id NOT IN (@id)

END
