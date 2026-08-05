CREATE PROCEDURE [dbo].[sp_RPT_MIS_RptMIOWiseReceiveableReport] 

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


select      isnull(JustSalesDiscount,0) ReturnAmountDiscount,  isnull(SalesDiscount,0) JustSalesDiscount,  
 (isnull(tblcurrentcollection.CurrentPay,0) + (isnull(tblColBak.CollectionAmtTP_B,0)+isnull(tblColBak.CollectionVat_B,0))) CurrentPeriodSales	, 
isnull(tblOldRtnPrior.PreviousPay,0)  PriorPeriodSales	,
 --isnull(tblPriorSale.SalesGrossAmt,0) + 
  isnull(tblcurrentcollection.CurrentPay,0) +  isnull(tblOldRtnPrior.PreviousPay,0)  as TotalCollection,


 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) JustSalesAmtTP,
(isnull(tblSale.SalesVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0) )-(isnull(tblRtn.ReturnAmountVat,0) +  isnull(tblOldRtn.ReturnAmountVat,0)) JustSalesVat,
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)) JustSalesGrossAmt,
mioEmp.EmpMasterCode +' : '+mioEmp.EmpName ComUnitShortName,
--Invoice
isnull(tblInv.NumberofInvoice,0) NumberofInvoice, isnull(tblInv.InvoieAmountTP,0)  InvoieAmountTP,  isnull(tblInv.InvoiceVatTp,0) InvoiceVatTp,  isnull(tblInv.InvoiceGrossAmt,0)  InvoiceGrossAmt,
--Return
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) ReturnAmountTP, isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0) ReturnAmountVat,isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0) ReturnGrossAmt,
--Sales
isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) SalesAmtTP,
 isnull(tblSale.SalesVat,0) SalesVat, isnull(tblSale.SalesDiscount,0) SalesDiscount,
 isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0) SalesGrossAmt,

--Collection
isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0) CollectionAmtTP,  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionVat,

isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionGrossAmt,

--Receivable
((isnull(tblSale.SalesAmtTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) )-isnull(isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0),0) ReceivableTP,
0 ReceivableAmountTP, 0 ReceivableVAT, 
((isnull(tblSale.SalesGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))) - ((isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0)))  ReceivableGrossAmount,

--Rejection
isnull(tblRejection.RejectAmtTP,0) + isnull(tblPartialRejection.RejectAmtTP,0) RejectAmtTP, isnull(tblRejection.RejectionTpVat,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectionTpVat,isnull(tblRejection.RejectGrossAmt,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectGrossAmt
  
--FROM dbo.tblCompanyUnit cUnit with(NoLock)   
FROM  dbo.tblTerritory tr with(NoLock)
inner join tblMIOInfo mio on tr.TerritoryId=mio.TerritoryId
inner join tblEmpGeneralInfo mioEmp on mioEmp.EmpInfoId=mio.EmployeeId
--Invoice
LEFT JOIN (SELECT mas.TerritoryId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY mas.TerritoryId

)tblInv ON tblInv.TerritoryId=tr.TerritoryId



 --Sales

LEFT JOIN   (SELECT mas.TerritoryId,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount)SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat, SUM(D.DeliveryDiscountAmount) SalesDiscount,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  mas.TerritoryId)tblSale ON tblSale.TerritoryId=tr.TerritoryId


---PriorPeriodSales
LEFT JOIN   (SELECT mas.TerritoryId,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN '01-jan-2019' AND @fromdate and DelivaryInvoiceNo is not null   GROUP BY  mas.TerritoryId)tblPriorSale ON tblPriorSale.TerritoryId=tr.TerritoryId
 
  --Rejection 
LEFT JOIN   (SELECT mas.TerritoryId,COUNT(DISTINCT rejMas.InvoiceId)RejectionNumberofInvoice,SUM(D.NetAmount - D.TotalPriceVatAmount) RejectAmtTP , 
SUM(D.TotalPriceVatAmount)RejectionTpVat, SUM(D.NetAmount - D.TotalPriceVatAmount) + 
SUM(D.TotalPriceVatAmount) RejectGrossAmt FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK) 
INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = rejMas.OrderId
WHERE   RejectionDate BETWEEN @fromdate AND @todate   GROUP BY  mas.TerritoryId)tblRejection ON tblRejection.TerritoryId=tr.TerritoryId


