
 CREATE PROCEDURE [dbo].[sp_GET_UnitPrice_ByProductId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select UnitPrice from tblUnitPrice As UP
	 LEFT JOIN tblProduct PQ ON UP.ProductId = PQ.ProductId
	 where UP.IsActive= 1 And  PQ.ProductId = @id

 END


