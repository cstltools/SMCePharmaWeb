CREATE FUNCTION dbo.GetMonthYearValuesDateRange
(
    @From_Date DATE,
    @To_Date DATE
)
RETURNS TABLE
AS
RETURN
(
    WITH DateRange AS
    (
        SELECT @From_Date AS CurrentDate
        UNION ALL
        SELECT DATEADD(MONTH, 1, CurrentDate)
        FROM DateRange
        WHERE DATEADD(MONTH, 1, CurrentDate) <= @To_Date
    )
    SELECT
        convert(int,FORMAT(CurrentDate, 'MM')) AS MonthValue,
        convert(int,YEAR(CurrentDate)) AS YearValue
    FROM DateRange
);

