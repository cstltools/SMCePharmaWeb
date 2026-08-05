-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProductWiseBusinessSummaryMISReportByParam] 

	@fromdate datetime,
	@todate datetime,
	@Type nvarchar(max),
	@Area nvarchar(max),
	@Terr nvarchar(max),
	@ZonId nvarchar(max)

AS
BEGIN

if(@Type='SC')
begin
	SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,tblC.ProductCode,tblC.ProductCode,

	--invoice
ISNULL(tblA.NumberofProformaInvoice,0)  AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0)  AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0)  + ISNULL(tblA.SumofNetProformaAmount,0) )GrossProforma


--return
,tblD.ProductCode,
ISNULL(tblRtn.Retqty,0) + isnull(tblOldRtn.Retqty,0) AS RetQty,
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) AS SumofNetReturnAmount 
,isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0)   AS DelReTpVat ,
isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)GrossRetuen


--Sales
,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.DeliveryQuantity, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.Retqty, 0)) AS NumberofInvoiceSold

, (ISNULL(tblSaleBonusQty.DeliveryQuantity,0)) -  (ISNULL(tblRtnBonus.Retqty,0))  AS bouns,
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) AS SumofNetSalesAmount,
(isnull(tblSale.SalesVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0) )-(isnull(tblRtn.ReturnAmountVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0)) AS DelTpVat,
 ((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))  AS GrossSales,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.SalesDiscount, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.JustSalesDiscount, 0))
  AS TotalDiscountAmount ,


--(((ISNULL(tblA.SumofNetProformaAmount,0) )  -  (ISNULL(tblD.SumofNetReturnAmount,0)  )))+(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0)) ) )
--(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
--,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
--,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
--((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales


ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0)
AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0) AS DelTpVatCollection 
,(ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 AS GrossSalesCollection



FROM dbo.tblProduct C with(NoLock) 


 --LEFT JOIN   ( select ProductCode,sum(tblReturnInvoiceDetail.UnitVatAmount*Quantity)TpVat,sum(tblReturnInvoiceDetail.TotalPrice)TpTotal,sum(tblReturnInvoiceDetail.NetAmount)TpGrandTotal from tblReturnInvoice
 --inner join tblReturnInvoiceDetail on tblReturnInvoice.ReturnInvoiceId=tblReturnInvoiceDetail.ReturnInvoiceId
	--	                  where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ProductCode  )
	--	                  tblAdjust ON tblAdjust.ProductCode = C.ProductCode 



--LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
--FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 AND  
--InvoiceDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode  


LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 and  
UpdateDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   




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
		LEFT JOIN   (SELECT    ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by  ID.ProductCode)tblCollection ON tblCollection.ProductCode  =C.ProductCode 


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
		 
		 ---return 1

		 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  ID.ProductCode

)tblRtn ON tblRtn.ProductCode=C.ProductCode


-- rtn for bouns prod
	 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt


 FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE ISGiftProduct=1 and I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  ID.ProductCode

)tblRtnBonus ON tblRtnBonus.ProductCode=C.ProductCode


 --Sales

LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  D.ProductCode)tblSale ON tblSale.ProductCode=c.ProductCode

-- sales bonus
LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE ISGiftProduct=1 and      I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  D.ProductCode)tblSaleBonusQty ON tblSaleBonusQty.ProductCode=c.ProductCode


 ---return 2

LEFT JOIN   (
SELECT  ID.ProductCode ,count(ID.Quantity-ID.DeliveryQuantity) Retqty,
--sum(ISNULL(ID.TotalPrice- ID.DeliveryTotalPrice,0))
((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS ReturnAmountTP, 
sum( ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount) ReturnAmountVat,
sum(ID.NetAmount-ID.DeliveryNetAmount) ReturnGrossAmt


FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
		 
	 
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId

INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  ID.ProductCode ) tblOldRtn ON tblOldRtn.ProductCode=C.ProductCode

	

	where C.Productgroupid=1
	order by ProductName
END
 

if(@Type='Zone')
begin
	SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,tblC.ProductCode,tblC.ProductCode,

	--invoice
ISNULL(tblA.NumberofProformaInvoice,0)  AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0)  AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0)  + ISNULL(tblA.SumofNetProformaAmount,0) )GrossProforma


--return
,tblD.ProductCode,
ISNULL(tblRtn.Retqty,0) + isnull(tblOldRtn.Retqty,0) AS RetQty,
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) AS SumofNetReturnAmount 
,isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0)   AS DelReTpVat ,
isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)GrossRetuen


--Sales
,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.DeliveryQuantity, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.Retqty, 0)) AS NumberofInvoiceSold

