
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_GET_EmployeeWiseProductSale] 
		
AS
BEGIN

	DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX)
	SET @columns = N'';
	SELECT @columns+=N', p.'+QUOTENAME([Name])
	FROM
	(
	SELECT   ProductName   AS [Name] FROM F_ProductNameFromEmpSale()
	AS p
    
	) AS x ;
	SET @sql = N'
	SELECT  [SalesManCode] , [SalesManName],[SaleAmount], '+STUFF(@columns, 1, 2, '')+' ,[Designation] , [Discount] , [vat] , [NetSales]  FROM (
	SELECT [SalesManCode] , [SalesManName],[SaleAmount],[Designation] , [Discount] , [vat] , [NetSales], [TDqty] AS [Quantity], [ProductName] as [Name] 
	FROM EmployeeSale()   ) AS j PIVOT (SUM(Quantity) FOR [Name] in 
	('+STUFF(REPLACE(@columns, ', p.[', ',['), 1, 1, '')+')) AS p;';
	EXEC sp_executesql @sql

END

