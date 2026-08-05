
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_GET_MonthwiseSale] 


    @FromDate nvarchar(Max),
	@ToDate nvarchar(Max)
		
AS
BEGIN


	DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX),@othermonth nvarchar(max)
	SET @columns = N'';
	SELECT @columns+=N', p.'+QUOTENAME([Name])
	FROM
	(
	SELECT   [MonthYear] AS [Name] FROM F_MonthName(@FromDate,@ToDate)
	AS p
    
	) AS x ;
	set @othermonth=N'';
	SELECT @othermonth+=N', null as '+QUOTENAME(monthname)
	FROM
	(
	SELECT
 number,
 DATENAME(MONTH, '1900-' + CAST(number as varchar(2)) + '-1') monthname
FROM master..spt_values
WHERE Type = 'P' and number between 1 and 12 and DATENAME(MONTH, '1900-' + CAST(number as varchar(2)) + '-1') not in(SELECT   [MonthYear]  FROM F_MonthName(@FromDate,@ToDate))


	) AS x ;

	SET @sql = N'
	SELECT  [SalesManCode] , [SalesManName],[Designation], '+STUFF(@columns, 1, 2, '')+','+STUFF(@othermonth, 1, 2, '')+' , [TotalSaleAmount] as [Total]  FROM (
	SELECT [SalesManCode] , [SalesManName],[Designation], [SaleAmount] as [TS]  , [TotalSaleAmount] ,[MonthYear] as [Name] 
	FROM dbo.GetMonthWiseSale('''+@FromDate+''','''+@ToDate+'''))   AS j PIVOT (SUM(TS) FOR [Name] in 
	('+STUFF(REPLACE(@columns, ', p.[', ',['), 1, 1, '')+')) AS p;';
	EXEC sp_executesql @sql

END


