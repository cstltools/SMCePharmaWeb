CREATE PROCEDURE [dbo].[sp_SAP_SalesMaster]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN


select   isnull(O.MIOCode,'Blank') MasterId,  
isnull(O.MIOCode,'Blank')                        as MIOCode,	
O.TerritoryCode                                as Territory,
FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt ,
 'ZSPH' as OrderType

 --from tblInvoice  iv with(nolock)
 
 --inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
 --where iv.InvoiceDate between @FrmDate and @ToDate
  from tblInvoice  iv with(nolock)
 --inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
 --inner join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
 --inner join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
 inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
 inner join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
 where iv.UpdateDate between 
 --'1-1-2023' and '1-1-2023'
 @FrmDate and @ToDate
 --iv.InvoiceId=@MasterId

Group by O.MIOCode ,	O.TerritoryCode ,FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	,  U.ComUnitCode     

order by FORMAT(iv.InvoiceDate,'dd.MM.yyyy') ,isnull(O.MIOCode,'Blank')   


--select   iv.InvoiceId MasterId,  
--isnull(O.MIOCode,'Blank')                        as MIOCode,	
--O.TerritoryCode                                as Territory,
--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt 
 
-- from tblInvoice  iv with(nolock)
 
-- inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
-- where iv.InvoiceDate between @FrmDate and @ToDate
  
END
 




