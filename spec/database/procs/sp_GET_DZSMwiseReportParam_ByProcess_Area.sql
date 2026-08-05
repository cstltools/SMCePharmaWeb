CREATE PROCEDURE [dbo].[sp_GET_DZSMwiseReportParam_ByProcess_Area] 

    @FromDate nvarchar(Max),
	@ToDate nvarchar(Max),
	@ZoneSelect  nvarchar(Max),
	@AreaSelect  nvarchar(Max),
	@TeritorySelect  nvarchar(Max)


		
AS
BEGIN

--declare @AreaCode nvarchar(max)=''

--if(@AreaSelect<>'')
--begin
--select @AreaCode= AreaCode from  tblArea where AreaId=@AreaSelect
--end

--declare @TerritoryCode nvarchar(max)=''

--if(@TeritorySelect<>'')
--begin
--select  @TerritoryCode=TerritoryCode from  tblTerritory where TerritoryId=@TeritorySelect
--end

Select isnull(tblCustCollection.CollectionAmtTP,0) CollectionAmtTP,  isnull(tblCustCollection.CollectionVat,0) CollectionVat,   ISNULL(tblCustCollection.CustCollectionGross,0) CustCollectionGross,  ISNULL(tblA.RegionId,tblc.RegionId) RegionId,
 ISNULL(tblA.TerritoryCode,C.TerritoryCode) AreaCode
 ,ISNULL(tblA.TerritoryName,C.TerritoryName) AreaName, 
 
 ISNULL(tblA.TerritoryCode,C.TerritoryCode) TerritoryCode
 ,ISNULL(tblA.TerritoryName,C.TerritoryName) TerritoryName,

   ISNULL(tblA.NumberofProformaInvoice,0) AS NumberofProformaInvoice
,ISNULL(tblA.SumofNetProformaAmount,0) AS SumofNetProformaAmount
,ISNULL(tblA.ProTpVat,0) AS ProTpVat ,

ISNULL(tblC.NumberofInvoiceSold,0)  AS NumberofInvoiceSold
,((((ISNULL(tblC.SumofNetSalesAmount,0))+((ISNULL(tblcO.SumofNetSalesAmount,0))+((ISNULL(tblcc.SumofNetSalesAmount,0)))))))  AS SumofNetSalesAmount
,
((((ISNULL(tblC.DelTpVat,0))+((ISNULL(tblcO.DelTpVat,0))+((ISNULL(tblcc.DelTpVat,0)))))))  AS DelTpVat ,


ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDold.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDold.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount ,
ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDold.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,


ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov01.CustomerCoverPer,0)+ISNULL(tblCov02.CustomerCoverPer,0)
 AS CustomerCoverPer 
,ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblFixed_old.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
ISNULL(tblCampBonSal.SumofNetSalesAmount,0) + ISNULL(tblCampO1.SumofNetSalesAmount,0) + ISNULL(tblcamp2.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,





(((((((ISNULL(tblC.SumofNetSalesAmount,0))+((ISNULL(tblcO.SumofNetSalesAmount,0))+((ISNULL(tblcc.SumofNetSalesAmount,0)))))))  )
-(( ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblFixed_old.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0)))) - ISNULL(tblNCOD.SumofNetSalesAmount,0))
-(ISNULL(tblCampBonSal.SumofNetSalesAmount,0) )+ (ISNULL(tblCampO1.SumofNetSalesAmount,0))+ISNULL(tblcamp2.SumofNetSalesAmount,0) 
----ISNULL(tblNCOD.SumofNetSalesAmount,0)

FinalSales,

 
 
