 
 CREATE PROCEDURE [dbo].[sp_RecoverOrderInfo]
	 
AS
BEGIN
 UPDATE o
SET o.isInvoice = 0
FROM tblOrder o
INNER JOIN tblOrder c ON o.OrderId = c.OrderId
LEFT JOIN tblInvoice i ON c.OrderCode = i.OrderNo
WHERE c.isInvoice = 1
  AND i.OrderNo IS NULL
  AND CAST(c.SubmissionDate AS DATE) = CAST(GETDATE() AS DATE)



  


UPDATE tblOrder
SET ComUnitId = 20
WHERE OrderCode IN (
    SELECT DISTINCT tblOrder.OrderCode
    FROM tblOrder
    INNER JOIN tblOrderDetail ON tblOrder.OrderId = tblOrderDetail.OrderId
    WHERE tblOrder.SubmissionDate BETWEEN '2025-07-01' AND CAST(GETDATE() AS DATE)
      AND tblOrder.CustTypeId = 1
      AND tblOrder.TotalDiscount = 0
      AND tblOrderDetail.CampaignName = ' '
      AND tblOrder.IsInvoice = 0
)




 end