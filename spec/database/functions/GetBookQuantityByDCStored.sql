CREATE FUNCTION GetBookQuantityByDCStored (@DCStoreId INT)
RETURNS @ResultTable TABLE
(
    DCStoreId INT,
    ProductCode INT,
    ComUnitId INT,
    BookQuantity DECIMAL(18, 2)
)
AS
BEGIN
    INSERT INTO @ResultTable
    SELECT 
        id.DCStoreId,
        id.ProductCode,
        i.ComUnitId,
        SUM(id.Quantity) AS BookQuantity
    FROM 
        tblInvoice i with (nolock)
    INNER JOIN 
        tblInvoiceDetail id  with (nolock) ON i.InvoiceId = id.InvoiceId
    WHERE 
        i.UpdateDate IS NULL
        AND id.DCStoreId = @DCStoreId
    GROUP BY 
        id.DCStoreId, id.ProductCode, i.ComUnitId;

    RETURN;
END;
