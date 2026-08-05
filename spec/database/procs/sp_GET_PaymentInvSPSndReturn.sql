CREATE PROCEDURE [dbo].[sp_GET_PaymentInvSPSndReturn]
	-- Add the parameters for the stored procedure here
	@param nvarchar(max)
AS
BEGIN
   
    DECLARE @Q NVARCHAR(MAX)='SELECT ord.TerritoryName_Ord, case when  isnull(sndRTN.sndReturnTotalPrice,0)>0  then isnull(sndRTN.sndReturnTotalPrice,0) -isnull(TPAmount,0)  else (ISNULL(TotalDelivery,0)-isnull(tblinvDetls.PaymentTotalPriceVatAmount,0))  -isnull(TPAmount,0) end
 TP_Pay,
  case when  isnull(SndRTN.sndReturnTotalPriceVatAmount,0)>0 then  isnull(SndRTN.sndReturnTotalPriceVatAmount,0)-isnull(VATAmount,0) else 
   isnull(SndRTN.sndReturnTotalPriceVatAmount,0) -isnull(VATAmount,0) end 
  Vat_Pay , ord.OrderCode OrderNo,CONVERT(VARCHAR,ord.SubmissionDate,103) as OrderDate, ord.CustomerCode,ord.CustomerName,  ord.MarketId,ord.DistributionRouteId,  ord.CustomerMasterId,  INV.InvoiceId,InvoiceNo,InvoiceDate,PaymentInvoiceNo RtnInvoiceNo,INV.PaymentDate RtnInvoiceDate, case when  isnull(sndRTN.sndReturnNetAmount,0)>0 then  isnull(sndRTN.sndReturnNetAmount,0) else TotalDelivery end TotalDelivery,ISNULL(PP,0) PaymentAmount,  (case when  isnull(sndRTN.sndReturnNetAmount,0)>0 then  isnull(sndRTN.sndReturnNetAmount,0) else  ISNULL(TotalDelivery,0) end - ISNULL(PP,0)) AS   Due,ISNULL(ReturnTotal,0) AdjustableAmount FROM tblInvoice AS INV WITH(NOLOCK)
inner join tblOrder ord with (nolock) on INV.OrderId=ord.OrderId

--INNER JOIN tblCustMaster C ON C.CustomerMasterId = ord.CustomerMasterId
LEFT JOIN (SELECT InvoiceId,SUM(PaymentAmount) AS PP, SUM(TPAmount) AS TPAmount, SUM(VATAmount) AS VATAmount FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON INV.InvoiceId = P.InvoiceId 
inner JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON INV.InvoiceId = TD.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(TPGrandTotal) ReturnTotal FROM tblReturnInvoice  GROUP BY InvoiceId) AS RTN ON INV.InvoiceId= RTN.InvoiceId

LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON INV.InvoiceId= SndRTN.InvoiceId

inner join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail group by InvoiceId)tblinvDetls on 
tblinvDetls.InvoiceId=INV.InvoiceId
WHERE (ISNULL(TotalDelivery,0) - ISNULL(PP,0))>0 and PaymentInvoiceNo  IS NOT NULL    and  SndReturnInvoiceNo is  not  null and isnull(sndRTN.sndReturnTotalPrice,0)<>0   ' + @param +' order by InvoiceDate asc' 

--and  isnull(PaymentInvoiceStatus,'''')<>''Reject'' and ( PaymentStatus is null or PaymentStatus= ''Partial'')
--
	EXEC sp_executesql @Q

END
              