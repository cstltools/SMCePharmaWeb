CREATE PROCEDURE [dbo].[sp_SAP_SalesReturnMaster] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

select   top 2 isnull(O.MIOCode,'Blank') MasterId,  
isnull(mio.SAP_MIOCode,'Blank')                        as MIOCode,	
tr.SAP_Code                                as Territory,
FORMAT(iv.updateDate,'dd.MM.yyyy') 	       as InvoiceDt 
--,O.OrderType OrderType 
,'ZRET' OrderType


  from tblInvoice  iv with(nolock)
 inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
 inner join tblMioInfo mio with(nolock) on O.MioId=  mio.MioId
 inner join tblTerritory tr  with(nolock)  on  tr.TerritoryId=O.TerritoryId
 --inner join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
 where   iv.DeliveryInvoiceStatus in ('Partial','Full') and iv.DelivaryInvoiceNo is not null and  iv.updateDate between 
 @FrmDate and @ToDate and mio.SAP_MIOCode is not null and tr.SAP_Code is not null
Group by mio.SAP_MIOCode, O.MIOCode ,	tr.SAP_Code ,FORMAT(iv.updateDate,'dd.MM.yyyy')  
order by FORMAT(iv.updateDate,'dd.MM.yyyy') ,isnull(O.MIOCode,'Blank')   



END



























 




