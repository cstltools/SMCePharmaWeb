
CREATE VIEW [dbo].[View_Return_BIReport]
AS
SELECT TOP (100) PERCENT mas.RegionName_Ord AS Zone, SUM(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0)) + SUM(ISNULL(ID.DeliveryTotalPriceVatAmount - ID.PaymentTotalPriceVatAmount, 0)) 
                  - SUM(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0)) AS Return_Amount, SUM(ISNULL(ID.DeliveryTotalQuantity - ID.PaymentTotalQuantity, 0)) AS Return_Qty, YEAR(I.PaymentDate) AS Year, DATENAME(month, 
                  I.PaymentDate) AS Month, CASE WHEN LTRIM(RTRIM(ID.PaymentReturnReason)) = '' THEN 'No Order' ELSE ID.PaymentReturnReason END AS Return_Reason
FROM     dbo.tblInvoice AS I WITH (nolock) INNER JOIN
                  dbo.tblOrder AS mas ON mas.OrderId = I.OrderId INNER JOIN
                  dbo.tblInvoiceDetail AS ID ON ID.InvoiceId = I.InvoiceId
WHERE  (I.PaymentInvoiceNo IS NOT NULL) AND (ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)) AND (ID.PaymentReturnReason IS NOT NULL)
GROUP BY mas.RegionName_Ord, YEAR(I.PaymentDate), DATENAME(month, I.PaymentDate), LTRIM(RTRIM(ID.PaymentReturnReason)), ID.PaymentReturnReason
ORDER BY Zone, Year, Month
