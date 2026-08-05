CREATE VIEW [dbo].[View_AllStock]
AS
SELECT ProductCode,ProductName,PackSize,TotalCurrentStockQty AS TotalQty FROM View_CentralStoreCurrentStock
UNION ALL
SELECT ProductCode,ProductName,PackSize,TotalQty FROM View_DCStoreCurrentStock
UNION ALL
SELECT ProductCode,ProductName,PackSize,Quantity AS TotalQty FROM tblStockInTransfar WHERE (IsTransfared IS NULL OR IsTransfared ='') AND IsIssue='OK'
