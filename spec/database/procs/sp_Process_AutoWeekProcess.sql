
CREATE PROCEDURE [dbo].[sp_Process_AutoWeekProcess]
	-- Add the parameters for the stored procedure here
   @Parameter INT

AS
    BEGIN
TRUNCATE TABLE tbl_TempAllMonthforWeek
	
DECLARE @fiscalYearId INT ,
    @fiscalYear NVARCHAR(MAX)

SET @fiscalYearId = @Parameter 
DECLARE @beginDate DATE ,
    @endDate DATE 
SELECT  @beginDate = YearFromDate
FROM    dbo.tblFiscalYearInfos
WHERE   FiscalYearId = @fiscalYearId 
SELECT  @endDate = YearTodate
FROM    dbo.tblFiscalYearInfos
WHERE   FiscalYearId = @fiscalYearId

SELECT  @fiscalYear = FiscalYearDesc
FROM    dbo.tblFiscalYearInfos
WHERE   FiscalYearId = @fiscalYearId

WHILE @beginDate <= @endDate
    BEGIN 

        INSERT  INTO tbl_TempAllMonthforWeek
                ( MonthValue ,
                  LastDateofTheMonth
                )
        VALUES  ( @beginDate ,
                  CAST(EOMONTH(@beginDate) AS DATETIME)
                )

        SET @beginDate = DATEADD(MONTH, 1, @beginDate) 
    END

--getting weeks FROM WEEK TABLE OF that year

DECLARE @firstWeekofMonth DATETIME ,
    @secondWeekofMonth DATETIME ,
    @thirdWeekofMonth DATETIME ,
    @fourthWeekofMonth DATETIME
DECLARE @firstWeekofMonthTODate DATETIME ,
    @secondWeekofMonthTODate DATETIME ,
    @thirdWeekofMonthTODate DATETIME ,
    @fourthWeekofMonthTODate DATETIME;
WITH    Records
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY WeekSettingId ) AS 'row' ,
                        *
               FROM     tblWeekSetting
               WHERE    FiscalYearId = @Parameter
             )
    SELECT  @firstWeekofMonth = Records.FromDate ,
            @firstWeekofMonthTODate = Records.Todate
    FROM    Records
    WHERE   row = 1;
WITH    Records
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY WeekSettingId ) AS 'row' ,
                        *
               FROM     tblWeekSetting
               WHERE    FiscalYearId = @Parameter
             )
    SELECT  @secondWeekofMonth = Records.FromDate ,
            @secondWeekofMonthTODate = Records.Todate
    FROM    Records
    WHERE   row = 2;
WITH    Records
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY WeekSettingId ) AS 'row' ,
                        *
               FROM     tblWeekSetting
               WHERE    FiscalYearId = @Parameter
             )
    SELECT  @thirdWeekofMonth = Records.FromDate ,
            @thirdWeekofMonthTODate = Records.Todate
    FROM    Records
    WHERE   row = 3;
WITH    Records
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY WeekSettingId ) AS 'row' ,
                        *
               FROM     tblWeekSetting
               WHERE    FiscalYearId = @Parameter
             )
    SELECT  @fourthWeekofMonth = Records.FromDate ,
            @fourthWeekofMonthTODate = Records.Todate
    FROM    Records
    WHERE   row = 4





------


DECLARE @monthStartValue DATETIME 
DECLARE @monthEndValue DATETIME


DECLARE db_cursor CURSOR
FOR
    SELECT  MonthValue ,
            LastDateofTheMonth
    FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY MonthValue ASC ) row ,
                        MonthValue ,
                        LastDateofTheMonth
              FROM      tbl_TempAllMonthforWeek
            ) t
    WHERE   row != 1;

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @monthStartValue, @monthEndValue

WHILE @@FETCH_STATUS = 0
    BEGIN 

        INSERT  INTO dbo.tblWeekSetting
                ( FiscalYearId ,
                  WeekName ,
                  FromDate ,
                  Todate ,
                  EntryBy ,
                  EntryDate 
	          
	            )
        VALUES  ( @fiscalYearId ,
                  ( CAST(DATENAME(MONTH, @monthStartValue) AS NVARCHAR(50))
                    + CAST(@fiscalYear AS NVARCHAR(10)) + '-Week-01' ) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@firstWeekofMonth) AS NVARCHAR(10)) AS DATETIME) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@firstWeekofMonthTODate) AS NVARCHAR(10)) AS DATETIME) ,
                  0 ,
                  GETDATE()
                )



        INSERT  INTO dbo.tblWeekSetting
                ( FiscalYearId ,
                  WeekName ,
                  FromDate ,
                  Todate ,
                  EntryBy ,
                  EntryDate 
	          
	            )
        VALUES  ( @fiscalYearId ,
                  ( CAST(DATENAME(MONTH, @monthStartValue) AS NVARCHAR(50))
                    + CAST(@fiscalYear AS NVARCHAR(10)) + '-Week-02' ) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@secondWeekofMonth) AS NVARCHAR(10)) AS DATETIME) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@secondWeekofMonthTODate) AS NVARCHAR(10)) AS DATETIME) ,
                  0 ,
                  GETDATE()
                )


        INSERT  INTO dbo.tblWeekSetting
                ( FiscalYearId ,
                  WeekName ,
                  FromDate ,
                  Todate ,
                  EntryBy ,
                  EntryDate 
	          
	            )
        VALUES  ( @fiscalYearId ,
                  ( CAST(DATENAME(MONTH, @monthStartValue) AS NVARCHAR(50))
                    + CAST(@fiscalYear AS NVARCHAR(10)) + '-Week-03' ) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@thirdWeekofMonth) AS NVARCHAR(10)) AS DATETIME) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@thirdWeekofMonthTODate) AS NVARCHAR(10)) AS DATETIME) ,
                  0 ,
                  GETDATE()
                )

        INSERT  INTO dbo.tblWeekSetting
                ( FiscalYearId ,
                  WeekName ,
                  FromDate ,
                  Todate ,
                  EntryBy ,
                  EntryDate 
	          
	            )
        VALUES  ( @fiscalYearId ,
                  ( CAST(DATENAME(MONTH, @monthStartValue) AS NVARCHAR(50))
                    + CAST(@fiscalYear AS NVARCHAR(10)) + '-Week-04' ) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@fourthWeekofMonth) AS NVARCHAR(10)) AS DATETIME) ,
                  CAST(CAST(YEAR(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(MONTH(@monthStartValue) AS NVARCHAR(10)) + '-'
                  + CAST(DAY(@monthEndValue) AS NVARCHAR(10)) AS DATETIME) ,
                  0 ,
                  GETDATE()
                )



        FETCH NEXT FROM db_cursor INTO @monthStartValue, @monthEndValue 
    END 

CLOSE db_cursor  
DEALLOCATE db_cursor

			
    END

