CREATE VIEW [dbo].[View_TotalCurrentStockofCompanyWithStockInTransfar]
AS
SELECT     ProductCode, ProductName, PackSize, SUM(TotalQty) AS TotalQty
FROM         dbo.View_AllStock
GROUP BY ProductCode, ProductName, PackSize
