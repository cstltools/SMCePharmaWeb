
CREATE PROCEDURE [dbo].[sp_Rep_DepopsitSlip_BusinessSummaryClosingReport] 
	@fromdate datetime,
	@todate datetime,
	@ComUnitId varchar(50) = null
AS
BEGIN


  SET NOCOUNT ON;

 DECLARE @InputFrom DATE = @fromdate;   -- 09-Aug-2025
DECLARE @InputTo   DATE = @todate;     -- 23-Aug-2025

----------------------------------------------------------------
-- 2) Fixed system start date (From Date always 01-Jul-2025)
----------------------------------------------------------------
DECLARE @SystemStart DATE = '2025-07-01';  -- always fixed

----------------------------------------------------------------
-- 3) Base Date = user From Date
----------------------------------------------------------------
DECLARE @BaseDate DATE = @InputFrom;       -- 09-Aug-2025

----------------------------------------------------------------
-- 4) SP-এর জন্য আসল From/To বের করি
--    FromDate = 01-Jul-2025
--    ToDate   = (BaseDate - 1 day) = 08-Aug-2025
----------------------------------------------------------------
SET @fromdate = @SystemStart;                 -- 01-Jul-2025
SET @todate   = DATEADD(DAY, -1, @BaseDate);  -- 08-Aug-2025

	    BEGIN TRY
        BEGIN TRAN;
  IF CAST(@InputFrom AS DATE) <> CAST(@SystemStart AS DATE)
BEGIN
    DELETE FROM dbo.tblDepositOpeningBalance
    WHERE CAST(OpeningDate AS DATE) = @baseDate;
INSERT INTO [dbo].[tblDepositOpeningBalance]
           ([Bran]
           ,[CollectionInHand]
           ,[MarketOutstanding]
           ,[TotalReceivable]
           ,[OpeningDate]
           ,[ComUnitID]
           ,[Name])
		   select ShortName, ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable,@baseDate,ComUnitId,'' from ( 
             select  ComUnitId,isnull((isnull(CashinHand,0)+isnull(TotalCollection,0)) - isnull(totalDeposit,0),0) ClosingCashinHand, isnull((isnull(MArketOutStanding,0)+isnull(JustSalesTotal,0))- isnull(TotalCollection,0),0) ClosingMarketOutstanding, isnull((isnull(CashinHand,0)+isnull(TotalCollection,0)) - isnull(totalDeposit,0),0) + isnull((isnull(MArketOutStanding,0)+isnull(JustSalesTotal,0))- isnull(TotalCollection,0),0)  ClosingTotalReceivable , ShortName from (
	select  u.ComUnitId, isnull(tblcurrentcollection.CurrentPay,0) +  isnull(tblOldRtnPrior.PreviousPay,0)+ (isnull(tblColBak.CollectionAmtTP_B,0)+isnull(tblColBak.CollectionVat_B,0))  as TotalCollection, isnull(tblOldRtnPrior.PreviousPay,0)  PriorPeriodSales	,  '' AS ComUnitCode,ShortName,
	(isnull(tblcurrentcollection.CurrentPay,0) + (isnull(tblColBak.CollectionAmtTP_B,0)+isnull(tblColBak.CollectionVat_B,0))) CurrentPeriodSales	, 
	  -----------tttt
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0))-((isnull(tblRtn.ReturnAmountTP,0) +  isnull(tbl2Rtn.TP,0)) ) JustSalesAmtTP,  isnull(tblSale.SalesVat,0)- (isnull(tblRtn.ReturnAmountVat,0)+isnull(tbl2Rtn.vat,0)) JustSalesVat,


 -----
( ((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)) ) - isnull(tbl2Rtn.gross,0) JustSalesTotal,
-- ( (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0))-((isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) +(isnull(JustSalesDiscount,0))) )+ (isnull(tblSale.SalesVat,0)- (isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0))) JustSalesTotal,

isnull(tblDps.CollectionInHand,0) as  CashinHand ,isnull(tblDps.MarketOutstanding,0) as MArketOutStanding, isnull(tblDps.TotalReceivable,0)  as TotalOpeningReceivable,


