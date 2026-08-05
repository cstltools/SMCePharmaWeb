CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartDeliveryAmount]
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
    C AS (
        SELECT
            CONVERT(date, custDtl.custPaymentDate) AS DayDate,
            SUM(ISNULL(custDtl.TPAmount, 0)) AS DayAmount
        FROM tblCustPayDetail AS custDtl WITH (NOLOCK)
        WHERE custDtl.custPaymentDate >= DATEADD(day, -7, @today) -- from 7 days ago 00:00
          AND custDtl.custPaymentDate <  @today                    -- before today 00:00
        GROUP BY CONVERT(date, custDtl.custPaymentDate)
    )
    SELECT
        DayName  = 8 - T.Seq,               -- 1..7 (পুরোনো→সাম্প্রতিক)
        DayCount = ISNULL(C.DayAmount, 0)   -- alias আগের মতোই রাখা
    FROM T
    LEFT JOIN C ON C.DayDate = T.DayDate
    ORDER BY T.Seq;                         -- 7 days ago → yesterday
END
