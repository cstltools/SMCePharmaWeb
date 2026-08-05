-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_RPT_MIOWiseBusinessSummary] 

	@fromdate datetime,
	@todate datetime,
	@Depid nvarchar(max)  

AS
BEGIN

SELECT 

  ISNULL(tblRcv.SumofRCVAmount,0)- ISNULL(tblRcv.SumofRCVVat,0)  AS SumofRCVTP, 
 

  ISNULL(tblRcv.SumofRCVAmount,0)  AS SumofRCVAmount, 
  ISNULL(tblRcv.SumofRCVVat,0)  AS SumofRCVVat, 
ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,--1
ISNULL(tblA.ProTpVat,0)  AS ProTpVat, --2
(ISNULL(tblA.NetAmount,0)  ) NetInvoiceAmt,--3

ISNULL(tblD.SumofNetReturnAmount,0)+ISNULL(0,0)  AS SumofNetReturnAmount --4
,ISNULL(tblD.TotalPriceVatAmount,0)+ISNULL(0,0)  AS DelReTpVat --5
,ISNULL(tblD.SumofNetReturnAmount,0) +ISNULL(tblD.TotalPriceVatAmount,0)+ISNULL(0,0)+ISNULL(0,0) as NetReturnAmt--6

,((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) ))-ISNULL(0,0) AS salesTP--7
,(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - ISNULL(0,0) AS SalesVat--8
,((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(0,0)+ISNULL(0,0)) AS SalesTotal--9 rafia 

,ISNULL(tblCollection.TpTotal,0)  AS SumofNetSalesAmount--10
,ISNULL(tblCollection.TotalVat,0) AS DelTpVat --11

--,(ISNULL(tblCollection.TpTotal,0) )
--+ ISNULL(tblCollection.TotalVat,0)
-- NetSalesAmt--12

,(ISNULL(tblCollection.TotalNetPayable,0) )
--+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 NetSalesAmt--12




,
 ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
emp.EmpMasterCode+' : '+emp.EmpName MIOName,
'' TerritoryName,
ISNULL(tblA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblC.NumberofInvoiceSold,0)  AS NumberofInvoiceSold,
ISNULL(tblD.NumberofReturnInvoice,0)  AS NumberofReturnInvoice,




(((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) ))-ISNULL(0,0) )-(ISNULL(tblCollection.TpTotal,0)+ISNULL(0,0)+ISNULL(0,0))
AS Outstanding1	
,
((((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - ISNULL(0,0))-(ISNULL(tblCollection.TotalVat,0)+ISNULL(0,0)+ISNULL(0,0))
AS Outstanding2

,
(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +
((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(0,0)+ISNULL(0,0)) )-((ISNULL(tblCollection.TpTotal,0)+ISNULL(0,0)+ISNULL(0,0) )
+ ISNULL(tblCollection.TotalVat,0)+ISNULL(0,0)+ISNULL(0,0))
AS Outstanding3


FROM  dbo.tblMIOInfo Mio with(NoLock) 
 
inner join tblEmpGeneralInfo emp on  Mio.EmployeeId=emp.EmpInfoId
 

--,(ISNULL(tblA.SumofNetProformaAmount,0)  +ISNULL(tblA.ProTpVat,0) ) NetInvoiceAmt

LEFT JOIN (SELECT ord.MIOCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat,SUM(ID.NetAmount)NetAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
 INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON ord.OrderId = I.OrderId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY ord.MIOCode)tblA ON  tblA.MIOCode=emp.EmpMasterCode


LEFT JOIN   (SELECT ord.MIOCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON ord.OrderId = tblInvoice.OrderId 
WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  tblInvoice.UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ord.MIOCode)tblc ON tblc.MIOCode=emp.EmpMasterCode


LEFT JOIN   (SELECT ord.MIOCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,sum(NetAmount) SumofRCVAmount , 
Sum(TotalPriceVatAmount)SumofRCVVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON ord.OrderId = tblInvoice.OrderId 

WHERE   tblInvoice.DelivaryInvoiceNo IS NULL AND TpGrandTotal>0 AND  tblInvoice.InvoiceDate BETWEEN @fromdate AND @todate   GROUP BY  ord.MIOCode)tblRcv ON tblRcv.MIOCode=emp.EmpMasterCode
 
 
 
 
  
--return start
LEFT JOIN (SELECT ord.MIOCode, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON ord.OrderId = I.OrderId 

INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ord.MIOCode)tblD ON tblD.MIOCode=emp.EmpMasterCode
	 
 

 


--return end
	 
 
	  
	  
 
		 
		 
	LEFT JOIN   (SELECT ord.MIOCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM 
	dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId
INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON ord.OrderId = tblInvoice.OrderId 
	   WHERE InvoiceDate 
	BETWEEN @fromdate AND @todate GROUP  BY  ord.MIOCode )tblUnD ON tblUnD.MIOCode=emp.EmpMasterCode


	--Collection
		LEFT JOIN   (SELECT   mas.MIOCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by   mas.MIOCode)tblCollection ON tblCollection.MIOCode=emp.EmpMasterCode


	 


 

	--
		 
	--LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
	--	            where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ComUnitId  )
	--	            tblAdjust ON tblAdjust.ComUnitId = C.ComUnitId 


--where Mio.isActive=1 and tr.isActive=1 
ORDER BY emp.EmpMasterCode
end