ISNULL(tblFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
ISNULL(tblCampBonPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,

(((ISNULL(tblA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblCampBonPro.SumofNetSalesAmount,0) )) ))-(ISNULL(tblNCODpro.SumofNetSalesAmount,0) ) FinalSales2


--


--, (ISNULL(tblAllGreenCov.CustomerCoverPer,0)+ISNULL(tblsubGreenCov2.CustomerCoverPer,0)) greenCov 
,
ISNULL(tblCovPro.CustomerCoverPer,0)
 AS CustomerCoverPerProforma,
(ISNULL(tblAllBlue.SumofNetProformaAmount,0)) BlueNetSell
, (ISNULL(tblAllGreen.SumofNetProformaAmount,0)) GreenNetSell 
,(ISNULL(tblAllBlueDel.SumofNetProformaAmount,0)) DelBlueNetSell, 
(ISNULL(tblAllGreenDel.SumofNetProformaAmount,0)) DelGreenNetSell ,

 ISNULL(tblProgrmaBl.CustomerCoverPer,0)+ISNULL(tblAllBlueCov.CustomerCoverPer,0)+ISNULL(tblSubBlueCov2.CustomerCoverPer,0) BlueCov 




, 

  ISNULL(tblProgrmaGr.CustomerCoverPer,0)+ISNULL(tblAllGreenCov.CustomerCoverPer,0)+ISNULL(tblsubGreenCov2.CustomerCoverPer,0)  as greenCov
  
  , 





 




--,(ISNULL(tblAllBlueCov.CustomerCoverPer,0)) BlueCov




--




 (ISNULL(tblProgrmaBlD.CustomerCoverPer,0)+ISNULL(tblDelBlueCov.CustomerCoverPer,0)+ISNULL(tblDelBlueCovSub.CustomerCoverPer,0)) DelBlueCov,
-- (ISNULL(tblDelGreenCov.CustomerCoverPer,0)+ISNULL(tblDelGreenCovSub.CustomerCoverPer,0)) DelgreenCov 


 
  
  (ISNULL(tblProgrmaGrD.CustomerCoverPer,0)+ISNULL(tblDelGreenCov.CustomerCoverPer,0)+ISNULL(tblDelGreenCovSub.CustomerCoverPer,0)) AS DelgreenCov, MONTH(CONVERT(Date, @FromDate)), Year(CONVERT(Date, @FromDate)), @FromDate
                                        --<asp:BoundField DataField="CustomerCoverPerProforma" HeaderText="Chemist Coverage (Proforma)" />
                                        --<asp:BoundField DataField="BlueCov" HeaderText="BSP Coverage (Proforma)" />
                                        --<asp:BoundField DataField="greenCov" HeaderText="GSP Coverage (Proforma)" />
                                        --<asp:BoundField DataField="DelBlueCov" HeaderText="BSP Coverage " />
                                        --<asp:BoundField DataField="DelgreenCov" HeaderText="GSP Coverage " />

--New Row
,ISNULL(tblNCOD.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixedNCOD
,ISNULL(tblNCODpro.SumofNetSalesAmount,0)  as NCODProforma,
0 as NCODBonusCam,
0 as FCFSSalesCam,
0 as FCFSBonusCam,
0 as Extra1,
0 as Extra2,
0 as Extra3, ISNULL(tblA.SumofNetProformaAmount,0)- ISNULL((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDold.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)),0) ActualProforma, (ISNULL(tblA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0))- (((((ISNULL(tblC.SumofNetSalesAmount,0))+((ISNULL(tblcO.SumofNetSalesAmount,0))+((ISNULL(tblcc.SumofNetSalesAmount,0))))))) + ((((ISNULL(tblC.DelTpVat,0))+((ISNULL(tblcO.DelTpVat,0))+((ISNULL(tblcc.DelTpVat,0))))))) ) TotalOutStanding





FROM SalesDisDB_SMC_TrSalesRepor..tblTerritory C with(NoLock) 

LEFT JOIN SalesDisDB_SMC..tblArea A with(NoLock)  ON A.AreaCode=C.TerritoryCode





--LEFT JOIN (SELECT  O.RegionId,A.TerritoryName,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.DeliveryTotalPrice))-SUM(D.DeliveryDiscountAmount))-sum(isnull(D.AdjustmentAmount,0))  SumofNetSalesAmount ,  
--SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
--FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 

--INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
--left join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
--left join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
----inner join tblRegion R on O.RegionId = R.RegionId
----INNER JOIN dbo.tblTerritory A WITH (NOLOCK) ON A.TerritoryCode = tblInvoice.TerritoryCode


-- WHERE  O.CustTypeId not in (8,10,12,6,2) and DeliveryInvoiceStatus IN  
--('Partial','Full')  AND  tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY   O.RegionId,A.TerritoryCode,A.TerritoryName)tblGeneralSales
--ON tblGeneralSales.TerritoryCode = C.TerritoryCode 









