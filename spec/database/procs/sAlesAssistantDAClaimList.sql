--------------------------------------------------
-- PROCEDURE: sAlesAssistantDAClaimList
--------------------------------------------------

CREATE   PROCEDURE dbo.sAlesAssistantDAClaimList
    @ComUnitId INT = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT daAm.DICApprovedDAClaimAmountId,
           da.DaId,
           da.DACode,
           da.Name AS daName,
           mr.MarketCode,
           mr.MarketName,
           daAm.DAAmount,
           daAm.ApprovalStatus,
           daAm.EntryDate
    FROM dbo.tblDICApprovedDAClaimAmount daAm WITH (NOLOCK)
    INNER JOIN dbo.tblDAInfo da WITH (NOLOCK)
            ON da.DAId = daAm.DaId
    INNER JOIN dbo.tblMarket mr WITH (NOLOCK)
            ON mr.MarketId = daAm.MarketId
    WHERE (@ComUnitId IS NULL OR da.ComUnitId = @ComUnitId)
      AND (@FromDate IS NULL OR CAST(daAm.EntryDate AS DATE) >= @FromDate)
      AND (@ToDate IS NULL OR CAST(daAm.EntryDate AS DATE) <= @ToDate)
    ORDER BY daAm.DICApprovedDAClaimAmountId DESC;
END

