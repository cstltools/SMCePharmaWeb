-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateDeliveryamout]
	
AS
BEGIN
--DECLARE @ContractAmount decimal(18,2)
--DECLARE @SalesContractId NVARCHAR(500)
DECLARE @TerritoryCode NVARCHAR(500)
DECLARE @AreaCode NVARCHAR(500)
DECLARE @ZoneCode NVARCHAR(500)
DECLARE @MarketName NVARCHAR(500)
DECLARE @OrderNO NVARCHAR(500)

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
select D.NetAmount,D.DeliveryNetAmount,D.InvoiceDetailId
--,(D.NetAmount-D.DeliveryNetAmount)
 from tblInvoice I
inner join tblInvoiceDetail  D on I.InvoiceId=D.InvoiceId
 where  D.NetAmount<>D.DeliveryNetAmount
 and I.InvoiceDate=convert(date, getdate()) 
 
  and D.DeliveryStatus='Full'


----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@TerritoryCode,@AreaCode,@OrderNO
WHILE @@FETCH_STATUS = 0
BEGIN

update tblInvoiceDetail SET  DeliveryNetAmount=@TerritoryCode    where InvoiceDetailId=@OrderNO 

--update ExcelUploadCustomer SET  MarketID=@AreaCode    where MarketCode=@TerritoryCode AND NewMarketTagg=1

FETCH NEXT FROM @MyCursor
INTO 
@TerritoryCode,@AreaCode,@OrderNO
END
CLOSE @MyCursor
DEALLOCATE @MyCursor









END
