create PROCEDURE [dbo].[sp_opeingBalanceCreate]
    @FinancialYear NVARCHAR(50) = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @FromDate IS NULL --SET @FromDate = '19000101';
    IF @ToDate IS NULL --SET @ToDate = '99991231';

    IF @FromDate > @ToDate
    BEGIN
        RAISERROR('FromDate cannot be greater than ToDate.', 16, 1);
        RETURN;
    END;

    BEGIN TRAN;
    BEGIN TRY
        DECLARE @PendingMap TABLE
        (
            OrderId BIGINT PRIMARY KEY,
            PendingDelID BIGINT
        );

        INSERT INTO dbo.tblPendingDeliveryInvoice_Master
        (
            OrderId,
            OrderCode,
            OrderSubmissionDate,
            DepoId,
            DepoCode,
            DepoName,
            CustomerMasterId,
            CustomerCode,
            CustomerName,
            CustTypeId,
            ProgramTypeId,
            CustType,
            ProgramType,
            OrderSenderType,
            OrderSenderCode,
            OrderSenderName,
            DistributionRouteId,
            DistributionRoute_Name,
            NSMId,
            RSMId,
            ASMId,
            MIOId,
            GroupId,
            RegionId,
            AreaId,
            TerritoryId,
            SubTerritoryId,
            MarketId,
            Group_Name,
            Region_Name,
            Area_Name,
            Territory_Name,
            SubTerritory_Name,
            Market_Name
        )
        OUTPUT inserted.OrderId, inserted.PendingDelID
        INTO @PendingMap (OrderId, PendingDelID)
        SELECT
            ord.OrderId,
            ord.OrderCode,
            ord.SubmissionDate,
            ord.ComUnitId,
            ord.ComUnitCode,
            ord.ComUnitName,
            ord.CustomerMasterId,
            ord.CustomerCode,
            ord.CustomerName,
            ord.CustTypeId,
            ord.ProgramTypeId,
            ord.CustomerType,
            '',
            ord.OrderSenderType,
            ord.OrderSenderCode,
            ord.OrderSenderName,
            ord.DistributionRouteId,
            ord.DistributionRoute_Ord,
            ord.NSMId,
            ord.RSMId,
            ord.ASMId,
            ord.MIOId,
            ord.GroupId,
            ord.RegionId,
            ord.AreaId,
            ord.TerritoryId,
            ord.SubTerritoryId,
            ord.MarketId,
            ord.GroupCode_Ord,
            ord.RegionCode_Ord,
            ord.AreaCode_Ord,
            ord.TerritoryCode_Ord,
            ord.SubTerritoryCode_Ord,
            ord.MarketCode_Ord
        FROM dbo.tblInvoice inv
        INNER JOIN dbo.tblOrder ord
            ON inv.OrderId = ord.OrderId
        WHERE inv.DelivaryInvoiceNo IS NULL
          AND inv.InvoiceDate >= @FromDate
          AND inv.InvoiceDate < DATEADD(DAY, 1, @ToDate)
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.tblPendingDeliveryInvoice_Master m
              WHERE m.OrderId = ord.OrderId
                AND m.OrderSubmissionDate = ord.SubmissionDate
                AND m.DepoId = ord.ComUnitId
          );

        INSERT INTO dbo.tblPendingDeliveryInvoice_Detail
        (
            PendingID,
            ProductId,
            ProductCode,
            ProductName,
            Order_Quantity,
            Order_TradePrice,
            Order_TotalTradePrice,
            Order_Status,
            ISGiftProduct,
            CampaignType,
            Order_DiscountPercent,
            Order_DiscountAmount,
            Order_UnitVatAmount,
            Order_TotalVatAmount,
            Order_NetAmount,
            CampaignName,
            IsCampaignProduct,
            IsSpDis,
            CampaignCategory,
            Invoice_CostPrice,
            Invoice_UnitPrice,
            Invoice_UnitVatAmount,
            Invoice_Quantity,
            Invoice_BonusQuantity,
            Invoice_TotalQuantity,
            Invoice_TotalPrice,
            Invoice_TotalPriceVatAmount,
            Invoice_DiscountPercentage,
            Invoice_DiscountAmount,
            Invoice_NetAmount,
            InvoiceId,
            DCStoreId,
            DeliveryQuantity,
            DeliveryBonusQuantity,
            DeliveryTotalQuantity,
            DeliveryTotalPrice,
            DeliveryTotalPriceVatAmount,
            DeliveryDiscountPercentage,
            DeliveryDiscountAmount,
            DeliveryNetAmount,
            DeliveryStatus,
            OrderDetailsId,
            SpecialAmount,
            DelivarySpecialAmount,
            ReturnReason,
            Campaign,
            AdjustmentAmount,
            PaymentQuantity,
            PaymentBonusQuantity,
            PaymentTotalQuantity,
            PaymentTotalPrice,
            PaymentTotalPriceVatAmount,
            PaymentDiscountPercentage,
            PaymentDiscountAmount,
            PaymentNetAmount,
            PaymentReturnReason,
            PaymentStatus
        )
        SELECT
            pm.PendingDelID,
            OrdD.ProductId,
            OrdD.ProductCode,
            OrdD.ProductName,
            OrdD.Quantity,
            OrdD.TradePrice,
            OrdD.TotalTradePrice,
            OrdD.Status,
            OrdD.ISGiftProduct,
            OrdD.CampaignType,
            OrdD.DiscountPercent,
            OrdD.DiscountAmount,
            OrdD.UnitVatAmount,
            OrdD.TotalVatAmount,
            OrdD.NetAmount,
            OrdD.CampaignName,
            OrdD.IsCampaignProduct,
            OrdD.IsSpDis,
            OrdD.CampaignCategory,
            ivD.CostPrice,
            ivD.UnitPrice,
            ivD.UnitVatAmount,
            ivD.Quantity,
            ivD.BonusQuantity,
            ivD.TotalQuantity,
            ivD.TotalPrice,
            ivD.TotalPriceVatAmount,
            ivD.DiscountPercentage,
            ivD.DiscountAmount,
            ivD.NetAmount,
            ivD.InvoiceId,
            ivD.DCStoreId,
            ivD.DeliveryQuantity,
            ivD.DeliveryBonusQuantity,
            ivD.DeliveryTotalQuantity,
            ivD.DeliveryTotalPrice,
            ivD.DeliveryTotalPriceVatAmount,
            ivD.DeliveryDiscountPercentage,
            ivD.DeliveryDiscountAmount,
            ivD.DeliveryNetAmount,
            ivD.DeliveryStatus,
            ivD.OrderDetailsId,
            ivD.SpecialAmount,
            ivD.DelivarySpecialAmount,
            ivD.ReturnReason,
            ivD.Campaign,
            ivD.AdjustmentAmount,
            ivD.PaymentQuantity,
            ivD.PaymentBonusQuantity,
            ivD.PaymentTotalQuantity,
            ivD.PaymentTotalPrice,
            ivD.PaymentTotalPriceVatAmount,
            ivD.PaymentDiscountPercentage,
            ivD.PaymentDiscountAmount,
            ivD.PaymentNetAmount,
            ivD.PaymentReturnReason,
            ivD.PaymentStatus
        FROM dbo.tblInvoice inv
        INNER JOIN dbo.tblOrder ord
            ON inv.OrderId = ord.OrderId
        INNER JOIN @PendingMap pm
            ON pm.OrderId = ord.OrderId
        INNER JOIN dbo.tblInvoiceDetail ivD
            ON inv.InvoiceId = ivD.InvoiceId
        INNER JOIN dbo.tblOrderDetail OrdD
            ON OrdD.OrderDetailId = ivD.OrderDetailsId
        WHERE inv.DelivaryInvoiceNo IS NULL
          AND inv.InvoiceDate >= @FromDate
          AND inv.InvoiceDate < DATEADD(DAY, 1, @ToDate)
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.tblPendingDeliveryInvoice_Detail d
              WHERE d.PendingID = pm.PendingDelID
                AND d.InvoiceId = ivD.InvoiceId
                AND d.OrderDetailsId = ivD.OrderDetailsId
          );

        -- Insert into new financial year tracking table
        INSERT INTO dbo.tblOpeningBalanceFinancialYearLog
        (
            FinancialYear,
            FromDate,
            ToDate,
            ProcessDate,
            TotalOrdersProcessed,
            TotalAmount,
            Status,
            CreatedBy
        )
        SELECT
            @FinancialYear,
            @FromDate,
            @ToDate,
            GETDATE(),
            COUNT(DISTINCT ord.OrderId),
            SUM(ivD.TotalPrice),
            'Completed',
            SYSTEM_USER
        FROM dbo.tblInvoice inv
        INNER JOIN dbo.tblOrder ord
            ON inv.OrderId = ord.OrderId
        INNER JOIN dbo.tblInvoiceDetail ivD
            ON inv.InvoiceId = ivD.InvoiceId
        WHERE inv.DelivaryInvoiceNo IS NULL
          AND inv.InvoiceDate >= @FromDate
          AND inv.InvoiceDate < DATEADD(DAY, 1, @ToDate);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
