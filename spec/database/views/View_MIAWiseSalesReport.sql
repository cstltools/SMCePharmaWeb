CREATE VIEW [dbo].[View_MIAWiseSalesReport]
AS
SELECT     I.InvoiceDate, I.ComUnitId, I.CustomerMasterId, I.MiaId, IDE.ProductCode, IDE.ProductName + ':' + IDE.PackSize AS Product, SUM(IDE.TotalQuantity) AS TotalQuantity, 
                      SUM(IDE.TotalQuantity * IDE.UnitPrice) AS Price
FROM         dbo.tblInvoiceDetail AS IDE LEFT OUTER JOIN
                      dbo.tblInvoice AS I ON IDE.InvoiceId = I.InvoiceId
GROUP BY I.InvoiceDate, I.ComUnitId, I.CustomerMasterId, I.MiaId, IDE.ProductCode, IDE.ProductName + ':' + IDE.PackSize
