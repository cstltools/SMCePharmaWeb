create PROCEDURE [dbo].[sp_RPT_MIS_ProductWiseSalesReport] 

	@fromdate datetime,
	@todate datetime,
	@Type nvarchar(max) ,
	@Area nvarchar(max) ,
	@Terr nvarchar(max) ,
	@ZonId  nvarchar(max) 
AS
BEGIN


if(@Type='SC')

begin


select  
   isnull(SalesDiscount,0)-isnull(JustSalesDiscount,0) JustSalesDiscount, 
isnull(JustSalesDiscount,0) ReturnAmountDiscount,  isnull(SalesDiscount,0) JustSalesDiscount,  
 (isnull(tblcurrentcollection.CurrentPay,0) + (isnull(tblColBak.CollectionAmtTP_B,0)+isnull(tblColBak.CollectionVat_B,0))) CurrentPeriodSales	, 
isnull(tblOldRtnPrior.PreviousPay,0) PriorPeriodSales	,
 --isnull(tblPriorSale.SalesGrossAmt,0) + 
  isnull(tblcurrentcollection.CurrentPay,0) +  isnull(tblOldRtnPrior.PreviousPay,0)+ isnull(tblColBak.CollectionAmtTP_B,0)+   isnull(tblColBak.CollectionVat_B,0)   as TotalCollection,

  -----------tttt
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0))-((isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) +(isnull(JustSalesDiscount,0))) JustSalesAmtTP,

 ---------------------

( isnull(tblSale.SalesVat,0)+ isnull(tblOldRtn.ReturnAmountVat,0) )- (isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0)) JustSalesVat,
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)) JustSalesGrossAmt,
 cUnit.ShortName ComUnitShortName,
--Invoice
isnull(tblInv.NumberofInvoice,0) NumberofInvoice, isnull(tblInv.InvoieAmountTP,0)  InvoieAmountTP,  isnull(tblInv.InvoiceVatTp,0) InvoiceVatTp,  isnull(tblInv.InvoiceGrossAmt,0)  InvoiceGrossAmt,
--Return
(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) +(isnull(JustSalesDiscount,0)) ReturnAmountTP, isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0) ReturnAmountVat,isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0) ReturnGrossAmt,
--Sales
isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) SalesAmtTP,
 isnull(tblSale.SalesVat,0)+ isnull(tblOldRtn.ReturnAmountVat,0) SalesVat, 
 isnull(tblSale.SalesDiscount,0)+isnull(tblOldRtn.returndiscount,0)+( ((isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0))) - (((isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) + isnull(tblSale.SalesVat,0)+ isnull(tblOldRtn.ReturnAmountVat,0) ))- isnull(tblSale.SalesDiscount,0)+isnull(tblOldRtn.returndiscount,0))) SalesDiscount,
 isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0) SalesGrossAmt,
 ((isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0))) - (((isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) + isnull(tblSale.SalesVat,0)+ isnull(tblOldRtn.ReturnAmountVat,0) ))- isnull(tblSale.SalesDiscount,0)+isnull(tblOldRtn.returndiscount,0)) diff,


--Collection
isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0) CollectionAmtTP, 
 isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionVat,

isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionGrossAmt,

--Receivable
((isnull(tblSale.SalesAmtTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) )-isnull(isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0),0) ReceivableTP,
0 ReceivableAmountTP, 0 ReceivableVAT, 
((isnull(tblSale.SalesGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))) - ((isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0)))  ReceivableGrossAmount,

--Rejection
isnull(tblRejection.RejectAmtTP,0) + isnull(tblPartialRejection.RejectAmtTP,0) RejectAmtTP, isnull(tblRejection.RejectionTpVat,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectionTpVat,isnull(tblRejection.RejectGrossAmt,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectGrossAmt
  
FROM dbo.tblCompanyUnit cUnit with(NoLock)   

--Invoice
LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY I.ComUnitId

)tblInv ON tblInv.ComUnitId=cUnit.ComUnitId



 --Sales

LEFT JOIN   (SELECT mas.ComUnitId,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) + SUM(D.DeliveryDiscountAmount) SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  mas.ComUnitId)tblSale ON tblSale.ComUnitId=cUnit.ComUnitId


---PriorPeriodSales
LEFT JOIN   (SELECT mas.ComUnitId,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN '01-jan-2019' AND @fromdate and DelivaryInvoiceNo is not null   GROUP BY  mas.ComUnitId)tblPriorSale ON tblPriorSale.ComUnitId=cUnit.ComUnitId
 
  --Rejection 
