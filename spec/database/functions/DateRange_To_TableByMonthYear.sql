CREATE FUNCTION [dbo].[DateRange_To_TableByMonthYear] ( @MonthVal nvarchar(max), @YearVal  nvarchar(max) )

RETURNS  @Result TABLE(DateString date)

AS

begin

 	declare	@StartDate DATETIME 
declare	@EndDate DATETIME
if(@MonthVal>= 10)
	 begin
	 set  @StartDate=@YearVal+''+@MonthVal+'01' 
	 set  @EndDate=@YearVal+''+@MonthVal+'01' 

	 end
	 else
	 begin
	 set  @StartDate=@YearVal+'0'+@MonthVal+'01' 
	 set  @EndDate=@YearVal+'0'+@MonthVal+'01' 
	 end
SELECT   @StartDate =  @StartDate--'20110501'        
        ,@EndDate   = @EndDate;

		  DECLARE @minDate DATE, @maxDate DATE
		  declare @minDate_Str NVARCHAR(30)  declare @maxDate_Str NVARCHAR(30)
SELECT  @minDate_Str=
CONVERT(VARCHAR(25),
DATEADD(dd,-(DAY(DATEADD(MONTH, x.number, @StartDate))-1), DATEADD(MONTH, x.number, @StartDate)),101)  , @maxDate_Str=
CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,DATEADD(MONTH, x.number, @StartDate)))),DATEADD(mm,1,DATEADD(MONTH, x.number, @StartDate))),101) 
FROM    master..spt_values x
WHERE   x.type = 'P'        
AND     x.number <= DATEDIFF(MONTH, @StartDate, @EndDate)


  
    SET @minDate = CONVERT(Date, @minDate_Str)
    SET @maxDate = CONVERT(Date, @maxDate_Str)


    INSERT INTO @Result(DateString )
    SELECT   CONVERT(Date, @minDate) 



    WHILE @maxDate > @minDate
    BEGIN
        SET @minDate = (SELECT DATEADD(dd,1,@minDate))
        INSERT INTO @Result(DateString )
        SELECT    CONVERT(Date,@minDate)
    END




    return

end   