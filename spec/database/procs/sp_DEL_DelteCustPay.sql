 

 CREATE PROCEDURE [dbo].[sp_DEL_DelteCustPay]
	-- Add the parameters for the stored procedure here
	@InvoiceNo NVARCHAR(MAX)

AS
BEGIN
 declare @OrdID int
   select @OrdID= InvoiceId  from tblInvoice where InvoiceNo=@InvoiceNo
   print @OrdID
 --for Final Payment Retun
   update tblInvoice set    FinalPaymentNo=null, PaymentStatus =null,  FinalPaymentBy=null, FinalPaymentDate=null where  InvoiceId=@OrdID
   
 
 INSERT INTO [dbo].[tblCustPayDetailDeleteLog]
           ([CustPayDetailId]
           ,[InvoiceId]
           ,[PaymentAmount]
           ,[CustPayId]
           ,[RetrunPayBy]
           ,[ReturnPayDate])
     select [CustPayDetailId],[InvoiceId],[PaymentAmount]
      ,[CustPayId] ,'shuvo', GETDATE()   from tblCustPayDetail where InvoiceId=@OrdID



delete from tblCustomerPay where  CustPayId in (select  CustPayId from tblCustPayDetail where InvoiceId=@OrdID
)
delete from tblCustPayDetail where  InvoiceId=@OrdID
end