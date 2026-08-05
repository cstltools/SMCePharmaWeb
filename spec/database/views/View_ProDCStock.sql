CREATE VIEW [dbo].[View_ProDCStock]
AS
SELECT     dbo.tblCompanyUnit.ComUnitCode, dbo.tblDCStore.DCStoreId, dbo.tblDCStore.StorageLocation, dbo.tblDCStore.ProductCode, dbo.tblDCStore.ProductName, dbo.tblDCStore.PackSize, 
                      dbo.tblDCStore.BatchNo, dbo.tblDCStore.TotalQuantity, dbo.tblDCStore.ExpDate, dbo.tblDCStore.ReceiveDate, dbo.tblDCStore.ChalanNo, dbo.tblDCStore.ChalanDate, dbo.tblDCStore.ComUnitId, 
                      dbo.tblDCStore.StockQty, dbo.tblDCStore.DamageQty, dbo.tblDCStore.StockRcvDate, dbo.tblDCStore.ReqId, dbo.tblDCStore.ReqChildId, dbo.tblDCStore.StockInTransfarId
FROM         dbo.tblDCStore LEFT OUTER JOIN
                      dbo.tblCompanyUnit ON dbo.tblDCStore.ComUnitId = dbo.tblCompanyUnit.ComUnitId