, (ISNULL(tblSaleBonusQty.DeliveryQuantity,0)) -  (ISNULL(tblRtnBonus.Retqty,0))  AS bouns,
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) AS SumofNetSalesAmount,
(isnull(tblSale.SalesVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0) )-(isnull(tblRtn.ReturnAmountVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0)) AS DelTpVat,
 ((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))  AS GrossSales,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.SalesDiscount, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.JustSalesDiscount, 0))
  AS TotalDiscountAmount ,


--(((ISNULL(tblA.SumofNetProformaAmount,0) )  -  (ISNULL(tblD.SumofNetReturnAmount,0)  )))+(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0)) ) )
--(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
--,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
--,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
--((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales


ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0)
AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0) AS DelTpVatCollection 
,(ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 AS GrossSalesCollection



FROM dbo.tblProduct C with(NoLock) 


 --LEFT JOIN   ( select ProductCode,sum(tblReturnInvoiceDetail.UnitVatAmount*Quantity)TpVat,sum(tblReturnInvoiceDetail.TotalPrice)TpTotal,sum(tblReturnInvoiceDetail.NetAmount)TpGrandTotal from tblReturnInvoice
 --inner join tblReturnInvoiceDetail on tblReturnInvoice.ReturnInvoiceId=tblReturnInvoiceDetail.ReturnInvoiceId
	--	                  where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ProductCode  )
	--	                  tblAdjust ON tblAdjust.ProductCode = C.ProductCode 



--LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
--FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 AND  
--InvoiceDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode  


LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 and  
UpdateDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   




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
		LEFT JOIN   (SELECT    ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by  ID.ProductCode)tblCollection ON tblCollection.ProductCode  =C.ProductCode 


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
		 
		 ---return 1

		 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  ID.ProductCode

)tblRtn ON tblRtn.ProductCode=C.ProductCode


-- rtn for bouns prod
	 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt


 FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE ISGiftProduct=1 and I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  ID.ProductCode

)tblRtnBonus ON tblRtnBonus.ProductCode=C.ProductCode


 --Sales

LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  D.ProductCode)tblSale ON tblSale.ProductCode=c.ProductCode

-- sales bonus
LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE ISGiftProduct=1 and      I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  D.ProductCode)tblSaleBonusQty ON tblSaleBonusQty.ProductCode=c.ProductCode


 ---return 2

LEFT JOIN   (
SELECT  ID.ProductCode ,count(ID.Quantity-ID.DeliveryQuantity) Retqty,
--sum(ISNULL(ID.TotalPrice- ID.DeliveryTotalPrice,0))
((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS ReturnAmountTP, 
sum( ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount) ReturnAmountVat,
sum(ID.NetAmount-ID.DeliveryNetAmount) ReturnGrossAmt


FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
		 
	 
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId

INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  ID.ProductCode ) tblOldRtn ON tblOldRtn.ProductCode=C.ProductCode

	

	where C.Productgroupid=1
	order by ProductName
END


if(@Type='Area')
begin
	SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,tblC.ProductCode,tblC.ProductCode,

	--invoice
ISNULL(tblA.NumberofProformaInvoice,0)  AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0)  AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0)  + ISNULL(tblA.SumofNetProformaAmount,0) )GrossProforma


--return
,tblD.ProductCode,
ISNULL(tblRtn.Retqty,0) + isnull(tblOldRtn.Retqty,0) AS RetQty,
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) AS SumofNetReturnAmount 
,isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0)   AS DelReTpVat ,
isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)GrossRetuen


--Sales
,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.DeliveryQuantity, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.Retqty, 0)) AS NumberofInvoiceSold

, (ISNULL(tblSaleBonusQty.DeliveryQuantity,0)) -  (ISNULL(tblRtnBonus.Retqty,0))  AS bouns,
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) AS SumofNetSalesAmount,
(isnull(tblSale.SalesVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0) )-(isnull(tblRtn.ReturnAmountVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0)) AS DelTpVat,
 ((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))  AS GrossSales,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.SalesDiscount, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.JustSalesDiscount, 0))
  AS TotalDiscountAmount ,


