
 Create PROCEDURE [dbo].[sp_GET_Check_QuotedpriceEntry]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max),
   @CusId NVARCHAR(max)
AS
    BEGIN

	Select IsActive from tblProductQuotedPrice where IsActive= 1 and ProductId=@id and CustomerMasterId = @CusId

 END


