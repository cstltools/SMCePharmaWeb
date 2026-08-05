CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartRejectionAmount]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @today date = CAST(GETDATE() AS date);

    ;WITH N(Seq) AS (
        SELECT v FROM (VALUES (7),(6),(5),(4),(3),(2),(1)) AS X(v)
    ),
    T AS (
        -- Seq: 7 = seven days ago ... 1 = yesterday
        SELECT Seq, DATEADD(day, -Seq, @today) AS DayDate
        FROM N
    ),
    -- 1) Pure rejection invoices (RejectionDate ভিত্তিক)
    R AS (
        SELECT
            CONVERT(date, rejMas.RejectionDate) AS DayDate,
            SUM( ISNULL(D.TotalPrice,0) - ISNULL(D.DiscountAmount,0) ) AS Amount
        FROM dbo.tblRejectionInvoiceMaster AS rejMas WITH (NOLOCK)
        INNER JOIN dbo.tblRejectionInvoiceDetail AS D WITH (NOLOCK)
            ON rejMas.InvoiceId = D.InvoiceId
        WHERE rejMas.RejectionDate >= DATEADD(day, -7, @today)
          AND rejMas.RejectionDate <  @today
        GROUP BY CONVERT(date, rejMas.RejectionDate)
    ),
    -- 2) Partial/Reject delivery adjustments (I.UpdateDate ভিত্তিক)
    P AS (
        SELECT
            CONVERT(date, I.UpdateDate) AS DayDate,
            SUM(
                ISNULL(ID.TotalPrice,0) - ISNULL(ID.DeliveryTotalPrice,0)
              - ISNULL(ID.DiscountAmount,0) + ISNULL(ID.DeliveryDiscountAmount,0)
            ) AS Amount
        FROM dbo.tblInvoice AS I WITH (NOLOCK)
        INNER JOIN dbo.tblOrder  AS mas WITH (NOLOCK)
            ON mas.OrderId = I.OrderId
        INNER JOIN dbo.tblInvoiceDetail AS ID WITH (NOLOCK)
            ON ID.InvoiceId = I.InvoiceId
        WHERE I.UpdateDate >= DATEADD(day, -7, @today)
          AND I.UpdateDate <  @today
        
          AND I.DelivaryInvoiceNo IS NOT NULL
          AND ID.DeliveryStatus IN ('Reject','Partial')
        GROUP BY CONVERT(date, I.UpdateDate)
    )
    SELECT
        DayName  = 8 - T.Seq,                                   -- 1..7 (পুরোনো→সাম্প্রতিক)
        DayCount = ISNULL(R.Amount,0) + ISNULL(P.Amount,0)
    FROM T
    LEFT JOIN R ON R.DayDate = T.DayDate
    LEFT JOIN P ON P.DayDate = T.DayDate
    ORDER BY T.Seq;                                             -- 7 days ago → yesterday
END
