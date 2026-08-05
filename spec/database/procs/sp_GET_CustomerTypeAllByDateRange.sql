
create   PROCEDURE [dbo].sp_GET_CustomerTypeAllByDateRange
     @FromDate date,
  @ToDate date
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Sargable month/year range
    ------------------------------------------------------------------
 

    ------------------------------------------------------------------
    -- Return customer types that actually have invoices in period
    ------------------------------------------------------------------
    SELECT DISTINCT
           GRP.CustomerTypeId,
          GRP.CustomerType
                  CustomerType
    FROM dbo.tblCustomerType AS GRP WITH (NOLOCK)
    WHERE EXISTS
    (
        SELECT 1
        FROM dbo.tblInvoice AS A WITH (NOLOCK)
        INNER JOIN dbo.tblOrder   AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        
        WHERE       (A.UpdateDate)  between  @FromDate and @ToDate
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND ord.CustTypeId = GRP.CustomerTypeId
    );
END
