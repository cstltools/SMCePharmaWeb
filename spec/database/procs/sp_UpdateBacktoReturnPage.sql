
CREATE PROCEDURE [dbo].[sp_UpdateBacktoReturnPage]
	@OrdID INT,
	@LoginName NVARCHAR(MAX)
AS
BEGIN
declare @CheckInvCount int =0
  select  @CheckInvCount=ISNULL(count(*),0) from tblInvoice where InvoiceId=@OrdID

  print @CheckInvCount

  if(@CheckInvCount>0)
  begin 


  --for Final Payment Retun
   --update tblInvoice set  PaymentInvoiceNo=null,   PaymentAmount=null, FinalPaymentNo=null, PaymentStatus =null,  FinalPaymentBy=null, FinalPaymentDate=getdate() where  InvoiceId=@OrdID
   
 
-- INSERT INTO [dbo].[tblCustPayDetailDeleteLog]
--           ([CustPayDetailId]
--           ,[InvoiceId]
--           ,[PaymentAmount]
--           ,[CustPayId]
--           ,[RetrunPayBy]
--           ,[ReturnPayDate])
--     select [CustPayDetailId],[InvoiceId],[PaymentAmount]
--      ,[CustPayId] ,@LoginName, GETDATE()   from tblCustPayDetail where InvoiceId=@OrdID



--delete from tblCustomerPay where  CustPayId in (select  CustPayId from tblCustPayDetail where InvoiceId=@OrdID
--)
--delete from tblCustPayDetail where  InvoiceId=@OrdID

update tblInvoice set  PaymentInvoiceNo=null,    PaymentDate=null where  InvoiceId=@OrdID
   


END
END