--((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
--,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
--((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales


((ISNULL(tblA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) ))-ISNULL(tblDr.SumofNetReturnAmount,0) AS SalesOnTP--7
,(((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - ISNULL(tblDr.TotalPriceVatAmount,0) AS TpVat--8
,((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)) AS TotalSales--9


--,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,
,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection_2

,(ISNULL(tblCollection.TotalNetPayable,0)+ISNULL(tblCollectionold.TotalNetPayable,0)+ISNULL(tblCollectionoldsub.TotalNetPayable,0) )
--+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)
 CurrentPeriodSales_2


,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+(((((ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
(ISNULL(tblDps.MarketOutstanding,0.0)+(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)))) -((ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0)) ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+(((((ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0))+((ISNULL(tblDps.MarketOutstanding,0.0)+(((ISNULL(tblA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) ) +((ISNULL(tblA.ProTpVat,0) )-(ISNULL(tblD.TotalPriceVatAmount,0) ))) - (ISNULL(tblDr.SumofNetReturnAmount,0)+ISNULL(tblDr.TotalPriceVatAmount,0)))) -((ISNULL(tblCollection.TpTotal,0)+ISNULL(tblCollectionold.TpTotal,0)+ISNULL(tblCollectionoldsub.TpTotal,0) )+ ISNULL(tblCollection.TotalVat,0)+ISNULL(tblCollectionold.TotalVat,0)+ISNULL(tblCollectionoldsub.TotalVat,0))) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)

--- Reior Collection 
LEFT JOIN   (
select  I.ComUnitId,SUM(isnull(TPAmount,0)) + sum(isnull(VATAmount,0)) AS PreviousPay from tblCustPayDetail
INNER JOIN dbo.tblInvoice I on tblCustPayDetail.InvoiceId=I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
WHERE  (custPaymentDate BETWEEN @fromdate AND @todate )  and (UpdateDate between '1-jan-2021' AND DATEADD(day, -1, @fromdate))
GROUP BY I.ComUnitId

) tblOldRtnPrior ON tblOldRtnPrior.ComUnitId=u.ComUnitId
left join (SELECT  I.ComUnitId,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)

INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by I.ComUnitId) tblColBak  ON tblColBak.ComUnitId=u.ComUnitId


LEFT JOIN   (

select  I.ComUnitId,SUM(isnull(TPAmount,0)) + sum(isnull(VATAmount,0)) AS CurrentPay from tblCustPayDetail
INNER JOIN dbo.tblInvoice I on tblCustPayDetail.InvoiceId=I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
WHERE ( I.UpdateDate BETWEEN @fromdate AND @todate )  and (custPaymentDate BETWEEN @fromdate AND @todate ) 
GROUP BY I.ComUnitId
) tblcurrentcollection ON tblcurrentcollection.ComUnitId=U.ComUnitId
 --Collection
LEFT JOIN   (SELECT  mas.ComUnitId ,sum(isnull(custDtl.PaymentAmount,0)) CollectionGrossAmt,sum(isnull(custDtl.TPAmount,0)) CollectionAmtTP, sum(isnull(custDtl.VATAmount,0)) CollectionVat FROM   tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I  with(nolock)   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE       CONVERT(date, custDtl.CustPaymentDate) BETWEEN @fromdate AND @todate   GROUP BY   mas.ComUnitId )tblCollectionN ON tblCollectionN.ComUnitId=U.ComUnitId



--Cash in hand and Market Outstanding (collection but no depost)
left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate=@fromdate )tblDps on U.ComUnitId= tblDps.ComUnitID
--left join (select sum(isnull(PaymentAmount,0))Amount,ComUnitId from tblCustomerPay WITH(NOLOCK) group by ComUnitId )tblPay on U.ComUnitId= tblPay.ComUnitId

----Market Outstanding (sales but no collection)
--LEFT JOIN (SELECT SUM(tblInvoiceDetail.TotalPrice)Sales ,ComUnitId
--FROM dbo.tblInvoiceDetail  with(nolock) INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
--WHERE  ISGiftProduct=0 AND PaymentStatus IS null   GROUP BY ComUnitId) vTblMO ON vTblMO.ComUnitId = U.ComUnitId  

--LEFT JOIN (SELECT SUM(tblSubInvoiceDetail.TotalPrice)Sales ,ComUnitId
--FROM dbo.tblSubInvoiceDetail  with(nolock) INNER JOIN dbo.tblSubInvoiceMaster ON tblSubInvoiceMaster.InvoiceId=tblSubInvoiceMaster.InvoiceId  
--WHERE  ISGiftProduct=0  AND PaymentStatus IS NULL GROUP BY ComUnitId) vTblMOSub ON vTblMOSub.ComUnitId = U.ComUnitId  

 --Sales

LEFT JOIN   (SELECT mas.ComUnitId,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)  SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  mas.ComUnitId)tblSale ON tblSale.ComUnitId=U.ComUnitId

 --Return

LEFT JOIN   (
SELECT  mas.ComUnitId,count(ID.Quantity-ID.DeliveryQuantity) NumberofReturn,
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
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  mas.ComUnitId) tblOldRtn ON tblOldRtn.ComUnitId=U.ComUnitId





--payment Return
LEFT JOIN (SELECT  mas.ComUnitId ,count(DISTINCT I.InvoiceId) NumberofReturn,  sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)) 
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  mas.ComUnitId 

)tblRtn ON tblRtn.ComUnitId=U.ComUnitId
--Current Period Sales

LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat,SUM(ID.NetAmount)NetAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , 
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,
SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate AND @todate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 
  
  
--return start
LEFT JOIN (SELECT ComUnitId, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId     
	 

--Old system return start
LEFT JOIN (SELECT ComUnitId, ((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
GROUP BY ComUnitId)tblDr ON tblDr.ComUnitId=U.ComUnitId     
	

--LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
--AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
--WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN @fromdate AND @todate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
--   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
--    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
--	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  
--	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN @fromdate AND @todate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId



-- Sales Collection


	--					   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 --SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 --WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN @fromdate AND @todate) AND InvoiceDate >= @fromdate    GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 --LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 --SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
 -- WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN @fromdate AND @todate  AND InvoiceDate >= @fromdate  GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < @fromdate  AND UpdateDate BETWEEN @fromdate AND @todate GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < @fromdate  AND UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 


-- Deposit

left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between @fromdate and @todate group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId


--adjustment


		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN @fromdate AND @todate GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 


		--Collection
		LEFT JOIN   (SELECT    I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)- sum(ISNULL(ID.AdjustmentAmount,0)) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable
FROM dbo.tblInvoice I  with(nolock)
LEFT JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
LEFT JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
INNER JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId


LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
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
 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate group by   I.ComUnitId)tblCollection ON tblCollection.ComUnitId = U.ComUnitId 


		LEFT JOIN   ( select I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable


FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN SalesDisDB_SMC..tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial')   AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by I.ComUnitId )tblCollectionold ON tblCollectionold.ComUnitId = U.ComUnitId 



--- send time return

LEFT JOIN (




select  

U.ComUnitId  , 
sum(CAST(tblInvoiceDetailReturn.PreviousQuantity as decimal(18,1)))  - sum(CAST(tblInvoiceDetailReturn.sndReturnQuantity as decimal(18,1)))                   as Quantity,

sum(ISNULL(ivD.PaymentTotalPrice- tblInvoiceDetailReturn.sndReturnTotalPrice,0))     as TP,
--CAST(ivD.UnitPrice as decimal(18,2)) 	         as UnitPrice,
sum(ISNULL(ivD.PaymentTotalPriceVatAmount- tblInvoiceDetailReturn.sndReturnTotalPriceVatAmount,0))     as vat,

--(sum(CAST(tblInvoiceDetailReturn.PreviousQuantity as decimal(18,1)))  - sum(CAST(tblInvoiceDetailReturn.sndReturnQuantity as decimal(18,1)))   )*(ivD.UnitVatAmount)	  as	VAT,
sum(ISNULL(ivD.PaymentDiscountAmount- tblInvoiceDetailReturn.sndReturnDiscountAmount,0))     as DiscountAmount,

((sum(ISNULL(ivD.PaymentTotalPrice- tblInvoiceDetailReturn.sndReturnTotalPrice,0)) )-sum(ISNULL(ivD.PaymentDiscountAmount- tblInvoiceDetailReturn.sndReturnDiscountAmount,0)) ) + sum(ISNULL(ivD.PaymentTotalPriceVatAmount- tblInvoiceDetailReturn.sndReturnTotalPriceVatAmount,0)) gross



from tblInvoice  iv with(nolock)
inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
left join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
left join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
left join tblEmpGeneralInfo on tblEmpGeneralInfo.EmpMasterCode=o.OrderSenderCode
left join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
left join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode
left join tblArea on o.AreaId=tblArea.AreaId
left join tblRegion on o.RegionId =tblRegion.RegionId
left join tblDCStore on tblDCStore.DCStoreId =ivD.DCStoreId
inner join tblInvoiceDetailReturn on tblInvoiceDetailReturn.InvoiceDetailId=ivD.InvoiceDetailId

where  

tblInvoiceDetailReturn.PreviousQuantity<>tblInvoiceDetailReturn.sndReturnQuantity
 and CONVERT(date,iv.SndReturnPaymentDate) between 
 CONVERT(date,@fromdate) AND CONVERT(date,@todate)



Group by U.ComUnitId 


)tbl2Rtn ON tbl2Rtn.ComUnitId=U.ComUnitId



	LEFT JOIN   (select I.ComUnitId, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) TpTotal, sum(ID.DeliveryTotalPriceVatAmount)
TotalVat,  sum(ID.DeliveryNetAmount )  TotalNetPayable

FROM SalesDisDB_SMC..tblSubInvoiceMaster I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN SalesDisDB_SMC..tblSubDepotStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial')  AND CONVERT(date,I.UpdateDate)  BETWEEN @fromdate AND @todate  group by I.ComUnitId )tblCollectionoldsub ON U.ComUnitId = 13



  )tbl where tbl.ComUnitId not in (14,16) and (@ComUnitId IS NULL OR tbl.ComUnitId = @ComUnitId) ) t
  
	      END

        ----------------------------------------------------------------
        -- baki report er main SELECT / logic ekhane thakbe
        -- (tumi ja already chhilo, oita continue kore diye dibo)
        ----------------------------------------------------------------

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        -- Error re-throw korte chaile:
        THROW;
    END CATCH
END