LEFT JOIN   (SELECT mas.ComUnitId,COUNT(DISTINCT rejMas.InvoiceId)RejectionNumberofInvoice,SUM(D.NetAmount - D.TotalPriceVatAmount) RejectAmtTP , 
SUM(D.TotalPriceVatAmount)RejectionTpVat, SUM(D.NetAmount - D.TotalPriceVatAmount) + 
SUM(D.TotalPriceVatAmount) RejectGrossAmt FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK) 
INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = rejMas.OrderId
WHERE   RejectionDate BETWEEN @fromdate AND @todate   GROUP BY  mas.ComUnitId)tblRejection ON tblRejection.ComUnitId=cUnit.ComUnitId


--Partial Rejection
LEFT JOIN   (

 SELECT   mas.ComUnitId ,SUM(ID.NetAmount-ID.DeliveryNetAmount)RejectGrossAmt,
SUM(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)RejectionTpVat,
SUM(ID.NetAmount-ID.DeliveryNetAmount)-SUM(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount) as RejectAmtTP
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
where RejectionSts is null  and I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null and ID.DeliveryStatus IN ('Reject','Partial')  group by  mas.ComUnitId)tblPartialRejection ON tblPartialRejection.ComUnitId=cUnit.ComUnitId



--payment Return
LEFT JOIN (SELECT  mas.ComUnitId ,count(DISTINCT I.InvoiceId) NumberofReturn,  sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)) 
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  mas.ComUnitId 

)tblRtn ON tblRtn.ComUnitId=cUnit.ComUnitId


 --Collection
LEFT JOIN   (SELECT  mas.ComUnitId ,sum(isnull(custDtl.PaymentAmount,0)) CollectionGrossAmt,sum(isnull(custDtl.TPAmount,0)) CollectionAmtTP, sum(isnull(custDtl.VATAmount,0)) CollectionVat FROM   tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I  with(nolock)   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE       CONVERT(date, custDtl.CustPaymentDate) BETWEEN @fromdate AND @todate   GROUP BY   mas.ComUnitId )tblCollection ON tblCollection.ComUnitId=cUnit.ComUnitId


left join (SELECT  I.ComUnitId,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)

INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by I.ComUnitId) tblColBak  ON tblColBak.ComUnitId=cUnit.ComUnitId


 

--- Delivery Return
LEFT JOIN   (
SELECT  mas.ComUnitId,count(ID.Quantity-ID.DeliveryQuantity) NumberofReturn,
--sum(ISNULL(ID.TotalPrice- ID.DeliveryTotalPrice,0))
((SUM(ID.TotalPrice)-sum(ID.DiscountAmount))- SUM(ID.DeliveryTotalPrice - ID.DeliveryDiscountAmount)) AS ReturnAmountTP, 
sum( ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount) ReturnAmountVat,
sum(ID.NetAmount-ID.DeliveryNetAmount) ReturnGrossAmt,
sum(ID.DiscountAmount+ID.DeliveryDiscountAmount)+sum(id.AdjustmentAmount) returndiscount


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
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  mas.ComUnitId) tblOldRtn ON tblOldRtn.ComUnitId=cUnit.ComUnitId


--- Reior Collection 
LEFT JOIN   (
select  I.ComUnitId,SUM(isnull(TPAmount,0)) + sum(isnull(VATAmount,0)) AS PreviousPay from tblCustPayDetail
INNER JOIN dbo.tblInvoice I on tblCustPayDetail.InvoiceId=I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
WHERE  (custPaymentDate BETWEEN @fromdate AND @todate )  and (UpdateDate between '1-jan-2021' AND DATEADD(day, -1, @fromdate))
GROUP BY I.ComUnitId

) tblOldRtnPrior ON tblOldRtnPrior.ComUnitId=cUnit.ComUnitId

LEFT JOIN   (

select  I.ComUnitId,SUM(isnull(TPAmount,0)) + sum(isnull(VATAmount,0)) AS CurrentPay from tblCustPayDetail
INNER JOIN dbo.tblInvoice I on tblCustPayDetail.InvoiceId=I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
WHERE ( I.UpdateDate BETWEEN @fromdate AND @todate )  and (custPaymentDate BETWEEN @fromdate AND @todate ) 
GROUP BY I.ComUnitId
) tblcurrentcollection ON tblcurrentcollection.ComUnitId=cUnit.ComUnitId

where cUnit.ComUnitId<>14
ORDER BY cUnit.ShortName
end




end




