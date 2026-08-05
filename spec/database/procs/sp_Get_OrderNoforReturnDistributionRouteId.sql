CREATE PROCEDURE [dbo].[sp_Get_OrderNoforReturnDistributionRouteId]
	-- Add the parameters for the stored procedure here
  @ComId INT,
  @rootId INT


AS
    BEGIN

	  select distinct Inv.InvoiceId ,Inv.InvoiceNo   OrderNo

from tblInvoice Inv with (nolock)
inner join tblOrder ord with (nolock) on Inv.OrderId=ord.OrderId
inner join ( select InvoiceId, ISNULL(SUM(vv.DeliveryQuantity),0) DeliveryQuantity,  ISNULL(SUM(vv.PaymentQuantity),0) PaymentQuantity   from  tblInvoiceDetail vv  (nolock) where isnull(vv.PaymentStatus,'')<>'Full' group by InvoiceId) InvD   on Inv.InvoiceId=InvD.InvoiceId
  
   
    
where Inv.ComUnitId=@ComId and  
--PaymentInvoiceNo is not null 
DelivaryInvoiceNo is not null 
--and  FinalPaymentNo is   null 
and DeliveryQuantity= PaymentQuantity   and ord.DistributionRouteId=@rootId
END