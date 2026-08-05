
--------------------------------------------------
-- PROCEDURE: sp_Get_DAExpenseDayWiseSummary
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_DAExpenseDayWiseSummary
    @Mode VARCHAR(20) = 'Summary',
    @ComUnitId INT = NULL,
    @Month INT = NULL,
    @Year INT = NULL,
    @DAId INT = NULL,
    @DAIds NVARCHAR(MAX) = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = ISNULL(@FromDate, CONVERT(DATE, CONVERT(VARCHAR(4), ISNULL(@Year, YEAR(GETDATE()))) + RIGHT('0' + CONVERT(VARCHAR(2), ISNULL(@Month, MONTH(GETDATE()))), 2) + '01', 112));
    DECLARE @EndDate DATE = ISNULL(@ToDate, DATEADD(DAY, -1, DATEADD(MONTH, 1, @StartDate)));
    DECLARE @SelectedDAIds NVARCHAR(MAX) = NULLIF(LTRIM(RTRIM(ISNULL(@DAIds, ''))), '');

    IF @EndDate < @StartDate
    BEGIN
        DECLARE @SwapDate DATE = @StartDate;
        SET @StartDate = @EndDate;
        SET @EndDate = @SwapDate;
    END;

    ;WITH DaBase AS
    (
        SELECT da.DAId,
               ISNULL(da.DACode, '') AS DACode,
               ISNULL(da.Name, '') AS DAName,
               da.ComUnitId,
               ISNULL(cu.ComUnitName, '') AS BaseHQ,
               ISNULL(cu.ComUnitCode, '') AS MarketCode
        FROM dbo.tblDAInfo da WITH (NOLOCK)
        LEFT JOIN dbo.tblCompanyUnit cu WITH (NOLOCK)
               ON cu.ComUnitId = da.ComUnitId
        WHERE (@ComUnitId IS NULL OR da.ComUnitId = @ComUnitId)
          AND (@DAId IS NULL OR da.DAId = @DAId)
          AND (@SelectedDAIds IS NULL OR CHARINDEX(',' + CONVERT(VARCHAR(20), da.DAId) + ',', ',' + @SelectedDAIds + ',') > 0)
    ),
    DAAgg AS
    (
        SELECT daAm.DaId,
               SUM(ISNULL(daAm.DAAmount, 0)) AS DAAmount
        FROM dbo.tblDICApprovedDAClaimAmount daAm WITH (NOLOCK)
        WHERE CAST(ISNULL(daAm.ApprovedDate, daAm.EntryDate) AS DATE) BETWEEN @StartDate AND @EndDate
          AND UPPER(LTRIM(RTRIM(ISNULL(daAm.ApprovalStatus, N'')))) = N'APPROVED'
        GROUP BY daAm.DaId
    ),
    ExpenseAgg AS
    (
        SELECT ec.EmpInfoId AS DAId,
               SUM(ISNULL(ec.Amount, 0)) AS ExpenseAmount
        FROM dbo.tbl_ExpenseClaim ec WITH (NOLOCK)
        WHERE CAST(ISNULL(ec.ApprovedDate, ec.ExpenseDate) AS DATE) BETWEEN @StartDate AND @EndDate
          AND UPPER(LTRIM(RTRIM(ISNULL(ec.ApprovalStatus, N'')))) = N'APPROVED'
        GROUP BY ec.EmpInfoId
    ),
    MonthList AS
    (
        SELECT DATEADD(DAY, 1 - DAY(@StartDate), @StartDate) AS MonthStart
        UNION ALL
        SELECT DATEADD(MONTH, 1, MonthStart)
        FROM MonthList
        WHERE DATEADD(MONTH, 1, MonthStart) <= DATEADD(DAY, 1 - DAY(@EndDate), @EndDate)
    ),
    AllowanceBase AS
    (
        SELECT SUM(ISNULL(AllowanceAmount, 0)) AS MonthlyAllowance
        FROM dbo.tblMonthlyAllowances WITH (NOLOCK)
        WHERE RoleName = N'Sales Assistant'
          AND IsActive = 1
    ),
    AllowanceAgg AS
    (
        SELECT SUM(ISNULL(ab.MonthlyAllowance, 0) * CONVERT(DECIMAL(18, 6), q.QuarterCount) / 4.0) AS AllowanceAmount
        FROM MonthList ml
        CROSS JOIN AllowanceBase ab
        CROSS APPLY
        (
            SELECT COUNT(1) AS QuarterCount
            FROM
            (
                SELECT DATEADD(DAY, 0, ml.MonthStart) AS PartStart,
                       DATEADD(DAY, 6, ml.MonthStart) AS PartEnd
                UNION ALL
                SELECT DATEADD(DAY, 7, ml.MonthStart),
                       DATEADD(DAY, 14, ml.MonthStart)
                UNION ALL
                SELECT DATEADD(DAY, 15, ml.MonthStart),
                       DATEADD(DAY, 22, ml.MonthStart)
                UNION ALL
                SELECT DATEADD(DAY, 23, ml.MonthStart),
                       DATEADD(DAY, -1, DATEADD(MONTH, 1, ml.MonthStart))
            ) parts
            WHERE parts.PartStart <= @EndDate
              AND parts.PartEnd >= @StartDate
        ) q
    )
    SELECT db.DAId,
           db.DACode,
           db.DAName,
           db.BaseHQ,
           db.MarketCode,
           'Sales Assistant' AS RoleName,
           ISNULL(daAgg.DAAmount, 0) AS DAAmount,
           CAST(0 AS DECIMAL(18, 2)) AS MileageExpense,
           ISNULL(expAgg.ExpenseAmount, 0) AS ExpenseAmount,
           CAST(ISNULL(allowanceAgg.AllowanceAmount, 0) AS DECIMAL(18, 2)) AS AllowanceAmount,
           ISNULL(daAgg.DAAmount, 0) + ISNULL(expAgg.ExpenseAmount, 0) + CAST(ISNULL(allowanceAgg.AllowanceAmount, 0) AS DECIMAL(18, 2)) AS TotalAmount
    INTO #Summary
    FROM DaBase db
    LEFT JOIN DAAgg daAgg
           ON daAgg.DaId = db.DAId
    LEFT JOIN ExpenseAgg expAgg
           ON expAgg.DAId = db.DAId
    CROSS JOIN AllowanceAgg allowanceAgg
    OPTION (MAXRECURSION 0);

    IF UPPER(@Mode) = 'SUMMARY'
    BEGIN
        SELECT *
        FROM #Summary
        WHERE DAAmount <> 0 OR ExpenseAmount <> 0 OR AllowanceAmount <> 0
        ORDER BY DAName, DACode;

        RETURN;
    END

    ;WITH Dates AS
    (
        SELECT @StartDate AS WorkDate
        UNION ALL
        SELECT DATEADD(DAY, 1, WorkDate)
        FROM Dates
        WHERE WorkDate < @EndDate
    ),
    DailyDA AS
    (
        SELECT daAm.DaId,
               CAST(ISNULL(daAm.ApprovedDate, daAm.EntryDate) AS DATE) AS WorkDate,
               ISNULL(mr.MarketCode, '') AS MarketCode,
               ISNULL(mr.MarketName, '') AS MarketName,
               SUM(ISNULL(daAm.DAAmount, 0)) AS DAAmount
        FROM dbo.tblDICApprovedDAClaimAmount daAm WITH (NOLOCK)
        LEFT JOIN dbo.tblMarket mr WITH (NOLOCK)
               ON mr.MarketId = daAm.MarketId
        WHERE CAST(ISNULL(daAm.ApprovedDate, daAm.EntryDate) AS DATE) BETWEEN @StartDate AND @EndDate
          AND UPPER(LTRIM(RTRIM(ISNULL(daAm.ApprovalStatus, N'')))) = N'APPROVED'
        GROUP BY daAm.DaId, CAST(ISNULL(daAm.ApprovedDate, daAm.EntryDate) AS DATE), ISNULL(mr.MarketCode, ''), ISNULL(mr.MarketName, '')
    ),
    DailyDARanked AS
    (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY DAId, WorkDate ORDER BY MarketName, MarketCode) AS RowNo
        FROM DailyDA
    ),
    DailyExpense AS
    (
        SELECT ec.EmpInfoId AS DAId,
               CAST(ISNULL(ec.ApprovedDate, ec.ExpenseDate) AS DATE) AS WorkDate,
               SUM(ISNULL(ec.Amount, 0)) AS ExpenseAmount
        FROM dbo.tbl_ExpenseClaim ec WITH (NOLOCK)
        WHERE CAST(ISNULL(ec.ApprovedDate, ec.ExpenseDate) AS DATE) BETWEEN @StartDate AND @EndDate
          AND UPPER(LTRIM(RTRIM(ISNULL(ec.ApprovalStatus, N'')))) = N'APPROVED'
        GROUP BY ec.EmpInfoId, CAST(ISNULL(ec.ApprovedDate, ec.ExpenseDate) AS DATE)
    ),
    DailyCombined AS
    (
        SELECT d.DAId,
               d.WorkDate,
               d.MarketCode,
               d.MarketName,
               'Ex. HQ' AS TourType,
               d.DAAmount,
               CASE WHEN d.RowNo = 1 THEN ISNULL(e.ExpenseAmount, 0) ELSE 0 END AS ExpenseAmount
        FROM DailyDARanked d
        LEFT JOIN DailyExpense e
               ON e.DAId = d.DAId
              AND e.WorkDate = d.WorkDate

        UNION ALL

        SELECT e.DAId,
               e.WorkDate,
               '' AS MarketCode,
               '' AS MarketName,
               '' AS TourType,
               CAST(0 AS DECIMAL(18, 2)) AS DAAmount,
               e.ExpenseAmount
        FROM DailyExpense e
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM DailyDARanked d
            WHERE d.DAId = e.DAId
              AND d.WorkDate = e.WorkDate
        )
    )
    SELECT s.DAId,
           s.DACode,
           s.DAName,
           s.BaseHQ,
           s.MarketCode AS DAOwnMarketCode,
           s.RoleName,
           CONVERT(VARCHAR(11), @StartDate, 106) + ' - ' + CONVERT(VARCHAR(11), @EndDate, 106) AS MonthYear,
           CONVERT(VARCHAR(10), dates.WorkDate, 23) AS WorkDate,
           RIGHT('0' + CONVERT(VARCHAR(2), DAY(dates.WorkDate)), 2) + ', ' + LEFT(DATENAME(WEEKDAY, dates.WorkDate), 3) AS DisplayDate,
           ISNULL(dc.MarketCode, '') AS MarketCode,
           ISNULL(dc.MarketName, '') AS MarketName,
           ISNULL(dc.TourType, '') AS TourType,
           ISNULL(dc.DAAmount, 0) AS DAAmount,
           CAST(0 AS DECIMAL(18, 2)) AS MileageExpense,
           ISNULL(dc.ExpenseAmount, 0) AS ExpenseAmount,
           s.AllowanceAmount,
           ISNULL(dc.DAAmount, 0) + ISNULL(dc.ExpenseAmount, 0) AS TotalAmount
    FROM #Summary s
    CROSS JOIN Dates dates
    LEFT JOIN DailyCombined dc
           ON dc.DAId = s.DAId
          AND dc.WorkDate = dates.WorkDate
    WHERE ISNULL(dc.DAAmount, 0) > 0
       OR ISNULL(dc.ExpenseAmount, 0) > 0
    ORDER BY s.DAName, s.DACode, dates.WorkDate, dc.MarketName
    OPTION (MAXRECURSION 366);
END