--Partial Rejection
LEFT JOIN   (

 SELECT   mas.TerritoryId ,SUM(ID.NetAmount-ID.DeliveryNetAmount)RejectGrossAmt,
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
where RejectionSts is null  and I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null and ID.DeliveryStatus IN ('Reject','Partial')  group by  mas.TerritoryId)tblPartialRejection ON tblPartialRejection.TerritoryId=tr.TerritoryId



--payment Return
LEFT JOIN (SELECT  mas.TerritoryId ,count(DISTINCT I.InvoiceId) NumberofReturn,  sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS JustSalesDiscount,   sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  mas.TerritoryId 

)tblRtn ON tblRtn.TerritoryId=tr.TerritoryId


 --Collection
LEFT JOIN   (SELECT  mas.TerritoryId ,sum(isnull(custDtl.PaymentAmount,0)) CollectionGrossAmt,sum(isnull(custDtl.TPAmount,0)) CollectionAmtTP, sum(isnull(custDtl.VATAmount,0)) CollectionVat FROM   tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I  with(nolock)   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE       CONVERT(date, custDtl.CustPaymentDate) BETWEEN @fromdate AND @todate  GROUP BY   mas.TerritoryId )tblCollection ON tblCollection.TerritoryId=tr.TerritoryId


left join (SELECT  mas.TerritoryCode,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
INNER JOIN SalesDisDB_SMC..tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by mas.TerritoryCode) tblColBak  ON tblColBak.TerritoryCode=tr.TerritoryCode


 

--- Delivery Return
LEFT JOIN   (
SELECT  mas.TerritoryId,count(ID.Quantity-ID.DeliveryQuantity) NumberofReturn,
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
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  mas.TerritoryId) tblOldRtn ON tblOldRtn.TerritoryId=tr.TerritoryId


--- Reior Collection 
LEFT JOIN   (
select  mas.TerritoryId,SUM(isnull(TPAmount,0)) + sum(isnull(VATAmount,0)) AS PreviousPay from tblCustPayDetail
INNER JOIN dbo.tblInvoice I on tblCustPayDetail.InvoiceId=I.InvoiceId
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
WHERE  (custPaymentDate BETWEEN @fromdate AND @todate )  and (I.UpdateDate between '1-jan-2021' AND DATEADD(day, -1, @fromdate))
GROUP BY mas.TerritoryId

) tblOldRtnPrior ON tblOldRtnPrior.TerritoryId=tr.TerritoryId

LEFT JOIN   (

select  mas.TerritoryId,SUM(isnull(TPAmount,0)) + sum(isnull(VATAmount,0)) AS CurrentPay from tblCustPayDetail
INNER JOIN dbo.tblInvoice I on tblCustPayDetail.InvoiceId=I.InvoiceId
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
WHERE ( I.UpdateDate BETWEEN @fromdate AND @todate )  and (custPaymentDate BETWEEN @fromdate AND @todate ) 
GROUP BY mas.TerritoryId
) tblcurrentcollection ON tblcurrentcollection.TerritoryId=tr.TerritoryId


--where cUnit.ComUnitId<>14
ORDER BY tr.TerritoryCode
end


----Zone

if(@Type='Zone')

begin


select  rgn.RegionCode, rgn.RegionCode +' : '+rgn.RegionName RegionName, 
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) JustSalesAmtTP,
0 JustSalesVat,
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)) JustSalesGrossAmt,
--Invoice
isnull(tblInv.NumberofInvoice,0) NumberofInvoice, isnull(tblInv.InvoieAmountTP,0)  InvoieAmountTP,  isnull(tblInv.InvoiceVatTp,0) InvoiceVatTp,  isnull(tblInv.InvoiceGrossAmt,0)  InvoiceGrossAmt,
--Return
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) ReturnAmountTP, isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0) ReturnAmountVat,isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0) ReturnGrossAmt,
--Sales
isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) SalesAmtTP,
 isnull(tblSale.SalesVat,0) SalesVat,
 isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0) SalesGrossAmt,

