


--SELECT distinct programtype FROM tblsubinvoicemaster  where InvoiceDate between '7/1/2020' and '11/3/2020' 

--SELECT distinct types FROM tblinvoice  where InvoiceDate between '7/1/2020' and '11/3/2020' 

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_GET_DZSMwiseReport] 

    @FromDate nvarchar(Max),
	@ToDate nvarchar(Max),
	@Dzsm  nvarchar(Max)
		
AS
BEGIN

Select ISNULL(tblA.RegionCode,tblc.RegionCode)RegionCode 
--,ISNULL(tblA.AreaCode,tblc.AreaCode)AreaCode 
-- ,ISNULL(tblA.AreaName,tblc.AreaName)AreaName,

, ISNULL(tblA.AreaCode,C.AreaCode) AreaCode
 ,ISNULL(tblA.AreaName,C.AreaName) AreaName,

ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
ISNULL(tblCov3.CustomerCoverPer,0)+ISNULL(tblCov4.CustomerCoverPer,0) AS CustomerCoverPerProforma,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,

ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,
((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales,

ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2


,(ISNULL(tblAllBlue.SumofNetProformaAmount,0)+ISNULL(tblSubBlue.SumofNetProformaAmount,0)) BlueNetSell, (ISNULL(tblAllGreen.SumofNetProformaAmount,0)+ISNULL(tblSubGreen.SumofNetProformaAmount,0)) GreenNetSell 
,(ISNULL(tblAllBlueDel.SumofNetProformaAmount,0)+ISNULL(tblAllBlueSubDel.SumofNetProformaAmount,0)) DelBlueNetSell, (ISNULL(tblAllGreenDel.SumofNetProformaAmount,0)+ISNULL(tblAllGreenSubDel.SumofNetProformaAmount,0)) DelGreenNetSell 

,(ISNULL(tblAllBlueCov.CustomerCoverPer,0)+ISNULL(tblSubBlueCov2.CustomerCoverPer,0)) BlueCov, (ISNULL(tblAllGreenCov.CustomerCoverPer,0)+ISNULL(tblsubGreenCov2.CustomerCoverPer,0)) greenCov 
,(ISNULL(tblDelBlueCov.CustomerCoverPer,0)+ISNULL(tblDelBlueCovSub.CustomerCoverPer,0)) DelBlueCov, (ISNULL(tblDelGreenCov.CustomerCoverPer,0)+ISNULL(tblDelGreenCovSub.CustomerCoverPer,0)) DelgreenCov 





FROM dbo.tblArea C with(NoLock) 


LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode 



LEFT JOIN (SELECT RegionCode,A.AreaName,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON A.AreaCode = tblInvoice.AreaCode
 WHERE DeliveryInvoiceStatus IN  
('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY RegionCode,tblInvoice.AreaCode,A.AreaName)tblc 
ON tblc.AreaCode = C.AreaCode 



LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - 
D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH 
(NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  
AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc
 ON tblcc.AreaCode = C.AreaCode      
 
 
 
LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate
 AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode  




LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  
GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  




LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, 
SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode 
WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   
GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    




LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
WHERE (D.IsCampaignProduct=1) AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  
UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode 
--D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign' 




LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, 
SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode 
WHERE (D.IsCampaignProduct=1) AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate between @FromDate and @ToDate
  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode     





LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  
SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1  AND 
TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  




LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount)
SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate 
GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    




LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  
SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.IsCampaignProduct=1)  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON 
tblCampPro.AreaCode = C.AreaCode  






LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) 
SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.IsCampaignProduct=1)  AND TpGrandTotal>0 AND InvoiceDate BETWEEN 
@FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode    




LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND 
I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode 



LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT 
I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   




---Customer Coverage for Delivery

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode  


LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode  
---Customer Coverage for Delivery end






---Customer Coverage for Proforma

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM dbo.tblInvoice WHERE  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov3  ON tblCov3.AreaCode = C.AreaCode  


LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov4  ON tblCov4.AreaCode = C.AreaCode  

---Customer Coverage for Proforma end







--BSP,GSP start Blue

--proforma
LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE  types='Blue Star' and I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblAllBlue ON tblAllBlue.AreaCode=C.AreaCode 


LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE types='Green Star' and I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblAllGreen ON tblAllGreen.AreaCode=C.AreaCode 


--Del

LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,SUM(ID.DeliveryNetAmount)-sum(ID.DeliveryTotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.DeliveryTotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE  types='Blue Star' and I.TpGrandTotal>0 AND I.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblAllBlueDel ON tblAllBlueDel.AreaCode=C.AreaCode 


LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE types='Green Star' and I.TpGrandTotal>0 AND I.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblAllGreenDel ON tblAllGreenDel.AreaCode=C.AreaCode 



-- sub



LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ProgramType='Blue Star' and I.TpGrandTotal>0 AND 
I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblSubBlue ON tblSubBlue.AreaCode=C.AreaCode 




LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ProgramType='Green Star' and I.TpGrandTotal>0 AND 
I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblSubGreen ON tblSubGreen.AreaCode=C.AreaCode 

--Del

LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,SUM(ID.DeliveryNetAmount)-sum(ID.DeliveryTotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.DeliveryTotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE  ProgramType='Blue Star' and I.TpGrandTotal>0 AND I.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblAllBlueSubDel ON tblAllBlueSubDel.AreaCode=C.AreaCode 


LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE ProgramType='Green Star' and I.TpGrandTotal>0 AND I.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblAllGreenSubDel ON tblAllGreenSubDel.AreaCode=C.AreaCode 


-- BSP,GSP end


---Customer Coverage for BSP,GSP

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM dbo.tblInvoice WHERE types='Blue Star' and  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblAllBlueCov  ON tblAllBlueCov.AreaCode = C.AreaCode  


LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM dbo.tblInvoice WHERE types='Green Star' and InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblAllGreenCov  ON tblAllGreenCov.AreaCode = C.AreaCode  


--sub

LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE ProgramType='Blue Star'  and  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblSubBlueCov2  ON tblSubBlueCov2.AreaCode = C.AreaCode  

LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode   FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE ProgramType='Green Star'  and  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblsubGreenCov2  ON tblsubGreenCov2.AreaCode = C.AreaCode  





--Delivery 

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM dbo.tblInvoice WHERE types='Blue Star'  and DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblDelBlueCov  ON tblDelBlueCov.AreaCode = C.AreaCode  

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM dbo.tblInvoice WHERE types='Green Star' and DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblDelGreenCov  ON tblDelGreenCov.AreaCode = C.AreaCode  


--sub
LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblDelBlueCovSub  ON tblDelBlueCovSub.AreaCode = C.AreaCode  


LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblDelGreenCovSub  ON tblDelGreenCovSub.AreaCode = C.AreaCode  




---Customer Coverage for BSP,GSP end



 where  tblAA.RegionCode= @Dzsm or tblcc.RegionCode= @Dzsm or tblA.RegionCode= @Dzsm   
 OR tblc.RegionCode= @Dzsm 
--and (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0    
  order by AreaCode 

END



