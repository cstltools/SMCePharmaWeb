create PROCEDURE [dbo].[sp_GetWarningForCustomerPayment] 
	-- Add the parameters for the stored procedure here
   
      @CustID nvarchar(max),
      @CustCode nvarchar(max)

AS
    BEGIN
	
	

Select TOP 1  InvoiceNo + '- Market Name: ' + MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal)  as Details,  DATEDIFF(DAY, UpdateDate, GETDATE()   ),* from tblInvoice with (nolock)
            where CustomerMasterId=@CustID and  	InvoiceDate between '1-july-2021' and getdate() and   DelivaryInvoiceNo is null  and DATEDIFF(DAY, InvoiceDate, GETDATE()   ) >=30  and (InvoiceNo is not null)




    END