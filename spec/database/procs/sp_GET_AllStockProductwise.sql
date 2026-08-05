
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_GET_AllStockProductwise] 
		
AS
BEGIN

	DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX)
	SET @columns = N'';
	SELECT @columns+=N', p.'+QUOTENAME([Name])
	FROM
	(
	SELECT   ProductName   AS [Name] FROM F_ProductName()
	AS p
    
	) AS x ;
	SET @sql = N'
	SELECT  [TotalValueAmount] , [DistributionCenterCode],[DistributionCenter], '+STUFF(@columns, 1, 2, '')+' ,[Total] as [Total Qty]  FROM (
	SELECT [TotalValueAmount] , [DistributionCenterCode],[DistributionCenter],[Total] , [StockQty] AS [Quantity], [ProductName] as [Name] 
	FROM GetDCwiseStock()   ) AS j PIVOT (SUM(Quantity) FOR [Name] in 
	('+STUFF(REPLACE(@columns, ', p.[', ',['), 1, 1, '')+')) AS p;';
	EXEC sp_executesql @sql

END

