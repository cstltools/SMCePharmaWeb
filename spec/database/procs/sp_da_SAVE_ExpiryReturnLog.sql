
CREATE   PROCEDURE dbo.sp_da_SAVE_ExpiryReturnLog
    @ExpiryReturnId INT = 0,
    @DaId INT,
    @ComUnitId INT,
    @RouteId INT,
    @CustomerCode NVARCHAR(50),
    @CustomerName NVARCHAR(250) = NULL,
    @SubmitBy INT,
    @Remarks NVARCHAR(500) = NULL,
    @IsFromApp BIT = 1,
    @Details dbo.ExpiryReturnDetailTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @SavedExpiryReturnId INT = ISNULL(@ExpiryReturnId, 0);
    DECLARE @DetailCount INT = 0;
    DECLARE @StatusCode INT = 0;
    DECLARE @Message NVARCHAR(250) = N'';
    DECLARE @NormalizedCustomerCode NVARCHAR(50) = NULLIF(LTRIM(RTRIM(ISNULL(@CustomerCode, N''))), N'');
    DECLARE @NormalizedCustomerName NVARCHAR(250) = NULLIF(LTRIM(RTRIM(ISNULL(@CustomerName, N''))), N'');
    DECLARE @NormalizedRemarks NVARCHAR(500) = NULLIF(LTRIM(RTRIM(ISNULL(@Remarks, N''))), N'');
    DECLARE @SavedIsFromApp BIT = ISNULL(@IsFromApp, 1);

    SELECT @DetailCount = COUNT(1)
    FROM @Details;

    IF ISNULL(@ExpiryReturnId, 0) < 0
    BEGIN
        SELECT @StatusCode = 400, @Message = N'ExpiryReturnId cannot be negative.';
        GOTO Finish;
    END

    IF ISNULL(@DaId, 0) <= 0 OR ISNULL(@ComUnitId, 0) <= 0 OR ISNULL(@RouteId, 0) <= 0
    BEGIN
        SELECT @StatusCode = 400, @Message = N'daid, ComUnitId and RouteId must be greater than 0.';
        GOTO Finish;
    END

    IF @NormalizedCustomerCode IS NULL
    BEGIN
        SELECT @StatusCode = 400, @Message = N'CustomerCode is required.';
        GOTO Finish;
    END

    IF ISNULL(@SubmitBy, 0) <= 0
    BEGIN
        SELECT @StatusCode = 400, @Message = N'SubmitBy must be greater than 0.';
        GOTO Finish;
    END

    IF @DetailCount = 0
    BEGIN
        SELECT @StatusCode = 400, @Message = N'At least one expiry return detail is required.';
        GOTO Finish;
    END

    IF EXISTS
    (
        SELECT 1
        FROM @Details
        WHERE ISNULL(ExpiryReturnDetailId, 0) < 0
           OR ISNULL(ProductId, 0) <= 0
           OR ISNULL(DCStoreId, 0) < 0
           OR NULLIF(LTRIM(RTRIM(ISNULL(ProductCode, N''))), N'') IS NULL
           OR NULLIF(LTRIM(RTRIM(ISNULL(BatchNo, N''))), N'') IS NULL
           OR ISNULL(ReturnQty, 0) <= 0
           OR ISNULL(ReasonId, 0) <= 0
    )
    BEGIN
        SELECT @StatusCode = 400,
               @Message = N'Every expiry return detail must have valid ProductId, dcStoreId, ProductCode, BatchNo, ReturnQty and ReasonId.';
        GOTO Finish;
    END

    IF EXISTS
    (
        SELECT 1
        FROM @Details
        GROUP BY
            UPPER(LTRIM(RTRIM(ProductCode))),
            ISNULL(DCStoreId, 0),
            UPPER(LTRIM(RTRIM(BatchNo)))
        HAVING COUNT(1) > 1
    )
    BEGIN
        SELECT @StatusCode = 400, @Message = N'Duplicate dcStoreId, ProductCode and BatchNo found in details.';
        GOTO Finish;
    END

    IF @SavedExpiryReturnId > 0
       AND NOT EXISTS
       (
            SELECT 1
            FROM dbo.tblExpiryReturn_appLog WITH (NOLOCK)
            WHERE ExpiryReturnId = @SavedExpiryReturnId
       )
    BEGIN
        SELECT @StatusCode = 404, @Message = N'Expiry return log not found.';
        GOTO Finish;
    END

    BEGIN TRANSACTION;

    IF @SavedExpiryReturnId > 0
    BEGIN
        DELETE FROM dbo.tblExpiryReturn_appLogDetail
        WHERE ExpiryReturnId = @SavedExpiryReturnId;

        UPDATE dbo.tblExpiryReturn_appLog
        SET DaId = @DaId,
            ComUnitId = @ComUnitId,
            RouteId = @RouteId,
            CustomerCode = @NormalizedCustomerCode,
            CustomerName = @NormalizedCustomerName,
            SubmitBy = @SubmitBy,
            SubmitDate = GETDATE(),
            Remarks = @NormalizedRemarks,
            IsFromApp = @SavedIsFromApp,
            UpdateBy = @SubmitBy,
            UpdateDate = GETDATE()
        WHERE ExpiryReturnId = @SavedExpiryReturnId;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.tblExpiryReturn_appLog
        (
            DaId,
            ComUnitId,
            RouteId,
            CustomerCode,
            CustomerName,
            SubmitBy,
            SubmitDate,
            Remarks,
            IsFromApp
        )
        VALUES
        (
            @DaId,
            @ComUnitId,
            @RouteId,
            @NormalizedCustomerCode,
            @NormalizedCustomerName,
            @SubmitBy,
            GETDATE(),
            @NormalizedRemarks,
            @SavedIsFromApp
        );

        SET @SavedExpiryReturnId = CONVERT(INT, SCOPE_IDENTITY());
    END

    INSERT INTO dbo.tblExpiryReturn_appLogDetail
    (
        ExpiryReturnId,
        ProductId,
        DCStoreId,
        ProductCode,
        ProductName,
        BatchNo,
        ReturnQty,
        ReasonId,
        ReasonName
    )
    SELECT
        @SavedExpiryReturnId,
        ProductId,
        ISNULL(DCStoreId, 0),
        LTRIM(RTRIM(ProductCode)),
        NULLIF(LTRIM(RTRIM(ProductName)), N''),
        LTRIM(RTRIM(BatchNo)),
        ReturnQty,
        ReasonId,
        NULLIF(LTRIM(RTRIM(ReasonName)), N'')
    FROM @Details;

    COMMIT TRANSACTION;

    SELECT @StatusCode = CASE WHEN ISNULL(@ExpiryReturnId, 0) > 0 THEN 200 ELSE 201 END,
           @Message = CASE
                WHEN ISNULL(@ExpiryReturnId, 0) > 0 THEN N'Expiry return log updated successfully.'
                ELSE N'Expiry return log saved successfully.'
           END;

Finish:
    SELECT
        @StatusCode AS StatusCode,
        @Message AS [Message],
        @SavedExpiryReturnId AS ExpiryReturnId,
        ISNULL(@DaId, 0) AS DaId,
        ISNULL(@ComUnitId, 0) AS ComUnitId,
        ISNULL(@RouteId, 0) AS RouteId,
        ISNULL(@NormalizedCustomerCode, N'') AS CustomerCode,
        ISNULL(@NormalizedCustomerName, N'') AS CustomerName,
        ISNULL(@SubmitBy, 0) AS SubmitBy,
        ISNULL(@NormalizedRemarks, N'') AS Remarks,
        @SavedIsFromApp AS IsFromApp,
        CASE WHEN @StatusCode >= 400 THEN 0 ELSE @DetailCount END AS DetailCount;
END
