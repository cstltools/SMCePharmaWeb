
CREATE   PROCEDURE dbo.sp_da_SAVE_DICApprovedDAClaimAmountLog
    @DAClaimId INT,
    @DaId INT,
    @MarketId INT,
    @DAAmount DECIMAL(18, 2),
    @ApprovalStatus NVARCHAR(50),
    @ApproveBy NVARCHAR(50) = NULL,
    @ApproveDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF ISNULL(@DAClaimId, 0) <= 0
    BEGIN
        SELECT
            400 AS StatusCode,
            N'DAClaimId must be greater than 0.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            ISNULL(@DAClaimId, 0) AS DAClaimId,
            ISNULL(@DaId, 0) AS DaId,
            ISNULL(@MarketId, 0) AS MarketId,
            ISNULL(@DAAmount, 0) AS DAAmount,
            ISNULL(@ApprovalStatus, N'') AS ApprovalStatus,
            ISNULL(@ApproveBy, N'') AS ApproveBy,
            N'' AS ApproveDate;
        RETURN;
    END

    IF ISNULL(@DaId, 0) <= 0
    BEGIN
        SELECT
            400 AS StatusCode,
            N'DaId must be greater than 0.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            @DAClaimId AS DAClaimId,
            ISNULL(@DaId, 0) AS DaId,
            ISNULL(@MarketId, 0) AS MarketId,
            ISNULL(@DAAmount, 0) AS DAAmount,
            ISNULL(@ApprovalStatus, N'') AS ApprovalStatus,
            ISNULL(@ApproveBy, N'') AS ApproveBy,
            N'' AS ApproveDate;
        RETURN;
    END

    IF ISNULL(@MarketId, 0) <= 0
    BEGIN
        SELECT
            400 AS StatusCode,
            N'MarketId must be greater than 0.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            @DAClaimId AS DAClaimId,
            @DaId AS DaId,
            ISNULL(@MarketId, 0) AS MarketId,
            ISNULL(@DAAmount, 0) AS DAAmount,
            ISNULL(@ApprovalStatus, N'') AS ApprovalStatus,
            ISNULL(@ApproveBy, N'') AS ApproveBy,
            N'' AS ApproveDate;
        RETURN;
    END

    IF @DAAmount IS NULL OR @DAAmount < 0
    BEGIN
        SELECT
            400 AS StatusCode,
            N'DAAmount is required and cannot be negative.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            @DAClaimId AS DAClaimId,
            @DaId AS DaId,
            @MarketId AS MarketId,
            ISNULL(@DAAmount, 0) AS DAAmount,
            ISNULL(@ApprovalStatus, N'') AS ApprovalStatus,
            ISNULL(@ApproveBy, N'') AS ApproveBy,
            N'' AS ApproveDate;
        RETURN;
    END

    IF NULLIF(LTRIM(RTRIM(ISNULL(@ApprovalStatus, N''))), N'') IS NULL
    BEGIN
        SELECT
            400 AS StatusCode,
            N'ApprovalStatus is required.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            @DAClaimId AS DAClaimId,
            @DaId AS DaId,
            @MarketId AS MarketId,
            @DAAmount AS DAAmount,
            N'' AS ApprovalStatus,
            ISNULL(@ApproveBy, N'') AS ApproveBy,
            N'' AS ApproveDate;
        RETURN;
    END

    DECLARE @SavedApproveDate DATETIME = ISNULL(@ApproveDate, GETDATE());
    DECLARE @EntryDate DATETIME = GETDATE();

    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tblDICApprovedDAClaimAmount WITH (UPDLOCK, HOLDLOCK)
        WHERE DAClaimId = @DAClaimId
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            409 AS StatusCode,
            N'DAClaimId already exists in DIC approved DA claim amount log.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            @DAClaimId AS DAClaimId,
            @DaId AS DaId,
            @MarketId AS MarketId,
            @DAAmount AS DAAmount,
            LTRIM(RTRIM(@ApprovalStatus)) AS ApprovalStatus,
            ISNULL(NULLIF(LTRIM(RTRIM(@ApproveBy)), N''), N'') AS ApproveBy,
            CONVERT(VARCHAR(19), @SavedApproveDate, 120) AS ApproveDate;
        RETURN;
    END

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tblDICApprovedDAClaimAmount WITH (UPDLOCK, HOLDLOCK)
        WHERE DaId = @DaId
          AND EntryDate >= CONVERT(DATE, @EntryDate)
          AND EntryDate < DATEADD(DAY, 1, CONVERT(DATE, @EntryDate))
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            400 AS StatusCode,
            N'Today already entry exists for this DA.' AS [Message],
            0 AS DICApprovedDAClaimAmountId,
            @DAClaimId AS DAClaimId,
            @DaId AS DaId,
            @MarketId AS MarketId,
            @DAAmount AS DAAmount,
            LTRIM(RTRIM(@ApprovalStatus)) AS ApprovalStatus,
            ISNULL(NULLIF(LTRIM(RTRIM(@ApproveBy)), N''), N'') AS ApproveBy,
            CONVERT(VARCHAR(19), @SavedApproveDate, 120) AS ApproveDate;
        RETURN;
    END

    INSERT INTO dbo.tblDICApprovedDAClaimAmount
    (
        DAClaimId,
        DaId,
        MarketId,
        DAAmount,
        ApprovalStatus,
        ApproveBy,
        ApproveDate,
        EntryDate
    )
    VALUES
    (
        @DAClaimId,
        @DaId,
        @MarketId,
        @DAAmount,
        LTRIM(RTRIM(@ApprovalStatus)),
        NULLIF(LTRIM(RTRIM(@ApproveBy)), N''),
        @SavedApproveDate,
        @EntryDate
    );

    COMMIT TRANSACTION;

    SELECT
        200 AS StatusCode,
        N'DIC approved DA claim amount log saved successfully.' AS [Message],
        CONVERT(INT, SCOPE_IDENTITY()) AS DICApprovedDAClaimAmountId,
        @DAClaimId AS DAClaimId,
        @DaId AS DaId,
        @MarketId AS MarketId,
        @DAAmount AS DAAmount,
        LTRIM(RTRIM(@ApprovalStatus)) AS ApprovalStatus,
        ISNULL(NULLIF(LTRIM(RTRIM(@ApproveBy)), N''), N'') AS ApproveBy,
        CONVERT(VARCHAR(19), @SavedApproveDate, 120) AS ApproveDate;
END
