
CREATE
 FUNCTION [dbo].[GetmonthlycustomerSaleDate] (
    @FromDate DATETIME,
	@ToDate DATETIME
)
RETURNS TABLE
AS
RETURN
    --SalesDisDB_SMC

SELECT C.CustomerMasterId,C.CustomerCode AS CustomerCode, C.CustomerName AS CustomerName,
-- ,ISNULL(tblA.ComUnitCode,'BD27')Depocode,ISNULL(tblA.ComUnitName,'Kustia Distribution Center')deponame,

(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))  -  (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) AS SumofNetSalesAmount

FROM dbo.tblCustMaster C WITH(NOLOCK) 

	  
	   
LEFT JOIN (SELECT I.CustomerMasterId,SUM(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat
-- ,U.ComUnitCode,U.ComUnitName
FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit U WITH (NOLOCK) ON I.ComUnitId = U.ComUnitId 
WHERE  (I.InvoiceDate BETWEEN @FromDate AND @ToDate)  
GROUP BY I.CustomerMasterId )tblA ON tblA.CustomerMasterId=C.CustomerMasterId 
	  
	    
LEFT JOIN (SELECT I.CustomerMasterId,SUM(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount) AS 
SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  
WHERE  I.InvoiceDate BETWEEN  @FromDate AND @ToDate  GROUP BY I.CustomerMasterId)tblAA ON tblAA.CustomerMasterId=C.CustomerMasterId 
	   
	   
			 
LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,I.CustomerMasterId, ((SUM(ID.NetAmount))) AS 
SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount) AS TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.InvoiceDate BETWEEN  @FromDate AND @ToDate  
GROUP BY I.CustomerMasterId)tblD ON tblD.CustomerMasterId = C.CustomerMasterId  
			
			
LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, I.CustomerMasterId, ((SUM(ID.NetAmount))) 
AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount) AS TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)
INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.InvoiceDate BETWEEN  @FromDate AND @ToDate AND I.TpGrandTotal>0  
GROUP BY I.CustomerMasterId)tblDD ON tblDD.CustomerMasterId = C.CustomerMasterId 
			 
	
	





