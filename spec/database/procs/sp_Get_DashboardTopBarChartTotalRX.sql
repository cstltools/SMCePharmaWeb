CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartTotalRX]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @today date = CAST(GETDATE() AS date);

    ;WITH N(Seq) AS (
        SELECT v FROM (VALUES (7),(6),(5),(4),(3),(2),(1)) AS X(v)
    ),
    T AS (
        -- 7 days ago .. yesterday (আজ বাদে)
        SELECT Seq, DATEADD(day, -Seq, @today) AS DayDate
        FROM N
    ),
    C AS (
        SELECT
            CONVERT(date, P.PrescriptionDate) AS DayDate,
            COUNT_BIG(*) AS Cnt
        FROM dbo.tbl_PrescriptionMaster AS P WITH (NOLOCK)
        WHERE ISNULL(P.ApprovalStatus, '') <> '3'
          AND P.PrescriptionDate >= DATEADD(day, -7, @today)  -- 7 days ago 00:00
          AND P.PrescriptionDate <  @today                    -- before today 00:00
        GROUP BY CONVERT(date, P.PrescriptionDate)
    )
    SELECT
        DayName  = 8 - T.Seq,         -- 1..7 (পুরোনো→সাম্প্রতিক)
        DayCount = ISNULL(C.Cnt, 0)
    FROM T
    LEFT JOIN C ON C.DayDate = T.DayDate
    ORDER BY T.Seq;                   -- 7 days ago → yesterday
END
