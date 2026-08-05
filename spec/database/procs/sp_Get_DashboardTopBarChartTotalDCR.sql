CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartTotalDCR]
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
            CONVERT(date, I.DcrDate) AS DayDate,
            COUNT_BIG(*) AS Cnt
        FROM dbo.tbl_DCRInfo        AS I WITH (NOLOCK)
        JOIN dbo.tblDoctorMaster    AS D WITH (NOLOCK)
             ON D.DoctorId = I.DoctorId
        WHERE D.DoctorTypeId = 2
          AND ISNULL(I.ApprovalStatus, '') <> '3'
          AND I.DcrDate >= DATEADD(day, -7, @today)  -- from 7 days ago 00:00
          AND I.DcrDate <  @today                    -- before today 00:00
        GROUP BY CONVERT(date, I.DcrDate)
    )
    SELECT
        DayName  = 8 - T.Seq,           -- 1..7 (পুরোনো→সাম্প্রতিক)
        DayCount = ISNULL(C.Cnt, 0)
    FROM T
    LEFT JOIN C ON C.DayDate = T.DayDate
    ORDER BY T.Seq;                     -- 7 days ago → yesterday
END