--Collection
isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0) CollectionAmtTP,  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionVat,

isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionGrossAmt,

--Receivable
((isnull(tblSale.SalesAmtTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) )-isnull(isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0),0) ReceivableTP,
0 ReceivableAmountTP, 0 ReceivableVAT, 
((isnull(tblSale.SalesGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))) - ((isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0)))  ReceivableGrossAmount,

--Rejection
isnull(tblRejection.RejectAmtTP,0) + isnull(tblPartialRejection.RejectAmtTP,0) RejectAmtTP, isnull(tblRejection.RejectionTpVat,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectionTpVat,isnull(tblRejection.RejectGrossAmt,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectGrossAmt
  
FROM dbo.tblRegion rgn with(NoLock)    

--Invoice
LEFT JOIN (SELECT mas.RegionId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY mas.RegionId

)tblInv ON tblInv.RegionId=rgn.RegionId



 --Sales

LEFT JOIN   (SELECT mas.RegionId,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  mas.RegionId)tblSale ON tblSale.RegionId=rgn.RegionId
 
  --Rejection 
LEFT JOIN   (SELECT mas.RegionId,COUNT(DISTINCT rejMas.InvoiceId)RejectionNumberofInvoice,SUM(D.NetAmount - D.TotalPriceVatAmount) RejectAmtTP , 
SUM(D.TotalPriceVatAmount)RejectionTpVat, SUM(D.NetAmount - D.TotalPriceVatAmount) + 
SUM(D.TotalPriceVatAmount) RejectGrossAmt FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK) 
INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = rejMas.OrderId
WHERE   RejectionDate BETWEEN @fromdate AND @todate   GROUP BY  mas.RegionId)tblRejection ON tblRejection.RegionId=rgn.RegionId


--Partial Rejection
LEFT JOIN   (

 SELECT   mas.RegionId ,SUM(ID.NetAmount-ID.DeliveryNetAmount)RejectGrossAmt,
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
where RejectionSts is null  and I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null and ID.DeliveryStatus IN ('Reject','Partial')  group by  mas.RegionId)tblPartialRejection ON tblPartialRejection.RegionId=rgn.RegionId



--payment Return
LEFT JOIN (SELECT  mas.RegionId ,count(DISTINCT I.InvoiceId) NumberofReturn,  sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  mas.RegionId 

)tblRtn ON tblRtn.RegionId=rgn.RegionId


 --Collection
LEFT JOIN   (SELECT  mas.RegionId ,sum(isnull(custDtl.PaymentAmount,0)) CollectionGrossAmt,sum(isnull(custDtl.TPAmount,0)) CollectionAmtTP, sum(isnull(custDtl.VATAmount,0)) CollectionVat FROM   tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I  with(nolock)   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE       CONVERT(date, custDtl.CustPaymentDate) BETWEEN @fromdate AND @todate    GROUP BY   mas.RegionId )tblCollection ON tblCollection.RegionId=rgn.RegionId


left join (SELECT  I.RegionCode,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)

INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by I.RegionCode) tblColBak  ON tblColBak.RegionCode=rgn.RegionCode

 

--- Delivery Return
LEFT JOIN   (
SELECT  mas.RegionId,count(ID.Quantity-ID.DeliveryQuantity) NumberofReturn,
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
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  mas.RegionId) tblOldRtn ON tblOldRtn.RegionId=rgn.RegionId

  where   (rgn.RegionId= COALESCE( NULLIF(@ZonId , 0) ,rgn.RegionId))  
ORDER BY rgn.RegionCode

 

end




---Area