--(((ISNULL(tblA.SumofNetProformaAmount,0) )  -  (ISNULL(tblD.SumofNetReturnAmount,0)  )))+(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0)) ) )
--(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
--,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
--,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
--((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales


ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0)
AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0) AS DelTpVatCollection 
,(ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 AS GrossSalesCollection



FROM dbo.tblProduct C with(NoLock) 


 --LEFT JOIN   ( select ProductCode,sum(tblReturnInvoiceDetail.UnitVatAmount*Quantity)TpVat,sum(tblReturnInvoiceDetail.TotalPrice)TpTotal,sum(tblReturnInvoiceDetail.NetAmount)TpGrandTotal from tblReturnInvoice
 --inner join tblReturnInvoiceDetail on tblReturnInvoice.ReturnInvoiceId=tblReturnInvoiceDetail.ReturnInvoiceId
	--	                  where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ProductCode  )
	--	                  tblAdjust ON tblAdjust.ProductCode = C.ProductCode 



--LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
--FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 AND  
--InvoiceDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode  


LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
FROM dbo.tblInvoice  WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = tblInvoice.OrderId
  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 and  
tblInvoice.UpdateDate BETWEEN @fromdate and @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   




LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @fromdate and @todate AND 
I.TpGrandTotal>0   GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   



LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate and @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode 



LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate and @todate AND 
I.TpGrandTotal>0   and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode 




LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate 
BETWEEN @fromdate and @todate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode 




LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @fromdate and @todate)  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) 
 GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode 
 
 
 
 
 --LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
 --FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate 
 --AND @todate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode 
 
 
 
 
 LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, (SUM(D.DiscountAmount)+(SUM(ISNULL(D.AdjustmentAmount,0))))DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)
 INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = tblInvoice.OrderId
   INNER JOIN dbo.tblInvoiceDetail D 
 WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId<>0 and tblInvoice.InvoiceDate BETWEEN @fromdate and @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))  GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  
 
 
 
 --LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 --SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) 
 --ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE InvoiceDate BETWEEN @fromdate and @todate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  
 
 
 
 LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- 
 SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,
 SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
 INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
  INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') 
  AND I.UpdateDate BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  
  
  
  
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
		LEFT JOIN   (SELECT    ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  and  (ar.AreaId= COALESCE( NULLIF(@Area , 0) ,ar.AreaId)) and     (rg.RegionId= COALESCE( NULLIF(@ZonId , 0) ,rg.RegionId)) group by  ID.ProductCode)tblCollection ON tblCollection.ProductCode  =C.ProductCode 


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
		 
		 ---return 1

		 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  ID.ProductCode

)tblRtn ON tblRtn.ProductCode=C.ProductCode


-- rtn for bouns prod
	 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt


 FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE ISGiftProduct=1 and I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  ID.ProductCode

)tblRtnBonus ON tblRtnBonus.ProductCode=C.ProductCode


 --Sales

LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  D.ProductCode)tblSale ON tblSale.ProductCode=c.ProductCode

-- sales bonus
LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE ISGiftProduct=1 and      I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  D.ProductCode)tblSaleBonusQty ON tblSaleBonusQty.ProductCode=c.ProductCode


 ---return 2

LEFT JOIN   (
SELECT  ID.ProductCode ,count(ID.Quantity-ID.DeliveryQuantity) Retqty,
--sum(ISNULL(ID.TotalPrice- ID.DeliveryTotalPrice,0))
((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS ReturnAmountTP, 
sum( ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount) ReturnAmountVat,
sum(ID.NetAmount-ID.DeliveryNetAmount) ReturnGrossAmt


FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
		 
	 
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId

INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))  GROUP BY  ID.ProductCode ) tblOldRtn ON tblOldRtn.ProductCode=C.ProductCode

	

	where C.Productgroupid=1
	order by ProductName
END


if(@Type='Territory')
begin
	SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,tblC.ProductCode,tblC.ProductCode,

	--invoice
ISNULL(tblA.NumberofProformaInvoice,0)  AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0)  AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0)  AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0)  + ISNULL(tblA.SumofNetProformaAmount,0) )GrossProforma


--return
,tblD.ProductCode,
ISNULL(tblRtn.Retqty,0) + isnull(tblOldRtn.Retqty,0) AS RetQty,
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) AS SumofNetReturnAmount 
,isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0)   AS DelReTpVat ,
isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)GrossRetuen


--Sales
,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.DeliveryQuantity, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.Retqty, 0)) AS NumberofInvoiceSold

, (ISNULL(tblSaleBonusQty.DeliveryQuantity,0)) -  (ISNULL(tblRtnBonus.Retqty,0))  AS bouns,
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) AS SumofNetSalesAmount,
(isnull(tblSale.SalesVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0) )-(isnull(tblRtn.ReturnAmountVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0)) AS DelTpVat,
 ((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))  AS GrossSales,
CONVERT(DECIMAL(18, 2), ISNULL(tblSale.SalesDiscount, 0)) - CONVERT(DECIMAL(18, 2), ISNULL(tblRtn.JustSalesDiscount, 0))
  AS TotalDiscountAmount ,


