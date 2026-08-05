CREATE VIEW dbo.VIew_SubDepotCurrentStock
AS
SELECT     dbo.tblProduct.ProductCode, dbo.tblProduct.ProductName, dbo.tblProduct.PackSize, dbo.tblSubDepotStore.SubDepotId, SUM(dbo.tblSubDepotStore.StockQty) AS TotalQty
FROM        dbo.tblSubDepotStore INNER JOIN
                  dbo.tblProduct ON dbo.tblSubDepotStore.ProductCode = dbo.tblProduct.ProductCode
GROUP BY dbo.tblProduct.ProductCode, dbo.tblProduct.ProductName, dbo.tblProduct.PackSize, dbo.tblSubDepotStore.SubDepotId
