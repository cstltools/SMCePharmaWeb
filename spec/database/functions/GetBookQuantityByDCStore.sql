create FUNCTION GetBookQuantityByDCStore (@DCStoreId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        id.DCStoreId,
        id.ProductCode,
        i.ComUnitId,
        SUM(id.Quantity) AS BookQuantity
    FROM 
        tblInvoice i
    INNER JOIN 
        tblInvoiceDetail id ON i.InvoiceId = id.InvoiceId
    WHERE 
        i.UpdateDate IS NULL
        AND id.DCStoreId = @DCStoreId
    GROUP BY 
        id.DCStoreId, id.ProductCode, i.ComUnitId
);