--(((ISNULL(tblA.SumofNetProformaAmount,0) )  -  (ISNULL(tblD.SumofNetReturnAmount,0)  )))+(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0)) ) )
--(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
--,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
--,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
--((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales


ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0)
AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0) AS DelTpVatCollection 
,(ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )
+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 AS GrossSalesCollection



FROM dbo.tblProduct C with(NoLock) 


 --LEFT JOIN   ( select ProductCode,sum(tblReturnInvoiceDetail.UnitVatAmount*Quantity)TpVat,sum(tblReturnInvoiceDetail.TotalPrice)TpTotal,sum(tblReturnInvoiceDetail.NetAmount)TpGrandTotal from tblReturnInvoice
 --inner join tblReturnInvoiceDetail on tblReturnInvoice.ReturnInvoiceId=tblReturnInvoiceDetail.ReturnInvoiceId
	--	                  where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ProductCode  )
	--	                  tblAdjust ON tblAdjust.ProductCode = C.ProductCode 



--LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
--FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 AND  
--InvoiceDate BETWEEN @fromdate and @todate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode  


LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount 
FROM dbo.tblInvoice  WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = tblInvoice.OrderId
  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.ISGiftProduct=1 and  
tblInvoice.UpdateDate BETWEEN @fromdate and @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   




LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @fromdate and @todate AND 
I.TpGrandTotal>0   GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   



LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,
SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate and @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode 



LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate and @todate AND 
I.TpGrandTotal>0   and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode 




LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate 
BETWEEN @fromdate and @todate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode 




LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
FROM dbo.tblInvoice I WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @fromdate and @todate)  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) 
 GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode 
 
 
 
 
 --LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
 --FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate 
 --AND @todate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode 
 
 
 
 
 LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, (SUM(D.DiscountAmount)+(SUM(ISNULL(D.AdjustmentAmount,0))))DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)
 INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = tblInvoice.OrderId
   INNER JOIN dbo.tblInvoiceDetail D 
 WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId<>0 and tblInvoice.InvoiceDate BETWEEN @fromdate and @todate and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))  GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  
 
 
 
 --LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
 --SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) 
 --ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE InvoiceDate BETWEEN @fromdate and @todate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  
 
 
 
 LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- 
 SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,
 SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
 INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
  INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') 
  AND I.UpdateDate BETWEEN @fromdate and @todate AND I.TpGrandTotal>0  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId)) GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  
  
  
  
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
		LEFT JOIN   (SELECT    ID.ProductCode, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  and  (ar.AreaId= COALESCE( NULLIF(@Area , 0) ,ar.AreaId)) and (tr.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,tr.TerritoryId))  and     (rg.RegionId= COALESCE( NULLIF(@ZonId , 0) ,rg.RegionId)) group by  ID.ProductCode)tblCollection ON tblCollection.ProductCode  =C.ProductCode 


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
		 
		 ---return 1

		 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  ID.ProductCode

)tblRtn ON tblRtn.ProductCode=C.ProductCode


-- rtn for bouns prod
	 LEFT JOIN (SELECT  ID.ProductCode ,count(DISTINCT I.InvoiceId) NumberofReturn, count(ID.DeliveryQuantity-ID.PaymentQuantity) Retqty, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt


 FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE ISGiftProduct=1 and I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  ID.ProductCode

)tblRtnBonus ON tblRtnBonus.ProductCode=C.ProductCode


 --Sales

LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null  and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  D.ProductCode)tblSale ON tblSale.ProductCode=c.ProductCode

-- sales bonus
LEFT JOIN   (SELECT D.ProductCode,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt, SUM(D.DeliveryQuantity) DeliveryQuantity FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE ISGiftProduct=1 and      I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))   GROUP BY  D.ProductCode)tblSaleBonusQty ON tblSaleBonusQty.ProductCode=c.ProductCode


 ---return 2

LEFT JOIN   (
SELECT  ID.ProductCode ,count(ID.Quantity-ID.DeliveryQuantity) Retqty,
--sum(ISNULL(ID.TotalPrice- ID.DeliveryTotalPrice,0))
((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS ReturnAmountTP, 
sum( ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount) ReturnAmountVat,
sum(ID.NetAmount-ID.DeliveryNetAmount) ReturnGrossAmt


FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
		 
	 
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId

INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  and (mas.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,mas.TerritoryId))  and  (mas.AreaId= COALESCE( NULLIF(@Area , 0) ,mas.AreaId)) and     (mas.RegionId= COALESCE( NULLIF(@ZonId , 0) ,mas.RegionId))  GROUP BY  ID.ProductCode ) tblOldRtn ON tblOldRtn.ProductCode=C.ProductCode

	

	where C.Productgroupid=1
	order by ProductName
END

 

END

--select * from tblproduct