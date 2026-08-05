-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_OPAPI_GetQuotedPrice] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
SELECT A.Description,
	B.QuotedPriceDetailId,
       A.Policy,
       A.CustomerMasterId,
       CONVERT(varchar(10),A.ActiveFromDate,120)AS ActiveFromDate,
       CONVERT(varchar(10),A.ActiveToDate,120)AS ActiveToDate,
       B.ProductId,
       B.UnitPrice,
       ISNULL(B.Vat,0)AS Vat
FROM dbo.tblQuotedPriceMaster A
    INNER JOIN dbo.tblQuotedPriceDetail B
        ON B.QuotedPriceMasterId = A.QuotedPriceMasterId
WHERE A.IsCustomerWise = 1 AND (CONVERT(DATE,GETDATE()) BETWEEN A.ActiveFromDate AND A.ActiveToDate)
END
