-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_Rpt_BusinessSummaryProductwise] 

	@fromdate datetime,
	@todate datetime
AS
BEGIN

	SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,tblC.ProductCode,tblC.ProductCode,

	--invoice
ISNULL(tblA.NumberofProformaInvoice,0)  AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0)  AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0)  + ISNULL(tblA.SumofNetProformaAmount,0) )GrossProforma


--return
,tblD.ProductCode,
ISNULL(tblD.DelQty,0) + isnull(tblDr.RQ,0) AS RetQty,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDr.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDr.TotalPriceVatAmount,0)  AS DelReTpVat ,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDr.SumofNetReturnAmount,0) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDr.TotalPriceVatAmount,0) ) GrossRetuen


--Sales
,(ISNULL(tblA.NumberofProformaInvoice,0) -(ISNULL(tblD.DelQty,0) + isnull(tblDr.RQ,0))) - ((ISNULL(tblBonus.NumberofInvoiceSold,0)))   AS NumberofInvoiceSold
,(ISNULL(tblBonus.NumberofInvoiceSold,0)) AS bouns,
ISNULL(tblCollection.TpTotal,0)  AS SumofNetSalesAmount,
ISNULL(tblCollection.TotalVat,0) AS DelTpVat,
(ISNULL(tblCollection.TotalNetPayable,0) ) AS GrossSales,
ISNULL(tblc.DiscountAmount,0)  AS TotalDiscountAmount ,


ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0)
AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0) AS DelTpVatCollection 
,(ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 AS GrossSalesCollection


FROM dbo.tblProduct C with(NoLock) 


LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 and  
InvoiceDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   




LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @fromdate and @todate AND 
I.TpGrandTotal>0  GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   



LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate and @todate  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode 



LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate and @todate AND 
I.TpGrandTotal>0  GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode 




LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate 
BETWEEN @fromdate and @todate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode 




LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @fromdate and @todate) 
 GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode 
 
 
 
 
 --LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
 --FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate 
 --AND @todate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode 
 
 
 
 
 LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, (SUM(D.DiscountAmount)+(SUM(ISNULL(D.AdjustmentAmount,0))))DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D 
 WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId<>0 and InvoiceDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  
 
 
 
 --LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 --SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) 
 --ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE InvoiceDate BETWEEN @fromdate and @todate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  
 
 
 
 LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- 
 SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,
 SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
  INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') 
  AND I.UpdateDate BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  
  
  
  
  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- 
  SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,
  SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate 
   BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDD ON tblDD.ProductCode = C.ProductCode 
   
   
   --LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,
   --SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) 
   --ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate and @todate  
   -- GROUP BY  ProductCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  
	
	
	
	LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
	SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail 
	D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate 
	BETWEEN @fromdate and @todate  GROUP BY  ProductCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode 






	--old system return
	LEFT JOIN (SELECT ProductCode,SUM(Quantity)-SUM(DeliveryQuantity) as RQ ,((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(ID.DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ProductCode)tblDr ON tblDr.ProductCode=C.ProductCode     

	--Collection
		LEFT JOIN   (SELECT     ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by   ID.ProductCode)tblCollection ON tblCollection.ProductCode  =C.ProductCode 

		LEFT JOIN   ( select ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable


FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN SalesDisDB_SMC..tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by ID.ProductCode )tblCollectionold ON tblCollectionold.ProductCode =C.ProductCode


	LEFT JOIN   (select ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable

FROM SalesDisDB_SMC..tblSubInvoiceMaster I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN SalesDisDB_SMC..tblSubDepotStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial')  AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by ID.ProductCode )tblCollectionoldsub ON tblCollectionoldsub.ProductCode =C.ProductCode

	--
		 
	

	where C.Productgroupid=1
	order by ProductName
END

