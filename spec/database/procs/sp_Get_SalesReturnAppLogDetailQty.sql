
--------------------------------------------------
-- PROCEDURE: sp_Get_SalesReturnAppLogDetailQty
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_Get_SalesReturnAppLogDetailQty]
    @SalesReturnAppLogId INT,
    @InvoiceId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        InvoiceDetailId,
        SUM(ISNULL(CONVERT(DECIMAL(18, 4), ReturnQty), 0)) AS ReturnQty, ReasonLabel
    FROM dbo.tblSalesReturn_appLogDetail WITH (NOLOCK)
    WHERE SalesReturnAppLogId = @SalesReturnAppLogId
      AND InvoiceId = @InvoiceId
    GROUP BY InvoiceDetailId,ReasonLabel;
END

