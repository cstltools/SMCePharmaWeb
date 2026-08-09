/*
============================================================================
 FIX SCRIPT: sp_Process_ProformaInvoiceByOrderId
 Server: 192.168.10.193   DB: SalesDisDB_SMC_NEWDB
 Base: live procedure body extracted via OBJECT_DEFINITION() on 2026-07-25.
 Business logic (FEFO batch split, invoice/detail insert, column lists) is
 UNCHANGED. Only concurrency/transaction-safety fixes are added, each
 marked with "-- FIX #n" so the diff against the current live SP is easy
 to review before deploying.

 FIX #1  SET XACT_ABORT ON  -> guarantees an automatic ROLLBACK on any
         unhandled runtime error instead of silently continuing / partially
         committing (see audit report section 5).
 FIX #2  BEGIN TRY / CATCH wrapped around the whole transaction body ->
         any error now hits ROLLBACK + THROW instead of leaving the
         transaction in an undefined state.
 FIX #3  Locked re-entrancy check on tblOrder.IsInvoice right after the
         transaction starts -> prevents two near-simultaneous calls for the
         SAME OrderId from both passing and double-invoicing / double-
         deducting stock (see audit report section 4).
 FIX #4  WITH (UPDLOCK, ROWLOCK) added to the batch-picking SELECT TOP 1
         on tblDCStore -> the row is locked for the remainder of the
         transaction from the moment it's read, so a concurrent session
         can no longer read the same "before decrement" StockQty and make
         the same allocation decision (root cause of possible negative /
         over-deducted stock, see audit report section 4 & 6).

 ---- Applied 2026-08-08 (stock-validation fix, backup at
 ---- spec/database/procs/_backups/sp_Process_ProformaInvoiceByOrderId_backup_20260808_pre_stockfix.sql):

 FIX #5  In the per-line FEFO allocation loop, the branch reached when no
         batch remains with StockQty<>0 for the product (i.e. requested
         qty exceeds available stock) now sets @ErrorStat=1 before
         breaking out of the loop. Previously it only did SET @MainQty=0;
         BREAK, so running out of stock mid-allocation left @ErrorStat=0
         and the transaction still COMMITted a partial/under-fulfilled
         invoice instead of rolling back.
 FIX #6  The order-level stock pre-check (@NegativeQtyCount) now compares
         ISNULL(tblt.Qty,0)-tblt.OrdQty<0 instead of tblt.Qty-tblt.OrdQty<0.
         tblt.Qty comes from a LEFT JOIN to tblDCStore, so a product with
         NO stock row at all for that ComUnitId produced NULL, and
         NULL-OrdQty<0 evaluates to UNKNOWN (excluded by WHERE) rather
         than TRUE - silently skipping the insufficient-stock count for
         products the depot has never stocked. ISNULL(...,0) makes "no
         stock row" correctly compare as zero available stock.

 ---- Applied 2026-08-08 (return-value follow-up):

 FIX #7  New @Success BIT OUTPUT parameter, defaulted to 0 (fail-closed)
         and set to 1 only on the actual COMMIT path, so the caller can
         finally distinguish "invoice created" from "silently did
         nothing" instead of always getting an unusable rows-affected
         count back (RunStoreProcedure returns rows-affected, not the
         SP's RETURN value, so a bare RETURN code was never going to be
         readable by the caller - an OUTPUT parameter is).
 FIX #8  The IF(@NegativeQtyCount<1 AND @CreditAmount=0) gate previously
         had no ELSE - failing the pre-check fell through to an empty
         COMMIT with @ErrorStat still 0, which would have made the new
         @Success flag lie (report success) for the single most common
         insufficient-stock rejection path. Added ELSE SET @ErrorStat=1.

 Test in a non-production environment first. Back up the current
 definition before running:
   SELECT OBJECT_DEFINITION(OBJECT_ID('sp_Process_ProformaInvoiceByOrderId'));
============================================================================
*/

CREATE PROCEDURE [dbo].[sp_Process_ProformaInvoiceByOrderId]

 @OrderId INT,
 @UserId INT,
 @DANameId INT,
 @BatchNo1 NVARCHAR(MAX),
 @SAforSelectedSick INT = NULL,
 @Success BIT = NULL OUTPUT   -- FIX #7

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;   -- FIX #1

SET @Success = 0;   -- FIX #7: fail-closed default, only flipped to 1 on the actual COMMIT below

