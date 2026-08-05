CREATE PROCEDURE [dbo].[sp_GetWarningForCustomerPayment_new] 
	-- Add the parameters for the stored procedure here
   
      @CustID nvarchar(max),
      @CustCode nvarchar(max)

AS
    BEGIN
	
	
	
--Select TOP 1  InvoiceNo + '- Market Name: ' + tblInvoice.MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal) 
--as Details,  DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) 
 
--from tblInvoice with (nolock)
--INNER JOIN tblCustMaster C ON tblInvoice.CustomerMasterId=C.CustomerMasterId
--where C.CustomerCode=@CustCode and InvoiceDate between '1-july-2021' and getdate() and 
--DelivaryInvoiceNo is not null and FinalPaymentNo is null and DATEDIFF(DAY, InvoiceDate, GETDATE()   ) >=30  
--and (InvoiceNo is not null) and TpGrandTotal>0



	
--Select TOP 1  InvoiceNo + '- Market Name: ' + tblInvoice.MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal) 
--as Details,  DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) 
 
--from tblInvoice with (nolock)
--INNER JOIN tblCustMaster C ON tblInvoice.CustomerMasterId=C.CustomerMasterId
--where C.CustomerCode=@CustCode and 
--DelivaryInvoiceNo is not null and (PaymentStatus is null or PaymentStatus='Partial') and 
-- DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) >=30 and tblInvoice.DeliveryTpGrandTotal>0 and PaymentStatus<>'Reject'


SELECT TOP 1 
    InvoiceNo + '- Market Name: ' + tblInvoice.MarketName + '- Amount: ' + CONVERT(varchar, TpGrandTotal) AS Details,  
    DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) AS DaysSinceUpdate
FROM tblInvoice WITH (NOLOCK)
--INNER JOIN tblCustMaster C ON tblInvoice.CustomerMasterId = C.CustomerMasterId
WHERE tblInvoice.CustomerMasterId =@CustID 
    AND DelivaryInvoiceNo IS NOT NULL 
    AND (PaymentStatus IS NULL OR PaymentStatus = 'Partial') 
    AND DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) >= 30 
    AND tblInvoice.DeliveryTpGrandTotal > 0 
    AND PaymentInvoiceStatus <> 'Reject'
ORDER BY DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) DESC;

  --and (InvoiceNo is not null) and TpGrandTotal>0


--  select * 
--  from tblInvoice with (nolock)
--INNER JOIN tblCustMaster C ON tblInvoice.CustomerMasterId=C.CustomerMasterId
--where C.CustomerCode='C4002875' and 
--DelivaryInvoiceNo is not null and (PaymentStatus is null or PaymentStatus='Partial') and 
-- DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) >=30 

	
--Select TOP 1  InvoiceNo + '- Market Name: ' + tblInvoice.MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal) 
--as Details,  DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) 
 
--from tblInvoice with (nolock)
--INNER JOIN tblCustMaster C ON tblInvoice.CustomerMasterId=C.CustomerMasterId
--left join tblCustPayDetail on 
--where C.CustomerCode=@CustCode and 
-- DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) >=30  and PaymentInvoiceStatus











--Select TOP 1  InvoiceNo + '- Market Name: ' + tblInvoice.MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal) 
--as Details,  DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) ,tblPay.custPaymentDate
 
--from tblInvoice with (nolock)
--INNER JOIN tblCustMaster C ON tblInvoice.CustomerMasterId=C.CustomerMasterId
--left join (select top 1 InvoiceId,custPaymentDate from tblCustPayDetail with (nolock) )tblPay on tblPay.InvoiceId = tblInvoice.InvoiceId

--where C.CustomerCode=@CustCode and InvoiceDate between '1-july-2021' and getdate() and 
--DelivaryInvoiceNo is not null  and DATEDIFF(DAY, tblInvoice.UpdateDate, tblPay.custPaymentDate   ) >=30  


--union all

--Select TOP 1  InvoiceNo + '- Market Name: ' + tblInvoice.MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal) 
--as Details,  DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) 
 
--from tblInvoice with (nolock)
--INNER JOIN tblCustMaster C with (nolock) ON tblInvoice.CustomerMasterId=C.CustomerMasterId
--inner join (select InvoiceId,sum(isnull(PaymentNetAmount,0))ConfirmAmount from tblInvoiceDetail with (nolock) group by InvoiceId)tbldts on tbldts.InvoiceId = tblInvoice.InvoiceId
--left join (select InvoiceId,sum(isnull(tblCustPayDetail.PaymentAmount,0))PaymentNetAmount from tblCustPayDetail with (nolock) group by InvoiceId)tblPay on tblPay.InvoiceId = tblInvoice.InvoiceId

--where C.CustomerCode=@CustCode


--and DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()   ) >=30  
--and RejectionSts is null and FinalPaymentNo is not null
--and tbldts.ConfirmAmount<>tblPay.PaymentNetAmount



    END