if(@Type='AreaTran')

begin


select  ar.AreaCode, rn.RegionCode +' : '+rn.RegionName RegionName, ar.AreaCode +' : '+ar.AreaName AreaName,
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) JustSalesAmtTP,
0 JustSalesVat,
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)) JustSalesGrossAmt,
--Invoice
isnull(tblInv.NumberofInvoice,0) NumberofInvoice, isnull(tblInv.InvoieAmountTP,0)  InvoieAmountTP,  isnull(tblInv.InvoiceVatTp,0) InvoiceVatTp,  isnull(tblInv.InvoiceGrossAmt,0)  InvoiceGrossAmt,
--Return
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) ReturnAmountTP, isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0) ReturnAmountVat,isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0) ReturnGrossAmt,
--Sales
isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) SalesAmtTP,
 isnull(tblSale.SalesVat,0) SalesVat,
 isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0) SalesGrossAmt,

--Collection
isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0) CollectionAmtTP,  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionVat,

isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionGrossAmt,

--Receivable
((isnull(tblSale.SalesAmtTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) )-isnull(isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0),0) ReceivableTP,
0 ReceivableAmountTP, 0 ReceivableVAT, 
((isnull(tblSale.SalesGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))) - ((isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0)))  ReceivableGrossAmount,

--Rejection
isnull(tblRejection.RejectAmtTP,0) + isnull(tblPartialRejection.RejectAmtTP,0) RejectAmtTP, isnull(tblRejection.RejectionTpVat,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectionTpVat,isnull(tblRejection.RejectGrossAmt,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectGrossAmt
  
FROM  dbo.tblArea ar with(NoLock)   
INNER JOIN dbo.tblRegion rn  WITH (NOLOCK) ON ar.RegionId = rn.RegionId

--Invoice
LEFT JOIN (SELECT mas.AreaId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY mas.AreaId

)tblInv ON tblInv.AreaId=ar.AreaId



 --Sales

LEFT JOIN   (SELECT mas.AreaId,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  mas.AreaId)tblSale ON tblSale.AreaId=ar.AreaId
 
  --Rejection 
LEFT JOIN   (SELECT mas.AreaId,COUNT(DISTINCT rejMas.InvoiceId)RejectionNumberofInvoice,SUM(D.NetAmount - D.TotalPriceVatAmount) RejectAmtTP , 
SUM(D.TotalPriceVatAmount)RejectionTpVat, SUM(D.NetAmount - D.TotalPriceVatAmount) + 
SUM(D.TotalPriceVatAmount) RejectGrossAmt FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK) 
INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = rejMas.OrderId
WHERE   RejectionDate BETWEEN @fromdate AND @todate   GROUP BY  mas.AreaId)tblRejection ON tblRejection.AreaId=ar.AreaId


--Partial Rejection
LEFT JOIN   (

 SELECT   mas.AreaId ,SUM(ID.NetAmount-ID.DeliveryNetAmount)RejectGrossAmt,
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
where RejectionSts is null  and I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null and ID.DeliveryStatus IN ('Reject','Partial')  group by  mas.AreaId)tblPartialRejection ON tblPartialRejection.AreaId=ar.AreaId



--payment Return
LEFT JOIN (SELECT  mas.AreaId ,count(DISTINCT I.InvoiceId) NumberofReturn,  sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  mas.AreaId 

)tblRtn ON tblRtn.AreaId=ar.AreaId


 --Collection
LEFT JOIN   (SELECT  ddd.AreaId ,sum(isnull(custDtl.PaymentAmount,0)) CollectionGrossAmt,sum(isnull(custDtl.TPAmount,0)) CollectionAmtTP, sum(isnull(custDtl.VATAmount,0)) CollectionVat FROM   tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I  with(nolock)   ON I.InvoiceId = custDtl.InvoiceId

INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 

LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1


--INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId


WHERE       CONVERT(date, custDtl.CustPaymentDate) BETWEEN @fromdate AND @todate   GROUP BY   ddd.AreaId )tblCollection ON tblCollection.AreaId=ar.AreaId




left join (SELECT  I.DisCode,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)

INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by I.DisCode) tblColBak  ON tblColBak.DisCode=ar.AreaCode

 

