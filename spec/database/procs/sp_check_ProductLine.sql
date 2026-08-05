create PROCEDURE [dbo].[sp_check_ProductLine]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @LineName     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblProductLine WHERE LineName=@LineName  AND  ProductLineID NOT IN ( @id)

END