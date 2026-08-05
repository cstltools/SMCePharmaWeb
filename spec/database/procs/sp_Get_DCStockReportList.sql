
CREATE PROCEDURE [dbo].[sp_Get_DCStockReportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='
SELECT p.ProductCode,p.ProductName,DCS.PackSize,
sum(DCS.StoreQty) + sum(ISNULL(e.ExtraStock, 0)) AS AvailableQty
FROM (
    SELECT ProductCode, PackSize, SUM(StockQty) AS StoreQty
    FROM dbo.tblDCStore DCS
    WHERE DCS.StockQty > 0
      AND StockCondition = ''Available''
     '+@Parm +'
    GROUP BY ProductCode, PackSize
) AS DCS
JOIN dbo.tblProduct AS p
  ON p.ProductCode = DCS.ProductCode
LEFT JOIN (
    SELECT PCode, SUM(ISNULL(Stock, 0)) AS ExtraStock
    FROM dbo.tblStockAdjust
    WHERE Comid = 6
    GROUP BY PCode
) AS e
  ON e.PCode = DCS.ProductCode

  	GROUP BY p.ProductCode,p.ProductName,DCS.PackSize
  ORDER BY p.ProductName ASc'


EXEC sp_executesql @Q

END
             
             
--SELECT p.ProductCode,p.ProductName,DCS.PackSize,
-- sum(DCS.StoreQty) + sum(ISNULL(e.ExtraStock, 0)) AS AvailableQty
--FROM (
--    SELECT ProductCode, PackSize, SUM(StockQty) AS StoreQty
--    FROM dbo.tblDCStore
--    WHERE StockQty > 0
--      AND StockCondition = 'Available'
    
--    GROUP BY ProductCode, PackSize
--) AS DCS
--JOIN dbo.tblProduct AS p
--  ON p.ProductCode = DCS.ProductCode
--LEFT JOIN (
--    SELECT PCode, SUM(ISNULL(Stock, 0)) AS ExtraStock
--    FROM dbo.tblStockAdjust
--    WHERE Comid = 6
--    GROUP BY PCode
--) AS e
--  ON e.PCode = DCS.ProductCode
--  	GROUP BY p.ProductCode,p.ProductName,DCS.PackSize
--  ORDER BY p.ProductName ASc