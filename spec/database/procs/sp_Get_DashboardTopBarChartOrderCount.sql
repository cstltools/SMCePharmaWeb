CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartOrderCount]
AS
BEGIN
    SET NOCOUNT ON;

    /* Last 7 days = GETDATE()-7 .. GETDATE()-1 (আজ বাদে) */
    WITH T(Seq, DayDate) AS (
        SELECT v.Seq, CONVERT(date, DATEADD(day, -v.Seq, GETDATE()))
        FROM (VALUES (7),(6),(5),(4),(3),(2),(1)) AS v(Seq)
    ),
    C AS (
        SELECT 
            CONVERT(date, A.SubmissionDate) AS DayDate,
            COUNT(*) AS DayCount
        FROM dbo.tblOrder AS A WITH (NOLOCK)
        WHERE A.ActionStatus <> '3'
          AND A.SubmissionDate >= DATEADD(day, -7, CONVERT(date, GETDATE()))
          AND A.SubmissionDate <  CONVERT(date, GETDATE())
        GROUP BY CONVERT(date, A.SubmissionDate)
    )
    SELECT 
        DayName  = 8 - T.Seq,                 -- 1..7 (পুরোনো→সাম্প্রতিক)
        T.DayDate,                            -- yyyy-mm-dd
        DayLabel = FORMAT(T.DayDate, 'ddd'),  -- Mon/Tue/... (ইচ্ছেমত)
        DayCount = ISNULL(C.DayCount, 0)
    FROM T
    LEFT JOIN C ON C.DayDate = T.DayDate
    ORDER BY T.Seq;                           -- 7 days ago → yesterday

    /* 
    -- যদি "আজকের" অর্ডার কাউন্টও লাগে, আলাদা করে এটা চালাতে পারো
    -- SELECT TodayCount = COUNT(*) 
    -- FROM dbo.tblOrder WITH (NOLOCK)
    -- WHERE ActionStatus <> '3'
    --   AND SubmissionDate >= CONVERT(date, GETDATE())
    --   AND SubmissionDate <  DATEADD(day, 1, CONVERT(date, GETDATE()));
    */
END
