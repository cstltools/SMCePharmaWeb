-- =============================================
-- Author:		Author,,Name>
-- Create date: Create Date,
-- Description:	Description,
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_ProformaInvoice_SubDeport] 
	@InvoiceCode NVARCHAR(500),
	@User NVARCHAR(500)
AS
BEGIN

IF EXISTS(SELECT * FROM dbo.tblSubInvoiceMaster WHERE InvoiceNo=@InvoiceCode)
BEGIN
	DECLARE @OrderIdForUpdate int

DECLARE @InvoiceId INT
DECLARE @InvoiceDetailId int
DECLARE @SubDCStoreId int
DECLARE @OrderId int
DECLARE @OrderDetailsId int
DECLARE @TotalQuantity DECIMAL(18,0)=0
DECLARE @TempQuantity DECIMAL(18,0)=0
---
DECLARE @ProductCode nvarchar(max)
DECLARE @ProductName nvarchar(max)
DECLARE @PackSize nvarchar(max)
DECLARE @BatchNo nvarchar(max)
DECLARE @ReceiveDate datetime
DECLARE @ExpDate datetime
DECLARE @CostPrice decimal(18,2)
DECLARE @UnitPrice decimal(18,2)
DECLARE @UnitVatAmount decimal(18,2)
DECLARE @Quantity decimal(18,0)
DECLARE @BonusQuantity decimal(18,0)
--DECLARE @TotalQuantity decimal(18,0)
DECLARE @TotalPrice decimal(18,2)
DECLARE @TotalPriceVatAmount decimal(18,2)
DECLARE @DiscountPercentage decimal(18,2)
DECLARE @DiscountAmount decimal(18,2)
DECLARE @NetAmount decimal(18,2)
--DECLARE @InvoiceId int
--DECLARE @SubDCStoreId int
DECLARE @DeliveryQuantity decimal(18,0)
DECLARE @DeliveryBonusQuantity decimal(18,0)
DECLARE @DeliveryTotalQuantity decimal(18,0)
DECLARE @DeliveryTotalPrice decimal(18,2)
DECLARE @DeliveryTotalPriceVatAmount decimal(18,2)
DECLARE @DeliveryDiscountPercentage decimal(18,2)
DECLARE @DeliveryDiscountAmount decimal(18,2)
DECLARE @DeliveryNetAmount decimal(18,2)
DECLARE @DeliveryStatus nvarchar(50)
--DECLARE @OrderDetailsId int
DECLARE @SpecialAmount decimal(18,2)
DECLARE @DelivarySpecialAmount decimal(18,2)
DECLARE @ReturnReason nvarchar(500)
---


--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR

SELECT I.InvoiceId,ID.InvoiceDetailId,ISNULL(ID.SubDCStoreId,0)SubDCStoreId,I.OrderId,ID.OrderDetailsId,ID.TotalQuantity,

ProductCode ,ProductName ,PackSize ,BatchNo ,ReceiveDate ,ExpDate ,CostPrice ,UnitPrice ,UnitVatAmount ,Quantity ,BonusQuantity ,TotalPrice ,TotalPriceVatAmount ,DiscountPercentage ,DiscountAmount ,
NetAmount ,DeliveryQuantity ,DeliveryBonusQuantity ,DeliveryTotalQuantity ,DeliveryTotalPrice ,DeliveryTotalPriceVatAmount ,DeliveryDiscountPercentage ,DeliveryDiscountAmount ,DeliveryNetAmount ,
DeliveryStatus ,SpecialAmount ,I.DelivarySpecialAmount ,ReturnReason 


FROM dbo.tblSubInvoiceMaster I INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
WHERE I.DelivaryInvoiceNo IS NULL AND I.InvoiceNo=@InvoiceCode ORDER BY ID.InvoiceDetailId

OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceDetailId,@SubDCStoreId,@OrderId,@OrderDetailsId,@TotalQuantity,


@ProductCode ,
				@ProductName ,
				@PackSize ,
				@BatchNo ,
				@ReceiveDate ,
				@ExpDate ,
				@CostPrice ,
				@UnitPrice ,
				@UnitVatAmount ,
				@Quantity ,
				@BonusQuantity ,
				
				@TotalPrice ,
				@TotalPriceVatAmount ,
				@DiscountPercentage ,
				@DiscountAmount ,----------
				@NetAmount ,
				
				
				@DeliveryQuantity ,
				@DeliveryBonusQuantity ,
				@DeliveryTotalQuantity ,
				@DeliveryTotalPrice ,
				@DeliveryTotalPriceVatAmount ,
				@DeliveryDiscountPercentage ,
				@DeliveryDiscountAmount ,
				@DeliveryNetAmount ,-----
				@DeliveryStatus ,
				
				@SpecialAmount ,
				@DelivarySpecialAmount ,
				@ReturnReason 
WHILE @@FETCH_STATUS = 0
BEGIN

