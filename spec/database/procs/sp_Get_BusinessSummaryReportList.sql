
CREATE PROCEDURE [dbo].[sp_Get_BusinessSummaryReportList]
-- Add the parameters for the stored procedure here
@fromdate datetime,
@todate datetime
AS
BEGIN 

SELECT ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,

tblORD.NumberofOrder,tblORD.NumberOfOrderValue, C.ComUnitCode,C.ComUnitId,C.ShortName,
ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ComUnitId,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ComUnitId,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 


,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt



,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) AS salesTP
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
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate and @todate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId = C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId = C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblD ON tblD.ComUnitId = C.ComUnitId    LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate and @todate  GROUP BY I.ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN (SELECT I.ComUnitId, (SUM(GrossValue)) AS NumberOfOrderValue,count(DISTINCT I.OrderCode) NumberofOrder FROM dbo.tblOrder I WITH (NOLOCK)  where  I.SubmissionDate  BETWEEN @fromdate and @todate GROUP BY I.ComUnitId)tblORD ON tblORD.ComUnitId = C.ComUnitId  LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId   )tblUnD ON tblUnD.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId  FROM dbo.tblCustMaster GROUP BY ComUnitId) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE InvoiceDate BETWEEN @fromdate and @todate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov  ON tblCov.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId  FROM dbo.tblCustMaster GROUP BY ComUnitId) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId  FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE InvoiceDate BETWEEN @fromdate and @todate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov2  ON tblCov.ComUnitId = C.ComUnitId 
--ORDER BY C.ComUnitName
				 




--union all




				 
--SELECT ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
--ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
--ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
--ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,

--tblORD.NumberofOrder,tblORD.NumberOfOrderValue, C.ComUnitCode,C.ComUnitId,C.ShortName,
--ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ComUnitId,
--ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ComUnitId,
--ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
--,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
--,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
--,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 


--,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
--,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
--,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt



--,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) AS salesTP
--,((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesVat
--,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) +
--((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesTotal


--,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
--- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
--- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
--AS Outstanding1

	
--,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
--- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
--- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
--AS Outstanding2

--, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
--- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
--- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +

--((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
--- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
--- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3


--FROM SalesDisDB_SMC..tblCompanyUnit C with(NoLock) 
--LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
--AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID 
--WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
--WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate and @todate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId 
--LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,
--SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
--FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
--WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate and @todate  
--GROUP BY  ComUnitId)tblc ON tblc.ComUnitId = C.ComUnitId  
  
--LEFT JOIN 
--(SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, 
--SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
--FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail D WITH (NOLOCK) 
--ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  
--AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId = C.ComUnitId  
--LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))-
--SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
--COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as
--TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID 
--WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial')
--AND I.UpdateDate BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblD ON tblD.ComUnitId = C.ComUnitId 
--LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) 
--AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) 
--INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate 
--BETWEEN @fromdate and @todate  GROUP BY I.ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  
--LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- 
--SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
--NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount 
--FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
--where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  
--GROUP BY I.ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN (SELECT I.ComUnitId, (SUM(GrossValue)) 
--AS NumberOfOrderValue,count(DISTINCT I.OrderCode) NumberofOrder FROM SalesDisDB_SMC..tblOrder I WITH (NOLOCK)  
--where  I.SubmissionDate  BETWEEN @fromdate and @todate GROUP BY I.ComUnitId)tblORD ON tblORD.ComUnitId = C.ComUnitId  
--LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,
--SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat
--FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail D 
--WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null 
--AND InvoiceDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN
--(  SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) 
--SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail
--D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND
--InvoiceDate BETWEEN @fromdate and @todate   GROUP BY  ComUnitId   )tblUnD
--ON tblUnD.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer 
--,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId 
--FROM SalesDisDB_SMC..tblCustMaster GROUP BY ComUnitId) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId      
--FROM SalesDisDB_SMC..tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM SalesDisDB_SMC..tblInvoice 
--WHERE InvoiceDate BETWEEN @fromdate and @todate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    )
--tblCov  ON tblCov.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) 
--CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId
--FROM SalesDisDB_SMC..tblCustMaster GROUP BY ComUnitId) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId 
--FROM SalesDisDB_SMC..tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
--FROM SalesDisDB_SMC..tblSubInvoiceMaster WHERE InvoiceDate BETWEEN @fromdate and @todate) GROUP BY ComUnitId) ) 
--AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov2  ON tblCov.ComUnitId = C.ComUnitId 
				 
















END
              