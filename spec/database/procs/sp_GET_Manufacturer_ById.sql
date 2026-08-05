CREATE PROCEDURE [dbo].[sp_GET_Manufacturer_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblManufacturer where ManufacId = @id
      
    END