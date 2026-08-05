CREATE PROCEDURE [dbo].[sp_check_Manufacturer]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @ManufacName  NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblManufacturer WHERE ManufacName=@ManufacName AND  ManufacId NOT IN ( @id)

END