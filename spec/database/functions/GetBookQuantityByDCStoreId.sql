CREATE FUNCTION dbo.GetBookQuantityByDCStoreId
(
    @DCStoreId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @BookQuantity INT;

    SELECT @BookQuantity = SUM(tblInvoiceDetail.Quantity)
    FROM tblInvoice with (nolock)
    INNER JOIN tblInvoiceDetail  with (nolock) ON tblInvoice.InvoiceId = tblInvoiceDetail.InvoiceId
    INNER JOIN tblDCStore  with (nolock) ON tblDCStore.DCStoreId = tblInvoiceDetail.DCStoreId
    LEFT JOIN tblProduct  with (nolock) ON tblInvoiceDetail.ProductCode = tblProduct.ProductCode
    LEFT JOIN tblStockUOM  with (nolock) ON tblStockUOM.StockUOMId = tblProduct.StockUOMId
    INNER JOIN tblCompanyUnit  with (nolock) ON tblCompanyUnit.ComUnitId = tblInvoice.ComUnitId
    WHERE tblInvoice.UpdateDate IS NULL
    AND tblInvoiceDetail.DCStoreId = @DCStoreId;

    RETURN @BookQuantity;
END;