--Cust Collection
LEFT JOIN (SELECT  t.TerritoryName,O.RegionId,t.TerritoryCode,sum((isnull(custDtl.TPAmount,0))) + sum((isnull(custDtl.VATAmount,0))) CustCollectionGross, sum((isnull(custDtl.TPAmount,0))) CollectionAmtTP,sum((isnull(custDtl.VATAmount,0))) CollectionVat
FROM  tblCustPayDetail custDtl WITH (NOLOCK) 
 
   
  INNER JOIN SalesDisDB_SMC_TrSalesRepor..tblInvoice I ON I.InvoiceId = custDtl.InvoiceId 
 
 
inner join SalesDisDB_SMC_TrSalesRepor..tblorder O with(NoLock) on O.OrderId = I.OrderId


inner join SalesDisDB_SMC_NEWDB..tblCustMaster C with(NoLock) on C.CustomerMasterId = O.CustomerMasterId
inner join SalesDisDB_SMC_NEWDB..tblMarket M on M.MarketId=C.MarketId
inner join SalesDisDB_SMC_NEWDB..tblSubTerritory s on S.SubTerritoryId=M.SubTerritoryId
inner join SalesDisDB_SMC_NEWDB..tblTerritory t on t.TerritoryId=s.TerritoryId



--inner join SalesDisDB_SMC_TrSalesRepor..tblTerritory A with(NoLock) on O.TerritoryId = A.TerritoryId
--inner join tblRegion R on O.RegionId = R.RegionId
WHERE  convert(date,custDtl.custPaymentDate) BETWEEN @FromDate and @ToDate and   ((isnull(custDtl.PaymentAmount,0))) >0  and I.FinalPaymentNo is not null    GROUP BY t.TerritoryName,O.RegionId,t.TerritoryCode)tblCustCollection ON tblCustCollection.TerritoryCode=C.TerritoryCode 

 









LEFT JOIN (SELECT  A.TerritoryName,O.RegionId,A.TerritoryCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,((SUM(ID.TotalPrice))-sum(ID.DiscountAmount))-sum(isnull(ID.AdjustmentAmount,0))  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM SalesDisDB_SMC_TrSalesRepor..tblInvoice I WITH (NOLOCK) 
INNER JOIN SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
inner join SalesDisDB_SMC_TrSalesRepor..tblorder O with(NoLock) on O.OrderId = I.OrderId
inner join SalesDisDB_SMC_TrSalesRepor..tblTerritory A with(NoLock) on O.TerritoryId = A.TerritoryId
--inner join tblRegion R on O.RegionId = R.RegionId
WHERE I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.TerritoryName,O.RegionId,A.TerritoryCode)tblA ON tblA.TerritoryCode=C.TerritoryCode 



LEFT JOIN (SELECT  O.RegionId,A.TerritoryName,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.DeliveryTotalPrice))-SUM(D.DeliveryDiscountAmount))-sum(isnull(D.AdjustmentAmount,0))  SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 

INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
left join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
left join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
--inner join tblRegion R on O.RegionId = R.RegionId
--INNER JOIN dbo.tblTerritory A WITH (NOLOCK) ON A.TerritoryCode = tblInvoice.TerritoryCode


 WHERE DeliveryInvoiceStatus IN  
('Partial','Full')  AND  tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY   O.RegionId,A.TerritoryCode,A.TerritoryName)tblC
ON tblc.TerritoryCode = C.TerritoryCode 










LEFT JOIN (SELECT RegionCode,A.AreaName,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount)) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail D WITH (NOLOCK) ON SalesDisDB_SMC..tblInvoice.InvoiceId = D.InvoiceId  
INNER JOIN SalesDisDB_SMC..tblArea A WITH (NOLOCK) ON A.AreaCode = SalesDisDB_SMC..tblInvoice.AreaCode
 WHERE DeliveryInvoiceStatus IN  