SELECT @TempQuantity=StockQty FROM dbo.tblSubDepotStore WHERE SubDCStoreId=@SubDCStoreId
SET @TempQuantity=@TempQuantity+@TotalQuantity
UPDATE tblSubDepotStore SET StockQty=@TempQuantity  WHERE SubDCStoreId=@SubDCStoreId
---
insert into tblProInvoiceReturnTrack (ReturnTotalQuantity,SubDCStoreId,ReturnDate,ReturnExecutionDateTime,InvoiceDetailId,InvoiceId)
values (@TotalQuantity,@SubDCStoreId,convert(nvarchar(11),getdate(),106),getdate(),@InvoiceDetailId,@InvoiceId)

 INSERT INTO [dbo].[tblInvoiceDetail_DeleterRecord]
           ([InvoiceDetailId]
           ,[ProductCode]
           ,[ProductName]
           ,[PackSize]
           ,[BatchNo]
           ,[ReceiveDate]
           ,[ExpDate]
           ,[CostPrice]
           ,[UnitPrice]
           ,[UnitVatAmount]
           ,[Quantity]
           ,[BonusQuantity]
           ,[TotalQuantity]
           ,[TotalPrice]
           ,[TotalPriceVatAmount]
           ,[DiscountPercentage]
           ,[DiscountAmount]
           ,[NetAmount]
           ,[InvoiceId]
           ,[SubDCStoreId]
           ,[DeliveryQuantity]
           ,[DeliveryBonusQuantity]
           ,[DeliveryTotalQuantity]
           ,[DeliveryTotalPrice]
           ,[DeliveryTotalPriceVatAmount]
           ,[DeliveryDiscountPercentage]
           ,[DeliveryDiscountAmount]
           ,[DeliveryNetAmount]
           ,[DeliveryStatus]
           ,[OrderDetailsId]
           ,[SpecialAmount]
           ,[DelivarySpecialAmount]
           ,[ReturnReason])
     VALUES
           (    @InvoiceDetailId,
				@ProductCode ,
				@ProductName ,
				@PackSize ,
				@BatchNo ,
				@ReceiveDate ,
				@ExpDate ,
				@CostPrice ,
				@UnitPrice ,
				@UnitVatAmount ,
				@Quantity ,
				@BonusQuantity ,
				@TotalQuantity ,
				@TotalPrice ,
				@TotalPriceVatAmount ,
				@DiscountPercentage ,
				@DiscountAmount ,
				@NetAmount ,
				@InvoiceId ,
				@SubDCStoreId ,
				@DeliveryQuantity ,
				@DeliveryBonusQuantity ,
				@DeliveryTotalQuantity ,
				@DeliveryTotalPrice ,
				@DeliveryTotalPriceVatAmount ,
				@DeliveryDiscountPercentage ,
				@DeliveryDiscountAmount ,
				@DeliveryNetAmount ,
				@DeliveryStatus ,
				@OrderDetailsId ,
				@SpecialAmount ,
				@DelivarySpecialAmount ,
				@ReturnReason 
		   )
 

DELETE FROM  tblSubInvoiceDetail WHERE InvoiceDetailId=@InvoiceDetailId
 
 SET @OrderIdForUpdate=@OrderId
 
FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceDetailId,@SubDCStoreId,@OrderId,@OrderDetailsId,@TotalQuantity,


@ProductCode ,
				@ProductName ,
				@PackSize ,
				@BatchNo ,
				@ReceiveDate ,
				@ExpDate ,
				@CostPrice ,
				@UnitPrice ,
				@UnitVatAmount ,
				@Quantity ,
				@BonusQuantity ,
				
				@TotalPrice ,
				@TotalPriceVatAmount ,
				@DiscountPercentage ,
				@DiscountAmount ,----------
				@NetAmount ,
				
				
				@DeliveryQuantity ,
				@DeliveryBonusQuantity ,
				@DeliveryTotalQuantity ,
				@DeliveryTotalPrice ,
				@DeliveryTotalPriceVatAmount ,
				@DeliveryDiscountPercentage ,
				@DeliveryDiscountAmount ,
				@DeliveryNetAmount ,-----
				@DeliveryStatus ,
				
				@SpecialAmount ,
				@DelivarySpecialAmount ,
				@ReturnReason 
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

DECLARE @InvoiceIdForLog INT
 DECLARE @InvoiceNoForLog NVARCHAR(500)
 SELECT @InvoiceIdForLog=InvoiceId,@InvoiceNoForLog=InvoiceNo FROM tblSubInvoiceMaster WHERE  InvoiceNo=@InvoiceCode

UPDATE dbo.tblOrderDetail SET [Status]=NULL WHERE OrderId=@OrderIdForUpdate
UPDATE dbo.tblOrder SET IsInvoice=0 WHERE OrderId=@OrderIdForUpdate 
DELETE FROM dbo.tblSubInvoiceMaster WHERE InvoiceNo=@InvoiceCode



 INSERT INTO tblInvoiceDeleteLog (InvoiceId,InvoiceNo,DeleteDateTime,DeleteBy)
 VALUES (@InvoiceIdForLog,@InvoiceNoForLog,GETDATE(),@User)

	
	END
	
END
