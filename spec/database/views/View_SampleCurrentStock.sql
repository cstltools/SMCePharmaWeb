CREATE VIEW dbo.View_SampleCurrentStock
AS
SELECT dbo.tblProduct.ProductCode, dbo.tblProduct.ProductName, dbo.tblProduct.PackSize, SUM(dbo.tblGroupWisePromoQty.TransactionQTY) AS TotalQty, dbo.tblGroupWisePromoQty.EmpInfoId
FROM   dbo.tblGroupWisePromoQty INNER JOIN
             dbo.tblProduct ON dbo.tblGroupWisePromoQty.ProductId = dbo.tblProduct.ProductId
GROUP BY dbo.tblProduct.ProductCode, dbo.tblProduct.ProductName, dbo.tblProduct.PackSize, dbo.tblGroupWisePromoQty.EmpInfoId
