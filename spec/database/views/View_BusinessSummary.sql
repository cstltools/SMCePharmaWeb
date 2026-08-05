CREATE VIEW [dbo].[View_BusinessSummary]
AS
SELECT     TOP (100) PERCENT tblA.ComUnitCode, tblA.ComUnitId, tblA.ComUnitName, tblA.NumberofProformaInvoice, tblA.SumofNetProformaAmount, tblc.ComUnitId AS Expr1, 
                      ISNULL(tblc.NumberofInvoiceSold, 0) AS NumberofInvoiceSold, ISNULL(tblc.SumofNetSalesAmount, 0) AS SumofNetSalesAmount, tblD.ComUnitId AS Expr2, ISNULL(tblD.NumberofReturnInvoice, 0) 
                      AS NumberofReturnInvoice, ISNULL(tblD.SumofNetReturnAmount, 0) AS SumofNetReturnAmount
FROM         (SELECT     I.ComUnitId, U.ComUnitCode, U.ComUnitName, COUNT(DISTINCT I.InvoiceId) AS NumberofProformaInvoice, SUM(ID.NetAmount) AS SumofNetProformaAmount
                       FROM          dbo.tblInvoice AS I WITH (NOLOCK) INNER JOIN
                                              dbo.tblInvoiceDetail AS ID ON ID.InvoiceId = I.InvoiceId INNER JOIN
                                              dbo.tblCompanyUnit AS U WITH (NOLOCK) ON I.ComUnitId = U.ComUnitId
                       WHERE      (I.TpGrandTotal > 0) AND (I.InvoiceDate BETWEEN '5/1/2018 12:00:00 AM' AND '5/30/2018 12:00:00 AM')
                       GROUP BY I.ComUnitId, U.ComUnitCode, U.ComUnitName) AS tblA LEFT OUTER JOIN
                          (SELECT     dbo.tblInvoice.ComUnitId, COUNT(DISTINCT dbo.tblInvoice.InvoiceId) AS NumberofInvoiceSold, SUM(D.DeliveryNetAmount) AS SumofNetSalesAmount
                            FROM          dbo.tblInvoice WITH (NOLOCK) INNER JOIN
                                                   dbo.tblInvoiceDetail AS D ON dbo.tblInvoice.InvoiceId = D.InvoiceId
                            WHERE      (dbo.tblInvoice.DeliveryInvoiceStatus IN ('Partial', 'Full')) AND (dbo.tblInvoice.TpGrandTotal > 0) AND (dbo.tblInvoice.UpdateDate BETWEEN '5/1/2018 12:00:00 AM' AND 
                                                   '5/30/2018 12:00:00 AM')
                            GROUP BY dbo.tblInvoice.ComUnitId) AS tblc ON tblc.ComUnitId = tblA.ComUnitId LEFT OUTER JOIN
                          (SELECT     CU.ComUnitId, SUM(ID.NetAmount - ID.DeliveryNetAmount) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo) AS NumberofReturnInvoice
                            FROM          dbo.tblInvoice AS I WITH (NOLOCK) INNER JOIN
                                                   dbo.tblInvoiceDetail AS ID ON ID.InvoiceId = I.InvoiceId INNER JOIN
                                                   dbo.tblCompanyUnit AS CU ON CU.ComUnitId = I.ComUnitId
                            WHERE      (ID.DeliveryStatus IN ('Reject', 'Partial')) AND (I.UpdateDate BETWEEN '5/1/2018 12:00:00 AM' AND '5/30/2018 12:00:00 AM') AND (I.TpGrandTotal > 0)
                            GROUP BY CU.ComUnitId, CU.ComUnitCode, CU.ComUnitName) AS tblD ON tblD.ComUnitId = tblA.ComUnitId
ORDER BY tblA.ComUnitCode
