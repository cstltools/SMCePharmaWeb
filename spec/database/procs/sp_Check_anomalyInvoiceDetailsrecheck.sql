create PROCEDURE [dbo].[sp_Check_anomalyInvoiceDetailsrecheck]
    @InvoiceId  int,
    @orderId    int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        inv_mas.InvoiceId,
        inv_mas.OrderId,
        inv_dtl.OrderDetailsId,
        inv_dtl.ProductCode,
        inv_dtl.ProductName
    FROM tblInvoice inv_mas
    INNER JOIN tblInvoiceDetail inv_dtl 
        ON inv_mas.InvoiceId = inv_dtl.InvoiceId
    WHERE 
        inv_mas.InvoiceId   = @InvoiceId
        AND inv_mas.OrderId = @orderId
        AND inv_dtl.OrderDetailsId IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM tblOrder ord_mas
            INNER JOIN tblOrderDetail ord_dtl 
                ON ord_mas.OrderId = ord_dtl.OrderId
            WHERE 
                ord_mas.OrderId           = inv_mas.OrderId
                AND ord_dtl.OrderDetailId = inv_dtl.OrderDetailsId
        )
    ORDER BY inv_mas.InvoiceId, inv_dtl.OrderDetailsId;

END