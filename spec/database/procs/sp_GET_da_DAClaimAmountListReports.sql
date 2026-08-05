
CREATE   PROCEDURE dbo.sp_GET_da_DAClaimAmountListReports
    @DaId INT,
    @month INT,
    @year INT
AS
BEGIN
    SET NOCOUNT ON;

  SELECT
        ISNULL(rt.RouteName, '') AS RouteName,
        ISNULL(cUnit.ComUnitCode, '') AS ComUnitCode,
        ISNULL(cUnit.ComUnitName, '') AS ComUnitName,
        CONVERT(VARCHAR(10), CONVERT(DATE, ClaimAmount.EntryDate), 23) AS EntryDate,
        DAY(ClaimAmount.EntryDate) AS [Day],
        DATENAME(WEEKDAY, ClaimAmount.EntryDate) AS DayName,
        ISNULL(FORMAT(ClaimAmount.ApproveDate, 'dd-MMMM yyyy hh:mm tt'), '') AS ApproveDate,
        ISNULL(D.MarketName, '') AS MarketName,
        ISNULL(ClaimAmount.DAAmount, 0) AS DAAmount
    FROM  dbo.tblDICApprovedDAClaimAmount ClaimAmount  WITH (NOLOCK)
    INNER JOIN dbo.tblDAClaimMaster M WITH  (NOLOCK)
        ON ClaimAmount.DAClaimId = M.DAClaimId
    INNER JOIN dbo.tblDAClaimDetails D WITH (NOLOCK)
        ON D.DAClaimId = M.DAClaimId
        AND D.MarketId = ClaimAmount.MarketId
    LEFT JOIN dbo.tblRouteInformationMaster rt WITH (NOLOCK)
        ON rt.RouteInformationMasterId = M.RouteId
    LEFT JOIN dbo.tblCompanyUnit cUnit WITH (NOLOCK)
        ON cUnit.ComUnitId = M.ComUnitId
    WHERE M.DaId = @DaId
      AND MONTH(ClaimAmount.EntryDate) = @month
      AND YEAR(ClaimAmount.EntryDate) = @year
    ORDER BY CONVERT(DATE, ClaimAmount.EntryDate), rt.RouteName, cUnit.ComUnitCode, D.MarketName;
END
