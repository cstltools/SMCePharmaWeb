create PROCEDURE [dbo].[sp_GET_ProductLine_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblProductLine where ProductLineID = @id
      
    END