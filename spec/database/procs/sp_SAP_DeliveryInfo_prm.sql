CREATE PROCEDURE [dbo].[sp_SAP_DeliveryInfo_prm]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN





Select   
   v.InviceNo InvoiceNo,    v.OrderNo,   v.Line,   v.ProductCode, v.Quantity, FORMAT(DeliveryDate,'dd.MM.yyyy')    DeliveryDate,  v.[Action]

from SAP_tblSales_PGI v  with (nolock)

 where  ( convert(Date, v.DeliveryDate ) between convert(Date, @FrmDate )  and convert(Date, @ToDate )  ) 
 


















--Select   
-- CAST(  InvoiceNo AS varchar) as InvoiceNo,  CAST(  OrderCode AS varchar) as OrderNo,  CAST(  d.InvoiceDetailId  AS varchar)Line, CAST(pro.SAP_Code  AS varchar) ProductCode,  CAST(d.DeliveryQuantity  AS varchar) Quantity,FORMAT(I.UpdateDate,'dd.MM.yyyy') DeliveryDate, 
 
 
--case when d.DeliveryQuantity=0 then 'RET' else 'PGI' end [Action]

--from tblOrder O with (nolock)

--left join tblInvoice I  with (nolock) on I.OrderId=O.OrderId 
--inner join tblInvoiceDetail d  with (nolock) on I.InvoiceId=d.InvoiceId 
--inner join tblProduct pro  with (nolock) on pro.ProductCode=d.ProductCode 

-- where  ( I.UpdateDate between convert(varchar, @FrmDate, 104)  and convert(varchar, @ToDate, 104) ) and  (DelivaryInvoiceNo is not null) 

--order by d.InvoiceDetailId asc

END
 

