-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateDiscountForInstrituteBusiness] --exec sp_UpdateDiscountForInstrituteBusiness

AS
BEGIN
DECLARE @CustomerCode intDECLARE @TerritoryCode decimal(18,3)DECLARE @Quantity int--------------------------------------------------------DECLARE @MyCursor CURSORSET @MyCursor = CURSOR FAST_FORWARDFOR---------------select OrderDetailId,(DiscountAmount/Quantity) DiscountAmount,Quantity from tblOrderDetail

inner join tblOrder on tblOrderDetail.OrderId=tblOrder.OrderId
where tblOrderDetail.IsSpDis=1 
--and SubmissionDate between '25-may-2021' and GETDATE()
--last update 24 may 2021  select GETDATE()----------OPEN @MyCursorFETCH NEXT FROM @MyCursorINTO @CustomerCode,@TerritoryCode,@QuantityWHILE @@FETCH_STATUS = 0BEGINDECLARE @Qty int = 0DECLARE @InvDe int = 0DECLARE @MyCursor2 CURSORSET @MyCursor2 = CURSOR FAST_FORWARDFOR--select Quantity,InvoiceDetailId   from tblInvoiceDetail where OrderDetailsId=@CustomerCodeselect DeliveryQuantity,InvoiceDetailId   from tblInvoiceDetail where OrderDetailsId=@CustomerCodeOPEN @MyCursor2FETCH NEXT FROM @MyCursor2INTO @Qty,@InvDeWHILE @@FETCH_STATUS = 0BEGINupdate tblInvoiceDetail set DeliveryDiscountAmount=@TerritoryCode*@Qty--update tblInvoiceDetail set DiscountAmount=@TerritoryCode*@Qtywhere OrderDetailsId=@CustomerCode and InvoiceDetailId= @InvDeFETCH NEXT FROM @MyCursor2INTO @Qty,@InvDeENDCLOSE @MyCursor2DEALLOCATE @MyCursor2FETCH NEXT FROM @MyCursorINTO @CustomerCode,@TerritoryCode,@QuantityENDCLOSE @MyCursorDEALLOCATE @MyCursor--select Quantity   from tblInvoiceDetail where OrderDetailsId=@CustomerCode--SELECT DISTINCT TerritoryCode
--FROM  tblsmc2019CustomerUpdate
--WHERE TerritoryCode NOT IN (SELECT AreaCode FROM tblArea)

END
