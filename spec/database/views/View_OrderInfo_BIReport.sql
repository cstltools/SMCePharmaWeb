

CREATE VIEW [dbo].[View_OrderInfo_BIReport]
AS
SELECT TOP (100) PERCENT ord.RegionName_Ord AS Zone_Name, CASE WHEN ord.PaymentType = 'COD' THEN 'Cash' WHEN ord.PaymentType = 'NCOD' THEN 'Credit' ELSE ord.PaymentType END AS Order_Type, DATENAME(month, 
                  ord.SubmissionDate) AS Order_Month, YEAR(ord.SubmissionDate) AS Order_Year, SUM(orddtl.Quantity) AS Order_Quantity, SUM(orddtl.NetAmount) AS Order_Amount
FROM     dbo.tblOrder AS ord WITH (nolock) INNER JOIN
                  dbo.tblOrderDetail AS orddtl WITH (nolock) ON ord.OrderId = orddtl.OrderId
WHERE  (ord.RegionName_Ord IS NOT NULL)  
GROUP BY ord.RegionName_Ord, ord.PaymentType, DATENAME(month, ord.SubmissionDate), MONTH(ord.SubmissionDate), YEAR(ord.SubmissionDate)
ORDER BY Order_Year, MONTH(ord.SubmissionDate), Zone_Name


