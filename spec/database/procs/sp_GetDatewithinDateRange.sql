CREATE PROCEDURE [dbo].[sp_GetDatewithinDateRange]
	-- Add the parameters for the stored procedure here
	@fDate DATETIME,
	@tDate DATETIME

AS
BEGIN
		
	 
with [dates] as (
    select convert(datetime, @fDate) as [date] --start
    union all
    select dateadd(day, 1, [date])
    from [dates]
    where [date] < @tDate --end
)
select    FORMAT( CONVERT(Date,[date])  ,'dd MMM, yyyy')  AS DWSPDate,'' GeneralAmount,'' FCBAmount,'' CampaignAmount
from [dates]
where [date] between @fDate and @tDate
END







