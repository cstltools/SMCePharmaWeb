-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_BusinessSummaryMISReport_Zone] 

	@fromdate datetime,
	@todate datetime
AS
BEGIN


SELECT 

ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,--1
ISNULL(tblA.ProTpVat,0)  AS ProTpVat, --2
(ISNULL(tblA.NetAmount,0)  ) NetInvoiceAmt,--3

ISNULL(tblD.SumofNetReturnAmount,0)  AS SumofNetReturnAmount --4
,ISNULL(tblD.TotalPriceVatAmount,0) AS DelReTpVat --5
,ISNULL(tblD.SumofNetReturnAmount,0) +ISNULL(tblD.TotalPriceVatAmount,0) as NetReturnAmt--6

,((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) )) AS salesTP--7
,(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) )))  AS SalesVat--8
,((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) )))  AS SalesTotal--9

,ISNULL(tblCollection.TpTotal,0) AS SumofNetSalesAmount--10
,ISNULL(tblCollection.TotalVat,0)AS DelTpVat --11
,(ISNULL(tblCollection.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0)
 NetSalesAmt--12




,
 ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
C.RegionName,
ISNULL(tblA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblC.NumberofInvoiceSold,0)  AS NumberofInvoiceSold,
ISNULL(tblD.NumberofReturnInvoice,0)  AS NumberofReturnInvoice,




(((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) )) )-(ISNULL(tblCollection.TpTotal,0))
AS Outstanding1	
,
((((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) )-(ISNULL(tblCollection.TotalVat,0))
AS Outstanding2

,
(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) )))  )-((ISNULL(tblCollection.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0))
AS Outstanding3


FROM dbo.tblRegion C with(NoLock) 

--,(ISNULL(tblA.SumofNetProformaAmount,0)  +ISNULL(tblA.ProTpVat,0) ) NetInvoiceAmt

LEFT JOIN (SELECT O.RegionId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat,SUM(ID.NetAmount)NetAmount 
FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
inner join tblOrder O WITH (NOLOCK)  ON O.OrderId = I.OrderId
 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY  O.RegionId)tblA ON tblA.RegionId=C.RegionId


LEFT JOIN   (SELECT  O.RegionId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId 
inner join tblOrder O WITH (NOLOCK)  ON O.OrderId = tblInvoice.OrderId  
WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  tblInvoice.UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  RegionId
)tblc ON tblc.RegionId=C.RegionId  
 
 
 
LEFT JOIN   (SELECT  O.RegionId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
inner join tblOrder O WITH (NOLOCK)  ON O.OrderId = tblSubInvoiceMaster.OrderId  
WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND tblSubInvoiceMaster.UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  RegionId)tblcc ON tblcc.RegionId=C.RegionId 
  
  
--return start
LEFT JOIN (SELECT  O.RegionId, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  
inner join tblOrder O WITH (NOLOCK)  ON O.OrderId = I.OrderId  
where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY RegionId)tblD ON tblD.RegionId=C.RegionId     
	 

----Old system return start
--LEFT JOIN (SELECT ComUnitId, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
--NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK)
--INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
--GROUP BY ComUnitId)tblDr ON tblDr.ComUnitId=C.ComUnitId     
	

--  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
--COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) 
--INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
--BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDDsub ON tblDDsub.ComUnitId = 60

--Old system return end


--return end
	 
--LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
--FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
--BETWEEN @fromdate AND @todate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  
	  
	  
-- LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount ,
--  SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
	--WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId 
		 
		 
		 
	LEFT JOIN   (SELECT  O.RegionId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM 
	dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
	inner join tblOrder O WITH (NOLOCK)  ON O.OrderId = tblInvoice.OrderId  
	WHERE InvoiceDate 
	BETWEEN @fromdate AND @todate GROUP  BY  RegionId )tblUnD ON tblUnD.RegionId = C.RegionId 


	--Collection
		LEFT JOIN   (SELECT    O.RegionId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
INNER JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId
inner join tblOrder O WITH (NOLOCK)  ON O.OrderId = I.OrderId  

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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by   O.RegionId)tblCollection ON tblCollection.RegionId = C.RegionId 












--		LEFT JOIN   ( select  O.RegionId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
--TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable


--FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
--INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN SalesDisDB_SMC..tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
--INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
--INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
--where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by I.ComUnitId )tblCollectionold ON tblCollectionold.ComUnitId = C.ComUnitId 


--	LEFT JOIN   (select I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
--TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable

--FROM SalesDisDB_SMC..tblSubInvoiceMaster I  with(nolock)
--INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
----INNER JOIN SalesDisDB_SMC..tblSubDepotStore DS ON DS.DCStoreId = ID.DCStoreId 
--INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
--INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
--where ID.DeliveryStatus IN ('Full','Partial')  AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by  O.RegionId )tblCollectionoldsub ON C.RegionId = 13

	--
		 
	--LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
	--	            where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ComUnitId  )
	--	            tblAdjust ON tblAdjust.ComUnitId = C.ComUnitId 


--where C.ComUnitId<>14
--ORDER BY C.ShortName


END
