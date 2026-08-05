/*
============================================================================
 FIX SCRIPT: sp_Delete_ProformaInvoice
 Server: 192.168.10.193   DB: SalesDisDB_SMC_NEWDB
 Base: live procedure body extracted via OBJECT_DEFINITION() on 2026-07-25.
 Business logic (stock reversal, audit inserts, cascading deletes) is
 UNCHANGED. Only transaction-safety is added, marked "-- FIX #n".

 Current live version has NO transaction at all — every statement (stock
 reversal UPDATE, 3 audit INSERTs, tblOrderDetail/tblOrder UPDATE,
 tblReturnAmount/tblInvoice DELETE) is its own separate implicit
 transaction. If any statement in the middle fails, everything before it
 has already committed and everything after it never runs -> partial
 cleanup (e.g. stock reversed but invoice row never deleted).

 FIX #1  SET XACT_ABORT ON
 FIX #2  Whole body wrapped in one explicit transaction with TRY/CATCH so
         it is all-or-nothing.

 Back up the current definition before running:
   SELECT OBJECT_DEFINITION(OBJECT_ID('sp_Delete_ProformaInvoice'));
============================================================================
*/

CREATE PROCEDURE [dbo].[sp_Delete_ProformaInvoice]
	@InvoiceCode NVARCHAR(500),
	@User NVARCHAR(500)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;                                                    -- FIX #1

BEGIN TRY                                                             -- FIX #2
BEGIN TRANSACTION delProforma

IF EXISTS(SELECT * FROM dbo.tblInvoice WHERE InvoiceNo=@InvoiceCode and DelivaryInvoiceNo IS NULL)
BEGIN
	DECLARE @OrderIdForUpdate int

DECLARE @InvoiceId INT
DECLARE @InvoiceDetailId int
DECLARE @DCStoreId int
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
DECLARE @TotalPrice decimal(18,2)
DECLARE @TotalPriceVatAmount decimal(18,2)
DECLARE @DiscountPercentage decimal(18,2)
DECLARE @DiscountAmount decimal(18,2)
DECLARE @NetAmount decimal(18,2)
DECLARE @DeliveryQuantity decimal(18,0)
DECLARE @DeliveryBonusQuantity decimal(18,0)
DECLARE @DeliveryTotalQuantity decimal(18,0)
DECLARE @DeliveryTotalPrice decimal(18,2)
DECLARE @DeliveryTotalPriceVatAmount decimal(18,2)
DECLARE @DeliveryDiscountPercentage decimal(18,2)
DECLARE @DeliveryDiscountAmount decimal(18,2)
DECLARE @DeliveryNetAmount decimal(18,2)
DECLARE @DeliveryStatus nvarchar(50)
DECLARE @SpecialAmount decimal(18,2)
DECLARE @DelivarySpecialAmount decimal(18,2)
DECLARE @ReturnReason nvarchar(500)
---


--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR

SELECT I.InvoiceId,ID.InvoiceDetailId,ISNULL(ID.DCStoreId,0)DCStoreId,I.OrderId,ID.OrderDetailsId,ID.TotalQuantity,

ProductCode ,ProductName ,PackSize ,BatchNo ,ReceiveDate ,ExpDate ,CostPrice ,UnitPrice ,UnitVatAmount ,Quantity ,BonusQuantity ,TotalPrice ,TotalPriceVatAmount ,DiscountPercentage ,DiscountAmount ,
NetAmount ,DeliveryQuantity ,DeliveryBonusQuantity ,DeliveryTotalQuantity ,DeliveryTotalPrice ,DeliveryTotalPriceVatAmount ,DeliveryDiscountPercentage ,DeliveryDiscountAmount ,DeliveryNetAmount ,
DeliveryStatus ,SpecialAmount ,I.DelivarySpecialAmount ,ReturnReason


FROM dbo.tblInvoice I INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
WHERE I.DelivaryInvoiceNo IS NULL AND I.InvoiceNo=@InvoiceCode ORDER BY ID.InvoiceDetailId

OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceDetailId,@DCStoreId,@OrderId,@OrderDetailsId,@TotalQuantity,


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
				@DiscountAmount ,
				@NetAmount ,


				@DeliveryQuantity ,
				@DeliveryBonusQuantity ,
				@DeliveryTotalQuantity ,
				@DeliveryTotalPrice ,
				@DeliveryTotalPriceVatAmount ,
				@DeliveryDiscountPercentage ,
				@DeliveryDiscountAmount ,
				@DeliveryNetAmount ,
				@DeliveryStatus ,

				@SpecialAmount ,
				@DelivarySpecialAmount ,
				@ReturnReason
WHILE @@FETCH_STATUS = 0
BEGIN

SELECT @TempQuantity=StockQty FROM dbo.tblDCStore WHERE DCStoreId=@DCStoreId
SET @TempQuantity=@TempQuantity+@TotalQuantity
UPDATE tblDCStore SET StockQty=@TempQuantity  WHERE DCStoreId=@DCStoreId
---
insert into tblProInvoiceReturnTrack (ReturnTotalQuantity,DCStoreId,ReturnDate,ReturnExecutionDateTime,InvoiceDetailId,InvoiceId)
values (@TotalQuantity,@DCStoreId,convert(nvarchar(11),getdate(),106),getdate(),@InvoiceDetailId,@InvoiceId)

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
           ,[DCStoreId]
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
				@DCStoreId ,
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


DELETE FROM  tblInvoiceDetail WHERE InvoiceDetailId=@InvoiceDetailId

 SET @OrderIdForUpdate=@OrderId

FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceDetailId,@DCStoreId,@OrderId,@OrderDetailsId,@TotalQuantity,


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
				@DiscountAmount ,
				@NetAmount ,


				@DeliveryQuantity ,
				@DeliveryBonusQuantity ,
				@DeliveryTotalQuantity ,
				@DeliveryTotalPrice ,
				@DeliveryTotalPriceVatAmount ,
				@DeliveryDiscountPercentage ,
				@DeliveryDiscountAmount ,
				@DeliveryNetAmount ,
				@DeliveryStatus ,

				@SpecialAmount ,
				@DelivarySpecialAmount ,
				@ReturnReason
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

DECLARE @InvoiceIdForLog INT
 DECLARE @InvoiceNoForLog NVARCHAR(500)
 SELECT @InvoiceIdForLog=InvoiceId,@InvoiceNoForLog=InvoiceNo FROM tblInvoice WHERE  InvoiceNo=@InvoiceCode

UPDATE dbo.tblOrderDetail SET [Status]=NULL WHERE OrderId=@OrderIdForUpdate
UPDATE dbo.tblOrder SET IsInvoice=0 WHERE OrderId=@OrderIdForUpdate

declare @InvoMasId int=0
select @InvoMasId=InvoiceId from  dbo.tblInvoice WHERE InvoiceNo=@InvoiceCode


DELETE FROM dbo.tblReturnAmount WHERE InvoiceId=@InvoMasId


DELETE FROM dbo.tblInvoice WHERE InvoiceNo=@InvoiceCode



 INSERT INTO tblInvoiceDeleteLog (InvoiceId,InvoiceNo,DeleteDateTime,DeleteBy)
 VALUES (@InvoiceIdForLog,@InvoiceNoForLog,GETDATE(),@User)

	END

COMMIT TRANSACTION delProforma                                        -- FIX #2

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION delProforma;
    THROW;
END CATCH

END
