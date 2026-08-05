

 CREATE PROCEDURE [dbo].[sp_GET_checkTodaysAlreadyInviceGenerateByCustId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN
	 SET NOCOUNT ON;
	select top 1 (InvoiceId) InvoiceId from tblInvoice with (nolock) where convert(date,invoicedate)=convert(date,getdate()) and customerMasterID=@id
 



      
    END


