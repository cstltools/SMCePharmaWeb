
CREATE   PROCEDURE dbo.sp_da_SAVE_tblDAClaim
    @DAClaimId INT = 0,
    @DaId INT,
    @ComUnitId INT,
    @RouteId INT,
    @FrmDate DATE,
    @ToDate DATE,
    @Remarks NVARCHAR(500) = NULL,
    @IsFromApp BIT = 1,
    @Details dbo.DAClaimDetailTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @SavedDAClaimId INT = ISNULL(@DAClaimId, 0);
    DECLARE @TotalClaimAmount DECIMAL(18, 2) = 0;
    DECLARE @DetailCount INT = 0;
    DECLARE @EntryBy NVARCHAR(50);

    IF ISNULL(@DAClaimId, 0) < 0
    BEGIN
        SELECT 400 AS StatusCode, N'DAClaimId cannot be negative.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF ISNULL(@DaId, 0) <= 0 OR ISNULL(@ComUnitId, 0) <= 0 OR ISNULL(@RouteId, 0) <= 0
    BEGIN
        SELECT 400 AS StatusCode, N'daid, comUnitId and routeId must be greater than 0.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF @FrmDate IS NULL OR @ToDate IS NULL
    BEGIN
        SELECT 400 AS StatusCode, N'frmDate and toDate are required.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF @ToDate < @FrmDate
    BEGIN
        SELECT 400 AS StatusCode, N'toDate must be greater than or equal to frmDate.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM @Details)
    BEGIN
        SELECT 400 AS StatusCode, N'At least one DA claim detail is required.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM @Details WHERE ISNULL(MarketId, 0) < 0 OR ISNULL(DAClaimAmount, 0) < 0)
    BEGIN
        SELECT 400 AS StatusCode, N'DA claim detail marketId and DAClaimAmount cannot be negative.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF EXISTS
    (
        SELECT MarketId
        FROM @Details
        WHERE MarketId > 0
        GROUP BY MarketId
        HAVING COUNT(1) > 1
    )
    BEGIN
        SELECT 400 AS StatusCode, N'Duplicate marketId found in details.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    SELECT TOP (1)
        @EntryBy = CONVERT(NVARCHAR(50), UserId)
    FROM dbo.tblUser WITH (NOLOCK)
    WHERE EmpInfoId = @DaId;

    IF @EntryBy IS NULL
    BEGIN
        SELECT 400 AS StatusCode, N'Employee user was not found for daid.' AS [Message],
               0 AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF @SavedDAClaimId > 0
       AND NOT EXISTS (SELECT 1 FROM dbo.tblDAClaimMaster WITH (NOLOCK) WHERE DAClaimId = @SavedDAClaimId)
    BEGIN
        SELECT 404 AS StatusCode, N'DA claim not found.' AS [Message],
               @SavedDAClaimId AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    SELECT
        @TotalClaimAmount = SUM(DAClaimAmount),
        @DetailCount = COUNT(1)
    FROM @Details;

    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tblDAClaimMaster WITH (UPDLOCK, HOLDLOCK)
        WHERE DaId = @DaId
          AND EntryDate >= CAST(GETDATE() AS DATE)
          AND EntryDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
          AND DAClaimId <> @SavedDAClaimId
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT 400 AS StatusCode, N'Today already entry exists for this DA.' AS [Message],
               @SavedDAClaimId AS DAClaimId, @DaId AS DaId, @ComUnitId AS ComUnitId, @RouteId AS RouteId,
               @FrmDate AS FrmDate, @ToDate AS ToDate, CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
               @Remarks AS Remarks, @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF @SavedDAClaimId > 0
    BEGIN
        DELETE FROM dbo.tblDAClaimDetails
        WHERE DAClaimId = @SavedDAClaimId;

        UPDATE dbo.tblDAClaimMaster
        SET DaId = @DaId,
            ComUnitId = @ComUnitId,
            RouteId = @RouteId,
            FrmDate = @FrmDate,
            ToDate = @ToDate,
            TotalClaimAmount = @TotalClaimAmount,
            Remarks = @Remarks,
            IsFromApp = @IsFromApp,
            UpdateBy = @EntryBy,
            UpdateDate = GETDATE()
        WHERE DAClaimId = @SavedDAClaimId;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.tblDAClaimMaster
        (
            DaId,
            ComUnitId,
            RouteId,
            FrmDate,
            ToDate,
            TotalClaimAmount,
            Remarks,
            ApprovalStatus,
            IsFromApp,
            EntryBy,
            EntryDate
        )
        VALUES
        (
            @DaId,
            @ComUnitId,
            @RouteId,
            @FrmDate,
            @ToDate,
            @TotalClaimAmount,
            @Remarks,
            N'0',
            @IsFromApp,
            @EntryBy,
            GETDATE()
        );

        SET @SavedDAClaimId = CONVERT(INT, SCOPE_IDENTITY());
    END

    INSERT INTO dbo.tblDAClaimDetails
    (
        DAClaimId,
        MarketId,
        MarketName,
        DAClaimAmount
    )
    SELECT
        @SavedDAClaimId,
        MarketId,
        NULLIF(LTRIM(RTRIM(MarketName)), N''),
        DAClaimAmount
    FROM @Details;

    COMMIT TRANSACTION;

    SELECT
        CASE WHEN ISNULL(@DAClaimId, 0) > 0 THEN 200 ELSE 201 END AS StatusCode,
        CASE WHEN ISNULL(@DAClaimId, 0) > 0 THEN N'DA claim updated successfully.' ELSE N'DA claim saved successfully.' END AS [Message],
        @SavedDAClaimId AS DAClaimId,
        @DaId AS DaId,
        @ComUnitId AS ComUnitId,
        @RouteId AS RouteId,
        @FrmDate AS FrmDate,
        @ToDate AS ToDate,
        @TotalClaimAmount AS TotalClaimAmount,
        @Remarks AS Remarks,
        @IsFromApp AS IsFromApp,
        @DetailCount AS DetailCount;
END
