create PROCEDURE [dbo].[sp_Get_RouteInfoforBacktoReturn]
	-- Add the parameters for the stored procedure here
  @id INT

AS
    BEGIN

	  select distinct ord.DistributionRouteId ,Rote.RouteName DistributionRouteName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
    
where       PaymentInvoiceNo is not null and  FinalPaymentNo is   null     and Inv.ComUnitId=@id 
 END