--- Delivery Return
LEFT JOIN   (
SELECT  mas.AreaId,count(ID.Quantity-ID.DeliveryQuantity) NumberofReturn,
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
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  mas.AreaId) tblOldRtn ON tblOldRtn.AreaId=ar.AreaId

where  (ar.AreaId= COALESCE( NULLIF(@Area , 0) ,ar.AreaId)) and     (rn.RegionId= COALESCE( NULLIF(@ZonId , 0) ,rn.RegionId))    
ORDER BY ar.AreaCode
 

end




---TerritoryTran

if(@Type='TerritoryTran')
begin


select   tr.TerritoryCode, rgn.RegionCode +' : '+rgn.RegionName RegionName, ara.AreaCode +' : '+ara.AreaName AreaName, tr.TerritoryCode +' : '+tr.TerritoryName TerritoryName, 
 (isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) JustSalesAmtTP,
0 JustSalesVat,
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0)) JustSalesGrossAmt,
--Invoice
isnull(tblInv.NumberofInvoice,0) NumberofInvoice, isnull(tblInv.InvoieAmountTP,0)  InvoieAmountTP,  isnull(tblInv.InvoiceVatTp,0) InvoiceVatTp,  isnull(tblInv.InvoiceGrossAmt,0)  InvoiceGrossAmt,
--Return
isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0) ReturnAmountTP, isnull(tblRtn.ReturnAmountVat,0)+isnull(tblOldRtn.ReturnAmountVat,0) ReturnAmountVat,isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0) ReturnGrossAmt,
--Sales
isnull(tblSale.SalesAmtTP,0)+  isnull(tblOldRtn.ReturnAmountTP,0) SalesAmtTP,
 isnull(tblSale.SalesVat,0) SalesVat,
 isnull(tblSale.SalesGrossAmt,0)+ isnull(tblOldRtn.ReturnGrossAmt,0) SalesGrossAmt,

--Collection
isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0) CollectionAmtTP,  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionVat,

isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0) CollectionGrossAmt,

--Receivable
((isnull(tblSale.SalesAmtTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) )-isnull(isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0),0) ReceivableTP,
0 ReceivableAmountTP, 0 ReceivableVAT, 
((isnull(tblSale.SalesGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))) - ((isnull(tblCollection.CollectionAmtTP,0) + isnull(tblColBak.CollectionAmtTP_B,0)+  isnull(tblCollection.CollectionVat,0) + isnull(tblColBak.CollectionVat_B,0)))  ReceivableGrossAmount,


--Receivable
((isnull(tblSale.SalesAmtTP,0) )-(isnull(tblRtn.ReturnAmountTP,0) +  isnull(tblOldRtn.ReturnAmountTP,0)) )-isnull(tblCollection.CollectionAmtTP,0) ReceivableTP,
0 ReceivableAmountTP, 0 ReceivableVAT, 
((isnull(tblSale.SalesGrossAmt,0))-(isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))) - ((isnull(tblCollection.CollectionAmtTP,0) +  isnull(tblCollection.CollectionVat,0)))  ReceivableGrossAmount,