('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY    RegionCode,tblInvoice.AreaCode,A.AreaName)tblcO
ON tblcO.AreaCode = A.AreaCode 

LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail D WITH 
(NOLOCK) ON SalesDisDB_SMC..tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN SalesDisDB_SMC..tblArea A WITH (NOLOCK) ON SalesDisDB_SMC..tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  
AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc
 ON tblcc.AreaCode = A.AreaCode   



LEFT JOIN (SELECT  O.RegionId,A.TerritoryCode,(SUM(ID.TotalPrice)-SUM(ID.DiscountAmount))-(SUM(ID.DeliveryTotalPrice)-SUM(ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(ID.DeliveryTotalPriceVatAmount) as TotalPriceVatAmount 
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice I WITH (NOLOCK) 
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
left join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = I.OrderId
inner join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
--inner join tblRegion R on O.RegionId = R.RegionId

  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate
  GROUP BY  O.RegionId,A.TerritoryCode)tblD ON tblD.TerritoryCode = C.TerritoryCode  



  ---Old Return
  LEFT JOIN (SELECT I.RegionCode,I.AreaCode,(SUM(ID.TotalPrice)-SUM(ID.DiscountAmount))-(SUM(ID.DeliveryTotalPrice)-SUM(ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) 
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate
 AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDold ON tblDold.AreaCode = A.AreaCode  

 LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)-sum(ID.DiscountAmount))- ((SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount))-sum(ID.DeliveryDiscountAmount))) AS SumofNetReturnAmount,COUNT(DISTINCT 
I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) 
INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = A.AreaCode   
---
  --ncod

  LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.DeliveryTotalPrice)-sum(D.DeliveryDiscountAmount)))-sum(isnull(D.AdjustmentAmount,0)) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 

FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId

--inner join tblRegion R on O.RegionId = R.RegionId
 
WHERE O.CustTypeId in (8,10,12) AND DeliveryInvoiceStatus IN  ('Partial','Full')  
AND  tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate  
GROUP BY    O.RegionId,A.TerritoryCode)tblNCOD ON tblNCOD.TerritoryCode = C.TerritoryCode 

  LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.TotalPrice)-sum(D.DiscountAmount)))-sum(isnull(D.AdjustmentAmount,0)) SumofNetSalesAmount ,  
SUM(D.TotalPriceVatAmount)DelTpVat 

FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
--inner join tblRegion R on O.RegionId = R.RegionId
 
WHERE O.CustTypeId in (8,10,12)   
AND  tblInvoice.InvoiceDate BETWEEN @FromDate and @ToDate  
GROUP BY    O.RegionId,A.TerritoryCode)tblNCODpro ON tblNCODpro.TerritoryCode = C.TerritoryCode 

  -----
LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.DeliveryTotalPrice)-sum(D.DeliveryDiscountAmount)))-sum(isnull(D.AdjustmentAmount,0)) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 

FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
--inner join tblRegion R on O.RegionId = R.RegionId
 
WHERE O.CustTypeId in (6,2,14,16) AND DeliveryInvoiceStatus IN  ('Partial','Full')  
AND  tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate  
GROUP BY    O.RegionId,A.TerritoryCode)tblFixed ON tblFixed.TerritoryCode = C.TerritoryCode  


LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount))) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  
GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed_old ON tblFixed_old.AreaCode = A.AreaCode  

LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, 
(SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount)) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) 
INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode 
WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND tblSubInvoiceMaster.UpdateDate BETWEEN @FromDate and @ToDate   
GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = A.AreaCode    


LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount)) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblOrderDetail masdtl  with(nolock) ON D.OrderDetailsId = masdtl.OrderDetailId
left JOIN   SalesDisDB_SMC_TrSalesRepor..[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tbl_BonusCampaignNewMaster MB WITH (NOLOCK) ON camp.CampaignMasterId = MB.CampgainMasterId 
WHERE   SUBSTRING(MB.CampaignName, 1, 3)<>'Fir' and CONVERT(int, masdtl.CampaignType)>0 AND MB.IsTradePolicy=0 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND  
tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY    O.RegionId,A.TerritoryCode)tblCamp ON tblCamp.TerritoryCode = C.TerritoryCode 




