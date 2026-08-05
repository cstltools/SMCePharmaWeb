-- =============================================
-- =============================================
create PROCEDURE [dbo].[sp_ValuewiseBusinessSummaryReport] 

	@fromdate datetime,
	@todate datetime
AS
BEGIN



SELECT 
ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,


C.ShortName,
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
- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3


FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId


 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=C.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=C.ComUnitId 
  
  
  --return start
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=C.ComUnitId     
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId 
	 --return end
	 
	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN @fromdate AND @todate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  
	  
	  
	   LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount ,
	    SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
		 WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId 
		 
		 
		 
		 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM 
		 dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate 
		 BETWEEN @fromdate AND @todate GROUP  BY  ComUnitId )tblUnD ON tblUnD.ComUnitId = C.ComUnitId 



ORDER BY C.ShortName




END
