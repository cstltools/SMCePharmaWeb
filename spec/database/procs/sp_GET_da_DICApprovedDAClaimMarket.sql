
--------------------------------------------------
-- PROCEDURE: sp_GET_da_DICApprovedDAClaimMarket
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_GET_da_DICApprovedDAClaimMarket]
    @DaId INT,
    @ComUnitId INT,
    @RouteId INT
AS
BEGIN
    SET NOCOUNT ON;

 

    SELECT TOP (1) 
        ISNULL(daClaim.DAAmount, 0) AS DAAmount,
        CONVERT(VARCHAR(10), daClaim.EntryDate, 120) AS ClaimedDate,
        ISNULL(daClaim.ApproveBy, N'') AS ClaimedBy,
        M.DAClaimId,
        D.DAClaimDetailId,
        M.DaId,
        M.ComUnitId,
        M.RouteId,
        CONVERT(VARCHAR(10), M.FrmDate, 120) AS FrmDate,
        CONVERT(VARCHAR(10), M.ToDate, 120) AS ToDate,
        ISNULL(M.DICApprovalStatus, N'') AS DICApprovalStatus,
        CONVERT(VARCHAR(10), M.DICApprovalDate, 120) AS DICApprovalDate,
        ISNULL(M.DICApprovalBy, N'') AS DICApprovalBy,
        D.MarketId,
        ISNULL(D.MarketName, N'') AS MarketName,
        CAST(ClaimCon.DAAmount AS DECIMAL(18, 2)) AS DAClaimAmount
    FROM dbo.tblDAClaimMaster M WITH (NOLOCK)
    INNER JOIN dbo.tblDAClaimDetails D WITH (NOLOCK)
        ON D.DAClaimId = M.DAClaimId
    LEFT JOIN dbo.tblDICApprovedDAClaimAmount daClaim WITH (NOLOCK)
        ON daClaim.DAClaimId = M.DAClaimId

        inner JOIN dbo.tblMarketStationDetail  Mtp WITH (NOLOCK)
        ON Mtp.MarketId = D.MarketId
         inner JOIN dbo.tblSalesAssistantDAAmountClaimConfig  ClaimCon WITH (NOLOCK)
        ON Mtp.StationTypeId = ClaimCon.TourTypeId 
      where     Mtp.UserRoleID= 15  and M.DaId = @DaId
      AND M.ComUnitId = @ComUnitId
      AND M.RouteId = @RouteId
      AND UPPER(LTRIM(RTRIM(ISNULL(M.DICApprovalStatus, N'')))) = N'APPROVED'
      AND CONVERT(DATE, M.EntryDate) = CONVERT(DATE, GETDATE())
    ORDER BY
        M.DICApprovalDate DESC,
        M.DAClaimId DESC,
        D.DAClaimDetailId ASC;
END


 
