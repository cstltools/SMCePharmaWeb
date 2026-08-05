-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_MiowiseMISReport] 

    @unitid INT,
	@fromdate datetime,
	@todate datetime
AS
BEGIN

SELECT 
ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,



ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 


,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt


,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) AS salesTP
,((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesVat
,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) +
((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesTotal


,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
AS Outstanding1

	
,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
AS Outstanding2

, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +

((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3,


C.MIAName
FROM dbo.tblMIAInfo C with(NoLock) 
--1
LEFT JOIN (SELECT I.ComUnitId,I.MIACode,I.MiaName,COUNT(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.ComUnitId=@unitid AND I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId,I.MIACode,I.MiaName)tblA ON tblA.MIACode=C.MIACode



--2
LEFT JOIN   (SELECT ComUnitId,MIACode,MiaName,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
WHERE ComUnitId=@unitid AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate AND @todate  
GROUP BY  ComUnitId,MIACode,MiaName)tblc  ON tblc.MIACode=C.MIACode   
  
  --3
LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   
WHERE ComUnitId=@unitid AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate AND @todate   
GROUP BY  ComUnitId,MIAName,MIACode)tblcc ON tblcc.MIACode=C.MIACode  
  
  
LEFT JOIN (SELECT I.ComUnitId,MIAName,MiaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where I.ComUnitId=@unitid AND ID.DeliveryStatus IN ('Reject','Partial') AND I.InvoiceDate 
BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId,MIAName,MiaCode)tblD ON tblD.MiaCode=C.MiaCode    
  
  
  
LEFT JOIN (SELECT I.ComUnitId,MIAName,MiaCode,COUNT(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount, 
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  
WHERE I.ComUnitId=@unitid  AND I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId,MIAName,MiaCode)tblAA ON tblAA.MiaCode=C.MiaCode
  
  
LEFT JOIN (SELECT I.ComUnitId,MIAName,MiaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ComUnitId=@unitid AND ID.DeliveryStatus IN ('Reject','Partial') AND I.InvoiceDate   BETWEEN  
@fromdate AND @todate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId,MIAName,I.MIACode)tblDD ON tblDD.MIACode = C.MiaCode  
	 
	 
	 
LEFT JOIN   (  SELECT ComUnitId,MIAName,MiaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , 
SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
WHERE ComUnitId=@unitid and DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId,MIAName,MIACode  )tblUn 
ON tblUn.MIACode = C.MiaCode   
	  
	  
	  
LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount ,  
SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE ComUnitId=@unitid AND   
DeliveryInvoiceStatus IS null AND InvoiceDate  BETWEEN @fromdate AND @todate GROUP BY  ComUnitId,MIAName,MiaCode )tblUnD ON tblUnD.MiaCode = C.MiaCode 
	  
	  
	  
LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode, SUM(D.DeliveryNetAmount ) SumTpSales , SUM(D.DeliveryTotalPriceVatAmount)vat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D 
WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE ComUnitId=@unitid AND   DeliveryInvoiceStatus IS not null AND UpdateDate  BETWEEN @fromdate AND @todate
GROUP BY  ComUnitId,MIAName,MiaCode )tblActualSales ON tblActualSales.MiaCode = C.MiaCode  
		
		
LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode, SUM(D.DeliveryNetAmount ) SumTpSales , 	 SUM(D.DeliveryTotalPriceVatAmount)vat FROM dbo.tblSubInvoiceMaster  
WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE ComUnitId=@unitid AND    DeliveryInvoiceStatus IS not null AND UpdateDate
BETWEEN @fromdate AND @todate  GROUP BY  ComUnitId,MIAName,MiaCode )tblActualSalesSUb ON tblActualSalesSUb.MiaCode = C.MiaCode  
WHERE tblActualSales.ComUnitId=@unitid OR tblActualSalesSub.ComUnitId=@unitid OR      tblA.ComUnitId=@unitid OR tblc.ComUnitId=@unitid OR tblcc.ComUnitId=@unitid OR tblD.ComUnitId=@unitid OR tblAA.ComUnitId=@unitid 
OR tblDD.ComUnitId=@unitid OR tblUnD.ComUnitId=@unitid 
		   
		   
		   
ORDER BY C.MIACode


END