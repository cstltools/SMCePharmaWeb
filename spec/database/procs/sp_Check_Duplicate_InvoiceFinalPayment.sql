create PROCEDURE [dbo].[sp_Check_Duplicate_InvoiceFinalPayment]
	-- Add the parameters for the stored procedure here
   @InvoiceId INT = 0 ,
   
    @PaymentAmount decimal(18,2)  
	
AS
BEGIN


 
SELECT * FROM dbo.tblCustPayDetail WHERE InvoiceId=@InvoiceId AND CONVERT(DATE,custPaymentDate)=CONVERT(DATE,getdate()) and  ISNULL(PaymentAmount,0)=ISNULL(@PaymentAmount,0)
 END