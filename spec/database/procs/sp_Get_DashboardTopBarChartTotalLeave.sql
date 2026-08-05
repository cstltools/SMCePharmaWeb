CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartTotalLeave]
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
        /* দিনের সাথে overlap হলেই গণনা:
           LeaveFromDate < (DayDate + 1)  AND  LeaveToDate >= DayDate
           -> end-inclusive rangeকে সঠিকভাবে কভার করে, SARGable থাকে            */
        SELECT
            T.DayDate,
            COUNT_BIG(*) AS Cnt
        FROM T
        JOIN dbo.Employee_LeaveApplications AS L WITH (NOLOCK)
          ON L.LeaveFromDate <  DATEADD(day, 1, T.DayDate)   -- starts before next day
         AND L.LeaveToDate   >= T.DayDate                    -- ends on/after this day
        WHERE ISNULL(L.ApprovalStatus,'') <> '3'
        GROUP BY T.DayDate
    )
    SELECT
        DayName  = 8 - T.Seq,           -- 1..7 (পুরোনো→সাম্প্রতিক)
        DayCount = ISNULL(C.Cnt, 0)
    FROM T
    LEFT JOIN C ON C.DayDate = T.DayDate
    ORDER BY T.Seq;                      -- 7 days ago → yesterday
END
