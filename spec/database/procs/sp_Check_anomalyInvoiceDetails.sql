CREATE PROCEDURE [dbo].[sp_Check_anomalyInvoiceDetails]
    @InvoiceId  int,
    @orderId    int
AS
BEGIN
    SET NOCOUNT ON;

    -- Invoice e ache but Order e nai --> PROBLEM
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
        inv_mas.InvoiceId          = @InvoiceId
        AND inv_mas.OrderId        = @orderId
        AND inv_dtl.OrderDetailsId IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM tblOrderDetail ord_dtl
            WHERE 
                ord_dtl.OrderId       = @orderId
                AND ord_dtl.OrderDetailId = inv_dtl.OrderDetailsId
        )
    ORDER BY inv_dtl.OrderDetailsId;

END