LEFT JOIN (SELECT O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.TotalPrice))-sum(D.DiscountAmount)   SumofNetSalesAmount ,  
SUM(D.TotalPriceVatAmount)DelTpVat 
FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblOrderDetail masdtl  with(nolock) ON D.OrderDetailsId = masdtl.OrderDetailId
left JOIN   SalesDisDB_SMC_TrSalesRepor..[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tbl_BonusCampaignNewMaster MB WITH (NOLOCK) ON camp.CampaignMasterId = MB.CampgainMasterId 
 WHERE  SUBSTRING(MB.CampaignName, 1, 3)<>'Fir' and CONVERT(int, masdtl.CampaignType)>0 AND MB.IsTradePolicy=0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  O.RegionId,A.TerritoryCode)tblCampPro ON 
tblCampPro.TerritoryCode = C.TerritoryCode  


LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount)))-sum(isnull(D.AdjustmentAmount,0)) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblOrderDetail masdtl  with(nolock) ON D.OrderDetailsId = masdtl.OrderDetailId
left JOIN   SalesDisDB_SMC_TrSalesRepor..[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tbl_BonusCampaignNewMaster MB WITH (NOLOCK) ON camp.CampaignMasterId = MB.CampgainMasterId 
WHERE (O.CustTypeId=1 or O.CustTypeId=2 or O.CustTypeId=3 or O.CustTypeId=4 or O.CustTypeId=5 or O.CustTypeId=6 or O.CustTypeId=7 or O.CustTypeId=8  or O.CustTypeId=9  or O.CustTypeId=10  or O.CustTypeId=11  or O.CustTypeId=12  or O.CustTypeId=13  or O.CustTypeId=14  or O.CustTypeId=15  or O.CustTypeId=16   ) and  (( SUBSTRING(MB.CampaignName, 1, 3)='Bon' or SUBSTRING(MB.CampaignName, 1, 3)='Sal')) AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND  
(tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate)  GROUP BY    O.RegionId,A.TerritoryCode)tblCampBonSal ON tblCampBonSal.TerritoryCode = C.TerritoryCode 



LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.TotalPrice)-SUM(D.DiscountAmount)))-sum(isnull(D.AdjustmentAmount,0)) SumofNetSalesAmount ,  
SUM(D.TotalPriceVatAmount)DelTpVat 
FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblOrderDetail masdtl  with(nolock) ON D.OrderDetailsId = masdtl.OrderDetailId
left JOIN   SalesDisDB_SMC_TrSalesRepor..[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tbl_BonusCampaignNewMaster MB WITH (NOLOCK) ON camp.CampaignMasterId = MB.CampgainMasterId 
WHERE (O.CustTypeId=1 or O.CustTypeId=2 or O.CustTypeId=3 or O.CustTypeId=4 or O.CustTypeId=5 or O.CustTypeId=6 or O.CustTypeId=7 or O.CustTypeId=8  or O.CustTypeId=9  or O.CustTypeId=10  or O.CustTypeId=11  or O.CustTypeId=12  or O.CustTypeId=13  or O.CustTypeId=14  or O.CustTypeId=15  or O.CustTypeId=16  ) and  (( SUBSTRING(MB.CampaignName, 1, 3)='Bon' or SUBSTRING(MB.CampaignName, 1, 3)='Sal'))   
AND  
(tblInvoice.InvoiceDate BETWEEN @FromDate and @ToDate)  GROUP BY    O.RegionId,A.TerritoryCode)tblCampBonPro ON tblCampBonPro.TerritoryCode = C.TerritoryCode 

--
  LEFT JOIN (SELECT    O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.TotalPrice)-SUM(D.DiscountAmount))) -sum(isnull(D.AdjustmentAmount,0)) SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat 
FROM   SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
inner join   SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join   SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
INNER JOIN   SalesDisDB_SMC_TrSalesRepor..tblOrderDetail masdtl  with(nolock) ON D.OrderDetailsId = masdtl.OrderDetailId
left JOIN   SalesDisDB_SMC_TrSalesRepor..[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tbl_BonusCampaignNewMaster MB WITH (NOLOCK) ON camp.CampaignMasterId = MB.CampgainMasterId 
WHERE  ( SUBSTRING(MB.CampaignName, 1, 3)='Bon' or SUBSTRING(MB.CampaignName, 1, 3)='Sal')   AND  
tblInvoice.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY    O.RegionId,A.TerritoryCode)tblCampBonSalPro ON tblCampBonSalPro.TerritoryCode = C.TerritoryCode 



LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount))  SumofNetSalesAmount ,  
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail D WITH (NOLOCK) ON SalesDisDB_SMC..tblInvoice.InvoiceId = D.InvoiceId   
WHERE (D.IsCampaignProduct=1) AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  
UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  SalesDisDB_SMC..tblInvoice.RegionCode,SalesDisDB_SMC..tblInvoice.AreaCode)tblCampO1 ON tblCampO1.AreaCode = A.AreaCode 
--D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign' 

LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, 
(SUM(D.DeliveryTotalPrice)-SUM(D.DeliveryDiscountAmount))  SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) 
INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail D WITH (NOLOCK) ON SalesDisDB_SMC..tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN SalesDisDB_SMC..tblArea A WITH (NOLOCK) ON SalesDisDB_SMC..tblSubInvoiceMaster.AreaCode = A.AreaCode 
WHERE (D.IsCampaignProduct=1) AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND SalesDisDB_SMC..tblSubInvoiceMaster.UpdateDate between @FromDate and @ToDate
  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = A.AreaCode   
















LEFT JOIN (SELECT O.RegionId,A.TerritoryCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,((SUM(D.TotalPrice))-sum(D.DiscountAmount))   -sum(isnull(D.AdjustmentAmount,0))   SumofNetSalesAmount ,  
SUM(D.TotalPriceVatAmount)DelTpVat 
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
inner join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
 WHERE O.CustTypeId in (2,6,14,16)  AND 
  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  O.RegionId,A.TerritoryCode)tblFixedPro ON tblFixedPro.TerritoryCode = C.TerritoryCode  






----proforma
LEFT JOIN (SELECT A.TerritoryName,O.RegionId,A.TerritoryCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,(SUM(ID.TotalPrice))-sum(ID.DiscountAmount)   
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice I WITH (NOLOCK) 
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = I.OrderId
inner join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
WHERE  O.ProgramTypeId=2  AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.TerritoryName,O.RegionId,A.TerritoryCode)tblAllBlue ON tblAllBlue.TerritoryCode=C.TerritoryCode 


LEFT JOIN (SELECT A.TerritoryName,O.RegionId,A.TerritoryCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,(SUM(ID.TotalPrice))-sum(ID.DiscountAmount)   
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice I WITH (NOLOCK) 
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = I.OrderId
inner join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
WHERE O.ProgramTypeId=1  AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.TerritoryName,O.RegionId,A.TerritoryCode)tblAllGreen ON tblAllGreen.TerritoryCode=C.TerritoryCode 


----Del

LEFT JOIN (SELECT A.TerritoryName,O.RegionId,A.TerritoryCode,(SUM(ID.DeliveryTotalPrice))-SUM(ID.DeliveryDiscountAmount)
AS SumofNetProformaAmount,SUM(ID.DeliveryTotalPriceVatAmount)ProTpVat 
FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = I.OrderId
inner join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
WHERE  O.ProgramTypeId=2  AND I.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.TerritoryName,O.RegionId,A.TerritoryCode)tblAllBlueDel ON tblAllBlueDel.TerritoryCode=C.TerritoryCode 


LEFT JOIN (SELECT A.TerritoryName,O.RegionId,A.TerritoryCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,(SUM(ID.DeliveryTotalPrice))-SUM(ID.DeliveryDiscountAmount)
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice I WITH (NOLOCK) 
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = I.OrderId
inner join  SalesDisDB_SMC_TrSalesRepor..tblTerritory A  WITH (NOLOCK) on O.TerritoryId = A.TerritoryId
WHERE O.ProgramTypeId=1 AND I.UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.TerritoryName,O.RegionId,A.TerritoryCode)tblAllGreenDel ON tblAllGreenDel.TerritoryCode=C.TerritoryCode 



