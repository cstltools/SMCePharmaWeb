
CREATE PROCEDURE [dbo].[sp_GET_UnitPrice_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN


	  SELECT * FROM tblUnitPrice WHERE UnitPriceId=@id
      
    END
