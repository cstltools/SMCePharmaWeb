

-- Wrapper stored procedure: filters + paging
CREATE   PROCEDURE dbo.sp_Get_ProformaInvoiceReportList_Search
    @FromDate       DATE        = NULL,
    @ToDate         DATE        = NULL,
    @ComUnitCode    VARCHAR(50) = NULL,
    @CustomerCode   VARCHAR(50) = NULL,
    @CustomerName   VARCHAR(200)= NULL,
    @InvoiceNo      VARCHAR(50) = NULL,
    @OrderNo        VARCHAR(50) = NULL,
    @ProductCode    VARCHAR(50) = NULL,
    @ProductName    VARCHAR(200)= NULL,
    @PaymentType    VARCHAR(50) = NULL,
    @MarketCode     VARCHAR(50) = NULL,
    @TerritoryCode  VARCHAR(50) = NULL,
    @PageNo         INT         = 1,
    @PageSize       INT         = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @PageNo   IS NULL OR @PageNo   < 1 SET @PageNo = 1;
    IF @PageSize IS NULL OR @PageSize < 1 SET @PageSize = 50;

    DECLARE @Offset INT = (@PageNo - 1) * @PageSize;

    ;WITH src AS (
        SELECT
            v.ComUnitCode,
            v.ComUnitName,
            v.CustomerCode,
            v.CustomerName,
            v.[Type],
            v.SMCType_Ord,
            v.IntransitDay,
            v.OrderNo,
            v.OrderDate,
            v.InvoiceNo,
            v.InvoiceDate,
            v.ProductCode,
            v.ProductName,
            v.PackSize,
            v.BatchNo,
            v.ExpDate,
            v.Quantity,
            v.GrossValue,
            v.TotalVat,
            v.TotalDiscount,
            v.AdjustmentAmount,
            v.TotalNetPayable,
            v.MarketCode,
            v.MarketName,
            v.TerritoryCode,
            v.MIOEmpCode,
            v.MIOEmpName,
            v.AMEmpCode,
            v.AMEmpName,
            v.RegionName,
            v.ProductOffer,
            v.CampaignCategory,
            v.paymenttype,
            TotalRows = COUNT(1) OVER()
        FROM dbo.View_ProformaInvoiceReportList v
        WHERE 1 = 1
          AND (@FromDate IS NULL OR v.InvoiceDate >= @FromDate)
          AND (@ToDate   IS NULL OR v.InvoiceDate < DATEADD(DAY, 1, @ToDate))
          AND (@ComUnitCode  IS NULL OR v.ComUnitCode  = @ComUnitCode)
          AND (@CustomerCode IS NULL OR v.CustomerCode = @CustomerCode)
          AND (@CustomerName IS NULL OR v.CustomerName LIKE @CustomerName + '%')
          AND (@InvoiceNo    IS NULL OR v.InvoiceNo    = @InvoiceNo)
          AND (@OrderNo      IS NULL OR v.OrderNo      = @OrderNo)
          AND (@ProductCode  IS NULL OR v.ProductCode  = @ProductCode)
          AND (@ProductName  IS NULL OR v.ProductName LIKE @ProductName + '%')
          AND (@PaymentType  IS NULL OR v.paymenttype  = @PaymentType)
          AND (@MarketCode   IS NULL OR v.MarketCode   = @MarketCode)
          AND (@TerritoryCode IS NULL OR v.TerritoryCode = @TerritoryCode)
    )
    SELECT *
    FROM src
    ORDER BY InvoiceDate DESC, InvoiceNo DESC, OrderNo DESC, ProductCode
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END
