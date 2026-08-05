

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_GET_DatewiseSale] 


    @FromDate nvarchar(Max),
	@ToDate nvarchar(Max)
		
AS
BEGIN


	DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX),@otherdate nvarchar(max)
	SET @columns = N'';
	SELECT @columns+=N', p.'+QUOTENAME([Name])
	FROM
	(
	SELECT   day(MainDate) AS [Name] FROM F_DateName(@FromDate,@ToDate)
	AS p
    
	) AS x ;
	set @otherdate=N'';
	SELECT @otherdate+=N', null as '+QUOTENAME(DayNo)
	FROM
	(
	
	select day(DayNo) as DayNo from GetDayes() where day(DayNo) not in (SELECT   day(MainDate) FROM F_DateName(@FromDate,@ToDate))
	
    
	) AS x ;

	SET @sql = N'
	SELECT  [SalesManCode] , [SalesManName],[Designation], '+STUFF(@columns, 1, 2, '')+','+STUFF(@otherdate, 1, 2, '')+'   FROM (
	SELECT [SalesManCode] , [SalesManName],[Designation], [SaleAmount]  AS [TS], day(MainDate) as [Name] 
	FROM dbo.GetDateWiseSale('''+@FromDate+''','''+@ToDate+'''))   AS j PIVOT (SUM(TS) FOR [Name] in 
	('+STUFF(REPLACE(@columns, ', p.[', ',['), 1, 1, '')+')) AS p;';
	EXEC sp_executesql @sql

END



