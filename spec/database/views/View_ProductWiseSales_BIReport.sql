CREATE VIEW dbo.View_ProductWiseSales_BIReport
AS
SELECT TOP (100) PERCENT ord.RegionName_Ord AS Region, YEAR(A.UpdateDate) AS SalesYear, MONTH(A.UpdateDate) AS SalesMonth, dbo.tblProduct.ProductName, SUM(CONVERT(DECIMAL(18, 2), ISNULL(ID.TotalPrice - ID.DiscountAmount, 
                  0) - ISNULL(ID.AdjustmentAmount, 0))) AS TotalSales
FROM     dbo.tblInvoice AS A WITH (NOLOCK) INNER JOIN
                  dbo.tblInvoiceDetail AS ID WITH (NOLOCK) ON A.InvoiceId = ID.InvoiceId INNER JOIN
                  dbo.tblOrder AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId INNER JOIN
                  dbo.tblProduct ON dbo.tblProduct.ProductCode = ID.ProductCode
WHERE  (A.DeliveryInvoiceStatus IN ('Full', 'Partial'))
GROUP BY ord.RegionName_Ord, MONTH(A.UpdateDate), YEAR(A.UpdateDate), dbo.tblProduct.ProductName
ORDER BY Region, SalesYear, SalesMonth, dbo.tblProduct.ProductName
