create PROCEDURE [dbo].[sp_Get_FirstDate_LastDatebyYearMonth]
	-- Add the parameters for the stored procedure here
	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN
		
	 
SELECT   @StartDate =  @StartDate--'20110501'        
        ,@EndDate   = @EndDate;


SELECT  DATENAME(MONTH, DATEADD(MONTH, x.number, @StartDate)) AS MonthName,
CONVERT(VARCHAR(25),
DATEADD(dd,-(DAY(DATEADD(MONTH, x.number, @StartDate))-1),DATEADD(MONTH, x.number, @StartDate)),101) as FirstDay,
CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,DATEADD(MONTH, x.number, @StartDate)))),DATEADD(mm,1,DATEADD(MONTH, x.number, @StartDate))),101) as LastDay
FROM    master..spt_values x
WHERE   x.type = 'P'        
AND     x.number <= DATEDIFF(MONTH, @StartDate, @EndDate)
END







