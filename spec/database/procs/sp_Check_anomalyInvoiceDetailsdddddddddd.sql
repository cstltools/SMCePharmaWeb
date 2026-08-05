
create PROCEDURE [dbo].[sp_Check_anomalyInvoiceDetailsdddddddddd]
    @InvoiceId  int,
    @orderId    int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ord_mas.OrderId,
        ord_dtl.OrderDetailId,
        ord_dtl.ProductCode,
        ord_dtl.ProductName
    FROM tblOrder ord_mas
    INNER JOIN tblOrderDetail ord_dtl 
        ON ord_mas.OrderId = ord_dtl.OrderId
    WHERE 
        ord_mas.OrderId = @orderId
        AND NOT EXISTS (
            SELECT 1
            FROM tblInvoiceDetail inv_dtl
            WHERE 
                inv_dtl.InvoiceId      = @InvoiceId
                AND inv_dtl.OrderDetailsId = ord_dtl.OrderDetailId  -- Match নেই
        )
    ORDER BY ord_dtl.OrderDetailId;

END