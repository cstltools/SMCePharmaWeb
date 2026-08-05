
 CREATE PROCEDURE [dbo].[sp_GET_productQuotedPrice_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)
AS
    BEGIN
	Select P.QuotedPriceId, p.QuotedPrice, p.ActiveDate, cus.CustomerCode, Pro.ProductCode,
    p.InactiveDate, cus.CustomerName, Pro.ProductName, UP.UnitPrice from tblProductQuotedPrice p 
    LEFT JOIN tblCustMaster cus on cus.CustomerMasterId = p.CustomerMasterId
    LEFT JOIN tblProduct Pro On Pro.ProductId = p.ProductId
    LEFT JOIN tblUnitPrice UP On UP.ProductId = p.ProductId 
    Where p.QuotedPriceId Is not NUll  And  UP.IsActive =1 and p.QuotedPriceId=@id
    END


