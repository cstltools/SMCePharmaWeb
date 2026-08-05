CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartTotalInvoiceAmount]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @today date = CAST(GETDATE() AS date);

    ;WITH N(Seq) AS (
        SELECT v FROM (VALUES (7),(6),(5),(4),(3),(2),(1)) AS X(v)
    ),
    T AS (
        /* Seq: 7=seven days ago ... 1=yesterday */
        SELECT Seq, DATEADD(day, -Seq, @today) AS DayDate
        FROM N
    ),
    C AS (
        SELECT
            CONVERT(date, A.InvoiceDate) AS DayDate,
            SUM(
                ISNULL(ID.TotalPrice, 0) - ISNULL(ID.DiscountAmount, 0)
            ) AS DayAmount
        FROM dbo.tblInvoice AS A WITH (NOLOCK)
        JOIN dbo.tblInvoiceDetail AS ID WITH (NOLOCK)
          ON ID.InvoiceId = A.InvoiceId
        WHERE A.InvoiceDate >= DATEADD(day, -7, @today)   -- 7 days ago (00:00)
          AND A.InvoiceDate <  @today                     -- before today (00:00)
        GROUP BY CONVERT(date, A.InvoiceDate)
    )
    SELECT
        DayName  = 8 - T.Seq,              -- 1..7 (পুরোনো→সাম্প্রতিক)
        DayCount = ISNULL(C.DayAmount, 0)  -- আপনার পুরনো alias 'DayCount' রেখে দিলাম
    FROM T
    LEFT JOIN C ON C.DayDate = T.DayDate
    ORDER BY T.Seq;                        -- 7 days ago → yesterday
END
