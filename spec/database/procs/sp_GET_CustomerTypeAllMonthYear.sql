
CREATE   PROCEDURE [dbo].[sp_GET_CustomerTypeAllMonthYear]
    @month INT,
    @year  INT
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
        
        WHERE   month(A.UpdateDate) = @Month
          AND year(A.UpdateDate) =  @Year
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND ord.CustTypeId = GRP.CustomerTypeId
    );
END
