CREATE PROCEDURE GetMonthYearValues
    @From_Date DATE,
    @To_Date DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Current_Date DATE = @From_Date;

    -- Create a temporary table to store the result set
    CREATE TABLE #MonthYearValues
    (
        MonthValue NVARCHAR(20),
        YearValue INT
    );

    -- Loop through the date range and insert month and year values into the temporary table
    WHILE @Current_Date <= @To_Date
    BEGIN
        INSERT INTO #MonthYearValues (MonthValue, YearValue)
        VALUES (FORMAT(@Current_Date, 'MM'), YEAR(@Current_Date));

        SET @Current_Date = DATEADD(MONTH, 1, @Current_Date);
    END

    -- Select the result set from the temporary table
    SELECT * FROM #MonthYearValues;

    -- Drop the temporary table
    DROP TABLE #MonthYearValues;
END;
