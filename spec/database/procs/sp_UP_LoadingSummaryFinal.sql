create PROCEDURE [dbo].[sp_UP_LoadingSummaryFinal] ---- sp_DeliveryConformationFull 'INV-BD32-00001394','Test','29-Oct-2018'
	@InvoiceId NVARCHAR(250),
	@UpdateBy NVARCHAR(250),
	@LoadingSummaryStatus NVARCHAR(250)  
AS
BEGIN
	

	 

  UPDATE tblInvoice SET loadingsummaryFinalStatus=@LoadingSummaryStatus,loadingsummaryFinalStatusUpdateBy=@UpdateBy,loadingsummaryFinalStatusUpdateDatetime=GETDATE() WHERE InvoiceNo=@InvoiceId
	 


END