CREATE PROCEDURE [dbo].[sp_SAP_StockInTransfer]  --- exec sp_StockInMIGOtoCentralStore 1
    @WHStockInMasterID INT,
    @ReqId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReceiveIdMAX INT = 0;

    DECLARE @ReqChildId INT;
    DECLARE @ProductCode NVARCHAR(MAX);
    DECLARE @ProductName NVARCHAR(MAX);
    DECLARE @PackSize NVARCHAR(MAX);
    DECLARE @Batch NVARCHAR(MAX);
    DECLARE @Qty INT;
    DECLARE @ExpDate DATETIME;
    DECLARE @MfgDate DATETIME;
    DECLARE @Price DECIMAL(18,2);
    DECLARE @VAT DECIMAL(18,2);
    DECLARE @ReceiveDate DATETIME;
    DECLARE @ReceiveId INT;
    DECLARE @IsIssue NVARCHAR(50);

    --------------------------------------------------------
    DECLARE @MyCursor CURSOR;

    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    WITH CTE AS
    (
        SELECT
            ReqChildId,
            PD.ProductCode,
            PD.ProductName,
            PD.PackSize,
            Batch,
            Qty,
            D.ExpDate,
            D.MfgDate,
            Price,
            VAT,
            CS.ReceiveDate,
            ReceiveId,
            IsIssue,
            ROW_NUMBER() OVER (PARTITION BY RD.ReqChildId ORDER BY RD.ReqChildId) AS rn
        FROM tblWHStockInDetail AS D
        LEFT JOIN tblCentralStore AS CS ON D.WHStockInDetailID = CS.MigoDetailID
        LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
        LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
        LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM
               ON UPPER(RTRIM(LTRIM(M.ChallanNo))) = UPPER(RTRIM(LTRIM(SM.challan_code)))
        LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
        LEFT JOIN tblRequsitionChild AS RD ON PD.ProductCode = RD.ProductCode AND RD.BatchNO = CS.BatchNO
        WHERE
            RD.ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM tblStockInTransfar WHERE ReqChildId IS NOT NULL)
            AND M.WHStockInMasterID = @WHStockInMasterID
            AND ReqId = @ReqId
    )
    SELECT
        ReqChildId,
        ProductCode,
        ProductName,
        PackSize,
        Batch,
        Qty,
        ExpDate,
        MfgDate,
        Price,
        VAT,
        ReceiveDate,
        ReceiveId,
        IsIssue
    FROM CTE
    WHERE rn = 1;

    OPEN @MyCursor;

    FETCH NEXT FROM @MyCursor
    INTO @ReqChildId, @ProductCode, @ProductName, @PackSize, @Batch, @Qty, @ExpDate, @MfgDate,
         @Price, @VAT, @ReceiveDate, @ReceiveId, @IsIssue;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @ReceiveIdMAX = (ISNULL(MAX(StockInTransfarId), 0) + 1)
        FROM tblStockInTransfar;

        INSERT INTO [dbo].[tblStockInTransfar]
        (
            StockInTransfarId,
            ReqId,
            ReqChildId,
            ProductCode,
            ProductName,
            PackSize,
            BatchNo,
            Quantity,
            PickingQty,
            UnitPrice,
            PriceAmount,
            VATAmount,
            TotalPriceAmount,
            ExpDate,
            ReceiveDate,
            IsIssue,
            ReceiveId,
            MfgDate
        )
        VALUES
        (
            @ReceiveIdMAX,
            @ReqId,
            @ReqChildId,
            @ProductCode,
            @ProductName,
            @PackSize,
            @Batch,
            @Qty,
            @Qty,
            @Price,
            @Qty * @Price,
            @Qty * @Vat,
            (@Qty * @Price) + (@Qty * @Vat),
            @ExpDate,
            @ReceiveDate,
            @IsIssue,
            @ReceiveId,
            @MfgDate
        );

        FETCH NEXT FROM @MyCursor
        INTO @ReqChildId, @ProductCode, @ProductName, @PackSize, @Batch, @Qty, @ExpDate, @MfgDate,
             @Price, @VAT, @ReceiveDate, @ReceiveId, @IsIssue;
    END

    CLOSE @MyCursor;
    DEALLOCATE @MyCursor;

    RETURN @ReceiveIdMAX;
END
