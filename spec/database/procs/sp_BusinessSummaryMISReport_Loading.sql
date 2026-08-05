CREATE PROCEDURE [dbo].[sp_BusinessSummaryMISReport_Loading] 

	@fromdate datetime,
	@todate datetime,
	@Type nvarchar(max) ,
	@Area nvarchar(max) ,
	@Terr nvarchar(max) 
AS
BEGIN


if(@Type='SC')

begin
SELECT 
 
 ISNULL(tblSale.DeliveryAmtTP,0) DeliveryAmtTP,  ISNULL(tblSale.DeliveryTpVat,0) DeliveryTpVat, ISNULL(tblSale.DeliveryAmtTP,0) +  ISNULL(tblSale.DeliveryTpVat,0) DeliveryAmtGross,


 0 PaymentAmtTP,  0 PaymentTpVat,0 PaymentAmtGross,
  --ISNULL(PaymentAmtTP,0) PaymentAmtTP,  ISNULL(PaymentTpVat,0) PaymentTpVat, ISNULL(PaymentAmtTP,0) +  ISNULL(PaymentTpVat,0) PaymentAmtGross,

ISNULL(RejectionAmtTP,0) RejectAmtTP,  ISNULL(RejectionTpVat,0) RejectionTpVat, ISNULL(RejectionAmtTP,0) +  ISNULL(RejectionTpVat,0) RejectAmtGross,

ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,--1
ISNULL(tblA.ProTpVat,0)  AS ProTpVat, --2
(ISNULL(tblA.NetAmount,0)  ) NetInvoiceAmt,--3

ISNULL(tblD.SumofNetReturnAmount,0)+ISNULL(tblDr.SumofNetReturnAmount,0)  AS SumofNetReturnAmount --4
,ISNULL(tblD.TotalPriceVatAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)  AS DelReTpVat --5
,ISNULL(tblD.SumofNetReturnAmount,0) +ISNULL(tblD.TotalPriceVatAmount,0)+ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0) as NetReturnAmt--6


,ISNULL(tblDsales.SumofNetReturnAmount,0)  AS salesTP--7
,ISNULL(tblDsales.TotalPriceVatAmount,0)  AS SalesVat--8
,(ISNULL(tblDsales.SumofNetReturnAmount,0) ) AS SalesTotal--9 rafia 

--,(((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) ))-ISNULL(tblDr.SumofNetReturnAmount,0))+ isnull(tbllodindSum.SumofNetProformaAmount,0) AS salesTP--7
--,((((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - ISNULL(tblDr.TotalPriceVatAmount,0))  + isnull(tbllodindSum.ProTpVat,0) AS SalesVat--8
--,(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
--((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)))
--+ (isnull(tbllodindSum.SumofNetProformaAmount,0)+ isnull(tbllodindSum.ProTpVat,0)) AS SalesTotal--9 rafia 


--,(((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) ))-ISNULL(tblDr.SumofNetReturnAmount,0))+ isnull(tbllodindSum.SumofNetProformaAmount,0) AS salesTP--7
--,((((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - ISNULL(tblDr.TotalPriceVatAmount,0))  + isnull(tbllodindSum.ProTpVat,0) AS SalesVat--8
--,(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
--((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)))
--+ (isnull(tbllodindSum.SumofNetProformaAmount,0)+ isnull(tbllodindSum.ProTpVat,0)) AS SalesTotal--9 rafia 

,ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) AS SumofNetSalesAmount--10
,ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)AS DelTpVat --11

--,(ISNULL(tblCollection.TpTotal,0) )
--+ ISNULL(tblCollection.TotalVat,0)
-- NetSalesAmt--12

,(ISNULL(tblCollection.TotalNetPayable,0)+ISNULL(tblCollectionold.TotalNetPayable,0)+ISNULL(tblCollectionoldsub.TotalNetPayable,0) )
--+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 NetSalesAmt--12




,
 ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
C.ShortName,
ISNULL(tblA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblC.NumberofInvoiceSold,0)  AS NumberofInvoiceSold,
ISNULL(tblD.NumberofReturnInvoice,0)  AS NumberofReturnInvoice,

0
AS Outstanding1	
,
0
AS Outstanding2

,0
AS Outstanding3


--(((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) ))-ISNULL(tblDr.SumofNetReturnAmount,0) )-(ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0))
--AS Outstanding1	
--,
--((((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - ISNULL(tblDr.TotalPriceVatAmount,0))-(ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0))
--AS Outstanding2

--,
--(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
--((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)) )-((ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )
--+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0))
--AS Outstanding3


FROM dbo.tblCompanyUnit C with(NoLock) 

	--Collection
		LEFT JOIN   (SELECT    I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
LEFT JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
LEFT JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
LEFT JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
LEFT JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId


INNER JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType


LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
		left join tblmarket mr   with (nolock) on mr.MarketId=mas.MarketId
		left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mas.SubTerritoryId
		left join tblTerritory tr  with (nolock) on mas.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=mas.AreaId
		left join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		left join dbo.tbl_Group gr  with (nolock) on mas.GroupId=gr.GroupId
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where ( loadingsummaryFinalStatus is not null ) and ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by   I.ComUnitId)tblCollection ON tblCollection.ComUnitId = C.ComUnitId 

--,(ISNULL(tblA.SumofNetProformaAmount,0)  +ISNULL(tblA.ProTpVat,0) ) NetInvoiceAmt      

LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat,SUM(ID.NetAmount)NetAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId

)tblA ON tblA.ComUnitId=C.ComUnitId



left join (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat,SUM(ID.NetAmount)NetAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE  ( loadingsummaryFinalStatus is not null ) and   I.TpGrandTotal>0 AND convert(varchar, I.LoadingSummaryUpdateDate, 23)   BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId)tbllodindSum ON tbllodindSum.ComUnitId=C.ComUnitId


LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=C.ComUnitId  


LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT rejMas.InvoiceId)RejectionNumberofInvoice,SUM(D.NetAmount - D.TotalPriceVatAmount) RejectionAmtTP , 
SUM(D.TotalPriceVatAmount)RejectionTpVat FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK)  INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
WHERE   RejectionDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblRejection ON tblc.ComUnitId=C.ComUnitId 


LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT I.InvoiceId)PaymentNumberofInvoice,SUM(D.PaymentNetAmount - D.PaymentTotalPriceVatAmount) PaymentAmtTP , 
SUM(D.PaymentTotalPriceVatAmount) PaymentTpVat FROM dbo.tblInvoice I  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       PaymentDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblPayment ON tblPayment.ComUnitId=C.ComUnitId  
 
  
 
 

LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT I.InvoiceId)DeliveryNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) DeliveryAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) DeliveryTpVat FROM dbo.tblInvoice I  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblSale ON tblPayment.ComUnitId=C.ComUnitId  
 
  
 
 
LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=C.ComUnitId 
  
  
  --sales
  LEFT JOIN (SELECT ComUnitId,
 SUM(isnull(ID.DeliveryNetAmount,0)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo)NumberofReturnInvoice,
SUM(ID.DeliveryTotalPriceVatAmount) as TotalPriceVatAmount  FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Full','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ComUnitId)tblDsales ON tblDsales.ComUnitId=C.ComUnitId   
--return start
LEFT JOIN (SELECT ComUnitId, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ComUnitId)tblD ON tblD.ComUnitId=C.ComUnitId     
	 

--Old system return start
LEFT JOIN (SELECT ComUnitId, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ComUnitId)tblDr ON tblDr.ComUnitId=C.ComUnitId     
	

--  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
--COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) 
--INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
--BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDDsub ON tblDDsub.ComUnitId = 60

--Old system return end


--return end
	 
LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
BETWEEN @fromdate AND @todate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  
	  
	  
-- LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount ,
--  SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
	--WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId 
		 
		 
		 
	LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM 
	dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE InvoiceDate 
	BETWEEN @fromdate AND @todate GROUP  BY  ComUnitId )tblUnD ON tblUnD.ComUnitId = C.ComUnitId 




		LEFT JOIN   ( select I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable


FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN SalesDisDB_SMC..tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by I.ComUnitId )tblCollectionold ON tblCollectionold.ComUnitId = C.ComUnitId 


	LEFT JOIN   (select I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable

FROM SalesDisDB_SMC..tblSubInvoiceMaster I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN SalesDisDB_SMC..tblSubDepotStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial')  AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by I.ComUnitId )tblCollectionoldsub ON C.ComUnitId = 13

	--
		 
	LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		            where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ComUnitId  )
		            tblAdjust ON tblAdjust.ComUnitId = C.ComUnitId 


where C.ComUnitId<>14
ORDER BY C.ShortName
end


END