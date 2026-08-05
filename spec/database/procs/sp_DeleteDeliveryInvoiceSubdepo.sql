-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteDeliveryInvoiceSubdepo]
	@DelivaryInvoiceNo nvarchar(500),
	@User NVARCHAR(500)

AS
BEGIN



IF EXISTS(SELECT * FROM dbo.tblSubInvoiceMaster WHERE DelivaryInvoiceNo=@DelivaryInvoiceNo)	
BEGIN
	DECLARE @OrderIdForUpdate int

DECLARE @InvoiceId INT
DECLARE @InvoiceDetailId int
DECLARE @SubDCStoreId int
DECLARE @OrderId int
DECLARE @OrderDetailsId int

DECLARE @TotalQuantity DECIMAL(18,0)=0
DECLARE @DeliveryTotalQuantity DECIMAL(18,0)=0

DECLARE @TempQuantity DECIMAL(18,0)=0

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR

SELECT I.InvoiceId,ID.InvoiceDetailId,ISNULL(ID.SubDCStoreId,0)SubDCStoreId,I.OrderId,ID.OrderDetailsId,ID.TotalQuantity,ISNULL(ID.DeliveryTotalQuantity,0)DeliveryTotalQuantity FROM dbo.tblSubInvoiceMaster I INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
WHERE  I.DelivaryInvoiceNo=@DelivaryInvoiceNo  ORDER BY ID.InvoiceDetailId

OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceDetailId,@SubDCStoreId,@OrderId,@OrderDetailsId,@TotalQuantity,@DeliveryTotalQuantity
WHILE @@FETCH_STATUS = 0
BEGIN

SELECT @TempQuantity=StockQty FROM dbo.tblSubDepotStore WHERE SubDCStoreId=@SubDCStoreId
SET @TempQuantity=@TempQuantity-(@TotalQuantity-@DeliveryTotalQuantity)
UPDATE tblSubDepotStore SET StockQty=@TempQuantity  WHERE SubDCStoreId=@SubDCStoreId
 delete tblSubDepotStoreFreeze where InvoiceDetailId=@InvoiceDetailId


 

 
FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceDetailId,@SubDCStoreId,@OrderId,@OrderDetailsId,@TotalQuantity,@DeliveryTotalQuantity
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

UPDATE dbo.tblSubInvoiceDetail SET 

       DeliveryQuantity =NULL,
       DeliveryBonusQuantity =NULL,
       DeliveryTotalQuantity =NULL,
       DeliveryTotalPrice =NULL,
       DeliveryTotalPriceVatAmount =NULL,
       DeliveryDiscountPercentage =NULL,
       DeliveryDiscountAmount =NULL,
       DeliveryNetAmount =NULL,
       DeliveryStatus =NULL,
       
       
       DelivarySpecialAmount =NULL,
       ReturnReason =NULL WHERE InvoiceId=(SELECT InvoiceId FROM tblSubInvoiceMaster WHERE  DelivaryInvoiceNo=@DelivaryInvoiceNo)
 
 
 update tblSubInvoiceMaster set DelivaryInvoiceNo=NULL , DeliveryInvoiceStatus=NULL WHERE  DelivaryInvoiceNo=@DelivaryInvoiceNo

 DECLARE @InvoiceIdForLog INT
 DECLARE @InvoiceNoForLog NVARCHAR(500)
 SELECT @InvoiceIdForLog=InvoiceId,@InvoiceNoForLog=InvoiceNo FROM tblSubInvoiceMaster WHERE  DelivaryInvoiceNo=@DelivaryInvoiceNo

 INSERT INTO tblInvoiceDeleteLog (InvoiceId,InvoiceNo,DelInvoiceNo,DeliveryDeleteDateTime,DeliveryDeleteBy)
 VALUES (@InvoiceIdForLog,@InvoiceNoForLog,@DelivaryInvoiceNo,GETDATE(),@User)
 
END

END
