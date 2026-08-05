
create PROCEDURE [dbo].[sp_UpdateAndInsertInvoiceDetailSalesReturn]
    @InvoiceDetailReturnId INT OUTPUT,
    @InvoiceId INT,
    @InvoiceDetailId INT,
    @Quantity INT,
    @PreviousQuantity INT,
    @BonusQuantity INT,
    @TotalQuantity INT,
    @TotalPrice DECIMAL(18,2),
    @TotalPriceVatAmount DECIMAL(18,2),
    @DiscountPercentage DECIMAL(5,2),
    @DiscountAmount DECIMAL(18,2),
    @NetAmount DECIMAL(18,2),
    @DeliveryStatus NVARCHAR(50),
    @ReturnReason NVARCHAR(250)
AS
BEGIN
    --SET NOCOUNT ON;
	 

    --IF ISNULL(@ReturnReason, '') <> ''
    --BEGIN
        INSERT INTO tblInvoiceDetailReturn (
            InvoiceId,
            InvoiceDetailId,
			PreviousQuantity,
            sndReturnQuantity,
            sndReturnBonusQuantity,
            sndReturnTotalQuantity,
            sndReturnTotalPrice,
            sndReturnTotalPriceVatAmount,
            sndReturnDiscountPercentage,
            sndReturnDiscountAmount,
            sndReturnNetAmount,
            sndReturnStatus,
            sndReturnReason
        )
        VALUES (
            @InvoiceId,
            @InvoiceDetailId,
			@PreviousQuantity,
            @Quantity,
            @BonusQuantity,
            @TotalQuantity,
            @TotalPrice,
            @TotalPriceVatAmount,
            @DiscountPercentage,
            @DiscountAmount,
            @NetAmount,
            @DeliveryStatus,
            @ReturnReason
        );

        SET @InvoiceDetailReturnId = SCOPE_IDENTITY();

		select @InvoiceDetailReturnId InvoiceDetailReturnId
    --END
END
