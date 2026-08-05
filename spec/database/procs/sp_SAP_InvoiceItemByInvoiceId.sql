CREATE PROCEDURE [dbo].[sp_SAP_InvoiceItemByInvoiceId]
   @InvoiceId nvarchar(max) 

AS
BEGIN


select  Line InvoiceDetailId,   Line,  Plant,  ProductCode,  
 Quantity,   UOM ,   StorageLoc,  UnitPrice,  Inco1,   Inco2,   OrderReason,  DiscountAmount,  FOCFlag,  Outlet, 
 
 
  Action
  from SAP_tblSales_Order dtl   with (nolock) 

  where  dtl.InvoiceId=@InvoiceId


--select InvoiceDetailId, InvoiceDetailId Line,'1003' Plant, pro.SAP_Code ProductCode,  CAST(isnull(dtl.DeliveryQuantity,dtl.Quantity) AS varchar) 
-- Quantity, case when pro.ProductGroupId=1 then 'PAK' else 'EA' end UOM , 'FG01' StorageLoc,OD.TradePrice UnitPrice, 'SAP' Inco1, 'SAP' Inco2, 'SAP' OrderReason, isnull(dtl.DiscountAmount,dtl.DeliveryDiscountAmount) DiscountAmount, case when pro.ProductGroupId=1 and OD.TradePrice=0 then  'M'   
-- when pro.ProductGroupId=3 and OD.TradePrice=0 then 'G' Else ' ' end FOCFlag, OrD.CustomerCode as Outlet, 
 
 
-- ' ' Action
--  from tblInvoiceDetail dtl   with (nolock) 

--inner join tblProduct pro   with (nolock)  on pro.ProductCode=dtl.ProductCode 
--left join tblOrderDetail OD   with (nolock)  on OD.OrderDetailId=dtl.OrderDetailsId 
--left join tblOrder OrD   with (nolock)  on OD.OrderId=OrD.OrderId 

-- where  dtl.InvoiceId=@InvoiceId

end