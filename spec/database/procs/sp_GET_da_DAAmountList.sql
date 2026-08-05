
CREATE   PROCEDURE dbo.sp_GET_da_DAAmountList
    @daid INT,
    @month INT,
    @year INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = DATEFROMPARTS(@year, @month, 1);
    DECLARE @ToDate DATE = DATEADD(MONTH, 1, @FromDate);

    SELECT
        M.DAClaimId,
        M.DaId,
        M.ComUnitId,
        M.RouteId,
        CONVERT(VARCHAR(10), M.FrmDate, 23) AS FrmDate,
        CONVERT(VARCHAR(10), M.ToDate, 23) AS ToDate,
        ISNULL(M.TotalClaimAmount, 0) AS TotalClaimAmount,
        ISNULL(M.Remarks, '') AS Remarks,
        ISNULL(M.ApprovalStatus, '') AS ApprovalStatus,
        ISNULL(M.DICApprovalStatus, '') AS DICApprovalStatus,
        ISNULL(CONVERT(VARCHAR(19), M.DICApprovalDate, 120), '') AS DICApprovalDate,
        ISNULL(M.DICApprovalBy, '') AS DICApprovalBy,
        ISNULL(CONVERT(VARCHAR(19), M.DICClaimDate, 120), '') AS DICClaimDate,
        ISNULL(M.DICClaimBy, '') AS DICClaimBy,
        ISNULL(M.DICClaimAmount, 0) AS DICClaimAmount,
        CAST(ISNULL(M.IsFromApp, 0) AS BIT) AS IsFromApp,
        ISNULL(M.EntryBy, '') AS EntryBy,
        ISNULL(CONVERT(VARCHAR(19), M.EntryDate, 120), '') AS EntryDate,
        ISNULL(M.UpdateBy, '') AS UpdateBy,
        ISNULL(CONVERT(VARCHAR(19), M.UpdateDate, 120), '') AS UpdateDate
    FROM dbo.tblDAClaimMaster M WITH (NOLOCK)
    WHERE M.DaId = @daid
      AND M.FrmDate < @ToDate
      AND M.ToDate >= @FromDate
    ORDER BY M.FrmDate DESC, M.DAClaimId DESC;

    SELECT
        D.DAClaimDetailId,
        D.DAClaimId,
        D.MarketId,
        ISNULL(D.MarketName, '') AS MarketName,
        ISNULL(D.DAClaimAmount, 0) AS DAClaimAmount
    FROM dbo.tblDAClaimDetails D WITH (NOLOCK)
    INNER JOIN dbo.tblDAClaimMaster M WITH (NOLOCK)
        ON M.DAClaimId = D.DAClaimId
    WHERE M.DaId = @daid
      AND M.FrmDate < @ToDate
      AND M.ToDate >= @FromDate
    ORDER BY D.DAClaimId, D.DAClaimDetailId;
END
