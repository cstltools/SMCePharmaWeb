
CREATE   PROCEDURE dbo.sp_GET_da_DATOurPlanMarketListReports
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
        CONVERT(VARCHAR(10), CONVERT(DATE, M.EntryDate), 23) AS EntryDate,
        DAY(M.EntryDate) AS [Day],
        DATENAME(WEEKDAY, M.EntryDate) AS DayName,
        ISNULL(FORMAT(M.DICApprovalDate, 'dd-MMMM yyyy hh:mm tt'), '') AS DICApprovalDate,
        ISNULL(D.MarketName, '') AS MarketName
    FROM dbo.tblDAClaimMaster M WITH (NOLOCK)
    INNER JOIN dbo.tblDAClaimDetails D WITH (NOLOCK)
        ON D.DAClaimId = M.DAClaimId
    LEFT JOIN dbo.tblRouteInformationMaster rt WITH (NOLOCK)
        ON rt.RouteInformationMasterId = M.RouteId
    LEFT JOIN dbo.tblCompanyUnit cUnit WITH (NOLOCK)
        ON cUnit.ComUnitId = M.ComUnitId
    WHERE M.DaId = @DaId
      AND MONTH(M.EntryDate) = @month
      AND YEAR(M.EntryDate) = @year
    ORDER BY CONVERT(DATE, M.EntryDate), rt.RouteName, cUnit.ComUnitCode, D.MarketName;
END
