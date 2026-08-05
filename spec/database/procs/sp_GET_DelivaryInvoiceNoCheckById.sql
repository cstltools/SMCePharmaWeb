
 CREATE PROCEDURE [dbo].[sp_GET_DelivaryInvoiceNoCheckById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max),
   @InvStatus NVARCHAR(max)

AS
    BEGIN

	if(@InvStatus='DelivaryInvoiceNo')
	 begin
	 select isnull(DelivaryInvoiceNo,'') DelivaryInvoiceNo  from tblInvoice where InvoiceId=@id and  isnull(DelivaryInvoiceNo,'') <>''
	 end


	 	if(@InvStatus='PaymentInvoiceNo')
	 begin
	 select isnull(PaymentInvoiceNo,'') PaymentInvoiceNo  from tblInvoice where InvoiceId=@id and  isnull(PaymentInvoiceNo,'') <>''
	 end

	 	if(@InvStatus='SndReturnInvoiceNo')
	 begin
	 select isnull(SndReturnInvoiceNo,'') SndReturnInvoiceNo  from tblInvoice where InvoiceId=@id and  isnull(SndReturnInvoiceNo,'') <>''
	 end

    END

	 