DECLARE @NegativeQtyCount INT=0
DECLARE @CreditAmount DECIMAL(18,2)=0

SELECT @NegativeQtyCount=COUNT(*)  FROM (SELECT tblt.Qty,ProductId,SUM(Quantity)AS OrdQty FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
LEFT JOIN (SELECT ProductCode,ComUnitId,SUM(StockQty)Qty FROM dbo.tblDCStore GROUP BY ProductCode,ComUnitId)
AS tblt ON tblt.ProductCode = tblOrderDetail.ProductCode AND tblt.ComUnitId = tblOrder.ComUnitId
WHERE  tblOrder.OrderId=@OrderId GROUP BY tblt.Qty,ProductId) AS tblt WHERE ISNULL(tblt.Qty,0)-tblt.OrdQty<0  -- FIX #6: NULL stock (no tblDCStore row) now counts as 0, not "unknown"

declare @CustId int

select @CustId=CustomerMasterId from tblOrder where OrderId=@OrderId

SELECT @CreditAmount=ISNULL(SUM(Amount),0) FROM [dbo].[tblReturnAmount] WHERE CustomerId=@CustId
Declare @ErrorStat bit=0

BEGIN TRY                                                            -- FIX #2

 begin TRANSACTION orderprocess

-- FIX #3: locked re-entrancy guard — stop a second concurrent call for the
-- same OrderId from proceeding while the first call's transaction is open.
IF EXISTS (SELECT 1 FROM dbo.tblOrder WITH (UPDLOCK, ROWLOCK) WHERE OrderId=@OrderId AND IsInvoice=1)
BEGIN
    ROLLBACK TRANSACTION orderprocess
    RETURN
END

