
/*, YEAR(I.InvoiceDate), MONTH(I.InvoiceDate)*/
CREATE VIEW [dbo].[View_AccountsReceivable_BIReport]
AS
SELECT mas.RegionName_Ord as Zone, SUM(ISNULL(ISNULL(TD.TotalDelivery, 0) - ISNULL(P.PP, 0), 0)) AS Receivable_Amount
FROM     dbo.tblInvoice AS I WITH (nolock) INNER JOIN
                      (SELECT InvoiceId, SUM(DeliveryNetAmount) AS NetAmount, SUM(DeliveryTotalPrice) + SUM(DeliveryTotalPriceVatAmount) - SUM(DeliveryDiscountAmount) AS DeliveryNetAmount, SUM(NetAmount) AS UnitVatAmount, 
                                         SUM(DeliveryDiscountAmount) AS TotalPriceVatAmount
                       FROM      dbo.tblInvoiceDetail
                       GROUP BY InvoiceId) AS tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN
                  dbo.tblOrder AS mas ON mas.OrderId = I.OrderId LEFT OUTER JOIN
                      (SELECT InvoiceId, SUM(ISNULL(TPAmount, 0) + ISNULL(VATAmount, 0)) AS PP
                       FROM      dbo.tblCustPayDetail
                       GROUP BY InvoiceId) AS P ON I.InvoiceId = P.InvoiceId INNER JOIN
                      (SELECT InvoiceId, SUM(PaymentNetAmount) AS TotalDelivery
                       FROM      dbo.tblInvoiceDetail AS IVD WITH (NOLOCK)
                       GROUP BY InvoiceId) AS TD ON I.InvoiceId = TD.InvoiceId AND ISNULL(P.PP, 0) <> ISNULL(TD.TotalDelivery, 0)
WHERE  (ISNULL(ISNULL(TD.TotalDelivery, 0) - ISNULL(P.PP, 0), 0) > 10)
GROUP BY mas.RegionName_Ord