--LEFT JOIN (SELECT ((CustomerMasterId)) CustomerCoverPer ,T2.TerritoryCode from (SELECT COUNT(tblInvoice.CustomerMasterId) CustomerMasterId1,tblTerritory.TerritoryCode  FROM dbo.tblCustMaster 
--INNER JOIN dbo.tblOrder ON tblOrder.CustomerMasterId = tblCustMaster.CustomerMasterId
--INNER JOIN dbo.tblInvoice ON tblInvoice.CustomerMasterId = tblCustMaster.CustomerMasterId
--INNER JOIN dbo.tblTerritory ON tblTerritory.TerritoryId = tblOrder.TerritoryId
--GROUP BY tblTerritory.TerritoryCode) AS T1,
--((SELECT COUNT(tblInvoice.CustomerMasterId)CustomerMasterId,tblTerritory.TerritoryCode  FROM dbo.tblInvoice 
--inner join tblorder O on O.OrderId = tblInvoice.OrderId
--INNER JOIN dbo.tblTerritory ON tblTerritory.TerritoryId = o.TerritoryId



-- WHERE  tblInvoice.CustomerMasterId  IN  (SELECT tblInvoice.CustomerMasterId 
--FROM dbo.tblInvoice 
--inner join tblorder O on O.OrderId = tblInvoice.OrderId
--INNER JOIN dbo.tblTerritory ON tblTerritory.TerritoryId = o.TerritoryId
--WHERE DeliveryInvoiceStatus<>'Reject'  and tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY tblTerritory.TerritoryCode)  ) AS 
--T2 WHERE T1.TerritoryCode=T2.TerritoryCode ) tblCov  ON tblCov.TerritoryCode = C.TerritoryCode


LEFT JOIN (SELECT COUNT(DISTINCT tblInvoice.CustomerMasterId )CustomerCoverPer,tblTerritory.TerritoryCode
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblTerritory  WITH (NOLOCK) ON tblTerritory.TerritoryId = o.TerritoryId
WHERE  tblInvoice.InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY tblTerritory.TerritoryCode)  tblCovPro  ON tblCovPro.TerritoryCode = C.TerritoryCode


LEFT JOIN (SELECT COUNT(DISTINCT tblInvoice.CustomerMasterId )CustomerCoverPer,tblTerritory.TerritoryCode
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblTerritory  WITH (NOLOCK) ON tblTerritory.TerritoryId = o.TerritoryId
WHERE DeliveryInvoiceStatus<>'Reject'  and tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate GROUP BY tblTerritory.TerritoryCode)  tblCov  ON tblCov.TerritoryCode = C.TerritoryCode

LEFT JOIN (SELECT COUNT(DISTINCT I.CustomerMasterId )CustomerCoverPer,AreaCode
FROM SalesDisDB_SMC..tblInvoice  I WITH (NOLOCK) 
WHERE DeliveryInvoiceStatus<>'Reject'  and I.UpdateDate BETWEEN @FromDate and @ToDate GROUP BY AreaCode )  tblCov01  ON tblCov01.AreaCode = A.AreaCode


LEFT JOIN (SELECT COUNT(DISTINCT I.CustomerMasterId )CustomerCoverPer,AreaCode
FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) 
WHERE DeliveryInvoiceStatus<>'Reject'  and I.UpdateDate BETWEEN @FromDate and @ToDate GROUP BY AreaCode )  tblCov02  ON tblCov02.AreaCode = A.AreaCode



---Customer Coverage for BSP,GSP


LEFT JOIN (SELECT COUNT(DISTINCT tblInvoice.CustomerMasterId )CustomerCoverPer,tblTerritory.TerritoryCode
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblTerritory  WITH (NOLOCK) ON tblTerritory.TerritoryId = o.TerritoryId
WHERE o.ProgramTypeId=2 and tblInvoice.InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY tblTerritory.TerritoryCode )  tblProgrmaBl  ON tblProgrmaBl.TerritoryCode = C.TerritoryCode


LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) WHERE types='Blue Star' and  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblAllBlueCov  ON tblAllBlueCov.AreaCode = A.AreaCode  

LEFT JOIN (SELECT COUNT(DISTINCT tblInvoice.CustomerMasterId )CustomerCoverPer,tblTerritory.TerritoryCode
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblTerritory  WITH (NOLOCK) ON tblTerritory.TerritoryId = o.TerritoryId
WHERE o.ProgramTypeId=1 and tblInvoice.InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY tblTerritory.TerritoryCode )  tblProgrmaGr  ON tblProgrmaGr.TerritoryCode = C.TerritoryCode

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM SalesDisDB_SMC..tblInvoice WHERE types='Green Star' and InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblAllGreenCov  ON tblAllGreenCov.AreaCode = A.AreaCode  