IF(@NegativeQtyCount<1 AND @CreditAmount=0)
BEGIN



		   DECLARE @InvoiceId INT
           DECLARE @InvoiceNo NVARCHAR(MAX)
           DECLARE @InvoiceDate DATETIME
           DECLARE @OrderNo NVARCHAR(MAX)
           DECLARE @OrderDate DATETIME
           DECLARE @CustomerMasterId INT
           DECLARE @ComUnitId INT
           DECLARE @MiaId INT
           DECLARE @PaymentTypeId INT
           DECLARE @TpTotal DECIMAL(18,2)
           DECLARE @TpDiscount DECIMAL(18,2)
           DECLARE @TpVat DECIMAL(18,2)
           DECLARE @TpGrandTotal DECIMAL(18,2)
           DECLARE @TotalSpecialAmount DECIMAL(18,2)
           DECLARE @ProductOffer BIT
           DECLARE @OldTradePolicy BIT
           DECLARE @FixedCustomer BIT
           DECLARE @MIACode NVARCHAR(MAX)
           DECLARE @MIAName NVARCHAR(MAX)
           DECLARE @MarketCode NVARCHAR(MAX)
           DECLARE @MarketName NVARCHAR(MAX)
           DECLARE @AreaCode NVARCHAR(MAX)
           DECLARE @DisCode NVARCHAR(MAX)
           DECLARE @FEName NVARCHAR(MAX)
           DECLARE @RegionCode NVARCHAR(MAX)
           DECLARE @DZSMName NVARCHAR(MAX)
           DECLARE @Types NVARCHAR(MAX)
           DECLARE @GreenStarBlueStarID INT
           DECLARE @CustomerType NVARCHAR(MAX)



    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT ODR.OrderId,ODR.OrderCode,ODR.SubmissionDate,ODR.CustomerMasterId,ODR.ComUnitId,ODR.MIOId,ODRD.TpTotal,
	ODRD.TpDiscount,ODRD.TpVat,ODRD.TpGrandTotal,ODRD.TotalSpecialAmount,ODR.FixedCustomer,ODR.MIOCode,ODR.MIOName,
	dbo.tblMarket.MarketCode
           ,
		   dbo.tblMarket.MarketName
		   ,
		   null
           ,
		   null
		   ,
		   null
           ,
		   null
		   ,
		   null
		   ,
		   tblCustomerType.CustomerType
		   ,
		    null
			,
			tblProgramType.ProgramTypeName
			FROM tblOrder AS ODR

		   INNER JOIN (SELECT OrderId,SUM(TotalTradePrice) AS TpTotal,

		   SUM(DiscountAmount) AS TpDiscount,
		   SUM(TotalVatAmount) AS TpVat,
		   SUM(NetAmount) AS TpGrandTotal,
		   0.00 AS TotalSpecialAmount
		   FROM dbo.tblOrderDetail GROUP BY OrderId) AS ODRD ON ODRD.OrderId = ODR.OrderId
		   left join tblCustomerType on ODR.CustTypeId=tblCustomerType.CustomerTypeId
		   left join tblProgramType on ODR.ProgramTypeId=tblProgramType.ProgramTypeId
		   LEFT JOIN dbo.tblMarket ON ODR.MarketId=dbo.tblMarket.MarketId
		   WHERE ODR.IsInvoice = 0 AND ODR.OrderId = @OrderId


    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO   @OrderId,
           @OrderNo ,
           @OrderDate ,
           @CustomerMasterId ,
           @ComUnitId ,
           @MiaId ,
           @TpTotal ,
           @TpDiscount ,
           @TpVat ,
           @TpGrandTotal ,
           @TotalSpecialAmount ,
           @FixedCustomer ,
           @MIACode ,
           @MIAName ,
           @MarketCode ,
           @MarketName ,
           @AreaCode ,
           @DisCode ,
           @FEName ,
           @RegionCode ,
           @DZSMName ,
           @Types ,
           @GreenStarBlueStarID ,
           @CustomerType

    WHILE @@FETCH_STATUS = 0
    BEGIN

	--Invoice Master
	DECLARE @LastNo NVARCHAR(MAX)=''
	DECLARE @ComUnitCode NVARCHAR(MAX)=''

	SELECT @ComUnitCode=ComUnitCode FROM dbo.tblCompanyUnit WHERE ComUnitId=@ComUnitId

	SELECT @InvoiceId = isnull(MAX(InvoiceId),0)+1 FROM dbo.tblInvoice
	SELECT @InvoiceNo =  'INV-BD23-00' + CONVERT(varchar(10), isnull(MAX(InvoiceId),0)+1) FROM dbo.tblInvoice
	IF(LEN(@InvoiceId)=1)
	BEGIN
	    SET @LastNo='000000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=2)
	BEGIN
	    SET @LastNo='00000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=3)
	BEGIN
	    SET @LastNo='0000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=4)
	BEGIN
	    SET @LastNo='000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=5)
	BEGIN
	    SET @LastNo='00000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=6)
	BEGIN
	    SET @LastNo='0000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=7)
	BEGIN
	    SET @LastNo='000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=8)
	BEGIN
	    SET @LastNo='00'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=9)
	BEGIN
	    SET @LastNo='0'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	SET @InvoiceNo='AINV-'+@ComUnitCode+@LastNo


	INSERT INTO tblInvoice
           (
           InvoiceNo
           ,InvoiceDate
           ,OrderId
           ,OrderNo
           ,OrderDate
           ,CustomerMasterId
           ,ComUnitId
           ,MIOId
           ,PaymentTypeId
           ,TpTotal
           ,TpDiscount
           ,TpVat
           ,TpGrandTotal
           ,UserId
           ,CreateDate
           ,TotalSpecialAmount
           ,ProductOffer
           ,OldTradePolicy
           ,FixedCustomer
           ,MIACode
           ,MIAName
           ,MarketCode
           ,MarketName
           ,AreaCode
           ,DisCode
           ,FEName
           ,RegionCode
           ,DZSMName
           ,Types
           ,GreenStarBlueStarID
           ,CustomerType,IsAuto,Inv_DANameId)

     VALUES
           (
			 @InvoiceNo,
			 CONVERT(NVARCHAR(11),GETDATE(),106)
           ,@OrderId
           ,@OrderNo
           ,@OrderDate
           ,@CustomerMasterId
           ,@ComUnitId
           ,@MiaId
           ,1
           ,@TpTotal
           ,@TpDiscount
           ,@TpVat
           ,@TpGrandTotal
           ,@UserId
           ,getdate()
           ,@TotalSpecialAmount
           , N'False' ,
			 N'False'
           ,@FixedCustomer
           ,@MIACode
           ,@MIAName
           ,@MarketCode
           ,@MarketName
           ,@AreaCode
           ,@DisCode
           ,@FEName
           ,@RegionCode
           ,@DZSMName
           ,@Types
           ,@GreenStarBlueStarID
           ,@CustomerType,1,@DANameId)


	SELECT @InvoiceId=SCOPE_IDENTITY()
	--Invoice Detail


		   DECLARE @InvoiceDetailId INT
           DECLARE @ProductCode NVARCHAR(MAX)
           DECLARE @ProductName NVARCHAR(MAX)
           DECLARE @PackSize NVARCHAR(MAX)
           DECLARE @BatchNo NVARCHAR(MAX)
           DECLARE @ReceiveDate DATETIME
           DECLARE @ExpDate NVARCHAR(MAX)
           DECLARE @CostPrice DECIMAL(18,2)
           DECLARE @UnitPrice DECIMAL(18,2)
           DECLARE @UnitVatAmount DECIMAL(18,2)
           DECLARE @Quantity DECIMAL(18,2)
           DECLARE @BonusQuantity DECIMAL(18,2)
           DECLARE @TotalQuantity DECIMAL(18,2)
           DECLARE @TotalPrice DECIMAL(18,2)
           DECLARE @TotalPriceVatAmount DECIMAL(18,2)
           DECLARE @DiscountPercentage DECIMAL(18,2)
           DECLARE @DiscountAmount DECIMAL(18,2)
           DECLARE @NetAmount DECIMAL(18,2)
           DECLARE @DCStoreId INT
           DECLARE @OrderDetailsId INT
           DECLARE @SpecialAmount DECIMAL(18,2)
		   DECLARE @Campaign NVARCHAR(MAX)
           DECLARE @ISGiftProduct BIT
           DECLARE @CampaignType NVARCHAR(MAX)
           DECLARE @IsCampaignProduct BIT

			--------------------------------------------------------
			DECLARE @MyCursor2 CURSOR
			SET @MyCursor2 = CURSOR FAST_FORWARD
			FOR
			---------------

			SELECT PD.ProductCode
           ,PD.ProductName
           ,PD.PackSize
		   ,1
           ,'2018-10-01 00:00:00.000'
           ,'2020-01-31 00:00:00.000',CostPrice
           ,OD.TradePrice
           ,OD.UnitVatAmount
		   ,Quantity
           ,0
           ,Quantity
           ,OD.TotalTradePrice
           ,OD.TotalVatAmount
           ,OD.DiscountPercent
           ,OD.DiscountAmount
           ,NetAmount
           ,270
		   ,OD.OrderDetailId
		   ,0
		   ,NULL
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct FROM tblOrderDetail AS OD
			LEFT JOIN dbo.tblProduct AS PD ON PD.ProductCode = OD.ProductCode
			LEFT JOIN dbo.tblUnitPrice AS UP ON UP.ProductCode = OD.ProductCode
			WHERE OrderId = @OrderId AND UP.IsActive = 1
			----------
			OPEN @MyCursor2
			FETCH NEXT FROM @MyCursor2
			INTO  @ProductCode ,
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
            @DCStoreId ,
            @OrderDetailsId ,
            @SpecialAmount ,
		    @Campaign ,
            @ISGiftProduct ,
            @CampaignType ,
            @IsCampaignProduct

			WHILE @@FETCH_STATUS = 0
			BEGIN

			DECLARE @MainQty INT=0
			DECLARE @DCStoresId INT=0

			SET @MainQty=@Quantity

			WHILE (@MainQty>0)
			BEGIN
				SELECT @InvoiceDetailId=ISNULL(MAX(InvoiceDetailId),0)+1 FROM dbo.tblInvoiceDetail

				DECLARE @StockQ INT=0

				-- FIX #4: UPDLOCK+ROWLOCK so this row is locked for the rest of
				-- the transaction the instant it's read — a concurrent session
				-- can no longer read the same pre-decrement StockQty for this
				-- batch and independently decide it has "enough" stock too.
				SELECT TOP 1 @StockQ=StockQty,@DCStoresId=DCStoreId,@BatchNo=BatchNo
				FROM dbo.tblDCStore WITH (UPDLOCK, ROWLOCK)
				WHERE ProductCode=@ProductCode AND ComUnitId=@ComUnitId AND StockQty<>0
				ORDER BY  ExpDate ASC,BatchNo ASC

				IF(@StockQ>0)
				BEGIN
				IF(@StockQ>=@MainQty)
				BEGIN

				   Declare @CountP int=0
				   select @CountP=count(OrderDetailId) from tblOrderDetail where OrderId=@OrderId and OrderDetailId=@OrderDetailsId
				   if(@CountP>0)
				   begin
				   UPDATE dbo.tblDCStore SET StockQty=StockQty-@MainQty WHERE DCStoreId=@DCStoresId

				   set @TotalPrice=@UnitPrice*@MainQty
				   set @TotalPriceVatAmount=@UnitVatAmount*@MainQty
				   set @DiscountAmount=@TotalPrice*(@DiscountPercentage/100)
				   set @NetAmount=@TotalPrice+@TotalPriceVatAmount-@DiscountAmount
				   			INSERT INTO tblInvoiceDetail
           (
           ProductCode
           ,ProductName
           ,PackSize
           ,BatchNo
           ,ReceiveDate
           ,ExpDate
           ,CostPrice
           ,UnitPrice
           ,UnitVatAmount
           ,Quantity
           ,BonusQuantity
           ,TotalQuantity
           ,TotalPrice
           ,TotalPriceVatAmount
           ,DiscountPercentage
           ,DiscountAmount
           ,NetAmount
           ,InvoiceId
           ,DCStoreId
           ,OrderDetailsId
           ,SpecialAmount
           ,Campaign
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct)
     VALUES
           (
           @ProductCode,@ProductName
           ,@PackSize
           ,@BatchNo
           ,@ReceiveDate
           ,@ExpDate
           ,@CostPrice
           ,@UnitPrice
           ,@UnitVatAmount
           ,@MainQty
           ,@BonusQuantity
           ,@MainQty
           ,@TotalPrice
           ,@TotalPriceVatAmount
           ,@DiscountPercentage
           ,@DiscountAmount
           ,@NetAmount
           ,@InvoiceId
           ,@DCStoresId
           ,@OrderDetailsId
           ,@SpecialAmount
           ,@Campaign
           ,@ISGiftProduct
           ,@CampaignType
           ,@IsCampaignProduct)
		   SELECT @InvoiceDetailId=SCOPE_IDENTITY()
		   INSERT INTO dbo.tblDCStoreTransaction
				   (
				       DCStoreId,
				       Date,
				       Id,
				       Type,
				       Quantity
				   )
				   VALUES
				   (   @DCStoresId,
				       GETDATE(),
				       @InvoiceDetailId,
				       N'ProformaInvoice',
				       -@MainQty
				       )

					   end
					   else
					   begin
					   set @ErrorStat=1
					   end


				    SET @MainQty=0
				END
				ELSE
                BEGIN

				select @CountP=count(OrderDetailId) from tblOrderDetail where OrderId=@OrderId and OrderDetailId=@OrderDetailsId
				   if(@CountP>0)
				   begin
                    SET @MainQty=@MainQty-@StockQ

					UPDATE dbo.tblDCStore SET StockQty=0 WHERE DCStoreId=@DCStoresId
					set @TotalPrice=@UnitPrice*@StockQ
				   set @TotalPriceVatAmount=@UnitVatAmount*@StockQ
				   set @DiscountAmount=@TotalPrice*(@DiscountPercentage/100)
				   set @NetAmount=@TotalPrice+@TotalPriceVatAmount-@DiscountAmount

								INSERT INTO tblInvoiceDetail
           (
           ProductCode
           ,ProductName
           ,PackSize
           ,BatchNo
           ,ReceiveDate
           ,ExpDate
           ,CostPrice
           ,UnitPrice
           ,UnitVatAmount
           ,Quantity
           ,BonusQuantity
           ,TotalQuantity
           ,TotalPrice
           ,TotalPriceVatAmount
           ,DiscountPercentage
           ,DiscountAmount
           ,NetAmount
           ,InvoiceId
           ,DCStoreId
           ,OrderDetailsId
           ,SpecialAmount
           ,Campaign
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct)
     VALUES
           (
           @ProductCode
           ,@ProductName
           ,@PackSize
           ,@BatchNo
           ,@ReceiveDate
           ,@ExpDate
           ,@CostPrice
           ,@UnitPrice
           ,@UnitVatAmount
           ,@StockQ
           ,@BonusQuantity
           ,@StockQ
           ,@TotalPrice
           ,@TotalPriceVatAmount
           ,@DiscountPercentage
           ,@DiscountAmount
           ,@NetAmount
           ,@InvoiceId
           ,@DCStoresId
           ,@OrderDetailsId
           ,@SpecialAmount
           ,@Campaign
           ,@ISGiftProduct
           ,@CampaignType
           ,@IsCampaignProduct)
		   SELECT @InvoiceDetailId=SCOPE_IDENTITY()
		   INSERT INTO dbo.tblDCStoreTransaction
				   (
				       DCStoreId,
				       Date,
				       Id,
				       Type,
				       Quantity
				   )
				   VALUES
				   (   @DCStoresId,
				       GETDATE(),
				       @InvoiceDetailId,
				       N'ProformaInvoice',
				       -@MainQty
				       )



                END
				else
				begin

					   set @ErrorStat=1
				end
				END

				END
				ELSE
                BEGIN
				SET @ErrorStat=1  -- FIX #5: no batch left to cover the remaining requested qty -> flag failure instead of silently under-fulfilling
				SET @MainQty=0
				BREAK


				END


			END

			FETCH NEXT FROM @MyCursor2
			INTO  @ProductCode ,
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
            @DCStoreId ,
            @OrderDetailsId ,
            @SpecialAmount ,
		    @Campaign ,
            @ISGiftProduct ,
            @CampaignType ,
            @IsCampaignProduct

			END
			CLOSE @MyCursor2
			DEALLOCATE @MyCursor2

    --Detail END

	END

	if(@ErrorStat=0)
	begin
	UPDATE dbo.tblOrder SET IsInvoice = 1 , SAforSelectedSick = ISNULL(@SAforSelectedSick, SAforSelectedSick)  WHERE OrderId = @OrderId
	end

    FETCH NEXT FROM @MyCursor
    INTO   @OrderId,
           @OrderNo ,
           @OrderDate ,
           @CustomerMasterId ,
           @ComUnitId ,
           @MiaId ,
           @TpTotal ,
           @TpDiscount ,
           @TpVat ,
           @TpGrandTotal ,
           @TotalSpecialAmount ,
           @FixedCustomer ,
           @MIACode ,
           @MIAName ,
           @MarketCode ,
           @MarketName ,
           @AreaCode ,
           @DisCode ,
           @FEName ,
           @RegionCode ,
           @DZSMName ,
           @Types ,
           @GreenStarBlueStarID ,
           @CustomerType


    CLOSE @MyCursor
    DEALLOCATE @MyCursor

	if(@ErrorStat=0)
	begin
	INSERT INTO dbo.tblInvoiceBatch
	(
	    BatchNo,
	    Date,
	    InvoiceId
	)
	VALUES
	(   @BatchNo1,
	    GETDATE(),
	    @InvoiceId
	    )

		end

	END
	ELSE
	BEGIN
	SET @ErrorStat=1  -- FIX #8: pre-check found insufficient stock (or outstanding credit) - flag it so @Success correctly reports failure instead of falling through to an empty COMMIT
	END

	Declare @ProblemStat bit=0
	Declare @InvoiceDetId2 int
	declare @OrderDetailId2 int
	declare @OrderId2 int

			DECLARE @Roll CURSOR
			SET @Roll = CURSOR FAST_FORWARD
			FOR

			select InvoiceDetailId,OrderId,OrderDetailsId from tblInvoiceDetail
			left join tblInvoice on tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId
			 where tblInvoiceDetail.InvoiceId=@InvoiceId

OPEN @Roll
			FETCH NEXT FROM @Roll
			INTO  @InvoiceDetId2 ,@OrderId2,
            @OrderDetailId2
			WHILE @@FETCH_STATUS = 0
			BEGIN

			Declare @MainOrderId int

			select @MainOrderId=tblOrder.OrderId from tblOrder
			left join tblOrderDetail on tblOrder.OrderId = tblOrderDetail.OrderId where OrderDetailId=@OrderDetailId2

			if(@MainOrderId<>@OrderId2)
			begin
			  set @ProblemStat=1
			end

			FETCH NEXT FROM @Roll
			INTO  @InvoiceDetId2 ,@OrderId2,
            @OrderDetailId2
			end

			close @Roll
			deallocate @Roll

if(@ErrorStat=1 or @ProblemStat=1)
begin

rollback transaction orderprocess

end

else
begin

commit transaction orderprocess
SET @Success = 1   -- FIX #7: only the real commit path reports success
end

END TRY                                                              -- FIX #2
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION orderprocess;
    THROW;
END CATCH

END
