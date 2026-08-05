-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteInvoice]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

  select InvoiceNo,TpGrandTotal,NetAmount,InvoiceNo,invoicedate from (select TpGrandTotal,sum(tblInvoiceDetail.NetAmount)NetAmount,InvoiceNo,invoicedate from tblInvoice
inner join tblInvoiceDetail on tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId group by TpGrandTotal,InvoiceNo,invoicedate)tblx
where (TpGrandTotal-NetAmount)>1 and invoicedate>'4-aug-2022'  

 union all

select InvoiceNo,TpGrandTotal,NetAmount,InvoiceNo,invoicedate from (select IsAdjustInvoice,invoicedate,TpGrandTotal,sum(tblInvoiceDetail.NetAmount)NetAmount,InvoiceNo from tblInvoice
inner join tblInvoiceDetail on tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId group by IsAdjustInvoice,TpGrandTotal,InvoiceNo,invoicedate)tblx
where (TpGrandTotal-NetAmount)<-1 and invoicedate>'1-Nov-2022' order by invoicedate desc

 
END
