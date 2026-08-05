
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ProductPrice]
	-- Add the parameters for the stored procedure here
	@ProductId INT,
	@CustomerId INT
AS
BEGIN
	DECLARE @CountPrice INT
	SELECT @CountPrice=COUNT(*) FROM dbo.tblQuotedPriceMaster
	LEFT JOIN dbo.tblQuotedPriceDetail ON tblQuotedPriceDetail.QuotedPriceMasterId = tblQuotedPriceMaster.QuotedPriceMasterId
	WHERE ProductId=@ProductId AND CustomerMasterId=@CustomerId AND (GETDATE() BETWEEN ActiveFromDate AND ActiveToDate) 
	IF(@CountPrice>0)
	BEGIN
		SELECT tblQuotedPriceDetail.ProductId,ProductCode,ProductName,tblQuotedPriceDetail.UnitPrice,VATPercentage,VATAmountPerUnit FROM dbo.tblQuotedPriceMaster
		LEFT JOIN dbo.tblQuotedPriceDetail ON tblQuotedPriceDetail.QuotedPriceMasterId = tblQuotedPriceMaster.QuotedPriceMasterId
		LEFT JOIN dbo.tblUnitPrice ON dbo.tblQuotedPriceDetail.ProductId=dbo.tblUnitPrice.ProductId AND tblUnitPrice.IsActive=1
		WHERE tblQuotedPriceDetail.ProductId=@ProductId AND tblQuotedPriceMaster.CustomerMasterId=@CustomerId AND (GETDATE() BETWEEN ActiveFromDate AND ActiveToDate) 

	END
    ELSE
    BEGIN

	SELECT UnitPriceId,
           ProductId,
           ProductCode,
           ProductName,
           PackSize,
           CostPrice,
           UnitPrice,
           VATPercentage,
           VATAmountPerUnit,
           MusakVATPercentage,
           MusakVATAmountPerUnit,
           TPVat,
           MusakVat,
           IsActive,
           ActiveDate,
           InActiveDate,
           EntryBy,
           EntryDate,
           UpdateBy,
           UpdateDate,
           ApproveBy,
           ApproveDate,
           CompanyId,
           MRPPrice,
           ActionStatus FROM dbo.tblUnitPrice WHERE ProductId=@ProductId AND IsActive=1
	END 
END


