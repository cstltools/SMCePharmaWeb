CREATE PROCEDURE [dbo].[sp_Get_OrderNoforReturn]
	-- Add the parameters for the stored procedure here
  @id INT

AS
    BEGIN

	  select distinct Inv.InvoiceId ,Inv.InvoiceNo   OrderNo

from tblInvoice Inv with (nolock)
  
   
    
where Inv.ComUnitId=@id and  PaymentInvoiceNo is not null and  FinalPaymentNo is   null          AND convert(date, Inv.InvoiceDate) >= convert(date,DATEADD(MONTH, -1, GETDATE()));
END