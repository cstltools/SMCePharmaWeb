CREATE VIEW dbo.View_SalesCollectionDue_BIReport
AS
SELECT TOP (100) PERCENT ord.RegionName_Ord AS Region, YEAR(A.UpdateDate) AS SalesYear, MONTH(A.UpdateDate) AS SalesMonth, SUM(CONVERT(DECIMAL(18, 2), ISNULL(ID.TotalPrice - ID.DiscountAmount, 0) 
                  - ISNULL(ID.AdjustmentAmount, 0))) AS TotalSales, SUM(tblpay.PaymentAmount) AS TotalPaymentAmount
FROM     dbo.tblInvoice AS A WITH (NOLOCK) INNER JOIN
                  dbo.tblInvoiceDetail AS ID WITH (NOLOCK) ON A.InvoiceId = ID.InvoiceId INNER JOIN
                  dbo.tblOrder AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId LEFT OUTER JOIN
                      (SELECT SUM(TPAmount) AS PaymentAmount, custPaymentDate
                       FROM      dbo.tblCustPayDetail
                       GROUP BY custPaymentDate) AS tblpay ON tblpay.custPaymentDate = A.UpdateDate
WHERE  (A.DeliveryInvoiceStatus IN ('Full', 'Partial'))
GROUP BY ord.RegionName_Ord, YEAR(A.UpdateDate), MONTH(A.UpdateDate)
ORDER BY Region, SalesYear, SalesMonth
