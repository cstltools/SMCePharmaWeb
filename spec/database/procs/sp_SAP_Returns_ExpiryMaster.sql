CREATE PROCEDURE [dbo].[sp_SAP_Returns_ExpiryMaster]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
select   iv.InvoiceId MasterId,  
isnull(O.MIOCode,'Blank')                        as MIOCode,	
O.TerritoryCode                                as Territory,
FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt 
 
 from tblInvoice  iv with(nolock)
 
 inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
 where iv.InvoiceDate between @FrmDate and @ToDate
  
END
 