--Rejection
isnull(tblRejection.RejectAmtTP,0) + isnull(tblPartialRejection.RejectAmtTP,0) RejectAmtTP, isnull(tblRejection.RejectionTpVat,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectionTpVat,isnull(tblRejection.RejectGrossAmt,0)+ isnull(tblPartialRejection.RejectAmtTP,0) RejectGrossAmt
  
FROM  dbo.tblTerritory tr with(NoLock)   
INNER JOIN dbo.tblArea ara  WITH (NOLOCK) ON ara.AreaId=tr.AreaId
INNER JOIN dbo.tblRegion rgn  WITH (NOLOCK) ON ara.RegionId = rgn.RegionId
--Invoice
LEFT JOIN (SELECT mas.TerritoryId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY mas.TerritoryId

)tblInv ON tblInv.TerritoryId=tr.TerritoryId



 --Sales

LEFT JOIN   (SELECT mas.TerritoryId,COUNT(DISTINCT I.InvoiceId)SalesNumberofInvoice,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SalesAmtTP , 
SUM(D.DeliveryTotalPriceVatAmount) SalesVat,   SUM(D.DeliveryNetAmount) SalesGrossAmt FROM dbo.tblInvoice I  WITH (NOLOCK) 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId   
WHERE       I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null   GROUP BY  mas.TerritoryId)tblSale ON tblSale.TerritoryId=tr.TerritoryId
 
  --Rejection 
LEFT JOIN   (SELECT mas.TerritoryId,COUNT(DISTINCT rejMas.InvoiceId)RejectionNumberofInvoice,SUM(D.NetAmount - D.TotalPriceVatAmount) RejectAmtTP , 
SUM(D.TotalPriceVatAmount)RejectionTpVat, SUM(D.NetAmount - D.TotalPriceVatAmount) + 
SUM(D.TotalPriceVatAmount) RejectGrossAmt FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK) 
INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = rejMas.OrderId
WHERE   RejectionDate BETWEEN @fromdate AND @todate   GROUP BY  mas.TerritoryId)tblRejection ON tblRejection.TerritoryId=tr.TerritoryId


--Partial Rejection
LEFT JOIN   (

 SELECT   mas.TerritoryId ,SUM(ID.NetAmount-ID.DeliveryNetAmount)RejectGrossAmt,
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
where RejectionSts is null  and I.UpdateDate BETWEEN @fromdate AND @todate and DelivaryInvoiceNo is not null and ID.DeliveryStatus IN ('Reject','Partial')  group by  mas.TerritoryId)tblPartialRejection ON tblPartialRejection.TerritoryId=tr.TerritoryId



--payment Return
LEFT JOIN (SELECT  mas.TerritoryId ,count(DISTINCT I.InvoiceId) NumberofReturn,  sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,( sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)))
+ sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnGrossAmt FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE  I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0) and convert(date,PaymentDate) BETWEEN @fromdate AND @todate  GROUP BY  mas.TerritoryId 

)tblRtn ON tblRtn.TerritoryId=tr.TerritoryId


 --Collection
LEFT JOIN   (SELECT  cc.TerritoryId ,sum(isnull(custDtl.PaymentAmount,0)) CollectionGrossAmt,sum(isnull(custDtl.TPAmount,0)) CollectionAmtTP, sum(isnull(custDtl.VATAmount,0)) CollectionVat FROM   tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I  with(nolock)   ON I.InvoiceId = custDtl.InvoiceId

INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 

LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1


--INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
WHERE       CONVERT(date, custDtl.CustPaymentDate) BETWEEN @fromdate AND @todate     GROUP BY   cc.TerritoryId )tblCollection ON tblCollection.TerritoryId=tr.TerritoryId


left join (SELECT  I.AreaCode,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)

INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by I.AreaCode) tblColBak  ON tblColBak.AreaCode=tr.TerritoryCode


 

--- Delivery Return
LEFT JOIN   (
SELECT  mas.TerritoryId,count(ID.Quantity-ID.DeliveryQuantity) NumberofReturn,
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
where RejectionSts='Old' and ID.DeliveryStatus IN ('Reject','Partial') and I.UpdateDate BETWEEN @fromdate AND @todate  GROUP BY  mas.TerritoryId) tblOldRtn ON tblOldRtn.TerritoryId=tr.TerritoryId

  where (ara.AreaId= COALESCE( NULLIF(@Area , 0) ,ara.AreaId))   and (tr.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,tr.TerritoryId))   and     (rgn.RegionId= COALESCE( NULLIF(@ZonId , 0) ,rgn.RegionId))   
ORDER BY tr.TerritoryCode

end

end




