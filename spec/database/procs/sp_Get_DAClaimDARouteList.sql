
--------------------------------------------------
-- PROCEDURE: sp_Get_DAClaimDARouteList
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_DAClaimDARouteList
    @ComUnitId INT,
    @ApprovalStatus NVARCHAR(20) = N'0'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NormalizedApprovalStatus NVARCHAR(20) = UPPER(LTRIM(RTRIM(ISNULL(@ApprovalStatus, N'0'))));

    SELECT DISTINCT
           mas.RouteId AS DistributionRouteId,
           ISNULL(route.RouteName, CONVERT(VARCHAR(20), mas.RouteId)) AS DistributionRouteName
    FROM dbo.tblDAClaimMaster mas WITH (NOLOCK)
    LEFT JOIN dbo.tblRouteInformationMaster route WITH (NOLOCK)
           ON mas.RouteId = route.RouteInformationMasterId
    WHERE mas.ComUnitId = @ComUnitId
      AND UPPER(LTRIM(RTRIM(ISNULL(mas.ApprovalStatus, N'')))) = @NormalizedApprovalStatus
      AND UPPER(LTRIM(RTRIM(ISNULL(mas.DICApprovalStatus, N'')))) = @NormalizedApprovalStatus
    ORDER BY DistributionRouteName;
END

