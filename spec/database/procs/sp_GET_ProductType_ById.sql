CREATE PROCEDURE [dbo].[sp_GET_ProductType_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblProductType where ProductTypeId = @id
      
    END
