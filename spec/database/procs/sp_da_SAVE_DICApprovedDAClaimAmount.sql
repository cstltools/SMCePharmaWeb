
CREATE   PROCEDURE dbo.sp_da_SAVE_DICApprovedDAClaimAmount
    @DAClaimId INT,
    @DAClaimDetailId INT,
    @MarketId INT,
    @DAClaimAmount DECIMAL(18, 2),
    @UpdateBy NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF ISNULL(@DAClaimId, 0) <= 0 OR ISNULL(@DAClaimDetailId, 0) <= 0 OR ISNULL(@MarketId, 0) < 0
    BEGIN
        SELECT
            400 AS StatusCode,
            N'DAClaimId and DAClaimDetailId must be greater than 0, and marketId cannot be negative.' AS [Message],
            ISNULL(@DAClaimId, 0) AS DAClaimId,
            ISNULL(@DAClaimDetailId, 0) AS DAClaimDetailId,
            ISNULL(@MarketId, 0) AS MarketId,
            ISNULL(@DAClaimAmount, 0) AS DAClaimAmount,
            CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
            N'' AS DICApprovalStatus,
            N'' AS DICApprovalDate,
            ISNULL(@UpdateBy, N'') AS UpdateBy,
            N'' AS UpdateDate;
        RETURN;
    END

    IF @DAClaimAmount IS NULL OR @DAClaimAmount < 0
    BEGIN
        SELECT
            400 AS StatusCode,
            N'DAClaimAmount is required and cannot be negative.' AS [Message],
            @DAClaimId AS DAClaimId,
            @DAClaimDetailId AS DAClaimDetailId,
            @MarketId AS MarketId,
            ISNULL(@DAClaimAmount, 0) AS DAClaimAmount,
            CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
            N'' AS DICApprovalStatus,
            N'' AS DICApprovalDate,
            ISNULL(@UpdateBy, N'') AS UpdateBy,
            N'' AS UpdateDate;
        RETURN;
    END

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tblDAClaimMaster CurrentClaim WITH (NOLOCK)
        INNER JOIN dbo.tblDAClaimMaster Claimed WITH (NOLOCK)
            ON Claimed.DaId = CurrentClaim.DaId
        WHERE CurrentClaim.DAClaimId = @DAClaimId
          AND Claimed.DICClaimDate IS NOT NULL
          AND CONVERT(DATE, Claimed.DICClaimDate) = CONVERT(DATE, CurrentClaim.DICApprovalDate)
    )
    BEGIN
        SELECT TOP (1)
            409 AS StatusCode,
            N'Already claim. Claimed amount: '
                + CONVERT(NVARCHAR(50), CAST(ISNULL(Claimed.DICClaimAmount, ISNULL(Claimed.TotalClaimAmount, 0)) AS DECIMAL(18, 2)))
                + N'.' AS [Message],
            @DAClaimId AS DAClaimId,
            @DAClaimDetailId AS DAClaimDetailId,
            @MarketId AS MarketId,
            CAST(ISNULL(Claimed.DICClaimAmount, ISNULL(Claimed.TotalClaimAmount, 0)) AS DECIMAL(18, 2)) AS DAClaimAmount,
            CAST(ISNULL(Claimed.TotalClaimAmount, 0) AS DECIMAL(18, 2)) AS TotalClaimAmount,
            ISNULL(Claimed.DICApprovalStatus, N'') AS DICApprovalStatus,
            CONVERT(VARCHAR(10), Claimed.DICApprovalDate, 120) AS DICApprovalDate,
            ISNULL(Claimed.DICClaimBy, N'') AS UpdateBy,
            CONVERT(VARCHAR(19), Claimed.DICClaimDate, 120) AS UpdateDate
        FROM dbo.tblDAClaimMaster CurrentClaim WITH (NOLOCK)
        INNER JOIN dbo.tblDAClaimMaster Claimed WITH (NOLOCK)
            ON Claimed.DaId = CurrentClaim.DaId
        WHERE CurrentClaim.DAClaimId = @DAClaimId
          AND Claimed.DICClaimDate IS NOT NULL
          AND CONVERT(DATE, Claimed.DICClaimDate) = CONVERT(DATE, CurrentClaim.DICApprovalDate)
        ORDER BY Claimed.DICClaimDate DESC, Claimed.DAClaimId DESC;
        RETURN;
    END

    UPDATE D
    SET DAClaimAmount = @DAClaimAmount
    FROM dbo.tblDAClaimDetails D
    INNER JOIN dbo.tblDAClaimMaster M
        ON M.DAClaimId = D.DAClaimId
    WHERE M.DAClaimId = @DAClaimId
      AND D.DAClaimDetailId = @DAClaimDetailId
      AND D.MarketId = @MarketId
      AND UPPER(LTRIM(RTRIM(ISNULL(M.DICApprovalStatus, N'')))) = N'APPROVED'
      AND CONVERT(DATE, M.DICApprovalDate) = CONVERT(DATE, GETDATE());

    IF @@ROWCOUNT = 0
    BEGIN
        SELECT
            404 AS StatusCode,
            N'DIC approved DA claim detail not found for today.' AS [Message],
            @DAClaimId AS DAClaimId,
            @DAClaimDetailId AS DAClaimDetailId,
            @MarketId AS MarketId,
            @DAClaimAmount AS DAClaimAmount,
            CAST(0 AS DECIMAL(18, 2)) AS TotalClaimAmount,
            N'' AS DICApprovalStatus,
            N'' AS DICApprovalDate,
            ISNULL(@UpdateBy, N'') AS UpdateBy,
            N'' AS UpdateDate;
        RETURN;
    END

    UPDATE M
    SET TotalClaimAmount = ISNULL(DetailTotals.TotalClaimAmount, 0),
        UpdateBy = COALESCE(NULLIF(LTRIM(RTRIM(@UpdateBy)), N''), M.UpdateBy),
        UpdateDate = GETDATE(),
        DICClaimDate = GETDATE(),
        DICClaimAmount = @DAClaimAmount,
        DICClaimBy = COALESCE(NULLIF(LTRIM(RTRIM(@UpdateBy)), N''), M.DICClaimBy)
    FROM dbo.tblDAClaimMaster M
    CROSS APPLY
    (
        SELECT SUM(DAClaimAmount) AS TotalClaimAmount
        FROM dbo.tblDAClaimDetails
        WHERE DAClaimId = M.DAClaimId
    ) DetailTotals
    WHERE M.DAClaimId = @DAClaimId;

    INSERT INTO dbo.tblDICApprovedDAClaimAmount
    (
        DaId,
        DAAmount,
        ApprovalStatus,
        ApproveBy,
        ApproveDate
    )
    SELECT
        M.DaId,
        @DAClaimAmount,
        ISNULL(M.DICApprovalStatus, N''),
        COALESCE(NULLIF(LTRIM(RTRIM(@UpdateBy)), N''), M.DICApprovalBy, M.UpdateBy),
        GETDATE()
    FROM dbo.tblDAClaimMaster M
    WHERE M.DAClaimId = @DAClaimId;

    SELECT
        200 AS StatusCode,
        N'DIC approved DA claim amount saved successfully.' AS [Message],
        M.DAClaimId,
        D.DAClaimDetailId,
        D.MarketId,
        D.DAClaimAmount,
        M.TotalClaimAmount,
        ISNULL(M.DICApprovalStatus, N'') AS DICApprovalStatus,
        CONVERT(VARCHAR(10), M.DICApprovalDate, 120) AS DICApprovalDate,
        ISNULL(M.UpdateBy, N'') AS UpdateBy,
        CONVERT(VARCHAR(19), M.UpdateDate, 120) AS UpdateDate
    FROM dbo.tblDAClaimMaster M
    INNER JOIN dbo.tblDAClaimDetails D
        ON D.DAClaimId = M.DAClaimId
    WHERE M.DAClaimId = @DAClaimId
      AND D.DAClaimDetailId = @DAClaimDetailId
      AND D.MarketId = @MarketId;
END