--sub

LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM dbo.tblCustMaster  WITH (NOLOCK) 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM SalesDisDB_SMC..tblCustMaster WITH (NOLOCK)  WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) WHERE ProgramType='Blue Star'  and  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblSubBlueCov2  ON tblSubBlueCov2.AreaCode = A.AreaCode  

LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode   FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM SalesDisDB_SMC..tblSubInvoiceMaster WHERE ProgramType='Green Star'  and  InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblsubGreenCov2  ON tblsubGreenCov2.AreaCode = A.AreaCode  





--Delivery 
LEFT JOIN (SELECT COUNT(DISTINCT tblInvoice.CustomerMasterId )CustomerCoverPer,tblTerritory.TerritoryCode
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblTerritory  WITH (NOLOCK) ON tblTerritory.TerritoryId = o.TerritoryId
WHERE o.ProgramTypeId=2 and tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate GROUP BY tblTerritory.TerritoryCode )  tblProgrmaBlD  ON tblProgrmaBlD.TerritoryCode = C.TerritoryCode


LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM SalesDisDB_SMC..tblInvoice  WITH (NOLOCK) WHERE types='Blue Star'  and DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblDelBlueCov  ON tblDelBlueCov.AreaCode = A.AreaCode  


LEFT JOIN (SELECT COUNT(DISTINCT tblInvoice.CustomerMasterId )CustomerCoverPer,tblTerritory.TerritoryCode
FROM  SalesDisDB_SMC_TrSalesRepor..tblInvoice  WITH (NOLOCK) 
inner join  SalesDisDB_SMC_TrSalesRepor..tblorder O  WITH (NOLOCK) on O.OrderId = tblInvoice.OrderId
INNER JOIN  SalesDisDB_SMC_TrSalesRepor..tblTerritory  WITH (NOLOCK) ON tblTerritory.TerritoryId = o.TerritoryId
WHERE o.ProgramTypeId=1 and tblInvoice.UpdateDate BETWEEN @FromDate and @ToDate GROUP BY tblTerritory.TerritoryCode )  tblProgrmaGrD  ON tblProgrmaGrD.TerritoryCode = C.TerritoryCode

LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) 
GROUP BY AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode       FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId 
FROM SalesDisDB_SMC..tblInvoice WITH (NOLOCK)  WHERE types='Green Star' and DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) AS 
T2 WHERE T1.AreaCode=T2.AreaCode    ) tblDelGreenCov  ON tblDelGreenCov.AreaCode = A.AreaCode  


--sub
LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblDelBlueCovSub  ON tblDelBlueCovSub.AreaCode = A.AreaCode  


LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.AreaCode 
from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,AreaCode  FROM SalesDisDB_SMC..tblCustMaster   WITH (NOLOCK) 
GROUP BY AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,AreaCode      FROM SalesDisDB_SMC..tblCustMaster  WITH (NOLOCK) WHERE  CustomerMasterId  IN  
(SELECT CustomerMasterId FROM SalesDisDB_SMC..tblSubInvoiceMaster  WITH (NOLOCK) WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY AreaCode) ) 
AS T2 WHERE T1.AreaCode=T2.AreaCode) tblDelGreenCovSub  ON tblDelGreenCovSub.AreaCode = A.AreaCode  




where  C.AreaId=@AreaSelect
 
 -- and ( CAST(ISNULL(tblA.AreaCode_Ord,  (tblc.AreaCode_Ord)) as nvarchar(max))= COALESCE( cast(NULLIF(@AreaCode , '') as nvarchar(max)) , CAST(ISNULL(tblA.AreaCode_Ord,  (tblc.AreaCode_Ord)) as nvarchar(max))))

  
 --and ( CAST(ISNULL(tblA.TerritoryCode,  (C.TerritoryCode)) as nvarchar(max))= COALESCE( cast(NULLIF(@TerritoryCode , '') as nvarchar(max)) , CAST(ISNULL(tblA.TerritoryCode,C.TerritoryCode)   as nvarchar(max))))

 order by C.TerritoryCode 

END


