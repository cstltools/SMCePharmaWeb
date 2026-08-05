CREATE VIEW dbo.View_CentralStoreCurrentStock
AS
SELECT     P.ProductCode, P.ProductName, P.PackSize, ISNULL(Vtbl.TotalCurrentStockQty, 0) AS TotalCurrentStockQty, ISNULL(Vtbl.StockCondition, N'Available') AS StockCondition
FROM        dbo.tblProduct AS P LEFT OUTER JOIN
                      (SELECT     TOP (100) PERCENT ProductCode, StockCondition, SUM(Quantity) AS TotalCurrentStockQty
                       FROM        dbo.tblCentralStore
                       WHERE     (Quantity > 0)
                       GROUP BY ProductCode, StockCondition) AS Vtbl ON P.ProductCode = Vtbl.ProductCode
