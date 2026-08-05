-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdatenullInvoiceStatus]
	
AS
BEGIN
update tblInvoiceDetail set DeliveryStatus='Full' 
 where DeliveryStatus =' '
and DeliveryQuantity =Quantity

END
