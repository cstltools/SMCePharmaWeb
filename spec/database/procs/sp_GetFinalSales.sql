-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetFinalSales] 

	@fromdate datetime,
	@todate datetime
AS
BEGIN

	select tblProductSQ.ProductSQName,
--BSP
--(isnull(tblblue2018.Amount,0)-isnull(tblblue2018up.Amount,0)) BSP2018
(isnull(tblblue2019.Amount,0)) BSP2019

--'Green Star' 

--,(isnull(tblgreen2018.Amount,0)-isnull(tblgreen2018Up.Amount,0)) Green2018
,(isnull(tblgreen2019.Amount,0)) Green2019



-- other
--,(isnull(tbOther2018.Amount,0)-isnull(tbOther2018up.Amount,0)) Other2018
,(isnull(tblother2019.Amount,0)) OTHER2019


from tblProductSQ

--select * from tblProgramType

 left join  (SELECT  SQ.ProductSQName as Brand  ,  ( (sum(ID.DeliveryNetAmount))) as Amount
FROM dbo.tblInvoice I  with(nolock)
left join tblOrder on I.OrderId=tblOrder.OrderId
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

left JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode left JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 


left JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
left JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
left JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
where (tblOrder.ProgramTypeId=1) and TotalPrice>0
                       and I.UpdateDate between @fromdate and @todate

					   group by SQ.ProductSQName)tblgreen2019 on tblProductSQ.ProductSQName = tblgreen2019.Brand




					   --------------------------------------

--					  left join  (SELECT  SQ.ProductSQName as Brand  ,  ((SUM(ID.NetAmount))- SUM(ID.DeliveryNetAmount)) as Amount
--FROM dbo.tblInvoice I  with(nolock)
--inner join tblOrder on I.OrderId=tblOrder.OrderId
--INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

--INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 


--INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
--where (tblOrder.ProgramTypeId=1) and ID.DeliveryStatus IN ('Reject','Partial') and TotalPrice>0
--                       and I.InvoiceDate between @fromdate and @todate 

--					   group by SQ.ProductSQName)tblgreen2019up on tblProductSQ.ProductSQName = tblgreen2019up.Brand



----------------------------------------------------------------



					   







 left join  (SELECT  SQ.ProductSQName as Brand  ,  ( (sum(ID.DeliveryNetAmount))) as Amount
FROM dbo.tblInvoice I  with(nolock)
left join tblOrder on I.OrderId=tblOrder.OrderId
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

left JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode left JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 


left JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
left JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
left JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
where (tblOrder.ProgramTypeId=2) and TotalPrice>0
                       and I.UpdateDate between @fromdate and @todate 

					   group by SQ.ProductSQName)tblblue2019 on tblProductSQ.ProductSQName = tblblue2019.Brand

					   ----------------------------
--					  left join  (SELECT  SQ.ProductSQName as Brand  ,  ((SUM(ID.NetAmount))- SUM(ID.DeliveryNetAmount)) as Amount
--FROM dbo.tblInvoice I  with(nolock)
--inner join tblOrder on I.OrderId=tblOrder.OrderId
--INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

--INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 


--INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
--where (tblOrder.ProgramTypeId=2) and ID.DeliveryStatus IN ('Reject','Partial') and TotalPrice>0
--                       and I.InvoiceDate between @fromdate and @todate 

--					   group by SQ.ProductSQName)tblblue2019up on tblProductSQ.ProductSQName = tblblue2019up.Brand


					   -----------------------------





					   





 left join  (SELECT  SQ.ProductSQName as Brand  ,  ( (sum(ID.DeliveryNetAmount))) as Amount
FROM dbo.tblInvoice I  with(nolock)
left join tblOrder on I.OrderId=tblOrder.OrderId
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

left JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode left JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 


left JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
left JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
left JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
where (tblOrder.ProgramTypeId=3 or tblOrder.ProgramTypeId=4 or tblOrder.ProgramTypeId=5 or tblOrder.ProgramTypeId=6 or tblOrder.ProgramTypeId=7 or tblOrder.ProgramTypeId=8
or tblOrder.ProgramTypeId=9 or tblOrder.ProgramTypeId=10 or tblOrder.ProgramTypeId=11 or tblOrder.ProgramTypeId=12 or tblOrder.ProgramTypeId is null) and TotalPrice>0
                       and I.UpdateDate between @fromdate and @todate 

					   group by SQ.ProductSQName)tblother2019 on tblProductSQ.ProductSQName = tblother2019.Brand

--					  left join  (SELECT  SQ.ProductSQName as Brand  ,  ((SUM(ID.NetAmount))- SUM(ID.DeliveryNetAmount)) as Amount
--FROM dbo.tblInvoice I  with(nolock)
--inner join tblOrder on I.OrderId=tblOrder.OrderId
--INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

--INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 


--INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
--where (tblOrder.ProgramTypeId=3 or tblOrder.ProgramTypeId=4)and ID.DeliveryStatus IN ('Reject','Partial') and TotalPrice>0
--                       and I.InvoiceDate between @fromdate and @todate

--					   group by SQ.ProductSQName)tblother2019up on tblProductSQ.ProductSQName = tblother2019up.Brand








					   

					
					  order by ProductSQName
	
END
