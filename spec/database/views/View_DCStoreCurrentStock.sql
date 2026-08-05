
CREATE VIEW [dbo].[View_DCStoreCurrentStock]
AS
SELECT     dbo.tblProduct.ProductCode, dbo.tblProduct.ProductName, dbo.tblProduct.PackSize, dbo.tblDCStore.ComUnitId, SUM(dbo.tblDCStore.StockQty) AS TotalQty
FROM         dbo.tblDCStore
 INNER JOIN
                      dbo.tblProduct ON dbo.tblDCStore.ProductCode = dbo.tblProduct.ProductCode  
GROUP BY dbo.tblProduct.ProductCode, dbo.tblProduct.ProductName, dbo.tblProduct.PackSize, dbo.tblDCStore.ComUnitId

